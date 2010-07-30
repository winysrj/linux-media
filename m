Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45485 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab0G3Lje (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 07:39:34 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 13/13] IR: Port ene driver to new IR subsystem and enable it.
Date: Fri, 30 Jul 2010 14:38:53 +0300
Message-Id: <1280489933-20865-14-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
References: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 MAINTAINERS               |    6 +
 drivers/media/IR/Kconfig  |   14 +
 drivers/media/IR/Makefile |    1 +
 drivers/media/IR/ene_ir.c |  595 +++++++++++++++++----------------------------
 drivers/media/IR/ene_ir.h |   51 ++---
 5 files changed, 265 insertions(+), 402 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 56a36d7..587785a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2188,6 +2188,12 @@ F:	drivers/misc/cb710/
 F:	drivers/mmc/host/cb710-mmc.*
 F:	include/linux/cb710.h
 
+ENE KB2426 (ENE0100/ENE020XX) INFRARED RECEIVER
+M:	Maxim Levitsky <maximlevitsky@gmail.com>
+S:	Maintained
+F:	drivers/media/IR/ene_ir.c
+F:	drivers/media/IR/ene_ir.h
+
 EPSON 1355 FRAMEBUFFER DRIVER
 M:	Christopher Hoover <ch@murgatroid.com>
 M:	Christopher Hoover <ch@hpl.hp.com>
diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index fc48a3f..3f62bf9 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -105,4 +105,18 @@ config IR_MCEUSB
 	   To compile this driver as a module, choose M here: the
 	   module will be called mceusb.
 
+config IR_ENE
+	tristate "ENE eHome Receiver/Transciever (pnp id: ENE0100/ENE02xxx)"
+	depends on PNP
+	depends on IR_CORE
+	---help---
+	   Say Y here to enable support for integrated infrared receiver
+	   /transciever made by ENE.
+
+	   You can see if you have it by looking at lspnp output.
+	   Output should include ENE0100 ENE0200 or something similiar.
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called ene_ir.
+
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
index 9d11caf..de1e5c4 100644
--- a/drivers/media/IR/ene_ir.c
+++ b/drivers/media/IR/ene_ir.c
@@ -1,5 +1,5 @@
 /*
- * driver for ENE KB3926 B/C/D CIR (also known as ENE0100/ENE0200/ENE0201)
+ * driver for ENE KB3926 B/C/D CIR (pnp id: ENE0XXX)
  *
  * Copyright (C) 2010 Maxim Levitsky <maximlevitsky@gmail.com>
  *
@@ -25,20 +25,20 @@
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
-#include <linux/uaccess.h>
-#include "lirc_ene0100.h"
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <media/ir-core.h>
+#include <media/ir-common.h>
+#include "ene_ir.h"
 
 
 static int sample_period = -1;
 static int enable_idle = 1;
-static int enable_duty_carrier;
 static int input = 1;
 static int debug;
 static int txsim;
 
-static void ene_rx_set_idle(struct ene_device *dev, int idle);
 static int ene_irq_status(struct ene_device *dev);
-static void ene_send_sample(struct ene_device *dev, unsigned long sample);
 
 /* read a hardware register */
 static u8 ene_hw_read_reg(struct ene_device *dev, u16 reg)
@@ -85,6 +85,7 @@ static int ene_hw_detect(struct ene_device *dev)
 	u8 hw_revision, old_ver;
 	u8 tmp;
 	u8 fw_capabilities;
+	int pll_freq;
 
 	tmp = ene_hw_read_reg(dev, ENE_HW_UNK);
 	ene_hw_write_reg(dev, ENE_HW_UNK, tmp & ~ENE_HW_UNK_CLR);
@@ -96,6 +97,17 @@ static int ene_hw_detect(struct ene_device *dev)
 	hw_revision = ene_hw_read_reg(dev, ENE_HW_VERSION);
 	old_ver = ene_hw_read_reg(dev, ENE_HW_VER_OLD);
 
+	pll_freq = (ene_hw_read_reg(dev, ENE_PLLFRH) << 4) +
+		(ene_hw_read_reg(dev, ENE_PLLFRL) >> 2);
+
+	if (pll_freq != 1000)
+		dev->rx_period_adjust = 4;
+	else
+		dev->rx_period_adjust = 2;
+
+
+	ene_printk(KERN_NOTICE, "PLL freq = %d\n", pll_freq);
+
 	if (hw_revision == 0xFF) {
 
 		ene_printk(KERN_WARNING, "device seems to be disabled\n");
@@ -160,7 +172,7 @@ static int ene_hw_detect(struct ene_device *dev)
 }
 
 /* this enables/disables IR input via gpio40*/
-static void ene_enable_gpio40_recieve(struct ene_device *dev, int enable)
+static void ene_enable_gpio40_receive(struct ene_device *dev, int enable)
 {
 	ene_hw_write_reg_mask(dev, ENE_CIR_CONF2, enable ?
 			      0 : ENE_CIR_CONF2_GPIO40DIS,
@@ -168,13 +180,13 @@ static void ene_enable_gpio40_recieve(struct ene_device *dev, int enable)
 }
 
 /* this enables/disables IR via standard input */
-static void ene_enable_normal_recieve(struct ene_device *dev, int enable)
+static void ene_enable_normal_receive(struct ene_device *dev, int enable)
 {
 	ene_hw_write_reg(dev, ENE_CIR_CONF1, enable ? ENE_CIR_CONF1_RX_ON : 0);
 }
 
 /* this enables/disables IR input via unused fan tachtometer input */
-static void ene_enable_fan_recieve(struct ene_device *dev, int enable)
+static void ene_enable_fan_receive(struct ene_device *dev, int enable)
 {
 	if (!enable)
 		ene_hw_write_reg(dev, ENE_FAN_AS_IN1, 0);
@@ -186,7 +198,7 @@ static void ene_enable_fan_recieve(struct ene_device *dev, int enable)
 }
 
 
-/* Sense current recieved carrier */
+/* Sense current received carrier */
 static int ene_rx_sense_carrier(struct ene_device *dev)
 {
 	int period = ene_hw_read_reg(dev, ENE_RX_CARRIER);
@@ -209,37 +221,37 @@ static int ene_rx_sense_carrier(struct ene_device *dev)
 /* determine which input to use*/
 static void ene_rx_set_inputs(struct ene_device *dev)
 {
-	int learning_mode = dev->learning_enabled || dev->rx_carrier_sense;
+	int learning_mode = dev->learning_enabled;
 
-	ene_dbg("RX: setup reciever, learning mode = %d", learning_mode);
+	ene_dbg("RX: setup receiver, learning mode = %d", learning_mode);
 
-	ene_enable_normal_recieve(dev, 1);
+	ene_enable_normal_receive(dev, 1);
 
 	/* old hardware doesn't support learning mode for sure */
 	if (dev->hw_revision <= ENE_HW_B)
 		return;
 
-	/* reciever not learning capable, still set gpio40 correctly */
+	/* receiver not learning capable, still set gpio40 correctly */
 	if (!dev->hw_learning_and_tx_capable) {
-		ene_enable_gpio40_recieve(dev, !dev->hw_gpio40_learning);
+		ene_enable_gpio40_receive(dev, !dev->hw_gpio40_learning);
 		return;
 	}
 
 	/* enable learning mode */
 	if (learning_mode) {
-		ene_enable_gpio40_recieve(dev, dev->hw_gpio40_learning);
+		ene_enable_gpio40_receive(dev, dev->hw_gpio40_learning);
 
 		/* fan input is not used for learning */
 		if (dev->hw_fan_as_normal_input)
-			ene_enable_fan_recieve(dev, 0);
+			ene_enable_fan_receive(dev, 0);
 
 	/* disable learning mode */
 	} else {
 		if (dev->hw_fan_as_normal_input) {
-			ene_enable_fan_recieve(dev, 1);
-			ene_enable_normal_recieve(dev, 0);
+			ene_enable_fan_receive(dev, 1);
+			ene_enable_normal_receive(dev, 0);
 		} else
-			ene_enable_gpio40_recieve(dev,
+			ene_enable_gpio40_receive(dev,
 					!dev->hw_gpio40_learning);
 	}
 
@@ -249,6 +261,16 @@ static void ene_rx_set_inputs(struct ene_device *dev)
 
 	ene_hw_write_reg_mask(dev, ENE_CIR_CONF2, learning_mode ?
 			      ENE_CIR_CONF2_LEARN2 : 0, ENE_CIR_CONF2_LEARN2);
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
 }
 
 /* Enable the device for receive */
@@ -277,147 +299,33 @@ static void ene_rx_enable(struct ene_device *dev)
 	/* ack any pending irqs - just in case */
 	ene_irq_status(dev);
 
-	/* enter idle mode */
-	ene_rx_set_idle(dev, 1);
-
 	/* enable firmware bits */
 	ene_hw_write_reg_mask(dev, ENE_FW1,
 			      ENE_FW1_ENABLE | ENE_FW1_IRQ,
 			      ENE_FW1_ENABLE | ENE_FW1_IRQ);
+
+	/* enter idle mode */
+	ir_raw_event_set_idle(dev->idev, 1);
+	ir_raw_event_reset(dev->idev);
+
 }
 
-/* Disable the device reciever */
+/* Disable the device receiver */
 static void ene_rx_disable(struct ene_device *dev)
 {
 	/* disable inputs */
-	ene_enable_normal_recieve(dev, 0);
+	ene_enable_normal_receive(dev, 0);
 
 	if (dev->hw_fan_as_normal_input)
-		ene_enable_fan_recieve(dev, 0);
+		ene_enable_fan_receive(dev, 0);
 
 	/* disable hardware IRQ and firmware flag */
 	ene_hw_write_reg_mask(dev, ENE_FW1, 0, ENE_FW1_ENABLE | ENE_FW1_IRQ);
 
-	ene_rx_set_idle(dev, 1);
-}
-
-/*  send current sample to the user */
-static void ene_rx_flush(struct ene_device *dev, int timeout)
-{
-	unsigned long value;
-
-	value =	dev->rx_sample_pulse ? LIRC_PULSE(dev->rx_sample) :
-					LIRC_SPACE(dev->rx_sample);
-	ene_send_sample(dev, value);
-	dev->rx_sample = 0;
-	dev->rx_sample_pulse = 0;
-}
-
-/* recieve new sample and process it */
-static void ene_rx_sample(struct ene_device *dev, int sample, int is_pulse)
-{
-	ene_dbg("RX: sample %8d (%s)", sample, is_pulse ? "pulse" : "space");
-
-	/* ignore spaces in idle mode, can get them on revC */
-	/* also ignore a space in front of first pulse */
-	if (dev->rx_idle && !is_pulse)
-		return;
-
-	/* get out of idle mode now */
-	if (dev->rx_idle)
-		ene_rx_set_idle(dev, 0);
-
-	if (!dev->rx_sample) {
-		dev->rx_sample = sample;
-		dev->rx_sample_pulse = is_pulse;
-	} else if (is_pulse == dev->rx_sample_pulse)
-		dev->rx_sample += sample;
-	else {
-		ene_rx_flush(dev, 0);
-		dev->rx_sample = sample;
-		dev->rx_sample_pulse = is_pulse;
-	}
-
-	if (is_pulse)
-		return;
-
-	/* overflow sample from fan input recieved, enable idle mode */
-	if (dev->rx_fan_input_inuse &&
-		sample == ENE_FAN_VALUE_MASK * ENE_SAMPLE_PERIOD_FAN) {
-		ene_rx_set_idle(dev, 1);
-		return;
-	}
-
-	if (!dev->rx_fan_input_inuse) {
-		/* Report timeout if enabled */
-		if (dev->rx_timeout && dev->rx_send_timeout_packet &&
-			!dev->rx_timeout_sent &&
-				dev->rx_sample > dev->rx_timeout) {
-			ene_dbg("RX: sending timeout sample");
-			ene_send_sample(dev, LIRC_TIMEOUT(dev->rx_sample));
-			dev->rx_timeout_sent = 1;
-		}
-
-		/* too large sample accumulated via normal input.
-		note that on revC, hardware idle mode turns on automaticly,
-			so max gap should be less that the gap after which
-			hw stops sending samples */
-		if (dev->rx_sample > ENE_MAXGAP) {
-			ene_rx_set_idle(dev, 1);
-			return;
-		}
-	}
+	ir_raw_event_set_idle(dev->idev, 1);
+	ir_raw_event_reset(dev->idev);
 }
 
-/* enable or disable idle mode */
-static void ene_rx_set_idle(struct ene_device *dev, int idle)
-{
-	struct timeval now;
-	int disable_sampler = 0;
-
-
-	/* Also put hardware sampler in 'idle' mode on revB*/
-	/* revC and higher do that automaticly (firmware does?) */
-	if ((dev->hw_revision < ENE_HW_C) && enable_idle)
-		if (idle)
-			disable_sampler = 1;
-
-	ene_hw_write_reg_mask(dev, ENE_CIR_SAMPLE_PERIOD,
-			      disable_sampler ? 0 : ENE_CIR_SAMPLE_OVERFLOW,
-			      ENE_CIR_SAMPLE_OVERFLOW);
-	dev->rx_idle = idle;
-
-	/* remember when we have entered the idle mode */
-	if (idle) {
-		ene_dbg("RX: going into idle mode");
-		do_gettimeofday(&dev->rx_gap_start);
-		return;
-	}
-
-	ene_dbg("RX: back from idle mode");
-
-	/* send the gap between keypresses now */
-	do_gettimeofday(&now);
-
-	if (dev->rx_sample_pulse) {
-		ene_dbg("RX: somehow we recieved a pulse before idle mode???");
-		return;
-	}
-
-	/* manually calculate and recieve the gap between keypresses */
-	if (now.tv_sec - dev->rx_gap_start.tv_sec > 16)
-		dev->rx_sample = LIRC_SPACE(LIRC_VALUE_MASK);
-	else
-		dev->rx_sample +=
-		    1000000ull * (now.tv_sec - dev->rx_gap_start.tv_sec)
-		    + now.tv_usec - dev->rx_gap_start.tv_usec;
-
-	if (dev->rx_sample > LIRC_SPACE(LIRC_VALUE_MASK))
-		dev->rx_sample = LIRC_SPACE(LIRC_VALUE_MASK);
-
-	ene_rx_flush(dev, 0);
-	dev->rx_timeout_sent = 0;
-}
 
 /* prepare transmission */
 static void ene_tx_prepare(struct ene_device *dev)
@@ -436,6 +344,8 @@ static void ene_tx_prepare(struct ene_device *dev)
 	/* Set carrier */
 	if (dev->tx_period) {
 
+		/* NOTE: duty cycle handling is just a guess, it might
+			not be aviable. Default values were tested */
 		int tx_period_in500ns = dev->tx_period * 2;
 
 		int tx_pulse_width_in_500ns =
@@ -459,7 +369,6 @@ static void ene_tx_prepare(struct ene_device *dev)
 		conf1 &= ~ENE_CIR_CONF1_TX_CARR;
 
 	ene_hw_write_reg(dev, ENE_CIR_CONF1, conf1);
-	dev->tx_underway = 1;
 
 }
 
@@ -467,11 +376,11 @@ static void ene_tx_prepare(struct ene_device *dev)
 static void ene_tx_complete(struct ene_device *dev)
 {
 	ene_hw_write_reg(dev, ENE_CIR_CONF1, dev->saved_conf1);
-	dev->tx_underway = 0;
+	dev->tx_buffer = NULL;
 }
 
 /* set transmit mask */
-static void ene_tx_set_transmiter_mask(struct ene_device *dev)
+static void ene_tx_hw_set_transmiter_mask(struct ene_device *dev)
 {
 	u8 txport1 = ene_hw_read_reg(dev, ENE_TX_PORT1) & ~ENE_TX_PORT1_EN;
 	u8 txport2 = ene_hw_read_reg(dev, ENE_TX_PORT2) & ~ENE_TX_PORT2_EN;
@@ -492,8 +401,8 @@ static void ene_tx_sample(struct ene_device *dev)
 	u8 raw_tx;
 	u32 sample;
 
-	if (!dev->tx_underway) {
-		ene_dbg("TX: attempt to transmit while hw isn't setup");
+	if (!dev->tx_buffer) {
+		ene_dbg("TX: attempt to transmit NULL buffer");
 		return;
 	}
 
@@ -623,6 +532,7 @@ static irqreturn_t ene_isr(int irq, void *data)
 	int carrier = 0;
 	irqreturn_t retval = IRQ_NONE;
 	struct ene_device *dev = (struct ene_device *)data;
+	struct ir_raw_event ev;
 
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
@@ -646,12 +556,13 @@ static irqreturn_t ene_isr(int irq, void *data)
 		goto unlock;
 
 
-	if ((debug && dev->learning_enabled) || dev->rx_carrier_sense)
+	if (dev->carrier_detect_enabled || debug)
 		carrier = ene_rx_sense_carrier(dev);
-
-	if (dev->rx_carrier_sense && carrier)
-		ene_send_sample(dev, LIRC_FREQUENCY(carrier));
-
+#if 0
+	/* TODO */
+	if (dev->carrier_detect_enabled && carrier)
+		ir_raw_event_report_frequency(dev->idev, carrier);
+#endif
 
 	for (i = 0; i < ENE_SAMPLES_SIZE; i++) {
 		hw_value = ene_hw_read_reg(dev,
@@ -672,13 +583,25 @@ static irqreturn_t ene_isr(int irq, void *data)
 			pulse = !(hw_value & ENE_SAMPLE_SPC_MASK);
 			hw_value &= ENE_SAMPLE_VALUE_MASK;
 			hw_sample = hw_value * sample_period;
+
+			if (dev->rx_period_adjust) {
+				hw_sample *= (100 - dev->rx_period_adjust);
+				hw_sample /= 100;
+			}
 		}
 		/* no more data */
 		if (!(hw_value))
 			break;
 
-		ene_rx_sample(dev, hw_sample, pulse);
+		ene_dbg("RX: %d (%s)", hw_sample, pulse ? "pulse" : "space");
+
+
+		ev.duration = hw_sample * 1000;
+		ev.pulse = pulse;
+		ir_raw_event_store_with_filter(dev->idev, &ev);
 	}
+
+	ir_raw_event_handle(dev->idev);
 unlock:
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 	return retval;
@@ -687,8 +610,6 @@ unlock:
 /* Initialize default settings */
 static void ene_setup_settings(struct ene_device *dev)
 {
-	dev->rx_send_timeout_packet = 0;
-	dev->rx_timeout = ENE_MAXGAP;
 	dev->tx_period = 32;
 	dev->tx_duty_cycle = 25; /*%*/
 	dev->transmitter_mask = 3;
@@ -698,11 +619,7 @@ static void ene_setup_settings(struct ene_device *dev)
 	dev->learning_enabled =
 		(input == 2 && dev->hw_learning_and_tx_capable);
 
-	/* Clear accumulated sample bufer */
-	dev->rx_sample = 0;
-	dev->rx_sample_pulse = 0;
 	dev->rx_pointer = -1;
-	dev->rx_carrier_sense = 0;
 
 }
 
@@ -732,144 +649,97 @@ static void ene_close(void *data)
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 }
 
-/* outside interface for settings */
-static int ene_ioctl(struct inode *node, struct file *file,
-		      unsigned int cmd, unsigned long arg)
+/* outside interface: set transmitter mask */
+static int ene_set_tx_mask(void *data, u32 tx_mask)
 {
-	int lvalue = 0, retval, tmp;
+	struct ene_device *dev = (struct ene_device *)data;
 	unsigned long flags;
-	struct ene_device *dev = lirc_get_pdata(file);
-
-
-	switch (cmd) {
-	case LIRC_SET_SEND_CARRIER:
-	case LIRC_SET_SEND_DUTY_CYCLE:
-	case LIRC_SET_TRANSMITTER_MASK:
-	case LIRC_SET_MEASURE_CARRIER_MODE:
-	case LIRC_SET_REC_CARRIER:
-		/* All these aren't possible without this */
-		if (!dev->hw_learning_and_tx_capable)
-			return -ENOSYS;
-		/* Fall through */
-	case LIRC_SET_REC_TIMEOUT:
-	case LIRC_SET_REC_TIMEOUT_REPORTS:
-		retval = get_user(lvalue, (unsigned int *) arg);
-		if (retval)
-			return retval;
+	ene_dbg("TX: attempt to set transmitter mask %02x", tx_mask);
+
+	/* invalid txmask */
+	if (!tx_mask || tx_mask & ~0x3) {
+		ene_dbg("TX: invalid mask");
+		/* return count of transmitters */
+		return 2;
 	}
 
-	switch (cmd) {
-	case LIRC_SET_SEND_CARRIER:
-		ene_dbg("TX: attempt to set tx carrier to %d kHz", lvalue);
-		tmp = 1000000 / lvalue; /* (1 / freq) (* # usec in 1 sec) */
+	spin_lock_irqsave(&dev->hw_lock, flags);
+	dev->transmitter_mask = tx_mask;
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	return 0;
+}
 
-		if (tmp && (tmp > ENE_TX_PERIOD_MAX ||
-				tmp < ENE_TX_PERIOD_MIN)) {
+/* outside interface : set tx carrier */
+static int ene_set_tx_carrier(void *data, u32 carrier)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	unsigned long flags;
+	u32 period = 1000000 / carrier; /* (1 / freq) (* # usec in 1 sec) */
 
-			ene_dbg("TX: out of range %d-%d carrier, "
-				"falling back to 32 kHz",
-				1000 / ENE_TX_PERIOD_MIN,
-				1000 / ENE_TX_PERIOD_MAX);
+	ene_dbg("TX: attempt to set tx carrier to %d kHz", carrier);
 
-			tmp = 32; /* this is just a coincidence!!! */
-		}
-		ene_dbg("TX: set carrier to %d kHz", lvalue);
+	if (period && (period > ENE_TX_PERIOD_MAX ||
+			period < ENE_TX_PERIOD_MIN)) {
 
-		spin_lock_irqsave(&dev->hw_lock, flags);
-		dev->tx_period = tmp;
-		spin_unlock_irqrestore(&dev->hw_lock, flags);
-		break;
-	case LIRC_SET_SEND_DUTY_CYCLE:
-		ene_dbg("TX: attempt to set duty cycle to %d%%", lvalue);
+		ene_dbg("TX: out of range %d-%d carrier, "
+			"falling back to 32 kHz",
+			1000 / ENE_TX_PERIOD_MIN,
+			1000 / ENE_TX_PERIOD_MAX);
 
-		if ((lvalue >= 100) || (lvalue <= 0)) {
-			retval = -EINVAL;
-			break;
-		}
-		spin_lock_irqsave(&dev->hw_lock, flags);
-		dev->tx_duty_cycle = lvalue;
-		spin_unlock_irqrestore(&dev->hw_lock, flags);
-		break;
-	case LIRC_SET_TRANSMITTER_MASK:
-		ene_dbg("TX: attempt to set transmitter mask %02x", lvalue);
-
-		/* invalid txmask */
-		if (!lvalue || lvalue & ~0x3) {
-			ene_dbg("TX: invalid mask");
-			/* this supposed to return num of transmitters */
-			retval =  2;
-			break;
-		}
-		spin_lock_irqsave(&dev->hw_lock, flags);
-		dev->transmitter_mask = lvalue;
-		spin_unlock_irqrestore(&dev->hw_lock, flags);
-		break;
-	case LIRC_SET_REC_CARRIER:
-		tmp = (lvalue > ENE_NORMAL_RX_HI || lvalue < ENE_NORMAL_RX_LOW);
-
-		if (tmp != dev->learning_enabled) {
-			spin_lock_irqsave(&dev->hw_lock, flags);
-			dev->learning_enabled = tmp;
-			ene_rx_set_inputs(dev);
-			spin_unlock_irqrestore(&dev->hw_lock, flags);
-		}
-		break;
-	case LIRC_SET_REC_TIMEOUT:
-		spin_lock_irqsave(&dev->hw_lock, flags);
-		dev->rx_timeout = lvalue;
-		spin_unlock_irqrestore(&dev->hw_lock, flags);
-		ene_dbg("RX: set rx report timeout to %d", dev->rx_timeout);
-		break;
-	case LIRC_SET_REC_TIMEOUT_REPORTS:
-		spin_lock_irqsave(&dev->hw_lock, flags);
-		dev->rx_send_timeout_packet = lvalue;
-		spin_unlock_irqrestore(&dev->hw_lock, flags);
-		ene_dbg("RX: %sable timeout reports",
-				dev->rx_send_timeout_packet ? "en" : "dis");
-		break;
-	case LIRC_SET_MEASURE_CARRIER_MODE:
-		if (dev->rx_carrier_sense == lvalue)
-			break;
-		spin_lock_irqsave(&dev->hw_lock, flags);
-		dev->rx_carrier_sense = lvalue;
-		ene_rx_set_inputs(dev);
-		spin_unlock_irqrestore(&dev->hw_lock, flags);
-		break;
-	case LIRC_GET_REC_RESOLUTION:
-		tmp = dev->rx_fan_input_inuse ?
-			ENE_SAMPLE_PERIOD_FAN : sample_period;
-		retval = put_user(tmp, (unsigned long *) arg);
-		break;
-	default:
-		retval = -ENOIOCTLCMD;
-		break;
+		period = 32; /* this is just a coincidence!!! */
 	}
+	ene_dbg("TX: set carrier to %d kHz", carrier);
 
-	return retval;
+	spin_lock_irqsave(&dev->hw_lock, flags);
+	dev->tx_period = period;
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	return 0;
 }
 
-/* outside interface: transmit */
-static ssize_t ene_transmit(struct file *file, const char *buf,
-				  size_t n, loff_t *ppos)
+
+/* outside interface: enable learning mode */
+static int ene_set_learning_mode(void *data, int enable)
 {
-	struct ene_device *dev = lirc_get_pdata(file);
+	struct ene_device *dev = (struct ene_device *)data;
 	unsigned long flags;
+	if (enable == dev->learning_enabled)
+		return 0;
 
-	if (!dev)
-		return -EFAULT;
+	spin_lock_irqsave(&dev->hw_lock, flags);
+	dev->learning_enabled = enable;
+	ene_rx_set_inputs(dev);
+	spin_unlock_irqrestore(&dev->hw_lock, flags);
+	return 0;
+}
 
-	if (!dev->hw_learning_and_tx_capable)
-		return -ENODEV;
+/* outside interface: set rec carrier */
+static int ene_set_rec_carrier(void *data, u32 min, u32 max)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	ene_set_learning_mode(dev,
+		max > ENE_NORMAL_RX_HI || min < ENE_NORMAL_RX_LOW);
+	return 0;
+}
 
-	if (n % sizeof(int))
-		return -EINVAL;
+/* outside interface: enable or disable idle mode */
+static void ene_rx_set_idle(void *data, int idle)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	ene_dbg("%sabling idle mode", idle ? "en" : "dis");
 
-	if (n > ENE_TXBUF_SIZE * sizeof(int))
-		return -ENOMEM;
+	ene_hw_write_reg_mask(dev, ENE_CIR_SAMPLE_PERIOD,
+		(enable_idle && idle) ? 0 : ENE_CIR_SAMPLE_OVERFLOW,
+			ENE_CIR_SAMPLE_OVERFLOW);
+}
 
-	if (copy_from_user(dev->tx_buffer, buf, n))
-		return -EFAULT;
 
+/* outside interface: transmit */
+static int ene_transmit(void *data, int *buf, u32 n)
+{
+	struct ene_device *dev = (struct ene_device *)data;
+	unsigned long flags;
+
+	dev->tx_buffer = buf;
 	dev->tx_len = n / sizeof(int);
 	dev->tx_pos = 0;
 	dev->tx_reg = 0;
@@ -881,7 +751,7 @@ static ssize_t ene_transmit(struct file *file, const char *buf,
 
 	spin_lock_irqsave(&dev->hw_lock, flags);
 
-	ene_tx_set_transmiter_mask(dev);
+	ene_tx_hw_set_transmiter_mask(dev);
 	ene_tx_prepare(dev);
 
 	/* Transmit first two samples */
@@ -897,80 +767,35 @@ static ssize_t ene_transmit(struct file *file, const char *buf,
 		spin_unlock_irqrestore(&dev->hw_lock, flags);
 	} else
 		ene_dbg("TX: done");
-
 	return n;
 }
 
-/* Sends one sample to the user */
-static void ene_send_sample(struct ene_device *dev, unsigned long sample)
-{
-	if (!lirc_buffer_full(dev->lirc_driver->rbuf)) {
-		lirc_buffer_write(dev->lirc_driver->rbuf, (void *)&sample);
-		wake_up(&dev->lirc_driver->rbuf->wait_poll);
-	}
-}
-
-
-static const struct file_operations ene_fops = {
-	.owner		= THIS_MODULE,
-	.write		= ene_transmit,
-	.ioctl		= ene_ioctl,
-};
 
-/* main load function */
-static int ene_probe(struct pnp_dev *pnp_dev,
-		     const struct pnp_device_id *dev_id)
+/* probe entry */
+static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 {
-	struct ene_device *dev;
-	struct lirc_driver *lirc_driver;
 	int error = -ENOMEM;
+	struct ir_dev_props *ir_props;
+	struct input_dev *input_dev;
+	struct ene_device *dev;
 
+	/* allocate memory */
+	input_dev = input_allocate_device();
+	ir_props = kzalloc(sizeof(struct ir_dev_props), GFP_KERNEL);
 	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
 
-	if (!dev)
-		goto err1;
-
-	dev->pnp_dev = pnp_dev;
-	pnp_set_drvdata(pnp_dev, dev);
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
-	lirc_driver->features = LIRC_CAN_REC_MODE2 |
-				LIRC_CAN_GET_REC_RESOLUTION |
-				LIRC_CAN_SET_REC_TIMEOUT;
-	lirc_driver->data = dev;
-	lirc_driver->set_use_inc = ene_open;
-	lirc_driver->set_use_dec = ene_close;
-	lirc_driver->dev = &pnp_dev->dev;
-	lirc_driver->owner = THIS_MODULE;
-	lirc_driver->fops = &ene_fops;
-	lirc_driver->min_timeout = ENE_MINGAP;
-	lirc_driver->max_timeout = ENE_MAXGAP;
-	lirc_driver->rbuf = kzalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-
-	if (!lirc_driver->rbuf)
-		goto err3;
-
-	if (lirc_buffer_init(lirc_driver->rbuf, sizeof(int), sizeof(int) * 512))
-		goto err4;
+	if (!input_dev || !ir_props || !dev)
+		goto error;
 
 	/* validate resources */
+	error = -ENODEV;
+
 	if (!pnp_port_valid(pnp_dev, 0) ||
 	    pnp_port_len(pnp_dev, 0) < ENE_MAX_IO)
-		goto err5;
+		goto error;
 
 	if (!pnp_irq_valid(pnp_dev, 0))
-		goto err5;
+		goto error;
 
 	dev->hw_io = pnp_port_start(pnp_dev, 0);
 	dev->irq = pnp_irq(pnp_dev, 0);
@@ -979,16 +804,19 @@ static int ene_probe(struct pnp_dev *pnp_dev,
 	/* claim the resources */
 	error = -EBUSY;
 	if (!request_region(dev->hw_io, ENE_MAX_IO, ENE_DRIVER_NAME))
-		goto err5;
+		goto error;
 
 	if (request_irq(dev->irq, ene_isr,
 			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev))
-		goto err6;
+		goto error;
+
+	pnp_set_drvdata(pnp_dev, dev);
+	dev->pnp_dev = pnp_dev;
 
 	/* detect hardware version and features */
 	error = ene_hw_detect(dev);
 	if (error)
-		goto err7;
+		goto error;
 
 	ene_setup_settings(dev);
 
@@ -1000,19 +828,21 @@ static int ene_probe(struct pnp_dev *pnp_dev,
 			"Simulation of TX activated\n");
 	}
 
-	if (dev->hw_learning_and_tx_capable) {
-		lirc_driver->features |= LIRC_CAN_SEND_PULSE |
-					 LIRC_CAN_SET_SEND_CARRIER |
-					 LIRC_CAN_SET_TRANSMITTER_MASK;
+	ir_props->driver_type = RC_DRIVER_IR_RAW;
+	ir_props->allowed_protos = IR_TYPE_ALL;
+	ir_props->priv = dev;
+	ir_props->open = ene_open;
+	ir_props->close = ene_close;
+	ir_props->min_timeout = ENE_MINGAP * 1000;
+	ir_props->max_timeout = ENE_MAXGAP * 1000;
+	ir_props->timeout = ENE_MAXGAP * 1000;
 
-		if (enable_duty_carrier)
-			lirc_driver->features |= LIRC_CAN_SET_SEND_DUTY_CYCLE;
+	if (dev->hw_revision == ENE_HW_B)
+		ir_props->s_idle = ene_rx_set_idle;
 
-		if (input == 0)
-			lirc_driver->features |= LIRC_CAN_SET_REC_CARRIER;
 
-		init_completion(&dev->tx_complete);
-	}
+	dev->props = ir_props;
+	dev->idev = input_dev;
 
 	/* don't allow too short/long sample periods */
 	if (sample_period < 5 || sample_period > 0x7F)
@@ -1029,29 +859,50 @@ static int ene_probe(struct pnp_dev *pnp_dev,
 			sample_period = 75;
 	}
 
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
+		/* ir_props->s_carrier_report = ene_set_carrier_report; */
+	}
+
+
 	device_set_wakeup_capable(&pnp_dev->dev, 1);
 	device_set_wakeup_enable(&pnp_dev->dev, 1);
 
+	if (dev->hw_learning_and_tx_capable)
+		input_dev->name = "ENE eHome Infrared Remote Transceiver";
+	else
+		input_dev->name = "ENE eHome Infrared Remote Receiver";
+
+
 	error = -ENODEV;
-	if (lirc_register_driver(lirc_driver))
-		goto err7;
+	if (ir_input_register(input_dev, RC_MAP_RC6_MCE, ir_props,
+							ENE_DRIVER_NAME))
+		goto error;
+
 
 	ene_printk(KERN_NOTICE, "driver has been succesfully loaded\n");
 	return 0;
-
-err7:
-	free_irq(dev->irq, dev);
-err6:
-	release_region(dev->hw_io, ENE_MAX_IO);
-err5:
-	lirc_buffer_free(lirc_driver->rbuf);
-err4:
-	kfree(lirc_driver->rbuf);
-err3:
-	kfree(lirc_driver);
-err2:
+error:
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+	if (dev->hw_io)
+		release_region(dev->hw_io, ENE_MAX_IO);
+
+	input_free_device(input_dev);
+	kfree(ir_props);
 	kfree(dev);
-err1:
 	return error;
 }
 
@@ -1067,9 +918,8 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 
 	free_irq(dev->irq, dev);
 	release_region(dev->hw_io, ENE_MAX_IO);
-	lirc_unregister_driver(dev->lirc_driver->minor);
-	lirc_buffer_free(dev->lirc_driver->rbuf);
-	kfree(dev->lirc_driver);
+	ir_input_unregister(dev->idev);
+	kfree(dev->props);
 	kfree(dev);
 }
 
@@ -1113,6 +963,7 @@ static const struct pnp_device_id ene_ids[] = {
 	{.id = "ENE0100",},
 	{.id = "ENE0200",},
 	{.id = "ENE0201",},
+	{.id = "ENE0202",},
 	{},
 };
 
@@ -1160,13 +1011,9 @@ module_param(txsim, bool, S_IRUGO);
 MODULE_PARM_DESC(txsim,
 	"Simulate TX features on unsupported hardware (dangerous)");
 
-module_param(enable_duty_carrier, bool, S_IRUGO);
-MODULE_PARM_DESC(enable_duty_carrier,
-	"Enable a code that might allow to to set TX carrier duty cycle");
-
 MODULE_DEVICE_TABLE(pnp, ene_ids);
 MODULE_DESCRIPTION
-	("LIRC driver for KB3926B/KB3926C/KB3926D "
+	("Infrared input driver for KB3926B/KB3926C/KB3926D "
 	"(aka ENE0100/ENE0200/ENE0201) CIR port");
 
 MODULE_AUTHOR("Maxim Levitsky");
diff --git a/drivers/media/IR/ene_ir.h b/drivers/media/IR/ene_ir.h
index 06453a8..54c76af 100644
--- a/drivers/media/IR/ene_ir.h
+++ b/drivers/media/IR/ene_ir.h
@@ -1,5 +1,5 @@
 /*
- * driver for ENE KB3926 B/C/D CIR (also known as ENE0100/ENE0200/ENE0201)
+ * driver for ENE KB3926 B/C/D CIR (also known as ENE0XXX)
  *
  * Copyright (C) 2010 Maxim Levitsky <maximlevitsky@gmail.com>
  *
@@ -19,8 +19,7 @@
  * USA
  */
 #include <linux/spinlock.h>
-#include <media/lirc.h>
-#include <media/lirc_dev.h>
+
 
 /* hardware address */
 #define ENE_STATUS		0	/* hardware status - unused */
@@ -62,7 +61,7 @@
 /* transmitter ports */
 #define ENE_TX_PORT2		0xFC01	/* this enables one or both */
 #define ENE_TX_PORT2_EN		0x20	/* TX ports */
-#define ENE_TX_PORT1		0xFC08	
+#define ENE_TX_PORT1		0xFC08
 #define ENE_TX_PORT1_EN		0x02
 
 /* IRQ registers block (for revision B) */
@@ -88,7 +87,7 @@
 #define ENE_CIR_CONF1		0xFEC0
 #define ENE_CIR_CONF1_TX_CLEAR	0x01	/* clear that on revC */
 					/* while transmitting */
-#define ENE_CIR_CONF1_RX_ON	0x07	/* normal reciever enabled */
+#define ENE_CIR_CONF1_RX_ON	0x07	/* normal receiver enabled */
 #define ENE_CIR_CONF1_LEARN1	0x08	/* enabled on learning mode */
 #define ENE_CIR_CONF1_TX_ON	0x30	/* enabled on transmit */
 #define ENE_CIR_CONF1_TX_CARR	0x80	/* send TX carrier or not */
@@ -112,7 +111,7 @@
 /* Unknown TX setting - TX sample period ??? */
 #define ENE_TX_UNK1		0xFECB	/* set to 0x63 */
 
-/* Current recieved carrier period */
+/* Current received carrier period */
 #define ENE_RX_CARRIER		0xFECC	/* RX period (500 ns) */
 #define ENE_RX_CARRIER_VALID	0x80	/* Register content valid */
 
@@ -124,6 +123,9 @@
 
 /* Hardware versions */
 #define ENE_HW_VERSION		0xFF00	/* hardware revision */
+#define ENE_PLLFRH		0xFF16
+#define ENE_PLLFRL		0xFF17
+
 #define ENE_HW_UNK		0xFF1D
 #define ENE_HW_UNK_CLR		0x04
 #define ENE_HW_VER_MAJOR	0xFF1E	/* chip version */
@@ -162,8 +164,7 @@
 
 /******************************************************************************/
 
-#define ENE_DRIVER_NAME		"enecir"
-#define ENE_TXBUF_SIZE (500 * sizeof(int))	/* 500 samples (arbitary) */
+#define ENE_DRIVER_NAME		"ene_ir"
 
 #define ENE_IRQ_RX		1
 #define ENE_IRQ_TX		2
@@ -188,7 +189,8 @@
 
 struct ene_device {
 	struct pnp_dev *pnp_dev;
-	struct lirc_driver *lirc_driver;
+	struct input_dev *idev;
+	struct ir_dev_props *props;
 	int in_use;
 
 	/* hw IO settings */
@@ -198,43 +200,36 @@ struct ene_device {
 
 	/* HW features */
 	int hw_revision;			/* hardware revision */
-	int hw_learning_and_tx_capable;		/* learning capable */
-	int hw_gpio40_learning;			/* gpio40 is learning */
-	int hw_fan_as_normal_input;		/* fan input is used as */
+	bool hw_learning_and_tx_capable;	/* learning capable */
+	bool hw_gpio40_learning;		/* gpio40 is learning */
+	bool hw_fan_as_normal_input;		/* fan input is used as */
 						/* regular input */
 	/* HW state*/
 	int rx_pointer;				/* hw pointer to rx buffer */
-	int rx_fan_input_inuse;			/* is fan input in use for rx*/
+	bool rx_fan_input_inuse;		/* is fan input in use for rx*/
 	int tx_reg;				/* current reg used for TX */
 	u8  saved_conf1;			/* saved FEC0 reg */
-	int learning_enabled;			/* learning input enabled */
-
-	/* RX sample handling */
-	int rx_sample;				/* current recieved sample */
-	int rx_sample_pulse;			/* recieved sample is pulse */
-	int rx_idle;				/* idle mode for RX activated */
-	struct timeval rx_gap_start;		/* time of start of idle */
-	int rx_timeout;				/* time in ms of RX timeout */
-	int rx_send_timeout_packet;		/* do we send RX timeout */
-	int rx_timeout_sent;			/* we sent the timeout packet */
-	int rx_carrier_sense;			/* sense carrier */
 
 	/* TX sample handling */
 	unsigned int tx_sample;			/* current sample for TX */
-	int tx_sample_pulse;			/* current sample is pulse */
+	bool tx_sample_pulse;			/* current sample is pulse */
 
 	/* TX buffer */
-	int tx_buffer[ENE_TXBUF_SIZE];		/* input samples buffer*/
+	int *tx_buffer;				/* input samples buffer*/
 	int tx_pos;				/* position in that bufer */
 	int tx_len;				/* current len of tx buffer */
-	int tx_underway;			/* TX is under way*/
 	int tx_done;				/* done transmitting */
 						/* one more sample pending*/
 	struct completion tx_complete;		/* TX completion */
 	struct timer_list tx_sim_timer;
 
-	/*TX settings */
+	/* TX settings */
 	int tx_period;
 	int tx_duty_cycle;
 	int transmitter_mask;
+
+	/* RX settings */
+	bool learning_enabled;			/* learning input enabled */
+	bool carrier_detect_enabled;		/* carrier detect enabled */
+	int rx_period_adjust;
 };
-- 
1.7.0.4

