Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:39629 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3LTWYR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 17:24:17 -0500
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/6] exynos4-is: Leave FIMC clocks enabled when runtime PM is disabled
Date: Fri, 20 Dec 2013 23:23:22 +0100
Message-Id: <1387578207-17625-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1387578207-17625-1-git-send-email-s.nawrocki@samsung.com>
References: <1387578207-17625-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver should ensure a device can be also used normally when runtime
PM is disabled. So enable the FIMC clock in probe() in such situation.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-core.c |   29 +++++++++++++-----------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index f791569..a7dfd07 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -998,36 +998,39 @@ static int fimc_probe(struct platform_device *pdev)
 
 	ret = devm_request_irq(dev, res->start, fimc_irq_handler,
 			       0, dev_name(dev), fimc);
-	if (ret) {
+	if (ret < 0) {
 		dev_err(dev, "failed to install irq (%d)\n", ret);
-		goto err_clk;
+		goto err_sclk;
 	}
 
 	ret = fimc_initialize_capture_subdev(fimc);
-	if (ret)
-		goto err_clk;
+	if (ret < 0)
+		goto err_sclk;
 
 	platform_set_drvdata(pdev, fimc);
 	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
-		goto err_sd;
+
+	if (!pm_runtime_enabled(dev)) {
+		ret = clk_enable(fimc->clock[CLK_GATE]);
+		if (ret < 0)
+			goto err_sd;
+	}
+
 	/* Initialize contiguous memory allocator */
 	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(fimc->alloc_ctx)) {
 		ret = PTR_ERR(fimc->alloc_ctx);
-		goto err_pm;
+		goto err_gclk;
 	}
 
 	dev_dbg(dev, "FIMC.%d registered successfully\n", fimc->id);
-
-	pm_runtime_put(dev);
 	return 0;
-err_pm:
-	pm_runtime_put(dev);
+
+err_gclk:
+	clk_disable(fimc->clock[CLK_GATE]);
 err_sd:
 	fimc_unregister_capture_subdev(fimc);
-err_clk:
+err_sclk:
 	clk_disable(fimc->clock[CLK_BUS]);
 	fimc_clk_put(fimc);
 	return ret;
-- 
1.7.4.1

