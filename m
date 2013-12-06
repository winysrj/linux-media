Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3847 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141Ab3LFKRn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 05:17:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dinesh.Ram@cern.ch, edubezval@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 08/11] si4713: move supply list to si4713_platform_data
Date: Fri,  6 Dec 2013 11:17:11 +0100
Message-Id: <1386325034-19344-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
References: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dinesh Ram <Dinesh.Ram@cern.ch>

The supply list is needed by the platform driver, but not by the usb driver.
So this information belongs to the platform data and should not be hardcoded
in the subdevice driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Eduardo Valentin <edubezval@gmail.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |  7 ++++
 drivers/media/radio/si4713/si4713.c          | 52 ++++++++++++++--------------
 drivers/media/radio/si4713/si4713.h          |  3 +-
 include/media/si4713.h                       |  2 ++
 4 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index f093af1..8760bbe 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -760,7 +760,14 @@ static struct regulator_init_data rx51_vintdig = {
 	},
 };
 
+static const char * const si4713_supply_names[] = {
+	"vio",
+	"vdd",
+};
+
 static struct si4713_platform_data rx51_si4713_i2c_data __initdata_or_module = {
+	.supplies	= ARRAY_SIZE(si4713_supply_names),
+	.supply_names	= si4713_supply_names,
 	.gpio_reset	= RX51_FMTX_RESET_GPIO,
 };
 
diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 4931325..097d4e0 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -44,11 +44,6 @@ MODULE_AUTHOR("Eduardo Valentin <eduardo.valentin@nokia.com>");
 MODULE_DESCRIPTION("I2C driver for Si4713 FM Radio Transmitter");
 MODULE_VERSION("0.0.1");
 
-static const char *si4713_supply_names[SI4713_NUM_SUPPLIES] = {
-	"vio",
-	"vdd",
-};
-
 #define DEFAULT_RDS_PI			0x00
 #define DEFAULT_RDS_PTY			0x00
 #define DEFAULT_RDS_DEVIATION		0x00C8
@@ -368,11 +363,12 @@ static int si4713_powerup(struct si4713_device *sdev)
 	if (sdev->power_state)
 		return 0;
 
-	err = regulator_bulk_enable(ARRAY_SIZE(sdev->supplies),
-				    sdev->supplies);
-	if (err) {
-		v4l2_err(&sdev->sd, "Failed to enable supplies: %d\n", err);
-		return err;
+	if (sdev->supplies) {
+		err = regulator_bulk_enable(sdev->supplies, sdev->supply_data);
+		if (err) {
+			v4l2_err(&sdev->sd, "Failed to enable supplies: %d\n", err);
+			return err;
+		}
 	}
 	if (gpio_is_valid(sdev->gpio_reset)) {
 		udelay(50);
@@ -396,11 +392,12 @@ static int si4713_powerup(struct si4713_device *sdev)
 		if (client->irq)
 			err = si4713_write_property(sdev, SI4713_GPO_IEN,
 						SI4713_STC_INT | SI4713_CTS);
-	} else {
-		if (gpio_is_valid(sdev->gpio_reset))
-			gpio_set_value(sdev->gpio_reset, 0);
-		err = regulator_bulk_disable(ARRAY_SIZE(sdev->supplies),
-					     sdev->supplies);
+		return err;
+	}
+	if (gpio_is_valid(sdev->gpio_reset))
+		gpio_set_value(sdev->gpio_reset, 0);
+	if (sdev->supplies) {
+		err = regulator_bulk_disable(sdev->supplies, sdev->supply_data);
 		if (err)
 			v4l2_err(&sdev->sd,
 				 "Failed to disable supplies: %d\n", err);
@@ -432,11 +429,13 @@ static int si4713_powerdown(struct si4713_device *sdev)
 		v4l2_dbg(1, debug, &sdev->sd, "Device in reset mode\n");
 		if (gpio_is_valid(sdev->gpio_reset))
 			gpio_set_value(sdev->gpio_reset, 0);
-		err = regulator_bulk_disable(ARRAY_SIZE(sdev->supplies),
-					     sdev->supplies);
-		if (err)
-			v4l2_err(&sdev->sd,
-				 "Failed to disable supplies: %d\n", err);
+		if (sdev->supplies) {
+			err = regulator_bulk_disable(sdev->supplies,
+						     sdev->supply_data);
+			if (err)
+				v4l2_err(&sdev->sd,
+					 "Failed to disable supplies: %d\n", err);
+		}
 		sdev->power_state = POWER_OFF;
 	}
 
@@ -1381,13 +1380,14 @@ static int si4713_probe(struct i2c_client *client,
 		}
 		sdev->gpio_reset = pdata->gpio_reset;
 		gpio_direction_output(sdev->gpio_reset, 0);
+		sdev->supplies = pdata->supplies;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(sdev->supplies); i++)
-		sdev->supplies[i].supply = si4713_supply_names[i];
+	for (i = 0; i < sdev->supplies; i++)
+		sdev->supply_data[i].supply = pdata->supply_names[i];
 
-	rval = regulator_bulk_get(&client->dev, ARRAY_SIZE(sdev->supplies),
-				  sdev->supplies);
+	rval = regulator_bulk_get(&client->dev, sdev->supplies,
+				  sdev->supply_data);
 	if (rval) {
 		dev_err(&client->dev, "Cannot get regulators: %d\n", rval);
 		goto free_gpio;
@@ -1500,7 +1500,7 @@ free_irq:
 free_ctrls:
 	v4l2_ctrl_handler_free(hdl);
 put_reg:
-	regulator_bulk_free(ARRAY_SIZE(sdev->supplies), sdev->supplies);
+	regulator_bulk_free(sdev->supplies, sdev->supply_data);
 free_gpio:
 	if (gpio_is_valid(sdev->gpio_reset))
 		gpio_free(sdev->gpio_reset);
@@ -1524,7 +1524,7 @@ static int si4713_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	regulator_bulk_free(ARRAY_SIZE(sdev->supplies), sdev->supplies);
+	regulator_bulk_free(sdev->supplies, sdev->supply_data);
 	if (gpio_is_valid(sdev->gpio_reset))
 		gpio_free(sdev->gpio_reset);
 	kfree(sdev);
diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
index 1410cd2..4837cf6 100644
--- a/drivers/media/radio/si4713/si4713.h
+++ b/drivers/media/radio/si4713/si4713.h
@@ -227,7 +227,8 @@ struct si4713_device {
 		struct v4l2_ctrl *tune_ant_cap;
 	};
 	struct completion work;
-	struct regulator_bulk_data supplies[SI4713_NUM_SUPPLIES];
+	unsigned supplies;
+	struct regulator_bulk_data supply_data[SI4713_NUM_SUPPLIES];
 	int gpio_reset;
 	u32 power_state;
 	u32 rds_enabled;
diff --git a/include/media/si4713.h b/include/media/si4713.h
index ed7353e..f98a0a7 100644
--- a/include/media/si4713.h
+++ b/include/media/si4713.h
@@ -23,6 +23,8 @@
  * Platform dependent definition
  */
 struct si4713_platform_data {
+	const char * const *supply_names;
+	unsigned supplies;
 	int gpio_reset; /* < 0 if not used */
 };
 
-- 
1.8.4.rc3

