Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:59683 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3AFRTr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 12:19:47 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/3] [media] winbond-cir: only enable higher sample resolution if needed
Date: Sun,  6 Jan 2013 17:19:43 +0000
Message-Id: <1357492785-30966-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A sample resolution of 2us generates more than 300 interrupts per key
and this resolution is not needed unless carrier reports are enabled.

Revert to a resolution of 10us unless carrier reports are needed. This
generates up to a fifth of the interrupts.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/winbond-cir.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 553d1cd..66f543c 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -154,6 +154,8 @@
 #define WBCIR_CNTR_R		0x02
 /* Invert TX */
 #define WBCIR_IRTX_INV		0x04
+/* Receiver oversampling */
+#define WBCIR_RX_T_OV		0x40
 
 /* Valid banks for the SP3 UART */
 enum wbcir_bank {
@@ -394,7 +396,8 @@ wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
 		if (data->rxstate == WBCIR_RXSTATE_ERROR)
 			continue;
 
-		duration = ((irdata & 0x7F) + 1) * 2;
+		duration = ((irdata & 0x7F) + 1) *
+			(data->carrier_report_enabled ? 2 : 10);
 		rawir.pulse = irdata & 0x80 ? false : true;
 		rawir.duration = US_TO_NS(duration);
 
@@ -550,6 +553,17 @@ wbcir_set_carrier_report(struct rc_dev *dev, int enable)
 		wbcir_set_bits(data->ebase + WBCIR_REG_ECEIR_CCTL,
 				WBCIR_CNTR_EN, WBCIR_CNTR_EN | WBCIR_CNTR_R);
 
+	/* Set a higher sampling resolution if carrier reports are enabled */
+	wbcir_select_bank(data, WBCIR_BANK_2);
+	data->dev->rx_resolution = US_TO_NS(enable ? 2 : 10);
+	outb(enable ? 0x03 : 0x0f, data->sbase + WBCIR_REG_SP3_BGDL);
+	outb(0x00, data->sbase + WBCIR_REG_SP3_BGDH);
+
+	/* Enable oversampling if carrier reports are enabled */
+	wbcir_select_bank(data, WBCIR_BANK_7);
+	wbcir_set_bits(data->sbase + WBCIR_REG_SP3_RCCFG,
+				enable ? WBCIR_RX_T_OV : 0, WBCIR_RX_T_OV);
+
 	data->carrier_report_enabled = enable;
 	spin_unlock_irqrestore(&data->spinlock, flags);
 
@@ -931,8 +945,8 @@ wbcir_init_hw(struct wbcir_data *data)
 	/* prescaler 1.0, tx/rx fifo lvl 16 */
 	outb(0x30, data->sbase + WBCIR_REG_SP3_EXCR2);
 
-	/* Set baud divisor to sample every 2 ns */
-	outb(0x03, data->sbase + WBCIR_REG_SP3_BGDL);
+	/* Set baud divisor to sample every 10 us */
+	outb(0x0f, data->sbase + WBCIR_REG_SP3_BGDL);
 	outb(0x00, data->sbase + WBCIR_REG_SP3_BGDH);
 
 	/* Set CEIR mode */
@@ -941,12 +955,9 @@ wbcir_init_hw(struct wbcir_data *data)
 	inb(data->sbase + WBCIR_REG_SP3_LSR); /* Clear LSR */
 	inb(data->sbase + WBCIR_REG_SP3_MSR); /* Clear MSR */
 
-	/*
-	 * Disable RX demod, enable run-length enc/dec, set freq span and
-	 * enable over-sampling
-	 */
+	/* Disable RX demod, enable run-length enc/dec, set freq span */
 	wbcir_select_bank(data, WBCIR_BANK_7);
-	outb(0xd0, data->sbase + WBCIR_REG_SP3_RCCFG);
+	outb(0x90, data->sbase + WBCIR_REG_SP3_RCCFG);
 
 	/* Disable timer */
 	wbcir_select_bank(data, WBCIR_BANK_4);
-- 
1.7.11.7

