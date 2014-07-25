Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:48102 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935059AbaGYRsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 13:48:07 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so4604448wes.17
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 10:48:06 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/4] em28xx-v4l: simplify some pointers in em28xx_init_camera()
Date: Fri, 25 Jul 2014 19:48:55 +0200
Message-Id: <1406310538-5001-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1406310538-5001-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1406310538-5001-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pointer v4l2" can be used instead of "dev->v4l2, which saves some characters.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 12d4c03..6d2ea9a 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -366,7 +366,7 @@ int em28xx_init_camera(struct em28xx *dev)
 		v4l2->sensor_xtal = 4300000;
 		pdata.xtal = v4l2->sensor_xtal;
 		if (NULL ==
-		    v4l2_i2c_new_subdev_board(&dev->v4l2->v4l2_dev, adap,
+		    v4l2_i2c_new_subdev_board(&v4l2->v4l2_dev, adap,
 					      &mt9v011_info, NULL)) {
 			ret = -ENODEV;
 			break;
@@ -423,7 +423,7 @@ int em28xx_init_camera(struct em28xx *dev)
 		v4l2->sensor_yres = 480;
 
 		subdev =
-		     v4l2_i2c_new_subdev_board(&dev->v4l2->v4l2_dev, adap,
+		     v4l2_i2c_new_subdev_board(&v4l2->v4l2_dev, adap,
 					       &ov2640_info, NULL);
 		if (NULL == subdev) {
 			ret = -ENODEV;
-- 
1.8.4.5

