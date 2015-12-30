Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37764 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbbL3Qq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:57 -0500
Received: by mail-wm0-f42.google.com with SMTP id f206so84215106wmf.0
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:57 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 13/16] media: rc: nuvoton-cir: add locking to calls of
 nvt_enable_wake
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <568409F4.2020102@gmail.com>
Date: Wed, 30 Dec 2015 17:44:36 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add locking to nvt_enable_wake calls.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 252804d..c3294fb 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1173,16 +1173,16 @@ static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
 
 	nvt_dbg("%s called", __func__);
 
-	/* zero out misc state tracking */
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
-	nvt->study_state = ST_STUDY_NONE;
-	nvt->wake_state = ST_WAKE_NONE;
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
-
 	spin_lock_irqsave(&nvt->tx.lock, flags);
 	nvt->tx.tx_state = ST_TX_NONE;
 	spin_unlock_irqrestore(&nvt->tx.lock, flags);
 
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
+
+	/* zero out misc state tracking */
+	nvt->study_state = ST_STUDY_NONE;
+	nvt->wake_state = ST_WAKE_NONE;
+
 	/* disable all CIR interrupts */
 	nvt_cir_reg_write(nvt, 0, CIR_IREN);
 
@@ -1192,6 +1192,8 @@ static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
 	/* make sure wake is enabled */
 	nvt_enable_wake(nvt);
 
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+
 	return 0;
 }
 
@@ -1210,7 +1212,11 @@ static int nvt_resume(struct pnp_dev *pdev)
 static void nvt_shutdown(struct pnp_dev *pdev)
 {
 	struct nvt_dev *nvt = pnp_get_drvdata(pdev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&nvt->nvt_lock, flags);
 	nvt_enable_wake(nvt);
+	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 }
 
 static const struct pnp_device_id nvt_ids[] = {
-- 
2.6.4


