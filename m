Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40346 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbeJBOOV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 10:14:21 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v5 3/6] [media] ad5820: Add support for enable pin
Date: Tue,  2 Oct 2018 09:32:19 +0200
Message-Id: <20181002073222.11368-3-ricardo.ribalda@gmail.com>
In-Reply-To: <20181002073222.11368-1-ricardo.ribalda@gmail.com>
References: <20181002073222.11368-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for a programmable enable pin. It can be used in
situations where the ANA-vcc is not configurable (dummy-regulator), or
just to have a more fine control of the power saving.

The use of the enable pin is optional.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/i2c/Kconfig  |  2 +-
 drivers/media/i2c/ad5820.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index bfdb494686bf..1ba6eaaf58fb 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -321,7 +321,7 @@ config VIDEO_ML86V7667
 
 config VIDEO_AD5820
 	tristate "AD5820 lens voice coil support"
-	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on GPIOLIB && I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
 	---help---
 	  This is a driver for the AD5820 camera lens voice coil.
 	  It is used for example in Nokia N900 (RX-51).
diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index 22759aaa2dba..97eb05e65833 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/regulator/consumer.h>
+#include <linux/gpio/consumer.h>
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
@@ -55,6 +56,8 @@ struct ad5820_device {
 	u32 focus_ramp_time;
 	u32 focus_ramp_mode;
 
+	struct gpio_desc *enable_gpio;
+
 	struct mutex power_lock;
 	int power_count;
 
@@ -122,6 +125,8 @@ static int ad5820_power_off(struct ad5820_device *coil, bool standby)
 		ret = ad5820_update_hw(coil);
 	}
 
+	gpiod_set_value_cansleep(coil->enable_gpio, 0);
+
 	ret2 = regulator_disable(coil->vana);
 	if (ret)
 		return ret;
@@ -136,6 +141,8 @@ static int ad5820_power_on(struct ad5820_device *coil, bool restore)
 	if (ret < 0)
 		return ret;
 
+	gpiod_set_value_cansleep(coil->enable_gpio, 1);
+
 	if (restore) {
 		/* Restore the hardware settings. */
 		coil->standby = false;
@@ -146,6 +153,7 @@ static int ad5820_power_on(struct ad5820_device *coil, bool restore)
 	return 0;
 
 fail:
+	gpiod_set_value_cansleep(coil->enable_gpio, 0);
 	coil->standby = true;
 	regulator_disable(coil->vana);
 
@@ -312,6 +320,15 @@ static int ad5820_probe(struct i2c_client *client,
 		return ret;
 	}
 
+	coil->enable_gpio = devm_gpiod_get_optional(&client->dev, "enable",
+						    GPIOD_OUT_LOW);
+	if (IS_ERR(coil->enable_gpio)) {
+		ret = PTR_ERR(coil->enable_gpio);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&client->dev, "could not get enable gpio\n");
+		return ret;
+	}
+
 	mutex_init(&coil->power_lock);
 
 	v4l2_i2c_subdev_init(&coil->subdev, client, &ad5820_ops);
-- 
2.19.0
