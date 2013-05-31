Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3248 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3EaKDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Fabio Belavenuto <belavenuto@gmail.com>
Subject: [PATCH 06/21] radio-tea5764: convert to the control framework.
Date: Fri, 31 May 2013 12:02:26 +0200
Message-Id: <1369994561-25236-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Fabio Belavenuto <belavenuto@gmail.com>
---
 drivers/media/radio/radio-tea5764.c |   79 ++++++++++++-----------------------
 1 file changed, 26 insertions(+), 53 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 4e0bf64..5c47a97 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -40,6 +40,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 
 #define DRIVER_VERSION	"0.0.2"
 
@@ -139,7 +140,8 @@ static int radio_nr = -1;
 static int use_xtal = RADIO_TEA5764_XTAL;
 
 struct tea5764_device {
-	struct v4l2_device v4l2_dev;
+	struct v4l2_device		v4l2_dev;
+	struct v4l2_ctrl_handler	ctrl_handler;
 	struct i2c_client		*i2c_client;
 	struct video_device		vdev;
 	struct tea5764_regs		regs;
@@ -189,18 +191,6 @@ static int tea5764_i2c_write(struct tea5764_device *radio)
 	return 0;
 }
 
-/* V4L2 code related */
-static struct v4l2_queryctrl radio_qctrl[] = {
-	{
-		.id            = V4L2_CID_AUDIO_MUTE,
-		.name          = "Mute",
-		.minimum       = 0,
-		.maximum       = 1,
-		.default_value = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	}
-};
-
 static void tea5764_power_up(struct tea5764_device *radio)
 {
 	struct tea5764_regs *r = &radio->regs;
@@ -293,11 +283,6 @@ static void tea5764_mute(struct tea5764_device *radio, int on)
 		tea5764_i2c_write(radio);
 }
 
-static int tea5764_is_muted(struct tea5764_device *radio)
-{
-	return radio->regs.tnctrl & TEA5764_TNCTRL_MU;
-}
-
 /* V4L2 vidioc */
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *v)
@@ -391,42 +376,14 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *qc)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(radio_qctrl); i++) {
-		if (qc->id && qc->id == radio_qctrl[i].id) {
-			memcpy(qc, &(radio_qctrl[i]), sizeof(*qc));
-			return 0;
-		}
-	}
-	return -EINVAL;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-			    struct v4l2_control *ctrl)
-{
-	struct tea5764_device *radio = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		tea5764_i2c_read(radio);
-		ctrl->value = tea5764_is_muted(radio) ? 1 : 0;
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-			    struct v4l2_control *ctrl)
+static int tea5764_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct tea5764_device *radio = video_drvdata(file);
+	struct tea5764_device *radio =
+		container_of(ctrl->handler, struct tea5764_device, ctrl_handler);
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		tea5764_mute(radio, ctrl->value);
+		tea5764_mute(radio, ctrl->val);
 		return 0;
 	}
 	return -EINVAL;
@@ -465,6 +422,10 @@ static int vidioc_s_audio(struct file *file, void *priv,
 	return 0;
 }
 
+static const struct v4l2_ctrl_ops tea5764_ctrl_ops = {
+	.s_ctrl = tea5764_s_ctrl,
+};
+
 /* File system interface */
 static const struct v4l2_file_operations tea5764_fops = {
 	.owner		= THIS_MODULE,
@@ -481,9 +442,6 @@ static const struct v4l2_ioctl_ops tea5764_ioctl_ops = {
 	.vidioc_s_input     = vidioc_s_input,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
-	.vidioc_queryctrl   = vidioc_queryctrl,
-	.vidioc_g_ctrl      = vidioc_g_ctrl,
-	.vidioc_s_ctrl      = vidioc_s_ctrl,
 };
 
 /* V4L2 interface */
@@ -500,6 +458,7 @@ static int tea5764_i2c_probe(struct i2c_client *client,
 {
 	struct tea5764_device *radio;
 	struct v4l2_device *v4l2_dev;
+	struct v4l2_ctrl_handler *hdl;
 	struct tea5764_regs *r;
 	int ret;
 
@@ -514,6 +473,18 @@ static int tea5764_i2c_probe(struct i2c_client *client,
 		v4l2_err(v4l2_dev, "could not register v4l2_device\n");
 		goto errfr;
 	}
+
+	hdl = &radio->ctrl_handler;
+	v4l2_ctrl_handler_init(hdl, 1);
+	v4l2_ctrl_new_std(hdl, &tea5764_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+	v4l2_dev->ctrl_handler = hdl;
+	if (hdl->error) {
+		ret = hdl->error;
+		v4l2_err(v4l2_dev, "Could not register controls\n");
+		goto errunreg;
+	}
+
 	mutex_init(&radio->mutex);
 	radio->i2c_client = client;
 	ret = tea5764_i2c_read(radio);
@@ -550,6 +521,7 @@ static int tea5764_i2c_probe(struct i2c_client *client,
 	PINFO("registered.");
 	return 0;
 errunreg:
+	v4l2_ctrl_handler_free(hdl);
 	v4l2_device_unregister(v4l2_dev);
 errfr:
 	kfree(radio);
@@ -564,6 +536,7 @@ static int tea5764_i2c_remove(struct i2c_client *client)
 	if (radio) {
 		tea5764_power_down(radio);
 		video_unregister_device(&radio->vdev);
+		v4l2_ctrl_handler_free(&radio->ctrl_handler);
 		v4l2_device_unregister(&radio->v4l2_dev);
 		kfree(radio);
 	}
-- 
1.7.10.4

