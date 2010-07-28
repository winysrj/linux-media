Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61086 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab0G1POu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 11:14:50 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 8/9] IR: Add ENE input driver.
Date: Wed, 28 Jul 2010 18:14:10 +0300
Message-Id: <1280330051-27732-9-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com>
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/Kconfig  |   11 +
 drivers/media/IR/Makefile |    1 +
 drivers/media/IR/ene_ir.c | 1019 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/IR/ene_ir.h |  228 ++++++++++
 4 files changed, 1259 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/IR/ene_ir.c
 create mode 100644 drivers/media/IR/ene_ir.h

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index 99ea9cd..8390d3c 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -105,8 +105,19 @@ config IR_MCEUSB
 	   To compile this driver as a module, choose M here: the
 	   module will be called mceusb.
 
+config IR_ENE
+	tristate "ENE eHome Receiver/Transciever (pnp id: ENE0100/ENE02xxx)"
+	depends on PNP
+	depends on IR_CORE
+	---help---
+	   Say Y here to enable support for integrated infrared receiver
+	   /transciever made by ENE.
 
+	   You can see if you have it by looking at lspnp output.
+	   Output should include ENE0100 ENE0200 or something similiar.
 
+	   To compile this driver as a module, choose M here: the
+	   module will be called ene_ir.
 
 
 endif #IR_CORE
diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index 2ae4f3a..3262a68 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
 # stand-alone IR receivers/transmitters
 obj-$(CONFIG_IR_IMON) += imon.o
 obj-$(CONFIG_IR_MCEUSB) += mceusb.o
+obj-$(CONFIG_IR_ENE) += ene_ir.o
diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
new file mode 100644
index 0000000..8b88dbd
--- /dev/null
+++ b/drivers/media/IR/ene_ir.c
@@ -0,0 +1,1019 @@
+/*
+ * driver for ENE KB3926 B/C/D CIR (pnp id: ENE0XXX)
+ *
+ * Copyright (C) 2010 Maxim Levitsky <maximlevitsky@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pnp.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <media/ir-core.h>
+#include <media/ir-common.h>
+#include "ene_ir.h"
+
+
+static int sample_period = -1;
+static int enable_idle = 1;
+static int error_adjustment = 4;
+static int input = 1;
+static int debug;
+static int txsim;
+
+static int ene_irq_status(struct ene_device *dev);
+
+/* read a hardware register */
+static u8 ene_hw_read_reg(struct ene_device *dev, u16 reg)
+{
+	u8 retval;
+	outb(reg >> 8, dev->hw_io + ENE_ADDR_HI);
+	outb(reg & 0xFF, dev->hw_io + ENE_ADDR_LO);
+	retval = inb(dev->hw_io + ENE_IO);
+
+	ene_dbg_verbose("reg %04x == %02x", reg, retval);
+	return retval;
+}
+
+/* write a hardware register */
+static void ene_hw_write_reg(struct ene_device *dev, u16 reg, u8 value)
+{
+	outb(reg >> 8, dev->hw_io + ENE_ADDR_HI);
+	outb(reg & 0xFF, dev->hw_io + ENE_ADDR_LO);
+	outb(value, dev->hw_io + ENE_IO);
+
+	ene_dbg_verbose("reg %04x <- %02x", reg, value);
+}
+
+/* change specific bits in hardware register */
+static void ene_hw_write_reg_mask(struct ene_device *dev,
+				  u16 reg, u8 value, u8 mask)
+{
+	u8 regvalue;
+
+	outb(reg >> 8, dev->hw_io + ENE_ADDR_HI);
+	outb(reg & 0xFF, dev->hw_io + ENE_ADDR_LO);
+
+	regvalue = inb(dev->hw_io + ENE_IO) & ~mask;
+	regvalue |= (value & mask);
+	outb(regvalue, dev->hw_io + ENE_IO);
+
+	ene_dbg_verbose("reg %04x <- %02x (mask=%02x)", reg, value, mask);
+}
+
+/* detect hardware features */
+static int ene_hw_detect(struct ene_device *dev)
+{
+	u8 chip_major, chip_minor;
+	u8 hw_revision, old_ver;
+	u8 tmp;
+	u8 fw_capabilities;
+
+	tmp = ene_hw_read_reg(dev, ENE_HW_UNK);
+	ene_hw_write_reg(dev, ENE_HW_UNK, tmp & ~ENE_HW_UNK_CLR);
+
+	chip_major = ene_hw_read_reg(dev, ENE_HW_VER_MAJOR);
+	chip_minor = ene_hw_read_reg(dev, ENE_HW_VER_MINOR);
+
+	ene_hw_write_reg(dev, ENE_HW_UNK, tmp);
+	hw_revision = ene_hw_read_reg(dev, ENE_HW_VERSION);
+	old_ver = ene_hw_read_reg(dev, ENE_HW_VER_OLD);
+
+	if (hw_revision == 0xFF) {
+
+		ene_printk(KERN_WARNING, "device seems to be disabled\n");
+		ene_printk(KERN_WARNING,
+			"send a mail to lirc-list@lists.sourceforge.net\n");
+		ene_printk(KERN_WARNING, "please attach output of acpidump\n");
+		return -ENODEV;
+	}
+
+	if (chip_major == 0x33) {
+		ene_printk(KERN_WARNING, "chips 0x33xx aren't supported\n");
+		return -ENODEV;
+	}
+
+	if (chip_major == 0x39 && chip_minor == 0x26 && hw_revision == 0xC0) {
+		dev->hw_revision = ENE_HW_C;
+	} else if (old_ver == 0x24 && hw_revision == 0xC0) {
+		dev->hw_revision = ENE_HW_B;
+		ene_printk(KERN_NOTICE, "KB3926B detected\n");
+	} else {
+		dev->hw_revision = ENE_HW_D;
+		ene_printk(KERN_WARNING,
+			"unknown ENE chip detected, assuming KB3926D\n");
+		ene_printk(KERN_WARNING,
+			"driver support might be not complete");
+
+	}
+
+	ene_printk(KERN_DEBUG,
+		"chip is 0x%02x%02x - kbver = 0x%02x, rev = 0x%02x\n",
+			chip_major, chip_minor, old_ver, hw_revision);
+
+	/* detect features hardware supports */
+	if (dev->hw_revision < ENE_HW_C)
+		return 0;
+
+	fw_capabilities = ene_hw_read_reg(dev, ENE_FW2);
+	ene_dbg("Firmware capabilities: %02x", fw_capabilities);
+
+	dev->hw_gpio40_learning = fw_capabilities & ENE_FW2_GP40_AS_LEARN;
+	dev->hw_learning_and_tx_capable = fw_capabilities & ENE_FW2_LEARNING;
+
+	dev->hw_fan_as_normal_input = dev->hw_learning_and_tx_capable &&
+	    (fw_capabilities & ENE_FW2_FAN_AS_NRML_IN);
+
+	ene_printk(KERN_NOTICE, "hardware features:\n");
+	ene_printk(KERN_NOTICE,
+		"learning and transmit %s, gpio40_learn %s, fan_in %s\n",
+	       dev->hw_learning_and_tx_capable ? "on" : "off",
+	       dev->hw_gpio40_learning ? "on" : "off",
+	       dev->hw_fan_as_normal_input ? "on" : "off");
+
+	if (dev->hw_learning_and_tx_capable) {
+		ene_printk(KERN_WARNING,
+		"Device supports transmitting, but that support is\n");
+		ene_printk(KERN_WARNING,
+		"lightly tested. Please test it and mail\n");
+		ene_printk(KERN_WARNING,
+		"lirc-list@lists.sourceforge.net\n");
+	}
+	return 0;
+}
+
+/* this enables/disables IR input via gpio40*/
+static void ene_enable_gpio40_receive(struct ene_device *dev, int enable)
+{
+	ene_hw_write_reg_mask(dev, ENE_CIR_CONF2, enable ?
+			      0 : ENE_CIR_CONF2_GPIO40DIS,
+			      ENE_CIR_CONF2_GPIO40DIS);
+}
+
+/* this enables/disables IR via standard input */
+static void ene_enable_normal_receive(struct ene_device *dev, int enable)
+{
+	ene_hw_write_reg(dev, ENE_CIR_CONF1, enable ? ENE_CIR_CONF1_RX_ON : 0);
+}
+
+/* this enables/disables IR input via unused fan tachtometer input */
+static void ene_enable_fan_receive(struct ene_device *dev, int enable)
+{
+	if (!enable)
+		ene_hw_write_reg(dev, ENE_FAN_AS_IN1, 0);
+	else {
+		ene_hw_write_reg(dev, ENE_FAN_AS_IN1, ENE_FAN_AS_IN1_EN);
+		ene_hw_write_reg(dev, ENE_FAN_AS_IN2, ENE_FAN_AS_IN2_EN);
+	}
+	dev->rx_fan_input_inuse = enable;
+}
+
+
+/* Sense current received carrier */
+static int ene_rx_sense_carrier(struct ene_device *dev)
+{
+	int period = ene_hw_read_reg(dev, ENE_RX_CARRIER);
+	int carrier;
+	ene_dbg("RX: hardware carrier period = %02x", period);
+
+	if (!(period & ENE_RX_CARRIER_VALID))
+		return 0;
+
+	period &= ~ENE_RX_CARRIER_VALID;
+
+	if (!period)
+		return 0;
+
+	carrier = 2000000 / period;
+	ene_dbg("RX: sensed carrier = %d Hz", carrier);
+	return carrier;
+}
+
+/* determine which input to use*/
+static void ene_rx_set_inputs(struct ene_device *dev)
+{
+	int learning_mode = dev->learning_enabled;
+
+	ene_dbg("RX: setup receiver, learning mode = %d", learning_mode);
+
+	ene_enable_normal_receive(dev, 1);
+
+	/* old hardware doesn't support learning mode for sure */
+	if (dev->hw_revision <= ENE_HW_B)
+		return;
+
+	/* receiver not learning capable, still set gpio40 correctly */
+	if (!dev->hw_learning_and_tx_capable) {
+		ene_enable_gpio40_receive(dev, !dev->hw_gpio40_learning);
+		return;
+	}
+
+	/* enable learning mode */
+	if (learning_mode) {
+		ene_enable_gpio40_receive(dev, dev->hw_gpio40_learning);
+
+		/* fan input is not used for learning */
+		if (dev->hw_fan_as_normal_input)
+			ene_enable_fan_receive(dev, 0);
+
+	/* disable learning mode */
+	} else {
+		if (dev->hw_fan_as_normal_input) {
+			ene_enable_fan_receive(dev, 1);
+			ene_enable_normal_receive(dev, 0);
+		} else
+			ene_enable_gpio40_receive(dev,
+					!dev->hw_gpio40_learning);
+	}
+
+	/* set few additional settings for this mode */
+	ene_hw_write_reg_mask(dev, ENE_CIR_CONF1, learning_mode ?
+			      ENE_CIR_CONF1_LEARN1 : 0, ENE_CIR_CONF1_LEARN1);
+
+	ene_hw_write_reg_mask(dev, ENE_CIR_CONF2, learning_mode ?
+			      ENE_CIR_CONF2_LEARN2 : 0, ENE_CIR_CONF2_LEARN2);
+
+	if (dev->rx_fan_input_inuse) {
+		dev->props->rx_resolution = ENE_SAMPLE_PERIOD_FAN * 1000;
+
+		dev->props->timeout =
+			ENE_FAN_VALUE_MASK * ENE_SAMPLE_PERIOD_FAN * 1000;
+	} else {
+		dev->props->rx_resolution = sample_period * 1000;
+		dev->props->timeout = ENE_MAXGAP * 1000;
+	}
+}
+
+/* Enable the device for receive */
+static void ene_rx_enable(struct ene_device *dev)
+{
+	u8 reg_value;
+
+	if (dev->hw_revision < ENE_HW_C) {
+		ene_hw_write_reg(dev, ENEB_IRQ, dev->irq << 1);
+		ene_hw_write_reg(dev, ENEB_IRQ_UNK1, 0x01);
+	} else {
+		reg_value = ene_hw_read_reg(dev, ENEC_IRQ) & 0xF0;
+		reg_value |= ENEC_IRQ_UNK_EN;
+		reg_value &= ~ENEC_IRQ_STATUS;
+		reg_value |= (dev->irq & ENEC_IRQ_MASK);
+		ene_hw_write_reg(dev, ENEC_IRQ, reg_value);
+		ene_hw_write_reg(dev, ENE_TX_UNK1, 0x63);
+	}
+
+	ene_hw_write_reg(dev, ENE_CIR_CONF2, 0x00);
+	ene_rx_set_inputs(dev);
+
+	/* set sampling period */
+	ene_hw_write_reg(dev, ENE_CIR_SAMPLE_PERIOD, sample_period);
+
+	/* ack any pending irqs - just in case */
+	ene_irq_status(dev);
+
+	/* enable firmware bits */
+	ene_hw_write_reg_mask(dev, ENE_FW1,
+			      ENE_FW1_ENABLE | ENE_FW1_IRQ,
+			      ENE_FW1_ENABLE | ENE_FW1_IRQ);
+
+	/* enter idle mode */
+	ir_raw_event_set_idle(dev->idev, 1);
+	ir_raw_event_reset(dev->idev);
+
+}
+
+/* Disable the device receiver */
+static void ene_rx_disable(struct ene_device *dev)
+{
+	/* disable inputs */
+	ene_enable_normal_receive(dev, 0);
+
+	if (dev->hw_fan_as_normal_input)
+		ene_enable_fan_receive(dev, 0);
+
+	/* disable hardware IRQ and firmware flag */
+	ene_hw_write_reg_mask(dev, ENE_FW1, 0, ENE_FW1_ENABLE | ENE_FW1_IRQ);
+
+	ir_raw_event_set_idle(dev->idev, 1);
+	ir_raw_event_reset(dev->idev);
+}
+
+
+/* prepare transmission */
+static void ene_tx_prepare(struct ene_device *dev)
+{
+	u8 conf1;
+
+	conf1 = ene_hw_read_reg(dev, ENE_CIR_CONF1);
+	dev->saved_conf1 = conf1;
+
+	if (dev->hw_revision == ENE_HW_C)
+		conf1 &= ~ENE_CIR_CONF1_TX_CLEAR;
+
+	/* Enable TX engine */
+	conf1 |= ENE_CIR_CONF1_TX_ON;
+
+	/* Set carrier */
+	if (dev->tx_period) {
+
+		/* NOTE: duty cycle handling is just a guess, it might
+			not be aviable. Default values were tested */
+		int tx_period_in500ns = dev->tx_period * 2;
+
+		int tx_pulse_width_in_500ns =
+			tx_period_in500ns / (100 / dev->tx_duty_cycle);
+
+		if (!tx_pulse_width_in_500ns)
+			tx_pulse_width_in_500ns = 1;
+
+		ene_dbg("TX: pulse distance = %d * 500 ns", tx_period_in500ns);
+		ene_dbg("TX: pulse width = %d * 500 ns",
+						tx_pulse_width_in_500ns);
+
+		ene_hw_write_reg(dev, ENE_TX_PERIOD, ENE_TX_PERIOD_UNKBIT |
+					tx_period_in500ns);
+
+		ene_hw_write_reg(dev, ENE_TX_PERIOD_PULSE,
+					tx_pulse_width_in_500ns);
+
+		conf1 |= ENE_CIR_CONF1_TX_CARR;
+	} else
+		conf1 &= ~ENE_CIR_CONF1_TX_CARR;
+
+	ene_hw_write_reg(dev, ENE_CIR_CONF1, conf1);
+
+}
+
+/* end transmission */
+static void ene_tx_complete(struct ene_device *dev)
+{
+	ene_hw_write_reg(dev, ENE_CIR_CONF1, dev->saved_conf1);
+	dev->tx_buffer = NULL;
+}
+
+/* set transmit mask */
+static void ene_tx_hw_set_transmiter_mask(struct ene_device *dev)
+{
+	u8 txport1 = ene_hw_read_reg(dev, ENE_TX_PORT1) & ~ENE_TX_PORT1_EN;
+	u8 txport2 = ene_hw_read_reg(dev, ENE_TX_PORT2) & ~ENE_TX_PORT2_EN;
+
+	if (dev->transmitter_mask & 0x01)
+		txport1 |= ENE_TX_PORT1_EN;
+
+	if (dev->transmitter_mask & 0x02)
+		txport2 |= ENE_TX_PORT2_EN;
+
+	ene_hw_write_reg(dev, ENE_TX_PORT1, txport1);
+	ene_hw_write_reg(dev, ENE_TX_PORT2, txport2);
+}
+
+/* TX one sample - must be called with dev->hw_lock*/
+static void ene_tx_sample(struct ene_device *dev)
+{
+	u8 raw_tx;
+	u32 sample;
+
+	if (!dev->tx_buffer) {
+		ene_dbg("TX: attempt to transmit NULL buffer");
+		return;
+	}
+
+	/* Grab next TX sample */
+	if (!dev->tx_sample) {
+again:
+		if (dev->tx_pos == dev->tx_len + 1) {
+			if (!dev->tx_done) {
+				ene_dbg("TX: no more data to send");
+				dev->tx_done = 1;
+				goto exit;
+			} else {
+				ene_dbg("TX: last sample sent by hardware");
+				ene_tx_complete(dev);
+				complete(&dev->tx_complete);
+				return;
+			}
+		}
+
+		sample = dev->tx_buffer[dev->tx_pos++];
+		dev->tx_sample_pulse = !dev->tx_sample_pulse;
+
+		ene_dbg("TX: sample %8d (%s)", sample, dev->tx_sample_pulse ?
+							"pulse" : "space");
+
+		dev->tx_sample = DIV_ROUND_CLOSEST(sample, ENE_TX_SMPL_PERIOD);
+
+		/* guard against too short samples */
+		if (!dev->tx_sample)
+			goto again;
+	}
+
+	raw_tx = min(dev->tx_sample , (unsigned int)ENE_TX_SMLP_MASK);
+	dev->tx_sample -= raw_tx;
+
+	if (dev->tx_sample_pulse)
+		raw_tx |= ENE_TX_PULSE_MASK;
+
+	ene_hw_write_reg(dev, ENE_TX_INPUT1 + dev->tx_reg, raw_tx);
+	dev->tx_reg = !dev->tx_reg;
+exit:
+	/* simulate TX done interrupt */
+	if (txsim)
+		mod_timer(&dev->tx_sim_timer, jiffies + HZ / 500);
+}
+
+/* timer to simulate tx done interrupt */
+static void ene_tx_irqsim(unsigned long data)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->hw_lock, flags);
+	ene_tx_sample(dev);
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+}
+
+
+/* read irq status and ack it */
+static int ene_irq_status(struct ene_device *dev)
+{
+	u8 irq_status;
+	u8 fw_flags1, fw_flags2;
+	int cur_rx_pointer;
+	int retval = 0;
+
+	fw_flags2 = ene_hw_read_reg(dev, ENE_FW2);
+	cur_rx_pointer = !!(fw_flags2 & ENE_FW2_BUF_HIGH);
+
+	if (dev->hw_revision < ENE_HW_C) {
+		irq_status = ene_hw_read_reg(dev, ENEB_IRQ_STATUS);
+
+		if (!(irq_status & ENEB_IRQ_STATUS_IR))
+			return 0;
+
+		ene_hw_write_reg(dev, ENEB_IRQ_STATUS,
+				 irq_status & ~ENEB_IRQ_STATUS_IR);
+		dev->rx_pointer = cur_rx_pointer;
+		return ENE_IRQ_RX;
+	}
+
+	irq_status = ene_hw_read_reg(dev, ENEC_IRQ);
+
+	if (!(irq_status & ENEC_IRQ_STATUS))
+		return 0;
+
+	/* original driver does that twice - a workaround ? */
+	ene_hw_write_reg(dev, ENEC_IRQ, irq_status & ~ENEC_IRQ_STATUS);
+	ene_hw_write_reg(dev, ENEC_IRQ, irq_status & ~ENEC_IRQ_STATUS);
+
+	/* clear unknown flag in F8F9 */
+	if (fw_flags2 & ENE_FW2_IRQ_CLR)
+		ene_hw_write_reg(dev, ENE_FW2, fw_flags2 & ~ENE_FW2_IRQ_CLR);
+
+	/* check if this is a TX interrupt */
+	fw_flags1 = ene_hw_read_reg(dev, ENE_FW1);
+	if (fw_flags1 & ENE_FW1_TXIRQ) {
+		ene_hw_write_reg(dev, ENE_FW1, fw_flags1 & ~ENE_FW1_TXIRQ);
+		retval |= ENE_IRQ_TX;
+	}
+
+	/* Check if this is RX interrupt */
+	if (dev->rx_pointer != cur_rx_pointer) {
+		retval |= ENE_IRQ_RX;
+		dev->rx_pointer = cur_rx_pointer;
+
+	} else if (!(retval & ENE_IRQ_TX)) {
+		ene_dbg("RX: interrupt without change in RX pointer(%d)",
+			dev->rx_pointer);
+		retval |= ENE_IRQ_RX;
+	}
+
+	if ((retval & ENE_IRQ_RX) && (retval & ENE_IRQ_TX))
+		ene_dbg("both RX and TX interrupt at same time");
+
+	return retval;
+}
+
+/* interrupt handler */
+static irqreturn_t ene_isr(int irq, void *data)
+{
+	u16 hw_value;
+	int i, hw_sample;
+	int pulse;
+	int irq_status;
+	unsigned long flags;
+	int carrier = 0;
+	irqreturn_t retval = IRQ_NONE;
+	struct ene_device *dev = (struct ene_device *)data;
+	struct ir_raw_event ev;
+
+
+	spin_lock_irqsave(&dev->hw_lock, flags);
+	irq_status = ene_irq_status(dev);
+
+	if (!irq_status)
+		goto unlock;
+
+	retval = IRQ_HANDLED;
+
+	if (irq_status & ENE_IRQ_TX) {
+
+		if (!dev->hw_learning_and_tx_capable) {
+			ene_dbg("TX interrupt on unsupported device!");
+			goto unlock;
+		}
+		ene_tx_sample(dev);
+	}
+
+	if (!(irq_status & ENE_IRQ_RX))
+		goto unlock;
+
+
+	if (dev->learning_enabled)
+		carrier = ene_rx_sense_carrier(dev);
+#if 0
+	/* TODO */
+	if (dev->learning_enabled && carrier)
+		ir_raw_event_report_frequency(dev->idev, carrier);
+#endif
+
+	for (i = 0; i < ENE_SAMPLES_SIZE; i++) {
+		hw_value = ene_hw_read_reg(dev,
+				ENE_SAMPLE_BUFFER + dev->rx_pointer * 4 + i);
+
+		if (dev->rx_fan_input_inuse) {
+			/* read high part of the sample */
+			hw_value |= ene_hw_read_reg(dev,
+			    ENE_SAMPLE_BUFFER_FAN +
+					dev->rx_pointer * 4 + i) << 8;
+			pulse = hw_value & ENE_FAN_SMPL_PULS_MSK;
+
+			/* clear space bit, and other unused bits */
+			hw_value &= ENE_FAN_VALUE_MASK;
+			hw_sample = hw_value * ENE_SAMPLE_PERIOD_FAN;
+
+		} else {
+			pulse = !(hw_value & ENE_SAMPLE_SPC_MASK);
+			hw_value &= ENE_SAMPLE_VALUE_MASK;
+			hw_sample = hw_value * sample_period;
+
+			if (error_adjustment && error_adjustment < 100) {
+				hw_sample *= (100 - error_adjustment);
+				hw_sample /= 100;
+			}
+		}
+		/* no more data */
+		if (!(hw_value))
+			break;
+
+		ene_dbg("RX: %d (%s)", hw_sample, pulse ? "pulse" : "space");
+
+
+		ev.duration = hw_sample * 1000;
+		ev.pulse = pulse;
+		ir_raw_event_store_with_filter(dev->idev, &ev);
+	}
+
+	ir_raw_event_handle(dev->idev);
+unlock:
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	return retval;
+}
+
+/* Initialize default settings */
+static void ene_setup_settings(struct ene_device *dev)
+{
+	dev->tx_period = 32;
+	dev->tx_duty_cycle = 25; /*%*/
+	dev->transmitter_mask = 3;
+
+	/* Force learning mode if (input == 2), otherwise
+		let user set it with LIRC_SET_REC_CARRIER */
+	dev->learning_enabled =
+		(input == 2 && dev->hw_learning_and_tx_capable);
+
+	dev->rx_pointer = -1;
+
+}
+
+/* outside interface: called on first open*/
+static int ene_open(void *data)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->hw_lock, flags);
+	dev->in_use = 1;
+	ene_setup_settings(dev);
+	ene_rx_enable(dev);
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	return 0;
+}
+
+/* outside interface: called on device close*/
+static void ene_close(void *data)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	unsigned long flags;
+	spin_lock_irqsave(&dev->hw_lock, flags);
+
+	ene_rx_disable(dev);
+	dev->in_use = 0;
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+}
+
+/* outside interface: set transmitter mask */
+static int ene_set_tx_mask(void *data, u32 tx_mask)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	unsigned long flags;
+	ene_dbg("TX: attempt to set transmitter mask %02x", tx_mask);
+
+	/* invalid txmask */
+	if (!tx_mask || tx_mask & ~0x3) {
+		ene_dbg("TX: invalid mask");
+		/* return count of transmitters */
+		return 2;
+	}
+
+	spin_lock_irqsave(&dev->hw_lock, flags);
+	dev->transmitter_mask = tx_mask;
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	return 0;
+}
+
+/* outside interface : set tx carrier */
+static int ene_set_tx_carrier(void *data, u32 carrier)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	unsigned long flags;
+	u32 period = 1000000 / carrier; /* (1 / freq) (* # usec in 1 sec) */
+
+	ene_dbg("TX: attempt to set tx carrier to %d kHz", carrier);
+
+	if (period && (period > ENE_TX_PERIOD_MAX ||
+			period < ENE_TX_PERIOD_MIN)) {
+
+		ene_dbg("TX: out of range %d-%d carrier, "
+			"falling back to 32 kHz",
+			1000 / ENE_TX_PERIOD_MIN,
+			1000 / ENE_TX_PERIOD_MAX);
+
+		period = 32; /* this is just a coincidence!!! */
+	}
+	ene_dbg("TX: set carrier to %d kHz", carrier);
+
+	spin_lock_irqsave(&dev->hw_lock, flags);
+	dev->tx_period = period;
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	return 0;
+}
+
+
+/* outside interface: enable learning mode */
+static int ene_set_learning_mode(void *data, int enable)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	unsigned long flags;
+	if (enable == dev->learning_enabled)
+		return 0;
+
+	spin_lock_irqsave(&dev->hw_lock, flags);
+	dev->learning_enabled = enable;
+	ene_rx_set_inputs(dev);
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	return 0;
+}
+
+/* outside interface: set rec carrier */
+static int ene_set_rec_carrier(void *data, u32 min, u32 max)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	ene_set_learning_mode(dev,
+		max > ENE_NORMAL_RX_HI || min < ENE_NORMAL_RX_LOW);
+	return 0;
+}
+
+/* outside interface: enable or disable idle mode */
+static void ene_rx_set_idle(void *data, int idle)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	ene_dbg("%sabling idle mode", idle ? "en" : "dis");
+
+	ene_hw_write_reg_mask(dev, ENE_CIR_SAMPLE_PERIOD,
+		(enable_idle && idle) ? 0 : ENE_CIR_SAMPLE_OVERFLOW,
+			ENE_CIR_SAMPLE_OVERFLOW);
+}
+
+
+/* outside interface: transmit */
+static int ene_transmit(void *data, int *buf, u32 n)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	unsigned long flags;
+
+	dev->tx_buffer = buf;
+	dev->tx_len = n / sizeof(int);
+	dev->tx_pos = 0;
+	dev->tx_reg = 0;
+	dev->tx_done = 0;
+	dev->tx_sample = 0;
+	dev->tx_sample_pulse = 0;
+
+	ene_dbg("TX: %d samples", dev->tx_len);
+
+	spin_lock_irqsave(&dev->hw_lock, flags);
+
+	ene_tx_hw_set_transmiter_mask(dev);
+	ene_tx_prepare(dev);
+
+	/* Transmit first two samples */
+	ene_tx_sample(dev);
+	ene_tx_sample(dev);
+
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+
+	if (wait_for_completion_timeout(&dev->tx_complete, 2 * HZ) == 0) {
+		ene_dbg("TX: timeout");
+		spin_lock_irqsave(&dev->hw_lock, flags);
+		ene_tx_complete(dev);
+		spin_unlock_irqrestore(&dev->hw_lock, flags);
+	} else
+		ene_dbg("TX: done");
+	return n;
+}
+
+
+/* probe entry */
+static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
+{
+	int error = -ENOMEM;
+	struct ir_dev_props *ir_props;
+	struct input_dev *input_dev;
+	struct ene_device *dev;
+
+	/* allocate memory */
+	input_dev = input_allocate_device();
+	ir_props = kzalloc(sizeof(struct ir_dev_props), GFP_KERNEL);
+	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
+
+	if (!input_dev || !ir_props || !dev)
+		goto error;
+
+	/* validate resources */
+	error = -ENODEV;
+
+	if (!pnp_port_valid(pnp_dev, 0) ||
+	    pnp_port_len(pnp_dev, 0) < ENE_MAX_IO)
+		goto error;
+
+	if (!pnp_irq_valid(pnp_dev, 0))
+		goto error;
+
+	dev->hw_io = pnp_port_start(pnp_dev, 0);
+	dev->irq = pnp_irq(pnp_dev, 0);
+	spin_lock_init(&dev->hw_lock);
+
+	/* claim the resources */
+	error = -EBUSY;
+	if (!request_region(dev->hw_io, ENE_MAX_IO, ENE_DRIVER_NAME))
+		goto error;
+
+	if (request_irq(dev->irq, ene_isr,
+			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev))
+		goto error;
+
+	pnp_set_drvdata(pnp_dev, dev);
+	dev->pnp_dev = pnp_dev;
+
+	/* detect hardware version and features */
+	error = ene_hw_detect(dev);
+	if (error)
+		goto error;
+
+	ene_setup_settings(dev);
+
+	if (!dev->hw_learning_and_tx_capable && txsim) {
+		dev->hw_learning_and_tx_capable = 1;
+		setup_timer(&dev->tx_sim_timer, ene_tx_irqsim,
+						(long unsigned int)dev);
+		ene_printk(KERN_WARNING,
+			"Simulation of TX activated\n");
+	}
+
+	ir_props->driver_type = RC_DRIVER_IR_RAW;
+	ir_props->allowed_protos = IR_TYPE_ALL;
+	ir_props->priv = dev;
+	ir_props->open = ene_open;
+	ir_props->close = ene_close;
+	ir_props->min_timeout = ENE_MINGAP * 1000;
+	ir_props->max_timeout = ENE_MAXGAP * 1000;
+	ir_props->timeout = ENE_MAXGAP * 1000;
+
+	if (dev->hw_revision == ENE_HW_B)
+		ir_props->s_idle = ene_rx_set_idle;
+
+
+	dev->props = ir_props;
+	dev->idev = input_dev;
+
+	/* don't allow too short/long sample periods */
+	if (sample_period < 5 || sample_period > 0x7F)
+		sample_period = -1;
+
+	/* choose default sample period */
+	if (sample_period == -1) {
+
+		sample_period = 50;
+
+		/* on revB, hardware idle mode eats first sample
+		  if we set too low sample period */
+		if (dev->hw_revision == ENE_HW_B && enable_idle)
+			sample_period = 75;
+	}
+
+	ir_props->rx_resolution = sample_period * 1000;
+
+	if (dev->hw_learning_and_tx_capable) {
+
+		ir_props->s_learning_mode = ene_set_learning_mode;
+
+		if (input == 0)
+			ir_props->s_rx_carrier_range = ene_set_rec_carrier;
+
+		init_completion(&dev->tx_complete);
+		ir_props->tx_ir = ene_transmit;
+		ir_props->s_tx_mask = ene_set_tx_mask;
+		ir_props->s_tx_carrier = ene_set_tx_carrier;
+		ir_props->tx_resolution = ENE_TX_SMPL_PERIOD * 1000;
+	}
+
+
+	device_set_wakeup_capable(&pnp_dev->dev, 1);
+	device_set_wakeup_enable(&pnp_dev->dev, 1);
+
+	if (dev->hw_learning_and_tx_capable)
+		input_dev->name = "ENE eHome Infrared Remote Transceiver";
+	else
+		input_dev->name = "ENE eHome Infrared Remote Receiver";
+
+
+	error = -ENODEV;
+	if (ir_input_register(input_dev, RC_MAP_RC6_MCE, ir_props,
+							ENE_DRIVER_NAME))
+		goto error;
+
+
+	ene_printk(KERN_NOTICE, "driver has been succesfully loaded\n");
+	return 0;
+error:
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+	if (dev->hw_io)
+		release_region(dev->hw_io, ENE_MAX_IO);
+
+	input_free_device(input_dev);
+	kfree(ir_props);
+	kfree(dev);
+	return error;
+}
+
+/* main unload function */
+static void ene_remove(struct pnp_dev *pnp_dev)
+{
+	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->hw_lock, flags);
+	ene_rx_disable(dev);
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+
+	free_irq(dev->irq, dev);
+	release_region(dev->hw_io, ENE_MAX_IO);
+	ir_input_unregister(dev->idev);
+	kfree(dev->props);
+	kfree(dev);
+}
+
+/* enable wake on IR (wakes on specific button on original remote) */
+static void ene_enable_wake(struct ene_device *dev, int enable)
+{
+	enable = enable && device_may_wakeup(&dev->pnp_dev->dev);
+
+	ene_dbg("wake on IR %s", enable ? "enabled" : "disabled");
+
+	ene_hw_write_reg_mask(dev, ENE_FW1, enable ?
+		ENE_FW1_WAKE : 0, ENE_FW1_WAKE);
+}
+
+#ifdef CONFIG_PM
+static int ene_suspend(struct pnp_dev *pnp_dev, pm_message_t state)
+{
+	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
+	ene_enable_wake(dev, 1);
+	return 0;
+}
+
+static int ene_resume(struct pnp_dev *pnp_dev)
+{
+	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
+	if (dev->in_use)
+		ene_rx_enable(dev);
+
+	ene_enable_wake(dev, 0);
+	return 0;
+}
+#endif
+
+static void ene_shutdown(struct pnp_dev *pnp_dev)
+{
+	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
+	ene_enable_wake(dev, 1);
+}
+
+static const struct pnp_device_id ene_ids[] = {
+	{.id = "ENE0100",},
+	{.id = "ENE0200",},
+	{.id = "ENE0201",},
+	{},
+};
+
+static struct pnp_driver ene_driver = {
+	.name = ENE_DRIVER_NAME,
+	.id_table = ene_ids,
+	.flags = PNP_DRIVER_RES_DO_NOT_CHANGE,
+
+	.probe = ene_probe,
+	.remove = __devexit_p(ene_remove),
+#ifdef CONFIG_PM
+	.suspend = ene_suspend,
+	.resume = ene_resume,
+#endif
+	.shutdown = ene_shutdown,
+};
+
+static int __init ene_init(void)
+{
+	return pnp_register_driver(&ene_driver);
+}
+
+static void ene_exit(void)
+{
+	pnp_unregister_driver(&ene_driver);
+}
+
+module_param(sample_period, int, S_IRUGO);
+MODULE_PARM_DESC(sample_period, "Hardware sample period (50 us default)");
+
+module_param(enable_idle, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(enable_idle,
+	"Enables turning off signal sampling after long inactivity time; "
+	"if disabled might help detecting input signal (default: enabled)"
+	" (KB3926B only)");
+
+module_param(input, bool, S_IRUGO);
+MODULE_PARM_DESC(input, "select which input to use "
+	"0 - auto, 1 - standard, 2 - wideband(KB3926C+)");
+
+module_param(debug, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "Enable debug (debug=2 verbose debug output)");
+
+module_param(txsim, bool, S_IRUGO);
+MODULE_PARM_DESC(txsim,
+	"Simulate TX features on unsupported hardware (dangerous)");
+
+
+module_param(error_adjustment, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(error_adjustment,
+	"Correct incoming samples by error_adjustment percent\n"
+	"A default value of 4% seems to help with signal decoding");
+
+
+
+
+MODULE_DEVICE_TABLE(pnp, ene_ids);
+MODULE_DESCRIPTION
+	("Infrared input driver for KB3926B/KB3926C/KB3926D "
+	"(aka ENE0100/ENE0200/ENE0201) CIR port");
+
+MODULE_AUTHOR("Maxim Levitsky");
+MODULE_LICENSE("GPL");
+
+module_init(ene_init);
+module_exit(ene_exit);
diff --git a/drivers/media/IR/ene_ir.h b/drivers/media/IR/ene_ir.h
new file mode 100644
index 0000000..63e5138
--- /dev/null
+++ b/drivers/media/IR/ene_ir.h
@@ -0,0 +1,228 @@
+/*
+ * driver for ENE KB3926 B/C/D CIR (also known as ENE0XXX)
+ *
+ * Copyright (C) 2010 Maxim Levitsky <maximlevitsky@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+ */
+#include <linux/spinlock.h>
+
+
+/* hardware address */
+#define ENE_STATUS		0	/* hardware status - unused */
+#define ENE_ADDR_HI		1	/* hi byte of register address */
+#define ENE_ADDR_LO		2	/* low byte of register address */
+#define ENE_IO			3	/* read/write window */
+#define ENE_MAX_IO		4
+
+/* 8 bytes of samples, divided in 2 halfs*/
+#define ENE_SAMPLE_BUFFER	0xF8F0	/* regular sample buffer */
+#define ENE_SAMPLE_SPC_MASK	0x80	/* sample is space */
+#define ENE_SAMPLE_VALUE_MASK	0x7F
+#define ENE_SAMPLE_OVERFLOW	0x7F
+#define ENE_SAMPLES_SIZE	4
+
+/* fan input sample buffer */
+#define ENE_SAMPLE_BUFFER_FAN	0xF8FB	/* this buffer holds high byte of */
+					/* each sample of normal buffer */
+#define ENE_FAN_SMPL_PULS_MSK	0x8000	/* this bit of combined sample */
+					/* if set, says that sample is pulse */
+#define ENE_FAN_VALUE_MASK	0x0FFF  /* mask for valid bits of the value */
+
+/* first firmware register */
+#define ENE_FW1			0xF8F8
+#define	ENE_FW1_ENABLE		0x01	/* enable fw processing */
+#define ENE_FW1_TXIRQ		0x02	/* TX interrupt pending */
+#define ENE_FW1_WAKE		0x40	/* enable wake from S3 */
+#define ENE_FW1_IRQ		0x80	/* enable interrupt */
+
+/* second firmware register */
+#define ENE_FW2			0xF8F9
+#define ENE_FW2_BUF_HIGH	0x01	/* which half of the buffer to read */
+#define ENE_FW2_IRQ_CLR		0x04	/* clear this on IRQ */
+#define ENE_FW2_GP40_AS_LEARN	0x08	/* normal input is used as */
+					/* learning input */
+#define ENE_FW2_FAN_AS_NRML_IN	0x40	/* fan is used as normal input */
+#define ENE_FW2_LEARNING	0x80	/* hardware supports learning and TX */
+
+/* transmitter ports */
+#define ENE_TX_PORT2		0xFC01	/* this enables one or both */
+#define ENE_TX_PORT2_EN		0x20	/* TX ports */
+#define ENE_TX_PORT1		0xFC08
+#define ENE_TX_PORT1_EN		0x02
+
+/* IRQ registers block (for revision B) */
+#define ENEB_IRQ		0xFD09	/* IRQ number */
+#define ENEB_IRQ_UNK1		0xFD17	/* unknown setting = 1 */
+#define ENEB_IRQ_STATUS		0xFD80	/* irq status */
+#define ENEB_IRQ_STATUS_IR	0x20	/* IR irq */
+
+/* fan as input settings - only if learning capable */
+#define ENE_FAN_AS_IN1		0xFE30  /* fan init reg 1 */
+#define ENE_FAN_AS_IN1_EN	0xCD
+#define ENE_FAN_AS_IN2		0xFE31  /* fan init reg 2 */
+#define ENE_FAN_AS_IN2_EN	0x03
+#define ENE_SAMPLE_PERIOD_FAN   61	/* fan input has fixed sample period */
+
+/* IRQ registers block (for revision C,D) */
+#define ENEC_IRQ		0xFE9B	/* new irq settings register */
+#define ENEC_IRQ_MASK		0x0F	/* irq number mask */
+#define ENEC_IRQ_UNK_EN		0x10	/* always enabled */
+#define ENEC_IRQ_STATUS		0x20	/* irq status and ACK */
+
+/* CIR block settings */
+#define ENE_CIR_CONF1		0xFEC0
+#define ENE_CIR_CONF1_TX_CLEAR	0x01	/* clear that on revC */
+					/* while transmitting */
+#define ENE_CIR_CONF1_RX_ON	0x07	/* normal receiver enabled */
+#define ENE_CIR_CONF1_LEARN1	0x08	/* enabled on learning mode */
+#define ENE_CIR_CONF1_TX_ON	0x30	/* enabled on transmit */
+#define ENE_CIR_CONF1_TX_CARR	0x80	/* send TX carrier or not */
+
+#define ENE_CIR_CONF2		0xFEC1	/* unknown setting = 0 */
+#define ENE_CIR_CONF2_LEARN2	0x10	/* set on enable learning */
+#define ENE_CIR_CONF2_GPIO40DIS	0x20	/* disable input via gpio40 */
+
+#define ENE_CIR_SAMPLE_PERIOD	0xFEC8	/* sample period in us */
+#define ENE_CIR_SAMPLE_OVERFLOW	0x80	/* interrupt on overflows if set */
+
+
+/* Two byte tx buffer */
+#define ENE_TX_INPUT1		0xFEC9
+#define ENE_TX_INPUT2		0xFECA
+#define ENE_TX_PULSE_MASK	0x80	/* Transmitted sample is pulse */
+#define ENE_TX_SMLP_MASK	0x7F
+#define ENE_TX_SMPL_PERIOD	50	/* transmit sample period - fixed */
+
+
+/* Unknown TX setting - TX sample period ??? */
+#define ENE_TX_UNK1		0xFECB	/* set to 0x63 */
+
+/* Current received carrier period */
+#define ENE_RX_CARRIER		0xFECC	/* RX period (500 ns) */
+#define ENE_RX_CARRIER_VALID	0x80	/* Register content valid */
+
+
+/* TX period (1/carrier) */
+#define ENE_TX_PERIOD		0xFECE	/* TX period (500 ns) */
+#define ENE_TX_PERIOD_UNKBIT	0x80	/* This bit set on transmit*/
+#define ENE_TX_PERIOD_PULSE	0xFECF	/* TX pulse period (500 ns)*/
+
+/* Hardware versions */
+#define ENE_HW_VERSION		0xFF00	/* hardware revision */
+#define ENE_HW_UNK		0xFF1D
+#define ENE_HW_UNK_CLR		0x04
+#define ENE_HW_VER_MAJOR	0xFF1E	/* chip version */
+#define ENE_HW_VER_MINOR	0xFF1F
+#define ENE_HW_VER_OLD		0xFD00
+
+/* Normal/Learning carrier ranges - only valid if we have learning input*/
+/* TODO: test */
+#define ENE_NORMAL_RX_LOW	34
+#define ENE_NORMAL_RX_HI	38
+
+/* Tx carrier range */
+/* Hardware might be able to do more, but this range is enough for
+   all purposes */
+#define ENE_TX_PERIOD_MAX	32	/* corresponds to 29.4 kHz */
+#define ENE_TX_PERIOD_MIN	16	/* corrsponds to 62.5 kHz */
+
+
+
+/* Minimal and maximal gaps */
+
+/* Normal case:
+	Minimal gap is 0x7F * sample period
+	Maximum gap depends on hardware.
+	For KB3926B, it is unlimited, for newer models its around
+	250000, after which HW stops sending samples, and that is
+	not possible to change */
+
+/* Fan case:
+	Both minimal and maximal gaps are same, and equal to 0xFFF * 0x61
+	And there is nothing to change this setting
+*/
+
+#define ENE_MAXGAP		250000
+#define ENE_MINGAP		(127 * sample_period)
+
+/******************************************************************************/
+
+#define ENE_DRIVER_NAME		"ene_ir"
+
+#define ENE_IRQ_RX		1
+#define ENE_IRQ_TX		2
+
+#define  ENE_HW_B		1	/* 3926B */
+#define  ENE_HW_C		2	/* 3926C */
+#define  ENE_HW_D		3	/* 3926D */
+
+#define ene_printk(level, text, ...) \
+	printk(level ENE_DRIVER_NAME ": " text, ## __VA_ARGS__)
+
+#define ene_dbg(text, ...) \
+	if (debug) \
+		printk(KERN_DEBUG \
+			ENE_DRIVER_NAME ": " text "\n" , ## __VA_ARGS__)
+
+#define ene_dbg_verbose(text, ...) \
+	if (debug > 1) \
+		printk(KERN_DEBUG \
+			ENE_DRIVER_NAME ": " text "\n" , ## __VA_ARGS__)
+
+
+struct ene_device {
+	struct pnp_dev *pnp_dev;
+	struct input_dev *idev;
+	struct ir_dev_props *props;
+	int in_use;
+
+	/* hw IO settings */
+	unsigned long hw_io;
+	int irq;
+	spinlock_t hw_lock;
+
+	/* HW features */
+	int hw_revision;			/* hardware revision */
+	int hw_learning_and_tx_capable;		/* learning capable */
+	int hw_gpio40_learning;			/* gpio40 is learning */
+	int hw_fan_as_normal_input;		/* fan input is used as */
+						/* regular input */
+	/* HW state*/
+	int rx_pointer;				/* hw pointer to rx buffer */
+	int rx_fan_input_inuse;			/* is fan input in use for rx*/
+	int tx_reg;				/* current reg used for TX */
+	u8  saved_conf1;			/* saved FEC0 reg */
+	int learning_enabled;			/* learning input enabled */
+
+	/* TX sample handling */
+	unsigned int tx_sample;			/* current sample for TX */
+	int tx_sample_pulse;			/* current sample is pulse */
+
+	/* TX buffer */
+	int *tx_buffer;				/* input samples buffer*/
+	int tx_pos;				/* position in that bufer */
+	int tx_len;				/* current len of tx buffer */
+	int tx_done;				/* done transmitting */
+						/* one more sample pending*/
+	struct completion tx_complete;		/* TX completion */
+	struct timer_list tx_sim_timer;
+
+	/*settings */
+	int tx_period;
+	int tx_duty_cycle;
+	int transmitter_mask;
+};
-- 
1.7.0.4

