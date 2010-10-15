Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65479 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab0JOQPp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 12:15:45 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 3/5] IR: ene_ir: few bugfixes
Date: Fri, 15 Oct 2010 18:06:37 +0200
Message-Id: <1287158799-21486-4-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1287158799-21486-1-git-send-email-maximlevitsky@gmail.com>
References: <1287158799-21486-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a result of last round of debug with
Sami R <maesesami@gmail.com>.

Thank you Sami very much!

The biggest bug I fixed is that,
I was clobbering the CIRCFG register after it is setup
That wasn't a good idea really

And some small refactoring, etc.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ene_ir.c |   43 ++++++++++++++++++++-----------------------
 1 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
index dc32509..8639621 100644
--- a/drivers/media/IR/ene_ir.c
+++ b/drivers/media/IR/ene_ir.c
@@ -156,11 +156,12 @@ static int ene_hw_detect(struct ene_device *dev)
 
 	ene_notice("Firmware regs: %02x %02x", fw_reg1, fw_reg2);
 
-	dev->hw_use_gpio_0a = fw_reg2 & ENE_FW2_GP0A;
-	dev->hw_learning_and_tx_capable = fw_reg2 & ENE_FW2_LEARNING;
-	dev->hw_extra_buffer = fw_reg1 & ENE_FW1_HAS_EXTRA_BUF;
-	dev->hw_fan_input = dev->hw_learning_and_tx_capable &&
-	    (fw_reg2 & ENE_FW2_FAN_INPUT);
+	dev->hw_use_gpio_0a = !!(fw_reg2 & ENE_FW2_GP0A);
+	dev->hw_learning_and_tx_capable = !!(fw_reg2 & ENE_FW2_LEARNING);
+	dev->hw_extra_buffer = !!(fw_reg1 & ENE_FW1_HAS_EXTRA_BUF);
+
+	if (dev->hw_learning_and_tx_capable)
+		dev->hw_fan_input = !!(fw_reg2 & ENE_FW2_FAN_INPUT);
 
 	ene_notice("Hardware features:");
 
@@ -255,6 +256,8 @@ static void ene_rx_setup(struct ene_device *dev)
 					dev->carrier_detect_enabled;
 	int sample_period_adjust = 0;
 
+	/* This selects RLC input and clears CFG2 settings */
+	ene_write_reg(dev, ENE_CIRCFG2, 0x00);
 
 	/* set sample period*/
 	if (sample_period == ENE_DEFAULT_SAMPLE_PERIOD)
@@ -268,7 +271,9 @@ static void ene_rx_setup(struct ene_device *dev)
 	if (dev->hw_revision < ENE_HW_C)
 		goto select_timeout;
 
-	if (learning_mode && dev->hw_learning_and_tx_capable) {
+	if (learning_mode) {
+
+		WARN_ON(!dev->hw_learning_and_tx_capable);
 
 		/* Enable the opposite of the normal input
 		That means that if GPIO40 is normally used, use GPIO0A
@@ -282,6 +287,7 @@ static void ene_rx_setup(struct ene_device *dev)
 		ene_set_reg_mask(dev, ENE_CIRCFG, ENE_CIRCFG_CARR_DEMOD);
 
 		/* Enable carrier detection */
+		ene_write_reg(dev, ENE_CIRCAR_PULS, 0x63);
 		ene_set_clear_reg_mask(dev, ENE_CIRCFG2, ENE_CIRCFG2_CARR_DETECT,
 			dev->carrier_detect_enabled || debug);
 	} else {
@@ -343,19 +349,9 @@ static void ene_rx_enable(struct ene_device *dev)
 		ene_write_reg(dev, ENE_IRQ, reg_value);
 	}
 
-	if (dev->hw_revision >= ENE_HW_C)
-		ene_write_reg(dev, ENE_CIRCAR_PULS, 0x63);
-
-	/* Enable the inputs */
-	ene_write_reg(dev, ENE_CIRCFG2, 0x00);
-
-	if (dev->rx_fan_input_inuse) {
-		ene_enable_cir_engine(dev, false);
-		ene_enable_fan_input(dev, true);
-	} else {
-		ene_enable_cir_engine(dev, true);
-		ene_enable_fan_input(dev, false);
-	}
+	/* Enable inputs */
+	ene_enable_fan_input(dev, dev->rx_fan_input_inuse);
+	ene_enable_cir_engine(dev, !dev->rx_fan_input_inuse);
 
 	/* ack any pending irqs - just in case */
 	ene_irq_status(dev);
@@ -793,12 +789,10 @@ static void ene_setup_settings(struct ene_device *dev)
 	dev->tx_period = 32;
 	dev->tx_duty_cycle = 50; /*%*/
 	dev->transmitter_mask = 0x03;
-
-	dev->learning_enabled =
-		(learning_mode && dev->hw_learning_and_tx_capable);
+	dev->learning_enabled = learning_mode;
 
 	/* Set reasonable default timeout */
-	dev->props->timeout = MS_TO_NS(15000);
+	dev->props->timeout = MS_TO_NS(150000);
 }
 
 /* outside interface: called on first open*/
@@ -1015,6 +1009,9 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		ene_warn("Simulation of TX activated");
 	}
 
+	if (!dev->hw_learning_and_tx_capable)
+		learning_mode = false;
+
 	ir_props->driver_type = RC_DRIVER_IR_RAW;
 	ir_props->allowed_protos = IR_TYPE_ALL;
 	ir_props->priv = dev;
-- 
1.7.1

