Return-path: <linux-media-owner@vger.kernel.org>
Received: from 84-245-11-97.dsl.cambrium.nl ([84.245.11.97]:40500 "EHLO
	grubby.stderr.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752286Ab2JOL4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 07:56:21 -0400
From: Matthijs Kooijman <matthijs@stdin.nl>
To: linux-media@vger.kernel.org
Cc: Luis Henriques <luis.henriques@canonical.com>,
	Jarod Wilson <jarod@redhat.com>,
	Stephan Raue <stephan@openelec.tv>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthijs Kooijman <matthijs@stdin.nl>
Subject: [PATCH 2/4] [media] rc: Make probe cleanup goto labels more verbose
Date: Mon, 15 Oct 2012 13:13:45 +0200
Message-Id: <1350299627-14339-2-git-send-email-matthijs@stdin.nl>
In-Reply-To: <1350299627-14339-1-git-send-email-matthijs@stdin.nl>
References: <20121015110111.GD17159@login.drsnuggles.stderr.nl>
 <1350299627-14339-1-git-send-email-matthijs@stdin.nl>
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
---
 drivers/media/rc/ati_remote.c   |   27 ++++++++++++++++-----------
 drivers/media/rc/ene_ir.c       |   20 ++++++++++----------
 drivers/media/rc/fintek-cir.c   |   20 ++++++++++----------
 drivers/media/rc/gpio-ir-recv.c |   19 +++++++++----------
 drivers/media/rc/ite-cir.c      |   18 +++++++++---------
 drivers/media/rc/nuvoton-cir.c  |   30 +++++++++++++++---------------
 6 files changed, 69 insertions(+), 65 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 8fa72e2..58fce6a 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -877,11 +877,11 @@ static int ati_remote_probe(struct usb_interface *interface,
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
@@ -929,12 +929,12 @@ static int ati_remote_probe(struct usb_interface *interface,
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
@@ -943,26 +943,31 @@ static int ati_remote_probe(struct usb_interface *interface,
 	if (mouse) {
 		input_dev = input_allocate_device();
 		if (!input_dev)
-			goto fail4;
+			goto exit_unregister_device;
 
 		ati_remote->idev = input_dev;
 		ati_remote_input_init(ati_remote);
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
index 62f9076..7337816 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1000,7 +1000,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
 	rdev = rc_allocate_device();
 	if (!dev || !rdev)
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	/* validate resources */
 	error = -ENODEV;
@@ -1011,10 +1011,10 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 
 	if (!pnp_port_valid(pnp_dev, 0) ||
 	    pnp_port_len(pnp_dev, 0) < ENE_IO_SIZE)
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	if (!pnp_irq_valid(pnp_dev, 0))
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	spin_lock_init(&dev->hw_lock);
 
@@ -1030,7 +1030,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	/* detect hardware version and features */
 	error = ene_hw_detect(dev);
 	if (error)
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	if (!dev->hw_learning_and_tx_capable && txsim) {
 		dev->hw_learning_and_tx_capable = true;
@@ -1075,27 +1075,27 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
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
index ab30c64..8284d28 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -495,18 +495,18 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
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
@@ -523,7 +523,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 
 	ret = fintek_hw_detect(fintek);
 	if (ret)
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	/* Initialize CIR & CIR Wake Logical Devices */
 	fintek_config_mode_enable(fintek);
@@ -556,15 +556,15 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
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
@@ -574,11 +574,11 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 
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
index 04cb272..0c03b7d 100644
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
index 36fe5a3..77cb21f 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1472,7 +1472,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	/* input device for IR remote (and tx) */
 	rdev = rc_allocate_device();
 	if (!rdev)
-		goto failure;
+		goto exit_free_dev_rdev;
 
 	ret = -ENODEV;
 
@@ -1497,12 +1497,12 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
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
@@ -1594,26 +1594,26 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
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
 
 	itdev->rdev = rdev;
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
index 699eef3..8ab6843 100644
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

