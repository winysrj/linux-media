Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57066 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934857AbcKPJFc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 04:05:32 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 7/9] s5p-mfc: Don't keep clock prepared all the time
Date: Wed, 16 Nov 2016 10:04:56 +0100
Message-id: <1479287098-30493-8-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
References: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161116090521eucas1p105428e9cd3affab0260a574e21a749f0@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch moves preparation of clocks from s5p_mfc_init_pm()
(driver probe) to s5p_mfc_power_on() (start of device operation).
This change will allow to use runtime power usage optimization
on newer Samsung Exynos platforms (for example Exynos 5433).

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c | 52 ++++++++++++++++-------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index b514584cf00d..796dac85746a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -39,23 +39,11 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 		goto err_g_ip_clk;
 	}
 
-	ret = clk_prepare(pm->clock_gate);
-	if (ret) {
-		mfc_err("Failed to prepare clock-gating control\n");
-		goto err_p_ip_clk;
-	}
-
 	if (dev->variant->version != MFC_VERSION_V6) {
 		pm->clock = clk_get(&dev->plat_dev->dev, MFC_SCLK_NAME);
 		if (IS_ERR(pm->clock)) {
 			mfc_info("Failed to get MFC special clock control\n");
 			pm->clock = NULL;
-		} else {
-			ret = clk_prepare_enable(pm->clock);
-			if (ret) {
-				mfc_err("Failed to enable MFC special clock\n");
-				goto err_s_clk;
-			}
 		}
 	}
 
@@ -65,10 +53,6 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 
 	return 0;
 
-err_s_clk:
-	clk_put(pm->clock);
-	pm->clock = NULL;
-err_p_ip_clk:
 	clk_put(pm->clock_gate);
 	pm->clock_gate = NULL;
 err_g_ip_clk:
@@ -79,11 +63,9 @@ void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)
 {
 	if (dev->variant->version != MFC_VERSION_V6 &&
 	    pm->clock) {
-		clk_disable_unprepare(pm->clock);
 		clk_put(pm->clock);
 		pm->clock = NULL;
 	}
-	clk_unprepare(pm->clock_gate);
 	clk_put(pm->clock_gate);
 	pm->clock_gate = NULL;
 	pm_runtime_disable(pm->device);
@@ -111,22 +93,44 @@ void s5p_mfc_clock_off(void)
 
 int s5p_mfc_power_on(void)
 {
-	int ret = 0;
+	int ret;
 
 	ret = pm_runtime_get_sync(pm->device);
 	if (ret)
 		return ret;
 
-	if (!pm->use_clock_gating)
-		ret = clk_enable(pm->clock_gate);
+	ret = clk_prepare_enable(pm->clock_gate);
+	if (ret)
+		goto err_pm;
+
+	if (pm->clock) {
+		ret = clk_prepare_enable(pm->clock);
+		if (ret)
+			goto err_gate;
+	}
+
+	if (pm->use_clock_gating)
+		clk_disable(pm->clock_gate);
+	return 0;
+
+err_gate:
+	clk_disable_unprepare(pm->clock_gate);
+err_pm:
+	pm_runtime_put_sync(pm->device);
 	return ret;
+
 }
 
 int s5p_mfc_power_off(void)
 {
-	if (!pm->use_clock_gating)
-		clk_disable(pm->clock_gate);
+	if (pm->clock)
+		clk_disable_unprepare(pm->clock);
+
+	if (pm->use_clock_gating)
+		clk_unprepare(pm->clock_gate);
+	else
+		clk_disable_unprepare(pm->clock_gate);
+
 	return pm_runtime_put_sync(pm->device);
 }
 
-
-- 
1.9.1

