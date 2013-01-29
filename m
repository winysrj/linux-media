Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2393 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab3A2Qde (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:33:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 04/20] cx231xx: remove broken audio input support from the driver.
Date: Tue, 29 Jan 2013 17:32:57 +0100
Message-Id: <559f99f7c84e3e0197958767e45426c191283abd.1359476777.git.hans.verkuil@cisco.com>
In-Reply-To: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
References: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The audio selection code is broken. Audio and video indices were
mixed up and s_audio would reject changing the audio input to
something else anyway, so what's the point?

All the audio input code has been removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |   52 +++++------------------------
 1 file changed, 8 insertions(+), 44 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 666152f..f043776 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1231,44 +1231,6 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
-{
-	struct cx231xx_fh *fh = priv;
-	struct cx231xx *dev = fh->dev;
-
-	switch (a->index) {
-	case CX231XX_AMUX_VIDEO:
-		strcpy(a->name, "Television");
-		break;
-	case CX231XX_AMUX_LINE_IN:
-		strcpy(a->name, "Line In");
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	a->index = dev->ctl_ainput;
-	a->capability = V4L2_AUDCAP_STEREO;
-
-	return 0;
-}
-
-static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
-{
-	struct cx231xx_fh *fh = priv;
-	struct cx231xx *dev = fh->dev;
-	int status = 0;
-
-	/* Doesn't allow manual routing */
-	if (a->index != dev->ctl_ainput)
-		return -EINVAL;
-
-	dev->ctl_ainput = INPUT(a->index)->amux;
-	status = cx231xx_set_audio_input(dev, dev->ctl_ainput);
-
-	return status;
-}
-
 static int vidioc_queryctrl(struct file *file, void *priv,
 			    struct v4l2_queryctrl *qc)
 {
@@ -1876,8 +1838,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 	if (vdev->vfl_type == VFL_TYPE_RADIO)
 		cap->device_caps = V4L2_CAP_RADIO;
 	else {
-		cap->device_caps = V4L2_CAP_AUDIO | V4L2_CAP_READWRITE |
-			V4L2_CAP_STREAMING;
+		cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
 		if (vdev->vfl_type == VFL_TYPE_VBI)
 			cap->device_caps |= V4L2_CAP_VBI_CAPTURE;
 		else
@@ -1885,9 +1846,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 	}
 	if (dev->tuner_type != TUNER_ABSENT)
 		cap->device_caps |= V4L2_CAP_TUNER;
-	cap->capabilities = cap->device_caps |
+	cap->capabilities = cap->device_caps | V4L2_CAP_READWRITE |
 		V4L2_CAP_VBI_CAPTURE | V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_AUDIO | V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;
 	if (dev->radio_dev)
 		cap->capabilities |= V4L2_CAP_RADIO;
@@ -2462,8 +2422,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_fmt_vbi_cap          = vidioc_g_fmt_vbi_cap,
 	.vidioc_try_fmt_vbi_cap        = vidioc_try_fmt_vbi_cap,
 	.vidioc_s_fmt_vbi_cap          = vidioc_try_fmt_vbi_cap,
-	.vidioc_g_audio                =  vidioc_g_audio,
-	.vidioc_s_audio                = vidioc_s_audio,
 	.vidioc_cropcap                = vidioc_cropcap,
 	.vidioc_g_fmt_sliced_vbi_cap   = vidioc_g_fmt_sliced_vbi_cap,
 	.vidioc_try_fmt_sliced_vbi_cap = vidioc_try_set_sliced_vbi_cap,
@@ -2552,6 +2510,12 @@ static struct video_device *cx231xx_vdev_init(struct cx231xx *dev,
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
 
 	video_set_drvdata(vfd, dev);
+	if (dev->tuner_type == TUNER_ABSENT) {
+		v4l2_disable_ioctl(vfd, VIDIOC_G_FREQUENCY);
+		v4l2_disable_ioctl(vfd, VIDIOC_S_FREQUENCY);
+		v4l2_disable_ioctl(vfd, VIDIOC_G_TUNER);
+		v4l2_disable_ioctl(vfd, VIDIOC_S_TUNER);
+	}
 	return vfd;
 }
 
-- 
1.7.10.4

