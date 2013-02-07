Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:50019 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202Ab3BGRja (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 12:39:30 -0500
Received: by mail-ea0-f176.google.com with SMTP id a13so1323074eaa.21
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 09:39:29 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 04/13] em28xx: use v4l2_disable_ioctl() to disable ioctl VIDIOC_S_PARM
Date: Thu,  7 Feb 2013 18:39:12 +0100
Message-Id: <1360258761-2959-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360258761-2959-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1360258761-2959-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking the device type and returning -ENOTTY inside the ioctl
function, use v4l2_disable_ioctl() to disable the ioctl VIDIOC_S_PARM if the
device is not a camera.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
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

