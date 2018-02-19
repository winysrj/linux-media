Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59827 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753106AbeBSPpL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 10:45:11 -0500
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
Subject: [PATCH 8/8] [media] s5p-mfc: Use clk bulk API
Date: Mon, 19 Feb 2018 16:44:06 +0100
Message-id: <1519055046-2399-9-git-send-email-m.purski@samsung.com>
In-reply-to: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
References: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
        <CGME20180219154503eucas1p1c8893411994bd1152d0ce5b386118416@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using bulk clk functions simplifies the driver's code. Use devm_clk_bulk
functions instead of iterating over an array of clks.

Signed-off-by: Maciej Purski <m.purski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  6 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     | 41 +++++++++----------------
 2 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 76119a8..da3f0b3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -192,9 +192,9 @@ struct s5p_mfc_buf {
  * struct s5p_mfc_pm - power management data structure
  */
 struct s5p_mfc_pm {
-	struct clk	*clock_gate;
-	const char * const *clk_names;
-	struct clk	*clocks[MFC_MAX_CLOCKS];
+	struct clk		*clock_gate;
+	const char * const	*clk_names;
+	struct clk_bulk_data	*clocks;
 	int		num_clocks;
 	bool		use_clock_gating;
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index eb85ced..857f6ea 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -24,7 +24,7 @@ static atomic_t clk_ref;
 
 int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 {
-	int i;
+	int ret;
 
 	pm = &dev->pm;
 	p_dev = dev;
@@ -35,17 +35,17 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 	pm->clock_gate = NULL;
 
 	/* clock control */
-	for (i = 0; i < pm->num_clocks; i++) {
-		pm->clocks[i] = devm_clk_get(pm->device, pm->clk_names[i]);
-		if (IS_ERR(pm->clocks[i])) {
-			mfc_err("Failed to get clock: %s\n",
-				pm->clk_names[i]);
-			return PTR_ERR(pm->clocks[i]);
-		}
-	}
+	pm->clocks = devm_clk_bulk_alloc(pm->device, pm->num_clocks,
+					 pm->clk_names);
+	if (IS_ERR(pm->clocks))
+		return PTR_ERR(pm->clocks);
+
+	ret = devm_clk_bulk_get(pm->device, pm->num_clocks, pm->clocks);
+	if (ret < 0)
+		return ret;
 
 	if (dev->variant->use_clock_gating)
-		pm->clock_gate = pm->clocks[0];
+		pm->clock_gate = pm->clocks[0].clk;
 
 	pm_runtime_enable(pm->device);
 	atomic_set(&clk_ref, 0);
@@ -75,43 +75,32 @@ void s5p_mfc_clock_off(void)
 
 int s5p_mfc_power_on(void)
 {
-	int i, ret = 0;
+	int ret = 0;
 
 	ret = pm_runtime_get_sync(pm->device);
 	if (ret < 0)
 		return ret;
 
 	/* clock control */
-	for (i = 0; i < pm->num_clocks; i++) {
-		ret = clk_prepare_enable(pm->clocks[i]);
-		if (ret < 0) {
-			mfc_err("clock prepare failed for clock: %s\n",
-				pm->clk_names[i]);
-			i++;
-			goto err;
-		}
-	}
+	ret = clk_bulk_prepare_enable(pm->num_clocks, pm->clocks);
+	if (ret < 0)
+		goto err;
 
 	/* prepare for software clock gating */
 	clk_disable(pm->clock_gate);
 
 	return 0;
 err:
-	while (--i > 0)
-		clk_disable_unprepare(pm->clocks[i]);
 	pm_runtime_put(pm->device);
 	return ret;
 }
 
 int s5p_mfc_power_off(void)
 {
-	int i;
-
 	/* finish software clock gating */
 	clk_enable(pm->clock_gate);
 
-	for (i = 0; i < pm->num_clocks; i++)
-		clk_disable_unprepare(pm->clocks[i]);
+	clk_bulk_disable_unprepare(pm->num_clocks, pm->clocks);
 
 	return pm_runtime_put_sync(pm->device);
 }
-- 
2.7.4
