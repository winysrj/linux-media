Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55370 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3BATJz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 14:09:55 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, kgene.kim@samsung.com,
	swarren@wwwdotorg.org, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 02/10] s5p-fimc: Add device tree support for FIMC devices
Date: Fri, 01 Feb 2013 20:09:23 +0100
Message-id: <1359745771-23684-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com>
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for FIMC devices instantiated from devicetree
for S5PV210 and Exynos4 SoCs. The FIMC IP features include colorspace
conversion and scaling (mem-to-mem) and parallel/MIPI CSI2 bus video
capture interface.

Multiple SoC revisions specific parameters are defined statically in
the driver and are used for both dt and non-dt. The driver's static
data is selected based on the compatible property. Previously the
platform device name was used to match driver data and a specific
SoC/IP version.

Aliases are used to determine an index of the IP which is essential
for linking FIMC IP with other entities, like MIPI-CSIS (the MIPI
CSI-2 bus frontend) or FIMC-LITE and FIMC-IS ISP.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v3:
 - added optional clock-frequency property to specify local bus
   (FIMCn_LCLK) clock frequency
---
 .../devicetree/bindings/media/soc/samsung-fimc.txt |   72 +++++++++++++++
 drivers/media/platform/s5p-fimc/fimc-capture.c     |    2 +-
 drivers/media/platform/s5p-fimc/fimc-core.c        |   93 +++++++++++++-------
 3 files changed, 135 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/soc/samsung-fimc.txt

diff --git a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
new file mode 100644
index 0000000..916b2c3
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
@@ -0,0 +1,72 @@
+Samsung S5P/EXYNOS SoC Camera Subsystem (FIMC)
+----------------------------------------------
+
+The Exynos Camera subsystem comprises of multiple sub-devices that are
+represented by separate platform devices. Some of the IPs come in different
+variants across the SoC revisions (FIMC) and some remain mostly unchanged
+(MIPI CSIS, FIMC-LITE).
+
+All those sub-subdevices are defined as parent nodes of the common device
+node, which also includes common properties of the whole subsystem not really
+specific to any single sub-device, like common camera port pins or external
+clocks for image sensors attached to the SoC.
+
+Common 'camera' node
+--------------------
+
+Required properties:
+
+- compatible	   : must be "samsung,fimc", "simple-bus"
+
+The 'camera' node must include at least one 'fimc' child node.
+
+
+'fimc' device nodes
+-------------------
+
+Required properties:
+
+- compatible : "samsung,s5pv210-fimc" for S5PV210,
+	       "samsung,exynos4210-fimc" for Exynos4210,
+	       "samsung,exynos4212-fimc" for Exynos4212/4412 SoCs;
+- reg	     : physical base address and size of the device memory mapped
+	       registers;
+- interrupts : FIMC interrupt to the CPU should be described here;
+
+For every fimc node a numbered alias should be present in the aliases node.
+Aliases are of the form fimc<n>, where <n> is an integer (0...N) specifying
+the IP's instance index.
+
+Optional properties
+
+ - clock-frequency - maximum FIMC local clock (LCLK) frequency
+
+Example:
+
+	aliases {
+		csis0 = &csis_0;
+		fimc0 = &fimc_0;
+	};
+
+	camera {
+		compatible = "samsung,fimc", "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		status = "okay";
+
+		fimc_0: fimc@11800000 {
+			compatible = "samsung,exynos4210-fimc";
+			reg = <0x11800000 0x1000>;
+			interrupts = <0 85 0>;
+			status = "okay";
+		};
+
+		csis_0: csis@11880000 {
+			compatible = "samsung,exynos4210-csis";
+			reg = <0x11880000 0x1000>;
+			interrupts = <0 78 0>;
+			max-data-lanes = <4>;
+		};
+	};
+
+[1] Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index f822b8e..bc84301 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -1883,7 +1883,7 @@ int fimc_initialize_capture_subdev(struct fimc_dev *fimc)
 
 	v4l2_subdev_init(sd, &fimc_subdev_ops);
 	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
-	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->pdev->id);
+	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->id);
 
 	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
 	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 29f7bb7..07ca0e0 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -21,6 +21,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/list.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <media/v4l2-ioctl.h>
@@ -863,45 +865,57 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
 	return 0;
 }
 
+static const struct of_device_id fimc_of_match[];
+
 static int fimc_probe(struct platform_device *pdev)
 {
-	const struct fimc_drvdata *drv_data = fimc_get_drvdata(pdev);
-	struct s5p_platform_fimc *pdata;
+	struct fimc_drvdata *drv_data = NULL;
+	struct device *dev = &pdev->dev;
+	const struct of_device_id *of_id;
+	u32 lclk_freq = 0;
 	struct fimc_dev *fimc;
 	struct resource *res;
 	int ret = 0;
 
-	if (pdev->id >= drv_data->num_entities) {
-		dev_err(&pdev->dev, "Invalid platform device id: %d\n",
-			pdev->id);
-		return -EINVAL;
-	}
-
-	fimc = devm_kzalloc(&pdev->dev, sizeof(*fimc), GFP_KERNEL);
+	fimc = devm_kzalloc(dev, sizeof(*fimc), GFP_KERNEL);
 	if (!fimc)
 		return -ENOMEM;
 
-	fimc->id = pdev->id;
+	if (dev->of_node) {
+		of_id = of_match_node(fimc_of_match, dev->of_node);
+		if (of_id)
+			drv_data = (struct fimc_drvdata *)of_id->data;
+		fimc->id = of_alias_get_id(dev->of_node, "fimc");
+
+		of_property_read_u32(dev->of_node, "clock-frequency",
+							&lclk_freq);
+	} else {
+		drv_data = fimc_get_drvdata(pdev);
+		fimc->id = pdev->id;
+	}
+
+	if (!drv_data || fimc->id < 0 || fimc->id >= drv_data->num_entities) {
+		dev_err(dev, "Invalid driver data or device index (%d)\n",
+			fimc->id);
+		return -EINVAL;
+	}
 
 	fimc->variant = drv_data->variant[fimc->id];
 	fimc->pdev = pdev;
-	pdata = pdev->dev.platform_data;
-	fimc->pdata = pdata;
-
 	init_waitqueue_head(&fimc->irq_queue);
 	spin_lock_init(&fimc->slock);
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
 
@@ -909,7 +923,10 @@ static int fimc_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = clk_set_rate(fimc->clock[CLK_BUS], drv_data->lclk_frequency);
+	if (lclk_freq == 0)
+		lclk_freq = drv_data->lclk_frequency;
+
+	ret = clk_set_rate(fimc->clock[CLK_BUS], lclk_freq);
 	if (ret < 0)
 		return ret;
 
@@ -917,10 +934,10 @@ static int fimc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	ret = devm_request_irq(&pdev->dev, res->start, fimc_irq_handler,
-			       0, dev_name(&pdev->dev), fimc);
+	ret = devm_request_irq(dev, res->start, fimc_irq_handler,
+			       0, dev_name(dev), fimc);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
+		dev_err(dev, "failed to install irq (%d)\n", ret);
 		goto err_clk;
 	}
 
@@ -929,27 +946,26 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_clk;
 
 	platform_set_drvdata(pdev, fimc);
-	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(dev);
 	if (ret < 0)
 		goto err_sd;
 	/* Initialize contiguous memory allocator */
-	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(fimc->alloc_ctx)) {
 		ret = PTR_ERR(fimc->alloc_ctx);
 		goto err_pm;
 	}
 
-	dev_dbg(&pdev->dev, "FIMC.%d registered successfully\n", fimc->id);
+	dev_dbg(dev, "FIMC.%d registered successfully\n", fimc->id);
 
-	pm_runtime_put(&pdev->dev);
+	pm_runtime_put(dev);
 	return 0;
 err_pm:
-	pm_runtime_put(&pdev->dev);
+	pm_runtime_put(dev);
 err_sd:
 	fimc_unregister_capture_subdev(fimc);
 err_clk:
-	clk_disable(fimc->clock[CLK_BUS]);
 	fimc_clk_put(fimc);
 	return ret;
 }
@@ -1258,10 +1274,24 @@ static const struct platform_device_id fimc_driver_ids[] = {
 		.name		= "exynos4x12-fimc",
 		.driver_data	= (unsigned long)&fimc_drvdata_exynos4x12,
 	},
-	{},
+	{ },
 };
 MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
 
+static const struct of_device_id fimc_of_match[] = {
+	{
+		.compatible = "samsung,s5pv210-fimc",
+		.data = &fimc_drvdata_s5pv210,
+	}, {
+		.compatible = "samsung,exynos4210-fimc",
+		.data = &fimc_drvdata_exynos4210,
+	}, {
+		.compatible = "samsung,exynos4212-fimc",
+		.data = &fimc_drvdata_exynos4x12,
+	},
+	{ /* sentinel */ },
+};
+
 static const struct dev_pm_ops fimc_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(fimc_suspend, fimc_resume)
 	SET_RUNTIME_PM_OPS(fimc_runtime_suspend, fimc_runtime_resume, NULL)
@@ -1272,9 +1302,10 @@ static struct platform_driver fimc_driver = {
 	.remove		= fimc_remove,
 	.id_table	= fimc_driver_ids,
 	.driver = {
-		.name	= FIMC_MODULE_NAME,
-		.owner	= THIS_MODULE,
-		.pm     = &fimc_pm_ops,
+		.of_match_table = fimc_of_match,
+		.name		= FIMC_MODULE_NAME,
+		.owner		= THIS_MODULE,
+		.pm     	= &fimc_pm_ops,
 	}
 };
 
-- 
1.7.9.5

