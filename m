Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41667 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab2KYKiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 05:38:08 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3997651eek.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 02:38:08 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 6/6] em28xx: use common urb data copying function for vbi and non-vbi data streams
Date: Sun, 25 Nov 2012 11:37:37 +0100
Message-Id: <1353839857-2990-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1353839857-2990-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1353839857-2990-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx_urb_data_copy_vbi() is actually an extended version of
em28xx_urb_data_copy(). With the preceding fixes and improvements, it works
fine with both, vbi and non-vbi data streams without performance impacts.

So rename em28xx_urb_data_copy_vbi() to em28xx_urb_data_copy(), delete the
the old implementation of em28xx_urb_data_copy() and change the code to use
this function for both data stream types.

Tested with "SilverCrest 1.3 MPix webcam" (progressive, non-vbi) and
"Hauppauge HVR-900 (65008/A1C0)" (interlaced, vbi enabled and disabled).

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |  130 ++-----------------------------
 drivers/media/usb/em28xx/em28xx.h       |    4 +-
 2 Dateien geändert, 9 Zeilen hinzugefügt(+), 125 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 6843784..6282d48 100644
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
@@ -413,115 +411,9 @@ static inline void vbi_get_next_buf(struct em28xx_dmaqueue *dma_q,
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
@@ -767,20 +659,12 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 
 	if (urb_init) {
 		dev->capture_type = -1;
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
+		rc = em28xx_init_usb_xfer(dev, EM28XX_ANALOG_MODE,
+					  dev->analog_xfer_bulk,
+					  EM28XX_NUM_BUFS,
+					  dev->max_pkt_size,
+					  dev->packet_multiplier,
+					  em28xx_urb_data_copy);
 		if (rc < 0)
 			goto fail;
 	}
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 09df56a..304896d 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -560,10 +560,10 @@ struct em28xx {
 	/* states */
 	enum em28xx_dev_state state;
 
-	/* vbi related state tracking */
+	/* capture state tracking */
 	int capture_type;
-	int vbi_read;
 	unsigned char top_field:1;
+	int vbi_read;
 	unsigned int vbi_width;
 	unsigned int vbi_height; /* lines per field */
 
-- 
1.7.10.4

