Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61095 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753182AbcKIOYM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:24:12 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 01/12] exynos-gsc: Simplify clock management
Date: Wed, 09 Nov 2016 15:23:50 +0100
Message-id: <1478701441-29107-2-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
References: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142407eucas1p14c59e64f284a9d556a63047295611984@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ulf Hansson <ulf.hansson@linaro.org>

Instead of having separate functions that fecthes, prepares and
unprepares the clock, let's encapsulate this code into ->probe().

This makes error handling easier and decreases the lines of code.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[mszyprow: rebased onto v4.9-rc4]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 49 ++++++++--------------------
 1 file changed, 14 insertions(+), 35 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 787bd16..abebbdb 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -988,36 +988,6 @@ static void *gsc_get_drv_data(struct platform_device *pdev)
 	return driver_data;
 }
 
-static void gsc_clk_put(struct gsc_dev *gsc)
-{
-	if (!IS_ERR(gsc->clock))
-		clk_unprepare(gsc->clock);
-}
-
-static int gsc_clk_get(struct gsc_dev *gsc)
-{
-	int ret;
-
-	dev_dbg(&gsc->pdev->dev, "gsc_clk_get Called\n");
-
-	gsc->clock = devm_clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
-	if (IS_ERR(gsc->clock)) {
-		dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
-			GSC_CLOCK_GATE_NAME);
-		return PTR_ERR(gsc->clock);
-	}
-
-	ret = clk_prepare(gsc->clock);
-	if (ret < 0) {
-		dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
-			GSC_CLOCK_GATE_NAME);
-		gsc->clock = ERR_PTR(-EINVAL);
-		return ret;
-	}
-
-	return 0;
-}
-
 static int gsc_m2m_suspend(struct gsc_dev *gsc)
 {
 	unsigned long flags;
@@ -1085,7 +1055,6 @@ static int gsc_probe(struct platform_device *pdev)
 	init_waitqueue_head(&gsc->irq_queue);
 	spin_lock_init(&gsc->slock);
 	mutex_init(&gsc->lock);
-	gsc->clock = ERR_PTR(-EINVAL);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	gsc->regs = devm_ioremap_resource(dev, res);
@@ -1098,9 +1067,19 @@ static int gsc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	ret = gsc_clk_get(gsc);
-	if (ret)
+	gsc->clock = devm_clk_get(dev, GSC_CLOCK_GATE_NAME);
+	if (IS_ERR(gsc->clock)) {
+		dev_err(dev, "failed to get clock~~~: %s\n",
+			GSC_CLOCK_GATE_NAME);
+		return PTR_ERR(gsc->clock);
+	}
+
+	ret = clk_prepare(gsc->clock);
+	if (ret) {
+		dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
+			GSC_CLOCK_GATE_NAME);
 		return ret;
+	}
 
 	ret = devm_request_irq(dev, res->start, gsc_irq_handler,
 				0, pdev->name, gsc);
@@ -1135,7 +1114,7 @@ static int gsc_probe(struct platform_device *pdev)
 err_v4l2:
 	v4l2_device_unregister(&gsc->v4l2_dev);
 err_clk:
-	gsc_clk_put(gsc);
+	clk_unprepare(gsc->clock);
 	return ret;
 }
 
@@ -1148,7 +1127,7 @@ static int gsc_remove(struct platform_device *pdev)
 
 	vb2_dma_contig_clear_max_seg_size(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	gsc_clk_put(gsc);
+	clk_unprepare(gsc->clock);
 
 	dev_dbg(&pdev->dev, "%s driver unloaded\n", pdev->name);
 	return 0;
-- 
1.9.1

