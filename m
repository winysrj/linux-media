Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1040 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3CKLqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 18/42] go7007: add audio input ioctls.
Date: Mon, 11 Mar 2013 12:45:56 +0100
Message-Id: <8917bc3bed05f727333c76520f3dc6891b9d0744.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Since we now know what audio inputs there are, we can also get/set and
enumerate them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-v4l2.c |   51 ++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index bab4a31..b79cda8 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -608,9 +608,10 @@ static int vidioc_querycap(struct file *file, void  *priv,
 
 	cap->version = KERNEL_VERSION(0, 9, 8);
 
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
-			    V4L2_CAP_STREAMING; /* | V4L2_CAP_AUDIO; */
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 
+	if (go->board_info->num_aud_inputs)
+		cap->device_caps |= V4L2_CAP_AUDIO;
 	if (go->board_info->flags & GO7007_BOARD_HAS_TUNER)
 		cap->capabilities |= V4L2_CAP_TUNER;
 
@@ -1191,7 +1192,10 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	else
 		inp->type = V4L2_INPUT_TYPE_CAMERA;
 
-	inp->audioset = 0;
+	if (go->board_info->num_aud_inputs)
+		inp->audioset = (1 << go->board_info->num_aud_inputs) - 1;
+	else
+		inp->audioset = 0;
 	inp->tuner = 0;
 	if (go->board_info->sensor_flags & GO7007_SENSOR_TV)
 		inp->std = V4L2_STD_NTSC | V4L2_STD_PAL |
@@ -1212,6 +1216,39 @@ static int vidioc_g_input(struct file *file, void *priv, unsigned int *input)
 	return 0;
 }
 
+static int vidioc_enumaudio(struct file *file, void *fh, struct v4l2_audio *a)
+{
+	struct go7007 *go = video_drvdata(file);
+
+	if (a->index >= go->board_info->num_aud_inputs)
+		return -EINVAL;
+	strlcpy(a->name, go->board_info->aud_inputs[a->index].name, sizeof(a->name));
+	a->capability = V4L2_AUDCAP_STEREO;
+	return 0;
+}
+
+static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
+{
+	struct go7007 *go = video_drvdata(file);
+
+	a->index = go->aud_input;
+	strlcpy(a->name, go->board_info->aud_inputs[go->aud_input].name, sizeof(a->name));
+	a->capability = V4L2_AUDCAP_STEREO;
+	return 0;
+}
+
+static int vidioc_s_audio(struct file *file, void *fh, const struct v4l2_audio *a)
+{
+	struct go7007 *go = video_drvdata(file);
+
+	if (a->index >= go->board_info->num_aud_inputs)
+		return -EINVAL;
+	go->aud_input = a->index;
+	v4l2_subdev_call(go->sd_audio, audio, s_routing,
+			go->board_info->aud_inputs[go->aud_input].audio_input, 0, 0);
+	return 0;
+}
+
 static int vidioc_s_input(struct file *file, void *priv, unsigned int input)
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
@@ -1772,6 +1809,9 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enum_input        = vidioc_enum_input,
 	.vidioc_g_input           = vidioc_g_input,
 	.vidioc_s_input           = vidioc_s_input,
+	.vidioc_enumaudio         = vidioc_enumaudio,
+	.vidioc_g_audio           = vidioc_g_audio,
+	.vidioc_s_audio           = vidioc_s_audio,
 	.vidioc_queryctrl         = vidioc_queryctrl,
 	.vidioc_g_ctrl            = vidioc_g_ctrl,
 	.vidioc_s_ctrl            = vidioc_s_ctrl,
@@ -1816,6 +1856,11 @@ int go7007_v4l2_init(struct go7007 *go)
 		go->video_dev = NULL;
 		return rv;
 	}
+	if (go->board_info->num_aud_inputs == 0) {
+		v4l2_disable_ioctl(go->video_dev, VIDIOC_G_AUDIO);
+		v4l2_disable_ioctl(go->video_dev, VIDIOC_S_AUDIO);
+		v4l2_disable_ioctl(go->video_dev, VIDIOC_ENUMAUDIO);
+	}
 	rv = v4l2_device_register(go->dev, &go->v4l2_dev);
 	if (rv < 0) {
 		video_device_release(go->video_dev);
-- 
1.7.10.4

