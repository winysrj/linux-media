Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:63994 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab3AYR0p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 12:26:45 -0500
Received: by mail-ea0-f180.google.com with SMTP id c1so261009eaa.39
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 09:26:44 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [REVIEW PATCH 03/12] em28xx: use v4l2_disable_ioctl() to disable ioctls VIDIOC_G_AUDIO and VIDIOC_S_AUDIO
Date: Fri, 25 Jan 2013 18:26:53 +0100
Message-Id: <1359134822-4585-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking the device type and returning -EINVAL inside the ioctl
functions, use v4l2_disable_ioctl() to disable the ioctls VIDIOC_G_AUDIO and
VIDIOC_S_AUDIO if the device doesn't support audio.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   15 ++++++++-------
 1 Datei geändert, 8 Zeilen hinzugefügt(+), 7 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index dd2e31c..378d8a1 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1130,9 +1130,6 @@ static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 	struct em28xx_fh   *fh    = priv;
 	struct em28xx      *dev   = fh->dev;
 
-	if (!dev->audio_mode.has_audio)
-		return -EINVAL;
-
 	switch (a->index) {
 	case EM28XX_AMUX_VIDEO:
 		strcpy(a->name, "Television");
@@ -1173,10 +1170,6 @@ static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio
 	struct em28xx_fh   *fh  = priv;
 	struct em28xx      *dev = fh->dev;
 
-
-	if (!dev->audio_mode.has_audio)
-		return -EINVAL;
-
 	if (a->index >= MAX_EM28XX_INPUT)
 		return -EINVAL;
 	if (0 == INPUT(a->index)->type)
@@ -1905,6 +1898,10 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 		v4l2_disable_ioctl(dev->vdev, VIDIOC_G_FREQUENCY);
 		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_FREQUENCY);
 	}
+	if (!dev->audio_mode.has_audio) {
+		v4l2_disable_ioctl(dev->vdev, VIDIOC_G_AUDIO);
+		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_AUDIO);
+	}
 
 	/* register v4l2 video video_device */
 	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER,
@@ -1930,6 +1927,10 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_G_FREQUENCY);
 			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_S_FREQUENCY);
 		}
+		if (!dev->audio_mode.has_audio) {
+			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_G_AUDIO);
+			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_S_AUDIO);
+		}
 
 		/* register v4l2 vbi video_device */
 		ret = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
-- 
1.7.10.4

