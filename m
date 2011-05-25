Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:4575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757614Ab1EYQfa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 12:35:30 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	Aaron Huang <aaron_huang@fintek.com.tw>,
	Tom Tsai <tom_tsai@fintek.com.tw>
Subject: [PATCH] [media] fintek-cir: new driver for Fintek LPC SuperIO CIR function
Date: Wed, 25 May 2011 12:35:13 -0400
Message-Id: <1306341313-12888-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a new driver for the Fintek LPC SuperIO CIR function, in the
Fintek F71809 chip. Hardware and datasheets were provided by Fintek, so
thanks go to them for supporting this effort.

This driver started out as a copy of the nuvoton-cir driver, and was
then modified as needed for the Fintek chip. The two share many
similaries, though the buffer handling for the Fintek chip is actually
nearly identical to the mceusb buffer handling, so the parser routine is
almost a drop-in copy of the mceusb buffer parser (a candidate for being
abstracted out into shared code at some point).

This initial code drop *only* supports receive, but the hardware does
support transmit as well. I really haven't even started to look at
what's required, but my guess is that its also pretty similar to mceusb.
Most people are probably only really interested in RX anyway though, so
I think its good to get this out there even with only RX.

(Nb: there are also Fintek-made mceusb receivers, which presumably, this
chip shares CIR hardware with).

This hardware can be found on at least Jetway NC98 boards and derivative
systems, and likely others as well. Functionality was tested with an
NC98 development board, in-kernel decode of RC6 (mce), RC5 (hauppauge)
and NEC-ish (tivo) remotes all successful, as was lirc userspace decode
of the RC6 remote.

CC: Aaron Huang <aaron_huang@fintek.com.tw>
CC: Tom Tsai <tom_tsai@fintek.com.tw>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/Kconfig      |   12 +
 drivers/media/rc/Makefile     |    1 +
 drivers/media/rc/fintek-cir.c |  684 +++++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/fintek-cir.h |  243 +++++++++++++++
 4 files changed, 940 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/rc/fintek-cir.c
 create mode 100644 drivers/media/rc/fintek-cir.h

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 154c337..7d4bbc2 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -148,6 +148,18 @@ config IR_ITE_CIR
 	   To compile this driver as a module, choose M here: the
 	   module will be called ite-cir.
 
+config IR_FINTEK
+	tristate "Fintek Consumer Infrared Transceiver"
+	depends on PNP
+	depends on RC_CORE
+	---help---
+	   Say Y here to enable support for integrated infrared receiver
+	   /transciever made by Fintek. This chip is found on assorted
+	   Jetway motherboards (and of course, possibly others).
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called fintek-cir.
+
 config IR_NUVOTON
 	tristate "Nuvoton w836x7hg Consumer Infrared Transceiver"
 	depends on PNP
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 1f90a21..52830e5 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
 obj-$(CONFIG_IR_IMON) += imon.o
 obj-$(CONFIG_IR_ITE_CIR) += ite-cir.o
 obj-$(CONFIG_IR_MCEUSB) += mceusb.o
+obj-$(CONFIG_IR_FINTEK) += fintek-cir.o
 obj-$(CONFIG_IR_NUVOTON) += nuvoton-cir.o
 obj-$(CONFIG_IR_ENE) += ene_ir.o
 obj-$(CONFIG_IR_REDRAT3) += redrat3.o
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
new file mode 100644
index 0000000..8fa539d
--- /dev/null
+++ b/drivers/media/rc/fintek-cir.c
@@ -0,0 +1,684 @@
+/*
+ * Driver for Feature Integration Technology Inc. (aka Fintek) LPC CIR
+ *
+ * Copyright (C) 2011 Jarod Wilson <jarod@redhat.com>
+ *
+ * Special thanks to Fintek for providing hardware and spec sheets.
+ * This driver is based upon the nuvoton, ite and ene drivers for
+ * similar hardware.
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
+#include <media/rc-core.h>
+#include <linux/pci_ids.h>
+
+#include "fintek-cir.h"
+
+/* write val to config reg */
+static inline void fintek_cr_write(struct fintek_dev *fintek, u8 val, u8 reg)
+{
+	fit_dbg("%s: reg 0x%02x, val 0x%02x  (ip/dp: %02x/%02x)",
+		__func__, reg, val, fintek->cr_ip, fintek->cr_dp);
+	outb(reg, fintek->cr_ip);
+	outb(val, fintek->cr_dp);
+}
+
+/* read val from config reg */
+static inline u8 fintek_cr_read(struct fintek_dev *fintek, u8 reg)
+{
+	u8 val;
+
+	outb(reg, fintek->cr_ip);
+	val = inb(fintek->cr_dp);
+
+	fit_dbg("%s: reg 0x%02x, val 0x%02x  (ip/dp: %02x/%02x)",
+		__func__, reg, val, fintek->cr_ip, fintek->cr_dp);
+	return val;
+}
+
+/* update config register bit without changing other bits */
+static inline void fintek_set_reg_bit(struct fintek_dev *fintek, u8 val, u8 reg)
+{
+	u8 tmp = fintek_cr_read(fintek, reg) | val;
+	fintek_cr_write(fintek, tmp, reg);
+}
+
+/* clear config register bit without changing other bits */
+static inline void fintek_clear_reg_bit(struct fintek_dev *fintek, u8 val, u8 reg)
+{
+	u8 tmp = fintek_cr_read(fintek, reg) & ~val;
+	fintek_cr_write(fintek, tmp, reg);
+}
+
+/* enter config mode */
+static inline void fintek_config_mode_enable(struct fintek_dev *fintek)
+{
+	/* Enabling Config Mode explicitly requires writing 2x */
+	outb(CONFIG_REG_ENABLE, fintek->cr_ip);
+	outb(CONFIG_REG_ENABLE, fintek->cr_ip);
+}
+
+/* exit config mode */
+static inline void fintek_config_mode_disable(struct fintek_dev *fintek)
+{
+	outb(CONFIG_REG_DISABLE, fintek->cr_ip);
+}
+
+/*
+ * When you want to address a specific logical device, write its logical
+ * device number to GCR_LOGICAL_DEV_NO
+ */
+static inline void fintek_select_logical_dev(struct fintek_dev *fintek, u8 ldev)
+{
+	fintek_cr_write(fintek, ldev, GCR_LOGICAL_DEV_NO);
+}
+
+/* write val to cir config register */
+static inline void fintek_cir_reg_write(struct fintek_dev *fintek, u8 val, u8 offset)
+{
+	outb(val, fintek->cir_addr + offset);
+}
+
+/* read val from cir config register */
+static u8 fintek_cir_reg_read(struct fintek_dev *fintek, u8 offset)
+{
+	u8 val;
+
+	val = inb(fintek->cir_addr + offset);
+
+	return val;
+}
+
+#define pr_reg(text, ...) \
+	printk(KERN_INFO KBUILD_MODNAME ": " text, ## __VA_ARGS__)
+
+/* dump current cir register contents */
+static void cir_dump_regs(struct fintek_dev *fintek)
+{
+	fintek_config_mode_enable(fintek);
+	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+
+	pr_reg("%s: Dump CIR logical device registers:\n", FINTEK_DRIVER_NAME);
+	pr_reg(" * CR CIR BASE ADDR: 0x%x\n",
+	       (fintek_cr_read(fintek, CIR_CR_BASE_ADDR_HI) << 8) |
+		fintek_cr_read(fintek, CIR_CR_BASE_ADDR_LO));
+	pr_reg(" * CR CIR IRQ NUM:   0x%x\n",
+	       fintek_cr_read(fintek, CIR_CR_IRQ_SEL));
+
+	fintek_config_mode_disable(fintek);
+
+	pr_reg("%s: Dump CIR registers:\n", FINTEK_DRIVER_NAME);
+	pr_reg(" * STATUS:     0x%x\n", fintek_cir_reg_read(fintek, CIR_STATUS));
+	pr_reg(" * CONTROL:    0x%x\n", fintek_cir_reg_read(fintek, CIR_CONTROL));
+	pr_reg(" * RX_DATA:    0x%x\n", fintek_cir_reg_read(fintek, CIR_RX_DATA));
+	pr_reg(" * TX_CONTROL: 0x%x\n", fintek_cir_reg_read(fintek, CIR_TX_CONTROL));
+	pr_reg(" * TX_DATA:    0x%x\n", fintek_cir_reg_read(fintek, CIR_TX_DATA));
+}
+
+/* detect hardware features */
+static int fintek_hw_detect(struct fintek_dev *fintek)
+{
+	unsigned long flags;
+	u8 chip_major, chip_minor;
+	u8 vendor_major, vendor_minor;
+	u8 portsel, ir_class;
+	u16 vendor;
+	int ret = 0;
+
+	fintek_config_mode_enable(fintek);
+
+	/* Check if we're using config port 0x4e or 0x2e */
+	portsel = fintek_cr_read(fintek, GCR_CONFIG_PORT_SEL);
+	if (portsel == 0xff) {
+		fit_pr(KERN_INFO, "first portsel read was bunk, trying alt");
+		fintek_config_mode_disable(fintek);
+		fintek->cr_ip = CR_INDEX_PORT2;
+		fintek->cr_dp = CR_DATA_PORT2;
+		fintek_config_mode_enable(fintek);
+		portsel = fintek_cr_read(fintek, GCR_CONFIG_PORT_SEL);
+	}
+	fit_dbg("portsel reg: 0x%02x", portsel);
+
+	ir_class = fintek_cir_reg_read(fintek, CIR_CR_CLASS);
+	fit_dbg("ir_class reg: 0x%02x", ir_class);
+
+	switch (ir_class) {
+	case CLASS_RX_2TX:
+	case CLASS_RX_1TX:
+		fintek->hw_tx_capable = true;
+		break;
+	case CLASS_RX_ONLY:
+	default:
+		fintek->hw_tx_capable = false;
+		break;
+	}
+
+	chip_major = fintek_cr_read(fintek, GCR_CHIP_ID_HI);
+	chip_minor = fintek_cr_read(fintek, GCR_CHIP_ID_LO);
+
+	vendor_major = fintek_cr_read(fintek, GCR_VENDOR_ID_HI);
+	vendor_minor = fintek_cr_read(fintek, GCR_VENDOR_ID_LO);
+	vendor = vendor_major << 8 | vendor_minor;
+
+	if (vendor != VENDOR_ID_FINTEK)
+		fit_pr(KERN_WARNING, "Unknown vendor ID: 0x%04x", vendor);
+	else
+		fit_dbg("Read Fintek vendor ID from chip");
+
+	fintek_config_mode_disable(fintek);
+
+	spin_lock_irqsave(&fintek->fintek_lock, flags);
+	fintek->chip_major  = chip_major;
+	fintek->chip_minor  = chip_minor;
+	fintek->chip_vendor = vendor;
+	spin_unlock_irqrestore(&fintek->fintek_lock, flags);
+
+	return ret;
+}
+
+static void fintek_cir_ldev_init(struct fintek_dev *fintek)
+{
+	/* Select CIR logical device and enable */
+	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+	fintek_cr_write(fintek, LOGICAL_DEV_ENABLE, CIR_CR_DEV_EN);
+
+	/* Write allocated CIR address and IRQ information to hardware */
+	fintek_cr_write(fintek, fintek->cir_addr >> 8, CIR_CR_BASE_ADDR_HI);
+	fintek_cr_write(fintek, fintek->cir_addr & 0xff, CIR_CR_BASE_ADDR_LO);
+
+	fintek_cr_write(fintek, fintek->cir_irq, CIR_CR_IRQ_SEL);
+
+	fit_dbg("CIR initialized, base io address: 0x%lx, irq: %d (len: %d)",
+		fintek->cir_addr, fintek->cir_irq, fintek->cir_port_len);
+}
+
+/* enable CIR interrupts */
+static void fintek_enable_cir_irq(struct fintek_dev *fintek)
+{
+	fintek_cir_reg_write(fintek, CIR_STATUS_IRQ_EN, CIR_STATUS);
+}
+
+static void fintek_cir_regs_init(struct fintek_dev *fintek)
+{
+	/* clear any and all stray interrupts */
+	fintek_cir_reg_write(fintek, CIR_STATUS_IRQ_MASK, CIR_STATUS);
+
+	/* and finally, enable interrupts */
+	fintek_enable_cir_irq(fintek);
+}
+
+static void fintek_enable_wake(struct fintek_dev *fintek)
+{
+	fintek_config_mode_enable(fintek);
+	fintek_select_logical_dev(fintek, LOGICAL_DEV_ACPI);
+
+	/* Allow CIR PME's to wake system */
+	fintek_set_reg_bit(fintek, ACPI_WAKE_EN_CIR_BIT, LDEV_ACPI_WAKE_EN_REG);
+	/* Enable CIR PME's */
+	fintek_set_reg_bit(fintek, ACPI_PME_CIR_BIT, LDEV_ACPI_PME_EN_REG);
+	/* Clear CIR PME status register */
+	fintek_set_reg_bit(fintek, ACPI_PME_CIR_BIT, LDEV_ACPI_PME_CLR_REG);
+	/* Save state */
+	fintek_set_reg_bit(fintek, ACPI_STATE_CIR_BIT, LDEV_ACPI_STATE_REG);
+
+	fintek_config_mode_disable(fintek);
+}
+
+static int fintek_cmdsize(u8 cmd, u8 subcmd)
+{
+	int datasize = 0;
+
+	switch (cmd) {
+	case BUF_COMMAND_NULL:
+		if (subcmd == BUF_HW_CMD_HEADER)
+			datasize = 1;
+		break;
+	case BUF_HW_CMD_HEADER:
+		if (subcmd == BUF_CMD_G_REVISION)
+			datasize = 2;
+		break;
+	case BUF_COMMAND_HEADER:
+		switch (subcmd) {
+		case BUF_CMD_S_CARRIER:
+		case BUF_CMD_S_TIMEOUT:
+		case BUF_RSP_PULSE_COUNT:
+			datasize = 2;
+			break;
+		case BUF_CMD_SIG_END:
+		case BUF_CMD_S_TXMASK:
+		case BUF_CMD_S_RXSENSOR:
+			datasize = 1;
+			break;
+		}
+	}
+
+	return datasize;
+}
+
+/* process ir data stored in driver buffer */
+static void fintek_process_rx_ir_data(struct fintek_dev *fintek)
+{
+	DEFINE_IR_RAW_EVENT(rawir);
+	u8 sample;
+	int i;
+
+	for (i = 0; i < fintek->pkts; i++) {
+		sample = fintek->buf[i];
+		switch (fintek->parser_state) {
+		case CMD_HEADER:
+			fintek->cmd = sample;
+			if ((fintek->cmd == BUF_COMMAND_HEADER) ||
+			    ((fintek->cmd & BUF_COMMAND_MASK) !=
+			     BUF_PULSE_BIT)) {
+				fintek->parser_state = SUBCMD;
+				continue;
+			}
+			fintek->rem = (fintek->cmd & BUF_LEN_MASK);
+			fit_dbg("%s: rem: 0x%02x", __func__, fintek->rem);
+			if (fintek->rem)
+				fintek->parser_state = PARSE_IRDATA;
+			else
+				ir_raw_event_reset(fintek->rdev);
+			break;
+		case SUBCMD:
+			fintek->rem = fintek_cmdsize(fintek->cmd, sample);
+			fintek->parser_state = CMD_DATA;
+			break;
+		case CMD_DATA:
+			fintek->rem--;
+			break;
+		case PARSE_IRDATA:
+			fintek->rem--;
+			init_ir_raw_event(&rawir);
+			rawir.pulse = ((sample & BUF_PULSE_BIT) != 0);
+			rawir.duration = US_TO_NS((sample & BUF_SAMPLE_MASK)
+					  * CIR_SAMPLE_PERIOD);
+
+			fit_dbg("Storing %s with duration %d",
+				rawir.pulse ? "pulse" : "space",
+				rawir.duration);
+			ir_raw_event_store_with_filter(fintek->rdev, &rawir);
+			break;
+		}
+
+		if ((fintek->parser_state != CMD_HEADER) && !fintek->rem)
+			fintek->parser_state = CMD_HEADER;
+	}
+
+	fintek->pkts = 0;
+
+	fit_dbg("Calling ir_raw_event_handle");
+	ir_raw_event_handle(fintek->rdev);
+}
+
+/* copy data from hardware rx register into driver buffer */
+static void fintek_get_rx_ir_data(struct fintek_dev *fintek, u8 rx_irqs)
+{
+	unsigned long flags;
+	u8 sample, status;
+
+	spin_lock_irqsave(&fintek->fintek_lock, flags);
+
+	/*
+	 * We must read data from CIR_RX_DATA until the hardware IR buffer
+	 * is empty and clears the RX_TIMEOUT and/or RX_RECEIVE flags in
+	 * the CIR_STATUS register
+	 */
+	do {
+		sample = fintek_cir_reg_read(fintek, CIR_RX_DATA);
+		fit_dbg("%s: sample: 0x%02x", __func__, sample);
+
+		fintek->buf[fintek->pkts] = sample;
+		fintek->pkts++;
+
+		status = fintek_cir_reg_read(fintek, CIR_STATUS);
+		if (!(status & CIR_STATUS_IRQ_EN))
+			break;
+	} while (status & rx_irqs);
+
+	fintek_process_rx_ir_data(fintek);
+
+	spin_unlock_irqrestore(&fintek->fintek_lock, flags);
+}
+
+static void fintek_cir_log_irqs(u8 status)
+{
+	fit_pr(KERN_INFO, "IRQ 0x%02x:%s%s%s%s%s", status,
+		status & CIR_STATUS_IRQ_EN	? " IRQEN"	: "",
+		status & CIR_STATUS_TX_FINISH	? " TXF"	: "",
+		status & CIR_STATUS_TX_UNDERRUN	? " TXU"	: "",
+		status & CIR_STATUS_RX_TIMEOUT	? " RXTO"	: "",
+		status & CIR_STATUS_RX_RECEIVE	? " RXOK"	: "");
+}
+
+/* interrupt service routine for incoming and outgoing CIR data */
+static irqreturn_t fintek_cir_isr(int irq, void *data)
+{
+	struct fintek_dev *fintek = data;
+	u8 status, rx_irqs;
+
+	fit_dbg_verbose("%s firing", __func__);
+
+	fintek_config_mode_enable(fintek);
+	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+	fintek_config_mode_disable(fintek);
+
+	/*
+	 * Get IR Status register contents. Write 1 to ack/clear
+	 *
+	 * bit: reg name    - description
+	 *   3: TX_FINISH   - TX is finished
+	 *   2: TX_UNDERRUN - TX underrun
+	 *   1: RX_TIMEOUT  - RX data timeout
+	 *   0: RX_RECEIVE  - RX data received
+	 */
+	status = fintek_cir_reg_read(fintek, CIR_STATUS);
+	if (!(status & CIR_STATUS_IRQ_MASK) || status == 0xff) {
+		fit_dbg_verbose("%s exiting, IRSTS 0x%02x", __func__, status);
+		fintek_cir_reg_write(fintek, CIR_STATUS_IRQ_MASK, CIR_STATUS);
+		return IRQ_RETVAL(IRQ_NONE);
+	}
+
+	if (debug)
+		fintek_cir_log_irqs(status);
+
+	rx_irqs = status & (CIR_STATUS_RX_RECEIVE | CIR_STATUS_RX_TIMEOUT);
+	if (rx_irqs)
+		fintek_get_rx_ir_data(fintek, rx_irqs);
+
+	/* ack/clear all irq flags we've got */
+	fintek_cir_reg_write(fintek, status, CIR_STATUS);
+
+	fit_dbg_verbose("%s done", __func__);
+	return IRQ_RETVAL(IRQ_HANDLED);
+}
+
+static void fintek_enable_cir(struct fintek_dev *fintek)
+{
+	/* set IRQ enabled */
+	fintek_cir_reg_write(fintek, CIR_STATUS_IRQ_EN, CIR_STATUS);
+
+	fintek_config_mode_enable(fintek);
+
+	/* enable the CIR logical device */
+	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+	fintek_cr_write(fintek, LOGICAL_DEV_ENABLE, CIR_CR_DEV_EN);
+
+	fintek_config_mode_disable(fintek);
+
+	/* clear all pending interrupts */
+	fintek_cir_reg_write(fintek, CIR_STATUS_IRQ_MASK, CIR_STATUS);
+
+	/* enable interrupts */
+	fintek_enable_cir_irq(fintek);
+}
+
+static void fintek_disable_cir(struct fintek_dev *fintek)
+{
+	fintek_config_mode_enable(fintek);
+
+	/* disable the CIR logical device */
+	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+	fintek_cr_write(fintek, LOGICAL_DEV_DISABLE, CIR_CR_DEV_EN);
+
+	fintek_config_mode_disable(fintek);
+}
+
+static int fintek_open(struct rc_dev *dev)
+{
+	struct fintek_dev *fintek = dev->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fintek->fintek_lock, flags);
+	fintek_enable_cir(fintek);
+	spin_unlock_irqrestore(&fintek->fintek_lock, flags);
+
+	return 0;
+}
+
+static void fintek_close(struct rc_dev *dev)
+{
+	struct fintek_dev *fintek = dev->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fintek->fintek_lock, flags);
+	fintek_disable_cir(fintek);
+	spin_unlock_irqrestore(&fintek->fintek_lock, flags);
+}
+
+/* Allocate memory, probe hardware, and initialize everything */
+static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
+{
+	struct fintek_dev *fintek;
+	struct rc_dev *rdev;
+	int ret = -ENOMEM;
+
+	fintek = kzalloc(sizeof(struct fintek_dev), GFP_KERNEL);
+	if (!fintek)
+		return ret;
+
+	/* input device for IR remote (and tx) */
+	rdev = rc_allocate_device();
+	if (!rdev)
+		goto failure;
+
+	ret = -ENODEV;
+	/* validate pnp resources */
+	if (!pnp_port_valid(pdev, 0)) {
+		dev_err(&pdev->dev, "IR PNP Port not valid!\n");
+		goto failure;
+	}
+
+	if (!pnp_irq_valid(pdev, 0)) {
+		dev_err(&pdev->dev, "IR PNP IRQ not valid!\n");
+		goto failure;
+	}
+
+	fintek->cir_addr = pnp_port_start(pdev, 0);
+	fintek->cir_irq  = pnp_irq(pdev, 0);
+	fintek->cir_port_len = pnp_port_len(pdev, 0);
+
+	fintek->cr_ip = CR_INDEX_PORT;
+	fintek->cr_dp = CR_DATA_PORT;
+
+	spin_lock_init(&fintek->fintek_lock);
+
+	ret = -EBUSY;
+	/* now claim resources */
+	if (!request_region(fintek->cir_addr,
+			    fintek->cir_port_len, FINTEK_DRIVER_NAME))
+		goto failure;
+
+	if (request_irq(fintek->cir_irq, fintek_cir_isr, IRQF_SHARED,
+			FINTEK_DRIVER_NAME, (void *)fintek))
+		goto failure;
+
+	pnp_set_drvdata(pdev, fintek);
+	fintek->pdev = pdev;
+
+	ret = fintek_hw_detect(fintek);
+	if (ret)
+		goto failure;
+
+	/* Initialize CIR & CIR Wake Logical Devices */
+	fintek_config_mode_enable(fintek);
+	fintek_cir_ldev_init(fintek);
+	fintek_config_mode_disable(fintek);
+
+	/* Initialize CIR & CIR Wake Config Registers */
+	fintek_cir_regs_init(fintek);
+
+	/* Set up the rc device */
+	rdev->priv = fintek;
+	rdev->driver_type = RC_DRIVER_IR_RAW;
+	rdev->allowed_protos = RC_TYPE_ALL;
+	rdev->open = fintek_open;
+	rdev->close = fintek_close;
+	rdev->input_name = FINTEK_DESCRIPTION;
+	rdev->input_phys = "fintek/cir0";
+	rdev->input_id.bustype = BUS_HOST;
+	rdev->input_id.vendor = VENDOR_ID_FINTEK;
+	rdev->input_id.product = fintek->chip_major;
+	rdev->input_id.version = fintek->chip_minor;
+	rdev->dev.parent = &pdev->dev;
+	rdev->driver_name = FINTEK_DRIVER_NAME;
+	rdev->map_name = RC_MAP_RC6_MCE;
+	rdev->timeout = US_TO_NS(1000);
+	/* rx resolution is hardwired to 50us atm, 1, 25, 100 also possible */
+	rdev->rx_resolution = US_TO_NS(CIR_SAMPLE_PERIOD);
+
+	ret = rc_register_device(rdev);
+	if (ret)
+		goto failure;
+
+	device_init_wakeup(&pdev->dev, true);
+	fintek->rdev = rdev;
+	fit_pr(KERN_NOTICE, "driver has been successfully loaded\n");
+	if (debug)
+		cir_dump_regs(fintek);
+
+	return 0;
+
+failure:
+	if (fintek->cir_irq)
+		free_irq(fintek->cir_irq, fintek);
+	if (fintek->cir_addr)
+		release_region(fintek->cir_addr, fintek->cir_port_len);
+
+	rc_free_device(rdev);
+	kfree(fintek);
+
+	return ret;
+}
+
+static void __devexit fintek_remove(struct pnp_dev *pdev)
+{
+	struct fintek_dev *fintek = pnp_get_drvdata(pdev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&fintek->fintek_lock, flags);
+	/* disable CIR */
+	fintek_disable_cir(fintek);
+	fintek_cir_reg_write(fintek, CIR_STATUS_IRQ_MASK, CIR_STATUS);
+	/* enable CIR Wake (for IR power-on) */
+	fintek_enable_wake(fintek);
+	spin_unlock_irqrestore(&fintek->fintek_lock, flags);
+
+	/* free resources */
+	free_irq(fintek->cir_irq, fintek);
+	release_region(fintek->cir_addr, fintek->cir_port_len);
+
+	rc_unregister_device(fintek->rdev);
+
+	kfree(fintek);
+}
+
+static int fintek_suspend(struct pnp_dev *pdev, pm_message_t state)
+{
+	struct fintek_dev *fintek = pnp_get_drvdata(pdev);
+
+	fit_dbg("%s called", __func__);
+
+	/* disable all CIR interrupts */
+	fintek_cir_reg_write(fintek, CIR_STATUS_IRQ_MASK, CIR_STATUS);
+
+	fintek_config_mode_enable(fintek);
+
+	/* disable cir logical dev */
+	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+	fintek_cr_write(fintek, LOGICAL_DEV_DISABLE, CIR_CR_DEV_EN);
+
+	fintek_config_mode_disable(fintek);
+
+	/* make sure wake is enabled */
+	fintek_enable_wake(fintek);
+
+	return 0;
+}
+
+static int fintek_resume(struct pnp_dev *pdev)
+{
+	int ret = 0;
+	struct fintek_dev *fintek = pnp_get_drvdata(pdev);
+
+	fit_dbg("%s called", __func__);
+
+	/* open interrupt */
+	fintek_enable_cir_irq(fintek);
+
+	/* Enable CIR logical device */
+	fintek_config_mode_enable(fintek);
+	fintek_select_logical_dev(fintek, LOGICAL_DEV_CIR);
+	fintek_cr_write(fintek, LOGICAL_DEV_ENABLE, CIR_CR_DEV_EN);
+
+	fintek_config_mode_disable(fintek);
+
+	fintek_cir_regs_init(fintek);
+
+	return ret;
+}
+
+static void fintek_shutdown(struct pnp_dev *pdev)
+{
+	struct fintek_dev *fintek = pnp_get_drvdata(pdev);
+	fintek_enable_wake(fintek);
+}
+
+static const struct pnp_device_id fintek_ids[] = {
+	{ "FIT0002", 0 },   /* CIR */
+	{ "", 0 },
+};
+
+static struct pnp_driver fintek_driver = {
+	.name		= FINTEK_DRIVER_NAME,
+	.id_table	= fintek_ids,
+	.flags		= PNP_DRIVER_RES_DO_NOT_CHANGE,
+	.probe		= fintek_probe,
+	.remove		= __devexit_p(fintek_remove),
+	.suspend	= fintek_suspend,
+	.resume		= fintek_resume,
+	.shutdown	= fintek_shutdown,
+};
+
+int fintek_init(void)
+{
+	return pnp_register_driver(&fintek_driver);
+}
+
+void fintek_exit(void)
+{
+	pnp_unregister_driver(&fintek_driver);
+}
+
+module_param(debug, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "Enable debugging output");
+
+MODULE_DEVICE_TABLE(pnp, fintek_ids);
+MODULE_DESCRIPTION(FINTEK_DESCRIPTION " driver");
+
+MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
+MODULE_LICENSE("GPL");
+
+module_init(fintek_init);
+module_exit(fintek_exit);
diff --git a/drivers/media/rc/fintek-cir.h b/drivers/media/rc/fintek-cir.h
new file mode 100644
index 0000000..1b10b20
--- /dev/null
+++ b/drivers/media/rc/fintek-cir.h
@@ -0,0 +1,243 @@
+/*
+ * Driver for Feature Integration Technology Inc. (aka Fintek) LPC CIR
+ *
+ * Copyright (C) 2011 Jarod Wilson <jarod@redhat.com>
+ *
+ * Special thanks to Fintek for providing hardware and spec sheets.
+ * This driver is based upon the nuvoton, ite and ene drivers for
+ * similar hardware.
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
+#include <linux/spinlock.h>
+#include <linux/ioctl.h>
+
+/* platform driver name to register */
+#define FINTEK_DRIVER_NAME	"fintek-cir"
+#define FINTEK_DESCRIPTION	"Fintek LPC SuperIO Consumer IR Transceiver"
+#define VENDOR_ID_FINTEK	0x1934
+
+
+/* debugging module parameter */
+static int debug;
+
+#define fit_pr(level, text, ...) \
+	printk(level KBUILD_MODNAME ": " text, ## __VA_ARGS__)
+
+#define fit_dbg(text, ...) \
+	if (debug) \
+		printk(KERN_DEBUG \
+			KBUILD_MODNAME ": " text "\n" , ## __VA_ARGS__)
+
+#define fit_dbg_verbose(text, ...) \
+	if (debug > 1) \
+		printk(KERN_DEBUG \
+			KBUILD_MODNAME ": " text "\n" , ## __VA_ARGS__)
+
+#define fit_dbg_wake(text, ...) \
+	if (debug > 2) \
+		printk(KERN_DEBUG \
+			KBUILD_MODNAME ": " text "\n" , ## __VA_ARGS__)
+
+
+#define TX_BUF_LEN 256
+#define RX_BUF_LEN 32
+
+struct fintek_dev {
+	struct pnp_dev *pdev;
+	struct rc_dev *rdev;
+
+	spinlock_t fintek_lock;
+
+	/* for rx */
+	u8 buf[RX_BUF_LEN];
+	unsigned int pkts;
+
+	struct {
+		spinlock_t lock;
+		u8 buf[TX_BUF_LEN];
+		unsigned int buf_count;
+		unsigned int cur_buf_num;
+		wait_queue_head_t queue;
+	} tx;
+
+	/* Config register index/data port pair */
+	u8 cr_ip;
+	u8 cr_dp;
+
+	/* hardware I/O settings */
+	unsigned long cir_addr;
+	int cir_irq;
+	int cir_port_len;
+
+	/* hardware id */
+	u8 chip_major;
+	u8 chip_minor;
+	u16 chip_vendor;
+
+	/* hardware features */
+	bool hw_learning_capable;
+	bool hw_tx_capable;
+
+	/* rx settings */
+	bool learning_enabled;
+	bool carrier_detect_enabled;
+
+	enum {
+		CMD_HEADER = 0,
+		SUBCMD,
+		CMD_DATA,
+		PARSE_IRDATA,
+	} parser_state;
+
+	u8 cmd, rem;
+
+	/* carrier period = 1 / frequency */
+	u32 carrier;
+};
+
+/* buffer packet constants, largely identical to mceusb.c */
+#define BUF_PULSE_BIT		0x80
+#define BUF_LEN_MASK		0x1f
+#define BUF_SAMPLE_MASK		0x7f
+
+#define BUF_COMMAND_HEADER	0x9f
+#define BUF_COMMAND_MASK	0xe0
+#define BUF_COMMAND_NULL	0x00
+#define BUF_HW_CMD_HEADER	0xff
+#define BUF_CMD_G_REVISION	0x0b
+#define BUF_CMD_S_CARRIER	0x06
+#define BUF_CMD_S_TIMEOUT	0x0c
+#define BUF_CMD_SIG_END		0x01
+#define BUF_CMD_S_TXMASK	0x08
+#define BUF_CMD_S_RXSENSOR	0x14
+#define BUF_RSP_PULSE_COUNT	0x15
+
+#define CIR_SAMPLE_PERIOD	50
+
+/*
+ * Configuration Register:
+ *  Index Port
+ *  Data Port
+ */
+#define CR_INDEX_PORT		0x2e
+#define CR_DATA_PORT		0x2f
+
+/* Possible alternate values, depends on how the chip is wired */
+#define CR_INDEX_PORT2		0x4e
+#define CR_DATA_PORT2		0x4f
+
+/*
+ * GCR_CONFIG_PORT_SEL bit 4 specifies which Index Port value is
+ * active. 1 = 0x4e, 0 = 0x2e
+ */
+#define PORT_SEL_PORT_4E_EN	0x10
+
+/* Extended Function Mode enable/disable magic values */
+#define CONFIG_REG_ENABLE	0x87
+#define CONFIG_REG_DISABLE	0xaa
+
+/* Chip IDs found in CR_CHIP_ID_{HI,LO} */
+#define CHIP_ID_HIGH_F71809U	0x04
+#define CHIP_ID_LOW_F71809U	0x08
+
+/*
+ * Global control regs we need to care about:
+ *      Global Control                  def.
+ *      Register name           addr    val. */
+#define GCR_SOFTWARE_RESET	0x02 /* 0x00 */
+#define GCR_LOGICAL_DEV_NO	0x07 /* 0x00 */
+#define GCR_CHIP_ID_HI		0x20 /* 0x04 */
+#define GCR_CHIP_ID_LO		0x21 /* 0x08 */
+#define GCR_VENDOR_ID_HI	0x23 /* 0x19 */
+#define GCR_VENDOR_ID_LO	0x24 /* 0x34 */
+#define GCR_CONFIG_PORT_SEL	0x25 /* 0x01 */
+#define GCR_KBMOUSE_WAKEUP	0x27
+
+#define LOGICAL_DEV_DISABLE	0x00
+#define LOGICAL_DEV_ENABLE	0x01
+
+/* Logical device number of the CIR function */
+#define LOGICAL_DEV_CIR		0x05
+
+/* CIR Logical Device (LDN 0x08) config registers */
+#define CIR_CR_COMMAND_INDEX	0x04
+#define CIR_CR_IRCS		0x05 /* Before host writes command to IR, host
+					must set to 1. When host finshes write
+					command to IR, host must clear to 0. */
+#define CIR_CR_COMMAND_DATA	0x06 /* Host read or write comand data */
+#define CIR_CR_CLASS		0x07 /* 0xff = rx-only, 0x66 = rx + 2 tx,
+					0x33 = rx + 1 tx */
+#define CIR_CR_DEV_EN		0x30 /* bit0 = 1 enables CIR */
+#define CIR_CR_BASE_ADDR_HI	0x60 /* MSB of CIR IO base addr */
+#define CIR_CR_BASE_ADDR_LO	0x61 /* LSB of CIR IO base addr */
+#define CIR_CR_IRQ_SEL		0x70 /* bits3-0 store CIR IRQ */
+#define CIR_CR_PSOUT_STATUS	0xf1
+#define CIR_CR_WAKE_KEY3_ADDR	0xf8
+#define CIR_CR_WAKE_KEY3_CODE	0xf9
+#define CIR_CR_WAKE_KEY3_DC	0xfa
+#define CIR_CR_WAKE_CONTROL	0xfb
+#define CIR_CR_WAKE_KEY12_ADDR	0xfc
+#define CIR_CR_WAKE_KEY4_ADDR	0xfd
+#define CIR_CR_WAKE_KEY5_ADDR	0xfe
+
+#define CLASS_RX_ONLY		0xff
+#define CLASS_RX_2TX		0x66
+#define CLASS_RX_1TX		0x33
+
+/* CIR device registers */
+#define CIR_STATUS		0x00
+#define CIR_RX_DATA		0x01
+#define CIR_TX_CONTROL		0x02
+#define CIR_TX_DATA		0x03
+#define CIR_CONTROL		0x04
+
+/* Bits to enable CIR wake */
+#define LOGICAL_DEV_ACPI	0x01
+#define LDEV_ACPI_WAKE_EN_REG	0xe8
+#define ACPI_WAKE_EN_CIR_BIT	0x04
+
+#define LDEV_ACPI_PME_EN_REG	0xf0
+#define LDEV_ACPI_PME_CLR_REG	0xf1
+#define ACPI_PME_CIR_BIT	0x02
+
+#define LDEV_ACPI_STATE_REG	0xf4
+#define ACPI_STATE_CIR_BIT	0x20
+
+/*
+ * CIR status register (0x00):
+ *   7 - CIR_IRQ_EN (1 = enable CIR IRQ, 0 = disable)
+ *   3 - TX_FINISH (1 when TX finished, write 1 to clear)
+ *   2 - TX_UNDERRUN (1 on TX underrun, write 1 to clear)
+ *   1 - RX_TIMEOUT (1 on RX timeout, write 1 to clear)
+ *   0 - RX_RECEIVE (1 on RX receive, write 1 to clear)
+ */
+#define CIR_STATUS_IRQ_EN	0x80
+#define CIR_STATUS_TX_FINISH	0x08
+#define CIR_STATUS_TX_UNDERRUN	0x04
+#define CIR_STATUS_RX_TIMEOUT	0x02
+#define CIR_STATUS_RX_RECEIVE	0x01
+#define CIR_STATUS_IRQ_MASK	0x0f
+
+/*
+ * CIR TX control register (0x02):
+ *   7 - TX_START (1 to indicate TX start, auto-cleared when done)
+ *   6 - TX_END (1 to indicate TX data written to TX fifo)
+ */
+#define CIR_TX_CONTROL_TX_START	0x80
+#define CIR_TX_CONTROL_TX_END	0x40
+
-- 
1.7.1

