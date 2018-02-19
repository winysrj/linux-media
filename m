Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57023 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753034AbeBSPpI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 10:45:08 -0500
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
Subject: [PATCH 4/8] drm/exynos/dsi: Use clk bulk API
Date: Mon, 19 Feb 2018 16:44:02 +0100
Message-id: <1519055046-2399-5-git-send-email-m.purski@samsung.com>
In-reply-to: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
References: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
        <CGME20180219154459eucas1p147525b88de5d34f646aa25cb8de1f1d0@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using bulk clk functions simplifies the driver's code. Use devm_clk_bulk
functions instead of iterating over an array of clks.

In order to achieve consistency with other drivers, define clock names
in driver's variants structures.

Signed-off-by: Maciej Purski <m.purski@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_dsi.c | 68 +++++++++++++++------------------
 1 file changed, 30 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index 7904ffa..46a8b5c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -209,11 +209,7 @@
 #define DSI_XFER_TIMEOUT_MS		100
 #define DSI_RX_FIFO_EMPTY		0x30800002
 
-#define OLD_SCLK_MIPI_CLK_NAME "pll_clk"
-
-static char *clk_names[5] = { "bus_clk", "sclk_mipi",
-	"phyclk_mipidphy0_bitclkdiv8", "phyclk_mipidphy0_rxclkesc0",
-	"sclk_rgb_vclk_to_dsim0" };
+#define DSI_MAX_CLOCKS			5
 
 enum exynos_dsi_transfer_type {
 	EXYNOS_DSI_TX,
@@ -243,6 +239,7 @@ struct exynos_dsi_driver_data {
 	unsigned int plltmr_reg;
 	unsigned int has_freqband:1;
 	unsigned int has_clklane_stop:1;
+	const char *clock_names[DSI_MAX_CLOCKS];
 	unsigned int num_clks;
 	unsigned int max_freq;
 	unsigned int wait_for_reset;
@@ -259,7 +256,7 @@ struct exynos_dsi {
 
 	void __iomem *reg_base;
 	struct phy *phy;
-	struct clk **clks;
+	struct clk_bulk_data *clks;
 	struct regulator_bulk_data supplies[2];
 	int irq;
 	int te_gpio;
@@ -453,6 +450,7 @@ static const struct exynos_dsi_driver_data exynos3_dsi_driver_data = {
 	.plltmr_reg = 0x50,
 	.has_freqband = 1,
 	.has_clklane_stop = 1,
+	.clock_names = {"bus_clk", "pll_clk"},
 	.num_clks = 2,
 	.max_freq = 1000,
 	.wait_for_reset = 1,
@@ -465,6 +463,7 @@ static const struct exynos_dsi_driver_data exynos4_dsi_driver_data = {
 	.plltmr_reg = 0x50,
 	.has_freqband = 1,
 	.has_clklane_stop = 1,
+	.clock_names = {"bus_clk", "sclk_mipi"},
 	.num_clks = 2,
 	.max_freq = 1000,
 	.wait_for_reset = 1,
@@ -475,6 +474,7 @@ static const struct exynos_dsi_driver_data exynos4_dsi_driver_data = {
 static const struct exynos_dsi_driver_data exynos5_dsi_driver_data = {
 	.reg_ofs = exynos_reg_ofs,
 	.plltmr_reg = 0x58,
+	.clock_names = {"bus_clk", "pll_clk"},
 	.num_clks = 2,
 	.max_freq = 1000,
 	.wait_for_reset = 1,
@@ -486,6 +486,10 @@ static const struct exynos_dsi_driver_data exynos5433_dsi_driver_data = {
 	.reg_ofs = exynos5433_reg_ofs,
 	.plltmr_reg = 0xa0,
 	.has_clklane_stop = 1,
+	.clock_names = {"bus_clk", "phyclk_mipidphy0_bitclkdiv8",
+			"phyclk_mipidphy0_rxclkesc0",
+			"sclk_rgb_vclk_to_dsim0",
+			"sclk_mipi"},
 	.num_clks = 5,
 	.max_freq = 1500,
 	.wait_for_reset = 0,
@@ -497,6 +501,7 @@ static const struct exynos_dsi_driver_data exynos5422_dsi_driver_data = {
 	.reg_ofs = exynos5433_reg_ofs,
 	.plltmr_reg = 0xa0,
 	.has_clklane_stop = 1,
+	.clock_names = {"bus_clk", "pll_clk"},
 	.num_clks = 2,
 	.max_freq = 1500,
 	.wait_for_reset = 1,
@@ -1711,7 +1716,7 @@ static int exynos_dsi_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct resource *res;
 	struct exynos_dsi *dsi;
-	int ret, i;
+	int ret;
 
 	dsi = devm_kzalloc(dev, sizeof(*dsi), GFP_KERNEL);
 	if (!dsi)
@@ -1743,26 +1748,15 @@ static int exynos_dsi_probe(struct platform_device *pdev)
 		return -EPROBE_DEFER;
 	}
 
-	dsi->clks = devm_kzalloc(dev,
-			sizeof(*dsi->clks) * dsi->driver_data->num_clks,
-			GFP_KERNEL);
-	if (!dsi->clks)
-		return -ENOMEM;
+	dsi->clks = devm_clk_bulk_alloc(dev, dsi->driver_data->num_clks,
+					dsi->driver_data->clock_names);
+	if (IS_ERR(dsi->clks))
+		return PTR_ERR(dsi->clks);
 
-	for (i = 0; i < dsi->driver_data->num_clks; i++) {
-		dsi->clks[i] = devm_clk_get(dev, clk_names[i]);
-		if (IS_ERR(dsi->clks[i])) {
-			if (strcmp(clk_names[i], "sclk_mipi") == 0) {
-				strcpy(clk_names[i], OLD_SCLK_MIPI_CLK_NAME);
-				i--;
-				continue;
-			}
-
-			dev_info(dev, "failed to get the clock: %s\n",
-					clk_names[i]);
-			return PTR_ERR(dsi->clks[i]);
-		}
-	}
+	ret = devm_clk_bulk_get(dev, dsi->driver_data->num_clks,
+				dsi->clks);
+	if (ret < 0)
+		return ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dsi->reg_base = devm_ioremap_resource(dev, res);
@@ -1817,7 +1811,7 @@ static int __maybe_unused exynos_dsi_suspend(struct device *dev)
 	struct drm_encoder *encoder = dev_get_drvdata(dev);
 	struct exynos_dsi *dsi = encoder_to_dsi(encoder);
 	const struct exynos_dsi_driver_data *driver_data = dsi->driver_data;
-	int ret, i;
+	int ret;
 
 	usleep_range(10000, 20000);
 
@@ -1833,8 +1827,7 @@ static int __maybe_unused exynos_dsi_suspend(struct device *dev)
 
 	phy_power_off(dsi->phy);
 
-	for (i = driver_data->num_clks - 1; i > -1; i--)
-		clk_disable_unprepare(dsi->clks[i]);
+	clk_bulk_disable_unprepare(driver_data->num_clks, dsi->clks);
 
 	ret = regulator_bulk_disable(ARRAY_SIZE(dsi->supplies), dsi->supplies);
 	if (ret < 0)
@@ -1848,7 +1841,7 @@ static int __maybe_unused exynos_dsi_resume(struct device *dev)
 	struct drm_encoder *encoder = dev_get_drvdata(dev);
 	struct exynos_dsi *dsi = encoder_to_dsi(encoder);
 	const struct exynos_dsi_driver_data *driver_data = dsi->driver_data;
-	int ret, i;
+	int ret;
 
 	ret = regulator_bulk_enable(ARRAY_SIZE(dsi->supplies), dsi->supplies);
 	if (ret < 0) {
@@ -1856,23 +1849,22 @@ static int __maybe_unused exynos_dsi_resume(struct device *dev)
 		return ret;
 	}
 
-	for (i = 0; i < driver_data->num_clks; i++) {
-		ret = clk_prepare_enable(dsi->clks[i]);
-		if (ret < 0)
-			goto err_clk;
-	}
+	ret = clk_bulk_prepare_enable(driver_data->num_clks, dsi->clks);
+	if (ret < 0)
+		goto err_clk;
 
 	ret = phy_power_on(dsi->phy);
 	if (ret < 0) {
 		dev_err(dsi->dev, "cannot enable phy %d\n", ret);
-		goto err_clk;
+		goto err_phy;
 	}
 
 	return 0;
 
+err_phy:
+	clk_bulk_disable_unprepare(driver_data->num_clks, dsi->clks);
+
 err_clk:
-	while (--i > -1)
-		clk_disable_unprepare(dsi->clks[i]);
 	regulator_bulk_disable(ARRAY_SIZE(dsi->supplies), dsi->supplies);
 
 	return ret;
-- 
2.7.4
