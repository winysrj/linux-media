Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54960 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819Ab0HLHqi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 03:46:38 -0400
Date: Thu, 12 Aug 2010 09:46:11 +0200
From: Dan Carpenter <error27@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] IR: ene_ir: problems in unwinding on probe
Message-ID: <20100812074611.GI645@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

There were a couple issues here.  If the allocation failed for "dev"
then it would lead to a NULL dereference.  If request_irq() or
request_region() failed it would release the irq and the region even
though they were not successfully aquired.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
index 5447750..8e5e964 100644
--- a/drivers/media/IR/ene_ir.c
+++ b/drivers/media/IR/ene_ir.c
@@ -781,21 +781,24 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 
 	/* allocate memory */
 	input_dev = input_allocate_device();
+	if (!input_dev)
+		goto err_out;
 	ir_props = kzalloc(sizeof(struct ir_dev_props), GFP_KERNEL);
+	if (!ir_props)
+		goto err_input_dev;
 	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
-
-	if (!input_dev || !ir_props || !dev)
-		goto error;
+	if (!dev)
+		goto err_ir_props;
 
 	/* validate resources */
 	error = -ENODEV;
 
 	if (!pnp_port_valid(pnp_dev, 0) ||
 	    pnp_port_len(pnp_dev, 0) < ENE_MAX_IO)
-		goto error;
+		goto err_dev;
 
 	if (!pnp_irq_valid(pnp_dev, 0))
-		goto error;
+		goto err_dev;
 
 	dev->hw_io = pnp_port_start(pnp_dev, 0);
 	dev->irq = pnp_irq(pnp_dev, 0);
@@ -804,11 +807,11 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	/* claim the resources */
 	error = -EBUSY;
 	if (!request_region(dev->hw_io, ENE_MAX_IO, ENE_DRIVER_NAME))
-		goto error;
+		goto err_dev;
 
 	if (request_irq(dev->irq, ene_isr,
 			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev))
-		goto error;
+		goto err_region;
 
 	pnp_set_drvdata(pnp_dev, dev);
 	dev->pnp_dev = pnp_dev;
@@ -816,7 +819,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	/* detect hardware version and features */
 	error = ene_hw_detect(dev);
 	if (error)
-		goto error;
+		goto err_irq;
 
 	ene_setup_settings(dev);
 
@@ -889,20 +892,22 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	error = -ENODEV;
 	if (ir_input_register(input_dev, RC_MAP_RC6_MCE, ir_props,
 							ENE_DRIVER_NAME))
-		goto error;
-
+		goto err_irq;
 
 	ene_printk(KERN_NOTICE, "driver has been succesfully loaded\n");
 	return 0;
-error:
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-	if (dev->hw_io)
-		release_region(dev->hw_io, ENE_MAX_IO);
 
-	input_free_device(input_dev);
-	kfree(ir_props);
+err_irq:
+	free_irq(dev->irq, dev);
+err_region:
+	release_region(dev->hw_io, ENE_MAX_IO);
+err_dev:
 	kfree(dev);
+err_ir_props:
+	kfree(ir_props);
+err_input_dev:
+	input_free_device(input_dev);
+err_out:
 	return error;
 }
 
