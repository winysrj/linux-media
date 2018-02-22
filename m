Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48939 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753579AbeBVKic (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 05:38:32 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 09/10] media: i2c: tw9910: Remove soc_camera dependencies
Date: Thu, 22 Feb 2018 11:37:25 +0100
Message-Id: <1519295846-11612-10-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519295846-11612-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519295846-11612-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove soc_camera framework dependencies from tw9910 sensor driver.
- Handle clock and gpios
- Register async subdevice
- Remove soc_camera specific g/s_mbus_config operations
- Add kernel doc to driver interface header file
- Adjust build system

This commit does not remove the original soc_camera based driver as long
as other platforms depends on soc_camera-based CEU driver.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig  |   9 +++
 drivers/media/i2c/Makefile |   1 +
 drivers/media/i2c/tw9910.c | 162 ++++++++++++++++++++++++++++-----------------
 include/media/i2c/tw9910.h |   9 +++
 4 files changed, 120 insertions(+), 61 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index e71e968..0460613 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -423,6 +423,15 @@ config VIDEO_TW9906
 	  To compile this driver as a module, choose M here: the
 	  module will be called tw9906.
 
+config VIDEO_TW9910
+	tristate "Techwell TW9910 video decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for Techwell TW9910 NTSC/PAL/SECAM video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tw9910.
+
 config VIDEO_VPX3220
 	tristate "vpx3220a, vpx3216b & vpx3214c video decoders"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index b0489a1..23c3ac6 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
 obj-$(CONFIG_VIDEO_TW2804) += tw2804.o
 obj-$(CONFIG_VIDEO_TW9903) += tw9903.o
 obj-$(CONFIG_VIDEO_TW9906) += tw9906.o
+obj-$(CONFIG_VIDEO_TW9910) += tw9910.o
 obj-$(CONFIG_VIDEO_CS3308) += cs3308.o
 obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
 obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index bdb5e0a..96792df 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -1,6 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * tw9910 Video Driver
  *
+ * Copyright (C) 2017 Jacopo Mondi <jacopo+renesas@jmondi.org>
+ *
  * Copyright (C) 2008 Renesas Solutions Corp.
  * Kuninori Morimoto <morimoto.kuninori@renesas.com>
  *
@@ -10,12 +13,10 @@
  * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
  * Copyright (C) 2008 Magnus Damm
  * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
+#include <linux/clk.h>
+#include <linux/gpio/consumer.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
@@ -25,9 +26,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
-#include <media/soc_camera.h>
 #include <media/i2c/tw9910.h>
-#include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 
 #define GET_ID(val)  ((val & 0xF8) >> 3)
@@ -228,8 +227,10 @@ struct tw9910_scale_ctrl {
 
 struct tw9910_priv {
 	struct v4l2_subdev		subdev;
-	struct v4l2_clk			*clk;
+	struct clk			*clk;
 	struct tw9910_video_info	*info;
+	struct gpio_desc		*pdn_gpio;
+	struct gpio_desc		*rstb_gpio;
 	const struct tw9910_scale_ctrl	*scale;
 	v4l2_std_id			norm;
 	u32				revision;
@@ -582,13 +583,66 @@ static int tw9910_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
+static int tw9910_power_on(struct tw9910_priv *priv)
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
+	if (priv->pdn_gpio) {
+		gpiod_set_value(priv->pdn_gpio, 0);
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
+static int tw9910_power_off(struct tw9910_priv *priv)
+{
+	clk_disable_unprepare(priv->clk);
+
+	if (priv->pdn_gpio) {
+		gpiod_set_value(priv->pdn_gpio, 1);
+		usleep_range(500, 1000);
+	}
+
+	return 0;
+}
+
 static int tw9910_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct tw9910_priv *priv = to_tw9910(client);
 
-	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
+	return on ? tw9910_power_on(priv) :
+		    tw9910_power_off(priv);
 }
 
 static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
@@ -614,7 +668,7 @@ static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
 	 * set bus width
 	 */
 	val = 0x00;
-	if (SOCAM_DATAWIDTH_16 == priv->info->buswidth)
+	if (priv->info->buswidth == 16)
 		val = LEN;
 
 	ret = tw9910_mask_set(client, OPFORM, LEN, val);
@@ -799,8 +853,7 @@ static int tw9910_video_probe(struct i2c_client *client)
 	/*
 	 * tw9910 only use 8 or 16 bit bus width
 	 */
-	if (SOCAM_DATAWIDTH_16 != priv->info->buswidth &&
-	    SOCAM_DATAWIDTH_8  != priv->info->buswidth) {
+	if (priv->info->buswidth != 16 && priv->info->buswidth != 8) {
 		dev_err(&client->dev, "bus width error\n");
 		return -ENODEV;
 	}
@@ -856,45 +909,6 @@ static int tw9910_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int tw9910_g_mbus_config(struct v4l2_subdev *sd,
-				struct v4l2_mbus_config *cfg)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-
-	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
-		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
-		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW |
-		V4L2_MBUS_DATA_ACTIVE_HIGH;
-	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
-
-	return 0;
-}
-
-static int tw9910_s_mbus_config(struct v4l2_subdev *sd,
-				const struct v4l2_mbus_config *cfg)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-	u8 val = VSSL_VVALID | HSSL_DVALID;
-	unsigned long flags = soc_camera_apply_board_flags(ssdd, cfg);
-
-	/*
-	 * set OUTCTR1
-	 *
-	 * We use VVALID and DVALID signals to control VSYNC and HSYNC
-	 * outputs, in this mode their polarity is inverted.
-	 */
-	if (flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
-		val |= HSP_HI;
-
-	if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
-		val |= VSP_HI;
-
-	return i2c_smbus_write_byte_data(client, OUTCTR1, val);
-}
-
 static int tw9910_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
 {
 	*norm = V4L2_STD_NTSC | V4L2_STD_PAL;
@@ -905,8 +919,6 @@ static const struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.s_std		= tw9910_s_std,
 	.g_std		= tw9910_g_std,
 	.s_stream	= tw9910_s_stream,
-	.g_mbus_config	= tw9910_g_mbus_config,
-	.s_mbus_config	= tw9910_s_mbus_config,
 	.g_tvnorms	= tw9910_g_tvnorms,
 };
 
@@ -935,15 +947,14 @@ static int tw9910_probe(struct i2c_client *client,
 	struct tw9910_video_info	*info;
 	struct i2c_adapter		*adapter =
 		to_i2c_adapter(client->dev.parent);
-	struct soc_camera_subdev_desc	*ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	if (!ssdd || !ssdd->drv_priv) {
+	if (!client->dev.platform_data) {
 		dev_err(&client->dev, "TW9910: missing platform data!\n");
 		return -EINVAL;
 	}
 
-	info = ssdd->drv_priv;
+	info = client->dev.platform_data;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&client->dev,
@@ -959,13 +970,37 @@ static int tw9910_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);
 
-	priv->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(priv->clk))
+	priv->clk = clk_get(&client->dev, "xti");
+	if (PTR_ERR(priv->clk) == -ENOENT) {
+		priv->clk = NULL;
+	} else if (IS_ERR(priv->clk)) {
+		dev_err(&client->dev, "Unable to get xti clock\n");
 		return PTR_ERR(priv->clk);
+	}
+
+	priv->pdn_gpio = gpiod_get_optional(&client->dev, "pdn",
+					    GPIOD_OUT_HIGH);
+	if (IS_ERR(priv->pdn_gpio)) {
+		dev_info(&client->dev, "Unable to get GPIO \"pdn\"");
+		ret = PTR_ERR(priv->pdn_gpio);
+		goto error_clk_put;
+	}
 
 	ret = tw9910_video_probe(client);
 	if (ret < 0)
-		v4l2_clk_put(priv->clk);
+		goto error_gpio_put;
+
+	ret = v4l2_async_register_subdev(&priv->subdev);
+	if (ret)
+		goto error_gpio_put;
+
+	return ret;
+
+error_gpio_put:
+	if (priv->pdn_gpio)
+		gpiod_put(priv->pdn_gpio);
+error_clk_put:
+	clk_put(priv->clk);
 
 	return ret;
 }
@@ -973,7 +1008,12 @@ static int tw9910_probe(struct i2c_client *client,
 static int tw9910_remove(struct i2c_client *client)
 {
 	struct tw9910_priv *priv = to_tw9910(client);
-	v4l2_clk_put(priv->clk);
+
+	if (priv->pdn_gpio)
+		gpiod_put(priv->pdn_gpio);
+	clk_put(priv->clk);
+	v4l2_device_unregister_subdev(&priv->subdev);
+
 	return 0;
 }
 
@@ -994,6 +1034,6 @@ static struct i2c_driver tw9910_i2c_driver = {
 
 module_i2c_driver(tw9910_i2c_driver);
 
-MODULE_DESCRIPTION("SoC Camera driver for tw9910");
+MODULE_DESCRIPTION("V4L2 driver for TW9910 video decoder");
 MODULE_AUTHOR("Kuninori Morimoto");
 MODULE_LICENSE("GPL v2");
diff --git a/include/media/i2c/tw9910.h b/include/media/i2c/tw9910.h
index 90bcf1f..bec8f7b 100644
--- a/include/media/i2c/tw9910.h
+++ b/include/media/i2c/tw9910.h
@@ -18,6 +18,9 @@
 
 #include <media/soc_camera.h>
 
+/**
+ * tw9910_mpout_pin - MPOUT (multi-purpose output) pin functions
+ */
 enum tw9910_mpout_pin {
 	TW9910_MPO_VLOSS,
 	TW9910_MPO_HLOCK,
@@ -29,6 +32,12 @@ enum tw9910_mpout_pin {
 	TW9910_MPO_RTCO,
 };
 
+/**
+ * tw9910_video_info -	tw9910 driver interface structure
+ * @buswidth:		Parallel data bus width (8 or 16).
+ * @mpout:		Selected function of MPOUT (multi-purpose output) pin.
+ *			See &enum tw9910_mpout_pin
+ */
 struct tw9910_video_info {
 	unsigned long		buswidth;
 	enum tw9910_mpout_pin	mpout;
-- 
2.7.4
