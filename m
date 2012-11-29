Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:53894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2K2JjB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 04:39:01 -0500
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id DD96F40B98
	for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 10:38:59 +0100 (CET)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Te0aB-0006l8-Hy
	for linux-media@vger.kernel.org; Thu, 29 Nov 2012 10:38:59 +0100
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] media: sh_mobile_ceu_camera: use managed memory and resource allocations
Date: Thu, 29 Nov 2012 10:38:59 +0100
Message-Id: <1354181939-25952-2-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1354181939-25952-1-git-send-email-g.liakhovetski@gmx.de>
References: <1354181939-25952-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use managed allocations to simplify error handling and clean up paths.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   32 +++++--------------
 1 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index bf66cb4..27eeca1 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -2088,15 +2088,13 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 	irq = platform_get_irq(pdev, 0);
 	if (!res || (int)irq <= 0) {
 		dev_err(&pdev->dev, "Not enough CEU platform resources.\n");
-		err = -ENODEV;
-		goto exit;
+		return -ENODEV;
 	}
 
-	pcdev = kzalloc(sizeof(*pcdev), GFP_KERNEL);
+	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
 	if (!pcdev) {
 		dev_err(&pdev->dev, "Could not allocate pcdev\n");
-		err = -ENOMEM;
-		goto exit;
+		return -ENOMEM;
 	}
 
 	INIT_LIST_HEAD(&pcdev->capture);
@@ -2105,19 +2103,17 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 
 	pcdev->pdata = pdev->dev.platform_data;
 	if (!pcdev->pdata) {
-		err = -EINVAL;
 		dev_err(&pdev->dev, "CEU platform data not set.\n");
-		goto exit_kfree;
+		return -EINVAL;
 	}
 
 	pcdev->max_width = pcdev->pdata->max_width ? : 2560;
 	pcdev->max_height = pcdev->pdata->max_height ? : 1920;
 
-	base = ioremap_nocache(res->start, resource_size(res));
+	base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!base) {
-		err = -ENXIO;
 		dev_err(&pdev->dev, "Unable to ioremap CEU registers.\n");
-		goto exit_kfree;
+		return -ENXIO;
 	}
 
 	pcdev->irq = irq;
@@ -2133,16 +2129,15 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 						  DMA_MEMORY_EXCLUSIVE);
 		if (!err) {
 			dev_err(&pdev->dev, "Unable to declare CEU memory.\n");
-			err = -ENXIO;
-			goto exit_iounmap;
+			return -ENXIO;
 		}
 
 		pcdev->video_limit = resource_size(res);
 	}
 
 	/* request irq */
-	err = request_irq(pcdev->irq, sh_mobile_ceu_irq, IRQF_DISABLED,
-			  dev_name(&pdev->dev), pcdev);
+	err = devm_request_irq(&pdev->dev, pcdev->irq, sh_mobile_ceu_irq,
+			       IRQF_DISABLED, dev_name(&pdev->dev), pcdev);
 	if (err) {
 		dev_err(&pdev->dev, "Unable to register CEU interrupt.\n");
 		goto exit_release_mem;
@@ -2246,15 +2241,9 @@ exit_free_ctx:
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 exit_free_clk:
 	pm_runtime_disable(&pdev->dev);
-	free_irq(pcdev->irq, pcdev);
 exit_release_mem:
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
 		dma_release_declared_memory(&pdev->dev);
-exit_iounmap:
-	iounmap(base);
-exit_kfree:
-	kfree(pcdev);
-exit:
 	return err;
 }
 
@@ -2267,10 +2256,8 @@ static int __devexit sh_mobile_ceu_remove(struct platform_device *pdev)
 
 	soc_camera_host_unregister(soc_host);
 	pm_runtime_disable(&pdev->dev);
-	free_irq(pcdev->irq, pcdev);
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
 		dma_release_declared_memory(&pdev->dev);
-	iounmap(pcdev->base);
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	if (csi2_pdev && csi2_pdev->dev.driver) {
 		struct module *csi2_drv = csi2_pdev->dev.driver->owner;
@@ -2279,7 +2266,6 @@ static int __devexit sh_mobile_ceu_remove(struct platform_device *pdev)
 		platform_device_put(csi2_pdev);
 		module_put(csi2_drv);
 	}
-	kfree(pcdev);
 
 	return 0;
 }
-- 
1.7.2.5

