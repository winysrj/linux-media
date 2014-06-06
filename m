Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42319 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaFFPVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 11:21:22 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.142.25])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id E45B2363DF
	for <linux-media@vger.kernel.org>; Fri,  6 Jun 2014 17:20:53 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] v4l: omap4iss: Use the devm_* managed allocators
Date: Fri,  6 Jun 2014 17:21:44 +0200
Message-Id: <1402068106-32677-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1402068106-32677-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1402068106-32677-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This simplifies remove and error code paths.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c | 84 ++++--------------------------------
 1 file changed, 8 insertions(+), 76 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 4a9e444..d548371 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1003,32 +1003,17 @@ static void iss_disable_clocks(struct iss_device *iss)
 	clk_disable(iss->iss_fck);
 }
 
-static void iss_put_clocks(struct iss_device *iss)
-{
-	if (iss->iss_fck) {
-		clk_put(iss->iss_fck);
-		iss->iss_fck = NULL;
-	}
-
-	if (iss->iss_ctrlclk) {
-		clk_put(iss->iss_ctrlclk);
-		iss->iss_ctrlclk = NULL;
-	}
-}
-
 static int iss_get_clocks(struct iss_device *iss)
 {
-	iss->iss_fck = clk_get(iss->dev, "iss_fck");
+	iss->iss_fck = devm_clk_get(iss->dev, "iss_fck");
 	if (IS_ERR(iss->iss_fck)) {
 		dev_err(iss->dev, "Unable to get iss_fck clock info\n");
-		iss_put_clocks(iss);
 		return PTR_ERR(iss->iss_fck);
 	}
 
-	iss->iss_ctrlclk = clk_get(iss->dev, "iss_ctrlclk");
+	iss->iss_ctrlclk = devm_clk_get(iss->dev, "iss_ctrlclk");
 	if (IS_ERR(iss->iss_ctrlclk)) {
 		dev_err(iss->dev, "Unable to get iss_ctrlclk clock info\n");
-		iss_put_clocks(iss);
 		return PTR_ERR(iss->iss_ctrlclk);
 	}
 
@@ -1104,29 +1089,11 @@ static int iss_map_mem_resource(struct platform_device *pdev,
 {
 	struct resource *mem;
 
-	/* request the mem region for the camera registers */
-
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, res);
-	if (!mem) {
-		dev_err(iss->dev, "no mem resource?\n");
-		return -ENODEV;
-	}
-
-	if (!request_mem_region(mem->start, resource_size(mem), pdev->name)) {
-		dev_err(iss->dev,
-			"cannot reserve camera register I/O region\n");
-		return -ENODEV;
-	}
-	iss->res[res] = mem;
 
-	/* map the region */
-	iss->regs[res] = ioremap_nocache(mem->start, resource_size(mem));
-	if (!iss->regs[res]) {
-		dev_err(iss->dev, "cannot map camera register I/O region\n");
-		return -ENODEV;
-	}
+	iss->regs[res] = devm_ioremap_resource(iss->dev, mem);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(iss->regs[res]);
 }
 
 static void iss_unregister_entities(struct iss_device *iss)
@@ -1389,7 +1356,7 @@ static int iss_probe(struct platform_device *pdev)
 	if (pdata == NULL)
 		return -EINVAL;
 
-	iss = kzalloc(sizeof(*iss), GFP_KERNEL);
+	iss = devm_kzalloc(&pdev->dev, sizeof(*iss), GFP_KERNEL);
 	if (!iss) {
 		dev_err(&pdev->dev, "Could not allocate memory\n");
 		return -ENOMEM;
@@ -1456,7 +1423,8 @@ static int iss_probe(struct platform_device *pdev)
 		goto error_iss;
 	}
 
-	if (request_irq(iss->irq_num, iss_isr, IRQF_SHARED, "OMAP4 ISS", iss)) {
+	if (devm_request_irq(iss->dev, iss->irq_num, iss_isr, IRQF_SHARED,
+			     "OMAP4 ISS", iss)) {
 		dev_err(iss->dev, "Unable to request IRQ\n");
 		ret = -EINVAL;
 		goto error_iss;
@@ -1465,7 +1433,7 @@ static int iss_probe(struct platform_device *pdev)
 	/* Entities */
 	ret = iss_initialize_modules(iss);
 	if (ret < 0)
-		goto error_irq;
+		goto error_iss;
 
 	ret = iss_register_entities(iss);
 	if (ret < 0)
@@ -1477,29 +1445,12 @@ static int iss_probe(struct platform_device *pdev)
 
 error_modules:
 	iss_cleanup_modules(iss);
-error_irq:
-	free_irq(iss->irq_num, iss);
 error_iss:
 	omap4iss_put(iss);
 error:
-	iss_put_clocks(iss);
-
-	for (i = 0; i < OMAP4_ISS_MEM_LAST; i++) {
-		if (iss->regs[i]) {
-			iounmap(iss->regs[i]);
-			iss->regs[i] = NULL;
-		}
-
-		if (iss->res[i]) {
-			release_mem_region(iss->res[i]->start,
-					   resource_size(iss->res[i]));
-			iss->res[i] = NULL;
-		}
-	}
 	platform_set_drvdata(pdev, NULL);
 
 	mutex_destroy(&iss->iss_mutex);
-	kfree(iss);
 
 	return ret;
 }
@@ -1507,29 +1458,10 @@ error:
 static int iss_remove(struct platform_device *pdev)
 {
 	struct iss_device *iss = platform_get_drvdata(pdev);
-	unsigned int i;
 
 	iss_unregister_entities(iss);
 	iss_cleanup_modules(iss);
 
-	free_irq(iss->irq_num, iss);
-	iss_put_clocks(iss);
-
-	for (i = 0; i < OMAP4_ISS_MEM_LAST; i++) {
-		if (iss->regs[i]) {
-			iounmap(iss->regs[i]);
-			iss->regs[i] = NULL;
-		}
-
-		if (iss->res[i]) {
-			release_mem_region(iss->res[i]->start,
-					   resource_size(iss->res[i]));
-			iss->res[i] = NULL;
-		}
-	}
-
-	kfree(iss);
-
 	return 0;
 }
 
-- 
1.8.5.5

