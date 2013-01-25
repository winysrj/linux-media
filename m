Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:50567 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab3AYR0k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 12:26:40 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so325321eei.31
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 09:26:39 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [REVIEW PATCH 01/12] em28xx: use v4l2_disable_ioctl() to disable ioctls VIDIOC_QUERYSTD, VIDIOC_G/S_STD
Date: Fri, 25 Jan 2013 18:26:51 +0100
Message-Id: <1359134822-4585-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking the device type and returning -ENOTTY inside the ioctl
functions, use v4l2_disable_ioctl() to disable the ioctls VIDIOC_QUERYSTD,
VIDIOC_G_STD and VIDIOC_S_STD if the device is a camera.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
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

