Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64860 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965358Ab2LHPbw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 10:31:52 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so806669eek.19
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2012 07:31:51 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 7/9] em28xx: em28xx_urb_data_copy(): move duplicate code for capture_type=0 and capture_type=2 to a function
Date: Sat,  8 Dec 2012 16:31:30 +0100
Message-Id: <1354980692-3791-8-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reduce code duplication by moving the duplicate code for dev->capture_type=0
(vbi start) and dev->capture_type=2 (video start) to a function.
The same function will also be called by the (not yet existing) em25xx frame
data processing code.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   45 +++++++++++++++++--------------
 1 Datei geändert, 25 Zeilen hinzugefügt(+), 20 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 60df756..61c7321 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -358,6 +358,27 @@ static inline struct em28xx_buffer *get_next_buf(struct em28xx *dev,
 	return buf;
 }
 
+/*
+ * Finish the current buffer if completed and prepare for the next field
+ */
+static struct em28xx_buffer *
+finish_field_prepare_next(struct em28xx *dev,
+			  struct em28xx_buffer *buf,
+			  struct em28xx_dmaqueue *dma_q)
+{
+	if (dev->progressive || dev->top_field) { /* Brand new frame */
+		if (buf != NULL)
+			finish_buffer(dev, buf);
+		buf = get_next_buf(dev, dma_q);
+	}
+	if (buf != NULL) {
+		buf->top_field = dev->top_field;
+		buf->pos = 0;
+	}
+
+	return buf;
+}
+
 /* Processes and copies the URB data content (video and VBI data) */
 static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 {
@@ -448,17 +469,9 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 		 * have no continuation header */
 
 		if (dev->capture_type == 0) {
+			vbi_buf = finish_field_prepare_next(dev, vbi_buf, vbi_dma_q);
+			dev->usb_ctl.vbi_buf = vbi_buf;
 			dev->capture_type = 1;
-			if (dev->top_field) { /* Brand new frame */
-				if (vbi_buf != NULL)
-					finish_buffer(dev, vbi_buf);
-				vbi_buf = get_next_buf(dev, vbi_dma_q);
-				dev->usb_ctl.vbi_buf = vbi_buf;
-			}
-			if (vbi_buf != NULL) {
-				vbi_buf->top_field = dev->top_field;
-				vbi_buf->pos = 0;
-			}
 		}
 
 		if (dev->capture_type == 1) {
@@ -480,17 +493,9 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 		}
 
 		if (dev->capture_type == 2) {
+			buf = finish_field_prepare_next(dev, buf, dma_q);
+			dev->usb_ctl.vid_buf = buf;
 			dev->capture_type = 3;
-			if (dev->progressive || dev->top_field) {
-				if (buf != NULL)
-					finish_buffer(dev, buf);
-				buf = get_next_buf(dev, dma_q);
-				dev->usb_ctl.vid_buf = buf;
-			}
-			if (buf != NULL) {
-				buf->top_field = dev->top_field;
-				buf->pos = 0;
-			}
 		}
 
 		if (buf != NULL && dev->capture_type == 3 && len > 0)
-- 
1.7.10.4

