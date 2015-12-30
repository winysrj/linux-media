Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:32940 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbbL3Qqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:55 -0500
Received: by mail-wm0-f49.google.com with SMTP id f206so71492895wmf.0
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:54 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 11/16] media: rc: nuvoton-cir: improve logical device handling
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <568409CF.2050101@gmail.com>
Date: Wed, 30 Dec 2015 17:43:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only enable the logical devices after the registers have been initialized.

The call to nvt_enable_logical_dev in nvt_resume is not needed as this is
done implicitely by nvt_cir_regs_init now.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index cf6ccb3..e01fdc8 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -352,9 +352,8 @@ static void nvt_cir_ldev_init(struct nvt_dev *nvt)
 	val |= psval;
 	nvt_cr_write(nvt, val, psreg);
 
-	/* Select CIR logical device and enable */
+	/* Select CIR logical device */
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
-	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
 
 	nvt_set_ioaddr(nvt, &nvt->cir_addr);
 
@@ -366,7 +365,7 @@ static void nvt_cir_ldev_init(struct nvt_dev *nvt)
 
 static void nvt_cir_wake_ldev_init(struct nvt_dev *nvt)
 {
-	/* Select ACPI logical device, enable it and CIR Wake */
+	/* Select ACPI logical device and anable it */
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_ACPI);
 	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
 
@@ -376,9 +375,8 @@ static void nvt_cir_wake_ldev_init(struct nvt_dev *nvt)
 	/* enable pme interrupt of cir wakeup event */
 	nvt_set_reg_bit(nvt, PME_INTR_CIR_PASS_BIT, CR_ACPI_IRQ_EVENTS2);
 
-	/* Select CIR Wake logical device and enable */
+	/* Select CIR Wake logical device */
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR_WAKE);
-	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
 
 	nvt_set_ioaddr(nvt, &nvt->cir_wake_addr);
 
@@ -461,6 +459,9 @@ static void nvt_cir_regs_init(struct nvt_dev *nvt)
 
 	/* and finally, enable interrupts */
 	nvt_set_cir_iren(nvt);
+
+	/* enable the CIR logical device */
+	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
 }
 
 static void nvt_cir_wake_regs_init(struct nvt_dev *nvt)
@@ -495,6 +496,9 @@ static void nvt_cir_wake_regs_init(struct nvt_dev *nvt)
 
 	/* clear any and all stray interrupts */
 	nvt_cir_wake_reg_write(nvt, 0xff, CIR_WAKE_IRSTS);
+
+	/* enable the CIR WAKE logical device */
+	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR_WAKE);
 }
 
 static void nvt_enable_wake(struct nvt_dev *nvt)
@@ -1070,7 +1074,9 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	nvt_cir_wake_ldev_init(nvt);
 	nvt_efm_disable(nvt);
 
-	/* Initialize CIR & CIR Wake Config Registers */
+	/* Initialize CIR & CIR Wake Config Registers
+	 * and enable logical devices
+	 */
 	nvt_cir_regs_init(nvt);
 	nvt_cir_wake_regs_init(nvt);
 
@@ -1198,9 +1204,6 @@ static int nvt_resume(struct pnp_dev *pdev)
 	/* open interrupt */
 	nvt_set_cir_iren(nvt);
 
-	/* Enable CIR logical device */
-	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
-
 	nvt_cir_regs_init(nvt);
 	nvt_cir_wake_regs_init(nvt);
 
-- 
2.6.4


