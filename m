Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28462 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2BPRWO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 12:22:14 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LZH007JDXKZXR80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:11 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZH008JHXKYX9@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:11 +0000 (GMT)
Date: Thu, 16 Feb 2012 18:22:05 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 6/6] s5p-csis: Convert to the device managed resources
In-reply-to: <1329412925-5872-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329412925-5872-7-git-send-email-s.nawrocki@samsung.com>
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
 drivers/media/video/s5p-fimc/mipi-csis.c |   81 +++++++++---------------------
 1 files changed, 24 insertions(+), 57 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index 58c4075..a903138 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -1,8 +1,8 @@
 /*
  * Samsung S5P/EXYNOS4 SoC series MIPI-CSI receiver driver
  *
- * Copyright (C) 2011 Samsung Electronics Co., Ltd.
- * Contact: Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ * Copyright (C) 2011 - 2012 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki, <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -100,7 +100,6 @@ enum {
  * @pads: CSIS pads array
  * @sd: v4l2_subdev associated with CSIS device instance
  * @pdev: CSIS platform device
- * @regs_res: requested I/O register memory resource
  * @regs: mmaped I/O registers memory
  * @clock: CSIS clocks
  * @irq: requested s5p-mipi-csis irq number
@@ -113,7 +112,6 @@ struct csis_state {
 	struct media_pad pads[CSIS_PADS_NUM];
 	struct v4l2_subdev sd;
 	struct platform_device *pdev;
-	struct resource *regs_res;
 	void __iomem *regs;
 	struct regulator_bulk_data supplies[CSIS_NUM_SUPPLIES];
 	struct clk *clock[NUM_CSIS_CLOCKS];
@@ -490,12 +488,11 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 {
 	struct s5p_platform_mipi_csis *pdata;
 	struct resource *mem_res;
-	struct resource *regs_res;
 	struct csis_state *state;
 	int ret = -ENOMEM;
 	int i;
 
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	state = devm_kzalloc(&pdev->dev, sizeof(*state), GFP_KERNEL);
 	if (!state)
 		return -ENOMEM;
 
@@ -505,52 +502,27 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	pdata = pdev->dev.platform_data;
 	if (pdata == NULL || pdata->phy_enable == NULL) {
 		dev_err(&pdev->dev, "Platform data not fully specified\n");
-		goto e_free;
+		return -EINVAL;
 	}
 
 	if ((pdev->id == 1 && pdata->lanes > CSIS1_MAX_LANES) ||
 	    pdata->lanes > CSIS0_MAX_LANES) {
-		ret = -EINVAL;
 		dev_err(&pdev->dev, "Unsupported number of data lanes: %d\n",
 			pdata->lanes);
-		goto e_free;
+		return -EINVAL;
 	}
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem_res) {
-		dev_err(&pdev->dev, "Failed to get IO memory region\n");
-		goto e_free;
-	}
-
-	regs_res = request_mem_region(mem_res->start, resource_size(mem_res),
-				      pdev->name);
-	if (!regs_res) {
-		dev_err(&pdev->dev, "Failed to request IO memory region\n");
-		goto e_free;
+	state->regs = devm_request_and_ioremap(&pdev->dev, mem_res);
+	if (state->regs == NULL) {
+		dev_err(&pdev->dev, "Failed to request and remap io memory\n");
+		return -ENXIO;
 	}
-	state->regs_res = regs_res;
-
-	state->regs = ioremap(mem_res->start, resource_size(mem_res));
-	if (!state->regs) {
-		dev_err(&pdev->dev, "Failed to remap IO region\n");
-		goto e_reqmem;
-	}
-
-	ret = s5pcsis_clk_get(state);
-	if (ret)
-		goto e_unmap;
-
-	clk_enable(state->clock[CSIS_CLK_MUX]);
-	if (pdata->clk_rate)
-		clk_set_rate(state->clock[CSIS_CLK_MUX], pdata->clk_rate);
-	else
-		dev_WARN(&pdev->dev, "No clock frequency specified!\n");
 
 	state->irq = platform_get_irq(pdev, 0);
 	if (state->irq < 0) {
-		ret = state->irq;
 		dev_err(&pdev->dev, "Failed to get irq\n");
-		goto e_clkput;
+		return state->irq;
 	}
 
 	for (i = 0; i < CSIS_NUM_SUPPLIES; i++)
@@ -559,12 +531,22 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	ret = regulator_bulk_get(&pdev->dev, CSIS_NUM_SUPPLIES,
 				 state->supplies);
 	if (ret)
+		return ret;
+
+	ret = s5pcsis_clk_get(state);
+	if (ret)
 		goto e_clkput;
 
-	ret = request_irq(state->irq, s5pcsis_irq_handler, 0,
-			  dev_name(&pdev->dev), state);
+	clk_enable(state->clock[CSIS_CLK_MUX]);
+	if (pdata->clk_rate)
+		clk_set_rate(state->clock[CSIS_CLK_MUX], pdata->clk_rate);
+	else
+		dev_WARN(&pdev->dev, "No clock frequency specified!\n");
+
+	ret = devm_request_irq(&pdev->dev, state->irq, s5pcsis_irq_handler,
+			       0, dev_name(&pdev->dev), state);
 	if (ret) {
-		dev_err(&pdev->dev, "request_irq failed\n");
+		dev_err(&pdev->dev, "Interrupt request failed\n");
 		goto e_regput;
 	}
 
@@ -583,7 +565,7 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	ret = media_entity_init(&state->sd.entity,
 				CSIS_PADS_NUM, state->pads, 0);
 	if (ret < 0)
-		goto e_irqfree;
+		goto e_clkput;
 
 	/* This allows to retrieve the platform device id by the host driver */
 	v4l2_set_subdevdata(&state->sd, pdev);
@@ -592,22 +574,13 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, &state->sd);
 
 	pm_runtime_enable(&pdev->dev);
-
 	return 0;
 
-e_irqfree:
-	free_irq(state->irq, state);
 e_regput:
 	regulator_bulk_free(CSIS_NUM_SUPPLIES, state->supplies);
 e_clkput:
 	clk_disable(state->clock[CSIS_CLK_MUX]);
 	s5pcsis_clk_put(state);
-e_unmap:
-	iounmap(state->regs);
-e_reqmem:
-	release_mem_region(regs_res->start, resource_size(regs_res));
-e_free:
-	kfree(state);
 	return ret;
 }
 
@@ -709,21 +682,15 @@ static int __devexit s5pcsis_remove(struct platform_device *pdev)
 {
 	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
 	struct csis_state *state = sd_to_csis_state(sd);
-	struct resource *res = state->regs_res;
 
 	pm_runtime_disable(&pdev->dev);
 	s5pcsis_suspend(&pdev->dev);
 	clk_disable(state->clock[CSIS_CLK_MUX]);
 	pm_runtime_set_suspended(&pdev->dev);
-
 	s5pcsis_clk_put(state);
 	regulator_bulk_free(CSIS_NUM_SUPPLIES, state->supplies);
 
 	media_entity_cleanup(&state->sd.entity);
-	free_irq(state->irq, state);
-	iounmap(state->regs);
-	release_mem_region(res->start, resource_size(res));
-	kfree(state);
 
 	return 0;
 }
-- 
1.7.9

