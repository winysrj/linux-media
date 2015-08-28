Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:54380 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbbH1Ltb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 07:49:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, ricardo.ribalda@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/8] saa7164: convert to the control framework
Date: Fri, 28 Aug 2015 13:48:26 +0200
Message-Id: <1440762513-30457-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
References: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert this driver to the control framework. Note that the VBI device
nodes have no controls as there is nothing to control.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7164/saa7164-encoder.c | 462 +++++-----------------------
 drivers/media/pci/saa7164/saa7164-vbi.c     | 359 ---------------------
 drivers/media/pci/saa7164/saa7164.h         |   2 +
 3 files changed, 81 insertions(+), 742 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 4434e0f..390211b 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -35,24 +35,6 @@ static struct saa7164_tvnorm saa7164_tvnorms[] = {
 	}
 };
 
-static const u32 saa7164_v4l2_ctrls[] = {
-	V4L2_CID_BRIGHTNESS,
-	V4L2_CID_CONTRAST,
-	V4L2_CID_SATURATION,
-	V4L2_CID_HUE,
-	V4L2_CID_AUDIO_VOLUME,
-	V4L2_CID_SHARPNESS,
-	V4L2_CID_MPEG_STREAM_TYPE,
-	V4L2_CID_MPEG_VIDEO_ASPECT,
-	V4L2_CID_MPEG_VIDEO_B_FRAMES,
-	V4L2_CID_MPEG_VIDEO_GOP_SIZE,
-	V4L2_CID_MPEG_AUDIO_MUTE,
-	V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
-	V4L2_CID_MPEG_VIDEO_BITRATE,
-	V4L2_CID_MPEG_VIDEO_BITRATE_PEAK,
-	0
-};
-
 /* Take the encoder configuration form the port struct and
  * flush it to the hardware.
  */
@@ -396,253 +378,46 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_g_ctrl(struct file *file, void *priv,
-	struct v4l2_control *ctl)
-{
-	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
-
-	dprintk(DBGLVL_ENC, "%s(id=%d, value=%d)\n", __func__,
-		ctl->id, ctl->value);
-
-	switch (ctl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		ctl->value = port->ctl_brightness;
-		break;
-	case V4L2_CID_CONTRAST:
-		ctl->value = port->ctl_contrast;
-		break;
-	case V4L2_CID_SATURATION:
-		ctl->value = port->ctl_saturation;
-		break;
-	case V4L2_CID_HUE:
-		ctl->value = port->ctl_hue;
-		break;
-	case V4L2_CID_SHARPNESS:
-		ctl->value = port->ctl_sharpness;
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-		ctl->value = port->ctl_volume;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-	struct v4l2_control *ctl)
+static int saa7164_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
+	struct saa7164_port *port =
+		container_of(ctrl->handler, struct saa7164_port, ctrl_handler);
+	struct saa7164_encoder_params *params = &port->encoder_params;
 	int ret = 0;
 
-	dprintk(DBGLVL_ENC, "%s(id=%d, value=%d)\n", __func__,
-		ctl->id, ctl->value);
-
-	switch (ctl->id) {
+	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		if ((ctl->value >= 0) && (ctl->value <= 255)) {
-			port->ctl_brightness = ctl->value;
-			saa7164_api_set_usercontrol(port,
-				PU_BRIGHTNESS_CONTROL);
-		} else
-			ret = -EINVAL;
+		port->ctl_brightness = ctrl->val;
+		saa7164_api_set_usercontrol(port, PU_BRIGHTNESS_CONTROL);
 		break;
 	case V4L2_CID_CONTRAST:
-		if ((ctl->value >= 0) && (ctl->value <= 255)) {
-			port->ctl_contrast = ctl->value;
-			saa7164_api_set_usercontrol(port, PU_CONTRAST_CONTROL);
-		} else
-			ret = -EINVAL;
+		port->ctl_contrast = ctrl->val;
+		saa7164_api_set_usercontrol(port, PU_CONTRAST_CONTROL);
 		break;
 	case V4L2_CID_SATURATION:
-		if ((ctl->value >= 0) && (ctl->value <= 255)) {
-			port->ctl_saturation = ctl->value;
-			saa7164_api_set_usercontrol(port,
-				PU_SATURATION_CONTROL);
-		} else
-			ret = -EINVAL;
+		port->ctl_saturation = ctrl->val;
+		saa7164_api_set_usercontrol(port, PU_SATURATION_CONTROL);
 		break;
 	case V4L2_CID_HUE:
-		if ((ctl->value >= 0) && (ctl->value <= 255)) {
-			port->ctl_hue = ctl->value;
-			saa7164_api_set_usercontrol(port, PU_HUE_CONTROL);
-		} else
-			ret = -EINVAL;
+		port->ctl_hue = ctrl->val;
+		saa7164_api_set_usercontrol(port, PU_HUE_CONTROL);
 		break;
 	case V4L2_CID_SHARPNESS:
-		if ((ctl->value >= 0) && (ctl->value <= 255)) {
-			port->ctl_sharpness = ctl->value;
-			saa7164_api_set_usercontrol(port, PU_SHARPNESS_CONTROL);
-		} else
-			ret = -EINVAL;
+		port->ctl_sharpness = ctrl->val;
+		saa7164_api_set_usercontrol(port, PU_SHARPNESS_CONTROL);
 		break;
 	case V4L2_CID_AUDIO_VOLUME:
-		if ((ctl->value >= -83) && (ctl->value <= 24)) {
-			port->ctl_volume = ctl->value;
-			saa7164_api_set_audio_volume(port, port->ctl_volume);
-		} else
-			ret = -EINVAL;
+		port->ctl_volume = ctrl->val;
+		saa7164_api_set_audio_volume(port, port->ctl_volume);
 		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-static int saa7164_get_ctrl(struct saa7164_port *port,
-	struct v4l2_ext_control *ctrl)
-{
-	struct saa7164_encoder_params *params = &port->encoder_params;
-
-	switch (ctrl->id) {
 	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		ctrl->value = params->bitrate;
+		params->bitrate = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_STREAM_TYPE:
-		ctrl->value = params->stream_type;
+		params->stream_type = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_AUDIO_MUTE:
-		ctrl->value = params->ctl_mute;
-		break;
-	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		ctrl->value = params->ctl_aspect;
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-		ctrl->value = params->bitrate_mode;
-		break;
-	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
-		ctrl->value = params->refdist;
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
-		ctrl->value = params->bitrate_peak;
-		break;
-	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		ctrl->value = params->gop_size;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int vidioc_g_ext_ctrls(struct file *file, void *priv,
-	struct v4l2_ext_controls *ctrls)
-{
-	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	int i, err = 0;
-
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
-
-			err = saa7164_get_ctrl(port, ctrl);
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
-static int saa7164_try_ctrl(struct v4l2_ext_control *ctrl, int ac3)
-{
-	int ret = -EINVAL;
-
-	switch (ctrl->id) {
-	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		if ((ctrl->value >= ENCODER_MIN_BITRATE) &&
-			(ctrl->value <= ENCODER_MAX_BITRATE))
-			ret = 0;
-		break;
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		if ((ctrl->value == V4L2_MPEG_STREAM_TYPE_MPEG2_PS) ||
-			(ctrl->value == V4L2_MPEG_STREAM_TYPE_MPEG2_TS))
-			ret = 0;
-		break;
-	case V4L2_CID_MPEG_AUDIO_MUTE:
-		if ((ctrl->value >= 0) &&
-			(ctrl->value <= 1))
-			ret = 0;
-		break;
-	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		if ((ctrl->value >= V4L2_MPEG_VIDEO_ASPECT_1x1) &&
-			(ctrl->value <= V4L2_MPEG_VIDEO_ASPECT_221x100))
-			ret = 0;
-		break;
-	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		if ((ctrl->value >= 0) &&
-			(ctrl->value <= 255))
-			ret = 0;
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-		if ((ctrl->value == V4L2_MPEG_VIDEO_BITRATE_MODE_VBR) ||
-			(ctrl->value == V4L2_MPEG_VIDEO_BITRATE_MODE_CBR))
-			ret = 0;
-		break;
-	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
-		if ((ctrl->value >= 1) &&
-			(ctrl->value <= 3))
-			ret = 0;
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
-		if ((ctrl->value >= ENCODER_MIN_BITRATE) &&
-			(ctrl->value <= ENCODER_MAX_BITRATE))
-			ret = 0;
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-static int vidioc_try_ext_ctrls(struct file *file, void *priv,
-	struct v4l2_ext_controls *ctrls)
-{
-	int i, err = 0;
-
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
-
-			err = saa7164_try_ctrl(ctrl, 0);
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
-static int saa7164_set_ctrl(struct saa7164_port *port,
-	struct v4l2_ext_control *ctrl)
-{
-	struct saa7164_encoder_params *params = &port->encoder_params;
-	int ret = 0;
-
-	switch (ctrl->id) {
-	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		params->bitrate = ctrl->value;
-		break;
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		params->stream_type = ctrl->value;
-		break;
-	case V4L2_CID_MPEG_AUDIO_MUTE:
-		params->ctl_mute = ctrl->value;
+		params->ctl_mute = ctrl->val;
 		ret = saa7164_api_audio_mute(port, params->ctl_mute);
 		if (ret != SAA_OK) {
 			printk(KERN_ERR "%s() error, ret = 0x%x\n", __func__,
@@ -651,7 +426,7 @@ static int saa7164_set_ctrl(struct saa7164_port *port,
 		}
 		break;
 	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		params->ctl_aspect = ctrl->value;
+		params->ctl_aspect = ctrl->val;
 		ret = saa7164_api_set_aspect_ratio(port);
 		if (ret != SAA_OK) {
 			printk(KERN_ERR "%s() error, ret = 0x%x\n", __func__,
@@ -660,55 +435,24 @@ static int saa7164_set_ctrl(struct saa7164_port *port,
 		}
 		break;
 	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-		params->bitrate_mode = ctrl->value;
+		params->bitrate_mode = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
-		params->refdist = ctrl->value;
+		params->refdist = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
-		params->bitrate_peak = ctrl->value;
+		params->bitrate_peak = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		params->gop_size = ctrl->value;
+		params->gop_size = ctrl->val;
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
-	/* TODO: Update the hardware */
-
 	return ret;
 }
 
-static int vidioc_s_ext_ctrls(struct file *file, void *priv,
-	struct v4l2_ext_controls *ctrls)
-{
-	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	int i, err = 0;
-
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
-
-			err = saa7164_try_ctrl(ctrl, 0);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
-			err = saa7164_set_ctrl(port, ctrl);
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
 static int vidioc_querycap(struct file *file, void  *priv,
 	struct v4l2_capability *cap)
 {
@@ -802,88 +546,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int fill_queryctrl(struct saa7164_encoder_params *params,
-	struct v4l2_queryctrl *c)
-{
-	switch (c->id) {
-	case V4L2_CID_BRIGHTNESS:
-		return v4l2_ctrl_query_fill(c, 0x0, 0xff, 1, 127);
-	case V4L2_CID_CONTRAST:
-		return v4l2_ctrl_query_fill(c, 0x0, 0xff, 1, 66);
-	case V4L2_CID_SATURATION:
-		return v4l2_ctrl_query_fill(c, 0x0, 0xff, 1, 62);
-	case V4L2_CID_HUE:
-		return v4l2_ctrl_query_fill(c, 0x0, 0xff, 1, 128);
-	case V4L2_CID_SHARPNESS:
-		return v4l2_ctrl_query_fill(c, 0x0, 0x0f, 1, 8);
-	case V4L2_CID_MPEG_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(c, 0x0, 0x01, 1, 0);
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(c, -83, 24, 1, 20);
-	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		return v4l2_ctrl_query_fill(c,
-			ENCODER_MIN_BITRATE, ENCODER_MAX_BITRATE,
-			100000, ENCODER_DEF_BITRATE);
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		return v4l2_ctrl_query_fill(c,
-			V4L2_MPEG_STREAM_TYPE_MPEG2_PS,
-			V4L2_MPEG_STREAM_TYPE_MPEG2_TS,
-			1, V4L2_MPEG_STREAM_TYPE_MPEG2_PS);
-	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		return v4l2_ctrl_query_fill(c,
-			V4L2_MPEG_VIDEO_ASPECT_1x1,
-			V4L2_MPEG_VIDEO_ASPECT_221x100,
-			1, V4L2_MPEG_VIDEO_ASPECT_4x3);
-	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		return v4l2_ctrl_query_fill(c, 1, 255, 1, 15);
-	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-		return v4l2_ctrl_query_fill(c,
-			V4L2_MPEG_VIDEO_BITRATE_MODE_VBR,
-			V4L2_MPEG_VIDEO_BITRATE_MODE_CBR,
-			1, V4L2_MPEG_VIDEO_BITRATE_MODE_VBR);
-	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
-		return v4l2_ctrl_query_fill(c,
-			1, 3, 1, 1);
-	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
-		return v4l2_ctrl_query_fill(c,
-			ENCODER_MIN_BITRATE, ENCODER_MAX_BITRATE,
-			100000, ENCODER_DEF_BITRATE);
-	default:
-		return -EINVAL;
-	}
-}
-
-static int vidioc_queryctrl(struct file *file, void *priv,
-	struct v4l2_queryctrl *c)
-{
-	struct saa7164_encoder_fh *fh = priv;
-	struct saa7164_port *port = fh->port;
-	int i, next;
-	u32 id = c->id;
-
-	memset(c, 0, sizeof(*c));
-
-	next = !!(id & V4L2_CTRL_FLAG_NEXT_CTRL);
-	c->id = id & ~V4L2_CTRL_FLAG_NEXT_CTRL;
-
-	for (i = 0; i < ARRAY_SIZE(saa7164_v4l2_ctrls); i++) {
-		if (next) {
-			if (c->id < saa7164_v4l2_ctrls[i])
-				c->id = saa7164_v4l2_ctrls[i];
-			else
-				continue;
-		}
-
-		if (c->id == saa7164_v4l2_ctrls[i])
-			return fill_queryctrl(&port->encoder_params, c);
-
-		if (c->id < saa7164_v4l2_ctrls[i])
-			break;
-	}
-
-	return -EINVAL;
-}
-
 static int saa7164_encoder_stop_port(struct saa7164_port *port)
 {
 	struct saa7164_dev *dev = port->dev;
@@ -1290,6 +952,10 @@ static unsigned int fops_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
+static const struct v4l2_ctrl_ops saa7164_ctrl_ops = {
+	.s_ctrl = saa7164_s_ctrl,
+};
+
 static const struct v4l2_file_operations mpeg_fops = {
 	.owner		= THIS_MODULE,
 	.open		= fops_open,
@@ -1309,17 +975,11 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_tuner		 = vidioc_s_tuner,
 	.vidioc_g_frequency	 = vidioc_g_frequency,
 	.vidioc_s_frequency	 = vidioc_s_frequency,
-	.vidioc_s_ctrl		 = vidioc_s_ctrl,
-	.vidioc_g_ctrl		 = vidioc_g_ctrl,
 	.vidioc_querycap	 = vidioc_querycap,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap	 = vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap	 = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap	 = vidioc_s_fmt_vid_cap,
-	.vidioc_g_ext_ctrls	 = vidioc_g_ext_ctrls,
-	.vidioc_s_ext_ctrls	 = vidioc_s_ext_ctrls,
-	.vidioc_try_ext_ctrls	 = vidioc_try_ext_ctrls,
-	.vidioc_queryctrl	 = vidioc_queryctrl,
 };
 
 static struct video_device saa7164_mpeg_template = {
@@ -1357,6 +1017,7 @@ static struct video_device *saa7164_encoder_alloc(
 int saa7164_encoder_register(struct saa7164_port *port)
 {
 	struct saa7164_dev *dev = port->dev;
+	struct v4l2_ctrl_handler *hdl = &port->ctrl_handler;
 	int result = -ENODEV;
 
 	dprintk(DBGLVL_ENC, "%s()\n", __func__);
@@ -1381,19 +1042,51 @@ int saa7164_encoder_register(struct saa7164_port *port)
 	port->video_format = EU_VIDEO_FORMAT_MPEG_2;
 	port->audio_format = 0;
 	port->video_resolution = 0;
-	port->ctl_brightness = 127;
-	port->ctl_contrast = 66;
-	port->ctl_hue = 128;
-	port->ctl_saturation = 62;
-	port->ctl_sharpness = 8;
-	port->encoder_params.bitrate = ENCODER_DEF_BITRATE;
-	port->encoder_params.bitrate_peak = ENCODER_DEF_BITRATE;
-	port->encoder_params.bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_CBR;
-	port->encoder_params.stream_type = V4L2_MPEG_STREAM_TYPE_MPEG2_PS;
-	port->encoder_params.ctl_mute = 0;
-	port->encoder_params.ctl_aspect = V4L2_MPEG_VIDEO_ASPECT_4x3;
-	port->encoder_params.refdist = 1;
-	port->encoder_params.gop_size = SAA7164_ENCODER_DEFAULT_GOP_SIZE;
+
+	v4l2_ctrl_handler_init(hdl, 14);
+	v4l2_ctrl_new_std(hdl, &saa7164_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, 0, 255, 1, 127);
+	v4l2_ctrl_new_std(hdl, &saa7164_ctrl_ops,
+			  V4L2_CID_CONTRAST, 0, 255, 1, 66);
+	v4l2_ctrl_new_std(hdl, &saa7164_ctrl_ops,
+			  V4L2_CID_SATURATION, 0, 255, 1, 62);
+	v4l2_ctrl_new_std(hdl, &saa7164_ctrl_ops,
+			  V4L2_CID_HUE, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(hdl, &saa7164_ctrl_ops,
+			  V4L2_CID_SHARPNESS, 0x0, 0x0f, 1, 8);
+	v4l2_ctrl_new_std(hdl, &saa7164_ctrl_ops,
+			  V4L2_CID_MPEG_AUDIO_MUTE, 0x0, 0x01, 1, 0);
+	v4l2_ctrl_new_std(hdl, &saa7164_ctrl_ops,
+			  V4L2_CID_AUDIO_VOLUME, -83, 24, 1, 20);
+	v4l2_ctrl_new_std(hdl, &saa7164_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_BITRATE,
+			  ENCODER_MIN_BITRATE, ENCODER_MAX_BITRATE,
+			  100000, ENCODER_DEF_BITRATE);
+	v4l2_ctrl_new_std_menu(hdl, &saa7164_ctrl_ops,
+			       V4L2_CID_MPEG_STREAM_TYPE,
+			       V4L2_MPEG_STREAM_TYPE_MPEG2_TS, 0,
+			       V4L2_MPEG_STREAM_TYPE_MPEG2_PS);
+	v4l2_ctrl_new_std_menu(hdl, &saa7164_ctrl_ops,
+			       V4L2_CID_MPEG_VIDEO_ASPECT,
+			       V4L2_MPEG_VIDEO_ASPECT_221x100, 0,
+			       V4L2_MPEG_VIDEO_ASPECT_4x3);
+	v4l2_ctrl_new_std(hdl, &saa7164_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 255, 1, 15);
+	v4l2_ctrl_new_std_menu(hdl, &saa7164_ctrl_ops,
+			       V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
+			       V4L2_MPEG_VIDEO_BITRATE_MODE_CBR, 0,
+			       V4L2_MPEG_VIDEO_BITRATE_MODE_VBR);
+	v4l2_ctrl_new_std(hdl, &saa7164_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_B_FRAMES, 1, 3, 1, 1);
+	v4l2_ctrl_new_std(hdl, &saa7164_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_BITRATE_PEAK,
+			  ENCODER_MIN_BITRATE, ENCODER_MAX_BITRATE,
+			  100000, ENCODER_DEF_BITRATE);
+	if (hdl->error) {
+		result = hdl->error;
+		goto failed;
+	}
+
 	port->std = V4L2_STD_NTSC_M;
 
 	if (port->encodernorm.id & V4L2_STD_525_60)
@@ -1412,6 +1105,8 @@ int saa7164_encoder_register(struct saa7164_port *port)
 		goto failed;
 	}
 
+	port->v4l_device->ctrl_handler = hdl;
+	v4l2_ctrl_handler_setup(hdl);
 	video_set_drvdata(port->v4l_device, port);
 	result = video_register_device(port->v4l_device,
 		VFL_TYPE_GRABBER, -1);
@@ -1466,6 +1161,7 @@ void saa7164_encoder_unregister(struct saa7164_port *port)
 
 		port->v4l_device = NULL;
 	}
+	v4l2_ctrl_handler_free(&port->ctrl_handler);
 
 	dprintk(DBGLVL_ENC, "%s(port=%d) done\n", __func__, port->nr);
 }
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index 859fd03..4858f59 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -31,10 +31,6 @@ static struct saa7164_tvnorm saa7164_tvnorms[] = {
 	}
 };
 
-static const u32 saa7164_v4l2_ctrls[] = {
-	0
-};
-
 /* Take the encoder configuration from the port struct and
  * flush it to the hardware.
  */
@@ -368,286 +364,6 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_g_ctrl(struct file *file, void *priv,
-	struct v4l2_control *ctl)
-{
-	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
-
-	dprintk(DBGLVL_VBI, "%s(id=%d, value=%d)\n", __func__,
-		ctl->id, ctl->value);
-
-	switch (ctl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		ctl->value = port->ctl_brightness;
-		break;
-	case V4L2_CID_CONTRAST:
-		ctl->value = port->ctl_contrast;
-		break;
-	case V4L2_CID_SATURATION:
-		ctl->value = port->ctl_saturation;
-		break;
-	case V4L2_CID_HUE:
-		ctl->value = port->ctl_hue;
-		break;
-	case V4L2_CID_SHARPNESS:
-		ctl->value = port->ctl_sharpness;
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-		ctl->value = port->ctl_volume;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-	struct v4l2_control *ctl)
-{
-	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
-	int ret = 0;
-
-	dprintk(DBGLVL_VBI, "%s(id=%d, value=%d)\n", __func__,
-		ctl->id, ctl->value);
-
-	switch (ctl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		if ((ctl->value >= 0) && (ctl->value <= 255)) {
-			port->ctl_brightness = ctl->value;
-			saa7164_api_set_usercontrol(port,
-				PU_BRIGHTNESS_CONTROL);
-		} else
-			ret = -EINVAL;
-		break;
-	case V4L2_CID_CONTRAST:
-		if ((ctl->value >= 0) && (ctl->value <= 255)) {
-			port->ctl_contrast = ctl->value;
-			saa7164_api_set_usercontrol(port, PU_CONTRAST_CONTROL);
-		} else
-			ret = -EINVAL;
-		break;
-	case V4L2_CID_SATURATION:
-		if ((ctl->value >= 0) && (ctl->value <= 255)) {
-			port->ctl_saturation = ctl->value;
-			saa7164_api_set_usercontrol(port,
-				PU_SATURATION_CONTROL);
-		} else
-			ret = -EINVAL;
-		break;
-	case V4L2_CID_HUE:
-		if ((ctl->value >= 0) && (ctl->value <= 255)) {
-			port->ctl_hue = ctl->value;
-			saa7164_api_set_usercontrol(port, PU_HUE_CONTROL);
-		} else
-			ret = -EINVAL;
-		break;
-	case V4L2_CID_SHARPNESS:
-		if ((ctl->value >= 0) && (ctl->value <= 255)) {
-			port->ctl_sharpness = ctl->value;
-			saa7164_api_set_usercontrol(port, PU_SHARPNESS_CONTROL);
-		} else
-			ret = -EINVAL;
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-		if ((ctl->value >= -83) && (ctl->value <= 24)) {
-			port->ctl_volume = ctl->value;
-			saa7164_api_set_audio_volume(port, port->ctl_volume);
-		} else
-			ret = -EINVAL;
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-static int saa7164_get_ctrl(struct saa7164_port *port,
-	struct v4l2_ext_control *ctrl)
-{
-	struct saa7164_vbi_params *params = &port->vbi_params;
-
-	switch (ctrl->id) {
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		ctrl->value = params->stream_type;
-		break;
-	case V4L2_CID_MPEG_AUDIO_MUTE:
-		ctrl->value = params->ctl_mute;
-		break;
-	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		ctrl->value = params->ctl_aspect;
-		break;
-	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
-		ctrl->value = params->refdist;
-		break;
-	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		ctrl->value = params->gop_size;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int vidioc_g_ext_ctrls(struct file *file, void *priv,
-	struct v4l2_ext_controls *ctrls)
-{
-	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	int i, err = 0;
-
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
-
-			err = saa7164_get_ctrl(port, ctrl);
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
-static int saa7164_try_ctrl(struct v4l2_ext_control *ctrl, int ac3)
-{
-	int ret = -EINVAL;
-
-	switch (ctrl->id) {
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		if ((ctrl->value == V4L2_MPEG_STREAM_TYPE_MPEG2_PS) ||
-			(ctrl->value == V4L2_MPEG_STREAM_TYPE_MPEG2_TS))
-			ret = 0;
-		break;
-	case V4L2_CID_MPEG_AUDIO_MUTE:
-		if ((ctrl->value >= 0) &&
-			(ctrl->value <= 1))
-			ret = 0;
-		break;
-	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		if ((ctrl->value >= V4L2_MPEG_VIDEO_ASPECT_1x1) &&
-			(ctrl->value <= V4L2_MPEG_VIDEO_ASPECT_221x100))
-			ret = 0;
-		break;
-	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		if ((ctrl->value >= 0) &&
-			(ctrl->value <= 255))
-			ret = 0;
-		break;
-	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
-		if ((ctrl->value >= 1) &&
-			(ctrl->value <= 3))
-			ret = 0;
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-static int vidioc_try_ext_ctrls(struct file *file, void *priv,
-	struct v4l2_ext_controls *ctrls)
-{
-	int i, err = 0;
-
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
-
-			err = saa7164_try_ctrl(ctrl, 0);
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
-static int saa7164_set_ctrl(struct saa7164_port *port,
-	struct v4l2_ext_control *ctrl)
-{
-	struct saa7164_vbi_params *params = &port->vbi_params;
-	int ret = 0;
-
-	switch (ctrl->id) {
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		params->stream_type = ctrl->value;
-		break;
-	case V4L2_CID_MPEG_AUDIO_MUTE:
-		params->ctl_mute = ctrl->value;
-		ret = saa7164_api_audio_mute(port, params->ctl_mute);
-		if (ret != SAA_OK) {
-			printk(KERN_ERR "%s() error, ret = 0x%x\n", __func__,
-				ret);
-			ret = -EIO;
-		}
-		break;
-	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		params->ctl_aspect = ctrl->value;
-		ret = saa7164_api_set_aspect_ratio(port);
-		if (ret != SAA_OK) {
-			printk(KERN_ERR "%s() error, ret = 0x%x\n", __func__,
-				ret);
-			ret = -EIO;
-		}
-		break;
-	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
-		params->refdist = ctrl->value;
-		break;
-	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		params->gop_size = ctrl->value;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	/* TODO: Update the hardware */
-
-	return ret;
-}
-
-static int vidioc_s_ext_ctrls(struct file *file, void *priv,
-	struct v4l2_ext_controls *ctrls)
-{
-	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	int i, err = 0;
-
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
-
-			err = saa7164_try_ctrl(ctrl, 0);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
-			err = saa7164_set_ctrl(port, ctrl);
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
 static int vidioc_querycap(struct file *file, void  *priv,
 	struct v4l2_capability *cap)
 {
@@ -741,75 +457,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int fill_queryctrl(struct saa7164_vbi_params *params,
-	struct v4l2_queryctrl *c)
-{
-	switch (c->id) {
-	case V4L2_CID_BRIGHTNESS:
-		return v4l2_ctrl_query_fill(c, 0x0, 0xff, 1, 127);
-	case V4L2_CID_CONTRAST:
-		return v4l2_ctrl_query_fill(c, 0x0, 0xff, 1, 66);
-	case V4L2_CID_SATURATION:
-		return v4l2_ctrl_query_fill(c, 0x0, 0xff, 1, 62);
-	case V4L2_CID_HUE:
-		return v4l2_ctrl_query_fill(c, 0x0, 0xff, 1, 128);
-	case V4L2_CID_SHARPNESS:
-		return v4l2_ctrl_query_fill(c, 0x0, 0x0f, 1, 8);
-	case V4L2_CID_MPEG_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(c, 0x0, 0x01, 1, 0);
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(c, -83, 24, 1, 20);
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		return v4l2_ctrl_query_fill(c,
-			V4L2_MPEG_STREAM_TYPE_MPEG2_PS,
-			V4L2_MPEG_STREAM_TYPE_MPEG2_TS,
-			1, V4L2_MPEG_STREAM_TYPE_MPEG2_PS);
-	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		return v4l2_ctrl_query_fill(c,
-			V4L2_MPEG_VIDEO_ASPECT_1x1,
-			V4L2_MPEG_VIDEO_ASPECT_221x100,
-			1, V4L2_MPEG_VIDEO_ASPECT_4x3);
-	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
-		return v4l2_ctrl_query_fill(c, 1, 255, 1, 15);
-	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
-		return v4l2_ctrl_query_fill(c,
-			1, 3, 1, 1);
-	default:
-		return -EINVAL;
-	}
-}
-
-static int vidioc_queryctrl(struct file *file, void *priv,
-	struct v4l2_queryctrl *c)
-{
-	struct saa7164_vbi_fh *fh = priv;
-	struct saa7164_port *port = fh->port;
-	int i, next;
-	u32 id = c->id;
-
-	memset(c, 0, sizeof(*c));
-
-	next = !!(id & V4L2_CTRL_FLAG_NEXT_CTRL);
-	c->id = id & ~V4L2_CTRL_FLAG_NEXT_CTRL;
-
-	for (i = 0; i < ARRAY_SIZE(saa7164_v4l2_ctrls); i++) {
-		if (next) {
-			if (c->id < saa7164_v4l2_ctrls[i])
-				c->id = saa7164_v4l2_ctrls[i];
-			else
-				continue;
-		}
-
-		if (c->id == saa7164_v4l2_ctrls[i])
-			return fill_queryctrl(&port->vbi_params, c);
-
-		if (c->id < saa7164_v4l2_ctrls[i])
-			break;
-	}
-
-	return -EINVAL;
-}
-
 static int saa7164_vbi_stop_port(struct saa7164_port *port)
 {
 	struct saa7164_dev *dev = port->dev;
@@ -1255,17 +902,11 @@ static const struct v4l2_ioctl_ops vbi_ioctl_ops = {
 	.vidioc_s_tuner		 = vidioc_s_tuner,
 	.vidioc_g_frequency	 = vidioc_g_frequency,
 	.vidioc_s_frequency	 = vidioc_s_frequency,
-	.vidioc_s_ctrl		 = vidioc_s_ctrl,
-	.vidioc_g_ctrl		 = vidioc_g_ctrl,
 	.vidioc_querycap	 = vidioc_querycap,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap	 = vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap	 = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap	 = vidioc_s_fmt_vid_cap,
-	.vidioc_g_ext_ctrls	 = vidioc_g_ext_ctrls,
-	.vidioc_s_ext_ctrls	 = vidioc_s_ext_ctrls,
-	.vidioc_try_ext_ctrls	 = vidioc_try_ext_ctrls,
-	.vidioc_queryctrl	 = vidioc_queryctrl,
 	.vidioc_g_fmt_vbi_cap	 = saa7164_vbi_fmt,
 	.vidioc_try_fmt_vbi_cap	 = saa7164_vbi_fmt,
 	.vidioc_s_fmt_vbi_cap	 = saa7164_vbi_fmt,
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index 18906e0..b3828c6 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -64,6 +64,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 
 #include "saa7164-reg.h"
 #include "saa7164-types.h"
@@ -381,6 +382,7 @@ struct saa7164_port {
 	/* Encoder */
 	/* Defaults established in saa7164-encoder.c */
 	struct saa7164_tvnorm encodernorm;
+	struct v4l2_ctrl_handler ctrl_handler;
 	v4l2_std_id std;
 	u32 height;
 	u32 width;
-- 
2.1.4

