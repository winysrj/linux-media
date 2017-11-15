Return-path: <linux-media-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:57855 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932350AbdKOLPE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 06:15:04 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 08/10] media: i2c: ov772x: Remove soc_camera dependencies
Date: Wed, 15 Nov 2017 11:56:01 +0100
Message-Id: <1510743363-25798-9-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove soc_camera framework dependencies from ov772x sensor driver.
- Handle clock directly
- Register async subdevice
- Add platform specific enable/disable functions
- Adjust build system

This commit does not remove the original soc_camera based driver.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/Kconfig  | 12 +++++++
 drivers/media/i2c/Makefile |  1 +
 drivers/media/i2c/ov772x.c | 88 +++++++++++++++++++++++++++++++---------------
 include/media/i2c/ov772x.h |  3 ++
 4 files changed, 76 insertions(+), 28 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 9415389..ff251ce 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -629,6 +629,18 @@ config VIDEO_OV5670
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
+
 config VIDEO_OV7640
 	tristate "OmniVision OV7640 sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index f104650..b2459a1 100644
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
index 8063835..9be7e4e 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -15,6 +15,7 @@
  * published by the Free Software Foundation.
  */

+#include <linux/clk.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -25,8 +26,8 @@
 #include <linux/videodev2.h>

 #include <media/i2c/ov772x.h>
-#include <media/soc_camera.h>
-#include <media/v4l2-clk.h>
+
+#include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-image-sizes.h>
@@ -393,7 +394,7 @@ struct ov772x_win_size {
 struct ov772x_priv {
 	struct v4l2_subdev                subdev;
 	struct v4l2_ctrl_handler	  hdl;
-	struct v4l2_clk			 *clk;
+	struct clk			 *clk;
 	struct ov772x_camera_info        *info;
 	const struct ov772x_color_format *cfmt;
 	const struct ov772x_win_size     *win;
@@ -550,7 +551,7 @@ static int ov772x_reset(struct i2c_client *client)
 }

 /*
- * soc_camera_ops function
+ * subdev ops
  */

 static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
@@ -650,13 +651,36 @@ static int ov772x_s_register(struct v4l2_subdev *sd,
 }
 #endif

+static int ov772x_power_on(struct ov772x_priv *priv)
+{
+	int ret;
+
+	if (priv->info->platform_enable) {
+		ret = priv->info->platform_enable();
+		if (ret)
+			return ret;
+	}
+
+	/*  drivers/sh/clk/core.c returns -EINVAL if clk is NULL */
+	return clk_enable(priv->clk) <= 0 ? 0 : 1;
+}
+
+static int ov772x_power_off(struct ov772x_priv *priv)
+{
+	if (priv->info->platform_enable)
+		priv->info->platform_disable();
+
+	clk_disable(priv->clk);
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
@@ -1000,14 +1024,10 @@ static int ov772x_enum_mbus_code(struct v4l2_subdev *sd,
 static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);

 	return 0;
 }
@@ -1038,12 +1058,11 @@ static int ov772x_probe(struct i2c_client *client,
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
+		dev_err(&adapter->dev, "Missing OV7725 platform data\n");
 		return -EINVAL;
 	}

@@ -1059,7 +1078,7 @@ static int ov772x_probe(struct i2c_client *client,
 	if (!priv)
 		return -ENOMEM;

-	priv->info = ssdd->drv_priv;
+	priv->info = client->dev.platform_data;

 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 3);
@@ -1073,21 +1092,33 @@ static int ov772x_probe(struct i2c_client *client,
 	if (priv->hdl.error)
 		return priv->hdl.error;

-	priv->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(priv->clk)) {
+	priv->clk = clk_get(&client->dev, "mclk");
+	if (PTR_ERR(priv->clk) == -ENOENT) {
+		priv->clk = NULL;
+	} else if (IS_ERR(priv->clk)) {
+		dev_err(&client->dev, "Unable to get mclk clock\n");
 		ret = PTR_ERR(priv->clk);
-		goto eclkget;
+		goto error_clk_enable;
 	}

 	ret = ov772x_video_probe(priv);
-	if (ret < 0) {
-		v4l2_clk_put(priv->clk);
-eclkget:
-		v4l2_ctrl_handler_free(&priv->hdl);
-	} else {
-		priv->cfmt = &ov772x_cfmts[0];
-		priv->win = &ov772x_win_sizes[0];
-	}
+	if (ret < 0)
+		goto error_video_probe;
+
+	priv->cfmt = &ov772x_cfmts[0];
+	priv->win = &ov772x_win_sizes[0];
+
+	ret = v4l2_async_register_subdev(&priv->subdev);
+	if (ret)
+		goto error_video_probe;
+
+	return 0;
+
+error_video_probe:
+	if (priv->clk)
+		clk_put(priv->clk);
+error_clk_enable:
+	v4l2_ctrl_handler_free(&priv->hdl);

 	return ret;
 }
@@ -1096,7 +1127,8 @@ static int ov772x_remove(struct i2c_client *client)
 {
 	struct ov772x_priv *priv = to_ov772x(i2c_get_clientdata(client));

-	v4l2_clk_put(priv->clk);
+	if (priv->clk)
+		clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
diff --git a/include/media/i2c/ov772x.h b/include/media/i2c/ov772x.h
index 00dbb7c..5896dff 100644
--- a/include/media/i2c/ov772x.h
+++ b/include/media/i2c/ov772x.h
@@ -54,6 +54,9 @@ struct ov772x_edge_ctrl {
 struct ov772x_camera_info {
 	unsigned long		flags;
 	struct ov772x_edge_ctrl	edgectrl;
+
+	int (*platform_enable)(void);
+	void (*platform_disable)(void);
 };

 #endif /* __OV772X_H__ */
--
2.7.4
