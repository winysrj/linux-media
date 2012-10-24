Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:52239 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab2JXVWo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 17:22:44 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=203/3=5D=20=5Bmedia=5D=20winbond-cir=3A=20add=20carrier=20detection?=
Date: Wed, 24 Oct 2012 22:22:42 +0100
Message-Id: <1351113762-5530-3-git-send-email-sean@mess.org>
In-Reply-To: <1351113762-5530-1-git-send-email-sean@mess.org>
References: <1351113762-5530-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The winbond hardware has a counter for leading edges, which increases as
they are received. As we read raw IR from a fifo in an interrupt handler,
we cannot correlate them to specific IR pulses so we simply count all
pulses and edges until we go idle and disable the receiver.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/winbond-cir.c | 80 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 75 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 1ff47eb..f033ecf 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -7,6 +7,7 @@
  *  with minor modifications.
  *
  *  Original Author: David Härdeman <david@hardeman.nu>
+ *     Copyright (C) 2012 Sean Young <sean@mess.org>
  *     Copyright (C) 2009 - 2011 David Härdeman <david@hardeman.nu>
  *
  *  Dedicated to my daughter Matilda, without whose loving attention this
@@ -22,9 +23,7 @@
  *    o IR Receive
  *    o IR Transmit
  *    o Wake-On-CIR functionality
- *
- *  To do:
- *    o Learning
+ *    o Carrier detection
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -149,6 +148,12 @@
 #define WBCIR_REGSEL_MASK	0x20
 /* Starting address of selected register in WBCIR_REG_WCEIR_INDEX */
 #define WBCIR_REG_ADDR0		0x00
+/* Enable carrier counter */
+#define WBCIR_CNTR_EN		0x01
+/* Reset carrier counter */
+#define WBCIR_CNTR_R		0x02
+/* Invert TX */
+#define WBCIR_IRTX_INV		0x04
 
 /* Valid banks for the SP3 UART */
 enum wbcir_bank {
@@ -207,6 +212,8 @@ struct wbcir_data {
 	/* RX state */
 	enum wbcir_rxstate rxstate;
 	struct led_trigger *rxtrigger;
+	int carrier_report_enabled;
+	u32 pulse_duration;
 
 	/* TX state */
 	enum wbcir_txstate txstate;
@@ -329,6 +336,30 @@ wbcir_to_rc6cells(u8 val)
  *****************************************************************************/
 
 static void
+wbcir_carrier_report(struct wbcir_data *data)
+{
+	unsigned counter = inb(data->ebase + WBCIR_REG_ECEIR_CNT_LO) |
+			inb(data->ebase + WBCIR_REG_ECEIR_CNT_HI) << 8;
+
+	if (counter > 0 && counter < 0xffff) {
+		DEFINE_IR_RAW_EVENT(ev);
+
+		ev.carrier_report = 1;
+		ev.carrier = DIV_ROUND_CLOSEST(counter * 1000000u,
+						data->pulse_duration);
+
+		ir_raw_event_store(data->dev, &ev);
+	}
+
+	/* reset and restart the counter */
+	data->pulse_duration = 0;
+	wbcir_set_bits(data->ebase + WBCIR_REG_ECEIR_CCTL, WBCIR_CNTR_R,
+						WBCIR_CNTR_EN | WBCIR_CNTR_R);
+	wbcir_set_bits(data->ebase + WBCIR_REG_ECEIR_CCTL, WBCIR_CNTR_EN,
+						WBCIR_CNTR_EN | WBCIR_CNTR_R);
+}
+
+static void
 wbcir_idle_rx(struct rc_dev *dev, bool idle)
 {
 	struct wbcir_data *data = dev->priv;
@@ -341,6 +372,10 @@ wbcir_idle_rx(struct rc_dev *dev, bool idle)
 	if (idle && data->rxstate != WBCIR_RXSTATE_INACTIVE) {
 		data->rxstate = WBCIR_RXSTATE_INACTIVE;
 		led_trigger_event(data->rxtrigger, LED_OFF);
+
+		if (data->carrier_report_enabled)
+			wbcir_carrier_report(data);
+
 		/* Tell hardware to go idle by setting RXINACTIVE */
 		outb(WBCIR_RX_DISABLE, data->sbase + WBCIR_REG_SP3_ASCR);
 	}
@@ -351,14 +386,21 @@ wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
 {
 	u8 irdata;
 	DEFINE_IR_RAW_EVENT(rawir);
+	unsigned duration;
 
 	/* Since RXHDLEV is set, at least 8 bytes are in the FIFO */
 	while (inb(data->sbase + WBCIR_REG_SP3_LSR) & WBCIR_RX_AVAIL) {
 		irdata = inb(data->sbase + WBCIR_REG_SP3_RXDATA);
 		if (data->rxstate == WBCIR_RXSTATE_ERROR)
 			continue;
+
+		duration = ((irdata & 0x7F) + 1) * 2;
 		rawir.pulse = irdata & 0x80 ? false : true;
-		rawir.duration = US_TO_NS(((irdata & 0x7F) + 1) * 2);
+		rawir.duration = US_TO_NS(duration);
+
+		if (rawir.pulse)
+			data->pulse_duration += duration;
+
 		ir_raw_event_store_with_filter(data->dev, &rawir);
 	}
 
@@ -488,6 +530,33 @@ wbcir_irq_handler(int irqno, void *cookie)
  *****************************************************************************/
 
 static int
+wbcir_set_carrier_report(struct rc_dev *dev, int enable)
+{
+	struct wbcir_data *data = dev->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->spinlock, flags);
+
+	if (data->carrier_report_enabled == enable) {
+		spin_unlock_irqrestore(&data->spinlock, flags);
+		return 0;
+	}
+
+	data->pulse_duration = 0;
+	wbcir_set_bits(data->ebase + WBCIR_REG_ECEIR_CCTL, WBCIR_CNTR_R,
+						WBCIR_CNTR_EN | WBCIR_CNTR_R);
+
+	if (enable && data->dev->idle)
+		wbcir_set_bits(data->ebase + WBCIR_REG_ECEIR_CCTL,
+				WBCIR_CNTR_EN, WBCIR_CNTR_EN | WBCIR_CNTR_R);
+
+	data->carrier_report_enabled = enable;
+	spin_unlock_irqrestore(&data->spinlock, flags);
+
+	return 0;
+}
+
+static int
 wbcir_txcarrier(struct rc_dev *dev, u32 carrier)
 {
 	struct wbcir_data *data = dev->priv;
@@ -833,7 +902,7 @@ wbcir_init_hw(struct wbcir_data *data)
 
 	/* Set IRTX_INV */
 	if (invert)
-		outb(0x04, data->ebase + WBCIR_REG_ECEIR_CCTL);
+		outb(WBCIR_IRTX_INV, data->ebase + WBCIR_REG_ECEIR_CCTL);
 	else
 		outb(0x00, data->ebase + WBCIR_REG_ECEIR_CCTL);
 
@@ -1014,6 +1083,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->input_id.version = WBCIR_ID_CHIP;
 	data->dev->map_name = RC_MAP_RC6_MCE;
 	data->dev->s_idle = wbcir_idle_rx;
+	data->dev->s_carrier_report = wbcir_set_carrier_report;
 	data->dev->s_tx_mask = wbcir_txmask;
 	data->dev->s_tx_carrier = wbcir_txcarrier;
 	data->dev->tx_ir = wbcir_tx;
-- 
1.7.11.7

