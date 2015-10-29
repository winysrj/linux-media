Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36632 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914AbbJ2VXi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 17:23:38 -0400
Received: by wmec75 with SMTP id c75so33074496wme.1
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2015 14:23:37 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 3/9] media: rc: nuvoton-cir: switch resource handling to devm
 functions
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56328D68.9050906@gmail.com>
Date: Thu, 29 Oct 2015 22:19:36 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to managed resource handling using the devm_ functions.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 4d8e12f..a382e17 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -971,7 +971,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	struct rc_dev *rdev;
 	int ret = -ENOMEM;
 
-	nvt = kzalloc(sizeof(struct nvt_dev), GFP_KERNEL);
+	nvt = devm_kzalloc(&pdev->dev, sizeof(struct nvt_dev), GFP_KERNEL);
 	if (!nvt)
 		return ret;
 
@@ -1071,21 +1071,22 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	ret = -EBUSY;
 	/* now claim resources */
-	if (!request_region(nvt->cir_addr,
+	if (!devm_request_region(&pdev->dev, nvt->cir_addr,
 			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
 		goto exit_unregister_device;
 
-	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
-			NVT_DRIVER_NAME, (void *)nvt))
-		goto exit_release_cir_addr;
+	if (devm_request_irq(&pdev->dev, nvt->cir_irq, nvt_cir_isr,
+			     IRQF_SHARED, NVT_DRIVER_NAME, (void *)nvt))
+		goto exit_unregister_device;
 
-	if (!request_region(nvt->cir_wake_addr,
+	if (!devm_request_region(&pdev->dev, nvt->cir_wake_addr,
 			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
-		goto exit_free_irq;
+		goto exit_unregister_device;
 
-	if (request_irq(nvt->cir_wake_irq, nvt_cir_wake_isr, IRQF_SHARED,
-			NVT_DRIVER_NAME, (void *)nvt))
-		goto exit_release_cir_wake_addr;
+	if (devm_request_irq(&pdev->dev, nvt->cir_wake_irq,
+			     nvt_cir_wake_isr, IRQF_SHARED,
+			     NVT_DRIVER_NAME, (void *)nvt))
+		goto exit_unregister_device;
 
 	device_init_wakeup(&pdev->dev, true);
 
@@ -1097,18 +1098,11 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	return 0;
 
-exit_release_cir_wake_addr:
-	release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
-exit_free_irq:
-	free_irq(nvt->cir_irq, nvt);
-exit_release_cir_addr:
-	release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
 exit_unregister_device:
 	rc_unregister_device(rdev);
 	rdev = NULL;
 exit_free_dev_rdev:
 	rc_free_device(rdev);
-	kfree(nvt);
 
 	return ret;
 }
@@ -1126,15 +1120,7 @@ static void nvt_remove(struct pnp_dev *pdev)
 	nvt_enable_wake(nvt);
 	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 
-	/* free resources */
-	free_irq(nvt->cir_irq, nvt);
-	free_irq(nvt->cir_wake_irq, nvt);
-	release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
-	release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
-
 	rc_unregister_device(nvt->rdev);
-
-	kfree(nvt);
 }
 
 static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
-- 
2.6.2


