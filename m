Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34535 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbbL3QrB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:47:01 -0500
Received: by mail-wm0-f44.google.com with SMTP id u188so44572938wmu.1
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:47:00 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 16/16] media: rc: nuvoton-cir: improve locking in both
 interrupt handlers
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56840A65.5060100@gmail.com>
Date: Wed, 30 Dec 2015 17:46:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the locking to protect more critical actions like register accesses
in the interrupt handlers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index c0bee1e..b6acc84 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -727,7 +727,6 @@ static void nvt_handle_rx_fifo_overrun(struct nvt_dev *nvt)
 /* copy data from hardware rx fifo into driver buffer */
 static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 {
-	unsigned long flags;
 	u8 fifocount, val;
 	unsigned int b_idx;
 	bool overrun = false;
@@ -746,8 +745,6 @@ static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 
 	nvt_dbg("attempting to fetch %u bytes from hw rx fifo", fifocount);
 
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
-
 	b_idx = nvt->pkts;
 
 	/* This should never happen, but lets check anyway... */
@@ -769,8 +766,6 @@ static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 
 	if (overrun)
 		nvt_handle_rx_fifo_overrun(nvt);
-
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 }
 
 static void nvt_cir_log_irqs(u8 status, u8 iren)
@@ -811,6 +806,8 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 
 	nvt_dbg_verbose("%s firing", __func__);
 
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
+
 	/*
 	 * Get IR Status register contents. Write 1 to ack/clear
 	 *
@@ -831,6 +828,7 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	 * status bit whether the related interrupt source is enabled
 	 */
 	if (!(status & iren)) {
+		spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 		nvt_dbg_verbose("%s exiting, IRSTS 0x0", __func__);
 		return IRQ_NONE;
 	}
@@ -852,16 +850,14 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 		if (nvt_cir_tx_inactive(nvt))
 			nvt_get_rx_ir_data(nvt);
 
-		spin_lock_irqsave(&nvt->nvt_lock, flags);
-
 		cur_state = nvt->study_state;
 
-		spin_unlock_irqrestore(&nvt->nvt_lock, flags);
-
 		if (cur_state == ST_STUDY_NONE)
 			nvt_clear_cir_fifo(nvt);
 	}
 
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
 	if (status & CIR_IRSTS_TE)
 		nvt_clear_tx_fifo(nvt);
 
@@ -910,14 +906,18 @@ static irqreturn_t nvt_cir_wake_isr(int irq, void *data)
 
 	nvt_dbg_wake("%s firing", __func__);
 
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
+
 	status = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRSTS);
 	iren = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IREN);
 
 	/* IRQ may be shared with CIR, therefore check for each
 	 * status bit whether the related interrupt source is enabled
 	 */
-	if (!(status & iren))
+	if (!(status & iren)) {
+		spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 		return IRQ_NONE;
+	}
 
 	if (status & CIR_WAKE_IRSTS_IR_PENDING)
 		nvt_clear_cir_wake_fifo(nvt);
@@ -933,11 +933,11 @@ static irqreturn_t nvt_cir_wake_isr(int irq, void *data)
 		}
 
 		nvt_cir_wake_reg_write(nvt, 0, CIR_WAKE_IREN);
-		spin_lock_irqsave(&nvt->nvt_lock, flags);
 		nvt->wake_state = ST_WAKE_FINISH;
-		spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 	}
 
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
 	nvt_dbg_wake("%s done", __func__);
 	return IRQ_HANDLED;
 }
-- 
2.6.4


