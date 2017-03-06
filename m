Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:54742 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754168AbdCFO6v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:58:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 10/15] ov2640: convert from soc-camera to a standard subdev sensor driver.
Date: Mon,  6 Mar 2017 15:56:11 +0100
Message-Id: <20170306145616.38485-11-hverkuil@xs4all.nl>
In-Reply-To: <20170306145616.38485-1-hverkuil@xs4all.nl>
References: <20170306145616.38485-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert ov2640 to a standard subdev driver. The soc-camera driver no longer
uses this driver, so it can safely be converted.

Note: the s_power op has been dropped: this never worked. When the last open()
is closed, then the power is turned off, and when it is opened again the power
is turned on again, but the old state isn't restored.

Someone else can figure out in the future how to get this working correctly,
but I don't want to spend more time on this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig                   | 11 ++++
 drivers/media/i2c/Makefile                  |  1 +
 drivers/media/i2c/{soc_camera => }/ov2640.c | 89 +++++------------------------
 drivers/media/i2c/soc_camera/Kconfig        |  6 --
 drivers/media/i2c/soc_camera/Makefile       |  1 -
 5 files changed, 27 insertions(+), 81 deletions(-)
 rename drivers/media/i2c/{soc_camera => }/ov2640.c (94%)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index cee1dae6e014..db2c63f592c5 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -520,6 +520,17 @@ config VIDEO_APTINA_PLL
 config VIDEO_SMIAPP_PLL
 	tristate
 
+config VIDEO_OV2640
+	tristate "OmniVision OV2640 sensor support"
+	depends on VIDEO_V4L2 && I2C && GPIOLIB
+	depends on MEDIA_CAMERA_SUPPORT
+	help
+	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  OV2640 camera.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ov2640.
+
 config VIDEO_OV2659
 	tristate "OmniVision OV2659 sensor support"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 5bc7bbeb5499..50af1e11c85a 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
 obj-$(CONFIG_VIDEO_SONY_BTF_MPX) += sony-btf-mpx.o
 obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
 obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
+obj-$(CONFIG_VIDEO_OV2640) += ov2640.o
 obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
 obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
 obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/ov2640.c
similarity index 94%
rename from drivers/media/i2c/soc_camera/ov2640.c
rename to drivers/media/i2c/ov2640.c
index b9a0069f5b33..83f88efbce69 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -24,8 +24,8 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
-#include <media/soc_camera.h>
 #include <media/v4l2-clk.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-image-sizes.h>
@@ -287,7 +287,6 @@ struct ov2640_priv {
 	struct v4l2_clk			*clk;
 	const struct ov2640_win_size	*win;
 
-	struct soc_camera_subdev_desc	ssdd_dt;
 	struct gpio_desc *resetb_gpio;
 	struct gpio_desc *pwdn_gpio;
 };
@@ -677,13 +676,8 @@ static int ov2640_reset(struct i2c_client *client)
 }
 
 /*
- * soc_camera_ops functions
+ * functions
  */
-static int ov2640_s_stream(struct v4l2_subdev *sd, int enable)
-{
-	return 0;
-}
-
 static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd =
@@ -744,10 +738,16 @@ static int ov2640_s_register(struct v4l2_subdev *sd,
 static int ov2640_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct ov2640_priv *priv = to_ov2640(client);
 
-	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
+	gpiod_direction_output(priv->pwdn_gpio, !on);
+	if (on && priv->resetb_gpio) {
+		/* Active the resetb pin to perform a reset pulse */
+		gpiod_direction_output(priv->resetb_gpio, 1);
+		usleep_range(3000, 5000);
+		gpiod_direction_output(priv->resetb_gpio, 0);
+	}
+	return 0;
 }
 
 /* Select the nearest higher resolution for capture */
@@ -994,26 +994,6 @@ static struct v4l2_subdev_core_ops ov2640_subdev_core_ops = {
 	.s_power	= ov2640_s_power,
 };
 
-static int ov2640_g_mbus_config(struct v4l2_subdev *sd,
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
-static struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
-	.s_stream	= ov2640_s_stream,
-	.g_mbus_config	= ov2640_g_mbus_config,
-};
-
 static const struct v4l2_subdev_pad_ops ov2640_subdev_pad_ops = {
 	.enum_mbus_code = ov2640_enum_mbus_code,
 	.get_selection	= ov2640_get_selection,
@@ -1023,40 +1003,9 @@ static const struct v4l2_subdev_pad_ops ov2640_subdev_pad_ops = {
 
 static struct v4l2_subdev_ops ov2640_subdev_ops = {
 	.core	= &ov2640_subdev_core_ops,
-	.video	= &ov2640_subdev_video_ops,
 	.pad	= &ov2640_subdev_pad_ops,
 };
 
-/* OF probe functions */
-static int ov2640_hw_power(struct device *dev, int on)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ov2640_priv *priv = to_ov2640(client);
-
-	dev_dbg(&client->dev, "%s: %s the camera\n",
-			__func__, on ? "ENABLE" : "DISABLE");
-
-	if (priv->pwdn_gpio)
-		gpiod_direction_output(priv->pwdn_gpio, !on);
-
-	return 0;
-}
-
-static int ov2640_hw_reset(struct device *dev)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ov2640_priv *priv = to_ov2640(client);
-
-	if (priv->resetb_gpio) {
-		/* Active the resetb pin to perform a reset pulse */
-		gpiod_direction_output(priv->resetb_gpio, 1);
-		usleep_range(3000, 5000);
-		gpiod_direction_output(priv->resetb_gpio, 0);
-	}
-
-	return 0;
-}
-
 static int ov2640_probe_dt(struct i2c_client *client,
 		struct ov2640_priv *priv)
 {
@@ -1076,11 +1025,6 @@ static int ov2640_probe_dt(struct i2c_client *client,
 	else if (IS_ERR(priv->pwdn_gpio))
 		return PTR_ERR(priv->pwdn_gpio);
 
-	/* Initialize the soc_camera_subdev_desc */
-	priv->ssdd_dt.power = ov2640_hw_power;
-	priv->ssdd_dt.reset = ov2640_hw_reset;
-	client->dev.platform_data = &priv->ssdd_dt;
-
 	return 0;
 }
 
@@ -1091,7 +1035,6 @@ static int ov2640_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov2640_priv	*priv;
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	int			ret;
 
@@ -1112,17 +1055,15 @@ static int ov2640_probe(struct i2c_client *client,
 	if (IS_ERR(priv->clk))
 		return -EPROBE_DEFER;
 
-	if (!ssdd && !client->dev.of_node) {
+	if (!client->dev.of_node) {
 		dev_err(&client->dev, "Missing platform_data for driver\n");
 		ret = -EINVAL;
 		goto err_clk;
 	}
 
-	if (!ssdd) {
-		ret = ov2640_probe_dt(client, priv);
-		if (ret)
-			goto err_clk;
-	}
+	ret = ov2640_probe_dt(client, priv);
+	if (ret)
+		goto err_clk;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 2);
@@ -1190,6 +1131,6 @@ static struct i2c_driver ov2640_i2c_driver = {
 
 module_i2c_driver(ov2640_i2c_driver);
 
-MODULE_DESCRIPTION("SoC Camera driver for Omni Vision 2640 sensor");
+MODULE_DESCRIPTION("Driver for Omni Vision 2640 sensor");
 MODULE_AUTHOR("Alberto Panizzo");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/media/i2c/soc_camera/Kconfig
index 7704bcf5cc25..96859f37cb1c 100644
--- a/drivers/media/i2c/soc_camera/Kconfig
+++ b/drivers/media/i2c/soc_camera/Kconfig
@@ -41,12 +41,6 @@ config SOC_CAMERA_MT9V022
 	help
 	  This driver supports MT9V022 cameras from Micron
 
-config SOC_CAMERA_OV2640
-	tristate "ov2640 camera support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This is a ov2640 camera driver
-
 config SOC_CAMERA_OV5642
 	tristate "ov5642 camera support"
 	depends on SOC_CAMERA && I2C
diff --git a/drivers/media/i2c/soc_camera/Makefile b/drivers/media/i2c/soc_camera/Makefile
index 6f994f9353a0..974bdb721dbe 100644
--- a/drivers/media/i2c/soc_camera/Makefile
+++ b/drivers/media/i2c/soc_camera/Makefile
@@ -3,7 +3,6 @@ obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
 obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
 obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
-obj-$(CONFIG_SOC_CAMERA_OV2640)		+= ov2640.o
 obj-$(CONFIG_SOC_CAMERA_OV5642)		+= ov5642.o
 obj-$(CONFIG_SOC_CAMERA_OV6650)		+= ov6650.o
 obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
-- 
2.11.0
