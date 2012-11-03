Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:38734 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab2KCLmP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Nov 2012 07:42:15 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCW001WLTUC7R20@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 03 Nov 2012 20:42:13 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MCW007MCTU3NJA0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 03 Nov 2012 20:42:13 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, jtp.park@samsung.com,
	sw0312.kim@samsung.com, arun.kk@samsung.com, joshi@samsung.com
Subject: [PATCH v1] s5p-mfc: Add device tree support
Date: Sat, 03 Nov 2012 17:32:01 +0530
Message-id: <1351944121-4756-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1351944121-4756-1-git-send-email-arun.kk@samsung.com>
References: <1351944121-4756-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch will add the device tree support for MFC driver.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |  114 +++++++++++++++++++++++++-----
 1 files changed, 97 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 130f4ac..0ca8dbb 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -21,6 +21,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-event.h>
 #include <linux/workqueue.h>
+#include <linux/of.h>
 #include <media/videobuf2-core.h>
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_ctrl.h"
@@ -1030,6 +1031,48 @@ static int match_child(struct device *dev, void *data)
 	return !strcmp(dev_name(dev), (char *)data);
 }
 
+static void *mfc_get_drv_data(struct platform_device *pdev);
+
+static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
+{
+	unsigned int mem_info[2];
+
+	dev->mem_dev_l = devm_kzalloc(&dev->plat_dev->dev,
+			sizeof(struct device), GFP_KERNEL);
+	if (!dev->mem_dev_l) {
+		mfc_err("Not enough memory\n");
+		return -ENOMEM;
+	}
+	device_initialize(dev->mem_dev_l);
+	of_property_read_u32_array(dev->plat_dev->dev.of_node, "samsung,mfc-l",
+			mem_info, 2);
+	if (dma_declare_coherent_memory(dev->mem_dev_l, mem_info[0],
+			mem_info[0], mem_info[1],
+			DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
+		mfc_err("Failed to declare coherent memory for\n"
+				"MFC device\n");
+		return -ENOMEM;
+	}
+
+	dev->mem_dev_r = devm_kzalloc(&dev->plat_dev->dev,
+			sizeof(struct device), GFP_KERNEL);
+	if (!dev->mem_dev_r) {
+		mfc_err("Not enough memory\n");
+		return -ENOMEM;
+	}
+	device_initialize(dev->mem_dev_r);
+	of_property_read_u32_array(dev->plat_dev->dev.of_node, "samsung,mfc-r",
+			mem_info, 2);
+	if (dma_declare_coherent_memory(dev->mem_dev_r, mem_info[0],
+			mem_info[0], mem_info[1],
+			DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
+		pr_err("Failed to declare coherent memory for\n"
+				"MFC device\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 /* MFC probe function */
 static int s5p_mfc_probe(struct platform_device *pdev)
 {
@@ -1053,8 +1096,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	dev->variant = (struct s5p_mfc_variant *)
-		platform_get_device_id(pdev)->driver_data;
+	dev->variant = mfc_get_drv_data(pdev);
 
 	ret = s5p_mfc_init_pm(dev);
 	if (ret < 0) {
@@ -1084,20 +1126,24 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		goto err_res;
 	}
 
-	dev->mem_dev_l = device_find_child(&dev->plat_dev->dev, "s5p-mfc-l",
-					   match_child);
-	if (!dev->mem_dev_l) {
-		mfc_err("Mem child (L) device get failed\n");
-		ret = -ENODEV;
-		goto err_res;
-	}
-
-	dev->mem_dev_r = device_find_child(&dev->plat_dev->dev, "s5p-mfc-r",
-					   match_child);
-	if (!dev->mem_dev_r) {
-		mfc_err("Mem child (R) device get failed\n");
-		ret = -ENODEV;
-		goto err_res;
+	if (pdev->dev.of_node) {
+		if (s5p_mfc_alloc_memdevs(dev) < 0)
+			goto err_res;
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
@@ -1221,6 +1267,10 @@ static int __devexit s5p_mfc_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&dev->v4l2_dev);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
+	if (pdev->dev.of_node) {
+		put_device(dev->mem_dev_l);
+		put_device(dev->mem_dev_r);
+	}
 
 	s5p_mfc_final_pm(dev);
 	return 0;
@@ -1369,6 +1419,35 @@ static struct platform_device_id mfc_driver_ids[] = {
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
+			driver_data = (struct s5p_mfc_variant *)match->data;
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
@@ -1376,7 +1455,8 @@ static struct platform_driver s5p_mfc_driver = {
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

