Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57448 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752648AbcKPJF1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 04:05:27 -0500
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
Subject: [PATCH 5/9] s5p-mfc: Remove dead conditional code
Date: Wed, 16 Nov 2016 10:04:54 +0100
Message-id: <1479287098-30493-6-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
References: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161116090520eucas1p151e1da5cba8c5b85f9fe63e77650c091@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_PM is always enabled on Exynos platforms, so remove dead code
related to early development of MFC driver on platform without PM support.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 22 ------------------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     | 30 +++++--------------------
 3 files changed, 5 insertions(+), 48 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 30ceae7eabc5..72af819a4f47 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1404,31 +1404,9 @@ static int s5p_mfc_resume(struct device *dev)
 }
 #endif
 
-#ifdef CONFIG_PM
-static int s5p_mfc_runtime_suspend(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct s5p_mfc_dev *m_dev = platform_get_drvdata(pdev);
-
-	atomic_set(&m_dev->pm.power, 0);
-	return 0;
-}
-
-static int s5p_mfc_runtime_resume(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct s5p_mfc_dev *m_dev = platform_get_drvdata(pdev);
-
-	atomic_set(&m_dev->pm.power, 1);
-	return 0;
-}
-#endif
-
 /* Power management */
 static const struct dev_pm_ops s5p_mfc_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(s5p_mfc_suspend, s5p_mfc_resume)
-	SET_RUNTIME_PM_OPS(s5p_mfc_runtime_suspend, s5p_mfc_runtime_resume,
-			   NULL)
 };
 
 static struct s5p_mfc_buf_size_v5 mfc_buf_size_v5 = {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index c068ee3ece6e..58b15c212dd2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -200,7 +200,6 @@ struct s5p_mfc_pm {
 	struct clk	*clock;
 	struct clk	*clock_gate;
 	bool		use_clock_gating;
-	atomic_t	power;
 	struct device	*device;
 };
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 818c04646061..11a918eb7564 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -21,14 +21,9 @@
 #define MFC_GATE_CLK_NAME	"mfc"
 #define MFC_SCLK_NAME		"sclk_mfc"
 
-#define CLK_DEBUG
-
 static struct s5p_mfc_pm *pm;
 static struct s5p_mfc_dev *p_dev;
-
-#ifdef CLK_DEBUG
 static atomic_t clk_ref;
-#endif
 
 int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 {
@@ -64,14 +59,10 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 		}
 	}
 
-	atomic_set(&pm->power, 0);
-#ifdef CONFIG_PM
 	pm->device = &dev->plat_dev->dev;
 	pm_runtime_enable(pm->device);
-#endif
-#ifdef CLK_DEBUG
 	atomic_set(&clk_ref, 0);
-#endif
+
 	return 0;
 
 err_s_clk:
@@ -95,18 +86,16 @@ void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)
 	clk_unprepare(pm->clock_gate);
 	clk_put(pm->clock_gate);
 	pm->clock_gate = NULL;
-#ifdef CONFIG_PM
 	pm_runtime_disable(pm->device);
-#endif
 }
 
 int s5p_mfc_clock_on(void)
 {
 	int ret = 0;
-#ifdef CLK_DEBUG
+
 	atomic_inc(&clk_ref);
 	mfc_debug(3, "+ %d\n", atomic_read(&clk_ref));
-#endif
+
 	if (!pm->use_clock_gating)
 		return 0;
 	if (!IS_ERR_OR_NULL(pm->clock_gate))
@@ -116,10 +105,9 @@ int s5p_mfc_clock_on(void)
 
 void s5p_mfc_clock_off(void)
 {
-#ifdef CLK_DEBUG
 	atomic_dec(&clk_ref);
 	mfc_debug(3, "- %d\n", atomic_read(&clk_ref));
-#endif
+
 	if (!pm->use_clock_gating)
 		return;
 	if (!IS_ERR_OR_NULL(pm->clock_gate))
@@ -130,13 +118,10 @@ int s5p_mfc_power_on(void)
 {
 	int ret = 0;
 
-#ifdef CONFIG_PM
 	ret = pm_runtime_get_sync(pm->device);
 	if (ret)
 		return ret;
-#else
-	atomic_set(&pm->power, 1);
-#endif
+
 	if (!pm->use_clock_gating && !IS_ERR_OR_NULL(pm->clock_gate))
 		ret = clk_enable(pm->clock_gate);
 	return ret;
@@ -146,12 +131,7 @@ int s5p_mfc_power_off(void)
 {
 	if (!pm->use_clock_gating && !IS_ERR_OR_NULL(pm->clock_gate))
 		clk_disable(pm->clock_gate);
-#ifdef CONFIG_PM
 	return pm_runtime_put_sync(pm->device);
-#else
-	atomic_set(&pm->power, 0);
-	return 0;
-#endif
 }
 
 
-- 
1.9.1

