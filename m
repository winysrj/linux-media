Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64150 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab0JOPQW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 11:16:22 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 6/7] IR: ene_ir: add support for carrier reports
Date: Fri, 15 Oct 2010 17:07:52 +0200
Message-Id: <1287155273-16171-7-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1287155273-16171-1-git-send-email-maximlevitsky@gmail.com>
References: <1287155273-16171-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ene_ir.c |   37 +++++++++++++++++++++++++++++--------
 1 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
index 8639621..1962652 100644
--- a/drivers/media/IR/ene_ir.c
+++ b/drivers/media/IR/ene_ir.c
@@ -193,10 +193,11 @@ static int ene_hw_detect(struct ene_device *dev)
 /* Sense current received carrier */
 void ene_rx_sense_carrier(struct ene_device *dev)
 {
+	DEFINE_IR_RAW_EVENT(ev);
+
+	int carrier, duty_cycle;
 	int period = ene_read_reg(dev, ENE_CIRCAR_PRD);
 	int hperiod = ene_read_reg(dev, ENE_CIRCAR_HPRD);
-	int carrier, duty_cycle;
-
 
 	if (!(period & ENE_CIRCAR_PRD_VALID))
 		return;
@@ -209,13 +210,16 @@ void ene_rx_sense_carrier(struct ene_device *dev)
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
 
 /* this enables/disables the CIR RX engine */
@@ -724,7 +728,7 @@ static irqreturn_t ene_isr(int irq, void *data)
 
 	dbg_verbose("RX interrupt");
 
-	if (dev->carrier_detect_enabled || debug)
+	if (dev->hw_learning_and_tx_capable)
 		ene_rx_sense_carrier(dev);
 
 	/* On hardware that don't support extra buffer we need to trust
@@ -897,6 +901,23 @@ static int ene_set_learning_mode(void *data, int enable)
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
+	ene_rx_disable(dev);
+	ene_rx_setup(dev);
+	ene_rx_enable(dev);
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	return 0;
+}
+
 /* outside interface: enable or disable idle mode */
 static void ene_rx_set_idle(void *data, bool idle)
 {
@@ -1029,7 +1050,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		ir_props->s_tx_mask = ene_set_tx_mask;
 		ir_props->s_tx_carrier = ene_set_tx_carrier;
 		ir_props->s_tx_duty_cycle = ene_set_tx_duty_cycle;
-		/* ir_props->s_carrier_report = ene_set_carrier_report; */
+		ir_props->s_carrier_report = ene_set_carrier_report;
 	}
 
 	ene_setup_hw_buffer(dev);
-- 
1.7.1

