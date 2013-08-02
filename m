Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:49070 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab3HBWnF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 18:43:05 -0400
Received: by mail-lb0-f181.google.com with SMTP id o10so826455lbi.40
        for <linux-media@vger.kernel.org>; Fri, 02 Aug 2013 15:43:03 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org,
	Gregor Jasny <gjasny@googlemail.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 2/2] libv4lconvert: Support for RGB32 and BGR32 format
Date: Sat,  3 Aug 2013 00:42:52 +0200
Message-Id: <1375483372-4354-3-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1375483372-4354-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1375483372-4354-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for V4L2_PIX_FMT_BGR32 and V4L2_PIX_FMT_BGR32
formats.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 lib/libv4lconvert/libv4lconvert-priv.h |    5 ++-
 lib/libv4lconvert/libv4lconvert.c      |   58 ++++++++++++++++++++++++++++----
 lib/libv4lconvert/rgbyuv.c             |   45 +++++++++++++++++++------
 3 files changed, 90 insertions(+), 18 deletions(-)

diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
index 6422fdd..ac1391e 100644
--- a/lib/libv4lconvert/libv4lconvert-priv.h
+++ b/lib/libv4lconvert/libv4lconvert-priv.h
@@ -108,7 +108,7 @@ unsigned char *v4lconvert_alloc_buffer(int needed,
 int v4lconvert_oom_error(struct v4lconvert_data *data);
 
 void v4lconvert_rgb24_to_yuv420(const unsigned char *src, unsigned char *dest,
-		const struct v4l2_format *src_fmt, int bgr, int yvu);
+		const struct v4l2_format *src_fmt, int bgr, int yvu, int bpp);
 
 void v4lconvert_yuv420_to_rgb24(const unsigned char *src, unsigned char *dst,
 		int width, int height, int yvu);
@@ -158,6 +158,9 @@ void v4lconvert_y16_to_rgb24(const unsigned char *src, unsigned char *dest,
 void v4lconvert_y16_to_yuv420(const unsigned char *src, unsigned char *dest,
 		const struct v4l2_format *src_fmt);
 
+void v4lconvert_rgb32_to_rgb24(const unsigned char *src, unsigned char *dest,
+		int width, int height, int bgr);
+
 int v4lconvert_y10b_to_rgb24(struct v4lconvert_data *data,
 	const unsigned char *src, unsigned char *dest, int width, int height);
 
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index bc5e34f..2aec99a 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -84,6 +84,8 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
 	SUPPORTED_DST_PIXFMTS,
 	/* packed rgb formats */
 	{ V4L2_PIX_FMT_RGB565,		16,	 4,	 6,	0 },
+	{ V4L2_PIX_FMT_BGR32,		32,	 4,	 6,	0 },
+	{ V4L2_PIX_FMT_RGB32,		32,	 4,	 6,	0 },
 	/* yuv 4:2:2 formats */
 	{ V4L2_PIX_FMT_YUYV,		16,	 5,	 4,	0 },
 	{ V4L2_PIX_FMT_YVYU,		16,	 5,	 4,	0 },
@@ -981,10 +983,10 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 			v4lconvert_swap_rgb(d, dest, width, height);
 			break;
 		case V4L2_PIX_FMT_YUV420:
-			v4lconvert_rgb24_to_yuv420(d, dest, fmt, 0, 0);
+			v4lconvert_rgb24_to_yuv420(d, dest, fmt, 0, 0, 3);
 			break;
 		case V4L2_PIX_FMT_YVU420:
-			v4lconvert_rgb24_to_yuv420(d, dest, fmt, 0, 1);
+			v4lconvert_rgb24_to_yuv420(d, dest, fmt, 0, 1, 3);
 			break;
 		}
 		break;
@@ -1079,10 +1081,10 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 			v4lconvert_swap_rgb(src, dest, width, height);
 			break;
 		case V4L2_PIX_FMT_YUV420:
-			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 0);
+			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 0, 3);
 			break;
 		case V4L2_PIX_FMT_YVU420:
-			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 1);
+			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 1, 3);
 			break;
 		}
 		if (src_size < (width * height * 3)) {
@@ -1101,10 +1103,10 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 			memcpy(dest, src, width * height * 3);
 			break;
 		case V4L2_PIX_FMT_YUV420:
-			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 1, 0);
+			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 1, 0, 3);
 			break;
 		case V4L2_PIX_FMT_YVU420:
-			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 1, 1);
+			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 1, 1, 3);
 			break;
 		}
 		if (src_size < (width * height * 3)) {
@@ -1114,6 +1116,50 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 		}
 		break;
 
+	case V4L2_PIX_FMT_RGB32:
+		switch (dest_pix_fmt) {
+		case V4L2_PIX_FMT_RGB24:
+			v4lconvert_rgb32_to_rgb24(src, dest, width, height, 0);
+			break;
+		case V4L2_PIX_FMT_BGR24:
+			v4lconvert_rgb32_to_rgb24(src, dest, width, height, 1);
+			break;
+		case V4L2_PIX_FMT_YUV420:
+			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 0, 4);
+			break;
+		case V4L2_PIX_FMT_YVU420:
+			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 1, 4);
+			break;
+		}
+		if (src_size < (width * height * 4)) {
+			V4LCONVERT_ERR("short rgb32 data frame\n");
+			errno = EPIPE;
+			result = -1;
+		}
+		break;
+
+	case V4L2_PIX_FMT_BGR32:
+		switch (dest_pix_fmt) {
+		case V4L2_PIX_FMT_RGB24:
+			v4lconvert_rgb32_to_rgb24(src, dest, width, height, 1);
+			break;
+		case V4L2_PIX_FMT_BGR24:
+			v4lconvert_rgb32_to_rgb24(src, dest, width, height, 0);
+			break;
+		case V4L2_PIX_FMT_YUV420:
+			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 1, 0, 4);
+			break;
+		case V4L2_PIX_FMT_YVU420:
+			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 1, 1, 4);
+			break;
+		}
+		if (src_size < (width * height * 4)) {
+			V4LCONVERT_ERR("short bgr32 data frame\n");
+			errno = EPIPE;
+			result = -1;
+		}
+		break;
+
 	case V4L2_PIX_FMT_YUV420:
 		switch (dest_pix_fmt) {
 		case V4L2_PIX_FMT_RGB24:
diff --git a/lib/libv4lconvert/rgbyuv.c b/lib/libv4lconvert/rgbyuv.c
index bef034f..d2f11bf 100644
--- a/lib/libv4lconvert/rgbyuv.c
+++ b/lib/libv4lconvert/rgbyuv.c
@@ -35,7 +35,7 @@
 	} while (0)
 
 void v4lconvert_rgb24_to_yuv420(const unsigned char *src, unsigned char *dest,
-		const struct v4l2_format *src_fmt, int bgr, int yvu)
+		const struct v4l2_format *src_fmt, int bgr, int yvu, int bpp)
 {
 	int x, y;
 	unsigned char *udest, *vdest;
@@ -47,9 +47,10 @@ void v4lconvert_rgb24_to_yuv420(const unsigned char *src, unsigned char *dest,
 				RGB2Y(src[2], src[1], src[0], *dest++);
 			else
 				RGB2Y(src[0], src[1], src[2], *dest++);
-			src += 3;
+			src += bpp;
 		}
-		src += src_fmt->fmt.pix.bytesperline - 3 * src_fmt->fmt.pix.width;
+
+		src += src_fmt->fmt.pix.bytesperline - bpp * src_fmt->fmt.pix.width;
 	}
 	src -= src_fmt->fmt.pix.height * src_fmt->fmt.pix.bytesperline;
 
@@ -66,19 +67,19 @@ void v4lconvert_rgb24_to_yuv420(const unsigned char *src, unsigned char *dest,
 		for (x = 0; x < src_fmt->fmt.pix.width / 2; x++) {
 			int avg_src[3];
 
-			avg_src[0] = (src[0] + src[3] + src[src_fmt->fmt.pix.bytesperline] +
-					src[src_fmt->fmt.pix.bytesperline + 3]) / 4;
-			avg_src[1] = (src[1] + src[4] + src[src_fmt->fmt.pix.bytesperline + 1] +
-					src[src_fmt->fmt.pix.bytesperline + 4]) / 4;
-			avg_src[2] = (src[2] + src[5] + src[src_fmt->fmt.pix.bytesperline + 2] +
-					src[src_fmt->fmt.pix.bytesperline + 5]) / 4;
+			avg_src[0] = (src[0] + src[bpp] + src[src_fmt->fmt.pix.bytesperline] +
+					src[src_fmt->fmt.pix.bytesperline + bpp]) / 4;
+			avg_src[1] = (src[1] + src[bpp + 1] + src[src_fmt->fmt.pix.bytesperline + 1] +
+					src[src_fmt->fmt.pix.bytesperline + bpp + 1]) / 4;
+			avg_src[2] = (src[2] + src[bpp + 2] + src[src_fmt->fmt.pix.bytesperline + 2] +
+					src[src_fmt->fmt.pix.bytesperline + bpp + 2]) / 4;
 			if (bgr)
 				RGB2UV(avg_src[2], avg_src[1], avg_src[0], *udest++, *vdest++);
 			else
 				RGB2UV(avg_src[0], avg_src[1], avg_src[2], *udest++, *vdest++);
-			src += 6;
+			src += 2 * bpp;
 		}
-		src += 2 * src_fmt->fmt.pix.bytesperline - 3 * src_fmt->fmt.pix.width;
+		src += 2 * src_fmt->fmt.pix.bytesperline - bpp * src_fmt->fmt.pix.width;
 	}
 }
 
@@ -725,3 +726,25 @@ int v4lconvert_y10b_to_yuv420(struct v4lconvert_data *data,
 
 	return 0;
 }
+
+void v4lconvert_rgb32_to_rgb24(const unsigned char *src, unsigned char *dest,
+		int width, int height,int bgr)
+{
+	int j;
+	while (--height >= 0) {
+		for (j = 0; j < width; j++) {
+			if (bgr){
+				*dest++ = src[2];
+				*dest++ = src[1];
+				*dest++ = src[0];
+				src+=4;
+			}
+			else{
+				*dest++ = *src++;
+				*dest++ = *src++;
+				*dest++ = *src++;
+				src+=1;
+			}
+		}
+	}
+}
-- 
1.7.10.4

