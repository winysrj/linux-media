Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39067 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932402Ab2EOBgD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 21:36:03 -0400
Message-ID: <1337045760.9080.75.camel@deadeye>
Subject: [PATCH] [media] rc: Fix invalid free_region and/or free_irq on
 probe failure
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Date: Tue, 15 May 2012 02:36:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fintek-cir, ite-cir and nuvoton-cir may try to free an I/O region
and/or IRQ handler that was never allocated after a failure in their
respective probe functions.  Add and use separate labels on the
failure path so they will do the right cleanup after each possible
point of failure.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/rc/fintek-cir.c  |   13 ++++++-------
 drivers/media/rc/ite-cir.c     |   14 ++++++--------
 drivers/media/rc/nuvoton-cir.c |   26 ++++++++++++--------------
 3 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 4a3a238..6aabf7a 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -556,11 +556,11 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 
 	if (request_irq(fintek->cir_irq, fintek_cir_isr, IRQF_SHARED,
 			FINTEK_DRIVER_NAME, (void *)fintek))
-		goto failure;
+		goto failure2;
 
 	ret = rc_register_device(rdev);
 	if (ret)
-		goto failure;
+		goto failure3;
 
 	device_init_wakeup(&pdev->dev, true);
 	fintek->rdev = rdev;
@@ -570,12 +570,11 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 
 	return 0;
 
+failure3:
+	free_irq(fintek->cir_irq, fintek);
+failure2:
+	release_region(fintek->cir_addr, fintek->cir_port_len);
 failure:
-	if (fintek->cir_irq)
-		free_irq(fintek->cir_irq, fintek);
-	if (fintek->cir_addr)
-		release_region(fintek->cir_addr, fintek->cir_port_len);
-
 	rc_free_device(rdev);
 	kfree(fintek);
 
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 0e49c99..36fe5a3 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1598,24 +1598,22 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 
 	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
 			ITE_DRIVER_NAME, (void *)itdev))
-		goto failure;
+		goto failure2;
 
 	ret = rc_register_device(rdev);
 	if (ret)
-		goto failure;
+		goto failure3;
 
 	itdev->rdev = rdev;
 	ite_pr(KERN_NOTICE, "driver has been successfully loaded\n");
 
 	return 0;
 
+failure3:
+	free_irq(itdev->cir_irq, itdev);
+failure2:
+	release_region(itdev->cir_addr, itdev->params.io_region_size);
 failure:
-	if (itdev->cir_irq)
-		free_irq(itdev->cir_irq, itdev);
-
-	if (itdev->cir_addr)
-		release_region(itdev->cir_addr, itdev->params.io_region_size);
-
 	rc_free_device(rdev);
 	kfree(itdev);
 
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 8b2c071..dc8a7dd 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1075,19 +1075,19 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
 			NVT_DRIVER_NAME, (void *)nvt))
-		goto failure;
+		goto failure2;
 
 	if (!request_region(nvt->cir_wake_addr,
 			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
-		goto failure;
+		goto failure3;
 
 	if (request_irq(nvt->cir_wake_irq, nvt_cir_wake_isr, IRQF_SHARED,
 			NVT_DRIVER_NAME, (void *)nvt))
-		goto failure;
+		goto failure4;
 
 	ret = rc_register_device(rdev);
 	if (ret)
-		goto failure;
+		goto failure5;
 
 	device_init_wakeup(&pdev->dev, true);
 	nvt->rdev = rdev;
@@ -1099,17 +1099,15 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	return 0;
 
+failure5:
+	free_irq(nvt->cir_wake_irq, nvt);
+failure4:
+	release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
+failure3:
+	free_irq(nvt->cir_irq, nvt);
+failure2:
+	release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
 failure:
-	if (nvt->cir_irq)
-		free_irq(nvt->cir_irq, nvt);
-	if (nvt->cir_addr)
-		release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
-
-	if (nvt->cir_wake_irq)
-		free_irq(nvt->cir_wake_irq, nvt);
-	if (nvt->cir_wake_addr)
-		release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
-
 	rc_free_device(rdev);
 	kfree(nvt);
 
-- 
1.7.10


