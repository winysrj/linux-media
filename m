Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34959 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750827AbdFPTsV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 15:48:21 -0400
Received: by mail-lf0-f68.google.com with SMTP id v20so5107943lfa.2
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 12:48:21 -0700 (PDT)
From: Janusz Krzysztofik <jmkrzyszt@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: [PATCH v2] media: ov6650: convert to standalone v4l2 subdevice
Date: Fri, 16 Jun 2017 21:45:33 +0200
Message-Id: <20170616194533.20532-1-jmkrzyszt@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the soc_camera dependencies and move the diver to i2c

Lost features, fortunately not used or not critical on test platform:
- soc_camera power on/off callback - replaced with clock enable/disable
  only, no support for platform provided regulators nor power callback,
- soc_camera sense request - replaced with arbitrarily selected default
  master clock rate and pixel clock limit, no support for platform
  requested values,
- soc_camera board flags - no support for platform requested mbus config
  tweaks.

Created against linux-4.12-rc2.
Tested on Amstrad Delta with now out of tree but still locally
maintained omap1_camera host driver.

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
---
 drivers/media/i2c/Kconfig                   | 11 +++++
 drivers/media/i2c/Makefile                  |  1 +
 drivers/media/i2c/{soc_camera => }/ov6650.c | 77 +++++++++--------------------
 drivers/media/i2c/soc_camera/Kconfig        |  6 ---
 drivers/media/i2c/soc_camera/Makefile       |  1 -
 5 files changed, 35 insertions(+), 61 deletions(-)
 rename drivers/media/i2c/{soc_camera => }/ov6650.c (92%)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index fd181c9..a3c1dff 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -562,6 +562,17 @@ config VIDEO_OV5647
 	  To compile this driver as a module, choose M here: the
 	  module will be called ov5647.
 
+config VIDEO_OV6650
+	tristate "OmniVision OV6650 sensor support"
+	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  OV6650 camera.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ov6650.
+
 config VIDEO_OV7640
 	tristate "OmniVision OV7640 sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 62323ec..be58ac0 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
 obj-$(CONFIG_VIDEO_OV2640) += ov2640.o
 obj-$(CONFIG_VIDEO_OV5645) += ov5645.o
 obj-$(CONFIG_VIDEO_OV5647) += ov5647.o
+obj-$(CONFIG_VIDEO_OV6650) += ov6650.o
 obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
 obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
 obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/ov6650.c
similarity index 92%
rename from drivers/media/i2c/soc_camera/ov6650.c
rename to drivers/media/i2c/ov6650.c
index dbd6d92..2f7b7a7 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -1,5 +1,5 @@
 /*
- * V4L2 SoC Camera driver for OmniVision OV6650 Camera Sensor
+ * V4L2 subdevice driver for OmniVision OV6650 Camera Sensor
  *
  * Copyright (C) 2010 Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
  *
@@ -31,9 +31,9 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
 
 /* Register definitions */
 #define REG_GAIN		0x00	/* range 00 - 3F */
@@ -426,10 +426,15 @@ static int ov6650_set_register(struct v4l2_subdev *sd,
 static int ov6650_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct ov6650 *priv = to_ov6650(client);
+	int ret = 0;
 
-	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
+	if (on)
+		ret = v4l2_clk_enable(priv->clk);
+	else
+		v4l2_clk_disable(priv->clk);
+
+	return ret;
 }
 
 static int ov6650_get_selection(struct v4l2_subdev *sd,
@@ -471,14 +476,13 @@ static int ov6650_set_selection(struct v4l2_subdev *sd,
 	    sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
-	rect.left   = ALIGN(rect.left,   2);
-	rect.width  = ALIGN(rect.width,  2);
-	rect.top    = ALIGN(rect.top,    2);
-	rect.height = ALIGN(rect.height, 2);
-	soc_camera_limit_side(&rect.left, &rect.width,
-			DEF_HSTRT << 1, 2, W_CIF);
-	soc_camera_limit_side(&rect.top, &rect.height,
-			DEF_VSTRT << 1, 2, H_CIF);
+	v4l_bound_align_image(&rect.width, 2, W_CIF, 1,
+			      &rect.height, 2, H_CIF, 1, 0);
+	v4l_bound_align_image(&rect.left, DEF_HSTRT << 1,
+			      (DEF_HSTRT << 1) + W_CIF - (__s32)rect.width, 1,
+			      &rect.top, DEF_VSTRT << 1,
+			      (DEF_VSTRT << 1) + H_CIF - (__s32)rect.height, 1,
+			      0);
 
 	ret = ov6650_reg_write(client, REG_HSTRT, rect.left >> 1);
 	if (!ret) {
@@ -547,8 +551,6 @@ static u8 to_clkrc(struct v4l2_fract *timeperframe,
 static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = v4l2_get_subdev_hostdata(sd);
-	struct soc_camera_sense *sense = icd->sense;
 	struct ov6650 *priv = to_ov6650(client);
 	bool half_scale = !is_unscaled_ok(mf->width, mf->height, &priv->rect);
 	struct v4l2_subdev_selection sel = {
@@ -640,32 +642,10 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 	}
 	priv->half_scale = half_scale;
 
-	if (sense) {
-		if (sense->master_clock == 8000000) {
-			dev_dbg(&client->dev, "8MHz input clock\n");
-			clkrc = CLKRC_6MHz;
-		} else if (sense->master_clock == 12000000) {
-			dev_dbg(&client->dev, "12MHz input clock\n");
-			clkrc = CLKRC_12MHz;
-		} else if (sense->master_clock == 16000000) {
-			dev_dbg(&client->dev, "16MHz input clock\n");
-			clkrc = CLKRC_16MHz;
-		} else if (sense->master_clock == 24000000) {
-			dev_dbg(&client->dev, "24MHz input clock\n");
-			clkrc = CLKRC_24MHz;
-		} else {
-			dev_err(&client->dev,
-				"unsupported input clock, check platform data\n");
-			return -EINVAL;
-		}
-		mclk = sense->master_clock;
-		priv->pclk_limit = sense->pixel_clock_max;
-	} else {
-		clkrc = CLKRC_24MHz;
-		mclk = 24000000;
-		priv->pclk_limit = 0;
-		dev_dbg(&client->dev, "using default 24MHz input clock\n");
-	}
+	clkrc = CLKRC_12MHz;
+	mclk = 12000000;
+	priv->pclk_limit = 1334000;
+	dev_dbg(&client->dev, "using 12MHz input clock\n");
 
 	clkrc |= to_clkrc(&priv->tpf, priv->pclk_limit, priv->pclk_max);
 
@@ -897,8 +877,6 @@ static const struct v4l2_subdev_core_ops ov6650_core_ops = {
 static int ov6650_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	cfg->flags = V4L2_MBUS_MASTER |
 		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
@@ -906,7 +884,6 @@ static int ov6650_g_mbus_config(struct v4l2_subdev *sd,
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -916,25 +893,23 @@ static int ov6650_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-	unsigned long flags = soc_camera_apply_board_flags(ssdd, cfg);
 	int ret;
 
-	if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
+	if (cfg->flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
 		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_PCLK_RISING, 0);
 	else
 		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_PCLK_RISING);
 	if (ret)
 		return ret;
 
-	if (flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+	if (cfg->flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
 		ret = ov6650_reg_rmw(client, REG_COMF, COMF_HREF_LOW, 0);
 	else
 		ret = ov6650_reg_rmw(client, REG_COMF, 0, COMF_HREF_LOW);
 	if (ret)
 		return ret;
 
-	if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
+	if (cfg->flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
 		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_VSYNC_HIGH, 0);
 	else
 		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_VSYNC_HIGH);
@@ -971,14 +946,8 @@ static int ov6650_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov6650 *priv;
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	if (!ssdd) {
-		dev_err(&client->dev, "Missing platform_data for driver\n");
-		return -EINVAL;
-	}
-
 	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
 		dev_err(&client->dev,
diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/media/i2c/soc_camera/Kconfig
index 96859f3..72b3698 100644
--- a/drivers/media/i2c/soc_camera/Kconfig
+++ b/drivers/media/i2c/soc_camera/Kconfig
@@ -47,12 +47,6 @@ config SOC_CAMERA_OV5642
 	help
 	  This is a V4L2 camera driver for the OmniVision OV5642 sensor
 
-config SOC_CAMERA_OV6650
-	tristate "ov6650 sensor support"
-	depends on SOC_CAMERA && I2C
-	---help---
-	  This is a V4L2 SoC camera driver for the OmniVision OV6650 sensor
-
 config SOC_CAMERA_OV772X
 	tristate "ov772x camera support"
 	depends on SOC_CAMERA && I2C
diff --git a/drivers/media/i2c/soc_camera/Makefile b/drivers/media/i2c/soc_camera/Makefile
index 974bdb7..78532a7 100644
--- a/drivers/media/i2c/soc_camera/Makefile
+++ b/drivers/media/i2c/soc_camera/Makefile
@@ -4,7 +4,6 @@ obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
 obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV5642)		+= ov5642.o
-obj-$(CONFIG_SOC_CAMERA_OV6650)		+= ov6650.o
 obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
 obj-$(CONFIG_SOC_CAMERA_OV9640)		+= ov9640.o
 obj-$(CONFIG_SOC_CAMERA_OV9740)		+= ov9740.o
-- 
2.10.2
