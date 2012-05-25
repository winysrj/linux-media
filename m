Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25307 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758481Ab2EYTxI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 25 May 2012 21:52:45 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 06/13] media: s5p-fimc: Add device tree support for
 FIMC-LITE
In-reply-to: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Message-id: <1337975573-27117-6-git-send-email-s.nawrocki@samsung.com>
References: <4FBFE1EC.9060209@samsung.com>
 <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../bindings/camera/soc/samsung-fimc.txt           |   15 ++++
 drivers/media/video/s5p-fimc/fimc-lite.c           |   73 ++++++++++++++------
 2 files changed, 67 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
index 1ec48e9..b459da2 100644
--- a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
@@ -39,6 +39,21 @@ Required properties:
 	       depends on the SoC revision. For S5PV210 valid values are:
 	       0...2, for Exynos4x1x: 0...3.
 
+
+'fimc-lite' device node
+-----------------------
+
+Required properties:
+
+- compatible : should be one of:
+		"samsung,exynos4212-fimc";
+		"samsung,exynos4412-fimc";
+- reg	     : physical base address and size of the device's memory mapped
+	       registers;
+- interrupts : should contain FIMC-LITE interrupt;
+- cell-index : FIMC-LITE IP instance index;
+
+
 Example:
 
 	fimc0: fimc@11800000 {
diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
index 400d701a..a7ae149 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
@@ -36,6 +37,37 @@
 static int debug;
 module_param(debug, int, 0644);
 
+
+static struct flite_variant fimc_lite0_variant_exynos4 = {
+	.max_width		= 8192,
+	.max_height		= 8192,
+	.out_width_align	= 8,
+	.win_hor_offs_align	= 2,
+	.out_hor_offs_align	= 8,
+};
+
+/* EXYNOS4212, EXYNOS4412 */
+static struct flite_drvdata fimc_lite_drvdata_exynos4 = {
+	.variant = {
+		[0] = &fimc_lite0_variant_exynos4,
+		[1] = &fimc_lite0_variant_exynos4,
+	},
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id flite_of_match[] __devinitconst = {
+	{
+		.compatible = "samsung,exynos4412-fimc-lite",
+		.data = &fimc_lite_drvdata_exynos4,
+	}, {
+		.compatible = "samsung,exynos4212-fimc-lite",
+		.data = &fimc_lite_drvdata_exynos4,
+	},
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, fimc_of_match);
+#endif
+
 static const struct fimc_fmt fimc_lite_formats[] = {
 	{
 		.name		= "YUV 4:2:2 packed, YCbYCr",
@@ -1378,6 +1410,7 @@ static int fimc_lite_clk_get(struct fimc_lite *fimc)
 static int __devinit fimc_lite_probe(struct platform_device *pdev)
 {
 	struct flite_drvdata *drv_data = fimc_lite_get_drvdata(pdev);
+	const struct of_device_id *of_id;
 	struct fimc_lite *fimc;
 	struct resource *res;
 	int ret;
@@ -1386,7 +1419,20 @@ static int __devinit fimc_lite_probe(struct platform_device *pdev)
 	if (!fimc)
 		return -ENOMEM;
 
-	fimc->index = pdev->id;
+	if (pdev->dev.of_node) {
+		of_id = of_match_node(of_match_ptr(flite_of_match),
+				      pdev->dev.of_node);
+		if (of_id)
+			drv_data = of_id->data;
+		of_property_read_u32(pdev->dev.of_node, "cell-index",
+				     &fimc->index);
+	} else {
+		fimc->index = pdev->id;
+	}
+
+	if (drv_data == NULL || fimc->index >= FIMC_LITE_MAX_DEVS)
+		return -EINVAL;
+
 	fimc->variant = drv_data->variant[fimc->index];
 	fimc->pdev = pdev;
 
@@ -1530,20 +1576,10 @@ static int __devexit fimc_lite_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct flite_variant fimc_lite0_variant_exynos4 = {
-	.max_width		= 8192,
-	.max_height		= 8192,
-	.out_width_align	= 8,
-	.win_hor_offs_align	= 2,
-	.out_hor_offs_align	= 8,
-};
-
-/* EXYNOS4212, EXYNOS4412 */
-static struct flite_drvdata fimc_lite_drvdata_exynos4 = {
-	.variant = {
-		[0] = &fimc_lite0_variant_exynos4,
-		[1] = &fimc_lite0_variant_exynos4,
-	},
+static const struct dev_pm_ops fimc_lite_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(fimc_lite_suspend, fimc_lite_resume)
+	SET_RUNTIME_PM_OPS(fimc_lite_runtime_suspend, fimc_lite_runtime_resume,
+			   NULL)
 };
 
 static struct platform_device_id fimc_lite_driver_ids[] = {
@@ -1555,17 +1591,12 @@ static struct platform_device_id fimc_lite_driver_ids[] = {
 };
 MODULE_DEVICE_TABLE(platform, fimc_lite_driver_ids);
 
-static const struct dev_pm_ops fimc_lite_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(fimc_lite_suspend, fimc_lite_resume)
-	SET_RUNTIME_PM_OPS(fimc_lite_runtime_suspend, fimc_lite_runtime_resume,
-			   NULL)
-};
-
 static struct platform_driver fimc_lite_driver = {
 	.probe		= fimc_lite_probe,
 	.remove		= __devexit_p(fimc_lite_remove),
 	.id_table	= fimc_lite_driver_ids,
 	.driver = {
+		.of_match_table = of_match_ptr(flite_of_match),
 		.name		= FIMC_LITE_DRV_NAME,
 		.owner		= THIS_MODULE,
 		.pm		= &fimc_lite_pm_ops,
-- 
1.7.10

