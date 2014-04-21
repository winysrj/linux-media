Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38682 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaDUM3L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 06/26] omap3isp: stat: Use the DMA API
Date: Mon, 21 Apr 2014 14:28:52 +0200
Message-Id: <1398083352-8451-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the OMAP-specific IOMMU API usage by the DMA API. All buffers
are now allocated using dma_alloc_coherent() and the related sg table is
retrieved using dma_get_sgtable() for sync operations.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispstat.c | 123 +++++++++++++-----------------
 drivers/media/platform/omap3isp/ispstat.h |   2 +-
 2 files changed, 53 insertions(+), 72 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 4cf7eb1..e6cbc1e 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -26,7 +26,6 @@
  */
 
 #include <linux/dma-mapping.h>
-#include <linux/omap-iommu.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
@@ -77,21 +76,10 @@ static void __isp_stat_buf_sync_magic(struct ispstat *stat,
 					dma_addr_t, unsigned long, size_t,
 					enum dma_data_direction))
 {
-	struct device *dev = stat->isp->dev;
-	struct page *pg;
-	dma_addr_t dma_addr;
-	u32 offset;
-
-	/* Initial magic words */
-	pg = vmalloc_to_page(buf->virt_addr);
-	dma_addr = pfn_to_dma(dev, page_to_pfn(pg));
-	dma_sync(dev, dma_addr, 0, MAGIC_SIZE, dir);
-
-	/* Final magic words */
-	pg = vmalloc_to_page(buf->virt_addr + buf_size);
-	dma_addr = pfn_to_dma(dev, page_to_pfn(pg));
-	offset = ((u32)buf->virt_addr + buf_size) & ~PAGE_MASK;
-	dma_sync(dev, dma_addr, offset, MAGIC_SIZE, dir);
+	/* Sync the initial and final magic words. */
+	dma_sync(stat->isp->dev, buf->dma_addr, 0, MAGIC_SIZE, dir);
+	dma_sync(stat->isp->dev, buf->dma_addr + (buf_size & PAGE_MASK),
+		 buf_size & ~PAGE_MASK, MAGIC_SIZE, dir);
 }
 
 static void isp_stat_buf_sync_magic_for_device(struct ispstat *stat,
@@ -183,8 +171,8 @@ static void isp_stat_buf_sync_for_device(struct ispstat *stat,
 	if (ISP_STAT_USES_DMAENGINE(stat))
 		return;
 
-	dma_sync_sg_for_device(stat->isp->dev, buf->sgt->sgl,
-			       buf->sgt->nents, DMA_FROM_DEVICE);
+	dma_sync_sg_for_device(stat->isp->dev, buf->sgt.sgl,
+			       buf->sgt.nents, DMA_FROM_DEVICE);
 }
 
 static void isp_stat_buf_sync_for_cpu(struct ispstat *stat,
@@ -193,8 +181,8 @@ static void isp_stat_buf_sync_for_cpu(struct ispstat *stat,
 	if (ISP_STAT_USES_DMAENGINE(stat))
 		return;
 
-	dma_sync_sg_for_cpu(stat->isp->dev, buf->sgt->sgl,
-			    buf->sgt->nents, DMA_FROM_DEVICE);
+	dma_sync_sg_for_cpu(stat->isp->dev, buf->sgt.sgl,
+			    buf->sgt.nents, DMA_FROM_DEVICE);
 }
 
 static void isp_stat_buf_clear(struct ispstat *stat)
@@ -354,26 +342,21 @@ static struct ispstat_buffer *isp_stat_buf_get(struct ispstat *stat,
 
 static void isp_stat_bufs_free(struct ispstat *stat)
 {
-	struct isp_device *isp = stat->isp;
-	int i;
+	struct device *dev = ISP_STAT_USES_DMAENGINE(stat)
+			   ? NULL : stat->isp->dev;
+	unsigned int i;
 
 	for (i = 0; i < STAT_MAX_BUFS; i++) {
 		struct ispstat_buffer *buf = &stat->buf[i];
 
-		if (!ISP_STAT_USES_DMAENGINE(stat)) {
-			if (IS_ERR_OR_NULL((void *)buf->dma_addr))
-				continue;
-			if (buf->sgt)
-				dma_unmap_sg(isp->dev, buf->sgt->sgl,
-					     buf->sgt->nents, DMA_FROM_DEVICE);
-			omap_iommu_vfree(isp->domain, isp->dev, buf->dma_addr);
-		} else {
-			if (!buf->virt_addr)
-				continue;
-			dma_free_coherent(stat->isp->dev, stat->buf_alloc_size,
-					  buf->virt_addr, buf->dma_addr);
-		}
-		buf->sgt = NULL;
+		if (!buf->virt_addr)
+			continue;
+
+		sg_free_table(&buf->sgt);
+
+		dma_free_coherent(dev, stat->buf_alloc_size, buf->virt_addr,
+				  buf->dma_addr);
+
 		buf->dma_addr = 0;
 		buf->virt_addr = NULL;
 		buf->empty = 1;
@@ -386,47 +369,49 @@ static void isp_stat_bufs_free(struct ispstat *stat)
 	stat->active_buf = NULL;
 }
 
-static int isp_stat_bufs_alloc_iommu(struct ispstat *stat,
-				     struct ispstat_buffer *buf,
-				     unsigned int size)
-{
-	struct isp_device *isp = stat->isp;
-	struct iovm_struct *iovm;
-
-	buf->dma_addr = omap_iommu_vmalloc(isp->domain, isp->dev, 0,
-					   size, IOMMU_FLAG);
-	if (IS_ERR_VALUE(buf->dma_addr))
-		return -ENOMEM;
-
-	iovm = omap_find_iovm_area(isp->dev, buf->dma_addr);
-	if (!iovm)
-		return -ENOMEM;
-
-	if (!dma_map_sg(isp->dev, iovm->sgt->sgl, iovm->sgt->nents,
-			DMA_FROM_DEVICE))
-		return -ENOMEM;
-
-	buf->sgt = iovm->sgt;
-	buf->virt_addr = omap_da_to_va(stat->isp->dev, buf->dma_addr);
-
-	return 0;
-}
-
-static int isp_stat_bufs_alloc_dma(struct ispstat *stat,
+static int isp_stat_bufs_alloc_one(struct device *dev,
 				   struct ispstat_buffer *buf,
 				   unsigned int size)
 {
-	buf->virt_addr = dma_alloc_coherent(stat->isp->dev, size,
-				&buf->dma_addr, GFP_KERNEL | GFP_DMA);
+	int ret;
 
-	if (!buf->virt_addr || !buf->dma_addr)
+	buf->virt_addr = dma_alloc_coherent(dev, size, &buf->dma_addr,
+					    GFP_KERNEL | GFP_DMA);
+	if (!buf->virt_addr)
 		return -ENOMEM;
 
+	ret = dma_get_sgtable(dev, &buf->sgt, buf->virt_addr, buf->dma_addr,
+			      size);
+	if (ret < 0) {
+		dma_free_coherent(dev, size, buf->virt_addr, buf->dma_addr);
+		buf->virt_addr = NULL;
+		buf->dma_addr = 0;
+		return ret;
+	}
+
 	return 0;
 }
 
+/*
+ * The device passed to the DMA API depends on whether the statistics block uses
+ * ISP DMA, external DMA or PIO to transfer data.
+ *
+ * The first case (for the AEWB and AF engines) passes the ISP device, resulting
+ * in the DMA buffers being mapped through the ISP IOMMU.
+ *
+ * The second case (for the histogram engine) should pass the DMA engine device.
+ * As that device isn't accessible through the OMAP DMA engine API the driver
+ * passes NULL instead, resulting in the buffers being mapped directly as
+ * physical pages.
+ *
+ * The third case (for the histogram engine) doesn't require any mapping. The
+ * buffers could be allocated with kmalloc/vmalloc, but we still use
+ * dma_alloc_coherent() for consistency purpose.
+ */
 static int isp_stat_bufs_alloc(struct ispstat *stat, u32 size)
 {
+	struct device *dev = ISP_STAT_USES_DMAENGINE(stat)
+			   ? NULL : stat->isp->dev;
 	unsigned long flags;
 	unsigned int i;
 
@@ -458,11 +443,7 @@ static int isp_stat_bufs_alloc(struct ispstat *stat, u32 size)
 		struct ispstat_buffer *buf = &stat->buf[i];
 		int ret;
 
-		if (ISP_STAT_USES_DMAENGINE(stat))
-			ret = isp_stat_bufs_alloc_dma(stat, buf, size);
-		else
-			ret = isp_stat_bufs_alloc_iommu(stat, buf, size);
-
+		ret = isp_stat_bufs_alloc_one(dev, buf, size);
 		if (ret < 0) {
 			dev_err(stat->isp->dev,
 				"%s: Failed to allocate DMA buffer %u\n",
diff --git a/drivers/media/platform/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
index 857f45e..58d6ac7 100644
--- a/drivers/media/platform/omap3isp/ispstat.h
+++ b/drivers/media/platform/omap3isp/ispstat.h
@@ -46,7 +46,7 @@
 struct ispstat;
 
 struct ispstat_buffer {
-	const struct sg_table *sgt;
+	struct sg_table sgt;
 	void *virt_addr;
 	dma_addr_t dma_addr;
 	struct timespec ts;
-- 
1.8.3.2

