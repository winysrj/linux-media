Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:54653 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763461Ab3DHLH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 07:07:59 -0400
Received: by mail-da0-f42.google.com with SMTP id n15so2577776dad.1
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 04:07:58 -0700 (PDT)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, patches@linaro.org,
	linaro-kernel@lists.linaro.org, jy0922.shim@samsung.com,
	linux-samsung-soc@vger.kernel.org, thomas.abraham@linaro.org
Subject: [PATCH v4] drm/exynos: prepare FIMD clocks
Date: Mon,  8 Apr 2013 16:37:45 +0530
Message-Id: <1365419265-21238-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While migrating to common clock framework (CCF), I found that the FIMD clocks
were pulled down by the CCF.
If CCF finds any clock(s) which has NOT been claimed by any of the
drivers, then such clock(s) are PULLed low by CCF.

Calling clk_prepare() for FIMD clocks fixes the issue.

This patch also replaces clk_disable() with clk_unprepare() during exit, since
clk_prepare() is called in fimd_probe().

Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
Changes since v3:
	- added clk_prepare() in fimd_probe() and clk_unprepare() in fimd_remove()
	 as suggested by Viresh Kumar <viresh.kumar@linaro.org>
Changes since v2:
	- moved clk_prepare_enable() and clk_disable_unprepare() from 
	fimd_probe() to fimd_clock() as suggested by Inki Dae <inki.dae@samsung.com>
Changes since v1:
	- added error checking for clk_prepare_enable() and also replaced 
	clk_disable() with clk_disable_unprepare() during exit.
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 9537761..aa22370 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -934,6 +934,16 @@ static int fimd_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = clk_prepare(ctx->bus_clk);
+	if (ret < 0)
+		return ret;
+
+	ret = clk_prepare(ctx->lcd_clk);
+	if  (ret < 0) {
+		clk_unprepare(ctx->bus_clk);
+		return ret;
+	}
+
 	ctx->vidcon0 = pdata->vidcon0;
 	ctx->vidcon1 = pdata->vidcon1;
 	ctx->default_win = pdata->default_win;
@@ -981,8 +991,8 @@ static int fimd_remove(struct platform_device *pdev)
 	if (ctx->suspended)
 		goto out;
 
-	clk_disable(ctx->lcd_clk);
-	clk_disable(ctx->bus_clk);
+	clk_unprepare(ctx->lcd_clk);
+	clk_unprepare(ctx->bus_clk);
 
 	pm_runtime_set_suspended(dev);
 	pm_runtime_put_sync(dev);
-- 
1.7.9.5

