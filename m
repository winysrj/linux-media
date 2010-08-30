Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50033 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab0H3IxG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 04:53:06 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 7/7] ENE: add support for carrier reports
Date: Mon, 30 Aug 2010 11:52:27 +0300
Message-Id: <1283158348-7429-8-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
References: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ene_ir.c |   47 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
index c7bbbca..dfb822b 100644
--- a/drivers/media/IR/ene_ir.c
+++ b/drivers/media/IR/ene_ir.c
@@ -224,6 +224,7 @@ void ene_rx_sense_carrier(struct ene_device *dev)
 {
 	int period = ene_read_reg(dev, ENE_CIRCAR_PRD);
 	int hperiod = ene_read_reg(dev, ENE_CIRCAR_HPRD);
+	struct ir_raw_event ev = ir_new_event;
 	int carrier, duty_cycle;
 
 
@@ -238,19 +239,23 @@ void ene_rx_sense_carrier(struct ene_device *dev)
 	dbg("RX: hardware carrier period = %02x", period);
 	dbg("RX: hardware carrier pulse period = %02x", hperiod);
 
-
 	carrier = 2000000 / period;
 	duty_cycle = (hperiod * 100) / period;
 	dbg("RX: sensed carrier = %d Hz, duty cycle %d%%",
-							carrier, duty_cycle);
-
-	/* TODO: Send carrier & duty cycle to IR layer */
+						carrier, duty_cycle);
+	if (dev->carrier_detect_enabled) {
+		ev.carrier_report = true;
+		ev.carrier = carrier;
+		ev.duty_cycle = duty_cycle;
+		ir_raw_event_store(dev->idev, &ev);
+	}
 }
 
 /* determine which input to use*/
 static void ene_rx_set_inputs(struct ene_device *dev)
 {
-	int learning_mode = dev->learning_enabled;
+	int learning_mode = dev->learning_enabled ||
+					dev->carrier_detect_enabled;
 
 	dbg("RX: setup receiver, learning mode = %d", learning_mode);
 
@@ -281,9 +286,17 @@ static void ene_rx_set_inputs(struct ene_device *dev)
 		ene_enable_cir_engine(dev, true);
 		ene_select_rx_input(dev, !dev->hw_use_gpio_0a);
 
-		/* Enable carrier detection & demodulation */
+		/* Enable demodulation */
 		ene_set_reg_mask(dev, ENE_CIRCFG, ENE_CIRCFG_CARR_DEMOD);
-		ene_set_reg_mask(dev, ENE_CIRCFG2, ENE_CIRCFG2_CARR_DETECT);
+
+		/* Enable carrier detect if asked to */
+		if (dev->carrier_detect_enabled || debug)
+			ene_set_reg_mask(dev, ENE_CIRCFG2,
+						ENE_CIRCFG2_CARR_DETECT);
+		else
+			ene_clear_reg_mask(dev, ENE_CIRCFG2,
+						ENE_CIRCFG2_CARR_DETECT);
+
 
 
 	/* disable learning mode */
@@ -726,7 +739,7 @@ static irqreturn_t ene_isr(int irq, void *data)
 
 	dbg_verbose("RX interrupt");
 
-	if (dev->carrier_detect_enabled || debug)
+	if (dev->hw_learning_and_tx_capable)
 		ene_rx_sense_carrier(dev);
 
 	/* On hardware that don't support extra buffer we need to trust
@@ -796,7 +809,6 @@ static void ene_setup_settings(struct ene_device *dev)
 		let user set it with LIRC_SET_REC_CARRIER */
 	dev->learning_enabled =
 		(learning_mode && dev->hw_learning_and_tx_capable);
-
 }
 
 /* outside interface: called on first open*/
@@ -902,6 +914,21 @@ static int ene_set_learning_mode(void *data, int enable)
 	return 0;
 }
 
+static int ene_set_carrier_report(void *data, int enable)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	unsigned long flags;
+
+	if (enable == dev->carrier_detect_enabled)
+		return 0;
+
+	spin_lock_irqsave(&dev->hw_lock, flags);
+	dev->carrier_detect_enabled = enable;
+	ene_rx_set_inputs(dev);
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	return 0;
+}
+
 /* outside interface: enable or disable idle mode */
 static void ene_rx_set_idle(void *data, int idle)
 {
@@ -1043,7 +1070,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		ir_props->s_tx_carrier = ene_set_tx_carrier;
 		ir_props->s_tx_duty_cycle = ene_set_tx_duty_cycle;
 		ir_props->tx_resolution = sample_period * 1000;
-		/* ir_props->s_carrier_report = ene_set_carrier_report; */
+		ir_props->s_carrier_report = ene_set_carrier_report;
 	}
 
 
-- 
1.7.0.4

