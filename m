Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55257 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605Ab3AYR0t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 12:26:49 -0500
Received: by mail-ee0-f51.google.com with SMTP id d17so310528eek.24
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 09:26:48 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [REVIEW PATCH 04/12] em28xx: use v4l2_disable_ioctl() to disable ioctl VIDIOC_S_PARM
Date: Fri, 25 Jan 2013 18:26:54 +0100
Message-Id: <1359134822-4585-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1359134822-4585-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking the device type and returning -ENOTTY inside the ioctl
function, use v4l2_disable_ioctl() to disable the ioctl VIDIOC_S_PARM if the
device is not a camera.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    5 ++---
 1 Datei geändert, 2 Zeilen hinzugefügt(+), 3 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 378d8a1..c76714d 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1044,9 +1044,6 @@ static int vidioc_s_parm(struct file *file, void *priv,
 	struct em28xx_fh   *fh  = priv;
 	struct em28xx      *dev = fh->dev;
 
-	if (!dev->board.is_webcam)
-		return -ENOTTY;
-
 	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
@@ -1891,6 +1888,8 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 		v4l2_disable_ioctl(dev->vdev, VIDIOC_QUERYSTD);
 		v4l2_disable_ioctl(dev->vdev, VIDIOC_G_STD);
 		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_STD);
+	} else {
+		v4l2_disable_ioctl(dev->vdev, VIDIOC_S_PARM);
 	}
 	if (dev->tuner_type == TUNER_ABSENT) {
 		v4l2_disable_ioctl(dev->vdev, VIDIOC_G_TUNER);
-- 
1.7.10.4

