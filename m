Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:58094 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaAGWIE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 17:08:04 -0500
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: Fix error paths in probe() for !pm_runtime_enabled()
Date: Tue,  7 Jan 2014 23:07:52 +0100
Message-Id: <1389132472-19245-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure clk_disable() is called on error paths only when clk_enable()
was previously called.

This fixes following build warning:

.../media-git/drivers/media/platform/exynos4-is/fimc-lite.c: In function 'fimc_lite_probe':
.../media-git/drivers/media/platform/exynos4-is/fimc-lite.c:1583:1: warning: label 'err_sd' defined but not used [-Wunused-label]

Reported-by: Hans Verkuil <hansverk@cisco.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-core.c |    3 ++-
 drivers/media/platform/exynos4-is/fimc-lite.c |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index a7dfd07..dcbea59 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -1027,7 +1027,8 @@ static int fimc_probe(struct platform_device *pdev)
 	return 0;
 
 err_gclk:
-	clk_disable(fimc->clock[CLK_GATE]);
+	if (!pm_runtime_enabled(dev))
+		clk_disable(fimc->clock[CLK_GATE]);
 err_sd:
 	fimc_unregister_capture_subdev(fimc);
 err_sclk:
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 1234734..5213ff0 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1563,7 +1563,7 @@ static int fimc_lite_probe(struct platform_device *pdev)
 	if (!pm_runtime_enabled(dev)) {
 		ret = clk_enable(fimc->clock);
 		if (ret < 0)
-			goto err_clk_put;
+			goto err_sd;
 	}
 
 	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
@@ -1579,7 +1579,8 @@ static int fimc_lite_probe(struct platform_device *pdev)
 	return 0;
 
 err_clk_dis:
-	clk_disable(fimc->clock);
+	if (!pm_runtime_enabled(dev))
+		clk_disable(fimc->clock);
 err_sd:
 	fimc_lite_unregister_capture_subdev(fimc);
 err_clk_put:
-- 
1.7.4.1

