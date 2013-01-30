Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1400 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3A3Oya (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 09:54:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/6] radio-miropcm20: convert to the control framework.
Date: Wed, 30 Jan 2013 15:54:01 +0100
Message-Id: <cf16454a3bd6b787b011728f6a04c6fa2695bd58.1359557431.git.hans.verkuil@cisco.com>
In-Reply-To: <1359557644-10982-1-git-send-email-hverkuil@xs4all.nl>
References: <1359557644-10982-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6fc0e0fabcd9ccf60c95ed5cd9c7a08834b43f9b.1359557431.git.hans.verkuil@cisco.com>
References: <6fc0e0fabcd9ccf60c95ed5cd9c7a08834b43f9b.1359557431.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-miropcm20.c |   64 ++++++++++++++-------------------
 1 file changed, 26 insertions(+), 38 deletions(-)

diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 4b7c164..061ebcf 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -17,6 +17,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 #include <sound/aci.h>
 
 static int radio_nr = -1;
@@ -30,6 +31,7 @@ MODULE_PARM_DESC(mono, "Force tuner into mono mode.");
 struct pcm20 {
 	struct v4l2_device v4l2_dev;
 	struct video_device vdev;
+	struct v4l2_ctrl_handler ctrl_handler;
 	unsigned long freq;
 	int muted;
 	struct snd_miro_aci *aci;
@@ -138,44 +140,16 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-				struct v4l2_queryctrl *qc)
+static int pcm20_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
-	}
-	return -EINVAL;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct pcm20 *dev = video_drvdata(file);
+	struct pcm20 *dev = container_of(ctrl->handler, struct pcm20, ctrl_handler);
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = dev->muted;
-		break;
-	default:
-		return -EINVAL;
+		pcm20_mute(dev, ctrl->val);
+		return 0;
 	}
-	return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct pcm20 *dev = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		pcm20_mute(dev, ctrl->value);
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
+	return -EINVAL;
 }
 
 static const struct v4l2_ioctl_ops pcm20_ioctl_ops = {
@@ -184,15 +158,17 @@ static const struct v4l2_ioctl_ops pcm20_ioctl_ops = {
 	.vidioc_s_tuner     = vidioc_s_tuner,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
-	.vidioc_queryctrl   = vidioc_queryctrl,
-	.vidioc_g_ctrl      = vidioc_g_ctrl,
-	.vidioc_s_ctrl      = vidioc_s_ctrl,
+};
+
+static const struct v4l2_ctrl_ops pcm20_ctrl_ops = {
+	.s_ctrl = pcm20_s_ctrl,
 };
 
 static int __init pcm20_init(void)
 {
 	struct pcm20 *dev = &pcm20_card;
 	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
+	struct v4l2_ctrl_handler *hdl;
 	int res;
 
 	dev->aci = snd_aci_get_aci();
@@ -210,6 +186,16 @@ static int __init pcm20_init(void)
 		return -EINVAL;
 	}
 
+	hdl = &dev->ctrl_handler;
+	v4l2_ctrl_handler_init(hdl, 1);
+	v4l2_ctrl_new_std(hdl, &pcm20_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+	v4l2_dev->ctrl_handler = hdl;
+	if (hdl->error) {
+		res = hdl->error;
+		v4l2_err(v4l2_dev, "Could not register control\n");
+		goto err_hdl;
+	}
 	strlcpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
 	dev->vdev.v4l2_dev = v4l2_dev;
 	dev->vdev.fops = &pcm20_fops;
@@ -219,11 +205,12 @@ static int __init pcm20_init(void)
 	video_set_drvdata(&dev->vdev, dev);
 
 	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0)
-		goto fail;
+		goto err_hdl;
 
 	v4l2_info(v4l2_dev, "Mirosound PCM20 Radio tuner\n");
 	return 0;
-fail:
+err_hdl:
+	v4l2_ctrl_handler_free(hdl);
 	v4l2_device_unregister(v4l2_dev);
 	return -EINVAL;
 }
@@ -237,6 +224,7 @@ static void __exit pcm20_cleanup(void)
 	struct pcm20 *dev = &pcm20_card;
 
 	video_unregister_device(&dev->vdev);
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	v4l2_device_unregister(&dev->v4l2_dev);
 }
 
-- 
1.7.10.4

