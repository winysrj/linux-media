Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:19757 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaLHLae (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 06:30:34 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>
CC: <m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<g.liakhovetski@gmx.de>, Josh Wu <josh.wu@atmel.com>,
	<devicetree@vger.kernel.org>
Subject: [PATCH 3/5] media: ov2640: add primary dt support
Date: Mon, 8 Dec 2014 19:29:05 +0800
Message-ID: <1418038147-13221-4-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1418038147-13221-1-git-send-email-josh.wu@atmel.com>
References: <1418038147-13221-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device tree support for ov2640.

Cc: devicetree@vger.kernel.org
Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
v1 -> v2:
  1. use gpiod APIs.
  2. change the gpio pin's name according to datasheet.
  3. reduce the delay for .reset() function.

 drivers/media/i2c/soc_camera/ov2640.c | 86 ++++++++++++++++++++++++++++++++---
 1 file changed, 80 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 9ee910d..2a57979 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -18,6 +18,8 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
@@ -283,6 +285,10 @@ struct ov2640_priv {
 	u32	cfmt_code;
 	struct v4l2_clk			*clk;
 	const struct ov2640_win_size	*win;
+
+	struct soc_camera_subdev_desc	ssdd_dt;
+	struct gpio_desc *resetb_gpio;
+	struct gpio_desc *pwdn_gpio;
 };
 
 /*
@@ -1047,6 +1053,61 @@ static struct v4l2_subdev_ops ov2640_subdev_ops = {
 	.video	= &ov2640_subdev_video_ops,
 };
 
+/* OF probe functions */
+static int ov2640_hw_power(struct device *dev, int on)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct ov2640_priv *priv = to_ov2640(client);
+
+	dev_dbg(&client->dev, "%s: %s the camera\n",
+			__func__, on ? "ENABLE" : "DISABLE");
+
+	if (priv->pwdn_gpio && !IS_ERR(priv->pwdn_gpio))
+		gpiod_direction_output(priv->pwdn_gpio, !on);
+
+	return 0;
+}
+
+static int ov2640_hw_reset(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct ov2640_priv *priv = to_ov2640(client);
+
+	/* If enabled, give a reset impulse */
+	if (priv->resetb_gpio && !IS_ERR(priv->resetb_gpio)) {
+		gpiod_direction_output(priv->resetb_gpio, 0);
+		usleep_range(3000, 5000);
+		gpiod_direction_output(priv->resetb_gpio, 1);
+	}
+
+	return 0;
+}
+
+static int ov2640_probe_dt(struct i2c_client *client,
+		struct ov2640_priv *priv)
+{
+	priv->resetb_gpio = devm_gpiod_get_optional(&client->dev, "resetb",
+			GPIOD_OUT_HIGH);
+	if (!priv->resetb_gpio)
+		dev_warn(&client->dev, "resetb gpio not found!\n");
+	else if (IS_ERR(priv->resetb_gpio))
+		return -EINVAL;
+
+	priv->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",
+			GPIOD_OUT_HIGH);
+	if (!priv->pwdn_gpio)
+		dev_warn(&client->dev, "pwdn gpio not found!\n");
+	else if (IS_ERR(priv->pwdn_gpio))
+		return -EINVAL;
+
+	/* Initialize the soc_camera_subdev_desc */
+	priv->ssdd_dt.power = ov2640_hw_power;
+	priv->ssdd_dt.reset = ov2640_hw_reset;
+	client->dev.platform_data = &priv->ssdd_dt;
+
+	return 0;
+}
+
 /*
  * i2c_driver functions
  */
@@ -1058,12 +1119,6 @@ static int ov2640_probe(struct i2c_client *client,
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	int			ret;
 
-	if (!ssdd) {
-		dev_err(&adapter->dev,
-			"OV2640: Missing platform_data for driver\n");
-		return -EINVAL;
-	}
-
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&adapter->dev,
 			"OV2640: I2C-Adapter doesn't support SMBUS\n");
@@ -1077,6 +1132,18 @@ static int ov2640_probe(struct i2c_client *client,
 		return -ENOMEM;
 	}
 
+	if (!ssdd) {
+		if (client->dev.of_node) {
+			ret = ov2640_probe_dt(client, priv);
+			if (ret)
+				return ret;
+		} else {
+			dev_err(&client->dev,
+				"Missing platform_data for driver\n");
+			return  -EINVAL;
+		}
+	}
+
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 2);
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
@@ -1123,9 +1190,16 @@ static const struct i2c_device_id ov2640_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ov2640_id);
 
+static const struct of_device_id ov2640_of_match[] = {
+	{.compatible = "ovti,ov2640", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ov2640_of_match);
+
 static struct i2c_driver ov2640_i2c_driver = {
 	.driver = {
 		.name = "ov2640",
+		.of_match_table = of_match_ptr(ov2640_of_match),
 	},
 	.probe    = ov2640_probe,
 	.remove   = ov2640_remove,
-- 
1.9.1

