Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42343 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab2JQLQc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 07:16:32 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so6997024pad.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 04:16:32 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/8] [media] s5p-fimc: Use clk_prepare_enable and clk_disable_unprepare
Date: Wed, 17 Oct 2012 16:41:44 +0530
Message-Id: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace clk_enable/clk_disable with clk_prepare_enable/clk_disable_unprepare
as required by the common clock framework.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-fimc/fimc-core.c    |   10 +++++-----
 drivers/media/platform/s5p-fimc/fimc-lite.c    |    4 ++--
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    4 ++--
 drivers/media/platform/s5p-fimc/mipi-csis.c    |   10 +++++-----
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 8d0d2b9..92308ba 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -827,7 +827,7 @@ static int fimc_clk_get(struct fimc_dev *fimc)
 		fimc->clock[i] = clk_get(&fimc->pdev->dev, fimc_clocks[i]);
 		if (IS_ERR(fimc->clock[i]))
 			goto err;
-		ret = clk_prepare(fimc->clock[i]);
+		ret = clk_prepare_enable(fimc->clock[i]);
 		if (ret < 0) {
 			clk_put(fimc->clock[i]);
 			fimc->clock[i] = NULL;
@@ -925,7 +925,7 @@ static int fimc_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 	clk_set_rate(fimc->clock[CLK_BUS], drv_data->lclk_frequency);
-	clk_enable(fimc->clock[CLK_BUS]);
+	clk_prepare_enable(fimc->clock[CLK_BUS]);
 
 	ret = devm_request_irq(&pdev->dev, res->start, fimc_irq_handler,
 			       0, dev_name(&pdev->dev), fimc);
@@ -970,7 +970,7 @@ static int fimc_runtime_resume(struct device *dev)
 	dbg("fimc%d: state: 0x%lx", fimc->id, fimc->state);
 
 	/* Enable clocks and perform basic initalization */
-	clk_enable(fimc->clock[CLK_GATE]);
+	clk_prepare_enable(fimc->clock[CLK_GATE]);
 	fimc_hw_reset(fimc);
 
 	/* Resume the capture or mem-to-mem device */
@@ -990,7 +990,7 @@ static int fimc_runtime_suspend(struct device *dev)
 	else
 		ret = fimc_m2m_suspend(fimc);
 	if (!ret)
-		clk_disable(fimc->clock[CLK_GATE]);
+		clk_disable_unprepare(fimc->clock[CLK_GATE]);
 
 	dbg("fimc%d: state: 0x%lx", fimc->id, fimc->state);
 	return ret;
@@ -1045,7 +1045,7 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	fimc_unregister_capture_subdev(fimc);
 	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 
-	clk_disable(fimc->clock[CLK_BUS]);
+	clk_disable_unprepare(fimc->clock[CLK_BUS]);
 	fimc_clk_put(fimc);
 
 	dev_info(&pdev->dev, "driver unloaded\n");
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 70bcf39..4a12847 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -1479,7 +1479,7 @@ static int fimc_lite_runtime_resume(struct device *dev)
 {
 	struct fimc_lite *fimc = dev_get_drvdata(dev);
 
-	clk_enable(fimc->clock);
+	clk_prepare_enable(fimc->clock);
 	return 0;
 }
 
@@ -1487,7 +1487,7 @@ static int fimc_lite_runtime_suspend(struct device *dev)
 {
 	struct fimc_lite *fimc = dev_get_drvdata(dev);
 
-	clk_disable(fimc->clock);
+	clk_disable_unprepare(fimc->clock);
 	return 0;
 }
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 61fab00..e1f7cbe 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -779,7 +779,7 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 		if (camclk->use_count++ == 0) {
 			clk_set_rate(camclk->clock, pdata->clk_frequency);
 			camclk->frequency = pdata->clk_frequency;
-			ret = clk_enable(camclk->clock);
+			ret = clk_prepare_enable(camclk->clock);
 			dbg("Enabled camclk %d: f: %lu", pdata->clk_id,
 			    clk_get_rate(camclk->clock));
 		}
@@ -790,7 +790,7 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 		return 0;
 
 	if (--camclk->use_count == 0) {
-		clk_disable(camclk->clock);
+		clk_disable_unprepare(camclk->clock);
 		dbg("Disabled camclk %d", pdata->clk_id);
 	}
 	return ret;
diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 4c961b1..f02c95b 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -710,7 +710,7 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	if (ret)
 		goto e_clkput;
 
-	clk_enable(state->clock[CSIS_CLK_MUX]);
+	clk_prepare_enable(state->clock[CSIS_CLK_MUX]);
 	if (pdata->clk_rate)
 		clk_set_rate(state->clock[CSIS_CLK_MUX], pdata->clk_rate);
 	else
@@ -754,7 +754,7 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 e_regput:
 	regulator_bulk_free(CSIS_NUM_SUPPLIES, state->supplies);
 e_clkput:
-	clk_disable(state->clock[CSIS_CLK_MUX]);
+	clk_disable_unprepare(state->clock[CSIS_CLK_MUX]);
 	s5pcsis_clk_put(state);
 	return ret;
 }
@@ -779,7 +779,7 @@ static int s5pcsis_pm_suspend(struct device *dev, bool runtime)
 					     state->supplies);
 		if (ret)
 			goto unlock;
-		clk_disable(state->clock[CSIS_CLK_GATE]);
+		clk_disable_unprepare(state->clock[CSIS_CLK_GATE]);
 		state->flags &= ~ST_POWERED;
 		if (!runtime)
 			state->flags |= ST_SUSPENDED;
@@ -816,7 +816,7 @@ static int s5pcsis_pm_resume(struct device *dev, bool runtime)
 					       state->supplies);
 			goto unlock;
 		}
-		clk_enable(state->clock[CSIS_CLK_GATE]);
+		clk_prepare_enable(state->clock[CSIS_CLK_GATE]);
 	}
 	if (state->flags & ST_STREAMING)
 		s5pcsis_start_stream(state);
@@ -858,7 +858,7 @@ static int __devexit s5pcsis_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 	s5pcsis_pm_suspend(&pdev->dev, false);
-	clk_disable(state->clock[CSIS_CLK_MUX]);
+	clk_disable_unprepare(state->clock[CSIS_CLK_MUX]);
 	pm_runtime_set_suspended(&pdev->dev);
 	s5pcsis_clk_put(state);
 	regulator_bulk_free(CSIS_NUM_SUPPLIES, state->supplies);
-- 
1.7.4.1

