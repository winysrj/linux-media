Return-path: <linux-media-owner@vger.kernel.org>
Received: from 84-245-11-97.dsl.cambrium.nl ([84.245.11.97]:37214 "EHLO
	grubby.stderr.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753358Ab2KBNO1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2012 09:14:27 -0400
From: Matthijs Kooijman <matthijs@stdin.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stephan Raue <stephan@openelec.tv>,
	Luis Henriques <luis.henriques@canonical.com>,
	Matthijs Kooijman <matthijs@stdin.nl>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/3] [media] rc: Make probe cleanup goto labels more verbose
Date: Fri,  2 Nov 2012 14:13:54 +0100
Message-Id: <1351862036-20384-2-git-send-email-matthijs@stdin.nl>
In-Reply-To: <1351862036-20384-1-git-send-email-matthijs@stdin.nl>
References: <20121015110111.GD17159@login.drsnuggles.stderr.nl>
 <1351862036-20384-1-git-send-email-matthijs@stdin.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before, labels were simply numbered. Now, the labels are named after the
cleanup action they'll perform (first), based on how the winbond-cir
driver does it. This makes the code a bit more clear and makes changes
in the ordering of labels easier to review.

This change is applied only to the rc drivers that do significant
cleanup in their probe functions: ati-remote, ene-ir, fintek-cir,
gpio-ir-recv, ite-cir, nuvoton-cir.

This commit should not change any code, it just renames goto labels.

Signed-off-by: Matthijs Kooijman <matthijs@stdin.nl>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/ati_remote.c   |   27 ++++++++++++++++-----------
 drivers/media/rc/ene_ir.c       |   20 ++++++++++----------
 drivers/media/rc/fintek-cir.c   |   20 ++++++++++----------
 drivers/media/rc/gpio-ir-recv.c |   19 +++++++++----------
 drivers/media/rc/ite-cir.c      |   18 +++++++++---------
 drivers/media/rc/nuvoton-cir.c  |   30 +++++++++++++++---------------
 6 files changed, 69 insertions(+), 65 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 2d6fb26..4d6a63f 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -872,11 +872,11 @@ static int ati_remote_probe(struct usb_interface *interface,
 	ati_remote = kzalloc(sizeof (struct ati_remote), GFP_KERNEL);
 	rc_dev = rc_allocate_device();
 	if (!ati_remote || !rc_dev)
-		goto fail1;
+		goto exit_free_dev_rdev;
 
 	/* Allocate URB buffers, URBs */
 	if (ati_remote_alloc_buffers(udev, ati_remote))
-		goto fail2;
+		goto exit_free_buffers;
 
 	ati_remote->endpoint_in = endpoint_in;
 	ati_remote->endpoint_out = endpoint_out;
@@ -924,12 +924,12 @@ static int ati_remote_probe(struct usb_interface *interface,
 	/* Device Hardware Initialization - fills in ati_remote->idev from udev. */
 	err = ati_remote_initialize(ati_remote);
 	if (err)
-		goto fail3;
+		goto exit_kill_urbs;
 
 	/* Set up and register rc device */
 	err = rc_register_device(ati_remote->rdev);
 	if (err)
-		goto fail3;
+		goto exit_kill_urbs;
 
 	/* use our delay for rc_dev */
 	ati_remote->rdev->input_dev->rep[REP_DELAY] = repeat_delay;
@@ -939,7 +939,7 @@ static int ati_remote_probe(struct usb_interface *interface,
 		input_dev = input_allocate_device();
 		if (!input_dev) {
 			err = -ENOMEM;
-			goto fail4;
+			goto exit_unregister_device;
 		}
 
 		ati_remote->idev = input_dev;
@@ -947,19 +947,24 @@ static int ati_remote_probe(struct usb_interface *interface,
 		err = input_register_device(input_dev);
 
 		if (err)
-			goto fail5;
+			goto exit_free_input_device;
 	}
 
 	usb_set_intfdata(interface, ati_remote);
 	return 0;
 
- fail5:	input_free_device(input_dev);
- fail4:	rc_unregister_device(rc_dev);
+ exit_free_input_device:
+	input_free_device(input_dev);
+ exit_unregister_device:
+	rc_unregister_device(rc_dev);
 	rc_dev = NULL;
- fail3:	usb_kill_urb(ati_remote->irq_urb);
+ exit_kill_urbs:
+	usb_kill_urb(ati_remote->irq_urb);
 	usb_kill_urb(ati_remote->out_urb);
- fail2:	ati_remote_free_buffers(ati_remote);
- fail1:	rc_free_device(rc_dev);
+ exit_free_buffers:
+	ati_remote_free_buffers(ati_remote);
+ exit_free_dev_rdev:
+	 rc_free_device(rc_dev);
 	kfree(ati_remote);
 	return err;
 }
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 22231dd..f7fdfea 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1003,7 +1003,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
 	rdev = rc_allocate_device();
 	if (!dev || !rdev)
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	/* validate resources */
 	error = -ENODEV;
@@ -1014,10 +1014,10 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 
 	if (!pnp_port_valid(pnp_dev, 0) ||
 	    pnp_port_len(pnp_dev, 0) < ENE_IO_SIZE)
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	if (!pnp_irq_valid(pnp_dev, 0))
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	spin_lock_init(&dev->hw_lock);
 
@@ -1033,7 +1033,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	/* detect hardware version and features */
 	error = ene_hw_detect(dev);
 	if (error)
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	if (!dev->hw_learning_and_tx_capable && txsim) {
 		dev->hw_learning_and_tx_capable = true;
@@ -1078,27 +1078,27 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	/* claim the resources */
 	error = -EBUSY;
 	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
-		goto failure;
+		goto exit_free_dev_rdev;
 	}
 
 	dev->irq = pnp_irq(pnp_dev, 0);
 	if (request_irq(dev->irq, ene_isr,
 			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev)) {
-		goto failure2;
+		goto exit_release_hw_io;
 	}
 
 	error = rc_register_device(rdev);
 	if (error < 0)
-		goto failure3;
+		goto exit_free_irq;
 
 	pr_notice("driver has been successfully loaded\n");
 	return 0;
 
-failure3:
+exit_free_irq:
 	free_irq(dev->irq, dev);
-failure2:
+exit_release_hw_io:
 	release_region(dev->hw_io, ENE_IO_SIZE);
-failure:
+exit_free_dev_rdev:
 	rc_free_device(rdev);
 	kfree(dev);
 	return error;
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 936c3f7..3d5e57c 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -500,18 +500,18 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 	/* input device for IR remote (and tx) */
 	rdev = rc_allocate_device();
 	if (!rdev)
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	ret = -ENODEV;
 	/* validate pnp resources */
 	if (!pnp_port_valid(pdev, 0)) {
 		dev_err(&pdev->dev, "IR PNP Port not valid!\n");
-		goto failure;
+		goto exit_free_dev_rdev;
 	}
 
 	if (!pnp_irq_valid(pdev, 0)) {
 		dev_err(&pdev->dev, "IR PNP IRQ not valid!\n");
-		goto failure;
+		goto exit_free_dev_rdev;
 	}
 
 	fintek->cir_addr = pnp_port_start(pdev, 0);
@@ -528,7 +528,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 
 	ret = fintek_hw_detect(fintek);
 	if (ret)
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	/* Initialize CIR & CIR Wake Logical Devices */
 	fintek_config_mode_enable(fintek);
@@ -561,15 +561,15 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 	/* now claim resources */
 	if (!request_region(fintek->cir_addr,
 			    fintek->cir_port_len, FINTEK_DRIVER_NAME))
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	if (request_irq(fintek->cir_irq, fintek_cir_isr, IRQF_SHARED,
 			FINTEK_DRIVER_NAME, (void *)fintek))
-		goto failure2;
+		goto exit_free_cir_addr;
 
 	ret = rc_register_device(rdev);
 	if (ret)
-		goto failure3;
+		goto exit_free_irq;
 
 	device_init_wakeup(&pdev->dev, true);
 	fintek->rdev = rdev;
@@ -579,11 +579,11 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 
 	return 0;
 
-failure3:
+exit_free_irq:
 	free_irq(fintek->cir_irq, fintek);
-failure2:
+exit_free_cir_addr:
 	release_region(fintek->cir_addr, fintek->cir_port_len);
-failure:
+exit_free_dev_rdev:
 	rc_free_device(rdev);
 	kfree(fintek);
 
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index ba1a1eb..d240036 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -79,7 +79,7 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
 	rcdev = rc_allocate_device();
 	if (!rcdev) {
 		rc = -ENOMEM;
-		goto err_allocate_device;
+		goto exit_free_dev;
 	}
 
 	rcdev->priv = gpio_dev;
@@ -104,15 +104,15 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
 
 	rc = gpio_request(pdata->gpio_nr, "gpio-ir-recv");
 	if (rc < 0)
-		goto err_gpio_request;
+		goto exit_free_rdev;
 	rc  = gpio_direction_input(pdata->gpio_nr);
 	if (rc < 0)
-		goto err_gpio_direction_input;
+		goto exit_free_gpio;
 
 	rc = rc_register_device(rcdev);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "failed to register rc device\n");
-		goto err_register_rc_device;
+		goto exit_free_gpio;
 	}
 
 	platform_set_drvdata(pdev, gpio_dev);
@@ -122,20 +122,19 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
 			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 					"gpio-ir-recv-irq", gpio_dev);
 	if (rc < 0)
-		goto err_request_irq;
+		goto exit_unregister_device;
 
 	return 0;
 
-err_request_irq:
+exit_unregister_device:
 	platform_set_drvdata(pdev, NULL);
 	rc_unregister_device(rcdev);
-err_register_rc_device:
-err_gpio_direction_input:
+exit_free_gpio:
 	gpio_free(pdata->gpio_nr);
-err_gpio_request:
+exit_free_rdev:
 	rc_free_device(rcdev);
 	rcdev = NULL;
-err_allocate_device:
+exit_free_dev:
 	kfree(gpio_dev);
 	return rc;
 }
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 5e5a7f2..8e0e661 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1472,7 +1472,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	/* input device for IR remote (and tx) */
 	rdev = rc_allocate_device();
 	if (!rdev)
-		goto failure;
+		goto exit_free_dev_rdev;
 	itdev->rdev = rdev;
 
 	ret = -ENODEV;
@@ -1498,12 +1498,12 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	if (!pnp_port_valid(pdev, io_rsrc_no) ||
 	    pnp_port_len(pdev, io_rsrc_no) != dev_desc->io_region_size) {
 		dev_err(&pdev->dev, "IR PNP Port not valid!\n");
-		goto failure;
+		goto exit_free_dev_rdev;
 	}
 
 	if (!pnp_irq_valid(pdev, 0)) {
 		dev_err(&pdev->dev, "PNP IRQ not valid!\n");
-		goto failure;
+		goto exit_free_dev_rdev;
 	}
 
 	/* store resource values */
@@ -1595,25 +1595,25 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	/* now claim resources */
 	if (!request_region(itdev->cir_addr,
 				dev_desc->io_region_size, ITE_DRIVER_NAME))
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
 			ITE_DRIVER_NAME, (void *)itdev))
-		goto failure2;
+		goto exit_release_cir_addr;
 
 	ret = rc_register_device(rdev);
 	if (ret)
-		goto failure3;
+		goto exit_free_irq;
 
 	ite_pr(KERN_NOTICE, "driver has been successfully loaded\n");
 
 	return 0;
 
-failure3:
+exit_free_irq:
 	free_irq(itdev->cir_irq, itdev);
-failure2:
+exit_release_cir_addr:
 	release_region(itdev->cir_addr, itdev->params.io_region_size);
-failure:
+exit_free_dev_rdev:
 	rc_free_device(rdev);
 	kfree(itdev);
 
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index e4ea89a..3477e23 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -986,25 +986,25 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* input device for IR remote (and tx) */
 	rdev = rc_allocate_device();
 	if (!rdev)
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	ret = -ENODEV;
 	/* validate pnp resources */
 	if (!pnp_port_valid(pdev, 0) ||
 	    pnp_port_len(pdev, 0) < CIR_IOREG_LENGTH) {
 		dev_err(&pdev->dev, "IR PNP Port not valid!\n");
-		goto failure;
+		goto exit_free_dev_rdev;
 	}
 
 	if (!pnp_irq_valid(pdev, 0)) {
 		dev_err(&pdev->dev, "PNP IRQ not valid!\n");
-		goto failure;
+		goto exit_free_dev_rdev;
 	}
 
 	if (!pnp_port_valid(pdev, 1) ||
 	    pnp_port_len(pdev, 1) < CIR_IOREG_LENGTH) {
 		dev_err(&pdev->dev, "Wake PNP Port not valid!\n");
-		goto failure;
+		goto exit_free_dev_rdev;
 	}
 
 	nvt->cir_addr = pnp_port_start(pdev, 0);
@@ -1027,7 +1027,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	ret = nvt_hw_detect(nvt);
 	if (ret)
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	/* Initialize CIR & CIR Wake Logical Devices */
 	nvt_efm_enable(nvt);
@@ -1070,23 +1070,23 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* now claim resources */
 	if (!request_region(nvt->cir_addr,
 			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
 			NVT_DRIVER_NAME, (void *)nvt))
-		goto failure2;
+		goto exit_release_cir_addr;
 
 	if (!request_region(nvt->cir_wake_addr,
 			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
-		goto failure3;
+		goto exit_free_irq;
 
 	if (request_irq(nvt->cir_wake_irq, nvt_cir_wake_isr, IRQF_SHARED,
 			NVT_DRIVER_NAME, (void *)nvt))
-		goto failure4;
+		goto exit_release_cir_wake_addr;
 
 	ret = rc_register_device(rdev);
 	if (ret)
-		goto failure5;
+		goto exit_free_wake_irq;
 
 	device_init_wakeup(&pdev->dev, true);
 	nvt->rdev = rdev;
@@ -1098,15 +1098,15 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	return 0;
 
-failure5:
+exit_free_wake_irq:
 	free_irq(nvt->cir_wake_irq, nvt);
-failure4:
+exit_release_cir_wake_addr:
 	release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
-failure3:
+exit_free_irq:
 	free_irq(nvt->cir_irq, nvt);
-failure2:
+exit_release_cir_addr:
 	release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
-failure:
+exit_free_dev_rdev:
 	rc_free_device(rdev);
 	kfree(nvt);
 
-- 
1.7.10

