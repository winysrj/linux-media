Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:55225 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759195Ab3BGRjU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 12:39:20 -0500
Received: by mail-ea0-f178.google.com with SMTP id a14so1281977eaa.37
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 09:39:18 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 01/13] em28xx: use v4l2_disable_ioctl() to disable ioctls VIDIOC_QUERYSTD, VIDIOC_G/S_STD
Date: Thu,  7 Feb 2013 18:39:09 +0100
Message-Id: <1360258761-2959-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360258761-2959-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1360258761-2959-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking the device type and returning -ENOTTY inside the ioctl
functions, use v4l2_disable_ioctl() to disable the ioctls VIDIOC_QUERYSTD,
VIDIOC_G_STD and VIDIOC_S_STD if the device is a camera.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   13 +++++++------
 1 Datei geändert, 7 Zeilen hinzugefügt(+), 6 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 2eabf2a..7f1f37c 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -959,8 +959,6 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
 	struct em28xx      *dev = fh->dev;
 	int                rc;
 
-	if (dev->board.is_webcam)
-		return -ENOTTY;
 	rc = check_dev(dev);
 	if (rc < 0)
 		return rc;
@@ -976,8 +974,6 @@ static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
 	struct em28xx      *dev = fh->dev;
 	int                rc;
 
-	if (dev->board.is_webcam)
-		return -ENOTTY;
 	rc = check_dev(dev);
 	if (rc < 0)
 		return rc;
@@ -994,8 +990,6 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 	struct v4l2_format f;
 	int                rc;
 
-	if (dev->board.is_webcam)
-		return -ENOTTY;
 	if (*norm == dev->norm)
 		return 0;
 	rc = check_dev(dev);
@@ -1899,6 +1893,13 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 	dev->vdev->queue = &dev->vb_vidq;
 	dev->vdev->queue->lock = &dev->vb_queue_lock;
 
+	/* disable inapplicable ioctls */
+	if (dev->board.is_webcam) {
+		v4l2_disable_ioctl(dev->vdev, VIDIOC_QUERYSTD);
+		v4l2_disable_ioctl(dev->vdev, VIDIOC_G_STD);
+		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_STD);
+	}
+
 	/* register v4l2 video video_device */
 	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER,
 				       video_nr[dev->devno]);
-- 
1.7.10.4

