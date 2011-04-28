Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:47928 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab1D1POS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 11:14:18 -0400
Subject: [PATCH 03/10] rc-core: use ir_raw_event_store_with_filter in
	winbond-cir
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@redhat.com
Date: Thu, 28 Apr 2011 17:13:27 +0200
Message-ID: <20110428151327.8272.62626.stgit@felix.hardeman.nu>
In-Reply-To: <20110428151311.8272.17290.stgit@felix.hardeman.nu>
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Using ir_raw_event_store_with_filter() saves about 20 lines of code.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/winbond-cir.c |   63 +++++++++++++---------------------------
 1 files changed, 21 insertions(+), 42 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 6ba4438..48bafa2 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -330,60 +330,38 @@ wbcir_to_rc6cells(u8 val)
  *****************************************************************************/
 
 static void
-wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
+wbcir_idle_rx(struct rc_dev *dev, bool idle)
 {
-	u8 irdata[8];
-	bool disable = true;
-	unsigned int i;
+	struct wbcir_data *data = dev->priv;
 
-	if (data->rxstate == WBCIR_RXSTATE_INACTIVE) {
+	if (!idle && data->rxstate == WBCIR_RXSTATE_INACTIVE) {
 		data->rxstate = WBCIR_RXSTATE_ACTIVE;
 		led_trigger_event(data->rxtrigger, LED_FULL);
 	}
 
-	/* Since RXHDLEV is set, at least 8 bytes are in the FIFO */
-	insb(data->sbase + WBCIR_REG_SP3_RXDATA, &irdata[0], 8);
-
-	for (i = 0; i < 8; i++) {
-		u8 pulse;
-		u32 duration;
+	if (idle && data->rxstate != WBCIR_RXSTATE_INACTIVE)
+		/* Tell hardware to go idle by setting RXINACTIVE */
+		outb(WBCIR_RX_DISABLE, data->sbase + WBCIR_REG_SP3_ASCR);
+}
 
-		if (irdata[i] != 0xFF && irdata[i] != 0x00)
-			disable = false;
+static void
+wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
+{
+	u8 irdata;
+	DEFINE_IR_RAW_EVENT(rawir);
 
+	/* Since RXHDLEV is set, at least 8 bytes are in the FIFO */
+	while (inb(data->sbase + WBCIR_REG_SP3_LSR) & WBCIR_RX_AVAIL) {
+		irdata = inb(data->sbase + WBCIR_REG_SP3_RXDATA);
 		if (data->rxstate == WBCIR_RXSTATE_ERROR)
 			continue;
-
-		pulse = irdata[i] & 0x80 ? false : true;
-		duration = (irdata[i] & 0x7F) * 10000; /* ns */
-
-		if (data->rxev.pulse != pulse) {
-			if (data->rxev.duration != 0) {
-				ir_raw_event_store(data->dev, &data->rxev);
-				data->rxev.duration = 0;
-			}
-
-			data->rxev.pulse = pulse;
-		}
-
-		data->rxev.duration += duration;
+		rawir.pulse = irdata & 0x80 ? false : true;
+		rawir.duration = US_TO_NS((irdata & 0x7F) * 10);
+		ir_raw_event_store_with_filter(data->dev, &rawir);
 	}
 
-	if (disable) {
-		if (data->rxev.duration != 0 &&
-		    data->rxstate != WBCIR_RXSTATE_ERROR) {
-			ir_raw_event_store(data->dev, &data->rxev);
-			data->rxev.duration = 0;
-		}
-
-		/* Set RXINACTIVE */
-		outb(WBCIR_RX_DISABLE, data->sbase + WBCIR_REG_SP3_ASCR);
-
-		/* Drain the FIFO */
-		while (inb(data->sbase + WBCIR_REG_SP3_LSR) & WBCIR_RX_AVAIL)
-			inb(data->sbase + WBCIR_REG_SP3_RXDATA);
-
-		ir_raw_event_reset(data->dev);
+	/* Check if we should go idle */
+	if (data->dev->idle) {
 		led_trigger_event(data->rxtrigger, LED_OFF);
 		data->rxstate = WBCIR_RXSTATE_INACTIVE;
 	}
@@ -1079,6 +1057,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->input_id.product = WBCIR_ID_FAMILY;
 	data->dev->input_id.version = WBCIR_ID_CHIP;
 	data->dev->map_name = RC_MAP_RC6_MCE;
+	data->dev->s_idle = wbcir_idle_rx;
 	data->dev->s_tx_mask = wbcir_txmask;
 	data->dev->s_tx_carrier = wbcir_txcarrier;
 	data->dev->tx_ir = wbcir_tx;

