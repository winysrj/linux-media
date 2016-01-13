Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35819 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbcAMPPt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 10:15:49 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Cc: magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk,
	sergei.shtylyov@cogentembedded.com,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v3] adv7604: add direct interrupt handling
Date: Wed, 13 Jan 2016 16:15:43 +0100
Message-Id: <1452698143-31897-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When probed from device tree, the i2c client driver can handle the
interrupt on its own.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
v3: uses IRQ_RETVAL

v2: implements the suggested style changes and drops the IRQF_TRIGGER_LOW
flag, which is handled in the device tree.


 drivers/media/i2c/adv7604.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 5bd81bd..ab4cb25 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -31,6 +31,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/hdmi.h>
 #include <linux/i2c.h>
+#include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -1971,6 +1972,16 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
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
@@ -2844,8 +2855,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 		state->pdata.op_656_range = 1;
 	}
 
-	/* Disable the interrupt for now as no DT-based board uses it. */
-	state->pdata.int1_config = ADV76XX_INT1_CONFIG_DISABLED;
+	state->pdata.int1_config = ADV76XX_INT1_CONFIG_ACTIVE_LOW;
 
 	/* Use the default I2C addresses. */
 	state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] = 0x42;
@@ -3235,6 +3245,16 @@ static int adv76xx_probe(struct i2c_client *client,
 	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
 			client->addr << 1, client->adapter->name);
 
+	if (client->irq) {
+		err = devm_request_threaded_irq(&client->dev,
+						client->irq,
+						NULL, adv76xx_irq_handler,
+						IRQF_ONESHOT,
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

