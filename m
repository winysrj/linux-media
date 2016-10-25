Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36398 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753871AbcJYTYQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 15:24:16 -0400
Received: by mail-wm0-f66.google.com with SMTP id c78so1922505wme.3
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2016 12:24:15 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 3/5] media: rc: nuvoton: eliminate nvt->tx.lock
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <d213893b-4bdf-7db1-b2e3-e2d5d028a51f@gmail.com>
Cc: linux-media@vger.kernel.org
Message-ID: <3ebbfb6b-8417-f1a9-ad7e-b1432e582ccd@gmail.com>
Date: Tue, 25 Oct 2016 21:23:45 +0200
MIME-Version: 1.0
In-Reply-To: <d213893b-4bdf-7db1-b2e3-e2d5d028a51f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using a separate spinlock to protect access to substruct tx of struct
nvt_dev doesn't provide any actual benefit. We can use spinlock
nvt_lock to protect all access to struct nvt_dev and get rid of
nvt->tx.lock.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 35 +++++++++--------------------------
 drivers/media/rc/nuvoton-cir.h |  1 -
 2 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index a583066..c677628 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -688,7 +688,7 @@ static int nvt_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned n)
 	u8 iren;
 	int ret;
 
-	spin_lock_irqsave(&nvt->tx.lock, flags);
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
 
 	ret = min((unsigned)(TX_BUF_LEN / sizeof(unsigned)), n);
 	nvt->tx.buf_count = (ret * sizeof(unsigned));
@@ -712,13 +712,13 @@ static int nvt_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned n)
 	for (i = 0; i < 9; i++)
 		nvt_cir_reg_write(nvt, 0x01, CIR_STXFIFO);
 
-	spin_unlock_irqrestore(&nvt->tx.lock, flags);
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 
 	wait_event(nvt->tx.queue, nvt->tx.tx_state == ST_TX_REQUEST);
 
-	spin_lock_irqsave(&nvt->tx.lock, flags);
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
 	nvt->tx.tx_state = ST_TX_NONE;
-	spin_unlock_irqrestore(&nvt->tx.lock, flags);
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 
 	/* restore enabled interrupts to prior state */
 	nvt_cir_reg_write(nvt, iren, CIR_IREN);
@@ -832,14 +832,7 @@ static void nvt_cir_log_irqs(u8 status, u8 iren)
 
 static bool nvt_cir_tx_inactive(struct nvt_dev *nvt)
 {
-	unsigned long flags;
-	u8 tx_state;
-
-	spin_lock_irqsave(&nvt->tx.lock, flags);
-	tx_state = nvt->tx.tx_state;
-	spin_unlock_irqrestore(&nvt->tx.lock, flags);
-
-	return tx_state == ST_TX_NONE;
+	return nvt->tx.tx_state == ST_TX_NONE;
 }
 
 /* interrupt service routine for incoming and outgoing CIR data */
@@ -902,8 +895,6 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 			nvt_get_rx_ir_data(nvt);
 	}
 
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
-
 	if (status & CIR_IRSTS_TE)
 		nvt_clear_tx_fifo(nvt);
 
@@ -911,8 +902,6 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 		unsigned int pos, count;
 		u8 tmp;
 
-		spin_lock_irqsave(&nvt->tx.lock, flags);
-
 		pos = nvt->tx.cur_buf_num;
 		count = nvt->tx.buf_count;
 
@@ -925,20 +914,17 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 			tmp = nvt_cir_reg_read(nvt, CIR_IREN);
 			nvt_cir_reg_write(nvt, tmp & ~CIR_IREN_TTR, CIR_IREN);
 		}
-
-		spin_unlock_irqrestore(&nvt->tx.lock, flags);
-
 	}
 
 	if (status & CIR_IRSTS_TFU) {
-		spin_lock_irqsave(&nvt->tx.lock, flags);
 		if (nvt->tx.tx_state == ST_TX_REPLY) {
 			nvt->tx.tx_state = ST_TX_REQUEST;
 			wake_up(&nvt->tx.queue);
 		}
-		spin_unlock_irqrestore(&nvt->tx.lock, flags);
 	}
 
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
 	nvt_dbg_verbose("%s done", __func__);
 	return IRQ_HANDLED;
 }
@@ -1019,7 +1005,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	nvt->cr_efdr = CR_EFDR;
 
 	spin_lock_init(&nvt->nvt_lock);
-	spin_lock_init(&nvt->tx.lock);
 
 	pnp_set_drvdata(pdev, nvt);
 
@@ -1117,12 +1102,10 @@ static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
 
 	nvt_dbg("%s called", __func__);
 
-	spin_lock_irqsave(&nvt->tx.lock, flags);
-	nvt->tx.tx_state = ST_TX_NONE;
-	spin_unlock_irqrestore(&nvt->tx.lock, flags);
-
 	spin_lock_irqsave(&nvt->nvt_lock, flags);
 
+	nvt->tx.tx_state = ST_TX_NONE;
+
 	/* disable all CIR interrupts */
 	nvt_cir_reg_write(nvt, 0, CIR_IREN);
 
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 77102a9..a8569b6 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -87,7 +87,6 @@ struct nvt_dev {
 	unsigned int pkts;
 
 	struct {
-		spinlock_t lock;
 		u8 buf[TX_BUF_LEN];
 		unsigned int buf_count;
 		unsigned int cur_buf_num;
-- 
2.10.1


