Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1736 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaIUOss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 10:48:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 11/11] vivid: add crop/compose selection control support
Date: Sun, 21 Sep 2014 16:48:29 +0200
Message-Id: <1411310909-32825-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.h    |  5 ++++
 drivers/media/platform/vivid/vivid-ctrls.c   | 37 ++++++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-vid-cap.c | 10 ++++++--
 drivers/media/platform/vivid/vivid-vid-cap.h |  1 +
 4 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 811c286..f9d6c45 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -214,6 +214,11 @@ struct vivid_dev {
 		struct v4l2_ctrl	*ctrl_dv_timings_signal_mode;
 		struct v4l2_ctrl	*ctrl_dv_timings;
 	};
+	struct {
+		/* capture selection crop/compose cluster */
+		struct v4l2_ctrl	*ctrl_cap_crop;
+		struct v4l2_ctrl	*ctrl_cap_compose;
+	};
 	struct v4l2_ctrl		*ctrl_has_crop_cap;
 	struct v4l2_ctrl		*ctrl_has_compose_cap;
 	struct v4l2_ctrl		*ctrl_has_scaler_cap;
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 42376a1..04d18be 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -398,6 +398,25 @@ static int vivid_vid_cap_s_ctrl(struct v4l2_ctrl *ctrl)
 		if (dev->edid_blocks > dev->edid_max_blocks)
 			dev->edid_blocks = dev->edid_max_blocks;
 		break;
+	case V4L2_CID_CAPTURE_CROP: {
+		struct v4l2_selection s = { V4L2_BUF_TYPE_VIDEO_CAPTURE };
+		struct v4l2_ctrl_selection *crop = dev->ctrl_cap_crop->p_new.p_sel;
+		struct v4l2_ctrl_selection *compose = dev->ctrl_cap_compose->p_new.p_sel;
+		int ret;
+
+		if (ctrl->store)
+			break;
+		s.target = V4L2_SEL_TGT_CROP;
+		s.r = crop->r;
+		s.flags = crop->flags;
+		ret = vivid_vid_cap_s_selection_int(dev, &s);
+		if (ret)
+			return ret;
+		s.target = V4L2_SEL_TGT_COMPOSE;
+		s.r = compose->r;
+		s.flags = compose->flags;
+		return vivid_vid_cap_s_selection_int(dev, &s);
+	}
 	}
 	return 0;
 }
@@ -668,6 +687,19 @@ static const struct v4l2_ctrl_config vivid_ctrl_limited_rgb_range = {
 	.step = 1,
 };
 
+static const struct v4l2_ctrl_config vivid_ctrl_capture_crop = {
+	.ops = &vivid_vid_cap_ctrl_ops,
+	.id = V4L2_CID_CAPTURE_CROP,
+	.dims = { 1 },
+	.can_store = true,
+};
+
+static const struct v4l2_ctrl_config vivid_ctrl_capture_compose = {
+	.ops = &vivid_vid_cap_ctrl_ops,
+	.id = V4L2_CID_CAPTURE_COMPOSE,
+	.dims = { 1 },
+	.can_store = true,
+};
 
 /* VBI Capture Control */
 
@@ -1263,6 +1295,10 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		dev->colorspace = v4l2_ctrl_new_custom(hdl_vid_cap,
 			&vivid_ctrl_colorspace, NULL);
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_alpha_mode, NULL);
+		dev->ctrl_cap_crop = v4l2_ctrl_new_custom(hdl_vid_cap,
+				&vivid_ctrl_capture_crop, NULL);
+		dev->ctrl_cap_compose = v4l2_ctrl_new_custom(hdl_vid_cap,
+				&vivid_ctrl_capture_compose, NULL);
 	}
 
 	if (dev->has_vid_out && show_ccs_out) {
@@ -1435,6 +1471,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_user_aud, NULL);
 		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_streaming, NULL);
 		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_sdtv_cap, NULL);
+		v4l2_ctrl_cluster(2, &dev->ctrl_cap_crop);
 		if (hdl_vid_cap->error)
 			return hdl_vid_cap->error;
 		dev->vid_cap_dev.ctrl_handler = hdl_vid_cap;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 95eda68..934ea3d 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -831,9 +831,8 @@ int vivid_vid_cap_g_selection(struct file *file, void *priv,
 	return 0;
 }
 
-int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
+int vivid_vid_cap_s_selection_int(struct vivid_dev *dev, struct v4l2_selection *s)
 {
-	struct vivid_dev *dev = video_drvdata(file);
 	struct v4l2_rect *crop = &dev->crop_cap;
 	struct v4l2_rect *compose = &dev->compose_cap;
 	unsigned factor = V4L2_FIELD_HAS_T_OR_B(dev->field_cap) ? 2 : 1;
@@ -967,6 +966,13 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 	return 0;
 }
 
+int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	return vivid_vid_cap_s_selection_int(dev, s);
+}
+
 int vivid_vid_cap_cropcap(struct file *file, void *priv,
 			      struct v4l2_cropcap *cap)
 {
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.h b/drivers/media/platform/vivid/vivid-vid-cap.h
index 9407981..e7d36cb 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.h
+++ b/drivers/media/platform/vivid/vivid-vid-cap.h
@@ -39,6 +39,7 @@ int vidioc_g_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f);
 int vidioc_try_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f);
 int vidioc_s_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f);
 int vivid_vid_cap_g_selection(struct file *file, void *priv, struct v4l2_selection *sel);
+int vivid_vid_cap_s_selection_int(struct vivid_dev *dev, struct v4l2_selection *s);
 int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection *s);
 int vivid_vid_cap_cropcap(struct file *file, void *priv, struct v4l2_cropcap *cap);
 int vidioc_enum_fmt_vid_overlay(struct file *file, void  *priv, struct v4l2_fmtdesc *f);
-- 
2.1.0

