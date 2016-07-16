Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36476 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbcGPKmK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 06:42:10 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v3 4/9] [media] vivid: code refactor for color encoding
Date: Sat, 16 Jul 2016 12:41:51 +0200
Message-Id: <1468665716-10178-5-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1468665716-10178-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1468665716-10178-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace is_yuv with color_enc Which can be used by other
color encodings such us HSV.

This change should ease the review of the following patches.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c   | 49 +++++++++++++++--------
 drivers/media/platform/vivid/vivid-core.h       |  2 +-
 drivers/media/platform/vivid/vivid-vid-common.c | 52 ++++++++++++-------------
 include/media/v4l2-tpg.h                        |  7 +++-
 4 files changed, 66 insertions(+), 44 deletions(-)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index 3ec3cebe62b9..e8d2bf388597 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -237,13 +237,13 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_GREY:
 	case V4L2_PIX_FMT_Y16:
 	case V4L2_PIX_FMT_Y16_BE:
-		tpg->is_yuv = false;
+		tpg->color_enc = TGP_COLOR_ENC_RGB;
 		break;
 	case V4L2_PIX_FMT_YUV444:
 	case V4L2_PIX_FMT_YUV555:
 	case V4L2_PIX_FMT_YUV565:
 	case V4L2_PIX_FMT_YUV32:
-		tpg->is_yuv = true;
+		tpg->color_enc = TGP_COLOR_ENC_YUV;
 		break;
 	case V4L2_PIX_FMT_YUV420M:
 	case V4L2_PIX_FMT_YVU420M:
@@ -256,7 +256,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->hdownsampling[1] = 2;
 		tpg->hdownsampling[2] = 2;
 		tpg->planes = 3;
-		tpg->is_yuv = true;
+		tpg->color_enc = TGP_COLOR_ENC_YUV;
 		break;
 	case V4L2_PIX_FMT_YUV422M:
 	case V4L2_PIX_FMT_YVU422M:
@@ -268,7 +268,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->hdownsampling[1] = 2;
 		tpg->hdownsampling[2] = 2;
 		tpg->planes = 3;
-		tpg->is_yuv = true;
+		tpg->color_enc = TGP_COLOR_ENC_YUV;
 		break;
 	case V4L2_PIX_FMT_NV16M:
 	case V4L2_PIX_FMT_NV61M:
@@ -280,7 +280,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->hdownsampling[1] = 1;
 		tpg->hmask[1] = ~1;
 		tpg->planes = 2;
-		tpg->is_yuv = true;
+		tpg->color_enc = TGP_COLOR_ENC_YUV;
 		break;
 	case V4L2_PIX_FMT_NV12M:
 	case V4L2_PIX_FMT_NV21M:
@@ -292,7 +292,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->hdownsampling[1] = 1;
 		tpg->hmask[1] = ~1;
 		tpg->planes = 2;
-		tpg->is_yuv = true;
+		tpg->color_enc = TGP_COLOR_ENC_YUV;
 		break;
 	case V4L2_PIX_FMT_YUV444M:
 	case V4L2_PIX_FMT_YVU444M:
@@ -302,21 +302,21 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->vdownsampling[2] = 1;
 		tpg->hdownsampling[1] = 1;
 		tpg->hdownsampling[2] = 1;
-		tpg->is_yuv = true;
+		tpg->color_enc = TGP_COLOR_ENC_YUV;
 		break;
 	case V4L2_PIX_FMT_NV24:
 	case V4L2_PIX_FMT_NV42:
 		tpg->vdownsampling[1] = 1;
 		tpg->hdownsampling[1] = 1;
 		tpg->planes = 2;
-		tpg->is_yuv = true;
+		tpg->color_enc = TGP_COLOR_ENC_YUV;
 		break;
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YVYU:
 	case V4L2_PIX_FMT_VYUY:
 		tpg->hmask[0] = ~1;
-		tpg->is_yuv = true;
+		tpg->color_enc = TGP_COLOR_ENC_YUV;
 		break;
 	default:
 		return false;
@@ -777,7 +777,8 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 	 * Remember that r, g and b are still in the 0 - 0xff0 range.
 	 */
 	if (tpg->real_rgb_range == V4L2_DV_RGB_RANGE_LIMITED &&
-	    tpg->rgb_range == V4L2_DV_RGB_RANGE_FULL && !tpg->is_yuv) {
+	    tpg->rgb_range == V4L2_DV_RGB_RANGE_FULL &&
+	    tpg->color_enc == TGP_COLOR_ENC_RGB) {
 		/*
 		 * Convert from full range (which is what r, g and b are)
 		 * to limited range (which is the 'real' RGB range), which
@@ -787,7 +788,9 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		g = (g * 219) / 255 + (16 << 4);
 		b = (b * 219) / 255 + (16 << 4);
 	} else if (tpg->real_rgb_range != V4L2_DV_RGB_RANGE_LIMITED &&
-		   tpg->rgb_range == V4L2_DV_RGB_RANGE_LIMITED && !tpg->is_yuv) {
+		   tpg->rgb_range == V4L2_DV_RGB_RANGE_LIMITED &&
+		   tpg->color_enc == TGP_COLOR_ENC_RGB) {
+
 		/*
 		 * Clamp r, g and b to the limited range and convert to full
 		 * range since that's what we deliver.
@@ -820,7 +823,7 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 
 		cb = (128 << 4) + (tmp_cb * tpg->contrast * tpg->saturation) / (128 * 128);
 		cr = (128 << 4) + (tmp_cr * tpg->contrast * tpg->saturation) / (128 * 128);
-		if (tpg->is_yuv) {
+		if (tpg->color_enc == TGP_COLOR_ENC_YUV) {
 			tpg->colors[k][0] = clamp(y >> 4, 1, 254);
 			tpg->colors[k][1] = clamp(cb >> 4, 1, 254);
 			tpg->colors[k][2] = clamp(cr >> 4, 1, 254);
@@ -829,7 +832,7 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		ycbcr_to_color(tpg, y, cb, cr, &r, &g, &b);
 	}
 
-	if (tpg->is_yuv) {
+	if (tpg->color_enc == TGP_COLOR_ENC_YUV) {
 		/* Convert to YCbCr */
 		int y, cb, cr;
 
@@ -1842,7 +1845,8 @@ static void tpg_recalc(struct tpg_data *tpg)
 
 		if (tpg->quantization == V4L2_QUANTIZATION_DEFAULT)
 			tpg->real_quantization =
-				V4L2_MAP_QUANTIZATION_DEFAULT(!tpg->is_yuv,
+				V4L2_MAP_QUANTIZATION_DEFAULT(
+					tpg->color_enc != TGP_COLOR_ENC_YUV,
 					tpg->colorspace, tpg->real_ycbcr_enc);
 
 		tpg_precalculate_colors(tpg);
@@ -1889,11 +1893,24 @@ static int tpg_pattern_avg(const struct tpg_data *tpg,
 	return -1;
 }
 
+static const char *tpg_color_enc_str(enum tgp_color_enc
+						 color_enc)
+{
+	switch (color_enc) {
+	case TGP_COLOR_ENC_YUV:
+		return "YCbCr";
+	case TGP_COLOR_ENC_RGB:
+	default:
+		return "RGB";
+
+	}
+}
+
 void tpg_log_status(struct tpg_data *tpg)
 {
 	pr_info("tpg source WxH: %ux%u (%s)\n",
-			tpg->src_width, tpg->src_height,
-			tpg->is_yuv ? "YCbCr" : "RGB");
+		tpg->src_width, tpg->src_height,
+		tpg_color_enc_str(tpg->color_enc));
 	pr_info("tpg field: %u\n", tpg->field);
 	pr_info("tpg crop: %ux%u@%dx%d\n", tpg->crop.width, tpg->crop.height,
 			tpg->crop.left, tpg->crop.top);
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index a7daa40d0a49..b59b49456d45 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -80,7 +80,7 @@ extern unsigned vivid_debug;
 
 struct vivid_fmt {
 	u32	fourcc;          /* v4l2 format id */
-	bool	is_yuv;
+	enum	tgp_color_enc color_enc;
 	bool	can_do_overlay;
 	u8	vdownsampling[TPG_MAX_PLANES];
 	u32	alpha_mask;
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index fcda3ae4e6b0..bd56a4a69683 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -48,7 +48,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_YUYV,
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 1,
 		.buffers = 1,
 		.data_offset = { PLANE0_DATA_OFFSET },
@@ -57,7 +57,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_UYVY,
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 1,
 		.buffers = 1,
 	},
@@ -65,7 +65,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_YVYU,
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 1,
 		.buffers = 1,
 	},
@@ -73,7 +73,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_VYUY,
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 1,
 		.buffers = 1,
 	},
@@ -81,7 +81,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_YUV422P,
 		.vdownsampling = { 1, 1, 1 },
 		.bit_depth = { 8, 4, 4 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 3,
 		.buffers = 1,
 	},
@@ -89,7 +89,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_YUV420,
 		.vdownsampling = { 1, 2, 2 },
 		.bit_depth = { 8, 4, 4 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 3,
 		.buffers = 1,
 	},
@@ -97,7 +97,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_YVU420,
 		.vdownsampling = { 1, 2, 2 },
 		.bit_depth = { 8, 4, 4 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 3,
 		.buffers = 1,
 	},
@@ -105,7 +105,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_NV12,
 		.vdownsampling = { 1, 2 },
 		.bit_depth = { 8, 8 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 2,
 		.buffers = 1,
 	},
@@ -113,7 +113,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_NV21,
 		.vdownsampling = { 1, 2 },
 		.bit_depth = { 8, 8 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 2,
 		.buffers = 1,
 	},
@@ -121,7 +121,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_NV16,
 		.vdownsampling = { 1, 1 },
 		.bit_depth = { 8, 8 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 2,
 		.buffers = 1,
 	},
@@ -129,7 +129,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_NV61,
 		.vdownsampling = { 1, 1 },
 		.bit_depth = { 8, 8 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 2,
 		.buffers = 1,
 	},
@@ -137,7 +137,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_NV24,
 		.vdownsampling = { 1, 1 },
 		.bit_depth = { 8, 16 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 2,
 		.buffers = 1,
 	},
@@ -145,7 +145,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_NV42,
 		.vdownsampling = { 1, 1 },
 		.bit_depth = { 8, 16 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 2,
 		.buffers = 1,
 	},
@@ -184,7 +184,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_GREY,
 		.vdownsampling = { 1 },
 		.bit_depth = { 8 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 1,
 		.buffers = 1,
 	},
@@ -192,7 +192,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_Y16,
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 1,
 		.buffers = 1,
 	},
@@ -200,7 +200,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_Y16_BE,
 		.vdownsampling = { 1 },
 		.bit_depth = { 16 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 1,
 		.buffers = 1,
 	},
@@ -452,7 +452,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_NV16M,
 		.vdownsampling = { 1, 1 },
 		.bit_depth = { 8, 8 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 2,
 		.buffers = 2,
 		.data_offset = { PLANE0_DATA_OFFSET, 0 },
@@ -461,7 +461,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_NV61M,
 		.vdownsampling = { 1, 1 },
 		.bit_depth = { 8, 8 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 2,
 		.buffers = 2,
 		.data_offset = { 0, PLANE0_DATA_OFFSET },
@@ -470,7 +470,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_YUV420M,
 		.vdownsampling = { 1, 2, 2 },
 		.bit_depth = { 8, 4, 4 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 3,
 		.buffers = 3,
 	},
@@ -478,7 +478,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_YVU420M,
 		.vdownsampling = { 1, 2, 2 },
 		.bit_depth = { 8, 4, 4 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 3,
 		.buffers = 3,
 	},
@@ -486,7 +486,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_NV12M,
 		.vdownsampling = { 1, 2 },
 		.bit_depth = { 8, 8 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 2,
 		.buffers = 2,
 	},
@@ -494,7 +494,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_NV21M,
 		.vdownsampling = { 1, 2 },
 		.bit_depth = { 8, 8 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 2,
 		.buffers = 2,
 	},
@@ -502,7 +502,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_YUV422M,
 		.vdownsampling = { 1, 1, 1 },
 		.bit_depth = { 8, 4, 4 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 3,
 		.buffers = 3,
 	},
@@ -510,7 +510,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_YVU422M,
 		.vdownsampling = { 1, 1, 1 },
 		.bit_depth = { 8, 4, 4 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 3,
 		.buffers = 3,
 	},
@@ -518,7 +518,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_YUV444M,
 		.vdownsampling = { 1, 1, 1 },
 		.bit_depth = { 8, 8, 8 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 3,
 		.buffers = 3,
 	},
@@ -526,7 +526,7 @@ struct vivid_fmt vivid_formats[] = {
 		.fourcc   = V4L2_PIX_FMT_YVU444M,
 		.vdownsampling = { 1, 1, 1 },
 		.bit_depth = { 8, 8, 8 },
-		.is_yuv   = true,
+		.color_enc = TGP_COLOR_ENC_YUV,
 		.planes   = 3,
 		.buffers = 3,
 	},
diff --git a/include/media/v4l2-tpg.h b/include/media/v4l2-tpg.h
index 329bebfa930c..e4da507d40e2 100644
--- a/include/media/v4l2-tpg.h
+++ b/include/media/v4l2-tpg.h
@@ -87,6 +87,11 @@ enum tpg_move_mode {
 	TPG_MOVE_POS_FAST,
 };
 
+enum tgp_color_enc {
+	TGP_COLOR_ENC_RGB,
+	TGP_COLOR_ENC_YUV,
+};
+
 extern const char * const tpg_aspect_strings[];
 
 #define TPG_MAX_PLANES 3
@@ -119,7 +124,7 @@ struct tpg_data {
 	u8				saturation;
 	s16				hue;
 	u32				fourcc;
-	bool				is_yuv;
+	enum tgp_color_enc		color_enc;
 	u32				colorspace;
 	u32				xfer_func;
 	u32				ycbcr_enc;
-- 
2.8.1

