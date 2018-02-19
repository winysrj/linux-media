Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57059 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753059AbeBSPpK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 10:45:10 -0500
From: Maciej Purski <m.purski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Cc: Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Russell King <linux@armlinux.org.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Hoegeun Kwon <hoegeun.kwon@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Maciej Purski <m.purski@samsung.com>
Subject: [PATCH 7/8] [media] exynos-gsc: Use clk bulk API
Date: Mon, 19 Feb 2018 16:44:05 +0100
Message-id: <1519055046-2399-8-git-send-email-m.purski@samsung.com>
In-reply-to: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
References: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
        <CGME20180219154502eucas1p20e8daf3edc6737817f8d62db5a2099f2@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using bulk clk functions simplifies the driver's code. Use devm_clk_bulk
functions instead of iterating over an array of clks.

Signed-off-by: Maciej Purski <m.purski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 55 ++++++++++------------------
 drivers/media/platform/exynos-gsc/gsc-core.h |  2 +-
 2 files changed, 20 insertions(+), 37 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 17854a3..fa7e993 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1149,7 +1149,6 @@ static int gsc_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	const struct gsc_driverdata *drv_data = of_device_get_match_data(dev);
 	int ret;
-	int i;
 
 	gsc = devm_kzalloc(dev, sizeof(struct gsc_dev), GFP_KERNEL);
 	if (!gsc)
@@ -1187,25 +1186,19 @@ static int gsc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	for (i = 0; i < gsc->num_clocks; i++) {
-		gsc->clock[i] = devm_clk_get(dev, drv_data->clk_names[i]);
-		if (IS_ERR(gsc->clock[i])) {
-			dev_err(dev, "failed to get clock: %s\n",
-				drv_data->clk_names[i]);
-			return PTR_ERR(gsc->clock[i]);
-		}
-	}
+	gsc->clocks = devm_clk_bulk_alloc(dev, gsc->num_clocks,
+					  drv_data->clk_names);
+	if (IS_ERR(gsc->clocks))
+		return PTR_ERR(gsc->clocks);
 
-	for (i = 0; i < gsc->num_clocks; i++) {
-		ret = clk_prepare_enable(gsc->clock[i]);
-		if (ret) {
-			dev_err(dev, "clock prepare failed for clock: %s\n",
-				drv_data->clk_names[i]);
-			while (--i >= 0)
-				clk_disable_unprepare(gsc->clock[i]);
-			return ret;
-		}
-	}
+	ret = devm_clk_bulk_get(dev, gsc->num_clocks,
+				gsc->clocks);
+	if (ret)
+		return ret;
+
+	ret = clk_bulk_prepare_enable(gsc->num_clocks, gsc->clocks);
+	if (ret)
+		return ret;
 
 	ret = devm_request_irq(dev, res->start, gsc_irq_handler,
 				0, pdev->name, gsc);
@@ -1239,15 +1232,14 @@ static int gsc_probe(struct platform_device *pdev)
 err_v4l2:
 	v4l2_device_unregister(&gsc->v4l2_dev);
 err_clk:
-	for (i = gsc->num_clocks - 1; i >= 0; i--)
-		clk_disable_unprepare(gsc->clock[i]);
+	clk_bulk_disable_unprepare(gsc->num_clocks, gsc->clocks);
+
 	return ret;
 }
 
 static int gsc_remove(struct platform_device *pdev)
 {
 	struct gsc_dev *gsc = platform_get_drvdata(pdev);
-	int i;
 
 	pm_runtime_get_sync(&pdev->dev);
 
@@ -1255,8 +1247,7 @@ static int gsc_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&gsc->v4l2_dev);
 
 	vb2_dma_contig_clear_max_seg_size(&pdev->dev);
-	for (i = 0; i < gsc->num_clocks; i++)
-		clk_disable_unprepare(gsc->clock[i]);
+	clk_bulk_disable_unprepare(gsc->num_clocks, gsc->clocks);
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -1307,18 +1298,12 @@ static int gsc_runtime_resume(struct device *dev)
 {
 	struct gsc_dev *gsc = dev_get_drvdata(dev);
 	int ret = 0;
-	int i;
 
 	pr_debug("gsc%d: state: 0x%lx\n", gsc->id, gsc->state);
 
-	for (i = 0; i < gsc->num_clocks; i++) {
-		ret = clk_prepare_enable(gsc->clock[i]);
-		if (ret) {
-			while (--i >= 0)
-				clk_disable_unprepare(gsc->clock[i]);
-			return ret;
-		}
-	}
+	ret = clk_bulk_prepare_enable(gsc->num_clocks, gsc->clocks);
+	if (ret)
+		return ret;
 
 	gsc_hw_set_sw_reset(gsc);
 	gsc_wait_reset(gsc);
@@ -1331,14 +1316,12 @@ static int gsc_runtime_suspend(struct device *dev)
 {
 	struct gsc_dev *gsc = dev_get_drvdata(dev);
 	int ret = 0;
-	int i;
 
 	ret = gsc_m2m_suspend(gsc);
 	if (ret)
 		return ret;
 
-	for (i = gsc->num_clocks - 1; i >= 0; i--)
-		clk_disable_unprepare(gsc->clock[i]);
+	clk_bulk_disable_unprepare(gsc->num_clocks, gsc->clocks);
 
 	pr_debug("gsc%d: state: 0x%lx\n", gsc->id, gsc->state);
 	return ret;
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 715d9c9d..08ff7b9 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -334,7 +334,7 @@ struct gsc_dev {
 	struct gsc_variant		*variant;
 	u16				id;
 	int				num_clocks;
-	struct clk			*clock[GSC_MAX_CLOCKS];
+	struct clk_bulk_data		*clocks;
 	void __iomem			*regs;
 	wait_queue_head_t		irq_queue;
 	struct gsc_m2m_device		m2m;
-- 
2.7.4
