Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60954 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbbC3LLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 07:11:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC 09/12] [media] tc358743: add direct interrupt handling
Date: Mon, 30 Mar 2015 13:10:53 +0200
Message-Id: <1427713856-10240-10-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When probed from device tree, the i2c client driver can handle the interrupt
on its own.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index e1059cc..2cf97d9 100644
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
@@ -891,7 +892,7 @@ static void tc358743_initial_setup(struct v4l2_subdev *sd)
 
 /* --------------- IRQ --------------- */
 
-static void tc358743_enable_interrupts(struct v4l2_subdev *sd)
+static void tc358743_clear_interrupt_status(struct v4l2_subdev *sd)
 {
 	u16 i;
 
@@ -900,6 +901,11 @@ static void tc358743_enable_interrupts(struct v4l2_subdev *sd)
 		i2c_wr8(sd, i, 0xff);
 
 	i2c_wr16(sd, INTSTATUS, 0xffff);
+}
+
+static void tc358743_enable_interrupts(struct v4l2_subdev *sd)
+{
+	tc358743_clear_interrupt_status(sd);
 
 	/* enable interrupts */
 	i2c_wr8(sd, SYS_INTM, ~(MASK_M_DDC | MASK_M_HDMI_DET) & 0xff);
@@ -1322,6 +1328,16 @@ static int tc358743_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
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
@@ -1838,6 +1854,17 @@ static int tc358743_probe(struct i2c_client *client,
 		v4l2_info(sd, "not a TC358743 on address 0x%x\n",
 			  client->addr << 1);
 		return -ENODEV;
+
+	tc358743_clear_interrupt_status(sd);
+
+	if (state->i2c_client->irq) {
+		err = devm_request_threaded_irq(&client->dev,
+						state->i2c_client->irq,
+						NULL, tc358743_irq_handler,
+						IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+						"tc358743", state);
+		if (err)
+			return err;
 	}
 
 	/* control handlers */
-- 
2.1.4

