Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:16916 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab3F1FYX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 01:24:23 -0400
From: Jingoo Han <jg1.han@samsung.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: 'Kishon Vijay Abraham I' <kishon@ti.com>,
	linux-media@vger.kernel.org, 'Kukjin Kim' <kgene.kim@samsung.com>,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Tomasz Figa' <t.figa@samsung.com>,
	devicetree-discuss@lists.ozlabs.org,
	'Inki Dae' <inki.dae@samsung.com>,
	'Donghwa Lee' <dh09.lee@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jean-Christophe PLAGNIOL-VILLARD' <plagnioj@jcrosoft.com>,
	linux-fbdev@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/3] video: exynos_dp: Use the generic PHY driver
Date: Fri, 28 Jun 2013 14:24:21 +0900
Message-id: <001701ce73bf$bebf9f20$3c3edd60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the generic PHY API instead of the platform callback to control
the DP PHY. The 'phy_label' field is added to the platform data
structure to allow PHY lookup on non-dt platforms.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 .../devicetree/bindings/video/exynos_dp.txt        |   17 ---
 drivers/video/exynos/exynos_dp_core.c              |  118 ++------------------
 drivers/video/exynos/exynos_dp_core.h              |    2 +
 include/video/exynos_dp.h                          |    6 +-
 4 files changed, 15 insertions(+), 128 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/exynos_dp.txt b/Documentation/devicetree/bindings/video/exynos_dp.txt
index 84f10c1..a8320e3 100644
--- a/Documentation/devicetree/bindings/video/exynos_dp.txt
+++ b/Documentation/devicetree/bindings/video/exynos_dp.txt
@@ -1,17 +1,6 @@
 The Exynos display port interface should be configured based on
 the type of panel connected to it.
 
-We use two nodes:
-	-dp-controller node
-	-dptx-phy node(defined inside dp-controller node)
-
-For the DP-PHY initialization, we use the dptx-phy node.
-Required properties for dptx-phy:
-	-reg:
-		Base address of DP PHY register.
-	-samsung,enable-mask:
-		The bit-mask used to enable/disable DP PHY.
-
 For the Panel initialization, we read data from dp-controller node.
 Required properties for dp-controller:
 	-compatible:
@@ -67,12 +56,6 @@ SOC specific portion:
 		interrupt-parent = <&combiner>;
 		clocks = <&clock 342>;
 		clock-names = "dp";
-
-		dptx-phy {
-			reg = <0x10040720>;
-			samsung,enable-mask = <1>;
-		};
-
 	};
 
 Board Specific portion:
diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index 12bbede..bac515b 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/of.h>
+#include <linux/phy/phy.h>
 
 #include <video/exynos_dp.h>
 
@@ -960,84 +961,15 @@ static struct exynos_dp_platdata *exynos_dp_dt_parse_pdata(struct device *dev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	return pd;
-}
-
-static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
-{
-	struct device_node *dp_phy_node = of_node_get(dp->dev->of_node);
-	u32 phy_base;
-	int ret = 0;
-
-	dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
-	if (!dp_phy_node) {
-		dev_err(dp->dev, "could not find dptx-phy node\n");
-		return -ENODEV;
-	}
-
-	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
-		dev_err(dp->dev, "failed to get reg for dptx-phy\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
-	if (of_property_read_u32(dp_phy_node, "samsung,enable-mask",
-				&dp->enable_mask)) {
-		dev_err(dp->dev, "failed to get enable-mask for dptx-phy\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
-	dp->phy_addr = ioremap(phy_base, SZ_4);
-	if (!dp->phy_addr) {
-		dev_err(dp->dev, "failed to ioremap dp-phy\n");
-		ret = -ENOMEM;
-		goto err;
-	}
-
-err:
-	of_node_put(dp_phy_node);
-
-	return ret;
-}
-
-static void exynos_dp_phy_init(struct exynos_dp_device *dp)
-{
-	u32 reg;
-
-	reg = __raw_readl(dp->phy_addr);
-	reg |= dp->enable_mask;
-	__raw_writel(reg, dp->phy_addr);
-}
-
-static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
-{
-	u32 reg;
+	pd->phy_label = "dp";
 
-	reg = __raw_readl(dp->phy_addr);
-	reg &= ~(dp->enable_mask);
-	__raw_writel(reg, dp->phy_addr);
+	return pd;
 }
 #else
 static struct exynos_dp_platdata *exynos_dp_dt_parse_pdata(struct device *dev)
 {
 	return NULL;
 }
-
-static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
-{
-	return -EINVAL;
-}
-
-static void exynos_dp_phy_init(struct exynos_dp_device *dp)
-{
-	return;
-}
-
-static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
-{
-	return;
-}
 #endif /* CONFIG_OF */
 
 static int exynos_dp_probe(struct platform_device *pdev)
@@ -1061,10 +993,6 @@ static int exynos_dp_probe(struct platform_device *pdev)
 		pdata = exynos_dp_dt_parse_pdata(&pdev->dev);
 		if (IS_ERR(pdata))
 			return PTR_ERR(pdata);
-
-		ret = exynos_dp_dt_parse_phydata(dp);
-		if (ret)
-			return ret;
 	} else {
 		pdata = pdev->dev.platform_data;
 		if (!pdata) {
@@ -1073,6 +1001,10 @@ static int exynos_dp_probe(struct platform_device *pdev)
 		}
 	}
 
+	dp->phy = devm_phy_get(&pdev->dev, pdata->phy_label);
+	if (IS_ERR(dp->phy))
+		return PTR_ERR(dp->phy);
+
 	dp->clock = devm_clk_get(&pdev->dev, "dp");
 	if (IS_ERR(dp->clock)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
@@ -1097,13 +1029,7 @@ static int exynos_dp_probe(struct platform_device *pdev)
 
 	dp->video_info = pdata->video_info;
 
-	if (pdev->dev.of_node) {
-		if (dp->phy_addr)
-			exynos_dp_phy_init(dp);
-	} else {
-		if (pdata->phy_init)
-			pdata->phy_init();
-	}
+	phy_power_on(dp->phy);
 
 	exynos_dp_init_dp(dp);
 
@@ -1121,42 +1047,27 @@ static int exynos_dp_probe(struct platform_device *pdev)
 
 static int exynos_dp_remove(struct platform_device *pdev)
 {
-	struct exynos_dp_platdata *pdata = pdev->dev.platform_data;
 	struct exynos_dp_device *dp = platform_get_drvdata(pdev);
 
 	flush_work(&dp->hotplug_work);
 
-	if (pdev->dev.of_node) {
-		if (dp->phy_addr)
-			exynos_dp_phy_exit(dp);
-	} else {
-		if (pdata->phy_exit)
-			pdata->phy_exit();
-	}
+	phy_power_off(dp->phy);
 
 	clk_disable_unprepare(dp->clock);
 
-
 	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
 static int exynos_dp_suspend(struct device *dev)
 {
-	struct exynos_dp_platdata *pdata = dev->platform_data;
 	struct exynos_dp_device *dp = dev_get_drvdata(dev);
 
 	disable_irq(dp->irq);
 
 	flush_work(&dp->hotplug_work);
 
-	if (dev->of_node) {
-		if (dp->phy_addr)
-			exynos_dp_phy_exit(dp);
-	} else {
-		if (pdata->phy_exit)
-			pdata->phy_exit();
-	}
+	phy_power_off(dp->phy);
 
 	clk_disable_unprepare(dp->clock);
 
@@ -1165,16 +1076,9 @@ static int exynos_dp_suspend(struct device *dev)
 
 static int exynos_dp_resume(struct device *dev)
 {
-	struct exynos_dp_platdata *pdata = dev->platform_data;
 	struct exynos_dp_device *dp = dev_get_drvdata(dev);
 
-	if (dev->of_node) {
-		if (dp->phy_addr)
-			exynos_dp_phy_init(dp);
-	} else {
-		if (pdata->phy_init)
-			pdata->phy_init();
-	}
+	phy_power_on(dp->phy);
 
 	clk_prepare_enable(dp->clock);
 
diff --git a/drivers/video/exynos/exynos_dp_core.h b/drivers/video/exynos/exynos_dp_core.h
index 6c567bbf..b3d0328 100644
--- a/drivers/video/exynos/exynos_dp_core.h
+++ b/drivers/video/exynos/exynos_dp_core.h
@@ -42,6 +42,8 @@ struct exynos_dp_device {
 	struct video_info	*video_info;
 	struct link_train	link_train;
 	struct work_struct	hotplug_work;
+
+	struct phy		*phy;
 };
 
 /* exynos_dp_reg.c */
diff --git a/include/video/exynos_dp.h b/include/video/exynos_dp.h
index bd8cabd..f38c9af 100644
--- a/include/video/exynos_dp.h
+++ b/include/video/exynos_dp.h
@@ -122,10 +122,8 @@ struct video_info {
 };
 
 struct exynos_dp_platdata {
-	struct video_info *video_info;
-
-	void (*phy_init)(void);
-	void (*phy_exit)(void);
+	struct video_info	*video_info;
+	const char		*phy_label;
 };
 
 #endif /* _EXYNOS_DP_H */
-- 
1.7.10.4


