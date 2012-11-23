Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64565 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2KWL5R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:57:17 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so3502852pad.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 03:57:17 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 6/6] [media] s5p-mfc: Use devm_clk_get APIs
Date: Fri, 23 Nov 2012 17:20:43 +0530
Message-Id: <1353671443-2978-7-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
References: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_clk_get() is device managed function and makes error handling
and exit code a bit simpler.

Cc: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 2895333..4864d93 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -37,7 +37,7 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 
 	pm = &dev->pm;
 	p_dev = dev;
-	pm->clock_gate = clk_get(&dev->plat_dev->dev, MFC_GATE_CLK_NAME);
+	pm->clock_gate = devm_clk_get(&dev->plat_dev->dev, MFC_GATE_CLK_NAME);
 	if (IS_ERR(pm->clock_gate)) {
 		mfc_err("Failed to get clock-gating control\n");
 		ret = PTR_ERR(pm->clock_gate);
@@ -47,10 +47,10 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 	ret = clk_prepare(pm->clock_gate);
 	if (ret) {
 		mfc_err("Failed to preapre clock-gating control\n");
-		goto err_p_ip_clk;
+		goto err_g_ip_clk;
 	}
 
-	pm->clock = clk_get(&dev->plat_dev->dev, dev->variant->mclk_name);
+	pm->clock = devm_clk_get(&dev->plat_dev->dev, dev->variant->mclk_name);
 	if (IS_ERR(pm->clock)) {
 		mfc_err("Failed to get MFC clock\n");
 		ret = PTR_ERR(pm->clock);
@@ -60,7 +60,7 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 	ret = clk_prepare(pm->clock);
 	if (ret) {
 		mfc_err("Failed to prepare MFC clock\n");
-		goto err_p_ip_clk_2;
+		goto err_g_ip_clk_2;
 	}
 
 	atomic_set(&pm->power, 0);
@@ -72,12 +72,8 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 	atomic_set(&clk_ref, 0);
 #endif
 	return 0;
-err_p_ip_clk_2:
-	clk_put(pm->clock);
 err_g_ip_clk_2:
 	clk_unprepare(pm->clock_gate);
-err_p_ip_clk:
-	clk_put(pm->clock_gate);
 err_g_ip_clk:
 	return ret;
 }
@@ -85,9 +81,7 @@ err_g_ip_clk:
 void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)
 {
 	clk_unprepare(pm->clock_gate);
-	clk_put(pm->clock_gate);
 	clk_unprepare(pm->clock);
-	clk_put(pm->clock);
 #ifdef CONFIG_PM_RUNTIME
 	pm_runtime_disable(pm->device);
 #endif
-- 
1.7.4.1

