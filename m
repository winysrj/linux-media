Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57693 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab0IFV0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 17:26:39 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 6/8] IR: ene_ir: updates
Date: Tue,  7 Sep 2010 00:26:11 +0300
Message-Id: <1283808373-27876-7-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

* Add support for newer firmware version that uses different
buffer format. Makes hardware work for many users.

* Register name updates

* Lot of refactoring

* Lots of fixes as a result of full testing

* Idle mode is done now by resetting the device, and this eliminates
the ugly sample_period = 75 hack.

Every feature of the driver is now well tested.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/Kconfig  |    6 +-
 drivers/media/IR/ene_ir.c |  978 ++++++++++++++++++++++++++-------------------
 drivers/media/IR/ene_ir.h |  273 +++++++------
 3 files changed, 719 insertions(+), 538 deletions(-)

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index 490c57c..e9bfdca 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -114,15 +114,15 @@ config IR_MCEUSB
 	   module will be called mceusb.
 
 config IR_ENE
-	tristate "ENE eHome Receiver/Transciever (pnp id: ENE0100/ENE02xxx)"
+	tristate "ENE eHome Receiver/Transceiver (pnp id: ENE0100/ENE02xxx)"
 	depends on PNP
 	depends on IR_CORE
 	---help---
 	   Say Y here to enable support for integrated infrared receiver
-	   /transciever made by ENE.
+	   /transceiver made by ENE.
 
 	   You can see if you have it by looking at lspnp output.
-	   Output should include ENE0100 ENE0200 or something similiar.
+	   Output should include ENE0100 ENE0200 or something similar.
 
 	   To compile this driver as a module, choose M here: the
 	   module will be called ene_ir.
diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
index 5447750..7880d9c 100644
--- a/drivers/media/IR/ene_ir.c
+++ b/drivers/media/IR/ene_ir.c
@@ -1,5 +1,5 @@
 /*
- * driver for ENE KB3926 B/C/D CIR (pnp id: ENE0XXX)
+ * driver for ENE KB3926 B/C/D/E/F CIR (pnp id: ENE0XXX)
  *
  * Copyright (C) 2010 Maxim Levitsky <maximlevitsky@gmail.com>
  *
@@ -17,6 +17,17 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
+ *
+ * Special thanks to:
+ *   Sami R. <maesesami@gmail.com> for lot of help in debugging and therefore
+ *    bringing to life support for transmission & learning mode.
+ *
+ *   Charlie Andrews <charliethepilot@googlemail.com> for lots of help in
+ *   bringing up the support of new firmware buffer that is popular
+ *   on latest notebooks
+ *
+ *   ENE for partial device documentation
+ *
  */
 
 #include <linux/kernel.h>
@@ -31,51 +42,59 @@
 #include <media/ir-common.h>
 #include "ene_ir.h"
 
-
-static int sample_period = -1;
-static int enable_idle = 1;
-static int input = 1;
+static int sample_period;
+static bool learning_mode;
 static int debug;
-static int txsim;
+static bool txsim;
 
-static int ene_irq_status(struct ene_device *dev);
+static void ene_set_reg_addr(struct ene_device *dev, u16 reg)
+{
+	outb(reg >> 8, dev->hw_io + ENE_ADDR_HI);
+	outb(reg & 0xFF, dev->hw_io + ENE_ADDR_LO);
+}
 
 /* read a hardware register */
-static u8 ene_hw_read_reg(struct ene_device *dev, u16 reg)
+static u8 ene_read_reg(struct ene_device *dev, u16 reg)
 {
 	u8 retval;
-	outb(reg >> 8, dev->hw_io + ENE_ADDR_HI);
-	outb(reg & 0xFF, dev->hw_io + ENE_ADDR_LO);
+	ene_set_reg_addr(dev, reg);
 	retval = inb(dev->hw_io + ENE_IO);
-
-	ene_dbg_verbose("reg %04x == %02x", reg, retval);
+	dbg_regs("reg %04x == %02x", reg, retval);
 	return retval;
 }
 
 /* write a hardware register */
-static void ene_hw_write_reg(struct ene_device *dev, u16 reg, u8 value)
+static void ene_write_reg(struct ene_device *dev, u16 reg, u8 value)
 {
-	outb(reg >> 8, dev->hw_io + ENE_ADDR_HI);
-	outb(reg & 0xFF, dev->hw_io + ENE_ADDR_LO);
+	dbg_regs("reg %04x <- %02x", reg, value);
+	ene_set_reg_addr(dev, reg);
 	outb(value, dev->hw_io + ENE_IO);
-
-	ene_dbg_verbose("reg %04x <- %02x", reg, value);
 }
 
-/* change specific bits in hardware register */
-static void ene_hw_write_reg_mask(struct ene_device *dev,
-				  u16 reg, u8 value, u8 mask)
+/* Set bits in hardware register */
+static void ene_set_reg_mask(struct ene_device *dev, u16 reg, u8 mask)
 {
-	u8 regvalue;
-
-	outb(reg >> 8, dev->hw_io + ENE_ADDR_HI);
-	outb(reg & 0xFF, dev->hw_io + ENE_ADDR_LO);
+	dbg_regs("reg %04x |= %02x", reg, mask);
+	ene_set_reg_addr(dev, reg);
+	outb(inb(dev->hw_io + ENE_IO) | mask, dev->hw_io + ENE_IO);
+}
 
-	regvalue = inb(dev->hw_io + ENE_IO) & ~mask;
-	regvalue |= (value & mask);
-	outb(regvalue, dev->hw_io + ENE_IO);
+/* Clear bits in hardware register */
+static void ene_clear_reg_mask(struct ene_device *dev, u16 reg, u8 mask)
+{
+	dbg_regs("reg %04x &= ~%02x ", reg, mask);
+	ene_set_reg_addr(dev, reg);
+	outb(inb(dev->hw_io + ENE_IO) & ~mask, dev->hw_io + ENE_IO);
+}
 
-	ene_dbg_verbose("reg %04x <- %02x (mask=%02x)", reg, value, mask);
+/* A helper to set/clear a bit in register according to boolean variable */
+static void ene_set_clear_reg_mask(struct ene_device *dev, u16 reg, u8 mask,
+								bool set)
+{
+	if (set)
+		ene_set_reg_mask(dev, reg, mask);
+	else
+		ene_clear_reg_mask(dev, reg, mask);
 }
 
 /* detect hardware features */
@@ -83,339 +102,369 @@ static int ene_hw_detect(struct ene_device *dev)
 {
 	u8 chip_major, chip_minor;
 	u8 hw_revision, old_ver;
-	u8 tmp;
-	u8 fw_capabilities;
-	int pll_freq;
-
-	tmp = ene_hw_read_reg(dev, ENE_HW_UNK);
-	ene_hw_write_reg(dev, ENE_HW_UNK, tmp & ~ENE_HW_UNK_CLR);
+	u8 fw_reg2, fw_reg1;
 
-	chip_major = ene_hw_read_reg(dev, ENE_HW_VER_MAJOR);
-	chip_minor = ene_hw_read_reg(dev, ENE_HW_VER_MINOR);
+	ene_clear_reg_mask(dev, ENE_ECSTS, ENE_ECSTS_RSRVD);
+	chip_major = ene_read_reg(dev, ENE_ECVER_MAJOR);
+	chip_minor = ene_read_reg(dev, ENE_ECVER_MINOR);
+	ene_set_reg_mask(dev, ENE_ECSTS, ENE_ECSTS_RSRVD);
 
-	ene_hw_write_reg(dev, ENE_HW_UNK, tmp);
-	hw_revision = ene_hw_read_reg(dev, ENE_HW_VERSION);
-	old_ver = ene_hw_read_reg(dev, ENE_HW_VER_OLD);
+	hw_revision = ene_read_reg(dev, ENE_ECHV);
+	old_ver = ene_read_reg(dev, ENE_HW_VER_OLD);
 
-	pll_freq = (ene_hw_read_reg(dev, ENE_PLLFRH) << 4) +
-		(ene_hw_read_reg(dev, ENE_PLLFRL) >> 4);
-
-	if (pll_freq != 1000)
-		dev->rx_period_adjust = 4;
-	else
-		dev->rx_period_adjust = 2;
+	dev->pll_freq = (ene_read_reg(dev, ENE_PLLFRH) << 4) +
+		(ene_read_reg(dev, ENE_PLLFRL) >> 4);
 
-
-	ene_printk(KERN_NOTICE, "PLL freq = %d\n", pll_freq);
+	if (sample_period != ENE_DEFAULT_SAMPLE_PERIOD)
+		dev->rx_period_adjust =
+			dev->pll_freq == ENE_DEFAULT_PLL_FREQ ? 2 : 4;
 
 	if (hw_revision == 0xFF) {
-
-		ene_printk(KERN_WARNING, "device seems to be disabled\n");
-		ene_printk(KERN_WARNING,
-			"send a mail to lirc-list@lists.sourceforge.net\n");
-		ene_printk(KERN_WARNING, "please attach output of acpidump\n");
+		ene_warn("device seems to be disabled");
+		ene_warn("send a mail to lirc-list@lists.sourceforge.net");
+		ene_warn("please attach output of acpidump and dmidecode");
 		return -ENODEV;
 	}
 
+	ene_notice("chip is 0x%02x%02x - kbver = 0x%02x, rev = 0x%02x",
+		chip_major, chip_minor, old_ver, hw_revision);
+
+	ene_notice("PLL freq = %d", dev->pll_freq);
+
 	if (chip_major == 0x33) {
-		ene_printk(KERN_WARNING, "chips 0x33xx aren't supported\n");
+		ene_warn("chips 0x33xx aren't supported");
 		return -ENODEV;
 	}
 
 	if (chip_major == 0x39 && chip_minor == 0x26 && hw_revision == 0xC0) {
 		dev->hw_revision = ENE_HW_C;
+		ene_notice("KB3926C detected");
 	} else if (old_ver == 0x24 && hw_revision == 0xC0) {
 		dev->hw_revision = ENE_HW_B;
-		ene_printk(KERN_NOTICE, "KB3926B detected\n");
+		ene_notice("KB3926B detected");
 	} else {
 		dev->hw_revision = ENE_HW_D;
-		ene_printk(KERN_WARNING,
-			"unknown ENE chip detected, assuming KB3926D\n");
-		ene_printk(KERN_WARNING,
-			"driver support might be not complete");
-
+		ene_notice("KB3926D or higher detected");
 	}
 
-	ene_printk(KERN_DEBUG,
-		"chip is 0x%02x%02x - kbver = 0x%02x, rev = 0x%02x\n",
-			chip_major, chip_minor, old_ver, hw_revision);
-
 	/* detect features hardware supports */
 	if (dev->hw_revision < ENE_HW_C)
 		return 0;
 
-	fw_capabilities = ene_hw_read_reg(dev, ENE_FW2);
-	ene_dbg("Firmware capabilities: %02x", fw_capabilities);
+	fw_reg1 = ene_read_reg(dev, ENE_FW1);
+	fw_reg2 = ene_read_reg(dev, ENE_FW2);
 
-	dev->hw_gpio40_learning = fw_capabilities & ENE_FW2_GP40_AS_LEARN;
-	dev->hw_learning_and_tx_capable = fw_capabilities & ENE_FW2_LEARNING;
+	ene_notice("Firmware regs: %02x %02x", fw_reg1, fw_reg2);
 
-	dev->hw_fan_as_normal_input = dev->hw_learning_and_tx_capable &&
-	    (fw_capabilities & ENE_FW2_FAN_AS_NRML_IN);
+	dev->hw_use_gpio_0a = fw_reg2 & ENE_FW2_GP0A;
+	dev->hw_learning_and_tx_capable = fw_reg2 & ENE_FW2_LEARNING;
+	dev->hw_extra_buffer = fw_reg1 & ENE_FW1_HAS_EXTRA_BUF;
+	dev->hw_fan_input = dev->hw_learning_and_tx_capable &&
+	    (fw_reg2 & ENE_FW2_FAN_INPUT);
 
-	ene_printk(KERN_NOTICE, "hardware features:\n");
-	ene_printk(KERN_NOTICE,
-		"learning and transmit %s, gpio40_learn %s, fan_in %s\n",
-	       dev->hw_learning_and_tx_capable ? "on" : "off",
-	       dev->hw_gpio40_learning ? "on" : "off",
-	       dev->hw_fan_as_normal_input ? "on" : "off");
+	ene_notice("Hardware features:");
 
 	if (dev->hw_learning_and_tx_capable) {
-		ene_printk(KERN_WARNING,
-		"Device supports transmitting, but that support is\n");
-		ene_printk(KERN_WARNING,
-		"lightly tested. Please test it and mail\n");
-		ene_printk(KERN_WARNING,
-		"lirc-list@lists.sourceforge.net\n");
+		ene_notice("* Supports transmitting & learning mode");
+		ene_notice("   This feature is rare and therefore,");
+		ene_notice("   you are welcome to test it,");
+		ene_notice("   and/or contact the author via:");
+		ene_notice("   lirc-list@lists.sourceforge.net");
+		ene_notice("   or maximlevitsky@gmail.com");
+
+		ene_notice("* Uses GPIO %s for IR raw input",
+			dev->hw_use_gpio_0a ? "40" : "0A");
+
+		if (dev->hw_fan_input)
+			ene_notice("* Uses unused fan feedback input as source"
+					" of demodulated IR data");
 	}
+
+	if (!dev->hw_fan_input)
+		ene_notice("* Uses GPIO %s for IR demodulated input",
+			dev->hw_use_gpio_0a ? "0A" : "40");
+
+	if (dev->hw_extra_buffer)
+		ene_notice("* Uses new style input buffer");
 	return 0;
 }
 
-/* this enables/disables IR input via gpio40*/
-static void ene_enable_gpio40_receive(struct ene_device *dev, int enable)
+/* Sense current received carrier */
+void ene_rx_sense_carrier(struct ene_device *dev)
 {
-	ene_hw_write_reg_mask(dev, ENE_CIR_CONF2, enable ?
-			      0 : ENE_CIR_CONF2_GPIO40DIS,
-			      ENE_CIR_CONF2_GPIO40DIS);
+	int period = ene_read_reg(dev, ENE_CIRCAR_PRD);
+	int hperiod = ene_read_reg(dev, ENE_CIRCAR_HPRD);
+	int carrier, duty_cycle;
+
+
+	if (!(period & ENE_CIRCAR_PRD_VALID))
+		return;
+
+	period &= ~ENE_CIRCAR_PRD_VALID;
+
+	if (!period)
+		return;
+
+	dbg("RX: hardware carrier period = %02x", period);
+	dbg("RX: hardware carrier pulse period = %02x", hperiod);
+
+
+	carrier = 2000000 / period;
+	duty_cycle = (hperiod * 100) / period;
+	dbg("RX: sensed carrier = %d Hz, duty cycle %d%%",
+							carrier, duty_cycle);
+
+	/* TODO: Send carrier & duty cycle to IR layer */
 }
 
-/* this enables/disables IR via standard input */
-static void ene_enable_normal_receive(struct ene_device *dev, int enable)
+/* this enables/disables the CIR RX engine */
+static void ene_enable_cir_engine(struct ene_device *dev, bool enable)
 {
-	ene_hw_write_reg(dev, ENE_CIR_CONF1, enable ? ENE_CIR_CONF1_RX_ON : 0);
+	ene_set_clear_reg_mask(dev, ENE_CIRCFG,
+			ENE_CIRCFG_RX_EN | ENE_CIRCFG_RX_IRQ, enable);
 }
 
-/* this enables/disables IR input via unused fan tachtometer input */
-static void ene_enable_fan_receive(struct ene_device *dev, int enable)
+/* this selects input for CIR engine. Ether GPIO 0A or GPIO40*/
+static void ene_select_rx_input(struct ene_device *dev, bool gpio_0a)
 {
-	if (!enable)
-		ene_hw_write_reg(dev, ENE_FAN_AS_IN1, 0);
-	else {
-		ene_hw_write_reg(dev, ENE_FAN_AS_IN1, ENE_FAN_AS_IN1_EN);
-		ene_hw_write_reg(dev, ENE_FAN_AS_IN2, ENE_FAN_AS_IN2_EN);
-	}
-	dev->rx_fan_input_inuse = enable;
+	ene_set_clear_reg_mask(dev, ENE_CIRCFG2, ENE_CIRCFG2_GPIO0A, gpio_0a);
 }
 
-
-/* Sense current received carrier */
-static int ene_rx_sense_carrier(struct ene_device *dev)
+/*
+ * this enables alternative input via fan tachometer sensor and bypasses
+ * the hw CIR engine
+ */
+static void ene_enable_fan_input(struct ene_device *dev, bool enable)
 {
-	int period = ene_hw_read_reg(dev, ENE_RX_CARRIER);
-	int carrier;
-	ene_dbg("RX: hardware carrier period = %02x", period);
-
-	if (!(period & ENE_RX_CARRIER_VALID))
-		return 0;
-
-	period &= ~ENE_RX_CARRIER_VALID;
-
-	if (!period)
-		return 0;
+	if (!dev->hw_fan_input)
+		return;
 
-	carrier = 2000000 / period;
-	ene_dbg("RX: sensed carrier = %d Hz", carrier);
-	return carrier;
+	if (!enable)
+		ene_write_reg(dev, ENE_FAN_AS_IN1, 0);
+	else {
+		ene_write_reg(dev, ENE_FAN_AS_IN1, ENE_FAN_AS_IN1_EN);
+		ene_write_reg(dev, ENE_FAN_AS_IN2, ENE_FAN_AS_IN2_EN);
+	}
+	dev->rx_fan_input_inuse = enable;
 }
 
-/* determine which input to use*/
-static void ene_rx_set_inputs(struct ene_device *dev)
+/* setup the receiver for RX*/
+static void ene_rx_setup(struct ene_device *dev)
 {
-	int learning_mode = dev->learning_enabled;
+	bool learning_mode = dev->learning_enabled ||
+					dev->carrier_detect_enabled;
+	int sample_period_adjust = 0;
 
-	ene_dbg("RX: setup receiver, learning mode = %d", learning_mode);
 
-	ene_enable_normal_receive(dev, 1);
+	/* set sample period*/
+	if (sample_period == ENE_DEFAULT_SAMPLE_PERIOD)
+		sample_period_adjust =
+			dev->pll_freq == ENE_DEFAULT_PLL_FREQ ? 1 : 2;
 
-	/* old hardware doesn't support learning mode for sure */
-	if (dev->hw_revision <= ENE_HW_B)
-		return;
+	ene_write_reg(dev, ENE_CIRRLC_CFG,
+			(sample_period + sample_period_adjust) |
+						ENE_CIRRLC_CFG_OVERFLOW);
+	/* revB doesn't support inputs */
+	if (dev->hw_revision < ENE_HW_C)
+		goto select_timeout;
 
-	/* receiver not learning capable, still set gpio40 correctly */
-	if (!dev->hw_learning_and_tx_capable) {
-		ene_enable_gpio40_receive(dev, !dev->hw_gpio40_learning);
-		return;
-	}
+	if (learning_mode && dev->hw_learning_and_tx_capable) {
 
-	/* enable learning mode */
-	if (learning_mode) {
-		ene_enable_gpio40_receive(dev, dev->hw_gpio40_learning);
+		/* Enable the opposite of the normal input
+		That means that if GPIO40 is normally used, use GPIO0A
+		and vice versa.
+		This input will carry non demodulated
+		signal, and we will tell the hw to demodulate it itself */
+		ene_select_rx_input(dev, !dev->hw_use_gpio_0a);
+		dev->rx_fan_input_inuse = false;
 
-		/* fan input is not used for learning */
-		if (dev->hw_fan_as_normal_input)
-			ene_enable_fan_receive(dev, 0);
+		/* Enable carrier demodulation */
+		ene_set_reg_mask(dev, ENE_CIRCFG, ENE_CIRCFG_CARR_DEMOD);
 
-	/* disable learning mode */
+		/* Enable carrier detection */
+		ene_set_clear_reg_mask(dev, ENE_CIRCFG2, ENE_CIRCFG2_CARR_DETECT,
+			dev->carrier_detect_enabled || debug);
 	} else {
-		if (dev->hw_fan_as_normal_input) {
-			ene_enable_fan_receive(dev, 1);
-			ene_enable_normal_receive(dev, 0);
-		} else
-			ene_enable_gpio40_receive(dev,
-					!dev->hw_gpio40_learning);
+		if (dev->hw_fan_input)
+			dev->rx_fan_input_inuse = true;
+		else
+			ene_select_rx_input(dev, dev->hw_use_gpio_0a);
+
+		/* Disable carrier detection & demodulation */
+		ene_clear_reg_mask(dev, ENE_CIRCFG, ENE_CIRCFG_CARR_DEMOD);
+		ene_clear_reg_mask(dev, ENE_CIRCFG2, ENE_CIRCFG2_CARR_DETECT);
 	}
 
-	/* set few additional settings for this mode */
-	ene_hw_write_reg_mask(dev, ENE_CIR_CONF1, learning_mode ?
-			      ENE_CIR_CONF1_LEARN1 : 0, ENE_CIR_CONF1_LEARN1);
-
-	ene_hw_write_reg_mask(dev, ENE_CIR_CONF2, learning_mode ?
-			      ENE_CIR_CONF2_LEARN2 : 0, ENE_CIR_CONF2_LEARN2);
-
+select_timeout:
 	if (dev->rx_fan_input_inuse) {
-		dev->props->rx_resolution = ENE_SAMPLE_PERIOD_FAN * 1000;
+		dev->props->rx_resolution = MS_TO_NS(ENE_FW_SAMPLE_PERIOD_FAN);
 
-		dev->props->timeout =
-			ENE_FAN_VALUE_MASK * ENE_SAMPLE_PERIOD_FAN * 1000;
+		/* Fan input doesn't support timeouts, it just ends the
+			input with a maximum sample */
+		dev->props->min_timeout = dev->props->max_timeout =
+			MS_TO_NS(ENE_FW_SMPL_BUF_FAN_MSK *
+				ENE_FW_SAMPLE_PERIOD_FAN);
 	} else {
-		dev->props->rx_resolution = sample_period * 1000;
-		dev->props->timeout = ENE_MAXGAP * 1000;
+		dev->props->rx_resolution = MS_TO_NS(sample_period);
+
+		/* Theoreticly timeout is unlimited, but we cap it
+		 * because it was seen that on one device, it
+		 * would stop sending spaces after around 250 msec.
+		 * Besides, this is close to 2^32 anyway and timeout is u32.
+		 */
+		dev->props->min_timeout = MS_TO_NS(127 * sample_period);
+		dev->props->max_timeout = MS_TO_NS(200000);
 	}
+
+	if (dev->hw_learning_and_tx_capable)
+		dev->props->tx_resolution = MS_TO_NS(sample_period);
+
+	if (dev->props->timeout > dev->props->max_timeout)
+		dev->props->timeout = dev->props->max_timeout;
+	if (dev->props->timeout < dev->props->min_timeout)
+		dev->props->timeout = dev->props->min_timeout;
 }
 
 /* Enable the device for receive */
 static void ene_rx_enable(struct ene_device *dev)
 {
 	u8 reg_value;
+	dbg("RX: setup receiver, learning mode = %d", learning_mode);
 
+	/* Enable system interrupt */
 	if (dev->hw_revision < ENE_HW_C) {
-		ene_hw_write_reg(dev, ENEB_IRQ, dev->irq << 1);
-		ene_hw_write_reg(dev, ENEB_IRQ_UNK1, 0x01);
+		ene_write_reg(dev, ENEB_IRQ, dev->irq << 1);
+		ene_write_reg(dev, ENEB_IRQ_UNK1, 0x01);
 	} else {
-		reg_value = ene_hw_read_reg(dev, ENEC_IRQ) & 0xF0;
-		reg_value |= ENEC_IRQ_UNK_EN;
-		reg_value &= ~ENEC_IRQ_STATUS;
-		reg_value |= (dev->irq & ENEC_IRQ_MASK);
-		ene_hw_write_reg(dev, ENEC_IRQ, reg_value);
-		ene_hw_write_reg(dev, ENE_TX_UNK1, 0x63);
+		reg_value = ene_read_reg(dev, ENE_IRQ) & 0xF0;
+		reg_value |= ENE_IRQ_UNK_EN;
+		reg_value &= ~ENE_IRQ_STATUS;
+		reg_value |= (dev->irq & ENE_IRQ_MASK);
+		ene_write_reg(dev, ENE_IRQ, reg_value);
 	}
 
-	ene_hw_write_reg(dev, ENE_CIR_CONF2, 0x00);
-	ene_rx_set_inputs(dev);
+	if (dev->hw_revision >= ENE_HW_C)
+		ene_write_reg(dev, ENE_CIRCAR_PULS, 0x63);
+
+	/* Enable the inputs */
+	ene_write_reg(dev, ENE_CIRCFG2, 0x00);
 
-	/* set sampling period */
-	ene_hw_write_reg(dev, ENE_CIR_SAMPLE_PERIOD, sample_period);
+	if (dev->rx_fan_input_inuse) {
+		ene_enable_cir_engine(dev, false);
+		ene_enable_fan_input(dev, true);
+	} else {
+		ene_enable_cir_engine(dev, true);
+		ene_enable_fan_input(dev, false);
+	}
 
 	/* ack any pending irqs - just in case */
 	ene_irq_status(dev);
 
 	/* enable firmware bits */
-	ene_hw_write_reg_mask(dev, ENE_FW1,
-			      ENE_FW1_ENABLE | ENE_FW1_IRQ,
-			      ENE_FW1_ENABLE | ENE_FW1_IRQ);
+	ene_set_reg_mask(dev, ENE_FW1, ENE_FW1_ENABLE | ENE_FW1_IRQ);
 
 	/* enter idle mode */
-	ir_raw_event_set_idle(dev->idev, 1);
-	ir_raw_event_reset(dev->idev);
-
+	ir_raw_event_set_idle(dev->idev, true);
+	dev->rx_enabled = true;
 }
 
 /* Disable the device receiver */
 static void ene_rx_disable(struct ene_device *dev)
 {
 	/* disable inputs */
-	ene_enable_normal_receive(dev, 0);
-
-	if (dev->hw_fan_as_normal_input)
-		ene_enable_fan_receive(dev, 0);
+	ene_enable_cir_engine(dev, false);
+	ene_enable_fan_input(dev, false);
 
 	/* disable hardware IRQ and firmware flag */
-	ene_hw_write_reg_mask(dev, ENE_FW1, 0, ENE_FW1_ENABLE | ENE_FW1_IRQ);
+	ene_clear_reg_mask(dev, ENE_FW1, ENE_FW1_ENABLE | ENE_FW1_IRQ);
 
-	ir_raw_event_set_idle(dev->idev, 1);
-	ir_raw_event_reset(dev->idev);
+	ir_raw_event_set_idle(dev->idev, true);
+	dev->rx_enabled = false;
 }
 
-
 /* prepare transmission */
 static void ene_tx_prepare(struct ene_device *dev)
 {
-	u8 conf1;
+	u8 conf1 = ene_read_reg(dev, ENE_CIRCFG);
+	u8 fwreg2 = ene_read_reg(dev, ENE_FW2);
 
-	conf1 = ene_hw_read_reg(dev, ENE_CIR_CONF1);
 	dev->saved_conf1 = conf1;
 
-	if (dev->hw_revision == ENE_HW_C)
-		conf1 &= ~ENE_CIR_CONF1_TX_CLEAR;
+	/* Show information about currently connected transmitter jacks */
+	if (fwreg2 & ENE_FW2_EMMITER1_CONN)
+		dbg("TX: Transmitter #1 is connected");
 
-	/* Enable TX engine */
-	conf1 |= ENE_CIR_CONF1_TX_ON;
+	if (fwreg2 & ENE_FW2_EMMITER2_CONN)
+		dbg("TX: Transmitter #2 is connected");
 
-	/* Set carrier */
-	if (dev->tx_period) {
+	if (!(fwreg2 & (ENE_FW2_EMMITER1_CONN | ENE_FW2_EMMITER2_CONN)))
+		ene_warn("TX: transmitter cable isn't connected!");
+
+	/* Set transmitter mask */
+	ene_set_clear_reg_mask(dev, ENE_GPIOFS8, ENE_GPIOFS8_GPIO41,
+					!!(dev->transmitter_mask & 0x01));
+	ene_set_clear_reg_mask(dev, ENE_GPIOFS1, ENE_GPIOFS1_GPIO0D,
+					!!(dev->transmitter_mask & 0x02));
 
-		/* NOTE: duty cycle handling is just a guess, it might
-			not be aviable. Default values were tested */
-		int tx_period_in500ns = dev->tx_period * 2;
+	/* Set the carrier period && duty cycle */
+	if (dev->tx_period) {
 
-		int tx_pulse_width_in_500ns =
-			tx_period_in500ns / (100 / dev->tx_duty_cycle);
+		int tx_puls_width = dev->tx_period / (100 / dev->tx_duty_cycle);
 
-		if (!tx_pulse_width_in_500ns)
-			tx_pulse_width_in_500ns = 1;
+		if (!tx_puls_width)
+			tx_puls_width = 1;
 
-		ene_dbg("TX: pulse distance = %d * 500 ns", tx_period_in500ns);
-		ene_dbg("TX: pulse width = %d * 500 ns",
-						tx_pulse_width_in_500ns);
+		dbg("TX: pulse distance = %d * 500 ns", dev->tx_period);
+		dbg("TX: pulse width = %d * 500 ns", tx_puls_width);
 
-		ene_hw_write_reg(dev, ENE_TX_PERIOD, ENE_TX_PERIOD_UNKBIT |
-					tx_period_in500ns);
+		ene_write_reg(dev, ENE_CIRMOD_PRD, ENE_CIRMOD_PRD_POL |
+					dev->tx_period);
 
-		ene_hw_write_reg(dev, ENE_TX_PERIOD_PULSE,
-					tx_pulse_width_in_500ns);
+		ene_write_reg(dev, ENE_CIRMOD_HPRD, tx_puls_width);
 
-		conf1 |= ENE_CIR_CONF1_TX_CARR;
+		conf1 |= ENE_CIRCFG_TX_CARR;
 	} else
-		conf1 &= ~ENE_CIR_CONF1_TX_CARR;
+		conf1 &= ~ENE_CIRCFG_TX_CARR;
 
-	ene_hw_write_reg(dev, ENE_CIR_CONF1, conf1);
+	/* disable receive on revc */
+	if (dev->hw_revision == ENE_HW_C)
+		conf1 &= ~ENE_CIRCFG_RX_EN;
 
+	/* Enable TX engine */
+	conf1 |= ENE_CIRCFG_TX_EN | ENE_CIRCFG_TX_IRQ;
+	ene_write_reg(dev, ENE_CIRCFG, conf1);
 }
 
 /* end transmission */
 static void ene_tx_complete(struct ene_device *dev)
 {
-	ene_hw_write_reg(dev, ENE_CIR_CONF1, dev->saved_conf1);
+	ene_write_reg(dev, ENE_CIRCFG, dev->saved_conf1);
 	dev->tx_buffer = NULL;
 }
 
-/* set transmit mask */
-static void ene_tx_hw_set_transmiter_mask(struct ene_device *dev)
-{
-	u8 txport1 = ene_hw_read_reg(dev, ENE_TX_PORT1) & ~ENE_TX_PORT1_EN;
-	u8 txport2 = ene_hw_read_reg(dev, ENE_TX_PORT2) & ~ENE_TX_PORT2_EN;
-
-	if (dev->transmitter_mask & 0x01)
-		txport1 |= ENE_TX_PORT1_EN;
-
-	if (dev->transmitter_mask & 0x02)
-		txport2 |= ENE_TX_PORT2_EN;
-
-	ene_hw_write_reg(dev, ENE_TX_PORT1, txport1);
-	ene_hw_write_reg(dev, ENE_TX_PORT2, txport2);
-}
 
 /* TX one sample - must be called with dev->hw_lock*/
 static void ene_tx_sample(struct ene_device *dev)
 {
 	u8 raw_tx;
 	u32 sample;
+	bool pulse = dev->tx_sample_pulse;
 
 	if (!dev->tx_buffer) {
-		ene_dbg("TX: attempt to transmit NULL buffer");
+		ene_warn("TX: BUG: attempt to transmit NULL buffer");
 		return;
 	}
 
 	/* Grab next TX sample */
 	if (!dev->tx_sample) {
-again:
-		if (dev->tx_pos == dev->tx_len + 1) {
+
+		if (dev->tx_pos == dev->tx_len) {
 			if (!dev->tx_done) {
-				ene_dbg("TX: no more data to send");
-				dev->tx_done = 1;
+				dbg("TX: no more data to send");
+				dev->tx_done = true;
 				goto exit;
 			} else {
-				ene_dbg("TX: last sample sent by hardware");
+				dbg("TX: last sample sent by hardware");
 				ene_tx_complete(dev);
 				complete(&dev->tx_complete);
 				return;
@@ -425,23 +474,23 @@ again:
 		sample = dev->tx_buffer[dev->tx_pos++];
 		dev->tx_sample_pulse = !dev->tx_sample_pulse;
 
-		ene_dbg("TX: sample %8d (%s)", sample, dev->tx_sample_pulse ?
-							"pulse" : "space");
+		dev->tx_sample = DIV_ROUND_CLOSEST(sample, sample_period);
 
-		dev->tx_sample = DIV_ROUND_CLOSEST(sample, ENE_TX_SMPL_PERIOD);
-
-		/* guard against too short samples */
 		if (!dev->tx_sample)
-			goto again;
+			dev->tx_sample = 1;
 	}
 
-	raw_tx = min(dev->tx_sample , (unsigned int)ENE_TX_SMLP_MASK);
+	raw_tx = min(dev->tx_sample , (unsigned int)ENE_CIRRLC_OUT_MASK);
 	dev->tx_sample -= raw_tx;
 
-	if (dev->tx_sample_pulse)
-		raw_tx |= ENE_TX_PULSE_MASK;
+	dbg("TX: sample %8d (%s)", raw_tx * sample_period,
+						pulse ? "pulse" : "space");
+	if (pulse)
+		raw_tx |= ENE_CIRRLC_OUT_PULSE;
+
+	ene_write_reg(dev,
+		dev->tx_reg ? ENE_CIRRLC_OUT1 : ENE_CIRRLC_OUT0, raw_tx);
 
-	ene_hw_write_reg(dev, ENE_TX_INPUT1 + dev->tx_reg, raw_tx);
 	dev->tx_reg = !dev->tx_reg;
 exit:
 	/* simulate TX done interrupt */
@@ -460,82 +509,204 @@ static void ene_tx_irqsim(unsigned long data)
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 }
 
+/* Read properities of hw sample buffer */
+static void ene_setup_hw_buffer(struct ene_device *dev)
+{
+	u16 tmp;
+
+	ene_read_hw_pointer(dev);
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
+static void ene_restore_extra_buffer(struct ene_device *dev)
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
 
 /* read irq status and ack it */
 static int ene_irq_status(struct ene_device *dev)
 {
 	u8 irq_status;
 	u8 fw_flags1, fw_flags2;
-	int cur_rx_pointer;
 	int retval = 0;
 
-	fw_flags2 = ene_hw_read_reg(dev, ENE_FW2);
-	cur_rx_pointer = !!(fw_flags2 & ENE_FW2_BUF_HIGH);
+	fw_flags2 = ene_read_reg(dev, ENE_FW2);
 
 	if (dev->hw_revision < ENE_HW_C) {
-		irq_status = ene_hw_read_reg(dev, ENEB_IRQ_STATUS);
+		irq_status = ene_read_reg(dev, ENEB_IRQ_STATUS);
 
 		if (!(irq_status & ENEB_IRQ_STATUS_IR))
 			return 0;
 
-		ene_hw_write_reg(dev, ENEB_IRQ_STATUS,
-				 irq_status & ~ENEB_IRQ_STATUS_IR);
-		dev->rx_pointer = cur_rx_pointer;
+		ene_clear_reg_mask(dev, ENEB_IRQ_STATUS, ENEB_IRQ_STATUS_IR);
 		return ENE_IRQ_RX;
 	}
 
-	irq_status = ene_hw_read_reg(dev, ENEC_IRQ);
-
-	if (!(irq_status & ENEC_IRQ_STATUS))
+	irq_status = ene_read_reg(dev, ENE_IRQ);
+	if (!(irq_status & ENE_IRQ_STATUS))
 		return 0;
 
 	/* original driver does that twice - a workaround ? */
-	ene_hw_write_reg(dev, ENEC_IRQ, irq_status & ~ENEC_IRQ_STATUS);
-	ene_hw_write_reg(dev, ENEC_IRQ, irq_status & ~ENEC_IRQ_STATUS);
+	ene_write_reg(dev, ENE_IRQ, irq_status & ~ENE_IRQ_STATUS);
+	ene_write_reg(dev, ENE_IRQ, irq_status & ~ENE_IRQ_STATUS);
 
-	/* clear unknown flag in F8F9 */
-	if (fw_flags2 & ENE_FW2_IRQ_CLR)
-		ene_hw_write_reg(dev, ENE_FW2, fw_flags2 & ~ENE_FW2_IRQ_CLR);
+	/* check RX interrupt */
+	if (fw_flags2 & ENE_FW2_RXIRQ) {
+		retval |= ENE_IRQ_RX;
+		ene_write_reg(dev, ENE_FW2, fw_flags2 & ~ENE_FW2_RXIRQ);
+	}
 
-	/* check if this is a TX interrupt */
-	fw_flags1 = ene_hw_read_reg(dev, ENE_FW1);
+	/* check TX interrupt */
+	fw_flags1 = ene_read_reg(dev, ENE_FW1);
 	if (fw_flags1 & ENE_FW1_TXIRQ) {
-		ene_hw_write_reg(dev, ENE_FW1, fw_flags1 & ~ENE_FW1_TXIRQ);
+		ene_write_reg(dev, ENE_FW1, fw_flags1 & ~ENE_FW1_TXIRQ);
 		retval |= ENE_IRQ_TX;
 	}
 
-	/* Check if this is RX interrupt */
-	if (dev->rx_pointer != cur_rx_pointer) {
-		retval |= ENE_IRQ_RX;
-		dev->rx_pointer = cur_rx_pointer;
+	return retval;
+}
 
-	} else if (!(retval & ENE_IRQ_TX)) {
-		ene_dbg("RX: interrupt without change in RX pointer(%d)",
-			dev->rx_pointer);
-		retval |= ENE_IRQ_RX;
+/* Read hardware write pointer */
+static void ene_read_hw_pointer(struct ene_device *dev)
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
+static int ene_get_sample_reg(struct ene_device *dev)
+{
+	int r_pointer;
+
+	if (dev->r_pointer == dev->w_pointer) {
+		dbg_verbose("RB: hit end, try update w_pointer");
+		ene_read_hw_pointer(dev);
 	}
 
-	if ((retval & ENE_IRQ_RX) && (retval & ENE_IRQ_TX))
-		ene_dbg("both RX and TX interrupt at same time");
+	if (dev->r_pointer == dev->w_pointer) {
+		dbg_verbose("RB: end of data at %d", dev->r_pointer);
+		return 0;
+	}
 
-	return retval;
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
 }
 
 /* interrupt handler */
 static irqreturn_t ene_isr(int irq, void *data)
 {
-	u16 hw_value;
-	int i, hw_sample;
-	int pulse;
-	int irq_status;
+	u16 hw_value, reg;
+	int hw_sample, irq_status;
+	bool pulse;
 	unsigned long flags;
-	int carrier = 0;
 	irqreturn_t retval = IRQ_NONE;
 	struct ene_device *dev = (struct ene_device *)data;
 	struct ir_raw_event ev;
 
-
 	spin_lock_irqsave(&dev->hw_lock, flags);
+
+	dbg_verbose("ISR called");
+	ene_read_hw_pointer(dev);
 	irq_status = ene_irq_status(dev);
 
 	if (!irq_status)
@@ -544,9 +715,9 @@ static irqreturn_t ene_isr(int irq, void *data)
 	retval = IRQ_HANDLED;
 
 	if (irq_status & ENE_IRQ_TX) {
-
+		dbg_verbose("TX interrupt");
 		if (!dev->hw_learning_and_tx_capable) {
-			ene_dbg("TX interrupt on unsupported device!");
+			dbg("TX interrupt on unsupported device!");
 			goto unlock;
 		}
 		ene_tx_sample(dev);
@@ -555,48 +726,57 @@ static irqreturn_t ene_isr(int irq, void *data)
 	if (!(irq_status & ENE_IRQ_RX))
 		goto unlock;
 
+	dbg_verbose("RX interrupt");
 
 	if (dev->carrier_detect_enabled || debug)
-		carrier = ene_rx_sense_carrier(dev);
-#if 0
-	/* TODO */
-	if (dev->carrier_detect_enabled && carrier)
-		ir_raw_event_report_frequency(dev->idev, carrier);
-#endif
+		ene_rx_sense_carrier(dev);
+
+	/* On hardware that don't support extra buffer we need to trust
+		the interrupt and not track the read pointer */
+	if (!dev->hw_extra_buffer)
+		dev->r_pointer = dev->w_pointer == 0 ? ENE_FW_PACKET_SIZE : 0;
+
+	while (1) {
 
-	for (i = 0; i < ENE_SAMPLES_SIZE; i++) {
-		hw_value = ene_hw_read_reg(dev,
-				ENE_SAMPLE_BUFFER + dev->rx_pointer * 4 + i);
+		reg = ene_get_sample_reg(dev);
+
+		dbg_verbose("next sample to read at: %04x", reg);
+		if (!reg)
+			break;
+
+		hw_value = ene_read_reg(dev, reg);
 
 		if (dev->rx_fan_input_inuse) {
+
+			int offset = ENE_FW_SMPL_BUF_FAN - ENE_FW_SAMPLE_BUFFER;
+
 			/* read high part of the sample */
-			hw_value |= ene_hw_read_reg(dev,
-			    ENE_SAMPLE_BUFFER_FAN +
-					dev->rx_pointer * 4 + i) << 8;
-			pulse = hw_value & ENE_FAN_SMPL_PULS_MSK;
+			hw_value |= ene_read_reg(dev, reg + offset) << 8;
+			pulse = hw_value & ENE_FW_SMPL_BUF_FAN_PLS;
 
 			/* clear space bit, and other unused bits */
-			hw_value &= ENE_FAN_VALUE_MASK;
-			hw_sample = hw_value * ENE_SAMPLE_PERIOD_FAN;
+			hw_value &= ENE_FW_SMPL_BUF_FAN_MSK;
+			hw_sample = hw_value * ENE_FW_SAMPLE_PERIOD_FAN;
 
 		} else {
-			pulse = !(hw_value & ENE_SAMPLE_SPC_MASK);
-			hw_value &= ENE_SAMPLE_VALUE_MASK;
+			pulse = !(hw_value & ENE_FW_SAMPLE_SPACE);
+			hw_value &= ~ENE_FW_SAMPLE_SPACE;
 			hw_sample = hw_value * sample_period;
 
 			if (dev->rx_period_adjust) {
-				hw_sample *= (100 - dev->rx_period_adjust);
-				hw_sample /= 100;
+				hw_sample *= 100;
+				hw_sample /= (100 + dev->rx_period_adjust);
 			}
 		}
-		/* no more data */
-		if (!(hw_value))
-			break;
 
-		ene_dbg("RX: %d (%s)", hw_sample, pulse ? "pulse" : "space");
+		if (!dev->hw_extra_buffer && !hw_sample) {
+			dev->r_pointer = dev->w_pointer;
+			continue;
+		}
 
+		dbg("RX: %d (%s)", hw_sample, pulse ? "pulse" : "space");
 
-		ev.duration = hw_sample * 1000;
+		ev.duration = MS_TO_NS(hw_sample);
 		ev.pulse = pulse;
 		ir_raw_event_store_with_filter(dev->idev, &ev);
 	}
@@ -611,16 +791,14 @@ unlock:
 static void ene_setup_settings(struct ene_device *dev)
 {
 	dev->tx_period = 32;
-	dev->tx_duty_cycle = 25; /*%*/
-	dev->transmitter_mask = 3;
+	dev->tx_duty_cycle = 50; /*%*/
+	dev->transmitter_mask = 0x03;
 
-	/* Force learning mode if (input == 2), otherwise
-		let user set it with LIRC_SET_REC_CARRIER */
 	dev->learning_enabled =
-		(input == 2 && dev->hw_learning_and_tx_capable);
-
-	dev->rx_pointer = -1;
+		(learning_mode && dev->hw_learning_and_tx_capable);
 
+	/* Set reasonable default timeout */
+	dev->props->timeout = MS_TO_NS(15000);
 }
 
 /* outside interface: called on first open*/
@@ -630,8 +808,6 @@ static int ene_open(void *data)
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
-	dev->in_use = 1;
-	ene_setup_settings(dev);
 	ene_rx_enable(dev);
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 	return 0;
@@ -645,7 +821,6 @@ static void ene_close(void *data)
 	spin_lock_irqsave(&dev->hw_lock, flags);
 
 	ene_rx_disable(dev);
-	dev->in_use = 0;
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 }
 
@@ -654,11 +829,11 @@ static int ene_set_tx_mask(void *data, u32 tx_mask)
 {
 	struct ene_device *dev = (struct ene_device *)data;
 	unsigned long flags;
-	ene_dbg("TX: attempt to set transmitter mask %02x", tx_mask);
+	dbg("TX: attempt to set transmitter mask %02x", tx_mask);
 
 	/* invalid txmask */
-	if (!tx_mask || tx_mask & ~0x3) {
-		ene_dbg("TX: invalid mask");
+	if (!tx_mask || tx_mask & ~0x03) {
+		dbg("TX: invalid mask");
 		/* return count of transmitters */
 		return 2;
 	}
@@ -674,28 +849,42 @@ static int ene_set_tx_carrier(void *data, u32 carrier)
 {
 	struct ene_device *dev = (struct ene_device *)data;
 	unsigned long flags;
-	u32 period = 1000000 / carrier; /* (1 / freq) (* # usec in 1 sec) */
+	u32 period = 2000000 / carrier;
 
-	ene_dbg("TX: attempt to set tx carrier to %d kHz", carrier);
+	dbg("TX: attempt to set tx carrier to %d kHz", carrier);
 
-	if (period && (period > ENE_TX_PERIOD_MAX ||
-			period < ENE_TX_PERIOD_MIN)) {
+	if (period && (period > ENE_CIRMOD_PRD_MAX ||
+			period < ENE_CIRMOD_PRD_MIN)) {
 
-		ene_dbg("TX: out of range %d-%d carrier, "
-			"falling back to 32 kHz",
-			1000 / ENE_TX_PERIOD_MIN,
-			1000 / ENE_TX_PERIOD_MAX);
+		dbg("TX: out of range %d-%d kHz carrier",
+			2000 / ENE_CIRMOD_PRD_MIN,
+			2000 / ENE_CIRMOD_PRD_MAX);
 
-		period = 32; /* this is just a coincidence!!! */
+		return -1;
 	}
-	ene_dbg("TX: set carrier to %d kHz", carrier);
 
+	dbg("TX: set carrier to %d kHz", carrier);
 	spin_lock_irqsave(&dev->hw_lock, flags);
 	dev->tx_period = period;
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 	return 0;
 }
 
+/*outside interface : set tx duty cycle */
+static int ene_set_tx_duty_cycle(void *data, u32 duty_cycle)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	unsigned long flags;
+
+	dbg("TX: setting duty cycle to %d%%", duty_cycle);
+
+	BUG_ON(!duty_cycle || duty_cycle >= 100);
+
+	spin_lock_irqsave(&dev->hw_lock, flags);
+	dev->tx_duty_cycle = duty_cycle;
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	return 0;
+}
 
 /* outside interface: enable learning mode */
 static int ene_set_learning_mode(void *data, int enable)
@@ -707,31 +896,25 @@ static int ene_set_learning_mode(void *data, int enable)
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
 	dev->learning_enabled = enable;
-	ene_rx_set_inputs(dev);
+	ene_rx_disable(dev);
+	ene_rx_setup(dev);
+	ene_rx_enable(dev);
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 	return 0;
 }
 
-/* outside interface: set rec carrier */
-static int ene_set_rec_carrier(void *data, u32 min, u32 max)
-{
-	struct ene_device *dev = (struct ene_device *)data;
-	ene_set_learning_mode(dev,
-		max > ENE_NORMAL_RX_HI || min < ENE_NORMAL_RX_LOW);
-	return 0;
-}
-
 /* outside interface: enable or disable idle mode */
 static void ene_rx_set_idle(void *data, int idle)
 {
 	struct ene_device *dev = (struct ene_device *)data;
-	ene_dbg("%sabling idle mode", idle ? "en" : "dis");
 
-	ene_hw_write_reg_mask(dev, ENE_CIR_SAMPLE_PERIOD,
-		(enable_idle && idle) ? 0 : ENE_CIR_SAMPLE_OVERFLOW,
-			ENE_CIR_SAMPLE_OVERFLOW);
-}
+	if (!idle)
+		return;
 
+	dbg("RX: stopping the receiver");
+	ene_clear_reg_mask(dev, ENE_CIRCFG, ENE_CIRCFG_RX_EN);
+	ene_set_reg_mask(dev, ENE_CIRCFG, ENE_CIRCFG_RX_EN);
+}
 
 /* outside interface: transmit */
 static int ene_transmit(void *data, int *buf, u32 n)
@@ -747,11 +930,10 @@ static int ene_transmit(void *data, int *buf, u32 n)
 	dev->tx_sample = 0;
 	dev->tx_sample_pulse = 0;
 
-	ene_dbg("TX: %d samples", dev->tx_len);
+	dbg("TX: %d samples", dev->tx_len);
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
 
-	ene_tx_hw_set_transmiter_mask(dev);
 	ene_tx_prepare(dev);
 
 	/* Transmit first two samples */
@@ -761,16 +943,15 @@ static int ene_transmit(void *data, int *buf, u32 n)
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 
 	if (wait_for_completion_timeout(&dev->tx_complete, 2 * HZ) == 0) {
-		ene_dbg("TX: timeout");
+		dbg("TX: timeout");
 		spin_lock_irqsave(&dev->hw_lock, flags);
 		ene_tx_complete(dev);
 		spin_unlock_irqrestore(&dev->hw_lock, flags);
 	} else
-		ene_dbg("TX: done");
+		dbg("TX: done");
 	return n;
 }
 
-
 /* probe entry */
 static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 {
@@ -791,41 +972,47 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	error = -ENODEV;
 
 	if (!pnp_port_valid(pnp_dev, 0) ||
-	    pnp_port_len(pnp_dev, 0) < ENE_MAX_IO)
+	    pnp_port_len(pnp_dev, 0) < ENE_IO_SIZE)
 		goto error;
 
 	if (!pnp_irq_valid(pnp_dev, 0))
 		goto error;
 
-	dev->hw_io = pnp_port_start(pnp_dev, 0);
-	dev->irq = pnp_irq(pnp_dev, 0);
 	spin_lock_init(&dev->hw_lock);
 
 	/* claim the resources */
 	error = -EBUSY;
-	if (!request_region(dev->hw_io, ENE_MAX_IO, ENE_DRIVER_NAME))
+	dev->hw_io = pnp_port_start(pnp_dev, 0);
+	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
+		dev->hw_io = -1;
+		dev->irq = -1;
 		goto error;
+	}
 
+	dev->irq = pnp_irq(pnp_dev, 0);
 	if (request_irq(dev->irq, ene_isr,
-			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev))
+			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev)) {
+		dev->irq = -1;
 		goto error;
+	}
 
 	pnp_set_drvdata(pnp_dev, dev);
 	dev->pnp_dev = pnp_dev;
 
+	/* don't allow too short/long sample periods */
+	if (sample_period < 5 || sample_period > 0x7F)
+		sample_period = ENE_DEFAULT_SAMPLE_PERIOD;
+
 	/* detect hardware version and features */
 	error = ene_hw_detect(dev);
 	if (error)
 		goto error;
 
-	ene_setup_settings(dev);
-
 	if (!dev->hw_learning_and_tx_capable && txsim) {
-		dev->hw_learning_and_tx_capable = 1;
+		dev->hw_learning_and_tx_capable = true;
 		setup_timer(&dev->tx_sim_timer, ene_tx_irqsim,
 						(long unsigned int)dev);
-		ene_printk(KERN_WARNING,
-			"Simulation of TX activated\n");
+		ene_warn("Simulation of TX activated");
 	}
 
 	ir_props->driver_type = RC_DRIVER_IR_RAW;
@@ -833,72 +1020,45 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	ir_props->priv = dev;
 	ir_props->open = ene_open;
 	ir_props->close = ene_close;
-	ir_props->min_timeout = ENE_MINGAP * 1000;
-	ir_props->max_timeout = ENE_MAXGAP * 1000;
-	ir_props->timeout = ENE_MAXGAP * 1000;
-
-	if (dev->hw_revision == ENE_HW_B)
-		ir_props->s_idle = ene_rx_set_idle;
-
+	ir_props->s_idle = ene_rx_set_idle;
 
 	dev->props = ir_props;
 	dev->idev = input_dev;
 
-	/* don't allow too short/long sample periods */
-	if (sample_period < 5 || sample_period > 0x7F)
-		sample_period = -1;
-
-	/* choose default sample period */
-	if (sample_period == -1) {
-
-		sample_period = 50;
-
-		/* on revB, hardware idle mode eats first sample
-		  if we set too low sample period */
-		if (dev->hw_revision == ENE_HW_B && enable_idle)
-			sample_period = 75;
-	}
-
-	ir_props->rx_resolution = sample_period * 1000;
-
 	if (dev->hw_learning_and_tx_capable) {
-
 		ir_props->s_learning_mode = ene_set_learning_mode;
-
-		if (input == 0)
-			ir_props->s_rx_carrier_range = ene_set_rec_carrier;
-
 		init_completion(&dev->tx_complete);
 		ir_props->tx_ir = ene_transmit;
 		ir_props->s_tx_mask = ene_set_tx_mask;
 		ir_props->s_tx_carrier = ene_set_tx_carrier;
-		ir_props->tx_resolution = ENE_TX_SMPL_PERIOD * 1000;
+		ir_props->s_tx_duty_cycle = ene_set_tx_duty_cycle;
 		/* ir_props->s_carrier_report = ene_set_carrier_report; */
 	}
 
+	ene_setup_hw_buffer(dev);
+	ene_setup_settings(dev);
+	ene_rx_setup(dev);
 
-	device_set_wakeup_capable(&pnp_dev->dev, 1);
-	device_set_wakeup_enable(&pnp_dev->dev, 1);
+	device_set_wakeup_capable(&pnp_dev->dev, true);
+	device_set_wakeup_enable(&pnp_dev->dev, true);
 
 	if (dev->hw_learning_and_tx_capable)
 		input_dev->name = "ENE eHome Infrared Remote Transceiver";
 	else
 		input_dev->name = "ENE eHome Infrared Remote Receiver";
 
-
 	error = -ENODEV;
 	if (ir_input_register(input_dev, RC_MAP_RC6_MCE, ir_props,
 							ENE_DRIVER_NAME))
 		goto error;
 
-
-	ene_printk(KERN_NOTICE, "driver has been succesfully loaded\n");
+	ene_notice("driver has been succesfully loaded");
 	return 0;
 error:
-	if (dev->irq)
+	if (dev && dev->irq >= 0)
 		free_irq(dev->irq, dev);
-	if (dev->hw_io)
-		release_region(dev->hw_io, ENE_MAX_IO);
+	if (dev && dev->hw_io >= 0)
+		release_region(dev->hw_io, ENE_IO_SIZE);
 
 	input_free_device(input_dev);
 	kfree(ir_props);
@@ -914,10 +1074,11 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
 	ene_rx_disable(dev);
+	ene_restore_extra_buffer(dev);
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 
 	free_irq(dev->irq, dev);
-	release_region(dev->hw_io, ENE_MAX_IO);
+	release_region(dev->hw_io, ENE_IO_SIZE);
 	ir_input_unregister(dev->idev);
 	kfree(dev->props);
 	kfree(dev);
@@ -927,28 +1088,28 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 static void ene_enable_wake(struct ene_device *dev, int enable)
 {
 	enable = enable && device_may_wakeup(&dev->pnp_dev->dev);
-
-	ene_dbg("wake on IR %s", enable ? "enabled" : "disabled");
-
-	ene_hw_write_reg_mask(dev, ENE_FW1, enable ?
-		ENE_FW1_WAKE : 0, ENE_FW1_WAKE);
+	dbg("wake on IR %s", enable ? "enabled" : "disabled");
+	ene_set_clear_reg_mask(dev, ENE_FW1, ENE_FW1_WAKE, enable);
 }
 
 #ifdef CONFIG_PM
 static int ene_suspend(struct pnp_dev *pnp_dev, pm_message_t state)
 {
 	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
-	ene_enable_wake(dev, 1);
+	ene_enable_wake(dev, true);
+
+	/* TODO: add support for wake pattern */
 	return 0;
 }
 
 static int ene_resume(struct pnp_dev *pnp_dev)
 {
 	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
-	if (dev->in_use)
+	if (dev->rx_enabled) {
+		ene_rx_setup(dev);
 		ene_rx_enable(dev);
-
-	ene_enable_wake(dev, 0);
+	}
+	ene_enable_wake(dev, false);
 	return 0;
 }
 #endif
@@ -956,7 +1117,7 @@ static int ene_resume(struct pnp_dev *pnp_dev)
 static void ene_shutdown(struct pnp_dev *pnp_dev)
 {
 	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
-	ene_enable_wake(dev, 1);
+	ene_enable_wake(dev, true);
 }
 
 static const struct pnp_device_id ene_ids[] = {
@@ -994,18 +1155,11 @@ static void ene_exit(void)
 module_param(sample_period, int, S_IRUGO);
 MODULE_PARM_DESC(sample_period, "Hardware sample period (50 us default)");
 
-module_param(enable_idle, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(enable_idle,
-	"Enables turning off signal sampling after long inactivity time; "
-	"if disabled might help detecting input signal (default: enabled)"
-	" (KB3926B only)");
-
-module_param(input, bool, S_IRUGO);
-MODULE_PARM_DESC(input, "select which input to use "
-	"0 - auto, 1 - standard, 2 - wideband(KB3926C+)");
+module_param(learning_mode, bool, S_IRUGO);
+MODULE_PARM_DESC(learning_mode, "Enable learning mode by default");
 
 module_param(debug, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(debug, "Enable debug (debug=2 verbose debug output)");
+MODULE_PARM_DESC(debug, "Debug level");
 
 module_param(txsim, bool, S_IRUGO);
 MODULE_PARM_DESC(txsim,
@@ -1013,8 +1167,8 @@ MODULE_PARM_DESC(txsim,
 
 MODULE_DEVICE_TABLE(pnp, ene_ids);
 MODULE_DESCRIPTION
-	("Infrared input driver for KB3926B/KB3926C/KB3926D "
-	"(aka ENE0100/ENE0200/ENE0201) CIR port");
+	("Infrared input driver for KB3926B/C/D/E/F "
+	"(aka ENE0100/ENE0200/ENE0201/ENE0202) CIR port");
 
 MODULE_AUTHOR("Maxim Levitsky");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/IR/ene_ir.h b/drivers/media/IR/ene_ir.h
index 54c76af..39c707b 100644
--- a/drivers/media/IR/ene_ir.h
+++ b/drivers/media/IR/ene_ir.h
@@ -1,5 +1,5 @@
 /*
- * driver for ENE KB3926 B/C/D CIR (also known as ENE0XXX)
+ * driver for ENE KB3926 B/C/D/E/F CIR (also known as ENE0XXX)
  *
  * Copyright (C) 2010 Maxim Levitsky <maximlevitsky@gmail.com>
  *
@@ -26,43 +26,50 @@
 #define ENE_ADDR_HI		1	/* hi byte of register address */
 #define ENE_ADDR_LO		2	/* low byte of register address */
 #define ENE_IO			3	/* read/write window */
-#define ENE_MAX_IO		4
-
-/* 8 bytes of samples, divided in 2 halfs*/
-#define ENE_SAMPLE_BUFFER	0xF8F0	/* regular sample buffer */
-#define ENE_SAMPLE_SPC_MASK	0x80	/* sample is space */
-#define ENE_SAMPLE_VALUE_MASK	0x7F
-#define ENE_SAMPLE_OVERFLOW	0x7F
-#define ENE_SAMPLES_SIZE	4
-
-/* fan input sample buffer */
-#define ENE_SAMPLE_BUFFER_FAN	0xF8FB	/* this buffer holds high byte of */
-					/* each sample of normal buffer */
-#define ENE_FAN_SMPL_PULS_MSK	0x8000	/* this bit of combined sample */
-					/* if set, says that sample is pulse */
-#define ENE_FAN_VALUE_MASK	0x0FFF  /* mask for valid bits of the value */
-
-/* first firmware register */
-#define ENE_FW1			0xF8F8
+#define ENE_IO_SIZE		4
+
+/* 8 bytes of samples, divided in 2 packets*/
+#define ENE_FW_SAMPLE_BUFFER	0xF8F0	/* sample buffer */
+#define ENE_FW_SAMPLE_SPACE	0x80	/* sample is space */
+#define ENE_FW_PACKET_SIZE	4
+
+/* first firmware flag register */
+#define ENE_FW1			0xF8F8  /* flagr */
 #define	ENE_FW1_ENABLE		0x01	/* enable fw processing */
 #define ENE_FW1_TXIRQ		0x02	/* TX interrupt pending */
+#define ENE_FW1_HAS_EXTRA_BUF	0x04	/* fw uses extra buffer*/
+#define ENE_FW1_EXTRA_BUF_HND	0x08	/* extra buffer handshake bit*/
+#define ENE_FW1_LED_ON		0x10	/* turn on a led */
+
+#define ENE_FW1_WPATTERN	0x20	/* enable wake pattern */
 #define ENE_FW1_WAKE		0x40	/* enable wake from S3 */
 #define ENE_FW1_IRQ		0x80	/* enable interrupt */
 
-/* second firmware register */
-#define ENE_FW2			0xF8F9
-#define ENE_FW2_BUF_HIGH	0x01	/* which half of the buffer to read */
-#define ENE_FW2_IRQ_CLR		0x04	/* clear this on IRQ */
-#define ENE_FW2_GP40_AS_LEARN	0x08	/* normal input is used as */
-					/* learning input */
-#define ENE_FW2_FAN_AS_NRML_IN	0x40	/* fan is used as normal input */
+/* second firmware flag register */
+#define ENE_FW2			0xF8F9  /* flagw */
+#define ENE_FW2_BUF_WPTR	0x01	/* which half of the buffer to read */
+#define ENE_FW2_RXIRQ		0x04	/* RX IRQ pending*/
+#define ENE_FW2_GP0A		0x08	/* Use GPIO0A for demodulated input */
+#define ENE_FW2_EMMITER1_CONN	0x10	/* TX emmiter 1 connected */
+#define ENE_FW2_EMMITER2_CONN	0x20	/* TX emmiter 2 connected */
+
+#define ENE_FW2_FAN_INPUT	0x40	/* fan input used for demodulated data*/
 #define ENE_FW2_LEARNING	0x80	/* hardware supports learning and TX */
 
+/* firmware RX pointer for new style buffer */
+#define ENE_FW_RX_POINTER	0xF8FA
+
+/* high parts of samples for fan input (8 samples)*/
+#define ENE_FW_SMPL_BUF_FAN	0xF8FB
+#define ENE_FW_SMPL_BUF_FAN_PLS	0x8000	/* combined sample is pulse */
+#define ENE_FW_SMPL_BUF_FAN_MSK	0x0FFF  /* combined sample maximum value */
+#define ENE_FW_SAMPLE_PERIOD_FAN 61	/* fan input has fixed sample period */
+
 /* transmitter ports */
-#define ENE_TX_PORT2		0xFC01	/* this enables one or both */
-#define ENE_TX_PORT2_EN		0x20	/* TX ports */
-#define ENE_TX_PORT1		0xFC08
-#define ENE_TX_PORT1_EN		0x02
+#define ENE_GPIOFS1		0xFC01
+#define ENE_GPIOFS1_GPIO0D	0x20	/* enable tx output on GPIO0D */
+#define ENE_GPIOFS8		0xFC08
+#define ENE_GPIOFS8_GPIO41	0x02	/* enable tx output on GPIO40 */
 
 /* IRQ registers block (for revision B) */
 #define ENEB_IRQ		0xFD09	/* IRQ number */
@@ -70,97 +77,99 @@
 #define ENEB_IRQ_STATUS		0xFD80	/* irq status */
 #define ENEB_IRQ_STATUS_IR	0x20	/* IR irq */
 
-/* fan as input settings - only if learning capable */
+/* fan as input settings */
 #define ENE_FAN_AS_IN1		0xFE30  /* fan init reg 1 */
 #define ENE_FAN_AS_IN1_EN	0xCD
 #define ENE_FAN_AS_IN2		0xFE31  /* fan init reg 2 */
 #define ENE_FAN_AS_IN2_EN	0x03
-#define ENE_SAMPLE_PERIOD_FAN   61	/* fan input has fixed sample period */
 
 /* IRQ registers block (for revision C,D) */
-#define ENEC_IRQ		0xFE9B	/* new irq settings register */
-#define ENEC_IRQ_MASK		0x0F	/* irq number mask */
-#define ENEC_IRQ_UNK_EN		0x10	/* always enabled */
-#define ENEC_IRQ_STATUS		0x20	/* irq status and ACK */
-
-/* CIR block settings */
-#define ENE_CIR_CONF1		0xFEC0
-#define ENE_CIR_CONF1_TX_CLEAR	0x01	/* clear that on revC */
-					/* while transmitting */
-#define ENE_CIR_CONF1_RX_ON	0x07	/* normal receiver enabled */
-#define ENE_CIR_CONF1_LEARN1	0x08	/* enabled on learning mode */
-#define ENE_CIR_CONF1_TX_ON	0x30	/* enabled on transmit */
-#define ENE_CIR_CONF1_TX_CARR	0x80	/* send TX carrier or not */
-
-#define ENE_CIR_CONF2		0xFEC1	/* unknown setting = 0 */
-#define ENE_CIR_CONF2_LEARN2	0x10	/* set on enable learning */
-#define ENE_CIR_CONF2_GPIO40DIS	0x20	/* disable input via gpio40 */
-
-#define ENE_CIR_SAMPLE_PERIOD	0xFEC8	/* sample period in us */
-#define ENE_CIR_SAMPLE_OVERFLOW	0x80	/* interrupt on overflows if set */
-
-
-/* Two byte tx buffer */
-#define ENE_TX_INPUT1		0xFEC9
-#define ENE_TX_INPUT2		0xFECA
-#define ENE_TX_PULSE_MASK	0x80	/* Transmitted sample is pulse */
-#define ENE_TX_SMLP_MASK	0x7F
-#define ENE_TX_SMPL_PERIOD	50	/* transmit sample period - fixed */
+#define ENE_IRQ			0xFE9B	/* new irq settings register */
+#define ENE_IRQ_MASK		0x0F	/* irq number mask */
+#define ENE_IRQ_UNK_EN		0x10	/* always enabled */
+#define ENE_IRQ_STATUS		0x20	/* irq status and ACK */
+
+/* CIR Config register #1 */
+#define ENE_CIRCFG		0xFEC0
+#define ENE_CIRCFG_RX_EN	0x01	/* RX enable */
+#define ENE_CIRCFG_RX_IRQ	0x02	/* Enable hardware interrupt */
+#define ENE_CIRCFG_REV_POL	0x04	/* Input polarity reversed */
+#define ENE_CIRCFG_CARR_DEMOD	0x08	/* Enable carrier demodulator */
+
+#define ENE_CIRCFG_TX_EN	0x10	/* TX enable */
+#define ENE_CIRCFG_TX_IRQ	0x20	/* Send interrupt on TX done */
+#define ENE_CIRCFG_TX_POL_REV	0x40	/* TX polarity reversed */
+#define ENE_CIRCFG_TX_CARR	0x80	/* send TX carrier or not */
+
+/* CIR config register #2 */
+#define ENE_CIRCFG2		0xFEC1
+#define ENE_CIRCFG2_RLC		0x00
+#define ENE_CIRCFG2_RC5		0x01
+#define ENE_CIRCFG2_RC6		0x02
+#define ENE_CIRCFG2_NEC		0x03
+#define ENE_CIRCFG2_CARR_DETECT	0x10	/* Enable carrier detection */
+#define ENE_CIRCFG2_GPIO0A	0x20	/* Use GPIO0A instead of GPIO40 for input */
+#define ENE_CIRCFG2_FAST_SAMPL1	0x40	/* Fast leading pulse detection for RC6 */
+#define ENE_CIRCFG2_FAST_SAMPL2	0x80	/* Fast data detection for RC6 */
+
+/* Knobs for protocol decoding - will document when/if will use them */
+#define ENE_CIRPF		0xFEC2
+#define ENE_CIRHIGH		0xFEC3
+#define ENE_CIRBIT		0xFEC4
+#define ENE_CIRSTART		0xFEC5
+#define ENE_CIRSTART2		0xFEC6
+
+/* Actual register which contains RLC RX data - read by firmware */
+#define ENE_CIRDAT_IN		0xFEC7
+
+
+/* RLC configuration - sample period (1us resulution) + idle mode */
+#define ENE_CIRRLC_CFG		0xFEC8
+#define ENE_CIRRLC_CFG_OVERFLOW	0x80	/* interrupt on overflows if set */
+#define ENE_DEFAULT_SAMPLE_PERIOD 50
+
+/* Two byte RLC TX buffer */
+#define ENE_CIRRLC_OUT0		0xFEC9
+#define ENE_CIRRLC_OUT1		0xFECA
+#define ENE_CIRRLC_OUT_PULSE	0x80	/* Transmitted sample is pulse */
+#define ENE_CIRRLC_OUT_MASK	0x7F
+
+
+/* Carrier detect setting
+ * Low nibble  - number of carrier pulses to average
+ * High nibble - number of initial carrier pulses to discard
+ */
+#define ENE_CIRCAR_PULS		0xFECB
 
+/* detected RX carrier period (resolution: 500 ns) */
+#define ENE_CIRCAR_PRD		0xFECC
+#define ENE_CIRCAR_PRD_VALID	0x80	/* data valid content valid */
 
-/* Unknown TX setting - TX sample period ??? */
-#define ENE_TX_UNK1		0xFECB	/* set to 0x63 */
+/* detected RX carrier pulse width (resolution: 500 ns) */
+#define ENE_CIRCAR_HPRD		0xFECD
 
-/* Current received carrier period */
-#define ENE_RX_CARRIER		0xFECC	/* RX period (500 ns) */
-#define ENE_RX_CARRIER_VALID	0x80	/* Register content valid */
+/* TX period (resolution: 500 ns, minimum 2)*/
+#define ENE_CIRMOD_PRD		0xFECE
+#define ENE_CIRMOD_PRD_POL	0x80	/* TX carrier polarity*/
 
+#define ENE_CIRMOD_PRD_MAX	0x7F	/* 15.87 kHz */
+#define ENE_CIRMOD_PRD_MIN	0x02	/* 1 Mhz */
 
-/* TX period (1/carrier) */
-#define ENE_TX_PERIOD		0xFECE	/* TX period (500 ns) */
-#define ENE_TX_PERIOD_UNKBIT	0x80	/* This bit set on transmit*/
-#define ENE_TX_PERIOD_PULSE	0xFECF	/* TX pulse period (500 ns)*/
+/* TX pulse width (resolution: 500 ns)*/
+#define ENE_CIRMOD_HPRD		0xFECF
 
 /* Hardware versions */
-#define ENE_HW_VERSION		0xFF00	/* hardware revision */
+#define ENE_ECHV		0xFF00	/* hardware revision */
 #define ENE_PLLFRH		0xFF16
 #define ENE_PLLFRL		0xFF17
+#define ENE_DEFAULT_PLL_FREQ	1000
 
-#define ENE_HW_UNK		0xFF1D
-#define ENE_HW_UNK_CLR		0x04
-#define ENE_HW_VER_MAJOR	0xFF1E	/* chip version */
-#define ENE_HW_VER_MINOR	0xFF1F
-#define ENE_HW_VER_OLD		0xFD00
-
-/* Normal/Learning carrier ranges - only valid if we have learning input*/
-/* TODO: test */
-#define ENE_NORMAL_RX_LOW	34
-#define ENE_NORMAL_RX_HI	38
+#define ENE_ECSTS		0xFF1D
+#define ENE_ECSTS_RSRVD		0x04
 
-/* Tx carrier range */
-/* Hardware might be able to do more, but this range is enough for
-   all purposes */
-#define ENE_TX_PERIOD_MAX	32	/* corresponds to 29.4 kHz */
-#define ENE_TX_PERIOD_MIN	16	/* corrsponds to 62.5 kHz */
-
-
-
-/* Minimal and maximal gaps */
-
-/* Normal case:
-	Minimal gap is 0x7F * sample period
-	Maximum gap depends on hardware.
-	For KB3926B, it is unlimited, for newer models its around
-	250000, after which HW stops sending samples, and that is
-	not possible to change */
-
-/* Fan case:
-	Both minimal and maximal gaps are same, and equal to 0xFFF * 0x61
-	And there is nothing to change this setting
-*/
-
-#define ENE_MAXGAP		250000
-#define ENE_MINGAP		(127 * sample_period)
+#define ENE_ECVER_MAJOR		0xFF1E	/* chip version */
+#define ENE_ECVER_MINOR		0xFF1F
+#define ENE_HW_VER_OLD		0xFD00
 
 /******************************************************************************/
 
@@ -171,46 +180,60 @@
 
 #define  ENE_HW_B		1	/* 3926B */
 #define  ENE_HW_C		2	/* 3926C */
-#define  ENE_HW_D		3	/* 3926D */
+#define  ENE_HW_D		3	/* 3926D or later */
 
 #define ene_printk(level, text, ...) \
-	printk(level ENE_DRIVER_NAME ": " text, ## __VA_ARGS__)
+	printk(level ENE_DRIVER_NAME ": " text "\n", ## __VA_ARGS__)
 
-#define ene_dbg(text, ...) \
-	if (debug) \
-		printk(KERN_DEBUG \
-			ENE_DRIVER_NAME ": " text "\n" , ## __VA_ARGS__)
+#define ene_notice(text, ...) ene_printk(KERN_NOTICE, text, ## __VA_ARGS__)
+#define ene_warn(text, ...) ene_printk(KERN_WARNING, text, ## __VA_ARGS__)
 
-#define ene_dbg_verbose(text, ...) \
-	if (debug > 1) \
-		printk(KERN_DEBUG \
-			ENE_DRIVER_NAME ": " text "\n" , ## __VA_ARGS__)
 
+#define __dbg(level, format, ...) \
+	do { \
+		if (debug >= level) \
+			printk(KERN_DEBUG ENE_DRIVER_NAME \
+				": " format "\n", ## __VA_ARGS__); \
+	} while (0)
+
+
+#define dbg(format, ...)		__dbg(1, format, ## __VA_ARGS__)
+#define dbg_verbose(format, ...)	__dbg(2, format, ## __VA_ARGS__)
+#define dbg_regs(format, ...)		__dbg(3, format, ## __VA_ARGS__)
+
+#define MS_TO_NS(msec) ((msec) * 1000)
 
 struct ene_device {
 	struct pnp_dev *pnp_dev;
 	struct input_dev *idev;
 	struct ir_dev_props *props;
-	int in_use;
 
 	/* hw IO settings */
-	unsigned long hw_io;
+	long hw_io;
 	int irq;
 	spinlock_t hw_lock;
 
 	/* HW features */
 	int hw_revision;			/* hardware revision */
-	bool hw_learning_and_tx_capable;	/* learning capable */
-	bool hw_gpio40_learning;		/* gpio40 is learning */
-	bool hw_fan_as_normal_input;		/* fan input is used as */
-						/* regular input */
+	bool hw_use_gpio_0a;			/* gpio40 is demodulated input*/
+	bool hw_extra_buffer;			/* hardware has 'extra buffer' */
+	bool hw_fan_input;			/* fan input is IR data source */
+	bool hw_learning_and_tx_capable;	/* learning & tx capable */
+	int  pll_freq;
+	int buffer_len;
+
+	/* Extra RX buffer location */
+	int extra_buf1_address;
+	int extra_buf1_len;
+	int extra_buf2_address;
+	int extra_buf2_len;
+
 	/* HW state*/
-	int rx_pointer;				/* hw pointer to rx buffer */
+	int r_pointer;				/* pointer to next sample to read */
+	int w_pointer;				/* pointer to next sample hw will write */
 	bool rx_fan_input_inuse;		/* is fan input in use for rx*/
 	int tx_reg;				/* current reg used for TX */
 	u8  saved_conf1;			/* saved FEC0 reg */
-
-	/* TX sample handling */
 	unsigned int tx_sample;			/* current sample for TX */
 	bool tx_sample_pulse;			/* current sample is pulse */
 
@@ -232,4 +255,8 @@ struct ene_device {
 	bool learning_enabled;			/* learning input enabled */
 	bool carrier_detect_enabled;		/* carrier detect enabled */
 	int rx_period_adjust;
+	bool rx_enabled;
 };
+
+static int ene_irq_status(struct ene_device *dev);
+static void ene_read_hw_pointer(struct ene_device *dev);
-- 
1.7.0.4

