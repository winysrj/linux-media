Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:51448 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932794AbcHaHnI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 03:43:08 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 2351120872
        for <linux-media@vger.kernel.org>; Wed, 31 Aug 2016 10:43:01 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] smiapp: Switch to gpiod API for GPIO control
Date: Wed, 31 Aug 2016 10:42:05 +0300
Message-Id: <1472629325-30875-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch from the old gpio API to the new descriptor based gpiod API.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 28 +++++++++++++++-------------
 drivers/media/i2c/smiapp/smiapp.h      |  1 +
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index aaf5299..d07e060 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -24,8 +24,8 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/module.h>
-#include <linux/of_gpio.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/smiapp.h>
@@ -1212,8 +1212,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	}
 	usleep_range(1000, 1000);
 
-	if (gpio_is_valid(sensor->hwcfg->xshutdown))
-		gpio_set_value(sensor->hwcfg->xshutdown, 1);
+	gpiod_set_value(sensor->xshutdown, 1);
 
 	sleep = SMIAPP_RESET_DELAY(sensor->hwcfg->ext_clk);
 	usleep_range(sleep, sleep);
@@ -1322,8 +1321,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	return 0;
 
 out_cci_addr_fail:
-	if (gpio_is_valid(sensor->hwcfg->xshutdown))
-		gpio_set_value(sensor->hwcfg->xshutdown, 0);
+	gpiod_set_value(sensor->xshutdown, 0);
 	if (sensor->hwcfg->set_xclk)
 		sensor->hwcfg->set_xclk(&sensor->src->sd, 0);
 	else
@@ -1348,8 +1346,7 @@ static void smiapp_power_off(struct smiapp_sensor *sensor)
 			     SMIAPP_REG_U8_SOFTWARE_RESET,
 			     SMIAPP_SOFTWARE_RESET);
 
-	if (gpio_is_valid(sensor->hwcfg->xshutdown))
-		gpio_set_value(sensor->hwcfg->xshutdown, 0);
+	gpiod_set_value(sensor->xshutdown, 0);
 	if (sensor->hwcfg->set_xclk)
 		sensor->hwcfg->set_xclk(&sensor->src->sd, 0);
 	else
@@ -2571,7 +2568,11 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 		}
 	}
 
-	if (gpio_is_valid(sensor->hwcfg->xshutdown)) {
+	if (client->dev.of_node) {
+		sensor->xshutdown =
+			devm_gpiod_get_optional(&client->dev, "xshutdown",
+						GPIOD_OUT_LOW);
+	} else if (gpio_is_valid(sensor->hwcfg->xshutdown)) {
 		rval = devm_gpio_request_one(
 			&client->dev, sensor->hwcfg->xshutdown, 0,
 			"SMIA++ xshutdown");
@@ -2581,8 +2582,13 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 				sensor->hwcfg->xshutdown);
 			return rval;
 		}
+
+		sensor->xshutdown = gpio_to_desc(sensor->hwcfg->xshutdown);
 	}
 
+	if (!sensor->xshutdown)
+		dev_dbg(&client->dev, "no xshutdown GPIO available\n");
+
 	rval = smiapp_power_on(sensor);
 	if (rval)
 		return -ENODEV;
@@ -3019,9 +3025,6 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 	hwcfg->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;
 	dev_dbg(dev, "lanes %u\n", hwcfg->lanes);
 
-	/* xshutdown GPIO is optional */
-	hwcfg->xshutdown = of_get_named_gpio(dev->of_node, "reset-gpios", 0);
-
 	/* NVM size is not mandatory */
 	of_property_read_u32(dev->of_node, "nokia,nvm-size",
 				    &hwcfg->nvm_size);
@@ -3119,8 +3122,7 @@ static int smiapp_remove(struct i2c_client *client)
 	v4l2_async_unregister_subdev(subdev);
 
 	if (sensor->power_count) {
-		if (gpio_is_valid(sensor->hwcfg->xshutdown))
-			gpio_set_value(sensor->hwcfg->xshutdown, 0);
+		gpiod_set_value(sensor->xshutdown, 0);
 		if (sensor->hwcfg->set_xclk)
 			sensor->hwcfg->set_xclk(&sensor->src->sd, 0);
 		else
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index 6ff095a..c504bd8 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -200,6 +200,7 @@ struct smiapp_sensor {
 	struct smiapp_hwconfig *hwcfg;
 	struct regulator *vana;
 	struct clk *ext_clk;
+	struct gpio_desc *xshutdown;
 	u32 limits[SMIAPP_LIMIT_LAST];
 	u8 nbinning_subtypes;
 	struct smiapp_binning_subtype binning_subtypes[SMIAPP_BINNING_SUBTYPES];
-- 
2.7.4

