Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58988 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbaK0NZL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 08:25:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 8/9] vivid: add support for YCbCr encoding and quantization
Date: Thu, 27 Nov 2014 14:23:51 +0100
Message-Id: <1417094632-31980-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417094632-31980-1-git-send-email-hverkuil@xs4all.nl>
References: <1417094632-31980-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Implement controls to set the YCbCr encoding and the quantization
range for the colorspace.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.h       |  2 +
 drivers/media/platform/vivid/vivid-ctrls.c      | 86 +++++++++++++++++++++----
 drivers/media/platform/vivid/vivid-vid-cap.c    | 18 ++++++
 drivers/media/platform/vivid/vivid-vid-common.c |  4 ++
 drivers/media/platform/vivid/vivid-vid-out.c    | 25 +++++--
 5 files changed, 116 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 9e41cbe..4b497df 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -329,6 +329,8 @@ struct vivid_dev {
 	v4l2_std_id			std_out;
 	struct v4l2_dv_timings		dv_timings_out;
 	u32				colorspace_out;
+	u32				ycbcr_enc_out;
+	u32				quantization_out;
 	u32				service_set_out;
 	u32				bytesperline_out[2];
 	unsigned			tv_field_out;
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index dcb912d..857e786 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -62,19 +62,21 @@
 #define VIVID_CID_DV_TIMINGS_ASPECT_RATIO	(VIVID_CID_VIVID_BASE + 23)
 #define VIVID_CID_TSTAMP_SRC		(VIVID_CID_VIVID_BASE + 24)
 #define VIVID_CID_COLORSPACE		(VIVID_CID_VIVID_BASE + 25)
-#define VIVID_CID_LIMITED_RGB_RANGE	(VIVID_CID_VIVID_BASE + 26)
-#define VIVID_CID_ALPHA_MODE		(VIVID_CID_VIVID_BASE + 27)
-#define VIVID_CID_HAS_CROP_CAP		(VIVID_CID_VIVID_BASE + 28)
-#define VIVID_CID_HAS_COMPOSE_CAP	(VIVID_CID_VIVID_BASE + 29)
-#define VIVID_CID_HAS_SCALER_CAP	(VIVID_CID_VIVID_BASE + 30)
-#define VIVID_CID_HAS_CROP_OUT		(VIVID_CID_VIVID_BASE + 31)
-#define VIVID_CID_HAS_COMPOSE_OUT	(VIVID_CID_VIVID_BASE + 32)
-#define VIVID_CID_HAS_SCALER_OUT	(VIVID_CID_VIVID_BASE + 33)
-#define VIVID_CID_LOOP_VIDEO		(VIVID_CID_VIVID_BASE + 34)
-#define VIVID_CID_SEQ_WRAP		(VIVID_CID_VIVID_BASE + 35)
-#define VIVID_CID_TIME_WRAP		(VIVID_CID_VIVID_BASE + 36)
-#define VIVID_CID_MAX_EDID_BLOCKS	(VIVID_CID_VIVID_BASE + 37)
-#define VIVID_CID_PERCENTAGE_FILL	(VIVID_CID_VIVID_BASE + 38)
+#define VIVID_CID_YCBCR_ENC		(VIVID_CID_VIVID_BASE + 26)
+#define VIVID_CID_QUANTIZATION		(VIVID_CID_VIVID_BASE + 27)
+#define VIVID_CID_LIMITED_RGB_RANGE	(VIVID_CID_VIVID_BASE + 28)
+#define VIVID_CID_ALPHA_MODE		(VIVID_CID_VIVID_BASE + 29)
+#define VIVID_CID_HAS_CROP_CAP		(VIVID_CID_VIVID_BASE + 30)
+#define VIVID_CID_HAS_COMPOSE_CAP	(VIVID_CID_VIVID_BASE + 31)
+#define VIVID_CID_HAS_SCALER_CAP	(VIVID_CID_VIVID_BASE + 32)
+#define VIVID_CID_HAS_CROP_OUT		(VIVID_CID_VIVID_BASE + 33)
+#define VIVID_CID_HAS_COMPOSE_OUT	(VIVID_CID_VIVID_BASE + 34)
+#define VIVID_CID_HAS_SCALER_OUT	(VIVID_CID_VIVID_BASE + 35)
+#define VIVID_CID_LOOP_VIDEO		(VIVID_CID_VIVID_BASE + 36)
+#define VIVID_CID_SEQ_WRAP		(VIVID_CID_VIVID_BASE + 37)
+#define VIVID_CID_TIME_WRAP		(VIVID_CID_VIVID_BASE + 38)
+#define VIVID_CID_MAX_EDID_BLOCKS	(VIVID_CID_VIVID_BASE + 39)
+#define VIVID_CID_PERCENTAGE_FILL	(VIVID_CID_VIVID_BASE + 40)
 
 #define VIVID_CID_STD_SIGNAL_MODE	(VIVID_CID_VIVID_BASE + 60)
 #define VIVID_CID_STANDARD		(VIVID_CID_VIVID_BASE + 61)
@@ -358,6 +360,20 @@ static int vivid_vid_cap_s_ctrl(struct v4l2_ctrl *ctrl)
 		vivid_send_source_change(dev, HDMI);
 		vivid_send_source_change(dev, WEBCAM);
 		break;
+	case VIVID_CID_YCBCR_ENC:
+		tpg_s_ycbcr_enc(&dev->tpg, ctrl->val);
+		vivid_send_source_change(dev, TV);
+		vivid_send_source_change(dev, SVID);
+		vivid_send_source_change(dev, HDMI);
+		vivid_send_source_change(dev, WEBCAM);
+		break;
+	case VIVID_CID_QUANTIZATION:
+		tpg_s_quantization(&dev->tpg, ctrl->val);
+		vivid_send_source_change(dev, TV);
+		vivid_send_source_change(dev, SVID);
+		vivid_send_source_change(dev, HDMI);
+		vivid_send_source_change(dev, WEBCAM);
+		break;
 	case V4L2_CID_DV_RX_RGB_RANGE:
 		if (!vivid_is_hdmi_cap(dev))
 			break;
@@ -693,6 +709,44 @@ static const struct v4l2_ctrl_config vivid_ctrl_colorspace = {
 	.qmenu = vivid_ctrl_colorspace_strings,
 };
 
+static const char * const vivid_ctrl_ycbcr_enc_strings[] = {
+	"Default",
+	"ITU-R 601",
+	"Rec. 709",
+	"xvYCC 601",
+	"xvYCC 709",
+	"sYCC",
+	"BT.2020 Non-Constant Luminance",
+	"BT.2020 Constant Luminance",
+	"SMPTE 240M",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivid_ctrl_ycbcr_enc = {
+	.ops = &vivid_vid_cap_ctrl_ops,
+	.id = VIVID_CID_YCBCR_ENC,
+	.name = "Y'CbCr Encoding",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = 8,
+	.qmenu = vivid_ctrl_ycbcr_enc_strings,
+};
+
+static const char * const vivid_ctrl_quantization_strings[] = {
+	"Default",
+	"Full Range",
+	"Limited Range",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config vivid_ctrl_quantization = {
+	.ops = &vivid_vid_cap_ctrl_ops,
+	.id = VIVID_CID_QUANTIZATION,
+	.name = "Quantization",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.max = 2,
+	.qmenu = vivid_ctrl_quantization_strings,
+};
+
 static const struct v4l2_ctrl_config vivid_ctrl_alpha_mode = {
 	.ops = &vivid_vid_cap_ctrl_ops,
 	.id = VIVID_CID_ALPHA_MODE,
@@ -769,8 +823,12 @@ static int vivid_vid_out_s_ctrl(struct v4l2_ctrl *ctrl)
 				dev->colorspace_out = V4L2_COLORSPACE_SMPTE170M;
 			else
 				dev->colorspace_out = V4L2_COLORSPACE_REC709;
+			dev->quantization_out = V4L2_QUANTIZATION_DEFAULT;
 		} else {
 			dev->colorspace_out = V4L2_COLORSPACE_SRGB;
+			dev->quantization_out = dev->dvi_d_out ?
+					V4L2_QUANTIZATION_LIM_RANGE :
+					V4L2_QUANTIZATION_DEFAULT;
 		}
 		if (dev->loop_video)
 			vivid_send_source_change(dev, HDMI);
@@ -1307,6 +1365,8 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_tstamp_src, NULL);
 		dev->colorspace = v4l2_ctrl_new_custom(hdl_vid_cap,
 			&vivid_ctrl_colorspace, NULL);
+		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_ycbcr_enc, NULL);
+		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_quantization, NULL);
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_alpha_mode, NULL);
 	}
 
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 923a4f8..867a29a 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -498,6 +498,20 @@ static unsigned vivid_colorspace_cap(struct vivid_dev *dev)
 	return dev->colorspace_out;
 }
 
+static unsigned vivid_ycbcr_enc_cap(struct vivid_dev *dev)
+{
+	if (!dev->loop_video || vivid_is_webcam(dev) || vivid_is_tv_cap(dev))
+		return tpg_g_ycbcr_enc(&dev->tpg);
+	return dev->ycbcr_enc_out;
+}
+
+static unsigned vivid_quantization_cap(struct vivid_dev *dev)
+{
+	if (!dev->loop_video || vivid_is_webcam(dev) || vivid_is_tv_cap(dev))
+		return tpg_g_quantization(&dev->tpg);
+	return dev->quantization_out;
+}
+
 int vivid_g_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
@@ -510,6 +524,8 @@ int vivid_g_fmt_vid_cap(struct file *file, void *priv,
 	mp->field        = dev->field_cap;
 	mp->pixelformat  = dev->fmt_cap->fourcc;
 	mp->colorspace   = vivid_colorspace_cap(dev);
+	mp->ycbcr_enc    = vivid_ycbcr_enc_cap(dev);
+	mp->quantization = vivid_quantization_cap(dev);
 	mp->num_planes = dev->fmt_cap->planes;
 	for (p = 0; p < mp->num_planes; p++) {
 		mp->plane_fmt[p].bytesperline = tpg_g_bytesperline(&dev->tpg, p);
@@ -595,6 +611,8 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
 		memset(pfmt[p].reserved, 0, sizeof(pfmt[p].reserved));
 	}
 	mp->colorspace = vivid_colorspace_cap(dev);
+	mp->ycbcr_enc = vivid_ycbcr_enc_cap(dev);
+	mp->quantization = vivid_quantization_cap(dev);
 	memset(mp->reserved, 0, sizeof(mp->reserved));
 	return 0;
 }
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 16cd6d2..6bef1e6 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -259,6 +259,8 @@ void fmt_sp2mp(const struct v4l2_format *sp_fmt, struct v4l2_format *mp_fmt)
 	mp->pixelformat = pix->pixelformat;
 	mp->field = pix->field;
 	mp->colorspace = pix->colorspace;
+	mp->ycbcr_enc = pix->ycbcr_enc;
+	mp->quantization = pix->quantization;
 	mp->num_planes = 1;
 	mp->flags = pix->flags;
 	ppix->sizeimage = pix->sizeimage;
@@ -285,6 +287,8 @@ int fmt_sp2mp_func(struct file *file, void *priv,
 	pix->pixelformat = mp->pixelformat;
 	pix->field = mp->field;
 	pix->colorspace = mp->colorspace;
+	pix->ycbcr_enc = mp->ycbcr_enc;
+	pix->quantization = mp->quantization;
 	pix->sizeimage = ppix->sizeimage;
 	pix->bytesperline = ppix->bytesperline;
 	pix->flags = mp->flags;
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 078bc35..ee5c399 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -259,6 +259,8 @@ void vivid_update_format_out(struct vivid_dev *dev)
 		}
 		break;
 	}
+	dev->ycbcr_enc_out = V4L2_YCBCR_ENC_DEFAULT;
+	dev->quantization_out = V4L2_QUANTIZATION_DEFAULT;
 	dev->compose_out = dev->sink_rect;
 	dev->compose_bounds_out = dev->sink_rect;
 	dev->crop_out = dev->compose_out;
@@ -318,6 +320,8 @@ int vivid_g_fmt_vid_out(struct file *file, void *priv,
 	mp->field        = dev->field_out;
 	mp->pixelformat  = dev->fmt_out->fourcc;
 	mp->colorspace   = dev->colorspace_out;
+	mp->ycbcr_enc    = dev->ycbcr_enc_out;
+	mp->quantization = dev->quantization_out;
 	mp->num_planes = dev->fmt_out->planes;
 	for (p = 0; p < mp->num_planes; p++) {
 		mp->plane_fmt[p].bytesperline = dev->bytesperline_out[p];
@@ -394,16 +398,23 @@ int vivid_try_fmt_vid_out(struct file *file, void *priv,
 		pfmt[p].sizeimage = pfmt[p].bytesperline * mp->height;
 		memset(pfmt[p].reserved, 0, sizeof(pfmt[p].reserved));
 	}
-	if (vivid_is_svid_out(dev))
+	mp->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	mp->quantization = V4L2_QUANTIZATION_DEFAULT;
+	if (vivid_is_svid_out(dev)) {
 		mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
-	else if (dev->dvi_d_out || !(bt->standards & V4L2_DV_BT_STD_CEA861))
+	} else if (dev->dvi_d_out || !(bt->standards & V4L2_DV_BT_STD_CEA861)) {
 		mp->colorspace = V4L2_COLORSPACE_SRGB;
-	else if (bt->width == 720 && bt->height <= 576)
+		if (dev->dvi_d_out)
+			mp->quantization = V4L2_QUANTIZATION_LIM_RANGE;
+	} else if (bt->width == 720 && bt->height <= 576) {
 		mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
-	else if (mp->colorspace != V4L2_COLORSPACE_SMPTE170M &&
-		 mp->colorspace != V4L2_COLORSPACE_REC709 &&
-		 mp->colorspace != V4L2_COLORSPACE_SRGB)
+	} else if (mp->colorspace != V4L2_COLORSPACE_SMPTE170M &&
+		   mp->colorspace != V4L2_COLORSPACE_REC709 &&
+		   mp->colorspace != V4L2_COLORSPACE_ADOBERGB &&
+		   mp->colorspace != V4L2_COLORSPACE_BT2020 &&
+		   mp->colorspace != V4L2_COLORSPACE_SRGB) {
 		mp->colorspace = V4L2_COLORSPACE_REC709;
+	}
 	memset(mp->reserved, 0, sizeof(mp->reserved));
 	return 0;
 }
@@ -522,6 +533,8 @@ int vivid_s_fmt_vid_out(struct file *file, void *priv,
 
 set_colorspace:
 	dev->colorspace_out = mp->colorspace;
+	dev->ycbcr_enc_out = mp->ycbcr_enc;
+	dev->quantization_out = mp->quantization;
 	if (dev->loop_video) {
 		vivid_send_source_change(dev, SVID);
 		vivid_send_source_change(dev, HDMI);
-- 
2.1.3

