Return-path: <linux-media-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:52215 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932355AbdKOLPE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 06:15:04 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 10/10] media: i2c: tw9910: Remove soc_camera dependencies
Date: Wed, 15 Nov 2017 11:56:03 +0100
Message-Id: <1510743363-25798-11-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove soc_camera framework dependencies from tw9910 sensor driver.
- Handle clock directly
- Register async subdevice
- Add platform specific enable/disable functions
- Adjust build system

This commit does not remove the original soc_camera based driver.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/Kconfig  |  9 ++++++
 drivers/media/i2c/Makefile |  1 +
 drivers/media/i2c/tw9910.c | 80 ++++++++++++++++++++++++++++++++++------------
 include/media/i2c/tw9910.h |  6 ++++
 4 files changed, 75 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index ff251ce..bbd77ee 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -415,6 +415,15 @@ config VIDEO_TW9906
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
index b2459a1..835784a 100644
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
index bdb5e0a..f422da2 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -16,6 +16,7 @@
  * published by the Free Software Foundation.
  */

+#include <linux/clk.h>
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
@@ -228,7 +227,7 @@ struct tw9910_scale_ctrl {

 struct tw9910_priv {
 	struct v4l2_subdev		subdev;
-	struct v4l2_clk			*clk;
+	struct clk			*clk;
 	struct tw9910_video_info	*info;
 	const struct tw9910_scale_ctrl	*scale;
 	v4l2_std_id			norm;
@@ -582,13 +581,40 @@ static int tw9910_s_register(struct v4l2_subdev *sd,
 }
 #endif

+static int tw9910_power_on(struct tw9910_priv *priv)
+{
+	int ret;
+
+	if (priv->info->platform_enable) {
+		ret = priv->info->platform_enable();
+		if (ret)
+			return ret;
+	}
+
+	if (priv->clk)
+		return clk_enable(priv->clk);
+
+	return 0;
+}
+
+static int tw9910_power_off(struct tw9910_priv *priv)
+{
+	if (priv->info->platform_enable)
+		priv->info->platform_disable();
+
+	if (priv->clk)
+		clk_disable(priv->clk);
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
@@ -614,7 +640,7 @@ static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
 	 * set bus width
 	 */
 	val = 0x00;
-	if (SOCAM_DATAWIDTH_16 == priv->info->buswidth)
+	if (priv->info->buswidth == TW9910_DATAWIDTH_16)
 		val = LEN;

 	ret = tw9910_mask_set(client, OPFORM, LEN, val);
@@ -799,8 +825,8 @@ static int tw9910_video_probe(struct i2c_client *client)
 	/*
 	 * tw9910 only use 8 or 16 bit bus width
 	 */
-	if (SOCAM_DATAWIDTH_16 != priv->info->buswidth &&
-	    SOCAM_DATAWIDTH_8  != priv->info->buswidth) {
+	if (priv->info->buswidth != TW9910_DATAWIDTH_16 &&
+	    priv->info->buswidth != TW9910_DATAWIDTH_8) {
 		dev_err(&client->dev, "bus width error\n");
 		return -ENODEV;
 	}
@@ -859,15 +885,11 @@ static int tw9910_enum_mbus_code(struct v4l2_subdev *sd,
 static int tw9910_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
 		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);

 	return 0;
 }
@@ -876,9 +898,8 @@ static int tw9910_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	u8 val = VSSL_VVALID | HSSL_DVALID;
-	unsigned long flags = soc_camera_apply_board_flags(ssdd, cfg);
+	unsigned long flags = cfg->flags;

 	/*
 	 * set OUTCTR1
@@ -935,15 +956,14 @@ static int tw9910_probe(struct i2c_client *client,
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
@@ -959,13 +979,27 @@ static int tw9910_probe(struct i2c_client *client,

 	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);

-	priv->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(priv->clk))
+	priv->clk = clk_get(&client->dev, "mclk");
+	if (PTR_ERR(priv->clk) == -ENOENT) {
+		priv->clk = NULL;
+	} else if (IS_ERR(priv->clk)) {
+		dev_err(&client->dev, "Unable to get mclk clock\n");
 		return PTR_ERR(priv->clk);
+	}

 	ret = tw9910_video_probe(client);
 	if (ret < 0)
-		v4l2_clk_put(priv->clk);
+		goto error_put_clk;
+
+	ret = v4l2_async_register_subdev(&priv->subdev);
+	if (ret)
+		goto error_put_clk;
+
+	return ret;
+
+error_put_clk:
+	if (priv->clk)
+		clk_put(priv->clk);

 	return ret;
 }
@@ -973,7 +1007,11 @@ static int tw9910_probe(struct i2c_client *client,
 static int tw9910_remove(struct i2c_client *client)
 {
 	struct tw9910_priv *priv = to_tw9910(client);
-	v4l2_clk_put(priv->clk);
+
+	if (priv->clk)
+		clk_put(priv->clk);
+	v4l2_device_unregister_subdev(&priv->subdev);
+
 	return 0;
 }

diff --git a/include/media/i2c/tw9910.h b/include/media/i2c/tw9910.h
index 90bcf1f..b80e45c 100644
--- a/include/media/i2c/tw9910.h
+++ b/include/media/i2c/tw9910.h
@@ -18,6 +18,9 @@

 #include <media/soc_camera.h>

+#define TW9910_DATAWIDTH_8	BIT(0)
+#define TW9910_DATAWIDTH_16	BIT(1)
+
 enum tw9910_mpout_pin {
 	TW9910_MPO_VLOSS,
 	TW9910_MPO_HLOCK,
@@ -32,6 +35,9 @@ enum tw9910_mpout_pin {
 struct tw9910_video_info {
 	unsigned long		buswidth;
 	enum tw9910_mpout_pin	mpout;
+
+	int (*platform_enable)(void);
+	void (*platform_disable)(void);
 };


--
2.7.4
