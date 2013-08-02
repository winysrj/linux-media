Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:41359 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab3HBWnC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 18:43:02 -0400
Received: by mail-la0-f51.google.com with SMTP id fp13so807854lab.24
        for <linux-media@vger.kernel.org>; Fri, 02 Aug 2013 15:43:00 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org,
	Gregor Jasny <gjasny@googlemail.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 1/2] libv4lconvert: Support for Y16 pixel format
Date: Sat,  3 Aug 2013 00:42:51 +0200
Message-Id: <1375483372-4354-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1375483372-4354-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1375483372-4354-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for V4L2_PIX_FMT_Y16 format.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 lib/libv4lconvert/libv4lconvert-priv.h |    6 ++++++
 lib/libv4lconvert/libv4lconvert.c      |   19 +++++++++++++++++++
 lib/libv4lconvert/rgbyuv.c             |   30 ++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
index c37e220..6422fdd 100644
--- a/lib/libv4lconvert/libv4lconvert-priv.h
+++ b/lib/libv4lconvert/libv4lconvert-priv.h
@@ -152,6 +152,12 @@ void v4lconvert_grey_to_rgb24(const unsigned char *src, unsigned char *dest,
 void v4lconvert_grey_to_yuv420(const unsigned char *src, unsigned char *dest,
 		const struct v4l2_format *src_fmt);
 
+void v4lconvert_y16_to_rgb24(const unsigned char *src, unsigned char *dest,
+		int width, int height);
+
+void v4lconvert_y16_to_yuv420(const unsigned char *src, unsigned char *dest,
+		const struct v4l2_format *src_fmt);
+
 int v4lconvert_y10b_to_rgb24(struct v4lconvert_data *data,
 	const unsigned char *src, unsigned char *dest, int width, int height);
 
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

