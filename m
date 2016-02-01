Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34948 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbcBAUvH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2016 15:51:07 -0500
Received: by mail-wm0-f66.google.com with SMTP id l66so10824320wml.2
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2016 12:51:06 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 2/3] media: rc: nuvoton: fix locking issue when calling
 nvt_enable_wake
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56AFC512.5070509@gmail.com>
Date: Mon, 1 Feb 2016 21:50:26 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

nvt_enable_wake calls nvt_select_logical_dev (that may sleep) and is called
from contexts holding a spinlock. Fix this.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 971858a..a6ea75d 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -503,6 +503,8 @@ static void nvt_cir_wake_regs_init(struct nvt_dev *nvt)
 
 static void nvt_enable_wake(struct nvt_dev *nvt)
 {
+	unsigned long flags;
+
 	nvt_efm_enable(nvt);
 
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_ACPI);
@@ -514,12 +516,16 @@ static void nvt_enable_wake(struct nvt_dev *nvt)
 
 	nvt_efm_disable(nvt);
 
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
+
 	nvt_cir_wake_reg_write(nvt, CIR_WAKE_IRCON_MODE0 | CIR_WAKE_IRCON_RXEN |
 			       CIR_WAKE_IRCON_R | CIR_WAKE_IRCON_RXINV |
 			       CIR_WAKE_IRCON_SAMPLE_PERIOD_SEL,
 			       CIR_WAKE_IRCON);
 	nvt_cir_wake_reg_write(nvt, 0xff, CIR_WAKE_IRSTS);
 	nvt_cir_wake_reg_write(nvt, 0, CIR_WAKE_IREN);
+
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 }
 
 #if 0 /* Currently unused */
@@ -1151,9 +1157,10 @@ static void nvt_remove(struct pnp_dev *pdev)
 	/* disable CIR */
 	nvt_cir_reg_write(nvt, 0, CIR_IREN);
 	nvt_disable_cir(nvt);
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
 	/* enable CIR Wake (for IR power-on) */
 	nvt_enable_wake(nvt);
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 
 	rc_unregister_device(nvt->rdev);
 }
@@ -1178,14 +1185,14 @@ static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
 	/* disable all CIR interrupts */
 	nvt_cir_reg_write(nvt, 0, CIR_IREN);
 
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
 	/* disable cir logical dev */
 	nvt_disable_logical_dev(nvt, LOGICAL_DEV_CIR);
 
 	/* make sure wake is enabled */
 	nvt_enable_wake(nvt);
 
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
-
 	return 0;
 }
 
@@ -1204,11 +1211,8 @@ static int nvt_resume(struct pnp_dev *pdev)
 static void nvt_shutdown(struct pnp_dev *pdev)
 {
 	struct nvt_dev *nvt = pnp_get_drvdata(pdev);
-	unsigned long flags;
 
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
 	nvt_enable_wake(nvt);
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 }
 
 static const struct pnp_device_id nvt_ids[] = {
-- 
2.7.0


