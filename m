Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2on0099.outbound.protection.outlook.com ([207.46.100.99]:4416
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752390AbcFVLbC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 07:31:02 -0400
From: Dragos Bogdan <dragos.bogdan@analog.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
	<linux-media@vger.kernel.org>,
	Dragos Bogdan <dragos.bogdan@analog.com>
Subject: [PATCH v3] [media] adv7604: Add support for hardware reset
Date: Wed, 22 Jun 2016 14:30:42 +0300
Message-ID: <1466595042-3649-1-git-send-email-dragos.bogdan@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The part can be reset by a low pulse on the RESET pin (i.e. a hardware
reset) with a minimum width of 5 ms. It is recommended to wait 5 ms
after the low pulse before an I2C write is performed to the part.
For safety reasons, the delays will be between 5 and 10 ms.

The RESET pin can be tied high, so the GPIO is optional.

Signed-off-by: Dragos Bogdan <dragos.bogdan@analog.com>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
Changes since v2:
 - adv76xx_reset() is now a void function (it always returned 0).

Changes since v1:
 - Replace mdelay() with usleep_range();
 - Limit the comments to 75 characters per line.

 drivers/media/i2c/adv7604.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 41a1bfc..ab4f933 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -164,6 +164,7 @@ struct adv76xx_state {
 	struct adv76xx_platform_data pdata;
 
 	struct gpio_desc *hpd_gpio[4];
+	struct gpio_desc *reset_gpio;
 
 	struct v4l2_subdev sd;
 	struct media_pad pads[ADV76XX_PAD_MAX];
@@ -2996,6 +2997,19 @@ static int configure_regmaps(struct adv76xx_state *state)
 	return 0;
 }
 
+static void adv76xx_reset(struct adv76xx_state *state)
+{
+	if (state->reset_gpio) {
+		/* ADV76XX can be reset by a low reset pulse of minimum 5 ms. */
+		gpiod_set_value_cansleep(state->reset_gpio, 0);
+		usleep_range(5000, 10000);
+		gpiod_set_value_cansleep(state->reset_gpio, 1);
+		/* It is recommended to wait 5 ms after the low pulse before */
+		/* an I2C write is performed to the ADV76XX. */
+		usleep_range(5000, 10000);
+	}
+}
+
 static int adv76xx_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -3059,6 +3073,12 @@ static int adv76xx_probe(struct i2c_client *client,
 		if (state->hpd_gpio[i])
 			v4l_info(client, "Handling HPD %u GPIO\n", i);
 	}
+	state->reset_gpio = devm_gpiod_get_optional(&client->dev, "reset",
+								GPIOD_OUT_HIGH);
+	if (IS_ERR(state->reset_gpio))
+		return PTR_ERR(state->reset_gpio);
+
+	adv76xx_reset(state);
 
 	state->timings = cea640x480;
 	state->format = adv76xx_format_info(state, MEDIA_BUS_FMT_YUYV8_2X8);
-- 
2.1.4

