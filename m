Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:50799 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965733Ab3CZQk0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 12:40:26 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v5 3/6] s5p-fimc: Add device tree support for FIMC-LITE device
 driver
Date: Tue, 26 Mar 2013 17:39:55 +0100
Message-id: <1364315998-19372-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364315998-19372-1-git-send-email-s.nawrocki@samsung.com>
References: <1364315998-19372-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the device tree support for FIMC-LITE device
driver. The bindings include compatible property for the Exynos5
SoC series, however the actual implementation for these SoCs will
be added in a separate patch.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v5:
 - Added clocks/clock-names properties to the binding documentation.
---
 .../devicetree/bindings/media/exynos-fimc-lite.txt |   14 +++++
 drivers/media/platform/s5p-fimc/fimc-lite.c        |   63 ++++++++++++++------
 2 files changed, 59 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/exynos-fimc-lite.txt

diff --git a/Documentation/devicetree/bindings/media/exynos-fimc-lite.txt b/Documentation/devicetree/bindings/media/exynos-fimc-lite.txt
new file mode 100644
index 0000000..3f62adf
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/exynos-fimc-lite.txt
@@ -0,0 +1,14 @@
+Exynos4x12/Exynos5 SoC series camera host interface (FIMC-LITE)
+
+Required properties:
+
+- compatible	: should be "samsung,exynos4212-fimc" for Exynos4212 and
+		  Exynos4412 SoCs;
+- reg		: physical base address and size of the device memory mapped
+		  registers;
+- interrupts	: should contain FIMC-LITE interrupt;
+- clocks	: FIMC LITE gate clock should be specified in this property.
+- clock-names	: should contain "flite" entry.
+
+Each FIMC device should have an alias in the aliases node, in the form of
+fimc-lite<n>, where <n> is an integer specifying the IP block instance.
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 187d9f6..c76a9d6 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
@@ -1401,18 +1402,34 @@ static int fimc_lite_clk_get(struct fimc_lite *fimc)
 	return ret;
 }
 
+static const struct of_device_id flite_of_match[];
+
 static int fimc_lite_probe(struct platform_device *pdev)
 {
-	struct flite_drvdata *drv_data = fimc_lite_get_drvdata(pdev);
+	struct flite_drvdata *drv_data = NULL;
+	struct device *dev = &pdev->dev;
+	const struct of_device_id *of_id;
 	struct fimc_lite *fimc;
 	struct resource *res;
 	int ret;
 
-	fimc = devm_kzalloc(&pdev->dev, sizeof(*fimc), GFP_KERNEL);
+	fimc = devm_kzalloc(dev, sizeof(*fimc), GFP_KERNEL);
 	if (!fimc)
 		return -ENOMEM;
 
-	fimc->index = pdev->id;
+	if (dev->of_node) {
+		of_id = of_match_node(flite_of_match, dev->of_node);
+		if (of_id)
+			drv_data = (struct flite_drvdata *)of_id->data;
+		fimc->index = of_alias_get_id(dev->of_node, "fimc-lite");
+	} else {
+		drv_data = fimc_lite_get_drvdata(pdev);
+		fimc->index = pdev->id;
+	}
+
+	if (!drv_data || fimc->index < 0 || fimc->index >= FIMC_LITE_MAX_DEVS)
+		return -EINVAL;
+
 	fimc->variant = drv_data->variant[fimc->index];
 	fimc->pdev = pdev;
 
@@ -1421,13 +1438,13 @@ static int fimc_lite_probe(struct platform_device *pdev)
 	mutex_init(&fimc->lock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	fimc->regs = devm_ioremap_resource(&pdev->dev, res);
+	fimc->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(fimc->regs))
 		return PTR_ERR(fimc->regs);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {
-		dev_err(&pdev->dev, "Failed to get IRQ resource\n");
+		dev_err(dev, "Failed to get IRQ resource\n");
 		return -ENXIO;
 	}
 
@@ -1435,10 +1452,10 @@ static int fimc_lite_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = devm_request_irq(&pdev->dev, res->start, flite_irq_handler,
-			       0, dev_name(&pdev->dev), fimc);
+	ret = devm_request_irq(dev, res->start, flite_irq_handler,
+			       0, dev_name(dev), fimc);
 	if (ret) {
-		dev_err(&pdev->dev, "Failed to install irq (%d)\n", ret);
+		dev_err(dev, "Failed to install irq (%d)\n", ret);
 		goto err_clk;
 	}
 
@@ -1448,23 +1465,23 @@ static int fimc_lite_probe(struct platform_device *pdev)
 		goto err_clk;
 
 	platform_set_drvdata(pdev, fimc);
-	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(dev);
 	if (ret < 0)
 		goto err_sd;
 
-	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(fimc->alloc_ctx)) {
 		ret = PTR_ERR(fimc->alloc_ctx);
 		goto err_pm;
 	}
-	pm_runtime_put(&pdev->dev);
+	pm_runtime_put(dev);
 
-	dev_dbg(&pdev->dev, "FIMC-LITE.%d registered successfully\n",
+	dev_dbg(dev, "FIMC-LITE.%d registered successfully\n",
 		fimc->index);
 	return 0;
 err_pm:
-	pm_runtime_put(&pdev->dev);
+	pm_runtime_put(dev);
 err_sd:
 	fimc_lite_unregister_capture_subdev(fimc);
 err_clk:
@@ -1555,6 +1572,12 @@ static int fimc_lite_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct dev_pm_ops fimc_lite_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(fimc_lite_suspend, fimc_lite_resume)
+	SET_RUNTIME_PM_OPS(fimc_lite_runtime_suspend, fimc_lite_runtime_resume,
+			   NULL)
+};
+
 static struct flite_variant fimc_lite0_variant_exynos4 = {
 	.max_width		= 8192,
 	.max_height		= 8192,
@@ -1580,17 +1603,21 @@ static struct platform_device_id fimc_lite_driver_ids[] = {
 };
 MODULE_DEVICE_TABLE(platform, fimc_lite_driver_ids);
 
-static const struct dev_pm_ops fimc_lite_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(fimc_lite_suspend, fimc_lite_resume)
-	SET_RUNTIME_PM_OPS(fimc_lite_runtime_suspend, fimc_lite_runtime_resume,
-			   NULL)
+static const struct of_device_id flite_of_match[] = {
+	{
+		.compatible = "samsung,exynos4212-fimc-lite",
+		.data = &fimc_lite_drvdata_exynos4,
+	},
+	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, flite_of_match);
 
 static struct platform_driver fimc_lite_driver = {
 	.probe		= fimc_lite_probe,
 	.remove		= fimc_lite_remove,
 	.id_table	= fimc_lite_driver_ids,
 	.driver = {
+		.of_match_table = flite_of_match,
 		.name		= FIMC_LITE_DRV_NAME,
 		.owner		= THIS_MODULE,
 		.pm		= &fimc_lite_pm_ops,
-- 
1.7.9.5

