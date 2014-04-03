Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52434 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaDCWiB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 18:38:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 05/25] omap3isp: stat: Store sg table in ispstat_buffer
Date: Fri,  4 Apr 2014 00:39:35 +0200
Message-Id: <1396564795-27192-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver stores the IOMMU mapped iovm struct pointer in the buffer
structure but only needs the iovm sg table. Store the sg table instead
to prepare the migration to the DMA API.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispstat.c | 19 +++++++++----------
 drivers/media/platform/omap3isp/ispstat.h |  2 +-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index dba713f..4cf7eb1 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -183,8 +183,8 @@ static void isp_stat_buf_sync_for_device(struct ispstat *stat,
 	if (ISP_STAT_USES_DMAENGINE(stat))
 		return;
 
-	dma_sync_sg_for_device(stat->isp->dev, buf->iovm->sgt->sgl,
-			       buf->iovm->sgt->nents, DMA_FROM_DEVICE);
+	dma_sync_sg_for_device(stat->isp->dev, buf->sgt->sgl,
+			       buf->sgt->nents, DMA_FROM_DEVICE);
 }
 
 static void isp_stat_buf_sync_for_cpu(struct ispstat *stat,
@@ -193,8 +193,8 @@ static void isp_stat_buf_sync_for_cpu(struct ispstat *stat,
 	if (ISP_STAT_USES_DMAENGINE(stat))
 		return;
 
-	dma_sync_sg_for_cpu(stat->isp->dev, buf->iovm->sgt->sgl,
-			    buf->iovm->sgt->nents, DMA_FROM_DEVICE);
+	dma_sync_sg_for_cpu(stat->isp->dev, buf->sgt->sgl,
+			    buf->sgt->nents, DMA_FROM_DEVICE);
 }
 
 static void isp_stat_buf_clear(struct ispstat *stat)
@@ -363,10 +363,9 @@ static void isp_stat_bufs_free(struct ispstat *stat)
 		if (!ISP_STAT_USES_DMAENGINE(stat)) {
 			if (IS_ERR_OR_NULL((void *)buf->dma_addr))
 				continue;
-			if (buf->iovm)
-				dma_unmap_sg(isp->dev, buf->iovm->sgt->sgl,
-					     buf->iovm->sgt->nents,
-					     DMA_FROM_DEVICE);
+			if (buf->sgt)
+				dma_unmap_sg(isp->dev, buf->sgt->sgl,
+					     buf->sgt->nents, DMA_FROM_DEVICE);
 			omap_iommu_vfree(isp->domain, isp->dev, buf->dma_addr);
 		} else {
 			if (!buf->virt_addr)
@@ -374,7 +373,7 @@ static void isp_stat_bufs_free(struct ispstat *stat)
 			dma_free_coherent(stat->isp->dev, stat->buf_alloc_size,
 					  buf->virt_addr, buf->dma_addr);
 		}
-		buf->iovm = NULL;
+		buf->sgt = NULL;
 		buf->dma_addr = 0;
 		buf->virt_addr = NULL;
 		buf->empty = 1;
@@ -407,7 +406,7 @@ static int isp_stat_bufs_alloc_iommu(struct ispstat *stat,
 			DMA_FROM_DEVICE))
 		return -ENOMEM;
 
-	buf->iovm = iovm;
+	buf->sgt = iovm->sgt;
 	buf->virt_addr = omap_da_to_va(stat->isp->dev, buf->dma_addr);
 
 	return 0;
diff --git a/drivers/media/platform/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
index 8e76846..857f45e 100644
--- a/drivers/media/platform/omap3isp/ispstat.h
+++ b/drivers/media/platform/omap3isp/ispstat.h
@@ -46,7 +46,7 @@
 struct ispstat;
 
 struct ispstat_buffer {
-	struct iovm_struct *iovm;
+	const struct sg_table *sgt;
 	void *virt_addr;
 	dma_addr_t dma_addr;
 	struct timespec ts;
-- 
1.8.3.2

