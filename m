Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:42661 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab3AYR0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 12:26:42 -0500
Received: by mail-ea0-f180.google.com with SMTP id c1so260982eaa.39
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 09:26:40 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [REVIEW PATCH 02/12] em28xx: disable tuner related ioctls for video and VBI devices without tuner
Date: Fri, 25 Jan 2013 18:26:52 +0100
Message-Id: <1359134822-4585-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disable the ioctls VIDIOC_G_TUNER, VIDIOC_S_TUNER, VIDIOC_G_FREQUENCY and
VIDIOC_S_FREQUENCY for video and VBI devices without tuner.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   14 ++++++++++++++
 1 Datei geändert, 14 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 7f1f37c..dd2e31c 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1899,6 +1899,12 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 		v4l2_disable_ioctl(dev->vdev, VIDIOC_G_STD);
 		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_STD);
 	}
+	if (dev->tuner_type == TUNER_ABSENT) {
+		v4l2_disable_ioctl(dev->vdev, VIDIOC_G_TUNER);
+		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_TUNER);
+		v4l2_disable_ioctl(dev->vdev, VIDIOC_G_FREQUENCY);
+		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_FREQUENCY);
+	}
 
 	/* register v4l2 video video_device */
 	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER,
@@ -1917,6 +1923,14 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 		dev->vbi_dev->queue = &dev->vb_vbiq;
 		dev->vbi_dev->queue->lock = &dev->vb_vbi_queue_lock;
 
+		/* disable inapplicable ioctls */
+		if (dev->tuner_type == TUNER_ABSENT) {
+			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_G_TUNER);
+			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_S_TUNER);
+			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_G_FREQUENCY);
+			v4l2_disable_ioctl(dev->vbi_dev, VIDIOC_S_FREQUENCY);
+		}
+
 		/* register v4l2 vbi video_device */
 		ret = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
 					    vbi_nr[dev->devno]);
-- 
1.7.10.4

