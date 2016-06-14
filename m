Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33548 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbcFNWvb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:31 -0400
Received: by mail-pf0-f193.google.com with SMTP id c74so307109pfb.0
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:31 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 35/38] media: adv7180: add power pin control
Date: Tue, 14 Jun 2016 15:49:31 -0700
Message-Id: <1465944574-15745-36-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some targets control the ADV7180 power pin via a gpio, so add
support for "pwdn-gpio" device node and pin control.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/i2c/adv7180.c | 51 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index b77b0a4..b3bb19f 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -26,6 +26,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
@@ -192,6 +193,7 @@ struct adv7180_state {
 	struct media_pad	pad;
 	struct mutex		mutex; /* mutual excl. when accessing chip */
 	int			irq;
+	int			pwdn_gpio;
 	v4l2_std_id		curr_norm;
 	bool			powered;
 	bool			streaming;
@@ -442,6 +444,19 @@ static int adv7180_g_std(struct v4l2_subdev *sd, v4l2_std_id *norm)
 	return 0;
 }
 
+static void adv7180_set_power_pin(struct adv7180_state *state, bool on)
+{
+	if (!gpio_is_valid(state->pwdn_gpio))
+		return;
+
+	if (on) {
+		gpio_set_value_cansleep(state->pwdn_gpio, 1);
+		usleep_range(5000, 5001);
+	} else {
+		gpio_set_value_cansleep(state->pwdn_gpio, 0);
+	}
+}
+
 static int adv7180_set_power(struct adv7180_state *state, bool on)
 {
 	u8 val;
@@ -1185,6 +1200,8 @@ static int init_device(struct adv7180_state *state)
 
 	mutex_lock(&state->mutex);
 
+	adv7180_set_power_pin(state, true);
+
 	adv7180_write(state, ADV7180_REG_PWR_MAN, ADV7180_PWR_MAN_RES);
 	usleep_range(5000, 10000);
 
@@ -1232,6 +1249,34 @@ out_unlock:
 	return ret;
 }
 
+static int adv7180_of_parse(struct adv7180_state *state)
+{
+	struct i2c_client *client = state->client;
+	struct device_node *np = client->dev.of_node;
+	int ret;
+
+	ret = of_get_named_gpio(np, "pwdn-gpio", 0);
+
+	if (gpio_is_valid(ret)) {
+		state->pwdn_gpio = ret;
+		ret = devm_gpio_request_one(&client->dev,
+					    state->pwdn_gpio,
+					    GPIOF_OUT_INIT_HIGH,
+					    "adv7180_pwdn");
+		if (ret < 0) {
+			v4l_err(client, "request for power pin failed\n");
+			return ret;
+		}
+	} else {
+		if (ret == -EPROBE_DEFER)
+			return ret;
+		/* assume a power-down gpio is not required */
+		state->pwdn_gpio = -1;
+	}
+
+	return 0;
+}
+
 static int adv7180_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -1254,6 +1299,10 @@ static int adv7180_probe(struct i2c_client *client,
 	state->field = V4L2_FIELD_INTERLACED;
 	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
 
+	ret = adv7180_of_parse(state);
+	if (ret)
+		return ret;
+
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
 		state->csi_client = i2c_new_dummy(client->adapter,
 				ADV7180_DEFAULT_CSI_I2C_ADDR);
@@ -1345,6 +1394,8 @@ static int adv7180_remove(struct i2c_client *client)
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2)
 		i2c_unregister_device(state->csi_client);
 
+	adv7180_set_power_pin(state, false);
+
 	mutex_destroy(&state->mutex);
 
 	return 0;
-- 
1.9.1

