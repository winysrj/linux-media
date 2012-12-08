Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64860 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965358Ab2LHPbq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 10:31:46 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so806669eek.19
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2012 07:31:46 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 5/9] em28xx: refactor VBI data processing code in em28xx_urb_data_copy()
Date: Sat,  8 Dec 2012 16:31:28 +0100
Message-Id: <1354980692-3791-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a new frame header is detected in em28xx_urb_data_copy() and the data
packet contains both, VBI data and video data, the prevoius VBI buffer doesn't
get finished and is overwritten with the new VBI data.
This bug is not triggered with isochronous USB transfers, because the data
packetes are much smaller than the VBI data size.
But when using USB bulk transfers, the whole data of an URB is treated as
single packet, which is usually much larger then the VBI data size.

Refactor the VBI data processing code to fix this bug, but also to simplify the
code and make it similar to the video data processing code part (which allows
further code abstraction/unification in the future).

The changes have been tested with device "Hauppauge HVR-900".

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   77 +++++++++++++++----------------
 1 Datei geändert, 36 Zeilen hinzugefügt(+), 41 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index ef81d62..70bc562 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -418,8 +418,9 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 		}
 
 		/* capture type 0 = vbi start
-		   capture type 1 = video start
-		   capture type 2 = video in progress */
+		   capture type 1 = vbi in progress
+		   capture type 2 = video start
+		   capture type 3 = video in progress */
 		len = actual_length;
 		if (len >= 4) {
 			/* NOTE: headers are always 4 bytes and
@@ -438,7 +439,7 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 				len -= 4;
 			} else if (p[0] == 0x22 && p[1] == 0x5a) {
 				/* start video */
-				dev->capture_type = 1;
+				dev->capture_type = 2;
 				dev->top_field = !(p[2] & 1);
 				p += 4;
 				len -= 4;
@@ -448,51 +449,45 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 		 * have no continuation header */
 
 		if (dev->capture_type == 0) {
+			dev->capture_type = 1;
+			if (dev->top_field) { /* Brand new frame */
+				if (vbi_buf != NULL)
+					finish_buffer(dev, vbi_buf);
+				vbi_buf = get_next_buf(dev, vbi_dma_q);
+				dev->usb_ctl.vbi_buf = vbi_buf;
+				if (vbi_buf == NULL)
+					vbioutp = NULL;
+				else
+					vbioutp =
+					  videobuf_to_vmalloc(&vbi_buf->vb);
+			}
+			if (vbi_buf != NULL) {
+				vbi_buf->top_field = dev->top_field;
+				vbi_buf->pos = 0;
+			}
+		}
+
+		if (dev->capture_type == 1) {
 			int vbi_size = dev->vbi_width * dev->vbi_height;
-			if (dev->vbi_read >= vbi_size) {
-				/* We've already read all the VBI data, so
-				   treat the rest as video */
-				em28xx_usbdbg("dev->vbi_read > vbi_size\n");
-			} else if ((dev->vbi_read + len) < vbi_size) {
-				/* This entire frame is VBI data */
-				if (dev->vbi_read == 0 && dev->top_field) {
-					/* Brand new frame */
-					if (vbi_buf != NULL)
-						finish_buffer(dev, vbi_buf);
-					vbi_buf = get_next_buf(dev, vbi_dma_q);
-					dev->usb_ctl.vbi_buf = vbi_buf;
-					if (vbi_buf == NULL)
-						vbioutp = NULL;
-					else
-						vbioutp = videobuf_to_vmalloc(
-							&vbi_buf->vb);
-				}
-
-				if (dev->vbi_read == 0) {
-					if (vbi_buf != NULL) {
-						vbi_buf->top_field
-						  = dev->top_field;
-						vbi_buf->pos = 0;
-					}
-				}
-
-				dev->vbi_read += len;
-				em28xx_copy_vbi(dev, vbi_buf, p, vbioutp, len);
-			} else {
-				/* Some of this frame is VBI data and some is
-				   video data */
-				int vbi_data_len = vbi_size - dev->vbi_read;
-				dev->vbi_read += vbi_data_len;
+			int vbi_data_len = ((dev->vbi_read + len) > vbi_size) ?
+					   (vbi_size - dev->vbi_read) : len;
+
+			/* Copy VBI data */
+			if (vbi_buf != NULL)
 				em28xx_copy_vbi(dev, vbi_buf, p, vbioutp,
 						vbi_data_len);
-				dev->capture_type = 1;
+			dev->vbi_read += vbi_data_len;
+
+			if (vbi_data_len < len) {
+				/* Continue with copying video data */
+				dev->capture_type = 2;
 				p += vbi_data_len;
 				len -= vbi_data_len;
 			}
 		}
 
-		if (dev->capture_type == 1) {
-			dev->capture_type = 2;
+		if (dev->capture_type == 2) {
+			dev->capture_type = 3;
 			if (dev->progressive || dev->top_field) {
 				if (buf != NULL)
 					finish_buffer(dev, buf);
@@ -509,7 +504,7 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 			}
 		}
 
-		if (buf != NULL && dev->capture_type == 2 && len > 0)
+		if (buf != NULL && dev->capture_type == 3 && len > 0)
 			em28xx_copy_video(dev, buf, p, outp, len);
 	}
 	return rc;
-- 
1.7.10.4

