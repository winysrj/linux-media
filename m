Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57190 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936681AbeCBQgZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 11:36:25 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        sakari.ailus@iki.fi, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] media: i2c: mt9t112: Remove soc_camera dependencies
Date: Fri,  2 Mar 2018 17:35:38 +0100
Message-Id: <1520008541-3961-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1520008541-3961-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520008541-3961-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove soc_camera framework dependencies from mt9t112 sensor driver.
- Handle clk, gpios and power routines
- Register async subdev
- Remove deprecated g/s_mbus_config operations
- Remove driver flags
- Change driver interface and add kernel doc
- Adjust build system

This commit does not remove the original soc_camera based driver as long
as other platforms depends on soc_camera framework.

As I don't have access to a working camera module, this change has only
been compile tested.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/Kconfig   |  11 ++++
 drivers/media/i2c/Makefile  |   1 +
 drivers/media/i2c/mt9t112.c | 147 +++++++++++++++++++++-----------------------
 include/media/i2c/mt9t112.h |  17 +++--
 4 files changed, 89 insertions(+), 87 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index d7bba0e..541f0d28 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -788,6 +788,17 @@ config VIDEO_MT9T001
 	  This is a Video4Linux2 sensor-level driver for the Aptina
 	  (Micron) mt0t001 3 Mpixel camera.

+config VIDEO_MT9T112
+	tristate "Aptina MT9T111/MT9T112 support"
+	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the Aptina
+	  (Micron) MT9T111 and MT9T112 3 Mpixel camera.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mt9t112.
+
 config VIDEO_MT9V011
 	tristate "Micron mt9v011 sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index cc30178..ea34aee 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
 obj-$(CONFIG_VIDEO_MT9M111) += mt9m111.o
 obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
 obj-$(CONFIG_VIDEO_MT9T001) += mt9t001.o
+obj-$(CONFIG_VIDEO_MT9T112) += mt9t112.o
 obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
 obj-$(CONFIG_VIDEO_MT9V032) += mt9v032.o
 obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
diff --git a/drivers/media/i2c/mt9t112.c b/drivers/media/i2c/mt9t112.c
index 297d22e..6b77dff 100644
--- a/drivers/media/i2c/mt9t112.c
+++ b/drivers/media/i2c/mt9t112.c
@@ -1,6 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * mt9t112 Camera Driver
  *
+ * Copyright (C) 2017 Jacopo Mondi <jacopo+renesas@jmondi.org>
+ *
  * Copyright (C) 2009 Renesas Solutions Corp.
  * Kuninori Morimoto <morimoto.kuninori@renesas.com>
  *
@@ -11,13 +14,11 @@
  * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
  * Copyright (C) 2008 Magnus Damm
  * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */

+#include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -26,10 +27,9 @@
 #include <linux/videodev2.h>

 #include <media/i2c/mt9t112.h>
-#include <media/soc_camera.h>
-#include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-image-sizes.h>
+#include <media/v4l2-subdev.h>

 /* you can check PLL/clock info */
 /* #define EXT_CLOCK 24000000 */
@@ -85,16 +85,14 @@ struct mt9t112_format {

 struct mt9t112_priv {
 	struct v4l2_subdev		 subdev;
-	struct mt9t112_camera_info	*info;
+	struct mt9t112_platform_data	*info;
 	struct i2c_client		*client;
 	struct v4l2_rect		 frame;
-	struct v4l2_clk			*clk;
+	struct clk			*clk;
+	struct gpio_desc		*standby_gpio;
 	const struct mt9t112_format	*format;
 	int				 num_formats;
-	u32				 flags;
-/* for flags */
-#define INIT_DONE	(1 << 0)
-#define PCLK_RISING	(1 << 1)
+	bool				 init_done;
 };

 /************************************************************************
@@ -341,12 +339,6 @@ static int mt9t112_clock_info(const struct i2c_client *client, u32 ext)
 }
 #endif

-static void mt9t112_frame_check(u32 *width, u32 *height, u32 *left, u32 *top)
-{
-	soc_camera_limit_side(left, width, 0, 0, MAX_WIDTH);
-	soc_camera_limit_side(top, height, 0, 0, MAX_HEIGHT);
-}
-
 static int mt9t112_set_a_frame_size(const struct i2c_client *client,
 				   u16 width,
 				   u16 height)
@@ -764,13 +756,40 @@ static int mt9t112_s_register(struct v4l2_subdev *sd,
 }
 #endif

+static int mt9t112_power_on(struct mt9t112_priv *priv)
+{
+	int ret;
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
+	if (priv->standby_gpio) {
+		gpiod_set_value(priv->standby_gpio, 0);
+		msleep(100);
+	}
+
+	return 0;
+}
+
+static int mt9t112_power_off(struct mt9t112_priv *priv)
+{
+	clk_disable_unprepare(priv->clk);
+	if (priv->standby_gpio) {
+		gpiod_set_value(priv->standby_gpio, 1);
+		msleep(100);
+	}
+
+	return 0;
+}
+
 static int mt9t112_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct mt9t112_priv *priv = to_mt9t112(client);

-	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
+	return on ? mt9t112_power_on(priv) :
+		    mt9t112_power_off(priv);
 }

 static const struct v4l2_subdev_core_ops mt9t112_subdev_core_ops = {
@@ -805,8 +824,9 @@ static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
 		return ret;
 	}

-	if (!(priv->flags & INIT_DONE)) {
-		u16 param = PCLK_RISING & priv->flags ? 0x0001 : 0x0000;
+	if (!priv->init_done) {
+		u16 param = MT9T112_FLAG_PCLK_RISING_EDGE & priv->info->flags ?
+			    0x0001 : 0x0000;

 		ECHECKER(ret, mt9t112_init_camera(client));

@@ -815,7 +835,7 @@ static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)

 		mdelay(5);

-		priv->flags |= INIT_DONE;
+		priv->init_done = true;
 	}

 	mt9t112_mcu_write(ret, client, VAR(26, 7), priv->format->fmt);
@@ -859,8 +879,8 @@ static int mt9t112_set_params(struct mt9t112_priv *priv,
 	/*
 	 * frame size check
 	 */
-	mt9t112_frame_check(&priv->frame.width, &priv->frame.height,
-			    &priv->frame.left, &priv->frame.top);
+	v4l_bound_align_image(&priv->frame.width, 0, MAX_WIDTH, 0,
+			      &priv->frame.height, 0, MAX_HEIGHT, 0, 0);

 	priv->format = mt9t112_cfmts + i;

@@ -961,7 +981,6 @@ static int mt9t112_set_fmt(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t112_priv *priv = to_mt9t112(client);
-	unsigned int top, left;
 	int i;

 	if (format->pad)
@@ -978,7 +997,8 @@ static int mt9t112_set_fmt(struct v4l2_subdev *sd,
 		mf->colorspace	= mt9t112_cfmts[i].colorspace;
 	}

-	mt9t112_frame_check(&mf->width, &mf->height, &left, &top);
+	v4l_bound_align_image(&mf->width, 0, MAX_WIDTH, 0,
+			      &mf->height, 0, MAX_HEIGHT, 0, 0);

 	mf->field = V4L2_FIELD_NONE;

@@ -1003,38 +1023,8 @@ static int mt9t112_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }

-static int mt9t112_g_mbus_config(struct v4l2_subdev *sd,
-				 struct v4l2_mbus_config *cfg)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-
-	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
-		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_DATA_ACTIVE_HIGH |
-		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING;
-	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
-
-	return 0;
-}
-
-static int mt9t112_s_mbus_config(struct v4l2_subdev *sd,
-				 const struct v4l2_mbus_config *cfg)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-	struct mt9t112_priv *priv = to_mt9t112(client);
-
-	if (soc_camera_apply_board_flags(ssdd, cfg) & V4L2_MBUS_PCLK_SAMPLE_RISING)
-		priv->flags |= PCLK_RISING;
-
-	return 0;
-}
-
 static const struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
 	.s_stream	= mt9t112_s_stream,
-	.g_mbus_config	= mt9t112_g_mbus_config,
-	.s_mbus_config	= mt9t112_s_mbus_config,
 };

 static const struct v4l2_subdev_pad_ops mt9t112_subdev_pad_ops = {
@@ -1096,16 +1086,9 @@ static int mt9t112_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9t112_priv *priv;
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-	struct v4l2_rect rect = {
-		.width = VGA_WIDTH,
-		.height = VGA_HEIGHT,
-		.left = (MAX_WIDTH - VGA_WIDTH) / 2,
-		.top = (MAX_HEIGHT - VGA_HEIGHT) / 2,
-	};
 	int ret;

-	if (!ssdd || !ssdd->drv_priv) {
+	if (!client->dev.platform_data) {
 		dev_err(&client->dev, "mt9t112: missing platform data!\n");
 		return -EINVAL;
 	}
@@ -1114,30 +1097,40 @@ static int mt9t112_probe(struct i2c_client *client,
 	if (!priv)
 		return -ENOMEM;

-	priv->info = ssdd->drv_priv;
+	priv->info = client->dev.platform_data;
+	priv->init_done = false;

 	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);

-	priv->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(priv->clk))
+	priv->clk = devm_clk_get(&client->dev, "extclk");
+	if (PTR_ERR(priv->clk) == -ENOENT) {
+		priv->clk = NULL;
+	} else if (IS_ERR(priv->clk)) {
+		dev_err(&client->dev, "Unable to get clock \"extclk\"\n");
 		return PTR_ERR(priv->clk);
+	}

-	ret = mt9t112_camera_probe(client);
+	priv->standby_gpio = devm_gpiod_get_optional(&client->dev, "standby",
+						     GPIOD_OUT_HIGH);
+	if (IS_ERR(priv->standby_gpio)) {
+		dev_err(&client->dev, "Unable to get gpio \"standby\"\n");
+		return PTR_ERR(priv->standby_gpio);
+	}

-	/* Cannot fail: using the default supported pixel code */
-	if (!ret)
-		mt9t112_set_params(priv, &rect, MEDIA_BUS_FMT_UYVY8_2X8);
-	else
-		v4l2_clk_put(priv->clk);
+	ret = mt9t112_camera_probe(client);
+	if (ret)
+		return ret;

-	return ret;
+	return  v4l2_async_register_subdev(&priv->subdev);
 }

 static int mt9t112_remove(struct i2c_client *client)
 {
 	struct mt9t112_priv *priv = to_mt9t112(client);

-	v4l2_clk_put(priv->clk);
+	clk_disable_unprepare(priv->clk);
+	v4l2_async_unregister_subdev(&priv->subdev);
+
 	return 0;
 }

@@ -1158,6 +1151,6 @@ static struct i2c_driver mt9t112_i2c_driver = {

 module_i2c_driver(mt9t112_i2c_driver);

-MODULE_DESCRIPTION("SoC Camera driver for mt9t112");
+MODULE_DESCRIPTION("V4L2 driver for MT9T111/MT9T112 camera sensor");
 MODULE_AUTHOR("Kuninori Morimoto");
 MODULE_LICENSE("GPL v2");
diff --git a/include/media/i2c/mt9t112.h b/include/media/i2c/mt9t112.h
index a43c74a..cc80d5c 100644
--- a/include/media/i2c/mt9t112.h
+++ b/include/media/i2c/mt9t112.h
@@ -1,28 +1,25 @@
+/*  SPDX-License-Identifier: GPL-2.0 */
 /* mt9t112 Camera
  *
  * Copyright (C) 2009 Renesas Solutions Corp.
  * Kuninori Morimoto <morimoto.kuninori@renesas.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */

 #ifndef __MT9T112_H__
 #define __MT9T112_H__

-#define MT9T112_FLAG_PCLK_RISING_EDGE	(1 << 0)
-#define MT9T112_FLAG_DATAWIDTH_8	(1 << 1) /* default width is 10 */
-
 struct mt9t112_pll_divider {
 	u8 m, n;
 	u8 p1, p2, p3, p4, p5, p6, p7;
 };

-/*
- * mt9t112 camera info
+/**
+ * mt9t112_platform_data -	mt9t112 driver interface
+ * @flags:			Sensor media bus configuration.
+ * @divider:			Sensor PLL configuration
  */
-struct mt9t112_camera_info {
+struct mt9t112_platform_data {
+#define MT9T112_FLAG_PCLK_RISING_EDGE	BIT(0)
 	u32 flags;
 	struct mt9t112_pll_divider divider;
 };
--
2.7.4
