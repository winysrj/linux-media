Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33487 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbcGOQNd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 12:13:33 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 5/6] [media] vivid: Add support for HSV formats
Date: Fri, 15 Jul 2016 18:13:18 +0200
Message-Id: <1468599199-5902-6-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1468599199-5902-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1468599199-5902-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for V4L2_PIX_FMT_HSV24 and V4L2_PIX_FMT_HSV32.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c   | 94 +++++++++++++++++++++++--
 drivers/media/platform/vivid/vivid-vid-common.c | 14 ++++
 include/media/v4l2-tpg.h                        |  1 +
 3 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index acf0e6854832..85b9c1925dd9 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -318,6 +318,10 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->hmask[0] = ~1;
 		tpg->color_representation = TGP_COLOR_REPRESENTATION_YUV;
 		break;
+	case V4L2_PIX_FMT_HSV24:
+	case V4L2_PIX_FMT_HSV32:
+		tpg->color_representation = TGP_COLOR_REPRESENTATION_HSV;
+		break;
 	default:
 		return false;
 	}
@@ -351,6 +355,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		break;
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_BGR24:
+	case V4L2_PIX_FMT_HSV24:
 		tpg->twopixelsize[0] = 2 * 3;
 		break;
 	case V4L2_PIX_FMT_BGR666:
@@ -361,6 +366,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_ARGB32:
 	case V4L2_PIX_FMT_ABGR32:
 	case V4L2_PIX_FMT_YUV32:
+	case V4L2_PIX_FMT_HSV32:
 		tpg->twopixelsize[0] = 2 * 4;
 		break;
 	case V4L2_PIX_FMT_NV12:
@@ -408,6 +414,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->twopixelsize[1] = 4;
 		break;
 	}
+
 	return true;
 }
 EXPORT_SYMBOL_GPL(tpg_s_fourcc);
@@ -490,6 +497,64 @@ static inline int linear_to_rec709(int v)
 	return tpg_linear_to_rec709[v];
 }
 
+static void color_to_hsv(struct tpg_data *tpg, int r, int g, int b,
+			   int *h, int *s, int *v)
+{
+	int max_rgb, min_rgb, diff_rgb;
+	int aux;
+	int third;
+
+	r >>= 4;
+	g >>= 4;
+	b >>= 4;
+
+	/*V*/
+	max_rgb = max3(r, g, b);
+	*v = max_rgb;
+	if (!max_rgb) {
+		*h = 0;
+		*s = 0;
+		return;
+	}
+
+	/*S*/
+	min_rgb = min3(r, g, b);
+	diff_rgb = max_rgb - min_rgb;
+	aux = 255 * diff_rgb;
+	aux += max_rgb / 2;
+	aux /= max_rgb;
+	*s = aux;
+	if (!aux) {
+		*h = 0;
+		return;
+	}
+
+	/*H*/
+	if (max_rgb == r) {
+		aux =  g - b;
+		third = 0;
+	} else if (max_rgb == g) {
+		aux =  b - r;
+		third = 60;
+	} else {
+		aux =  r - g;
+		third = 120;
+	}
+
+	aux *= 30;
+	aux += diff_rgb / 2;
+	aux /= diff_rgb;
+	aux += third;
+
+	/*Clamp H*/
+	if (aux < 0)
+		aux += 180;
+	else if (aux > 180)
+		aux -= 180;
+	*h = aux;
+
+}
+
 static void rgb2ycbcr(const int m[3][3], int r, int g, int b,
 			int y_offset, int *y, int *cb, int *cr)
 {
@@ -829,7 +894,19 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		ycbcr_to_color(tpg, y, cb, cr, &r, &g, &b);
 	}
 
-	if (tpg->color_representation == TGP_COLOR_REPRESENTATION_YUV) {
+	switch (tpg->color_representation) {
+	case TGP_COLOR_REPRESENTATION_HSV:
+	{
+		int h, s, v;
+
+		color_to_hsv(tpg, r, g, b, &h, &s, &v);
+		tpg->colors[k][0] = h;
+		tpg->colors[k][1] = s;
+		tpg->colors[k][2] = v;
+		break;
+	}
+	case TGP_COLOR_REPRESENTATION_YUV:
+	{
 		/* Convert to YCbCr */
 		int y, cb, cr;
 
@@ -863,7 +940,10 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		tpg->colors[k][0] = y;
 		tpg->colors[k][1] = cb;
 		tpg->colors[k][2] = cr;
-	} else {
+		break;
+	}
+	case TGP_COLOR_REPRESENTATION_RGB:
+	{
 		if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE) {
 			r = (r * 219) / 255 + (16 << 4);
 			g = (g * 219) / 255 + (16 << 4);
@@ -913,6 +993,8 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		tpg->colors[k][0] = r;
 		tpg->colors[k][1] = g;
 		tpg->colors[k][2] = b;
+		break;
+	}
 	}
 }
 
@@ -938,8 +1020,8 @@ static void gen_twopix(struct tpg_data *tpg,
 		alpha = 0;
 	if (color == TPG_COLOR_RANDOM)
 		precalculate_color(tpg, color);
-	r_y = tpg->colors[color][0]; /* R or precalculated Y */
-	g_u = tpg->colors[color][1]; /* G or precalculated U */
+	r_y = tpg->colors[color][0]; /* R or precalculated Y, H */
+	g_u = tpg->colors[color][1]; /* G or precalculated U, V */
 	b_v = tpg->colors[color][2]; /* B or precalculated V */
 
 	switch (tpg->fourcc) {
@@ -1121,6 +1203,7 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][offset + 1] = (g_u << 5) | b_v;
 		break;
 	case V4L2_PIX_FMT_RGB24:
+	case V4L2_PIX_FMT_HSV24:
 		buf[0][offset] = r_y;
 		buf[0][offset + 1] = g_u;
 		buf[0][offset + 2] = b_v;
@@ -1138,6 +1221,7 @@ static void gen_twopix(struct tpg_data *tpg,
 		break;
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_XRGB32:
+	case V4L2_PIX_FMT_HSV32:
 		alpha = 0;
 		/* fall through */
 	case V4L2_PIX_FMT_YUV32:
@@ -1896,6 +1980,8 @@ static const char *tpg_color_representation_str(enum tgp_color_representation
 {
 	switch (color_representation) {
 
+	case TGP_COLOR_REPRESENTATION_HSV:
+		return "HSV";
 	case TGP_COLOR_REPRESENTATION_YUV:
 		return "YCbCr";
 	case TGP_COLOR_REPRESENTATION_RGB:
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 314799111cf7..cc985685ed05 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -445,6 +445,20 @@ struct vivid_fmt vivid_formats[] = {
 		.planes   = 1,
 		.buffers = 1,
 	},
+	{
+		.fourcc   = V4L2_PIX_FMT_HSV24, /* HSV 24bits */
+		.vdownsampling = { 1 },
+		.bit_depth = { 24 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_HSV32, /* HSV 32bits */
+		.vdownsampling = { 1 },
+		.bit_depth = { 32 },
+		.planes   = 1,
+		.buffers = 1,
+	},
 
 	/* Multiplanar formats */
 
diff --git a/include/media/v4l2-tpg.h b/include/media/v4l2-tpg.h
index 13ea42bb9530..17a257d12941 100644
--- a/include/media/v4l2-tpg.h
+++ b/include/media/v4l2-tpg.h
@@ -90,6 +90,7 @@ enum tpg_move_mode {
 enum tgp_color_representation {
 	TGP_COLOR_REPRESENTATION_RGB,
 	TGP_COLOR_REPRESENTATION_YUV,
+	TGP_COLOR_REPRESENTATION_HSV,
 };
 
 extern const char * const tpg_aspect_strings[];
-- 
2.8.1

