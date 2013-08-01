Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:58001 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab3HALvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 07:51:40 -0400
Received: by mail-la0-f53.google.com with SMTP id el20so1327296lab.26
        for <linux-media@vger.kernel.org>; Thu, 01 Aug 2013 04:51:39 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: hans.verkuil@cisco.com, gjasny@googlemail.com,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] libv4lconvert: Support for Y16 pixel format
Date: Thu,  1 Aug 2013 13:51:29 +0200
Message-Id: <1375357890-3665-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for V4L2_PIX_FMT_Y16 format.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 lib/libv4lconvert/libv4lconvert.c |   19 +++++++++++++++++++
 lib/libv4lconvert/rgbyuv.c        |   30 ++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index 60010f1..bc5e34f 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -128,6 +128,7 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
 	{ V4L2_PIX_FMT_Y4,		 8,	20,	20,	0 },
 	{ V4L2_PIX_FMT_Y6,		 8,	20,	20,	0 },
 	{ V4L2_PIX_FMT_Y10BPACK,	10,	20,	20,	0 },
+	{ V4L2_PIX_FMT_Y16,		16,	20,	20,	0 },
 };
 
 static const struct v4lconvert_pixfmt supported_dst_pixfmts[] = {
@@ -989,6 +990,24 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 		break;
 	}
 
+	case V4L2_PIX_FMT_Y16:
+		switch (dest_pix_fmt) {
+		case V4L2_PIX_FMT_RGB24:
+	        case V4L2_PIX_FMT_BGR24:
+			v4lconvert_y16_to_rgb24(src, dest, width, height);
+			break;
+		case V4L2_PIX_FMT_YUV420:
+		case V4L2_PIX_FMT_YVU420:
+			v4lconvert_y16_to_yuv420(src, dest, fmt);
+			break;
+		}
+		if (src_size < (width * height * 2)) {
+			V4LCONVERT_ERR("short y16 data frame\n");
+			errno = EPIPE;
+			result = -1;
+		}
+		break;
+
 	case V4L2_PIX_FMT_GREY:
 	case V4L2_PIX_FMT_Y4:
 	case V4L2_PIX_FMT_Y6:
diff --git a/lib/libv4lconvert/rgbyuv.c b/lib/libv4lconvert/rgbyuv.c
index d05abe9..bef034f 100644
--- a/lib/libv4lconvert/rgbyuv.c
+++ b/lib/libv4lconvert/rgbyuv.c
@@ -586,6 +586,36 @@ void v4lconvert_rgb565_to_yuv420(const unsigned char *src, unsigned char *dest,
 	}
 }
 
+void v4lconvert_y16_to_rgb24(const unsigned char *src, unsigned char *dest,
+		int width, int height)
+{
+	int j;
+	while (--height >= 0) {
+		for (j = 0; j < width; j++) {
+			*dest++ = *src;
+			*dest++ = *src;
+			*dest++ = *src;
+			src+=2;
+		}
+	}
+}
+
+void v4lconvert_y16_to_yuv420(const unsigned char *src, unsigned char *dest,
+		const struct v4l2_format *src_fmt)
+{
+	int x, y;
+
+	/* Y */
+	for (y = 0; y < src_fmt->fmt.pix.height; y++)
+		for (x = 0; x < src_fmt->fmt.pix.width; x++){
+			*dest++ = *src;
+			src+=2;
+		}
+
+	/* Clear U/V */
+	memset(dest, 0x80, src_fmt->fmt.pix.width * src_fmt->fmt.pix.height / 2);
+}
+
 void v4lconvert_grey_to_rgb24(const unsigned char *src, unsigned char *dest,
 		int width, int height)
 {
-- 
1.7.10.4

