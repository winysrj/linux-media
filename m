Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:33356 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934161AbcHaNCv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 09:02:51 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, sre@kernel.org
Subject: [PATCH v1.1 5/5] smiapp: Switch to gpiod API for GPIO control
Date: Wed, 31 Aug 2016 16:00:56 +0300
Message-Id: <1472648456-26608-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472629325-30875-4-git-send-email-sakari.ailus@linux.intel.com>
References: <1472629325-30875-4-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch from the old gpio API to the new descriptor based gpiod API.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
- Remove xshutdown field in smiapp_hwconfig, and SMIAPP_NO_XSHUTDOWN macro

 drivers/media/i2c/smiapp/smiapp-core.c | 36 +++++++++++-----------------------
 drivers/media/i2c/smiapp/smiapp.h      |  1 +
 include/media/i2c/smiapp.h             |  3 ---
 3 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 103e335..1ecc9a4 100644
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
@@ -2572,17 +2569,10 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 		}
 	}
 
-	if (gpio_is_valid(sensor->hwcfg->xshutdown)) {
-		rval = devm_gpio_request_one(
-			&client->dev, sensor->hwcfg->xshutdown, 0,
-			"SMIA++ xshutdown");
-		if (rval < 0) {
-			dev_err(&client->dev,
-				"unable to acquire reset gpio %d\n",
-				sensor->hwcfg->xshutdown);
-			return rval;
-		}
-	}
+	sensor->xshutdown = devm_gpiod_get_optional(&client->dev, "xshutdown",
+						    GPIOD_OUT_LOW);
+	if (!sensor->xshutdown)
+		dev_dbg(&client->dev, "no xshutdown GPIO available\n");
 
 	rval = smiapp_power_on(sensor);
 	if (rval)
@@ -3020,9 +3010,6 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 	hwcfg->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;
 	dev_dbg(dev, "lanes %u\n", hwcfg->lanes);
 
-	/* xshutdown GPIO is optional */
-	hwcfg->xshutdown = of_get_named_gpio(dev->of_node, "reset-gpios", 0);
-
 	/* NVM size is not mandatory */
 	of_property_read_u32(dev->of_node, "nokia,nvm-size",
 				    &hwcfg->nvm_size);
@@ -3034,8 +3021,8 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 		goto out_err;
 	}
 
-	dev_dbg(dev, "reset %d, nvm %d, clk %d, csi %d\n", hwcfg->xshutdown,
-		hwcfg->nvm_size, hwcfg->ext_clk, hwcfg->csi_signalling_mode);
+	dev_dbg(dev, "nvm %d, clk %d, csi %d\n", hwcfg->nvm_size,
+		hwcfg->ext_clk, hwcfg->csi_signalling_mode);
 
 	if (!bus_cfg->nr_of_link_frequencies) {
 		dev_warn(dev, "no link frequencies defined\n");
@@ -3120,8 +3107,7 @@ static int smiapp_remove(struct i2c_client *client)
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
diff --git a/include/media/i2c/smiapp.h b/include/media/i2c/smiapp.h
index a4a1b51..eacc3f4 100644
--- a/include/media/i2c/smiapp.h
+++ b/include/media/i2c/smiapp.h
@@ -36,8 +36,6 @@
 #define SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_STROBE	1
 #define SMIAPP_CSI_SIGNALLING_MODE_CSI2			2
 
-#define SMIAPP_NO_XSHUTDOWN	-1
-
 /*
  * Sometimes due to board layout considerations the camera module can be
  * mounted rotated. The typical rotation used is 180 degrees which can be
@@ -77,7 +75,6 @@ struct smiapp_hwconfig {
 	struct smiapp_flash_strobe_parms *strobe_setup;
 
 	int (*set_xclk)(struct v4l2_subdev *sd, int hz);
-	int32_t xshutdown;		/* gpio or SMIAPP_NO_XSHUTDOWN */
 };
 
 #endif /* __SMIAPP_H_  */
-- 
2.7.4

