Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57934 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935274Ab2JYU0C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 16:26:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v2] omap3isp: Remove unneeded module memory address definitions
Date: Thu, 25 Oct 2012 22:26:50 +0200
Message-Id: <1351196810-27560-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The OMAP3ISP_*_REG_OFFSET, OMAP3ISP_*_REG_BASE and OMAP3ISP_*_REG macros
are not needed. Remove them.

The only expection is the OMAP3ISP_HIST_REG_BASE address. Replace it
with the memory address received through platform resources.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/isphist.c |    8 ++-
 drivers/media/platform/omap3isp/ispreg.h  |   77 -----------------------------
 2 files changed, 6 insertions(+), 79 deletions(-)

Changes since v1:

- Fix a crash in hist_dma_config() caused by the unset hist->isp field.

diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index d1a8dee..74326ff 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -72,11 +72,14 @@ static void hist_reset_mem(struct ispstat *hist)
 
 static void hist_dma_config(struct ispstat *hist)
 {
+	struct isp_device *isp = hist->isp;
+
 	hist->dma_config.data_type = OMAP_DMA_DATA_TYPE_S32;
 	hist->dma_config.sync_mode = OMAP_DMA_SYNC_ELEMENT;
 	hist->dma_config.frame_count = 1;
 	hist->dma_config.src_amode = OMAP_DMA_AMODE_CONSTANT;
-	hist->dma_config.src_start = OMAP3ISP_HIST_REG_BASE + ISPHIST_DATA;
+	hist->dma_config.src_start = isp->mmio_base_phys[OMAP3_ISP_IOMEM_HIST]
+				   + ISPHIST_DATA;
 	hist->dma_config.dst_amode = OMAP_DMA_AMODE_POST_INC;
 	hist->dma_config.src_or_dst_synch = OMAP_DMA_SRC_SYNC;
 }
@@ -477,6 +480,8 @@ int omap3isp_hist_init(struct isp_device *isp)
 		return -ENOMEM;
 
 	memset(hist, 0, sizeof(*hist));
+	hist->isp = isp;
+
 	if (HIST_CONFIG_DMA)
 		ret = omap_request_dma(OMAP24XX_DMA_NO_DEVICE, "DMA_ISP_HIST",
 				       hist_dma_cb, hist, &hist->dma_ch);
@@ -494,7 +499,6 @@ int omap3isp_hist_init(struct isp_device *isp)
 	hist->ops = &hist_ops;
 	hist->priv = hist_cfg;
 	hist->event_type = V4L2_EVENT_OMAP3ISP_HIST;
-	hist->isp = isp;
 
 	ret = omap3isp_stat_init(hist, "histogram", &hist_subdev_ops);
 	if (ret) {
diff --git a/drivers/media/platform/omap3isp/ispreg.h b/drivers/media/platform/omap3isp/ispreg.h
index e2c57f3..fd13d8b 100644
--- a/drivers/media/platform/omap3isp/ispreg.h
+++ b/drivers/media/platform/omap3isp/ispreg.h
@@ -29,83 +29,6 @@
 
 #define CM_CAM_MCLK_HZ			172800000	/* Hz */
 
-/* ISP Submodules offset */
-
-#define L4_34XX_BASE			0x48000000
-#define OMAP3430_ISP_BASE		(L4_34XX_BASE + 0xBC000)
-
-#define OMAP3ISP_REG_BASE		OMAP3430_ISP_BASE
-#define OMAP3ISP_REG(offset)		(OMAP3ISP_REG_BASE + (offset))
-
-#define OMAP3ISP_CCP2_REG_OFFSET	0x0400
-#define OMAP3ISP_CCP2_REG_BASE		(OMAP3ISP_REG_BASE +		\
-					 OMAP3ISP_CCP2_REG_OFFSET)
-#define OMAP3ISP_CCP2_REG(offset)	(OMAP3ISP_CCP2_REG_BASE + (offset))
-
-#define OMAP3ISP_CCDC_REG_OFFSET	0x0600
-#define OMAP3ISP_CCDC_REG_BASE		(OMAP3ISP_REG_BASE +		\
-					 OMAP3ISP_CCDC_REG_OFFSET)
-#define OMAP3ISP_CCDC_REG(offset)	(OMAP3ISP_CCDC_REG_BASE + (offset))
-
-#define OMAP3ISP_HIST_REG_OFFSET	0x0A00
-#define OMAP3ISP_HIST_REG_BASE		(OMAP3ISP_REG_BASE +		\
-					 OMAP3ISP_HIST_REG_OFFSET)
-#define OMAP3ISP_HIST_REG(offset)	(OMAP3ISP_HIST_REG_BASE + (offset))
-
-#define OMAP3ISP_H3A_REG_OFFSET		0x0C00
-#define OMAP3ISP_H3A_REG_BASE		(OMAP3ISP_REG_BASE +		\
-					 OMAP3ISP_H3A_REG_OFFSET)
-#define OMAP3ISP_H3A_REG(offset)	(OMAP3ISP_H3A_REG_BASE + (offset))
-
-#define OMAP3ISP_PREV_REG_OFFSET	0x0E00
-#define OMAP3ISP_PREV_REG_BASE		(OMAP3ISP_REG_BASE +		\
-					 OMAP3ISP_PREV_REG_OFFSET)
-#define OMAP3ISP_PREV_REG(offset)	(OMAP3ISP_PREV_REG_BASE + (offset))
-
-#define OMAP3ISP_RESZ_REG_OFFSET	0x1000
-#define OMAP3ISP_RESZ_REG_BASE		(OMAP3ISP_REG_BASE +		\
-					 OMAP3ISP_RESZ_REG_OFFSET)
-#define OMAP3ISP_RESZ_REG(offset)	(OMAP3ISP_RESZ_REG_BASE + (offset))
-
-#define OMAP3ISP_SBL_REG_OFFSET		0x1200
-#define OMAP3ISP_SBL_REG_BASE		(OMAP3ISP_REG_BASE +		\
-					 OMAP3ISP_SBL_REG_OFFSET)
-#define OMAP3ISP_SBL_REG(offset)	(OMAP3ISP_SBL_REG_BASE + (offset))
-
-#define OMAP3ISP_CSI2A_REGS1_REG_OFFSET	0x1800
-#define OMAP3ISP_CSI2A_REGS1_REG_BASE	(OMAP3ISP_REG_BASE +		\
-					 OMAP3ISP_CSI2A_REGS1_REG_OFFSET)
-#define OMAP3ISP_CSI2A_REGS1_REG(offset)				\
-				(OMAP3ISP_CSI2A_REGS1_REG_BASE + (offset))
-
-#define OMAP3ISP_CSIPHY2_REG_OFFSET	0x1970
-#define OMAP3ISP_CSIPHY2_REG_BASE	(OMAP3ISP_REG_BASE +	\
-					 OMAP3ISP_CSIPHY2_REG_OFFSET)
-#define OMAP3ISP_CSIPHY2_REG(offset)	(OMAP3ISP_CSIPHY2_REG_BASE + (offset))
-
-#define OMAP3ISP_CSI2A_REGS2_REG_OFFSET	0x19C0
-#define OMAP3ISP_CSI2A_REGS2_REG_BASE	(OMAP3ISP_REG_BASE +		\
-					 OMAP3ISP_CSI2A_REGS2_REG_OFFSET)
-#define OMAP3ISP_CSI2A_REGS2_REG(offset)				\
-				(OMAP3ISP_CSI2A_REGS2_REG_BASE + (offset))
-
-#define OMAP3ISP_CSI2C_REGS1_REG_OFFSET	0x1C00
-#define OMAP3ISP_CSI2C_REGS1_REG_BASE	(OMAP3ISP_REG_BASE +		\
-					 OMAP3ISP_CSI2C_REGS1_REG_OFFSET)
-#define OMAP3ISP_CSI2C_REGS1_REG(offset)				\
-				(OMAP3ISP_CSI2C_REGS1_REG_BASE + (offset))
-
-#define OMAP3ISP_CSIPHY1_REG_OFFSET	0x1D70
-#define OMAP3ISP_CSIPHY1_REG_BASE	(OMAP3ISP_REG_BASE +	\
-					 OMAP3ISP_CSIPHY1_REG_OFFSET)
-#define OMAP3ISP_CSIPHY1_REG(offset)	(OMAP3ISP_CSIPHY1_REG_BASE + (offset))
-
-#define OMAP3ISP_CSI2C_REGS2_REG_OFFSET	0x1DC0
-#define OMAP3ISP_CSI2C_REGS2_REG_BASE	(OMAP3ISP_REG_BASE +		\
-					 OMAP3ISP_CSI2C_REGS2_REG_OFFSET)
-#define OMAP3ISP_CSI2C_REGS2_REG(offset)				\
-				(OMAP3ISP_CSI2C_REGS2_REG_BASE + (offset))
-
 /* ISP module register offset */
 
 #define ISP_REVISION			(0x000)
-- 
Regards,

Laurent Pinchart

