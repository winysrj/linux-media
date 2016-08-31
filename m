Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48401 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934002AbcHaM4R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 08:56:17 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4/6] drm/exynos: g2d: fix system and runtime pm integration
Date: Wed, 31 Aug 2016 14:55:57 +0200
Message-id: <1472648159-9814-5-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1472648159-9814-1-git-send-email-m.szyprowski@samsung.com>
References: <1472648159-9814-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move code from system sleep pm to runtime pm callbacks to ensure proper
driver state preservation when device is under power domain. Then, use
generic helpers for using runtime pm for system sleep pm.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_g2d.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index 4bf00f57ffe8..6eca8bb88648 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -1475,8 +1475,8 @@ static int g2d_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
-static int g2d_suspend(struct device *dev)
+#ifdef CONFIG_PM
+static int g2d_runtime_suspend(struct device *dev)
 {
 	struct g2d_data *g2d = dev_get_drvdata(dev);
 
@@ -1490,25 +1490,6 @@ static int g2d_suspend(struct device *dev)
 
 	flush_work(&g2d->runqueue_work);
 
-	return 0;
-}
-
-static int g2d_resume(struct device *dev)
-{
-	struct g2d_data *g2d = dev_get_drvdata(dev);
-
-	g2d->suspended = false;
-	g2d_exec_runqueue(g2d);
-
-	return 0;
-}
-#endif
-
-#ifdef CONFIG_PM
-static int g2d_runtime_suspend(struct device *dev)
-{
-	struct g2d_data *g2d = dev_get_drvdata(dev);
-
 	clk_disable_unprepare(g2d->gate_clk);
 
 	return 0;
@@ -1523,12 +1504,16 @@ static int g2d_runtime_resume(struct device *dev)
 	if (ret < 0)
 		dev_warn(dev, "failed to enable clock.\n");
 
+	g2d->suspended = false;
+	g2d_exec_runqueue(g2d);
+
 	return ret;
 }
 #endif
 
 static const struct dev_pm_ops g2d_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(g2d_suspend, g2d_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
 	SET_RUNTIME_PM_OPS(g2d_runtime_suspend, g2d_runtime_resume, NULL)
 };
 
-- 
1.9.1

