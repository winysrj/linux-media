Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38682 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaDUM3K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 04/26] omap3isp: stat: Merge dma_addr and iommu_addr fields
Date: Mon, 21 Apr 2014 14:28:50 +0200
Message-Id: <1398083352-8451-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fields store buffer addresses as seen from the device. The first one
is used with an external DMA engine while the second one is used with
the ISP DMA engine. As they're never used together, merge them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isph3a_aewb.c |  2 +-
 drivers/media/platform/omap3isp/isph3a_af.c   |  2 +-
 drivers/media/platform/omap3isp/ispstat.c     | 21 +++++++++------------
 drivers/media/platform/omap3isp/ispstat.h     |  1 -
 4 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c b/drivers/media/platform/omap3isp/isph3a_aewb.c
index 75fd82b..d6811ce 100644
--- a/drivers/media/platform/omap3isp/isph3a_aewb.c
+++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
@@ -47,7 +47,7 @@ static void h3a_aewb_setup_regs(struct ispstat *aewb, void *priv)
 	if (aewb->state == ISPSTAT_DISABLED)
 		return;
 
-	isp_reg_writel(aewb->isp, aewb->active_buf->iommu_addr,
+	isp_reg_writel(aewb->isp, aewb->active_buf->dma_addr,
 		       OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWBUFST);
 
 	if (!aewb->update)
diff --git a/drivers/media/platform/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
index a0bf5af..6fc960c 100644
--- a/drivers/media/platform/omap3isp/isph3a_af.c
+++ b/drivers/media/platform/omap3isp/isph3a_af.c
@@ -51,7 +51,7 @@ static void h3a_af_setup_regs(struct ispstat *af, void *priv)
 	if (af->state == ISPSTAT_DISABLED)
 		return;
 
-	isp_reg_writel(af->isp, af->active_buf->iommu_addr, OMAP3_ISP_IOMEM_H3A,
+	isp_reg_writel(af->isp, af->active_buf->dma_addr, OMAP3_ISP_IOMEM_H3A,
 		       ISPH3A_AFBUFST);
 
 	if (!af->update)
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index b1eb902..dba713f 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -361,21 +361,19 @@ static void isp_stat_bufs_free(struct ispstat *stat)
 		struct ispstat_buffer *buf = &stat->buf[i];
 
 		if (!ISP_STAT_USES_DMAENGINE(stat)) {
-			if (IS_ERR_OR_NULL((void *)buf->iommu_addr))
+			if (IS_ERR_OR_NULL((void *)buf->dma_addr))
 				continue;
 			if (buf->iovm)
 				dma_unmap_sg(isp->dev, buf->iovm->sgt->sgl,
 					     buf->iovm->sgt->nents,
 					     DMA_FROM_DEVICE);
-			omap_iommu_vfree(isp->domain, isp->dev,
-							buf->iommu_addr);
+			omap_iommu_vfree(isp->domain, isp->dev, buf->dma_addr);
 		} else {
 			if (!buf->virt_addr)
 				continue;
 			dma_free_coherent(stat->isp->dev, stat->buf_alloc_size,
 					  buf->virt_addr, buf->dma_addr);
 		}
-		buf->iommu_addr = 0;
 		buf->iovm = NULL;
 		buf->dma_addr = 0;
 		buf->virt_addr = NULL;
@@ -396,12 +394,12 @@ static int isp_stat_bufs_alloc_iommu(struct ispstat *stat,
 	struct isp_device *isp = stat->isp;
 	struct iovm_struct *iovm;
 
-	buf->iommu_addr = omap_iommu_vmalloc(isp->domain, isp->dev, 0,
-						size, IOMMU_FLAG);
-	if (IS_ERR((void *)buf->iommu_addr))
+	buf->dma_addr = omap_iommu_vmalloc(isp->domain, isp->dev, 0,
+					   size, IOMMU_FLAG);
+	if (IS_ERR_VALUE(buf->dma_addr))
 		return -ENOMEM;
 
-	iovm = omap_find_iovm_area(isp->dev, buf->iommu_addr);
+	iovm = omap_find_iovm_area(isp->dev, buf->dma_addr);
 	if (!iovm)
 		return -ENOMEM;
 
@@ -410,8 +408,7 @@ static int isp_stat_bufs_alloc_iommu(struct ispstat *stat,
 		return -ENOMEM;
 
 	buf->iovm = iovm;
-	buf->virt_addr = omap_da_to_va(stat->isp->dev,
-				  (u32)buf->iommu_addr);
+	buf->virt_addr = omap_da_to_va(stat->isp->dev, buf->dma_addr);
 
 	return 0;
 }
@@ -478,8 +475,8 @@ static int isp_stat_bufs_alloc(struct ispstat *stat, u32 size)
 		buf->empty = 1;
 
 		dev_dbg(stat->isp->dev,
-			"%s: buffer[%u] allocated. iommu=0x%08lx dma=0x%08lx virt=0x%08lx",
-			stat->subdev.name, i, buf->iommu_addr,
+			"%s: buffer[%u] allocated. dma=0x%08lx virt=0x%08lx",
+			stat->subdev.name, i,
 			(unsigned long)buf->dma_addr,
 			(unsigned long)buf->virt_addr);
 	}
diff --git a/drivers/media/platform/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
index 9a047c9..8e76846 100644
--- a/drivers/media/platform/omap3isp/ispstat.h
+++ b/drivers/media/platform/omap3isp/ispstat.h
@@ -46,7 +46,6 @@
 struct ispstat;
 
 struct ispstat_buffer {
-	unsigned long iommu_addr;
 	struct iovm_struct *iovm;
 	void *virt_addr;
 	dma_addr_t dma_addr;
-- 
1.8.3.2

