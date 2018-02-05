Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:41564 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752808AbeBEOhb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 09:37:31 -0500
From: Florian Echtler <floe@butterbrot.org>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: linux-input@vger.kernel.org, modin@yuri.at,
        Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 4/5] add V4L2 control functions
Date: Mon,  5 Feb 2018 15:29:40 +0100
Message-Id: <1517840981-12280-5-git-send-email-floe@butterbrot.org>
In-Reply-To: <1517840981-12280-1-git-send-email-floe@butterbrot.org>
References: <1517840981-12280-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 114 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 63c7264b..c4b7cf1 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -953,6 +953,119 @@ static int sur40_vidioc_g_fmt(struct file *file, void *priv,
 	return 0;
 }
 
+
+static int sur40_vidioc_queryctrl(struct file *file, void *fh,
+			       struct v4l2_queryctrl *qc)
+{
+
+	switch (qc->id) {
+	case V4L2_CID_BRIGHTNESS:
+		qc->flags = 0;
+		sprintf(qc->name, "Brightness");
+		qc->type = V4L2_CTRL_TYPE_INTEGER;
+		qc->minimum = SUR40_BRIGHTNESS_MIN;
+		qc->default_value = SUR40_BRIGHTNESS_DEF;
+		qc->maximum = SUR40_BRIGHTNESS_MAX;
+		qc->step = 8;
+		return 0;
+	case V4L2_CID_CONTRAST:
+		qc->flags = 0;
+		sprintf(qc->name, "Contrast");
+		qc->type = V4L2_CTRL_TYPE_INTEGER;
+		qc->minimum = SUR40_CONTRAST_MIN;
+		qc->default_value = SUR40_CONTRAST_DEF;
+		qc->maximum = SUR40_CONTRAST_MAX;
+		qc->step = 1;
+		return 0;
+	case V4L2_CID_GAIN:
+		qc->flags = 0;
+		sprintf(qc->name, "Gain");
+		qc->type = V4L2_CTRL_TYPE_INTEGER;
+		qc->minimum = SUR40_GAIN_MIN;
+		qc->default_value = SUR40_GAIN_DEF;
+		qc->maximum = SUR40_GAIN_MAX;
+		qc->step = 1;
+		return 0;
+	case V4L2_CID_BACKLIGHT_COMPENSATION:
+		qc->flags = 0;
+		sprintf(qc->name, "Preprocessor");
+		qc->type = V4L2_CTRL_TYPE_INTEGER;
+		qc->minimum = SUR40_BACKLIGHT_MIN;
+		qc->default_value = SUR40_BACKLIGHT_DEF;
+		qc->maximum = SUR40_BACKLIGHT_MAX;
+		qc->step = 1;
+		return 0;
+	default:
+		qc->flags = V4L2_CTRL_FLAG_DISABLED;
+		return -EINVAL;
+	}
+}
+
+static int sur40_vidioc_g_ctrl(struct file *file, void *fh,
+			    struct v4l2_control *ctrl)
+{
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		ctrl->value = sur40_v4l2_brightness;
+		return 0;
+	case V4L2_CID_CONTRAST:
+		ctrl->value = sur40_v4l2_contrast;
+		return 0;
+	case V4L2_CID_GAIN:
+		ctrl->value = sur40_v4l2_gain;
+		return 0;
+	case V4L2_CID_BACKLIGHT_COMPENSATION:
+		ctrl->value = sur40_v4l2_backlight;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int sur40_vidioc_s_ctrl(struct file *file, void *fh,
+			    struct v4l2_control *ctrl)
+{
+	u8 value = 0;
+	struct sur40_state *sur40 = video_drvdata(file);
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		sur40_v4l2_brightness = ctrl->value;
+		if (sur40_v4l2_brightness < SUR40_BRIGHTNESS_MIN)
+			sur40_v4l2_brightness = SUR40_BRIGHTNESS_MIN;
+		else if (sur40_v4l2_brightness > SUR40_BRIGHTNESS_MAX)
+			sur40_v4l2_brightness = SUR40_BRIGHTNESS_MAX;
+		sur40_set_irlevel(sur40, sur40_v4l2_brightness);
+		return 0;
+	case V4L2_CID_CONTRAST:
+		sur40_v4l2_contrast = ctrl->value;
+		if (sur40_v4l2_contrast < SUR40_CONTRAST_MIN)
+			sur40_v4l2_contrast = SUR40_CONTRAST_MIN;
+		else if (sur40_v4l2_contrast > SUR40_CONTRAST_MAX)
+			sur40_v4l2_contrast = SUR40_CONTRAST_MAX;
+		value = (sur40_v4l2_contrast << 4) + sur40_v4l2_gain;
+		sur40_set_vsvideo(sur40, value);
+		return 0;
+	case V4L2_CID_GAIN:
+		sur40_v4l2_gain = ctrl->value;
+		if (sur40_v4l2_gain < SUR40_GAIN_MIN)
+			sur40_v4l2_gain = SUR40_GAIN_MIN;
+		else if (sur40_v4l2_gain > SUR40_GAIN_MAX)
+			sur40_v4l2_gain = SUR40_GAIN_MAX;
+		value = (sur40_v4l2_contrast << 4) + sur40_v4l2_gain;
+		sur40_set_vsvideo(sur40, value);
+		return 0;
+	case V4L2_CID_BACKLIGHT_COMPENSATION:
+		sur40_v4l2_backlight = ctrl->value;
+		sur40_set_preprocessor(sur40, sur40_v4l2_backlight);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+
 static int sur40_ioctl_parm(struct file *file, void *priv,
 			    struct v4l2_streamparm *p)
 {
@@ -1071,6 +1181,10 @@ static const struct v4l2_ioctl_ops sur40_video_ioctl_ops = {
 	.vidioc_g_input		= sur40_vidioc_g_input,
 	.vidioc_s_input		= sur40_vidioc_s_input,
 
+	.vidioc_queryctrl	= sur40_vidioc_queryctrl,
+	.vidioc_g_ctrl		= sur40_vidioc_g_ctrl,
+	.vidioc_s_ctrl		= sur40_vidioc_s_ctrl,
+
 	.vidioc_reqbufs		= vb2_ioctl_reqbufs,
 	.vidioc_create_bufs	= vb2_ioctl_create_bufs,
 	.vidioc_querybuf	= vb2_ioctl_querybuf,
-- 
2.7.4
