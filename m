Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36693 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752840AbdDOKFk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Apr 2017 06:05:40 -0400
Received: by mail-wm0-f65.google.com with SMTP id q125so1908452wmd.3
        for <linux-media@vger.kernel.org>; Sat, 15 Apr 2017 03:05:39 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/5] em28xx: get rid of the dummy clock source
Date: Sat, 15 Apr 2017 12:05:00 +0200
Message-Id: <20170415100504.3076-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2 dummy clock has been added with commit fc5d0f8a8878
("V4L2: em28xx: register a V4L2 clock source") to be able to use the ov2640
soc_camera driver.
Since commit 46796cfcd346 ("ov2640: use standard clk and enable it") it is
no longer required.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c | 30 ++++++------------------------
 drivers/media/usb/em28xx/em28xx-video.c  |  6 ------
 drivers/media/usb/em28xx/em28xx.h        |  1 -
 3 files changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 2f59237ee399..d43f630050bb 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -24,7 +24,6 @@
 #include <linux/i2c.h>
 #include <linux/usb.h>
 #include <media/i2c/mt9v011.h>
-#include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 
 /* Possible i2c addresses of Micron sensors */
@@ -331,17 +330,9 @@ int em28xx_detect_sensor(struct em28xx *dev)
 
 int em28xx_init_camera(struct em28xx *dev)
 {
-	char clk_name[V4L2_CLK_NAME_SIZE];
 	struct i2c_client *client = &dev->i2c_client[dev->def_i2c_bus];
 	struct i2c_adapter *adap = &dev->i2c_adap[dev->def_i2c_bus];
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
-	int ret = 0;
-
-	v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
-			  i2c_adapter_id(adap), client->addr);
-	v4l2->clk = v4l2_clk_register_fixed(clk_name, -EINVAL);
-	if (IS_ERR(v4l2->clk))
-		return PTR_ERR(v4l2->clk);
 
 	switch (dev->em28xx_sensor) {
 	case EM28XX_MT9V011:
@@ -371,10 +362,8 @@ int em28xx_init_camera(struct em28xx *dev)
 		pdata.xtal = v4l2->sensor_xtal;
 		if (NULL ==
 		    v4l2_i2c_new_subdev_board(&v4l2->v4l2_dev, adap,
-					      &mt9v011_info, NULL)) {
-			ret = -ENODEV;
-			break;
-		}
+					      &mt9v011_info, NULL))
+			return -ENODEV;
 		/* probably means GRGB 16 bit bayer */
 		v4l2->vinmode = 0x0d;
 		v4l2->vinctl = 0x00;
@@ -430,10 +419,8 @@ int em28xx_init_camera(struct em28xx *dev)
 		subdev =
 		     v4l2_i2c_new_subdev_board(&v4l2->v4l2_dev, adap,
 					       &ov2640_info, NULL);
-		if (NULL == subdev) {
-			ret = -ENODEV;
-			break;
-		}
+		if (subdev == NULL)
+			return -ENODEV;
 
 		format.format.code = MEDIA_BUS_FMT_YUYV8_2X8;
 		format.format.width = 640;
@@ -450,14 +437,9 @@ int em28xx_init_camera(struct em28xx *dev)
 	}
 	case EM28XX_NOSENSOR:
 	default:
-		ret = -EINVAL;
-	}
-
-	if (ret < 0) {
-		v4l2_clk_unregister_fixed(v4l2->clk);
-		v4l2->clk = NULL;
+		return -EINVAL;
 	}
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(em28xx_init_camera);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 8d93100334ea..3cbc3d4270a3 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -43,7 +43,6 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/v4l2-clk.h>
 #include <media/drv-intf/msp3400.h>
 #include <media/tuner.h>
 
@@ -2140,11 +2139,6 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
 	v4l2_device_unregister(&v4l2->v4l2_dev);
 
-	if (v4l2->clk) {
-		v4l2_clk_unregister_fixed(v4l2->clk);
-		v4l2->clk = NULL;
-	}
-
 	kref_put(&v4l2->ref, em28xx_free_v4l2);
 
 	mutex_unlock(&dev->lock);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index e9f379959fa5..e8d97d5ec161 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -510,7 +510,6 @@ struct em28xx_v4l2 {
 
 	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler ctrl_handler;
-	struct v4l2_clk *clk;
 
 	struct video_device vdev;
 	struct video_device vbi_dev;
-- 
2.12.2
