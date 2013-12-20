Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53960 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3LTWYX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 17:24:23 -0500
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 5/6] exynos4-is: Enable fimc-is clocks in probe() if runtime PM is disabled
Date: Fri, 20 Dec 2013 23:23:26 +0100
Message-Id: <1387578207-17625-6-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1387578207-17625-1-git-send-email-s.nawrocki@samsung.com>
References: <1387578207-17625-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure the device works also when runtime PM is disabled. This will
allow to drop an incorrect dependency on PM_RUNTIME.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 8cb70c2..13a4228 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -781,6 +781,9 @@ static int fimc_is_debugfs_create(struct fimc_is *is)
 	return is->debugfs_entry == NULL ? -EIO : 0;
 }
 
+static int fimc_is_runtime_resume(struct device *dev);
+static int fimc_is_runtime_suspend(struct device *dev);
+
 static int fimc_is_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -835,14 +838,20 @@ static int fimc_is_probe(struct platform_device *pdev)
 	}
 	pm_runtime_enable(dev);
 
+	if (!pm_runtime_enabled(dev)) {
+		ret = fimc_is_runtime_resume(dev);
+		if (ret < 0)
+			goto err_irq;
+	}
+
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0)
-		goto err_irq;
+		goto err_pm;
 
 	is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(is->alloc_ctx)) {
 		ret = PTR_ERR(is->alloc_ctx);
-		goto err_irq;
+		goto err_pm;
 	}
 	/*
 	 * Register FIMC-IS V4L2 subdevs to this driver. The video nodes
@@ -871,6 +880,9 @@ err_sd:
 	fimc_is_unregister_subdevs(is);
 err_vb:
 	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
+err_pm:
+	if (!pm_runtime_enabled(dev))
+		fimc_is_runtime_suspend(dev);
 err_irq:
 	free_irq(is->irq, is);
 err_clk:
@@ -919,10 +931,13 @@ static int fimc_is_suspend(struct device *dev)
 
 static int fimc_is_remove(struct platform_device *pdev)
 {
-	struct fimc_is *is = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+	struct fimc_is *is = dev_get_drvdata(dev);
 
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
+	if (!pm_runtime_status_suspended(dev))
+		fimc_is_runtime_suspend(dev);
 	free_irq(is->irq, is);
 	fimc_is_unregister_subdevs(is);
 	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
-- 
1.7.4.1

