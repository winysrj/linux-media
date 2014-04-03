Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52434 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbaDCWiA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 18:38:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 03/25] omap3isp: stat: Share common code for buffer allocation
Date: Fri,  4 Apr 2014 00:39:33 +0200
Message-Id: <1396564795-27192-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move code common between the isp_stat_bufs_alloc_dma() and
isp_stat_bufs_alloc_iommu() functions to isp_stat_bufs_alloc().

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispstat.c | 114 ++++++++++++++----------------
 1 file changed, 54 insertions(+), 60 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index c6c1290..b1eb902 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -389,74 +389,42 @@ static void isp_stat_bufs_free(struct ispstat *stat)
 	stat->active_buf = NULL;
 }
 
-static int isp_stat_bufs_alloc_iommu(struct ispstat *stat, unsigned int size)
+static int isp_stat_bufs_alloc_iommu(struct ispstat *stat,
+				     struct ispstat_buffer *buf,
+				     unsigned int size)
 {
 	struct isp_device *isp = stat->isp;
-	int i;
+	struct iovm_struct *iovm;
 
-	stat->buf_alloc_size = size;
+	buf->iommu_addr = omap_iommu_vmalloc(isp->domain, isp->dev, 0,
+						size, IOMMU_FLAG);
+	if (IS_ERR((void *)buf->iommu_addr))
+		return -ENOMEM;
 
-	for (i = 0; i < STAT_MAX_BUFS; i++) {
-		struct ispstat_buffer *buf = &stat->buf[i];
-		struct iovm_struct *iovm;
+	iovm = omap_find_iovm_area(isp->dev, buf->iommu_addr);
+	if (!iovm)
+		return -ENOMEM;
 
-		buf->iommu_addr = omap_iommu_vmalloc(isp->domain, isp->dev, 0,
-							size, IOMMU_FLAG);
-		if (IS_ERR((void *)buf->iommu_addr)) {
-			dev_err(stat->isp->dev,
-				 "%s: Can't acquire memory for "
-				 "buffer %d\n", stat->subdev.name, i);
-			isp_stat_bufs_free(stat);
-			return -ENOMEM;
-		}
+	if (!dma_map_sg(isp->dev, iovm->sgt->sgl, iovm->sgt->nents,
+			DMA_FROM_DEVICE))
+		return -ENOMEM;
 
-		iovm = omap_find_iovm_area(isp->dev, buf->iommu_addr);
-		if (!iovm ||
-		    !dma_map_sg(isp->dev, iovm->sgt->sgl, iovm->sgt->nents,
-				DMA_FROM_DEVICE)) {
-			isp_stat_bufs_free(stat);
-			return -ENOMEM;
-		}
-		buf->iovm = iovm;
-
-		buf->virt_addr = omap_da_to_va(stat->isp->dev,
-					  (u32)buf->iommu_addr);
-		buf->empty = 1;
-		dev_dbg(stat->isp->dev, "%s: buffer[%d] allocated."
-			"iommu_addr=0x%08lx virt_addr=0x%08lx",
-			stat->subdev.name, i, buf->iommu_addr,
-			(unsigned long)buf->virt_addr);
-	}
+	buf->iovm = iovm;
+	buf->virt_addr = omap_da_to_va(stat->isp->dev,
+				  (u32)buf->iommu_addr);
 
 	return 0;
 }
 
-static int isp_stat_bufs_alloc_dma(struct ispstat *stat, unsigned int size)
+static int isp_stat_bufs_alloc_dma(struct ispstat *stat,
+				   struct ispstat_buffer *buf,
+				   unsigned int size)
 {
-	int i;
-
-	stat->buf_alloc_size = size;
-
-	for (i = 0; i < STAT_MAX_BUFS; i++) {
-		struct ispstat_buffer *buf = &stat->buf[i];
-
-		buf->virt_addr = dma_alloc_coherent(stat->isp->dev, size,
-					&buf->dma_addr, GFP_KERNEL | GFP_DMA);
-
-		if (!buf->virt_addr || !buf->dma_addr) {
-			dev_info(stat->isp->dev,
-				 "%s: Can't acquire memory for "
-				 "DMA buffer %d\n", stat->subdev.name, i);
-			isp_stat_bufs_free(stat);
-			return -ENOMEM;
-		}
-		buf->empty = 1;
+	buf->virt_addr = dma_alloc_coherent(stat->isp->dev, size,
+				&buf->dma_addr, GFP_KERNEL | GFP_DMA);
 
-		dev_dbg(stat->isp->dev, "%s: buffer[%d] allocated."
-			"dma_addr=0x%08lx virt_addr=0x%08lx\n",
-			stat->subdev.name, i, (unsigned long)buf->dma_addr,
-			(unsigned long)buf->virt_addr);
-	}
+	if (!buf->virt_addr || !buf->dma_addr)
+		return -ENOMEM;
 
 	return 0;
 }
@@ -464,6 +432,7 @@ static int isp_stat_bufs_alloc_dma(struct ispstat *stat, unsigned int size)
 static int isp_stat_bufs_alloc(struct ispstat *stat, u32 size)
 {
 	unsigned long flags;
+	unsigned int i;
 
 	spin_lock_irqsave(&stat->isp->stat_lock, flags);
 
@@ -487,10 +456,35 @@ static int isp_stat_bufs_alloc(struct ispstat *stat, u32 size)
 
 	isp_stat_bufs_free(stat);
 
-	if (ISP_STAT_USES_DMAENGINE(stat))
-		return isp_stat_bufs_alloc_dma(stat, size);
-	else
-		return isp_stat_bufs_alloc_iommu(stat, size);
+	stat->buf_alloc_size = size;
+
+	for (i = 0; i < STAT_MAX_BUFS; i++) {
+		struct ispstat_buffer *buf = &stat->buf[i];
+		int ret;
+
+		if (ISP_STAT_USES_DMAENGINE(stat))
+			ret = isp_stat_bufs_alloc_dma(stat, buf, size);
+		else
+			ret = isp_stat_bufs_alloc_iommu(stat, buf, size);
+
+		if (ret < 0) {
+			dev_err(stat->isp->dev,
+				"%s: Failed to allocate DMA buffer %u\n",
+				stat->subdev.name, i);
+			isp_stat_bufs_free(stat);
+			return ret;
+		}
+
+		buf->empty = 1;
+
+		dev_dbg(stat->isp->dev,
+			"%s: buffer[%u] allocated. iommu=0x%08lx dma=0x%08lx virt=0x%08lx",
+			stat->subdev.name, i, buf->iommu_addr,
+			(unsigned long)buf->dma_addr,
+			(unsigned long)buf->virt_addr);
+	}
+
+	return 0;
 }
 
 static void isp_stat_queue_event(struct ispstat *stat, int err)
-- 
1.8.3.2

