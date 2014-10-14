Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:43466 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbaJNHP4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 03:15:56 -0400
Received: by mail-la0-f48.google.com with SMTP id gi9so8054399lab.35
        for <linux-media@vger.kernel.org>; Tue, 14 Oct 2014 00:15:55 -0700 (PDT)
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kevin Hilman <khilman@linaro.org>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Philipp Zabel <philipp.zabel@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Pavel Machek <pavel@ucw.cz>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 1/7] [media] exynos-gsc: Simplify clock management
Date: Tue, 14 Oct 2014 09:15:34 +0200
Message-Id: <1413270940-4378-2-git-send-email-ulf.hansson@linaro.org>
In-Reply-To: <1413270940-4378-1-git-send-email-ulf.hansson@linaro.org>
References: <1413270940-4378-1-git-send-email-ulf.hansson@linaro.org>
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
index b4c9f1d..3fca4fd 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1000,36 +1000,6 @@ static void *gsc_get_drv_data(struct platform_device *pdev)
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
@@ -1098,7 +1068,6 @@ static int gsc_probe(struct platform_device *pdev)
 	init_waitqueue_head(&gsc->irq_queue);
 	spin_lock_init(&gsc->slock);
 	mutex_init(&gsc->lock);
-	gsc->clock = ERR_PTR(-EINVAL);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	gsc->regs = devm_ioremap_resource(dev, res);
@@ -1111,9 +1080,19 @@ static int gsc_probe(struct platform_device *pdev)
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
@@ -1154,7 +1133,7 @@ err_m2m:
 err_v4l2:
 	v4l2_device_unregister(&gsc->v4l2_dev);
 err_clk:
-	gsc_clk_put(gsc);
+	clk_unprepare(gsc->clock);
 	return ret;
 }
 
@@ -1167,7 +1146,7 @@ static int gsc_remove(struct platform_device *pdev)
 
 	vb2_dma_contig_cleanup_ctx(gsc->alloc_ctx);
 	pm_runtime_disable(&pdev->dev);
-	gsc_clk_put(gsc);
+	clk_unprepare(gsc->clock);
 
 	dev_dbg(&pdev->dev, "%s driver unloaded\n", pdev->name);
 	return 0;
-- 
1.9.1

