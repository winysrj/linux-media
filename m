Return-path: <mchehab@gaivota>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4800 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab1ACNyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 08:54:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: David Ellingsworth <david@identd.dyndns.org>
Subject: [RFC PATCH 4/4] dsbr100: ensure correct disconnect sequence.
Date: Mon,  3 Jan 2011 14:54:32 +0100
Message-Id: <05d3d9e5c8a6d5e631a41899d76cd33c061a0a21.1294062751.git.hverkuil@xs4all.nl>
In-Reply-To: <1294062872-8312-1-git-send-email-hverkuil@xs4all.nl>
References: <1294062872-8312-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <adec9ffda2cd47023cde5d0beda01fc84bd867f6.1294062751.git.hverkuil@xs4all.nl>
References: <adec9ffda2cd47023cde5d0beda01fc84bd867f6.1294062751.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/dsbr100.c |   58 ++++++++--------------------------------
 1 files changed, 12 insertions(+), 46 deletions(-)

diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index bf2dd6f..b5dff79 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -129,7 +129,7 @@ devices, that would be 76 and 91.  */
 #define STARTED	0
 #define STOPPED	1
 
-#define videodev_to_radio(d) container_of(d, struct dsbr100_device, videodev)
+#define v4l2_dev_to_radio(d) container_of(d, struct dsbr100_device, v4l2_dev)
 
 static int usb_dsbr100_probe(struct usb_interface *intf,
 			     const struct usb_device_id *id);
@@ -151,7 +151,6 @@ struct dsbr100_device {
 	struct mutex v4l2_lock;
 	int curfreq;
 	int stereo;
-	int removed;
 	int status;
 };
 
@@ -346,10 +345,6 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 {
 	struct dsbr100_device *radio = video_drvdata(file);
 
-	/* safety check */
-	if (radio->removed)
-		return -EIO;
-
 	if (v->index > 0)
 		return -EINVAL;
 
@@ -371,16 +366,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 static int vidioc_s_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
-	struct dsbr100_device *radio = video_drvdata(file);
-
-	/* safety check */
-	if (radio->removed)
-		return -EIO;
-
-	if (v->index > 0)
-		return -EINVAL;
-
-	return 0;
+	return v->index ? -EINVAL : 0;
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
@@ -389,10 +375,6 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	struct dsbr100_device *radio = video_drvdata(file);
 	int retval;
 
-	/* safety check */
-	if (radio->removed)
-		return -EIO;
-
 	radio->curfreq = f->frequency;
 
 	retval = dsbr100_setfreq(radio);
@@ -406,10 +388,6 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 {
 	struct dsbr100_device *radio = video_drvdata(file);
 
-	/* safety check */
-	if (radio->removed)
-		return -EIO;
-
 	f->type = V4L2_TUNER_RADIO;
 	f->frequency = radio->curfreq;
 	return 0;
@@ -431,10 +409,6 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 {
 	struct dsbr100_device *radio = video_drvdata(file);
 
-	/* safety check */
-	if (radio->removed)
-		return -EIO;
-
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
 		ctrl->value = radio->status;
@@ -449,10 +423,6 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	struct dsbr100_device *radio = video_drvdata(file);
 	int retval;
 
-	/* safety check */
-	if (radio->removed)
-		return -EIO;
-
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
 		if (ctrl->value) {
@@ -494,17 +464,13 @@ static int vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
 
 static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
 {
-	if (i != 0)
-		return -EINVAL;
-	return 0;
+	return i ? -EINVAL : 0;
 }
 
 static int vidioc_s_audio(struct file *file, void *priv,
 					struct v4l2_audio *a)
 {
-	if (a->index != 0)
-		return -EINVAL;
-	return 0;
+	return a->index ? -EINVAL : 0;
 }
 
 /* USB subsystem interface begins here */
@@ -519,14 +485,14 @@ static void usb_dsbr100_disconnect(struct usb_interface *intf)
 {
 	struct dsbr100_device *radio = usb_get_intfdata(intf);
 
-	usb_set_intfdata(intf, NULL);
-
 	mutex_lock(&radio->v4l2_lock);
-	radio->removed = 1;
-	mutex_unlock(&radio->v4l2_lock);
+	usb_set_intfdata(intf, NULL);
 
+	v4l2_device_get(&radio->v4l2_dev);
 	video_unregister_device(&radio->videodev);
 	v4l2_device_disconnect(&radio->v4l2_dev);
+	mutex_unlock(&radio->v4l2_lock);
+	v4l2_device_put(&radio->v4l2_dev);
 }
 
 
@@ -576,9 +542,9 @@ static int usb_dsbr100_resume(struct usb_interface *intf)
 }
 
 /* free data structures */
-static void usb_dsbr100_video_device_release(struct video_device *videodev)
+static void usb_dsbr100_release(struct v4l2_device *v4l2_dev)
 {
-	struct dsbr100_device *radio = videodev_to_radio(videodev);
+	struct dsbr100_device *radio = v4l2_dev_to_radio(v4l2_dev);
 
 	v4l2_device_unregister(&radio->v4l2_dev);
 	kfree(radio->transfer_buffer);
@@ -627,6 +593,7 @@ static int usb_dsbr100_probe(struct usb_interface *intf,
 	}
 
 	v4l2_dev = &radio->v4l2_dev;
+	v4l2_dev->release = usb_dsbr100_release;
 
 	retval = v4l2_device_register(&intf->dev, v4l2_dev);
 	if (retval < 0) {
@@ -641,10 +608,9 @@ static int usb_dsbr100_probe(struct usb_interface *intf,
 	radio->videodev.v4l2_dev = v4l2_dev;
 	radio->videodev.fops = &usb_dsbr100_fops;
 	radio->videodev.ioctl_ops = &usb_dsbr100_ioctl_ops;
-	radio->videodev.release = usb_dsbr100_video_device_release;
+	radio->videodev.release = video_device_release_empty;
 	radio->videodev.lock = &radio->v4l2_lock;
 
-	radio->removed = 0;
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = FREQ_MIN * FREQ_MUL;
 	radio->status = STOPPED;
-- 
1.7.0.4

