Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17311 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2LJTqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 14:46:31 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 03/12] s5p-fimc: Add device tree support for FIMC-LITE
Date: Mon, 10 Dec 2012 20:45:57 +0100
Message-id: <1355168766-6068-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1355168766-6068-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168766-6068-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add support for instantiation FIMC-LITE platform
devices from device tree. Device tree aliases are used to specify
the IP hardware instance.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/media/soc/samsung-fimc.txt |   16 +++++
 drivers/media/platform/s5p-fimc/fimc-lite.c        |   65 ++++++++++++++------
 2 files changed, 62 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
index fab7e61..5bbda07 100644
--- a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
@@ -57,6 +57,22 @@ Optional properties
 			   0 - CAM_A_CLKOUT, 1 - CAM_B_CLKOUT;
 
 
+'fimc-lite' device nodes
+-----------------------
+
+Required properties:
+
+- compatible : should be "samsung,exynos4212-fimc" for Exynos4212 and
+	       Exynos4412 SoCs;
+- reg	     : physical base address and size of the device memory mapped
+	       registers;
+- interrupts : should contain FIMC-LITE interrupt;
+
+For every fimc-lite node a numbered alias should be present in the aliases
+node. Aliases are in form of fimc-lite<n>, where <n> is an integer (0...N)
+specifying the IP's instance index.
+
+
 Example:
 
 	aliases {
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index ef31c39..cfa3952 100644
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
@@ -1490,18 +1491,34 @@ static int fimc_lite_clk_get(struct fimc_lite *fimc)
 	return ret;
 }
 
+static const struct of_device_id flite_of_match[];
+
 static int __devinit fimc_lite_probe(struct platform_device *pdev)
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
 
@@ -1510,15 +1527,15 @@ static int __devinit fimc_lite_probe(struct platform_device *pdev)
 	mutex_init(&fimc->lock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	fimc->regs = devm_request_and_ioremap(&pdev->dev, res);
+	fimc->regs = devm_request_and_ioremap(dev, res);
 	if (fimc->regs == NULL) {
-		dev_err(&pdev->dev, "Failed to obtain io memory\n");
+		dev_err(dev, "Failed to obtain io memory\n");
 		return -ENOENT;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {
-		dev_err(&pdev->dev, "Failed to get IRQ resource\n");
+		dev_err(dev, "Failed to get IRQ resource\n");
 		return -ENXIO;
 	}
 
@@ -1526,10 +1543,10 @@ static int __devinit fimc_lite_probe(struct platform_device *pdev)
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
 
@@ -1539,23 +1556,23 @@ static int __devinit fimc_lite_probe(struct platform_device *pdev)
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
@@ -1646,6 +1663,12 @@ static int __devexit fimc_lite_remove(struct platform_device *pdev)
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
@@ -1671,17 +1694,21 @@ static struct platform_device_id fimc_lite_driver_ids[] = {
 };
 MODULE_DEVICE_TABLE(platform, fimc_lite_driver_ids);
 
-static const struct dev_pm_ops fimc_lite_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(fimc_lite_suspend, fimc_lite_resume)
-	SET_RUNTIME_PM_OPS(fimc_lite_runtime_suspend, fimc_lite_runtime_resume,
-			   NULL)
+static const struct of_device_id flite_of_match[] __devinitconst = {
+	{
+		.compatible = "samsung,exynos4212-fimc-lite",
+		.data = &fimc_lite_drvdata_exynos4,
+	},
+	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, flite_of_match);
 
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
1.7.9.5

