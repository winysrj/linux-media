Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62074 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab2ENLca (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 07:32:30 -0400
Received: by dady13 with SMTP id y13so5800649dad.19
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 04:32:29 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, k.debski@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] s5p-mfc: Use devm_* functions in s5p_mfc.c file
Date: Mon, 14 May 2012 16:52:27 +0530
Message-Id: <1336994547-30081-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_* functions are device managed functions and make error handling
and cleanup simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-mfc/s5p_mfc.c        |   63 ++++++--------------------
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |    2 -
 2 files changed, 14 insertions(+), 51 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index 83fe461..3302d45 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -948,7 +948,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	int ret;
 
 	pr_debug("%s++\n", __func__);
-	dev = kzalloc(sizeof *dev, GFP_KERNEL);
+	dev = devm_kzalloc(&pdev->dev, sizeof *dev, GFP_KERNEL);
 	if (!dev) {
 		dev_err(&pdev->dev, "Not enough memory for MFC device\n");
 		return -ENOMEM;
@@ -959,49 +959,35 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	dev->plat_dev = pdev;
 	if (!dev->plat_dev) {
 		dev_err(&pdev->dev, "No platform data specified\n");
-		ret = -ENODEV;
-		goto err_dev;
+		return -ENODEV;
 	}
 
 	ret = s5p_mfc_init_pm(dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to get mfc clock source\n");
-		goto err_clk;
+		return ret;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "failed to get memory region resource\n");
-		ret = -ENOENT;
-		goto err_res;
-	}
 
-	dev->mfc_mem = request_mem_region(res->start, resource_size(res),
-					  pdev->name);
-	if (dev->mfc_mem == NULL) {
-		dev_err(&pdev->dev, "failed to get memory region\n");
-		ret = -ENOENT;
-		goto err_mem_reg;
-	}
-	dev->regs_base = ioremap(dev->mfc_mem->start, resource_size(dev->mfc_mem));
+	dev->regs_base = devm_request_and_ioremap(&pdev->dev, res);
 	if (dev->regs_base == NULL) {
-		dev_err(&pdev->dev, "failed to ioremap address region\n");
-		ret = -ENOENT;
-		goto err_ioremap;
+		dev_err(&pdev->dev, "Failed to obtain io memory\n");
+		return -ENOENT;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "failed to get irq resource\n");
 		ret = -ENOENT;
-		goto err_get_res;
+		goto err_res;
 	}
 	dev->irq = res->start;
-	ret = request_irq(dev->irq, s5p_mfc_irq, IRQF_DISABLED, pdev->name,
-									dev);
+	ret = devm_request_irq(&pdev->dev, dev->irq, s5p_mfc_irq,
+					IRQF_DISABLED, pdev->name, dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to install irq (%d)\n", ret);
-		goto err_req_irq;
+		goto err_res;
 	}
 
 	dev->mem_dev_l = device_find_child(&dev->plat_dev->dev, "s5p-mfc-l",
@@ -1009,20 +995,20 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	if (!dev->mem_dev_l) {
 		mfc_err("Mem child (L) device get failed\n");
 		ret = -ENODEV;
-		goto err_find_child;
+		goto err_res;
 	}
 	dev->mem_dev_r = device_find_child(&dev->plat_dev->dev, "s5p-mfc-r",
 					   match_child);
 	if (!dev->mem_dev_r) {
 		mfc_err("Mem child (R) device get failed\n");
 		ret = -ENODEV;
-		goto err_find_child;
+		goto err_res;
 	}
 
 	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
 	if (IS_ERR_OR_NULL(dev->alloc_ctx[0])) {
 		ret = PTR_ERR(dev->alloc_ctx[0]);
-		goto err_mem_init_ctx_0;
+		goto err_res;
 	}
 	dev->alloc_ctx[1] = vb2_dma_contig_init_ctx(dev->mem_dev_r);
 	if (IS_ERR_OR_NULL(dev->alloc_ctx[1])) {
@@ -1110,22 +1096,9 @@ err_v4l2_dev_reg:
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
 err_mem_init_ctx_1:
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
-err_mem_init_ctx_0:
-err_find_child:
-	free_irq(dev->irq, dev);
-err_req_irq:
-err_get_res:
-	iounmap(dev->regs_base);
-	dev->regs_base = NULL;
-err_ioremap:
-	release_resource(dev->mfc_mem);
-	kfree(dev->mfc_mem);
-err_mem_reg:
 err_res:
 	s5p_mfc_final_pm(dev);
-err_clk:
-err_dev:
-	kfree(dev);
+
 	pr_debug("%s-- with error\n", __func__);
 	return ret;
 
@@ -1148,15 +1121,7 @@ static int __devexit s5p_mfc_remove(struct platform_device *pdev)
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
 
-	free_irq(dev->irq, dev);
-	iounmap(dev->regs_base);
-	if (dev->mfc_mem) {
-		release_resource(dev->mfc_mem);
-		kfree(dev->mfc_mem);
-		dev->mfc_mem = NULL;
-	}
 	s5p_mfc_final_pm(dev);
-	kfree(dev);
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
index 91146fa..bd5706a 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
@@ -185,7 +185,6 @@ struct s5p_mfc_pm {
  * @mem_dev_r:		child device of the right memory bank (1)
  * @regs_base:		base address of the MFC hw registers
  * @irq:		irq resource
- * @mfc_mem:		MFC registers memory resource
  * @dec_ctrl_handler:	control framework handler for decoding
  * @enc_ctrl_handler:	control framework handler for encoding
  * @pm:			power management control
@@ -221,7 +220,6 @@ struct s5p_mfc_dev {
 	struct device		*mem_dev_r;
 	void __iomem		*regs_base;
 	int			irq;
-	struct resource		*mfc_mem;
 	struct v4l2_ctrl_handler dec_ctrl_handler;
 	struct v4l2_ctrl_handler enc_ctrl_handler;
 	struct s5p_mfc_pm	pm;
-- 
1.7.4.1

