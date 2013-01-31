Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4837 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3AaKZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 14/18] tlg2300: implement the control framework.
Date: Thu, 31 Jan 2013 11:25:32 +0100
Message-Id: <36ec60bc7420a183eab3a2637f187576b9cea780.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
References: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-common.h |    1 +
 drivers/media/usb/tlg2300/pd-video.c  |  128 +++++++++++----------------------
 2 files changed, 41 insertions(+), 88 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-common.h b/drivers/media/usb/tlg2300/pd-common.h
index 55fe66e..cb5cb0f 100644
--- a/drivers/media/usb/tlg2300/pd-common.h
+++ b/drivers/media/usb/tlg2300/pd-common.h
@@ -64,6 +64,7 @@ struct running_context {
 struct video_data {
 	/* v4l2 video device */
 	struct video_device	v_dev;
+	struct v4l2_ctrl_handler ctrl_handler;
 
 	/* the working context */
 	struct running_context	context;
diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index 122f299..849c4bb 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -8,6 +8,7 @@
 
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-ctrls.h>
 
 #include "pd-common.h"
 #include "vendorcmds.h"
@@ -82,31 +83,6 @@ static const struct pd_input pd_inputs[] = {
 };
 static const unsigned int POSEIDON_INPUTS = ARRAY_SIZE(pd_inputs);
 
-struct poseidon_control {
-	struct v4l2_queryctrl v4l2_ctrl;
-	enum cmd_custom_param_id vc_id;
-};
-
-static struct poseidon_control controls[] = {
-	{
-		{ V4L2_CID_BRIGHTNESS, V4L2_CTRL_TYPE_INTEGER,
-			"brightness", 0, 10000, 1, 100, 0, },
-		CUST_PARM_ID_BRIGHTNESS_CTRL
-	}, {
-		{ V4L2_CID_CONTRAST, V4L2_CTRL_TYPE_INTEGER,
-			"contrast", 0, 10000, 1, 100, 0, },
-		CUST_PARM_ID_CONTRAST_CTRL,
-	}, {
-		{ V4L2_CID_HUE, V4L2_CTRL_TYPE_INTEGER,
-			"hue", 0, 10000, 1, 100, 0, },
-		CUST_PARM_ID_HUE_CTRL,
-	}, {
-		{ V4L2_CID_SATURATION, V4L2_CTRL_TYPE_INTEGER,
-			"saturation", 0, 10000, 1, 100, 0, },
-		CUST_PARM_ID_SATURATION_CTRL,
-	},
-};
-
 struct video_std_to_audio_std {
 	v4l2_std_id	video_std;
 	int 		audio_std;
@@ -940,68 +916,28 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
 	return 0;
 }
 
-static struct poseidon_control *check_control_id(u32 id)
-{
-	struct poseidon_control *control = &controls[0];
-	int array_size = ARRAY_SIZE(controls);
-
-	for (; control < &controls[array_size]; control++)
-		if (control->v4l2_ctrl.id  == id)
-			return control;
-	return NULL;
-}
-
-static int vidioc_queryctrl(struct file *file, void *fh,
-			struct v4l2_queryctrl *a)
-{
-	struct poseidon_control *control = NULL;
-
-	control = check_control_id(a->id);
-	if (!control)
-		return -EINVAL;
-
-	*a = control->v4l2_ctrl;
-	return 0;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *ctrl)
-{
-	struct front_face *front = fh;
-	struct poseidon *pd = front->pd;
-	struct poseidon_control *control = NULL;
-	struct tuner_custom_parameter_s tuner_param;
-	s32 ret = 0, cmd_status;
-
-	control = check_control_id(ctrl->id);
-	if (!control)
-		return -EINVAL;
-
-	mutex_lock(&pd->lock);
-	ret = send_get_req(pd, TUNER_CUSTOM_PARAMETER, control->vc_id,
-			&tuner_param, &cmd_status, sizeof(tuner_param));
-	mutex_unlock(&pd->lock);
-
-	if (ret || cmd_status)
-		return -1;
-
-	ctrl->value = tuner_param.param_value;
-	return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
+static int tlg_s_ctrl(struct v4l2_ctrl *c)
 {
+	struct poseidon *pd = container_of(c->handler, struct poseidon,
+						video_data.ctrl_handler);
 	struct tuner_custom_parameter_s param = {0};
-	struct poseidon_control *control = NULL;
-	struct front_face *front	= fh;
-	struct poseidon *pd		= front->pd;
 	s32 ret = 0, cmd_status, params;
 
-	control = check_control_id(a->id);
-	if (!control)
-		return -EINVAL;
-
-	param.param_value = a->value;
-	param.param_id	= control->vc_id;
+	switch (c->id) {
+	case V4L2_CID_BRIGHTNESS:
+		param.param_id = CUST_PARM_ID_BRIGHTNESS_CTRL;
+		break;
+	case V4L2_CID_CONTRAST:
+		param.param_id = CUST_PARM_ID_CONTRAST_CTRL;
+		break;
+	case V4L2_CID_HUE:
+		param.param_id = CUST_PARM_ID_HUE_CTRL;
+		break;
+	case V4L2_CID_SATURATION:
+		param.param_id = CUST_PARM_ID_SATURATION_CTRL;
+		break;
+	}
+	param.param_value = c->val;
 	params = *(s32 *)&param; /* temp code */
 
 	mutex_lock(&pd->lock);
@@ -1587,11 +1523,6 @@ static const struct v4l2_ioctl_ops pd_video_ioctl_ops = {
 	/* Stream on/off */
 	.vidioc_streamon	= vidioc_streamon,
 	.vidioc_streamoff	= vidioc_streamoff,
-
-	/* Control handling */
-	.vidioc_queryctrl	= vidioc_queryctrl,
-	.vidioc_g_ctrl		= vidioc_g_ctrl,
-	.vidioc_s_ctrl		= vidioc_s_ctrl,
 };
 
 static struct video_device pd_video_template = {
@@ -1603,6 +1534,10 @@ static struct video_device pd_video_template = {
 	.ioctl_ops = &pd_video_ioctl_ops,
 };
 
+static const struct v4l2_ctrl_ops tlg_ctrl_ops = {
+	.s_ctrl = tlg_s_ctrl,
+};
+
 void pd_video_exit(struct poseidon *pd)
 {
 	struct video_data *video = &pd->video_data;
@@ -1610,6 +1545,7 @@ void pd_video_exit(struct poseidon *pd)
 
 	video_unregister_device(&video->v_dev);
 	video_unregister_device(&vbi->v_dev);
+	v4l2_ctrl_handler_free(&video->ctrl_handler);
 	log();
 }
 
@@ -1617,12 +1553,27 @@ int pd_video_init(struct poseidon *pd)
 {
 	struct video_data *video = &pd->video_data;
 	struct vbi_data *vbi	= &pd->vbi_data;
+	struct v4l2_ctrl_handler *hdl = &video->ctrl_handler;
 	u32 freq = TUNER_FREQ_MIN / 62500;
 	int ret = -ENOMEM;
 
+	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_new_std(hdl, &tlg_ctrl_ops, V4L2_CID_BRIGHTNESS,
+			0, 10000, 1, 100);
+	v4l2_ctrl_new_std(hdl, &tlg_ctrl_ops, V4L2_CID_CONTRAST,
+			0, 10000, 1, 100);
+	v4l2_ctrl_new_std(hdl, &tlg_ctrl_ops, V4L2_CID_HUE,
+			0, 10000, 1, 100);
+	v4l2_ctrl_new_std(hdl, &tlg_ctrl_ops, V4L2_CID_SATURATION,
+			0, 10000, 1, 100);
+	if (hdl->error) {
+		v4l2_ctrl_handler_free(hdl);
+		return hdl->error;
+	}
 	set_frequency(pd, &freq);
 	video->v_dev = pd_video_template;
 	video->v_dev.v4l2_dev = &pd->v4l2_dev;
+	video->v_dev.ctrl_handler = hdl;
 	video_set_drvdata(&video->v_dev, pd);
 
 	ret = video_register_device(&video->v_dev, VFL_TYPE_GRABBER, -1);
@@ -1632,6 +1583,7 @@ int pd_video_init(struct poseidon *pd)
 	/* VBI uses the same template as video */
 	vbi->v_dev = pd_video_template;
 	vbi->v_dev.v4l2_dev = &pd->v4l2_dev;
+	vbi->v_dev.ctrl_handler = hdl;
 	video_set_drvdata(&vbi->v_dev, pd);
 	ret = video_register_device(&vbi->v_dev, VFL_TYPE_VBI, -1);
 	if (ret != 0)
-- 
1.7.10.4

