Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:42738 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474AbbGTNA6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:00:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/12] usbvision: remove g/s_audio and for radio remove enum/g/s_input
Date: Mon, 20 Jul 2015 14:59:31 +0200
Message-Id: <1437397178-5013-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The g/s_audio ioctls didn't do anything, so remove them all for both
video and radio nodes and remove V4L2_CAP_AUDIO.

The enum/g/s_input ioctls are invalid for radio nodes, so remove them
from the radio ioctl_ops.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-video.c | 29 ---------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 82a65a4..15a1ebf 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -494,7 +494,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 		sizeof(vc->card));
 	usb_make_path(usbvision->dev, vc->bus_info, sizeof(vc->bus_info));
 	vc->device_caps = V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_AUDIO |
 		V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING |
 		(usbvision->have_tuner ? V4L2_CAP_TUNER : 0);
@@ -524,7 +523,6 @@ static int vidioc_enum_input(struct file *file, void *priv,
 		} else {
 			strcpy(vi->name, "Television");
 			vi->type = V4L2_INPUT_TYPE_TUNER;
-			vi->audioset = 1;
 			vi->tuner = chan;
 			vi->std = USBVISION_NORMS;
 		}
@@ -661,26 +659,6 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
-{
-	struct usb_usbvision *usbvision = video_drvdata(file);
-
-	if (usbvision->radio)
-		strcpy(a->name, "Radio");
-	else
-		strcpy(a->name, "TV");
-
-	return 0;
-}
-
-static int vidioc_s_audio(struct file *file, void *fh,
-			  const struct v4l2_audio *a)
-{
-	if (a->index)
-		return -EINVAL;
-	return 0;
-}
-
 static int vidioc_reqbufs(struct file *file,
 			   void *priv, struct v4l2_requestbuffers *vr)
 {
@@ -1204,8 +1182,6 @@ static const struct v4l2_ioctl_ops usbvision_ioctl_ops = {
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
-	.vidioc_g_audio       = vidioc_g_audio,
-	.vidioc_s_audio       = vidioc_s_audio,
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
 	.vidioc_g_tuner       = vidioc_g_tuner,
@@ -1241,11 +1217,6 @@ static const struct v4l2_file_operations usbvision_radio_fops = {
 
 static const struct v4l2_ioctl_ops usbvision_radio_ioctl_ops = {
 	.vidioc_querycap      = vidioc_querycap,
-	.vidioc_enum_input    = vidioc_enum_input,
-	.vidioc_g_input       = vidioc_g_input,
-	.vidioc_s_input       = vidioc_s_input,
-	.vidioc_g_audio       = vidioc_g_audio,
-	.vidioc_s_audio       = vidioc_s_audio,
 	.vidioc_g_tuner       = vidioc_g_tuner,
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
-- 
2.1.4

