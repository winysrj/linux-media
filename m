Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52434 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaDCWiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 18:38:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 11/25] omap3isp: queue: Use sg_table structure
Date: Fri,  4 Apr 2014 00:39:41 +0200
Message-Id: <1396564795-27192-12-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the sglen and sglist fields stored in the buffer structure with
an sg_table. This allows using the sg table allocation helper function.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.c | 108 ++++++++++-------------------
 drivers/media/platform/omap3isp/ispqueue.h |   6 +-
 2 files changed, 40 insertions(+), 74 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index 8623c05..51ec40d 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -45,33 +45,17 @@
 #define IOMMU_FLAG	(IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_8)
 
 /*
- * ispmmu_vmap - Wrapper for Virtual memory mapping of a scatter gather list
+ * ispmmu_vmap - Wrapper for virtual memory mapping of a scatter gather table
  * @dev: Device pointer specific to the OMAP3 ISP.
- * @sglist: Pointer to source Scatter gather list to allocate.
- * @sglen: Number of elements of the scatter-gatter list.
+ * @sgt: Pointer to source scatter gather table.
  *
  * Returns a resulting mapped device address by the ISP MMU, or -ENOMEM if
  * we ran out of memory.
  */
 static dma_addr_t
-ispmmu_vmap(struct isp_device *isp, const struct scatterlist *sglist, int sglen)
+ispmmu_vmap(struct isp_device *isp, const struct sg_table *sgt)
 {
-	struct sg_table *sgt;
-	u32 da;
-
-	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
-	if (sgt == NULL)
-		return -ENOMEM;
-
-	sgt->sgl = (struct scatterlist *)sglist;
-	sgt->nents = sglen;
-	sgt->orig_nents = sglen;
-
-	da = omap_iommu_vmap(isp->domain, isp->dev, 0, sgt, IOMMU_FLAG);
-	if (IS_ERR_VALUE(da))
-		kfree(sgt);
-
-	return da;
+	return omap_iommu_vmap(isp->domain, isp->dev, 0, sgt, IOMMU_FLAG);
 }
 
 /*
@@ -81,10 +65,7 @@ ispmmu_vmap(struct isp_device *isp, const struct scatterlist *sglist, int sglen)
  */
 static void ispmmu_vunmap(struct isp_device *isp, dma_addr_t da)
 {
-	struct sg_table *sgt;
-
-	sgt = omap_iommu_vunmap(isp->domain, isp->dev, (u32)da);
-	kfree(sgt);
+	omap_iommu_vunmap(isp->domain, isp->dev, (u32)da);
 }
 
 /* -----------------------------------------------------------------------------
@@ -204,34 +185,31 @@ out:
  */
 static int isp_video_buffer_sglist_kernel(struct isp_video_buffer *buf)
 {
-	struct scatterlist *sglist;
+	struct scatterlist *sg;
 	unsigned int npages;
 	unsigned int i;
 	void *addr;
+	int ret;
 
 	addr = buf->vaddr;
 	npages = PAGE_ALIGN(buf->vbuf.length) >> PAGE_SHIFT;
 
-	sglist = vmalloc(npages * sizeof(*sglist));
-	if (sglist == NULL)
-		return -ENOMEM;
-
-	sg_init_table(sglist, npages);
+	ret = sg_alloc_table(&buf->sgt, npages, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
 
-	for (i = 0; i < npages; ++i, addr += PAGE_SIZE) {
+	for (sg = buf->sgt.sgl, i = 0; i < npages; ++i, addr += PAGE_SIZE) {
 		struct page *page = vmalloc_to_page(addr);
 
 		if (page == NULL || PageHighMem(page)) {
-			vfree(sglist);
+			sg_free_table(&buf->sgt);
 			return -EINVAL;
 		}
 
-		sg_set_page(&sglist[i], page, PAGE_SIZE, 0);
+		sg_set_page(sg, page, PAGE_SIZE, 0);
+		sg = sg_next(sg);
 	}
 
-	buf->sglen = npages;
-	buf->sglist = sglist;
-
 	return 0;
 }
 
@@ -242,30 +220,26 @@ static int isp_video_buffer_sglist_kernel(struct isp_video_buffer *buf)
  */
 static int isp_video_buffer_sglist_user(struct isp_video_buffer *buf)
 {
-	struct scatterlist *sglist;
 	unsigned int offset = buf->offset;
+	struct scatterlist *sg;
 	unsigned int i;
+	int ret;
 
-	sglist = vmalloc(buf->npages * sizeof(*sglist));
-	if (sglist == NULL)
-		return -ENOMEM;
-
-	sg_init_table(sglist, buf->npages);
+	ret = sg_alloc_table(&buf->sgt, buf->npages, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
 
-	for (i = 0; i < buf->npages; ++i) {
+	for (sg = buf->sgt.sgl, i = 0; i < buf->npages; ++i) {
 		if (PageHighMem(buf->pages[i])) {
-			vfree(sglist);
+			sg_free_table(&buf->sgt);
 			return -EINVAL;
 		}
 
-		sg_set_page(&sglist[i], buf->pages[i], PAGE_SIZE - offset,
-			    offset);
+		sg_set_page(sg, buf->pages[i], PAGE_SIZE - offset, offset);
+		sg = sg_next(sg);
 		offset = 0;
 	}
 
-	buf->sglen = buf->npages;
-	buf->sglist = sglist;
-
 	return 0;
 }
 
@@ -277,30 +251,26 @@ static int isp_video_buffer_sglist_user(struct isp_video_buffer *buf)
  */
 static int isp_video_buffer_sglist_pfnmap(struct isp_video_buffer *buf)
 {
-	struct scatterlist *sglist;
+	struct scatterlist *sg;
 	unsigned int offset = buf->offset;
 	unsigned long pfn = buf->paddr >> PAGE_SHIFT;
 	unsigned int i;
+	int ret;
 
-	sglist = vmalloc(buf->npages * sizeof(*sglist));
-	if (sglist == NULL)
-		return -ENOMEM;
-
-	sg_init_table(sglist, buf->npages);
+	ret = sg_alloc_table(&buf->sgt, buf->npages, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
 
-	for (i = 0; i < buf->npages; ++i, ++pfn) {
-		sg_set_page(&sglist[i], pfn_to_page(pfn), PAGE_SIZE - offset,
-			    offset);
+	for (sg = buf->sgt.sgl, i = 0; i < buf->npages; ++i, ++pfn) {
+		sg_set_page(sg, pfn_to_page(pfn), PAGE_SIZE - offset, offset);
 		/* PFNMAP buffers will not get DMA-mapped, set the DMA address
 		 * manually.
 		 */
-		sg_dma_address(&sglist[i]) = (pfn << PAGE_SHIFT) + offset;
+		sg_dma_address(sg) = (pfn << PAGE_SHIFT) + offset;
+		sg = sg_next(sg);
 		offset = 0;
 	}
 
-	buf->sglen = buf->npages;
-	buf->sglist = sglist;
-
 	return 0;
 }
 
@@ -325,13 +295,11 @@ static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
 	if (!(buf->vm_flags & VM_PFNMAP)) {
 		direction = buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE
 			  ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-		dma_unmap_sg(buf->queue->dev, buf->sglist, buf->sglen,
+		dma_unmap_sg(buf->queue->dev, buf->sgt.sgl, buf->sgt.orig_nents,
 			     direction);
 	}
 
-	vfree(buf->sglist);
-	buf->sglist = NULL;
-	buf->sglen = 0;
+	sg_free_table(&buf->sgt);
 
 	if (buf->pages != NULL) {
 		isp_video_buffer_lock_vma(buf, 0);
@@ -576,15 +544,15 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 	if (!(buf->vm_flags & VM_PFNMAP)) {
 		direction = buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE
 			  ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-		ret = dma_map_sg(buf->queue->dev, buf->sglist, buf->sglen,
-				 direction);
-		if (ret != buf->sglen) {
+		ret = dma_map_sg(buf->queue->dev, buf->sgt.sgl,
+				 buf->sgt.orig_nents, direction);
+		if (ret != buf->sgt.orig_nents) {
 			ret = -EFAULT;
 			goto done;
 		}
 	}
 
-	addr = ispmmu_vmap(video->isp, buf->sglist, buf->sglen);
+	addr = ispmmu_vmap(video->isp, &buf->sgt);
 	if (IS_ERR_VALUE(addr)) {
 		ret = -EIO;
 		goto done;
diff --git a/drivers/media/platform/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
index 0899a11..99c11e8 100644
--- a/drivers/media/platform/omap3isp/ispqueue.h
+++ b/drivers/media/platform/omap3isp/ispqueue.h
@@ -73,8 +73,7 @@ enum isp_video_buffer_state {
  * @npages: Number of pages (for userspace buffers)
  * @pages: Pages table (for userspace non-VM_PFNMAP buffers)
  * @paddr: Memory physical address (for userspace VM_PFNMAP buffers)
- * @sglen: Number of elements in the scatter list (for non-VM_PFNMAP buffers)
- * @sglist: Scatter list (for non-VM_PFNMAP buffers)
+ * @sgt: Scatter gather table (for non-VM_PFNMAP buffers)
  * @vbuf: V4L2 buffer
  * @irqlist: List head for insertion into IRQ queue
  * @state: Current buffer state
@@ -98,8 +97,7 @@ struct isp_video_buffer {
 	dma_addr_t paddr;
 
 	/* For all buffers except VM_PFNMAP. */
-	unsigned int sglen;
-	struct scatterlist *sglist;
+	struct sg_table sgt;
 
 	/* Touched by the interrupt handler. */
 	struct v4l2_buffer vbuf;
-- 
1.8.3.2

