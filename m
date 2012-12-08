Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64860 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965355Ab2LHPbj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 10:31:39 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so806669eek.19
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2012 07:31:38 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/9] em28xx: use common function for video and vbi buffer completion
Date: Sat,  8 Dec 2012 16:31:25 +0100
Message-Id: <1354980692-3791-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   33 +++++--------------------------
 1 Datei geändert, 5 Zeilen hinzugefügt(+), 28 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 6acdfea..71a3181 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -154,36 +154,15 @@ static struct v4l2_queryctrl ac97_qctrl[] = {
    ------------------------------------------------------------------*/
 
 /*
- * Announces that a buffer were filled and request the next
+ * Finish the current buffer
  */
-static inline void buffer_filled(struct em28xx *dev,
-				  struct em28xx_dmaqueue *dma_q,
-				  struct em28xx_buffer *buf)
+static inline void finish_buffer(struct em28xx *dev,
+				 struct em28xx_buffer *buf)
 {
-	/* Advice that buffer was filled */
 	em28xx_usbdbg("[%p/%d] wakeup\n", buf, buf->vb.i);
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
 	do_gettimeofday(&buf->vb.ts);
-
-	dev->usb_ctl.vid_buf = NULL;
-
-	list_del(&buf->vb.queue);
-	wake_up(&buf->vb.done);
-}
-
-static inline void vbi_buffer_filled(struct em28xx *dev,
-				     struct em28xx_dmaqueue *dma_q,
-				     struct em28xx_buffer *buf)
-{
-	/* Advice that buffer was filled */
-	em28xx_usbdbg("[%p/%d] wakeup\n", buf, buf->vb.i);
-	buf->vb.state = VIDEOBUF_DONE;
-	buf->vb.field_count++;
-	do_gettimeofday(&buf->vb.ts);
-
-	dev->usb_ctl.vbi_buf = NULL;
-
 	list_del(&buf->vb.queue);
 	wake_up(&buf->vb.done);
 }
@@ -484,9 +463,7 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 				if (dev->vbi_read == 0 && dev->top_field) {
 					/* Brand new frame */
 					if (vbi_buf != NULL)
-						vbi_buffer_filled(dev,
-								  vbi_dma_q,
-								  vbi_buf);
+						finish_buffer(dev, vbi_buf);
 					vbi_buf = get_next_buf(dev, vbi_dma_q);
 					dev->usb_ctl.vbi_buf = vbi_buf;
 					if (vbi_buf == NULL)
@@ -523,7 +500,7 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 			dev->capture_type = 2;
 			if (dev->progressive || dev->top_field) {
 				if (buf != NULL)
-					buffer_filled(dev, dma_q, buf);
+					finish_buffer(dev, buf);
 				buf = get_next_buf(dev, dma_q);
 				dev->usb_ctl.vid_buf = buf;
 				if (buf == NULL)
-- 
1.7.10.4

