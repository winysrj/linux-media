Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49215 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3ADU7y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 15:59:54 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so16673752vcd.19
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 12:59:53 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/15] em28xx: fix querycap.
Date: Fri,  4 Jan 2013 15:59:31 -0500
Message-Id: <1357333186-8466-2-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   42 ++++++++++++++-----------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 4c1726d..fb9ee46 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1577,6 +1577,7 @@ static int vidioc_streamoff(struct file *file, void *priv,
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
 
@@ -1584,20 +1585,28 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, em28xx_boards[dev->model].name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
-	cap->capabilities =
-			V4L2_CAP_SLICED_VBI_CAPTURE |
-			V4L2_CAP_VIDEO_CAPTURE |
-			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
-
-	if (dev->vbi_dev)
-		cap->capabilities |= V4L2_CAP_VBI_CAPTURE;
+	if (vdev->vfl_type == VFL_TYPE_GRABBER)
+		cap->device_caps = V4L2_CAP_READWRITE |
+			V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	else if (vdev->vfl_type == VFL_TYPE_RADIO)
+		cap->device_caps = V4L2_CAP_RADIO;
+	else
+		cap->device_caps = V4L2_CAP_READWRITE |
+			V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE;
 
 	if (dev->audio_mode.has_audio)
-		cap->capabilities |= V4L2_CAP_AUDIO;
+		cap->device_caps |= V4L2_CAP_AUDIO;
 
 	if (dev->tuner_type != TUNER_ABSENT)
-		cap->capabilities |= V4L2_CAP_TUNER;
+		cap->device_caps |= V4L2_CAP_TUNER;
 
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
+		V4L2_CAP_READWRITE | V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	if (dev->vbi_dev)
+		cap->capabilities |=
+			V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE;
+	if (dev->radio_dev)
+		cap->capabilities |= V4L2_CAP_RADIO;
 	return 0;
 }
 
@@ -1831,19 +1840,6 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 /* RADIO ESPECIFIC IOCTLS                                      */
 /* ----------------------------------------------------------- */
 
-static int radio_querycap(struct file *file, void  *priv,
-			  struct v4l2_capability *cap)
-{
-	struct em28xx *dev = ((struct em28xx_fh *)priv)->dev;
-
-	strlcpy(cap->driver, "em28xx", sizeof(cap->driver));
-	strlcpy(cap->card, em28xx_boards[dev->model].name, sizeof(cap->card));
-	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
-
-	cap->capabilities = V4L2_CAP_TUNER;
-	return 0;
-}
-
 static int radio_g_tuner(struct file *file, void *priv,
 			 struct v4l2_tuner *t)
 {
@@ -2281,7 +2277,7 @@ static const struct v4l2_file_operations radio_fops = {
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
-	.vidioc_querycap      = radio_querycap,
+	.vidioc_querycap      = vidioc_querycap,
 	.vidioc_g_tuner       = radio_g_tuner,
 	.vidioc_enum_input    = radio_enum_input,
 	.vidioc_g_audio       = radio_g_audio,
-- 
1.7.9.5

