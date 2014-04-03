Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52433 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaDCWiD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 18:38:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 08/25] omap3isp: ccdc: Use the DMA API for FPC
Date: Fri,  4 Apr 2014 00:39:38 +0200
Message-Id: <1396564795-27192-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the OMAP-specific IOMMU API usage by the DMA API for FPC. The
table is now allocated using dma_alloc_coherent() and the related sg
table is retrieved using dma_get_sgtable() for sync operations.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 51 +++++++++++++++++--------------
 drivers/media/platform/omap3isp/ispccdc.h |  8 ++++-
 2 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index a907b20..004a4f5 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -30,7 +30,6 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/mm.h>
-#include <linux/omap-iommu.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <media/v4l2-event.h>
@@ -578,7 +577,7 @@ static void ccdc_configure_fpc(struct isp_ccdc_device *ccdc)
 	if (!ccdc->fpc_en)
 		return;
 
-	isp_reg_writel(isp, ccdc->fpc.fpcaddr, OMAP3_ISP_IOMEM_CCDC,
+	isp_reg_writel(isp, ccdc->fpc.dma, OMAP3_ISP_IOMEM_CCDC,
 		       ISPCCDC_FPC_ADDR);
 	/* The FPNUM field must be set before enabling FPC. */
 	isp_reg_writel(isp, (ccdc->fpc.fpnum << ISPCCDC_FPC_FPNUM_SHIFT),
@@ -718,8 +717,9 @@ static int ccdc_config(struct isp_ccdc_device *ccdc,
 	ccdc->shadow_update = 0;
 
 	if (OMAP3ISP_CCDC_FPC & ccdc_struct->update) {
-		u32 table_old = 0;
-		u32 table_new;
+		struct omap3isp_ccdc_fpc fpc;
+		struct ispccdc_fpc fpc_old = { .addr = NULL, };
+		struct ispccdc_fpc fpc_new;
 		u32 size;
 
 		if (ccdc->state != ISP_PIPELINE_STREAM_STOPPED)
@@ -728,35 +728,39 @@ static int ccdc_config(struct isp_ccdc_device *ccdc,
 		ccdc->fpc_en = !!(OMAP3ISP_CCDC_FPC & ccdc_struct->flag);
 
 		if (ccdc->fpc_en) {
-			if (copy_from_user(&ccdc->fpc, ccdc_struct->fpc,
-					   sizeof(ccdc->fpc)))
+			if (copy_from_user(&fpc, ccdc_struct->fpc, sizeof(fpc)))
 				return -EFAULT;
 
+			size = fpc.fpnum * 4;
+
 			/*
-			 * table_new must be 64-bytes aligned, but it's
-			 * already done by omap_iommu_vmalloc().
+			 * The table address must be 64-bytes aligned, which is
+			 * guaranteed by dma_alloc_coherent().
 			 */
-			size = ccdc->fpc.fpnum * 4;
-			table_new = omap_iommu_vmalloc(isp->domain, isp->dev,
-							0, size, IOMMU_FLAG);
-			if (IS_ERR_VALUE(table_new))
+			fpc_new.fpnum = fpc.fpnum;
+			fpc_new.addr = dma_alloc_coherent(isp->dev, size,
+							  &fpc_new.dma,
+							  GFP_KERNEL);
+			if (fpc_new.addr == NULL)
 				return -ENOMEM;
 
-			if (copy_from_user(omap_da_to_va(isp->dev, table_new),
-					   (__force void __user *)
-					   ccdc->fpc.fpcaddr, size)) {
-				omap_iommu_vfree(isp->domain, isp->dev,
-								table_new);
+			if (copy_from_user(fpc_new.addr,
+					   (__force void __user *)fpc.fpcaddr,
+					   size)) {
+				dma_free_coherent(isp->dev, size, fpc_new.addr,
+						  fpc_new.dma);
 				return -EFAULT;
 			}
 
-			table_old = ccdc->fpc.fpcaddr;
-			ccdc->fpc.fpcaddr = table_new;
+			fpc_old = ccdc->fpc;
+			ccdc->fpc = fpc_new;
 		}
 
 		ccdc_configure_fpc(ccdc);
-		if (table_old != 0)
-			omap_iommu_vfree(isp->domain, isp->dev, table_old);
+
+		if (fpc_old.addr != NULL)
+			dma_free_coherent(isp->dev, fpc_old.fpnum * 4,
+					  fpc_old.addr, fpc_old.dma);
 	}
 
 	return ccdc_lsc_config(ccdc, ccdc_struct);
@@ -2574,8 +2578,9 @@ void omap3isp_ccdc_cleanup(struct isp_device *isp)
 	cancel_work_sync(&ccdc->lsc.table_work);
 	ccdc_lsc_free_queue(ccdc, &ccdc->lsc.free_queue);
 
-	if (ccdc->fpc.fpcaddr != 0)
-		omap_iommu_vfree(isp->domain, isp->dev, ccdc->fpc.fpcaddr);
+	if (ccdc->fpc.addr != NULL)
+		dma_free_coherent(isp->dev, ccdc->fpc.fpnum * 4, ccdc->fpc.addr,
+				  ccdc->fpc.dma);
 
 	mutex_destroy(&ccdc->ioctl_lock);
 }
diff --git a/drivers/media/platform/omap3isp/ispccdc.h b/drivers/media/platform/omap3isp/ispccdc.h
index 20db3a0..f650616 100644
--- a/drivers/media/platform/omap3isp/ispccdc.h
+++ b/drivers/media/platform/omap3isp/ispccdc.h
@@ -46,6 +46,12 @@ enum ccdc_input_entity {
 
 #define	OMAP3ISP_CCDC_NEVENTS	16
 
+struct ispccdc_fpc {
+	void *addr;
+	dma_addr_t dma;
+	unsigned int fpnum;
+};
+
 enum ispccdc_lsc_state {
 	LSC_STATE_STOPPED = 0,
 	LSC_STATE_STOPPING = 1,
@@ -140,7 +146,7 @@ struct isp_ccdc_device {
 		     fpc_en:1;
 	struct omap3isp_ccdc_blcomp blcomp;
 	struct omap3isp_ccdc_bclamp clamp;
-	struct omap3isp_ccdc_fpc fpc;
+	struct ispccdc_fpc fpc;
 	struct ispccdc_lsc lsc;
 	unsigned int update;
 	unsigned int shadow_update;
-- 
1.8.3.2

