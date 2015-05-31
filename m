Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:59999 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758140AbbEaNL6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 09:11:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/9] vivid: add xfer_func support.
Date: Sun, 31 May 2015 15:11:35 +0200
Message-Id: <1433077899-18516-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
References: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the transfer function: create a new control for it,
and support it for both capture and output sides.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.h       |  1 +
 drivers/media/platform/vivid/vivid-ctrls.c      | 58 ++++++++++++++++++-------
 drivers/media/platform/vivid/vivid-tpg.c        |  7 +++
 drivers/media/platform/vivid/vivid-tpg.h        | 19 ++++++++
 drivers/media/platform/vivid/vivid-vid-cap.c    |  9 ++++
 drivers/media/platform/vivid/vivid-vid-common.c |  2 +
 drivers/media/platform/vivid/vivid-vid-out.c    |  4 ++
 7 files changed, 85 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index aa1b523..3755b18 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -332,6 +332,7 @@ struct vivid_dev {
 	u32				colorspace_out;
 	u32				ycbcr_enc_out;
 	u32				quantization_out;
+	u32				xfer_func_out;
 	u32				service_set_out;
 	unsigned			bytesperline_out[TPG_MAX_PLANES];
 	unsigned			tv_field_out;
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 2b90700..1898751 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -62,21 +62,22 @@
 #define VIVID_CID_DV_TIMINGS_ASPECT_RATIO	(VIVID_CID_VIVID_BASE + 23)
 #define VIVID_CID_TSTAMP_SRC		(VIVID_CID_VIVID_BASE + 24)
 #define VIVID_CID_COLORSPACE		(VIVID_CID_VIVID_BASE + 25)
-#define VIVID_CID_YCBCR_ENC		(VIVID_CID_VIVID_BASE + 26)
-#define VIVID_CID_QUANTIZATION		(VIVID_CID_VIVID_BASE + 27)
-#define VIVID_CID_LIMITED_RGB_RANGE	(VIVID_CID_VIVID_BASE + 28)
-#define VIVID_CID_ALPHA_MODE		(VIVID_CID_VIVID_BASE + 29)
-#define VIVID_CID_HAS_CROP_CAP		(VIVID_CID_VIVID_BASE + 30)
-#define VIVID_CID_HAS_COMPOSE_CAP	(VIVID_CID_VIVID_BASE + 31)
-#define VIVID_CID_HAS_SCALER_CAP	(VIVID_CID_VIVID_BASE + 32)
-#define VIVID_CID_HAS_CROP_OUT		(VIVID_CID_VIVID_BASE + 33)
-#define VIVID_CID_HAS_COMPOSE_OUT	(VIVID_CID_VIVID_BASE + 34)
-#define VIVID_CID_HAS_SCALER_OUT	(VIVID_CID_VIVID_BASE + 35)
-#define VIVID_CID_LOOP_VIDEO		(VIVID_CID_VIVID_BASE + 36)
-#define VIVID_CID_SEQ_WRAP		(VIVID_CID_VIVID_BASE + 37)
-#define VIVID_CID_TIME_WRAP		(VIVID_CID_VIVID_BASE + 38)
-#define VIVID_CID_MAX_EDID_BLOCKS	(VIVID_CID_VIVID_BASE + 39)
-#define VIVID_CID_PERCENTAGE_FILL	(VIVID_CID_VIVID_BASE + 40)
+#define VIVID_CID_XFER_FUNC		(VIVID_CID_VIVID_BASE + 26)
+#define VIVID_CID_YCBCR_ENC		(VIVID_CID_VIVID_BASE + 27)
+#define VIVID_CID_QUANTIZATION		(VIVID_CID_VIVID_BASE + 28)
+#define VIVID_CID_LIMITED_RGB_RANGE	(VIVID_CID_VIVID_BASE + 29)
+#define VIVID_CID_ALPHA_MODE		(VIVID_CID_VIVID_BASE + 30)
+#define VIVID_CID_HAS_CROP_CAP		(VIVID_CID_VIVID_BASE + 31)
+#define VIVID_CID_HAS_COMPOSE_CAP	(VIVID_CID_VIVID_BASE + 32)
+#define VIVID_CID_HAS_SCALER_CAP	(VIVID_CID_VIVID_BASE + 33)
+#define VIVID_CID_HAS_CROP_OUT		(VIVID_CID_VIVID_BASE + 34)
+#define VIVID_CID_HAS_COMPOSE_OUT	(VIVID_CID_VIVID_BASE + 35)
+#define VIVID_CID_HAS_SCALER_OUT	(VIVID_CID_VIVID_BASE + 36)
+#define VIVID_CID_LOOP_VIDEO		(VIVID_CID_VIVID_BASE + 37)
+#define VIVID_CID_SEQ_WRAP		(VIVID_CID_VIVID_BASE + 38)
+#define VIVID_CID_TIME_WRAP		(VIVID_CID_VIVID_BASE + 39)
+#define VIVID_CID_MAX_EDID_BLOCKS	(VIVID_CID_VIVID_BASE + 40)
+#define VIVID_CID_PERCENTAGE_FILL	(VIVID_CID_VIVID_BASE + 41)
 
 #define VIVID_CID_STD_SIGNAL_MODE	(VIVID_CID_VIVID_BASE + 60)
 #define VIVID_CID_STANDARD		(VIVID_CID_VIVID_BASE + 61)
@@ -360,6 +361,13 @@ static int vivid_vid_cap_s_ctrl(struct v4l2_ctrl *ctrl)
 		vivid_send_source_change(dev, HDMI);
 		vivid_send_source_change(dev, WEBCAM);
 		break;
+	case VIVID_CID_XFER_FUNC:
+		tpg_s_xfer_func(&dev->tpg, ctrl->val);
+		vivid_send_source_change(dev, TV);
+		vivid_send_source_change(dev, SVID);
+		vivid_send_source_change(dev, HDMI);
+		vivid_send_source_change(dev, WEBCAM);
+		break;
 	case VIVID_CID_YCBCR_ENC:
 		tpg_s_ycbcr_enc(&dev->tpg, ctrl->val);
 		vivid_send_source_change(dev, TV);
@@ -709,6 +717,25 @@ static const struct v4l2_ctrl_config vivid_ctrl_colorspace = {
 	.qmenu = vivid_ctrl_colorspace_strings,
 };
 
+static const char * const vivid_ctrl_xfer_func_strings[] = {
+	"Default",
+	"Rec. 709",
+	"sRGB",
+	"AdobeRGB",
+	"SMPTE 240M",
+	"None",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivid_ctrl_xfer_func = {
+	.ops = &vivid_vid_cap_ctrl_ops,
+	.id = VIVID_CID_XFER_FUNC,
+	.name = "Transfer Function",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = 5,
+	.qmenu = vivid_ctrl_xfer_func_strings,
+};
+
 static const char * const vivid_ctrl_ycbcr_enc_strings[] = {
 	"Default",
 	"ITU-R 601",
@@ -1365,6 +1392,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_tstamp_src, NULL);
 		dev->colorspace = v4l2_ctrl_new_custom(hdl_vid_cap,
 			&vivid_ctrl_colorspace, NULL);
+		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_xfer_func, NULL);
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_ycbcr_enc, NULL);
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_quantization, NULL);
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_alpha_mode, NULL);
diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index b1147f2..249b744 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1650,8 +1650,14 @@ static void tpg_recalc(struct tpg_data *tpg)
 	if (tpg->recalc_colors) {
 		tpg->recalc_colors = false;
 		tpg->recalc_lines = true;
+		tpg->real_xfer_func = tpg->xfer_func;
 		tpg->real_ycbcr_enc = tpg->ycbcr_enc;
 		tpg->real_quantization = tpg->quantization;
+
+		if (tpg->xfer_func == V4L2_XFER_FUNC_DEFAULT)
+			tpg->real_xfer_func =
+				V4L2_MAP_XFER_FUNC_DEFAULT(tpg->colorspace);
+
 		if (tpg->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
 			tpg->real_ycbcr_enc =
 				V4L2_MAP_YCBCR_ENC_DEFAULT(tpg->colorspace);
@@ -1715,6 +1721,7 @@ void tpg_log_status(struct tpg_data *tpg)
 	pr_info("tpg compose: %ux%u@%dx%d\n", tpg->compose.width, tpg->compose.height,
 			tpg->compose.left, tpg->compose.top);
 	pr_info("tpg colorspace: %d\n", tpg->colorspace);
+	pr_info("tpg transfer function: %d/%d\n", tpg->xfer_func, tpg->real_xfer_func);
 	pr_info("tpg Y'CbCr encoding: %d/%d\n", tpg->ycbcr_enc, tpg->real_ycbcr_enc);
 	pr_info("tpg quantization: %d/%d\n", tpg->quantization, tpg->real_quantization);
 	pr_info("tpg RGB range: %d/%d\n", tpg->rgb_range, tpg->real_rgb_range);
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index ef8638f..9baed6a 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -122,8 +122,14 @@ struct tpg_data {
 	u32				fourcc;
 	bool				is_yuv;
 	u32				colorspace;
+	u32				xfer_func;
 	u32				ycbcr_enc;
 	/*
+	 * Stores the actual transfer function, i.e. will never be
+	 * V4L2_XFER_FUNC_DEFAULT.
+	 */
+	u32				real_xfer_func;
+	/*
 	 * Stores the actual Y'CbCr encoding, i.e. will never be
 	 * V4L2_YCBCR_ENC_DEFAULT.
 	 */
@@ -329,6 +335,19 @@ static inline u32 tpg_g_ycbcr_enc(const struct tpg_data *tpg)
 	return tpg->ycbcr_enc;
 }
 
+static inline void tpg_s_xfer_func(struct tpg_data *tpg, u32 xfer_func)
+{
+	if (tpg->xfer_func == xfer_func)
+		return;
+	tpg->xfer_func = xfer_func;
+	tpg->recalc_colors = true;
+}
+
+static inline u32 tpg_g_xfer_func(const struct tpg_data *tpg)
+{
+	return tpg->xfer_func;
+}
+
 static inline void tpg_s_quantization(struct tpg_data *tpg, u32 quantization)
 {
 	if (tpg->quantization == quantization)
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index fd7adc4..7b80bda 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -501,6 +501,13 @@ static unsigned vivid_colorspace_cap(struct vivid_dev *dev)
 	return dev->colorspace_out;
 }
 
+static unsigned vivid_xfer_func_cap(struct vivid_dev *dev)
+{
+	if (!dev->loop_video || vivid_is_webcam(dev) || vivid_is_tv_cap(dev))
+		return tpg_g_xfer_func(&dev->tpg);
+	return dev->xfer_func_out;
+}
+
 static unsigned vivid_ycbcr_enc_cap(struct vivid_dev *dev)
 {
 	if (!dev->loop_video || vivid_is_webcam(dev) || vivid_is_tv_cap(dev))
@@ -527,6 +534,7 @@ int vivid_g_fmt_vid_cap(struct file *file, void *priv,
 	mp->field        = dev->field_cap;
 	mp->pixelformat  = dev->fmt_cap->fourcc;
 	mp->colorspace   = vivid_colorspace_cap(dev);
+	mp->xfer_func    = vivid_xfer_func_cap(dev);
 	mp->ycbcr_enc    = vivid_ycbcr_enc_cap(dev);
 	mp->quantization = vivid_quantization_cap(dev);
 	mp->num_planes = dev->fmt_cap->buffers;
@@ -616,6 +624,7 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
 	}
 	mp->colorspace = vivid_colorspace_cap(dev);
 	mp->ycbcr_enc = vivid_ycbcr_enc_cap(dev);
+	mp->xfer_func = vivid_xfer_func_cap(dev);
 	mp->quantization = vivid_quantization_cap(dev);
 	memset(mp->reserved, 0, sizeof(mp->reserved));
 	return 0;
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 45f10a7..fc73927 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -524,6 +524,7 @@ void fmt_sp2mp(const struct v4l2_format *sp_fmt, struct v4l2_format *mp_fmt)
 	mp->pixelformat = pix->pixelformat;
 	mp->field = pix->field;
 	mp->colorspace = pix->colorspace;
+	mp->xfer_func = pix->xfer_func;
 	mp->ycbcr_enc = pix->ycbcr_enc;
 	mp->quantization = pix->quantization;
 	mp->num_planes = 1;
@@ -552,6 +553,7 @@ int fmt_sp2mp_func(struct file *file, void *priv,
 	pix->pixelformat = mp->pixelformat;
 	pix->field = mp->field;
 	pix->colorspace = mp->colorspace;
+	pix->xfer_func = mp->xfer_func;
 	pix->ycbcr_enc = mp->ycbcr_enc;
 	pix->quantization = mp->quantization;
 	pix->sizeimage = ppix->sizeimage;
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 00f42df..0862c1f 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -258,6 +258,7 @@ void vivid_update_format_out(struct vivid_dev *dev)
 		}
 		break;
 	}
+	dev->xfer_func_out = V4L2_XFER_FUNC_DEFAULT;
 	dev->ycbcr_enc_out = V4L2_YCBCR_ENC_DEFAULT;
 	dev->quantization_out = V4L2_QUANTIZATION_DEFAULT;
 	dev->compose_out = dev->sink_rect;
@@ -320,6 +321,7 @@ int vivid_g_fmt_vid_out(struct file *file, void *priv,
 	mp->field        = dev->field_out;
 	mp->pixelformat  = fmt->fourcc;
 	mp->colorspace   = dev->colorspace_out;
+	mp->xfer_func    = dev->xfer_func_out;
 	mp->ycbcr_enc    = dev->ycbcr_enc_out;
 	mp->quantization = dev->quantization_out;
 	mp->num_planes = fmt->buffers;
@@ -407,6 +409,7 @@ int vivid_try_fmt_vid_out(struct file *file, void *priv,
 	for (p = fmt->buffers; p < fmt->planes; p++)
 		pfmt[0].sizeimage += (pfmt[0].bytesperline * fmt->bit_depth[p]) /
 				     (fmt->bit_depth[0] * fmt->vdownsampling[p]);
+	mp->xfer_func = V4L2_XFER_FUNC_DEFAULT;
 	mp->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
 	mp->quantization = V4L2_QUANTIZATION_DEFAULT;
 	if (vivid_is_svid_out(dev)) {
@@ -546,6 +549,7 @@ int vivid_s_fmt_vid_out(struct file *file, void *priv,
 
 set_colorspace:
 	dev->colorspace_out = mp->colorspace;
+	dev->xfer_func_out = mp->xfer_func;
 	dev->ycbcr_enc_out = mp->ycbcr_enc;
 	dev->quantization_out = mp->quantization;
 	if (dev->loop_video) {
-- 
2.1.4

