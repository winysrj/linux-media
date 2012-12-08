Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38287 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965367Ab2LHPby (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 10:31:54 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so548069eaa.19
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2012 07:31:53 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 8/9] em28xx: move the em2710/em2750/em28xx specific frame data processing code to a separate function
Date: Sat,  8 Dec 2012 16:31:31 +0100
Message-Id: <1354980692-3791-9-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx_urb_data_copy() actually consists of two parts:
USB urb processing (checks, data extraction) and frame data packet processing.
Move the latter to a separate function and call it from em28xx_urb_data_copy()
for each data packet.
The em25xx, em2760, em2765 (and likely em277x) chip variants are using a
different frame data format, for which support will be added later with
another function.

This reduces the size of em28xx_urb_data_copy() and makes the code much more
readable. While we're at it, clean up the code a bit (rename some variables to
something more meaningful, improve some comments etc.)

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |  170 ++++++++++++++++---------------
 1 Datei geändert, 90 Zeilen hinzugefügt(+), 80 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 61c7321..fb40d0b 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -379,15 +379,90 @@ finish_field_prepare_next(struct em28xx *dev,
 	return buf;
 }
 
-/* Processes and copies the URB data content (video and VBI data) */
-static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
+/*
+ * Process data packet according to the em2710/em2750/em28xx frame data format
+ */
+static inline void process_frame_data_em28xx(struct em28xx *dev,
+					     unsigned char *data_pkt,
+					     unsigned int  data_len)
 {
-	struct em28xx_buffer    *buf, *vbi_buf;
+	struct em28xx_buffer    *buf = dev->usb_ctl.vid_buf;
+	struct em28xx_buffer    *vbi_buf = dev->usb_ctl.vbi_buf;
 	struct em28xx_dmaqueue  *dma_q = &dev->vidq;
 	struct em28xx_dmaqueue  *vbi_dma_q = &dev->vbiq;
-	int xfer_bulk, num_packets, i, rc = 1;
-	unsigned int actual_length, len = 0;
-	unsigned char *p;
+
+	/* capture type 0 = vbi start
+	   capture type 1 = vbi in progress
+	   capture type 2 = video start
+	   capture type 3 = video in progress */
+	if (data_len >= 4) {
+		/* NOTE: Headers are always 4 bytes and
+		 * never split across packets */
+		if (data_pkt[0] == 0x88 && data_pkt[1] == 0x88 &&
+		    data_pkt[2] == 0x88 && data_pkt[3] == 0x88) {
+			/* Continuation */
+			data_pkt += 4;
+			data_len -= 4;
+		} else if (data_pkt[0] == 0x33 && data_pkt[1] == 0x95) {
+			/* Field start (VBI mode) */
+			dev->capture_type = 0;
+			dev->vbi_read = 0;
+			em28xx_usbdbg("VBI START HEADER !!!\n");
+			dev->top_field = !(data_pkt[2] & 1);
+			data_pkt += 4;
+			data_len -= 4;
+		} else if (data_pkt[0] == 0x22 && data_pkt[1] == 0x5a) {
+			/* Field start (VBI disabled) */
+			dev->capture_type = 2;
+			em28xx_usbdbg("VIDEO START HEADER !!!\n");
+			dev->top_field = !(data_pkt[2] & 1);
+			data_pkt += 4;
+			data_len -= 4;
+		}
+	}
+	/* NOTE: With bulk transfers, intermediate data packets
+	 * have no continuation header */
+
+	if (dev->capture_type == 0) {
+		vbi_buf = finish_field_prepare_next(dev, vbi_buf, vbi_dma_q);
+		dev->usb_ctl.vbi_buf = vbi_buf;
+		dev->capture_type = 1;
+	}
+
+	if (dev->capture_type == 1) {
+		int vbi_size = dev->vbi_width * dev->vbi_height;
+		int vbi_data_len = ((dev->vbi_read + data_len) > vbi_size) ?
+				   (vbi_size - dev->vbi_read) : data_len;
+
+		/* Copy VBI data */
+		if (vbi_buf != NULL)
+			em28xx_copy_vbi(dev, vbi_buf, data_pkt, vbi_data_len);
+		dev->vbi_read += vbi_data_len;
+
+		if (vbi_data_len < data_len) {
+			/* Continue with copying video data */
+			dev->capture_type = 2;
+			data_pkt += vbi_data_len;
+			data_len -= vbi_data_len;
+		}
+	}
+
+	if (dev->capture_type == 2) {
+		buf = finish_field_prepare_next(dev, buf, dma_q);
+		dev->usb_ctl.vid_buf = buf;
+		dev->capture_type = 3;
+	}
+
+	if (dev->capture_type == 3 && buf != NULL && data_len > 0)
+		em28xx_copy_video(dev, buf, data_pkt, data_len);
+}
+
+/* Processes and copies the URB data content (video and VBI data) */
+static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
+{
+	int xfer_bulk, num_packets, i;
+	unsigned char *usb_data_pkt;
+	unsigned int usb_data_len;
 
 	if (!dev)
 		return 0;
@@ -400,9 +475,6 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 
 	xfer_bulk = usb_pipebulk(urb->pipe);
 
-	buf = dev->usb_ctl.vid_buf;
-	vbi_buf = dev->usb_ctl.vbi_buf;
-
 	if (xfer_bulk) /* bulk */
 		num_packets = 1;
 	else /* isoc */
@@ -410,9 +482,9 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 
 	for (i = 0; i < num_packets; i++) {
 		if (xfer_bulk) { /* bulk */
-			actual_length = urb->actual_length;
+			usb_data_len = urb->actual_length;
 
-			p = urb->transfer_buffer;
+			usb_data_pkt = urb->transfer_buffer;
 		} else { /* isoc */
 			if (urb->iso_frame_desc[i].status < 0) {
 				print_err_status(dev, i,
@@ -421,87 +493,25 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 					continue;
 			}
 
-			actual_length = urb->iso_frame_desc[i].actual_length;
-			if (actual_length > dev->max_pkt_size) {
+			usb_data_len = urb->iso_frame_desc[i].actual_length;
+			if (usb_data_len > dev->max_pkt_size) {
 				em28xx_usbdbg("packet bigger than packet size");
 				continue;
 			}
 
-			p = urb->transfer_buffer +
-			    urb->iso_frame_desc[i].offset;
+			usb_data_pkt = urb->transfer_buffer +
+				       urb->iso_frame_desc[i].offset;
 		}
 
-		if (actual_length == 0) {
+		if (usb_data_len == 0) {
 			/* NOTE: happens very often with isoc transfers */
 			/* em28xx_usbdbg("packet %d is empty",i); - spammy */
 			continue;
 		}
 
-		/* capture type 0 = vbi start
-		   capture type 1 = vbi in progress
-		   capture type 2 = video start
-		   capture type 3 = video in progress */
-		len = actual_length;
-		if (len >= 4) {
-			/* NOTE: headers are always 4 bytes and
-			 * never split across packets */
-			if (p[0] == 0x33 && p[1] == 0x95) {
-				dev->capture_type = 0;
-				dev->vbi_read = 0;
-				em28xx_usbdbg("VBI START HEADER!!!\n");
-				dev->top_field = !(p[2] & 1);
-				p += 4;
-				len -= 4;
-			} else if (p[0] == 0x88 && p[1] == 0x88 &&
-				   p[2] == 0x88 && p[3] == 0x88) {
-				/* continuation */
-				p += 4;
-				len -= 4;
-			} else if (p[0] == 0x22 && p[1] == 0x5a) {
-				/* start video */
-				dev->capture_type = 2;
-				dev->top_field = !(p[2] & 1);
-				p += 4;
-				len -= 4;
-			}
-		}
-		/* NOTE: with bulk transfers, intermediate data packets
-		 * have no continuation header */
-
-		if (dev->capture_type == 0) {
-			vbi_buf = finish_field_prepare_next(dev, vbi_buf, vbi_dma_q);
-			dev->usb_ctl.vbi_buf = vbi_buf;
-			dev->capture_type = 1;
-		}
-
-		if (dev->capture_type == 1) {
-			int vbi_size = dev->vbi_width * dev->vbi_height;
-			int vbi_data_len = ((dev->vbi_read + len) > vbi_size) ?
-					   (vbi_size - dev->vbi_read) : len;
-
-			/* Copy VBI data */
-			if (vbi_buf != NULL)
-				em28xx_copy_vbi(dev, vbi_buf, p, vbi_data_len);
-			dev->vbi_read += vbi_data_len;
-
-			if (vbi_data_len < len) {
-				/* Continue with copying video data */
-				dev->capture_type = 2;
-				p += vbi_data_len;
-				len -= vbi_data_len;
-			}
-		}
-
-		if (dev->capture_type == 2) {
-			buf = finish_field_prepare_next(dev, buf, dma_q);
-			dev->usb_ctl.vid_buf = buf;
-			dev->capture_type = 3;
-		}
-
-		if (buf != NULL && dev->capture_type == 3 && len > 0)
-			em28xx_copy_video(dev, buf, p, len);
+		process_frame_data_em28xx(dev, usb_data_pkt, usb_data_len);
 	}
-	return rc;
+	return 1;
 }
 
 
-- 
1.7.10.4

