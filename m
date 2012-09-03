Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:10244 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab2ICNHh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 09:07:37 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, linux-media@vger.kernel.org
Cc: kgene.kim@samsung.com, k.debski@samsung.com, jtp.park@samsung.com,
	ch.naveen@samsung.com, arun.kk@samsung.com,
	thomas.abraham@linaro.org, kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH v1 2/2] [media] s5p-mfc: Add device tree support
Date: Mon, 03 Sep 2012 22:22:58 +0530
Message-id: <1346691178-29580-3-git-send-email-arun.kk@samsung.com>
In-reply-to: <1346691178-29580-1-git-send-email-arun.kk@samsung.com>
References: <1346691178-29580-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch will add the device tree support for MFC driver.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 .../devicetree/bindings/media/s5p-mfc.txt          |   27 +++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  104 +++++++++++++++++---
 2 files changed, 115 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/s5p-mfc.txt

diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
new file mode 100644
index 0000000..9a74d09
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
@@ -0,0 +1,27 @@
+* Samsung Multi Format Codec (MFC)
+
+Mult Format Codec (MFC) is the IP present in Samsung SoCs which
+supports high resolution decoding and encoding functionalities.
+The MFC device driver is a v4l2 driver which can encode/decode
+video raw/elementary streams and has support for all popular
+video codecs.
+
+Required properties:
+  - compatible : value should be either one among the following
+	(a) "samsung,mfc-v5" for MFC v5 present in Exynos4 SoCs
+	(b) "samsung,mfc-v6" for MFC v6 present in Exynos5 SoCs
+
+  - reg : Physical base address of the IP registers and length of memory
+	  mapped region.
+
+  - interrupts : MFC interupt number to the CPU.
+
+  - samsung,mfc-r : Base address of the first memory bank used by MFC
+		    for DMA contiguous memory allocation.
+
+  - samsung,mfc-r-size : Size of the first memory bank.
+
+  - samsung,mfc-l : Base address of the second memory bank used by MFC
+		    for DMA contiguous memory allocation.
+
+  - samsung,mfc-l-size : Size of the second memory bank.
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 80f0555..365b6f5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -957,6 +957,8 @@ static int match_child(struct device *dev, void *data)
 	return !strcmp(dev_name(dev), (char *)data);
 }
 
+static void *mfc_get_drv_data(struct platform_device *pdev);
+
 /* MFC probe function */
 static int s5p_mfc_probe(struct platform_device *pdev)
 {
@@ -964,6 +966,8 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	struct resource *res;
 	int ret;
+	unsigned int base_addr;
+	unsigned int bank_size;
 
 	pr_debug("%s++\n", __func__);
 	dev = devm_kzalloc(&pdev->dev, sizeof *dev, GFP_KERNEL);
@@ -980,8 +984,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	dev->variant = (struct s5p_mfc_variant *)
-		platform_get_device_id(pdev)->driver_data;
+	dev->variant = mfc_get_drv_data(pdev);
 
 	ret = s5p_mfc_init_pm(dev);
 	if (ret < 0) {
@@ -1011,20 +1014,59 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		goto err_res;
 	}
 
-	dev->mem_dev_l = device_find_child(&dev->plat_dev->dev, "s5p-mfc-l",
-					   match_child);
-	if (!dev->mem_dev_l) {
-		mfc_err("Mem child (L) device get failed\n");
-		ret = -ENODEV;
-		goto err_res;
-	}
+	if (pdev->dev.of_node) {
+		dev->mem_dev_l = kzalloc(sizeof(struct device), GFP_KERNEL);
+		if (!dev->mem_dev_l) {
+			mfc_err("Not enough memory\n");
+			ret = -ENOMEM;
+			goto err_res;
+		}
+		of_property_read_u32(pdev->dev.of_node, "samsung,mfc-l",
+				&base_addr);
+		of_property_read_u32(pdev->dev.of_node, "samsung,mfc-l-size",
+				&bank_size);
+		if (dma_declare_coherent_memory(dev->mem_dev_l, base_addr,
+				base_addr, bank_size,
+				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
+			mfc_err("Failed to declare coherent memory for\n"
+					"MFC device\n");
+			ret = -ENOMEM;
+			goto err_res;
+		}
 
-	dev->mem_dev_r = device_find_child(&dev->plat_dev->dev, "s5p-mfc-r",
-					   match_child);
-	if (!dev->mem_dev_r) {
-		mfc_err("Mem child (R) device get failed\n");
-		ret = -ENODEV;
-		goto err_res;
+		dev->mem_dev_r = kzalloc(sizeof(struct device), GFP_KERNEL);
+		if (!dev->mem_dev_r) {
+			mfc_err("Not enough memory\n");
+			ret = -ENOMEM;
+			goto err_res;
+		}
+		of_property_read_u32(pdev->dev.of_node, "samsung,mfc-r",
+				&base_addr);
+		of_property_read_u32(pdev->dev.of_node, "samsung,mfc-r-size",
+				&bank_size);
+		if (dma_declare_coherent_memory(dev->mem_dev_r, base_addr,
+				base_addr, bank_size,
+				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
+			pr_err("Failed to declare coherent memory for\n"
+					"MFC device\n");
+			ret = -ENOMEM;
+			goto err_res;
+		}
+	} else {
+		dev->mem_dev_l = device_find_child(&dev->plat_dev->dev,
+				"s5p-mfc-l", match_child);
+		if (!dev->mem_dev_l) {
+			mfc_err("Mem child (L) device get failed\n");
+			ret = -ENODEV;
+			goto err_res;
+		}
+		dev->mem_dev_r = device_find_child(&dev->plat_dev->dev,
+				"s5p-mfc-r", match_child);
+		if (!dev->mem_dev_r) {
+			mfc_err("Mem child (R) device get failed\n");
+			ret = -ENODEV;
+			goto err_res;
+		}
 	}
 
 	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
@@ -1293,6 +1335,35 @@ static struct platform_device_id mfc_driver_ids[] = {
 };
 MODULE_DEVICE_TABLE(platform, mfc_driver_ids);
 
+static const struct of_device_id exynos_mfc_match[] = {
+	{
+		.compatible = "samsung,mfc-v5",
+		.data = &mfc_drvdata_v5,
+	}, {
+		.compatible = "samsung,mfc-v6",
+		.data = &mfc_drvdata_v6,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_mfc_match);
+
+static void *mfc_get_drv_data(struct platform_device *pdev)
+{
+	struct s5p_mfc_variant *driver_data = NULL;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(of_match_ptr(exynos_mfc_match),
+				pdev->dev.of_node);
+		if (match)
+			driver_data = match->data;
+	} else {
+		driver_data = (struct s5p_mfc_variant *)
+			platform_get_device_id(pdev)->driver_data;
+	}
+	return driver_data;
+}
+
 static struct platform_driver s5p_mfc_driver = {
 	.probe		= s5p_mfc_probe,
 	.remove		= __devexit_p(s5p_mfc_remove),
@@ -1300,7 +1371,8 @@ static struct platform_driver s5p_mfc_driver = {
 	.driver	= {
 		.name	= S5P_MFC_NAME,
 		.owner	= THIS_MODULE,
-		.pm	= &s5p_mfc_pm_ops
+		.pm	= &s5p_mfc_pm_ops,
+		.of_match_table = exynos_mfc_match,
 	},
 };
 
-- 
1.7.0.4

