Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34460 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932280AbcKOMGI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 07:06:08 -0500
Received: by mail-wm0-f67.google.com with SMTP id g23so25193072wme.1
        for <linux-media@vger.kernel.org>; Tue, 15 Nov 2016 04:06:07 -0800 (PST)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 1/3] libv4lconvert: Add support for V4L2_PIX_FMT_{HSV24, HSV32}
Date: Tue, 15 Nov 2016 13:05:56 +0100
Message-Id: <20161115120558.2872-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HSV32 and HSV24 are single plane interleaved Hue Saturation Value
formats.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 lib/libv4lconvert/libv4lconvert-priv.h |  3 ++
 lib/libv4lconvert/libv4lconvert.c      | 62 +++++++++++++++++++++++++++
 lib/libv4lconvert/rgbyuv.c             | 77 ++++++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+)

diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
index 1740efc94456..e23893475a6e 100644
--- a/lib/libv4lconvert/libv4lconvert-priv.h
+++ b/lib/libv4lconvert/libv4lconvert-priv.h
@@ -271,6 +271,9 @@ void v4lconvert_hm12_to_bgr24(const unsigned char *src,
 void v4lconvert_hm12_to_yuv420(const unsigned char *src,
 		unsigned char *dst, int width, int height, int yvu);
 
+void v4lconvert_hsv_to_rgb24(const unsigned char *src, unsigned char *dest,
+		int width, int height, int bgr, int Xin, unsigned char hsv_enc);
+
 void v4lconvert_rotate90(unsigned char *src, unsigned char *dest,
 		struct v4l2_format *fmt);
 
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index d3d89362d3ca..da718918b030 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -142,6 +142,9 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
 	{ V4L2_PIX_FMT_Y10BPACK,	10,	20,	20,	0 },
 	{ V4L2_PIX_FMT_Y16,		16,	20,	20,	0 },
 	{ V4L2_PIX_FMT_Y16_BE,		16,	20,	20,	0 },
+	/* hsv formats */
+	{ V4L2_PIX_FMT_HSV32,		32,	 5,	 4,	0 },
+	{ V4L2_PIX_FMT_HSV24,		24,	 5,	 4,	0 },
 };
 
 static const struct v4lconvert_pixfmt supported_dst_pixfmts[] = {
@@ -1327,6 +1330,65 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 			break;
 		}
 		break;
+	case V4L2_PIX_FMT_HSV24:
+		if (src_size < (width * height * 3)) {
+			V4LCONVERT_ERR("short hsv24 data frame\n");
+			errno = EPIPE;
+			result = -1;
+		}
+		switch (dest_pix_fmt) {
+		case V4L2_PIX_FMT_RGB24:
+			v4lconvert_hsv_to_rgb24(src, dest, width, height, 0,
+						24, fmt->fmt.pix.hsv_enc);
+			break;
+		case V4L2_PIX_FMT_BGR24:
+			v4lconvert_hsv_to_rgb24(src, dest, width, height, 1,
+						24, fmt->fmt.pix.hsv_enc);
+			break;
+		case V4L2_PIX_FMT_YUV420:
+			v4lconvert_hsv_to_rgb24(src, dest, width, height, 0,
+						24, fmt->fmt.pix.hsv_enc);
+			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 0, 3);
+			break;
+		case V4L2_PIX_FMT_YVU420:
+			v4lconvert_hsv_to_rgb24(src, dest, width, height, 0,
+						24, fmt->fmt.pix.hsv_enc);
+			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 1, 3);
+			break;
+		}
+
+		break;
+
+	case V4L2_PIX_FMT_HSV32:
+		if (src_size < (width * height * 4)) {
+			V4LCONVERT_ERR("short hsv32 data frame\n");
+			errno = EPIPE;
+			result = -1;
+		}
+		switch (dest_pix_fmt) {
+		case V4L2_PIX_FMT_RGB24:
+			v4lconvert_hsv_to_rgb24(src, dest, width, height, 0,
+						32, fmt->fmt.pix.hsv_enc);
+			break;
+		case V4L2_PIX_FMT_BGR24:
+			v4lconvert_hsv_to_rgb24(src, dest, width, height, 1,
+						32, fmt->fmt.pix.hsv_enc);
+			break;
+		case V4L2_PIX_FMT_YUV420:
+			v4lconvert_hsv_to_rgb24(src, dest, width, height, 0,
+						32, fmt->fmt.pix.hsv_enc);
+			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 0, 3);
+			break;
+		case V4L2_PIX_FMT_YVU420:
+			v4lconvert_hsv_to_rgb24(src, dest, width, height, 0,
+						32, fmt->fmt.pix.hsv_enc);
+			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 1, 3);
+			break;
+		}
+
+		break;
+
+
 
 	default:
 		V4LCONVERT_ERR("Unknown src format in conversion\n");
diff --git a/lib/libv4lconvert/rgbyuv.c b/lib/libv4lconvert/rgbyuv.c
index a0f8256bf7ab..2c91b71ff715 100644
--- a/lib/libv4lconvert/rgbyuv.c
+++ b/lib/libv4lconvert/rgbyuv.c
@@ -770,3 +770,80 @@ void v4lconvert_rgb32_to_rgb24(const unsigned char *src, unsigned char *dest,
 		}
 	}
 }
+
+static void hsvtorgb(const unsigned char *hsv, unsigned char *rgb,
+		     unsigned char hsv_enc)
+{
+	/* From http://stackoverflow.com/questions/3018313/ */
+	uint8_t region;
+	uint8_t remain;
+	uint8_t p, q, t;
+
+	if (!hsv[1]) {
+		rgb[0] = rgb[1] = rgb[2] = hsv[2];
+		return;
+	}
+
+	if (hsv_enc == V4L2_HSV_ENC_256) {
+
+		region = hsv[0] / 43;
+		remain = (hsv[0] - (region * 43)) * 6;
+
+	} else {
+		int aux;
+
+		region = hsv[0] / (180/6);
+
+		/* Remain must be scaled to 0..255 */
+		aux = (hsv[0] % (180/6)) * 6 * 256;
+		aux /= 180;
+		remain = aux;
+	}
+
+	p = (hsv[2] * (255 - hsv[1])) >> 8;
+	q = (hsv[2] * (255 - ((hsv[1] * remain) >> 8))) >> 8;
+	t = (hsv[2] * (255 - ((hsv[1] * (255 - remain)) >> 8))) >> 8;
+
+	switch (region)	{
+	case 0:
+		rgb[0] = hsv[2]; rgb[1] = t; rgb[2] = p;
+		break;
+	case 1:
+		rgb[0] = q; rgb[1] = hsv[2]; rgb[2] = p;
+		break;
+	case 2:
+		rgb[0] = p; rgb[1] = hsv[2]; rgb[2] = t;
+		break;
+	case 3:
+		rgb[0] = p; rgb[1] = q; rgb[2] = hsv[2];
+		break;
+	case 4:
+		rgb[0] = t; rgb[1] = p; rgb[2] = hsv[2];
+		break;
+	default:
+		rgb[0] = hsv[2]; rgb[1] = p; rgb[2] = q;
+		break;
+	}
+
+}
+
+void v4lconvert_hsv_to_rgb24(const unsigned char *src, unsigned char *dest,
+		int width, int height, int bgr, int Xin, unsigned char hsv_enc){
+	int j, k;
+	int bppIN = Xin / 8;
+	unsigned char rgb[3];
+
+	src += bppIN - 3;
+
+	while (--height >= 0)
+		for (j = 0; j < width; j++) {
+			hsvtorgb(src, rgb, hsv_enc);
+			for (k = 0; k < 3; k++)
+				if (bgr && k < 3)
+					*dest++ = rgb[2-k];
+				else
+					*dest++ = rgb[k];
+			src += bppIN;
+		}
+}
+
-- 
2.10.2

