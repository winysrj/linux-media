Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38287 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965354Ab2LHPbh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 10:31:37 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so548069eaa.19
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2012 07:31:36 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/9] em28xx: refactor get_next_buf() and use it for vbi data, too
Date: Sat,  8 Dec 2012 16:31:24 +0100
Message-Id: <1354980692-3791-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

get_next_buf() and vbi_get_next_buf() do exactly the same just with a
different dma queue and buffer. Saving the new buffer pointer back to the
device struct in em28xx_urb_data_copy() instead of doing this from inside
these functions makes it possible to get rid of one of them.

Also refactor the function parameters and return type:
- pass a pointer to struct em28xx as parameter (instead of obtaining the
  pointer from the dma queue pointer with the container_of macro) like we do
  it in all other functions
- instead of using a pointer-pointer, return the pointer to the new buffer
  as return value of the function

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   58 ++++++++-----------------------
 1 Datei geändert, 15 Zeilen hinzugefügt(+), 43 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 6282d48..6acdfea 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -358,57 +358,26 @@ static inline void print_err_status(struct em28xx *dev,
 }
 
 /*
- * video-buf generic routine to get the next available buffer
+ * get the next available buffer from dma queue
  */
-static inline void get_next_buf(struct em28xx_dmaqueue *dma_q,
-					  struct em28xx_buffer **buf)
+static inline struct em28xx_buffer *get_next_buf(struct em28xx *dev,
+						 struct em28xx_dmaqueue *dma_q)
 {
-	struct em28xx *dev = container_of(dma_q, struct em28xx, vidq);
+	struct em28xx_buffer *buf;
 	char *outp;
 
 	if (list_empty(&dma_q->active)) {
 		em28xx_usbdbg("No active queue to serve\n");
-		dev->usb_ctl.vid_buf = NULL;
-		*buf = NULL;
-		return;
-	}
-
-	/* Get the next buffer */
-	*buf = list_entry(dma_q->active.next, struct em28xx_buffer, vb.queue);
-	/* Cleans up buffer - Useful for testing for frame/URB loss */
-	outp = videobuf_to_vmalloc(&(*buf)->vb);
-	memset(outp, 0, (*buf)->vb.size);
-
-	dev->usb_ctl.vid_buf = *buf;
-
-	return;
-}
-
-/*
- * video-buf generic routine to get the next available VBI buffer
- */
-static inline void vbi_get_next_buf(struct em28xx_dmaqueue *dma_q,
-				    struct em28xx_buffer **buf)
-{
-	struct em28xx *dev = container_of(dma_q, struct em28xx, vbiq);
-	char *outp;
-
-	if (list_empty(&dma_q->active)) {
-		em28xx_usbdbg("No active queue to serve\n");
-		dev->usb_ctl.vbi_buf = NULL;
-		*buf = NULL;
-		return;
+		return NULL;
 	}
 
 	/* Get the next buffer */
-	*buf = list_entry(dma_q->active.next, struct em28xx_buffer, vb.queue);
+	buf = list_entry(dma_q->active.next, struct em28xx_buffer, vb.queue);
 	/* Cleans up buffer - Useful for testing for frame/URB loss */
-	outp = videobuf_to_vmalloc(&(*buf)->vb);
-	memset(outp, 0x00, (*buf)->vb.size);
-
-	dev->usb_ctl.vbi_buf = *buf;
+	outp = videobuf_to_vmalloc(&buf->vb);
+	memset(outp, 0, buf->vb.size);
 
-	return;
+	return buf;
 }
 
 /* Processes and copies the URB data content (video and VBI data) */
@@ -518,7 +487,8 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 						vbi_buffer_filled(dev,
 								  vbi_dma_q,
 								  vbi_buf);
-					vbi_get_next_buf(vbi_dma_q, &vbi_buf);
+					vbi_buf = get_next_buf(dev, vbi_dma_q);
+					dev->usb_ctl.vbi_buf = vbi_buf;
 					if (vbi_buf == NULL)
 						vbioutp = NULL;
 					else
@@ -529,7 +499,8 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 				if (dev->vbi_read == 0) {
 					vbi_dma_q->pos = 0;
 					if (vbi_buf != NULL)
-						vbi_buf->top_field = dev->top_field;
+						vbi_buf->top_field
+						  = dev->top_field;
 				}
 
 				dev->vbi_read += len;
@@ -553,7 +524,8 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 			if (dev->progressive || dev->top_field) {
 				if (buf != NULL)
 					buffer_filled(dev, dma_q, buf);
-				get_next_buf(dma_q, &buf);
+				buf = get_next_buf(dev, dma_q);
+				dev->usb_ctl.vid_buf = buf;
 				if (buf == NULL)
 					outp = NULL;
 				else
-- 
1.7.10.4

