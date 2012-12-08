Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38287 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965358Ab2LHPbt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 10:31:49 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so548069eaa.19
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2012 07:31:48 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 6/9] em28xx: move caching of pointer to vmalloc memory in videobuf to struct em28xx_buffer
Date: Sat,  8 Dec 2012 16:31:29 +0100
Message-Id: <1354980692-3791-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the current code em28xx_urb_data_copy() caches the pointer to the vmalloc
memory in videobuf locally.
The alternative would be to call videobuf_to_vmalloc() for each processed USB
data packet (isoc USB transfers => 64 times per URB) in the em28xx_copy_*()
functions.

With the next commits, the data processing code will be split into functions
for serveral reasons:
- em28xx_urb_data_copy() is generally way to long, making it less readable
- there is code duplication between VBI and video data processing
- support for em25xx data processing (uses a different header and frame
  end signaling mechanism) will be added

This would require extensive usage of pointer-pointers, which usually makes the
code less readable and prone to bugs.

The better solution is to cache the pointer in struct em28xx_buffer.
This also improves consistency, because we already track the buffer fill count there.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   29 +++++++++--------------------
 drivers/media/usb/em28xx/em28xx.h       |    3 +++
 2 Dateien geändert, 12 Zeilen hinzugefügt(+), 20 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 70bc562..60df756 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -173,11 +173,12 @@ static inline void finish_buffer(struct em28xx *dev,
 static void em28xx_copy_video(struct em28xx *dev,
 			      struct em28xx_buffer *buf,
 			      unsigned char *p,
-			      unsigned char *outp, unsigned long len)
+			      unsigned long len)
 {
 	void *fieldstart, *startwrite, *startread;
 	int  linesdone, currlinedone, offset, lencopy, remain;
 	int bytesperline = dev->width << 1;
+	unsigned char *outp = buf->vb_buf;
 
 	if (buf->pos + len > buf->vb.size)
 		len = buf->vb.size - buf->pos;
@@ -249,11 +250,12 @@ static void em28xx_copy_video(struct em28xx *dev,
 static void em28xx_copy_vbi(struct em28xx *dev,
 			    struct em28xx_buffer *buf,
 			    unsigned char *p,
-			    unsigned char *outp, unsigned long len)
+			    unsigned long len)
 {
 	void *startwrite, *startread;
 	int  offset;
 	int bytesperline;
+	unsigned char *outp;
 
 	if (dev == NULL) {
 		em28xx_usbdbg("dev is null\n");
@@ -268,6 +270,7 @@ static void em28xx_copy_vbi(struct em28xx *dev,
 		em28xx_usbdbg("p is null\n");
 		return;
 	}
+	outp = buf->vb_buf;
 	if (outp == NULL) {
 		em28xx_usbdbg("outp is null\n");
 		return;
@@ -350,6 +353,7 @@ static inline struct em28xx_buffer *get_next_buf(struct em28xx *dev,
 	outp = videobuf_to_vmalloc(&buf->vb);
 	memset(outp, 0, buf->vb.size);
 	buf->pos = 0;
+	buf->vb_buf = outp;
 
 	return buf;
 }
@@ -362,7 +366,7 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 	struct em28xx_dmaqueue  *vbi_dma_q = &dev->vbiq;
 	int xfer_bulk, num_packets, i, rc = 1;
 	unsigned int actual_length, len = 0;
-	unsigned char *p, *outp = NULL, *vbioutp = NULL;
+	unsigned char *p;
 
 	if (!dev)
 		return 0;
@@ -376,12 +380,7 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 	xfer_bulk = usb_pipebulk(urb->pipe);
 
 	buf = dev->usb_ctl.vid_buf;
-	if (buf != NULL)
-		outp = videobuf_to_vmalloc(&buf->vb);
-
 	vbi_buf = dev->usb_ctl.vbi_buf;
-	if (vbi_buf != NULL)
-		vbioutp = videobuf_to_vmalloc(&vbi_buf->vb);
 
 	if (xfer_bulk) /* bulk */
 		num_packets = 1;
@@ -455,11 +454,6 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 					finish_buffer(dev, vbi_buf);
 				vbi_buf = get_next_buf(dev, vbi_dma_q);
 				dev->usb_ctl.vbi_buf = vbi_buf;
-				if (vbi_buf == NULL)
-					vbioutp = NULL;
-				else
-					vbioutp =
-					  videobuf_to_vmalloc(&vbi_buf->vb);
 			}
 			if (vbi_buf != NULL) {
 				vbi_buf->top_field = dev->top_field;
@@ -474,8 +468,7 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 
 			/* Copy VBI data */
 			if (vbi_buf != NULL)
-				em28xx_copy_vbi(dev, vbi_buf, p, vbioutp,
-						vbi_data_len);
+				em28xx_copy_vbi(dev, vbi_buf, p, vbi_data_len);
 			dev->vbi_read += vbi_data_len;
 
 			if (vbi_data_len < len) {
@@ -493,10 +486,6 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 					finish_buffer(dev, buf);
 				buf = get_next_buf(dev, dma_q);
 				dev->usb_ctl.vid_buf = buf;
-				if (buf == NULL)
-					outp = NULL;
-				else
-					outp = videobuf_to_vmalloc(&buf->vb);
 			}
 			if (buf != NULL) {
 				buf->top_field = dev->top_field;
@@ -505,7 +494,7 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 		}
 
 		if (buf != NULL && dev->capture_type == 3 && len > 0)
-			em28xx_copy_video(dev, buf, p, outp, len);
+			em28xx_copy_video(dev, buf, p, len);
 	}
 	return rc;
 }
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 7507aa6..062841e 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -258,6 +258,9 @@ struct em28xx_buffer {
 	unsigned int pos;
 	/* NOTE; in interlaced mode, this value is reset to zero at
 	 * the start of each new field (not frame !)		   */
+
+	/* pointer to vmalloc memory address in vb */
+	char *vb_buf;
 };
 
 struct em28xx_dmaqueue {
-- 
1.7.10.4

