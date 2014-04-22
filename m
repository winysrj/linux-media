Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59352 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbaDVLCy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Apr 2014 07:02:54 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH] [media] s5p-mfc: Add IOMMU support
Date: Tue, 22 Apr 2014 16:32:48 +0530
Message-Id: <1398164568-6048-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch adds IOMMU support for MFC driver.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
This patch is tested on IOMMU support series [1] posted
by KyonHo Cho.
[1] https://lkml.org/lkml/2014/3/14/9
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |   33 ++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 89356ae..1f248ba 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -32,11 +32,18 @@
 #include "s5p_mfc_opr.h"
 #include "s5p_mfc_cmd.h"
 #include "s5p_mfc_pm.h"
+#ifdef CONFIG_EXYNOS_IOMMU
+#include <asm/dma-iommu.h>
+#endif
 
 #define S5P_MFC_NAME		"s5p-mfc"
 #define S5P_MFC_DEC_NAME	"s5p-mfc-dec"
 #define S5P_MFC_ENC_NAME	"s5p-mfc-enc"
 
+#ifdef CONFIG_EXYNOS_IOMMU
+static struct dma_iommu_mapping *mapping;
+#endif
+
 int debug;
 module_param(debug, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug level - higher value produces more verbose messages");
@@ -1013,6 +1020,23 @@ static void *mfc_get_drv_data(struct platform_device *pdev);
 
 static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
 {
+#ifdef CONFIG_EXYNOS_IOMMU
+	struct device *mdev = &dev->plat_dev->dev;
+
+	mapping = arm_iommu_create_mapping(&platform_bus_type, 0x20000000,
+			SZ_256M);
+	if (mapping == NULL) {
+		mfc_err("IOMMU mapping failed\n");
+		return -EFAULT;
+	}
+	mdev->dma_parms = devm_kzalloc(&dev->plat_dev->dev,
+			sizeof(*mdev->dma_parms), GFP_KERNEL);
+	dma_set_max_seg_size(mdev, 0xffffffffu);
+	arm_iommu_attach_device(mdev, mapping);
+
+	dev->mem_dev_l = dev->mem_dev_r = mdev;
+	return 0;
+#else
 	unsigned int mem_info[2] = { };
 
 	dev->mem_dev_l = devm_kzalloc(&dev->plat_dev->dev,
@@ -1049,6 +1073,7 @@ static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
 		return -ENOMEM;
 	}
 	return 0;
+#endif
 }
 
 /* MFC probe function */
@@ -1228,6 +1253,10 @@ err_mem_init_ctx_1:
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
 err_res:
 	s5p_mfc_final_pm(dev);
+#ifdef CONFIG_EXYNOS_IOMMU
+	if (mapping)
+		arm_iommu_release_mapping(mapping);
+#endif
 
 	pr_debug("%s-- with error\n", __func__);
 	return ret;
@@ -1256,6 +1285,10 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 		put_device(dev->mem_dev_r);
 	}
 
+#ifdef CONFIG_EXYNOS_IOMMU
+	if (mapping)
+		arm_iommu_release_mapping(mapping);
+#endif
 	s5p_mfc_final_pm(dev);
 	return 0;
 }
-- 
1.7.9.5

