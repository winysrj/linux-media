Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64860 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965354Ab2LHPbo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 10:31:44 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so806669eek.19
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2012 07:31:43 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/9] em28xx: move field 'pos' from struct em28xx_dmaqueue to struct em28xx_buffer
Date: Sat,  8 Dec 2012 16:31:27 +0100
Message-Id: <1354980692-3791-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This field is used to keep track of the current memory position in the buffer,
not in the dma queue, so move it to right place.
This also allows us to get rid of the struct em28xx_dmaqueue pointer parameter
in functions em28xx_copy_video() and em28xx_copy_vbi().

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   53 ++++++++++++++-----------------
 drivers/media/usb/em28xx/em28xx.h       |    8 +++--
 2 Dateien geändert, 29 Zeilen hinzugefügt(+), 32 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 71a3181..ef81d62 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -171,7 +171,6 @@ static inline void finish_buffer(struct em28xx *dev,
  * Identify the buffer header type and properly handles
  */
 static void em28xx_copy_video(struct em28xx *dev,
-			      struct em28xx_dmaqueue  *dma_q,
 			      struct em28xx_buffer *buf,
 			      unsigned char *p,
 			      unsigned char *outp, unsigned long len)
@@ -180,8 +179,8 @@ static void em28xx_copy_video(struct em28xx *dev,
 	int  linesdone, currlinedone, offset, lencopy, remain;
 	int bytesperline = dev->width << 1;
 
-	if (dma_q->pos + len > buf->vb.size)
-		len = buf->vb.size - dma_q->pos;
+	if (buf->pos + len > buf->vb.size)
+		len = buf->vb.size - buf->pos;
 
 	startread = p;
 	remain = len;
@@ -191,8 +190,8 @@ static void em28xx_copy_video(struct em28xx *dev,
 	else /* interlaced mode, even nr. of lines */
 		fieldstart = outp + bytesperline;
 
-	linesdone = dma_q->pos / bytesperline;
-	currlinedone = dma_q->pos % bytesperline;
+	linesdone = buf->pos / bytesperline;
+	currlinedone = buf->pos % bytesperline;
 
 	if (dev->progressive)
 		offset = linesdone * bytesperline + currlinedone;
@@ -244,14 +243,13 @@ static void em28xx_copy_video(struct em28xx *dev,
 		remain -= lencopy;
 	}
 
-	dma_q->pos += len;
+	buf->pos += len;
 }
 
 static void em28xx_copy_vbi(struct em28xx *dev,
-			      struct em28xx_dmaqueue  *dma_q,
-			      struct em28xx_buffer *buf,
-			      unsigned char *p,
-			      unsigned char *outp, unsigned long len)
+			    struct em28xx_buffer *buf,
+			    unsigned char *p,
+			    unsigned char *outp, unsigned long len)
 {
 	void *startwrite, *startread;
 	int  offset;
@@ -263,10 +261,6 @@ static void em28xx_copy_vbi(struct em28xx *dev,
 	}
 	bytesperline = dev->vbi_width;
 
-	if (dma_q == NULL) {
-		em28xx_usbdbg("dma_q is null\n");
-		return;
-	}
 	if (buf == NULL) {
 		return;
 	}
@@ -279,13 +273,13 @@ static void em28xx_copy_vbi(struct em28xx *dev,
 		return;
 	}
 
-	if (dma_q->pos + len > buf->vb.size)
-		len = buf->vb.size - dma_q->pos;
+	if (buf->pos + len > buf->vb.size)
+		len = buf->vb.size - buf->pos;
 
 	startread = p;
 
-	startwrite = outp + dma_q->pos;
-	offset = dma_q->pos;
+	startwrite = outp + buf->pos;
+	offset = buf->pos;
 
 	/* Make sure the bottom field populates the second half of the frame */
 	if (buf->top_field == 0) {
@@ -294,7 +288,7 @@ static void em28xx_copy_vbi(struct em28xx *dev,
 	}
 
 	memcpy(startwrite, startread, len);
-	dma_q->pos += len;
+	buf->pos += len;
 }
 
 static inline void print_err_status(struct em28xx *dev,
@@ -355,6 +349,7 @@ static inline struct em28xx_buffer *get_next_buf(struct em28xx *dev,
 	/* Cleans up buffer - Useful for testing for frame/URB loss */
 	outp = videobuf_to_vmalloc(&buf->vb);
 	memset(outp, 0, buf->vb.size);
+	buf->pos = 0;
 
 	return buf;
 }
@@ -474,22 +469,22 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 				}
 
 				if (dev->vbi_read == 0) {
-					vbi_dma_q->pos = 0;
-					if (vbi_buf != NULL)
+					if (vbi_buf != NULL) {
 						vbi_buf->top_field
 						  = dev->top_field;
+						vbi_buf->pos = 0;
+					}
 				}
 
 				dev->vbi_read += len;
-				em28xx_copy_vbi(dev, vbi_dma_q, vbi_buf, p,
-						vbioutp, len);
+				em28xx_copy_vbi(dev, vbi_buf, p, vbioutp, len);
 			} else {
 				/* Some of this frame is VBI data and some is
 				   video data */
 				int vbi_data_len = vbi_size - dev->vbi_read;
 				dev->vbi_read += vbi_data_len;
-				em28xx_copy_vbi(dev, vbi_dma_q, vbi_buf, p,
-						vbioutp, vbi_data_len);
+				em28xx_copy_vbi(dev, vbi_buf, p, vbioutp,
+						vbi_data_len);
 				dev->capture_type = 1;
 				p += vbi_data_len;
 				len -= vbi_data_len;
@@ -508,14 +503,14 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 				else
 					outp = videobuf_to_vmalloc(&buf->vb);
 			}
-			if (buf != NULL)
+			if (buf != NULL) {
 				buf->top_field = dev->top_field;
-
-			dma_q->pos = 0;
+				buf->pos = 0;
+			}
 		}
 
 		if (buf != NULL && dev->capture_type == 2 && len > 0)
-			em28xx_copy_video(dev, dma_q, buf, p, outp, len);
+			em28xx_copy_video(dev, buf, p, outp, len);
 	}
 	return rc;
 }
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index b3d72a9..7507aa6 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -253,15 +253,17 @@ struct em28xx_buffer {
 	struct videobuf_buffer vb;
 
 	int top_field;
+
+	/* counter to control buffer fill */
+	unsigned int pos;
+	/* NOTE; in interlaced mode, this value is reset to zero at
+	 * the start of each new field (not frame !)		   */
 };
 
 struct em28xx_dmaqueue {
 	struct list_head       active;
 
 	wait_queue_head_t          wq;
-
-	/* Counters to control buffer fill */
-	int                        pos;
 };
 
 /* inputs */
-- 
1.7.10.4

