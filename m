Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36244 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbcI3Ume (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Sep 2016 16:42:34 -0400
Received: by mail-wm0-f68.google.com with SMTP id b184so4992272wma.3
        for <linux-media@vger.kernel.org>; Fri, 30 Sep 2016 13:42:33 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 2/2] rc: nuvoton: use managed versions of rc_allocate_device
 and rc_register_device
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <73953c79-642d-7c76-f402-dfff199af811@gmail.com>
Cc: linux-media@vger.kernel.org
Message-ID: <13d0cf01-7fc7-a33f-a7e6-6e32bf41b3d3@gmail.com>
Date: Fri, 30 Sep 2016 22:42:17 +0200
MIME-Version: 1.0
In-Reply-To: <73953c79-642d-7c76-f402-dfff199af811@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the remove function and the error path in the probe function by
using the managed versions of rc_allocate_device and rc_register_device.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 50 +++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 04fedaa..3df3bd9 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1002,40 +1002,40 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 {
 	struct nvt_dev *nvt;
 	struct rc_dev *rdev;
-	int ret = -ENOMEM;
+	int ret;
 
 	nvt = devm_kzalloc(&pdev->dev, sizeof(struct nvt_dev), GFP_KERNEL);
 	if (!nvt)
-		return ret;
+		return -ENOMEM;
 
 	/* input device for IR remote (and tx) */
-	rdev = rc_allocate_device();
+	rdev = devm_rc_allocate_device(&pdev->dev);
 	if (!rdev)
-		goto exit_free_dev_rdev;
+		return -ENOMEM;
 
-	ret = -ENODEV;
 	/* activate pnp device */
-	if (pnp_activate_dev(pdev) < 0) {
+	ret = pnp_activate_dev(pdev);
+	if (ret) {
 		dev_err(&pdev->dev, "Could not activate PNP device!\n");
-		goto exit_free_dev_rdev;
+		return ret;
 	}
 
 	/* validate pnp resources */
 	if (!pnp_port_valid(pdev, 0) ||
 	    pnp_port_len(pdev, 0) < CIR_IOREG_LENGTH) {
 		dev_err(&pdev->dev, "IR PNP Port not valid!\n");
-		goto exit_free_dev_rdev;
+		return -EINVAL;
 	}
 
 	if (!pnp_irq_valid(pdev, 0)) {
 		dev_err(&pdev->dev, "PNP IRQ not valid!\n");
-		goto exit_free_dev_rdev;
+		return -EINVAL;
 	}
 
 	if (!pnp_port_valid(pdev, 1) ||
 	    pnp_port_len(pdev, 1) < CIR_IOREG_LENGTH) {
 		dev_err(&pdev->dev, "Wake PNP Port not valid!\n");
-		goto exit_free_dev_rdev;
+		return -EINVAL;
 	}
 
 	nvt->cir_addr = pnp_port_start(pdev, 0);
@@ -1056,7 +1056,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	ret = nvt_hw_detect(nvt);
 	if (ret)
-		goto exit_free_dev_rdev;
+		return ret;
 
 	/* Initialize CIR & CIR Wake Logical Devices */
 	nvt_efm_enable(nvt);
@@ -1099,27 +1099,27 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 #endif
 	nvt->rdev = rdev;
 
-	ret = rc_register_device(rdev);
+	ret = devm_rc_register_device(&pdev->dev, rdev);
 	if (ret)
-		goto exit_free_dev_rdev;
+		return ret;
 
-	ret = -EBUSY;
 	/* now claim resources */
 	if (!devm_request_region(&pdev->dev, nvt->cir_addr,
 			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
-		goto exit_unregister_device;
+		return -EBUSY;
 
-	if (devm_request_irq(&pdev->dev, nvt->cir_irq, nvt_cir_isr,
-			     IRQF_SHARED, NVT_DRIVER_NAME, (void *)nvt))
-		goto exit_unregister_device;
+	ret = devm_request_irq(&pdev->dev, nvt->cir_irq, nvt_cir_isr,
+			       IRQF_SHARED, NVT_DRIVER_NAME, nvt);
+	if (ret)
+		return ret;
 
 	if (!devm_request_region(&pdev->dev, nvt->cir_wake_addr,
 			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME "-wake"))
-		goto exit_unregister_device;
+		return -EBUSY;
 
 	ret = device_create_file(&rdev->dev, &dev_attr_wakeup_data);
 	if (ret)
-		goto exit_unregister_device;
+		return ret;
 
 	device_init_wakeup(&pdev->dev, true);
 
@@ -1130,14 +1130,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	}
 
 	return 0;
-
-exit_unregister_device:
-	rc_unregister_device(rdev);
-	rdev = NULL;
-exit_free_dev_rdev:
-	rc_free_device(rdev);
-
-	return ret;
 }
 
 static void nvt_remove(struct pnp_dev *pdev)
@@ -1150,8 +1142,6 @@ static void nvt_remove(struct pnp_dev *pdev)
 
 	/* enable CIR Wake (for IR power-on) */
 	nvt_enable_wake(nvt);
-
-	rc_unregister_device(nvt->rdev);
 }
 
 static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
-- 
2.10.0


