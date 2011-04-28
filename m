Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:47924 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760620Ab1D1POQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 11:14:16 -0400
Subject: [PATCH 02/10] rc-core: add TX support to the winbond-cir driver
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@redhat.com
Date: Thu, 28 Apr 2011 17:13:22 +0200
Message-ID: <20110428151322.8272.65682.stgit@felix.hardeman.nu>
In-Reply-To: <20110428151311.8272.17290.stgit@felix.hardeman.nu>
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds preliminary IR TX capabilities to the
winbond-cir driver.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/winbond-cir.c |  431 +++++++++++++++++++++++++++++++++-------
 1 files changed, 356 insertions(+), 75 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index cdb5ef4..6ba4438 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -19,11 +19,12 @@
  *    o DSDT dumps
  *
  *  Supported features:
+ *    o IR Receive
+ *    o IR Transmit
  *    o Wake-On-CIR functionality
  *
  *  To do:
  *    o Learning
- *    o IR Transmit
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -50,6 +51,8 @@
 #include <linux/io.h>
 #include <linux/bitrev.h>
 #include <linux/slab.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
 #include <media/rc-core.h>
 
 #define DRVNAME "winbond-cir"
@@ -118,14 +121,24 @@
 #define WBCIR_IRQ_NONE		0x00
 /* RX data bit for WBCIR_REG_SP3_IER and WBCIR_REG_SP3_EIR */
 #define WBCIR_IRQ_RX		0x01
+/* TX data low bit for WBCIR_REG_SP3_IER and WBCIR_REG_SP3_EIR */
+#define WBCIR_IRQ_TX_LOW	0x02
 /* Over/Under-flow bit for WBCIR_REG_SP3_IER and WBCIR_REG_SP3_EIR */
 #define WBCIR_IRQ_ERR		0x04
+/* TX data empty bit for WBCEIR_REG_SP3_IER and WBCIR_REG_SP3_EIR */
+#define WBCIR_IRQ_TX_EMPTY	0x20
 /* Led enable/disable bit for WBCIR_REG_ECEIR_CTS */
 #define WBCIR_LED_ENABLE	0x80
 /* RX data available bit for WBCIR_REG_SP3_LSR */
 #define WBCIR_RX_AVAIL		0x01
+/* RX data overrun error bit for WBCIR_REG_SP3_LSR */
+#define WBCIR_RX_OVERRUN	0x02
+/* TX End-Of-Transmission bit for WBCIR_REG_SP3_ASCR */
+#define WBCIR_TX_EOT		0x04
 /* RX disable bit for WBCIR_REG_SP3_ASCR */
 #define WBCIR_RX_DISABLE	0x20
+/* TX data underrun error bit for WBCIR_REG_SP3_ASCR */
+#define WBCIR_TX_UNDERRUN	0x40
 /* Extended mode enable bit for WBCIR_REG_SP3_EXCR1 */
 #define WBCIR_EXT_ENABLE	0x01
 /* Select compare register in WBCIR_REG_WCEIR_INDEX (bits 5 & 6) */
@@ -154,6 +167,21 @@ enum wbcir_protocol {
 	IR_PROTOCOL_RC6          = 0x2,
 };
 
+/* Possible states for IR reception */
+enum wbcir_rxstate {
+	WBCIR_RXSTATE_INACTIVE = 0,
+	WBCIR_RXSTATE_ACTIVE,
+	WBCIR_RXSTATE_ERROR
+};
+
+/* Possible states for IR transmission */
+enum wbcir_txstate {
+	WBCIR_TXSTATE_INACTIVE = 0,
+	WBCIR_TXSTATE_ACTIVE,
+	WBCIR_TXSTATE_DONE,
+	WBCIR_TXSTATE_ERROR
+};
+
 /* Misc */
 #define WBCIR_NAME	"Winbond CIR"
 #define WBCIR_ID_FAMILY          0xF1 /* Family ID for the WPCD376I	*/
@@ -166,22 +194,29 @@ enum wbcir_protocol {
 /* Per-device data */
 struct wbcir_data {
 	spinlock_t spinlock;
+	struct rc_dev *dev;
+	struct led_classdev led;
 
 	unsigned long wbase;        /* Wake-Up Baseaddr		*/
 	unsigned long ebase;        /* Enhanced Func. Baseaddr	*/
 	unsigned long sbase;        /* Serial Port Baseaddr	*/
 	unsigned int  irq;          /* Serial Port IRQ		*/
+	u8 irqmask;
 
-	struct rc_dev *dev;
-
+	/* RX state */
+	enum wbcir_rxstate rxstate;
 	struct led_trigger *rxtrigger;
-	struct led_trigger *txtrigger;
-	struct led_classdev led;
+	struct ir_raw_event rxev;
 
-	/* RX irdata state */
-	bool irdata_active;
-	bool irdata_error;
-	struct ir_raw_event ev;
+	/* TX state */
+	enum wbcir_txstate txstate;
+	struct led_trigger *txtrigger;
+	u32 txlen;
+	u32 txoff;
+	u32 *txbuf;
+	wait_queue_head_t txwaitq;
+	u8 txmask;
+	u32 txcarrier;
 };
 
 static enum wbcir_protocol protocol = IR_PROTOCOL_RC6;
@@ -193,6 +228,10 @@ static int invert; /* default = 0 */
 module_param(invert, bool, 0444);
 MODULE_PARM_DESC(invert, "Invert the signal from the IR receiver");
 
+static int txandrx; /* default = 0 */
+module_param(txandrx, bool, 0444);
+MODULE_PARM_DESC(invert, "Allow simultaneous TX and RX");
+
 static unsigned int wake_sc = 0x800F040C;
 module_param(wake_sc, uint, 0644);
 MODULE_PARM_DESC(wake_sc, "Scancode of the power-on IR command");
@@ -228,6 +267,17 @@ wbcir_select_bank(struct wbcir_data *data, enum wbcir_bank bank)
 	outb(bank, data->sbase + WBCIR_REG_SP3_BSR);
 }
 
+static inline void
+wbcir_set_irqmask(struct wbcir_data *data, u8 irqmask)
+{
+	if (data->irqmask == irqmask)
+		return;
+
+	wbcir_select_bank(data, WBCIR_BANK_0);
+	outb(irqmask, data->sbase + WBCIR_REG_SP3_IER);
+	data->irqmask = irqmask;
+}
+
 static enum led_brightness
 wbcir_led_brightness_get(struct led_classdev *led_cdev)
 {
@@ -279,39 +329,15 @@ wbcir_to_rc6cells(u8 val)
  *
  *****************************************************************************/
 
-static irqreturn_t
-wbcir_irq_handler(int irqno, void *cookie)
+static void
+wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
 {
-	struct pnp_dev *device = cookie;
-	struct wbcir_data *data = pnp_get_drvdata(device);
-	unsigned long flags;
 	u8 irdata[8];
-	u8 disable = true;
-	u8 status;
-	int i;
-
-	spin_lock_irqsave(&data->spinlock, flags);
-
-	wbcir_select_bank(data, WBCIR_BANK_0);
-
-	status = inb(data->sbase + WBCIR_REG_SP3_EIR);
-
-	if (!(status & (WBCIR_IRQ_RX | WBCIR_IRQ_ERR))) {
-		spin_unlock_irqrestore(&data->spinlock, flags);
-		return IRQ_NONE;
-	}
-
-	/* Check for e.g. buffer overflow */
-	if (status & WBCIR_IRQ_ERR) {
-		data->irdata_error = true;
-		ir_raw_event_reset(data->dev);
-	}
-
-	if (!(status & WBCIR_IRQ_RX))
-		goto out;
+	bool disable = true;
+	unsigned int i;
 
-	if (!data->irdata_active) {
-		data->irdata_active = true;
+	if (data->rxstate == WBCIR_RXSTATE_INACTIVE) {
+		data->rxstate = WBCIR_RXSTATE_ACTIVE;
 		led_trigger_event(data->rxtrigger, LED_FULL);
 	}
 
@@ -325,28 +351,29 @@ wbcir_irq_handler(int irqno, void *cookie)
 		if (irdata[i] != 0xFF && irdata[i] != 0x00)
 			disable = false;
 
-		if (data->irdata_error)
+		if (data->rxstate == WBCIR_RXSTATE_ERROR)
 			continue;
 
 		pulse = irdata[i] & 0x80 ? false : true;
 		duration = (irdata[i] & 0x7F) * 10000; /* ns */
 
-		if (data->ev.pulse != pulse) {
-			if (data->ev.duration != 0) {
-				ir_raw_event_store(data->dev, &data->ev);
-				data->ev.duration = 0;
+		if (data->rxev.pulse != pulse) {
+			if (data->rxev.duration != 0) {
+				ir_raw_event_store(data->dev, &data->rxev);
+				data->rxev.duration = 0;
 			}
 
-			data->ev.pulse = pulse;
+			data->rxev.pulse = pulse;
 		}
 
-		data->ev.duration += duration;
+		data->rxev.duration += duration;
 	}
 
 	if (disable) {
-		if (data->ev.duration != 0 && !data->irdata_error) {
-			ir_raw_event_store(data->dev, &data->ev);
-			data->ev.duration = 0;
+		if (data->rxev.duration != 0 &&
+		    data->rxstate != WBCIR_RXSTATE_ERROR) {
+			ir_raw_event_store(data->dev, &data->rxev);
+			data->rxev.duration = 0;
 		}
 
 		/* Set RXINACTIVE */
@@ -357,19 +384,264 @@ wbcir_irq_handler(int irqno, void *cookie)
 			inb(data->sbase + WBCIR_REG_SP3_RXDATA);
 
 		ir_raw_event_reset(data->dev);
-		data->irdata_error = false;
-		data->irdata_active = false;
 		led_trigger_event(data->rxtrigger, LED_OFF);
+		data->rxstate = WBCIR_RXSTATE_INACTIVE;
 	}
 
 	ir_raw_event_handle(data->dev);
+}
+
+static void
+wbcir_irq_tx(struct wbcir_data *data)
+{
+	unsigned int space;
+	unsigned int used;
+	u8 bytes[16];
+	u8 byte;
+
+	if (!data->txbuf)
+		return;
+
+	switch (data->txstate) {
+	case WBCIR_TXSTATE_INACTIVE:
+		/* TX FIFO empty */
+		space = 16;
+		led_trigger_event(data->txtrigger, LED_FULL);
+		break;
+	case WBCIR_TXSTATE_ACTIVE:
+		/* TX FIFO low (3 bytes or less) */
+		space = 13;
+		break;
+	case WBCIR_TXSTATE_ERROR:
+		space = 0;
+		break;
+	default:
+		return;
+	}
+
+	/*
+	 * TX data is run-length coded in bytes: YXXXXXXX
+	 * Y = space (1) or pulse (0)
+	 * X = duration, encoded as (X + 1) * 10us (i.e 10 to 1280 us)
+	 */
+	for (used = 0; used < space && data->txoff != data->txlen; used++) {
+		if (data->txbuf[data->txoff] == 0) {
+			data->txoff++;
+			continue;
+		}
+		byte = min((u32)0x80, data->txbuf[data->txoff]);
+		data->txbuf[data->txoff] -= byte;
+		byte--;
+		byte |= (data->txoff % 2 ? 0x80 : 0x00); /* pulse/space */
+		bytes[used] = byte;
+	}
+
+	while (data->txbuf[data->txoff] == 0 && data->txoff != data->txlen)
+		data->txoff++;
+
+	if (used == 0) {
+		/* Finished */
+		if (data->txstate == WBCIR_TXSTATE_ERROR)
+			/* Clear TX underrun bit */
+			outb(WBCIR_TX_UNDERRUN, data->sbase + WBCIR_REG_SP3_ASCR);
+		else
+			data->txstate = WBCIR_TXSTATE_DONE;
+		wbcir_set_irqmask(data, WBCIR_IRQ_RX | WBCIR_IRQ_ERR);
+		led_trigger_event(data->txtrigger, LED_OFF);
+		wake_up(&data->txwaitq);
+	} else if (data->txoff == data->txlen) {
+		/* At the end of transmission, tell the hw before last byte */
+		outsb(data->sbase + WBCIR_REG_SP3_TXDATA, bytes, used - 1);
+		outb(WBCIR_TX_EOT, data->sbase + WBCIR_REG_SP3_ASCR);
+		outb(bytes[used - 1], data->sbase + WBCIR_REG_SP3_TXDATA);
+		wbcir_set_irqmask(data, WBCIR_IRQ_RX | WBCIR_IRQ_ERR |
+				  WBCIR_IRQ_TX_EMPTY);
+	} else {
+		/* More data to follow... */
+		outsb(data->sbase + WBCIR_REG_SP3_RXDATA, bytes, used);
+		if (data->txstate == WBCIR_TXSTATE_INACTIVE) {
+			wbcir_set_irqmask(data, WBCIR_IRQ_RX | WBCIR_IRQ_ERR |
+					  WBCIR_IRQ_TX_LOW);
+			data->txstate = WBCIR_TXSTATE_ACTIVE;
+		}
+	}
+}
+
+static irqreturn_t
+wbcir_irq_handler(int irqno, void *cookie)
+{
+	struct pnp_dev *device = cookie;
+	struct wbcir_data *data = pnp_get_drvdata(device);
+	unsigned long flags;
+	u8 status;
+
+	spin_lock_irqsave(&data->spinlock, flags);
+	wbcir_select_bank(data, WBCIR_BANK_0);
+	status = inb(data->sbase + WBCIR_REG_SP3_EIR);
+	status &= data->irqmask;
+
+	if (!status) {
+		spin_unlock_irqrestore(&data->spinlock, flags);
+		return IRQ_NONE;
+	}
+
+	if (status & WBCIR_IRQ_ERR) {
+		/* RX overflow? (read clears bit) */
+		if (inb(data->sbase + WBCIR_REG_SP3_LSR) & WBCIR_RX_OVERRUN) {
+			data->rxstate = WBCIR_RXSTATE_ERROR;
+			ir_raw_event_reset(data->dev);
+		}
+
+		/* TX underflow? */
+		if (inb(data->sbase + WBCIR_REG_SP3_ASCR) & WBCIR_TX_UNDERRUN)
+			data->txstate = WBCIR_TXSTATE_ERROR;
+	}
+
+	if (status & WBCIR_IRQ_RX)
+		wbcir_irq_rx(data, device);
+
+	if (status & (WBCIR_IRQ_TX_LOW | WBCIR_IRQ_TX_EMPTY))
+		wbcir_irq_tx(data);
 
-out:
 	spin_unlock_irqrestore(&data->spinlock, flags);
 	return IRQ_HANDLED;
 }
 
+/*****************************************************************************
+ *
+ * RC-CORE INTERFACE FUNCTIONS
+ *
+ *****************************************************************************/
+
+static int
+wbcir_txcarrier(struct rc_dev *dev, u32 carrier)
+{
+	struct wbcir_data *data = dev->priv;
+	unsigned long flags;
+	u8 val;
+	u32 freq;
+
+	freq = DIV_ROUND_CLOSEST(carrier, 1000);
+	if (freq < 30 || freq > 60)
+		return -EINVAL;
+
+	switch (freq) {
+	case 58:
+	case 59:
+	case 60:
+		val = freq - 58;
+		freq *= 1000;
+		break;
+	case 57:
+		val = freq - 27;
+		freq = 56900;
+		break;
+	default:
+		val = freq - 27;
+		freq *= 1000;
+		break;
+	}
+
+	spin_lock_irqsave(&data->spinlock, flags);
+	if (data->txstate != WBCIR_TXSTATE_INACTIVE) {
+		spin_unlock_irqrestore(&data->spinlock, flags);
+		return -EBUSY;
+	}
+
+	if (data->txcarrier != freq) {
+		wbcir_select_bank(data, WBCIR_BANK_7);
+		wbcir_set_bits(data->sbase + WBCIR_REG_SP3_IRTXMC, val, 0x1F);
+		data->txcarrier = freq;
+	}
+
+	spin_unlock_irqrestore(&data->spinlock, flags);
+	return 0;
+}
+
+static int
+wbcir_txmask(struct rc_dev *dev, u32 mask)
+{
+	struct wbcir_data *data = dev->priv;
+	unsigned long flags;
+	u8 val;
+
+	/* Four outputs, only one output can be enabled at a time */
+	switch (mask) {
+	case 0x1:
+		val = 0x0;
+		break;
+	case 0x2:
+		val = 0x1;
+		break;
+	case 0x4:
+		val = 0x2;
+		break;
+	case 0x8:
+		val = 0x3;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&data->spinlock, flags);
+	if (data->txstate != WBCIR_TXSTATE_INACTIVE) {
+		spin_unlock_irqrestore(&data->spinlock, flags);
+		return -EBUSY;
+	}
+
+	if (data->txmask != mask) {
+		wbcir_set_bits(data->ebase + WBCIR_REG_ECEIR_CTS, val, 0x0c);
+		data->txmask = mask;
+	}
+
+	spin_unlock_irqrestore(&data->spinlock, flags);
+	return 0;
+}
+
+static int
+wbcir_tx(struct rc_dev *dev, int *buf, u32 bufsize)
+{
+	struct wbcir_data *data = dev->priv;
+	u32 count;
+	unsigned i;
+	unsigned long flags;
+
+	/* bufsize has been sanity checked by the caller */
+	count = bufsize / sizeof(int);
+
+	/* Not sure if this is possible, but better safe than sorry */
+	spin_lock_irqsave(&data->spinlock, flags);
+	if (data->txstate != WBCIR_TXSTATE_INACTIVE) {
+		spin_unlock_irqrestore(&data->spinlock, flags);
+		return -EBUSY;
+	}
+
+	/* Convert values to multiples of 10us */
+	for (i = 0; i < count; i++)
+		buf[i] = DIV_ROUND_CLOSEST(buf[i], 10);
+
+	/* Fill the TX fifo once, the irq handler will do the rest */
+	data->txbuf = buf;
+	data->txlen = count;
+	data->txoff = 0;
+	wbcir_irq_tx(data);
+
+	/* Wait for the TX to complete */
+	while (data->txstate == WBCIR_TXSTATE_ACTIVE) {
+		spin_unlock_irqrestore(&data->spinlock, flags);
+		wait_event(data->txwaitq, data->txstate != WBCIR_TXSTATE_ACTIVE);
+		spin_lock_irqsave(&data->spinlock, flags);
+	}
+
+	/* We're done */
+	if (data->txstate == WBCIR_TXSTATE_ERROR)
+		count = -EAGAIN;
+	data->txstate = WBCIR_TXSTATE_INACTIVE;
+	data->txbuf = NULL;
+	spin_unlock_irqrestore(&data->spinlock, flags);
 
+	return count;
+}
 
 /*****************************************************************************
  *
@@ -551,21 +823,18 @@ finish:
 		wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x00, 0x01);
 	}
 
-	/* Disable interrupts */
-	wbcir_select_bank(data, WBCIR_BANK_0);
-	outb(WBCIR_IRQ_NONE, data->sbase + WBCIR_REG_SP3_IER);
-
-	/* Disable LED */
-	data->irdata_active = false;
-	led_trigger_event(data->rxtrigger, LED_OFF);
-
 	/*
 	 * ACPI will set the HW disable bit for SP3 which means that the
 	 * output signals are left in an undefined state which may cause
 	 * spurious interrupts which we need to ignore until the hardware
 	 * is reinitialized.
 	 */
+	wbcir_set_irqmask(data, WBCIR_IRQ_NONE);
 	disable_irq(data->irq);
+
+	/* Disable LED */
+	led_trigger_event(data->rxtrigger, LED_OFF);
+	led_trigger_event(data->txtrigger, LED_OFF);
 }
 
 static int
@@ -581,8 +850,7 @@ wbcir_init_hw(struct wbcir_data *data)
 	u8 tmp;
 
 	/* Disable interrupts */
-	wbcir_select_bank(data, WBCIR_BANK_0);
-	outb(WBCIR_IRQ_NONE, data->sbase + WBCIR_REG_SP3_IER);
+	wbcir_set_irqmask(data, WBCIR_IRQ_NONE);
 
 	/* Set PROT_SEL, RX_INV, Clear CEIR_EN (needed for the led) */
 	tmp = protocol << 4;
@@ -606,10 +874,11 @@ wbcir_init_hw(struct wbcir_data *data)
 		outb(0x00, data->ebase + WBCIR_REG_ECEIR_CCTL);
 
 	/*
-	 * Clear IR LED, set SP3 clock to 24Mhz
+	 * Clear IR LED, set SP3 clock to 24Mhz, set TX mask to IRTX1,
 	 * set SP3_IRRX_SW to binary 01, helpfully not documented
 	 */
 	outb(0x10, data->ebase + WBCIR_REG_ECEIR_CTS);
+	data->txmask = 0x1;
 
 	/* Enable extended mode */
 	wbcir_select_bank(data, WBCIR_BANK_2);
@@ -647,18 +916,21 @@ wbcir_init_hw(struct wbcir_data *data)
 	wbcir_select_bank(data, WBCIR_BANK_4);
 	outb(0x00, data->sbase + WBCIR_REG_SP3_IRCR1);
 
-	/* Enable MSR interrupt, Clear AUX_IRX */
+	/* Disable MSR interrupt, clear AUX_IRX, mask RX during TX? */
 	wbcir_select_bank(data, WBCIR_BANK_5);
-	outb(0x00, data->sbase + WBCIR_REG_SP3_IRCR2);
+	outb(txandrx ? 0x03 : 0x02, data->sbase + WBCIR_REG_SP3_IRCR2);
 
 	/* Disable CRC */
 	wbcir_select_bank(data, WBCIR_BANK_6);
 	outb(0x20, data->sbase + WBCIR_REG_SP3_IRCR3);
 
-	/* Set RX/TX (de)modulation freq, not really used */
+	/* Set RX demodulation freq, not really used */
 	wbcir_select_bank(data, WBCIR_BANK_7);
 	outb(0xF2, data->sbase + WBCIR_REG_SP3_IRRXDC);
+
+	/* Set TX modulation, 36kHz, 7us pulse width */
 	outb(0x69, data->sbase + WBCIR_REG_SP3_IRTXMC);
+	data->txcarrier = 36000;
 
 	/* Set invert and pin direction */
 	if (invert)
@@ -673,16 +945,23 @@ wbcir_init_hw(struct wbcir_data *data)
 	/* Clear AUX status bits */
 	outb(0xE0, data->sbase + WBCIR_REG_SP3_ASCR);
 
-	/* Clear IR decoding state */
-	data->irdata_active = false;
-	led_trigger_event(data->rxtrigger, LED_OFF);
-	data->irdata_error = false;
-	data->ev.duration = 0;
+	/* Clear RX state */
+	data->rxstate = WBCIR_RXSTATE_INACTIVE;
+	data->rxev.duration = 0;
 	ir_raw_event_reset(data->dev);
 	ir_raw_event_handle(data->dev);
 
+	/*
+	 * Check TX state, if we did a suspend/resume cycle while TX was
+	 * active, we will have a process waiting in txwaitq.
+	 */
+	if (data->txstate == WBCIR_TXSTATE_ACTIVE) {
+		data->txstate = WBCIR_TXSTATE_ERROR;
+		wake_up(&data->txwaitq);
+	}
+
 	/* Enable interrupts */
-	outb(WBCIR_IRQ_RX | WBCIR_IRQ_ERR, data->sbase + WBCIR_REG_SP3_IER);
+	wbcir_set_irqmask(data, WBCIR_IRQ_RX | WBCIR_IRQ_ERR);
 }
 
 static int
@@ -719,6 +998,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	pnp_set_drvdata(device, data);
 
 	spin_lock_init(&data->spinlock);
+	init_waitqueue_head(&data->txwaitq);
 	data->ebase = pnp_port_start(device, 0);
 	data->wbase = pnp_port_start(device, 1);
 	data->sbase = pnp_port_start(device, 2);
@@ -799,6 +1079,9 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->input_id.product = WBCIR_ID_FAMILY;
 	data->dev->input_id.version = WBCIR_ID_CHIP;
 	data->dev->map_name = RC_MAP_RC6_MCE;
+	data->dev->s_tx_mask = wbcir_txmask;
+	data->dev->s_tx_carrier = wbcir_txcarrier;
+	data->dev->tx_ir = wbcir_tx;
 	data->dev->priv = data;
 	data->dev->dev.parent = &device->dev;
 
@@ -841,9 +1124,7 @@ wbcir_remove(struct pnp_dev *device)
 	struct wbcir_data *data = pnp_get_drvdata(device);
 
 	/* Disable interrupts */
-	wbcir_select_bank(data, WBCIR_BANK_0);
-	outb(WBCIR_IRQ_NONE, data->sbase + WBCIR_REG_SP3_IER);
-
+	wbcir_set_irqmask(data, WBCIR_IRQ_NONE);
 	free_irq(data->irq, device);
 
 	/* Clear status bits NEC_REP, BUFF, MSG_END, MATCH */

