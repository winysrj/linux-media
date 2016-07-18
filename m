Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33968 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbcGRMml (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 08:42:41 -0400
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
Subject: [PATCH v4 12/12] [media] vivid: Add support for HSV encoding
Date: Mon, 18 Jul 2016 14:42:16 +0200
Message-Id: <1468845736-19651-13-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support HSV encoding. Most of the logic is replicated from ycbcr_enc.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c   | 25 +++++++++++++++++--------
 drivers/media/platform/vivid/vivid-core.h       |  1 +
 drivers/media/platform/vivid/vivid-ctrls.c      | 25 +++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-vid-cap.c    | 17 +++++++++++++++--
 drivers/media/platform/vivid/vivid-vid-common.c |  2 ++
 drivers/media/platform/vivid/vivid-vid-out.c    |  1 +
 include/media/v4l2-tpg.h                        | 15 +++++++++++++++
 7 files changed, 76 insertions(+), 10 deletions(-)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index 7f284c591f25..2341d8ee2601 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -504,6 +504,7 @@ static void color_to_hsv(struct tpg_data *tpg, int r, int g, int b,
 	int max_rgb, min_rgb, diff_rgb;
 	int aux;
 	int third;
+	int third_size;
 
 	r >>= 4;
 	g >>= 4;
@@ -530,30 +531,36 @@ static void color_to_hsv(struct tpg_data *tpg, int r, int g, int b,
 		return;
 	}
 
+	third_size = (tpg->real_hsv_enc == V4L2_HSV_ENC_180) ? 60 : 85;
+
 	/* Hue */
 	if (max_rgb == r) {
 		aux =  g - b;
 		third = 0;
 	} else if (max_rgb == g) {
 		aux =  b - r;
-		third = 60;
+		third = third_size;
 	} else {
 		aux =  r - g;
-		third = 120;
+		third = third_size * 2;
 	}
 
-	aux *= 30;
+	aux *= third_size / 2;
 	aux += diff_rgb / 2;
 	aux /= diff_rgb;
 	aux += third;
 
 	/* Clamp Hue */
-	if (aux < 0)
-		aux += 180;
-	else if (aux > 180)
-		aux -= 180;
-	*h = aux;
+	if (tpg->real_hsv_enc == V4L2_HSV_ENC_180) {
+		if (aux < 0)
+			aux += 180;
+		else if (aux > 180)
+			aux -= 180;
+	} else {
+		aux = aux & 0xff;
+	}
 
+	*h = aux;
 }
 
 static void rgb2ycbcr(const int m[3][3], int r, int g, int b,
@@ -1927,6 +1934,7 @@ static void tpg_recalc(struct tpg_data *tpg)
 		tpg->recalc_lines = true;
 		tpg->real_xfer_func = tpg->xfer_func;
 		tpg->real_ycbcr_enc = tpg->ycbcr_enc;
+		tpg->real_hsv_enc = tpg->hsv_enc;
 		tpg->real_quantization = tpg->quantization;
 
 		if (tpg->xfer_func == V4L2_XFER_FUNC_DEFAULT)
@@ -2017,6 +2025,7 @@ void tpg_log_status(struct tpg_data *tpg)
 	pr_info("tpg colorspace: %d\n", tpg->colorspace);
 	pr_info("tpg transfer function: %d/%d\n", tpg->xfer_func, tpg->real_xfer_func);
 	pr_info("tpg Y'CbCr encoding: %d/%d\n", tpg->ycbcr_enc, tpg->real_ycbcr_enc);
+	pr_info("tpg HSV encoding: %d/%d\n", tpg->hsv_enc, tpg->real_hsv_enc);
 	pr_info("tpg quantization: %d/%d\n", tpg->quantization, tpg->real_quantization);
 	pr_info("tpg RGB range: %d/%d\n", tpg->rgb_range, tpg->real_rgb_range);
 }
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index b59b49456d45..5cdf95bdc4d1 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -346,6 +346,7 @@ struct vivid_dev {
 	struct v4l2_dv_timings		dv_timings_out;
 	u32				colorspace_out;
 	u32				ycbcr_enc_out;
+	u32				hsv_enc_out;
 	u32				quantization_out;
 	u32				xfer_func_out;
 	u32				service_set_out;
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index b98089c95ef5..2e1c0b6d6842 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -79,6 +79,7 @@
 #define VIVID_CID_MAX_EDID_BLOCKS	(VIVID_CID_VIVID_BASE + 40)
 #define VIVID_CID_PERCENTAGE_FILL	(VIVID_CID_VIVID_BASE + 41)
 #define VIVID_CID_REDUCED_FPS		(VIVID_CID_VIVID_BASE + 42)
+#define VIVID_CID_HSV_ENC		(VIVID_CID_VIVID_BASE + 43)
 
 #define VIVID_CID_STD_SIGNAL_MODE	(VIVID_CID_VIVID_BASE + 60)
 #define VIVID_CID_STANDARD		(VIVID_CID_VIVID_BASE + 61)
@@ -378,6 +379,14 @@ static int vivid_vid_cap_s_ctrl(struct v4l2_ctrl *ctrl)
 		vivid_send_source_change(dev, HDMI);
 		vivid_send_source_change(dev, WEBCAM);
 		break;
+	case VIVID_CID_HSV_ENC:
+		tpg_s_hsv_enc(&dev->tpg, ctrl->val ? V4L2_HSV_ENC_256 :
+						     V4L2_HSV_ENC_180);
+		vivid_send_source_change(dev, TV);
+		vivid_send_source_change(dev, SVID);
+		vivid_send_source_change(dev, HDMI);
+		vivid_send_source_change(dev, WEBCAM);
+		break;
 	case VIVID_CID_QUANTIZATION:
 		tpg_s_quantization(&dev->tpg, ctrl->val);
 		vivid_send_source_change(dev, TV);
@@ -777,6 +786,21 @@ static const struct v4l2_ctrl_config vivid_ctrl_ycbcr_enc = {
 	.qmenu = vivid_ctrl_ycbcr_enc_strings,
 };
 
+static const char * const vivid_ctrl_hsv_enc_strings[] = {
+	"Hue 0-179",
+	"Hue 0-256",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivid_ctrl_hsv_enc = {
+	.ops = &vivid_vid_cap_ctrl_ops,
+	.id = VIVID_CID_HSV_ENC,
+	.name = "HSV Encoding",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = ARRAY_SIZE(vivid_ctrl_hsv_enc_strings) - 2,
+	.qmenu = vivid_ctrl_hsv_enc_strings,
+};
+
 static const char * const vivid_ctrl_quantization_strings[] = {
 	"Default",
 	"Full Range",
@@ -1453,6 +1477,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 			&vivid_ctrl_colorspace, NULL);
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_xfer_func, NULL);
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_ycbcr_enc, NULL);
+		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_hsv_enc, NULL);
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_quantization, NULL);
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_alpha_mode, NULL);
 	}
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index d404a7ce33a4..fbe1cc8b8a95 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -510,6 +510,13 @@ static unsigned vivid_ycbcr_enc_cap(struct vivid_dev *dev)
 	return dev->ycbcr_enc_out;
 }
 
+static unsigned int vivid_hsv_enc_cap(struct vivid_dev *dev)
+{
+	if (!dev->loop_video || vivid_is_webcam(dev) || vivid_is_tv_cap(dev))
+		return tpg_g_hsv_enc(&dev->tpg);
+	return dev->hsv_enc_out;
+}
+
 static unsigned vivid_quantization_cap(struct vivid_dev *dev)
 {
 	if (!dev->loop_video || vivid_is_webcam(dev) || vivid_is_tv_cap(dev))
@@ -530,7 +537,10 @@ int vivid_g_fmt_vid_cap(struct file *file, void *priv,
 	mp->pixelformat  = dev->fmt_cap->fourcc;
 	mp->colorspace   = vivid_colorspace_cap(dev);
 	mp->xfer_func    = vivid_xfer_func_cap(dev);
-	mp->ycbcr_enc    = vivid_ycbcr_enc_cap(dev);
+	if (dev->fmt_cap->color_enc == TGP_COLOR_ENC_HSV)
+		mp->hsv_enc    = vivid_hsv_enc_cap(dev);
+	else
+		mp->ycbcr_enc    = vivid_ycbcr_enc_cap(dev);
 	mp->quantization = vivid_quantization_cap(dev);
 	mp->num_planes = dev->fmt_cap->buffers;
 	for (p = 0; p < mp->num_planes; p++) {
@@ -618,7 +628,10 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
 		memset(pfmt[p].reserved, 0, sizeof(pfmt[p].reserved));
 	}
 	mp->colorspace = vivid_colorspace_cap(dev);
-	mp->ycbcr_enc = vivid_ycbcr_enc_cap(dev);
+	if (fmt->color_enc == TGP_COLOR_ENC_HSV)
+		mp->hsv_enc = vivid_hsv_enc_cap(dev);
+	else
+		mp->ycbcr_enc = vivid_ycbcr_enc_cap(dev);
 	mp->xfer_func = vivid_xfer_func_cap(dev);
 	mp->quantization = vivid_quantization_cap(dev);
 	memset(mp->reserved, 0, sizeof(mp->reserved));
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index e0df44151461..3d003fb913ed 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -630,6 +630,7 @@ void fmt_sp2mp(const struct v4l2_format *sp_fmt, struct v4l2_format *mp_fmt)
 	mp->field = pix->field;
 	mp->colorspace = pix->colorspace;
 	mp->xfer_func = pix->xfer_func;
+	/* Also copies hsv_enc */
 	mp->ycbcr_enc = pix->ycbcr_enc;
 	mp->quantization = pix->quantization;
 	mp->num_planes = 1;
@@ -659,6 +660,7 @@ int fmt_sp2mp_func(struct file *file, void *priv,
 	pix->field = mp->field;
 	pix->colorspace = mp->colorspace;
 	pix->xfer_func = mp->xfer_func;
+	/* Also copies hsv_enc */
 	pix->ycbcr_enc = mp->ycbcr_enc;
 	pix->quantization = mp->quantization;
 	pix->sizeimage = ppix->sizeimage;
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index dd609eea4753..7ba52ee98371 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -256,6 +256,7 @@ void vivid_update_format_out(struct vivid_dev *dev)
 	}
 	dev->xfer_func_out = V4L2_XFER_FUNC_DEFAULT;
 	dev->ycbcr_enc_out = V4L2_YCBCR_ENC_DEFAULT;
+	dev->hsv_enc_out = V4L2_HSV_ENC_180;
 	dev->quantization_out = V4L2_QUANTIZATION_DEFAULT;
 	dev->compose_out = dev->sink_rect;
 	dev->compose_bounds_out = dev->sink_rect;
diff --git a/include/media/v4l2-tpg.h b/include/media/v4l2-tpg.h
index 8abed92317e8..13e49d85cae3 100644
--- a/include/media/v4l2-tpg.h
+++ b/include/media/v4l2-tpg.h
@@ -130,6 +130,7 @@ struct tpg_data {
 	u32				colorspace;
 	u32				xfer_func;
 	u32				ycbcr_enc;
+	u32				hsv_enc;
 	/*
 	 * Stores the actual transfer function, i.e. will never be
 	 * V4L2_XFER_FUNC_DEFAULT.
@@ -139,6 +140,7 @@ struct tpg_data {
 	 * Stores the actual Y'CbCr encoding, i.e. will never be
 	 * V4L2_YCBCR_ENC_DEFAULT.
 	 */
+	u32				real_hsv_enc;
 	u32				real_ycbcr_enc;
 	u32				quantization;
 	/*
@@ -341,6 +343,19 @@ static inline u32 tpg_g_ycbcr_enc(const struct tpg_data *tpg)
 	return tpg->ycbcr_enc;
 }
 
+static inline void tpg_s_hsv_enc(struct tpg_data *tpg, u32 hsv_enc)
+{
+	if (tpg->hsv_enc == hsv_enc)
+		return;
+	tpg->hsv_enc = hsv_enc;
+	tpg->recalc_colors = true;
+}
+
+static inline u32 tpg_g_hsv_enc(const struct tpg_data *tpg)
+{
+	return tpg->hsv_enc;
+}
+
 static inline void tpg_s_xfer_func(struct tpg_data *tpg, u32 xfer_func)
 {
 	if (tpg->xfer_func == xfer_func)
-- 
2.8.1

