Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:51022 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755503AbbGTNBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:01:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/12] usbvision: frequency fixes.
Date: Mon, 20 Jul 2015 14:59:33 +0200
Message-Id: <1437397178-5013-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- setup initial radio and tv frequencies.
- set/get the correct frequency (radio vs tv).
- disable tuner/freq ioctls if there is no tuner.
- fix some tuner index checks.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-video.c | 44 +++++++++++++++++----------
 drivers/media/usb/usbvision/usbvision.h       |  3 +-
 2 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index f526712..dc0e034 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -608,14 +608,13 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
 
-	if (!usbvision->have_tuner || vt->index)	/* Only tuner 0 */
+	if (vt->index)	/* Only tuner 0 */
 		return -EINVAL;
-	if (usbvision->radio) {
+	if (vt->type == V4L2_TUNER_RADIO)
 		strcpy(vt->name, "Radio");
-		vt->type = V4L2_TUNER_RADIO;
-	} else {
+	else
 		strcpy(vt->name, "Television");
-	}
+
 	/* Let clients fill in the remainder of this struct */
 	call_all(usbvision, tuner, g_tuner, vt);
 
@@ -627,8 +626,8 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
 
-	/* Only no or one tuner for now */
-	if (!usbvision->have_tuner || vt->index)
+	/* Only one tuner for now */
+	if (vt->index)
 		return -EINVAL;
 	/* let clients handle this */
 	call_all(usbvision, tuner, s_tuner, vt);
@@ -641,12 +640,13 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
 
-	freq->tuner = 0; /* Only one tuner */
-	if (usbvision->radio)
-		freq->type = V4L2_TUNER_RADIO;
+	/* Only one tuner */
+	if (freq->tuner)
+		return -EINVAL;
+	if (freq->type == V4L2_TUNER_RADIO)
+		freq->frequency = usbvision->radio_freq;
 	else
-		freq->type = V4L2_TUNER_ANALOG_TV;
-	freq->frequency = usbvision->freq;
+		freq->frequency = usbvision->tv_freq;
 
 	return 0;
 }
@@ -655,13 +655,18 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 				const struct v4l2_frequency *freq)
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
+	struct v4l2_frequency new_freq = *freq;
 
-	/* Only no or one tuner for now */
-	if (!usbvision->have_tuner || freq->tuner)
+	/* Only one tuner for now */
+	if (freq->tuner)
 		return -EINVAL;
 
-	usbvision->freq = freq->frequency;
 	call_all(usbvision, tuner, s_frequency, freq);
+	call_all(usbvision, tuner, g_frequency, &new_freq);
+	if (freq->type == V4L2_TUNER_RADIO)
+		usbvision->radio_freq = new_freq.frequency;
+	else
+		usbvision->tv_freq = new_freq.frequency;
 
 	return 0;
 }
@@ -1287,6 +1292,12 @@ static int usbvision_register_video(struct usb_usbvision *usbvision)
 	/* Video Device: */
 	usbvision_vdev_init(usbvision, &usbvision->vdev,
 			      &usbvision_video_template, "USBVision Video");
+	if (!usbvision->have_tuner) {
+		v4l2_disable_ioctl(&usbvision->vdev, VIDIOC_G_FREQUENCY);
+		v4l2_disable_ioctl(&usbvision->vdev, VIDIOC_S_TUNER);
+		v4l2_disable_ioctl(&usbvision->vdev, VIDIOC_G_FREQUENCY);
+		v4l2_disable_ioctl(&usbvision->vdev, VIDIOC_S_TUNER);
+	}
 	if (video_register_device(&usbvision->vdev, VFL_TYPE_GRABBER, video_nr) < 0)
 		goto err_exit;
 	printk(KERN_INFO "USBVision[%d]: registered USBVision Video device %s [v4l2]\n",
@@ -1403,9 +1414,10 @@ static void usbvision_configure_video(struct usb_usbvision *usbvision)
 	}
 
 	usbvision->tvnorm_id = usbvision_device_data[model].video_norm;
-
 	usbvision->video_inputs = usbvision_device_data[model].video_channels;
 	usbvision->ctl_input = 0;
+	usbvision->radio_freq = 87.5 * 16000;
+	usbvision->tv_freq = 400 * 16;
 
 	/* This should be here to make i2c clients to be able to register */
 	/* first switch off audio */
diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
index 4dbb421..4f2e4fd 100644
--- a/drivers/media/usb/usbvision/usbvision.h
+++ b/drivers/media/usb/usbvision/usbvision.h
@@ -378,7 +378,8 @@ struct usb_usbvision {
 	int bridge_type;						/* NT1003, NT1004, NT1005 */
 	int radio;
 	int video_inputs;						/* # of inputs */
-	unsigned long freq;
+	unsigned long radio_freq;
+	unsigned long tv_freq;
 	int audio_mute;
 	int audio_channel;
 	int isoc_mode;							/* format of video data for the usb isoc-transfer */
-- 
2.1.4

