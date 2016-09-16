Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:50332 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751257AbcIPJCf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 05:02:35 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: add of_platform_populate() call for FIMC-IS child
 devices
Date: Fri, 16 Sep 2016 11:02:16 +0200
Message-id: <1474016536-29766-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of relying on the "simple-bus" compatible and the driver core
populating FIMC-IS child devices make the fimc-is driver populating its
child devices.  This prevents issues related to accessing ISP_I2C clock
registers with corresponding power domain switched off, which happens
after applying some pending Exynos IOMMU driver patches improving
runtime PM.  Now the I2C_ISP child devices will be instantiated only
when required parent device drivers are initialized and ready.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 313ab10..518ad34 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -852,13 +852,18 @@ static int fimc_is_probe(struct platform_device *pdev)
 		goto err_pm;
 
 	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
+
+	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+	if (ret < 0)
+		goto err_pm;
+
 	/*
 	 * Register FIMC-IS V4L2 subdevs to this driver. The video nodes
 	 * will be created within the subdev's registered() callback.
 	 */
 	ret = fimc_is_register_subdevs(is);
 	if (ret < 0)
-		goto err_pm;
+		goto err_of_dep;
 
 	ret = fimc_is_debugfs_create(is);
 	if (ret < 0)
@@ -877,6 +882,8 @@ err_dfs:
 	fimc_is_debugfs_remove(is);
 err_sd:
 	fimc_is_unregister_subdevs(is);
+err_of_dep:
+	of_platform_depopulate(dev);
 err_pm:
 	if (!pm_runtime_enabled(dev))
 		fimc_is_runtime_suspend(dev);
@@ -936,6 +943,7 @@ static int fimc_is_remove(struct platform_device *pdev)
 	if (!pm_runtime_status_suspended(dev))
 		fimc_is_runtime_suspend(dev);
 	free_irq(is->irq, is);
+	of_platform_depopulate(dev);
 	fimc_is_unregister_subdevs(is);
 	vb2_dma_contig_clear_max_seg_size(dev);
 	fimc_is_put_clocks(is);
-- 
1.9.1

