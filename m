Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3001 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934735Ab3DHK7X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:59:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 03/12] hdpvr: convert to the control framework.
Date: Mon,  8 Apr 2013 12:58:32 +0200
Message-Id: <1365418721-23859-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl>
References: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |  515 +++++++++------------------------
 drivers/media/usb/hdpvr/hdpvr.h       |    8 +
 2 files changed, 145 insertions(+), 378 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 2983bf0..a890127 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -710,335 +710,69 @@ static int vidioc_g_audio(struct file *file, void *private_data,
 	return 0;
 }
 
-static const s32 supported_v4l2_ctrls[] = {
-	V4L2_CID_BRIGHTNESS,
-	V4L2_CID_CONTRAST,
-	V4L2_CID_SATURATION,
-	V4L2_CID_HUE,
-	V4L2_CID_SHARPNESS,
-	V4L2_CID_MPEG_AUDIO_ENCODING,
-	V4L2_CID_MPEG_VIDEO_ENCODING,
-	V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
-	V4L2_CID_MPEG_VIDEO_BITRATE,
-	V4L2_CID_MPEG_VIDEO_BITRATE_PEAK,
-};
-
-static int fill_queryctrl(struct hdpvr_options *opt, struct v4l2_queryctrl *qc,
-			  int ac3, int fw_ver)
-{
-	int err;
-
-	if (fw_ver > 0x15) {
-		switch (qc->id) {
-		case V4L2_CID_BRIGHTNESS:
-			return v4l2_ctrl_query_fill(qc, 0x0, 0xff, 1, 0x80);
-		case V4L2_CID_CONTRAST:
-			return v4l2_ctrl_query_fill(qc, 0x0, 0xff, 1, 0x40);
-		case V4L2_CID_SATURATION:
-			return v4l2_ctrl_query_fill(qc, 0x0, 0xff, 1, 0x40);
-		case V4L2_CID_HUE:
-			return v4l2_ctrl_query_fill(qc, 0x0, 0x1e, 1, 0xf);
-		case V4L2_CID_SHARPNESS:
-			return v4l2_ctrl_query_fill(qc, 0x0, 0xff, 1, 0x80);
-		}
-	} else {
-		switch (qc->id) {
-		case V4L2_CID_BRIGHTNESS:
-			return v4l2_ctrl_query_fill(qc, 0x0, 0xff, 1, 0x86);
-		case V4L2_CID_CONTRAST:
-			return v4l2_ctrl_query_fill(qc, 0x0, 0xff, 1, 0x80);
-		case V4L2_CID_SATURATION:
-			return v4l2_ctrl_query_fill(qc, 0x0, 0xff, 1, 0x80);
-		case V4L2_CID_HUE:
-			return v4l2_ctrl_query_fill(qc, 0x0, 0xff, 1, 0x80);
-		case V4L2_CID_SHARPNESS:
-			return v4l2_ctrl_query_fill(qc, 0x0, 0xff, 1, 0x80);
-		}
-	}
-
-	switch (qc->id) {
-	case V4L2_CID_MPEG_AUDIO_ENCODING:
-		return v4l2_ctrl_query_fill(
-			qc, V4L2_MPEG_AUDIO_ENCODING_AAC,
-			ac3 ? V4L2_MPEG_AUDIO_ENCODING_AC3
-			: V4L2_MPEG_AUDIO_ENCODING_AAC,
-			1, V4L2_MPEG_AUDIO_ENCODING_AAC);
-	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		return v4l2_ctrl_query_fill(
-			qc, V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC,
-			V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC, 1,
-			V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC);
-
-/* 	case V4L2_CID_MPEG_VIDEO_? maybe keyframe interval: */
-/* 		return v4l2_ctrl_query_fill(qc, 0, 128, 128, 0); */
-	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-		return v4l2_ctrl_query_fill(
-			qc, V4L2_MPEG_VIDEO_BITRATE_MODE_VBR,
-			V4L2_MPEG_VIDEO_BITRATE_MODE_CBR, 1,
-			V4L2_MPEG_VIDEO_BITRATE_MODE_CBR);
-
-	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		return v4l2_ctrl_query_fill(qc, 1000000, 13500000, 100000,
-					    6500000);
-	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
-		err = v4l2_ctrl_query_fill(qc, 1100000, 20200000, 100000,
-					   9000000);
-		if (!err && opt->bitrate_mode == HDPVR_CONSTANT)
-			qc->flags |= V4L2_CTRL_FLAG_INACTIVE;
-		return err;
-	default:
-		return -EINVAL;
-	}
-}
-
-static int vidioc_queryctrl(struct file *file, void *private_data,
-			    struct v4l2_queryctrl *qc)
+static int hdpvr_try_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
-	int i, next;
-	u32 id = qc->id;
-
-	memset(qc, 0, sizeof(*qc));
-
-	next = !!(id &  V4L2_CTRL_FLAG_NEXT_CTRL);
-	qc->id = id & ~V4L2_CTRL_FLAG_NEXT_CTRL;
-
-	for (i = 0; i < ARRAY_SIZE(supported_v4l2_ctrls); i++) {
-		if (next) {
-			if (qc->id < supported_v4l2_ctrls[i])
-				qc->id = supported_v4l2_ctrls[i];
-			else
-				continue;
-		}
-
-		if (qc->id == supported_v4l2_ctrls[i])
-			return fill_queryctrl(&dev->options, qc,
-					      dev->flags & HDPVR_FLAG_AC3_CAP,
-					      dev->fw_ver);
-
-		if (qc->id < supported_v4l2_ctrls[i])
-			break;
-	}
-
-	return -EINVAL;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *private_data,
-			 struct v4l2_control *ctrl)
-{
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
+	struct hdpvr_device *dev =
+		container_of(ctrl->handler, struct hdpvr_device, hdl);
 
 	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = dev->options.brightness;
-		break;
-	case V4L2_CID_CONTRAST:
-		ctrl->value = dev->options.contrast;
-		break;
-	case V4L2_CID_SATURATION:
-		ctrl->value = dev->options.saturation;
-		break;
-	case V4L2_CID_HUE:
-		ctrl->value = dev->options.hue;
-		break;
-	case V4L2_CID_SHARPNESS:
-		ctrl->value = dev->options.sharpness;
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
+		if (ctrl->val == V4L2_MPEG_VIDEO_BITRATE_MODE_VBR &&
+		    dev->video_bitrate->val >= dev->video_bitrate_peak->val)
+			dev->video_bitrate_peak->val =
+					dev->video_bitrate->val + 100000;
 		break;
-	default:
-		return -EINVAL;
 	}
 	return 0;
 }
 
-static int vidioc_s_ctrl(struct file *file, void *private_data,
-			 struct v4l2_control *ctrl)
+static int hdpvr_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
-	int retval;
+	struct hdpvr_device *dev =
+		container_of(ctrl->handler, struct hdpvr_device, hdl);
+	struct hdpvr_options *opt = &dev->options;
+	int ret = -EINVAL;
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		retval = hdpvr_config_call(dev, CTRL_BRIGHTNESS, ctrl->value);
-		if (!retval)
-			dev->options.brightness = ctrl->value;
-		break;
+		ret = hdpvr_config_call(dev, CTRL_BRIGHTNESS, ctrl->val);
+		if (ret)
+			break;
+		dev->options.brightness = ctrl->val;
+		return 0;
 	case V4L2_CID_CONTRAST:
-		retval = hdpvr_config_call(dev, CTRL_CONTRAST, ctrl->value);
-		if (!retval)
-			dev->options.contrast = ctrl->value;
-		break;
+		ret = hdpvr_config_call(dev, CTRL_CONTRAST, ctrl->val);
+		if (ret)
+			break;
+		dev->options.contrast = ctrl->val;
+		return 0;
 	case V4L2_CID_SATURATION:
-		retval = hdpvr_config_call(dev, CTRL_SATURATION, ctrl->value);
-		if (!retval)
-			dev->options.saturation = ctrl->value;
-		break;
+		ret = hdpvr_config_call(dev, CTRL_SATURATION, ctrl->val);
+		if (ret)
+			break;
+		dev->options.saturation = ctrl->val;
+		return 0;
 	case V4L2_CID_HUE:
-		retval = hdpvr_config_call(dev, CTRL_HUE, ctrl->value);
-		if (!retval)
-			dev->options.hue = ctrl->value;
-		break;
+		ret = hdpvr_config_call(dev, CTRL_HUE, ctrl->val);
+		if (ret)
+			break;
+		dev->options.hue = ctrl->val;
+		return 0;
 	case V4L2_CID_SHARPNESS:
-		retval = hdpvr_config_call(dev, CTRL_SHARPNESS, ctrl->value);
-		if (!retval)
-			dev->options.sharpness = ctrl->value;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return retval;
-}
-
-
-static int hdpvr_get_ctrl(struct hdpvr_options *opt,
-			  struct v4l2_ext_control *ctrl)
-{
-	switch (ctrl->id) {
-	case V4L2_CID_MPEG_AUDIO_ENCODING:
-		ctrl->value = opt->audio_codec;
-		break;
-	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		ctrl->value = V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC;
-		break;
-/* 	case V4L2_CID_MPEG_VIDEO_B_FRAMES: */
-/* 		ctrl->value = (opt->gop_mode & 0x2) ? 0 : 128; */
-/* 		break; */
-	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-		ctrl->value = opt->bitrate_mode == HDPVR_CONSTANT
-			? V4L2_MPEG_VIDEO_BITRATE_MODE_CBR
-			: V4L2_MPEG_VIDEO_BITRATE_MODE_VBR;
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		ctrl->value = opt->bitrate * 100000;
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
-		ctrl->value = opt->peak_bitrate * 100000;
-		break;
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		ctrl->value = V4L2_MPEG_STREAM_TYPE_MPEG2_TS;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int vidioc_g_ext_ctrls(struct file *file, void *priv,
-			      struct v4l2_ext_controls *ctrls)
-{
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
-	int i, err = 0;
-
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
-
-			err = hdpvr_get_ctrl(&dev->options, ctrl);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
-		}
-		return err;
-
-	}
-
-	return -EINVAL;
-}
-
-
-static int hdpvr_try_ctrl(struct v4l2_ext_control *ctrl, int ac3)
-{
-	int ret = -EINVAL;
-
-	switch (ctrl->id) {
-	case V4L2_CID_MPEG_AUDIO_ENCODING:
-		if (ctrl->value == V4L2_MPEG_AUDIO_ENCODING_AAC ||
-		    (ac3 && ctrl->value == V4L2_MPEG_AUDIO_ENCODING_AC3))
-			ret = 0;
-		break;
-	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		if (ctrl->value == V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC)
-			ret = 0;
-		break;
-/* 	case V4L2_CID_MPEG_VIDEO_B_FRAMES: */
-/* 		if (ctrl->value == 0 || ctrl->value == 128) */
-/* 			ret = 0; */
-/* 		break; */
-	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-		if (ctrl->value == V4L2_MPEG_VIDEO_BITRATE_MODE_CBR ||
-		    ctrl->value == V4L2_MPEG_VIDEO_BITRATE_MODE_VBR)
-			ret = 0;
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE:
-	{
-		uint bitrate = ctrl->value / 100000;
-		if (bitrate >= 10 && bitrate <= 135)
-			ret = 0;
-		break;
-	}
-	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
-	{
-		uint peak_bitrate = ctrl->value / 100000;
-		if (peak_bitrate >= 10 && peak_bitrate <= 202)
-			ret = 0;
-		break;
-	}
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		if (ctrl->value == V4L2_MPEG_STREAM_TYPE_MPEG2_TS)
-			ret = 0;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return ret;
-}
-
-static int vidioc_try_ext_ctrls(struct file *file, void *priv,
-				struct v4l2_ext_controls *ctrls)
-{
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
-	int i, err = 0;
-
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
-
-			err = hdpvr_try_ctrl(ctrl,
-					     dev->flags & HDPVR_FLAG_AC3_CAP);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
-		}
-		return err;
-	}
-
-	return -EINVAL;
-}
-
-
-static int hdpvr_set_ctrl(struct hdpvr_device *dev,
-			  struct v4l2_ext_control *ctrl)
-{
-	struct hdpvr_options *opt = &dev->options;
-	int ret = 0;
-
-	switch (ctrl->id) {
+		ret = hdpvr_config_call(dev, CTRL_SHARPNESS, ctrl->val);
+		if (ret)
+			break;
+		dev->options.sharpness = ctrl->val;
+		return 0;
 	case V4L2_CID_MPEG_AUDIO_ENCODING:
 		if (dev->flags & HDPVR_FLAG_AC3_CAP) {
-			opt->audio_codec = ctrl->value;
-			ret = hdpvr_set_audio(dev, opt->audio_input,
+			opt->audio_codec = ctrl->val;
+			return hdpvr_set_audio(dev, opt->audio_input,
 					      opt->audio_codec);
 		}
-		break;
+		return 0;
 	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		break;
+		return 0;
 /* 	case V4L2_CID_MPEG_VIDEO_B_FRAMES: */
 /* 		if (ctrl->value == 0 && !(opt->gop_mode & 0x2)) { */
 /* 			opt->gop_mode |= 0x2; */
@@ -1051,81 +785,37 @@ static int hdpvr_set_ctrl(struct hdpvr_device *dev,
 /* 					  opt->gop_mode); */
 /* 		} */
 /* 		break; */
-	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-		if (ctrl->value == V4L2_MPEG_VIDEO_BITRATE_MODE_CBR &&
-		    opt->bitrate_mode != HDPVR_CONSTANT) {
-			opt->bitrate_mode = HDPVR_CONSTANT;
-			hdpvr_config_call(dev, CTRL_BITRATE_MODE_VALUE,
-					  opt->bitrate_mode);
-		}
-		if (ctrl->value == V4L2_MPEG_VIDEO_BITRATE_MODE_VBR &&
-		    opt->bitrate_mode == HDPVR_CONSTANT) {
-			opt->bitrate_mode = HDPVR_VARIABLE_AVERAGE;
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE: {
+		uint peak_bitrate = dev->video_bitrate_peak->val / 100000;
+		uint bitrate = dev->video_bitrate->val / 100000;
+
+		if (ctrl->is_new) {
+			if (ctrl->val == V4L2_MPEG_VIDEO_BITRATE_MODE_CBR)
+				opt->bitrate_mode = HDPVR_CONSTANT;
+			else
+				opt->bitrate_mode = HDPVR_VARIABLE_AVERAGE;
 			hdpvr_config_call(dev, CTRL_BITRATE_MODE_VALUE,
 					  opt->bitrate_mode);
+			v4l2_ctrl_activate(dev->video_bitrate_peak,
+				ctrl->val != V4L2_MPEG_VIDEO_BITRATE_MODE_CBR);
 		}
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE: {
-		uint bitrate = ctrl->value / 100000;
-
-		opt->bitrate = bitrate;
-		if (bitrate >= opt->peak_bitrate)
-			opt->peak_bitrate = bitrate+1;
-
-		hdpvr_set_bitrate(dev);
-		break;
-	}
-	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK: {
-		uint peak_bitrate = ctrl->value / 100000;
 
-		if (opt->bitrate_mode == HDPVR_CONSTANT)
-			break;
-
-		if (opt->bitrate < peak_bitrate) {
+		if (dev->video_bitrate_peak->is_new ||
+		    dev->video_bitrate->is_new) {
+			opt->bitrate = bitrate;
 			opt->peak_bitrate = peak_bitrate;
 			hdpvr_set_bitrate(dev);
-		} else
-			ret = -EINVAL;
-		break;
+		}
+		return 0;
 	}
 	case V4L2_CID_MPEG_STREAM_TYPE:
-		break;
+		return 0;
 	default:
-		return -EINVAL;
+		break;
 	}
 	return ret;
 }
 
-static int vidioc_s_ext_ctrls(struct file *file, void *priv,
-			      struct v4l2_ext_controls *ctrls)
-{
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
-	int i, err = 0;
-
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
-
-			err = hdpvr_try_ctrl(ctrl,
-					     dev->flags & HDPVR_FLAG_AC3_CAP);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
-			err = hdpvr_set_ctrl(dev, ctrl);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
-		}
-		return err;
-
-	}
-
-	return -EINVAL;
-}
-
 static int vidioc_enum_fmt_vid_cap(struct file *file, void *private_data,
 				    struct v4l2_fmtdesc *f)
 {
@@ -1215,12 +905,6 @@ static const struct v4l2_ioctl_ops hdpvr_ioctl_ops = {
 	.vidioc_enumaudio	= vidioc_enumaudio,
 	.vidioc_g_audio		= vidioc_g_audio,
 	.vidioc_s_audio		= vidioc_s_audio,
-	.vidioc_queryctrl	= vidioc_queryctrl,
-	.vidioc_g_ctrl		= vidioc_g_ctrl,
-	.vidioc_s_ctrl		= vidioc_s_ctrl,
-	.vidioc_g_ext_ctrls	= vidioc_g_ext_ctrls,
-	.vidioc_s_ext_ctrls	= vidioc_s_ext_ctrls,
-	.vidioc_try_ext_ctrls	= vidioc_try_ext_ctrls,
 	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap		= vidioc_g_fmt_vid_cap,
 	.vidioc_encoder_cmd	= vidioc_encoder_cmd,
@@ -1237,6 +921,7 @@ static void hdpvr_device_release(struct video_device *vdev)
 	mutex_unlock(&dev->io_mutex);
 
 	v4l2_device_unregister(&dev->v4l2_dev);
+	v4l2_ctrl_handler_free(&dev->hdl);
 
 	/* deregister I2C adapter */
 #if IS_ENABLED(CONFIG_I2C)
@@ -1264,13 +949,85 @@ static const struct video_device hdpvr_video_template = {
 		V4L2_STD_PAL_60,
 };
 
+static const struct v4l2_ctrl_ops hdpvr_ctrl_ops = {
+	.try_ctrl = hdpvr_try_ctrl,
+	.s_ctrl = hdpvr_s_ctrl,
+};
+
 int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
 			    int devnum)
 {
+	struct v4l2_ctrl_handler *hdl = &dev->hdl;
+	bool ac3 = dev->flags & HDPVR_FLAG_AC3_CAP;
+	int res;
+
+	v4l2_ctrl_handler_init(hdl, 11);
+	if (dev->fw_ver > 0x15) {
+		v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0x0, 0xff, 1, 0x80);
+		v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
+			V4L2_CID_CONTRAST, 0x0, 0xff, 1, 0x40);
+		v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
+			V4L2_CID_SATURATION, 0x0, 0xff, 1, 0x40);
+		v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
+			V4L2_CID_HUE, 0x0, 0x1e, 1, 0xf);
+		v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
+			V4L2_CID_SHARPNESS, 0x0, 0xff, 1, 0x80);
+	} else {
+		v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0x0, 0xff, 1, 0x86);
+		v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
+			V4L2_CID_CONTRAST, 0x0, 0xff, 1, 0x80);
+		v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
+			V4L2_CID_SATURATION, 0x0, 0xff, 1, 0x80);
+		v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
+			V4L2_CID_HUE, 0x0, 0xff, 1, 0x80);
+		v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
+			V4L2_CID_SHARPNESS, 0x0, 0xff, 1, 0x80);
+	}
+
+	v4l2_ctrl_new_std_menu(hdl, &hdpvr_ctrl_ops,
+		V4L2_CID_MPEG_STREAM_TYPE,
+		V4L2_MPEG_STREAM_TYPE_MPEG2_TS,
+		0x1, V4L2_MPEG_STREAM_TYPE_MPEG2_TS);
+	v4l2_ctrl_new_std_menu(hdl, &hdpvr_ctrl_ops,
+		V4L2_CID_MPEG_AUDIO_ENCODING,
+		ac3 ? V4L2_MPEG_AUDIO_ENCODING_AC3 : V4L2_MPEG_AUDIO_ENCODING_AAC,
+		0x7, V4L2_MPEG_AUDIO_ENCODING_AAC);
+	v4l2_ctrl_new_std_menu(hdl, &hdpvr_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_ENCODING,
+		V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC, 0x3,
+		V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC);
+
+	dev->video_mode = v4l2_ctrl_new_std_menu(hdl, &hdpvr_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
+		V4L2_MPEG_VIDEO_BITRATE_MODE_CBR, 0,
+		V4L2_MPEG_VIDEO_BITRATE_MODE_CBR);
+
+	dev->video_bitrate = v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_BITRATE,
+		1000000, 13500000, 100000, 6500000);
+	dev->video_bitrate_peak = v4l2_ctrl_new_std(hdl, &hdpvr_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_BITRATE_PEAK,
+		1100000, 20200000, 100000, 9000000);
+	dev->v4l2_dev.ctrl_handler = hdl;
+	if (hdl->error) {
+		res = hdl->error;
+		v4l2_err(&dev->v4l2_dev, "Could not register controls\n");
+		goto error;
+	}
+	v4l2_ctrl_cluster(3, &dev->video_mode);
+	res = v4l2_ctrl_handler_setup(hdl);
+	if (res < 0) {
+		v4l2_err(&dev->v4l2_dev, "Could not setup controls\n");
+		goto error;
+	}
+
 	/* setup and register video device */
 	dev->video_dev = video_device_alloc();
 	if (!dev->video_dev) {
 		v4l2_err(&dev->v4l2_dev, "video_device_alloc() failed\n");
+		res = -ENOMEM;
 		goto error;
 	}
 
@@ -1279,12 +1036,14 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
 	dev->video_dev->parent = parent;
 	video_set_drvdata(dev->video_dev, dev);
 
-	if (video_register_device(dev->video_dev, VFL_TYPE_GRABBER, devnum)) {
+	res = video_register_device(dev->video_dev, VFL_TYPE_GRABBER, devnum);
+	if (res < 0) {
 		v4l2_err(&dev->v4l2_dev, "video_device registration failed\n");
 		goto error;
 	}
 
 	return 0;
 error:
-	return -ENOMEM;
+	v4l2_ctrl_handler_free(hdl);
+	return res;
 }
diff --git a/drivers/media/usb/hdpvr/hdpvr.h b/drivers/media/usb/hdpvr/hdpvr.h
index fea3c69..2a4deab 100644
--- a/drivers/media/usb/hdpvr/hdpvr.h
+++ b/drivers/media/usb/hdpvr/hdpvr.h
@@ -16,6 +16,7 @@
 #include <linux/videodev2.h>
 
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/ir-kbd-i2c.h>
 
 #define HDPVR_MAX 8
@@ -65,10 +66,17 @@ struct hdpvr_options {
 struct hdpvr_device {
 	/* the v4l device for this device */
 	struct video_device	*video_dev;
+	/* the control handler for this device */
+	struct v4l2_ctrl_handler hdl;
 	/* the usb device for this device */
 	struct usb_device	*udev;
 	/* v4l2-device unused */
 	struct v4l2_device	v4l2_dev;
+	struct { /* video mode/bitrate control cluster */
+		struct v4l2_ctrl *video_mode;
+		struct v4l2_ctrl *video_bitrate;
+		struct v4l2_ctrl *video_bitrate_peak;
+	};
 
 	/* the max packet size of the bulk endpoint */
 	size_t			bulk_in_size;
-- 
1.7.10.4

