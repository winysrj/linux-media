Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33095 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbcBAUvF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2016 15:51:05 -0500
Received: by mail-wm0-f67.google.com with SMTP id r129so10835557wmr.0
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2016 12:51:05 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 1/3] media: rc: nuvoton: fix locking issue with nvt_enable_cir
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56AFC4DC.9080004@gmail.com>
Date: Mon, 1 Feb 2016 21:49:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

nvt_enable_cir calls nvt_enable_logical_dev (that may sleep)
while holding a spinlock.
This patch fixes this and moves the content of nvt_enable_cir
to nvt_open as this is the only caller.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index b6acc84..971858a 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -942,23 +942,6 @@ static irqreturn_t nvt_cir_wake_isr(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void nvt_enable_cir(struct nvt_dev *nvt)
-{
-	/* set function enable flags */
-	nvt_cir_reg_write(nvt, CIR_IRCON_TXEN | CIR_IRCON_RXEN |
-			  CIR_IRCON_RXINV | CIR_IRCON_SAMPLE_PERIOD_SEL,
-			  CIR_IRCON);
-
-	/* enable the CIR logical device */
-	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
-
-	/* clear all pending interrupts */
-	nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
-
-	/* enable interrupts */
-	nvt_set_cir_iren(nvt);
-}
-
 static void nvt_disable_cir(struct nvt_dev *nvt)
 {
 	/* disable CIR interrupts */
@@ -984,9 +967,23 @@ static int nvt_open(struct rc_dev *dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&nvt->nvt_lock, flags);
-	nvt_enable_cir(nvt);
+
+	/* set function enable flags */
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
 	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 
+	/* enable the CIR logical device */
+	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
+
 	return 0;
 }
 
-- 
2.7.0


