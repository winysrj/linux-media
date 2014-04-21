Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38683 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaDUM3P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 12/26] omap3isp: queue: Merge the prepare and sglist functions
Date: Mon, 21 Apr 2014 14:28:58 +0200
Message-Id: <1398083352-8451-13-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for the switch to the DMA API merge the two functions
that handle buffer preparation for the USERPTR cases (both page-backed
and non page-backed memory).

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.c | 169 ++++++++++++-----------------
 drivers/media/platform/omap3isp/ispqueue.h |   4 -
 2 files changed, 69 insertions(+), 104 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index 51ec40d..a7be7d7 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -178,12 +178,12 @@ out:
 }
 
 /*
- * isp_video_buffer_sglist_kernel - Build a scatter list for a vmalloc'ed buffer
+ * isp_video_buffer_prepare_kernel - Build scatter list for a vmalloc'ed buffer
  *
  * Iterate over the vmalloc'ed area and create a scatter list entry for every
  * page.
  */
-static int isp_video_buffer_sglist_kernel(struct isp_video_buffer *buf)
+static int isp_video_buffer_prepare_kernel(struct isp_video_buffer *buf)
 {
 	struct scatterlist *sg;
 	unsigned int npages;
@@ -214,67 +214,6 @@ static int isp_video_buffer_sglist_kernel(struct isp_video_buffer *buf)
 }
 
 /*
- * isp_video_buffer_sglist_user - Build a scatter list for a userspace buffer
- *
- * Walk the buffer pages list and create a 1:1 mapping to a scatter list.
- */
-static int isp_video_buffer_sglist_user(struct isp_video_buffer *buf)
-{
-	unsigned int offset = buf->offset;
-	struct scatterlist *sg;
-	unsigned int i;
-	int ret;
-
-	ret = sg_alloc_table(&buf->sgt, buf->npages, GFP_KERNEL);
-	if (ret < 0)
-		return ret;
-
-	for (sg = buf->sgt.sgl, i = 0; i < buf->npages; ++i) {
-		if (PageHighMem(buf->pages[i])) {
-			sg_free_table(&buf->sgt);
-			return -EINVAL;
-		}
-
-		sg_set_page(sg, buf->pages[i], PAGE_SIZE - offset, offset);
-		sg = sg_next(sg);
-		offset = 0;
-	}
-
-	return 0;
-}
-
-/*
- * isp_video_buffer_sglist_pfnmap - Build a scatter list for a VM_PFNMAP buffer
- *
- * Create a scatter list of physically contiguous pages starting at the buffer
- * memory physical address.
- */
-static int isp_video_buffer_sglist_pfnmap(struct isp_video_buffer *buf)
-{
-	struct scatterlist *sg;
-	unsigned int offset = buf->offset;
-	unsigned long pfn = buf->paddr >> PAGE_SHIFT;
-	unsigned int i;
-	int ret;
-
-	ret = sg_alloc_table(&buf->sgt, buf->npages, GFP_KERNEL);
-	if (ret < 0)
-		return ret;
-
-	for (sg = buf->sgt.sgl, i = 0; i < buf->npages; ++i, ++pfn) {
-		sg_set_page(sg, pfn_to_page(pfn), PAGE_SIZE - offset, offset);
-		/* PFNMAP buffers will not get DMA-mapped, set the DMA address
-		 * manually.
-		 */
-		sg_dma_address(sg) = (pfn << PAGE_SHIFT) + offset;
-		sg = sg_next(sg);
-		offset = 0;
-	}
-
-	return 0;
-}
-
-/*
  * isp_video_buffer_cleanup - Release pages for a userspace VMA.
  *
  * Release pages locked by a call isp_video_buffer_prepare_user and free the
@@ -316,11 +255,11 @@ static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
 }
 
 /*
- * isp_video_buffer_prepare_user - Pin userspace VMA pages to memory.
+ * isp_video_buffer_prepare_user - Prepare a userspace buffer.
  *
- * This function creates a list of pages for a userspace VMA. The number of
- * pages is first computed based on the buffer size, and pages are then
- * retrieved by a call to get_user_pages.
+ * This function creates a scatter list with a 1:1 mapping for a userspace VMA.
+ * The number of pages is first computed based on the buffer size, and pages are
+ * then retrieved by a call to get_user_pages.
  *
  * Pages are pinned to memory by get_user_pages, making them available for DMA
  * transfers. However, due to memory management optimization, it seems the
@@ -340,16 +279,19 @@ static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
  */
 static int isp_video_buffer_prepare_user(struct isp_video_buffer *buf)
 {
+	struct scatterlist *sg;
+	unsigned int offset;
 	unsigned long data;
 	unsigned int first;
 	unsigned int last;
+	unsigned int i;
 	int ret;
 
 	data = buf->vbuf.m.userptr;
 	first = (data & PAGE_MASK) >> PAGE_SHIFT;
 	last = ((data + buf->vbuf.length - 1) & PAGE_MASK) >> PAGE_SHIFT;
+	offset = data & ~PAGE_MASK;
 
-	buf->offset = data & ~PAGE_MASK;
 	buf->npages = last - first + 1;
 	buf->pages = vmalloc(buf->npages * sizeof(buf->pages[0]));
 	if (buf->pages == NULL)
@@ -364,68 +306,104 @@ static int isp_video_buffer_prepare_user(struct isp_video_buffer *buf)
 
 	if (ret != buf->npages) {
 		buf->npages = ret < 0 ? 0 : ret;
-		isp_video_buffer_cleanup(buf);
 		return -EFAULT;
 	}
 
 	ret = isp_video_buffer_lock_vma(buf, 1);
 	if (ret < 0)
-		isp_video_buffer_cleanup(buf);
+		return ret;
 
-	return ret;
+	ret = sg_alloc_table(&buf->sgt, buf->npages, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+
+	for (sg = buf->sgt.sgl, i = 0; i < buf->npages; ++i) {
+		if (PageHighMem(buf->pages[i])) {
+			sg_free_table(&buf->sgt);
+			return -EINVAL;
+		}
+
+		sg_set_page(sg, buf->pages[i], PAGE_SIZE - offset, offset);
+		sg = sg_next(sg);
+		offset = 0;
+	}
+
+	return 0;
 }
 
 /*
- * isp_video_buffer_prepare_pfnmap - Validate a VM_PFNMAP userspace buffer
+ * isp_video_buffer_prepare_pfnmap - Prepare a VM_PFNMAP userspace buffer
  *
  * Userspace VM_PFNMAP buffers are supported only if they are contiguous in
- * memory and if they span a single VMA.
+ * memory and if they span a single VMA. Start by validating the user pointer to
+ * make sure it fulfils that condition, and then build a scatter list of
+ * physically contiguous pages starting at the buffer memory physical address.
  *
- * Return 0 if the buffer is valid, or -EFAULT otherwise.
+ * Return 0 on success, -EFAULT if the buffer isn't valid or -ENOMEM if memory
+ * can't be allocated.
  */
 static int isp_video_buffer_prepare_pfnmap(struct isp_video_buffer *buf)
 {
 	struct vm_area_struct *vma;
+	struct scatterlist *sg;
 	unsigned long prev_pfn;
 	unsigned long this_pfn;
 	unsigned long start;
+	unsigned int offset;
 	unsigned long end;
-	dma_addr_t pa = 0;
-	int ret = -EFAULT;
+	unsigned long pfn;
+	unsigned int i;
+	int ret = 0;
 
 	start = buf->vbuf.m.userptr;
 	end = buf->vbuf.m.userptr + buf->vbuf.length - 1;
+	offset = start & ~PAGE_MASK;
 
-	buf->offset = start & ~PAGE_MASK;
 	buf->npages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
 	buf->pages = NULL;
 
 	down_read(&current->mm->mmap_sem);
 	vma = find_vma(current->mm, start);
-	if (vma == NULL || vma->vm_end < end)
-		goto done;
+	if (vma == NULL || vma->vm_end < end) {
+		ret = -EFAULT;
+		goto unlock;
+	}
 
 	for (prev_pfn = 0; start <= end; start += PAGE_SIZE) {
 		ret = follow_pfn(vma, start, &this_pfn);
-		if (ret)
-			goto done;
+		if (ret < 0)
+			goto unlock;
 
 		if (prev_pfn == 0)
-			pa = this_pfn << PAGE_SHIFT;
+			pfn = this_pfn;
 		else if (this_pfn != prev_pfn + 1) {
 			ret = -EFAULT;
-			goto done;
+			goto unlock;
 		}
 
 		prev_pfn = this_pfn;
 	}
 
-	buf->paddr = pa + buf->offset;
-	ret = 0;
-
-done:
+unlock:
 	up_read(&current->mm->mmap_sem);
-	return ret;
+	if (ret < 0)
+		return ret;
+
+	ret = sg_alloc_table(&buf->sgt, buf->npages, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+
+	for (sg = buf->sgt.sgl, i = 0; i < buf->npages; ++i, ++pfn) {
+		sg_set_page(sg, pfn_to_page(pfn), PAGE_SIZE - offset, offset);
+		/* PFNMAP buffers will not get DMA-mapped, set the DMA address
+		 * manually.
+		 */
+		sg_dma_address(sg) = (pfn << PAGE_SHIFT) + offset;
+		sg = sg_next(sg);
+		offset = 0;
+	}
+
+	return 0;
 }
 
 /*
@@ -511,7 +489,7 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 
 	switch (buf->vbuf.memory) {
 	case V4L2_MEMORY_MMAP:
-		ret = isp_video_buffer_sglist_kernel(buf);
+		ret = isp_video_buffer_prepare_kernel(buf);
 		break;
 
 	case V4L2_MEMORY_USERPTR:
@@ -519,19 +497,10 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 		if (ret < 0)
 			return ret;
 
-		if (buf->vm_flags & VM_PFNMAP) {
+		if (buf->vm_flags & VM_PFNMAP)
 			ret = isp_video_buffer_prepare_pfnmap(buf);
-			if (ret < 0)
-				return ret;
-
-			ret = isp_video_buffer_sglist_pfnmap(buf);
-		} else {
+		else
 			ret = isp_video_buffer_prepare_user(buf);
-			if (ret < 0)
-				return ret;
-
-			ret = isp_video_buffer_sglist_user(buf);
-		}
 		break;
 
 	default:
diff --git a/drivers/media/platform/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
index 99c11e8..f78325d 100644
--- a/drivers/media/platform/omap3isp/ispqueue.h
+++ b/drivers/media/platform/omap3isp/ispqueue.h
@@ -69,10 +69,8 @@ enum isp_video_buffer_state {
  * @skip_cache: Whether to skip cache management operations for this buffer
  * @vaddr: Memory virtual address (for kernel buffers)
  * @vm_flags: Buffer VMA flags (for userspace buffers)
- * @offset: Offset inside the first page (for userspace buffers)
  * @npages: Number of pages (for userspace buffers)
  * @pages: Pages table (for userspace non-VM_PFNMAP buffers)
- * @paddr: Memory physical address (for userspace VM_PFNMAP buffers)
  * @sgt: Scatter gather table (for non-VM_PFNMAP buffers)
  * @vbuf: V4L2 buffer
  * @irqlist: List head for insertion into IRQ queue
@@ -91,10 +89,8 @@ struct isp_video_buffer {
 
 	/* For userspace buffers. */
 	vm_flags_t vm_flags;
-	unsigned long offset;
 	unsigned int npages;
 	struct page **pages;
-	dma_addr_t paddr;
 
 	/* For all buffers except VM_PFNMAP. */
 	struct sg_table sgt;
-- 
1.8.3.2

