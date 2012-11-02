Return-path: <linux-media-owner@vger.kernel.org>
Received: from 84-245-11-97.dsl.cambrium.nl ([84.245.11.97]:37231 "EHLO
	grubby.stderr.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757356Ab2KBNOg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2012 09:14:36 -0400
From: Matthijs Kooijman <matthijs@stdin.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stephan Raue <stephan@openelec.tv>,
	Luis Henriques <luis.henriques@canonical.com>,
	Matthijs Kooijman <matthijs@stdin.nl>,
	Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH 3/3] [media] rc: Call rc_register_device before irq setup
Date: Fri,  2 Nov 2012 14:13:56 +0100
Message-Id: <1351862036-20384-4-git-send-email-matthijs@stdin.nl>
In-Reply-To: <1351862036-20384-1-git-send-email-matthijs@stdin.nl>
References: <20121015110111.GD17159@login.drsnuggles.stderr.nl>
 <1351862036-20384-1-git-send-email-matthijs@stdin.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This should fix a potential race condition, when the irq handler
triggers while rc_register_device is still setting up the rdev->raw
device.

This crash has not been observed in practice, but there should be a very
small window where it could occur. Since ir_raw_event_store_with_filter
checks if rdev->raw is not NULL before using it, this bug is not
triggered if the request_irq triggers a pending irq directly (since
rdev->raw will still be NULL then).

This commit was tested on nuvoton-cir only.

Signed-off-by: Matthijs Kooijman <matthijs@stdin.nl>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ene_ir.c      |   14 +++++++-------
 drivers/media/rc/ite-cir.c     |   14 +++++++-------
 drivers/media/rc/nuvoton-cir.c |   14 +++++++-------
 drivers/media/rc/winbond-cir.c |   14 +++++++-------
 4 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index f7fdfea..e601166 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1075,10 +1075,14 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	device_set_wakeup_capable(&pnp_dev->dev, true);
 	device_set_wakeup_enable(&pnp_dev->dev, true);
 
+	error = rc_register_device(rdev);
+	if (error < 0)
+		goto exit_free_dev_rdev;
+
 	/* claim the resources */
 	error = -EBUSY;
 	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
-		goto exit_free_dev_rdev;
+		goto exit_unregister_device;
 	}
 
 	dev->irq = pnp_irq(pnp_dev, 0);
@@ -1087,17 +1091,13 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		goto exit_release_hw_io;
 	}
 
-	error = rc_register_device(rdev);
-	if (error < 0)
-		goto exit_free_irq;
-
 	pr_notice("driver has been successfully loaded\n");
 	return 0;
 
-exit_free_irq:
-	free_irq(dev->irq, dev);
 exit_release_hw_io:
 	release_region(dev->hw_io, ENE_IO_SIZE);
+exit_unregister_device:
+	rc_unregister_device(rdev);
 exit_free_dev_rdev:
 	rc_free_device(rdev);
 	kfree(dev);
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 8e0e661..e810846 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1591,28 +1591,28 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	rdev->driver_name = ITE_DRIVER_NAME;
 	rdev->map_name = RC_MAP_RC6_MCE;
 
+	ret = rc_register_device(rdev);
+	if (ret)
+		goto exit_free_dev_rdev;
+
 	ret = -EBUSY;
 	/* now claim resources */
 	if (!request_region(itdev->cir_addr,
 				dev_desc->io_region_size, ITE_DRIVER_NAME))
-		goto exit_free_dev_rdev;
+		goto exit_unregister_device;
 
 	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
 			ITE_DRIVER_NAME, (void *)itdev))
 		goto exit_release_cir_addr;
 
-	ret = rc_register_device(rdev);
-	if (ret)
-		goto exit_free_irq;
-
 	ite_pr(KERN_NOTICE, "driver has been successfully loaded\n");
 
 	return 0;
 
-exit_free_irq:
-	free_irq(itdev->cir_irq, itdev);
 exit_release_cir_addr:
 	release_region(itdev->cir_addr, itdev->params.io_region_size);
+exit_unregister_device:
+	rc_unregister_device(rdev);
 exit_free_dev_rdev:
 	rc_free_device(rdev);
 	kfree(itdev);
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index c6441e6..6cf43cc 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1067,11 +1067,15 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 #endif
 	nvt->rdev = rdev;
 
+	ret = rc_register_device(rdev);
+	if (ret)
+		goto exit_free_dev_rdev;
+
 	ret = -EBUSY;
 	/* now claim resources */
 	if (!request_region(nvt->cir_addr,
 			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
-		goto exit_free_dev_rdev;
+		goto exit_unregister_device;
 
 	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
 			NVT_DRIVER_NAME, (void *)nvt))
@@ -1085,10 +1089,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 			NVT_DRIVER_NAME, (void *)nvt))
 		goto exit_release_cir_wake_addr;
 
-	ret = rc_register_device(rdev);
-	if (ret)
-		goto exit_free_wake_irq;
-
 	device_init_wakeup(&pdev->dev, true);
 
 	nvt_pr(KERN_NOTICE, "driver has been successfully loaded\n");
@@ -1099,14 +1099,14 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	return 0;
 
-exit_free_wake_irq:
-	free_irq(nvt->cir_wake_irq, nvt);
 exit_release_cir_wake_addr:
 	release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
 exit_free_irq:
 	free_irq(nvt->cir_irq, nvt);
 exit_release_cir_addr:
 	release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
+exit_unregister_device:
+	rc_unregister_device(rdev);
 exit_free_dev_rdev:
 	rc_free_device(rdev);
 	kfree(nvt);
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 45d2fff..de76474 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1024,11 +1024,15 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->timeout = MS_TO_NS(100);
 	data->dev->allowed_protos = RC_BIT_ALL;
 
+	err = rc_register_device(data->dev);
+	if (err)
+		goto exit_free_rc;
+
 	if (!request_region(data->wbase, WAKEUP_IOMEM_LEN, DRVNAME)) {
 		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
 			data->wbase, data->wbase + WAKEUP_IOMEM_LEN - 1);
 		err = -EBUSY;
-		goto exit_free_rc;
+		goto exit_unregister_device;
 	}
 
 	if (!request_region(data->ebase, EHFUNC_IOMEM_LEN, DRVNAME)) {
@@ -1053,24 +1057,20 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 		goto exit_release_sbase;
 	}
 
-	err = rc_register_device(data->dev);
-	if (err)
-		goto exit_free_irq;
-
 	device_init_wakeup(&device->dev, 1);
 
 	wbcir_init_hw(data);
 
 	return 0;
 
-exit_free_irq:
-	free_irq(data->irq, device);
 exit_release_sbase:
 	release_region(data->sbase, SP_IOMEM_LEN);
 exit_release_ebase:
 	release_region(data->ebase, EHFUNC_IOMEM_LEN);
 exit_release_wbase:
 	release_region(data->wbase, WAKEUP_IOMEM_LEN);
+exit_unregister_device:
+	rc_unregister_device(data->dev);
 exit_free_rc:
 	rc_free_device(data->dev);
 exit_unregister_led:
-- 
1.7.10

