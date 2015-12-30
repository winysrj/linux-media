Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38074 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbbL3Qqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:46 -0500
Received: by mail-wm0-f51.google.com with SMTP id b14so55519311wmb.1
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:45 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 04/16] media: rc: nuvoton-cir: factor out logical device
 disabling
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <568408E5.6030208@gmail.com>
Date: Wed, 30 Dec 2015 17:40:05 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Factor out disabling of a logical device.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index f661eff..ceb6b95 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -110,6 +110,15 @@ static inline void nvt_select_logical_dev(struct nvt_dev *nvt, u8 ldev)
 	nvt_cr_write(nvt, ldev, CR_LOGICAL_DEV_SEL);
 }
 
+/* select and disable logical device with setting EFM mode*/
+static inline void nvt_disable_logical_dev(struct nvt_dev *nvt, u8 ldev)
+{
+	nvt_efm_enable(nvt);
+	nvt_select_logical_dev(nvt, ldev);
+	nvt_cr_write(nvt, LOGICAL_DEV_DISABLE, CR_LOGICAL_DEV_EN);
+	nvt_efm_disable(nvt);
+}
+
 /* write val to cir config register */
 static inline void nvt_cir_reg_write(struct nvt_dev *nvt, u8 val, u8 offset)
 {
@@ -937,13 +946,8 @@ static void nvt_disable_cir(struct nvt_dev *nvt)
 	nvt_clear_cir_fifo(nvt);
 	nvt_clear_tx_fifo(nvt);
 
-	nvt_efm_enable(nvt);
-
 	/* disable the CIR logical device */
-	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
-	nvt_cr_write(nvt, LOGICAL_DEV_DISABLE, CR_LOGICAL_DEV_EN);
-
-	nvt_efm_disable(nvt);
+	nvt_disable_logical_dev(nvt, LOGICAL_DEV_CIR);
 }
 
 static int nvt_open(struct rc_dev *dev)
@@ -1145,13 +1149,8 @@ static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
 	/* disable all CIR interrupts */
 	nvt_cir_reg_write(nvt, 0, CIR_IREN);
 
-	nvt_efm_enable(nvt);
-
 	/* disable cir logical dev */
-	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
-	nvt_cr_write(nvt, LOGICAL_DEV_DISABLE, CR_LOGICAL_DEV_EN);
-
-	nvt_efm_disable(nvt);
+	nvt_disable_logical_dev(nvt, LOGICAL_DEV_CIR);
 
 	/* make sure wake is enabled */
 	nvt_enable_wake(nvt);
-- 
2.6.4


