Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33275 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbcGTAED (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 20:04:03 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 05/10] media: adv7180: add power pin control
Date: Tue, 19 Jul 2016 17:03:32 -0700
Message-Id: <1468973017-17647-6-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1468973017-17647-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1468973017-17647-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some targets control the ADV7180 power pin via a gpio, so add
optional support for "powerdown" pin control.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Tested-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Tim Harvey <tharvey@gateworks.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>

---

v2:
- placed call to gpiod_get inline in adv7180_probe().
- rename gpio pin to "powerdown".
- document optional powerdown-gpios property in
  Documentation/devicetree/bindings/media/i2c/adv7180.txt.
- include error number in error message on gpiod_get failure.
---
 .../devicetree/bindings/media/i2c/adv7180.txt      |  5 ++++
 drivers/media/i2c/Kconfig                          |  2 +-
 drivers/media/i2c/adv7180.c                        | 27 ++++++++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7180.txt b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
index 0d50115..4da486f 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7180.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
@@ -15,6 +15,11 @@ Required Properties :
 		"adi,adv7282"
 		"adi,adv7282-m"
 
+Optional Properties :
+- powerdown-gpios: reference to the GPIO connected to the powerdown pin,
+  if any.
+
+
 Example:
 
 	i2c0@1c22000 {
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index ce9006e..6769898 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -187,7 +187,7 @@ comment "Video decoders"
 
 config VIDEO_ADV7180
 	tristate "Analog Devices ADV7180 decoder"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	depends on GPIOLIB && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  Support for the Analog Devices ADV7180 video decoder.
 
diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 667931e9..8612d21 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -26,6 +26,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/gpio/consumer.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
@@ -215,6 +216,7 @@ struct adv7180_state {
 	struct media_pad	pad;
 	struct mutex		mutex; /* mutual excl. when accessing chip */
 	int			irq;
+	struct gpio_desc	*pwdn_gpio;
 	v4l2_std_id		curr_norm;
 	bool			newavmode;
 	bool			powered;
@@ -466,6 +468,19 @@ static int adv7180_g_std(struct v4l2_subdev *sd, v4l2_std_id *norm)
 	return 0;
 }
 
+static void adv7180_set_power_pin(struct adv7180_state *state, bool on)
+{
+	if (!state->pwdn_gpio)
+		return;
+
+	if (on) {
+		gpiod_set_value_cansleep(state->pwdn_gpio, 0);
+		usleep_range(5000, 10000);
+	} else {
+		gpiod_set_value_cansleep(state->pwdn_gpio, 1);
+	}
+}
+
 static int adv7180_set_power(struct adv7180_state *state, bool on)
 {
 	u8 val;
@@ -1221,6 +1236,8 @@ static int init_device(struct adv7180_state *state)
 
 	mutex_lock(&state->mutex);
 
+	adv7180_set_power_pin(state, true);
+
 	adv7180_write(state, ADV7180_REG_PWR_MAN, ADV7180_PWR_MAN_RES);
 	usleep_range(5000, 10000);
 
@@ -1320,6 +1337,14 @@ static int adv7180_probe(struct i2c_client *client,
 
 	adv7180_of_parse(state);
 
+	state->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "powerdown",
+						   GPIOD_OUT_HIGH);
+	if (IS_ERR(state->pwdn_gpio)) {
+		ret = PTR_ERR(state->pwdn_gpio);
+		v4l_err(client, "request for power pin failed: %d\n", ret);
+		return ret;
+	}
+
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
 		state->csi_client = i2c_new_dummy(client->adapter,
 				ADV7180_DEFAULT_CSI_I2C_ADDR);
@@ -1411,6 +1436,8 @@ static int adv7180_remove(struct i2c_client *client)
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2)
 		i2c_unregister_device(state->csi_client);
 
+	adv7180_set_power_pin(state, false);
+
 	mutex_destroy(&state->mutex);
 
 	return 0;
-- 
1.9.1

