Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38683 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaDUM3M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 07/26] omap3isp: ccdc: Use the DMA API for LSC
Date: Mon, 21 Apr 2014 14:28:53 +0200
Message-Id: <1398083352-8451-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the OMAP-specific IOMMU API usage by the DMA API for LSC. The
table is now allocated using dma_alloc_coherent() and the related sg
table is retrieved using dma_get_sgtable() for sync operations.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 52 ++++++++++++++-----------------
 drivers/media/platform/omap3isp/ispccdc.h |  8 +++--
 2 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 4d920c8..a907b20 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -206,7 +206,8 @@ static int ccdc_lsc_validate_config(struct isp_ccdc_device *ccdc,
  * ccdc_lsc_program_table - Program Lens Shading Compensation table address.
  * @ccdc: Pointer to ISP CCDC device.
  */
-static void ccdc_lsc_program_table(struct isp_ccdc_device *ccdc, u32 addr)
+static void ccdc_lsc_program_table(struct isp_ccdc_device *ccdc,
+				   dma_addr_t addr)
 {
 	isp_reg_writel(to_isp_device(ccdc), addr,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_TABLE_BASE);
@@ -333,7 +334,7 @@ static int __ccdc_lsc_configure(struct isp_ccdc_device *ccdc,
 		return -EBUSY;
 
 	ccdc_lsc_setup_regs(ccdc, &req->config);
-	ccdc_lsc_program_table(ccdc, req->table);
+	ccdc_lsc_program_table(ccdc, req->table.dma);
 	return 0;
 }
 
@@ -368,11 +369,12 @@ static void ccdc_lsc_free_request(struct isp_ccdc_device *ccdc,
 	if (req == NULL)
 		return;
 
-	if (req->iovm)
-		dma_unmap_sg(isp->dev, req->iovm->sgt->sgl,
-			     req->iovm->sgt->nents, DMA_TO_DEVICE);
-	if (req->table)
-		omap_iommu_vfree(isp->domain, isp->dev, req->table);
+	if (req->table.addr) {
+		sg_free_table(&req->table.sgt);
+		dma_free_coherent(isp->dev, req->config.size, req->table.addr,
+				  req->table.dma);
+	}
+
 	kfree(req);
 }
 
@@ -416,7 +418,6 @@ static int ccdc_lsc_config(struct isp_ccdc_device *ccdc,
 	struct isp_device *isp = to_isp_device(ccdc);
 	struct ispccdc_lsc_config_req *req;
 	unsigned long flags;
-	void *table;
 	u16 update;
 	int ret;
 
@@ -444,38 +445,31 @@ static int ccdc_lsc_config(struct isp_ccdc_device *ccdc,
 
 		req->enable = 1;
 
-		req->table = omap_iommu_vmalloc(isp->domain, isp->dev, 0,
-					req->config.size, IOMMU_FLAG);
-		if (IS_ERR_VALUE(req->table)) {
-			req->table = 0;
-			ret = -ENOMEM;
-			goto done;
-		}
-
-		req->iovm = omap_find_iovm_area(isp->dev, req->table);
-		if (req->iovm == NULL) {
+		req->table.addr = dma_alloc_coherent(isp->dev, req->config.size,
+						     &req->table.dma,
+						     GFP_KERNEL);
+		if (req->table.addr == NULL) {
 			ret = -ENOMEM;
 			goto done;
 		}
 
-		if (!dma_map_sg(isp->dev, req->iovm->sgt->sgl,
-				req->iovm->sgt->nents, DMA_TO_DEVICE)) {
-			ret = -ENOMEM;
-			req->iovm = NULL;
+		ret = dma_get_sgtable(isp->dev, &req->table.sgt,
+				      req->table.addr, req->table.dma,
+				      req->config.size);
+		if (ret < 0)
 			goto done;
-		}
 
-		dma_sync_sg_for_cpu(isp->dev, req->iovm->sgt->sgl,
-				    req->iovm->sgt->nents, DMA_TO_DEVICE);
+		dma_sync_sg_for_cpu(isp->dev, req->table.sgt.sgl,
+				    req->table.sgt.nents, DMA_TO_DEVICE);
 
-		table = omap_da_to_va(isp->dev, req->table);
-		if (copy_from_user(table, config->lsc, req->config.size)) {
+		if (copy_from_user(req->table.addr, config->lsc,
+				   req->config.size)) {
 			ret = -EFAULT;
 			goto done;
 		}
 
-		dma_sync_sg_for_device(isp->dev, req->iovm->sgt->sgl,
-				       req->iovm->sgt->nents, DMA_TO_DEVICE);
+		dma_sync_sg_for_device(isp->dev, req->table.sgt.sgl,
+				       req->table.sgt.nents, DMA_TO_DEVICE);
 	}
 
 	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
diff --git a/drivers/media/platform/omap3isp/ispccdc.h b/drivers/media/platform/omap3isp/ispccdc.h
index 9d24e41..20db3a0 100644
--- a/drivers/media/platform/omap3isp/ispccdc.h
+++ b/drivers/media/platform/omap3isp/ispccdc.h
@@ -57,8 +57,12 @@ struct ispccdc_lsc_config_req {
 	struct list_head list;
 	struct omap3isp_ccdc_lsc_config config;
 	unsigned char enable;
-	u32 table;
-	struct iovm_struct *iovm;
+
+	struct {
+		void *addr;
+		dma_addr_t dma;
+		struct sg_table sgt;
+	} table;
 };
 
 /*
-- 
1.8.3.2

