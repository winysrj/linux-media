Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62763 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab3H1N2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 09:28:37 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] V4L2: em28xx: register a V4L2 clock source
Date: Wed, 28 Aug 2013 15:28:28 +0200
Message-Id: <1377696508-3190-4-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1377696508-3190-1-git-send-email-g.liakhovetski@gmx.de>
References: <1377696508-3190-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Camera sensors usually require a master clock for data sampling. This patch
registers such a clock source for em28xx cameras. This fixes the currently
broken em28xx ov2640 camera support and can also be used by other camera
sensors.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Actually after thinking a bit more, it'd probably be better to register a 
clock only for the ov2640 based camera, not for all cameras. If all agree, 
I'll redo this.

 drivers/media/usb/em28xx/em28xx-camera.c |   41 ++++++++++++++++++++++-------
 drivers/media/usb/em28xx/em28xx-cards.c  |    3 ++
 drivers/media/usb/em28xx/em28xx.h        |    1 +
 3 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 73cc50a..2f451e4 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -22,6 +22,7 @@
 #include <linux/i2c.h>
 #include <media/soc_camera.h>
 #include <media/mt9v011.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 
 #include "em28xx.h"
@@ -325,13 +326,24 @@ int em28xx_detect_sensor(struct em28xx *dev)
 
 int em28xx_init_camera(struct em28xx *dev)
 {
+	char clk_name[V4L2_SUBDEV_NAME_SIZE];
+	struct i2c_client *client = &dev->i2c_client[dev->def_i2c_bus];
+	struct i2c_adapter *adap = &dev->i2c_adap[dev->def_i2c_bus];
+	int ret = 0;
+
+	v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
+			  i2c_adapter_id(adap), client->addr);
+	dev->clk = v4l2_clk_register_fixed(clk_name, "mclk", -EINVAL);
+	if (IS_ERR(dev->clk))
+		return PTR_ERR(dev->clk);
+
 	switch (dev->em28xx_sensor) {
 	case EM28XX_MT9V011:
 	{
 		struct mt9v011_platform_data pdata;
 		struct i2c_board_info mt9v011_info = {
 			.type = "mt9v011",
-			.addr = dev->i2c_client[dev->def_i2c_bus].addr,
+			.addr = client->addr,
 			.platform_data = &pdata,
 		};
 
@@ -352,10 +364,11 @@ int em28xx_init_camera(struct em28xx *dev)
 		dev->sensor_xtal = 4300000;
 		pdata.xtal = dev->sensor_xtal;
 		if (NULL ==
-		    v4l2_i2c_new_subdev_board(&dev->v4l2_dev,
-					      &dev->i2c_adap[dev->def_i2c_bus],
-					      &mt9v011_info, NULL))
-			return -ENODEV;
+		    v4l2_i2c_new_subdev_board(&dev->v4l2_dev, adap,
+					      &mt9v011_info, NULL)) {
+			ret = -ENODEV;
+			break;
+		}
 		/* probably means GRGB 16 bit bayer */
 		dev->vinmode = 0x0d;
 		dev->vinctl = 0x00;
@@ -391,7 +404,7 @@ int em28xx_init_camera(struct em28xx *dev)
 		struct i2c_board_info ov2640_info = {
 			.type = "ov2640",
 			.flags = I2C_CLIENT_SCCB,
-			.addr = dev->i2c_client[dev->def_i2c_bus].addr,
+			.addr = client->addr,
 			.platform_data = &camlink,
 		};
 		struct v4l2_mbus_framefmt fmt;
@@ -408,9 +421,12 @@ int em28xx_init_camera(struct em28xx *dev)
 		dev->sensor_yres = 480;
 
 		subdev =
-		     v4l2_i2c_new_subdev_board(&dev->v4l2_dev,
-					       &dev->i2c_adap[dev->def_i2c_bus],
+		     v4l2_i2c_new_subdev_board(&dev->v4l2_dev, adap,
 					       &ov2640_info, NULL);
+		if (NULL == subdev) {
+			ret = -ENODEV;
+			break;
+		}
 
 		fmt.code = V4L2_MBUS_FMT_YUYV8_2X8;
 		fmt.width = 640;
@@ -427,8 +443,13 @@ int em28xx_init_camera(struct em28xx *dev)
 	}
 	case EM28XX_NOSENSOR:
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
-	return 0;
+	if (ret < 0) {
+		v4l2_clk_unregister_fixed(dev->clk);
+		dev->clk = NULL;
+	}
+
+	return ret;
 }
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index dc65742..7c0afa2 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -36,6 +36,7 @@
 #include <media/tvaudio.h>
 #include <media/i2c-addr.h>
 #include <media/tveeprom.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 
 #include "em28xx.h"
@@ -2857,6 +2858,8 @@ void em28xx_release_resources(struct em28xx *dev)
 	if (dev->def_i2c_bus)
 		em28xx_i2c_unregister(dev, 1);
 	em28xx_i2c_unregister(dev, 0);
+	if (dev->clk)
+		v4l2_clk_unregister_fixed(dev->clk);
 
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 205e903..c9ebe19 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -492,6 +492,7 @@ struct em28xx {
 
 	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_clk *clk;
 	struct em28xx_board board;
 
 	/* Webcam specific fields */
-- 
1.7.2.5

