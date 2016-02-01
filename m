Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34973 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122AbcBAUvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2016 15:51:08 -0500
Received: by mail-wm0-f66.google.com with SMTP id l66so10824508wml.2
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2016 12:51:07 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 3/3] media: rc: nuvoton: fix locking issue when calling
 nvt_disable_cir
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56AFC52F.2030301@gmail.com>
Date: Mon, 1 Feb 2016 21:50:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

nvt_disable_cir calls nvt_disable_logical_dev (that may sleep) and is
called from contexts holding a spinlock.
Fix this and remove the unneeded clearing of CIR_IREN as this is done
in nvt_cir_disable already.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index a6ea75d..34dc1c3 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -950,6 +950,10 @@ static irqreturn_t nvt_cir_wake_isr(int irq, void *data)
 
 static void nvt_disable_cir(struct nvt_dev *nvt)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
+
 	/* disable CIR interrupts */
 	nvt_cir_reg_write(nvt, 0, CIR_IREN);
 
@@ -963,6 +967,8 @@ static void nvt_disable_cir(struct nvt_dev *nvt)
 	nvt_clear_cir_fifo(nvt);
 	nvt_clear_tx_fifo(nvt);
 
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
 	/* disable the CIR logical device */
 	nvt_disable_logical_dev(nvt, LOGICAL_DEV_CIR);
 }
@@ -996,11 +1002,8 @@ static int nvt_open(struct rc_dev *dev)
 static void nvt_close(struct rc_dev *dev)
 {
 	struct nvt_dev *nvt = dev->priv;
-	unsigned long flags;
 
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
 	nvt_disable_cir(nvt);
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 }
 
 /* Allocate memory, probe hardware, and initialize everything */
@@ -1151,13 +1154,8 @@ exit_free_dev_rdev:
 static void nvt_remove(struct pnp_dev *pdev)
 {
 	struct nvt_dev *nvt = pnp_get_drvdata(pdev);
-	unsigned long flags;
 
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
-	/* disable CIR */
-	nvt_cir_reg_write(nvt, 0, CIR_IREN);
 	nvt_disable_cir(nvt);
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 
 	/* enable CIR Wake (for IR power-on) */
 	nvt_enable_wake(nvt);
-- 
2.7.0


