Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37825 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab3CTLcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 07:32:12 -0400
Received: by mail-pb0-f42.google.com with SMTP id xb4so1283671pbc.29
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 04:32:12 -0700 (PDT)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, linaro-kernel@lists.linaro.org,
	jy0922.shim@samsung.com, linux-samsung-soc@vger.kernel.org,
	thomas.abraham@linaro.org
Subject: [PATCH v2] drm/exynos: enable FIMD clocks
Date: Wed, 20 Mar 2013 17:01:59 +0530
Message-Id: <1363779119-3255-1-git-send-email-vikas.sajjan@linaro.org>
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
Changes since v1:
	- added error checking for clk_prepare_enable() and also replaced 
	clk_disable() with clk_disable_unprepare() during exit.
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 9537761..014d750 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -934,6 +934,19 @@ static int fimd_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = clk_prepare_enable(ctx->lcd_clk);
+	if (ret) {
+		dev_err(dev, "failed to enable 'sclk_fimd' clock\n");
+		return ret;
+	}
+
+	ret = clk_prepare_enable(ctx->bus_clk);
+	if (ret) {
+		clk_disable_unprepare(ctx->lcd_clk);
+		dev_err(dev, "failed to enable 'fimd' clock\n");
+		return ret;
+	}
+
 	ctx->vidcon0 = pdata->vidcon0;
 	ctx->vidcon1 = pdata->vidcon1;
 	ctx->default_win = pdata->default_win;
@@ -981,8 +994,8 @@ static int fimd_remove(struct platform_device *pdev)
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

