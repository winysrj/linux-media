Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38287 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965370Ab2LHPb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 10:31:57 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so548069eaa.19
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2012 07:31:56 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 9/9] em28xx: clean up and unify functions em28xx_copy_vbi() em28xx_copy_video()
Date: Sat,  8 Dec 2012 16:31:32 +0100
Message-Id: <1354980692-3791-10-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code in em28xx_vbi_copy can be simplified a lot.
Also rename some variables to something more meaningful and fix+add the
function descriptions.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   65 ++++++++++---------------------
 1 Datei geändert, 20 Zeilen hinzugefügt(+), 45 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index fb40d0b..bd168de 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -168,28 +168,27 @@ static inline void finish_buffer(struct em28xx *dev,
 }
 
 /*
- * Identify the buffer header type and properly handles
+ * Copy picture data from USB buffer to videobuf buffer
  */
 static void em28xx_copy_video(struct em28xx *dev,
 			      struct em28xx_buffer *buf,
-			      unsigned char *p,
+			      unsigned char *usb_buf,
 			      unsigned long len)
 {
 	void *fieldstart, *startwrite, *startread;
 	int  linesdone, currlinedone, offset, lencopy, remain;
 	int bytesperline = dev->width << 1;
-	unsigned char *outp = buf->vb_buf;
 
 	if (buf->pos + len > buf->vb.size)
 		len = buf->vb.size - buf->pos;
 
-	startread = p;
+	startread = usb_buf;
 	remain = len;
 
 	if (dev->progressive || buf->top_field)
-		fieldstart = outp;
+		fieldstart = buf->vb_buf;
 	else /* interlaced mode, even nr. of lines */
-		fieldstart = outp + bytesperline;
+		fieldstart = buf->vb_buf + bytesperline;
 
 	linesdone = buf->pos / bytesperline;
 	currlinedone = buf->pos % bytesperline;
@@ -203,11 +202,12 @@ static void em28xx_copy_video(struct em28xx *dev,
 	lencopy = bytesperline - currlinedone;
 	lencopy = lencopy > remain ? remain : lencopy;
 
-	if ((char *)startwrite + lencopy > (char *)outp + buf->vb.size) {
+	if ((char *)startwrite + lencopy > (char *)buf->vb_buf + buf->vb.size) {
 		em28xx_usbdbg("Overflow of %zi bytes past buffer end (1)\n",
 			      ((char *)startwrite + lencopy) -
-			      ((char *)outp + buf->vb.size));
-		remain = (char *)outp + buf->vb.size - (char *)startwrite;
+			      ((char *)buf->vb_buf + buf->vb.size));
+		remain = (char *)buf->vb_buf + buf->vb.size -
+			 (char *)startwrite;
 		lencopy = remain;
 	}
 	if (lencopy <= 0)
@@ -227,13 +227,13 @@ static void em28xx_copy_video(struct em28xx *dev,
 		else
 			lencopy = bytesperline;
 
-		if ((char *)startwrite + lencopy > (char *)outp +
+		if ((char *)startwrite + lencopy > (char *)buf->vb_buf +
 		    buf->vb.size) {
 			em28xx_usbdbg("Overflow of %zi bytes past buffer end"
 				       "(2)\n",
 				       ((char *)startwrite + lencopy) -
-				       ((char *)outp + buf->vb.size));
-			lencopy = remain = (char *)outp + buf->vb.size -
+				       ((char *)buf->vb_buf + buf->vb.size));
+			lencopy = remain = (char *)buf->vb_buf + buf->vb.size -
 					   (char *)startwrite;
 		}
 		if (lencopy <= 0)
@@ -247,50 +247,25 @@ static void em28xx_copy_video(struct em28xx *dev,
 	buf->pos += len;
 }
 
+/*
+ * Copy VBI data from USB buffer to videobuf buffer
+ */
 static void em28xx_copy_vbi(struct em28xx *dev,
 			    struct em28xx_buffer *buf,
-			    unsigned char *p,
+			    unsigned char *usb_buf,
 			    unsigned long len)
 {
-	void *startwrite, *startread;
-	int  offset;
-	int bytesperline;
-	unsigned char *outp;
-
-	if (dev == NULL) {
-		em28xx_usbdbg("dev is null\n");
-		return;
-	}
-	bytesperline = dev->vbi_width;
-
-	if (buf == NULL) {
-		return;
-	}
-	if (p == NULL) {
-		em28xx_usbdbg("p is null\n");
-		return;
-	}
-	outp = buf->vb_buf;
-	if (outp == NULL) {
-		em28xx_usbdbg("outp is null\n");
-		return;
-	}
+	unsigned int offset;
 
 	if (buf->pos + len > buf->vb.size)
 		len = buf->vb.size - buf->pos;
 
-	startread = p;
-
-	startwrite = outp + buf->pos;
 	offset = buf->pos;
-
 	/* Make sure the bottom field populates the second half of the frame */
-	if (buf->top_field == 0) {
-		startwrite += bytesperline * dev->vbi_height;
-		offset += bytesperline * dev->vbi_height;
-	}
+	if (buf->top_field == 0)
+		offset += dev->vbi_width * dev->vbi_height;
 
-	memcpy(startwrite, startread, len);
+	memcpy(buf->vb_buf + offset, usb_buf, len);
 	buf->pos += len;
 }
 
-- 
1.7.10.4

