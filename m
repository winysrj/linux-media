Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36412 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932932AbcJYTYT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 15:24:19 -0400
Received: by mail-wm0-f66.google.com with SMTP id c78so1922562wme.3
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2016 12:24:18 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5/5] media: rc: nuvoton: replace usage of spin_lock_irqsave in
 ISR
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <d213893b-4bdf-7db1-b2e3-e2d5d028a51f@gmail.com>
Cc: linux-media@vger.kernel.org
Message-ID: <e1597e55-e454-1be3-62b8-09eb59ebe991@gmail.com>
Date: Tue, 25 Oct 2016 21:23:52 +0200
MIME-Version: 1.0
In-Reply-To: <d213893b-4bdf-7db1-b2e3-e2d5d028a51f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kernel takes care that interrupts from one source are serialized.
So there's no need to use spinlock_irq_save.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 6332cf3..f21a2bc 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -840,11 +840,10 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 {
 	struct nvt_dev *nvt = data;
 	u8 status, iren;
-	unsigned long flags;
 
 	nvt_dbg_verbose("%s firing", __func__);
 
-	spin_lock_irqsave(&nvt->lock, flags);
+	spin_lock(&nvt->lock);
 
 	/*
 	 * Get IR Status register contents. Write 1 to ack/clear
@@ -866,7 +865,7 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	 * logical device is being disabled.
 	 */
 	if (status == 0xff && iren == 0xff) {
-		spin_unlock_irqrestore(&nvt->lock, flags);
+		spin_unlock(&nvt->lock);
 		nvt_dbg_verbose("Spurious interrupt detected");
 		return IRQ_HANDLED;
 	}
@@ -875,7 +874,7 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	 * status bit whether the related interrupt source is enabled
 	 */
 	if (!(status & iren)) {
-		spin_unlock_irqrestore(&nvt->lock, flags);
+		spin_unlock(&nvt->lock);
 		nvt_dbg_verbose("%s exiting, IRSTS 0x0", __func__);
 		return IRQ_NONE;
 	}
@@ -923,7 +922,7 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 		}
 	}
 
-	spin_unlock_irqrestore(&nvt->lock, flags);
+	spin_unlock(&nvt->lock);
 
 	nvt_dbg_verbose("%s done", __func__);
 	return IRQ_HANDLED;
-- 
2.10.1


