Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61162 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3LTWYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 17:24:20 -0500
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/6] exynos4-is: Enable FIMC-LITE clock if runtime PM is not used
Date: Fri, 20 Dec 2013 23:23:24 +0100
Message-Id: <1387578207-17625-4-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1387578207-17625-1-git-send-email-s.nawrocki@samsung.com>
References: <1387578207-17625-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure the device also works when runtime PM is disabled.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index d3b32b6..1234734 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1549,38 +1549,40 @@ static int fimc_lite_probe(struct platform_device *pdev)
 			       0, dev_name(dev), fimc);
 	if (ret) {
 		dev_err(dev, "Failed to install irq (%d)\n", ret);
-		goto err_clk;
+		goto err_clk_put;
 	}
 
 	/* The video node will be created within the subdev's registered() op */
 	ret = fimc_lite_create_capture_subdev(fimc);
 	if (ret)
-		goto err_clk;
+		goto err_clk_put;
 
 	platform_set_drvdata(pdev, fimc);
 	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
-		goto err_sd;
+
+	if (!pm_runtime_enabled(dev)) {
+		ret = clk_enable(fimc->clock);
+		if (ret < 0)
+			goto err_clk_put;
+	}
 
 	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(fimc->alloc_ctx)) {
 		ret = PTR_ERR(fimc->alloc_ctx);
-		goto err_pm;
+		goto err_clk_dis;
 	}
 
-	pm_runtime_put(dev);
-
 	fimc_lite_set_default_config(fimc);
 
 	dev_dbg(dev, "FIMC-LITE.%d registered successfully\n",
 		fimc->index);
 	return 0;
-err_pm:
-	pm_runtime_put(dev);
+
+err_clk_dis:
+	clk_disable(fimc->clock);
 err_sd:
 	fimc_lite_unregister_capture_subdev(fimc);
-err_clk:
+err_clk_put:
 	fimc_lite_clk_put(fimc);
 	return ret;
 }
-- 
1.7.4.1

