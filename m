Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35643 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2DUQZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Apr 2012 12:25:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	luis.henriques@canonical.com
Subject: [PATCH v3] [media] rc: Postpone ISR registration
Date: Sat, 21 Apr 2012 17:25:21 +0100
Message-Id: <1335025521-7979-1-git-send-email-luis.henriques@canonical.com>
In-Reply-To: <20120420205002.GD17452@redhat.com>
References: <20120420205002.GD17452@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An early registration of an ISR was causing a crash to several users (for
example, with the ite-cir driver: http://bugs.launchpad.net/bugs/972723).
The reason was that IRQs were being triggered before a driver
initialisation was completed.

This patch fixes this by moving the invocation to request_irq() and to
request_region() to a later stage on the driver probe function.

Cc: <stable@vger.kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/rc/ene_ir.c      |   32 ++++++++---------
 drivers/media/rc/fintek-cir.c  |   20 +++++------
 drivers/media/rc/ite-cir.c     |   20 +++++------
 drivers/media/rc/nuvoton-cir.c |   36 +++++++++----------
 drivers/media/rc/winbond-cir.c |   78 ++++++++++++++++++++--------------------
 5 files changed, 93 insertions(+), 93 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 860c112..bef5296 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1018,22 +1018,6 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 
 	spin_lock_init(&dev->hw_lock);
 
-	/* claim the resources */
-	error = -EBUSY;
-	dev->hw_io = pnp_port_start(pnp_dev, 0);
-	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
-		dev->hw_io = -1;
-		dev->irq = -1;
-		goto error;
-	}
-
-	dev->irq = pnp_irq(pnp_dev, 0);
-	if (request_irq(dev->irq, ene_isr,
-			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev)) {
-		dev->irq = -1;
-		goto error;
-	}
-
 	pnp_set_drvdata(pnp_dev, dev);
 	dev->pnp_dev = pnp_dev;
 
@@ -1086,6 +1070,22 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	device_set_wakeup_capable(&pnp_dev->dev, true);
 	device_set_wakeup_enable(&pnp_dev->dev, true);
 
+	/* claim the resources */
+	error = -EBUSY;
+	dev->hw_io = pnp_port_start(pnp_dev, 0);
+	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
+		dev->hw_io = -1;
+		dev->irq = -1;
+		goto error;
+	}
+
+	dev->irq = pnp_irq(pnp_dev, 0);
+	if (request_irq(dev->irq, ene_isr,
+			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev)) {
+		dev->irq = -1;
+		goto error;
+	}
+
 	error = rc_register_device(rdev);
 	if (error < 0)
 		goto error;
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 392d4be..238d403 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -514,16 +514,6 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 
 	spin_lock_init(&fintek->fintek_lock);
 
-	ret = -EBUSY;
-	/* now claim resources */
-	if (!request_region(fintek->cir_addr,
-			    fintek->cir_port_len, FINTEK_DRIVER_NAME))
-		goto failure;
-
-	if (request_irq(fintek->cir_irq, fintek_cir_isr, IRQF_SHARED,
-			FINTEK_DRIVER_NAME, (void *)fintek))
-		goto failure;
-
 	pnp_set_drvdata(pdev, fintek);
 	fintek->pdev = pdev;
 
@@ -558,6 +548,16 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 	/* rx resolution is hardwired to 50us atm, 1, 25, 100 also possible */
 	rdev->rx_resolution = US_TO_NS(CIR_SAMPLE_PERIOD);
 
+	ret = -EBUSY;
+	/* now claim resources */
+	if (!request_region(fintek->cir_addr,
+			    fintek->cir_port_len, FINTEK_DRIVER_NAME))
+		goto failure;
+
+	if (request_irq(fintek->cir_irq, fintek_cir_isr, IRQF_SHARED,
+			FINTEK_DRIVER_NAME, (void *)fintek))
+		goto failure;
+
 	ret = rc_register_device(rdev);
 	if (ret)
 		goto failure;
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 682009d..0e49c99 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1515,16 +1515,6 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	/* initialize raw event */
 	init_ir_raw_event(&itdev->rawir);
 
-	ret = -EBUSY;
-	/* now claim resources */
-	if (!request_region(itdev->cir_addr,
-				dev_desc->io_region_size, ITE_DRIVER_NAME))
-		goto failure;
-
-	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
-			ITE_DRIVER_NAME, (void *)itdev))
-		goto failure;
-
 	/* set driver data into the pnp device */
 	pnp_set_drvdata(pdev, itdev);
 	itdev->pdev = pdev;
@@ -1600,6 +1590,16 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	rdev->driver_name = ITE_DRIVER_NAME;
 	rdev->map_name = RC_MAP_RC6_MCE;
 
+	ret = -EBUSY;
+	/* now claim resources */
+	if (!request_region(itdev->cir_addr,
+				dev_desc->io_region_size, ITE_DRIVER_NAME))
+		goto failure;
+
+	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
+			ITE_DRIVER_NAME, (void *)itdev))
+		goto failure;
+
 	ret = rc_register_device(rdev);
 	if (ret)
 		goto failure;
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 144f3f5..8b2c071 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1021,24 +1021,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	spin_lock_init(&nvt->nvt_lock);
 	spin_lock_init(&nvt->tx.lock);
 
-	ret = -EBUSY;
-	/* now claim resources */
-	if (!request_region(nvt->cir_addr,
-			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
-		goto failure;
-
-	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
-			NVT_DRIVER_NAME, (void *)nvt))
-		goto failure;
-
-	if (!request_region(nvt->cir_wake_addr,
-			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
-		goto failure;
-
-	if (request_irq(nvt->cir_wake_irq, nvt_cir_wake_isr, IRQF_SHARED,
-			NVT_DRIVER_NAME, (void *)nvt))
-		goto failure;
-
 	pnp_set_drvdata(pdev, nvt);
 	nvt->pdev = pdev;
 
@@ -1085,6 +1067,24 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	rdev->tx_resolution = XYZ;
 #endif
 
+	ret = -EBUSY;
+	/* now claim resources */
+	if (!request_region(nvt->cir_addr,
+			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
+		goto failure;
+
+	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
+			NVT_DRIVER_NAME, (void *)nvt))
+		goto failure;
+
+	if (!request_region(nvt->cir_wake_addr,
+			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
+		goto failure;
+
+	if (request_irq(nvt->cir_wake_irq, nvt_cir_wake_isr, IRQF_SHARED,
+			NVT_DRIVER_NAME, (void *)nvt))
+		goto failure;
+
 	ret = rc_register_device(rdev);
 	if (ret)
 		goto failure;
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index b09c5fa..e366a8b 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -991,39 +991,10 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 		"(w: 0x%lX, e: 0x%lX, s: 0x%lX, i: %u)\n",
 		data->wbase, data->ebase, data->sbase, data->irq);
 
-	if (!request_region(data->wbase, WAKEUP_IOMEM_LEN, DRVNAME)) {
-		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
-			data->wbase, data->wbase + WAKEUP_IOMEM_LEN - 1);
-		err = -EBUSY;
-		goto exit_free_data;
-	}
-
-	if (!request_region(data->ebase, EHFUNC_IOMEM_LEN, DRVNAME)) {
-		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
-			data->ebase, data->ebase + EHFUNC_IOMEM_LEN - 1);
-		err = -EBUSY;
-		goto exit_release_wbase;
-	}
-
-	if (!request_region(data->sbase, SP_IOMEM_LEN, DRVNAME)) {
-		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
-			data->sbase, data->sbase + SP_IOMEM_LEN - 1);
-		err = -EBUSY;
-		goto exit_release_ebase;
-	}
-
-	err = request_irq(data->irq, wbcir_irq_handler,
-			  IRQF_DISABLED, DRVNAME, device);
-	if (err) {
-		dev_err(dev, "Failed to claim IRQ %u\n", data->irq);
-		err = -EBUSY;
-		goto exit_release_sbase;
-	}
-
 	led_trigger_register_simple("cir-tx", &data->txtrigger);
 	if (!data->txtrigger) {
 		err = -ENOMEM;
-		goto exit_free_irq;
+		goto exit_free_data;
 	}
 
 	led_trigger_register_simple("cir-rx", &data->rxtrigger);
@@ -1061,9 +1032,38 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->priv = data;
 	data->dev->dev.parent = &device->dev;
 
+	if (!request_region(data->wbase, WAKEUP_IOMEM_LEN, DRVNAME)) {
+		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
+			data->wbase, data->wbase + WAKEUP_IOMEM_LEN - 1);
+		err = -EBUSY;
+		goto exit_free_rc;
+	}
+
+	if (!request_region(data->ebase, EHFUNC_IOMEM_LEN, DRVNAME)) {
+		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
+			data->ebase, data->ebase + EHFUNC_IOMEM_LEN - 1);
+		err = -EBUSY;
+		goto exit_release_wbase;
+	}
+
+	if (!request_region(data->sbase, SP_IOMEM_LEN, DRVNAME)) {
+		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
+			data->sbase, data->sbase + SP_IOMEM_LEN - 1);
+		err = -EBUSY;
+		goto exit_release_ebase;
+	}
+
+	err = request_irq(data->irq, wbcir_irq_handler,
+			  IRQF_DISABLED, DRVNAME, device);
+	if (err) {
+		dev_err(dev, "Failed to claim IRQ %u\n", data->irq);
+		err = -EBUSY;
+		goto exit_release_sbase;
+	}
+
 	err = rc_register_device(data->dev);
 	if (err)
-		goto exit_free_rc;
+		goto exit_free_irq;
 
 	device_init_wakeup(&device->dev, 1);
 
@@ -1071,14 +1071,6 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 
 	return 0;
 
-exit_free_rc:
-	rc_free_device(data->dev);
-exit_unregister_led:
-	led_classdev_unregister(&data->led);
-exit_unregister_rxtrigger:
-	led_trigger_unregister_simple(data->rxtrigger);
-exit_unregister_txtrigger:
-	led_trigger_unregister_simple(data->txtrigger);
 exit_free_irq:
 	free_irq(data->irq, device);
 exit_release_sbase:
@@ -1087,6 +1079,14 @@ exit_release_ebase:
 	release_region(data->ebase, EHFUNC_IOMEM_LEN);
 exit_release_wbase:
 	release_region(data->wbase, WAKEUP_IOMEM_LEN);
+exit_free_rc:
+	rc_free_device(data->dev);
+exit_unregister_led:
+	led_classdev_unregister(&data->led);
+exit_unregister_rxtrigger:
+	led_trigger_unregister_simple(data->rxtrigger);
+exit_unregister_txtrigger:
+	led_trigger_unregister_simple(data->txtrigger);
 exit_free_data:
 	kfree(data);
 	pnp_set_drvdata(device, NULL);
-- 
1.7.9.5

