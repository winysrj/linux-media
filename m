Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:36623 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726664AbeJLTCH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 15:02:07 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] adv7604: add CEC support for adv7611/adv7612
Message-ID: <9f1afd35-b8b4-fc3c-c634-21bc6c6d9c35@xs4all.nl>
Date: Fri, 12 Oct 2018 13:30:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC IP is very similar between the three HDMI receivers, but
not identical. Add support for all three variants.

Tested with an adv7604 and an adv7612.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 63 +++++++++++++++++++++++++++++++------
 1 file changed, 53 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 9eb7c70a7712..88786276dbe4 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -114,6 +114,11 @@ struct adv76xx_chip_info {
 	unsigned int fmt_change_digital_mask;
 	unsigned int cp_csc;

+	unsigned int cec_irq_status;
+	unsigned int cec_rx_enable;
+	unsigned int cec_rx_enable_mask;
+	bool cec_irq_swap;
+
 	const struct adv76xx_format_info *formats;
 	unsigned int nformats;

@@ -2003,10 +2008,11 @@ static void adv76xx_cec_tx_raw_status(struct v4l2_subdev *sd, u8 tx_raw_status)
 static void adv76xx_cec_isr(struct v4l2_subdev *sd, bool *handled)
 {
 	struct adv76xx_state *state = to_state(sd);
+	const struct adv76xx_chip_info *info = state->info;
 	u8 cec_irq;

 	/* cec controller */
-	cec_irq = io_read(sd, 0x4d) & 0x0f;
+	cec_irq = io_read(sd, info->cec_irq_status) & 0x0f;
 	if (!cec_irq)
 		return;

@@ -2024,15 +2030,21 @@ static void adv76xx_cec_isr(struct v4l2_subdev *sd, bool *handled)

 			for (i = 0; i < msg.len; i++)
 				msg.msg[i] = cec_read(sd, i + 0x15);
-			cec_write(sd, 0x26, 0x01); /* re-enable rx */
+			cec_write(sd, info->cec_rx_enable,
+				  info->cec_rx_enable_mask); /* re-enable rx */
 			cec_received_msg(state->cec_adap, &msg);
 		}
 	}

-	/* note: the bit order is swapped between 0x4d and 0x4e */
-	cec_irq = ((cec_irq & 0x08) >> 3) | ((cec_irq & 0x04) >> 1) |
-		  ((cec_irq & 0x02) << 1) | ((cec_irq & 0x01) << 3);
-	io_write(sd, 0x4e, cec_irq);
+	if (info->cec_irq_swap) {
+		/*
+		 * Note: the bit order is swapped between 0x4d and 0x4e
+		 * on adv7604
+		 */
+		cec_irq = ((cec_irq & 0x08) >> 3) | ((cec_irq & 0x04) >> 1) |
+			  ((cec_irq & 0x02) << 1) | ((cec_irq & 0x01) << 3);
+	}
+	io_write(sd, info->cec_irq_status + 1, cec_irq);

 	if (handled)
 		*handled = true;
@@ -2041,6 +2053,7 @@ static void adv76xx_cec_isr(struct v4l2_subdev *sd, bool *handled)
 static int adv76xx_cec_adap_enable(struct cec_adapter *adap, bool enable)
 {
 	struct adv76xx_state *state = cec_get_drvdata(adap);
+	const struct adv76xx_chip_info *info = state->info;
 	struct v4l2_subdev *sd = &state->sd;

 	if (!state->cec_enabled_adap && enable) {
@@ -2052,11 +2065,11 @@ static int adv76xx_cec_adap_enable(struct cec_adapter *adap, bool enable)
 		/* tx: arbitration lost */
 		/* tx: retry timeout */
 		/* rx: ready */
-		io_write_clr_set(sd, 0x50, 0x0f, 0x0f);
-		cec_write(sd, 0x26, 0x01);            /* enable rx */
+		io_write_clr_set(sd, info->cec_irq_status + 3, 0x0f, 0x0f);
+		cec_write(sd, info->cec_rx_enable, info->cec_rx_enable_mask);
 	} else if (state->cec_enabled_adap && !enable) {
 		/* disable cec interrupts */
-		io_write_clr_set(sd, 0x50, 0x0f, 0x00);
+		io_write_clr_set(sd, info->cec_irq_status + 3, 0x0f, 0x00);
 		/* disable address mask 1-3 */
 		cec_write_clr_set(sd, 0x27, 0x70, 0x00);
 		/* power down cec section */
@@ -2221,6 +2234,16 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	return 0;
 }

+static irqreturn_t adv76xx_irq_handler(int irq, void *dev_id)
+{
+	struct adv76xx_state *state = dev_id;
+	bool handled = false;
+
+	adv76xx_isr(&state->sd, 0, &handled);
+
+	return handled ? IRQ_HANDLED : IRQ_NONE;
+}
+
 static int adv76xx_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 {
 	struct adv76xx_state *state = to_state(sd);
@@ -2960,6 +2983,10 @@ static const struct adv76xx_chip_info adv76xx_chip_info[] = {
 		.cable_det_mask = 0x1e,
 		.fmt_change_digital_mask = 0xc1,
 		.cp_csc = 0xfc,
+		.cec_irq_status = 0x4d,
+		.cec_rx_enable = 0x26,
+		.cec_rx_enable_mask = 0x01,
+		.cec_irq_swap = true,
 		.formats = adv7604_formats,
 		.nformats = ARRAY_SIZE(adv7604_formats),
 		.set_termination = adv7604_set_termination,
@@ -3006,6 +3033,9 @@ static const struct adv76xx_chip_info adv76xx_chip_info[] = {
 		.cable_det_mask = 0x01,
 		.fmt_change_digital_mask = 0x03,
 		.cp_csc = 0xf4,
+		.cec_irq_status = 0x93,
+		.cec_rx_enable = 0x2c,
+		.cec_rx_enable_mask = 0x02,
 		.formats = adv7611_formats,
 		.nformats = ARRAY_SIZE(adv7611_formats),
 		.set_termination = adv7611_set_termination,
@@ -3047,6 +3077,9 @@ static const struct adv76xx_chip_info adv76xx_chip_info[] = {
 		.cable_det_mask = 0x01,
 		.fmt_change_digital_mask = 0x03,
 		.cp_csc = 0xf4,
+		.cec_irq_status = 0x93,
+		.cec_rx_enable = 0x2c,
+		.cec_rx_enable_mask = 0x02,
 		.formats = adv7612_formats,
 		.nformats = ARRAY_SIZE(adv7612_formats),
 		.set_termination = adv7611_set_termination,
@@ -3134,7 +3167,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 		state->pdata.insert_av_codes = 1;

 	/* Disable the interrupt for now as no DT-based board uses it. */
-	state->pdata.int1_config = ADV76XX_INT1_CONFIG_DISABLED;
+	state->pdata.int1_config = ADV76XX_INT1_CONFIG_ACTIVE_HIGH;

 	/* Hardcode the remaining platform data fields. */
 	state->pdata.disable_pwrdnb = 0;
@@ -3517,6 +3550,16 @@ static int adv76xx_probe(struct i2c_client *client,
 	if (err)
 		goto err_entity;

+	if (client->irq) {
+		err = devm_request_threaded_irq(&client->dev,
+						client->irq,
+						NULL, adv76xx_irq_handler,
+						IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+						client->name, state);
+		if (err)
+			goto err_entity;
+	}
+
 #if IS_ENABLED(CONFIG_VIDEO_ADV7604_CEC)
 	state->cec_adap = cec_allocate_adapter(&adv76xx_cec_adap_ops,
 		state, dev_name(&client->dev),
-- 
2.18.0
