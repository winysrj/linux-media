Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44084 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3LKQHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 11:07:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Josh Wu <josh.wu@atmel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v2 2/7] v4l: atmel-isi: Use devm_* managed allocators
Date: Wed, 11 Dec 2013 17:07:40 +0100
Message-Id: <1386778065-14135-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386778065-14135-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386778065-14135-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This simplifies error and cleanup code paths.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 56 +++++++++------------------
 1 file changed, 19 insertions(+), 37 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index b46c0ed..faa7f8d 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -862,7 +862,6 @@ static int atmel_isi_remove(struct platform_device *pdev)
 	struct atmel_isi *isi = container_of(soc_host,
 					struct atmel_isi, soc_host);
 
-	free_irq(isi->irq, isi);
 	soc_camera_host_unregister(soc_host);
 	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
 	dma_free_coherent(&pdev->dev,
@@ -870,12 +869,8 @@ static int atmel_isi_remove(struct platform_device *pdev)
 			isi->p_fb_descriptors,
 			isi->fb_descriptors_phys);
 
-	iounmap(isi->regs);
 	clk_unprepare(isi->mck);
-	clk_put(isi->mck);
 	clk_unprepare(isi->pclk);
-	clk_put(isi->pclk);
-	kfree(isi);
 
 	return 0;
 }
@@ -884,7 +879,6 @@ static int atmel_isi_probe(struct platform_device *pdev)
 {
 	unsigned int irq;
 	struct atmel_isi *isi;
-	struct clk *pclk;
 	struct resource *regs;
 	int ret, i;
 	struct device *dev = &pdev->dev;
@@ -898,26 +892,20 @@ static int atmel_isi_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!regs)
-		return -ENXIO;
-
-	pclk = clk_get(&pdev->dev, "isi_clk");
-	if (IS_ERR(pclk))
-		return PTR_ERR(pclk);
-
-	ret = clk_prepare(pclk);
-	if (ret)
-		goto err_clk_prepare_pclk;
-
-	isi = kzalloc(sizeof(struct atmel_isi), GFP_KERNEL);
+	isi = devm_kzalloc(&pdev->dev, sizeof(struct atmel_isi), GFP_KERNEL);
 	if (!isi) {
-		ret = -ENOMEM;
 		dev_err(&pdev->dev, "Can't allocate interface!\n");
-		goto err_alloc_isi;
+		return -ENOMEM;
 	}
 
-	isi->pclk = pclk;
+	isi->pclk = devm_clk_get(&pdev->dev, "isi_clk");
+	if (IS_ERR(isi->pclk))
+		return PTR_ERR(isi->pclk);
+
+	ret = clk_prepare(isi->pclk);
+	if (ret)
+		return ret;
+
 	isi->pdata = pdata;
 	isi->active = NULL;
 	spin_lock_init(&isi->lock);
@@ -925,11 +913,11 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&isi->dma_desc_head);
 
 	/* Get ISI_MCK, provided by programmable clock or external clock */
-	isi->mck = clk_get(dev, "isi_mck");
+	isi->mck = devm_clk_get(dev, "isi_mck");
 	if (IS_ERR(isi->mck)) {
 		dev_err(dev, "Failed to get isi_mck\n");
 		ret = PTR_ERR(isi->mck);
-		goto err_clk_get;
+		goto err_clk_get_mck;
 	}
 
 	ret = clk_prepare(isi->mck);
@@ -964,9 +952,10 @@ static int atmel_isi_probe(struct platform_device *pdev)
 		goto err_alloc_ctx;
 	}
 
-	isi->regs = ioremap(regs->start, resource_size(regs));
-	if (!isi->regs) {
-		ret = -ENOMEM;
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	isi->regs = devm_ioremap_resource(&pdev->dev, regs);
+	if (IS_ERR(isi->regs)) {
+		ret = PTR_ERR(isi->regs);
 		goto err_ioremap;
 	}
 
@@ -983,7 +972,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 		goto err_req_irq;
 	}
 
-	ret = request_irq(irq, isi_interrupt, 0, "isi", isi);
+	ret = devm_request_irq(&pdev->dev, irq, isi_interrupt, 0, "isi", isi);
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to request irq %d\n", irq);
 		goto err_req_irq;
@@ -1005,9 +994,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	return 0;
 
 err_register_soc_camera_host:
-	free_irq(isi->irq, isi);
 err_req_irq:
-	iounmap(isi->regs);
 err_ioremap:
 	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
 err_alloc_ctx:
@@ -1019,13 +1006,8 @@ err_alloc_descriptors:
 err_set_mck_rate:
 	clk_unprepare(isi->mck);
 err_clk_prepare_mck:
-	clk_put(isi->mck);
-err_clk_get:
-	kfree(isi);
-err_alloc_isi:
-	clk_unprepare(pclk);
-err_clk_prepare_pclk:
-	clk_put(pclk);
+err_clk_get_mck:
+	clk_unprepare(isi->pclk);
 
 	return ret;
 }
-- 
1.8.3.2

