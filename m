Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:58725 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934023AbeALOE6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 09:04:58 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 6/9] media: i2c: ov772x: Remove soc_camera dependencies
Date: Fri, 12 Jan 2018 15:04:06 +0100
Message-Id: <1515765849-10345-7-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1515765849-10345-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1515765849-10345-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove soc_camera framework dependencies from ov772x sensor driver.
- Handle clock and gpios
- Register async subdevice
- Remove soc_camera specific g/s_mbus_config operations
- Change image format colorspace from JPEG to SRGB as the two use the
  same colorspace information but JPEG makes assumptions on color
  components quantization that do not apply to the sensor
- Remove sizes crop from get_selection as driver can't scale
- Add kernel doc to driver interface header file
- Adjust build system

This commit does not remove the original soc_camera based driver as long
as other platforms depends on soc_camera-based CEU driver.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/Kconfig  |  11 +++
 drivers/media/i2c/Makefile |   1 +
 drivers/media/i2c/ov772x.c | 177 ++++++++++++++++++++++++++++++---------------
 include/media/i2c/ov772x.h |   6 +-
 4 files changed, 133 insertions(+), 62 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index cb5d7ff..a61d7f4 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -645,6 +645,17 @@ config VIDEO_OV5670
 	  To compile this driver as a module, choose M here: the
 	  module will be called ov5670.
 
+config VIDEO_OV772X
+	tristate "OmniVision OV772x sensor support"
+	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  OV772x camera.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ov772x.
+
 config VIDEO_OV7640
 	tristate "OmniVision OV7640 sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 548a9ef..fb99293 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -66,6 +66,7 @@ obj-$(CONFIG_VIDEO_OV5645) += ov5645.o
 obj-$(CONFIG_VIDEO_OV5647) += ov5647.o
 obj-$(CONFIG_VIDEO_OV5670) += ov5670.o
 obj-$(CONFIG_VIDEO_OV6650) += ov6650.o
+obj-$(CONFIG_VIDEO_OV772X) += ov772x.o
 obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
 obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
 obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 8063835..df2516c 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1,6 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * ov772x Camera Driver
  *
+ * Copyright (C) 2017 Jacopo Mondi <jacopo+renesas@jmondi.org>
+ *
  * Copyright (C) 2008 Renesas Solutions Corp.
  * Kuninori Morimoto <morimoto.kuninori@renesas.com>
  *
@@ -9,27 +12,25 @@
  * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
  * Copyright (C) 2008 Magnus Damm
  * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/gpio/consumer.h>
+#include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/i2c.h>
 #include <linux/slab.h>
-#include <linux/delay.h>
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
 #include <media/i2c/ov772x.h>
-#include <media/soc_camera.h>
-#include <media/v4l2-clk.h>
+
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-subdev.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-image-sizes.h>
+#include <media/v4l2-subdev.h>
 
 /*
  * register offset
@@ -393,8 +394,10 @@ struct ov772x_win_size {
 struct ov772x_priv {
 	struct v4l2_subdev                subdev;
 	struct v4l2_ctrl_handler	  hdl;
-	struct v4l2_clk			 *clk;
+	struct clk			 *clk;
 	struct ov772x_camera_info        *info;
+	struct gpio_desc		 *pwdn_gpio;
+	struct gpio_desc		 *rstb_gpio;
 	const struct ov772x_color_format *cfmt;
 	const struct ov772x_win_size     *win;
 	unsigned short                    flag_vflip:1;
@@ -409,7 +412,7 @@ struct ov772x_priv {
 static const struct ov772x_color_format ov772x_cfmts[] = {
 	{
 		.code		= MEDIA_BUS_FMT_YUYV8_2X8,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.dsp3		= 0x0,
 		.dsp4		= DSP_OFMT_YUV,
 		.com3		= SWAP_YUV,
@@ -417,7 +420,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 	},
 	{
 		.code		= MEDIA_BUS_FMT_YVYU8_2X8,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.dsp3		= UV_ON,
 		.dsp4		= DSP_OFMT_YUV,
 		.com3		= SWAP_YUV,
@@ -425,7 +428,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 	},
 	{
 		.code		= MEDIA_BUS_FMT_UYVY8_2X8,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.dsp3		= 0x0,
 		.dsp4		= DSP_OFMT_YUV,
 		.com3		= 0x0,
@@ -550,7 +553,7 @@ static int ov772x_reset(struct i2c_client *client)
 }
 
 /*
- * soc_camera_ops function
+ * subdev ops
  */
 
 static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
@@ -650,13 +653,65 @@ static int ov772x_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
+static int ov772x_power_on(struct ov772x_priv *priv)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
+	int ret;
+
+	if (priv->clk) {
+		ret = clk_prepare_enable(priv->clk);
+		if (ret)
+			return ret;
+	}
+
+	if (priv->pwdn_gpio) {
+		gpiod_set_value(priv->pwdn_gpio, 1);
+		usleep_range(500, 1000);
+	}
+
+	/*
+	 * FIXME: The reset signal is connected to a shared GPIO on some
+	 * platforms (namely the SuperH Migo-R). Until a framework becomes
+	 * available to handle this cleanly, request the GPIO temporarily
+	 * to avoid conflicts.
+	 */
+	priv->rstb_gpio = gpiod_get_optional(&client->dev, "rstb",
+					     GPIOD_OUT_LOW);
+	if (IS_ERR(priv->rstb_gpio)) {
+		dev_info(&client->dev, "Unable to get GPIO \"rstb\"");
+		return PTR_ERR(priv->rstb_gpio);
+	}
+
+	if (priv->rstb_gpio) {
+		gpiod_set_value(priv->rstb_gpio, 1);
+		usleep_range(500, 1000);
+		gpiod_set_value(priv->rstb_gpio, 0);
+		usleep_range(500, 1000);
+
+		gpiod_put(priv->rstb_gpio);
+	}
+
+	return 0;
+}
+
+static int ov772x_power_off(struct ov772x_priv *priv)
+{
+	clk_disable_unprepare(priv->clk);
+
+	if (priv->pwdn_gpio) {
+		gpiod_set_value(priv->pwdn_gpio, 0);
+		usleep_range(500, 1000);
+	}
+
+	return 0;
+}
+
 static int ov772x_s_power(struct v4l2_subdev *sd, int on)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct ov772x_priv *priv = to_ov772x(sd);
 
-	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
+	return on ? ov772x_power_on(priv) :
+		    ov772x_power_off(priv);
 }
 
 static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
@@ -855,24 +910,21 @@ static int ov772x_get_selection(struct v4l2_subdev *sd,
 		struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_selection *sel)
 {
+	struct ov772x_priv *priv = to_ov772x(sd);
+
 	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
 		return -EINVAL;
 
-	sel->r.left = 0;
-	sel->r.top = 0;
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP_BOUNDS:
 	case V4L2_SEL_TGT_CROP_DEFAULT:
-		sel->r.width = OV772X_MAX_WIDTH;
-		sel->r.height = OV772X_MAX_HEIGHT;
-		return 0;
 	case V4L2_SEL_TGT_CROP:
-		sel->r.width = VGA_WIDTH;
-		sel->r.height = VGA_HEIGHT;
-		return 0;
-	default:
-		return -EINVAL;
+		sel->r.width = priv->win->rect.width;
+		sel->r.height = priv->win->rect.height;
+		break;
 	}
+
+	return 0;
 }
 
 static int ov772x_get_fmt(struct v4l2_subdev *sd,
@@ -997,24 +1049,8 @@ static int ov772x_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
-				struct v4l2_mbus_config *cfg)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-
-	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
-		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
-		V4L2_MBUS_DATA_ACTIVE_HIGH;
-	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
-
-	return 0;
-}
-
 static const struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
 	.s_stream	= ov772x_s_stream,
-	.g_mbus_config	= ov772x_g_mbus_config,
 };
 
 static const struct v4l2_subdev_pad_ops ov772x_subdev_pad_ops = {
@@ -1038,12 +1074,11 @@ static int ov772x_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov772x_priv	*priv;
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
+	struct i2c_adapter	*adapter = client->adapter;
 	int			ret;
 
-	if (!ssdd || !ssdd->drv_priv) {
-		dev_err(&client->dev, "OV772X: missing platform data!\n");
+	if (!client->dev.platform_data) {
+		dev_err(&client->dev, "Missing OV7725 platform data\n");
 		return -EINVAL;
 	}
 
@@ -1059,7 +1094,7 @@ static int ov772x_probe(struct i2c_client *client,
 	if (!priv)
 		return -ENOMEM;
 
-	priv->info = ssdd->drv_priv;
+	priv->info = client->dev.platform_data;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 3);
@@ -1073,22 +1108,42 @@ static int ov772x_probe(struct i2c_client *client,
 	if (priv->hdl.error)
 		return priv->hdl.error;
 
-	priv->clk = v4l2_clk_get(&client->dev, "mclk");
+	priv->clk = clk_get(&client->dev, "xclk");
 	if (IS_ERR(priv->clk)) {
+		dev_err(&client->dev, "Unable to get xclk clock\n");
 		ret = PTR_ERR(priv->clk);
-		goto eclkget;
+		goto error_ctrl_free;
 	}
 
-	ret = ov772x_video_probe(priv);
-	if (ret < 0) {
-		v4l2_clk_put(priv->clk);
-eclkget:
-		v4l2_ctrl_handler_free(&priv->hdl);
-	} else {
-		priv->cfmt = &ov772x_cfmts[0];
-		priv->win = &ov772x_win_sizes[0];
+	priv->pwdn_gpio = gpiod_get_optional(&client->dev, "pwdn",
+					     GPIOD_OUT_LOW);
+	if (IS_ERR(priv->pwdn_gpio)) {
+		dev_info(&client->dev, "Unable to get GPIO \"pwdn\"");
+		ret = PTR_ERR(priv->pwdn_gpio);
+		goto error_clk_put;
 	}
 
+	ret = ov772x_video_probe(priv);
+	if (ret < 0)
+		goto error_gpio_put;
+
+	priv->cfmt = &ov772x_cfmts[0];
+	priv->win = &ov772x_win_sizes[0];
+
+	ret = v4l2_async_register_subdev(&priv->subdev);
+	if (ret)
+		goto error_gpio_put;
+
+	return 0;
+
+error_gpio_put:
+	if (priv->pwdn_gpio)
+		gpiod_put(priv->pwdn_gpio);
+error_clk_put:
+	clk_put(priv->clk);
+error_ctrl_free:
+	v4l2_ctrl_handler_free(&priv->hdl);
+
 	return ret;
 }
 
@@ -1096,7 +1151,9 @@ static int ov772x_remove(struct i2c_client *client)
 {
 	struct ov772x_priv *priv = to_ov772x(i2c_get_clientdata(client));
 
-	v4l2_clk_put(priv->clk);
+	clk_put(priv->clk);
+	if (priv->pwdn_gpio)
+		gpiod_put(priv->pwdn_gpio);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
@@ -1119,6 +1176,6 @@ static struct i2c_driver ov772x_i2c_driver = {
 
 module_i2c_driver(ov772x_i2c_driver);
 
-MODULE_DESCRIPTION("SoC Camera driver for ov772x");
+MODULE_DESCRIPTION("V4L2 driver for OV772x image sensor");
 MODULE_AUTHOR("Kuninori Morimoto");
 MODULE_LICENSE("GPL v2");
diff --git a/include/media/i2c/ov772x.h b/include/media/i2c/ov772x.h
index 00dbb7c..27d087b 100644
--- a/include/media/i2c/ov772x.h
+++ b/include/media/i2c/ov772x.h
@@ -48,8 +48,10 @@ struct ov772x_edge_ctrl {
 	.threshold = (t & OV772X_EDGE_THRESHOLD_MASK),	\
 }
 
-/*
- * ov772x camera info
+/**
+ * ov772x_camera_info -	ov772x driver interface structure
+ * @flags:		Sensor configuration flags
+ * @edgectrl:		Sensor edge control
  */
 struct ov772x_camera_info {
 	unsigned long		flags;
-- 
2.7.4
