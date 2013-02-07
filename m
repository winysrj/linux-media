Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:42308 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200Ab3BGRjZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 12:39:25 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so1618745eei.21
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 09:39:24 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 02/13] em28xx: disable tuner related ioctls for video and VBI devices without tuner
Date: Thu,  7 Feb 2013 18:39:10 +0100
Message-Id: <1360258761-2959-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360258761-2959-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1360258761-2959-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disable the ioctls VIDIOC_G_TUNER, VIDIOC_S_TUNER, VIDIOC_G_FREQUENCY and
VIDIOC_S_FREQUENCY for video and VBI devices without tuner.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
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

