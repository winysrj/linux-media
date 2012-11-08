Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33191 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2KHTMm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:42 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so1190326eaa.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:42 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 14/21] em28xx: rename function em28xx_isoc_copy_vbi and extend for USB bulk transfers
Date: Thu,  8 Nov 2012 20:11:46 +0200
Message-Id: <1352398313-3698-15-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The URB data processing for bulk transfers is very similar to what
is done with isoc transfers, so create a common function that works
with both transfer types based on the existing isoc function.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   71 +++++++++++++++++++------------
 1 Datei geändert, 44 Zeilen hinzugefügt(+), 27 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 63b0cc3..d6de1cc 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -519,18 +519,16 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 	return rc;
 }
 
-/* Version of isoc handler that takes into account a mixture of video and
-   VBI data */
-static inline int em28xx_isoc_copy_vbi(struct em28xx *dev, struct urb *urb)
+/* Version of the urb data handler that takes into account a mixture of
+   video and VBI data */
+static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 {
 	struct em28xx_buffer    *buf, *vbi_buf;
 	struct em28xx_dmaqueue  *dma_q = &dev->vidq;
 	struct em28xx_dmaqueue  *vbi_dma_q = &dev->vbiq;
-	unsigned char *outp = NULL;
-	unsigned char *vbioutp = NULL;
-	int i, len = 0, rc = 1;
-	unsigned char *p;
-	int vbi_size;
+	int xfer_bulk, vbi_size, num_packets, i, rc = 1;
+	unsigned int actual_length, len = 0;
+	unsigned char *p, *outp = NULL, *vbioutp = NULL;
 
 	if (!dev)
 		return 0;
@@ -541,6 +539,8 @@ static inline int em28xx_isoc_copy_vbi(struct em28xx *dev, struct urb *urb)
 	if (urb->status < 0)
 		print_err_status(dev, -1, urb->status);
 
+	xfer_bulk = usb_pipebulk(urb->pipe);
+
 	buf = dev->usb_ctl.vid_buf;
 	if (buf != NULL)
 		outp = videobuf_to_vmalloc(&buf->vb);
@@ -549,28 +549,41 @@ static inline int em28xx_isoc_copy_vbi(struct em28xx *dev, struct urb *urb)
 	if (vbi_buf != NULL)
 		vbioutp = videobuf_to_vmalloc(&vbi_buf->vb);
 
-	for (i = 0; i < urb->number_of_packets; i++) {
-		int status = urb->iso_frame_desc[i].status;
+	if (xfer_bulk) /* bulk */
+		num_packets = 1;
+	else /* isoc */
+		num_packets = urb->number_of_packets;
+
+	for (i = 0; i < num_packets; i++) {
+		if (xfer_bulk) { /* bulk */
+			actual_length = urb->actual_length;
+
+			p = urb->transfer_buffer;
+		} else { /* isoc */
+			if (urb->iso_frame_desc[i].status < 0) {
+				print_err_status(dev, i,
+						 urb->iso_frame_desc[i].status);
+				if (urb->iso_frame_desc[i].status != -EPROTO)
+					continue;
+			}
 
-		if (status < 0) {
-			print_err_status(dev, i, status);
-			if (urb->iso_frame_desc[i].status != -EPROTO)
+			actual_length = urb->iso_frame_desc[i].actual_length;
+			if (actual_length > dev->max_pkt_size) {
+				em28xx_isocdbg("packet bigger than "
+					       "packet size");
 				continue;
-		}
+			}
 
-		len = urb->iso_frame_desc[i].actual_length;
-		if (urb->iso_frame_desc[i].actual_length <= 0) {
-			/* em28xx_isocdbg("packet %d is empty",i); - spammy */
-			continue;
+			p = urb->transfer_buffer +
+			    urb->iso_frame_desc[i].offset;
 		}
-		if (urb->iso_frame_desc[i].actual_length >
-						dev->max_pkt_size) {
-			em28xx_isocdbg("packet bigger than packet size");
+
+		if (actual_length <= 0) {
+			/* NOTE: happens very often with isoc transfers */
+			/* em28xx_usbdbg("packet %d is empty",i); - spammy */
 			continue;
 		}
 
-		p = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
-
 		/* capture type 0 = vbi start
 		   capture type 1 = video start
 		   capture type 2 = video in progress */
@@ -580,16 +593,20 @@ static inline int em28xx_isoc_copy_vbi(struct em28xx *dev, struct urb *urb)
 			em28xx_isocdbg("VBI START HEADER!!!\n");
 			dev->cur_field = p[2];
 			p += 4;
-			len -= 4;
+			len = actual_length - 4;
 		} else if (p[0] == 0x88 && p[1] == 0x88 &&
 			   p[2] == 0x88 && p[3] == 0x88) {
 			/* continuation */
 			p += 4;
-			len -= 4;
+			len = actual_length - 4;
 		} else if (p[0] == 0x22 && p[1] == 0x5a) {
 			/* start video */
 			p += 4;
-			len -= 4;
+			len = actual_length - 4;
+		} else {
+			/* NOTE: With bulk transfers, intermediate data packets
+			 * have no continuation header */
+			len = actual_length;
 		}
 
 		vbi_size = dev->vbi_width * dev->vbi_height;
@@ -777,7 +794,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 						  EM28XX_NUM_BUFS,
 						  dev->max_pkt_size,
 						  EM28XX_NUM_ISOC_PACKETS,
-						  em28xx_isoc_copy_vbi);
+						  em28xx_urb_data_copy_vbi);
 		else
 			rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE, 0,
 						  EM28XX_NUM_BUFS,
-- 
1.7.10.4

