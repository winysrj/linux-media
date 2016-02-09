Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32872 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbcBIQk3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2016 11:40:29 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk,
	sergei.shtylyov@cogentembedded.com,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v4] adv7604: add direct interrupt handling
Date: Tue,  9 Feb 2016 17:40:19 +0100
Message-Id: <1455036019-7066-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When probed from device tree, the i2c client driver can handle the
interrupt on its own.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
v4: As suggested by Hans and Lars-Peter, this revision attempts to parse the
interrupts node to determine polarity, and passes the appropriate flags to
devm_request_threaded_irq().

v3: uses IRQ_RETVAL

v2: implements the suggested style changes and drops the IRQF_TRIGGER_LOW
flag, which is handled in the device tree.


 drivers/media/i2c/adv7604.c | 50 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 66dbe86..2a1ae6d 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -31,6 +31,8 @@
 #include <linux/gpio/consumer.h>
 #include <linux/hdmi.h>
 #include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -1971,6 +1973,16 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	return 0;
 }
 
+static irqreturn_t adv76xx_irq_handler(int irq, void *devid)
+{
+	struct adv76xx_state *state = devid;
+	bool handled;
+
+	adv76xx_isr(&state->sd, 0, &handled);
+
+	return IRQ_RETVAL(handled);
+}
+
 static int adv76xx_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 {
 	struct adv76xx_state *state = to_state(sd);
@@ -2799,6 +2811,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 	struct device_node *endpoint;
 	struct device_node *np;
 	unsigned int flags;
+	u32 irq[2];
 	u32 v= -1;
 
 	np = state->i2c_clients[ADV76XX_PAGE_IO]->dev.of_node;
@@ -2844,8 +2857,20 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 		state->pdata.op_656_range = 1;
 	}
 
-	/* Disable the interrupt for now as no DT-based board uses it. */
 	state->pdata.int1_config = ADV76XX_INT1_CONFIG_DISABLED;
+	if (!of_property_read_u32_array(np, "interrupts", irq, 2)) {
+		switch (irq[1]) {
+		case IRQ_TYPE_LEVEL_LOW:
+			state->pdata.int1_config = ADV76XX_INT1_CONFIG_ACTIVE_LOW;
+			break;
+		case IRQ_TYPE_LEVEL_HIGH:
+			state->pdata.int1_config = ADV76XX_INT1_CONFIG_ACTIVE_HIGH;
+			break;
+		default:
+			WARN(1, "Unsupported interrupt configuration.");
+			break;
+		}
+	}
 
 	/* Use the default I2C addresses. */
 	state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] = 0x42;
@@ -3235,6 +3260,29 @@ static int adv76xx_probe(struct i2c_client *client,
 	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
 			client->addr << 1, client->adapter->name);
 
+	if (client->irq) {
+		unsigned long flags = IRQF_ONESHOT;
+
+		switch (state->pdata.int1_config) {
+		case ADV76XX_INT1_CONFIG_ACTIVE_LOW:
+			flags |= IRQF_TRIGGER_LOW;
+			break;
+		case ADV76XX_INT1_CONFIG_ACTIVE_HIGH:
+			flags |= IRQF_TRIGGER_HIGH;
+			break;
+		default:
+			break;
+		}
+
+		err = devm_request_threaded_irq(&client->dev,
+						client->irq,
+						NULL, adv76xx_irq_handler,
+						flags,
+						dev_name(&client->dev), state);
+		if (err)
+			goto err_entity;
+	}
+
 	err = v4l2_async_register_subdev(sd);
 	if (err)
 		goto err_entity;
-- 
2.6.4

