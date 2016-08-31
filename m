Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41285 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932622AbcHaNZd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 09:25:33 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/3] media: exynos4-is: Improve clock management
Date: Wed, 31 Aug 2016 15:25:17 +0200
Message-id: <1472649918-10371-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1472649918-10371-1-git-send-email-m.szyprowski@samsung.com>
References: <1472649918-10371-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to keep all clocks prepared all the time. Call to
clk_prepare/unprepare can be done on demand from runtime pm callbacks
(it is allowed to call sleeping functions from that context).

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index a0f149fb88e1..fd16605dd1d4 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1454,25 +1454,17 @@ static void fimc_lite_clk_put(struct fimc_lite *fimc)
 	if (IS_ERR(fimc->clock))
 		return;
 
-	clk_unprepare(fimc->clock);
 	clk_put(fimc->clock);
 	fimc->clock = ERR_PTR(-EINVAL);
 }
 
 static int fimc_lite_clk_get(struct fimc_lite *fimc)
 {
-	int ret;
-
 	fimc->clock = clk_get(&fimc->pdev->dev, FLITE_CLK_NAME);
 	if (IS_ERR(fimc->clock))
 		return PTR_ERR(fimc->clock);
 
-	ret = clk_prepare(fimc->clock);
-	if (ret < 0) {
-		clk_put(fimc->clock);
-		fimc->clock = ERR_PTR(-EINVAL);
-	}
-	return ret;
+	return 0;
 }
 
 static const struct of_device_id flite_of_match[];
@@ -1543,7 +1535,7 @@ static int fimc_lite_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 
 	if (!pm_runtime_enabled(dev)) {
-		ret = clk_enable(fimc->clock);
+		ret = clk_prepare_enable(fimc->clock);
 		if (ret < 0)
 			goto err_sd;
 	}
@@ -1568,7 +1560,7 @@ static int fimc_lite_runtime_resume(struct device *dev)
 {
 	struct fimc_lite *fimc = dev_get_drvdata(dev);
 
-	clk_enable(fimc->clock);
+	clk_prepare_enable(fimc->clock);
 	return 0;
 }
 
@@ -1576,7 +1568,7 @@ static int fimc_lite_runtime_suspend(struct device *dev)
 {
 	struct fimc_lite *fimc = dev_get_drvdata(dev);
 
-	clk_disable(fimc->clock);
+	clk_disable_unprepare(fimc->clock);
 	return 0;
 }
 #endif
-- 
1.9.1

