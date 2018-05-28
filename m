Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:57059 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940312AbeE1Qha (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 12:37:30 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        sakari.ailus@iki.fi, mchehab@kernel.org,
        ysato@users.sourceforge.jp, dalias@libc.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] media: i2c: rj54n1: Remove soc_camera dependencies
Date: Mon, 28 May 2018 18:37:08 +0200
Message-Id: <1527525431-22852-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove soc_camera framework dependencies from rj54n1 sensor driver.
- Handle clock
- Handle GPIOs (named 'powerup' and 'enable')
- Register the async subdevice
- Remove g/s_mbus_config as they're deprecated.
- Adjust build system
- List the driver as maintained for 'Odd Fixes' as I don't have HW to test.

This commits does not remove the original soc_camera based driver.

Compiled tested only.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 MAINTAINERS                    |   8 +++
 drivers/media/i2c/Kconfig      |  11 +++
 drivers/media/i2c/Makefile     |   1 +
 drivers/media/i2c/rj54n1cb0c.c | 153 +++++++++++++++++++++++------------------
 4 files changed, 107 insertions(+), 66 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cbcd5ab..0dd7532 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12680,6 +12680,14 @@ W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
 F:	net/smc/
 
+SHARP RJ54N1CB0C SENSOR DRIVER
+M:	Jacopo Mondi <jacopo@jmondi.org>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Odd fixes
+F:	drivers/media/i2c/rj54n1cb0c.c
+F:	include/media/i2c/rj54n1cb0c.h
+
 SH_VEU V4L2 MEM2MEM DRIVER
 L:	linux-media@vger.kernel.org
 S:	Orphan
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index b95b447..7b5a224 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -846,6 +846,17 @@ config VIDEO_NOON010PC30
 
 source "drivers/media/i2c/m5mols/Kconfig"
 
+config VIDEO_RJ54N1
+	tristate "Sharp RJ54N1CB0C sensor support"
+	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	help
+	  This is a V4L2 sensor-level driver for Sharp RJ54N1CB0C CMOS image
+	  sensor.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rj54n1.
+
 config VIDEO_S5K6AA
 	tristate "Samsung S5K6AAFX sensor support"
 	depends on MEDIA_CAMERA_SUPPORT
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index ff6e291..3f9c1f7 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
 obj-$(CONFIG_VIDEO_MT9V032) += mt9v032.o
 obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
+obj-$(CONFIG_VIDEO_RJ54N1)	+= rj54n1cb0c.o
 obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
 obj-$(CONFIG_VIDEO_S5K6A3)	+= s5k6a3.o
 obj-$(CONFIG_VIDEO_S5K4ECGX)	+= s5k4ecgx.o
diff --git a/drivers/media/i2c/rj54n1cb0c.c b/drivers/media/i2c/rj54n1cb0c.c
index 02398d0..6ad998a 100644
--- a/drivers/media/i2c/rj54n1cb0c.c
+++ b/drivers/media/i2c/rj54n1cb0c.c
@@ -1,25 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Driver for RJ54N1CB0C CMOS Image Sensor from Sharp
  *
- * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ * Copyright (C) 2018, Jacopo Mondi <jacopo@jmondi.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
  */
 
+#include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
-#include <linux/module.h>
 
 #include <media/i2c/rj54n1cb0c.h>
-#include <media/soc_camera.h>
-#include <media/v4l2-clk.h>
-#include <media/v4l2-subdev.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
 
 #define RJ54N1_DEV_CODE			0x0400
 #define RJ54N1_DEV_CODE2		0x0401
@@ -151,7 +151,9 @@ struct rj54n1_clock_div {
 struct rj54n1 {
 	struct v4l2_subdev subdev;
 	struct v4l2_ctrl_handler hdl;
-	struct v4l2_clk *clk;
+	struct clk *clk;
+	struct gpio_desc *pwup_gpio;
+	struct gpio_desc *enable_gpio;
 	struct rj54n1_clock_div clk_div;
 	const struct rj54n1_datafmt *fmt;
 	struct v4l2_rect rect;	/* Sensor window */
@@ -545,8 +547,7 @@ static int rj54n1_set_selection(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	const struct v4l2_rect *rect = &sel->r;
-	int dummy = 0, output_w, output_h,
-		input_w = rect->width, input_h = rect->height;
+	int output_w, output_h, input_w = rect->width, input_h = rect->height;
 	int ret;
 
 	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
@@ -554,11 +555,8 @@ static int rj54n1_set_selection(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	/* arbitrary minimum width and height, edges unimportant */
-	soc_camera_limit_side(&dummy, &input_w,
-		     RJ54N1_COLUMN_SKIP, 8, RJ54N1_MAX_WIDTH);
-
-	soc_camera_limit_side(&dummy, &input_h,
-		     RJ54N1_ROW_SKIP, 8, RJ54N1_MAX_HEIGHT);
+	v4l_bound_align_image(&input_w, 8, RJ54N1_MAX_WIDTH, 0,
+			      &input_h, 8, RJ54N1_MAX_HEIGHT, 0, 0);
 
 	output_w = (input_w * 1024 + rj54n1->resize / 2) / rj54n1->resize;
 	output_h = (input_h * 1024 + rj54n1->resize / 2) / rj54n1->resize;
@@ -618,6 +616,9 @@ static int rj54n1_get_fmt(struct v4l2_subdev *sd,
 
 	mf->code	= rj54n1->fmt->code;
 	mf->colorspace	= rj54n1->fmt->colorspace;
+	mf->ycbcr_enc	= V4L2_YCBCR_ENC_601;
+	mf->xfer_func	= V4L2_XFER_FUNC_SRGB;
+	mf->quantization = V4L2_QUANTIZATION_DEFAULT;
 	mf->field	= V4L2_FIELD_NONE;
 	mf->width	= rj54n1->width;
 	mf->height	= rj54n1->height;
@@ -1163,10 +1164,27 @@ static int rj54n1_s_register(struct v4l2_subdev *sd,
 static int rj54n1_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 
-	return soc_camera_set_power(&client->dev, ssdd, rj54n1->clk, on);
+	if (on) {
+		if (rj54n1->pwup_gpio)
+			gpiod_set_value(rj54n1->pwup_gpio, 1);
+		if (rj54n1->enable_gpio)
+			gpiod_set_value(rj54n1->enable_gpio, 1);
+
+		msleep(1);
+
+		return clk_prepare_enable(rj54n1->clk);
+	}
+
+	clk_disable_unprepare(rj54n1->clk);
+
+	if (rj54n1->enable_gpio)
+		gpiod_set_value(rj54n1->enable_gpio, 0);
+	if (rj54n1->pwup_gpio)
+		gpiod_set_value(rj54n1->pwup_gpio, 0);
+
+	return 0;
 }
 
 static int rj54n1_s_ctrl(struct v4l2_ctrl *ctrl)
@@ -1221,40 +1239,8 @@ static const struct v4l2_subdev_core_ops rj54n1_subdev_core_ops = {
 	.s_power	= rj54n1_s_power,
 };
 
-static int rj54n1_g_mbus_config(struct v4l2_subdev *sd,
-				struct v4l2_mbus_config *cfg)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-
-	cfg->flags =
-		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
-		V4L2_MBUS_MASTER | V4L2_MBUS_DATA_ACTIVE_HIGH |
-		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH;
-	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
-
-	return 0;
-}
-
-static int rj54n1_s_mbus_config(struct v4l2_subdev *sd,
-				const struct v4l2_mbus_config *cfg)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-
-	/* Figures 2.5-1 to 2.5-3 - default falling pixclk edge */
-	if (soc_camera_apply_board_flags(ssdd, cfg) &
-	    V4L2_MBUS_PCLK_SAMPLE_RISING)
-		return reg_write(client, RJ54N1_OUT_SIGPO, 1 << 4);
-	else
-		return reg_write(client, RJ54N1_OUT_SIGPO, 0);
-}
-
 static const struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
 	.s_stream	= rj54n1_s_stream,
-	.g_mbus_config	= rj54n1_g_mbus_config,
-	.s_mbus_config	= rj54n1_s_mbus_config,
 };
 
 static const struct v4l2_subdev_pad_ops rj54n1_subdev_pad_ops = {
@@ -1316,17 +1302,16 @@ static int rj54n1_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct rj54n1 *rj54n1;
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct i2c_adapter *adapter = client->adapter;
 	struct rj54n1_pdata *rj54n1_priv;
 	int ret;
 
-	if (!ssdd || !ssdd->drv_priv) {
+	if (!client->dev.platform_data) {
 		dev_err(&client->dev, "RJ54N1CB0C: missing platform data!\n");
 		return -EINVAL;
 	}
 
-	rj54n1_priv = ssdd->drv_priv;
+	rj54n1_priv = client->dev.platform_data;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_warn(&adapter->dev,
@@ -1364,32 +1349,68 @@ static int rj54n1_probe(struct i2c_client *client,
 	rj54n1->tgclk_mhz	= (rj54n1_priv->mclk_freq / PLL_L * PLL_N) /
 		(clk_div.ratio_tg + 1) / (clk_div.ratio_t + 1);
 
-	rj54n1->clk = v4l2_clk_get(&client->dev, "mclk");
+	rj54n1->clk = clk_get(&client->dev, NULL);
 	if (IS_ERR(rj54n1->clk)) {
 		ret = PTR_ERR(rj54n1->clk);
-		goto eclkget;
+		goto err_free_ctrl;
 	}
 
-	ret = rj54n1_video_probe(client, rj54n1_priv);
-	if (ret < 0) {
-		v4l2_clk_put(rj54n1->clk);
-eclkget:
-		v4l2_ctrl_handler_free(&rj54n1->hdl);
+	rj54n1->pwup_gpio = gpiod_get_optional(&client->dev, "powerup",
+					       GPIOD_OUT_LOW);
+	if (IS_ERR(rj54n1->pwup_gpio)) {
+		dev_info(&client->dev, "Unable to get GPIO \"powerup\": %ld\n",
+			 PTR_ERR(rj54n1->pwup_gpio));
+		ret = PTR_ERR(rj54n1->pwup_gpio);
+		goto err_clk_put;
+	}
+
+	rj54n1->enable_gpio = gpiod_get_optional(&client->dev, "enable",
+						 GPIOD_OUT_LOW);
+	if (IS_ERR(rj54n1->enable_gpio)) {
+		dev_info(&client->dev, "Unable to get GPIO \"enable\": %ld\n",
+			 PTR_ERR(rj54n1->enable_gpio));
+		ret = PTR_ERR(rj54n1->enable_gpio);
+		goto err_gpio_put;
 	}
 
+	ret = rj54n1_video_probe(client, rj54n1_priv);
+	if (ret < 0)
+		goto err_gpio_put;
+
+	ret = v4l2_async_register_subdev(&rj54n1->subdev);
+	if (ret)
+		goto err_gpio_put;
+
+	return 0;
+
+err_gpio_put:
+	if (rj54n1->enable_gpio)
+		gpiod_put(rj54n1->enable_gpio);
+
+	if (rj54n1->pwup_gpio)
+		gpiod_put(rj54n1->pwup_gpio);
+
+err_clk_put:
+	clk_put(rj54n1->clk);
+
+err_free_ctrl:
+	v4l2_ctrl_handler_free(&rj54n1->hdl);
+
 	return ret;
 }
 
 static int rj54n1_remove(struct i2c_client *client)
 {
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	v4l2_clk_put(rj54n1->clk);
-	v4l2_device_unregister_subdev(&rj54n1->subdev);
-	if (ssdd->free_bus)
-		ssdd->free_bus(ssdd);
+	if (rj54n1->enable_gpio)
+		gpiod_put(rj54n1->enable_gpio);
+	if (rj54n1->pwup_gpio)
+		gpiod_put(rj54n1->pwup_gpio);
+
+	clk_put(rj54n1->clk);
 	v4l2_ctrl_handler_free(&rj54n1->hdl);
+	v4l2_async_unregister_subdev(&rj54n1->subdev);
 
 	return 0;
 }
-- 
2.7.4
