Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:29237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab0JHOSj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 10:18:39 -0400
Date: Fri, 8 Oct 2010 10:18:25 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net, lcchen@nuvoton.com
Subject: [PATCH] IR: add driver for Nuvoton w836x7hg integrated CIR
Message-ID: <20101008141825.GC5165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a new ir-core pnp driver for the Nuvoton w836x7hg integrated CIR
function. The chip is found on at least the ASRock ION 330HT boxes and
apparently, on a number of Intel DP55-series motherboards:

http://www.asrock.com/nettop/overview.asp?Model=ION%20330HT
http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=17685&lang=eng

This driver was made possible by a hardware donation from Nuvoton, along
with sample code (in the form of an lirc driver) and datasheet, so huge
thanks to them for supporting this effort. Note that this driver
constitutes a massive rewrite, porting from the lirc interfaces to the
ir-core interfaces, and restructuring the driver to look more like Maxim
Levitsky's ene_ir driver (as well as generally making it look more like
kernel code).

There's some work left to be done on this driver, to fully support the
range of functionality possible, but receive and IR power-on/wake are
both functional (may require setting wake key under another OS atm). The
hardware I've got (one of the ASRock boxes) only supports RX, so TX is
completely untested as of yet. Certain RX parameters, like sample
resolution and RX IRQ sample length trigger level could possibly stand
to be made tweakable via modparams or sysfs nodes, but the current
values work well enough for me w/an MCE RC6A remote.

The original lirc driver carried support for the Windows MCE IR
keyboard/mouse device, which I plan to add back generically, in a way
that should be usable by any raw IR receiver (or at least by this driver
and the mceusb driver).

Suspend and resume have also been tested, the power button on my remote
can be used to wake the machine, and CIR functionality resumes just
fine. Module unload/reload has also been tested, though not extensively
or repetitively. Also tested to work with the lirc bridge plugin for
userspace decoding.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/Kconfig       |   13 +
 drivers/media/IR/Makefile      |    1 +
 drivers/media/IR/nuvoton-cir.c | 1216 ++++++++++++++++++++++++++++++++++++++++
 drivers/media/IR/nuvoton-cir.h |  408 ++++++++++++++
 4 files changed, 1638 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/IR/nuvoton-cir.c
 create mode 100644 drivers/media/IR/nuvoton-cir.h

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index 152000d..364514a 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -113,6 +113,19 @@ config IR_IMON
 	   To compile this driver as a module, choose M here: the
 	   module will be called imon.
 
+config IR_NUVOTON
+	tristate "Nuvoton w836x7hg Consumer Infrared Transceiver"
+	depends on PNP
+	depends on IR_CORE
+	---help---
+	   Say Y here to enable support for integrated infrared receiver
+	   /transciever made by Nuvoton (formerly Winbond). This chip is
+	   found in the ASRock ION 330HT, as well as assorted Intel
+	   DP55-series motherboards (and of course, possibly others).
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called nuvoton-cir.
+
 config IR_MCEUSB
 	tristate "Windows Media Center Ed. eHome Infrared Transceiver"
 	depends on USB_ARCH_HAS_HCD
diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index 953c6c4..f9574ad 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -17,5 +17,6 @@ obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
 # stand-alone IR receivers/transmitters
 obj-$(CONFIG_IR_IMON) += imon.o
 obj-$(CONFIG_IR_MCEUSB) += mceusb.o
+obj-$(CONFIG_IR_NUVOTON) += nuvoton-cir.o
 obj-$(CONFIG_IR_ENE) += ene_ir.o
 obj-$(CONFIG_IR_STREAMZAP) += streamzap.o
diff --git a/drivers/media/IR/nuvoton-cir.c b/drivers/media/IR/nuvoton-cir.c
new file mode 100644
index 0000000..1ce9359
--- /dev/null
+++ b/drivers/media/IR/nuvoton-cir.c
@@ -0,0 +1,1216 @@
+/*
+ * Driver for Nuvoton Technology Corporation w83667hg/w83677hg-i CIR
+ *
+ * Copyright (C) 2010 Jarod Wilson <jarod@redhat.com>
+ * Copyright (C) 2009 Nuvoton PS Team
+ *
+ * Special thanks to Nuvoton for providing hardware, spec sheets and
+ * sample code upon which portions of this driver are based. Indirect
+ * thanks also to Maxim Levitsky, whose ene_ir driver this driver is
+ * modeled after.
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
+#include <linux/pci_ids.h>
+
+#include "nuvoton-cir.h"
+
+static char *chip_id = "w836x7hg";
+
+/* write val to config reg */
+static inline void nvt_cr_write(struct nvt_dev *nvt, u8 val, u8 reg)
+{
+	outb(reg, nvt->cr_efir);
+	outb(val, nvt->cr_efdr);
+}
+
+/* read val from config reg */
+static inline u8 nvt_cr_read(struct nvt_dev *nvt, u8 reg)
+{
+	outb(reg, nvt->cr_efir);
+	return inb(nvt->cr_efdr);
+}
+
+/* update config register bit without changing other bits */
+static inline void nvt_set_reg_bit(struct nvt_dev *nvt, u8 val, u8 reg)
+{
+	u8 tmp = nvt_cr_read(nvt, reg) | val;
+	nvt_cr_write(nvt, tmp, reg);
+}
+
+/* clear config register bit without changing other bits */
+static inline void nvt_clear_reg_bit(struct nvt_dev *nvt, u8 val, u8 reg)
+{
+	u8 tmp = nvt_cr_read(nvt, reg) & ~val;
+	nvt_cr_write(nvt, tmp, reg);
+}
+
+/* enter extended function mode */
+static inline void nvt_efm_enable(struct nvt_dev *nvt)
+{
+	/* Enabling Extended Function Mode explicitly requires writing 2x */
+	outb(EFER_EFM_ENABLE, nvt->cr_efir);
+	outb(EFER_EFM_ENABLE, nvt->cr_efir);
+}
+
+/* exit extended function mode */
+static inline void nvt_efm_disable(struct nvt_dev *nvt)
+{
+	outb(EFER_EFM_DISABLE, nvt->cr_efir);
+}
+
+/*
+ * When you want to address a specific logical device, write its logical
+ * device number to CR_LOGICAL_DEV_SEL, then enable/disable by writing
+ * 0x1/0x0 respectively to CR_LOGICAL_DEV_EN.
+ */
+static inline void nvt_select_logical_dev(struct nvt_dev *nvt, u8 ldev)
+{
+	outb(CR_LOGICAL_DEV_SEL, nvt->cr_efir);
+	outb(ldev, nvt->cr_efdr);
+}
+
+/* write val to cir config register */
+static inline void nvt_cir_reg_write(struct nvt_dev *nvt, u8 val, u8 offset)
+{
+	outb(val, nvt->cir_addr + offset);
+}
+
+/* read val from cir config register */
+static u8 nvt_cir_reg_read(struct nvt_dev *nvt, u8 offset)
+{
+	u8 val;
+
+	val = inb(nvt->cir_addr + offset);
+
+	return val;
+}
+
+/* write val to cir wake register */
+static inline void nvt_cir_wake_reg_write(struct nvt_dev *nvt,
+					  u8 val, u8 offset)
+{
+	outb(val, nvt->cir_wake_addr + offset);
+}
+
+/* read val from cir wake config register */
+static u8 nvt_cir_wake_reg_read(struct nvt_dev *nvt, u8 offset)
+{
+	u8 val;
+
+	val = inb(nvt->cir_wake_addr + offset);
+
+	return val;
+}
+
+/* dump current cir register contents */
+static void cir_dump_regs(struct nvt_dev *nvt)
+{
+	nvt_efm_enable(nvt);
+	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
+
+	printk("%s: Dump CIR logical device registers:\n", NVT_DRIVER_NAME);
+	printk(" * CR CIR ACTIVE :   0x%x\n",
+	       nvt_cr_read(nvt, CR_LOGICAL_DEV_EN));
+	printk(" * CR CIR BASE ADDR: 0x%x\n",
+	       (nvt_cr_read(nvt, CR_CIR_BASE_ADDR_HI) << 8) |
+		nvt_cr_read(nvt, CR_CIR_BASE_ADDR_LO));
+	printk(" * CR CIR IRQ NUM:   0x%x\n",
+	       nvt_cr_read(nvt, CR_CIR_IRQ_RSRC));
+
+	nvt_efm_disable(nvt);
+
+	printk("%s: Dump CIR registers:\n", NVT_DRIVER_NAME);
+	printk(" * IRCON:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRCON));
+	printk(" * IRSTS:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRSTS));
+	printk(" * IREN:      0x%x\n", nvt_cir_reg_read(nvt, CIR_IREN));
+	printk(" * RXFCONT:   0x%x\n", nvt_cir_reg_read(nvt, CIR_RXFCONT));
+	printk(" * CP:        0x%x\n", nvt_cir_reg_read(nvt, CIR_CP));
+	printk(" * CC:        0x%x\n", nvt_cir_reg_read(nvt, CIR_CC));
+	printk(" * SLCH:      0x%x\n", nvt_cir_reg_read(nvt, CIR_SLCH));
+	printk(" * SLCL:      0x%x\n", nvt_cir_reg_read(nvt, CIR_SLCL));
+	printk(" * FIFOCON:   0x%x\n", nvt_cir_reg_read(nvt, CIR_FIFOCON));
+	printk(" * IRFIFOSTS: 0x%x\n", nvt_cir_reg_read(nvt, CIR_IRFIFOSTS));
+	printk(" * SRXFIFO:   0x%x\n", nvt_cir_reg_read(nvt, CIR_SRXFIFO));
+	printk(" * TXFCONT:   0x%x\n", nvt_cir_reg_read(nvt, CIR_TXFCONT));
+	printk(" * STXFIFO:   0x%x\n", nvt_cir_reg_read(nvt, CIR_STXFIFO));
+	printk(" * FCCH:      0x%x\n", nvt_cir_reg_read(nvt, CIR_FCCH));
+	printk(" * FCCL:      0x%x\n", nvt_cir_reg_read(nvt, CIR_FCCL));
+	printk(" * IRFSM:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRFSM));
+}
+
+/* dump current cir wake register contents */
+static void cir_wake_dump_regs(struct nvt_dev *nvt)
+{
+	u8 i, fifo_len;
+
+	nvt_efm_enable(nvt);
+	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR_WAKE);
+
+	printk("%s: Dump CIR WAKE logical device registers:\n",
+	       NVT_DRIVER_NAME);
+	printk(" * CR CIR WAKE ACTIVE :   0x%x\n",
+	       nvt_cr_read(nvt, CR_LOGICAL_DEV_EN));
+	printk(" * CR CIR WAKE BASE ADDR: 0x%x\n",
+	       (nvt_cr_read(nvt, CR_CIR_BASE_ADDR_HI) << 8) |
+	        nvt_cr_read(nvt, CR_CIR_BASE_ADDR_LO));
+	printk(" * CR CIR WAKE IRQ NUM:   0x%x\n",
+	       nvt_cr_read(nvt, CR_CIR_IRQ_RSRC));
+
+	nvt_efm_disable(nvt);
+
+	printk("%s: Dump CIR WAKE registers\n", NVT_DRIVER_NAME);
+	printk(" * IRCON:          0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON));
+	printk(" * IRSTS:          0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRSTS));
+	printk(" * IREN:           0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_IREN));
+	printk(" * FIFO CMP DEEP:  0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_CMP_DEEP));
+	printk(" * FIFO CMP TOL:   0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_CMP_TOL));
+	printk(" * FIFO COUNT:     0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_COUNT));
+	printk(" * SLCH:           0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_SLCH));
+	printk(" * SLCL:           0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_SLCL));
+	printk(" * FIFOCON:        0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFOCON));
+	printk(" * SRXFSTS:        0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_SRXFSTS));
+	printk(" * SAMPLE RX FIFO: 0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_SAMPLE_RX_FIFO));
+	printk(" * WR FIFO DATA:   0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_WR_FIFO_DATA));
+	printk(" * RD FIFO ONLY:   0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY));
+	printk(" * RD FIFO ONLY IDX: 0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY_IDX));
+	printk(" * FIFO IGNORE:    0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_IGNORE));
+	printk(" * IRFSM:          0x%x\n",
+	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRFSM));
+
+	fifo_len = nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_COUNT);
+	printk("%s: Dump CIR WAKE FIFO (len %d)\n", NVT_DRIVER_NAME, fifo_len);
+	printk("* Contents = ");
+	for (i = 0; i < fifo_len; i++)
+		printk("%02x ",
+		       nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY));
+	printk("\n");
+}
+
+/* detect hardware features */
+static int nvt_hw_detect(struct nvt_dev *nvt)
+{
+	unsigned long flags;
+	u8 chip_major, chip_minor;
+	int ret = 0;
+
+	nvt_efm_enable(nvt);
+
+	/* Check if we're wired for the alternate EFER setup */
+	chip_major = nvt_cr_read(nvt, CR_CHIP_ID_HI);
+	if (chip_major == 0xff) {
+		nvt->cr_efir = CR_EFIR2;
+		nvt->cr_efdr = CR_EFDR2;
+		nvt_efm_enable(nvt);
+		chip_major = nvt_cr_read(nvt, CR_CHIP_ID_HI);
+	}
+
+	chip_minor = nvt_cr_read(nvt, CR_CHIP_ID_LO);
+	nvt_dbg("%s: chip id: 0x%02x 0x%02x", chip_id, chip_major, chip_minor);
+
+	if (chip_major != CHIP_ID_HIGH &&
+	    (chip_minor != CHIP_ID_LOW || chip_minor != CHIP_ID_LOW2))
+		ret = -ENODEV;
+
+	nvt_efm_disable(nvt);
+
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
+	nvt->chip_major = chip_major;
+	nvt->chip_minor = chip_minor;
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
+	return ret;
+}
+
+static void nvt_cir_ldev_init(struct nvt_dev *nvt)
+{
+	u8 val;
+
+	/* output pin selection (Pin95=CIRRX, Pin96=CIRTX1, WB enabled */
+	val = nvt_cr_read(nvt, CR_OUTPUT_PIN_SEL);
+	val &= OUTPUT_PIN_SEL_MASK;
+	val |= (OUTPUT_ENABLE_CIR | OUTPUT_ENABLE_CIRWB);
+	nvt_cr_write(nvt, val, CR_OUTPUT_PIN_SEL);
+
+	/* Select CIR logical device and enable */
+	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
+	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
+
+	nvt_cr_write(nvt, nvt->cir_addr >> 8, CR_CIR_BASE_ADDR_HI);
+	nvt_cr_write(nvt, nvt->cir_addr & 0xff, CR_CIR_BASE_ADDR_LO);
+
+	nvt_cr_write(nvt, nvt->cir_irq, CR_CIR_IRQ_RSRC);
+
+	nvt_dbg("CIR initialized, base io port address: 0x%lx, irq: %d",
+		nvt->cir_addr, nvt->cir_irq);
+}
+
+static void nvt_cir_wake_ldev_init(struct nvt_dev *nvt)
+{
+	/* Select ACPI logical device, enable it and CIR Wake */
+	nvt_select_logical_dev(nvt, LOGICAL_DEV_ACPI);
+	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
+
+	/* Enable CIR Wake via PSOUT# (Pin60) */
+	nvt_set_reg_bit(nvt, CIR_WAKE_ENABLE_BIT, CR_ACPI_CIR_WAKE);
+
+	/* enable cir interrupt of mouse/keyboard IRQ event */
+	nvt_set_reg_bit(nvt, CIR_INTR_MOUSE_IRQ_BIT, CR_ACPI_IRQ_EVENTS);
+
+	/* enable pme interrupt of cir wakeup event */
+	nvt_set_reg_bit(nvt, PME_INTR_CIR_PASS_BIT, CR_ACPI_IRQ_EVENTS2);
+
+	/* Select CIR Wake logical device and enable */
+	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR_WAKE);
+	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
+
+	nvt_cr_write(nvt, nvt->cir_wake_addr >> 8, CR_CIR_BASE_ADDR_HI);
+	nvt_cr_write(nvt, nvt->cir_wake_addr & 0xff, CR_CIR_BASE_ADDR_LO);
+
+	nvt_cr_write(nvt, nvt->cir_wake_irq, CR_CIR_IRQ_RSRC);
+
+	nvt_dbg("CIR Wake initialized, base io port address: 0x%lx, irq: %d",
+		nvt->cir_wake_addr, nvt->cir_wake_irq);
+}
+
+/* clear out the hardware's cir rx fifo */
+static void nvt_clear_cir_fifo(struct nvt_dev *nvt)
+{
+	u8 val;
+
+	val = nvt_cir_reg_read(nvt, CIR_FIFOCON);
+	nvt_cir_reg_write(nvt, val | CIR_FIFOCON_RXFIFOCLR, CIR_FIFOCON);
+}
+
+/* clear out the hardware's cir wake rx fifo */
+static void nvt_clear_cir_wake_fifo(struct nvt_dev *nvt)
+{
+	u8 val;
+
+	val = nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFOCON);
+	nvt_cir_wake_reg_write(nvt, val | CIR_WAKE_FIFOCON_RXFIFOCLR,
+			       CIR_WAKE_FIFOCON);
+}
+
+/* clear out the hardware's cir tx fifo */
+static void nvt_clear_tx_fifo(struct nvt_dev *nvt)
+{
+	u8 val;
+
+	val = nvt_cir_reg_read(nvt, CIR_FIFOCON);
+	nvt_cir_reg_write(nvt, val | CIR_FIFOCON_TXFIFOCLR, CIR_FIFOCON);
+}
+
+static void nvt_cir_regs_init(struct nvt_dev *nvt)
+{
+	/* set sample limit count (PE interrupt raised when reached) */
+	nvt_cir_reg_write(nvt, CIR_RX_LIMIT_COUNT >> 8, CIR_SLCH);
+	nvt_cir_reg_write(nvt, CIR_RX_LIMIT_COUNT & 0xff, CIR_SLCL);
+
+	/* set fifo irq trigger levels */
+	nvt_cir_reg_write(nvt, CIR_FIFOCON_TX_TRIGGER_LEV |
+			  CIR_FIFOCON_RX_TRIGGER_LEV, CIR_FIFOCON);
+
+	/*
+	 * Enable TX and RX, specify carrier on = low, off = high, and set
+	 * sample period (currently 50us)
+	 */
+	nvt_cir_reg_write(nvt, CIR_IRCON_TXEN | CIR_IRCON_RXEN | CIR_IRCON_RXINV |
+			  CIR_IRCON_SAMPLE_PERIOD_SEL, CIR_IRCON);
+
+	/* clear hardware rx and tx fifos */
+	nvt_clear_cir_fifo(nvt);
+	nvt_clear_tx_fifo(nvt);
+
+	/* clear any and all stray interrupts */
+	nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
+
+	/* and finally, enable RX Trigger Level Read and Packet End interrupts */
+	nvt_cir_reg_write(nvt, CIR_IREN_RTR | CIR_IREN_PE, CIR_IREN);
+}
+
+static void nvt_cir_wake_regs_init(struct nvt_dev *nvt)
+{
+	/* set number of bytes needed for wake key comparison (default 67) */
+	nvt_cir_wake_reg_write(nvt, CIR_WAKE_FIFO_LEN, CIR_WAKE_FIFO_CMP_DEEP);
+
+	/* set tolerance/variance allowed per byte during wake compare */
+	nvt_cir_wake_reg_write(nvt, CIR_WAKE_CMP_TOLERANCE,
+			       CIR_WAKE_FIFO_CMP_TOL);
+
+	/* set sample limit count (PE interrupt raised when reached) */
+	nvt_cir_wake_reg_write(nvt, CIR_RX_LIMIT_COUNT >> 8, CIR_WAKE_SLCH);
+	nvt_cir_wake_reg_write(nvt, CIR_RX_LIMIT_COUNT & 0xff, CIR_WAKE_SLCL);
+
+	/* set cir wake fifo rx trigger level (currently 67) */
+	nvt_cir_wake_reg_write(nvt, CIR_WAKE_FIFOCON_RX_TRIGGER_LEV,
+			       CIR_WAKE_FIFOCON);
+
+	/*
+	 * Enable TX and RX, specific carrier on = low, off = high, and set
+	 * sample period (currently 50us)
+	 */
+	nvt_cir_wake_reg_write(nvt, CIR_WAKE_IRCON_MODE0 | CIR_WAKE_IRCON_RXEN |
+			       CIR_WAKE_IRCON_R | CIR_WAKE_IRCON_RXINV |
+			       CIR_WAKE_IRCON_SAMPLE_PERIOD_SEL,
+			       CIR_WAKE_IRCON);
+
+	/* clear cir wake rx fifo */
+	nvt_clear_cir_wake_fifo(nvt);
+
+	/* clear any and all stray interrupts */
+	nvt_cir_wake_reg_write(nvt, 0xff, CIR_WAKE_IRSTS);
+}
+
+static void nvt_enable_wake(struct nvt_dev *nvt)
+{
+	nvt_efm_enable(nvt);
+
+	nvt_select_logical_dev(nvt, LOGICAL_DEV_ACPI);
+	nvt_set_reg_bit(nvt, CIR_WAKE_ENABLE_BIT, CR_ACPI_CIR_WAKE);
+	nvt_set_reg_bit(nvt, CIR_INTR_MOUSE_IRQ_BIT, CR_ACPI_IRQ_EVENTS);
+	nvt_set_reg_bit(nvt, PME_INTR_CIR_PASS_BIT, CR_ACPI_IRQ_EVENTS2);
+
+	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR_WAKE);
+	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
+
+	nvt_efm_disable(nvt);
+
+	nvt_cir_wake_reg_write(nvt, CIR_WAKE_IRCON_MODE0 | CIR_WAKE_IRCON_RXEN |
+			       CIR_WAKE_IRCON_R | CIR_WAKE_IRCON_RXINV |
+			       CIR_WAKE_IRCON_SAMPLE_PERIOD_SEL, CIR_WAKE_IRCON);
+	nvt_cir_wake_reg_write(nvt, 0xff, CIR_WAKE_IRSTS);
+	nvt_cir_wake_reg_write(nvt, 0, CIR_WAKE_IREN);
+}
+
+/* rx carrier detect only works in learning mode, must be called w/nvt_lock */
+static u32 nvt_rx_carrier_detect(struct nvt_dev *nvt)
+{
+	u32 count, carrier, duration = 0;
+	int i;
+
+	count = nvt_cir_reg_read(nvt, CIR_FCCL) |
+		nvt_cir_reg_read(nvt, CIR_FCCH) << 8;
+
+	for (i = 0; i < nvt->pkts; i++) {
+		if (nvt->buf[i] & BUF_PULSE_BIT)
+			duration += nvt->buf[i] & BUF_LEN_MASK;
+	}
+
+	duration *= SAMPLE_PERIOD;
+
+	if (!count || !duration) {
+		nvt_pr(KERN_NOTICE, "Unable to determine carrier! (c:%u, d:%u)",
+		       count, duration);
+		return 0;
+	}
+
+	carrier = (count * 1000000) / duration;
+
+	if ((carrier > MAX_CARRIER) || (carrier < MIN_CARRIER))
+		nvt_dbg("WTF? Carrier frequency out of range!");
+
+	nvt_dbg("Carrier frequency: %u (count %u, duration %u)",
+		carrier, count, duration);
+
+	return carrier;
+}
+
+/*
+ * set carrier frequency
+ *
+ * set carrier on 2 registers: CP & CC
+ * always set CP as 0x81
+ * set CC by SPEC, CC = 3MHz/carrier - 1
+ */
+static int nvt_set_tx_carrier(void *data, u32 carrier)
+{
+	struct nvt_dev *nvt = data;
+	u16 val;
+
+	nvt_cir_reg_write(nvt, 1, CIR_CP);
+	val = 3000000 / (carrier) - 1;
+	nvt_cir_reg_write(nvt, val & 0xff, CIR_CC);
+
+	nvt_dbg("cp: 0x%x cc: 0x%x\n",
+		nvt_cir_reg_read(nvt, CIR_CP), nvt_cir_reg_read(nvt, CIR_CC));
+
+	return 0;
+}
+
+/*
+ * nvt_tx_ir
+ *
+ * 1) clean TX fifo first (handled by AP)
+ * 2) copy data from user space
+ * 3) disable RX interrupts, enable TX interrupts: TTR & TFU
+ * 4) send 9 packets to TX FIFO to open TTR
+ * in interrupt_handler:
+ * 5) send all data out
+ * go back to write():
+ * 6) disable TX interrupts, re-enable RX interupts
+ *
+ * The key problem of this function is user space data may larger than
+ * driver's data buf length. So nvt_tx_ir() will only copy TX_BUF_LEN data to
+ * buf, and keep current copied data buf num in cur_buf_num. But driver's buf
+ * number may larger than TXFCONT (0xff). So in interrupt_handler, it has to
+ * set TXFCONT as 0xff, until buf_count less than 0xff.
+ */
+static int nvt_tx_ir(void *priv, int *txbuf, u32 n)
+{
+	struct nvt_dev *nvt = priv;
+	unsigned long flags;
+	size_t cur_count;
+	unsigned int i;
+	u8 iren;
+	int ret;
+
+	spin_lock_irqsave(&nvt->tx.lock, flags);
+
+	if (n >= TX_BUF_LEN) {
+		nvt->tx.buf_count = cur_count = TX_BUF_LEN;
+		ret = TX_BUF_LEN;
+	} else {
+		nvt->tx.buf_count = cur_count = n;
+		ret = n;
+	}
+
+	memcpy(nvt->tx.buf, txbuf, nvt->tx.buf_count);
+
+	nvt->tx.cur_buf_num = 0;
+
+	/* save currently enabled interrupts */
+	iren = nvt_cir_reg_read(nvt, CIR_IREN);
+
+	/* now disable all interrupts, save TFU & TTR */
+	nvt_cir_reg_write(nvt, CIR_IREN_TFU | CIR_IREN_TTR, CIR_IREN);
+
+	nvt->tx.tx_state = ST_TX_REPLY;
+
+	nvt_cir_reg_write(nvt, CIR_FIFOCON_TX_TRIGGER_LEV_8 |
+			  CIR_FIFOCON_RXFIFOCLR, CIR_FIFOCON);
+
+	/* trigger TTR interrupt by writing out ones, (yes, it's ugly) */
+	for (i = 0; i < 9; i++)
+		nvt_cir_reg_write(nvt, 0x01, CIR_STXFIFO);
+
+	spin_unlock_irqrestore(&nvt->tx.lock, flags);
+
+	wait_event(nvt->tx.queue, nvt->tx.tx_state == ST_TX_REQUEST);
+
+	spin_lock_irqsave(&nvt->tx.lock, flags);
+	nvt->tx.tx_state = ST_TX_NONE;
+	spin_unlock_irqrestore(&nvt->tx.lock, flags);
+
+	/* restore enabled interrupts to prior state */
+	nvt_cir_reg_write(nvt, iren, CIR_IREN);
+
+	return ret;
+}
+
+/* dump contents of the last rx buffer we got from the hw rx fifo */
+static void nvt_dump_rx_buf(struct nvt_dev *nvt)
+{
+	int i;
+
+	printk("%s (len %d): ", __func__, nvt->pkts);
+	for (i = 0; (i < nvt->pkts) && (i < RX_BUF_LEN); i++)
+		printk("0x%02x ", nvt->buf[i]);
+	printk("\n");
+}
+
+/*
+ * Process raw data in rx driver buffer, store it in raw IR event kfifo,
+ * trigger decode when appropriate.
+ *
+ * We get IR data samples one byte at a time. If the msb is set, its a pulse,
+ * otherwise its a space. The lower 7 bits are the count of SAMPLE_PERIOD
+ * (default 50us) intervals for that pulse/space. A discrete signal is
+ * followed by a series of 0x7f packets, then either 0x7<something> or 0x80
+ * to signal more IR coming (repeats) or end of IR, respectively. We store
+ * sample data in the raw event kfifo until we see 0x7<something> (except f)
+ * or 0x80, at which time, we trigger a decode operation.
+ */
+static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
+{
+	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
+	unsigned int count;
+	u32 carrier;
+	u8 sample;
+	int i;
+
+	nvt_dbg_verbose("%s firing", __func__);
+
+	if (debug)
+		nvt_dump_rx_buf(nvt);
+
+	if (nvt->carrier_detect_enabled)
+		carrier = nvt_rx_carrier_detect(nvt);
+
+	count = nvt->pkts;
+	nvt_dbg_verbose("Processing buffer of len %d", count);
+
+	for (i = 0; i < count; i++) {
+		nvt->pkts--;
+		sample = nvt->buf[i];
+
+		rawir.pulse = ((sample & BUF_PULSE_BIT) != 0);
+		rawir.duration = (sample & BUF_LEN_MASK)
+					* SAMPLE_PERIOD * 1000;
+
+		if ((sample & BUF_LEN_MASK) == BUF_LEN_MASK) {
+			if (nvt->rawir.pulse == rawir.pulse)
+				nvt->rawir.duration += rawir.duration;
+			else {
+				nvt->rawir.duration = rawir.duration;
+				nvt->rawir.pulse = rawir.pulse;
+			}
+			continue;
+		}
+
+		rawir.duration += nvt->rawir.duration;
+		nvt->rawir.duration = 0;
+		nvt->rawir.pulse = rawir.pulse;
+
+		if (sample == BUF_PULSE_BIT)
+			rawir.pulse = false;
+
+		if (rawir.duration) {
+			nvt_dbg("Storing %s with duration %d",
+				rawir.pulse ? "pulse" : "space",
+				rawir.duration);
+
+			ir_raw_event_store(nvt->rdev, &rawir);
+		}
+
+		/*
+		 * BUF_PULSE_BIT indicates end of IR data, BUF_REPEAT_BYTE
+		 * indicates end of IR signal, but new data incoming. In both
+		 * cases, it means we're ready to call ir_raw_event_handle
+		 */
+		if (sample == BUF_PULSE_BIT || ((sample != BUF_LEN_MASK) &&
+		    (sample & BUF_REPEAT_MASK) == BUF_REPEAT_BYTE))
+			ir_raw_event_handle(nvt->rdev);
+	}
+
+	if (nvt->pkts) {
+		nvt_dbg("Odd, pkts should be 0 now... (its %u)", nvt->pkts);
+		nvt->pkts = 0;
+	}
+
+	nvt_dbg_verbose("%s done", __func__);
+}
+
+/* copy data from hardware rx fifo into driver buffer */
+static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
+{
+	unsigned long flags;
+	u8 fifocount, val;
+	unsigned int b_idx;
+	int i;
+
+	/* Get count of how many bytes to read from RX FIFO */
+	fifocount = nvt_cir_reg_read(nvt, CIR_RXFCONT);
+	/* if we get 0xff, probably means the logical dev is disabled */
+	if (fifocount == 0xff)
+		return;
+	/* this would suggest a fifo overrun, not good... */
+	else if (fifocount > RX_BUF_LEN) {
+		nvt_pr(KERN_WARNING, "fifocount %d over fifo len (%d)!",
+		       fifocount, RX_BUF_LEN);
+		return;
+	}
+
+	nvt_dbg("attempting to fetch %u bytes from hw rx fifo", fifocount);
+
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
+
+	b_idx = nvt->pkts;
+
+	/* This should never happen, but lets check anyway... */
+	if (b_idx + fifocount > RX_BUF_LEN) {
+		nvt_process_rx_ir_data(nvt);
+		b_idx = 0;
+	}
+
+	/* Read fifocount bytes from CIR Sample RX FIFO register */
+	for (i = 0; i < fifocount; i++) {
+		val = nvt_cir_reg_read(nvt, CIR_SRXFIFO);
+		nvt->buf[b_idx + i] = val;
+	}
+
+	nvt->pkts += fifocount;
+	nvt_dbg("%s: pkts now %d", __func__, nvt->pkts);
+
+	nvt_process_rx_ir_data(nvt);
+
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+}
+
+static void nvt_cir_log_irqs(u8 status, u8 iren)
+{
+	nvt_pr(KERN_INFO, "IRQ 0x%02x (IREN 0x%02x) :%s%s%s%s%s%s%s%s%s",
+		status, iren,
+		status & CIR_IRSTS_RDR	? " RDR"	: "",
+		status & CIR_IRSTS_RTR	? " RTR"	: "",
+		status & CIR_IRSTS_PE	? " PE"		: "",
+		status & CIR_IRSTS_RFO	? " RFO"	: "",
+		status & CIR_IRSTS_TE	? " TE"		: "",
+		status & CIR_IRSTS_TTR	? " TTR"	: "",
+		status & CIR_IRSTS_TFU	? " TFU"	: "",
+		status & CIR_IRSTS_GH	? " GH"		: "",
+		status & ~(CIR_IRSTS_RDR | CIR_IRSTS_RTR | CIR_IRSTS_PE |
+			   CIR_IRSTS_RFO | CIR_IRSTS_TE | CIR_IRSTS_TTR |
+			   CIR_IRSTS_TFU | CIR_IRSTS_GH) ? " ?" : "");
+}
+
+static bool nvt_cir_tx_inactive(struct nvt_dev *nvt)
+{
+	unsigned long flags;
+	bool tx_inactive;
+	u8 tx_state;
+
+	spin_lock_irqsave(&nvt->tx.lock, flags);
+	tx_state = nvt->tx.tx_state;
+	spin_unlock_irqrestore(&nvt->tx.lock, flags);
+
+	tx_inactive = (tx_state == ST_TX_NONE);
+
+	return tx_inactive;
+}
+
+/* interrupt service routine for incoming and outgoing CIR data */
+static irqreturn_t nvt_cir_isr(int irq, void *data)
+{
+	struct nvt_dev *nvt = data;
+	u8 status, iren, cur_state;
+	unsigned long flags;
+
+	nvt_dbg_verbose("%s firing", __func__);
+
+	nvt_efm_enable(nvt);
+	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
+	nvt_efm_disable(nvt);
+
+	/*
+	 * Get IR Status register contents. Write 1 to ack/clear
+	 *
+	 * bit: reg name      - description
+	 *   7: CIR_IRSTS_RDR - RX Data Ready
+	 *   6: CIR_IRSTS_RTR - RX FIFO Trigger Level Reach
+	 *   5: CIR_IRSTS_PE  - Packet End
+	 *   4: CIR_IRSTS_RFO - RX FIFO Overrun (RDR will also be set)
+	 *   3: CIR_IRSTS_TE  - TX FIFO Empty
+	 *   2: CIR_IRSTS_TTR - TX FIFO Trigger Level Reach
+	 *   1: CIR_IRSTS_TFU - TX FIFO Underrun
+	 *   0: CIR_IRSTS_GH  - Min Length Detected
+	 */
+	status = nvt_cir_reg_read(nvt, CIR_IRSTS);
+	if (!status) {
+		nvt_dbg_verbose("%s exiting, IRSTS 0x0", __func__);
+		nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
+		return IRQ_RETVAL(IRQ_NONE);
+	}
+
+	/* ack/clear all irq flags we've got */
+	nvt_cir_reg_write(nvt, status, CIR_IRSTS);
+	nvt_cir_reg_write(nvt, 0, CIR_IRSTS);
+
+	/* Interrupt may be shared with CIR Wake, bail if CIR not enabled */
+	iren = nvt_cir_reg_read(nvt, CIR_IREN);
+	if (!iren) {
+		nvt_dbg_verbose("%s exiting, CIR not enabled", __func__);
+		return IRQ_RETVAL(IRQ_NONE);
+	}
+
+	if (debug)
+		nvt_cir_log_irqs(status, iren);
+
+	if (status & CIR_IRSTS_RTR) {
+		/* FIXME: add code for study/learn mode */
+		/* We only do rx if not tx'ing */
+		if (nvt_cir_tx_inactive(nvt))
+			nvt_get_rx_ir_data(nvt);
+	}
+
+	if (status & CIR_IRSTS_PE) {
+		if (nvt_cir_tx_inactive(nvt))
+			nvt_get_rx_ir_data(nvt);
+
+		spin_lock_irqsave(&nvt->nvt_lock, flags);
+
+		cur_state = nvt->study_state;
+
+		spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
+		if (cur_state == ST_STUDY_NONE)
+			nvt_clear_cir_fifo(nvt);
+	}
+
+	if (status & CIR_IRSTS_TE)
+		nvt_clear_tx_fifo(nvt);
+
+	if (status & CIR_IRSTS_TTR) {
+		unsigned int pos, count;
+		u8 tmp;
+
+		spin_lock_irqsave(&nvt->tx.lock, flags);
+
+		pos = nvt->tx.cur_buf_num;
+		count = nvt->tx.buf_count;
+
+		/* Write data into the hardware tx fifo while pos < count */
+		if (pos < count) {
+			nvt_cir_reg_write(nvt, nvt->tx.buf[pos], CIR_STXFIFO);
+			nvt->tx.cur_buf_num++;
+		/* Disable TX FIFO Trigger Level Reach (TTR) interrupt */
+		} else {
+			tmp = nvt_cir_reg_read(nvt, CIR_IREN);
+			nvt_cir_reg_write(nvt, tmp & ~CIR_IREN_TTR, CIR_IREN);
+		}
+
+		spin_unlock_irqrestore(&nvt->tx.lock, flags);
+
+	}
+
+	if (status & CIR_IRSTS_TFU) {
+		spin_lock_irqsave(&nvt->tx.lock, flags);
+		if (nvt->tx.tx_state == ST_TX_REPLY) {
+			nvt->tx.tx_state = ST_TX_REQUEST;
+			wake_up(&nvt->tx.queue);
+		}
+		spin_unlock_irqrestore(&nvt->tx.lock, flags);
+	}
+
+	nvt_dbg_verbose("%s done", __func__);
+	return IRQ_RETVAL(IRQ_HANDLED);
+}
+
+/* Interrupt service routine for CIR Wake */
+static irqreturn_t nvt_cir_wake_isr(int irq, void *data)
+{
+	u8 status, iren, val;
+	struct nvt_dev *nvt = data;
+	unsigned long flags;
+
+	nvt_dbg_wake("%s firing", __func__);
+
+	status = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRSTS);
+	if (!status)
+		return IRQ_RETVAL(IRQ_NONE);
+
+	if (status & CIR_WAKE_IRSTS_IR_PENDING)
+		nvt_clear_cir_wake_fifo(nvt);
+
+	nvt_cir_wake_reg_write(nvt, status, CIR_WAKE_IRSTS);
+	nvt_cir_wake_reg_write(nvt, 0, CIR_WAKE_IRSTS);
+
+	/* Interrupt may be shared with CIR, bail if Wake not enabled */
+	iren = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IREN);
+	if (!iren) {
+		nvt_dbg_wake("%s exiting, wake not enabled", __func__);
+		return IRQ_RETVAL(IRQ_HANDLED);
+	}
+
+	if ((status & CIR_WAKE_IRSTS_PE) &&
+	    (nvt->wake_state == ST_WAKE_START)) {
+		while (nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY_IDX)) {
+			val = nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY);
+			nvt_dbg("setting wake up key: 0x%x", val);
+		}
+
+		nvt_cir_wake_reg_write(nvt, 0, CIR_WAKE_IREN);
+		spin_lock_irqsave(&nvt->nvt_lock, flags);
+		nvt->wake_state = ST_WAKE_FINISH;
+		spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+	}
+
+	nvt_dbg_wake("%s done", __func__);
+	return IRQ_RETVAL(IRQ_HANDLED);
+}
+
+static void nvt_enable_cir(struct nvt_dev *nvt)
+{
+	/* set function enable flags */
+	nvt_cir_reg_write(nvt, CIR_IRCON_TXEN | CIR_IRCON_RXEN |
+			  CIR_IRCON_RXINV | CIR_IRCON_SAMPLE_PERIOD_SEL,
+			  CIR_IRCON);
+
+	nvt_efm_enable(nvt);
+
+	/* enable the CIR logical device */
+	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
+	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
+
+	nvt_efm_disable(nvt);
+
+	/* clear all pending interrupts */
+	nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
+
+	/* enable interrupts */
+	nvt_cir_reg_write(nvt, CIR_IREN_RTR | CIR_IREN_PE, CIR_IREN);
+}
+
+static void nvt_disable_cir(struct nvt_dev *nvt)
+{
+	/* disable CIR interrupts */
+	nvt_cir_reg_write(nvt, 0, CIR_IREN);
+
+	/* clear any and all pending interrupts */
+	nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
+
+	/* clear all function enable flags */
+	nvt_cir_reg_write(nvt, 0, CIR_IRCON);
+
+	/* clear hardware rx and tx fifos */
+	nvt_clear_cir_fifo(nvt);
+	nvt_clear_tx_fifo(nvt);
+
+	nvt_efm_enable(nvt);
+
+	/* disable the CIR logical device */
+	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
+	nvt_cr_write(nvt, LOGICAL_DEV_DISABLE, CR_LOGICAL_DEV_EN);
+
+	nvt_efm_disable(nvt);
+}
+
+static int nvt_open(void *data)
+{
+	struct nvt_dev *nvt = (struct nvt_dev *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
+	nvt->in_use = true;
+	nvt_enable_cir(nvt);
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
+	return 0;
+}
+
+static void nvt_close(void *data)
+{
+	struct nvt_dev *nvt = (struct nvt_dev *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
+	nvt->in_use = false;
+	nvt_disable_cir(nvt);
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+}
+
+/* Allocate memory, probe hardware, and initialize everything */
+static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
+{
+	struct nvt_dev *nvt = NULL;
+	struct input_dev *rdev = NULL;
+	struct ir_dev_props *props = NULL;
+	int ret = -ENOMEM;
+
+	nvt = kzalloc(sizeof(struct nvt_dev), GFP_KERNEL);
+	if (!nvt)
+		return ret;
+
+	props = kzalloc(sizeof(struct ir_dev_props), GFP_KERNEL);
+	if (!props)
+		goto failure;
+
+	/* input device for IR remote (and tx) */
+	rdev = input_allocate_device();
+	if (!rdev)
+		goto failure;
+
+	ret = -ENODEV;
+	/* validate pnp resources */
+	if (!pnp_port_valid(pdev, 0) ||
+	    pnp_port_len(pdev, 0) < CIR_IOREG_LENGTH) {
+		dev_err(&pdev->dev, "IR PNP Port not valid!\n");
+		goto failure;
+	}
+
+	if (!pnp_irq_valid(pdev, 0)) {
+		dev_err(&pdev->dev, "PNP IRQ not valid!\n");
+		goto failure;
+	}
+
+	if (!pnp_port_valid(pdev, 1) ||
+	    pnp_port_len(pdev, 1) < CIR_IOREG_LENGTH) {
+		dev_err(&pdev->dev, "Wake PNP Port not valid!\n");
+		goto failure;
+	}
+
+	nvt->cir_addr = pnp_port_start(pdev, 0);
+	nvt->cir_irq  = pnp_irq(pdev, 0);
+
+	nvt->cir_wake_addr = pnp_port_start(pdev, 1);
+	/* irq is always shared between cir and cir wake */
+	nvt->cir_wake_irq  = nvt->cir_irq;
+
+	nvt->cr_efir = CR_EFIR;
+	nvt->cr_efdr = CR_EFDR;
+
+	spin_lock_init(&nvt->nvt_lock);
+	spin_lock_init(&nvt->tx.lock);
+
+	ret = -EBUSY;
+	/* now claim resources */
+	if (!request_region(nvt->cir_addr,
+			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
+		goto failure;
+
+	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
+			NVT_DRIVER_NAME, (void *)nvt))
+		goto failure;
+
+	if (!request_region(nvt->cir_wake_addr,
+			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
+		goto failure;
+
+	if (request_irq(nvt->cir_wake_irq, nvt_cir_wake_isr, IRQF_SHARED,
+			NVT_DRIVER_NAME, (void *)nvt))
+		goto failure;
+
+	pnp_set_drvdata(pdev, nvt);
+	nvt->pdev = pdev;
+
+	init_waitqueue_head(&nvt->tx.queue);
+
+	ret = nvt_hw_detect(nvt);
+	if (ret)
+		goto failure;
+
+	/* Initialize CIR & CIR Wake Logical Devices */
+	nvt_efm_enable(nvt);
+	nvt_cir_ldev_init(nvt);
+	nvt_cir_wake_ldev_init(nvt);
+	nvt_efm_disable(nvt);
+
+	/* Initialize CIR & CIR Wake Config Registers */
+	nvt_cir_regs_init(nvt);
+	nvt_cir_wake_regs_init(nvt);
+
+	/* Set up ir-core props */
+	props->priv = nvt;
+	props->driver_type = RC_DRIVER_IR_RAW;
+	props->allowed_protos = IR_TYPE_ALL;
+	props->open = nvt_open;
+	props->close = nvt_close;
+#if 0
+	props->min_timeout = XYZ;
+	props->max_timeout = XYZ;
+	props->timeout = XYZ;
+	/* rx resolution is hardwired to 50us atm, 1, 25, 100 also possible */
+	props->rx_resolution = XYZ;
+
+	/* tx bits */
+	props->tx_resolution = XYZ;
+#endif
+	props->tx_ir = nvt_tx_ir;
+	props->s_tx_carrier = nvt_set_tx_carrier;
+
+	rdev->name = "Nuvoton w836x7hg Infrared Remote Transceiver";
+	rdev->id.bustype = BUS_HOST;
+	rdev->id.vendor = PCI_VENDOR_ID_WINBOND2;
+	rdev->id.product = nvt->chip_major;
+	rdev->id.version = nvt->chip_minor;
+
+	nvt->props = props;
+	nvt->rdev = rdev;
+
+	device_set_wakeup_capable(&pdev->dev, 1);
+	device_set_wakeup_enable(&pdev->dev, 1);
+
+	ret = ir_input_register(rdev, RC_MAP_RC6_MCE, props, NVT_DRIVER_NAME);
+	if (ret)
+		goto failure;
+
+	nvt_pr(KERN_NOTICE, "driver has been successfully loaded\n");
+	if (debug) {
+		cir_dump_regs(nvt);
+		cir_wake_dump_regs(nvt);
+	}
+
+	return 0;
+
+failure:
+	if (nvt->cir_irq)
+		free_irq(nvt->cir_irq, nvt);
+	if (nvt->cir_addr)
+		release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
+
+	if (nvt->cir_wake_irq)
+		free_irq(nvt->cir_wake_irq, nvt);
+	if (nvt->cir_wake_addr)
+		release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
+
+	input_free_device(rdev);
+	kfree(props);
+	kfree(nvt);
+
+	return ret;
+}
+
+static void __devexit nvt_remove(struct pnp_dev *pdev)
+{
+	struct nvt_dev *nvt = pnp_get_drvdata(pdev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
+	/* disable CIR */
+	nvt_cir_reg_write(nvt, 0, CIR_IREN);
+	nvt_disable_cir(nvt);
+	/* enable CIR Wake (for IR power-on) */
+	nvt_enable_wake(nvt);
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
+	/* free resources */
+	free_irq(nvt->cir_irq, nvt);
+	free_irq(nvt->cir_wake_irq, nvt);
+	release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
+	release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
+
+	ir_input_unregister(nvt->rdev);
+
+	kfree(nvt->props);
+	kfree(nvt);
+}
+
+static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
+{
+	struct nvt_dev *nvt = pnp_get_drvdata(pdev);
+	unsigned long flags;
+
+	nvt_dbg("%s called", __func__);
+
+	/* zero out misc state tracking */
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
+	nvt->study_state = ST_STUDY_NONE;
+	nvt->wake_state = ST_WAKE_NONE;
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
+	spin_lock_irqsave(&nvt->tx.lock, flags);
+	nvt->tx.tx_state = ST_TX_NONE;
+	spin_unlock_irqrestore(&nvt->tx.lock, flags);
+
+	/* disable all CIR interrupts */
+	nvt_cir_reg_write(nvt, 0, CIR_IREN);
+
+	nvt_efm_enable(nvt);
+
+	/* disable cir logical dev */
+	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
+	nvt_cr_write(nvt, LOGICAL_DEV_DISABLE, CR_LOGICAL_DEV_EN);
+
+	nvt_efm_disable(nvt);
+
+	/* make sure wake is enabled */
+	nvt_enable_wake(nvt);
+
+	return 0;
+}
+
+static int nvt_resume(struct pnp_dev *pdev)
+{
+	int ret = 0;
+	struct nvt_dev *nvt = pnp_get_drvdata(pdev);
+
+	nvt_dbg("%s called", __func__);
+
+	/* open interrupt */
+	nvt_cir_reg_write(nvt, CIR_IREN_RTR | CIR_IREN_PE, CIR_IREN);
+
+	/* Enable CIR logical device */
+	nvt_efm_enable(nvt);
+	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
+	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
+
+	nvt_efm_disable(nvt);
+
+	nvt_cir_regs_init(nvt);
+	nvt_cir_wake_regs_init(nvt);
+
+	return ret;
+}
+
+static void nvt_shutdown(struct pnp_dev *pdev)
+{
+	struct nvt_dev *nvt = pnp_get_drvdata(pdev);
+	nvt_enable_wake(nvt);
+}
+
+static const struct pnp_device_id nvt_ids[] = {
+	{ "WEC0530", 0 },   /* CIR */
+	{ "NTN0530", 0 },   /* CIR for new chip's pnp id*/
+	{ "", 0 },
+};
+
+static struct pnp_driver nvt_driver = {
+	.name		= NVT_DRIVER_NAME,
+	.id_table	= nvt_ids,
+	.flags		= PNP_DRIVER_RES_DO_NOT_CHANGE,
+	.probe		= nvt_probe,
+	.remove		= __devexit_p(nvt_remove),
+	.suspend	= nvt_suspend,
+	.resume		= nvt_resume,
+	.shutdown	= nvt_shutdown,
+};
+
+int nvt_init(void)
+{
+	return pnp_register_driver(&nvt_driver);
+}
+
+void nvt_exit(void)
+{
+	pnp_unregister_driver(&nvt_driver);
+}
+
+module_param(debug, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "Enable debugging output");
+
+MODULE_DEVICE_TABLE(pnp, nvt_ids);
+MODULE_DESCRIPTION("Nuvoton W83667HG-A & W83677HG-I CIR driver");
+
+MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
+MODULE_LICENSE("GPL");
+
+module_init(nvt_init);
+module_exit(nvt_exit);
diff --git a/drivers/media/IR/nuvoton-cir.h b/drivers/media/IR/nuvoton-cir.h
new file mode 100644
index 0000000..12bfe89
--- /dev/null
+++ b/drivers/media/IR/nuvoton-cir.h
@@ -0,0 +1,408 @@
+/*
+ * Driver for Nuvoton Technology Corporation w83667hg/w83677hg-i CIR
+ *
+ * Copyright (C) 2010 Jarod Wilson <jarod@redhat.com>
+ * Copyright (C) 2009 Nuvoton PS Team
+ *
+ * Special thanks to Nuvoton for providing hardware, spec sheets and
+ * sample code upon which portions of this driver are based. Indirect
+ * thanks also to Maxim Levitsky, whose ene_ir driver this driver is
+ * modeled after.
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
+#include <asm/ioctl.h>
+
+/* platform driver name to register */
+#define NVT_DRIVER_NAME "nuvoton-cir"
+
+/* debugging module parameter */
+static int debug;
+
+
+#define nvt_pr(level, text, ...) \
+	printk(level KBUILD_MODNAME ": " text, ## __VA_ARGS__)
+
+#define nvt_dbg(text, ...) \
+	if (debug) \
+		printk(KERN_DEBUG \
+			KBUILD_MODNAME ": " text "\n" , ## __VA_ARGS__)
+
+#define nvt_dbg_verbose(text, ...) \
+	if (debug > 1) \
+		printk(KERN_DEBUG \
+			KBUILD_MODNAME ": " text "\n" , ## __VA_ARGS__)
+
+#define nvt_dbg_wake(text, ...) \
+	if (debug > 2) \
+		printk(KERN_DEBUG \
+			KBUILD_MODNAME ": " text "\n" , ## __VA_ARGS__)
+
+
+/*
+ * Original lirc driver said min value of 76, and recommended value of 256
+ * for the buffer length, but then used 2048. Never mind that the size of the
+ * RX FIFO is 32 bytes... So I'm using 32 for RX and 256 for TX atm, but I'm
+ * not sure if maybe that TX value is off by a factor of 8 (bits vs. bytes),
+ * and I don't have TX-capable hardware to test/debug on...
+ */
+#define TX_BUF_LEN 256
+#define RX_BUF_LEN 32
+
+struct nvt_dev {
+	struct pnp_dev *pdev;
+	struct input_dev *rdev;
+	struct ir_dev_props *props;
+	struct ir_raw_event rawir;
+
+	spinlock_t nvt_lock;
+	bool in_use;
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
+		u8 tx_state;
+	} tx;
+
+	/* EFER Config register index/data pair */
+	u8 cr_efir;
+	u8 cr_efdr;
+
+	/* hardware I/O settings */
+	unsigned long cir_addr;
+	unsigned long cir_wake_addr;
+	int cir_irq;
+	int cir_wake_irq;
+
+	/* hardware id */
+	u8 chip_major;
+	u8 chip_minor;
+
+	/* hardware features */
+	bool hw_learning_capable;
+	bool hw_tx_capable;
+
+	/* rx settings */
+	bool learning_enabled;
+	bool carrier_detect_enabled;
+
+	/* track cir wake state */
+	u8 wake_state;
+	/* for study */
+	u8 study_state;
+	/* carrier period = 1 / frequency */
+	u32 carrier;
+};
+
+/* study states */
+#define ST_STUDY_NONE      0x0
+#define ST_STUDY_START     0x1
+#define ST_STUDY_CARRIER   0x2
+#define ST_STUDY_ALL_RECV  0x4
+
+/* wake states */
+#define ST_WAKE_NONE	0x0
+#define ST_WAKE_START	0x1
+#define ST_WAKE_FINISH	0x2
+
+/* receive states */
+#define ST_RX_WAIT_7F		0x1
+#define ST_RX_WAIT_HEAD		0x2
+#define ST_RX_WAIT_SILENT_END	0x4
+
+/* send states */
+#define ST_TX_NONE	0x0
+#define ST_TX_REQUEST	0x2
+#define ST_TX_REPLY	0x4
+
+/* buffer packet constants */
+#define BUF_PULSE_BIT	0x80
+#define BUF_LEN_MASK	0x7f
+#define BUF_REPEAT_BYTE	0x70
+#define BUF_REPEAT_MASK	0xf0
+
+/* CIR settings */
+
+/* total length of CIR and CIR WAKE */
+#define CIR_IOREG_LENGTH	0x0f
+
+/* RX limit length, 8 high bits for SLCH, 8 low bits for SLCL (0x7d0 = 2000) */
+#define CIR_RX_LIMIT_COUNT	0x7d0
+
+/* CIR Regs */
+#define CIR_IRCON	0x00
+#define CIR_IRSTS	0x01
+#define CIR_IREN	0x02
+#define CIR_RXFCONT	0x03
+#define CIR_CP		0x04
+#define CIR_CC		0x05
+#define CIR_SLCH	0x06
+#define CIR_SLCL	0x07
+#define CIR_FIFOCON	0x08
+#define CIR_IRFIFOSTS	0x09
+#define CIR_SRXFIFO	0x0a
+#define CIR_TXFCONT	0x0b
+#define CIR_STXFIFO	0x0c
+#define CIR_FCCH	0x0d
+#define CIR_FCCL	0x0e
+#define CIR_IRFSM	0x0f
+
+/* CIR IRCON settings */
+#define CIR_IRCON_RECV	 0x80
+#define CIR_IRCON_WIREN	 0x40
+#define CIR_IRCON_TXEN	 0x20
+#define CIR_IRCON_RXEN	 0x10
+#define CIR_IRCON_WRXINV 0x08
+#define CIR_IRCON_RXINV	 0x04
+
+#define CIR_IRCON_SAMPLE_PERIOD_SEL_1	0x00
+#define CIR_IRCON_SAMPLE_PERIOD_SEL_25	0x01
+#define CIR_IRCON_SAMPLE_PERIOD_SEL_50	0x02
+#define CIR_IRCON_SAMPLE_PERIOD_SEL_100	0x03
+
+/* FIXME: make this a runtime option */
+/* select sample period as 50us */
+#define CIR_IRCON_SAMPLE_PERIOD_SEL	CIR_IRCON_SAMPLE_PERIOD_SEL_50
+
+/* CIR IRSTS settings */
+#define CIR_IRSTS_RDR	0x80
+#define CIR_IRSTS_RTR	0x40
+#define CIR_IRSTS_PE	0x20
+#define CIR_IRSTS_RFO	0x10
+#define CIR_IRSTS_TE	0x08
+#define CIR_IRSTS_TTR	0x04
+#define CIR_IRSTS_TFU	0x02
+#define CIR_IRSTS_GH	0x01
+
+/* CIR IREN settings */
+#define CIR_IREN_RDR	0x80
+#define CIR_IREN_RTR	0x40
+#define CIR_IREN_PE	0x20
+#define CIR_IREN_RFO	0x10
+#define CIR_IREN_TE	0x08
+#define CIR_IREN_TTR	0x04
+#define CIR_IREN_TFU	0x02
+#define CIR_IREN_GH	0x01
+
+/* CIR FIFOCON settings */
+#define CIR_FIFOCON_TXFIFOCLR		0x80
+
+#define CIR_FIFOCON_TX_TRIGGER_LEV_31	0x00
+#define CIR_FIFOCON_TX_TRIGGER_LEV_24	0x10
+#define CIR_FIFOCON_TX_TRIGGER_LEV_16	0x20
+#define CIR_FIFOCON_TX_TRIGGER_LEV_8	0x30
+
+/* FIXME: make this a runtime option */
+/* select TX trigger level as 16 */
+#define CIR_FIFOCON_TX_TRIGGER_LEV	CIR_FIFOCON_TX_TRIGGER_LEV_16
+
+#define CIR_FIFOCON_RXFIFOCLR		0x08
+
+#define CIR_FIFOCON_RX_TRIGGER_LEV_1	0x00
+#define CIR_FIFOCON_RX_TRIGGER_LEV_8	0x01
+#define CIR_FIFOCON_RX_TRIGGER_LEV_16	0x02
+#define CIR_FIFOCON_RX_TRIGGER_LEV_24	0x03
+
+/* FIXME: make this a runtime option */
+/* select RX trigger level as 24 */
+#define CIR_FIFOCON_RX_TRIGGER_LEV	CIR_FIFOCON_RX_TRIGGER_LEV_24
+
+/* CIR IRFIFOSTS settings */
+#define CIR_IRFIFOSTS_IR_PENDING	0x80
+#define CIR_IRFIFOSTS_RX_GS		0x40
+#define CIR_IRFIFOSTS_RX_FTA		0x20
+#define CIR_IRFIFOSTS_RX_EMPTY		0x10
+#define CIR_IRFIFOSTS_RX_FULL		0x08
+#define CIR_IRFIFOSTS_TX_FTA		0x04
+#define CIR_IRFIFOSTS_TX_EMPTY		0x02
+#define CIR_IRFIFOSTS_TX_FULL		0x01
+
+
+/* CIR WAKE UP Regs */
+#define CIR_WAKE_IRCON			0x00
+#define CIR_WAKE_IRSTS			0x01
+#define CIR_WAKE_IREN			0x02
+#define CIR_WAKE_FIFO_CMP_DEEP		0x03
+#define CIR_WAKE_FIFO_CMP_TOL		0x04
+#define CIR_WAKE_FIFO_COUNT		0x05
+#define CIR_WAKE_SLCH			0x06
+#define CIR_WAKE_SLCL			0x07
+#define CIR_WAKE_FIFOCON		0x08
+#define CIR_WAKE_SRXFSTS		0x09
+#define CIR_WAKE_SAMPLE_RX_FIFO		0x0a
+#define CIR_WAKE_WR_FIFO_DATA		0x0b
+#define CIR_WAKE_RD_FIFO_ONLY		0x0c
+#define CIR_WAKE_RD_FIFO_ONLY_IDX	0x0d
+#define CIR_WAKE_FIFO_IGNORE		0x0e
+#define CIR_WAKE_IRFSM			0x0f
+
+/* CIR WAKE UP IRCON settings */
+#define CIR_WAKE_IRCON_DEC_RST		0x80
+#define CIR_WAKE_IRCON_MODE1		0x40
+#define CIR_WAKE_IRCON_MODE0		0x20
+#define CIR_WAKE_IRCON_RXEN		0x10
+#define CIR_WAKE_IRCON_R		0x08
+#define CIR_WAKE_IRCON_RXINV		0x04
+
+/* FIXME/jarod: make this a runtime option */
+/* select a same sample period like cir register */
+#define CIR_WAKE_IRCON_SAMPLE_PERIOD_SEL	CIR_IRCON_SAMPLE_PERIOD_SEL_50
+
+/* CIR WAKE IRSTS Bits */
+#define CIR_WAKE_IRSTS_RDR		0x80
+#define CIR_WAKE_IRSTS_RTR		0x40
+#define CIR_WAKE_IRSTS_PE		0x20
+#define CIR_WAKE_IRSTS_RFO		0x10
+#define CIR_WAKE_IRSTS_GH		0x08
+#define CIR_WAKE_IRSTS_IR_PENDING	0x01
+
+/* CIR WAKE UP IREN Bits */
+#define CIR_WAKE_IREN_RDR		0x80
+#define CIR_WAKE_IREN_RTR		0x40
+#define CIR_WAKE_IREN_PE		0x20
+#define CIR_WAKE_IREN_RFO		0x10
+#define CIR_WAKE_IREN_TE		0x08
+#define CIR_WAKE_IREN_TTR		0x04
+#define CIR_WAKE_IREN_TFU		0x02
+#define CIR_WAKE_IREN_GH		0x01
+
+/* CIR WAKE FIFOCON settings */
+#define CIR_WAKE_FIFOCON_RXFIFOCLR	0x08
+
+#define CIR_WAKE_FIFOCON_RX_TRIGGER_LEV_67	0x00
+#define CIR_WAKE_FIFOCON_RX_TRIGGER_LEV_66	0x01
+#define CIR_WAKE_FIFOCON_RX_TRIGGER_LEV_65	0x02
+#define CIR_WAKE_FIFOCON_RX_TRIGGER_LEV_64	0x03
+
+/* FIXME: make this a runtime option */
+/* select WAKE UP RX trigger level as 67 */
+#define CIR_WAKE_FIFOCON_RX_TRIGGER_LEV	CIR_WAKE_FIFOCON_RX_TRIGGER_LEV_67
+
+/* CIR WAKE SRXFSTS settings */
+#define CIR_WAKE_IRFIFOSTS_RX_GS	0x80
+#define CIR_WAKE_IRFIFOSTS_RX_FTA	0x40
+#define CIR_WAKE_IRFIFOSTS_RX_EMPTY	0x20
+#define CIR_WAKE_IRFIFOSTS_RX_FULL	0x10
+
+/* CIR Wake FIFO buffer is 67 bytes long */
+#define CIR_WAKE_FIFO_LEN		67
+/* CIR Wake byte comparison tolerance */
+#define CIR_WAKE_CMP_TOLERANCE		5
+
+/*
+ * Extended Function Enable Registers:
+ *  Extended Function Index Register
+ *  Extended Function Data Register
+ */
+#define CR_EFIR			0x2e
+#define CR_EFDR			0x2f
+
+/* Possible alternate EFER values, depends on how the chip is wired */
+#define CR_EFIR2		0x4e
+#define CR_EFDR2		0x4f
+
+/* Extended Function Mode enable/disable magic values */
+#define EFER_EFM_ENABLE		0x87
+#define EFER_EFM_DISABLE	0xaa
+
+/* Chip IDs found in CR_CHIP_ID_{HI,LO} */
+#define CHIP_ID_HIGH		0xb4
+#define CHIP_ID_LOW		0x72
+#define CHIP_ID_LOW2		0x73
+
+/* Config regs we need to care about */
+#define CR_SOFTWARE_RESET	0x02
+#define CR_LOGICAL_DEV_SEL	0x07
+#define CR_CHIP_ID_HI		0x20
+#define CR_CHIP_ID_LO		0x21
+#define CR_DEV_POWER_DOWN	0x22 /* bit 2 is CIR power, default power on */
+#define CR_OUTPUT_PIN_SEL	0x27
+#define CR_LOGICAL_DEV_EN	0x30 /* valid for all logical devices */
+/* next three regs valid for both the CIR and CIR_WAKE logical devices */
+#define CR_CIR_BASE_ADDR_HI	0x60
+#define CR_CIR_BASE_ADDR_LO	0x61
+#define CR_CIR_IRQ_RSRC		0x70
+/* next three regs valid only for ACPI logical dev */
+#define CR_ACPI_CIR_WAKE	0xe0
+#define CR_ACPI_IRQ_EVENTS	0xf6
+#define CR_ACPI_IRQ_EVENTS2	0xf7
+
+/* Logical devices that we need to care about */
+#define LOGICAL_DEV_LPT		0x01
+#define LOGICAL_DEV_CIR		0x06
+#define LOGICAL_DEV_ACPI	0x0a
+#define LOGICAL_DEV_CIR_WAKE	0x0e
+
+#define LOGICAL_DEV_DISABLE	0x00
+#define LOGICAL_DEV_ENABLE	0x01
+
+#define CIR_WAKE_ENABLE_BIT	0x08
+#define CIR_INTR_MOUSE_IRQ_BIT	0x80
+#define PME_INTR_CIR_PASS_BIT	0x08
+
+#define OUTPUT_PIN_SEL_MASK	0xbc
+#define OUTPUT_ENABLE_CIR	0x01 /* Pin95=CIRRX, Pin96=CIRTX1 */
+#define OUTPUT_ENABLE_CIRWB	0x40 /* enable wide-band sensor */
+
+/* MCE CIR signal length, related on sample period */
+
+/* MCE CIR controller signal length: about 43ms
+ * 43ms / 50us (sample period) * 0.85 (inaccuracy)
+ */
+#define CONTROLLER_BUF_LEN_MIN 830
+
+/* MCE CIR keyboard signal length: about 26ms
+ * 26ms / 50us (sample period) * 0.85 (inaccuracy)
+ */
+#define KEYBOARD_BUF_LEN_MAX 650
+#define KEYBOARD_BUF_LEN_MIN 610
+
+/* MCE CIR mouse signal length: about 24ms
+ * 24ms / 50us (sample period) * 0.85 (inaccuracy)
+ */
+#define MOUSE_BUF_LEN_MIN 565
+
+#define CIR_SAMPLE_PERIOD 50
+#define CIR_SAMPLE_LOW_INACCURACY 0.85
+
+/* MAX silence time that driver will sent to lirc */
+#define MAX_SILENCE_TIME 60000
+
+#if CIR_IRCON_SAMPLE_PERIOD_SEL == CIR_IRCON_SAMPLE_PERIOD_SEL_100
+#define SAMPLE_PERIOD 100
+
+#elif CIR_IRCON_SAMPLE_PERIOD_SEL == CIR_IRCON_SAMPLE_PERIOD_SEL_50
+#define SAMPLE_PERIOD 50
+
+#elif CIR_IRCON_SAMPLE_PERIOD_SEL == CIR_IRCON_SAMPLE_PERIOD_SEL_25
+#define SAMPLE_PERIOD 25
+
+#else
+#define SAMPLE_PERIOD 1
+#endif
+
+/* as VISTA MCE definition, valid carrier value */
+#define MAX_CARRIER 60000
+#define MIN_CARRIER 30000
-- 
1.7.1

-- 
Jarod Wilson
jarod@redhat.com

