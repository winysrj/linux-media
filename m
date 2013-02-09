Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1113 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3BIKBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 03/26] cx231xx: clean up radio support.
Date: Sat,  9 Feb 2013 11:00:33 +0100
Message-Id: <4ef4f24cddb2a39c59499639fc93c8b08baf7781.1360403309.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Radio should not use video or audio inputs.
In addition, fix a bug in radio_g_tuner where s_tuner was called in the tuner
subdev instead of g_tuner.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |   79 +++++++----------------------
 1 file changed, 18 insertions(+), 61 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 794b83c..0436b12 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1874,20 +1874,24 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, cx231xx_boards[dev->model].name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
-	cap->device_caps =
-		V4L2_CAP_AUDIO		|
-		V4L2_CAP_READWRITE	|
-		V4L2_CAP_STREAMING;
-
-	if (vdev->vfl_type == VFL_TYPE_VBI)
-		cap->device_caps |= V4L2_CAP_VBI_CAPTURE;
-	else
-		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
+	if (vdev->vfl_type == VFL_TYPE_RADIO)
+		cap->device_caps = V4L2_CAP_RADIO;
+	else {
+		cap->device_caps = V4L2_CAP_AUDIO | V4L2_CAP_READWRITE |
+			V4L2_CAP_STREAMING;
+		if (vdev->vfl_type == VFL_TYPE_VBI)
+			cap->device_caps |= V4L2_CAP_VBI_CAPTURE;
+		else
+			cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
+	}
 	if (dev->tuner_type != TUNER_ABSENT)
 		cap->device_caps |= V4L2_CAP_TUNER;
 	cap->capabilities = cap->device_caps |
 		V4L2_CAP_VBI_CAPTURE | V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_DEVICE_CAPS;
+		V4L2_CAP_AUDIO | V4L2_CAP_READWRITE |
+		V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;
+	if (dev->radio_dev)
+		cap->capabilities |= V4L2_CAP_RADIO;
 
 	return 0;
 }
@@ -2054,53 +2058,19 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 /* RADIO ESPECIFIC IOCTLS                                      */
 /* ----------------------------------------------------------- */
 
-static int radio_querycap(struct file *file, void *priv,
-			  struct v4l2_capability *cap)
-{
-	struct cx231xx *dev = ((struct cx231xx_fh *)priv)->dev;
-
-	strlcpy(cap->driver, "cx231xx", sizeof(cap->driver));
-	strlcpy(cap->card, cx231xx_boards[dev->model].name, sizeof(cap->card));
-	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
-
-	cap->capabilities = V4L2_CAP_TUNER;
-	return 0;
-}
-
 static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct cx231xx *dev = ((struct cx231xx_fh *)priv)->dev;
 
-	if (unlikely(t->index > 0))
+	if (t->index)
 		return -EINVAL;
 
 	strcpy(t->name, "Radio");
-	t->type = V4L2_TUNER_RADIO;
-
-	call_all(dev, tuner, s_tuner, t);
-
-	return 0;
-}
 
-static int radio_enum_input(struct file *file, void *priv, struct v4l2_input *i)
-{
-	if (i->index != 0)
-		return -EINVAL;
-	strcpy(i->name, "Radio");
-	i->type = V4L2_INPUT_TYPE_TUNER;
-
-	return 0;
-}
-
-static int radio_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
-{
-	if (unlikely(a->index))
-		return -EINVAL;
+	call_all(dev, tuner, g_tuner, t);
 
-	strcpy(a->name, "Radio");
 	return 0;
 }
-
 static int radio_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct cx231xx *dev = ((struct cx231xx_fh *)priv)->dev;
@@ -2113,16 +2083,6 @@ static int radio_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	return 0;
 }
 
-static int radio_s_audio(struct file *file, void *fh, const struct v4l2_audio *a)
-{
-	return 0;
-}
-
-static int radio_s_input(struct file *file, void *fh, unsigned int i)
-{
-	return 0;
-}
-
 static int radio_queryctrl(struct file *file, void *priv,
 			   struct v4l2_queryctrl *c)
 {
@@ -2551,18 +2511,15 @@ static const struct v4l2_file_operations radio_fops = {
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
-	.vidioc_querycap    = radio_querycap,
+	.vidioc_querycap    = vidioc_querycap,
 	.vidioc_g_tuner     = radio_g_tuner,
-	.vidioc_enum_input  = radio_enum_input,
-	.vidioc_g_audio     = radio_g_audio,
 	.vidioc_s_tuner     = radio_s_tuner,
-	.vidioc_s_audio     = radio_s_audio,
-	.vidioc_s_input     = radio_s_input,
 	.vidioc_queryctrl   = radio_queryctrl,
 	.vidioc_g_ctrl      = vidioc_g_ctrl,
 	.vidioc_s_ctrl      = vidioc_s_ctrl,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
+	.vidioc_g_chip_ident = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register  = vidioc_g_register,
 	.vidioc_s_register  = vidioc_s_register,
-- 
1.7.10.4

