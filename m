Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39124 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932711AbcJYTYR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 15:24:17 -0400
Received: by mail-wm0-f68.google.com with SMTP id m83so1908767wmc.6
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2016 12:24:16 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 4/5] media: rc: nuvoton: rename spinlock nvt_lock
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <d213893b-4bdf-7db1-b2e3-e2d5d028a51f@gmail.com>
Cc: linux-media@vger.kernel.org
Message-ID: <7ea97b11-8711-115f-1da7-e662810ca1bf@gmail.com>
Date: Tue, 25 Oct 2016 21:23:49 +0200
MIME-Version: 1.0
In-Reply-To: <d213893b-4bdf-7db1-b2e3-e2d5d028a51f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Spinlock nvt_lock is a member of struct nvt_dev and there's no need
to prefix it with nvt_. So remove this prefix.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 40 ++++++++++++++++++++--------------------
 drivers/media/rc/nuvoton-cir.h |  2 +-
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index c677628..6332cf3 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -187,7 +187,7 @@ static ssize_t wakeup_data_show(struct device *dev,
 	ssize_t buf_len = 0;
 	int i;
 
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
+	spin_lock_irqsave(&nvt->lock, flags);
 
 	fifo_len = nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_COUNT);
 	fifo_len = min(fifo_len, WAKEUP_MAX_SIZE);
@@ -204,7 +204,7 @@ static ssize_t wakeup_data_show(struct device *dev,
 	}
 	buf_len += snprintf(buf + buf_len, PAGE_SIZE - buf_len, "\n");
 
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+	spin_unlock_irqrestore(&nvt->lock, flags);
 
 	return buf_len;
 }
@@ -248,7 +248,7 @@ static ssize_t wakeup_data_store(struct device *dev,
 	/* hardcode the tolerance to 10% */
 	tolerance = DIV_ROUND_UP(count, 10);
 
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
+	spin_lock_irqsave(&nvt->lock, flags);
 
 	nvt_clear_cir_wake_fifo(nvt);
 	nvt_cir_wake_reg_write(nvt, count, CIR_WAKE_FIFO_CMP_DEEP);
@@ -265,7 +265,7 @@ static ssize_t wakeup_data_store(struct device *dev,
 
 	nvt_cir_wake_reg_write(nvt, config, CIR_WAKE_IRCON);
 
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+	spin_unlock_irqrestore(&nvt->lock, flags);
 
 	ret = len;
 out:
@@ -590,7 +590,7 @@ static void nvt_enable_wake(struct nvt_dev *nvt)
 
 	nvt_efm_disable(nvt);
 
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
+	spin_lock_irqsave(&nvt->lock, flags);
 
 	nvt_cir_wake_reg_write(nvt, CIR_WAKE_IRCON_MODE0 | CIR_WAKE_IRCON_RXEN |
 			       CIR_WAKE_IRCON_R | CIR_WAKE_IRCON_RXINV |
@@ -599,11 +599,11 @@ static void nvt_enable_wake(struct nvt_dev *nvt)
 	nvt_cir_wake_reg_write(nvt, 0xff, CIR_WAKE_IRSTS);
 	nvt_cir_wake_reg_write(nvt, 0, CIR_WAKE_IREN);
 
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+	spin_unlock_irqrestore(&nvt->lock, flags);
 }
 
 #if 0 /* Currently unused */
-/* rx carrier detect only works in learning mode, must be called w/nvt_lock */
+/* rx carrier detect only works in learning mode, must be called w/lock */
 static u32 nvt_rx_carrier_detect(struct nvt_dev *nvt)
 {
 	u32 count, carrier, duration = 0;
@@ -688,7 +688,7 @@ static int nvt_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned n)
 	u8 iren;
 	int ret;
 
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
+	spin_lock_irqsave(&nvt->lock, flags);
 
 	ret = min((unsigned)(TX_BUF_LEN / sizeof(unsigned)), n);
 	nvt->tx.buf_count = (ret * sizeof(unsigned));
@@ -712,13 +712,13 @@ static int nvt_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned n)
 	for (i = 0; i < 9; i++)
 		nvt_cir_reg_write(nvt, 0x01, CIR_STXFIFO);
 
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+	spin_unlock_irqrestore(&nvt->lock, flags);
 
 	wait_event(nvt->tx.queue, nvt->tx.tx_state == ST_TX_REQUEST);
 
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
+	spin_lock_irqsave(&nvt->lock, flags);
 	nvt->tx.tx_state = ST_TX_NONE;
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+	spin_unlock_irqrestore(&nvt->lock, flags);
 
 	/* restore enabled interrupts to prior state */
 	nvt_cir_reg_write(nvt, iren, CIR_IREN);
@@ -844,7 +844,7 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 
 	nvt_dbg_verbose("%s firing", __func__);
 
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
+	spin_lock_irqsave(&nvt->lock, flags);
 
 	/*
 	 * Get IR Status register contents. Write 1 to ack/clear
@@ -866,7 +866,7 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	 * logical device is being disabled.
 	 */
 	if (status == 0xff && iren == 0xff) {
-		spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+		spin_unlock_irqrestore(&nvt->lock, flags);
 		nvt_dbg_verbose("Spurious interrupt detected");
 		return IRQ_HANDLED;
 	}
@@ -875,7 +875,7 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	 * status bit whether the related interrupt source is enabled
 	 */
 	if (!(status & iren)) {
-		spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+		spin_unlock_irqrestore(&nvt->lock, flags);
 		nvt_dbg_verbose("%s exiting, IRSTS 0x0", __func__);
 		return IRQ_NONE;
 	}
@@ -923,7 +923,7 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 		}
 	}
 
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+	spin_unlock_irqrestore(&nvt->lock, flags);
 
 	nvt_dbg_verbose("%s done", __func__);
 	return IRQ_HANDLED;
@@ -933,7 +933,7 @@ static void nvt_disable_cir(struct nvt_dev *nvt)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
+	spin_lock_irqsave(&nvt->lock, flags);
 
 	/* disable CIR interrupts */
 	nvt_cir_reg_write(nvt, 0, CIR_IREN);
@@ -948,7 +948,7 @@ static void nvt_disable_cir(struct nvt_dev *nvt)
 	nvt_clear_cir_fifo(nvt);
 	nvt_clear_tx_fifo(nvt);
 
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+	spin_unlock_irqrestore(&nvt->lock, flags);
 
 	/* disable the CIR logical device */
 	nvt_disable_logical_dev(nvt, LOGICAL_DEV_CIR);
@@ -1004,7 +1004,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	nvt->cr_efir = CR_EFIR;
 	nvt->cr_efdr = CR_EFDR;
 
-	spin_lock_init(&nvt->nvt_lock);
+	spin_lock_init(&nvt->lock);
 
 	pnp_set_drvdata(pdev, nvt);
 
@@ -1102,14 +1102,14 @@ static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
 
 	nvt_dbg("%s called", __func__);
 
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
+	spin_lock_irqsave(&nvt->lock, flags);
 
 	nvt->tx.tx_state = ST_TX_NONE;
 
 	/* disable all CIR interrupts */
 	nvt_cir_reg_write(nvt, 0, CIR_IREN);
 
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+	spin_unlock_irqrestore(&nvt->lock, flags);
 
 	/* disable cir logical dev */
 	nvt_disable_logical_dev(nvt, LOGICAL_DEV_CIR);
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index a8569b6..c41c576 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -80,7 +80,7 @@ struct nvt_chip {
 struct nvt_dev {
 	struct rc_dev *rdev;
 
-	spinlock_t nvt_lock;
+	spinlock_t lock;
 
 	/* for rx */
 	u8 buf[RX_BUF_LEN];
-- 
2.10.1


