Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:54051 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3ARKtB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jan 2013 05:49:01 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGT00FBKI1CPXC0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 18 Jan 2013 19:48:59 +0900 (KST)
Received: from ubuntu.sisodomain.com ([107.108.73.176])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MGT00F17I19OI80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 18 Jan 2013 19:48:59 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH] [media] s5p-mfc: Fix kernel warning on memory init
Date: Sat, 19 Jan 2013 01:12:34 +0530
Message-id: <1358538154-29812-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleaned up the memory devices allocation code and added
missing device_initialize() call to remove the kernel warning
during memory allocations.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |   78 +++++++++++++++++-------------
 1 file changed, 45 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index b1d7f9a..ac69e9b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1029,6 +1029,46 @@ static int match_child(struct device *dev, void *data)
 
 static void *mfc_get_drv_data(struct platform_device *pdev);
 
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
+	of_property_read_u32_array(dev->plat_dev->dev.of_node,
+			"samsung,mfc-l", mem_info, 2);
+	if (dma_declare_coherent_memory(dev->mem_dev_l, mem_info[0],
+				mem_info[0], mem_info[1],
+				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
+		mfc_err("Failed to declare coherent memory for\n"
+		"MFC device\n");
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
+	of_property_read_u32_array(dev->plat_dev->dev.of_node,
+			"samsung,mfc-r", mem_info, 2);
+	if (dma_declare_coherent_memory(dev->mem_dev_r, mem_info[0],
+				mem_info[0], mem_info[1],
+				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
+		pr_err("Failed to declare coherent memory for\n"
+		"MFC device\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 /* MFC probe function */
 static int s5p_mfc_probe(struct platform_device *pdev)
 {
@@ -1036,7 +1076,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	struct resource *res;
 	int ret;
-	unsigned int mem_info[2];
 
 	pr_debug("%s++\n", __func__);
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
@@ -1084,39 +1123,8 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	}
 
 	if (pdev->dev.of_node) {
-		dev->mem_dev_l = kzalloc(sizeof(struct device), GFP_KERNEL);
-		if (!dev->mem_dev_l) {
-			mfc_err("Not enough memory\n");
-			ret = -ENOMEM;
-			goto err_res;
-		}
-		of_property_read_u32_array(pdev->dev.of_node, "samsung,mfc-l",
-				mem_info, 2);
-		if (dma_declare_coherent_memory(dev->mem_dev_l, mem_info[0],
-				mem_info[0], mem_info[1],
-				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
-			mfc_err("Failed to declare coherent memory for\n"
-					"MFC device\n");
-			ret = -ENOMEM;
+		if (s5p_mfc_alloc_memdevs(dev) < 0)
 			goto err_res;
-		}
-
-		dev->mem_dev_r = kzalloc(sizeof(struct device), GFP_KERNEL);
-		if (!dev->mem_dev_r) {
-			mfc_err("Not enough memory\n");
-			ret = -ENOMEM;
-			goto err_res;
-		}
-		of_property_read_u32_array(pdev->dev.of_node, "samsung,mfc-r",
-				mem_info, 2);
-		if (dma_declare_coherent_memory(dev->mem_dev_r, mem_info[0],
-				mem_info[0], mem_info[1],
-				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
-			pr_err("Failed to declare coherent memory for\n"
-					"MFC device\n");
-			ret = -ENOMEM;
-			goto err_res;
-		}
 	} else {
 		dev->mem_dev_l = device_find_child(&dev->plat_dev->dev,
 				"s5p-mfc-l", match_child);
@@ -1262,6 +1270,10 @@ static int __devexit s5p_mfc_remove(struct platform_device *pdev)
 	s5p_mfc_release_firmware(dev);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
+	if (pdev->dev.of_node) {
+		put_device(dev->mem_dev_l);
+		put_device(dev->mem_dev_r);
+	}
 
 	s5p_mfc_final_pm(dev);
 	return 0;
-- 
1.7.9.5

