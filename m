Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34934 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab2KYKiC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 05:38:02 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3997648eek.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 02:38:01 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/6] em28xx: fix/improve frame field handling in em28xx_urb_data_copy_vbi()
Date: Sun, 25 Nov 2012 11:37:35 +0100
Message-Id: <1353839857-2990-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1353839857-2990-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1353839857-2990-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code doesn't set the frame field when a normal video header is
received. This bug didn't cause any trouble, because this type of header is
never received in vbi mode.
Fix it, because we want to use this function with disabled vbi in the future.
Also simplifiy the code.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   24 ++++++++----------------
 drivers/media/usb/em28xx/em28xx.h       |    2 +-
 2 Dateien geändert, 9 Zeilen hinzugefügt(+), 17 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index b170476..12e4b0a 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -593,7 +593,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 				dev->capture_type = 0;
 				dev->vbi_read = 0;
 				em28xx_usbdbg("VBI START HEADER!!!\n");
-				dev->cur_field = p[2];
+				dev->top_field = !(p[2] & 1);
 				p += 4;
 				len -= 4;
 			} else if (p[0] == 0x88 && p[1] == 0x88 &&
@@ -604,6 +604,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 			} else if (p[0] == 0x22 && p[1] == 0x5a) {
 				/* start video */
 				dev->capture_type = 1;
+				dev->top_field = !(p[2] & 1);
 				p += 4;
 				len -= 4;
 			}
@@ -620,8 +621,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 				em28xx_usbdbg("dev->vbi_read > vbi_size\n");
 			} else if ((dev->vbi_read + len) < vbi_size) {
 				/* This entire frame is VBI data */
-				if (dev->vbi_read == 0 &&
-				    (!(dev->cur_field & 1))) {
+				if (dev->vbi_read == 0 && dev->top_field) {
 					/* Brand new frame */
 					if (vbi_buf != NULL)
 						vbi_buffer_filled(dev,
@@ -637,12 +637,8 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 
 				if (dev->vbi_read == 0) {
 					vbi_dma_q->pos = 0;
-					if (vbi_buf != NULL) {
-						if (dev->cur_field & 1)
-							vbi_buf->top_field = 0;
-						else
-							vbi_buf->top_field = 1;
-					}
+					if (vbi_buf != NULL)
+						vbi_buf->top_field = dev->top_field;
 				}
 
 				dev->vbi_read += len;
@@ -663,7 +659,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 
 		if (dev->capture_type == 1) {
 			dev->capture_type = 2;
-			if (dev->progressive || !(dev->cur_field & 1)) {
+			if (dev->progressive || dev->top_field) {
 				if (buf != NULL)
 					buffer_filled(dev, dma_q, buf);
 				get_next_buf(dma_q, &buf);
@@ -672,12 +668,8 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
 				else
 					outp = videobuf_to_vmalloc(&buf->vb);
 			}
-			if (buf != NULL) {
-				if (dev->cur_field & 1)
-					buf->top_field = 0;
-				else
-					buf->top_field = 1;
-			}
+			if (buf != NULL)
+				buf->top_field = dev->top_field;
 
 			dma_q->pos = 0;
 		}
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index aa413bd..09df56a 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -563,7 +563,7 @@ struct em28xx {
 	/* vbi related state tracking */
 	int capture_type;
 	int vbi_read;
-	unsigned char cur_field;
+	unsigned char top_field:1;
 	unsigned int vbi_width;
 	unsigned int vbi_height; /* lines per field */
 
-- 
1.7.10.4

