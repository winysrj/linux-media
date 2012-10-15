Return-path: <linux-media-owner@vger.kernel.org>
Received: from 84-245-11-97.dsl.cambrium.nl ([84.245.11.97]:40503 "EHLO
	grubby.stderr.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752388Ab2JOL41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 07:56:27 -0400
From: Matthijs Kooijman <matthijs@stdin.nl>
To: linux-media@vger.kernel.org
Cc: Luis Henriques <luis.henriques@canonical.com>,
	Jarod Wilson <jarod@redhat.com>,
	Stephan Raue <stephan@openelec.tv>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthijs Kooijman <matthijs@stdin.nl>
Subject: [PATCH 1/4] [media] ene-ir: Fix cleanup on probe failure
Date: Mon, 15 Oct 2012 13:13:44 +0200
Message-Id: <1350299627-14339-1-git-send-email-matthijs@stdin.nl>
In-Reply-To: <20121015110111.GD17159@login.drsnuggles.stderr.nl>
References: <20121015110111.GD17159@login.drsnuggles.stderr.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes the cleanup on probe failure more consistent with other
drivers. This is similar to what commit
f27b853ea24a9b70585f9251384d97929e6551c3 ("[media] rc: Fix invalid
free_region and/or free_irq on probe failure") did for some other
drivers.

In addition to making the cleanup more consistent, this also fixes a
case where (on a ene_hw_detect failure) free_region would be called on a
region that was not requested yet.

This last problem was probably introduced by the moving of code in
commit b31b021988fed9e3741a46918f14ba9b063811db ("[media] ene_ir: Fix
driver initialisation") and commit
9ef449c6b31bb6a8e6dedc24de475a3b8c79be20 ("[media] rc: Postpone ISR
registration").

Signed-off-by: Matthijs Kooijman <matthijs@stdin.nl>
---
 drivers/media/rc/ene_ir.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 647dd95..62f9076 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1000,7 +1000,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
 	rdev = rc_allocate_device();
 	if (!dev || !rdev)
-		goto error1;
+		goto failure;
 
 	/* validate resources */
 	error = -ENODEV;
@@ -1011,10 +1011,10 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 
 	if (!pnp_port_valid(pnp_dev, 0) ||
 	    pnp_port_len(pnp_dev, 0) < ENE_IO_SIZE)
-		goto error;
+		goto failure;
 
 	if (!pnp_irq_valid(pnp_dev, 0))
-		goto error;
+		goto failure;
 
 	spin_lock_init(&dev->hw_lock);
 
@@ -1030,7 +1030,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	/* detect hardware version and features */
 	error = ene_hw_detect(dev);
 	if (error)
-		goto error;
+		goto failure;
 
 	if (!dev->hw_learning_and_tx_capable && txsim) {
 		dev->hw_learning_and_tx_capable = true;
@@ -1075,30 +1075,27 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	/* claim the resources */
 	error = -EBUSY;
 	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
-		dev->hw_io = -1;
-		dev->irq = -1;
-		goto error;
+		goto failure;
 	}
 
 	dev->irq = pnp_irq(pnp_dev, 0);
 	if (request_irq(dev->irq, ene_isr,
 			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev)) {
-		dev->irq = -1;
-		goto error;
+		goto failure2;
 	}
 
 	error = rc_register_device(rdev);
 	if (error < 0)
-		goto error;
+		goto failure3;
 
 	pr_notice("driver has been successfully loaded\n");
 	return 0;
-error:
-	if (dev && dev->irq >= 0)
-		free_irq(dev->irq, dev);
-	if (dev && dev->hw_io >= 0)
-		release_region(dev->hw_io, ENE_IO_SIZE);
-error1:
+
+failure3:
+	free_irq(dev->irq, dev);
+failure2:
+	release_region(dev->hw_io, ENE_IO_SIZE);
+failure:
 	rc_free_device(rdev);
 	kfree(dev);
 	return error;
-- 
1.7.10

