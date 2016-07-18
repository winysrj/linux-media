Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33934 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbcGRMm3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 08:42:29 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v4 05/12] [media] vivid: Add support for HSV formats
Date: Mon, 18 Jul 2016 14:42:09 +0200
Message-Id: <1468845736-19651-6-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for V4L2_PIX_FMT_HSV24 and V4L2_PIX_FMT_HSV32.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c   | 93 +++++++++++++++++++++++--
 drivers/media/platform/vivid/vivid-vid-common.c | 14 ++++
 include/media/v4l2-tpg.h                        |  1 +
 3 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index 4d0c9ab408da..ec8f887a84e5 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -318,6 +318,10 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->hmask[0] = ~1;
 		tpg->color_enc = TGP_COLOR_ENC_YCBCR;
 		break;
+	case V4L2_PIX_FMT_HSV24:
+	case V4L2_PIX_FMT_HSV32:
+		tpg->color_enc = TGP_COLOR_ENC_HSV;
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
@@ -490,6 +496,64 @@ static inline int linear_to_rec709(int v)
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
+	/* Value */
+	max_rgb = max3(r, g, b);
+	*v = max_rgb;
+	if (!max_rgb) {
+		*h = 0;
+		*s = 0;
+		return;
+	}
+
+	/* Saturation */
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
+	/* Hue */
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
+	/* Clamp Hue */
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
@@ -832,7 +896,19 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		ycbcr_to_color(tpg, y, cb, cr, &r, &g, &b);
 	}
 
-	if (tpg->color_enc == TGP_COLOR_ENC_YCBCR) {
+	switch (tpg->color_enc) {
+	case TGP_COLOR_ENC_HSV:
+	{
+		int h, s, v;
+
+		color_to_hsv(tpg, r, g, b, &h, &s, &v);
+		tpg->colors[k][0] = h;
+		tpg->colors[k][1] = s;
+		tpg->colors[k][2] = v;
+		break;
+	}
+	case TGP_COLOR_ENC_YCBCR:
+	{
 		/* Convert to YCbCr */
 		int y, cb, cr;
 
@@ -866,7 +942,10 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		tpg->colors[k][0] = y;
 		tpg->colors[k][1] = cb;
 		tpg->colors[k][2] = cr;
-	} else {
+		break;
+	}
+	case TGP_COLOR_ENC_RGB:
+	{
 		if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE) {
 			r = (r * 219) / 255 + (16 << 4);
 			g = (g * 219) / 255 + (16 << 4);
@@ -916,6 +995,8 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		tpg->colors[k][0] = r;
 		tpg->colors[k][1] = g;
 		tpg->colors[k][2] = b;
+		break;
+	}
 	}
 }
 
@@ -941,8 +1022,8 @@ static void gen_twopix(struct tpg_data *tpg,
 		alpha = 0;
 	if (color == TPG_COLOR_RANDOM)
 		precalculate_color(tpg, color);
-	r_y = tpg->colors[color][0]; /* R or precalculated Y */
-	g_u = tpg->colors[color][1]; /* G or precalculated U */
+	r_y = tpg->colors[color][0]; /* R or precalculated Y, H */
+	g_u = tpg->colors[color][1]; /* G or precalculated U, V */
 	b_v = tpg->colors[color][2]; /* B or precalculated V */
 
 	switch (tpg->fourcc) {
@@ -1124,6 +1205,7 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][offset + 1] = (g_u << 5) | b_v;
 		break;
 	case V4L2_PIX_FMT_RGB24:
+	case V4L2_PIX_FMT_HSV24:
 		buf[0][offset] = r_y;
 		buf[0][offset + 1] = g_u;
 		buf[0][offset + 2] = b_v;
@@ -1141,6 +1223,7 @@ static void gen_twopix(struct tpg_data *tpg,
 		break;
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_XRGB32:
+	case V4L2_PIX_FMT_HSV32:
 		alpha = 0;
 		/* fall through */
 	case V4L2_PIX_FMT_YUV32:
@@ -1897,6 +1980,8 @@ static const char *tpg_color_enc_str(enum tgp_color_enc
 						 color_enc)
 {
 	switch (color_enc) {
+	case TGP_COLOR_ENC_HSV:
+		return "HSV";
 	case TGP_COLOR_ENC_YCBCR:
 		return "Y'CbCr";
 	case TGP_COLOR_ENC_RGB:
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index f4c35ba5f070..20822b5111b3 100644
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
index b4cb8f34cd87..4a40f9b79053 100644
--- a/include/media/v4l2-tpg.h
+++ b/include/media/v4l2-tpg.h
@@ -90,6 +90,7 @@ enum tpg_move_mode {
 enum tgp_color_enc {
 	TGP_COLOR_ENC_RGB,
 	TGP_COLOR_ENC_YCBCR,
+	TGP_COLOR_ENC_HSV,
 };
 
 extern const char * const tpg_aspect_strings[];
-- 
2.8.1

