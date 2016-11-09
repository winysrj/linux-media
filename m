Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11054 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932867AbcKIO3z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:29:55 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 2/2] exynos-gsc: Add support for Exynos5433 specific version
Date: Wed, 09 Nov 2016 15:29:38 +0100
Message-id: <1478701778-29452-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478701778-29452-1-git-send-email-m.szyprowski@samsung.com>
References: <1478701778-29452-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142951eucas1p25ea07a6d0ba507b26df345f3888b4539@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add support for Exynos5433 specific version of GScaller module.
The main difference is between Exynos 5433 and earlier is addition of
new clocks that have to be controlled.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 .../devicetree/bindings/media/exynos5-gsc.txt      |  3 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       | 74 ++++++++++++++++------
 drivers/media/platform/exynos-gsc/gsc-core.h       |  6 +-
 3 files changed, 62 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/exynos5-gsc.txt b/Documentation/devicetree/bindings/media/exynos5-gsc.txt
index 5fe9372..26ca25b 100644
--- a/Documentation/devicetree/bindings/media/exynos5-gsc.txt
+++ b/Documentation/devicetree/bindings/media/exynos5-gsc.txt
@@ -3,7 +3,8 @@
 G-Scaler is used for scaling and color space conversion on EXYNOS5 SoCs.
 
 Required properties:
-- compatible: should be "samsung,exynos5-gsc"
+- compatible: should be "samsung,exynos5-gsc" (for Exynos 5250, 5420 and
+	      5422 SoCs) or "samsung,exynos5433-gsc" (Exynos 5433)
 - reg: should contain G-Scaler physical address location and length.
 - interrupts: should contain G-Scaler interrupt number
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 664398c..827c1bb 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -29,8 +29,6 @@
 
 #include "gsc-core.h"
 
-#define GSC_CLOCK_GATE_NAME	"gscl"
-
 static const struct gsc_fmt gsc_formats[] = {
 	{
 		.name		= "RGB565",
@@ -965,6 +963,19 @@ static irqreturn_t gsc_irq_handler(int irq, void *priv)
 		[3] = &gsc_v_100_variant,
 	},
 	.num_entities = 4,
+	.clk_names = { "gscl" },
+	.num_clocks = 1,
+};
+
+static struct gsc_driverdata gsc_5433_drvdata = {
+	.variant = {
+		[0] = &gsc_v_100_variant,
+		[1] = &gsc_v_100_variant,
+		[2] = &gsc_v_100_variant,
+	},
+	.num_entities = 3,
+	.clk_names = { "pclk", "aclk", "aclk_xiu", "aclk_gsclbend" },
+	.num_clocks = 4,
 };
 
 static const struct of_device_id exynos_gsc_match[] = {
@@ -972,6 +983,10 @@ static irqreturn_t gsc_irq_handler(int irq, void *priv)
 		.compatible = "samsung,exynos5-gsc",
 		.data = &gsc_v_100_drvdata,
 	},
+	{
+		.compatible = "samsung,exynos5433-gsc",
+		.data = &gsc_5433_drvdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos_gsc_match);
@@ -983,6 +998,7 @@ static int gsc_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	const struct gsc_driverdata *drv_data = of_device_get_match_data(dev);
 	int ret;
+	int i;
 
 	gsc = devm_kzalloc(dev, sizeof(struct gsc_dev), GFP_KERNEL);
 	if (!gsc)
@@ -998,6 +1014,7 @@ static int gsc_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	gsc->num_clocks = drv_data->num_clocks;
 	gsc->variant = drv_data->variant[gsc->id];
 	gsc->pdev = pdev;
 
@@ -1016,18 +1033,24 @@ static int gsc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	gsc->clock = devm_clk_get(dev, GSC_CLOCK_GATE_NAME);
-	if (IS_ERR(gsc->clock)) {
-		dev_err(dev, "failed to get clock~~~: %s\n",
-			GSC_CLOCK_GATE_NAME);
-		return PTR_ERR(gsc->clock);
+	for (i = 0; i < gsc->num_clocks; i++) {
+		gsc->clock[i] = devm_clk_get(dev, drv_data->clk_names[i]);
+		if (IS_ERR(gsc->clock[i])) {
+			dev_err(dev, "failed to get clock: %s\n",
+				drv_data->clk_names[i]);
+			return PTR_ERR(gsc->clock[i]);
+		}
 	}
 
-	ret = clk_prepare_enable(gsc->clock);
-	if (ret) {
-		dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
-			GSC_CLOCK_GATE_NAME);
-		return ret;
+	for (i = 0; i < gsc->num_clocks; i++) {
+		ret = clk_prepare_enable(gsc->clock[i]);
+		if (ret) {
+			dev_err(dev, "clock prepare failed for clock: %s\n",
+				drv_data->clk_names[i]);
+			while (--i >= 0)
+				clk_disable_unprepare(gsc->clock[i]);
+			return ret;
+		}
 	}
 
 	ret = devm_request_irq(dev, res->start, gsc_irq_handler,
@@ -1062,13 +1085,15 @@ static int gsc_probe(struct platform_device *pdev)
 err_v4l2:
 	v4l2_device_unregister(&gsc->v4l2_dev);
 err_clk:
-	clk_disable_unprepare(gsc->clock);
+	for (i = gsc->num_clocks - 1; i >= 0; i--)
+		clk_disable_unprepare(gsc->clock[i]);
 	return ret;
 }
 
 static int gsc_remove(struct platform_device *pdev)
 {
 	struct gsc_dev *gsc = platform_get_drvdata(pdev);
+	int i;
 
 	pm_runtime_get_sync(&pdev->dev);
 
@@ -1076,7 +1101,8 @@ static int gsc_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&gsc->v4l2_dev);
 
 	vb2_dma_contig_clear_max_seg_size(&pdev->dev);
-	clk_disable_unprepare(gsc->clock);
+	for (i = 0; i < gsc->num_clocks; i++)
+		clk_disable_unprepare(gsc->clock[i]);
 
 	pm_runtime_put_noidle(&pdev->dev);
 
@@ -1126,12 +1152,18 @@ static int gsc_runtime_resume(struct device *dev)
 {
 	struct gsc_dev *gsc = dev_get_drvdata(dev);
 	int ret = 0;
+	int i;
 
 	pr_debug("gsc%d: state: 0x%lx\n", gsc->id, gsc->state);
 
-	ret = clk_prepare_enable(gsc->clock);
-	if (ret)
-		return ret;
+	for (i = 0; i < gsc->num_clocks; i++) {
+		ret = clk_prepare_enable(gsc->clock[i]);
+		if (ret) {
+			while (--i >= 0)
+				clk_disable_unprepare(gsc->clock[i]);
+			return ret;
+		}
+	}
 
 	gsc_hw_set_sw_reset(gsc);
 	gsc_wait_reset(gsc);
@@ -1144,10 +1176,14 @@ static int gsc_runtime_suspend(struct device *dev)
 {
 	struct gsc_dev *gsc = dev_get_drvdata(dev);
 	int ret = 0;
+	int i;
 
 	ret = gsc_m2m_suspend(gsc);
-	if (!ret)
-		clk_disable_unprepare(gsc->clock);
+	if (ret)
+		return ret;
+
+	for (i = gsc->num_clocks - 1; i >= 0; i--)
+		clk_disable_unprepare(gsc->clock[i]);
 
 	pr_debug("gsc%d: state: 0x%lx\n", gsc->id, gsc->state);
 	return ret;
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index e5aa8f4..696217e 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -33,6 +33,7 @@
 
 #define GSC_SHUTDOWN_TIMEOUT		((100*HZ)/1000)
 #define GSC_MAX_DEVS			4
+#define GSC_MAX_CLOCKS			4
 #define GSC_M2M_BUF_NUM			0
 #define GSC_MAX_CTRL_NUM		10
 #define GSC_SC_ALIGN_4			4
@@ -307,6 +308,8 @@ struct gsc_variant {
  */
 struct gsc_driverdata {
 	struct gsc_variant *variant[GSC_MAX_DEVS];
+	const char	*clk_names[GSC_MAX_CLOCKS];
+	int		num_clocks;
 	int		num_entities;
 };
 
@@ -330,7 +333,8 @@ struct gsc_dev {
 	struct platform_device		*pdev;
 	struct gsc_variant		*variant;
 	u16				id;
-	struct clk			*clock;
+	int				num_clocks;
+	struct clk			*clock[GSC_MAX_CLOCKS];
 	void __iomem			*regs;
 	wait_queue_head_t		irq_queue;
 	struct gsc_m2m_device		m2m;
-- 
1.9.1

