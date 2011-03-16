Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761Ab1CPUO7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 16:14:59 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: "Juan J. Garcia de Soria" <skandalfo@gmail.com>,
	Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/2] rc: New rc-based ite-cir driver for several ITE CIRs
Date: Wed, 16 Mar 2011 16:14:52 -0400
Message-Id: <1300306493-18921-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Juan J. Garcia de Soria <skandalfo@gmail.com>

This is a second version of an rc-core based driver for the ITE Tech IT8712F
CIR and now for a pair of other variants of the IT8512 CIR too.

This driver should replace the lirc_it87 and lirc_ite8709 currently living in
the LIRC staging directory.

The driver should support the ITE8704, ITE8713, ITE8708 and ITE8709 (this last
one yet untested) PNP ID's.

The code doesn'te reuse code from the pre-existing LIRC drivers, but has been
written from scratch using the nuvoton.cir driver as a skeleton.

This new driver shouldn't exhibit timing problems when running under load (or
with interrupts disabled for relatively long times). It works OOTB with the
RC6 MCE remote bundled with the ASUS EEEBox. TX support is implemented, but
I'm unable to test it since my hardware lacks TX capability.

Signed-off-by: Juan J. Garcia de Soria <skandalfo@gmail.com>
Tested-by: Stephan Raue <stephan@openelec.tv>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---

Nb: Juan sent this a while ago, but for some reason, it never made it to the
mailing list, so he sent it directly to me, and I've integrated it in my
tree and build-tested it. --jarod

 drivers/media/rc/Kconfig   |   13 +
 drivers/media/rc/Makefile  |    1 +
 drivers/media/rc/ite-cir.c | 1734 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/ite-cir.h |  478 ++++++++++++
 4 files changed, 2226 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/rc/ite-cir.c
 create mode 100644 drivers/media/rc/ite-cir.h

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 3785162..0615443 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -135,6 +135,19 @@ config IR_MCEUSB
 	   To compile this driver as a module, choose M here: the
 	   module will be called mceusb.
 
+config IR_ITE_CIR
+	tristate "ITE Tech Inc. IT8712/IT8512 Consumer Infrared Transceiver"
+	depends on PNP
+	depends on RC_CORE
+	---help---
+	   Say Y here to enable support for integrated infrared receivers
+	   /transceivers made by ITE Tech Inc. These are found in
+	   several ASUS devices, like the ASUS Digimatrix or the ASUS
+	   EEEBox 1501U.
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called ite-cir.
+
 config IR_NUVOTON
 	tristate "Nuvoton w836x7hg Consumer Infrared Transceiver"
 	depends on PNP
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 67b4f7f..c6cfe70 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
 
 # stand-alone IR receivers/transmitters
 obj-$(CONFIG_IR_IMON) += imon.o
+obj-$(CONFIG_IR_ITE_CIR) += ite-cir.o
 obj-$(CONFIG_IR_MCEUSB) += mceusb.o
 obj-$(CONFIG_IR_NUVOTON) += nuvoton-cir.o
 obj-$(CONFIG_IR_ENE) += ene_ir.o
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
new file mode 100644
index 0000000..7970195
--- /dev/null
+++ b/drivers/media/rc/ite-cir.c
@@ -0,0 +1,1734 @@
+/*
+ * Driver for ITE Tech Inc. IT8712F/IT8512 CIR
+ *
+ * Copyright (C) 2010 Juan Jesús García de Soria <skandalfo@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA.
+ *
+ * Inspired by the original lirc_it87 and lirc_ite8709 drivers, on top of the
+ * skeleton provided by the nuvoton-cir driver.
+ *
+ * The lirc_it87 driver was originally written by Hans-Gunter Lutke Uphues
+ * <hg_lu@web.de> in 2001, with enhancements by Christoph Bartelmus
+ * <lirc@bartelmus.de>, Andrew Calkin <r_tay@hotmail.com> and James Edwards
+ * <jimbo-lirc@edwardsclan.net>.
+ *
+ * The lirc_ite8709 driver was written by Grégory Lardière
+ * <spmf2004-lirc@yahoo.fr> in 2008.
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
+#include <linux/bitops.h>
+#include <media/rc-core.h>
+#include <linux/pci_ids.h>
+
+#include "ite-cir.h"
+
+/* module parameters */
+
+/* debug level */
+static int debug;
+module_param(debug, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "Enable debugging output");
+
+/* low limit for RX carrier freq, Hz, 0 for no RX demodulation */
+static int rx_low_carrier_freq;
+module_param(rx_low_carrier_freq, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(rx_low_carrier_freq, "Override low RX carrier frequency, Hz, "
+		 "0 for no RX demodulation");
+
+/* high limit for RX carrier freq, Hz, 0 for no RX demodulation */
+static int rx_high_carrier_freq;
+module_param(rx_high_carrier_freq, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(rx_high_carrier_freq, "Override high RX carrier frequency, "
+		 "Hz, 0 for no RX demodulation");
+
+/* override tx carrier frequency */
+static int tx_carrier_freq;
+module_param(tx_carrier_freq, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(tx_carrier_freq, "Override TX carrier frequency, Hz");
+
+/* override tx duty cycle */
+static int tx_duty_cycle;
+module_param(tx_duty_cycle, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(tx_duty_cycle, "Override TX duty cycle, 1-100");
+
+/* override default sample period */
+static long sample_period;
+module_param(sample_period, long, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(sample_period, "Override carrier sample period, us");
+
+/* override detected model id */
+static int model_number = -1;
+module_param(model_number, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(model_number, "Use this model number, don't autodetect");
+
+
+/* HW-independent code functions */
+
+/* check whether carrier frequency is high frequency */
+static inline bool ite_is_high_carrier_freq(unsigned int freq)
+{
+	return freq >= ITE_HCF_MIN_CARRIER_FREQ;
+}
+
+/* get the bits required to program the carrier frequency in CFQ bits,
+ * unshifted */
+static u8 ite_get_carrier_freq_bits(unsigned int freq)
+{
+	if (ite_is_high_carrier_freq(freq)) {
+		if (freq < 425000)
+			return ITE_CFQ_400;
+
+		else if (freq < 465000)
+			return ITE_CFQ_450;
+
+		else if (freq < 490000)
+			return ITE_CFQ_480;
+
+		else
+			return ITE_CFQ_500;
+	} else {
+			/* trim to limits */
+		if (freq < ITE_LCF_MIN_CARRIER_FREQ)
+			freq = ITE_LCF_MIN_CARRIER_FREQ;
+		if (freq > ITE_LCF_MAX_CARRIER_FREQ)
+			freq = ITE_LCF_MAX_CARRIER_FREQ;
+
+		/* convert to kHz and subtract the base freq */
+		freq =
+		    DIV_ROUND_CLOSEST(freq - ITE_LCF_MIN_CARRIER_FREQ,
+				      1000);
+
+		return (u8) freq;
+	}
+}
+
+/* get the bits required to program the pulse with in TXMPW */
+static u8 ite_get_pulse_width_bits(unsigned int freq, int duty_cycle)
+{
+	unsigned long period_ns, on_ns;
+
+	/* sanitize freq into range */
+	if (freq < ITE_LCF_MIN_CARRIER_FREQ)
+		freq = ITE_LCF_MIN_CARRIER_FREQ;
+	if (freq > ITE_HCF_MAX_CARRIER_FREQ)
+		freq = ITE_HCF_MAX_CARRIER_FREQ;
+
+	period_ns = 1000000000UL / freq;
+	on_ns = period_ns * duty_cycle / 100;
+
+	if (ite_is_high_carrier_freq(freq)) {
+		if (on_ns < 750)
+			return ITE_TXMPW_A;
+
+		else if (on_ns < 850)
+			return ITE_TXMPW_B;
+
+		else if (on_ns < 950)
+			return ITE_TXMPW_C;
+
+		else if (on_ns < 1080)
+			return ITE_TXMPW_D;
+
+		else
+			return ITE_TXMPW_E;
+	} else {
+		if (on_ns < 6500)
+			return ITE_TXMPW_A;
+
+		else if (on_ns < 7850)
+			return ITE_TXMPW_B;
+
+		else if (on_ns < 9650)
+			return ITE_TXMPW_C;
+
+		else if (on_ns < 11950)
+			return ITE_TXMPW_D;
+
+		else
+			return ITE_TXMPW_E;
+	}
+}
+
+/* decode raw bytes as received by the hardware, and push them to the ir-core
+ * layer */
+static void ite_decode_bytes(struct ite_dev *dev, const u8 * data, int
+			     length)
+{
+	u32 sample_period;
+	unsigned long *ldata;
+	unsigned int next_one, next_zero, size;
+	DEFINE_IR_RAW_EVENT(ev);
+
+	if (length == 0)
+		return;
+
+	sample_period = dev->params.sample_period;
+	ldata = (unsigned long *)data;
+	size = length << 3;
+	next_one = generic_find_next_le_bit(ldata, size, 0);
+	if (next_one > 0) {
+		ev.pulse = true;
+		ev.duration =
+		    ITE_BITS_TO_NS(next_one, sample_period);
+		ir_raw_event_store_with_filter(dev->rdev, &ev);
+	}
+
+	while (next_one < size) {
+		next_zero = generic_find_next_zero_le_bit(ldata, size, next_one + 1);
+		ev.pulse = false;
+		ev.duration = ITE_BITS_TO_NS(next_zero - next_one, sample_period);
+		ir_raw_event_store_with_filter(dev->rdev, &ev);
+
+		if (next_zero < size) {
+			next_one =
+			    generic_find_next_le_bit(ldata,
+						     size,
+						     next_zero + 1);
+			ev.pulse = true;
+			ev.duration =
+			    ITE_BITS_TO_NS(next_one - next_zero,
+					   sample_period);
+			ir_raw_event_store_with_filter
+			    (dev->rdev, &ev);
+		} else
+			next_one = size;
+	}
+
+	ir_raw_event_handle(dev->rdev);
+
+	ite_dbg_verbose("decoded %d bytes.", length);
+}
+
+/* set all the rx/tx carrier parameters; this must be called with the device
+ * spinlock held */
+static void ite_set_carrier_params(struct ite_dev *dev)
+{
+	unsigned int freq, low_freq, high_freq;
+	int allowance;
+	bool use_demodulator;
+	bool for_tx = dev->transmitting;
+
+	ite_dbg("%s called", __func__);
+
+	if (for_tx) {
+		/* we don't need no stinking calculations */
+		freq = dev->params.tx_carrier_freq;
+		allowance = ITE_RXDCR_DEFAULT;
+		use_demodulator = false;
+	} else {
+		low_freq = dev->params.rx_low_carrier_freq;
+		high_freq = dev->params.rx_high_carrier_freq;
+
+		if (low_freq == 0) {
+			/* don't demodulate */
+			freq =
+			ITE_DEFAULT_CARRIER_FREQ;
+			allowance = ITE_RXDCR_DEFAULT;
+			use_demodulator = false;
+		} else {
+			/* calculate the middle freq */
+			freq = (low_freq + high_freq) / 2;
+
+			/* calculate the allowance */
+			allowance =
+			    DIV_ROUND_CLOSEST(10000 * (high_freq - low_freq),
+					      ITE_RXDCR_PER_10000_STEP
+					      * (high_freq + low_freq));
+
+			if (allowance < 1)
+				allowance = 1;
+
+			if (allowance > ITE_RXDCR_MAX)
+				allowance = ITE_RXDCR_MAX;
+		}
+	}
+
+	/* set the carrier parameters in a device-dependent way */
+	dev->params.set_carrier_params(dev, ite_is_high_carrier_freq(freq),
+		 use_demodulator, ite_get_carrier_freq_bits(freq), allowance,
+		 ite_get_pulse_width_bits(freq, dev->params.tx_duty_cycle));
+}
+
+/* interrupt service routine for incoming and outgoing CIR data */
+static irqreturn_t ite_cir_isr(int irq, void *data)
+{
+	struct ite_dev *dev = data;
+	unsigned long flags;
+	irqreturn_t ret = IRQ_RETVAL(IRQ_NONE);
+	u8 rx_buf[ITE_RX_FIFO_LEN];
+	int rx_bytes;
+	int iflags;
+
+	ite_dbg_verbose("%s firing", __func__);
+
+	/* grab the spinlock */
+	spin_lock_irqsave(&dev->lock, flags);
+
+	/* read the interrupt flags */
+	iflags = dev->params.get_irq_causes(dev);
+
+	/* check for the receive interrupt */
+	if (iflags & (ITE_IRQ_RX_FIFO | ITE_IRQ_RX_FIFO_OVERRUN)) {
+		/* read the FIFO bytes */
+		rx_bytes =
+			dev->params.get_rx_bytes(dev, rx_buf,
+					     ITE_RX_FIFO_LEN);
+
+		if (rx_bytes > 0) {
+			/* drop the spinlock, since the ir-core layer
+			 * may call us back again through
+			 * ite_s_idle() */
+			spin_unlock_irqrestore(&dev->
+									 lock,
+									 flags);
+
+			/* decode the data we've just received */
+			ite_decode_bytes(dev, rx_buf,
+								   rx_bytes);
+
+			/* reacquire the spinlock */
+			spin_lock_irqsave(&dev->lock,
+								    flags);
+
+			/* mark the interrupt as serviced */
+			ret = IRQ_RETVAL(IRQ_HANDLED);
+		}
+	} else if (iflags & ITE_IRQ_TX_FIFO) {
+		/* FIFO space available interrupt */
+		ite_dbg_verbose("got interrupt for TX FIFO");
+
+		/* wake any sleeping transmitter */
+		wake_up_interruptible(&dev->tx_queue);
+
+		/* mark the interrupt as serviced */
+		ret = IRQ_RETVAL(IRQ_HANDLED);
+	}
+
+	/* drop the spinlock */
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	ite_dbg_verbose("%s done returning %d", __func__, (int)ret);
+
+	return ret;
+}
+
+/* set the rx carrier freq range, guess it's in Hz... */
+static int ite_set_rx_carrier_range(struct rc_dev *rcdev, u32 carrier_low, u32
+				    carrier_high)
+{
+	unsigned long flags;
+	struct ite_dev *dev = rcdev->priv;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	dev->params.rx_low_carrier_freq = carrier_low;
+	dev->params.rx_high_carrier_freq = carrier_high;
+	ite_set_carrier_params(dev);
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	return 0;
+}
+
+/* set the tx carrier freq, guess it's in Hz... */
+static int ite_set_tx_carrier(struct rc_dev *rcdev, u32 carrier)
+{
+	unsigned long flags;
+	struct ite_dev *dev = rcdev->priv;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	dev->params.tx_carrier_freq = carrier;
+	ite_set_carrier_params(dev);
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	return 0;
+}
+
+/* set the tx duty cycle by controlling the pulse width */
+static int ite_set_tx_duty_cycle(struct rc_dev *rcdev, u32 duty_cycle)
+{
+	unsigned long flags;
+	struct ite_dev *dev = rcdev->priv;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	dev->params.tx_duty_cycle = duty_cycle;
+	ite_set_carrier_params(dev);
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	return 0;
+}
+
+/* transmit out IR pulses; what you get here is a batch of alternating
+ * pulse/space/pulse/space lengths that we should write out completely through
+ * the FIFO, blocking on a full FIFO */
+static int ite_tx_ir(struct rc_dev *rcdev, int *txbuf, u32 n)
+{
+	unsigned long flags;
+	struct ite_dev *dev = rcdev->priv;
+	bool is_pulse = false;
+	int remaining_us, fifo_avail, fifo_remaining, last_idx = 0;
+	int max_rle_us, next_rle_us;
+	int ret = n;
+	u8 last_sent[ITE_TX_FIFO_LEN];
+	u8 val;
+
+	ite_dbg("%s called", __func__);
+
+	/* clear the array just in case */
+	memset(last_sent, 0, ARRAY_SIZE(last_sent));
+
+	/* n comes in bytes; convert to ints */
+	n /= sizeof(int);
+
+	spin_lock_irqsave(&dev->lock, flags);
+
+	/* let everybody know we're now transmitting */
+	dev->transmitting = true;
+
+	/* and set the carrier values for transmission */
+	ite_set_carrier_params(dev);
+
+	/* calculate how much time we can send in one byte */
+	max_rle_us =
+	    (ITE_BAUDRATE_DIVISOR * dev->params.sample_period *
+	     ITE_TX_MAX_RLE) / 1000;
+
+	/* disable the receiver */
+	dev->params.disable_rx(dev);
+
+	/* this is where we'll begin filling in the FIFO, until it's full.
+	 * then we'll just activate the interrupt, wait for it to wake us up
+	 * again, disable it, continue filling the FIFO... until everything
+	 * has been pushed out */
+	fifo_avail =
+	    ITE_TX_FIFO_LEN - dev->params.get_tx_used_slots(dev);
+
+	while (n > 0 && dev->in_use) {
+		/* transmit the next sample */
+		is_pulse = !is_pulse;
+		remaining_us = *(txbuf++);
+		n--;
+
+		ite_dbg("%s: %ld",
+				      ((is_pulse) ? "pulse" : "space"),
+				      (long int)
+				      remaining_us);
+
+		/* repeat while the pulse is non-zero length */
+		while (remaining_us > 0 && dev->in_use) {
+			if (remaining_us > max_rle_us)
+				next_rle_us = max_rle_us;
+
+			else
+				next_rle_us = remaining_us;
+
+			remaining_us -= next_rle_us;
+
+			/* check what's the length we have to pump out */
+			val = (ITE_TX_MAX_RLE * next_rle_us) / max_rle_us;
+
+			/* put it into the sent buffer */
+			last_sent[last_idx++] = val;
+			last_idx &= (ITE_TX_FIFO_LEN);
+
+			/* encode it for 7 bits */
+			val = (val - 1) & ITE_TX_RLE_MASK;
+
+			/* take into account pulse/space prefix */
+			if (is_pulse)
+				val |= ITE_TX_PULSE;
+
+			else
+				val |= ITE_TX_SPACE;
+
+			/* if we get to 0 available, read again, just in case
+						              * some other slot got freed */
+			if (fifo_avail <= 0)
+				fifo_avail = ITE_TX_FIFO_LEN - dev->params.get_tx_used_slots(dev);
+
+			/* if it's still full */
+			if (fifo_avail <= 0) {
+				/* enable the tx interrupt */
+				dev->params.
+				enable_tx_interrupt(dev);
+
+				/* drop the spinlock */
+				spin_unlock_irqrestore(&dev->lock, flags);
+
+				/* wait for the FIFO to empty enough */
+				wait_event_interruptible(dev->tx_queue, (fifo_avail = ITE_TX_FIFO_LEN - dev->params.get_tx_used_slots(dev)) >= 8);
+
+				/* get the spinlock again */
+				spin_lock_irqsave(&dev->lock, flags);
+
+				/* disable the tx interrupt again. */
+				dev->params.
+				disable_tx_interrupt(dev);
+			}
+
+			/* now send the byte through the FIFO */
+			dev->params.put_tx_byte(dev, val);
+			fifo_avail--;
+		}
+	}
+
+	/* wait and don't return until the whole FIFO has been sent out;
+	 * otherwise we could configure the RX carrier params instead of the
+	 * TX ones while the transmission is still being performed! */
+	fifo_remaining = dev->params.get_tx_used_slots(dev);
+	remaining_us = 0;
+	while (fifo_remaining > 0) {
+		fifo_remaining--;
+		last_idx--;
+		last_idx &= (ITE_TX_FIFO_LEN - 1);
+		remaining_us += last_sent[last_idx];
+	}
+	remaining_us = (remaining_us * max_rle_us) / (ITE_TX_MAX_RLE);
+
+	/* drop the spinlock while we sleep */
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	/* sleep remaining_us microseconds */
+	mdelay(DIV_ROUND_UP(remaining_us, 1000));
+
+	/* reacquire the spinlock */
+	spin_lock_irqsave(&dev->lock, flags);
+
+	/* now we're not transmitting anymore */
+	dev->transmitting = false;
+
+	/* and set the carrier values for reception */
+	ite_set_carrier_params(dev);
+
+	/* reenable the receiver */
+	if (dev->in_use)
+		dev->params.enable_rx(dev);
+
+	/* notify transmission end */
+	wake_up_interruptible(&dev->tx_ended);
+
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	return ret;
+}
+
+/* idle the receiver if needed */
+static void ite_s_idle(struct rc_dev *rcdev, bool enable)
+{
+	unsigned long flags;
+	struct ite_dev *dev = rcdev->priv;
+
+	ite_dbg("%s called", __func__);
+
+	if (enable) {
+		spin_lock_irqsave(&dev->lock, flags);
+		dev->params.idle_rx(dev);
+		spin_unlock_irqrestore(&dev->lock, flags);
+	}
+}
+
+
+/* IT8712F HW-specific functions */
+
+/* retrieve a bitmask of the current causes for a pending interrupt; this may
+ * be composed of ITE_IRQ_TX_FIFO, ITE_IRQ_RX_FIFO and ITE_IRQ_RX_FIFO_OVERRUN
+ * */
+static int it87_get_irq_causes(struct ite_dev *dev)
+{
+	u8 iflags;
+	int ret = 0;
+
+	ite_dbg("%s called", __func__);
+
+	/* read the interrupt flags */
+	iflags = inb(dev->cir_addr + IT87_IIR) & IT87_II;
+
+	switch (iflags) {
+	case IT87_II_RXDS:
+		ret = ITE_IRQ_RX_FIFO;
+		break;
+	case IT87_II_RXFO:
+		ret = ITE_IRQ_RX_FIFO_OVERRUN;
+		break;
+	case IT87_II_TXLDL:
+		ret = ITE_IRQ_TX_FIFO;
+		break;
+	}
+
+	return ret;
+}
+
+/* set the carrier parameters; to be called with the spinlock held */
+static void it87_set_carrier_params(struct ite_dev *dev, bool high_freq,
+				    bool use_demodulator,
+				    u8 carrier_freq_bits, u8 allowance_bits,
+				    u8 pulse_width_bits)
+{
+	u8 val;
+
+	ite_dbg("%s called", __func__);
+
+	/* program the RCR register */
+	val = inb(dev->cir_addr + IT87_RCR)
+		& ~(IT87_HCFS | IT87_RXEND | IT87_RXDCR);
+
+	if (high_freq)
+		val |= IT87_HCFS;
+
+	if (use_demodulator)
+		val |= IT87_RXEND;
+
+	val |= allowance_bits;
+
+	outb(val, dev->cir_addr + IT87_RCR);
+
+	/* program the TCR2 register */
+	outb((carrier_freq_bits << IT87_CFQ_SHIFT) | pulse_width_bits,
+		dev->cir_addr + IT87_TCR2);
+}
+
+/* read up to buf_size bytes from the RX FIFO; to be called with the spinlock
+ * held */
+static int it87_get_rx_bytes(struct ite_dev *dev, u8 * buf, int buf_size)
+{
+	int fifo, read = 0;
+
+	ite_dbg("%s called", __func__);
+
+	/* read how many bytes are still in the FIFO */
+	fifo = inb(dev->cir_addr + IT87_RSR) & IT87_RXFBC;
+
+	while (fifo > 0 && buf_size > 0) {
+		*(buf++) = inb(dev->cir_addr + IT87_DR);
+		fifo--;
+		read++;
+		buf_size--;
+	}
+
+	return read;
+}
+
+/* return how many bytes are still in the FIFO; this will be called
+ * with the device spinlock NOT HELD while waiting for the TX FIFO to get
+ * empty; let's expect this won't be a problem */
+static int it87_get_tx_used_slots(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	return inb(dev->cir_addr + IT87_TSR) & IT87_TXFBC;
+}
+
+/* put a byte to the TX fifo; this should be called with the spinlock held */
+static void it87_put_tx_byte(struct ite_dev *dev, u8 value)
+{
+	outb(value, dev->cir_addr + IT87_DR);
+}
+
+/* idle the receiver so that we won't receive samples until another
+  pulse is detected; this must be called with the device spinlock held */
+static void it87_idle_rx(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* disable streaming by clearing RXACT writing it as 1 */
+	outb(inb(dev->cir_addr + IT87_RCR) | IT87_RXACT,
+		dev->cir_addr + IT87_RCR);
+
+	/* clear the FIFO */
+	outb(inb(dev->cir_addr + IT87_TCR1) | IT87_FIFOCLR,
+		dev->cir_addr + IT87_TCR1);
+}
+
+/* disable the receiver; this must be called with the device spinlock held */
+static void it87_disable_rx(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* disable the receiver interrupts */
+	outb(inb(dev->cir_addr + IT87_IER) & ~(IT87_RDAIE | IT87_RFOIE),
+		dev->cir_addr + IT87_IER);
+
+	/* disable the receiver */
+	outb(inb(dev->cir_addr + IT87_RCR) & ~IT87_RXEN,
+		dev->cir_addr + IT87_RCR);
+
+	/* clear the FIFO and RXACT (actually RXACT should have been cleared
+	* in the previous outb() call) */
+	it87_idle_rx(dev);
+}
+
+/* enable the receiver; this must be called with the device spinlock held */
+static void it87_enable_rx(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* enable the receiver by setting RXEN */
+	outb(inb(dev->cir_addr + IT87_RCR) | IT87_RXEN,
+		dev->cir_addr + IT87_RCR);
+
+	/* just prepare it to idle for the next reception */
+	it87_idle_rx(dev);
+
+	/* enable the receiver interrupts and master enable flag */
+	outb(inb(dev->cir_addr + IT87_IER) | IT87_RDAIE | IT87_RFOIE | IT87_IEC,
+		dev->cir_addr + IT87_IER);
+}
+
+/* disable the transmitter interrupt; this must be called with the device
+ * spinlock held */
+static void it87_disable_tx_interrupt(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* disable the transmitter interrupts */
+	outb(inb(dev->cir_addr + IT87_IER) & ~IT87_TLDLIE,
+		dev->cir_addr + IT87_IER);
+}
+
+/* enable the transmitter interrupt; this must be called with the device
+ * spinlock held */
+static void it87_enable_tx_interrupt(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* enable the transmitter interrupts and master enable flag */
+	outb(inb(dev->cir_addr + IT87_IER) | IT87_TLDLIE | IT87_IEC,
+		dev->cir_addr + IT87_IER);
+}
+
+/* disable the device; this must be called with the device spinlock held */
+static void it87_disable(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* clear out all interrupt enable flags */
+	outb(inb(dev->cir_addr + IT87_IER) &
+		~(IT87_IEC | IT87_RFOIE | IT87_RDAIE | IT87_TLDLIE),
+		dev->cir_addr + IT87_IER);
+
+	/* disable the receiver */
+	it87_disable_rx(dev);
+
+	/* erase the FIFO */
+	outb(IT87_FIFOCLR | inb(dev->cir_addr + IT87_TCR1),
+		dev->cir_addr + IT87_TCR1);
+}
+
+/* initialize the hardware */
+static void it87_init_hardware(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* enable just the baud rate divisor register,
+	disabling all the interrupts at the same time */
+	outb((inb(dev->cir_addr + IT87_IER) &
+		~(IT87_IEC | IT87_RFOIE | IT87_RDAIE | IT87_TLDLIE)) | IT87_BR,
+		dev->cir_addr + IT87_IER);
+
+	/* write out the baud rate divisor */
+	outb(ITE_BAUDRATE_DIVISOR & 0xff, dev->cir_addr + IT87_BDLR);
+	outb((ITE_BAUDRATE_DIVISOR >> 8) & 0xff, dev->cir_addr + IT87_BDHR);
+
+	/* disable the baud rate divisor register again */
+	outb(inb(dev->cir_addr + IT87_IER) & ~IT87_BR,
+		dev->cir_addr + IT87_IER);
+
+	/* program the RCR register defaults */
+	outb(ITE_RXDCR_DEFAULT, dev->cir_addr + IT87_RCR);
+
+	/* program the TCR1 register */
+	outb(IT87_TXMPM_DEFAULT | IT87_TXENDF | IT87_TXRLE
+		| IT87_FIFOTL_DEFAULT | IT87_FIFOCLR,
+		dev->cir_addr + IT87_TCR1);
+
+	/* program the carrier parameters */
+	ite_set_carrier_params(dev);
+}
+
+/* IT8512F on ITE8708 HW-specific functions */
+
+/* retrieve a bitmask of the current causes for a pending interrupt; this may
+ * be composed of ITE_IRQ_TX_FIFO, ITE_IRQ_RX_FIFO and ITE_IRQ_RX_FIFO_OVERRUN
+ * */
+static int it8708_get_irq_causes(struct ite_dev *dev)
+{
+	u8 iflags;
+	int ret = 0;
+
+	ite_dbg("%s called", __func__);
+
+	/* read the interrupt flags */
+	iflags = inb(dev->cir_addr + IT8708_C0IIR);
+
+	if (iflags & IT85_TLDLI)
+		ret |= ITE_IRQ_TX_FIFO;
+	if (iflags & IT85_RDAI)
+		ret |= ITE_IRQ_RX_FIFO;
+	if (iflags & IT85_RFOI)
+		ret |= ITE_IRQ_RX_FIFO_OVERRUN;
+
+	return ret;
+}
+
+/* set the carrier parameters; to be called with the spinlock held */
+static void it8708_set_carrier_params(struct ite_dev *dev, bool high_freq,
+				      bool use_demodulator,
+				      u8 carrier_freq_bits, u8 allowance_bits,
+				      u8 pulse_width_bits)
+{
+	u8 val;
+
+	ite_dbg("%s called", __func__);
+
+	/* program the C0CFR register, with HRAE=1 */
+	outb(inb(dev->cir_addr + IT8708_BANKSEL) | IT8708_HRAE,
+		dev->cir_addr + IT8708_BANKSEL);
+
+	val = (inb(dev->cir_addr + IT8708_C0CFR)
+		& ~(IT85_HCFS | IT85_CFQ)) | carrier_freq_bits;
+
+	if (high_freq)
+		val |= IT85_HCFS;
+
+	outb(val, dev->cir_addr + IT8708_C0CFR);
+
+	outb(inb(dev->cir_addr + IT8708_BANKSEL) & ~IT8708_HRAE,
+		   dev->cir_addr + IT8708_BANKSEL);
+
+	/* program the C0RCR register */
+	val = inb(dev->cir_addr + IT8708_C0RCR)
+		& ~(IT85_RXEND | IT85_RXDCR);
+
+	if (use_demodulator)
+		val |= IT85_RXEND;
+
+	val |= allowance_bits;
+
+	outb(val, dev->cir_addr + IT8708_C0RCR);
+
+	/* program the C0TCR register */
+	val = inb(dev->cir_addr + IT8708_C0TCR) & ~IT85_TXMPW;
+	val |= pulse_width_bits;
+	outb(val, dev->cir_addr + IT8708_C0TCR);
+}
+
+/* read up to buf_size bytes from the RX FIFO; to be called with the spinlock
+ * held */
+static int it8708_get_rx_bytes(struct ite_dev *dev, u8 * buf, int buf_size)
+{
+	int fifo, read = 0;
+
+	ite_dbg("%s called", __func__);
+
+	/* read how many bytes are still in the FIFO */
+	fifo = inb(dev->cir_addr + IT8708_C0RFSR) & IT85_RXFBC;
+
+	while (fifo > 0 && buf_size > 0) {
+		*(buf++) = inb(dev->cir_addr + IT8708_C0DR);
+		fifo--;
+		read++;
+		buf_size--;
+	}
+
+	return read;
+}
+
+/* return how many bytes are still in the FIFO; this will be called
+ * with the device spinlock NOT HELD while waiting for the TX FIFO to get
+ * empty; let's expect this won't be a problem */
+static int it8708_get_tx_used_slots(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	return inb(dev->cir_addr + IT8708_C0TFSR) & IT85_TXFBC;
+}
+
+/* put a byte to the TX fifo; this should be called with the spinlock held */
+static void it8708_put_tx_byte(struct ite_dev *dev, u8 value)
+{
+	outb(value, dev->cir_addr + IT8708_C0DR);
+}
+
+/* idle the receiver so that we won't receive samples until another
+  pulse is detected; this must be called with the device spinlock held */
+static void it8708_idle_rx(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* disable streaming by clearing RXACT writing it as 1 */
+	outb(inb(dev->cir_addr + IT8708_C0RCR) | IT85_RXACT,
+		dev->cir_addr + IT8708_C0RCR);
+
+	/* clear the FIFO */
+	outb(inb(dev->cir_addr + IT8708_C0MSTCR) | IT85_FIFOCLR,
+		dev->cir_addr + IT8708_C0MSTCR);
+}
+
+/* disable the receiver; this must be called with the device spinlock held */
+static void it8708_disable_rx(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* disable the receiver interrupts */
+	outb(inb(dev->cir_addr + IT8708_C0IER) &
+		~(IT85_RDAIE | IT85_RFOIE),
+		dev->cir_addr + IT8708_C0IER);
+
+	/* disable the receiver */
+	outb(inb(dev->cir_addr + IT8708_C0RCR) & ~IT85_RXEN,
+		dev->cir_addr + IT8708_C0RCR);
+
+	/* clear the FIFO and RXACT (actually RXACT should have been cleared
+	 * in the previous outb() call) */
+	it8708_idle_rx(dev);
+}
+
+/* enable the receiver; this must be called with the device spinlock held */
+static void it8708_enable_rx(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* enable the receiver by setting RXEN */
+	outb(inb(dev->cir_addr + IT8708_C0RCR) | IT85_RXEN,
+		dev->cir_addr + IT8708_C0RCR);
+
+	/* just prepare it to idle for the next reception */
+	it8708_idle_rx(dev);
+
+	/* enable the receiver interrupts and master enable flag */
+	outb(inb(dev->cir_addr + IT8708_C0IER)
+		|IT85_RDAIE | IT85_RFOIE | IT85_IEC,
+		dev->cir_addr + IT8708_C0IER);
+}
+
+/* disable the transmitter interrupt; this must be called with the device
+ * spinlock held */
+static void it8708_disable_tx_interrupt(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* disable the transmitter interrupts */
+	outb(inb(dev->cir_addr + IT8708_C0IER) & ~IT85_TLDLIE,
+		dev->cir_addr + IT8708_C0IER);
+}
+
+/* enable the transmitter interrupt; this must be called with the device
+ * spinlock held */
+static void it8708_enable_tx_interrupt(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* enable the transmitter interrupts and master enable flag */
+	outb(inb(dev->cir_addr + IT8708_C0IER)
+		|IT85_TLDLIE | IT85_IEC,
+		dev->cir_addr + IT8708_C0IER);
+}
+
+/* disable the device; this must be called with the device spinlock held */
+static void it8708_disable(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* clear out all interrupt enable flags */
+	outb(inb(dev->cir_addr + IT8708_C0IER) &
+		~(IT85_IEC | IT85_RFOIE | IT85_RDAIE | IT85_TLDLIE),
+		dev->cir_addr + IT8708_C0IER);
+
+	/* disable the receiver */
+	it8708_disable_rx(dev);
+
+	/* erase the FIFO */
+	outb(IT85_FIFOCLR | inb(dev->cir_addr + IT8708_C0MSTCR),
+		dev->cir_addr + IT8708_C0MSTCR);
+}
+
+/* initialize the hardware */
+static void it8708_init_hardware(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* disable all the interrupts */
+	outb(inb(dev->cir_addr + IT8708_C0IER) &
+		~(IT85_IEC | IT85_RFOIE | IT85_RDAIE | IT85_TLDLIE),
+		dev->cir_addr + IT8708_C0IER);
+
+	/* program the baud rate divisor */
+	outb(inb(dev->cir_addr + IT8708_BANKSEL) | IT8708_HRAE,
+		dev->cir_addr + IT8708_BANKSEL);
+
+	outb(ITE_BAUDRATE_DIVISOR & 0xff, dev->cir_addr + IT8708_C0BDLR);
+	outb((ITE_BAUDRATE_DIVISOR >> 8) & 0xff,
+		   dev->cir_addr + IT8708_C0BDHR);
+
+	outb(inb(dev->cir_addr + IT8708_BANKSEL) & ~IT8708_HRAE,
+		   dev->cir_addr + IT8708_BANKSEL);
+
+	/* program the C0MSTCR register defaults */
+	outb((inb(dev->cir_addr + IT8708_C0MSTCR) &
+			~(IT85_ILSEL | IT85_ILE | IT85_FIFOTL |
+			  IT85_FIFOCLR | IT85_RESET)) |
+		       IT85_FIFOTL_DEFAULT,
+		       dev->cir_addr + IT8708_C0MSTCR);
+
+	/* program the C0RCR register defaults */
+	outb((inb(dev->cir_addr + IT8708_C0RCR) &
+			~(IT85_RXEN | IT85_RDWOS | IT85_RXEND |
+			  IT85_RXACT | IT85_RXDCR)) |
+		       ITE_RXDCR_DEFAULT,
+		       dev->cir_addr + IT8708_C0RCR);
+
+	/* program the C0TCR register defaults */
+	outb((inb(dev->cir_addr + IT8708_C0TCR) &
+			~(IT85_TXMPM | IT85_TXMPW))
+		       |IT85_TXRLE | IT85_TXENDF |
+		       IT85_TXMPM_DEFAULT | IT85_TXMPW_DEFAULT,
+		       dev->cir_addr + IT8708_C0TCR);
+
+	/* program the carrier parameters */
+	ite_set_carrier_params(dev);
+}
+
+/* IT8512F on ITE8709 HW-specific functions */
+
+/* read a byte from the SRAM module */
+static inline u8 it8709_rm(struct ite_dev *dev, int index)
+{
+	outb(index, dev->cir_addr + IT8709_RAM_IDX);
+	return inb(dev->cir_addr + IT8709_RAM_VAL);
+}
+
+/* write a byte to the SRAM module */
+static inline void it8709_wm(struct ite_dev *dev, u8 val, int index)
+{
+	outb(index, dev->cir_addr + IT8709_RAM_IDX);
+	outb(val, dev->cir_addr + IT8709_RAM_VAL);
+}
+
+static void it8709_wait(struct ite_dev *dev)
+{
+	int i = 0;
+	/*
+	 * loop until device tells it's ready to continue
+	 * iterations count is usually ~750 but can sometimes achieve 13000
+	 */
+	for (i = 0; i < 15000; i++) {
+		udelay(2);
+		if (it8709_rm(dev, IT8709_MODE) == IT8709_IDLE)
+			break;
+	}
+}
+
+/* read the value of a CIR register */
+static u8 it8709_rr(struct ite_dev *dev, int index)
+{
+	/* just wait in case the previous access was a write */
+	it8709_wait(dev);
+	it8709_wm(dev, index, IT8709_REG_IDX);
+	it8709_wm(dev, IT8709_READ, IT8709_MODE);
+
+	/* wait for the read data to be available */
+	it8709_wait(dev);
+
+	/* return the read value */
+	return it8709_rm(dev, IT8709_REG_VAL);
+}
+
+/* write the value of a CIR register */
+static void it8709_wr(struct ite_dev *dev, u8 val, int index)
+{
+	/* we wait before writing, and not afterwards, since this allows us to
+	 * pipeline the host CPU with the microcontroller */
+	it8709_wait(dev);
+	it8709_wm(dev, val, IT8709_REG_VAL);
+	it8709_wm(dev, index, IT8709_REG_IDX);
+	it8709_wm(dev, IT8709_WRITE, IT8709_MODE);
+}
+
+/* retrieve a bitmask of the current causes for a pending interrupt; this may
+ * be composed of ITE_IRQ_TX_FIFO, ITE_IRQ_RX_FIFO and ITE_IRQ_RX_FIFO_OVERRUN
+ * */
+static int it8709_get_irq_causes(struct ite_dev *dev)
+{
+	u8 iflags;
+	int ret = 0;
+
+	ite_dbg("%s called", __func__);
+
+	/* read the interrupt flags */
+	iflags = it8709_rm(dev, IT8709_IIR);
+
+	if (iflags & IT85_TLDLI)
+		ret |= ITE_IRQ_TX_FIFO;
+	if (iflags & IT85_RDAI)
+		ret |= ITE_IRQ_RX_FIFO;
+	if (iflags & IT85_RFOI)
+		ret |= ITE_IRQ_RX_FIFO_OVERRUN;
+
+	return ret;
+}
+
+/* set the carrier parameters; to be called with the spinlock held */
+static void it8709_set_carrier_params(struct ite_dev *dev, bool high_freq,
+				      bool use_demodulator,
+				      u8 carrier_freq_bits, u8 allowance_bits,
+				      u8 pulse_width_bits)
+{
+	u8 val;
+
+	ite_dbg("%s called", __func__);
+
+	val = (it8709_rr(dev, IT85_C0CFR)
+		     &~(IT85_HCFS | IT85_CFQ)) |
+	    carrier_freq_bits;
+
+	if (high_freq)
+		val |= IT85_HCFS;
+
+	it8709_wr(dev, val, IT85_C0CFR);
+
+	/* program the C0RCR register */
+	val = it8709_rr(dev, IT85_C0RCR)
+		& ~(IT85_RXEND | IT85_RXDCR);
+
+	if (use_demodulator)
+		val |= IT85_RXEND;
+
+	val |= allowance_bits;
+
+	it8709_wr(dev, val, IT85_C0RCR);
+
+	/* program the C0TCR register */
+	val = it8709_rr(dev, IT85_C0TCR) & ~IT85_TXMPW;
+	val |= pulse_width_bits;
+	it8709_wr(dev, val, IT85_C0TCR);
+}
+
+/* read up to buf_size bytes from the RX FIFO; to be called with the spinlock
+ * held */
+static int it8709_get_rx_bytes(struct ite_dev *dev, u8 * buf, int buf_size)
+{
+	int fifo, read = 0;
+
+	ite_dbg("%s called", __func__);
+
+	/* read how many bytes are still in the FIFO */
+	fifo = it8709_rm(dev, IT8709_RFSR) & IT85_RXFBC;
+
+	while (fifo > 0 && buf_size > 0) {
+		*(buf++) = it8709_rm(dev, IT8709_FIFO + read);
+		fifo--;
+		read++;
+		buf_size--;
+	}
+
+	/* 'clear' the FIFO by setting the writing index to 0; this is
+	 * completely bound to be racy, but we can't help it, since it's a
+	 * limitation of the protocol */
+	it8709_wm(dev, 0, IT8709_RFSR);
+
+	return read;
+}
+
+/* return how many bytes are still in the FIFO; this will be called
+ * with the device spinlock NOT HELD while waiting for the TX FIFO to get
+ * empty; let's expect this won't be a problem */
+static int it8709_get_tx_used_slots(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	return it8709_rr(dev, IT85_C0TFSR) & IT85_TXFBC;
+}
+
+/* put a byte to the TX fifo; this should be called with the spinlock held */
+static void it8709_put_tx_byte(struct ite_dev *dev, u8 value)
+{
+	it8709_wr(dev, value, IT85_C0DR);
+}
+
+/* idle the receiver so that we won't receive samples until another
+  pulse is detected; this must be called with the device spinlock held */
+static void it8709_idle_rx(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* disable streaming by clearing RXACT writing it as 1 */
+	it8709_wr(dev, it8709_rr(dev, IT85_C0RCR) | IT85_RXACT,
+			    IT85_C0RCR);
+
+	/* clear the FIFO */
+	it8709_wr(dev, it8709_rr(dev, IT85_C0MSTCR) | IT85_FIFOCLR,
+			    IT85_C0MSTCR);
+}
+
+/* disable the receiver; this must be called with the device spinlock held */
+static void it8709_disable_rx(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* disable the receiver interrupts */
+	it8709_wr(dev, it8709_rr(dev, IT85_C0IER) &
+			    ~(IT85_RDAIE | IT85_RFOIE),
+			    IT85_C0IER);
+
+	/* disable the receiver */
+	it8709_wr(dev, it8709_rr(dev, IT85_C0RCR) & ~IT85_RXEN,
+			    IT85_C0RCR);
+
+	/* clear the FIFO and RXACT (actually RXACT should have been cleared
+	 * in the previous it8709_wr(dev, ) call) */
+	it8709_idle_rx(dev);
+}
+
+/* enable the receiver; this must be called with the device spinlock held */
+static void it8709_enable_rx(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* enable the receiver by setting RXEN */
+	it8709_wr(dev, it8709_rr(dev, IT85_C0RCR) | IT85_RXEN,
+			    IT85_C0RCR);
+
+	/* just prepare it to idle for the next reception */
+	it8709_idle_rx(dev);
+
+	/* enable the receiver interrupts and master enable flag */
+	it8709_wr(dev, it8709_rr(dev, IT85_C0IER)
+			    |IT85_RDAIE | IT85_RFOIE | IT85_IEC,
+			    IT85_C0IER);
+}
+
+/* disable the transmitter interrupt; this must be called with the device
+ * spinlock held */
+static void it8709_disable_tx_interrupt(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* disable the transmitter interrupts */
+	it8709_wr(dev, it8709_rr(dev, IT85_C0IER) & ~IT85_TLDLIE,
+			    IT85_C0IER);
+}
+
+/* enable the transmitter interrupt; this must be called with the device
+ * spinlock held */
+static void it8709_enable_tx_interrupt(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* enable the transmitter interrupts and master enable flag */
+	it8709_wr(dev, it8709_rr(dev, IT85_C0IER)
+			    |IT85_TLDLIE | IT85_IEC,
+			    IT85_C0IER);
+}
+
+/* disable the device; this must be called with the device spinlock held */
+static void it8709_disable(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* clear out all interrupt enable flags */
+	it8709_wr(dev,
+			    it8709_rr(dev,
+				      IT85_C0IER) & ~(IT85_IEC | IT85_RFOIE |
+						      IT85_RDAIE |
+						      IT85_TLDLIE), IT85_C0IER);
+
+	/* disable the receiver */
+	it8709_disable_rx(dev);
+
+	/* erase the FIFO */
+	it8709_wr(dev, IT85_FIFOCLR | it8709_rr(dev, IT85_C0MSTCR),
+			    IT85_C0MSTCR);
+}
+
+/* initialize the hardware */
+static void it8709_init_hardware(struct ite_dev *dev)
+{
+	ite_dbg("%s called", __func__);
+
+	/* disable all the interrupts */
+	it8709_wr(dev,
+			    it8709_rr(dev,
+				      IT85_C0IER) & ~(IT85_IEC | IT85_RFOIE |
+						      IT85_RDAIE |
+						      IT85_TLDLIE), IT85_C0IER);
+
+	/* program the baud rate divisor */
+	it8709_wr(dev, ITE_BAUDRATE_DIVISOR & 0xff, IT85_C0BDLR);
+	it8709_wr(dev, (ITE_BAUDRATE_DIVISOR >> 8) & 0xff,
+			IT85_C0BDHR);
+
+	/* program the C0MSTCR register defaults */
+	it8709_wr(dev, (it8709_rr(dev, IT85_C0MSTCR) & ~(IT85_ILSEL |
+								   IT85_ILE
+								   | IT85_FIFOTL
+								   |
+								   IT85_FIFOCLR
+								   |
+								   IT85_RESET))
+			    | IT85_FIFOTL_DEFAULT, IT85_C0MSTCR);
+
+	/* program the C0RCR register defaults */
+	it8709_wr(dev,
+			    (it8709_rr(dev, IT85_C0RCR) &
+			     ~(IT85_RXEN | IT85_RDWOS | IT85_RXEND
+			       | IT85_RXACT | IT85_RXDCR)) |
+			    ITE_RXDCR_DEFAULT, IT85_C0RCR);
+
+	/* program the C0TCR register defaults */
+	it8709_wr(dev, (it8709_rr(dev, IT85_C0TCR)
+				  &~(IT85_TXMPM | IT85_TXMPW))
+			    |IT85_TXRLE | IT85_TXENDF |
+			    IT85_TXMPM_DEFAULT |
+			    IT85_TXMPW_DEFAULT, IT85_C0TCR);
+
+	/* program the carrier parameters */
+	ite_set_carrier_params(dev);
+}
+
+
+/* generic hardware setup/teardown code */
+
+/* activate the device for use */
+static int ite_open(struct rc_dev *rcdev)
+{
+	struct ite_dev *dev = rcdev->priv;
+	unsigned long flags;
+
+	ite_dbg("%s called", __func__);
+
+	spin_lock_irqsave(&dev->lock, flags);
+	dev->in_use = true;
+
+	/* enable the receiver */
+	dev->params.enable_rx(dev);
+
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	return 0;
+}
+
+/* deactivate the device for use */
+static void ite_close(struct rc_dev *rcdev)
+{
+	struct ite_dev *dev = rcdev->priv;
+	unsigned long flags;
+
+	ite_dbg("%s called", __func__);
+
+	spin_lock_irqsave(&dev->lock, flags);
+	dev->in_use = false;
+
+	/* wait for any transmission to end */
+	spin_unlock_irqrestore(&dev->lock, flags);
+	wait_event_interruptible(dev->tx_ended, !dev->transmitting);
+	spin_lock_irqsave(&dev->lock, flags);
+
+	dev->params.disable(dev);
+
+	spin_unlock_irqrestore(&dev->lock, flags);
+}
+
+/* supported models and their parameters */
+static const struct ite_dev_params ite_dev_descs[] = {
+	{	/* 0: ITE8704 */
+	       .model = "ITE8704 CIR transceiver",
+	       .io_region_size = IT87_IOREG_LENGTH,
+	       .hw_tx_capable = true,
+	       .sample_period = (u32) (1000000000ULL / 115200),
+	       .tx_carrier_freq = 38000,
+	       .tx_duty_cycle = 33,
+	       .rx_low_carrier_freq = 0,
+	       .rx_high_carrier_freq = 0,
+
+		/* operations */
+	       .get_irq_causes = it87_get_irq_causes,
+	       .enable_rx = it87_enable_rx,
+	       .idle_rx = it87_idle_rx,
+	       .disable_rx = it87_idle_rx,
+	       .get_rx_bytes = it87_get_rx_bytes,
+	       .enable_tx_interrupt = it87_enable_tx_interrupt,
+	       .disable_tx_interrupt = it87_disable_tx_interrupt,
+	       .get_tx_used_slots = it87_get_tx_used_slots,
+	       .put_tx_byte = it87_put_tx_byte,
+	       .disable = it87_disable,
+	       .init_hardware = it87_init_hardware,
+	       .set_carrier_params = it87_set_carrier_params,
+	       },
+	{	/* 1: ITE8713 */
+	       .model = "ITE8713 CIR transceiver",
+	       .io_region_size = IT87_IOREG_LENGTH,
+	       .hw_tx_capable = true,
+	       .sample_period = (u32) (1000000000ULL / 115200),
+	       .tx_carrier_freq = 38000,
+	       .tx_duty_cycle = 33,
+	       .rx_low_carrier_freq = 0,
+	       .rx_high_carrier_freq = 0,
+
+		/* operations */
+	       .get_irq_causes = it87_get_irq_causes,
+	       .enable_rx = it87_enable_rx,
+	       .idle_rx = it87_idle_rx,
+	       .disable_rx = it87_idle_rx,
+	       .get_rx_bytes = it87_get_rx_bytes,
+	       .enable_tx_interrupt = it87_enable_tx_interrupt,
+	       .disable_tx_interrupt = it87_disable_tx_interrupt,
+	       .get_tx_used_slots = it87_get_tx_used_slots,
+	       .put_tx_byte = it87_put_tx_byte,
+	       .disable = it87_disable,
+	       .init_hardware = it87_init_hardware,
+	       .set_carrier_params = it87_set_carrier_params,
+	       },
+	{	/* 2: ITE8708 */
+	       .model = "ITE8708 CIR transceiver",
+	       .io_region_size = IT8708_IOREG_LENGTH,
+	       .hw_tx_capable = true,
+	       .sample_period = (u32) (1000000000ULL / 115200),
+	       .tx_carrier_freq = 38000,
+	       .tx_duty_cycle = 33,
+	       .rx_low_carrier_freq = 0,
+	       .rx_high_carrier_freq = 0,
+
+		/* operations */
+	       .get_irq_causes = it8708_get_irq_causes,
+	       .enable_rx = it8708_enable_rx,
+	       .idle_rx = it8708_idle_rx,
+	       .disable_rx = it8708_idle_rx,
+	       .get_rx_bytes = it8708_get_rx_bytes,
+	       .enable_tx_interrupt = it8708_enable_tx_interrupt,
+	       .disable_tx_interrupt =
+	       it8708_disable_tx_interrupt,
+	       .get_tx_used_slots = it8708_get_tx_used_slots,
+	       .put_tx_byte = it8708_put_tx_byte,
+	       .disable = it8708_disable,
+	       .init_hardware = it8708_init_hardware,
+	       .set_carrier_params = it8708_set_carrier_params,
+	       },
+	{	/* 3: ITE8709 */
+	       .model = "ITE8709 CIR transceiver",
+	       .io_region_size = IT8709_IOREG_LENGTH,
+	       .hw_tx_capable = true,
+	       .sample_period = (u32) (1000000000ULL / 115200),
+	       .tx_carrier_freq = 38000,
+	       .tx_duty_cycle = 33,
+	       .rx_low_carrier_freq = 0,
+	       .rx_high_carrier_freq = 0,
+
+		/* operations */
+	       .get_irq_causes = it8709_get_irq_causes,
+	       .enable_rx = it8709_enable_rx,
+	       .idle_rx = it8709_idle_rx,
+	       .disable_rx = it8709_idle_rx,
+	       .get_rx_bytes = it8709_get_rx_bytes,
+	       .enable_tx_interrupt = it8709_enable_tx_interrupt,
+	       .disable_tx_interrupt =
+	       it8709_disable_tx_interrupt,
+	       .get_tx_used_slots = it8709_get_tx_used_slots,
+	       .put_tx_byte = it8709_put_tx_byte,
+	       .disable = it8709_disable,
+	       .init_hardware = it8709_init_hardware,
+	       .set_carrier_params = it8709_set_carrier_params,
+	       },
+};
+
+static const struct pnp_device_id ite_ids[] = {
+	{"ITE8704", 0},		/* Default model */
+	{"ITE8713", 1},		/* CIR found in EEEBox 1501U */
+	{"ITE8708", 2},		/* Bridged IT8512 */
+	{"ITE8709", 3},		/* SRAM-Bridged IT8512 */
+	{"", 0},
+};
+
+/* allocate memory, probe hardware, and initialize everything */
+static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
+		     *dev_id)
+{
+	const struct ite_dev_params *dev_desc = NULL;
+	struct ite_dev *itdev = NULL;
+	struct rc_dev *rdev = NULL;
+	int ret = -ENOMEM;
+	int model_no;
+
+	ite_dbg("%s called", __func__);
+
+	itdev = kzalloc(sizeof(struct ite_dev), GFP_KERNEL);
+	if (!itdev)
+		return ret;
+
+	/* input device for IR remote (and tx) */
+	rdev = rc_allocate_device();
+	if (!rdev)
+		goto failure;
+
+	ret = -ENODEV;
+
+	/* get the model number */
+	model_no = (int)dev_id->driver_data;
+	ite_pr(KERN_NOTICE, "Auto-detected model: %s\n",
+		ite_dev_descs[model_no].model);
+
+	if (model_number >= 0 && model_number < ARRAY_SIZE(ite_dev_descs)) {
+		model_no = model_number;
+		ite_pr(KERN_NOTICE, "The model has been fixed by a module "
+			"parameter.");
+	}
+
+	ite_pr(KERN_NOTICE, "Using model: %s\n", ite_dev_descs[model_no].model);
+
+	/* get the description for the device */
+	dev_desc = &ite_dev_descs[model_no];
+
+	/* validate pnp resources */
+	if (!pnp_port_valid(pdev, 0) ||
+	    pnp_port_len(pdev, 0) != dev_desc->io_region_size) {
+		dev_err(&pdev->dev, "IR PNP Port not valid!\n");
+		goto failure;
+	}
+
+	if (!pnp_irq_valid(pdev, 0)) {
+		dev_err(&pdev->dev, "PNP IRQ not valid!\n");
+		goto failure;
+	}
+
+	/* store resource values */
+	itdev->cir_addr = pnp_port_start(pdev, 0);
+	itdev->cir_irq =pnp_irq(pdev, 0);
+
+	/* initialize spinlocks */
+	spin_lock_init(&itdev->lock);
+
+	/* initialize raw event */
+	init_ir_raw_event(&itdev->rawir);
+
+	ret = -EBUSY;
+	/* now claim resources */
+	if (!request_region(itdev->cir_addr,
+				dev_desc->io_region_size, ITE_DRIVER_NAME))
+		goto failure;
+
+	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
+			ITE_DRIVER_NAME, (void *)itdev))
+		goto failure;
+
+	/* set driver data into the pnp device */
+	pnp_set_drvdata(pdev, itdev);
+	itdev->pdev = pdev;
+
+	/* initialize waitqueues for transmission */
+	init_waitqueue_head(&itdev->tx_queue);
+	init_waitqueue_head(&itdev->tx_ended);
+
+	/* copy model-specific parameters */
+	itdev->params = *dev_desc;
+
+	/* apply any overrides */
+	if (sample_period > 0)
+		itdev->params.sample_period = sample_period;
+
+	if (tx_carrier_freq > 0)
+		itdev->params.tx_carrier_freq = tx_carrier_freq;
+
+	if (tx_duty_cycle > 0 && tx_duty_cycle <= 100)
+		itdev->params.tx_duty_cycle = tx_duty_cycle;
+
+	if (rx_low_carrier_freq > 0)
+		itdev->params.rx_low_carrier_freq = rx_low_carrier_freq;
+
+	if (rx_high_carrier_freq > 0)
+		itdev->params.rx_high_carrier_freq = rx_high_carrier_freq;
+
+	/* print out parameters */
+	ite_pr(KERN_NOTICE, "TX-capable: %d\n", (int)
+			 itdev->params.hw_tx_capable);
+	ite_pr(KERN_NOTICE, "Sample period (ns): %ld\n", (long)
+		     itdev->params.sample_period);
+	ite_pr(KERN_NOTICE, "TX carrier frequency (Hz): %d\n", (int)
+		     itdev->params.tx_carrier_freq);
+	ite_pr(KERN_NOTICE, "TX duty cycle (%%): %d\n", (int)
+		     itdev->params.tx_duty_cycle);
+	ite_pr(KERN_NOTICE, "RX low carrier frequency (Hz): %d\n", (int)
+		     itdev->params.rx_low_carrier_freq);
+	ite_pr(KERN_NOTICE, "RX high carrier frequency (Hz): %d\n", (int)
+		     itdev->params.rx_high_carrier_freq);
+
+	/* set up hardware initial state */
+	itdev->params.init_hardware(itdev);
+
+	/* set up ir-core props */
+	rdev->priv = itdev;
+	rdev->driver_type = RC_DRIVER_IR_RAW;
+	rdev->allowed_protos = RC_TYPE_ALL;
+	rdev->open = ite_open;
+	rdev->close = ite_close;
+	rdev->s_idle = ite_s_idle;
+	rdev->s_rx_carrier_range = ite_set_rx_carrier_range;
+	rdev->min_timeout = ITE_MIN_IDLE_TIMEOUT;
+	rdev->max_timeout = ITE_MAX_IDLE_TIMEOUT;
+	rdev->timeout = ITE_IDLE_TIMEOUT;
+	rdev->rx_resolution = ITE_BAUDRATE_DIVISOR *
+				itdev->params.sample_period;
+	rdev->tx_resolution = ITE_BAUDRATE_DIVISOR *
+				itdev->params.sample_period;
+
+	/* set up transmitter related values if needed */
+	if (itdev->params.hw_tx_capable) {
+		rdev->tx_ir = ite_tx_ir;
+		rdev->s_tx_carrier = ite_set_tx_carrier;
+		rdev->s_tx_duty_cycle = ite_set_tx_duty_cycle;
+	}
+
+	rdev->input_name = dev_desc->model;
+	rdev->input_id.bustype = BUS_HOST;
+	rdev->input_id.vendor = PCI_VENDOR_ID_ITE;
+	rdev->input_id.product = 0;
+	rdev->input_id.version = 0;
+	rdev->driver_name = ITE_DRIVER_NAME;
+	rdev->map_name = RC_MAP_RC6_MCE;
+
+	ret = rc_register_device(rdev);
+	if (ret)
+		goto failure;
+
+	itdev->rdev = rdev;
+	ite_pr(KERN_NOTICE, "driver has been successfully loaded\n");
+
+	return 0;
+
+failure:
+	if (itdev->cir_irq)
+		free_irq(itdev->cir_irq, itdev);
+
+	if (itdev->cir_addr)
+		release_region(itdev->cir_addr, itdev->params.io_region_size);
+
+	rc_free_device(rdev);
+	kfree(itdev);
+
+	return ret;
+}
+
+static void __devexit ite_remove(struct pnp_dev *pdev)
+{
+	struct ite_dev *dev = pnp_get_drvdata(pdev);
+	unsigned long flags;
+
+	ite_dbg("%s called", __func__);
+
+	spin_lock_irqsave(&dev->lock, flags);
+
+	/* disable hardware */
+	dev->params.disable(dev);
+
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	/* free resources */
+	free_irq(dev->cir_irq, dev);
+	release_region(dev->cir_addr, dev->params.io_region_size);
+
+	rc_unregister_device(dev->rdev);
+
+	kfree(dev);
+}
+
+static int ite_suspend(struct pnp_dev *pdev, pm_message_t state)
+{
+	struct ite_dev *dev = pnp_get_drvdata(pdev);
+	unsigned long flags;
+
+	ite_dbg("%s called", __func__);
+
+	spin_lock_irqsave(&dev->lock, flags);
+
+	/* disable all interrupts */
+	dev->params.disable(dev);
+
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	return 0;
+}
+
+static int ite_resume(struct pnp_dev *pdev)
+{
+	int ret = 0;
+	struct ite_dev *dev = pnp_get_drvdata(pdev);
+	unsigned long flags;
+
+	ite_dbg("%s called", __func__);
+
+	spin_lock_irqsave(&dev->lock, flags);
+
+	if (dev->transmitting) {
+		/* wake up the transmitter */
+		wake_up_interruptible(&dev->tx_queue);
+	} else {
+		/* enable the receiver */
+		dev->params.enable_rx(dev);
+	}
+
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	return ret;
+}
+
+static void ite_shutdown(struct pnp_dev *pdev)
+{
+	struct ite_dev *dev = pnp_get_drvdata(pdev);
+	unsigned long flags;
+
+	ite_dbg("%s called", __func__);
+
+	spin_lock_irqsave(&dev->lock, flags);
+
+	/* disable all interrupts */
+	dev->params.disable(dev);
+
+	spin_unlock_irqrestore(&dev->lock, flags);
+}
+
+static struct pnp_driver ite_driver = {
+	.name		= ITE_DRIVER_NAME,
+	.id_table	= ite_ids,
+	.probe		= ite_probe,
+	.remove		= __devexit_p(ite_remove),
+	.suspend	= ite_suspend,
+	.resume		= ite_resume,
+	.shutdown	= ite_shutdown,
+};
+
+int ite_init(void)
+{
+	return pnp_register_driver(&ite_driver);
+}
+
+void ite_exit(void)
+{
+	pnp_unregister_driver(&ite_driver);
+}
+
+MODULE_DEVICE_TABLE(pnp, ite_ids);
+MODULE_DESCRIPTION("ITE Tech Inc. IT8712F/ITE8512F CIR driver");
+
+MODULE_AUTHOR("Juan J. Garcia de Soria <skandalfo@gmail.com>");
+MODULE_LICENSE("GPL");
+
+module_init(ite_init);
+module_exit(ite_exit);
diff --git a/drivers/media/rc/ite-cir.h b/drivers/media/rc/ite-cir.h
new file mode 100644
index 0000000..996bb06
--- /dev/null
+++ b/drivers/media/rc/ite-cir.h
@@ -0,0 +1,478 @@
+/*
+ * Driver for ITE Tech Inc. IT8712F/IT8512F CIR
+ *
+ * Copyright (C) 2010 Juan Jesús García de Soria <skandalfo@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA.
+ */
+
+/* platform driver name to register */
+#define ITE_DRIVER_NAME "ite-cir"
+
+/* logging macros */
+#define ite_pr(level, text, ...) \
+    printk(level KBUILD_MODNAME ": " text, ## __VA_ARGS__)
+#define ite_dbg(text, ...) \
+    if (debug) \
+        printk(KERN_DEBUG \
+            KBUILD_MODNAME ": " text "\n" , ## __VA_ARGS__)
+#define ite_dbg_verbose(text, ...) \
+    if (debug > 1) \
+        printk(KERN_DEBUG \
+            KBUILD_MODNAME ": " text "\n" , ## __VA_ARGS__)
+
+/* FIFO sizes */
+#define ITE_TX_FIFO_LEN 32
+#define ITE_RX_FIFO_LEN 32
+
+/* interrupt types */
+#define ITE_IRQ_TX_FIFO        1
+#define ITE_IRQ_RX_FIFO        2
+#define ITE_IRQ_RX_FIFO_OVERRUN    4
+
+/* forward declaration */
+struct ite_dev;
+
+/* struct for storing the parameters of different recognized devices */
+struct ite_dev_params {
+	/* model of the device */
+	const char *model;
+
+	/* size of the I/O region */
+	int io_region_size;
+
+	/* true if the hardware supports transmission */
+	bool hw_tx_capable;
+
+	/* base sampling period, in ns */
+	u32 sample_period;
+
+	/* rx low carrier frequency, in Hz, 0 means no demodulation */
+	unsigned int rx_low_carrier_freq;
+
+	/* tx high carrier frequency, in Hz, 0 means no demodulation */
+	unsigned int rx_high_carrier_freq;
+
+	/* tx carrier frequency, in Hz */
+	unsigned int tx_carrier_freq;
+
+	/* duty cycle, 0-100 */
+	int tx_duty_cycle;
+
+	/* hw-specific operation function pointers; most of these must be
+	 * called while holding the spin lock, except for the TX FIFO length
+	 * one */
+	/* get pending interrupt causes */
+	int (*get_irq_causes) (struct ite_dev * dev);
+
+	/* enable rx */
+	void (*enable_rx) (struct ite_dev * dev);
+
+	/* make rx enter the idle state; keep listening for a pulse, but stop
+	 * streaming space bytes */
+	void (*idle_rx) (struct ite_dev * dev);
+
+	/* disable rx completely */
+	void (*disable_rx) (struct ite_dev * dev);
+
+	/* read bytes from RX FIFO; return read count */
+	int (*get_rx_bytes) (struct ite_dev * dev, u8 * buf, int buf_size);
+
+	/* enable tx FIFO space available interrupt */
+	void (*enable_tx_interrupt) (struct ite_dev * dev);
+
+	/* disable tx FIFO space available interrupt */
+	void (*disable_tx_interrupt) (struct ite_dev * dev);
+
+	/* get number of full TX FIFO slots */
+	int (*get_tx_used_slots) (struct ite_dev * dev);
+
+	/* put a byte to the TX FIFO */
+	void (*put_tx_byte) (struct ite_dev * dev, u8 value);
+
+	/* disable hardware completely */
+	void (*disable) (struct ite_dev * dev);
+
+	/* initialize the hardware */
+	void (*init_hardware) (struct ite_dev * dev);
+
+	/* set the carrier parameters */
+	void (*set_carrier_params) (struct ite_dev * dev, bool high_freq,
+				    bool use_demodulator, u8 carrier_freq_bits,
+				    u8 allowance_bits, u8 pulse_width_bits);
+};
+
+/* ITE CIR device structure */
+struct ite_dev {
+	struct pnp_dev *pdev;
+	struct rc_dev *rdev;
+	struct ir_raw_event rawir;
+
+	/* sync data */
+	spinlock_t lock;
+	bool in_use, transmitting;
+
+	/* transmit support */
+	int tx_fifo_allowance;
+	wait_queue_head_t tx_queue, tx_ended;
+
+	/* hardware I/O settings */
+	unsigned long cir_addr;
+	int cir_irq;
+
+	/* overridable copy of model parameters */
+	struct ite_dev_params params;
+};
+
+/* common values for all kinds of hardware */
+
+/* baud rate divisor default */
+#define ITE_BAUDRATE_DIVISOR		1
+
+/* low-speed carrier frequency limits (Hz) */
+#define ITE_LCF_MIN_CARRIER_FREQ	27000
+#define ITE_LCF_MAX_CARRIER_FREQ	58000
+
+/* high-speed carrier frequency limits (Hz) */
+#define ITE_HCF_MIN_CARRIER_FREQ	400000
+#define ITE_HCF_MAX_CARRIER_FREQ	500000
+
+/* default carrier freq for when demodulator is off (Hz) */
+#define ITE_DEFAULT_CARRIER_FREQ	38000
+
+/* default idling timeout in ns (0.2 seconds) */
+#define ITE_IDLE_TIMEOUT		200000000UL
+
+/* limit timeout values */
+#define ITE_MIN_IDLE_TIMEOUT		100000000UL
+#define ITE_MAX_IDLE_TIMEOUT		1000000000UL
+
+/* convert bits to us */
+#define ITE_BITS_TO_NS(bits, sample_period) \
+((u32) ((bits) * ITE_BAUDRATE_DIVISOR * sample_period))
+
+/*
+ * n in RDCR produces a tolerance of +/- n * 6.25% around the center
+ * carrier frequency...
+ *
+ * From two limit frequencies, L (low) and H (high), we can get both the
+ * center frequency F = (L + H) / 2 and the variation from the center
+ * frequency A = (H - L) / (H + L). We can use this in order to honor the
+ * s_rx_carrier_range() call in ir-core. We'll suppose that any request
+ * setting L=0 means we must shut down the demodulator.
+ */
+#define ITE_RXDCR_PER_10000_STEP 625
+
+/* high speed carrier freq values */
+#define ITE_CFQ_400		0x03
+#define ITE_CFQ_450		0x08
+#define ITE_CFQ_480		0x0b
+#define ITE_CFQ_500		0x0d
+
+/* values for pulse widths */
+#define ITE_TXMPW_A		0x02
+#define ITE_TXMPW_B		0x03
+#define ITE_TXMPW_C		0x04
+#define ITE_TXMPW_D		0x05
+#define ITE_TXMPW_E		0x06
+
+/* values for demodulator carrier range allowance */
+#define ITE_RXDCR_DEFAULT	0x01	/* default carrier range */
+#define ITE_RXDCR_MAX		0x07	/* default carrier range */
+
+/* DR TX bits */
+#define ITE_TX_PULSE		0x00
+#define ITE_TX_SPACE		0x80
+#define ITE_TX_MAX_RLE		0x80
+#define ITE_TX_RLE_MASK		0x7f
+
+/*
+ * IT8712F
+ *
+ * hardware data obtained from:
+ *
+ * IT8712F
+ * Environment Control – Low Pin Count Input / Output
+ * (EC - LPC I/O)
+ * Preliminary Specification V0. 81
+ */
+
+/* register offsets */
+#define IT87_DR		0x00	/* data register */
+#define IT87_IER	0x01	/* interrupt enable register */
+#define IT87_RCR	0x02	/* receiver control register */
+#define IT87_TCR1	0x03	/* transmitter control register 1 */
+#define IT87_TCR2	0x04	/* transmitter control register 2 */
+#define IT87_TSR	0x05	/* transmitter status register */
+#define IT87_RSR	0x06	/* receiver status register */
+#define IT87_BDLR	0x05	/* baud rate divisor low byte register */
+#define IT87_BDHR	0x06	/* baud rate divisor high byte register */
+#define IT87_IIR	0x07	/* interrupt identification register */
+
+#define IT87_IOREG_LENGTH 0x08	/* length of register file */
+
+/* IER bits */
+#define IT87_TLDLIE	0x01	/* transmitter low data interrupt enable */
+#define IT87_RDAIE	0x02	/* receiver data available interrupt enable */
+#define IT87_RFOIE	0x04	/* receiver FIFO overrun interrupt enable */
+#define IT87_IEC	0x08	/* interrupt enable control */
+#define IT87_BR		0x10	/* baud rate register enable */
+#define IT87_RESET	0x20	/* reset */
+
+/* RCR bits */
+#define IT87_RXDCR	0x07	/* receiver demodulation carrier range mask */
+#define IT87_RXACT	0x08	/* receiver active */
+#define IT87_RXEND	0x10	/* receiver demodulation enable */
+#define IT87_RXEN	0x20	/* receiver enable */
+#define IT87_HCFS	0x40	/* high-speed carrier frequency select */
+#define IT87_RDWOS	0x80	/* receiver data without sync */
+
+/* TCR1 bits */
+#define IT87_TXMPM	0x03	/* transmitter modulation pulse mode mask */
+#define IT87_TXMPM_DEFAULT 0x00	/* modulation pulse mode default */
+#define IT87_TXENDF	0x04	/* transmitter deferral */
+#define IT87_TXRLE	0x08	/* transmitter run length enable */
+#define IT87_FIFOTL	0x30	/* FIFO level threshold mask */
+#define IT87_FIFOTL_DEFAULT 0x20	/* FIFO level threshold default
+					 * 0x00 -> 1, 0x10 -> 7, 0x20 -> 17,
+					 * 0x30 -> 25 */
+#define IT87_ILE	0x40	/* internal loopback enable */
+#define IT87_FIFOCLR	0x80	/* FIFO clear bit */
+
+/* TCR2 bits */
+#define IT87_TXMPW	0x07	/* transmitter modulation pulse width mask */
+#define IT87_TXMPW_DEFAULT 0x04	/* default modulation pulse width */
+#define IT87_CFQ	0xf8	/* carrier frequency mask */
+#define IT87_CFQ_SHIFT	3	/* carrier frequency bit shift */
+
+/* TSR bits */
+#define IT87_TXFBC	0x3f	/* transmitter FIFO byte count mask */
+
+/* RSR bits */
+#define IT87_RXFBC	0x3f	/* receiver FIFO byte count mask */
+#define IT87_RXFTO	0x80	/* receiver FIFO time-out */
+
+/* IIR bits */
+#define IT87_IP		0x01	/* interrupt pending */
+#define IT87_II		0x06	/* interrupt identification mask */
+#define IT87_II_NOINT	0x00	/* no interrupt */
+#define IT87_II_TXLDL	0x02	/* transmitter low data level */
+#define IT87_II_RXDS	0x04	/* receiver data stored */
+#define IT87_II_RXFO	0x06	/* receiver FIFO overrun */
+
+/*
+ * IT8512E/F
+ *
+ * Hardware data obtained from:
+ *
+ * IT8512E/F
+ * Embedded Controller
+ * Preliminary Specification V0.4.1
+ *
+ * Note that the CIR registers are not directly available to the host, because
+ * they only are accessible to the integrated microcontroller. Thus, in order
+ * use it, some kind of bridging is required. As the bridging may depend on
+ * the controller firmware in use, we are going to use the PNP ID in order to
+ * determine the strategy and ports available. See after these generic
+ * IT8512E/F register definitions for register definitions for those
+ * strategies.
+ */
+
+/* register offsets */
+#define IT85_C0DR	0x00	/* data register */
+#define IT85_C0MSTCR	0x01	/* master control register */
+#define IT85_C0IER	0x02	/* interrupt enable register */
+#define IT85_C0IIR	0x03	/* interrupt identification register */
+#define IT85_C0CFR	0x04	/* carrier frequency register */
+#define IT85_C0RCR	0x05	/* receiver control register */
+#define IT85_C0TCR	0x06	/* transmitter control register */
+#define IT85_C0SCK	0x07	/* slow clock control register */
+#define IT85_C0BDLR	0x08	/* baud rate divisor low byte register */
+#define IT85_C0BDHR	0x09	/* baud rate divisor high byte register */
+#define IT85_C0TFSR	0x0a	/* transmitter FIFO status register */
+#define IT85_C0RFSR	0x0b	/* receiver FIFO status register */
+#define IT85_C0WCL	0x0d	/* wakeup code length register */
+#define IT85_C0WCR	0x0e	/* wakeup code read/write register */
+#define IT85_C0WPS	0x0f	/* wakeup power control/status register */
+
+#define IT85_IOREG_LENGTH 0x10	/* length of register file */
+
+/* C0MSTCR bits */
+#define IT85_RESET	0x01	/* reset */
+#define IT85_FIFOCLR	0x02	/* FIFO clear bit */
+#define IT85_FIFOTL	0x0c	/* FIFO level threshold mask */
+#define IT85_FIFOTL_DEFAULT 0x08	/* FIFO level threshold default
+					 * 0x00 -> 1, 0x04 -> 7, 0x08 -> 17,
+					 * 0x0c -> 25 */
+#define IT85_ILE	0x10	/* internal loopback enable */
+#define IT85_ILSEL	0x20	/* internal loopback select */
+
+/* C0IER bits */
+#define IT85_TLDLIE	0x01	/* TX low data level interrupt enable */
+#define IT85_RDAIE	0x02	/* RX data available interrupt enable */
+#define IT85_RFOIE	0x04	/* RX FIFO overrun interrupt enable */
+#define IT85_IEC	0x80	/* interrupt enable function control */
+
+/* C0IIR bits */
+#define IT85_TLDLI	0x01	/* transmitter low data level interrupt */
+#define IT85_RDAI	0x02	/* receiver data available interrupt */
+#define IT85_RFOI	0x04	/* receiver FIFO overrun interrupt */
+#define IT85_NIP	0x80	/* no interrupt pending */
+
+/* C0CFR bits */
+#define IT85_CFQ	0x1f	/* carrier frequency mask */
+#define IT85_HCFS	0x20	/* high speed carrier frequency select */
+
+/* C0RCR bits */
+#define IT85_RXDCR	0x07	/* receiver demodulation carrier range mask */
+#define IT85_RXACT	0x08	/* receiver active */
+#define IT85_RXEND	0x10	/* receiver demodulation enable */
+#define IT85_RDWOS	0x20	/* receiver data without sync */
+#define IT85_RXEN	0x80	/* receiver enable */
+
+/* C0TCR bits */
+#define IT85_TXMPW	0x07	/* transmitter modulation pulse width mask */
+#define IT85_TXMPW_DEFAULT 0x04	/* default modulation pulse width */
+#define IT85_TXMPM	0x18	/* transmitter modulation pulse mode mask */
+#define IT85_TXMPM_DEFAULT 0x00	/* modulation pulse mode default */
+#define IT85_TXENDF	0x20	/* transmitter deferral */
+#define IT85_TXRLE	0x40	/* transmitter run length enable */
+
+/* C0SCK bits */
+#define IT85_SCKS	0x01	/* slow clock select */
+#define IT85_TXDCKG	0x02	/* TXD clock gating */
+#define IT85_DLL1P8E	0x04	/* DLL 1.8432M enable */
+#define IT85_DLLTE	0x08	/* DLL test enable */
+#define IT85_BRCM	0x70	/* baud rate count mode */
+#define IT85_DLLOCK	0x80	/* DLL lock */
+
+/* C0TFSR bits */
+#define IT85_TXFBC	0x3f	/* transmitter FIFO count mask */
+
+/* C0RFSR bits */
+#define IT85_RXFBC	0x3f	/* receiver FIFO count mask */
+#define IT85_RXFTO	0x80	/* receiver FIFO time-out */
+
+/* C0WCL bits */
+#define IT85_WCL	0x3f	/* wakeup code length mask */
+
+/* C0WPS bits */
+#define IT85_CIRPOSIE	0x01	/* power on/off status interrupt enable */
+#define IT85_CIRPOIS	0x02	/* power on/off interrupt status */
+#define IT85_CIRPOII	0x04	/* power on/off interrupt identification */
+#define IT85_RCRST	0x10	/* wakeup code reading counter reset bit */
+#define IT85_WCRST	0x20	/* wakeup code writing counter reset bit */
+
+/*
+ * ITE8708
+ *
+ * Hardware data obtained from hacked driver for IT8512 in this forum post:
+ *
+ *  http://ubuntuforums.org/showthread.php?t=1028640
+ *
+ * Although there's no official documentation for that driver, analysis would
+ * suggest that it maps the 16 registers of IT8512 onto two 8-register banks,
+ * selectable by a single bank-select bit that's mapped onto both banks. The
+ * IT8512 registers are mapped in a different order, so that the first bank
+ * maps the ones that are used more often, and two registers that share a
+ * reserved high-order bit are placed at the same offset in both banks in
+ * order to reuse the reserved bit as the bank select bit.
+ */
+
+/* register offsets */
+
+/* mapped onto both banks */
+#define IT8708_BANKSEL	0x07	/* bank select register */
+#define IT8708_HRAE	0x80	/* high registers access enable */
+
+/* mapped onto the low bank */
+#define IT8708_C0DR	0x00	/* data register */
+#define IT8708_C0MSTCR	0x01	/* master control register */
+#define IT8708_C0IER	0x02	/* interrupt enable register */
+#define IT8708_C0IIR	0x03	/* interrupt identification register */
+#define IT8708_C0RFSR	0x04	/* receiver FIFO status register */
+#define IT8708_C0RCR	0x05	/* receiver control register */
+#define IT8708_C0TFSR	0x06	/* transmitter FIFO status register */
+#define IT8708_C0TCR	0x07	/* transmitter control register */
+
+/* mapped onto the high bank */
+#define IT8708_C0BDLR	0x01	/* baud rate divisor low byte register */
+#define IT8708_C0BDHR	0x02	/* baud rate divisor high byte register */
+#define IT8708_C0CFR	0x04	/* carrier frequency register */
+
+/* registers whose bank mapping we don't know, since they weren't being used
+ * in the hacked driver... most probably they belong to the high bank too,
+ * since they fit in the holes the other registers leave */
+#define IT8708_C0SCK	0x03	/* slow clock control register */
+#define IT8708_C0WCL	0x05	/* wakeup code length register */
+#define IT8708_C0WCR	0x06	/* wakeup code read/write register */
+#define IT8708_C0WPS	0x07	/* wakeup power control/status register */
+
+#define IT8708_IOREG_LENGTH 0x08	/* length of register file */
+
+/* two more registers that are defined in the hacked driver, but can't be
+ * found in the data sheets; no idea what they are or how they are accessed,
+ * since the hacked driver doesn't seem to use them */
+#define IT8708_CSCRR	0x00
+#define IT8708_CGPINTR	0x01
+
+/* CSCRR bits */
+#define IT8708_CSCRR_SCRB 0x3f
+#define IT8708_CSCRR_PM	0x80
+
+/* CGPINTR bits */
+#define IT8708_CGPINT	0x01
+
+/*
+ * ITE8709
+ *
+ * Hardware interfacing data obtained from the original lirc_ite8709 driver.
+ * Verbatim from its sources:
+ *
+ * The ITE8709 device seems to be the combination of IT8512 superIO chip and
+ * a specific firmware running on the IT8512's embedded micro-controller.
+ * In addition of the embedded micro-controller, the IT8512 chip contains a
+ * CIR module and several other modules. A few modules are directly accessible
+ * by the host CPU, but most of them are only accessible by the
+ * micro-controller. The CIR module is only accessible by the
+ * micro-controller.
+ *
+ * The battery-backed SRAM module is accessible by the host CPU and the
+ * micro-controller. So one of the MC's firmware role is to act as a bridge
+ * between the host CPU and the CIR module. The firmware implements a kind of
+ * communication protocol using the SRAM module as a shared memory. The IT8512
+ * specification is publicly available on ITE's web site, but the
+ * communication protocol is not, so it was reverse-engineered.
+ */
+
+/* register offsets */
+#define IT8709_RAM_IDX	0x00	/* index into the SRAM module bytes */
+#define IT8709_RAM_VAL	0x01	/* read/write data to the indexed byte */
+
+#define IT8709_IOREG_LENGTH 0x02	/* length of register file */
+
+/* register offsets inside the SRAM module */
+#define IT8709_MODE	0x1a	/* request/ack byte */
+#define IT8709_REG_IDX	0x1b	/* index of the CIR register to access */
+#define IT8709_REG_VAL	0x1c	/* value read/to be written */
+#define IT8709_IIR	0x1e	/* interrupt identification register */
+#define IT8709_RFSR	0x1f	/* receiver FIFO status register */
+#define IT8709_FIFO	0x20	/* start of in RAM RX FIFO copy */
+
+/* MODE values */
+#define IT8709_IDLE	0x00
+#define IT8709_WRITE	0x01
+#define IT8709_READ	0x02
-- 
1.7.1

