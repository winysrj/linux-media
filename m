Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:41844 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754144AbeAGQyq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 Jan 2018 11:54:46 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v2 1/2] media: ov9650: support device tree probing
Date: Mon,  8 Jan 2018 01:54:23 +0900
Message-Id: <1515344064-23156-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1515344064-23156-1-git-send-email-akinobu.mita@gmail.com>
References: <1515344064-23156-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov9650 driver currently only supports legacy platform data probe.
This change adds device tree probing.

There has been an attempt to add device tree support for ov9650 driver
by Hugues Fruchet as a part of the patchset that adds support of OV9655
camera (http://www.spinics.net/lists/linux-media/msg117903.html), but
it wasn't merged into mainline because creating a separate driver for
OV9655 is preferred.

This is very similar to Hugues's patch, but not supporting new device.

Cc: Jacopo Mondi <jacopo@jmondi.org>
Cc: H. Nikolaus Schaller <hns@goldelico.com>
Cc: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* Changelog v2
- Split binding documentation, suggested by Rob Herring and Jacopo Mondi
- Remove ov965x_gpio_set() helper and open-code it, suggested by Jacopo Mondi
  and Sakari Ailus
- Call clk_prepare_enable() in s_power callback instead of probe, suggested
  by Sakari Ailus
- Unify clk and gpio configuration in a single if-else block and, also add
  a check either platform data or fwnode is actually specified, suggested
  by Jacopo Mondi
- Add CONFIG_OF guards, suggested by Jacopo Mondi

 drivers/media/i2c/ov9650.c | 130 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 92 insertions(+), 38 deletions(-)

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 69433e1..99a3eab 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -11,8 +11,10 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
 #include <linux/media.h>
@@ -249,9 +251,10 @@ struct ov965x {
 	struct v4l2_subdev sd;
 	struct media_pad pad;
 	enum v4l2_mbus_type bus_type;
-	int gpios[NUM_GPIOS];
+	struct gpio_desc *gpios[NUM_GPIOS];
 	/* External master clock frequency */
 	unsigned long mclk_frequency;
+	struct clk *clk;
 
 	/* Protects the struct fields below */
 	struct mutex lock;
@@ -513,24 +516,27 @@ static int ov965x_set_color_matrix(struct ov965x *ov965x)
 	return 0;
 }
 
-static void ov965x_gpio_set(int gpio, int val)
-{
-	if (gpio_is_valid(gpio))
-		gpio_set_value(gpio, val);
-}
-
-static void __ov965x_set_power(struct ov965x *ov965x, int on)
+static int __ov965x_set_power(struct ov965x *ov965x, int on)
 {
 	if (on) {
-		ov965x_gpio_set(ov965x->gpios[GPIO_PWDN], 0);
-		ov965x_gpio_set(ov965x->gpios[GPIO_RST], 0);
+		int ret = clk_prepare_enable(ov965x->clk);
+
+		if (ret)
+			return ret;
+
+		gpiod_set_value_cansleep(ov965x->gpios[GPIO_PWDN], 0);
+		gpiod_set_value_cansleep(ov965x->gpios[GPIO_RST], 0);
 		msleep(25);
 	} else {
-		ov965x_gpio_set(ov965x->gpios[GPIO_RST], 1);
-		ov965x_gpio_set(ov965x->gpios[GPIO_PWDN], 1);
+		gpiod_set_value_cansleep(ov965x->gpios[GPIO_RST], 1);
+		gpiod_set_value_cansleep(ov965x->gpios[GPIO_PWDN], 1);
+
+		clk_disable_unprepare(ov965x->clk);
 	}
 
 	ov965x->streaming = 0;
+
+	return 0;
 }
 
 static int ov965x_s_power(struct v4l2_subdev *sd, int on)
@@ -543,8 +549,8 @@ static int ov965x_s_power(struct v4l2_subdev *sd, int on)
 
 	mutex_lock(&ov965x->lock);
 	if (ov965x->power == !on) {
-		__ov965x_set_power(ov965x, on);
-		if (on) {
+		ret = __ov965x_set_power(ov965x, on);
+		if (!ret && on) {
 			ret = ov965x_write_array(client,
 						 ov965x_init_regs);
 			ov965x->apply_frame_fmt = 1;
@@ -1408,16 +1414,17 @@ static const struct v4l2_subdev_ops ov965x_subdev_ops = {
 /*
  * Reset and power down GPIOs configuration
  */
-static int ov965x_configure_gpios(struct ov965x *ov965x,
-				  const struct ov9650_platform_data *pdata)
+static int ov965x_configure_gpios_pdata(struct ov965x *ov965x,
+				const struct ov9650_platform_data *pdata)
 {
 	int ret, i;
+	int gpios[NUM_GPIOS];
 
-	ov965x->gpios[GPIO_PWDN] = pdata->gpio_pwdn;
-	ov965x->gpios[GPIO_RST]  = pdata->gpio_reset;
+	gpios[GPIO_PWDN] = pdata->gpio_pwdn;
+	gpios[GPIO_RST]  = pdata->gpio_reset;
 
 	for (i = 0; i < ARRAY_SIZE(ov965x->gpios); i++) {
-		int gpio = ov965x->gpios[i];
+		int gpio = gpios[i];
 
 		if (!gpio_is_valid(gpio))
 			continue;
@@ -1427,9 +1434,30 @@ static int ov965x_configure_gpios(struct ov965x *ov965x,
 			return ret;
 		v4l2_dbg(1, debug, &ov965x->sd, "set gpio %d to 1\n", gpio);
 
-		gpio_set_value(gpio, 1);
+		gpio_set_value_cansleep(gpio, 1);
 		gpio_export(gpio, 0);
-		ov965x->gpios[i] = gpio;
+		ov965x->gpios[i] = gpio_to_desc(gpio);
+	}
+
+	return 0;
+}
+
+static int ov965x_configure_gpios(struct ov965x *ov965x)
+{
+	struct device *dev = &ov965x->client->dev;
+
+	ov965x->gpios[GPIO_PWDN] = devm_gpiod_get_optional(dev, "powerdown",
+							GPIOD_OUT_HIGH);
+	if (IS_ERR(ov965x->gpios[GPIO_PWDN])) {
+		dev_info(dev, "can't get %s GPIO\n", "powerdown");
+		return PTR_ERR(ov965x->gpios[GPIO_PWDN]);
+	}
+
+	ov965x->gpios[GPIO_RST] = devm_gpiod_get_optional(dev, "reset",
+							GPIOD_OUT_HIGH);
+	if (IS_ERR(ov965x->gpios[GPIO_RST])) {
+		dev_info(dev, "can't get %s GPIO\n", "reset");
+		return PTR_ERR(ov965x->gpios[GPIO_RST]);
 	}
 
 	return 0;
@@ -1443,7 +1471,10 @@ static int ov965x_detect_sensor(struct v4l2_subdev *sd)
 	int ret;
 
 	mutex_lock(&ov965x->lock);
-	__ov965x_set_power(ov965x, 1);
+	ret = __ov965x_set_power(ov965x, 1);
+	if (ret)
+		goto out;
+
 	msleep(25);
 
 	/* Check sensor revision */
@@ -1463,6 +1494,7 @@ static int ov965x_detect_sensor(struct v4l2_subdev *sd)
 			ret = -ENODEV;
 		}
 	}
+out:
 	mutex_unlock(&ov965x->lock);
 
 	return ret;
@@ -1476,23 +1508,39 @@ static int ov965x_probe(struct i2c_client *client,
 	struct ov965x *ov965x;
 	int ret;
 
-	if (!pdata) {
-		dev_err(&client->dev, "platform data not specified\n");
-		return -EINVAL;
-	}
-
-	if (pdata->mclk_frequency == 0) {
-		dev_err(&client->dev, "MCLK frequency not specified\n");
-		return -EINVAL;
-	}
-
 	ov965x = devm_kzalloc(&client->dev, sizeof(*ov965x), GFP_KERNEL);
 	if (!ov965x)
 		return -ENOMEM;
 
-	mutex_init(&ov965x->lock);
 	ov965x->client = client;
-	ov965x->mclk_frequency = pdata->mclk_frequency;
+
+	if (pdata) {
+		if (pdata->mclk_frequency == 0) {
+			dev_err(&client->dev, "MCLK frequency not specified\n");
+			return -EINVAL;
+		}
+		ov965x->mclk_frequency = pdata->mclk_frequency;
+
+		ret = ov965x_configure_gpios_pdata(ov965x, pdata);
+		if (ret < 0)
+			return ret;
+	} else if (dev_fwnode(&client->dev)) {
+		ov965x->clk = devm_clk_get(&ov965x->client->dev, NULL);
+		if (IS_ERR(ov965x->clk))
+			return PTR_ERR(ov965x->clk);
+		ov965x->mclk_frequency = clk_get_rate(ov965x->clk);
+
+		ret = ov965x_configure_gpios(ov965x);
+		if (ret < 0)
+			return ret;
+	} else {
+		dev_err(&client->dev,
+			"Neither platform data nor device property specified\n");
+
+		return -EINVAL;
+	}
+
+	mutex_init(&ov965x->lock);
 
 	sd = &ov965x->sd;
 	v4l2_i2c_subdev_init(sd, client, &ov965x_subdev_ops);
@@ -1502,10 +1550,6 @@ static int ov965x_probe(struct i2c_client *client,
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
 		     V4L2_SUBDEV_FL_HAS_EVENTS;
 
-	ret = ov965x_configure_gpios(ov965x, pdata);
-	if (ret < 0)
-		goto err_mutex;
-
 	ov965x->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	ret = media_entity_pads_init(&sd->entity, 1, &ov965x->pad);
@@ -1561,9 +1605,19 @@ static const struct i2c_device_id ov965x_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ov965x_id);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id ov965x_of_match[] = {
+	{ .compatible = "ovti,ov9650", },
+	{ .compatible = "ovti,ov9652", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ov965x_of_match);
+#endif
+
 static struct i2c_driver ov965x_i2c_driver = {
 	.driver = {
 		.name	= DRIVER_NAME,
+		.of_match_table = of_match_ptr(ov965x_of_match),
 	},
 	.probe		= ov965x_probe,
 	.remove		= ov965x_remove,
-- 
2.7.4
