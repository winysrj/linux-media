Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:20265 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2HPLzJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 07:55:09 -0400
Received: from epcpsbgm2.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8U00KO0JRV6OS0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 20:55:07 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8U0072VJOLM8B0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 20:55:07 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, ch.naveen@samsung.com,
	arun.kk@samsung.com, kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH] [media] s5p-mfc: Add device tree support
Date: Thu, 16 Aug 2012 18:32:31 +0530
Message-id: <1345122151-15514-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1345122151-15514-1-git-send-email-arun.kk@samsung.com>
References: <1345122151-15514-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch will add the device tree support for MFC driver.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc.c |  106 ++++++++++++++++++++++++++++-----
 1 files changed, 90 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index 75b9026..83a4494 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/workqueue.h>
+#include <linux/of.h>
 #include <media/videobuf2-core.h>
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_ctrl.h"
@@ -921,6 +922,8 @@ static int match_child(struct device *dev, void *data)
 	return !strcmp(dev_name(dev), (char *)data);
 }
 
+static void *mfc_get_drv_data(struct platform_device *pdev);
+
 /* MFC probe function */
 static int s5p_mfc_probe(struct platform_device *pdev)
 {
@@ -928,6 +931,8 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	struct resource *res;
 	int ret;
+	unsigned int base_addr;
+	unsigned int bank_size;
 
 	pr_debug("%s++\n", __func__);
 	dev = devm_kzalloc(&pdev->dev, sizeof *dev, GFP_KERNEL);
@@ -944,8 +949,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	dev->variant = (struct s5p_mfc_variant *)
-		platform_get_device_id(pdev)->driver_data;
+	dev->variant = mfc_get_drv_data(pdev);
 
 	ret = s5p_mfc_init_pm(dev);
 	if (ret < 0) {
@@ -975,19 +979,59 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		goto err_res;
 	}
 
-	dev->mem_dev_l = device_find_child(&dev->plat_dev->dev, "s5p-mfc-l",
-					   match_child);
-	if (!dev->mem_dev_l) {
-		mfc_err("Mem child (L) device get failed\n");
-		ret = -ENODEV;
-		goto err_res;
-	}
-	dev->mem_dev_r = device_find_child(&dev->plat_dev->dev, "s5p-mfc-r",
-					   match_child);
-	if (!dev->mem_dev_r) {
-		mfc_err("Mem child (R) device get failed\n");
-		ret = -ENODEV;
-		goto err_res;
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
+
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
@@ -1262,6 +1306,35 @@ static struct platform_device_id mfc_driver_ids[] = {
 };
 MODULE_DEVICE_TABLE(platform, mfc_driver_ids);
 
+static const struct of_device_id exynos_mfc_match[] = {
+	{
+		.compatible = "samsung,s5p-mfc",
+		.data = &mfc_drvdata_v5,
+	}, {
+		.compatible = "samsung,s5p-mfc-v6",
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
@@ -1269,7 +1342,8 @@ static struct platform_driver s5p_mfc_driver = {
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

