Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56097 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2KZG1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 01:27:00 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so7770073pbc.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 22:27:00 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: shaik.ameer@samsung.com, sylvester.nawrocki@gmail.com,
	s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/3] [media] exynos-gsc: Correct clock handling
Date: Mon, 26 Nov 2012 11:50:20 +0530
Message-Id: <1353910821-21408-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353910821-21408-1-git-send-email-sachin.kamat@linaro.org>
References: <1353910821-21408-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>

Make sure there is no unbalanced clk_unprepare call and add missing
clock release in the driver's remove() callback.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 45bcfa7..c8b82c0 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1002,12 +1002,11 @@ static void *gsc_get_drv_data(struct platform_device *pdev)
 
 static void gsc_clk_put(struct gsc_dev *gsc)
 {
-	if (IS_ERR_OR_NULL(gsc->clock))
-		return;
-
-	clk_unprepare(gsc->clock);
-	clk_put(gsc->clock);
-	gsc->clock = NULL;
+	if (!IS_ERR(gsc->clock)) {
+		clk_unprepare(gsc->clock);
+		clk_put(gsc->clock);
+		gsc->clock = NULL;
+	}
 }
 
 static int gsc_clk_get(struct gsc_dev *gsc)
@@ -1028,7 +1027,7 @@ static int gsc_clk_get(struct gsc_dev *gsc)
 		dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
 			GSC_CLOCK_GATE_NAME);
 		clk_put(gsc->clock);
-		gsc->clock = NULL;
+		gsc->clock = ERR_PTR(-EINVAL);
 		goto err_clk_prepare;
 	}
 
@@ -1106,6 +1105,7 @@ static int gsc_probe(struct platform_device *pdev)
 	init_waitqueue_head(&gsc->irq_queue);
 	spin_lock_init(&gsc->slock);
 	mutex_init(&gsc->lock);
+	gsc->clock = ERR_PTR(-EINVAL);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	gsc->regs = devm_request_and_ioremap(dev, res);
@@ -1169,6 +1169,7 @@ static int __devexit gsc_remove(struct platform_device *pdev)
 
 	vb2_dma_contig_cleanup_ctx(gsc->alloc_ctx);
 	pm_runtime_disable(&pdev->dev);
+	gsc_clk_put(gsc);
 
 	dev_dbg(&pdev->dev, "%s driver unloaded\n", pdev->name);
 	return 0;
-- 
1.7.4.1

