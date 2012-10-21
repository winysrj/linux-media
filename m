Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34268 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab2JURxv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 13:53:51 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so1752706wib.1
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 10:53:50 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 22/23] em28xx: use common urb data copying function for vbi and non-vbi devices
Date: Sun, 21 Oct 2012 19:52:28 +0300
Message-Id: <1350838349-14763-24-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx_urb_data_copy_vbi is actually an extended version of
em28xx_urb_data_copy. With some minor fixes applied, it can be
used for non-vbi-devices, too, without any performance impacts.

Tested with a non-VBI device only.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |  145 ++++---------------------------
 1 Datei geändert, 16 Zeilen hinzugefügt(+), 129 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 4ec54fd..5f8b508 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -178,7 +178,6 @@ static inline void vbi_buffer_filled(struct em28xx *dev,
 {
 	/* Advice that buffer was filled */
 	em28xx_usbdbg("[%p/%d] wakeup\n", buf, buf->vb.i);
-
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
 	do_gettimeofday(&buf->vb.ts);
@@ -376,7 +375,6 @@ static inline void get_next_buf(struct em28xx_dmaqueue *dma_q,
 
 	/* Get the next buffer */
 	*buf = list_entry(dma_q->active.next, struct em28xx_buffer, vb.queue);
-
 	/* Cleans up buffer - Useful for testing for frame/URB loss */
 	outp = videobuf_to_vmalloc(&(*buf)->vb);
 	memset(outp, 0, (*buf)->vb.size);
@@ -413,119 +411,13 @@ static inline void vbi_get_next_buf(struct em28xx_dmaqueue *dma_q,
 	return;
 }
 
-/* Processes and copies the URB data content to a frame buffer queue */
+/* Processes and copies the URB data content (video and VBI data) */
 static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 {
-	struct em28xx_buffer    *buf;
-	struct em28xx_dmaqueue  *dma_q = &dev->vidq;
-	int xfer_bulk, num_packets, i, rc = 1;
-	unsigned int actual_length, len = 0;
-	unsigned char *p, *outp = NULL;
-
-	if (!dev)
-		return 0;
-
-	if ((dev->state & DEV_DISCONNECTED) || (dev->state & DEV_MISCONFIGURED))
-		return 0;
-
-	if (urb->status < 0)
-		print_err_status(dev, -1, urb->status);
-
-	xfer_bulk = usb_pipebulk(urb->pipe);
-
-	buf = dev->usb_ctl.vid_buf;
-	if (buf != NULL)
-		outp = videobuf_to_vmalloc(&buf->vb);
-
-	if (xfer_bulk) /* bulk */
-		num_packets = 1;
-	else /* isoc */
-		num_packets = urb->number_of_packets;
-
-	for (i = 0; i < num_packets; i++) {
-		if (xfer_bulk) { /* bulk */
-			actual_length = urb->actual_length;
-
-			p = urb->transfer_buffer;
-		} else { /* isoc */
-			if (urb->iso_frame_desc[i].status < 0) {
-				print_err_status(dev, i,
-						 urb->iso_frame_desc[i].status);
-				if (urb->iso_frame_desc[i].status != -EPROTO)
-					continue;
-			}
-
-			actual_length = urb->iso_frame_desc[i].actual_length;
-			if (actual_length > dev->max_pkt_size) {
-				em28xx_usbdbg("packet bigger than packet size");
-				continue;
-			}
-
-			p = urb->transfer_buffer +
-			    urb->iso_frame_desc[i].offset;
-		}
-
-		if (actual_length <= 0) {
-			/* NOTE: happens very often with isoc transfers */
-			/* em28xx_usbdbg("packet %d is empty",i); - spammy */
-			continue;
-		}
-
-		/* FIXME: incomplete buffer checks where removed to make
-		   logic simpler. Impacts of those changes should be evaluated
-		 */
-		if (p[0] == 0x33 && p[1] == 0x95 && p[2] == 0x00) {
-			em28xx_usbdbg("VBI HEADER!!!\n");
-			/* FIXME: Should add vbi copy */
-			continue;
-		}
-		if (p[0] == 0x22 && p[1] == 0x5a) {
-			em28xx_usbdbg("Video frame %d, length=%i, %s\n", p[2],
-				       len, (p[2] & 1) ? "odd" : "even");
-
-			if (dev->progressive || !(p[2] & 1)) {
-				if (buf != NULL)
-					buffer_filled(dev, dma_q, buf);
-				get_next_buf(dma_q, &buf);
-				if (buf == NULL)
-					outp = NULL;
-				else
-					outp = videobuf_to_vmalloc(&buf->vb);
-			}
-
-			if (buf != NULL) {
-				if (p[2] & 1)
-					buf->top_field = 0;
-				else
-					buf->top_field = 1;
-			}
-
-			dma_q->pos = 0;
-		}
-		if (buf != NULL) {
-			if (p[0] != 0x88 && p[0] != 0x22) {
-				/* NOTE: no intermediate data packet header
-				 * 88 88 88 88 when using bulk transfers */
-				em28xx_usbdbg("frame is not complete\n");
-				len = actual_length;
-			} else {
-				len = actual_length - 4;
-				p += 4;
-			}
-			em28xx_copy_video(dev, dma_q, buf, p, outp, len);
-		}
-	}
-	return rc;
-}
-
-/* Version of the urb data handler that takes into account a mixture of
-   video and VBI data */
-static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
-{
 	struct em28xx_buffer    *buf, *vbi_buf;
 	struct em28xx_dmaqueue  *dma_q = &dev->vidq;
 	struct em28xx_dmaqueue  *vbi_dma_q = &dev->vbiq;
-	int xfer_bulk, vbi_size, num_packets, i, rc = 1;
+	int xfer_bulk, num_packets, i, rc = 1;
 	unsigned int actual_length, len = 0;
 	unsigned char *p, *outp = NULL, *vbioutp = NULL;
 
@@ -599,6 +491,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 			len = actual_length - 4;
 		} else if (p[0] == 0x22 && p[1] == 0x5a) {
 			/* start video */
+			dev->capture_type = 1;
 			p += 4;
 			len = actual_length - 4;
 		} else {
@@ -607,9 +500,8 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 			len = actual_length;
 		}
 
-		vbi_size = dev->vbi_width * dev->vbi_height;
-
 		if (dev->capture_type == 0) {
+			int vbi_size = dev->vbi_width * dev->vbi_height;
 			if (dev->vbi_read >= vbi_size) {
 				/* We've already read all the VBI data, so
 				   treat the rest as video */
@@ -641,9 +533,11 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 					}
 				}
 
-				dev->vbi_read += len;
-				em28xx_copy_vbi(dev, vbi_dma_q, vbi_buf, p,
-						vbioutp, len);
+				if (vbi_buf != NULL) {
+					dev->vbi_read += len;
+					em28xx_copy_vbi(dev, vbi_dma_q, vbi_buf,
+							p, vbioutp, len);
+				}
 			} else {
 				/* Some of this frame is VBI data and some is
 				   video data */
@@ -787,20 +681,13 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 		urb_init = 1;
 
 	if (urb_init) {
-		if (em28xx_vbi_supported(dev) == 1)
-			rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE,
-						  dev->analog_xfer_bulk,
-						  EM28XX_NUM_BUFS,
-						  dev->max_pkt_size,
-						  dev->packet_multiplier,
-						  em28xx_urb_data_copy_vbi);
-		else
-			rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE,
-						  dev->analog_xfer_bulk,
-						  EM28XX_NUM_BUFS,
-						  dev->max_pkt_size,
-						  dev->packet_multiplier,
-						  em28xx_urb_data_copy);
+		dev->capture_type = -1;
+		rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE,
+					  dev->analog_xfer_bulk,
+					  EM28XX_NUM_BUFS,
+					  dev->max_pkt_size,
+					  dev->packet_multiplier,
+					  em28xx_urb_data_copy);
 		if (rc < 0)
 			goto fail;
 	}
-- 
1.7.10.4

