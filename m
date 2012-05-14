Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33313 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab2ENJl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 05:41:26 -0400
Received: by dady13 with SMTP id y13so5694411dad.19
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 02:41:26 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, k.debski@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] s5p-g2d: Use devm_* functions in g2d.c file
Date: Mon, 14 May 2012 15:01:24 +0530
Message-Id: <1336987884-23665-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_* functions are device managed functions and make error handling
and cleanup simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-g2d/g2d.c |   47 ++++++++----------------------------
 drivers/media/video/s5p-g2d/g2d.h |    1 -
 2 files changed, 11 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index 789de74..5a11d37 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -674,42 +674,27 @@ static int g2d_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret = 0;
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
+
 	spin_lock_init(&dev->ctrl_lock);
 	mutex_init(&dev->mutex);
 	atomic_set(&dev->num_inst, 0);
 	init_waitqueue_head(&dev->irq_queue);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to find registers\n");
-		ret = -ENOENT;
-		goto free_dev;
-	}
 
-	dev->res_regs = request_mem_region(res->start, resource_size(res),
-						dev_name(&pdev->dev));
-
-	if (!dev->res_regs) {
-		dev_err(&pdev->dev, "failed to obtain register region\n");
-		ret = -ENOENT;
-		goto free_dev;
-	}
-
-	dev->regs = ioremap(res->start, resource_size(res));
-	if (!dev->regs) {
-		dev_err(&pdev->dev, "failed to map registers\n");
-		ret = -ENOENT;
-		goto rel_res_regs;
+	dev->regs = devm_request_and_ioremap(&pdev->dev, res);
+	if (dev->regs == NULL) {
+			dev_err(&pdev->dev, "Failed to obtain io memory\n");
+			return -ENOENT;
 	}
 
 	dev->clk = clk_get(&pdev->dev, "sclk_fimg2d");
 	if (IS_ERR_OR_NULL(dev->clk)) {
 		dev_err(&pdev->dev, "failed to get g2d clock\n");
-		ret = -ENXIO;
-		goto unmap_regs;
+		return -ENXIO;
 	}
 
 	ret = clk_prepare(dev->clk);
@@ -740,7 +725,8 @@ static int g2d_probe(struct platform_device *pdev)
 
 	dev->irq = res->start;
 
-	ret = request_irq(dev->irq, g2d_isr, 0, pdev->name, dev);
+	ret = devm_request_irq(&pdev->dev, dev->irq, g2d_isr,
+						0, pdev->name, dev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to install IRQ\n");
 		goto put_clk_gate;
@@ -749,7 +735,7 @@ static int g2d_probe(struct platform_device *pdev)
 	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(dev->alloc_ctx)) {
 		ret = PTR_ERR(dev->alloc_ctx);
-		goto rel_irq;
+		goto unprep_clk_gate;
 	}
 
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
@@ -793,8 +779,6 @@ unreg_v4l2_dev:
 	v4l2_device_unregister(&dev->v4l2_dev);
 alloc_ctx_cleanup:
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
-rel_irq:
-	free_irq(dev->irq, dev);
 unprep_clk_gate:
 	clk_unprepare(dev->gate);
 put_clk_gate:
@@ -803,12 +787,7 @@ unprep_clk:
 	clk_unprepare(dev->clk);
 put_clk:
 	clk_put(dev->clk);
-unmap_regs:
-	iounmap(dev->regs);
-rel_res_regs:
-	release_resource(dev->res_regs);
-free_dev:
-	kfree(dev);
+
 	return ret;
 }
 
@@ -821,14 +800,10 @@ static int g2d_remove(struct platform_device *pdev)
 	video_unregister_device(dev->vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
-	free_irq(dev->irq, dev);
 	clk_unprepare(dev->gate);
 	clk_put(dev->gate);
 	clk_unprepare(dev->clk);
 	clk_put(dev->clk);
-	iounmap(dev->regs);
-	release_resource(dev->res_regs);
-	kfree(dev);
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-g2d/g2d.h b/drivers/media/video/s5p-g2d/g2d.h
index 1b82065..6b765b0 100644
--- a/drivers/media/video/s5p-g2d/g2d.h
+++ b/drivers/media/video/s5p-g2d/g2d.h
@@ -23,7 +23,6 @@ struct g2d_dev {
 	spinlock_t		ctrl_lock;
 	atomic_t		num_inst;
 	struct vb2_alloc_ctx	*alloc_ctx;
-	struct resource		*res_regs;
 	void __iomem		*regs;
 	struct clk		*clk;
 	struct clk		*gate;
-- 
1.7.4.1

