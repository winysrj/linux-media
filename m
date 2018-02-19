Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57043 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752602AbeBSPpK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 10:45:10 -0500
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
Subject: [PATCH 6/8] drm/exynos/hdmi: Use clk bulk API
Date: Mon, 19 Feb 2018 16:44:04 +0100
Message-id: <1519055046-2399-7-git-send-email-m.purski@samsung.com>
In-reply-to: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
References: <1519055046-2399-1-git-send-email-m.purski@samsung.com>
        <CGME20180219154501eucas1p1e16a883d2eb0c8a99bafce5d71656066@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using bulk clk functions simplifies the driver's code. Use devm_clk_bulk
functions instead of iterating over an array of clks.

Signed-off-by: Maciej Purski <m.purski@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c | 97 ++++++++++--------------------------
 1 file changed, 27 insertions(+), 70 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index a4b75a4..6c208f7 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -136,8 +136,8 @@ struct hdmi_context {
 	int				irq;
 	struct regmap			*pmureg;
 	struct regmap			*sysreg;
-	struct clk			**clk_gates;
-	struct clk			**clk_muxes;
+	struct clk_bulk_data		*clk_gates;
+	struct clk_bulk_data		*clk_muxes;
 	struct regulator_bulk_data	regul_bulk[ARRAY_SIZE(supply)];
 	struct regulator		*reg_hdmi_en;
 	struct exynos_drm_clk		phy_clk;
@@ -739,43 +739,16 @@ static int hdmiphy_reg_write_buf(struct hdmi_context *hdata,
 	}
 }
 
-static int hdmi_clk_enable_gates(struct hdmi_context *hdata)
-{
-	int i, ret;
-
-	for (i = 0; i < hdata->drv_data->clk_gates.count; ++i) {
-		ret = clk_prepare_enable(hdata->clk_gates[i]);
-		if (!ret)
-			continue;
-
-		dev_err(hdata->dev, "Cannot enable clock '%s', %d\n",
-			hdata->drv_data->clk_gates.data[i], ret);
-		while (i--)
-			clk_disable_unprepare(hdata->clk_gates[i]);
-		return ret;
-	}
-
-	return 0;
-}
-
-static void hdmi_clk_disable_gates(struct hdmi_context *hdata)
-{
-	int i = hdata->drv_data->clk_gates.count;
-
-	while (i--)
-		clk_disable_unprepare(hdata->clk_gates[i]);
-}
-
 static int hdmi_clk_set_parents(struct hdmi_context *hdata, bool to_phy)
 {
 	struct device *dev = hdata->dev;
 	int ret = 0;
+	struct clk_bulk_data *clk_muxes = hdata->clk_muxes;
 	int i;
 
 	for (i = 0; i < hdata->drv_data->clk_muxes.count; i += 3) {
-		struct clk **c = &hdata->clk_muxes[i];
-
-		ret = clk_set_parent(c[2], c[to_phy]);
+		ret = clk_set_parent(clk_muxes[i + 2].clk,
+				     clk_muxes[i + to_phy].clk);
 		if (!ret)
 			continue;
 
@@ -1655,54 +1628,36 @@ static irqreturn_t hdmi_irq_thread(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static int hdmi_clks_get(struct hdmi_context *hdata,
-			 const struct string_array_spec *names,
-			 struct clk **clks)
+static struct clk_bulk_data *hdmi_clks_alloc_get(struct hdmi_context *hdata,
+					const struct string_array_spec *names)
 {
-	struct device *dev = hdata->dev;
-	int i;
-
-	for (i = 0; i < names->count; ++i) {
-		struct clk *clk = devm_clk_get(dev, names->data[i]);
-
-		if (IS_ERR(clk)) {
-			int ret = PTR_ERR(clk);
+	struct clk_bulk_data *ptr;
+	int ret;
 
-			dev_err(dev, "Cannot get clock %s, %d\n",
-				names->data[i], ret);
+	ptr = devm_clk_bulk_alloc(hdata->dev, names->count, names->data);
+	if (IS_ERR(ptr))
+		return ptr;
 
-			return ret;
-		}
-
-		clks[i] = clk;
-	}
+	ret = devm_clk_bulk_get(hdata->dev, names->count, ptr);
+	if (ret < 0)
+		return ERR_PTR(ret);
 
-	return 0;
+	return ptr;
 }
 
 static int hdmi_clk_init(struct hdmi_context *hdata)
 {
 	const struct hdmi_driver_data *drv_data = hdata->drv_data;
-	int count = drv_data->clk_gates.count + drv_data->clk_muxes.count;
-	struct device *dev = hdata->dev;
-	struct clk **clks;
-	int ret;
 
-	if (!count)
-		return 0;
-
-	clks = devm_kzalloc(dev, sizeof(*clks) * count, GFP_KERNEL);
-	if (!clks)
-		return -ENOMEM;
+	hdata->clk_muxes = hdmi_clks_alloc_get(hdata, &drv_data->clk_muxes);
+	if (IS_ERR(hdata->clk_muxes))
+		return PTR_ERR(hdata->clk_muxes);
 
-	hdata->clk_gates = clks;
-	hdata->clk_muxes = clks + drv_data->clk_gates.count;
+	hdata->clk_gates = hdmi_clks_alloc_get(hdata, &drv_data->clk_gates);
+	if (IS_ERR(hdata->clk_gates))
+		return PTR_ERR(hdata->clk_gates);
 
-	ret = hdmi_clks_get(hdata, &drv_data->clk_gates, hdata->clk_gates);
-	if (ret)
-		return ret;
-
-	return hdmi_clks_get(hdata, &drv_data->clk_muxes, hdata->clk_muxes);
+	return 0;
 }
 
 
@@ -2073,7 +2028,8 @@ static int __maybe_unused exynos_hdmi_suspend(struct device *dev)
 {
 	struct hdmi_context *hdata = dev_get_drvdata(dev);
 
-	hdmi_clk_disable_gates(hdata);
+	clk_bulk_disable_unprepare(hdata->drv_data->clk_gates.count,
+				   hdata->clk_gates);
 
 	return 0;
 }
@@ -2083,7 +2039,8 @@ static int __maybe_unused exynos_hdmi_resume(struct device *dev)
 	struct hdmi_context *hdata = dev_get_drvdata(dev);
 	int ret;
 
-	ret = hdmi_clk_enable_gates(hdata);
+	ret = clk_bulk_prepare_enable(hdata->drv_data->clk_gates.count,
+				      hdata->clk_gates);
 	if (ret < 0)
 		return ret;
 
-- 
2.7.4
