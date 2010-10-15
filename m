Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56296 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab0JOPIj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 11:08:39 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 7/7] IR: ene_ir: don't upload all settings on each TX packet.
Date: Fri, 15 Oct 2010 17:07:53 +0200
Message-Id: <1287155273-16171-8-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1287155273-16171-1-git-send-email-maximlevitsky@gmail.com>
References: <1287155273-16171-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is just unnessesary, and now more logical

Also lot of refactoring

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ene_ir.c |  474 +++++++++++++++++++++++---------------------
 drivers/media/IR/ene_ir.h |    6 +-
 2 files changed, 251 insertions(+), 229 deletions(-)

diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
index 1962652..685db83 100644
--- a/drivers/media/IR/ene_ir.c
+++ b/drivers/media/IR/ene_ir.c
@@ -43,7 +43,7 @@
 #include "ene_ir.h"
 
 static int sample_period;
-static bool learning_mode;
+static bool learning_mode_force;
 static int debug;
 static bool txsim;
 
@@ -190,6 +190,145 @@ static int ene_hw_detect(struct ene_device *dev)
 	return 0;
 }
 
+/* Read properities of hw sample buffer */
+static void ene_rx_setup_hw_buffer(struct ene_device *dev)
+{
+	u16 tmp;
+
+	ene_rx_read_hw_pointer(dev);
+	dev->r_pointer = dev->w_pointer;
+
+	if (!dev->hw_extra_buffer) {
+		dev->buffer_len = ENE_FW_PACKET_SIZE * 2;
+		return;
+	}
+
+	tmp = ene_read_reg(dev, ENE_FW_SAMPLE_BUFFER);
+	tmp |= ene_read_reg(dev, ENE_FW_SAMPLE_BUFFER+1) << 8;
+	dev->extra_buf1_address = tmp;
+
+	dev->extra_buf1_len = ene_read_reg(dev, ENE_FW_SAMPLE_BUFFER + 2);
+
+	tmp = ene_read_reg(dev, ENE_FW_SAMPLE_BUFFER + 3);
+	tmp |= ene_read_reg(dev, ENE_FW_SAMPLE_BUFFER + 4) << 8;
+	dev->extra_buf2_address = tmp;
+
+	dev->extra_buf2_len = ene_read_reg(dev, ENE_FW_SAMPLE_BUFFER + 5);
+
+	dev->buffer_len = dev->extra_buf1_len + dev->extra_buf2_len + 8;
+
+	ene_notice("Hardware uses 2 extended buffers:");
+	ene_notice("  0x%04x - len : %d", dev->extra_buf1_address,
+						dev->extra_buf1_len);
+	ene_notice("  0x%04x - len : %d", dev->extra_buf2_address,
+						dev->extra_buf2_len);
+
+	ene_notice("Total buffer len = %d", dev->buffer_len);
+
+	if (dev->buffer_len > 64 || dev->buffer_len < 16)
+		goto error;
+
+	if (dev->extra_buf1_address > 0xFBFC ||
+					dev->extra_buf1_address < 0xEC00)
+		goto error;
+
+	if (dev->extra_buf2_address > 0xFBFC ||
+					dev->extra_buf2_address < 0xEC00)
+		goto error;
+
+	if (dev->r_pointer > dev->buffer_len)
+		goto error;
+
+	ene_set_reg_mask(dev, ENE_FW1, ENE_FW1_EXTRA_BUF_HND);
+	return;
+error:
+	ene_warn("Error validating extra buffers, device probably won't work");
+	dev->hw_extra_buffer = false;
+	ene_clear_reg_mask(dev, ENE_FW1, ENE_FW1_EXTRA_BUF_HND);
+}
+
+
+/* Restore the pointers to extra buffers - to make module reload work*/
+static void ene_rx_restore_hw_buffer(struct ene_device *dev)
+{
+	if (!dev->hw_extra_buffer)
+		return;
+
+	ene_write_reg(dev, ENE_FW_SAMPLE_BUFFER + 0,
+				dev->extra_buf1_address & 0xFF);
+	ene_write_reg(dev, ENE_FW_SAMPLE_BUFFER + 1,
+				dev->extra_buf1_address >> 8);
+	ene_write_reg(dev, ENE_FW_SAMPLE_BUFFER + 2, dev->extra_buf1_len);
+
+	ene_write_reg(dev, ENE_FW_SAMPLE_BUFFER + 3,
+				dev->extra_buf2_address & 0xFF);
+	ene_write_reg(dev, ENE_FW_SAMPLE_BUFFER + 4,
+				dev->extra_buf2_address >> 8);
+	ene_write_reg(dev, ENE_FW_SAMPLE_BUFFER + 5,
+				dev->extra_buf2_len);
+	ene_clear_reg_mask(dev, ENE_FW1, ENE_FW1_EXTRA_BUF_HND);
+}
+
+/* Read hardware write pointer */
+static void ene_rx_read_hw_pointer(struct ene_device *dev)
+{
+	if (dev->hw_extra_buffer)
+		dev->w_pointer = ene_read_reg(dev, ENE_FW_RX_POINTER);
+	else
+		dev->w_pointer = ene_read_reg(dev, ENE_FW2)
+			& ENE_FW2_BUF_WPTR ? 0 : ENE_FW_PACKET_SIZE;
+
+	dbg_verbose("RB: HW write pointer: %02x, driver read pointer: %02x",
+		dev->w_pointer, dev->r_pointer);
+}
+
+/* Gets address of next sample from HW ring buffer */
+static int ene_rx_get_sample_reg(struct ene_device *dev)
+{
+	int r_pointer;
+
+	if (dev->r_pointer == dev->w_pointer) {
+		dbg_verbose("RB: hit end, try update w_pointer");
+		ene_rx_read_hw_pointer(dev);
+	}
+
+	if (dev->r_pointer == dev->w_pointer) {
+		dbg_verbose("RB: end of data at %d", dev->r_pointer);
+		return 0;
+	}
+
+	dbg_verbose("RB: reading at offset %d", dev->r_pointer);
+	r_pointer = dev->r_pointer;
+
+	dev->r_pointer++;
+	if (dev->r_pointer == dev->buffer_len)
+		dev->r_pointer = 0;
+
+	dbg_verbose("RB: next read will be from offset %d", dev->r_pointer);
+
+	if (r_pointer < 8) {
+		dbg_verbose("RB: read at main buffer at %d", r_pointer);
+		return ENE_FW_SAMPLE_BUFFER + r_pointer;
+	}
+
+	r_pointer -= 8;
+
+	if (r_pointer < dev->extra_buf1_len) {
+		dbg_verbose("RB: read at 1st extra buffer at %d", r_pointer);
+		return dev->extra_buf1_address + r_pointer;
+	}
+
+	r_pointer -= dev->extra_buf1_len;
+
+	if (r_pointer < dev->extra_buf2_len) {
+		dbg_verbose("RB: read at 2nd extra buffer at %d", r_pointer);
+		return dev->extra_buf2_address + r_pointer;
+	}
+
+	dbg("attempt to read beyong ring bufer end");
+	return 0;
+}
+
 /* Sense current received carrier */
 void ene_rx_sense_carrier(struct ene_device *dev)
 {
@@ -223,14 +362,14 @@ void ene_rx_sense_carrier(struct ene_device *dev)
 }
 
 /* this enables/disables the CIR RX engine */
-static void ene_enable_cir_engine(struct ene_device *dev, bool enable)
+static void ene_rx_enable_cir_engine(struct ene_device *dev, bool enable)
 {
 	ene_set_clear_reg_mask(dev, ENE_CIRCFG,
 			ENE_CIRCFG_RX_EN | ENE_CIRCFG_RX_IRQ, enable);
 }
 
 /* this selects input for CIR engine. Ether GPIO 0A or GPIO40*/
-static void ene_select_rx_input(struct ene_device *dev, bool gpio_0a)
+static void ene_rx_select_input(struct ene_device *dev, bool gpio_0a)
 {
 	ene_set_clear_reg_mask(dev, ENE_CIRCFG2, ENE_CIRCFG2_GPIO0A, gpio_0a);
 }
@@ -239,7 +378,7 @@ static void ene_select_rx_input(struct ene_device *dev, bool gpio_0a)
  * this enables alternative input via fan tachometer sensor and bypasses
  * the hw CIR engine
  */
-static void ene_enable_fan_input(struct ene_device *dev, bool enable)
+static void ene_rx_enable_fan_input(struct ene_device *dev, bool enable)
 {
 	if (!dev->hw_fan_input)
 		return;
@@ -250,16 +389,18 @@ static void ene_enable_fan_input(struct ene_device *dev, bool enable)
 		ene_write_reg(dev, ENE_FAN_AS_IN1, ENE_FAN_AS_IN1_EN);
 		ene_write_reg(dev, ENE_FAN_AS_IN2, ENE_FAN_AS_IN2_EN);
 	}
-	dev->rx_fan_input_inuse = enable;
 }
 
 /* setup the receiver for RX*/
 static void ene_rx_setup(struct ene_device *dev)
 {
-	bool learning_mode = dev->learning_enabled ||
+	bool learning_mode = dev->learning_mode_enabled ||
 					dev->carrier_detect_enabled;
 	int sample_period_adjust = 0;
 
+	dbg("RX: setup receiver, learning mode = %d", learning_mode);
+
+
 	/* This selects RLC input and clears CFG2 settings */
 	ene_write_reg(dev, ENE_CIRCFG2, 0x00);
 
@@ -284,7 +425,7 @@ static void ene_rx_setup(struct ene_device *dev)
 		and vice versa.
 		This input will carry non demodulated
 		signal, and we will tell the hw to demodulate it itself */
-		ene_select_rx_input(dev, !dev->hw_use_gpio_0a);
+		ene_rx_select_input(dev, !dev->hw_use_gpio_0a);
 		dev->rx_fan_input_inuse = false;
 
 		/* Enable carrier demodulation */
@@ -298,7 +439,7 @@ static void ene_rx_setup(struct ene_device *dev)
 		if (dev->hw_fan_input)
 			dev->rx_fan_input_inuse = true;
 		else
-			ene_select_rx_input(dev, dev->hw_use_gpio_0a);
+			ene_rx_select_input(dev, dev->hw_use_gpio_0a);
 
 		/* Disable carrier detection & demodulation */
 		ene_clear_reg_mask(dev, ENE_CIRCFG, ENE_CIRCFG_CARR_DEMOD);
@@ -339,7 +480,6 @@ select_timeout:
 static void ene_rx_enable(struct ene_device *dev)
 {
 	u8 reg_value;
-	dbg("RX: setup receiver, learning mode = %d", learning_mode);
 
 	/* Enable system interrupt */
 	if (dev->hw_revision < ENE_HW_C) {
@@ -354,8 +494,8 @@ static void ene_rx_enable(struct ene_device *dev)
 	}
 
 	/* Enable inputs */
-	ene_enable_fan_input(dev, dev->rx_fan_input_inuse);
-	ene_enable_cir_engine(dev, !dev->rx_fan_input_inuse);
+	ene_rx_enable_fan_input(dev, dev->rx_fan_input_inuse);
+	ene_rx_enable_cir_engine(dev, !dev->rx_fan_input_inuse);
 
 	/* ack any pending irqs - just in case */
 	ene_irq_status(dev);
@@ -372,8 +512,8 @@ static void ene_rx_enable(struct ene_device *dev)
 static void ene_rx_disable(struct ene_device *dev)
 {
 	/* disable inputs */
-	ene_enable_cir_engine(dev, false);
-	ene_enable_fan_input(dev, false);
+	ene_rx_enable_cir_engine(dev, false);
+	ene_rx_enable_fan_input(dev, false);
 
 	/* disable hardware IRQ and firmware flag */
 	ene_clear_reg_mask(dev, ENE_FW1, ENE_FW1_ENABLE | ENE_FW1_IRQ);
@@ -382,8 +522,60 @@ static void ene_rx_disable(struct ene_device *dev)
 	dev->rx_enabled = false;
 }
 
+/* This resets the receiver. Usefull to stop stream of spaces at end of
+ * transmission
+ */
+static void ene_rx_reset(struct ene_device *dev)
+{
+	ene_clear_reg_mask(dev, ENE_CIRCFG, ENE_CIRCFG_RX_EN);
+	ene_set_reg_mask(dev, ENE_CIRCFG, ENE_CIRCFG_RX_EN);
+}
+
+/* Set up the TX carrier frequency and duty cycle */
+static void ene_tx_set_carrier(struct ene_device *dev)
+{
+	u8 tx_puls_width;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->hw_lock, flags);
+
+	ene_set_clear_reg_mask(dev, ENE_CIRCFG,
+		ENE_CIRCFG_TX_CARR, dev->tx_period > 0);
+
+	if (!dev->tx_period)
+		goto unlock;
+
+	BUG_ON(dev->tx_duty_cycle >= 100 || dev->tx_duty_cycle <= 0);
+
+	tx_puls_width = dev->tx_period / (100 / dev->tx_duty_cycle);
+
+	if (!tx_puls_width)
+		tx_puls_width = 1;
+
+	dbg("TX: pulse distance = %d * 500 ns", dev->tx_period);
+	dbg("TX: pulse width = %d * 500 ns", tx_puls_width);
+
+	ene_write_reg(dev, ENE_CIRMOD_PRD, dev->tx_period | ENE_CIRMOD_PRD_POL);
+	ene_write_reg(dev, ENE_CIRMOD_HPRD, tx_puls_width);
+unlock:
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+}
+
+/* Enable/disable transmitters */
+static void ene_tx_set_transmitters(struct ene_device *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->hw_lock, flags);
+	ene_set_clear_reg_mask(dev, ENE_GPIOFS8, ENE_GPIOFS8_GPIO41,
+					!!(dev->transmitter_mask & 0x01));
+	ene_set_clear_reg_mask(dev, ENE_GPIOFS1, ENE_GPIOFS1_GPIO0D,
+					!!(dev->transmitter_mask & 0x02));
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+}
+
 /* prepare transmission */
-static void ene_tx_prepare(struct ene_device *dev)
+static void ene_tx_enable(struct ene_device *dev)
 {
 	u8 conf1 = ene_read_reg(dev, ENE_CIRCFG);
 	u8 fwreg2 = ene_read_reg(dev, ENE_FW2);
@@ -400,32 +592,6 @@ static void ene_tx_prepare(struct ene_device *dev)
 	if (!(fwreg2 & (ENE_FW2_EMMITER1_CONN | ENE_FW2_EMMITER2_CONN)))
 		ene_warn("TX: transmitter cable isn't connected!");
 
-	/* Set transmitter mask */
-	ene_set_clear_reg_mask(dev, ENE_GPIOFS8, ENE_GPIOFS8_GPIO41,
-					!!(dev->transmitter_mask & 0x01));
-	ene_set_clear_reg_mask(dev, ENE_GPIOFS1, ENE_GPIOFS1_GPIO0D,
-					!!(dev->transmitter_mask & 0x02));
-
-	/* Set the carrier period && duty cycle */
-	if (dev->tx_period) {
-
-		int tx_puls_width = dev->tx_period / (100 / dev->tx_duty_cycle);
-
-		if (!tx_puls_width)
-			tx_puls_width = 1;
-
-		dbg("TX: pulse distance = %d * 500 ns", dev->tx_period);
-		dbg("TX: pulse width = %d * 500 ns", tx_puls_width);
-
-		ene_write_reg(dev, ENE_CIRMOD_PRD, ENE_CIRMOD_PRD_POL |
-					dev->tx_period);
-
-		ene_write_reg(dev, ENE_CIRMOD_HPRD, tx_puls_width);
-
-		conf1 |= ENE_CIRCFG_TX_CARR;
-	} else
-		conf1 &= ~ENE_CIRCFG_TX_CARR;
-
 	/* disable receive on revc */
 	if (dev->hw_revision == ENE_HW_C)
 		conf1 &= ~ENE_CIRCFG_RX_EN;
@@ -436,7 +602,7 @@ static void ene_tx_prepare(struct ene_device *dev)
 }
 
 /* end transmission */
-static void ene_tx_complete(struct ene_device *dev)
+static void ene_tx_disable(struct ene_device *dev)
 {
 	ene_write_reg(dev, ENE_CIRCFG, dev->saved_conf1);
 	dev->tx_buffer = NULL;
@@ -465,7 +631,7 @@ static void ene_tx_sample(struct ene_device *dev)
 				goto exit;
 			} else {
 				dbg("TX: last sample sent by hardware");
-				ene_tx_complete(dev);
+				ene_tx_disable(dev);
 				complete(&dev->tx_complete);
 				return;
 			}
@@ -509,85 +675,6 @@ static void ene_tx_irqsim(unsigned long data)
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 }
 
-/* Read properities of hw sample buffer */
-static void ene_setup_hw_buffer(struct ene_device *dev)
-{
-	u16 tmp;
-
-	ene_read_hw_pointer(dev);
-	dev->r_pointer = dev->w_pointer;
-
-	if (!dev->hw_extra_buffer) {
-		dev->buffer_len = ENE_FW_PACKET_SIZE * 2;
-		return;
-	}
-
-	tmp = ene_read_reg(dev, ENE_FW_SAMPLE_BUFFER);
-	tmp |= ene_read_reg(dev, ENE_FW_SAMPLE_BUFFER+1) << 8;
-	dev->extra_buf1_address = tmp;
-
-	dev->extra_buf1_len = ene_read_reg(dev, ENE_FW_SAMPLE_BUFFER + 2);
-
-	tmp = ene_read_reg(dev, ENE_FW_SAMPLE_BUFFER + 3);
-	tmp |= ene_read_reg(dev, ENE_FW_SAMPLE_BUFFER + 4) << 8;
-	dev->extra_buf2_address = tmp;
-
-	dev->extra_buf2_len = ene_read_reg(dev, ENE_FW_SAMPLE_BUFFER + 5);
-
-	dev->buffer_len = dev->extra_buf1_len + dev->extra_buf2_len + 8;
-
-	ene_notice("Hardware uses 2 extended buffers:");
-	ene_notice("  0x%04x - len : %d", dev->extra_buf1_address,
-						dev->extra_buf1_len);
-	ene_notice("  0x%04x - len : %d", dev->extra_buf2_address,
-						dev->extra_buf2_len);
-
-	ene_notice("Total buffer len = %d", dev->buffer_len);
-
-	if (dev->buffer_len > 64 || dev->buffer_len < 16)
-		goto error;
-
-	if (dev->extra_buf1_address > 0xFBFC ||
-					dev->extra_buf1_address < 0xEC00)
-		goto error;
-
-	if (dev->extra_buf2_address > 0xFBFC ||
-					dev->extra_buf2_address < 0xEC00)
-		goto error;
-
-	if (dev->r_pointer > dev->buffer_len)
-		goto error;
-
-	ene_set_reg_mask(dev, ENE_FW1, ENE_FW1_EXTRA_BUF_HND);
-	return;
-error:
-	ene_warn("Error validating extra buffers, device probably won't work");
-	dev->hw_extra_buffer = false;
-	ene_clear_reg_mask(dev, ENE_FW1, ENE_FW1_EXTRA_BUF_HND);
-}
-
-
-/* Restore the pointers to extra buffers - to make module reload work*/
-static void ene_restore_extra_buffer(struct ene_device *dev)
-{
-	if (!dev->hw_extra_buffer)
-		return;
-
-	ene_write_reg(dev, ENE_FW_SAMPLE_BUFFER + 0,
-				dev->extra_buf1_address & 0xFF);
-	ene_write_reg(dev, ENE_FW_SAMPLE_BUFFER + 1,
-				dev->extra_buf1_address >> 8);
-	ene_write_reg(dev, ENE_FW_SAMPLE_BUFFER + 2, dev->extra_buf1_len);
-
-	ene_write_reg(dev, ENE_FW_SAMPLE_BUFFER + 3,
-				dev->extra_buf2_address & 0xFF);
-	ene_write_reg(dev, ENE_FW_SAMPLE_BUFFER + 4,
-				dev->extra_buf2_address >> 8);
-	ene_write_reg(dev, ENE_FW_SAMPLE_BUFFER + 5,
-				dev->extra_buf2_len);
-	ene_clear_reg_mask(dev, ENE_FW1, ENE_FW1_EXTRA_BUF_HND);
-}
-
 
 /* read irq status and ack it */
 static int ene_irq_status(struct ene_device *dev)
@@ -632,66 +719,6 @@ static int ene_irq_status(struct ene_device *dev)
 	return retval;
 }
 
-/* Read hardware write pointer */
-static void ene_read_hw_pointer(struct ene_device *dev)
-{
-	if (dev->hw_extra_buffer)
-		dev->w_pointer = ene_read_reg(dev, ENE_FW_RX_POINTER);
-	else
-		dev->w_pointer = ene_read_reg(dev, ENE_FW2)
-			& ENE_FW2_BUF_WPTR ? 0 : ENE_FW_PACKET_SIZE;
-
-	dbg_verbose("RB: HW write pointer: %02x, driver read pointer: %02x",
-		dev->w_pointer, dev->r_pointer);
-}
-
-/* Gets address of next sample from HW ring buffer */
-static int ene_get_sample_reg(struct ene_device *dev)
-{
-	int r_pointer;
-
-	if (dev->r_pointer == dev->w_pointer) {
-		dbg_verbose("RB: hit end, try update w_pointer");
-		ene_read_hw_pointer(dev);
-	}
-
-	if (dev->r_pointer == dev->w_pointer) {
-		dbg_verbose("RB: end of data at %d", dev->r_pointer);
-		return 0;
-	}
-
-	dbg_verbose("RB: reading at offset %d", dev->r_pointer);
-	r_pointer = dev->r_pointer;
-
-	dev->r_pointer++;
-	if (dev->r_pointer == dev->buffer_len)
-		dev->r_pointer = 0;
-
-	dbg_verbose("RB: next read will be from offset %d", dev->r_pointer);
-
-	if (r_pointer < 8) {
-		dbg_verbose("RB: read at main buffer at %d", r_pointer);
-		return ENE_FW_SAMPLE_BUFFER + r_pointer;
-	}
-
-	r_pointer -= 8;
-
-	if (r_pointer < dev->extra_buf1_len) {
-		dbg_verbose("RB: read at 1st extra buffer at %d", r_pointer);
-		return dev->extra_buf1_address + r_pointer;
-	}
-
-	r_pointer -= dev->extra_buf1_len;
-
-	if (r_pointer < dev->extra_buf2_len) {
-		dbg_verbose("RB: read at 2nd extra buffer at %d", r_pointer);
-		return dev->extra_buf2_address + r_pointer;
-	}
-
-	dbg("attempt to read beyong ring bufer end");
-	return 0;
-}
-
 /* interrupt handler */
 static irqreturn_t ene_isr(int irq, void *data)
 {
@@ -706,7 +733,7 @@ static irqreturn_t ene_isr(int irq, void *data)
 	spin_lock_irqsave(&dev->hw_lock, flags);
 
 	dbg_verbose("ISR called");
-	ene_read_hw_pointer(dev);
+	ene_rx_read_hw_pointer(dev);
 	irq_status = ene_irq_status(dev);
 
 	if (!irq_status)
@@ -738,7 +765,7 @@ static irqreturn_t ene_isr(int irq, void *data)
 
 	while (1) {
 
-		reg = ene_get_sample_reg(dev);
+		reg = ene_rx_get_sample_reg(dev);
 
 		dbg_verbose("next sample to read at: %04x", reg);
 		if (!reg)
@@ -788,17 +815,28 @@ unlock:
 }
 
 /* Initialize default settings */
-static void ene_setup_settings(struct ene_device *dev)
+static void ene_setup_default_settings(struct ene_device *dev)
 {
 	dev->tx_period = 32;
 	dev->tx_duty_cycle = 50; /*%*/
 	dev->transmitter_mask = 0x03;
-	dev->learning_enabled = learning_mode;
+	dev->learning_mode_enabled = learning_mode_force;
 
 	/* Set reasonable default timeout */
 	dev->props->timeout = MS_TO_NS(150000);
 }
 
+/* Upload all hardware settings at once. Used at load and resume time */
+static void ene_setup_hw_settings(struct ene_device *dev)
+{
+	if (dev->hw_learning_and_tx_capable) {
+		ene_tx_set_carrier(dev);
+		ene_tx_set_transmitters(dev);
+	}
+
+	ene_rx_setup(dev);
+}
+
 /* outside interface: called on first open*/
 static int ene_open(void *data)
 {
@@ -826,7 +864,6 @@ static void ene_close(void *data)
 static int ene_set_tx_mask(void *data, u32 tx_mask)
 {
 	struct ene_device *dev = (struct ene_device *)data;
-	unsigned long flags;
 	dbg("TX: attempt to set transmitter mask %02x", tx_mask);
 
 	/* invalid txmask */
@@ -836,9 +873,8 @@ static int ene_set_tx_mask(void *data, u32 tx_mask)
 		return 2;
 	}
 
-	spin_lock_irqsave(&dev->hw_lock, flags);
 	dev->transmitter_mask = tx_mask;
-	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	ene_tx_set_transmitters(dev);
 	return 0;
 }
 
@@ -846,7 +882,6 @@ static int ene_set_tx_mask(void *data, u32 tx_mask)
 static int ene_set_tx_carrier(void *data, u32 carrier)
 {
 	struct ene_device *dev = (struct ene_device *)data;
-	unsigned long flags;
 	u32 period = 2000000 / carrier;
 
 	dbg("TX: attempt to set tx carrier to %d kHz", carrier);
@@ -855,16 +890,12 @@ static int ene_set_tx_carrier(void *data, u32 carrier)
 			period < ENE_CIRMOD_PRD_MIN)) {
 
 		dbg("TX: out of range %d-%d kHz carrier",
-			2000 / ENE_CIRMOD_PRD_MIN,
-			2000 / ENE_CIRMOD_PRD_MAX);
-
+			2000 / ENE_CIRMOD_PRD_MIN, 2000 / ENE_CIRMOD_PRD_MAX);
 		return -1;
 	}
 
-	dbg("TX: set carrier to %d kHz", carrier);
-	spin_lock_irqsave(&dev->hw_lock, flags);
 	dev->tx_period = period;
-	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	ene_tx_set_carrier(dev);
 	return 0;
 }
 
@@ -872,15 +903,9 @@ static int ene_set_tx_carrier(void *data, u32 carrier)
 static int ene_set_tx_duty_cycle(void *data, u32 duty_cycle)
 {
 	struct ene_device *dev = (struct ene_device *)data;
-	unsigned long flags;
-
 	dbg("TX: setting duty cycle to %d%%", duty_cycle);
-
-	BUG_ON(!duty_cycle || duty_cycle >= 100);
-
-	spin_lock_irqsave(&dev->hw_lock, flags);
 	dev->tx_duty_cycle = duty_cycle;
-	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	ene_tx_set_carrier(dev);
 	return 0;
 }
 
@@ -889,11 +914,11 @@ static int ene_set_learning_mode(void *data, int enable)
 {
 	struct ene_device *dev = (struct ene_device *)data;
 	unsigned long flags;
-	if (enable == dev->learning_enabled)
+	if (enable == dev->learning_mode_enabled)
 		return 0;
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
-	dev->learning_enabled = enable;
+	dev->learning_mode_enabled = enable;
 	ene_rx_disable(dev);
 	ene_rx_setup(dev);
 	ene_rx_enable(dev);
@@ -919,16 +944,12 @@ static int ene_set_carrier_report(void *data, int enable)
 }
 
 /* outside interface: enable or disable idle mode */
-static void ene_rx_set_idle(void *data, bool idle)
+static void ene_set_idle(void *data, bool idle)
 {
-	struct ene_device *dev = (struct ene_device *)data;
-
-	if (!idle)
-		return;
-
-	dbg("RX: stopping the receiver");
-	ene_clear_reg_mask(dev, ENE_CIRCFG, ENE_CIRCFG_RX_EN);
-	ene_set_reg_mask(dev, ENE_CIRCFG, ENE_CIRCFG_RX_EN);
+	if (idle) {
+		ene_rx_reset((struct ene_device *)data);
+		dbg("RX: end of data");
+	}
 }
 
 /* outside interface: transmit */
@@ -949,7 +970,7 @@ static int ene_transmit(void *data, int *buf, u32 n)
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
 
-	ene_tx_prepare(dev);
+	ene_tx_enable(dev);
 
 	/* Transmit first two samples */
 	ene_tx_sample(dev);
@@ -960,7 +981,7 @@ static int ene_transmit(void *data, int *buf, u32 n)
 	if (wait_for_completion_timeout(&dev->tx_complete, 2 * HZ) == 0) {
 		dbg("TX: timeout");
 		spin_lock_irqsave(&dev->hw_lock, flags);
-		ene_tx_complete(dev);
+		ene_tx_disable(dev);
 		spin_unlock_irqrestore(&dev->hw_lock, flags);
 	} else
 		dbg("TX: done");
@@ -1031,14 +1052,14 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	}
 
 	if (!dev->hw_learning_and_tx_capable)
-		learning_mode = false;
+		learning_mode_force = false;
 
 	ir_props->driver_type = RC_DRIVER_IR_RAW;
 	ir_props->allowed_protos = IR_TYPE_ALL;
 	ir_props->priv = dev;
 	ir_props->open = ene_open;
 	ir_props->close = ene_close;
-	ir_props->s_idle = ene_rx_set_idle;
+	ir_props->s_idle = ene_set_idle;
 
 	dev->props = ir_props;
 	dev->idev = input_dev;
@@ -1053,9 +1074,9 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		ir_props->s_carrier_report = ene_set_carrier_report;
 	}
 
-	ene_setup_hw_buffer(dev);
-	ene_setup_settings(dev);
-	ene_rx_setup(dev);
+	ene_rx_setup_hw_buffer(dev);
+	ene_setup_default_settings(dev);
+	ene_setup_hw_settings(dev);
 
 	device_set_wakeup_capable(&pnp_dev->dev, true);
 	device_set_wakeup_enable(&pnp_dev->dev, true);
@@ -1092,7 +1113,7 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
 	ene_rx_disable(dev);
-	ene_restore_extra_buffer(dev);
+	ene_rx_restore_hw_buffer(dev);
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 
 	free_irq(dev->irq, dev);
@@ -1123,10 +1144,11 @@ static int ene_suspend(struct pnp_dev *pnp_dev, pm_message_t state)
 static int ene_resume(struct pnp_dev *pnp_dev)
 {
 	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
-	if (dev->rx_enabled) {
-		ene_rx_setup(dev);
+	ene_setup_hw_settings(dev);
+
+	if (dev->rx_enabled)
 		ene_rx_enable(dev);
-	}
+
 	ene_enable_wake(dev, false);
 	return 0;
 }
@@ -1173,8 +1195,8 @@ static void ene_exit(void)
 module_param(sample_period, int, S_IRUGO);
 MODULE_PARM_DESC(sample_period, "Hardware sample period (50 us default)");
 
-module_param(learning_mode, bool, S_IRUGO);
-MODULE_PARM_DESC(learning_mode, "Enable learning mode by default");
+module_param(learning_mode_force, bool, S_IRUGO);
+MODULE_PARM_DESC(learning_mode_force, "Enable learning mode by default");
 
 module_param(debug, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug level");
diff --git a/drivers/media/IR/ene_ir.h b/drivers/media/IR/ene_ir.h
index 39c707b..f587066 100644
--- a/drivers/media/IR/ene_ir.h
+++ b/drivers/media/IR/ene_ir.h
@@ -215,7 +215,7 @@ struct ene_device {
 
 	/* HW features */
 	int hw_revision;			/* hardware revision */
-	bool hw_use_gpio_0a;			/* gpio40 is demodulated input*/
+	bool hw_use_gpio_0a;			/* gpio0a is demodulated input*/
 	bool hw_extra_buffer;			/* hardware has 'extra buffer' */
 	bool hw_fan_input;			/* fan input is IR data source */
 	bool hw_learning_and_tx_capable;	/* learning & tx capable */
@@ -252,11 +252,11 @@ struct ene_device {
 	int transmitter_mask;
 
 	/* RX settings */
-	bool learning_enabled;			/* learning input enabled */
+	bool learning_mode_enabled;		/* learning input enabled */
 	bool carrier_detect_enabled;		/* carrier detect enabled */
 	int rx_period_adjust;
 	bool rx_enabled;
 };
 
 static int ene_irq_status(struct ene_device *dev);
-static void ene_read_hw_pointer(struct ene_device *dev);
+static void ene_rx_read_hw_pointer(struct ene_device *dev);
-- 
1.7.1

