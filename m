Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:44964 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbbASNa5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 08:30:57 -0500
Received: by mail-la0-f53.google.com with SMTP id gq15so4397113lab.12
        for <linux-media@vger.kernel.org>; Mon, 19 Jan 2015 05:30:55 -0800 (PST)
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH V2 1/8] [media] exynos-gsc: Simplify clock management
Date: Mon, 19 Jan 2015 14:22:33 +0100
Message-Id: <1421673760-2600-2-git-send-email-ulf.hansson@linaro.org>
In-Reply-To: <1421673760-2600-1-git-send-email-ulf.hansson@linaro.org>
References: <1421673760-2600-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of having separate functions that fecthes, prepares and
unprepares the clock, let's encapsulate this code into ->probe().

This makes error handling easier and decreases the lines of code.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 49 ++++++++--------------------
 1 file changed, 14 insertions(+), 35 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index fd2891c..bd769d4 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1003,36 +1003,6 @@ static void *gsc_get_drv_data(struct platform_device *pdev)
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
@@ -1101,7 +1071,6 @@ static int gsc_probe(struct platform_device *pdev)
 	init_waitqueue_head(&gsc->irq_queue);
 	spin_lock_init(&gsc->slock);
 	mutex_init(&gsc->lock);
-	gsc->clock = ERR_PTR(-EINVAL);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	gsc->regs = devm_ioremap_resource(dev, res);
@@ -1114,9 +1083,19 @@ static int gsc_probe(struct platform_device *pdev)
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
@@ -1157,7 +1136,7 @@ err_m2m:
 err_v4l2:
 	v4l2_device_unregister(&gsc->v4l2_dev);
 err_clk:
-	gsc_clk_put(gsc);
+	clk_unprepare(gsc->clock);
 	return ret;
 }
 
@@ -1170,7 +1149,7 @@ static int gsc_remove(struct platform_device *pdev)
 
 	vb2_dma_contig_cleanup_ctx(gsc->alloc_ctx);
 	pm_runtime_disable(&pdev->dev);
-	gsc_clk_put(gsc);
+	clk_unprepare(gsc->clock);
 
 	dev_dbg(&pdev->dev, "%s driver unloaded\n", pdev->name);
 	return 0;
-- 
1.9.1

