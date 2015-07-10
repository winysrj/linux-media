Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46213 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbbGJNLv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 09:11:51 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4/5] [media] tc358743: add direct interrupt handling
Date: Fri, 10 Jul 2015 15:11:36 +0200
Message-Id: <1436533897-3060-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1436533897-3060-1-git-send-email-p.zabel@pengutronix.de>
References: <1436533897-3060-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When probed from device tree, the i2c client driver can handle the interrupt
on its own.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 02c60b3..4a889d4 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -32,6 +32,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
+#include <linux/interrupt.h>
 #include <linux/videodev2.h>
 #include <linux/workqueue.h>
 #include <linux/v4l2-dv-timings.h>
@@ -1306,6 +1307,16 @@ static int tc358743_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	return 0;
 }
 
+static irqreturn_t tc358743_irq_handler(int irq, void *dev_id)
+{
+	struct tc358743_state *state = dev_id;
+	bool handled;
+
+	tc358743_isr(&state->sd, 0, &handled);
+
+	return handled ? IRQ_HANDLED : IRQ_NONE;
+}
+
 /* --------------- VIDEO OPS --------------- */
 
 static int tc358743_g_input_status(struct v4l2_subdev *sd, u32 *status)
@@ -1874,6 +1885,17 @@ static int tc358743_probe(struct i2c_client *client,
 	tc358743_set_csi_color_space(sd);
 
 	tc358743_init_interrupts(sd);
+
+	if (state->i2c_client->irq) {
+		err = devm_request_threaded_irq(&client->dev,
+						state->i2c_client->irq,
+						NULL, tc358743_irq_handler,
+						IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+						"tc358743", state);
+		if (err)
+			goto err_work_queues;
+	}
+
 	tc358743_enable_interrupts(sd, tx_5v_power_present(sd));
 	i2c_wr16(sd, INTMASK, ~(MASK_HDMI_MSK | MASK_CSI_MSK) & 0xffff);
 
-- 
2.1.4

