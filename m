Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15387 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934236AbcHaM4X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 08:56:23 -0400
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
Subject: [PATCH 2/6] drm/exynos: gsc: fix system and runtime pm integration
Date: Wed, 31 Aug 2016 14:55:55 +0200
Message-id: <1472648159-9814-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1472648159-9814-1-git-send-email-m.szyprowski@samsung.com>
References: <1472648159-9814-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use generic helpers instead of open-coding usage of runtime pm for system
sleep pm, which was potentially broken for some corner cases.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_gsc.c | 29 ++---------------------------
 1 file changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index 5d20da8f957e..b1894aa9286e 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1760,32 +1760,6 @@ static int gsc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
-static int gsc_suspend(struct device *dev)
-{
-	struct gsc_context *ctx = get_gsc_context(dev);
-
-	DRM_DEBUG_KMS("id[%d]\n", ctx->id);
-
-	if (pm_runtime_suspended(dev))
-		return 0;
-
-	return gsc_clk_ctrl(ctx, false);
-}
-
-static int gsc_resume(struct device *dev)
-{
-	struct gsc_context *ctx = get_gsc_context(dev);
-
-	DRM_DEBUG_KMS("id[%d]\n", ctx->id);
-
-	if (!pm_runtime_suspended(dev))
-		return gsc_clk_ctrl(ctx, true);
-
-	return 0;
-}
-#endif
-
 #ifdef CONFIG_PM
 static int gsc_runtime_suspend(struct device *dev)
 {
@@ -1807,7 +1781,8 @@ static int gsc_runtime_resume(struct device *dev)
 #endif
 
 static const struct dev_pm_ops gsc_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(gsc_suspend, gsc_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
 	SET_RUNTIME_PM_OPS(gsc_runtime_suspend, gsc_runtime_resume, NULL)
 };
 
-- 
1.9.1

