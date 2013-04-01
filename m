Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50680 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853Ab3DAIoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Apr 2013 04:44:01 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz11so1218997pad.2
        for <linux-media@vger.kernel.org>; Mon, 01 Apr 2013 01:44:01 -0700 (PDT)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, linaro-kernel@lists.linaro.org,
	jy0922.shim@samsung.com, linux-samsung-soc@vger.kernel.org,
	thomas.abraham@linaro.org
Subject: [PATCH v3] drm/exynos: enable FIMD clocks
Date: Mon,  1 Apr 2013 14:13:50 +0530
Message-Id: <1364805830-6129-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While migrating to common clock framework (CCF), found that the FIMD clocks
were pulled down by the CCF.
If CCF finds any clock(s) which has NOT been claimed by any of the
drivers, then such clock(s) are PULLed low by CCF.

By calling clk_prepare_enable() for FIMD clocks fixes the issue.

this patch also replaces clk_disable() with clk_disable_unprepare()
during exit.

Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
Changes since v2:
	- moved clk_prepare_enable() and clk_disable_unprepare() from 
	fimd_probe() to fimd_clock() as suggested by Inki Dae <inki.dae@samsung.com>
Changes since v1:
	- added error checking for clk_prepare_enable() and also replaced 
	clk_disable() with clk_disable_unprepare() during exit.
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 9537761..f2400c8 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -799,18 +799,18 @@ static int fimd_clock(struct fimd_context *ctx, bool enable)
 	if (enable) {
 		int ret;
 
-		ret = clk_enable(ctx->bus_clk);
+		ret = clk_prepare_enable(ctx->bus_clk);
 		if (ret < 0)
 			return ret;
 
-		ret = clk_enable(ctx->lcd_clk);
+		ret = clk_prepare_enable(ctx->lcd_clk);
 		if  (ret < 0) {
-			clk_disable(ctx->bus_clk);
+			clk_disable_unprepare(ctx->bus_clk);
 			return ret;
 		}
 	} else {
-		clk_disable(ctx->lcd_clk);
-		clk_disable(ctx->bus_clk);
+		clk_disable_unprepare(ctx->lcd_clk);
+		clk_disable_unprepare(ctx->bus_clk);
 	}
 
 	return 0;
@@ -981,8 +981,8 @@ static int fimd_remove(struct platform_device *pdev)
 	if (ctx->suspended)
 		goto out;
 
-	clk_disable(ctx->lcd_clk);
-	clk_disable(ctx->bus_clk);
+	clk_disable_unprepare(ctx->lcd_clk);
+	clk_disable_unprepare(ctx->bus_clk);
 
 	pm_runtime_set_suspended(dev);
 	pm_runtime_put_sync(dev);
-- 
1.7.9.5

