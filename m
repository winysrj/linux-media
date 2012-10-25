Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56317 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935051Ab2JYJIV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 05:08:21 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCF00I21YPMRNX0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Oct 2012 18:08:19 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MCF00DIBYMOU750@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Oct 2012 18:08:19 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	ch.naveen@samsung.com, arun.kk@samsung.com, joshi@samsung.com
Subject: [PATCH] s5p-mfc: Add device tree support
Date: Thu, 25 Oct 2012 14:54:14 +0530
Message-id: <1351157054-19428-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1351157054-19428-1-git-send-email-arun.kk@samsung.com>
References: <1351157054-19428-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch will add the device tree support for MFC driver.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |  100 +++++++++++++++++++++++++-----
 1 files changed, 84 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index d5182d6..4432a82 100644
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
@@ -1028,6 +1029,8 @@ static int match_child(struct device *dev, void *data)
 	return !strcmp(dev_name(dev), (char *)data);
 }
 
+static void *mfc_get_drv_data(struct platform_device *pdev);
+
 /* MFC probe function */
 static int s5p_mfc_probe(struct platform_device *pdev)
 {
@@ -1035,6 +1038,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	struct resource *res;
 	int ret;
+	unsigned int mem_info[2];
 
 	pr_debug("%s++\n", __func__);
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
@@ -1051,8 +1055,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	dev->variant = (struct s5p_mfc_variant *)
-		platform_get_device_id(pdev)->driver_data;
+	dev->variant = mfc_get_drv_data(pdev);
 
 	ret = s5p_mfc_init_pm(dev);
 	if (ret < 0) {
@@ -1082,20 +1085,55 @@ static int s5p_mfc_probe(struct platform_device *pdev)
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
+		of_property_read_u32_array(pdev->dev.of_node, "samsung,mfc-l",
+				mem_info, 2);
+		if (dma_declare_coherent_memory(dev->mem_dev_l, mem_info[0],
+				mem_info[0], mem_info[1],
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
+		of_property_read_u32_array(pdev->dev.of_node, "samsung,mfc-r",
+				mem_info, 2);
+		if (dma_declare_coherent_memory(dev->mem_dev_r, mem_info[0],
+				mem_info[0], mem_info[1],
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
@@ -1374,6 +1412,35 @@ static struct platform_device_id mfc_driver_ids[] = {
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
@@ -1381,7 +1448,8 @@ static struct platform_driver s5p_mfc_driver = {
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

