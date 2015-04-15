Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58820 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752154AbbDOXiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2015 19:38:05 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: pavel@ucw.cz, linux-leds@vger.kernel.org
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	sre@ring0.de
Subject: [PATCH v8 1/1] media: i2c/adp1653: Devicetree support for adp1653
Date: Thu, 16 Apr 2015 02:37:13 +0300
Message-Id: <1429141034-29237-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pavel Machek <pavel@ucw.cz>

Add device tree support for adp1653 flash LED driver.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
Hi folks,

Here's an updated adp1653 DT patch, with changes since v7:

- Include of.h and gpio/consumer.h instead of of_gpio.h and gpio.h.

- Don't initialise ret as zero in __adp1653_set_power(), check ret only when
  it's been set.

- Don't check for node non-NULL in adp1653_of_init(). It never is NULL.

- Remove temporary variable val in adp1653_of_init().

- If the device has no of_node, check that platform data is non-NULL;
  otherwise return an error.

- Assign flash->platform_data only if dev->of_node is NULL.

 drivers/media/i2c/adp1653.c |  100 ++++++++++++++++++++++++++++++++++++++-----
 include/media/adp1653.h     |    8 ++--
 2 files changed, 95 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
index 873fe19..c70abab 100644
--- a/drivers/media/i2c/adp1653.c
+++ b/drivers/media/i2c/adp1653.c
@@ -8,6 +8,7 @@
  * Contributors:
  *	Sakari Ailus <sakari.ailus@iki.fi>
  *	Tuukka Toivonen <tuukkat76@gmail.com>
+ *	Pavel Machek <pavel@ucw.cz>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -34,6 +35,8 @@
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/gpio/consumer.h>
 #include <media/adp1653.h>
 #include <media/v4l2-device.h>
 
@@ -308,16 +311,28 @@ __adp1653_set_power(struct adp1653_flash *flash, int on)
 {
 	int ret;
 
-	ret = flash->platform_data->power(&flash->subdev, on);
-	if (ret < 0)
-		return ret;
+	if (flash->platform_data->power) {
+		ret = flash->platform_data->power(&flash->subdev, on);
+		if (ret < 0)
+			return ret;
+	} else {
+		gpiod_set_value(flash->platform_data->enable_gpio, on);
+		if (on)
+			/* Some delay is apparently required. */
+			udelay(20);
+	}
 
 	if (!on)
 		return 0;
 
 	ret = adp1653_init_device(flash);
-	if (ret < 0)
+	if (ret >= 0)
+		return ret;
+
+	if (flash->platform_data->power)
 		flash->platform_data->power(&flash->subdev, 0);
+	else
+		gpiod_set_value(flash->platform_data->enable_gpio, 0);
 
 	return ret;
 }
@@ -407,21 +422,85 @@ static int adp1653_resume(struct device *dev)
 
 #endif /* CONFIG_PM */
 
+static int adp1653_of_init(struct i2c_client *client,
+			   struct adp1653_flash *flash,
+			   struct device_node *node)
+{
+	struct adp1653_platform_data *pd;
+	struct device_node *child;
+
+	pd = devm_kzalloc(&client->dev, sizeof(*pd), GFP_KERNEL);
+	if (!pd)
+		return -ENOMEM;
+	flash->platform_data = pd;
+
+	child = of_get_child_by_name(node, "flash");
+	if (!child)
+		return -EINVAL;
+
+	if (of_property_read_u32(child, "flash-timeout-us",
+				 &pd->max_flash_timeout))
+		goto err;
+
+	if (of_property_read_u32(child, "flash-max-microamp",
+				 &pd->max_flash_intensity))
+		goto err;
+
+	pd->max_flash_intensity /= 1000;
+
+	if (of_property_read_u32(child, "led-max-microamp",
+				 &pd->max_torch_intensity))
+		goto err;
+
+	pd->max_torch_intensity /= 1000;
+	of_node_put(child);
+
+	child = of_get_child_by_name(node, "indicator");
+	if (!child)
+		return -EINVAL;
+
+	if (of_property_read_u32(child, "led-max-microamp",
+				 &pd->max_indicator_intensity))
+		goto err;
+
+	of_node_put(child);
+
+	pd->enable_gpio = devm_gpiod_get(&client->dev, "enable");
+	if (!pd->enable_gpio) {
+		dev_err(&client->dev, "Error getting GPIO\n");
+		return -EINVAL;
+	}
+
+	return 0;
+err:
+	dev_err(&client->dev, "Required property not found\n");
+	of_node_put(child);
+	return -EINVAL;
+}
+
+
 static int adp1653_probe(struct i2c_client *client,
 			 const struct i2c_device_id *devid)
 {
 	struct adp1653_flash *flash;
 	int ret;
 
-	/* we couldn't work without platform data */
-	if (client->dev.platform_data == NULL)
-		return -ENODEV;
-
 	flash = devm_kzalloc(&client->dev, sizeof(*flash), GFP_KERNEL);
 	if (flash == NULL)
 		return -ENOMEM;
 
-	flash->platform_data = client->dev.platform_data;
+	if (client->dev.of_node) {
+		ret = adp1653_of_init(client, flash, client->dev.of_node);
+		if (ret)
+			return ret;
+	} else {
+		if (!client->dev.platform_data) {
+			dev_err(&client->dev,
+				"Neither DT not platform data provided\n");
+			return EINVAL;
+		}
+		flash->platform_data = client->dev.platform_data;
+	}
 
 	mutex_init(&flash->power_lock);
 
@@ -442,6 +521,7 @@ static int adp1653_probe(struct i2c_client *client,
 	return 0;
 
 free_and_quit:
+	dev_err(&client->dev, "adp1653: failed to register device\n");
 	v4l2_ctrl_handler_free(&flash->ctrls);
 	return ret;
 }
@@ -464,7 +544,7 @@ static const struct i2c_device_id adp1653_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, adp1653_id_table);
 
-static struct dev_pm_ops adp1653_pm_ops = {
+static const struct dev_pm_ops adp1653_pm_ops = {
 	.suspend	= adp1653_suspend,
 	.resume		= adp1653_resume,
 };
diff --git a/include/media/adp1653.h b/include/media/adp1653.h
index 1d9b48a..9779c85 100644
--- a/include/media/adp1653.h
+++ b/include/media/adp1653.h
@@ -100,9 +100,11 @@ struct adp1653_platform_data {
 	int (*power)(struct v4l2_subdev *sd, int on);
 
 	u32 max_flash_timeout;		/* flash light timeout in us */
-	u32 max_flash_intensity;	/* led intensity, flash mode */
-	u32 max_torch_intensity;	/* led intensity, torch mode */
-	u32 max_indicator_intensity;	/* indicator led intensity */
+	u32 max_flash_intensity;	/* led intensity, flash mode, mA */
+	u32 max_torch_intensity;	/* led intensity, torch mode, mA */
+	u32 max_indicator_intensity;	/* indicator led intensity, uA */
+
+	struct gpio_desc *enable_gpio;	/* for device-tree based boot */
 };
 
 #define to_adp1653_flash(sd)	container_of(sd, struct adp1653_flash, subdev)
-- 
1.7.10.4

