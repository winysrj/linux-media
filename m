Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4875 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3BAMRb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 07:17:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/6] tm6000: fix querycap and input/tuner compliance issues.
Date: Fri,  1 Feb 2013 13:17:16 +0100
Message-Id: <db596a5954282c998c516d9a8ebd719df71549b3.1359720708.git.hans.verkuil@cisco.com>
In-Reply-To: <1359721041-5133-1-git-send-email-hverkuil@xs4all.nl>
References: <1359721041-5133-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- add device_caps support
- fix bus_info
- fix numerous tuner-related problems due to incorrect tests
  and setting v4l2_tuner fields to wrong values.
- remove (audio) input support from the radio: it doesn't belong
  there. This also fixed a nasty issue where opening the radio
  would set dev->input to 5 for no good reason. This was never
  set back to a valid TV input after closing the radio device,
  thus leaving it at 5 which is out of bounds of the vinput
  card array.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tm6000/tm6000-video.c |  147 +++++++------------------------
 1 file changed, 31 insertions(+), 116 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index e3c567c..7a653b2 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -948,16 +948,21 @@ static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
 	struct tm6000_core *dev = ((struct tm6000_fh *)priv)->dev;
+	struct video_device *vdev = video_devdata(file);
 
 	strlcpy(cap->driver, "tm6000", sizeof(cap->driver));
 	strlcpy(cap->card, "Trident TVMaster TM5600/6000/6010", sizeof(cap->card));
-	cap->capabilities =	V4L2_CAP_VIDEO_CAPTURE |
-				V4L2_CAP_STREAMING     |
-				V4L2_CAP_AUDIO         |
-				V4L2_CAP_READWRITE;
-
+	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	if (dev->tuner_type != TUNER_ABSENT)
-		cap->capabilities |= V4L2_CAP_TUNER;
+		cap->device_caps |= V4L2_CAP_TUNER;
+	if (vdev->vfl_type == VFL_TYPE_GRABBER)
+		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE |
+				V4L2_CAP_STREAMING |
+				V4L2_CAP_READWRITE;
+	else
+		cap->device_caps |= V4L2_CAP_RADIO;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
+		V4L2_CAP_RADIO | V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
 
 	return 0;
 }
@@ -965,7 +970,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
-	if (unlikely(f->index >= ARRAY_SIZE(format)))
+	if (f->index >= ARRAY_SIZE(format))
 		return -EINVAL;
 
 	strlcpy(f->description, format[f->index].name, sizeof(f->description));
@@ -1301,14 +1306,14 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	struct tm6000_fh   *fh  = priv;
 	struct tm6000_core *dev = fh->dev;
 
-	if (unlikely(UNSET == dev->tuner_type))
-		return -EINVAL;
+	if (UNSET == dev->tuner_type)
+		return -ENOTTY;
 	if (0 != t->index)
 		return -EINVAL;
 
 	strcpy(t->name, "Television");
 	t->type       = V4L2_TUNER_ANALOG_TV;
-	t->capability = V4L2_TUNER_CAP_NORM;
+	t->capability = V4L2_TUNER_CAP_NORM | V4L2_TUNER_CAP_STEREO;
 	t->rangehigh  = 0xffffffffUL;
 	t->rxsubchans = V4L2_TUNER_SUB_STEREO;
 
@@ -1326,11 +1331,14 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	struct tm6000_core *dev = fh->dev;
 
 	if (UNSET == dev->tuner_type)
-		return -EINVAL;
+		return -ENOTTY;
 	if (0 != t->index)
 		return -EINVAL;
 
-	dev->amode = t->audmode;
+	if (t->audmode > V4L2_TUNER_MODE_STEREO)
+		dev->amode = V4L2_TUNER_MODE_STEREO;
+	else
+		dev->amode = t->audmode;
 	dprintk(dev, 3, "audio mode: %x\n", t->audmode);
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
@@ -1344,10 +1352,11 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	struct tm6000_fh   *fh  = priv;
 	struct tm6000_core *dev = fh->dev;
 
-	if (unlikely(UNSET == dev->tuner_type))
+	if (UNSET == dev->tuner_type)
+		return -ENOTTY;
+	if (f->tuner)
 		return -EINVAL;
 
-	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	f->frequency = dev->freq;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_frequency, f);
@@ -1361,13 +1370,9 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	struct tm6000_fh   *fh  = priv;
 	struct tm6000_core *dev = fh->dev;
 
-	if (unlikely(UNSET == dev->tuner_type))
-		return -EINVAL;
-	if (unlikely(f->tuner != 0))
-		return -EINVAL;
-	if (0 == fh->radio && V4L2_TUNER_ANALOG_TV != f->type)
-		return -EINVAL;
-	if (1 == fh->radio && V4L2_TUNER_RADIO != f->type)
+	if (UNSET == dev->tuner_type)
+		return -ENOTTY;
+	if (f->tuner != 0)
 		return -EINVAL;
 
 	dev->freq = f->frequency;
@@ -1376,27 +1381,6 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-static int radio_querycap(struct file *file, void *priv,
-					struct v4l2_capability *cap)
-{
-	struct tm6000_fh *fh = file->private_data;
-	struct tm6000_core *dev = fh->dev;
-
-	strcpy(cap->driver, "tm6000");
-	strlcpy(cap->card, dev->name, sizeof(dev->name));
-	sprintf(cap->bus_info, "USB%04x:%04x",
-		le16_to_cpu(dev->udev->descriptor.idVendor),
-		le16_to_cpu(dev->udev->descriptor.idProduct));
-	cap->version = dev->dev_type;
-	cap->capabilities = V4L2_CAP_TUNER |
-			V4L2_CAP_AUDIO     |
-			V4L2_CAP_RADIO     |
-			V4L2_CAP_READWRITE |
-			V4L2_CAP_STREAMING;
-
-	return 0;
-}
-
 static int radio_g_tuner(struct file *file, void *priv,
 					struct v4l2_tuner *t)
 {
@@ -1409,7 +1393,9 @@ static int radio_g_tuner(struct file *file, void *priv,
 	memset(t, 0, sizeof(*t));
 	strcpy(t->name, "Radio");
 	t->type = V4L2_TUNER_RADIO;
+	t->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
 	t->rxsubchans = V4L2_TUNER_SUB_STEREO;
+	t->audmode = V4L2_TUNER_MODE_STEREO;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
 
@@ -1424,78 +1410,14 @@ static int radio_s_tuner(struct file *file, void *priv,
 
 	if (0 != t->index)
 		return -EINVAL;
+	if (t->audmode > V4L2_TUNER_MODE_STEREO)
+		t->audmode = V4L2_TUNER_MODE_STEREO;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
 
 	return 0;
 }
 
-static int radio_enum_input(struct file *file, void *priv,
-					struct v4l2_input *i)
-{
-	struct tm6000_fh *fh = priv;
-	struct tm6000_core *dev = fh->dev;
-
-	if (i->index != 0)
-		return -EINVAL;
-
-	if (!dev->rinput.type)
-		return -EINVAL;
-
-	strcpy(i->name, "Radio");
-	i->type = V4L2_INPUT_TYPE_TUNER;
-
-	return 0;
-}
-
-static int radio_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	struct tm6000_fh *fh = priv;
-	struct tm6000_core *dev = fh->dev;
-
-	if (dev->input != 5)
-		return -EINVAL;
-
-	*i = dev->input - 5;
-
-	return 0;
-}
-
-static int radio_g_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
-{
-	memset(a, 0, sizeof(*a));
-	strcpy(a->name, "Radio");
-	return 0;
-}
-
-static int radio_s_audio(struct file *file, void *priv,
-					const struct v4l2_audio *a)
-{
-	return 0;
-}
-
-static int radio_s_input(struct file *filp, void *priv, unsigned int i)
-{
-	struct tm6000_fh *fh = priv;
-	struct tm6000_core *dev = fh->dev;
-
-	if (i)
-		return -EINVAL;
-
-	if (!dev->rinput.type)
-		return -EINVAL;
-
-	dev->input = i + 5;
-
-	return 0;
-}
-
-static int radio_s_std(struct file *file, void *fh, v4l2_std_id *norm)
-{
-	return 0;
-}
-
 static int radio_queryctrl(struct file *file, void *priv,
 					struct v4l2_queryctrl *c)
 {
@@ -1599,7 +1521,6 @@ static int __tm6000_open(struct file *file)
 				sizeof(struct tm6000_buffer), fh, &dev->lock);
 	} else {
 		dprintk(dev, V4L2_DEBUG_OPEN, "video_open: setting radio device\n");
-		dev->input = 5;
 		tm6000_set_audio_rinput(dev);
 		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_radio);
 		tm6000_prepare_isoc(dev);
@@ -1789,16 +1710,10 @@ static const struct v4l2_file_operations radio_fops = {
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
-	.vidioc_querycap	= radio_querycap,
+	.vidioc_querycap	= vidioc_querycap,
 	.vidioc_g_tuner		= radio_g_tuner,
-	.vidioc_enum_input	= radio_enum_input,
-	.vidioc_g_audio		= radio_g_audio,
 	.vidioc_s_tuner		= radio_s_tuner,
-	.vidioc_s_audio		= radio_s_audio,
-	.vidioc_s_input		= radio_s_input,
-	.vidioc_s_std		= radio_s_std,
 	.vidioc_queryctrl	= radio_queryctrl,
-	.vidioc_g_input		= radio_g_input,
 	.vidioc_g_ctrl		= vidioc_g_ctrl,
 	.vidioc_s_ctrl		= vidioc_s_ctrl,
 	.vidioc_g_frequency	= vidioc_g_frequency,
-- 
1.7.10.4

