Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38091 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbbL3Qqr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:47 -0500
Received: by mail-wm0-f47.google.com with SMTP id b14so55519965wmb.1
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:47 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 05/16] media: rc: nuvoton-cir: factor out logical device
 enabling
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <568408EC.5090900@gmail.com>
Date: Wed, 30 Dec 2015 17:40:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Factor out enabling of a logical device.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index ceb6b95..8ed8011 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -110,6 +110,15 @@ static inline void nvt_select_logical_dev(struct nvt_dev *nvt, u8 ldev)
 	nvt_cr_write(nvt, ldev, CR_LOGICAL_DEV_SEL);
 }
 
+/* select and enable logical device with setting EFM mode*/
+static inline void nvt_enable_logical_dev(struct nvt_dev *nvt, u8 ldev)
+{
+	nvt_efm_enable(nvt);
+	nvt_select_logical_dev(nvt, ldev);
+	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
+	nvt_efm_disable(nvt);
+}
+
 /* select and disable logical device with setting EFM mode*/
 static inline void nvt_disable_logical_dev(struct nvt_dev *nvt, u8 ldev)
 {
@@ -916,13 +925,8 @@ static void nvt_enable_cir(struct nvt_dev *nvt)
 			  CIR_IRCON_RXINV | CIR_IRCON_SAMPLE_PERIOD_SEL,
 			  CIR_IRCON);
 
-	nvt_efm_enable(nvt);
-
 	/* enable the CIR logical device */
-	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
-	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
-
-	nvt_efm_disable(nvt);
+	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
 
 	/* clear all pending interrupts */
 	nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
@@ -1168,11 +1172,7 @@ static int nvt_resume(struct pnp_dev *pdev)
 	nvt_set_cir_iren(nvt);
 
 	/* Enable CIR logical device */
-	nvt_efm_enable(nvt);
-	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
-	nvt_cr_write(nvt, LOGICAL_DEV_ENABLE, CR_LOGICAL_DEV_EN);
-
-	nvt_efm_disable(nvt);
+	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
 
 	nvt_cir_regs_init(nvt);
 	nvt_cir_wake_regs_init(nvt);
-- 
2.6.4


