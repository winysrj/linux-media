Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17324 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965788AbbLPPhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 10:37:42 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v3 6/7] media: s5p-mfc: replace custom reserved memory init
 code with generic one
Date: Wed, 16 Dec 2015 16:37:28 +0100
Message-id: <1450280249-24681-7-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1450280249-24681-1-git-send-email-m.szyprowski@samsung.com>
References: <1450280249-24681-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes custom code for initialization and handling of
reserved memory regions in s5p-mfc driver and replaces it with generic
named reserved memory regions specified in device tree.

s5p-mfc driver now handles two reserved memory regions: "left" and
"right", defined by generic reserved memory bindings. Support for non-dt
platform has been removed, because all supported platforms have been
converted to device tree.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 129 +++++++++++++++----------------
 1 file changed, 62 insertions(+), 67 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 3e9cdafe2168..306344994c8e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -22,6 +22,7 @@
 #include <media/v4l2-event.h>
 #include <linux/workqueue.h>
 #include <linux/of.h>
+#include <linux/of_reserved_mem.h>
 #include <media/videobuf2-v4l2.h>
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_ctrl.h"
@@ -1022,55 +1023,67 @@ static const struct v4l2_file_operations s5p_mfc_fops = {
 	.mmap = s5p_mfc_mmap,
 };
 
-static int match_child(struct device *dev, void *data)
+/* DMA memory related helper functions */
+static void s5p_mfc_memdev_release(struct device *dev)
 {
-	if (!dev_name(dev))
-		return 0;
-	return !strcmp(dev_name(dev), (char *)data);
+	of_reserved_mem_device_release(dev);
 }
 
-static void *mfc_get_drv_data(struct platform_device *pdev);
-
-static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
+static struct device *s5p_mfc_alloc_memdev(struct device *dev, const char *name)
 {
-	unsigned int mem_info[2] = { };
+	struct device *child;
+	int ret;
 
-	dev->mem_dev_l = devm_kzalloc(&dev->plat_dev->dev,
-			sizeof(struct device), GFP_KERNEL);
-	if (!dev->mem_dev_l) {
-		mfc_err("Not enough memory\n");
-		return -ENOMEM;
-	}
-	device_initialize(dev->mem_dev_l);
-	of_property_read_u32_array(dev->plat_dev->dev.of_node,
-			"samsung,mfc-l", mem_info, 2);
-	if (dma_declare_coherent_memory(dev->mem_dev_l, mem_info[0],
-				mem_info[0], mem_info[1],
-				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
-		mfc_err("Failed to declare coherent memory for\n"
-		"MFC device\n");
-		return -ENOMEM;
+	child = devm_kzalloc(dev, sizeof(struct device), GFP_KERNEL);
+	if (!child)
+		return NULL;
+
+	device_initialize(child);
+	dev_set_name(child, "%s:%s", dev_name(dev), name);
+	child->parent = dev;
+	child->bus = dev->bus;
+	child->coherent_dma_mask = dev->coherent_dma_mask;
+	child->dma_mask = dev->dma_mask;
+	child->release = s5p_mfc_memdev_release;
+
+	if (device_add(child) == 0) {
+		ret = of_reserved_mem_init_by_name(child, dev->of_node, name);
+		if (ret == 0)
+			return child;
 	}
 
-	dev->mem_dev_r = devm_kzalloc(&dev->plat_dev->dev,
-			sizeof(struct device), GFP_KERNEL);
-	if (!dev->mem_dev_r) {
-		mfc_err("Not enough memory\n");
-		return -ENOMEM;
-	}
-	device_initialize(dev->mem_dev_r);
-	of_property_read_u32_array(dev->plat_dev->dev.of_node,
-			"samsung,mfc-r", mem_info, 2);
-	if (dma_declare_coherent_memory(dev->mem_dev_r, mem_info[0],
-				mem_info[0], mem_info[1],
-				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE) == 0) {
-		pr_err("Failed to declare coherent memory for\n"
-		"MFC device\n");
-		return -ENOMEM;
+	put_device(child);
+	return NULL;
+}
+
+static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
+{
+	struct device *dev = &mfc_dev->plat_dev->dev;
+
+	/*
+	 * Create and initialize virtual devices for accessing
+	 * reserved memory regions.
+	 */
+	mfc_dev->mem_dev_l = s5p_mfc_alloc_memdev(dev, "left");
+	if (!mfc_dev->mem_dev_l)
+		return -ENODEV;
+	mfc_dev->mem_dev_r = s5p_mfc_alloc_memdev(dev, "right");
+	if (!mfc_dev->mem_dev_r) {
+		device_unregister(mfc_dev->mem_dev_l);
+		return -ENODEV;
 	}
+
 	return 0;
 }
 
+static void s5p_mfc_unconfigure_dma_memory(struct s5p_mfc_dev *mfc_dev)
+{
+	device_unregister(mfc_dev->mem_dev_l);
+	device_unregister(mfc_dev->mem_dev_r);
+}
+
+static void *mfc_get_drv_data(struct platform_device *pdev);
+
 /* MFC probe function */
 static int s5p_mfc_probe(struct platform_device *pdev)
 {
@@ -1096,12 +1109,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 
 	dev->variant = mfc_get_drv_data(pdev);
 
-	ret = s5p_mfc_init_pm(dev);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "failed to get mfc clock source\n");
-		return ret;
-	}
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	dev->regs_base = devm_ioremap_resource(&pdev->dev, res);
@@ -1122,25 +1129,16 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		goto err_res;
 	}
 
-	if (pdev->dev.of_node) {
-		ret = s5p_mfc_alloc_memdevs(dev);
-		if (ret < 0)
-			goto err_res;
-	} else {
-		dev->mem_dev_l = device_find_child(&dev->plat_dev->dev,
-				"s5p-mfc-l", match_child);
-		if (!dev->mem_dev_l) {
-			mfc_err("Mem child (L) device get failed\n");
-			ret = -ENODEV;
-			goto err_res;
-		}
-		dev->mem_dev_r = device_find_child(&dev->plat_dev->dev,
-				"s5p-mfc-r", match_child);
-		if (!dev->mem_dev_r) {
-			mfc_err("Mem child (R) device get failed\n");
-			ret = -ENODEV;
-			goto err_res;
-		}
+	ret = s5p_mfc_configure_dma_memory(dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to configure DMA memory\n");
+		return ret;
+	}
+
+	ret = s5p_mfc_init_pm(dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to get mfc clock source\n");
+		return ret;
 	}
 
 	vb2_dma_contig_set_max_seg_size(dev->mem_dev_l, DMA_BIT_MASK(32));
@@ -1274,10 +1272,7 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 	s5p_mfc_release_firmware(dev);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
-	if (pdev->dev.of_node) {
-		put_device(dev->mem_dev_l);
-		put_device(dev->mem_dev_r);
-	}
+	s5p_mfc_unconfigure_dma_memory(dev);
 
 	s5p_mfc_final_pm(dev);
 	return 0;
-- 
1.9.2

