Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57066 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934094AbcKPJFj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 04:05:39 -0500
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
Subject: [PATCH 8/9] s5p-mfc: Rework clock handling
Date: Wed, 16 Nov 2016 10:04:57 +0100
Message-id: <1479287098-30493-9-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
References: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161116090522eucas1p2110bfe357718cfb5aebd750201a1b22e@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch changes the code for handling clocks. Now clocks are defined
per each device variant, what is a preparation for adding support for
Exynos 5433 MFC V8, which has more clocks than all previous versions.
Also use devm_clk_get() to simplify cleanup path.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  8 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  9 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     | 98 ++++++++++---------------
 3 files changed, 56 insertions(+), 59 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 72af819a4f47..fa674e8e09a8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1433,6 +1433,8 @@ static int s5p_mfc_resume(struct device *dev)
 	.buf_size	= &buf_size_v5,
 	.buf_align	= &mfc_buf_align_v5,
 	.fw_name[0]	= "s5p-mfc.fw",
+	.clk_names	= {"mfc", "sclk_mfc"},
+	.num_clocks	= 2,
 	.use_clock_gating = true,
 };
 
@@ -1466,6 +1468,8 @@ static int s5p_mfc_resume(struct device *dev)
 	 * for init buffer command
 	 */
 	.fw_name[1]     = "s5p-mfc-v6-v2.fw",
+	.clk_names	= {"mfc"},
+	.num_clocks	= 1,
 };
 
 static struct s5p_mfc_buf_size_v6 mfc_buf_size_v7 = {
@@ -1493,6 +1497,8 @@ static int s5p_mfc_resume(struct device *dev)
 	.buf_size	= &buf_size_v7,
 	.buf_align	= &mfc_buf_align_v7,
 	.fw_name[0]     = "s5p-mfc-v7.fw",
+	.clk_names	= {"mfc", "sclk_mfc"},
+	.num_clocks	= 2,
 };
 
 static struct s5p_mfc_buf_size_v6 mfc_buf_size_v8 = {
@@ -1520,6 +1526,8 @@ static int s5p_mfc_resume(struct device *dev)
 	.buf_size	= &buf_size_v8,
 	.buf_align	= &mfc_buf_align_v8,
 	.fw_name[0]     = "s5p-mfc-v8.fw",
+	.clk_names	= {"mfc"},
+	.num_clocks	= 1,
 };
 
 static const struct of_device_id exynos_mfc_match[] = {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 58b15c212dd2..ab23236aa942 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -104,6 +104,8 @@ static inline dma_addr_t s5p_mfc_mem_cookie(void *a, void *b)
 #define S5P_MFC_R2H_CMD_ENC_BUFFER_FUL_RET	16
 #define S5P_MFC_R2H_CMD_ERR_RET			32
 
+#define MFC_MAX_CLOCKS		4
+
 #define mfc_read(dev, offset)		readl(dev->regs_base + (offset))
 #define mfc_write(dev, data, offset)	writel((data), dev->regs_base + \
 								(offset))
@@ -197,9 +199,12 @@ struct s5p_mfc_buf {
  * struct s5p_mfc_pm - power management data structure
  */
 struct s5p_mfc_pm {
-	struct clk	*clock;
 	struct clk	*clock_gate;
+	const char	**clk_names;
+	struct clk	*clocks[MFC_MAX_CLOCKS];
+	int		num_clocks;
 	bool		use_clock_gating;
+
 	struct device	*device;
 };
 
@@ -235,6 +240,8 @@ struct s5p_mfc_variant {
 	struct s5p_mfc_buf_size *buf_size;
 	struct s5p_mfc_buf_align *buf_align;
 	char	*fw_name[MFC_FW_MAX_VERSIONS];
+	const char	*clk_names[MFC_MAX_CLOCKS];
+	int		num_clocks;
 	bool		use_clock_gating;
 };
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 796dac85746a..eb85cedc5ef3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -18,56 +18,42 @@
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_pm.h"
 
-#define MFC_GATE_CLK_NAME	"mfc"
-#define MFC_SCLK_NAME		"sclk_mfc"
-
 static struct s5p_mfc_pm *pm;
 static struct s5p_mfc_dev *p_dev;
 static atomic_t clk_ref;
 
 int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 {
-	int ret = 0;
+	int i;
 
 	pm = &dev->pm;
 	p_dev = dev;
-	pm->use_clock_gating = dev->variant->use_clock_gating;
-	pm->clock_gate = clk_get(&dev->plat_dev->dev, MFC_GATE_CLK_NAME);
-	if (IS_ERR(pm->clock_gate)) {
-		mfc_err("Failed to get clock-gating control\n");
-		ret = PTR_ERR(pm->clock_gate);
-		goto err_g_ip_clk;
-	}
 
-	if (dev->variant->version != MFC_VERSION_V6) {
-		pm->clock = clk_get(&dev->plat_dev->dev, MFC_SCLK_NAME);
-		if (IS_ERR(pm->clock)) {
-			mfc_info("Failed to get MFC special clock control\n");
-			pm->clock = NULL;
+	pm->num_clocks = dev->variant->num_clocks;
+	pm->clk_names = dev->variant->clk_names;
+	pm->device = &dev->plat_dev->dev;
+	pm->clock_gate = NULL;
+
+	/* clock control */
+	for (i = 0; i < pm->num_clocks; i++) {
+		pm->clocks[i] = devm_clk_get(pm->device, pm->clk_names[i]);
+		if (IS_ERR(pm->clocks[i])) {
+			mfc_err("Failed to get clock: %s\n",
+				pm->clk_names[i]);
+			return PTR_ERR(pm->clocks[i]);
 		}
 	}
 
-	pm->device = &dev->plat_dev->dev;
+	if (dev->variant->use_clock_gating)
+		pm->clock_gate = pm->clocks[0];
+
 	pm_runtime_enable(pm->device);
 	atomic_set(&clk_ref, 0);
-
 	return 0;
-
-	clk_put(pm->clock_gate);
-	pm->clock_gate = NULL;
-err_g_ip_clk:
-	return ret;
 }
 
 void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)
 {
-	if (dev->variant->version != MFC_VERSION_V6 &&
-	    pm->clock) {
-		clk_put(pm->clock);
-		pm->clock = NULL;
-	}
-	clk_put(pm->clock_gate);
-	pm->clock_gate = NULL;
 	pm_runtime_disable(pm->device);
 }
 
@@ -76,8 +62,6 @@ int s5p_mfc_clock_on(void)
 	atomic_inc(&clk_ref);
 	mfc_debug(3, "+ %d\n", atomic_read(&clk_ref));
 
-	if (!pm->use_clock_gating)
-		return 0;
 	return clk_enable(pm->clock_gate);
 }
 
@@ -86,50 +70,48 @@ void s5p_mfc_clock_off(void)
 	atomic_dec(&clk_ref);
 	mfc_debug(3, "- %d\n", atomic_read(&clk_ref));
 
-	if (!pm->use_clock_gating)
-		return;
 	clk_disable(pm->clock_gate);
 }
 
 int s5p_mfc_power_on(void)
 {
-	int ret;
+	int i, ret = 0;
 
 	ret = pm_runtime_get_sync(pm->device);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
-	ret = clk_prepare_enable(pm->clock_gate);
-	if (ret)
-		goto err_pm;
-
-	if (pm->clock) {
-		ret = clk_prepare_enable(pm->clock);
-		if (ret)
-			goto err_gate;
+	/* clock control */
+	for (i = 0; i < pm->num_clocks; i++) {
+		ret = clk_prepare_enable(pm->clocks[i]);
+		if (ret < 0) {
+			mfc_err("clock prepare failed for clock: %s\n",
+				pm->clk_names[i]);
+			i++;
+			goto err;
+		}
 	}
 
-	if (pm->use_clock_gating)
-		clk_disable(pm->clock_gate);
-	return 0;
+	/* prepare for software clock gating */
+	clk_disable(pm->clock_gate);
 
-err_gate:
-	clk_disable_unprepare(pm->clock_gate);
-err_pm:
-	pm_runtime_put_sync(pm->device);
+	return 0;
+err:
+	while (--i > 0)
+		clk_disable_unprepare(pm->clocks[i]);
+	pm_runtime_put(pm->device);
 	return ret;
-
 }
 
 int s5p_mfc_power_off(void)
 {
-	if (pm->clock)
-		clk_disable_unprepare(pm->clock);
+	int i;
+
+	/* finish software clock gating */
+	clk_enable(pm->clock_gate);
 
-	if (pm->use_clock_gating)
-		clk_unprepare(pm->clock_gate);
-	else
-		clk_disable_unprepare(pm->clock_gate);
+	for (i = 0; i < pm->num_clocks; i++)
+		clk_disable_unprepare(pm->clocks[i]);
 
 	return pm_runtime_put_sync(pm->device);
 }
-- 
1.9.1

