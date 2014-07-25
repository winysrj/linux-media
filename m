Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44796 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbaGYSHr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 14:07:47 -0400
Received: by mail-wi0-f170.google.com with SMTP id f8so1495496wiw.3
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 11:07:46 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx-v4l: fix disabling ioctl VIDIOC_S_PARM for vbi devices
Date: Fri, 25 Jul 2014 20:08:30 +0200
Message-Id: <1406311710-5914-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes an old copy+paste bug that has survived all recent code
changes in this code area.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 087ccf9..90dec29 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2528,7 +2528,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		v4l2->vbi_dev->queue->lock = &v4l2->vb_vbi_queue_lock;
 
 		/* disable inapplicable ioctls */
-		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_PARM);
+		v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_S_PARM);
 		if (dev->tuner_type == TUNER_ABSENT) {
 			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_G_TUNER);
 			v4l2_disable_ioctl(v4l2->vbi_dev, VIDIOC_S_TUNER);
-- 
1.8.4.5

