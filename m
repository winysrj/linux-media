Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:39554 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab3FNSFH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 14:05:07 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: Fix FIMC-IS clocks initialization
Date: Fri, 14 Jun 2013 20:04:28 +0200
Message-id: <1371233068-4165-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ISP clock register content is not preserved over the ISP power domain
off/on cycle. Instead of setting the clock frequencies once at probe time
the clock rates set up is moved to the runtime_resume handler, which is
invoked after the related power domain is already enabled, ensuring the
clocks are properly when the device is actively used.

This fixes the FIMC-IS malfunctions and STREAM ON timeout errors accuring
on some boards:

[ 59.860000] fimc_is_general_irq_handler:583 ISR_NDONE: 5: 0x800003e8, IS_ERROR_UNKNOWN
[ 59.860000] fimc_is_general_irq_handler:586 IS_ERROR_TIME_OUT

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com
---
 drivers/media/platform/exynos4-is/fimc-is.c |   26 ++++++++------------------
 drivers/media/platform/exynos4-is/fimc-is.h |    1 -
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index ddb32e4..ae5bbc5 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -837,23 +837,11 @@ static int fimc_is_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 	pm_runtime_enable(dev);
-	/*
-	 * Enable only the ISP power domain, keep FIMC-IS clocks off until
-	 * the whole clock tree is configured. The ISP power domain needs
-	 * be active in order to acces any CMU_ISP clock registers.
-	 */
-	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
-		goto err_irq;
-
-	ret = fimc_is_setup_clocks(is);
-	pm_runtime_put_sync(dev);
 
+	ret = pm_runtime_get_sync(dev);
 	if (ret < 0)
 		goto err_irq;
 
-	is->clk_init = true;
-
 	is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(is->alloc_ctx)) {
 		ret = PTR_ERR(is->alloc_ctx);
@@ -875,6 +863,8 @@ static int fimc_is_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_dfs;
 
+	pm_runtime_put_sync(dev);
+
 	dev_dbg(dev, "FIMC-IS registered successfully\n");
 	return 0;
 
@@ -894,9 +884,11 @@ err_clk:
 static int fimc_is_runtime_resume(struct device *dev)
 {
 	struct fimc_is *is = dev_get_drvdata(dev);
+	int ret;
 
-	if (!is->clk_init)
-		return 0;
+	ret = fimc_is_setup_clocks(is);
+	if (ret)
+		return ret;
 
 	return fimc_is_enable_clocks(is);
 }
@@ -905,9 +897,7 @@ static int fimc_is_runtime_suspend(struct device *dev)
 {
 	struct fimc_is *is = dev_get_drvdata(dev);
 
-	if (is->clk_init)
-		fimc_is_disable_clocks(is);
-
+	fimc_is_disable_clocks(is);
 	return 0;
 }
 
diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
index 04b4564..c5ce6a2 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.h
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -264,7 +264,6 @@ struct fimc_is {
 	spinlock_t			slock;
 
 	struct clk			*clocks[ISS_CLKS_MAX];
-	bool				clk_init;
 	void __iomem			*regs;
 	void __iomem			*pmu_regs;
 	int				irq;
-- 
1.7.9.5

