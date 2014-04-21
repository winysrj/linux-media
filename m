Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38683 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaDUM3Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 14/26] omap3isp: queue: Allocate kernel buffers with dma_alloc_coherent
Date: Mon, 21 Apr 2014 14:29:00 +0200
Message-Id: <1398083352-8451-15-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

And retrieve the related sg table using dma_get_sgtable().

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.c | 57 +++++++++++++-----------------
 drivers/media/platform/omap3isp/ispqueue.h |  2 ++
 2 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index 088710b..2fd254f 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -148,39 +148,18 @@ out:
 }
 
 /*
- * isp_video_buffer_prepare_kernel - Build scatter list for a vmalloc'ed buffer
+ * isp_video_buffer_prepare_kernel - Build scatter list for a kernel-allocated
+ * buffer
  *
- * Iterate over the vmalloc'ed area and create a scatter list entry for every
- * page.
+ * Retrieve the sgtable using the DMA API.
  */
 static int isp_video_buffer_prepare_kernel(struct isp_video_buffer *buf)
 {
-	struct scatterlist *sg;
-	unsigned int npages;
-	unsigned int i;
-	void *addr;
-	int ret;
-
-	addr = buf->vaddr;
-	npages = PAGE_ALIGN(buf->vbuf.length) >> PAGE_SHIFT;
-
-	ret = sg_alloc_table(&buf->sgt, npages, GFP_KERNEL);
-	if (ret < 0)
-		return ret;
-
-	for (sg = buf->sgt.sgl, i = 0; i < npages; ++i, addr += PAGE_SIZE) {
-		struct page *page = vmalloc_to_page(addr);
-
-		if (page == NULL || PageHighMem(page)) {
-			sg_free_table(&buf->sgt);
-			return -EINVAL;
-		}
-
-		sg_set_page(sg, page, PAGE_SIZE, 0);
-		sg = sg_next(sg);
-	}
+	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
+	struct isp_video *video = vfh->video;
 
-	return 0;
+	return dma_get_sgtable(video->isp->dev, &buf->sgt, buf->vaddr,
+			       buf->paddr, PAGE_ALIGN(buf->vbuf.length));
 }
 
 /*
@@ -601,8 +580,12 @@ static int isp_video_queue_free(struct isp_video_queue *queue)
 
 		isp_video_buffer_cleanup(buf);
 
-		vfree(buf->vaddr);
-		buf->vaddr = NULL;
+		if (buf->vaddr) {
+			dma_free_coherent(queue->dev,
+					  PAGE_ALIGN(buf->vbuf.length),
+					  buf->vaddr, buf->paddr);
+			buf->vaddr = NULL;
+		}
 
 		kfree(buf);
 		queue->buffers[i] = NULL;
@@ -623,6 +606,7 @@ static int isp_video_queue_alloc(struct isp_video_queue *queue,
 				 unsigned int size, enum v4l2_memory memory)
 {
 	struct isp_video_buffer *buf;
+	dma_addr_t dma;
 	unsigned int i;
 	void *mem;
 	int ret;
@@ -646,7 +630,8 @@ static int isp_video_queue_alloc(struct isp_video_queue *queue,
 			/* Allocate video buffers memory for mmap mode. Align
 			 * the size to the page size.
 			 */
-			mem = vmalloc_32_user(PAGE_ALIGN(size));
+			mem = dma_alloc_coherent(queue->dev, PAGE_ALIGN(size),
+						 &dma, GFP_KERNEL);
 			if (mem == NULL) {
 				kfree(buf);
 				break;
@@ -654,6 +639,7 @@ static int isp_video_queue_alloc(struct isp_video_queue *queue,
 
 			buf->vbuf.m.offset = i * PAGE_ALIGN(size);
 			buf->vaddr = mem;
+			buf->paddr = dma;
 		}
 
 		buf->vbuf.index = i;
@@ -1094,10 +1080,17 @@ int omap3isp_video_queue_mmap(struct isp_video_queue *queue,
 		goto done;
 	}
 
-	ret = remap_vmalloc_range(vma, buf->vaddr, 0);
+	/* dma_mmap_coherent() uses vm_pgoff as an offset inside the buffer
+	 * while we used it to identify the buffer and want to map the whole
+	 * buffer.
+	 */
+	vma->vm_pgoff = 0;
+
+	ret = dma_mmap_coherent(queue->dev, vma, buf->vaddr, buf->paddr, size);
 	if (ret < 0)
 		goto done;
 
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &isp_video_queue_vm_ops;
 	vma->vm_private_data = buf;
 	isp_video_queue_vm_open(vma);
diff --git a/drivers/media/platform/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
index f78325d..e03af74 100644
--- a/drivers/media/platform/omap3isp/ispqueue.h
+++ b/drivers/media/platform/omap3isp/ispqueue.h
@@ -68,6 +68,7 @@ enum isp_video_buffer_state {
  * @prepared: Whether the buffer has been prepared
  * @skip_cache: Whether to skip cache management operations for this buffer
  * @vaddr: Memory virtual address (for kernel buffers)
+ * @paddr: Memory physicall address (for kernel buffers)
  * @vm_flags: Buffer VMA flags (for userspace buffers)
  * @npages: Number of pages (for userspace buffers)
  * @pages: Pages table (for userspace non-VM_PFNMAP buffers)
@@ -86,6 +87,7 @@ struct isp_video_buffer {
 
 	/* For kernel buffers. */
 	void *vaddr;
+	dma_addr_t paddr;
 
 	/* For userspace buffers. */
 	vm_flags_t vm_flags;
-- 
1.8.3.2

