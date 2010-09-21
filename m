Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65526 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab0IUItn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 04:49:43 -0400
Received: by mail-ey0-f174.google.com with SMTP id 6so1842068eyb.19
        for <linux-media@vger.kernel.org>; Tue, 21 Sep 2010 01:49:43 -0700 (PDT)
From: Jarkko Nikula <jhnikula@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Jarkko Nikula <jhnikula@gmail.com>
Subject: [PATCHv2 2/2] V4L/DVB: radio-si4713: Add regulator framework support
Date: Tue, 21 Sep 2010 11:49:43 +0300
Message-Id: <1285058983-28657-3-git-send-email-jhnikula@gmail.com>
In-Reply-To: <1285058983-28657-1-git-send-email-jhnikula@gmail.com>
References: <1285058983-28657-1-git-send-email-jhnikula@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Convert the driver to use regulator framework instead of set_power callback.
This with gpio_reset platform data provide cleaner way to manage chip VIO,
VDD and reset signal inside the driver.

Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>
---
v2:
I moved all the regulator management to i2c driver part of si4713 as suggested
by Eduardo. Then the si4713-i2c.c can still be used separately from
radio-si4713.c and it's easier to follow what supply voltages are needed.

v1:
I don't have specifications for this chip so I don't know how long the
reset signal must be active after power-up. I used 50 us from Maemo
kernel sources for Nokia N900 and I can successfully enable-disable
transmitter on N900 with vdd power cycling.
---
 drivers/media/radio/si4713-i2c.c |   74 ++++++++++++++++++++++++++++++++------
 drivers/media/radio/si4713-i2c.h |    5 ++-
 2 files changed, 67 insertions(+), 12 deletions(-)

diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index fc7f4b7..f1502c6 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -27,6 +27,8 @@
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/regulator/consumer.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
@@ -43,6 +45,11 @@ MODULE_AUTHOR("Eduardo Valentin <eduardo.valentin@nokia.com>");
 MODULE_DESCRIPTION("I2C driver for Si4713 FM Radio Transmitter");
 MODULE_VERSION("0.0.1");
 
+static const char *si4713_supply_names[SI4713_NUM_SUPPLIES] = {
+	"vio",
+	"vdd",
+};
+
 #define DEFAULT_RDS_PI			0x00
 #define DEFAULT_RDS_PTY			0x00
 #define DEFAULT_RDS_PS_NAME		""
@@ -369,7 +376,17 @@ static int si4713_powerup(struct si4713_device *sdev)
 	if (sdev->power_state)
 		return 0;
 
-	sdev->platform_data->set_power(1);
+	err = regulator_bulk_enable(ARRAY_SIZE(sdev->supplies),
+				    sdev->supplies);
+	if (err) {
+		v4l2_err(&sdev->sd, "Failed to enable supplies: %d\n", err);
+		return err;
+	}
+	if (gpio_is_valid(sdev->gpio_reset)) {
+		udelay(50);
+		gpio_set_value(sdev->gpio_reset, 1);
+	}
+
 	err = si4713_send_command(sdev, SI4713_CMD_POWER_UP,
 					args, ARRAY_SIZE(args),
 					resp, ARRAY_SIZE(resp),
@@ -384,7 +401,13 @@ static int si4713_powerup(struct si4713_device *sdev)
 		err = si4713_write_property(sdev, SI4713_GPO_IEN,
 						SI4713_STC_INT | SI4713_CTS);
 	} else {
-		sdev->platform_data->set_power(0);
+		if (gpio_is_valid(sdev->gpio_reset))
+			gpio_set_value(sdev->gpio_reset, 0);
+		err = regulator_bulk_disable(ARRAY_SIZE(sdev->supplies),
+					     sdev->supplies);
+		if (err)
+			v4l2_err(&sdev->sd,
+				 "Failed to disable supplies: %d\n", err);
 	}
 
 	return err;
@@ -411,7 +434,13 @@ static int si4713_powerdown(struct si4713_device *sdev)
 		v4l2_dbg(1, debug, &sdev->sd, "Power down response: 0x%02x\n",
 				resp[0]);
 		v4l2_dbg(1, debug, &sdev->sd, "Device in reset mode\n");
-		sdev->platform_data->set_power(0);
+		if (gpio_is_valid(sdev->gpio_reset))
+			gpio_set_value(sdev->gpio_reset, 0);
+		err = regulator_bulk_disable(ARRAY_SIZE(sdev->supplies),
+					     sdev->supplies);
+		if (err)
+			v4l2_err(&sdev->sd,
+				 "Failed to disable supplies: %d\n", err);
 		sdev->power_state = POWER_OFF;
 	}
 
@@ -1967,7 +1996,8 @@ static int si4713_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
 	struct si4713_device *sdev;
-	int rval;
+	struct si4713_platform_data *pdata = client->dev.platform_data;
+	int rval, i;
 
 	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
 	if (!sdev) {
@@ -1976,11 +2006,26 @@ static int si4713_probe(struct i2c_client *client,
 		goto exit;
 	}
 
-	sdev->platform_data = client->dev.platform_data;
-	if (!sdev->platform_data) {
-		v4l2_err(&sdev->sd, "No platform data registered.\n");
-		rval = -ENODEV;
-		goto free_sdev;
+	sdev->gpio_reset = -1;
+	if (pdata && gpio_is_valid(pdata->gpio_reset)) {
+		rval = gpio_request(pdata->gpio_reset, "si4713 reset");
+		if (rval) {
+			dev_err(&client->dev,
+				"Failed to request gpio: %d\n", rval);
+			goto free_sdev;
+		}
+		sdev->gpio_reset = pdata->gpio_reset;
+		gpio_direction_output(sdev->gpio_reset, 0);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sdev->supplies); i++)
+		sdev->supplies[i].supply = si4713_supply_names[i];
+
+	rval = regulator_bulk_get(&client->dev, ARRAY_SIZE(sdev->supplies),
+				  sdev->supplies);
+	if (rval) {
+		dev_err(&client->dev, "Cannot get regulators: %d\n", rval);
+		goto free_gpio;
 	}
 
 	v4l2_i2c_subdev_init(&sdev->sd, client, &si4713_subdev_ops);
@@ -1994,7 +2039,7 @@ static int si4713_probe(struct i2c_client *client,
 			client->name, sdev);
 		if (rval < 0) {
 			v4l2_err(&sdev->sd, "Could not request IRQ\n");
-			goto free_sdev;
+			goto put_reg;
 		}
 		v4l2_dbg(1, debug, &sdev->sd, "IRQ requested.\n");
 	} else {
@@ -2012,6 +2057,11 @@ static int si4713_probe(struct i2c_client *client,
 free_irq:
 	if (client->irq)
 		free_irq(client->irq, sdev);
+put_reg:
+	regulator_bulk_free(ARRAY_SIZE(sdev->supplies), sdev->supplies);
+free_gpio:
+	if (gpio_is_valid(sdev->gpio_reset))
+		gpio_free(sdev->gpio_reset);
 free_sdev:
 	kfree(sdev);
 exit:
@@ -2031,7 +2081,9 @@ static int si4713_remove(struct i2c_client *client)
 		free_irq(client->irq, sdev);
 
 	v4l2_device_unregister_subdev(sd);
-
+	regulator_bulk_free(ARRAY_SIZE(sdev->supplies), sdev->supplies);
+	if (gpio_is_valid(sdev->gpio_reset))
+		gpio_free(sdev->gpio_reset);
 	kfree(sdev);
 
 	return 0;
diff --git a/drivers/media/radio/si4713-i2c.h b/drivers/media/radio/si4713-i2c.h
index faf8cff..c6dfa7f 100644
--- a/drivers/media/radio/si4713-i2c.h
+++ b/drivers/media/radio/si4713-i2c.h
@@ -211,6 +211,8 @@ struct acomp_info {
 	u32 enabled;
 };
 
+#define SI4713_NUM_SUPPLIES		2
+
 /*
  * si4713_device - private data
  */
@@ -220,11 +222,12 @@ struct si4713_device {
 	/* private data structures */
 	struct mutex mutex;
 	struct completion work;
-	struct si4713_platform_data *platform_data;
 	struct rds_info rds_info;
 	struct limiter_info limiter_info;
 	struct pilot_info pilot_info;
 	struct acomp_info acomp_info;
+	struct regulator_bulk_data supplies[SI4713_NUM_SUPPLIES];
+	int gpio_reset;
 	u32 frequency;
 	u32 preemphasis;
 	u32 mute;
-- 
1.7.1

