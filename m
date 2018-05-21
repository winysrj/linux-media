Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:41829 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751127AbeEUOij (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 10:38:39 -0400
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: <linux-media@vger.kernel.org>
CC: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
        Jarod Wilson <jarod@redhat.com>, Sean Young <sean@mess.org>
Subject: [PATCH 2/3] media: rc: nuvoton: Keep track of users on CIR enable/disable
Date: Mon, 21 May 2018 16:38:02 +0200
Message-ID: <20180521143803.25664-2-michal.winiarski@intel.com>
In-Reply-To: <20180521143803.25664-1-michal.winiarski@intel.com>
References: <20180521143803.25664-1-michal.winiarski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Core rc keeps track of the users - let's use it to tweak the code and
use the common code path on suspend/resume.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Sean Young <sean@mess.org>
---
 drivers/media/rc/nuvoton-cir.c | 82 +++++++++++++++-------------------
 1 file changed, 36 insertions(+), 46 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index ce8949b6549d..eebd6fef5602 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -543,27 +543,9 @@ static void nvt_cir_regs_init(struct nvt_dev *nvt)
 	nvt_cir_reg_write(nvt, CIR_FIFOCON_TX_TRIGGER_LEV |
 			  CIR_FIFOCON_RX_TRIGGER_LEV, CIR_FIFOCON);
 
-	/*
-	 * Enable TX and RX, specify carrier on = low, off = high, and set
-	 * sample period (currently 50us)
-	 */
-	nvt_cir_reg_write(nvt,
-			  CIR_IRCON_TXEN | CIR_IRCON_RXEN |
-			  CIR_IRCON_RXINV | CIR_IRCON_SAMPLE_PERIOD_SEL,
-			  CIR_IRCON);
-
 	/* clear hardware rx and tx fifos */
 	nvt_clear_cir_fifo(nvt);
 	nvt_clear_tx_fifo(nvt);
-
-	/* clear any and all stray interrupts */
-	nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
-
-	/* and finally, enable interrupts */
-	nvt_set_cir_iren(nvt);
-
-	/* enable the CIR logical device */
-	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
 }
 
 static void nvt_cir_wake_regs_init(struct nvt_dev *nvt)
@@ -892,6 +874,32 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static void nvt_enable_cir(struct nvt_dev *nvt)
+{
+	unsigned long flags;
+
+	/* enable the CIR logical device */
+	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
+
+	spin_lock_irqsave(&nvt->lock, flags);
+
+	/*
+	 * Enable TX and RX, specify carrier on = low, off = high, and set
+	 * sample period (currently 50us)
+	 */
+	nvt_cir_reg_write(nvt, CIR_IRCON_TXEN | CIR_IRCON_RXEN |
+			  CIR_IRCON_RXINV | CIR_IRCON_SAMPLE_PERIOD_SEL,
+			  CIR_IRCON);
+
+	/* clear all pending interrupts */
+	nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
+
+	/* enable interrupts */
+	nvt_set_cir_iren(nvt);
+
+	spin_unlock_irqrestore(&nvt->lock, flags);
+}
+
 static void nvt_disable_cir(struct nvt_dev *nvt)
 {
 	unsigned long flags;
@@ -920,25 +928,8 @@ static void nvt_disable_cir(struct nvt_dev *nvt)
 static int nvt_open(struct rc_dev *dev)
 {
 	struct nvt_dev *nvt = dev->priv;
-	unsigned long flags;
 
-	/* enable the CIR logical device */
-	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
-
-	spin_lock_irqsave(&nvt->lock, flags);
-
-	/* set function enable flags */
-	nvt_cir_reg_write(nvt, CIR_IRCON_TXEN | CIR_IRCON_RXEN |
-			  CIR_IRCON_RXINV | CIR_IRCON_SAMPLE_PERIOD_SEL,
-			  CIR_IRCON);
-
-	/* clear all pending interrupts */
-	nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
-
-	/* enable interrupts */
-	nvt_set_cir_iren(nvt);
-
-	spin_unlock_irqrestore(&nvt->lock, flags);
+	nvt_enable_cir(nvt);
 
 	return 0;
 }
@@ -1093,19 +1084,13 @@ static void nvt_remove(struct pnp_dev *pdev)
 static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
 {
 	struct nvt_dev *nvt = pnp_get_drvdata(pdev);
-	unsigned long flags;
 
 	nvt_dbg("%s called", __func__);
 
-	spin_lock_irqsave(&nvt->lock, flags);
-
-	/* disable all CIR interrupts */
-	nvt_cir_reg_write(nvt, 0, CIR_IREN);
-
-	spin_unlock_irqrestore(&nvt->lock, flags);
-
-	/* disable cir logical dev */
-	nvt_disable_logical_dev(nvt, LOGICAL_DEV_CIR);
+	mutex_lock(&nvt->rdev->lock);
+	if (nvt->rdev->users)
+		nvt_disable_cir(nvt);
+	mutex_unlock(&nvt->rdev->lock);
 
 	/* make sure wake is enabled */
 	nvt_enable_wake(nvt);
@@ -1122,6 +1107,11 @@ static int nvt_resume(struct pnp_dev *pdev)
 	nvt_cir_regs_init(nvt);
 	nvt_cir_wake_regs_init(nvt);
 
+	mutex_lock(&nvt->rdev->lock);
+	if (nvt->rdev->users)
+		nvt_enable_cir(nvt);
+	mutex_unlock(&nvt->rdev->lock);
+
 	return 0;
 }
 
-- 
2.17.0
