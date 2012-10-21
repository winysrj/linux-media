Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57147 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab2JURxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 13:53:38 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1632849wgb.1
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 10:53:37 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 13/23] em28xx: rename function em28xx_isoc_copy and extend for USB bulk transfers
Date: Sun, 21 Oct 2012 19:52:19 +0300
Message-Id: <1350838349-14763-15-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
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
 drivers/media/usb/em28xx/em28xx-video.c |   66 +++++++++++++++++++------------
 1 Datei geändert, 41 Zeilen hinzugefügt(+), 25 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 3518753..63b0cc3 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -6,6 +6,7 @@
 		      Markus Rechberger <mrechberger@gmail.com>
 		      Mauro Carvalho Chehab <mchehab@infradead.org>
 		      Sascha Sommer <saschasommer@freenet.de>
+   Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
 
 	Some parts based on SN9C10x PC Camera Controllers GPL driver made
 		by Luca Risolia <luca.risolia@studio.unibo.it>
@@ -412,16 +413,14 @@ static inline void vbi_get_next_buf(struct em28xx_dmaqueue *dma_q,
 	return;
 }
 
-/*
- * Controls the isoc copy of each urb packet
- */
-static inline int em28xx_isoc_copy(struct em28xx *dev, struct urb *urb)
+/* Processes and copies the URB data content to a frame buffer queue */
+static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 {
 	struct em28xx_buffer    *buf;
 	struct em28xx_dmaqueue  *dma_q = &dev->vidq;
-	unsigned char *outp = NULL;
-	int i, len = 0, rc = 1;
-	unsigned char *p;
+	int xfer_bulk, num_packets, i, rc = 1;
+	unsigned int actual_length, len = 0;
+	unsigned char *p, *outp = NULL;
 
 	if (!dev)
 		return 0;
@@ -432,33 +431,47 @@ static inline int em28xx_isoc_copy(struct em28xx *dev, struct urb *urb)
 	if (urb->status < 0)
 		print_err_status(dev, -1, urb->status);
 
+	xfer_bulk = usb_pipebulk(urb->pipe);
+
 	buf = dev->usb_ctl.vid_buf;
 	if (buf != NULL)
 		outp = videobuf_to_vmalloc(&buf->vb);
 
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
-
-		len = urb->iso_frame_desc[i].actual_length - 4;
+			}
 
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
 		/* FIXME: incomplete buffer checks where removed to make
 		   logic simpler. Impacts of those changes should be evaluated
 		 */
@@ -492,9 +505,12 @@ static inline int em28xx_isoc_copy(struct em28xx *dev, struct urb *urb)
 		}
 		if (buf != NULL) {
 			if (p[0] != 0x88 && p[0] != 0x22) {
+				/* NOTE: no intermediate data packet header
+				 * 88 88 88 88 when using bulk transfers */
 				em28xx_isocdbg("frame is not complete\n");
-				len += 4;
+				len = actual_length;
 			} else {
+				len = actual_length - 4;
 				p += 4;
 			}
 			em28xx_copy_video(dev, dma_q, buf, p, outp, len);
@@ -767,7 +783,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 						  EM28XX_NUM_BUFS,
 						  dev->max_pkt_size,
 						  EM28XX_NUM_ISOC_PACKETS,
-						  em28xx_isoc_copy);
+						  em28xx_urb_data_copy);
 		if (rc < 0)
 			goto fail;
 	}
-- 
1.7.10.4

