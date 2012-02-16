Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44225 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2BPRWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 12:22:13 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZH000W2XKYQ4@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:10 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZH00JRSXKYZO@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:10 +0000 (GMT)
Date: Thu, 16 Feb 2012 18:22:02 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/6] s5p-fimc: Convert to the device managed resources
In-reply-to: <1329412925-5872-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329412925-5872-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329412925-5872-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The devm_* functions are used in the platform device probe() for data
that is freed on driver removal. The managed device layer takes care
of undoing actions taken in the probe callback() and freeing resources
on driver detach. This eliminates the need for manually releasing
resources and simplifies error handling.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c    |   56 ++++++---------------------
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 -
 drivers/media/video/s5p-fimc/fimc-mdevice.c |    7 +--
 3 files changed, 14 insertions(+), 51 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index a6b4580..e184e65 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1678,8 +1678,6 @@ static int fimc_probe(struct platform_device *pdev)
 	struct s5p_platform_fimc *pdata;
 	int ret = 0;
 
-	dev_dbg(&pdev->dev, "%s():\n", __func__);
-
 	drv_data = (struct samsung_fimc_driverdata *)
 		platform_get_device_id(pdev)->driver_data;
 
@@ -1689,7 +1687,7 @@ static int fimc_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	fimc = kzalloc(sizeof(struct fimc_dev), GFP_KERNEL);
+	fimc = devm_kzalloc(&pdev->dev, sizeof(*fimc), GFP_KERNEL);
 	if (!fimc)
 		return -ENOMEM;
 
@@ -1700,51 +1698,35 @@ static int fimc_probe(struct platform_device *pdev)
 	pdata = pdev->dev.platform_data;
 	fimc->pdata = pdata;
 
-
 	init_waitqueue_head(&fimc->irq_queue);
 	spin_lock_init(&fimc->slock);
 	mutex_init(&fimc->lock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to find the registers\n");
-		ret = -ENOENT;
-		goto err_info;
-	}
-
-	fimc->regs_res = request_mem_region(res->start, resource_size(res),
-			dev_name(&pdev->dev));
-	if (!fimc->regs_res) {
-		dev_err(&pdev->dev, "failed to obtain register region\n");
-		ret = -ENOENT;
-		goto err_info;
-	}
-
-	fimc->regs = ioremap(res->start, resource_size(res));
-	if (!fimc->regs) {
-		dev_err(&pdev->dev, "failed to map registers\n");
-		ret = -ENXIO;
-		goto err_req_region;
+	fimc->regs = devm_request_and_ioremap(&pdev->dev, res);
+	if (fimc->regs == NULL) {
+		dev_err(&pdev->dev, "Failed to obtain io memory\n");
+		return -ENOENT;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to get IRQ resource\n");
-		ret = -ENXIO;
-		goto err_regs_unmap;
+	if (res == NULL) {
+		dev_err(&pdev->dev, "Failed to get IRQ resource\n");
+		return -ENXIO;
 	}
 	fimc->irq = res->start;
 
 	fimc->num_clocks = MAX_FIMC_CLOCKS;
 	ret = fimc_clk_get(fimc);
 	if (ret)
-		goto err_regs_unmap;
+		return ret;
 	clk_set_rate(fimc->clock[CLK_BUS], drv_data->lclk_frequency);
 	clk_enable(fimc->clock[CLK_BUS]);
 
 	platform_set_drvdata(pdev, fimc);
 
-	ret = request_irq(fimc->irq, fimc_irq_handler, 0, pdev->name, fimc);
+	ret = devm_request_irq(&pdev->dev, fimc->irq, fimc_irq_handler,
+			       0, pdev->name, fimc);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
 		goto err_clk;
@@ -1753,7 +1735,7 @@ static int fimc_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
-		goto err_irq;
+		goto err_clk;
 	/* Initialize contiguous memory allocator */
 	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(fimc->alloc_ctx)) {
@@ -1768,17 +1750,8 @@ static int fimc_probe(struct platform_device *pdev)
 
 err_pm:
 	pm_runtime_put(&pdev->dev);
-err_irq:
-	free_irq(fimc->irq, fimc);
 err_clk:
 	fimc_clk_put(fimc);
-err_regs_unmap:
-	iounmap(fimc->regs);
-err_req_region:
-	release_resource(fimc->regs_res);
-	kfree(fimc->regs_res);
-err_info:
-	kfree(fimc);
 	return ret;
 }
 
@@ -1865,11 +1838,6 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 
 	clk_disable(fimc->clock[CLK_BUS]);
 	fimc_clk_put(fimc);
-	free_irq(fimc->irq, fimc);
-	iounmap(fimc->regs);
-	release_resource(fimc->regs_res);
-	kfree(fimc->regs_res);
-	kfree(fimc);
 
 	dev_info(&pdev->dev, "driver unloaded\n");
 	return 0;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 4e20560..a18291e 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -434,7 +434,6 @@ struct fimc_ctx;
  * @num_clocks: the number of clocks managed by this device instance
  * @clock:	clocks required for FIMC operation
  * @regs:	the mapped hardware registers
- * @regs_res:	the resource claimed for IO registers
  * @irq:	FIMC interrupt number
  * @irq_queue:	interrupt handler waitqueue
  * @v4l2_dev:	root v4l2_device
@@ -454,7 +453,6 @@ struct fimc_dev {
 	u16				num_clocks;
 	struct clk			*clock[MAX_FIMC_CLOCKS];
 	void __iomem			*regs;
-	struct resource			*regs_res;
 	int				irq;
 	wait_queue_head_t		irq_queue;
 	struct v4l2_device		*v4l2_dev;
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 8ea4ee1..087ea09 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -753,7 +753,7 @@ static int __devinit fimc_md_probe(struct platform_device *pdev)
 	struct fimc_md *fmd;
 	int ret;
 
-	fmd = kzalloc(sizeof(struct fimc_md), GFP_KERNEL);
+	fmd = devm_kzalloc(&pdev->dev, sizeof(*fmd), GFP_KERNEL);
 	if (!fmd)
 		return -ENOMEM;
 
@@ -774,7 +774,7 @@ static int __devinit fimc_md_probe(struct platform_device *pdev)
 	ret = v4l2_device_register(&pdev->dev, &fmd->v4l2_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
-		goto err1;
+		return ret;
 	}
 	ret = media_device_register(&fmd->media_dev);
 	if (ret < 0) {
@@ -816,8 +816,6 @@ err3:
 	fimc_md_unregister_entities(fmd);
 err2:
 	v4l2_device_unregister(&fmd->v4l2_dev);
-err1:
-	kfree(fmd);
 	return ret;
 }
 
@@ -831,7 +829,6 @@ static int __devexit fimc_md_remove(struct platform_device *pdev)
 	fimc_md_unregister_entities(fmd);
 	media_device_unregister(&fmd->media_dev);
 	fimc_md_put_clocks(fmd);
-	kfree(fmd);
 	return 0;
 }
 
-- 
1.7.9

