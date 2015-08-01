Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59713 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbbHAJWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2015 05:22:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 3/4] v4l: atmel-isi: Remove support for platform data
Date: Sat,  1 Aug 2015 12:22:55 +0300
Message-Id: <1438420976-7899-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All in-tree users have migrated to DT, remove support for platform data.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c |  23 ++---
 drivers/media/platform/soc_camera/atmel-isi.h | 131 ++++++++++++++++++++++++++
 include/media/atmel-isi.h                     | 131 --------------------------
 3 files changed, 137 insertions(+), 148 deletions(-)
 create mode 100644 drivers/media/platform/soc_camera/atmel-isi.h
 delete mode 100644 include/media/atmel-isi.h

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index a2e50a734fa3..de9237e56f84 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -23,12 +23,13 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
-#include <media/atmel-isi.h>
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
 #include <media/v4l2-of.h>
 #include <media/videobuf2-dma-contig.h>
 
+#include "atmel-isi.h"
+
 #define MAX_BUFFER_NUM			32
 #define MAX_SUPPORT_WIDTH		2048
 #define MAX_SUPPORT_HEIGHT		2048
@@ -873,7 +874,7 @@ static int atmel_isi_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int atmel_isi_probe_dt(struct atmel_isi *isi,
+static int atmel_isi_parse_dt(struct atmel_isi *isi,
 			struct platform_device *pdev)
 {
 	struct device_node *np= pdev->dev.of_node;
@@ -921,14 +922,6 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	struct resource *regs;
 	int ret, i;
 	struct soc_camera_host *soc_host;
-	struct isi_platform_data *pdata;
-
-	pdata = dev->platform_data;
-	if ((!pdata || !pdata->data_width_flags) && !pdev->dev.of_node) {
-		dev_err(&pdev->dev,
-			"No config available for Atmel ISI\n");
-		return -EINVAL;
-	}
 
 	isi = devm_kzalloc(&pdev->dev, sizeof(struct atmel_isi), GFP_KERNEL);
 	if (!isi) {
@@ -940,13 +933,9 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	if (IS_ERR(isi->pclk))
 		return PTR_ERR(isi->pclk);
 
-	if (pdata) {
-		memcpy(&isi->pdata, pdata, sizeof(isi->pdata));
-	} else {
-		ret = atmel_isi_probe_dt(isi, pdev);
-		if (ret)
-			return ret;
-	}
+	ret = atmel_isi_parse_dt(isi, pdev);
+	if (ret)
+		return ret;
 
 	isi->active = NULL;
 	spin_lock_init(&isi->lock);
diff --git a/drivers/media/platform/soc_camera/atmel-isi.h b/drivers/media/platform/soc_camera/atmel-isi.h
new file mode 100644
index 000000000000..6008b0985b7b
--- /dev/null
+++ b/drivers/media/platform/soc_camera/atmel-isi.h
@@ -0,0 +1,131 @@
+/*
+ * Register definitions for the Atmel Image Sensor Interface.
+ *
+ * Copyright (C) 2011 Atmel Corporation
+ * Josh Wu, <josh.wu@atmel.com>
+ *
+ * Based on previous work by Lars Haring, <lars.haring@atmel.com>
+ * and Sedji Gaouaou
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ATMEL_ISI_H__
+#define __ATMEL_ISI_H__
+
+#include <linux/types.h>
+
+/* ISI_V2 register offsets */
+#define ISI_CFG1				0x0000
+#define ISI_CFG2				0x0004
+#define ISI_PSIZE				0x0008
+#define ISI_PDECF				0x000c
+#define ISI_Y2R_SET0				0x0010
+#define ISI_Y2R_SET1				0x0014
+#define ISI_R2Y_SET0				0x0018
+#define ISI_R2Y_SET1				0x001C
+#define ISI_R2Y_SET2				0x0020
+#define ISI_CTRL				0x0024
+#define ISI_STATUS				0x0028
+#define ISI_INTEN				0x002C
+#define ISI_INTDIS				0x0030
+#define ISI_INTMASK				0x0034
+#define ISI_DMA_CHER				0x0038
+#define ISI_DMA_CHDR				0x003C
+#define ISI_DMA_CHSR				0x0040
+#define ISI_DMA_P_ADDR				0x0044
+#define ISI_DMA_P_CTRL				0x0048
+#define ISI_DMA_P_DSCR				0x004C
+#define ISI_DMA_C_ADDR				0x0050
+#define ISI_DMA_C_CTRL				0x0054
+#define ISI_DMA_C_DSCR				0x0058
+
+/* Bitfields in CFG1 */
+#define ISI_CFG1_HSYNC_POL_ACTIVE_LOW		(1 << 2)
+#define ISI_CFG1_VSYNC_POL_ACTIVE_LOW		(1 << 3)
+#define ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING	(1 << 4)
+#define ISI_CFG1_EMB_SYNC			(1 << 6)
+#define ISI_CFG1_CRC_SYNC			(1 << 7)
+/* Constants for FRATE(ISI_V2) */
+#define		ISI_CFG1_FRATE_CAPTURE_ALL	(0 << 8)
+#define		ISI_CFG1_FRATE_DIV_2		(1 << 8)
+#define		ISI_CFG1_FRATE_DIV_3		(2 << 8)
+#define		ISI_CFG1_FRATE_DIV_4		(3 << 8)
+#define		ISI_CFG1_FRATE_DIV_5		(4 << 8)
+#define		ISI_CFG1_FRATE_DIV_6		(5 << 8)
+#define		ISI_CFG1_FRATE_DIV_7		(6 << 8)
+#define		ISI_CFG1_FRATE_DIV_8		(7 << 8)
+#define		ISI_CFG1_FRATE_DIV_MASK		(7 << 8)
+#define ISI_CFG1_DISCR				(1 << 11)
+#define ISI_CFG1_FULL_MODE			(1 << 12)
+/* Definition for THMASK(ISI_V2) */
+#define		ISI_CFG1_THMASK_BEATS_4		(0 << 13)
+#define		ISI_CFG1_THMASK_BEATS_8		(1 << 13)
+#define		ISI_CFG1_THMASK_BEATS_16	(2 << 13)
+
+/* Bitfields in CFG2 */
+#define ISI_CFG2_GRAYSCALE			(1 << 13)
+/* Constants for YCC_SWAP(ISI_V2) */
+#define		ISI_CFG2_YCC_SWAP_DEFAULT	(0 << 28)
+#define		ISI_CFG2_YCC_SWAP_MODE_1	(1 << 28)
+#define		ISI_CFG2_YCC_SWAP_MODE_2	(2 << 28)
+#define		ISI_CFG2_YCC_SWAP_MODE_3	(3 << 28)
+#define		ISI_CFG2_YCC_SWAP_MODE_MASK	(3 << 28)
+#define ISI_CFG2_IM_VSIZE_OFFSET		0
+#define ISI_CFG2_IM_HSIZE_OFFSET		16
+#define ISI_CFG2_IM_VSIZE_MASK		(0x7FF << ISI_CFG2_IM_VSIZE_OFFSET)
+#define ISI_CFG2_IM_HSIZE_MASK		(0x7FF << ISI_CFG2_IM_HSIZE_OFFSET)
+
+/* Bitfields in CTRL */
+/* Also using in SR(ISI_V2) */
+#define ISI_CTRL_EN				(1 << 0)
+#define ISI_CTRL_CDC				(1 << 8)
+/* Also using in SR/IER/IDR/IMR(ISI_V2) */
+#define ISI_CTRL_DIS				(1 << 1)
+#define ISI_CTRL_SRST				(1 << 2)
+
+/* Bitfields in SR */
+#define ISI_SR_SIP				(1 << 19)
+/* Also using in SR/IER/IDR/IMR */
+#define ISI_SR_VSYNC				(1 << 10)
+#define ISI_SR_PXFR_DONE			(1 << 16)
+#define ISI_SR_CXFR_DONE			(1 << 17)
+#define ISI_SR_P_OVR				(1 << 24)
+#define ISI_SR_C_OVR				(1 << 25)
+#define ISI_SR_CRC_ERR				(1 << 26)
+#define ISI_SR_FR_OVR				(1 << 27)
+
+/* Bitfields in DMA_C_CTRL & in DMA_P_CTRL */
+#define ISI_DMA_CTRL_FETCH			(1 << 0)
+#define ISI_DMA_CTRL_WB				(1 << 1)
+#define ISI_DMA_CTRL_IEN			(1 << 2)
+#define ISI_DMA_CTRL_DONE			(1 << 3)
+
+/* Bitfields in DMA_CHSR/CHER/CHDR */
+#define ISI_DMA_CHSR_P_CH			(1 << 0)
+#define ISI_DMA_CHSR_C_CH			(1 << 1)
+
+/* Definition for isi_platform_data */
+#define ISI_DATAWIDTH_8				0x01
+#define ISI_DATAWIDTH_10			0x02
+
+struct v4l2_async_subdev;
+
+struct isi_platform_data {
+	u8 has_emb_sync;
+	u8 emb_crc_sync;
+	u8 hsync_act_low;
+	u8 vsync_act_low;
+	u8 pclk_act_falling;
+	u8 full_mode;
+	u32 data_width_flags;
+	/* Using for ISI_CFG1 */
+	u32 frate;
+	/* Using for ISI_MCK */
+	u32 mck_hz;
+	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
+	int *asd_sizes;		/* 0-terminated array of asd group sizes */
+};
+
+#endif /* __ATMEL_ISI_H__ */
diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
deleted file mode 100644
index 6008b0985b7b..000000000000
--- a/include/media/atmel-isi.h
+++ /dev/null
@@ -1,131 +0,0 @@
-/*
- * Register definitions for the Atmel Image Sensor Interface.
- *
- * Copyright (C) 2011 Atmel Corporation
- * Josh Wu, <josh.wu@atmel.com>
- *
- * Based on previous work by Lars Haring, <lars.haring@atmel.com>
- * and Sedji Gaouaou
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef __ATMEL_ISI_H__
-#define __ATMEL_ISI_H__
-
-#include <linux/types.h>
-
-/* ISI_V2 register offsets */
-#define ISI_CFG1				0x0000
-#define ISI_CFG2				0x0004
-#define ISI_PSIZE				0x0008
-#define ISI_PDECF				0x000c
-#define ISI_Y2R_SET0				0x0010
-#define ISI_Y2R_SET1				0x0014
-#define ISI_R2Y_SET0				0x0018
-#define ISI_R2Y_SET1				0x001C
-#define ISI_R2Y_SET2				0x0020
-#define ISI_CTRL				0x0024
-#define ISI_STATUS				0x0028
-#define ISI_INTEN				0x002C
-#define ISI_INTDIS				0x0030
-#define ISI_INTMASK				0x0034
-#define ISI_DMA_CHER				0x0038
-#define ISI_DMA_CHDR				0x003C
-#define ISI_DMA_CHSR				0x0040
-#define ISI_DMA_P_ADDR				0x0044
-#define ISI_DMA_P_CTRL				0x0048
-#define ISI_DMA_P_DSCR				0x004C
-#define ISI_DMA_C_ADDR				0x0050
-#define ISI_DMA_C_CTRL				0x0054
-#define ISI_DMA_C_DSCR				0x0058
-
-/* Bitfields in CFG1 */
-#define ISI_CFG1_HSYNC_POL_ACTIVE_LOW		(1 << 2)
-#define ISI_CFG1_VSYNC_POL_ACTIVE_LOW		(1 << 3)
-#define ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING	(1 << 4)
-#define ISI_CFG1_EMB_SYNC			(1 << 6)
-#define ISI_CFG1_CRC_SYNC			(1 << 7)
-/* Constants for FRATE(ISI_V2) */
-#define		ISI_CFG1_FRATE_CAPTURE_ALL	(0 << 8)
-#define		ISI_CFG1_FRATE_DIV_2		(1 << 8)
-#define		ISI_CFG1_FRATE_DIV_3		(2 << 8)
-#define		ISI_CFG1_FRATE_DIV_4		(3 << 8)
-#define		ISI_CFG1_FRATE_DIV_5		(4 << 8)
-#define		ISI_CFG1_FRATE_DIV_6		(5 << 8)
-#define		ISI_CFG1_FRATE_DIV_7		(6 << 8)
-#define		ISI_CFG1_FRATE_DIV_8		(7 << 8)
-#define		ISI_CFG1_FRATE_DIV_MASK		(7 << 8)
-#define ISI_CFG1_DISCR				(1 << 11)
-#define ISI_CFG1_FULL_MODE			(1 << 12)
-/* Definition for THMASK(ISI_V2) */
-#define		ISI_CFG1_THMASK_BEATS_4		(0 << 13)
-#define		ISI_CFG1_THMASK_BEATS_8		(1 << 13)
-#define		ISI_CFG1_THMASK_BEATS_16	(2 << 13)
-
-/* Bitfields in CFG2 */
-#define ISI_CFG2_GRAYSCALE			(1 << 13)
-/* Constants for YCC_SWAP(ISI_V2) */
-#define		ISI_CFG2_YCC_SWAP_DEFAULT	(0 << 28)
-#define		ISI_CFG2_YCC_SWAP_MODE_1	(1 << 28)
-#define		ISI_CFG2_YCC_SWAP_MODE_2	(2 << 28)
-#define		ISI_CFG2_YCC_SWAP_MODE_3	(3 << 28)
-#define		ISI_CFG2_YCC_SWAP_MODE_MASK	(3 << 28)
-#define ISI_CFG2_IM_VSIZE_OFFSET		0
-#define ISI_CFG2_IM_HSIZE_OFFSET		16
-#define ISI_CFG2_IM_VSIZE_MASK		(0x7FF << ISI_CFG2_IM_VSIZE_OFFSET)
-#define ISI_CFG2_IM_HSIZE_MASK		(0x7FF << ISI_CFG2_IM_HSIZE_OFFSET)
-
-/* Bitfields in CTRL */
-/* Also using in SR(ISI_V2) */
-#define ISI_CTRL_EN				(1 << 0)
-#define ISI_CTRL_CDC				(1 << 8)
-/* Also using in SR/IER/IDR/IMR(ISI_V2) */
-#define ISI_CTRL_DIS				(1 << 1)
-#define ISI_CTRL_SRST				(1 << 2)
-
-/* Bitfields in SR */
-#define ISI_SR_SIP				(1 << 19)
-/* Also using in SR/IER/IDR/IMR */
-#define ISI_SR_VSYNC				(1 << 10)
-#define ISI_SR_PXFR_DONE			(1 << 16)
-#define ISI_SR_CXFR_DONE			(1 << 17)
-#define ISI_SR_P_OVR				(1 << 24)
-#define ISI_SR_C_OVR				(1 << 25)
-#define ISI_SR_CRC_ERR				(1 << 26)
-#define ISI_SR_FR_OVR				(1 << 27)
-
-/* Bitfields in DMA_C_CTRL & in DMA_P_CTRL */
-#define ISI_DMA_CTRL_FETCH			(1 << 0)
-#define ISI_DMA_CTRL_WB				(1 << 1)
-#define ISI_DMA_CTRL_IEN			(1 << 2)
-#define ISI_DMA_CTRL_DONE			(1 << 3)
-
-/* Bitfields in DMA_CHSR/CHER/CHDR */
-#define ISI_DMA_CHSR_P_CH			(1 << 0)
-#define ISI_DMA_CHSR_C_CH			(1 << 1)
-
-/* Definition for isi_platform_data */
-#define ISI_DATAWIDTH_8				0x01
-#define ISI_DATAWIDTH_10			0x02
-
-struct v4l2_async_subdev;
-
-struct isi_platform_data {
-	u8 has_emb_sync;
-	u8 emb_crc_sync;
-	u8 hsync_act_low;
-	u8 vsync_act_low;
-	u8 pclk_act_falling;
-	u8 full_mode;
-	u32 data_width_flags;
-	/* Using for ISI_CFG1 */
-	u32 frate;
-	/* Using for ISI_MCK */
-	u32 mck_hz;
-	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
-	int *asd_sizes;		/* 0-terminated array of asd group sizes */
-};
-
-#endif /* __ATMEL_ISI_H__ */
-- 
2.3.6

