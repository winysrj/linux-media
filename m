Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1bon0091.outbound.protection.outlook.com ([157.56.111.91]:46526
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752500AbcEXJqs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 05:46:48 -0400
From: Dragos Bogdan <dragos.bogdan@analog.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
	<linux-media@vger.kernel.org>,
	Dragos Bogdan <dragos.bogdan@analog.com>
Subject: [PATCH] [media] adv7604: Add support for hardware reset
Date: Tue, 24 May 2016 12:13:22 +0300
Message-ID: <1464081202-25043-1-git-send-email-dragos.bogdan@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The part can be reset by a low pulse on the RESET pin (i.e. a hardware reset) with a minimum width of 5 ms. It is recommended to wait 5 ms after the low pulse before an I2C write is performed to the part.
For safety reasons, the delays will be 10 ms.
The RESET pin can be tied high, so the GPIO is optional.

Signed-off-by: Dragos Bogdan <dragos.bogdan@analog.com>
---
 drivers/media/i2c/adv7604.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 41a1bfc..fac0ff1 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -164,6 +164,7 @@ struct adv76xx_state {
 	struct adv76xx_platform_data pdata;
 
 	struct gpio_desc *hpd_gpio[4];
+	struct gpio_desc *reset_gpio;
 
 	struct v4l2_subdev sd;
 	struct media_pad pads[ADV76XX_PAD_MAX];
@@ -2996,6 +2997,21 @@ static int configure_regmaps(struct adv76xx_state *state)
 	return 0;
 }
 
+static int adv76xx_reset(struct adv76xx_state *state)
+{
+	if (state->reset_gpio) {
+		/* ADV76XX can be reset by a low reset pulse of minimum 5 ms. */
+		gpiod_set_value_cansleep(state->reset_gpio, 0);
+		mdelay(10);
+		gpiod_set_value_cansleep(state->reset_gpio, 1);
+		/* It is recommended to wait 5 ms after the low pulse before */
+		/* an I2C write is performed to the ADV76XX. */
+		mdelay(10);
+	}
+
+	return 0;
+}
+
 static int adv76xx_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -3059,6 +3075,12 @@ static int adv76xx_probe(struct i2c_client *client,
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

