Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57031 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753047AbeBSPpJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 10:45:09 -0500
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
Subject: [PATCH 5/8] drm/exynos: mic: Use clk bulk API
Date: Mon, 19 Feb 2018 16:44:03 +0100
Message-id: <1519055046-2399-6-git-send-email-m.purski@samsung.com>
In-reply-to: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
References: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
        <CGME20180219154500eucas1p25e9f3bf44901cb2bbe9720cdc5bdd855@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using bulk clk functions simplifies the driver's code. Use devm_clk_bulk
functions instead of iterating over an array of clks.

Signed-off-by: Maciej Purski <m.purski@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_mic.c | 41 +++++++++++----------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_mic.c b/drivers/gpu/drm/exynos/exynos_drm_mic.c
index 2174814..276558a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_mic.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_mic.c
@@ -88,7 +88,7 @@
 
 #define MIC_BS_SIZE_2D(x)	((x) & 0x3fff)
 
-static char *clk_names[] = { "pclk_mic0", "sclk_rgb_vclk_to_mic0" };
+static const char *const clk_names[] = { "pclk_mic0", "sclk_rgb_vclk_to_mic0" };
 #define NUM_CLKS		ARRAY_SIZE(clk_names)
 static DEFINE_MUTEX(mic_mutex);
 
@@ -96,7 +96,7 @@ struct exynos_mic {
 	struct device *dev;
 	void __iomem *reg;
 	struct regmap *sysreg;
-	struct clk *clks[NUM_CLKS];
+	struct clk_bulk_data *clks;
 
 	bool i80_mode;
 	struct videomode vm;
@@ -338,10 +338,8 @@ static const struct component_ops exynos_mic_component_ops = {
 static int exynos_mic_suspend(struct device *dev)
 {
 	struct exynos_mic *mic = dev_get_drvdata(dev);
-	int i;
 
-	for (i = NUM_CLKS - 1; i > -1; i--)
-		clk_disable_unprepare(mic->clks[i]);
+	clk_bulk_disable_unprepare(NUM_CLKS, mic->clks);
 
 	return 0;
 }
@@ -349,19 +347,8 @@ static int exynos_mic_suspend(struct device *dev)
 static int exynos_mic_resume(struct device *dev)
 {
 	struct exynos_mic *mic = dev_get_drvdata(dev);
-	int ret, i;
-
-	for (i = 0; i < NUM_CLKS; i++) {
-		ret = clk_prepare_enable(mic->clks[i]);
-		if (ret < 0) {
-			DRM_ERROR("Failed to enable clock (%s)\n",
-							clk_names[i]);
-			while (--i > -1)
-				clk_disable_unprepare(mic->clks[i]);
-			return ret;
-		}
-	}
-	return 0;
+
+	return clk_bulk_prepare_enable(NUM_CLKS, mic->clks);
 }
 #endif
 
@@ -374,7 +361,7 @@ static int exynos_mic_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct exynos_mic *mic;
 	struct resource res;
-	int ret, i;
+	int ret;
 
 	mic = devm_kzalloc(dev, sizeof(*mic), GFP_KERNEL);
 	if (!mic) {
@@ -405,16 +392,16 @@ static int exynos_mic_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	for (i = 0; i < NUM_CLKS; i++) {
-		mic->clks[i] = devm_clk_get(dev, clk_names[i]);
-		if (IS_ERR(mic->clks[i])) {
-			DRM_ERROR("mic: Failed to get clock (%s)\n",
-								clk_names[i]);
-			ret = PTR_ERR(mic->clks[i]);
-			goto err;
-		}
+	mic->clks = devm_clk_bulk_alloc(dev, NUM_CLKS, clk_names);
+	if (IS_ERR(mic->clks)) {
+		ret = PTR_ERR(mic->clks);
+		goto err;
 	}
 
+	ret = devm_clk_bulk_get(dev, NUM_CLKS, mic->clks);
+	if (ret < 0)
+		goto err;
+
 	platform_set_drvdata(pdev, mic);
 
 	mic->bridge.funcs = &mic_bridge_funcs;
-- 
2.7.4
