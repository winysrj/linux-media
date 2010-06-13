Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:65302 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab0FMSJa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 14:09:30 -0400
Received: by mail-ww0-f46.google.com with SMTP id 18so3028519wwb.19
        for <linux-media@vger.kernel.org>; Sun, 13 Jun 2010 11:09:29 -0700 (PDT)
From: Jarkko Nikula <jhnikula@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jarkko Nikula <jhnikula@gmail.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH 2/2] V4L/DVB: radio-si4713: Add regulator framework support
Date: Sun, 13 Jun 2010 21:09:28 +0300
Message-Id: <1276452568-16366-2-git-send-email-jhnikula@gmail.com>
In-Reply-To: <1276452568-16366-1-git-send-email-jhnikula@gmail.com>
References: <1276452568-16366-1-git-send-email-jhnikula@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the driver to use regulator framework instead of set_power callback.
This with gpio_reset platform data provide cleaner way to manage chip VIO,
VDD and reset signal inside the driver.

Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>
---
I don't have specifications for this chip so I don't know how long the
reset signal must be active after power-up. I used 50 us from Maemo
kernel sources for Nokia N900 and I can successfully enable-disable
transmitter on N900 with vdd power cycling.
---
 drivers/media/radio/radio-si4713.c |   20 ++++++++++++++-
 drivers/media/radio/si4713-i2c.c   |   48 ++++++++++++++++++++++++++++-------
 drivers/media/radio/si4713-i2c.h   |    3 +-
 include/media/si4713.h             |    3 +-
 4 files changed, 60 insertions(+), 14 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 0a9fc4d..c666012 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -28,6 +28,7 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/slab.h>
+#include <linux/regulator/consumer.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
@@ -48,6 +49,7 @@ MODULE_VERSION("0.0.1");
 struct radio_si4713_device {
 	struct v4l2_device		v4l2_dev;
 	struct video_device		*radio_dev;
+	struct regulator		*reg_vio;
 };
 
 /* radio_si4713_fops - file operations interface */
@@ -283,12 +285,22 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 		goto free_rsdev;
 	}
 
+	rsdev->reg_vio = regulator_get(&pdev->dev, "vio");
+	if (IS_ERR(rsdev->reg_vio)) {
+		dev_err(&pdev->dev, "Cannot get vio regulator\n");
+		rval = PTR_ERR(rsdev->reg_vio);
+		goto unregister_v4l2_dev;
+	}
+	rval = regulator_enable(rsdev->reg_vio);
+	if (rval)
+		goto reg_put;
+
 	adapter = i2c_get_adapter(pdata->i2c_bus);
 	if (!adapter) {
 		dev_err(&pdev->dev, "Cannot get i2c adapter %d\n",
 							pdata->i2c_bus);
 		rval = -ENODEV;
-		goto unregister_v4l2_dev;
+		goto reg_disable;
 	}
 
 	sd = v4l2_i2c_new_subdev_board(&rsdev->v4l2_dev, adapter, "si4713_i2c",
@@ -322,6 +334,10 @@ free_vdev:
 	video_device_release(rsdev->radio_dev);
 put_adapter:
 	i2c_put_adapter(adapter);
+reg_disable:
+	regulator_disable(rsdev->reg_vio);
+reg_put:
+	regulator_put(rsdev->reg_vio);
 unregister_v4l2_dev:
 	v4l2_device_unregister(&rsdev->v4l2_dev);
 free_rsdev:
@@ -343,6 +359,8 @@ static int __exit radio_si4713_pdriver_remove(struct platform_device *pdev)
 
 	video_unregister_device(rsdev->radio_dev);
 	i2c_put_adapter(client->adapter);
+	regulator_disable(rsdev->reg_vio);
+	regulator_put(rsdev->reg_vio);
 	v4l2_device_unregister(&rsdev->v4l2_dev);
 	kfree(rsdev);
 
diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index ab63dd5..4b5470c 100644
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
@@ -369,7 +371,12 @@ static int si4713_powerup(struct si4713_device *sdev)
 	if (sdev->power_state)
 		return 0;
 
-	sdev->platform_data->set_power(1);
+	regulator_enable(sdev->reg_vdd);
+	if (gpio_is_valid(sdev->gpio_reset)) {
+		udelay(50);
+		gpio_set_value(sdev->gpio_reset, 1);
+	}
+
 	err = si4713_send_command(sdev, SI4713_CMD_POWER_UP,
 					args, ARRAY_SIZE(args),
 					resp, ARRAY_SIZE(resp),
@@ -384,7 +391,9 @@ static int si4713_powerup(struct si4713_device *sdev)
 		err = si4713_write_property(sdev, SI4713_GPO_IEN,
 						SI4713_STC_INT | SI4713_CTS);
 	} else {
-		sdev->platform_data->set_power(0);
+		if (gpio_is_valid(sdev->gpio_reset))
+			gpio_set_value(sdev->gpio_reset, 0);
+		regulator_disable(sdev->reg_vdd);
 	}
 
 	return err;
@@ -411,7 +420,9 @@ static int si4713_powerdown(struct si4713_device *sdev)
 		v4l2_dbg(1, debug, &sdev->sd, "Power down response: 0x%02x\n",
 				resp[0]);
 		v4l2_dbg(1, debug, &sdev->sd, "Device in reset mode\n");
-		sdev->platform_data->set_power(0);
+		if (gpio_is_valid(sdev->gpio_reset))
+			gpio_set_value(sdev->gpio_reset, 0);
+		regulator_disable(sdev->reg_vdd);
 		sdev->power_state = POWER_OFF;
 	}
 
@@ -1959,6 +1970,7 @@ static int si4713_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
 	struct si4713_device *sdev;
+	struct si4713_platform_data *pdata = client->dev.platform_data;
 	int rval;
 
 	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
@@ -1968,11 +1980,20 @@ static int si4713_probe(struct i2c_client *client,
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
+		if (rval)
+			goto free_sdev;
+		sdev->gpio_reset = pdata->gpio_reset;
+		gpio_direction_output(sdev->gpio_reset, 0);
+	}
+
+	sdev->reg_vdd = regulator_get(&client->dev, "vdd");
+	if (IS_ERR(sdev->reg_vdd)) {
+		dev_err(&client->dev, "Cannot get vdd regulator\n");
+		rval = PTR_ERR(sdev->reg_vdd);
+		goto free_gpio;
 	}
 
 	v4l2_i2c_subdev_init(&sdev->sd, client, &si4713_subdev_ops);
@@ -1986,7 +2007,7 @@ static int si4713_probe(struct i2c_client *client,
 			client->name, sdev);
 		if (rval < 0) {
 			v4l2_err(&sdev->sd, "Could not request IRQ\n");
-			goto free_sdev;
+			goto put_reg;
 		}
 		v4l2_dbg(1, debug, &sdev->sd, "IRQ requested.\n");
 	} else {
@@ -2004,6 +2025,11 @@ static int si4713_probe(struct i2c_client *client,
 free_irq:
 	if (client->irq)
 		free_irq(client->irq, sdev);
+put_reg:
+	regulator_put(sdev->reg_vdd);
+free_gpio:
+	if (gpio_is_valid(sdev->gpio_reset))
+		gpio_free(sdev->gpio_reset);
 free_sdev:
 	kfree(sdev);
 exit:
@@ -2023,7 +2049,9 @@ static int si4713_remove(struct i2c_client *client)
 		free_irq(client->irq, sdev);
 
 	v4l2_device_unregister_subdev(sd);
-
+	regulator_put(sdev->reg_vdd);
+	if (gpio_is_valid(sdev->gpio_reset))
+		gpio_free(sdev->gpio_reset);
 	kfree(sdev);
 
 	return 0;
diff --git a/drivers/media/radio/si4713-i2c.h b/drivers/media/radio/si4713-i2c.h
index faf8cff..cf79f6e 100644
--- a/drivers/media/radio/si4713-i2c.h
+++ b/drivers/media/radio/si4713-i2c.h
@@ -220,11 +220,12 @@ struct si4713_device {
 	/* private data structures */
 	struct mutex mutex;
 	struct completion work;
-	struct si4713_platform_data *platform_data;
 	struct rds_info rds_info;
 	struct limiter_info limiter_info;
 	struct pilot_info pilot_info;
 	struct acomp_info acomp_info;
+	struct regulator *reg_vdd;
+	int gpio_reset;
 	u32 frequency;
 	u32 preemphasis;
 	u32 mute;
diff --git a/include/media/si4713.h b/include/media/si4713.h
index 99850a5..ed7353e 100644
--- a/include/media/si4713.h
+++ b/include/media/si4713.h
@@ -23,8 +23,7 @@
  * Platform dependent definition
  */
 struct si4713_platform_data {
-	/* Set power state, zero is off, non-zero is on. */
-	int (*set_power)(int power);
+	int gpio_reset; /* < 0 if not used */
 };
 
 /*
-- 
1.7.1

