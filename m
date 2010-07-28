Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38643 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0G1XlR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 19:41:17 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 8/9] STAGING: remove lirc_ene0100 driver.
Date: Thu, 29 Jul 2010 02:40:51 +0300
Message-Id: <1280360452-8852-9-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280360452-8852-1-git-send-email-maximlevitsky@gmail.com>
References: <1280360452-8852-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add latest unported version of this driver to media/IR.
Next patch will port it to ir core.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ene_ir.c           | 1176 +++++++++++++++++++++++++++++++++++
 drivers/media/IR/ene_ir.h           |  240 +++++++
 drivers/staging/lirc/Kconfig        |    8 -
 drivers/staging/lirc/Makefile       |    1 -
 drivers/staging/lirc/lirc_ene0100.c |  646 -------------------
 drivers/staging/lirc/lirc_ene0100.h |  169 -----
 6 files changed, 1416 insertions(+), 824 deletions(-)
 create mode 100644 drivers/media/IR/ene_ir.c
 create mode 100644 drivers/media/IR/ene_ir.h
 delete mode 100644 drivers/staging/lirc/lirc_ene0100.c
 delete mode 100644 drivers/staging/lirc/lirc_ene0100.h

diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
new file mode 100644
index 0000000..9d11caf
--- /dev/null
+++ b/drivers/media/IR/ene_ir.c
@@ -0,0 +1,1176 @@
+/*
+ * driver for ENE KB3926 B/C/D CIR (also known as ENE0100/ENE0200/ENE0201)
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
+#include <linux/uaccess.h>
+#include "lirc_ene0100.h"
+
+
+static int sample_period = -1;
+static int enable_idle = 1;
+static int enable_duty_carrier;
+static int input = 1;
+static int debug;
+static int txsim;
+
+static void ene_rx_set_idle(struct ene_device *dev, int idle);
+static int ene_irq_status(struct ene_device *dev);
+static void ene_send_sample(struct ene_device *dev, unsigned long sample);
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
+static void ene_enable_gpio40_recieve(struct ene_device *dev, int enable)
+{
+	ene_hw_write_reg_mask(dev, ENE_CIR_CONF2, enable ?
+			      0 : ENE_CIR_CONF2_GPIO40DIS,
+			      ENE_CIR_CONF2_GPIO40DIS);
+}
+
+/* this enables/disables IR via standard input */
+static void ene_enable_normal_recieve(struct ene_device *dev, int enable)
+{
+	ene_hw_write_reg(dev, ENE_CIR_CONF1, enable ? ENE_CIR_CONF1_RX_ON : 0);
+}
+
+/* this enables/disables IR input via unused fan tachtometer input */
+static void ene_enable_fan_recieve(struct ene_device *dev, int enable)
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
+/* Sense current recieved carrier */
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
+	int learning_mode = dev->learning_enabled || dev->rx_carrier_sense;
+
+	ene_dbg("RX: setup reciever, learning mode = %d", learning_mode);
+
+	ene_enable_normal_recieve(dev, 1);
+
+	/* old hardware doesn't support learning mode for sure */
+	if (dev->hw_revision <= ENE_HW_B)
+		return;
+
+	/* reciever not learning capable, still set gpio40 correctly */
+	if (!dev->hw_learning_and_tx_capable) {
+		ene_enable_gpio40_recieve(dev, !dev->hw_gpio40_learning);
+		return;
+	}
+
+	/* enable learning mode */
+	if (learning_mode) {
+		ene_enable_gpio40_recieve(dev, dev->hw_gpio40_learning);
+
+		/* fan input is not used for learning */
+		if (dev->hw_fan_as_normal_input)
+			ene_enable_fan_recieve(dev, 0);
+
+	/* disable learning mode */
+	} else {
+		if (dev->hw_fan_as_normal_input) {
+			ene_enable_fan_recieve(dev, 1);
+			ene_enable_normal_recieve(dev, 0);
+		} else
+			ene_enable_gpio40_recieve(dev,
+					!dev->hw_gpio40_learning);
+	}
+
+	/* set few additional settings for this mode */
+	ene_hw_write_reg_mask(dev, ENE_CIR_CONF1, learning_mode ?
+			      ENE_CIR_CONF1_LEARN1 : 0, ENE_CIR_CONF1_LEARN1);
+
+	ene_hw_write_reg_mask(dev, ENE_CIR_CONF2, learning_mode ?
+			      ENE_CIR_CONF2_LEARN2 : 0, ENE_CIR_CONF2_LEARN2);
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
+	/* enter idle mode */
+	ene_rx_set_idle(dev, 1);
+
+	/* enable firmware bits */
+	ene_hw_write_reg_mask(dev, ENE_FW1,
+			      ENE_FW1_ENABLE | ENE_FW1_IRQ,
+			      ENE_FW1_ENABLE | ENE_FW1_IRQ);
+}
+
+/* Disable the device reciever */
+static void ene_rx_disable(struct ene_device *dev)
+{
+	/* disable inputs */
+	ene_enable_normal_recieve(dev, 0);
+
+	if (dev->hw_fan_as_normal_input)
+		ene_enable_fan_recieve(dev, 0);
+
+	/* disable hardware IRQ and firmware flag */
+	ene_hw_write_reg_mask(dev, ENE_FW1, 0, ENE_FW1_ENABLE | ENE_FW1_IRQ);
+
+	ene_rx_set_idle(dev, 1);
+}
+
+/*  send current sample to the user */
+static void ene_rx_flush(struct ene_device *dev, int timeout)
+{
+	unsigned long value;
+
+	value =	dev->rx_sample_pulse ? LIRC_PULSE(dev->rx_sample) :
+					LIRC_SPACE(dev->rx_sample);
+	ene_send_sample(dev, value);
+	dev->rx_sample = 0;
+	dev->rx_sample_pulse = 0;
+}
+
+/* recieve new sample and process it */
+static void ene_rx_sample(struct ene_device *dev, int sample, int is_pulse)
+{
+	ene_dbg("RX: sample %8d (%s)", sample, is_pulse ? "pulse" : "space");
+
+	/* ignore spaces in idle mode, can get them on revC */
+	/* also ignore a space in front of first pulse */
+	if (dev->rx_idle && !is_pulse)
+		return;
+
+	/* get out of idle mode now */
+	if (dev->rx_idle)
+		ene_rx_set_idle(dev, 0);
+
+	if (!dev->rx_sample) {
+		dev->rx_sample = sample;
+		dev->rx_sample_pulse = is_pulse;
+	} else if (is_pulse == dev->rx_sample_pulse)
+		dev->rx_sample += sample;
+	else {
+		ene_rx_flush(dev, 0);
+		dev->rx_sample = sample;
+		dev->rx_sample_pulse = is_pulse;
+	}
+
+	if (is_pulse)
+		return;
+
+	/* overflow sample from fan input recieved, enable idle mode */
+	if (dev->rx_fan_input_inuse &&
+		sample == ENE_FAN_VALUE_MASK * ENE_SAMPLE_PERIOD_FAN) {
+		ene_rx_set_idle(dev, 1);
+		return;
+	}
+
+	if (!dev->rx_fan_input_inuse) {
+		/* Report timeout if enabled */
+		if (dev->rx_timeout && dev->rx_send_timeout_packet &&
+			!dev->rx_timeout_sent &&
+				dev->rx_sample > dev->rx_timeout) {
+			ene_dbg("RX: sending timeout sample");
+			ene_send_sample(dev, LIRC_TIMEOUT(dev->rx_sample));
+			dev->rx_timeout_sent = 1;
+		}
+
+		/* too large sample accumulated via normal input.
+		note that on revC, hardware idle mode turns on automaticly,
+			so max gap should be less that the gap after which
+			hw stops sending samples */
+		if (dev->rx_sample > ENE_MAXGAP) {
+			ene_rx_set_idle(dev, 1);
+			return;
+		}
+	}
+}
+
+/* enable or disable idle mode */
+static void ene_rx_set_idle(struct ene_device *dev, int idle)
+{
+	struct timeval now;
+	int disable_sampler = 0;
+
+
+	/* Also put hardware sampler in 'idle' mode on revB*/
+	/* revC and higher do that automaticly (firmware does?) */
+	if ((dev->hw_revision < ENE_HW_C) && enable_idle)
+		if (idle)
+			disable_sampler = 1;
+
+	ene_hw_write_reg_mask(dev, ENE_CIR_SAMPLE_PERIOD,
+			      disable_sampler ? 0 : ENE_CIR_SAMPLE_OVERFLOW,
+			      ENE_CIR_SAMPLE_OVERFLOW);
+	dev->rx_idle = idle;
+
+	/* remember when we have entered the idle mode */
+	if (idle) {
+		ene_dbg("RX: going into idle mode");
+		do_gettimeofday(&dev->rx_gap_start);
+		return;
+	}
+
+	ene_dbg("RX: back from idle mode");
+
+	/* send the gap between keypresses now */
+	do_gettimeofday(&now);
+
+	if (dev->rx_sample_pulse) {
+		ene_dbg("RX: somehow we recieved a pulse before idle mode???");
+		return;
+	}
+
+	/* manually calculate and recieve the gap between keypresses */
+	if (now.tv_sec - dev->rx_gap_start.tv_sec > 16)
+		dev->rx_sample = LIRC_SPACE(LIRC_VALUE_MASK);
+	else
+		dev->rx_sample +=
+		    1000000ull * (now.tv_sec - dev->rx_gap_start.tv_sec)
+		    + now.tv_usec - dev->rx_gap_start.tv_usec;
+
+	if (dev->rx_sample > LIRC_SPACE(LIRC_VALUE_MASK))
+		dev->rx_sample = LIRC_SPACE(LIRC_VALUE_MASK);
+
+	ene_rx_flush(dev, 0);
+	dev->rx_timeout_sent = 0;
+}
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
+	dev->tx_underway = 1;
+
+}
+
+/* end transmission */
+static void ene_tx_complete(struct ene_device *dev)
+{
+	ene_hw_write_reg(dev, ENE_CIR_CONF1, dev->saved_conf1);
+	dev->tx_underway = 0;
+}
+
+/* set transmit mask */
+static void ene_tx_set_transmiter_mask(struct ene_device *dev)
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
+	if (!dev->tx_underway) {
+		ene_dbg("TX: attempt to transmit while hw isn't setup");
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
+	if ((debug && dev->learning_enabled) || dev->rx_carrier_sense)
+		carrier = ene_rx_sense_carrier(dev);
+
+	if (dev->rx_carrier_sense && carrier)
+		ene_send_sample(dev, LIRC_FREQUENCY(carrier));
+
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
+		}
+		/* no more data */
+		if (!(hw_value))
+			break;
+
+		ene_rx_sample(dev, hw_sample, pulse);
+	}
+unlock:
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	return retval;
+}
+
+/* Initialize default settings */
+static void ene_setup_settings(struct ene_device *dev)
+{
+	dev->rx_send_timeout_packet = 0;
+	dev->rx_timeout = ENE_MAXGAP;
+	dev->tx_period = 32;
+	dev->tx_duty_cycle = 25; /*%*/
+	dev->transmitter_mask = 3;
+
+	/* Force learning mode if (input == 2), otherwise
+		let user set it with LIRC_SET_REC_CARRIER */
+	dev->learning_enabled =
+		(input == 2 && dev->hw_learning_and_tx_capable);
+
+	/* Clear accumulated sample bufer */
+	dev->rx_sample = 0;
+	dev->rx_sample_pulse = 0;
+	dev->rx_pointer = -1;
+	dev->rx_carrier_sense = 0;
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
+/* outside interface for settings */
+static int ene_ioctl(struct inode *node, struct file *file,
+		      unsigned int cmd, unsigned long arg)
+{
+	int lvalue = 0, retval, tmp;
+	unsigned long flags;
+	struct ene_device *dev = lirc_get_pdata(file);
+
+
+	switch (cmd) {
+	case LIRC_SET_SEND_CARRIER:
+	case LIRC_SET_SEND_DUTY_CYCLE:
+	case LIRC_SET_TRANSMITTER_MASK:
+	case LIRC_SET_MEASURE_CARRIER_MODE:
+	case LIRC_SET_REC_CARRIER:
+		/* All these aren't possible without this */
+		if (!dev->hw_learning_and_tx_capable)
+			return -ENOSYS;
+		/* Fall through */
+	case LIRC_SET_REC_TIMEOUT:
+	case LIRC_SET_REC_TIMEOUT_REPORTS:
+		retval = get_user(lvalue, (unsigned int *) arg);
+		if (retval)
+			return retval;
+	}
+
+	switch (cmd) {
+	case LIRC_SET_SEND_CARRIER:
+		ene_dbg("TX: attempt to set tx carrier to %d kHz", lvalue);
+		tmp = 1000000 / lvalue; /* (1 / freq) (* # usec in 1 sec) */
+
+		if (tmp && (tmp > ENE_TX_PERIOD_MAX ||
+				tmp < ENE_TX_PERIOD_MIN)) {
+
+			ene_dbg("TX: out of range %d-%d carrier, "
+				"falling back to 32 kHz",
+				1000 / ENE_TX_PERIOD_MIN,
+				1000 / ENE_TX_PERIOD_MAX);
+
+			tmp = 32; /* this is just a coincidence!!! */
+		}
+		ene_dbg("TX: set carrier to %d kHz", lvalue);
+
+		spin_lock_irqsave(&dev->hw_lock, flags);
+		dev->tx_period = tmp;
+		spin_unlock_irqrestore(&dev->hw_lock, flags);
+		break;
+	case LIRC_SET_SEND_DUTY_CYCLE:
+		ene_dbg("TX: attempt to set duty cycle to %d%%", lvalue);
+
+		if ((lvalue >= 100) || (lvalue <= 0)) {
+			retval = -EINVAL;
+			break;
+		}
+		spin_lock_irqsave(&dev->hw_lock, flags);
+		dev->tx_duty_cycle = lvalue;
+		spin_unlock_irqrestore(&dev->hw_lock, flags);
+		break;
+	case LIRC_SET_TRANSMITTER_MASK:
+		ene_dbg("TX: attempt to set transmitter mask %02x", lvalue);
+
+		/* invalid txmask */
+		if (!lvalue || lvalue & ~0x3) {
+			ene_dbg("TX: invalid mask");
+			/* this supposed to return num of transmitters */
+			retval =  2;
+			break;
+		}
+		spin_lock_irqsave(&dev->hw_lock, flags);
+		dev->transmitter_mask = lvalue;
+		spin_unlock_irqrestore(&dev->hw_lock, flags);
+		break;
+	case LIRC_SET_REC_CARRIER:
+		tmp = (lvalue > ENE_NORMAL_RX_HI || lvalue < ENE_NORMAL_RX_LOW);
+
+		if (tmp != dev->learning_enabled) {
+			spin_lock_irqsave(&dev->hw_lock, flags);
+			dev->learning_enabled = tmp;
+			ene_rx_set_inputs(dev);
+			spin_unlock_irqrestore(&dev->hw_lock, flags);
+		}
+		break;
+	case LIRC_SET_REC_TIMEOUT:
+		spin_lock_irqsave(&dev->hw_lock, flags);
+		dev->rx_timeout = lvalue;
+		spin_unlock_irqrestore(&dev->hw_lock, flags);
+		ene_dbg("RX: set rx report timeout to %d", dev->rx_timeout);
+		break;
+	case LIRC_SET_REC_TIMEOUT_REPORTS:
+		spin_lock_irqsave(&dev->hw_lock, flags);
+		dev->rx_send_timeout_packet = lvalue;
+		spin_unlock_irqrestore(&dev->hw_lock, flags);
+		ene_dbg("RX: %sable timeout reports",
+				dev->rx_send_timeout_packet ? "en" : "dis");
+		break;
+	case LIRC_SET_MEASURE_CARRIER_MODE:
+		if (dev->rx_carrier_sense == lvalue)
+			break;
+		spin_lock_irqsave(&dev->hw_lock, flags);
+		dev->rx_carrier_sense = lvalue;
+		ene_rx_set_inputs(dev);
+		spin_unlock_irqrestore(&dev->hw_lock, flags);
+		break;
+	case LIRC_GET_REC_RESOLUTION:
+		tmp = dev->rx_fan_input_inuse ?
+			ENE_SAMPLE_PERIOD_FAN : sample_period;
+		retval = put_user(tmp, (unsigned long *) arg);
+		break;
+	default:
+		retval = -ENOIOCTLCMD;
+		break;
+	}
+
+	return retval;
+}
+
+/* outside interface: transmit */
+static ssize_t ene_transmit(struct file *file, const char *buf,
+				  size_t n, loff_t *ppos)
+{
+	struct ene_device *dev = lirc_get_pdata(file);
+	unsigned long flags;
+
+	if (!dev)
+		return -EFAULT;
+
+	if (!dev->hw_learning_and_tx_capable)
+		return -ENODEV;
+
+	if (n % sizeof(int))
+		return -EINVAL;
+
+	if (n > ENE_TXBUF_SIZE * sizeof(int))
+		return -ENOMEM;
+
+	if (copy_from_user(dev->tx_buffer, buf, n))
+		return -EFAULT;
+
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
+	ene_tx_set_transmiter_mask(dev);
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
+
+	return n;
+}
+
+/* Sends one sample to the user */
+static void ene_send_sample(struct ene_device *dev, unsigned long sample)
+{
+	if (!lirc_buffer_full(dev->lirc_driver->rbuf)) {
+		lirc_buffer_write(dev->lirc_driver->rbuf, (void *)&sample);
+		wake_up(&dev->lirc_driver->rbuf->wait_poll);
+	}
+}
+
+
+static const struct file_operations ene_fops = {
+	.owner		= THIS_MODULE,
+	.write		= ene_transmit,
+	.ioctl		= ene_ioctl,
+};
+
+/* main load function */
+static int ene_probe(struct pnp_dev *pnp_dev,
+		     const struct pnp_device_id *dev_id)
+{
+	struct ene_device *dev;
+	struct lirc_driver *lirc_driver;
+	int error = -ENOMEM;
+
+	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
+
+	if (!dev)
+		goto err1;
+
+	dev->pnp_dev = pnp_dev;
+	pnp_set_drvdata(pnp_dev, dev);
+
+	/* prepare lirc interface */
+	error = -ENOMEM;
+	lirc_driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
+
+	if (!lirc_driver)
+		goto err2;
+
+	dev->lirc_driver = lirc_driver;
+
+	strcpy(lirc_driver->name, ENE_DRIVER_NAME);
+	lirc_driver->minor = -1;
+	lirc_driver->code_length = sizeof(int) * 8;
+	lirc_driver->features = LIRC_CAN_REC_MODE2 |
+				LIRC_CAN_GET_REC_RESOLUTION |
+				LIRC_CAN_SET_REC_TIMEOUT;
+	lirc_driver->data = dev;
+	lirc_driver->set_use_inc = ene_open;
+	lirc_driver->set_use_dec = ene_close;
+	lirc_driver->dev = &pnp_dev->dev;
+	lirc_driver->owner = THIS_MODULE;
+	lirc_driver->fops = &ene_fops;
+	lirc_driver->min_timeout = ENE_MINGAP;
+	lirc_driver->max_timeout = ENE_MAXGAP;
+	lirc_driver->rbuf = kzalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
+
+	if (!lirc_driver->rbuf)
+		goto err3;
+
+	if (lirc_buffer_init(lirc_driver->rbuf, sizeof(int), sizeof(int) * 512))
+		goto err4;
+
+	/* validate resources */
+	if (!pnp_port_valid(pnp_dev, 0) ||
+	    pnp_port_len(pnp_dev, 0) < ENE_MAX_IO)
+		goto err5;
+
+	if (!pnp_irq_valid(pnp_dev, 0))
+		goto err5;
+
+	dev->hw_io = pnp_port_start(pnp_dev, 0);
+	dev->irq = pnp_irq(pnp_dev, 0);
+	spin_lock_init(&dev->hw_lock);
+
+	/* claim the resources */
+	error = -EBUSY;
+	if (!request_region(dev->hw_io, ENE_MAX_IO, ENE_DRIVER_NAME))
+		goto err5;
+
+	if (request_irq(dev->irq, ene_isr,
+			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev))
+		goto err6;
+
+	/* detect hardware version and features */
+	error = ene_hw_detect(dev);
+	if (error)
+		goto err7;
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
+	if (dev->hw_learning_and_tx_capable) {
+		lirc_driver->features |= LIRC_CAN_SEND_PULSE |
+					 LIRC_CAN_SET_SEND_CARRIER |
+					 LIRC_CAN_SET_TRANSMITTER_MASK;
+
+		if (enable_duty_carrier)
+			lirc_driver->features |= LIRC_CAN_SET_SEND_DUTY_CYCLE;
+
+		if (input == 0)
+			lirc_driver->features |= LIRC_CAN_SET_REC_CARRIER;
+
+		init_completion(&dev->tx_complete);
+	}
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
+	device_set_wakeup_capable(&pnp_dev->dev, 1);
+	device_set_wakeup_enable(&pnp_dev->dev, 1);
+
+	error = -ENODEV;
+	if (lirc_register_driver(lirc_driver))
+		goto err7;
+
+	ene_printk(KERN_NOTICE, "driver has been succesfully loaded\n");
+	return 0;
+
+err7:
+	free_irq(dev->irq, dev);
+err6:
+	release_region(dev->hw_io, ENE_MAX_IO);
+err5:
+	lirc_buffer_free(lirc_driver->rbuf);
+err4:
+	kfree(lirc_driver->rbuf);
+err3:
+	kfree(lirc_driver);
+err2:
+	kfree(dev);
+err1:
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
+	lirc_unregister_driver(dev->lirc_driver->minor);
+	lirc_buffer_free(dev->lirc_driver->rbuf);
+	kfree(dev->lirc_driver);
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
+module_param(enable_duty_carrier, bool, S_IRUGO);
+MODULE_PARM_DESC(enable_duty_carrier,
+	"Enable a code that might allow to to set TX carrier duty cycle");
+
+MODULE_DEVICE_TABLE(pnp, ene_ids);
+MODULE_DESCRIPTION
+	("LIRC driver for KB3926B/KB3926C/KB3926D "
+	"(aka ENE0100/ENE0200/ENE0201) CIR port");
+
+MODULE_AUTHOR("Maxim Levitsky");
+MODULE_LICENSE("GPL");
+
+module_init(ene_init);
+module_exit(ene_exit);
diff --git a/drivers/media/IR/ene_ir.h b/drivers/media/IR/ene_ir.h
new file mode 100644
index 0000000..06453a8
--- /dev/null
+++ b/drivers/media/IR/ene_ir.h
@@ -0,0 +1,240 @@
+/*
+ * driver for ENE KB3926 B/C/D CIR (also known as ENE0100/ENE0200/ENE0201)
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
+#include <media/lirc.h>
+#include <media/lirc_dev.h>
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
+#define ENE_CIR_CONF1_RX_ON	0x07	/* normal reciever enabled */
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
+/* Current recieved carrier period */
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
+#define ENE_DRIVER_NAME		"enecir"
+#define ENE_TXBUF_SIZE (500 * sizeof(int))	/* 500 samples (arbitary) */
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
+	struct lirc_driver *lirc_driver;
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
+	/* RX sample handling */
+	int rx_sample;				/* current recieved sample */
+	int rx_sample_pulse;			/* recieved sample is pulse */
+	int rx_idle;				/* idle mode for RX activated */
+	struct timeval rx_gap_start;		/* time of start of idle */
+	int rx_timeout;				/* time in ms of RX timeout */
+	int rx_send_timeout_packet;		/* do we send RX timeout */
+	int rx_timeout_sent;			/* we sent the timeout packet */
+	int rx_carrier_sense;			/* sense carrier */
+
+	/* TX sample handling */
+	unsigned int tx_sample;			/* current sample for TX */
+	int tx_sample_pulse;			/* current sample is pulse */
+
+	/* TX buffer */
+	int tx_buffer[ENE_TXBUF_SIZE];		/* input samples buffer*/
+	int tx_pos;				/* position in that bufer */
+	int tx_len;				/* current len of tx buffer */
+	int tx_underway;			/* TX is under way*/
+	int tx_done;				/* done transmitting */
+						/* one more sample pending*/
+	struct completion tx_complete;		/* TX completion */
+	struct timer_list tx_sim_timer;
+
+	/*TX settings */
+	int tx_period;
+	int tx_duty_cycle;
+	int transmitter_mask;
+};
diff --git a/drivers/staging/lirc/Kconfig b/drivers/staging/lirc/Kconfig
index 968c2ad..d199165 100644
--- a/drivers/staging/lirc/Kconfig
+++ b/drivers/staging/lirc/Kconfig
@@ -17,14 +17,6 @@ config LIRC_BT829
 	help
 	  Driver for the IR interface on BT829-based hardware
 
-config LIRC_ENE0100
-	tristate "ENE KB3924/ENE0100 CIR Port Reciever"
-	depends on LIRC_STAGING
-	help
-	  This is a driver for CIR port handled by ENE KB3924 embedded
-	  controller found on some notebooks.
-	  It appears on PNP list as ENE0100.
-
 config LIRC_I2C
 	tristate "I2C Based IR Receivers"
 	depends on LIRC_STAGING
diff --git a/drivers/staging/lirc/Makefile b/drivers/staging/lirc/Makefile
index a019182..7011d6c 100644
--- a/drivers/staging/lirc/Makefile
+++ b/drivers/staging/lirc/Makefile
@@ -4,7 +4,6 @@
 # Each configuration option enables a list of files.
 
 obj-$(CONFIG_LIRC_BT829)	+= lirc_bt829.o
-obj-$(CONFIG_LIRC_ENE0100)	+= lirc_ene0100.o
 obj-$(CONFIG_LIRC_I2C)		+= lirc_i2c.o
 obj-$(CONFIG_LIRC_IGORPLUGUSB)	+= lirc_igorplugusb.o
 obj-$(CONFIG_LIRC_IMON)		+= lirc_imon.o
diff --git a/drivers/staging/lirc/lirc_ene0100.c b/drivers/staging/lirc/lirc_ene0100.c
deleted file mode 100644
index a152c52..0000000
--- a/drivers/staging/lirc/lirc_ene0100.c
+++ /dev/null
@@ -1,646 +0,0 @@
-/*
- * driver for ENE KB3926 B/C/D CIR (also known as ENE0100)
- *
- * Copyright (C) 2009 Maxim Levitsky <maximlevitsky@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/pnp.h>
-#include <linux/io.h>
-#include <linux/interrupt.h>
-#include <linux/sched.h>
-#include "lirc_ene0100.h"
-
-static int sample_period = 75;
-static int enable_idle = 1;
-static int enable_learning;
-
-static void ene_set_idle(struct ene_device *dev, int idle);
-static void ene_set_inputs(struct ene_device *dev, int enable);
-
-/* read a hardware register */
-static u8 ene_hw_read_reg(struct ene_device *dev, u16 reg)
-{
-	outb(reg >> 8, dev->hw_io + ENE_ADDR_HI);
-	outb(reg & 0xFF, dev->hw_io + ENE_ADDR_LO);
-	return inb(dev->hw_io + ENE_IO);
-}
-
-/* write a hardware register */
-static void ene_hw_write_reg(struct ene_device *dev, u16 reg, u8 value)
-{
-	outb(reg >> 8, dev->hw_io + ENE_ADDR_HI);
-	outb(reg & 0xFF, dev->hw_io + ENE_ADDR_LO);
-	outb(value, dev->hw_io + ENE_IO);
-}
-
-/* change specific bits in hardware register */
-static void ene_hw_write_reg_mask(struct ene_device *dev,
-				  u16 reg, u8 value, u8 mask)
-{
-	u8 regvalue;
-
-	outb(reg >> 8, dev->hw_io + ENE_ADDR_HI);
-	outb(reg & 0xFF, dev->hw_io + ENE_ADDR_LO);
-
-	regvalue = inb(dev->hw_io + ENE_IO) & ~mask;
-	regvalue |= (value & mask);
-	outb(regvalue, dev->hw_io + ENE_IO);
-}
-
-/* read irq status and ack it */
-static int ene_hw_irq_status(struct ene_device *dev, int *buffer_pointer)
-{
-	u8 irq_status;
-	u8 fw_flags1, fw_flags2;
-
-	fw_flags2 = ene_hw_read_reg(dev, ENE_FW2);
-
-	if (buffer_pointer)
-		*buffer_pointer = 4 * (fw_flags2 & ENE_FW2_BUF_HIGH);
-
-	if (dev->hw_revision < ENE_HW_C) {
-		irq_status = ene_hw_read_reg(dev, ENEB_IRQ_STATUS);
-
-		if (!(irq_status & ENEB_IRQ_STATUS_IR))
-			return 0;
-		ene_hw_write_reg(dev, ENEB_IRQ_STATUS,
-				 irq_status & ~ENEB_IRQ_STATUS_IR);
-
-		/* rev B support only recieving */
-		return ENE_IRQ_RX;
-	}
-
-	irq_status = ene_hw_read_reg(dev, ENEC_IRQ);
-
-	if (!(irq_status & ENEC_IRQ_STATUS))
-		return 0;
-
-	/* original driver does that twice - a workaround ? */
-	ene_hw_write_reg(dev, ENEC_IRQ, irq_status & ~ENEC_IRQ_STATUS);
-	ene_hw_write_reg(dev, ENEC_IRQ, irq_status & ~ENEC_IRQ_STATUS);
-
-	/* clear unknown flag in F8F9 */
-	if (fw_flags2 & ENE_FW2_IRQ_CLR)
-		ene_hw_write_reg(dev, ENE_FW2, fw_flags2 & ~ENE_FW2_IRQ_CLR);
-
-	/* check if this is a TX interrupt */
-	fw_flags1 = ene_hw_read_reg(dev, ENE_FW1);
-
-	if (fw_flags1 & ENE_FW1_TXIRQ) {
-		ene_hw_write_reg(dev, ENE_FW1, fw_flags1 & ~ENE_FW1_TXIRQ);
-		return ENE_IRQ_TX;
-	} else
-		return ENE_IRQ_RX;
-}
-
-static int ene_hw_detect(struct ene_device *dev)
-{
-	u8 chip_major, chip_minor;
-	u8 hw_revision, old_ver;
-	u8 tmp;
-	u8 fw_capabilities;
-
-	tmp = ene_hw_read_reg(dev, ENE_HW_UNK);
-	ene_hw_write_reg(dev, ENE_HW_UNK, tmp & ~ENE_HW_UNK_CLR);
-
-	chip_major = ene_hw_read_reg(dev, ENE_HW_VER_MAJOR);
-	chip_minor = ene_hw_read_reg(dev, ENE_HW_VER_MINOR);
-
-	ene_hw_write_reg(dev, ENE_HW_UNK, tmp);
-	hw_revision = ene_hw_read_reg(dev, ENE_HW_VERSION);
-	old_ver = ene_hw_read_reg(dev, ENE_HW_VER_OLD);
-
-	if (hw_revision == 0xFF) {
-
-		ene_printk(KERN_WARNING, "device seems to be disabled\n");
-		ene_printk(KERN_WARNING,
-			"send a mail to lirc-list@lists.sourceforge.net\n");
-		ene_printk(KERN_WARNING, "please attach output of acpidump\n");
-
-		return -ENODEV;
-	}
-
-	if (chip_major == 0x33) {
-		ene_printk(KERN_WARNING, "chips 0x33xx aren't supported yet\n");
-		return -ENODEV;
-	}
-
-	if (chip_major == 0x39 && chip_minor == 0x26 && hw_revision == 0xC0) {
-		dev->hw_revision = ENE_HW_C;
-		ene_printk(KERN_WARNING,
-		       "KB3926C detected, driver support is not complete!\n");
-
-	} else if (old_ver == 0x24 && hw_revision == 0xC0) {
-		dev->hw_revision = ENE_HW_B;
-		ene_printk(KERN_NOTICE, "KB3926B detected\n");
-	} else {
-		dev->hw_revision = ENE_HW_D;
-		ene_printk(KERN_WARNING,
-			"unknown ENE chip detected, assuming KB3926D\n");
-		ene_printk(KERN_WARNING, "driver support incomplete");
-
-	}
-
-	ene_printk(KERN_DEBUG, "chip is 0x%02x%02x - 0x%02x, 0x%02x\n",
-		chip_major, chip_minor, old_ver, hw_revision);
-
-
-	/* detect features hardware supports */
-
-	if (dev->hw_revision < ENE_HW_C)
-		return 0;
-
-	fw_capabilities = ene_hw_read_reg(dev, ENE_FW2);
-
-	dev->hw_gpio40_learning = fw_capabilities & ENE_FW2_GP40_AS_LEARN;
-	dev->hw_learning_and_tx_capable = fw_capabilities & ENE_FW2_LEARNING;
-
-	dev->hw_fan_as_normal_input = dev->hw_learning_and_tx_capable &&
-	    fw_capabilities & ENE_FW2_FAN_AS_NRML_IN;
-
-	ene_printk(KERN_NOTICE, "hardware features:\n");
-	ene_printk(KERN_NOTICE,
-		"learning and tx %s, gpio40_learn %s, fan_in %s\n",
-	       dev->hw_learning_and_tx_capable ? "on" : "off",
-	       dev->hw_gpio40_learning ? "on" : "off",
-	       dev->hw_fan_as_normal_input ? "on" : "off");
-
-	if (!dev->hw_learning_and_tx_capable && enable_learning)
-		enable_learning = 0;
-
-	if (dev->hw_learning_and_tx_capable) {
-		ene_printk(KERN_WARNING,
-		"Device supports transmitting, but the driver doesn't\n");
-		ene_printk(KERN_WARNING,
-		"due to lack of hardware to test against.\n");
-		ene_printk(KERN_WARNING,
-		"Send a mail to: lirc-list@lists.sourceforge.net\n");
-	}
-	return 0;
-}
-
-/* hardware initialization */
-static int ene_hw_init(void *data)
-{
-	u8 reg_value;
-	struct ene_device *dev = (struct ene_device *)data;
-	dev->in_use = 1;
-
-	if (dev->hw_revision < ENE_HW_C) {
-		ene_hw_write_reg(dev, ENEB_IRQ, dev->irq << 1);
-		ene_hw_write_reg(dev, ENEB_IRQ_UNK1, 0x01);
-	} else {
-		reg_value = ene_hw_read_reg(dev, ENEC_IRQ) & 0xF0;
-		reg_value |= ENEC_IRQ_UNK_EN;
-		reg_value &= ~ENEC_IRQ_STATUS;
-		reg_value |= (dev->irq & ENEC_IRQ_MASK);
-		ene_hw_write_reg(dev, ENEC_IRQ, reg_value);
-		ene_hw_write_reg(dev, ENE_TX_UNK1, 0x63);
-	}
-
-	ene_hw_write_reg(dev, ENE_CIR_CONF2, 0x00);
-	ene_set_inputs(dev, enable_learning);
-
-	/* set sampling period */
-	ene_hw_write_reg(dev, ENE_CIR_SAMPLE_PERIOD, sample_period);
-
-	/* ack any pending irqs - just in case */
-	ene_hw_irq_status(dev, NULL);
-
-	/* enter idle mode */
-	ene_set_idle(dev, 1);
-
-	/* enable firmware bits */
-	ene_hw_write_reg_mask(dev, ENE_FW1,
-			      ENE_FW1_ENABLE | ENE_FW1_IRQ,
-			      ENE_FW1_ENABLE | ENE_FW1_IRQ);
-	/* clear stats */
-	dev->sample = 0;
-	return 0;
-}
-
-/* this enables gpio40 signal, used if connected to wide band input*/
-static void ene_enable_gpio40(struct ene_device *dev, int enable)
-{
-	ene_hw_write_reg_mask(dev, ENE_CIR_CONF1, enable ?
-			      0 : ENE_CIR_CONF2_GPIO40DIS,
-			      ENE_CIR_CONF2_GPIO40DIS);
-}
-
-/* this enables the classic sampler */
-static void ene_enable_normal_recieve(struct ene_device *dev, int enable)
-{
-	ene_hw_write_reg(dev, ENE_CIR_CONF1, enable ? ENE_CIR_CONF1_ADC_ON : 0);
-}
-
-/* this enables recieve via fan input */
-static void ene_enable_fan_recieve(struct ene_device *dev, int enable)
-{
-	if (!enable)
-		ene_hw_write_reg(dev, ENE_FAN_AS_IN1, 0);
-	else {
-		ene_hw_write_reg(dev, ENE_FAN_AS_IN1, ENE_FAN_AS_IN1_EN);
-		ene_hw_write_reg(dev, ENE_FAN_AS_IN2, ENE_FAN_AS_IN2_EN);
-	}
-	dev->fan_input_inuse = enable;
-}
-
-/* determine which input to use*/
-static void ene_set_inputs(struct ene_device *dev, int learning_enable)
-{
-	ene_enable_normal_recieve(dev, 1);
-
-	/* old hardware doesn't support learning mode for sure */
-	if (dev->hw_revision <= ENE_HW_B)
-		return;
-
-	/* reciever not learning capable, still set gpio40 correctly */
-	if (!dev->hw_learning_and_tx_capable) {
-		ene_enable_gpio40(dev, !dev->hw_gpio40_learning);
-		return;
-	}
-
-	/* enable learning mode */
-	if (learning_enable) {
-		ene_enable_gpio40(dev, dev->hw_gpio40_learning);
-
-		/* fan input is not used for learning */
-		if (dev->hw_fan_as_normal_input)
-			ene_enable_fan_recieve(dev, 0);
-
-	/* disable learning mode */
-	} else {
-		if (dev->hw_fan_as_normal_input) {
-			ene_enable_fan_recieve(dev, 1);
-			ene_enable_normal_recieve(dev, 0);
-		} else
-			ene_enable_gpio40(dev, !dev->hw_gpio40_learning);
-	}
-
-	/* set few additional settings for this mode */
-	ene_hw_write_reg_mask(dev, ENE_CIR_CONF1, learning_enable ?
-			      ENE_CIR_CONF1_LEARN1 : 0, ENE_CIR_CONF1_LEARN1);
-
-	ene_hw_write_reg_mask(dev, ENE_CIR_CONF2, learning_enable ?
-			      ENE_CIR_CONF2_LEARN2 : 0, ENE_CIR_CONF2_LEARN2);
-}
-
-/* deinitialization */
-static void ene_hw_deinit(void *data)
-{
-	struct ene_device *dev = (struct ene_device *)data;
-
-	/* disable samplers */
-	ene_enable_normal_recieve(dev, 0);
-
-	if (dev->hw_fan_as_normal_input)
-		ene_enable_fan_recieve(dev, 0);
-
-	/* disable hardware IRQ and firmware flag */
-	ene_hw_write_reg_mask(dev, ENE_FW1, 0, ENE_FW1_ENABLE | ENE_FW1_IRQ);
-
-	ene_set_idle(dev, 1);
-	dev->in_use = 0;
-}
-
-/*  sends current sample to userspace */
-static void send_sample(struct ene_device *dev)
-{
-	int value = abs(dev->sample) & PULSE_MASK;
-
-	if (dev->sample > 0)
-		value |= PULSE_BIT;
-
-	if (!lirc_buffer_full(dev->lirc_driver->rbuf)) {
-		lirc_buffer_write(dev->lirc_driver->rbuf, (void *)&value);
-		wake_up(&dev->lirc_driver->rbuf->wait_poll);
-	}
-	dev->sample = 0;
-}
-
-/*  this updates current sample */
-static void update_sample(struct ene_device *dev, int sample)
-{
-	if (!dev->sample)
-		dev->sample = sample;
-	else if (same_sign(dev->sample, sample))
-		dev->sample += sample;
-	else {
-		send_sample(dev);
-		dev->sample = sample;
-	}
-}
-
-/* enable or disable idle mode */
-static void ene_set_idle(struct ene_device *dev, int idle)
-{
-	struct timeval now;
-	int disable = idle && enable_idle && (dev->hw_revision < ENE_HW_C);
-
-	ene_hw_write_reg_mask(dev, ENE_CIR_SAMPLE_PERIOD,
-			      disable ? 0 : ENE_CIR_SAMPLE_OVERFLOW,
-			      ENE_CIR_SAMPLE_OVERFLOW);
-	dev->idle = idle;
-
-	/* remember when we have entered the idle mode */
-	if (idle) {
-		do_gettimeofday(&dev->gap_start);
-		return;
-	}
-
-	/* send the gap between keypresses now */
-	do_gettimeofday(&now);
-
-	if (now.tv_sec - dev->gap_start.tv_sec > 16)
-		dev->sample = space(PULSE_MASK);
-	else
-		dev->sample = dev->sample +
-		    space(1000000ull * (now.tv_sec - dev->gap_start.tv_sec))
-		    + space(now.tv_usec - dev->gap_start.tv_usec);
-
-	if (abs(dev->sample) > PULSE_MASK)
-		dev->sample = space(PULSE_MASK);
-	send_sample(dev);
-}
-
-/* interrupt handler */
-static irqreturn_t ene_hw_irq(int irq, void *data)
-{
-	u16 hw_value;
-	int i, hw_sample;
-	int space;
-	int buffer_pointer;
-	int irq_status;
-
-	struct ene_device *dev = (struct ene_device *)data;
-	irq_status = ene_hw_irq_status(dev, &buffer_pointer);
-
-	if (!irq_status)
-		return IRQ_NONE;
-
-	/* TODO: only RX for now */
-	if (irq_status == ENE_IRQ_TX)
-		return IRQ_HANDLED;
-
-	for (i = 0; i < ENE_SAMPLES_SIZE; i++) {
-
-		hw_value = ene_hw_read_reg(dev,
-				ENE_SAMPLE_BUFFER + buffer_pointer + i);
-
-		if (dev->fan_input_inuse) {
-			/* read high part of the sample */
-			hw_value |= ene_hw_read_reg(dev,
-			    ENE_SAMPLE_BUFFER_FAN + buffer_pointer + i) << 8;
-
-			/* test for _space_ bit */
-			space = !(hw_value & ENE_FAN_SMPL_PULS_MSK);
-
-			/* clear space bit, and other unused bits */
-			hw_value &= ENE_FAN_VALUE_MASK;
-			hw_sample = hw_value * ENE_SAMPLE_PERIOD_FAN;
-
-		} else {
-			space = hw_value & ENE_SAMPLE_SPC_MASK;
-			hw_value &= ENE_SAMPLE_VALUE_MASK;
-			hw_sample = hw_value * sample_period;
-		}
-
-		/* no more data */
-		if (!(hw_value))
-			break;
-
-		if (space)
-			hw_sample *= -1;
-
-		/* overflow sample recieved, handle it */
-
-		if (!dev->fan_input_inuse && hw_value == ENE_SAMPLE_OVERFLOW) {
-
-			if (dev->idle)
-				continue;
-
-			if (dev->sample > 0 || abs(dev->sample) <= ENE_MAXGAP)
-				update_sample(dev, hw_sample);
-			else
-				ene_set_idle(dev, 1);
-
-			continue;
-		}
-
-		/* normal first sample recieved */
-		if (!dev->fan_input_inuse && dev->idle) {
-			ene_set_idle(dev, 0);
-
-			/* discard first recieved value, its random
-			   since its the time signal was off before
-			   first pulse if idle mode is enabled, HW
-			   does that for us */
-
-			if (!enable_idle)
-				continue;
-		}
-		update_sample(dev, hw_sample);
-		send_sample(dev);
-	}
-	return IRQ_HANDLED;
-}
-
-static int ene_probe(struct pnp_dev *pnp_dev,
-		     const struct pnp_device_id *dev_id)
-{
-	struct ene_device *dev;
-	struct lirc_driver *lirc_driver;
-	int error = -ENOMEM;
-
-	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
-
-	if (!dev)
-		goto err1;
-
-	dev->pnp_dev = pnp_dev;
-	pnp_set_drvdata(pnp_dev, dev);
-
-
-	/* prepare lirc interface */
-	error = -ENOMEM;
-	lirc_driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
-
-	if (!lirc_driver)
-		goto err2;
-
-	dev->lirc_driver = lirc_driver;
-
-	strcpy(lirc_driver->name, ENE_DRIVER_NAME);
-	lirc_driver->minor = -1;
-	lirc_driver->code_length = sizeof(int) * 8;
-	lirc_driver->features = LIRC_CAN_REC_MODE2;
-	lirc_driver->data = dev;
-	lirc_driver->set_use_inc = ene_hw_init;
-	lirc_driver->set_use_dec = ene_hw_deinit;
-	lirc_driver->dev = &pnp_dev->dev;
-	lirc_driver->owner = THIS_MODULE;
-
-	lirc_driver->rbuf = kzalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-
-	if (!lirc_driver->rbuf)
-		goto err3;
-
-	if (lirc_buffer_init(lirc_driver->rbuf, sizeof(int), sizeof(int) * 256))
-		goto err4;
-
-	error = -ENODEV;
-	if (lirc_register_driver(lirc_driver))
-		goto err5;
-
-	/* validate resources */
-	if (!pnp_port_valid(pnp_dev, 0) ||
-	    pnp_port_len(pnp_dev, 0) < ENE_MAX_IO)
-		goto err6;
-
-	if (!pnp_irq_valid(pnp_dev, 0))
-		goto err6;
-
-	dev->hw_io = pnp_port_start(pnp_dev, 0);
-	dev->irq = pnp_irq(pnp_dev, 0);
-
-	/* claim the resources */
-	error = -EBUSY;
-	if (!request_region(dev->hw_io, ENE_MAX_IO, ENE_DRIVER_NAME))
-		goto err6;
-
-	if (request_irq(dev->irq, ene_hw_irq,
-			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev))
-		goto err7;
-
-	/* detect hardware version and features */
-	error = ene_hw_detect(dev);
-	if (error)
-		goto err8;
-
-	ene_printk(KERN_NOTICE, "driver has been succesfully loaded\n");
-	return 0;
-
-err8:
-	free_irq(dev->irq, dev);
-err7:
-	release_region(dev->hw_io, ENE_MAX_IO);
-err6:
-	lirc_unregister_driver(lirc_driver->minor);
-err5:
-	lirc_buffer_free(lirc_driver->rbuf);
-err4:
-	kfree(lirc_driver->rbuf);
-err3:
-	kfree(lirc_driver);
-err2:
-	kfree(dev);
-err1:
-	return error;
-}
-
-static void ene_remove(struct pnp_dev *pnp_dev)
-{
-	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
-	ene_hw_deinit(dev);
-	free_irq(dev->irq, dev);
-	release_region(dev->hw_io, ENE_MAX_IO);
-	lirc_unregister_driver(dev->lirc_driver->minor);
-	lirc_buffer_free(dev->lirc_driver->rbuf);
-	kfree(dev->lirc_driver);
-	kfree(dev);
-}
-
-#ifdef CONFIG_PM
-
-/* TODO: make 'wake on IR' configurable and add .shutdown */
-/* currently impossible due to lack of kernel support */
-
-static int ene_suspend(struct pnp_dev *pnp_dev, pm_message_t state)
-{
-	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
-	ene_hw_write_reg_mask(dev, ENE_FW1, ENE_FW1_WAKE, ENE_FW1_WAKE);
-	return 0;
-}
-
-static int ene_resume(struct pnp_dev *pnp_dev)
-{
-	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
-	if (dev->in_use)
-		ene_hw_init(dev);
-
-	ene_hw_write_reg_mask(dev, ENE_FW1, 0, ENE_FW1_WAKE);
-	return 0;
-}
-
-#endif
-
-static const struct pnp_device_id ene_ids[] = {
-	{.id = "ENE0100",},
-	{},
-};
-
-static struct pnp_driver ene_driver = {
-	.name = ENE_DRIVER_NAME,
-	.id_table = ene_ids,
-	.flags = PNP_DRIVER_RES_DO_NOT_CHANGE,
-
-	.probe = ene_probe,
-	.remove = __devexit_p(ene_remove),
-
-#ifdef CONFIG_PM
-	.suspend = ene_suspend,
-	.resume = ene_resume,
-#endif
-};
-
-static int __init ene_init(void)
-{
-	if (sample_period < 5) {
-		ene_printk(KERN_ERR, "sample period must be at\n");
-		ene_printk(KERN_ERR, "least 5 us, (at least 30 recommended)\n");
-		return -EINVAL;
-	}
-	return pnp_register_driver(&ene_driver);
-}
-
-static void ene_exit(void)
-{
-	pnp_unregister_driver(&ene_driver);
-}
-
-module_param(sample_period, int, S_IRUGO);
-MODULE_PARM_DESC(sample_period, "Hardware sample period (75 us default)");
-
-module_param(enable_idle, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(enable_idle,
-	"Enables turning off signal sampling after long inactivity time; "
-	"if disabled might help detecting input signal (default: enabled)");
-
-module_param(enable_learning, bool, S_IRUGO);
-MODULE_PARM_DESC(enable_learning, "Use wide band (learning) reciever");
-
-MODULE_DEVICE_TABLE(pnp, ene_ids);
-MODULE_DESCRIPTION
-    ("LIRC driver for KB3926B/KB3926C/KB3926D (aka ENE0100) CIR port");
-MODULE_AUTHOR("Maxim Levitsky");
-MODULE_LICENSE("GPL");
-
-module_init(ene_init);
-module_exit(ene_exit);
diff --git a/drivers/staging/lirc/lirc_ene0100.h b/drivers/staging/lirc/lirc_ene0100.h
deleted file mode 100644
index 825045d..0000000
--- a/drivers/staging/lirc/lirc_ene0100.h
+++ /dev/null
@@ -1,169 +0,0 @@
-/*
- * driver for ENE KB3926 B/C/D CIR (also known as ENE0100)
- *
- * Copyright (C) 2009 Maxim Levitsky <maximlevitsky@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- */
-
-#include <media/lirc.h>
-#include <media/lirc_dev.h>
-
-/* hardware address */
-#define ENE_STATUS		0	 /* hardware status - unused */
-#define ENE_ADDR_HI 		1	 /* hi byte of register address */
-#define ENE_ADDR_LO 		2	 /* low byte of register address */
-#define ENE_IO 			3	 /* read/write window */
-#define ENE_MAX_IO		4
-
-/* 8 bytes of samples, divided in 2 halfs*/
-#define ENE_SAMPLE_BUFFER 	0xF8F0	 /* regular sample buffer */
-#define ENE_SAMPLE_SPC_MASK 	(1 << 7) /* sample is space */
-#define ENE_SAMPLE_VALUE_MASK	0x7F
-#define ENE_SAMPLE_OVERFLOW	0x7F
-#define ENE_SAMPLES_SIZE	4
-
-/* fan input sample buffer */
-#define ENE_SAMPLE_BUFFER_FAN	0xF8FB	 /* this buffer holds high byte of */
-					 /* each sample of normal buffer */
-
-#define ENE_FAN_SMPL_PULS_MSK	0x8000	 /* this bit of combined sample */
-					 /* if set, says that sample is pulse */
-#define ENE_FAN_VALUE_MASK	0x0FFF   /* mask for valid bits of the value */
-
-/* first firmware register */
-#define ENE_FW1			0xF8F8
-#define	ENE_FW1_ENABLE		(1 << 0) /* enable fw processing */
-#define ENE_FW1_TXIRQ		(1 << 1) /* TX interrupt pending */
-#define ENE_FW1_WAKE		(1 << 6) /* enable wake from S3 */
-#define ENE_FW1_IRQ		(1 << 7) /* enable interrupt */
-
-/* second firmware register */
-#define ENE_FW2			0xF8F9
-#define ENE_FW2_BUF_HIGH	(1 << 0) /* which half of the buffer to read */
-#define ENE_FW2_IRQ_CLR		(1 << 2) /* clear this on IRQ */
-#define ENE_FW2_GP40_AS_LEARN	(1 << 4) /* normal input is used as */
-					 /* learning input */
-#define ENE_FW2_FAN_AS_NRML_IN	(1 << 6) /* fan is used as normal input */
-#define ENE_FW2_LEARNING	(1 << 7) /* hardware supports learning and TX */
-
-/* fan as input settings - only if learning capable */
-#define ENE_FAN_AS_IN1		0xFE30   /* fan init reg 1 */
-#define ENE_FAN_AS_IN1_EN	0xCD
-#define ENE_FAN_AS_IN2		0xFE31   /* fan init reg 2 */
-#define ENE_FAN_AS_IN2_EN	0x03
-#define ENE_SAMPLE_PERIOD_FAN   61	 /* fan input has fixed sample period */
-
-/* IRQ registers block (for revision B) */
-#define ENEB_IRQ		0xFD09	 /* IRQ number */
-#define ENEB_IRQ_UNK1		0xFD17	 /* unknown setting = 1 */
-#define ENEB_IRQ_STATUS		0xFD80	 /* irq status */
-#define ENEB_IRQ_STATUS_IR	(1 << 5) /* IR irq */
-
-/* IRQ registers block (for revision C,D) */
-#define ENEC_IRQ		0xFE9B	 /* new irq settings register */
-#define ENEC_IRQ_MASK		0x0F	 /* irq number mask */
-#define ENEC_IRQ_UNK_EN		(1 << 4) /* always enabled */
-#define ENEC_IRQ_STATUS		(1 << 5) /* irq status and ACK */
-
-/* CIR block settings */
-#define ENE_CIR_CONF1		0xFEC0
-#define ENE_CIR_CONF1_ADC_ON	0x7	 /* reciever on gpio40 enabled */
-#define ENE_CIR_CONF1_LEARN1	(1 << 3) /* enabled on learning mode */
-#define ENE_CIR_CONF1_TX_ON	0x30	 /* enabled on transmit */
-#define ENE_CIR_CONF1_TX_CARR	(1 << 7) /* send TX carrier or not */
-
-#define ENE_CIR_CONF2		0xFEC1	 /* unknown setting = 0 */
-#define ENE_CIR_CONF2_LEARN2	(1 << 4) /* set on enable learning */
-#define ENE_CIR_CONF2_GPIO40DIS	(1 << 5) /* disable normal input via gpio40 */
-
-#define ENE_CIR_SAMPLE_PERIOD	0xFEC8	 /* sample period in us */
-#define ENE_CIR_SAMPLE_OVERFLOW	(1 << 7) /* interrupt on overflows if set */
-
-
-/* transmitter - not implemented yet */
-/* KB3926C and higher */
-/* transmission is very similiar to recieving, a byte is written to */
-/* ENE_TX_INPUT, in same manner as it is read from sample buffer */
-/* sample period is fixed*/
-
-
-/* transmitter ports */
-#define ENE_TX_PORT1		0xFC01	 /* this enables one or both */
-#define ENE_TX_PORT1_EN		(1 << 5) /* TX ports */
-#define ENE_TX_PORT2		0xFC08
-#define ENE_TX_PORT2_EN		(1 << 1)
-
-#define ENE_TX_INPUT		0xFEC9	 /* next byte to transmit */
-#define ENE_TX_SPC_MASK 	(1 << 7) /* Transmitted sample is space */
-#define ENE_TX_UNK1		0xFECB	 /* set to 0x63 */
-#define ENE_TX_SMPL_PERIOD	50	 /* transmit sample period */
-
-
-#define ENE_TX_CARRIER		0xFECE	 /* TX carrier * 2 (khz) */
-#define ENE_TX_CARRIER_UNKBIT	0x80	 /* This bit set on transmit */
-#define ENE_TX_CARRIER_LOW	0xFECF	 /* TX carrier / 2 */
-
-/* Hardware versions */
-#define ENE_HW_VERSION		0xFF00	 /* hardware revision */
-#define ENE_HW_UNK 		0xFF1D
-#define ENE_HW_UNK_CLR		(1 << 2)
-#define ENE_HW_VER_MAJOR	0xFF1E	 /* chip version */
-#define ENE_HW_VER_MINOR	0xFF1F
-#define ENE_HW_VER_OLD		0xFD00
-
-#define same_sign(a, b) ((((a) > 0) && (b) > 0) || ((a) < 0 && (b) < 0))
-
-#define ENE_DRIVER_NAME 	"enecir"
-#define ENE_MAXGAP 		250000	 /* this is amount of time we wait
-					 before turning the sampler, chosen
-					 arbitry */
-
-#define space(len) 	       (-(len))	 /* add a space */
-
-/* software defines */
-#define ENE_IRQ_RX		1
-#define ENE_IRQ_TX		2
-
-#define  ENE_HW_B		1	/* 3926B */
-#define  ENE_HW_C		2	/* 3926C */
-#define  ENE_HW_D		3	/* 3926D */
-
-#define ene_printk(level, text, ...) \
-	printk(level ENE_DRIVER_NAME ": " text, ## __VA_ARGS__)
-
-struct ene_device {
-	struct pnp_dev *pnp_dev;
-	struct lirc_driver *lirc_driver;
-
-	/* hw settings */
-	unsigned long hw_io;
-	int irq;
-
-	int hw_revision;			/* hardware revision */
-	int hw_learning_and_tx_capable;		/* learning capable */
-	int hw_gpio40_learning;			/* gpio40 is learning */
-	int hw_fan_as_normal_input;	/* fan input is used as regular input */
-
-	/* device data */
-	int idle;
-	int fan_input_inuse;
-
-	int sample;
-	int in_use;
-
-	struct timeval gap_start;
-};
-- 
1.7.0.4

