Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58187 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab1BNMVw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v6 06/10] omap3isp: Video devices and buffers queue
Date: Mon, 14 Feb 2011 13:21:33 +0100
Message-Id: <1297686097-9804-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The OMAP3 ISP video devices and buffers queue modules implement the V4L2
API on all the ISP video nodes.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: David Cohen <dacohen@gmail.com>
Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Signed-off-by: Tuukka Toivonen <tuukkat76@gmail.com>
Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Signed-off-by: Antti Koskipaa <akoskipa@gmail.com>
Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Signed-off-by: RaniSuneela <r-m@ti.com>
Signed-off-by: Atanas Filipov <afilipov@mm-sol.com>
Signed-off-by: Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Signed-off-by: Nayden Kanchev <nkanchev@mm-sol.com>
Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Dominic Curran <dcurran@ti.com>
Signed-off-by: Ilkka Myllyperkio <ilkka.myllyperkio@sofica.fi>
Signed-off-by: Pallavi Kulkarni <p-kulkarni@ti.com>
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/omap3-isp/ispqueue.c | 1153 +++++++++++++++++++++++++++
 drivers/media/video/omap3-isp/ispqueue.h |  187 +++++
 drivers/media/video/omap3-isp/ispvideo.c | 1264 ++++++++++++++++++++++++++++++
 drivers/media/video/omap3-isp/ispvideo.h |  202 +++++
 4 files changed, 2806 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/omap3-isp/ispqueue.c
 create mode 100644 drivers/media/video/omap3-isp/ispqueue.h
 create mode 100644 drivers/media/video/omap3-isp/ispvideo.c
 create mode 100644 drivers/media/video/omap3-isp/ispvideo.h

diff --git a/drivers/media/video/omap3-isp/ispqueue.c b/drivers/media/video/omap3-isp/ispqueue.c
new file mode 100644
index 0000000..8fddc58
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispqueue.c
@@ -0,0 +1,1153 @@
+/*
+ * ispqueue.c
+ *
+ * TI OMAP3 ISP - Video buffers queue handling
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <asm/cacheflush.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/poll.h>
+#include <linux/scatterlist.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include "ispqueue.h"
+
+/* -----------------------------------------------------------------------------
+ * Video buffers management
+ */
+
+/*
+ * isp_video_buffer_cache_sync - Keep the buffers coherent between CPU and ISP
+ *
+ * The typical operation required here is Cache Invalidation across
+ * the (user space) buffer address range. And this _must_ be done
+ * at QBUF stage (and *only* at QBUF).
+ *
+ * We try to use optimal cache invalidation function:
+ * - dmac_map_area:
+ *    - used when the number of pages are _low_.
+ *    - it becomes quite slow as the number of pages increase.
+ *       - for 648x492 viewfinder (150 pages) it takes 1.3 ms.
+ *       - for 5 Mpix buffer (2491 pages) it takes between 25-50 ms.
+ *
+ * - flush_cache_all:
+ *    - used when the number of pages are _high_.
+ *    - time taken in the range of 500-900 us.
+ *    - has a higher penalty but, as whole dcache + icache is invalidated
+ */
+/*
+ * FIXME: dmac_inv_range crashes randomly on the user space buffer
+ *        address. Fall back to flush_cache_all for now.
+ */
+#define ISP_CACHE_FLUSH_PAGES_MAX       0
+
+static void isp_video_buffer_cache_sync(struct isp_video_buffer *buf)
+{
+	if (buf->skip_cache)
+		return;
+
+	if (buf->vbuf.m.userptr == 0 || buf->npages == 0 ||
+	    buf->npages > ISP_CACHE_FLUSH_PAGES_MAX)
+		flush_cache_all();
+	else {
+		dmac_map_area((void *)buf->vbuf.m.userptr, buf->vbuf.length,
+			      DMA_FROM_DEVICE);
+		outer_inv_range(buf->vbuf.m.userptr,
+				buf->vbuf.m.userptr + buf->vbuf.length);
+	}
+}
+
+/*
+ * isp_video_buffer_lock_vma - Prevent VMAs from being unmapped
+ *
+ * Lock the VMAs underlying the given buffer into memory. This avoids the
+ * userspace buffer mapping from being swapped out, making VIPT cache handling
+ * easier.
+ *
+ * Note that the pages will not be freed as the buffers have been locked to
+ * memory using by a call to get_user_pages(), but the userspace mapping could
+ * still disappear if the VMAs are not locked. This is caused by the memory
+ * management code trying to be as lock-less as possible, which results in the
+ * userspace mapping manager not finding out that the pages are locked under
+ * some conditions.
+ */
+static int isp_video_buffer_lock_vma(struct isp_video_buffer *buf, int lock)
+{
+	struct vm_area_struct *vma;
+	unsigned long start;
+	unsigned long end;
+	int ret = 0;
+
+	if (buf->vbuf.memory == V4L2_MEMORY_MMAP)
+		return 0;
+
+	/* We can be called from workqueue context if the current task dies to
+	 * unlock the VMAs. In that case there's no current memory management
+	 * context so unlocking can't be performed, but the VMAs have been or
+	 * are getting destroyed anyway so it doesn't really matter.
+	 */
+	if (!current || !current->mm)
+		return lock ? -EINVAL : 0;
+
+	start = buf->vbuf.m.userptr;
+	end = buf->vbuf.m.userptr + buf->vbuf.length - 1;
+
+	down_write(&current->mm->mmap_sem);
+	spin_lock(&current->mm->page_table_lock);
+
+	do {
+		vma = find_vma(current->mm, start);
+		if (vma == NULL) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		if (lock)
+			vma->vm_flags |= VM_LOCKED;
+		else
+			vma->vm_flags &= ~VM_LOCKED;
+
+		start = vma->vm_end + 1;
+	} while (vma->vm_end < end);
+
+	if (lock)
+		buf->vm_flags |= VM_LOCKED;
+	else
+		buf->vm_flags &= ~VM_LOCKED;
+
+out:
+	spin_unlock(&current->mm->page_table_lock);
+	up_write(&current->mm->mmap_sem);
+	return ret;
+}
+
+/*
+ * isp_video_buffer_sglist_kernel - Build a scatter list for a vmalloc'ed buffer
+ *
+ * Iterate over the vmalloc'ed area and create a scatter list entry for every
+ * page.
+ */
+static int isp_video_buffer_sglist_kernel(struct isp_video_buffer *buf)
+{
+	struct scatterlist *sglist;
+	unsigned int npages;
+	unsigned int i;
+	void *addr;
+
+	addr = buf->vaddr;
+	npages = PAGE_ALIGN(buf->vbuf.length) >> PAGE_SHIFT;
+
+	sglist = vmalloc(npages * sizeof(*sglist));
+	if (sglist == NULL)
+		return -ENOMEM;
+
+	sg_init_table(sglist, npages);
+
+	for (i = 0; i < npages; ++i, addr += PAGE_SIZE) {
+		struct page *page = vmalloc_to_page(addr);
+
+		if (page == NULL || PageHighMem(page)) {
+			vfree(sglist);
+			return -EINVAL;
+		}
+
+		sg_set_page(&sglist[i], page, PAGE_SIZE, 0);
+	}
+
+	buf->sglen = npages;
+	buf->sglist = sglist;
+
+	return 0;
+}
+
+/*
+ * isp_video_buffer_sglist_user - Build a scatter list for a userspace buffer
+ *
+ * Walk the buffer pages list and create a 1:1 mapping to a scatter list.
+ */
+static int isp_video_buffer_sglist_user(struct isp_video_buffer *buf)
+{
+	struct scatterlist *sglist;
+	unsigned int offset = buf->offset;
+	unsigned int i;
+
+	sglist = vmalloc(buf->npages * sizeof(*sglist));
+	if (sglist == NULL)
+		return -ENOMEM;
+
+	sg_init_table(sglist, buf->npages);
+
+	for (i = 0; i < buf->npages; ++i) {
+		if (PageHighMem(buf->pages[i])) {
+			vfree(sglist);
+			return -EINVAL;
+		}
+
+		sg_set_page(&sglist[i], buf->pages[i], PAGE_SIZE - offset,
+			    offset);
+		offset = 0;
+	}
+
+	buf->sglen = buf->npages;
+	buf->sglist = sglist;
+
+	return 0;
+}
+
+/*
+ * isp_video_buffer_sglist_pfnmap - Build a scatter list for a VM_PFNMAP buffer
+ *
+ * Create a scatter list of physically contiguous pages starting at the buffer
+ * memory physical address.
+ */
+static int isp_video_buffer_sglist_pfnmap(struct isp_video_buffer *buf)
+{
+	struct scatterlist *sglist;
+	unsigned int offset = buf->offset;
+	unsigned long pfn = buf->paddr >> PAGE_SHIFT;
+	unsigned int i;
+
+	sglist = vmalloc(buf->npages * sizeof(*sglist));
+	if (sglist == NULL)
+		return -ENOMEM;
+
+	sg_init_table(sglist, buf->npages);
+
+	for (i = 0; i < buf->npages; ++i, ++pfn) {
+		sg_set_page(&sglist[i], pfn_to_page(pfn), PAGE_SIZE - offset,
+			    offset);
+		/* PFNMAP buffers will not get DMA-mapped, set the DMA address
+		 * manually.
+		 */
+		sg_dma_address(&sglist[i]) = (pfn << PAGE_SHIFT) + offset;
+		offset = 0;
+	}
+
+	buf->sglen = buf->npages;
+	buf->sglist = sglist;
+
+	return 0;
+}
+
+/*
+ * isp_video_buffer_cleanup - Release pages for a userspace VMA.
+ *
+ * Release pages locked by a call isp_video_buffer_prepare_user and free the
+ * pages table.
+ */
+static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
+{
+	enum dma_data_direction direction;
+	unsigned int i;
+
+	if (buf->queue->ops->buffer_cleanup)
+		buf->queue->ops->buffer_cleanup(buf);
+
+	if (!(buf->vm_flags & VM_PFNMAP)) {
+		direction = buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE
+			  ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+		dma_unmap_sg(buf->queue->dev, buf->sglist, buf->sglen,
+			     direction);
+	}
+
+	vfree(buf->sglist);
+	buf->sglist = NULL;
+	buf->sglen = 0;
+
+	if (buf->pages != NULL) {
+		isp_video_buffer_lock_vma(buf, 0);
+
+		for (i = 0; i < buf->npages; ++i)
+			page_cache_release(buf->pages[i]);
+
+		vfree(buf->pages);
+		buf->pages = NULL;
+	}
+
+	buf->npages = 0;
+	buf->skip_cache = false;
+}
+
+/*
+ * isp_video_buffer_prepare_user - Pin userspace VMA pages to memory.
+ *
+ * This function creates a list of pages for a userspace VMA. The number of
+ * pages is first computed based on the buffer size, and pages are then
+ * retrieved by a call to get_user_pages.
+ *
+ * Pages are pinned to memory by get_user_pages, making them available for DMA
+ * transfers. However, due to memory management optimization, it seems the
+ * get_user_pages doesn't guarantee that the pinned pages will not be written
+ * to swap and removed from the userspace mapping(s). When this happens, a page
+ * fault can be generated when accessing those unmapped pages.
+ *
+ * If the fault is triggered by a page table walk caused by VIPT cache
+ * management operations, the page fault handler might oops if the MM semaphore
+ * is held, as it can't handle kernel page faults in that case. To fix that, a
+ * fixup entry needs to be added to the cache management code, or the userspace
+ * VMA must be locked to avoid removing pages from the userspace mapping in the
+ * first place.
+ *
+ * If the number of pages retrieved is smaller than the number required by the
+ * buffer size, the function returns -EFAULT.
+ */
+static int isp_video_buffer_prepare_user(struct isp_video_buffer *buf)
+{
+	unsigned long data;
+	unsigned int first;
+	unsigned int last;
+	int ret;
+
+	data = buf->vbuf.m.userptr;
+	first = (data & PAGE_MASK) >> PAGE_SHIFT;
+	last = ((data + buf->vbuf.length - 1) & PAGE_MASK) >> PAGE_SHIFT;
+
+	buf->offset = data & ~PAGE_MASK;
+	buf->npages = last - first + 1;
+	buf->pages = vmalloc(buf->npages * sizeof(buf->pages[0]));
+	if (buf->pages == NULL)
+		return -ENOMEM;
+
+	down_read(&current->mm->mmap_sem);
+	ret = get_user_pages(current, current->mm, data & PAGE_MASK,
+			     buf->npages,
+			     buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE, 0,
+			     buf->pages, NULL);
+	up_read(&current->mm->mmap_sem);
+
+	if (ret != buf->npages) {
+		buf->npages = ret;
+		isp_video_buffer_cleanup(buf);
+		return -EFAULT;
+	}
+
+	ret = isp_video_buffer_lock_vma(buf, 1);
+	if (ret < 0)
+		isp_video_buffer_cleanup(buf);
+
+	return ret;
+}
+
+/*
+ * isp_video_buffer_prepare_pfnmap - Validate a VM_PFNMAP userspace buffer
+ *
+ * Userspace VM_PFNMAP buffers are supported only if they are contiguous in
+ * memory and if they span a single VMA.
+ *
+ * Return 0 if the buffer is valid, or -EFAULT otherwise.
+ */
+static int isp_video_buffer_prepare_pfnmap(struct isp_video_buffer *buf)
+{
+	struct vm_area_struct *vma;
+	unsigned long prev_pfn;
+	unsigned long this_pfn;
+	unsigned long start;
+	unsigned long end;
+	dma_addr_t pa;
+	int ret = -EFAULT;
+
+	start = buf->vbuf.m.userptr;
+	end = buf->vbuf.m.userptr + buf->vbuf.length - 1;
+
+	buf->offset = start & ~PAGE_MASK;
+	buf->npages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
+	buf->pages = NULL;
+
+	down_read(&current->mm->mmap_sem);
+	vma = find_vma(current->mm, start);
+	if (vma == NULL || vma->vm_end < end)
+		goto done;
+
+	for (prev_pfn = 0; start <= end; start += PAGE_SIZE) {
+		ret = follow_pfn(vma, start, &this_pfn);
+		if (ret)
+			goto done;
+
+		if (prev_pfn == 0)
+			pa = this_pfn << PAGE_SHIFT;
+		else if (this_pfn != prev_pfn + 1) {
+			ret = -EFAULT;
+			goto done;
+		}
+
+		prev_pfn = this_pfn;
+	}
+
+	buf->paddr = pa + buf->offset;
+	ret = 0;
+
+done:
+	up_read(&current->mm->mmap_sem);
+	return ret;
+}
+
+/*
+ * isp_video_buffer_prepare_vm_flags - Get VMA flags for a userspace address
+ *
+ * This function locates the VMAs for the buffer's userspace address and checks
+ * that their flags match. The onlflag that we need to care for at the moment is
+ * VM_PFNMAP.
+ *
+ * The buffer vm_flags field is set to the first VMA flags.
+ *
+ * Return -EFAULT if no VMA can be found for part of the buffer, or if the VMAs
+ * have incompatible flags.
+ */
+static int isp_video_buffer_prepare_vm_flags(struct isp_video_buffer *buf)
+{
+	struct vm_area_struct *vma;
+	pgprot_t vm_page_prot;
+	unsigned long start;
+	unsigned long end;
+	int ret = -EFAULT;
+
+	start = buf->vbuf.m.userptr;
+	end = buf->vbuf.m.userptr + buf->vbuf.length - 1;
+
+	down_read(&current->mm->mmap_sem);
+
+	do {
+		vma = find_vma(current->mm, start);
+		if (vma == NULL)
+			goto done;
+
+		if (start == buf->vbuf.m.userptr) {
+			buf->vm_flags = vma->vm_flags;
+			vm_page_prot = vma->vm_page_prot;
+		}
+
+		if ((buf->vm_flags ^ vma->vm_flags) & VM_PFNMAP)
+			goto done;
+
+		if (vm_page_prot != vma->vm_page_prot)
+			goto done;
+
+		start = vma->vm_end + 1;
+	} while (vma->vm_end < end);
+
+	/* Skip cache management to enhance performances for non-cached or
+	 * write-combining buffers.
+	 */
+	if (vm_page_prot == pgprot_noncached(vm_page_prot) ||
+	    vm_page_prot == pgprot_writecombine(vm_page_prot))
+		buf->skip_cache = true;
+
+	ret = 0;
+
+done:
+	up_read(&current->mm->mmap_sem);
+	return ret;
+}
+
+/*
+ * isp_video_buffer_prepare - Make a buffer ready for operation
+ *
+ * Preparing a buffer involves:
+ *
+ * - validating VMAs (userspace buffers only)
+ * - locking pages and VMAs into memory (userspace buffers only)
+ * - building page and scatter-gather lists
+ * - mapping buffers for DMA operation
+ * - performing driver-specific preparation
+ *
+ * The function must be called in userspace context with a valid mm context
+ * (this excludes cleanup paths such as sys_close when the userspace process
+ * segfaults).
+ */
+static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
+{
+	enum dma_data_direction direction;
+	int ret;
+
+	switch (buf->vbuf.memory) {
+	case V4L2_MEMORY_MMAP:
+		ret = isp_video_buffer_sglist_kernel(buf);
+		break;
+
+	case V4L2_MEMORY_USERPTR:
+		ret = isp_video_buffer_prepare_vm_flags(buf);
+		if (ret < 0)
+			return ret;
+
+		if (buf->vm_flags & VM_PFNMAP) {
+			ret = isp_video_buffer_prepare_pfnmap(buf);
+			if (ret < 0)
+				return ret;
+
+			ret = isp_video_buffer_sglist_pfnmap(buf);
+		} else {
+			ret = isp_video_buffer_prepare_user(buf);
+			if (ret < 0)
+				return ret;
+
+			ret = isp_video_buffer_sglist_user(buf);
+		}
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (ret < 0)
+		goto done;
+
+	if (!(buf->vm_flags & VM_PFNMAP)) {
+		direction = buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE
+			  ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+		ret = dma_map_sg(buf->queue->dev, buf->sglist, buf->sglen,
+				 direction);
+		if (ret != buf->sglen) {
+			ret = -EFAULT;
+			goto done;
+		}
+	}
+
+	if (buf->queue->ops->buffer_prepare)
+		ret = buf->queue->ops->buffer_prepare(buf);
+
+done:
+	if (ret < 0) {
+		isp_video_buffer_cleanup(buf);
+		return ret;
+	}
+
+	return ret;
+}
+
+/*
+ * isp_video_queue_query - Query the status of a given buffer
+ *
+ * Locking: must be called with the queue lock held.
+ */
+static void isp_video_buffer_query(struct isp_video_buffer *buf,
+				   struct v4l2_buffer *vbuf)
+{
+	memcpy(vbuf, &buf->vbuf, sizeof(*vbuf));
+
+	if (buf->vma_use_count)
+		vbuf->flags |= V4L2_BUF_FLAG_MAPPED;
+
+	switch (buf->state) {
+	case ISP_BUF_STATE_ERROR:
+		vbuf->flags |= V4L2_BUF_FLAG_ERROR;
+	case ISP_BUF_STATE_DONE:
+		vbuf->flags |= V4L2_BUF_FLAG_DONE;
+	case ISP_BUF_STATE_QUEUED:
+	case ISP_BUF_STATE_ACTIVE:
+		vbuf->flags |= V4L2_BUF_FLAG_QUEUED;
+		break;
+	case ISP_BUF_STATE_IDLE:
+	default:
+		break;
+	}
+}
+
+/*
+ * isp_video_buffer_wait - Wait for a buffer to be ready
+ *
+ * In non-blocking mode, return immediately with 0 if the buffer is ready or
+ * -EAGAIN if the buffer is in the QUEUED or ACTIVE state.
+ *
+ * In blocking mode, wait (interruptibly but with no timeout) on the buffer wait
+ * queue using the same condition.
+ */
+static int isp_video_buffer_wait(struct isp_video_buffer *buf, int nonblocking)
+{
+	if (nonblocking) {
+		return (buf->state != ISP_BUF_STATE_QUEUED &&
+			buf->state != ISP_BUF_STATE_ACTIVE)
+			? 0 : -EAGAIN;
+	}
+
+	return wait_event_interruptible(buf->wait,
+		buf->state != ISP_BUF_STATE_QUEUED &&
+		buf->state != ISP_BUF_STATE_ACTIVE);
+}
+
+/* -----------------------------------------------------------------------------
+ * Queue management
+ */
+
+/*
+ * isp_video_queue_free - Free video buffers memory
+ *
+ * Buffers can only be freed if the queue isn't streaming and if no buffer is
+ * mapped to userspace. Return -EBUSY if those conditions aren't statisfied.
+ *
+ * This function must be called with the queue lock held.
+ */
+static int isp_video_queue_free(struct isp_video_queue *queue)
+{
+	unsigned int i;
+
+	if (queue->streaming)
+		return -EBUSY;
+
+	for (i = 0; i < queue->count; ++i) {
+		if (queue->buffers[i]->vma_use_count != 0)
+			return -EBUSY;
+	}
+
+	for (i = 0; i < queue->count; ++i) {
+		struct isp_video_buffer *buf = queue->buffers[i];
+
+		isp_video_buffer_cleanup(buf);
+
+		vfree(buf->vaddr);
+		buf->vaddr = NULL;
+
+		kfree(buf);
+		queue->buffers[i] = NULL;
+	}
+
+	INIT_LIST_HEAD(&queue->queue);
+	queue->count = 0;
+	return 0;
+}
+
+/*
+ * isp_video_queue_alloc - Allocate video buffers memory
+ *
+ * This function must be called with the queue lock held.
+ */
+static int isp_video_queue_alloc(struct isp_video_queue *queue,
+				 unsigned int nbuffers,
+				 unsigned int size, enum v4l2_memory memory)
+{
+	struct isp_video_buffer *buf;
+	unsigned int i;
+	void *mem;
+	int ret;
+
+	/* Start by freeing the buffers. */
+	ret = isp_video_queue_free(queue);
+	if (ret < 0)
+		return ret;
+
+	/* Bail out of no buffers should be allocated. */
+	if (nbuffers == 0)
+		return 0;
+
+	/* Initialize the allocated buffers. */
+	for (i = 0; i < nbuffers; ++i) {
+		buf = kzalloc(queue->bufsize, GFP_KERNEL);
+		if (buf == NULL)
+			break;
+
+		if (memory == V4L2_MEMORY_MMAP) {
+			/* Allocate video buffers memory for mmap mode. Align
+			 * the size to the page size.
+			 */
+			mem = vmalloc_32_user(PAGE_ALIGN(size));
+			if (mem == NULL) {
+				kfree(buf);
+				break;
+			}
+
+			buf->vbuf.m.offset = i * PAGE_ALIGN(size);
+			buf->vaddr = mem;
+		}
+
+		buf->vbuf.index = i;
+		buf->vbuf.length = size;
+		buf->vbuf.type = queue->type;
+		buf->vbuf.field = V4L2_FIELD_NONE;
+		buf->vbuf.memory = memory;
+
+		buf->queue = queue;
+		init_waitqueue_head(&buf->wait);
+
+		queue->buffers[i] = buf;
+	}
+
+	if (i == 0)
+		return -ENOMEM;
+
+	queue->count = i;
+	return nbuffers;
+}
+
+/**
+ * omap3isp_video_queue_cleanup - Clean up the video buffers queue
+ * @queue: Video buffers queue
+ *
+ * Free all allocated resources and clean up the video buffers queue. The queue
+ * must not be busy (no ongoing video stream) and buffers must have been
+ * unmapped.
+ *
+ * Return 0 on success or -EBUSY if the queue is busy or buffers haven't been
+ * unmapped.
+ */
+int omap3isp_video_queue_cleanup(struct isp_video_queue *queue)
+{
+	return isp_video_queue_free(queue);
+}
+
+/**
+ * omap3isp_video_queue_init - Initialize the video buffers queue
+ * @queue: Video buffers queue
+ * @type: V4L2 buffer type (capture or output)
+ * @ops: Driver-specific queue operations
+ * @dev: Device used for DMA operations
+ * @bufsize: Size of the driver-specific buffer structure
+ *
+ * Initialize the video buffers queue with the supplied parameters.
+ *
+ * The queue type must be one of V4L2_BUF_TYPE_VIDEO_CAPTURE or
+ * V4L2_BUF_TYPE_VIDEO_OUTPUT. Other buffer types are not supported yet.
+ *
+ * Buffer objects will be allocated using the given buffer size to allow room
+ * for driver-specific fields. Driver-specific buffer structures must start
+ * with a struct isp_video_buffer field. Drivers with no driver-specific buffer
+ * structure must pass the size of the isp_video_buffer structure in the bufsize
+ * parameter.
+ *
+ * Return 0 on success.
+ */
+int omap3isp_video_queue_init(struct isp_video_queue *queue,
+			      enum v4l2_buf_type type,
+			      const struct isp_video_queue_operations *ops,
+			      struct device *dev, unsigned int bufsize)
+{
+	INIT_LIST_HEAD(&queue->queue);
+	mutex_init(&queue->lock);
+	spin_lock_init(&queue->irqlock);
+
+	queue->type = type;
+	queue->ops = ops;
+	queue->dev = dev;
+	queue->bufsize = bufsize;
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 operations
+ */
+
+/**
+ * omap3isp_video_queue_reqbufs - Allocate video buffers memory
+ *
+ * This function is intended to be used as a VIDIOC_REQBUFS ioctl handler. It
+ * allocated video buffer objects and, for MMAP buffers, buffer memory.
+ *
+ * If the number of buffers is 0, all buffers are freed and the function returns
+ * without performing any allocation.
+ *
+ * If the number of buffers is not 0, currently allocated buffers (if any) are
+ * freed and the requested number of buffers are allocated. Depending on
+ * driver-specific requirements and on memory availability, a number of buffer
+ * smaller or bigger than requested can be allocated. This isn't considered as
+ * an error.
+ *
+ * Return 0 on success or one of the following error codes:
+ *
+ * -EINVAL if the buffer type or index are invalid
+ * -EBUSY if the queue is busy (streaming or buffers mapped)
+ * -ENOMEM if the buffers can't be allocated due to an out-of-memory condition
+ */
+int omap3isp_video_queue_reqbufs(struct isp_video_queue *queue,
+				 struct v4l2_requestbuffers *rb)
+{
+	unsigned int nbuffers = rb->count;
+	unsigned int size;
+	int ret;
+
+	if (rb->type != queue->type)
+		return -EINVAL;
+
+	queue->ops->queue_prepare(queue, &nbuffers, &size);
+	if (size == 0)
+		return -EINVAL;
+
+	nbuffers = min_t(unsigned int, nbuffers, ISP_VIDEO_MAX_BUFFERS);
+
+	mutex_lock(&queue->lock);
+
+	ret = isp_video_queue_alloc(queue, nbuffers, size, rb->memory);
+	if (ret < 0)
+		goto done;
+
+	rb->count = ret;
+	ret = 0;
+
+done:
+	mutex_unlock(&queue->lock);
+	return ret;
+}
+
+/**
+ * omap3isp_video_queue_querybuf - Query the status of a buffer in a queue
+ *
+ * This function is intended to be used as a VIDIOC_QUERYBUF ioctl handler. It
+ * returns the status of a given video buffer.
+ *
+ * Return 0 on success or -EINVAL if the buffer type or index are invalid.
+ */
+int omap3isp_video_queue_querybuf(struct isp_video_queue *queue,
+				  struct v4l2_buffer *vbuf)
+{
+	struct isp_video_buffer *buf;
+	int ret = 0;
+
+	if (vbuf->type != queue->type)
+		return -EINVAL;
+
+	mutex_lock(&queue->lock);
+
+	if (vbuf->index >= queue->count) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	buf = queue->buffers[vbuf->index];
+	isp_video_buffer_query(buf, vbuf);
+
+done:
+	mutex_unlock(&queue->lock);
+	return ret;
+}
+
+/**
+ * omap3isp_video_queue_qbuf - Queue a buffer
+ *
+ * This function is intended to be used as a VIDIOC_QBUF ioctl handler.
+ *
+ * The v4l2_buffer structure passed from userspace is first sanity tested. If
+ * sane, the buffer is then processed and added to the main queue and, if the
+ * queue is streaming, to the IRQ queue.
+ *
+ * Before being enqueued, USERPTR buffers are checked for address changes. If
+ * the buffer has a different userspace address, the old memory area is unlocked
+ * and the new memory area is locked.
+ */
+int omap3isp_video_queue_qbuf(struct isp_video_queue *queue,
+			      struct v4l2_buffer *vbuf)
+{
+	struct isp_video_buffer *buf;
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	if (vbuf->type != queue->type)
+		goto done;
+
+	mutex_lock(&queue->lock);
+
+	if (vbuf->index >= queue->count)
+		goto done;
+
+	buf = queue->buffers[vbuf->index];
+
+	if (vbuf->memory != buf->vbuf.memory)
+		goto done;
+
+	if (buf->state != ISP_BUF_STATE_IDLE)
+		goto done;
+
+	if (vbuf->memory == V4L2_MEMORY_USERPTR &&
+	    vbuf->m.userptr != buf->vbuf.m.userptr) {
+		isp_video_buffer_cleanup(buf);
+		buf->vbuf.m.userptr = vbuf->m.userptr;
+		buf->prepared = 0;
+	}
+
+	if (!buf->prepared) {
+		ret = isp_video_buffer_prepare(buf);
+		if (ret < 0)
+			goto done;
+		buf->prepared = 1;
+	}
+
+	isp_video_buffer_cache_sync(buf);
+
+	buf->state = ISP_BUF_STATE_QUEUED;
+	list_add_tail(&buf->stream, &queue->queue);
+
+	if (queue->streaming) {
+		spin_lock_irqsave(&queue->irqlock, flags);
+		queue->ops->buffer_queue(buf);
+		spin_unlock_irqrestore(&queue->irqlock, flags);
+	}
+
+	ret = 0;
+
+done:
+	mutex_unlock(&queue->lock);
+	return ret;
+}
+
+/**
+ * omap3isp_video_queue_dqbuf - Dequeue a buffer
+ *
+ * This function is intended to be used as a VIDIOC_DQBUF ioctl handler.
+ *
+ * The v4l2_buffer structure passed from userspace is first sanity tested. If
+ * sane, the buffer is then processed and added to the main queue and, if the
+ * queue is streaming, to the IRQ queue.
+ *
+ * Before being enqueued, USERPTR buffers are checked for address changes. If
+ * the buffer has a different userspace address, the old memory area is unlocked
+ * and the new memory area is locked.
+ */
+int omap3isp_video_queue_dqbuf(struct isp_video_queue *queue,
+			       struct v4l2_buffer *vbuf, int nonblocking)
+{
+	struct isp_video_buffer *buf;
+	int ret;
+
+	if (vbuf->type != queue->type)
+		return -EINVAL;
+
+	mutex_lock(&queue->lock);
+
+	if (list_empty(&queue->queue)) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	buf = list_first_entry(&queue->queue, struct isp_video_buffer, stream);
+	ret = isp_video_buffer_wait(buf, nonblocking);
+	if (ret < 0)
+		goto done;
+
+	list_del(&buf->stream);
+
+	isp_video_buffer_query(buf, vbuf);
+	buf->state = ISP_BUF_STATE_IDLE;
+	vbuf->flags &= ~V4L2_BUF_FLAG_QUEUED;
+
+done:
+	mutex_unlock(&queue->lock);
+	return ret;
+}
+
+/**
+ * omap3isp_video_queue_streamon - Start streaming
+ *
+ * This function is intended to be used as a VIDIOC_STREAMON ioctl handler. It
+ * starts streaming on the queue and calls the buffer_queue operation for all
+ * queued buffers.
+ *
+ * Return 0 on success.
+ */
+int omap3isp_video_queue_streamon(struct isp_video_queue *queue)
+{
+	struct isp_video_buffer *buf;
+	unsigned long flags;
+
+	mutex_lock(&queue->lock);
+
+	if (queue->streaming)
+		goto done;
+
+	queue->streaming = 1;
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+	list_for_each_entry(buf, &queue->queue, stream)
+		queue->ops->buffer_queue(buf);
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+
+done:
+	mutex_unlock(&queue->lock);
+	return 0;
+}
+
+/**
+ * omap3isp_video_queue_streamoff - Stop streaming
+ *
+ * This function is intended to be used as a VIDIOC_STREAMOFF ioctl handler. It
+ * stops streaming on the queue and wakes up all the buffers.
+ *
+ * Drivers must stop the hardware and synchronize with interrupt handlers and/or
+ * delayed works before calling this function to make sure no buffer will be
+ * touched by the driver and/or hardware.
+ */
+void omap3isp_video_queue_streamoff(struct isp_video_queue *queue)
+{
+	struct isp_video_buffer *buf;
+	unsigned long flags;
+	unsigned int i;
+
+	mutex_lock(&queue->lock);
+
+	if (!queue->streaming)
+		goto done;
+
+	queue->streaming = 0;
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+	for (i = 0; i < queue->count; ++i) {
+		buf = queue->buffers[i];
+
+		if (buf->state == ISP_BUF_STATE_ACTIVE)
+			wake_up(&buf->wait);
+
+		buf->state = ISP_BUF_STATE_IDLE;
+	}
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+
+	INIT_LIST_HEAD(&queue->queue);
+
+done:
+	mutex_unlock(&queue->lock);
+}
+
+/**
+ * omap3isp_video_queue_discard_done - Discard all buffers marked as DONE
+ *
+ * This function is intended to be used with suspend/resume operations. It
+ * discards all 'done' buffers as they would be too old to be requested after
+ * resume.
+ *
+ * Drivers must stop the hardware and synchronize with interrupt handlers and/or
+ * delayed works before calling this function to make sure no buffer will be
+ * touched by the driver and/or hardware.
+ */
+void omap3isp_video_queue_discard_done(struct isp_video_queue *queue)
+{
+	struct isp_video_buffer *buf;
+	unsigned int i;
+
+	mutex_lock(&queue->lock);
+
+	if (!queue->streaming)
+		goto done;
+
+	for (i = 0; i < queue->count; ++i) {
+		buf = queue->buffers[i];
+
+		if (buf->state == ISP_BUF_STATE_DONE)
+			buf->state = ISP_BUF_STATE_ERROR;
+	}
+
+done:
+	mutex_unlock(&queue->lock);
+}
+
+static void isp_video_queue_vm_open(struct vm_area_struct *vma)
+{
+	struct isp_video_buffer *buf = vma->vm_private_data;
+
+	buf->vma_use_count++;
+}
+
+static void isp_video_queue_vm_close(struct vm_area_struct *vma)
+{
+	struct isp_video_buffer *buf = vma->vm_private_data;
+
+	buf->vma_use_count--;
+}
+
+static const struct vm_operations_struct isp_video_queue_vm_ops = {
+	.open = isp_video_queue_vm_open,
+	.close = isp_video_queue_vm_close,
+};
+
+/**
+ * omap3isp_video_queue_mmap - Map buffers to userspace
+ *
+ * This function is intended to be used as an mmap() file operation handler. It
+ * maps a buffer to userspace based on the VMA offset.
+ *
+ * Only buffers of memory type MMAP are supported.
+ */
+int omap3isp_video_queue_mmap(struct isp_video_queue *queue,
+			 struct vm_area_struct *vma)
+{
+	struct isp_video_buffer *uninitialized_var(buf);
+	unsigned long size;
+	unsigned int i;
+	int ret = 0;
+
+	mutex_lock(&queue->lock);
+
+	for (i = 0; i < queue->count; ++i) {
+		buf = queue->buffers[i];
+		if ((buf->vbuf.m.offset >> PAGE_SHIFT) == vma->vm_pgoff)
+			break;
+	}
+
+	if (i == queue->count) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	size = vma->vm_end - vma->vm_start;
+
+	if (buf->vbuf.memory != V4L2_MEMORY_MMAP ||
+	    size != PAGE_ALIGN(buf->vbuf.length)) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	ret = remap_vmalloc_range(vma, buf->vaddr, 0);
+	if (ret < 0)
+		goto done;
+
+	vma->vm_ops = &isp_video_queue_vm_ops;
+	vma->vm_private_data = buf;
+	isp_video_queue_vm_open(vma);
+
+done:
+	mutex_unlock(&queue->lock);
+	return ret;
+}
+
+/**
+ * omap3isp_video_queue_poll - Poll video queue state
+ *
+ * This function is intended to be used as a poll() file operation handler. It
+ * polls the state of the video buffer at the front of the queue and returns an
+ * events mask.
+ *
+ * If no buffer is present at the front of the queue, POLLERR is returned.
+ */
+unsigned int omap3isp_video_queue_poll(struct isp_video_queue *queue,
+				       struct file *file, poll_table *wait)
+{
+	struct isp_video_buffer *buf;
+	unsigned int mask = 0;
+
+	mutex_lock(&queue->lock);
+	if (list_empty(&queue->queue)) {
+		mask |= POLLERR;
+		goto done;
+	}
+	buf = list_first_entry(&queue->queue, struct isp_video_buffer, stream);
+
+	poll_wait(file, &buf->wait, wait);
+	if (buf->state == ISP_BUF_STATE_DONE ||
+	    buf->state == ISP_BUF_STATE_ERROR) {
+		if (queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			mask |= POLLIN | POLLRDNORM;
+		else
+			mask |= POLLOUT | POLLWRNORM;
+	}
+
+done:
+	mutex_unlock(&queue->lock);
+	return mask;
+}
diff --git a/drivers/media/video/omap3-isp/ispqueue.h b/drivers/media/video/omap3-isp/ispqueue.h
new file mode 100644
index 0000000..251de3e
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispqueue.h
@@ -0,0 +1,187 @@
+/*
+ * ispqueue.h
+ *
+ * TI OMAP3 ISP - Video buffers queue handling
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef OMAP3_ISP_QUEUE_H
+#define OMAP3_ISP_QUEUE_H
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/videodev2.h>
+#include <linux/wait.h>
+
+struct isp_video_queue;
+struct page;
+struct scatterlist;
+
+#define ISP_VIDEO_MAX_BUFFERS		16
+
+/**
+ * enum isp_video_buffer_state - ISP video buffer state
+ * @ISP_BUF_STATE_IDLE:	The buffer is under userspace control (dequeued
+ *	or not queued yet).
+ * @ISP_BUF_STATE_QUEUED: The buffer has been queued but isn't used by the
+ *	device yet.
+ * @ISP_BUF_STATE_ACTIVE: The buffer is in use for an active video transfer.
+ * @ISP_BUF_STATE_ERROR: The device is done with the buffer and an error
+ *	occured. For capture device the buffer likely contains corrupted data or
+ *	no data at all.
+ * @ISP_BUF_STATE_DONE: The device is done with the buffer and no error occured.
+ *	For capture devices the buffer contains valid data.
+ */
+enum isp_video_buffer_state {
+	ISP_BUF_STATE_IDLE,
+	ISP_BUF_STATE_QUEUED,
+	ISP_BUF_STATE_ACTIVE,
+	ISP_BUF_STATE_ERROR,
+	ISP_BUF_STATE_DONE,
+};
+
+/**
+ * struct isp_video_buffer - ISP video buffer
+ * @vma_use_count: Number of times the buffer is mmap'ed to userspace
+ * @stream: List head for insertion into main queue
+ * @queue: ISP buffers queue this buffer belongs to
+ * @prepared: Whether the buffer has been prepared
+ * @skip_cache: Whether to skip cache management operations for this buffer
+ * @vaddr: Memory virtual address (for kernel buffers)
+ * @vm_flags: Buffer VMA flags (for userspace buffers)
+ * @offset: Offset inside the first page (for userspace buffers)
+ * @npages: Number of pages (for userspace buffers)
+ * @pages: Pages table (for userspace non-VM_PFNMAP buffers)
+ * @paddr: Memory physical address (for userspace VM_PFNMAP buffers)
+ * @sglen: Number of elements in the scatter list (for non-VM_PFNMAP buffers)
+ * @sglist: Scatter list (for non-VM_PFNMAP buffers)
+ * @vbuf: V4L2 buffer
+ * @irqlist: List head for insertion into IRQ queue
+ * @state: Current buffer state
+ * @wait: Wait queue to signal buffer completion
+ */
+struct isp_video_buffer {
+	unsigned long vma_use_count;
+	struct list_head stream;
+	struct isp_video_queue *queue;
+	unsigned int prepared:1;
+	bool skip_cache;
+
+	/* For kernel buffers. */
+	void *vaddr;
+
+	/* For userspace buffers. */
+	unsigned long vm_flags;
+	unsigned long offset;
+	unsigned int npages;
+	struct page **pages;
+	dma_addr_t paddr;
+
+	/* For all buffers except VM_PFNMAP. */
+	unsigned int sglen;
+	struct scatterlist *sglist;
+
+	/* Touched by the interrupt handler. */
+	struct v4l2_buffer vbuf;
+	struct list_head irqlist;
+	enum isp_video_buffer_state state;
+	wait_queue_head_t wait;
+};
+
+#define to_isp_video_buffer(vb)	container_of(vb, struct isp_video_buffer, vb)
+
+/**
+ * struct isp_video_queue_operations - Driver-specific operations
+ * @queue_prepare: Called before allocating buffers. Drivers should clamp the
+ *	number of buffers according to their requirements, and must return the
+ *	buffer size in bytes.
+ * @buffer_prepare: Called the first time a buffer is queued, or after changing
+ *	the userspace memory address for a USERPTR buffer, with the queue lock
+ *	held. Drivers should perform device-specific buffer preparation (such as
+ *	mapping the buffer memory in an IOMMU). This operation is optional.
+ * @buffer_queue: Called when a buffer is being added to the queue with the
+ *	queue irqlock spinlock held.
+ * @buffer_cleanup: Called before freeing buffers, or before changing the
+ *	userspace memory address for a USERPTR buffer, with the queue lock held.
+ *	Drivers must perform cleanup operations required to undo the
+ *	buffer_prepare call. This operation is optional.
+ */
+struct isp_video_queue_operations {
+	void (*queue_prepare)(struct isp_video_queue *queue,
+			      unsigned int *nbuffers, unsigned int *size);
+	int  (*buffer_prepare)(struct isp_video_buffer *buf);
+	void (*buffer_queue)(struct isp_video_buffer *buf);
+	void (*buffer_cleanup)(struct isp_video_buffer *buf);
+};
+
+/**
+ * struct isp_video_queue - ISP video buffers queue
+ * @type: Type of video buffers handled by this queue
+ * @ops: Queue operations
+ * @dev: Device used for DMA operations
+ * @bufsize: Size of a driver-specific buffer object
+ * @count: Number of currently allocated buffers
+ * @buffers: ISP video buffers
+ * @lock: Mutex to protect access to the buffers, main queue and state
+ * @irqlock: Spinlock to protect access to the IRQ queue
+ * @streaming: Queue state, indicates whether the queue is streaming
+ * @queue: List of all queued buffers
+ */
+struct isp_video_queue {
+	enum v4l2_buf_type type;
+	const struct isp_video_queue_operations *ops;
+	struct device *dev;
+	unsigned int bufsize;
+
+	unsigned int count;
+	struct isp_video_buffer *buffers[ISP_VIDEO_MAX_BUFFERS];
+	struct mutex lock;
+	spinlock_t irqlock;
+
+	unsigned int streaming:1;
+
+	struct list_head queue;
+};
+
+int omap3isp_video_queue_cleanup(struct isp_video_queue *queue);
+int omap3isp_video_queue_init(struct isp_video_queue *queue,
+			      enum v4l2_buf_type type,
+			      const struct isp_video_queue_operations *ops,
+			      struct device *dev, unsigned int bufsize);
+
+int omap3isp_video_queue_reqbufs(struct isp_video_queue *queue,
+				 struct v4l2_requestbuffers *rb);
+int omap3isp_video_queue_querybuf(struct isp_video_queue *queue,
+				  struct v4l2_buffer *vbuf);
+int omap3isp_video_queue_qbuf(struct isp_video_queue *queue,
+			      struct v4l2_buffer *vbuf);
+int omap3isp_video_queue_dqbuf(struct isp_video_queue *queue,
+			       struct v4l2_buffer *vbuf, int nonblocking);
+int omap3isp_video_queue_streamon(struct isp_video_queue *queue);
+void omap3isp_video_queue_streamoff(struct isp_video_queue *queue);
+void omap3isp_video_queue_discard_done(struct isp_video_queue *queue);
+int omap3isp_video_queue_mmap(struct isp_video_queue *queue,
+			      struct vm_area_struct *vma);
+unsigned int omap3isp_video_queue_poll(struct isp_video_queue *queue,
+				       struct file *file, poll_table *wait);
+
+#endif /* OMAP3_ISP_QUEUE_H */
diff --git a/drivers/media/video/omap3-isp/ispvideo.c b/drivers/media/video/omap3-isp/ispvideo.c
new file mode 100644
index 0000000..517a24d
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispvideo.c
@@ -0,0 +1,1264 @@
+/*
+ * ispvideo.c
+ *
+ * TI OMAP3 ISP - Generic video node
+ *
+ * Copyright (C) 2009-2010 Nokia Corporation
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <asm/cacheflush.h>
+#include <linux/clk.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/scatterlist.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-ioctl.h>
+#include <plat/iommu.h>
+#include <plat/iovmm.h>
+#include <plat/omap-pm.h>
+
+#include "ispvideo.h"
+#include "isp.h"
+
+
+/* -----------------------------------------------------------------------------
+ * Helper functions
+ */
+
+static struct isp_format_info formats[] = {
+	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
+	  V4L2_MBUS_FMT_Y8_1X8, V4L2_PIX_FMT_GREY, 8, },
+	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
+	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
+	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,
+	  V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_PIX_FMT_SBGGR10, 10, },
+	{ V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG10_1X10,
+	  V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_PIX_FMT_SGBRG10, 10, },
+	{ V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG10_1X10,
+	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10, 10, },
+	{ V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB10_1X10,
+	  V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_PIX_FMT_SRGGB10, 10, },
+	{ V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR10_1X10,
+	  V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_PIX_FMT_SBGGR12, 12, },
+	{ V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG10_1X10,
+	  V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_PIX_FMT_SGBRG12, 12, },
+	{ V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG10_1X10,
+	  V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_PIX_FMT_SGRBG12, 12, },
+	{ V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB10_1X10,
+	  V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_PIX_FMT_SRGGB12, 12, },
+	{ V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_1X16,
+	  V4L2_MBUS_FMT_UYVY8_1X16, V4L2_PIX_FMT_UYVY, 16, },
+	{ V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_1X16,
+	  V4L2_MBUS_FMT_YUYV8_1X16, V4L2_PIX_FMT_YUYV, 16, },
+};
+
+const struct isp_format_info *
+omap3isp_video_format_info(enum v4l2_mbus_pixelcode code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		if (formats[i].code == code)
+			return &formats[i];
+	}
+
+	return NULL;
+}
+
+/*
+ * isp_video_mbus_to_pix - Convert v4l2_mbus_framefmt to v4l2_pix_format
+ * @video: ISP video instance
+ * @mbus: v4l2_mbus_framefmt format (input)
+ * @pix: v4l2_pix_format format (output)
+ *
+ * Fill the output pix structure with information from the input mbus format.
+ * The bytesperline and sizeimage fields are computed from the requested bytes
+ * per line value in the pix format and information from the video instance.
+ *
+ * Return the number of padding bytes at end of line.
+ */
+static unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
+					  const struct v4l2_mbus_framefmt *mbus,
+					  struct v4l2_pix_format *pix)
+{
+	unsigned int bpl = pix->bytesperline;
+	unsigned int min_bpl;
+	unsigned int i;
+
+	memset(pix, 0, sizeof(*pix));
+	pix->width = mbus->width;
+	pix->height = mbus->height;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		if (formats[i].code == mbus->code)
+			break;
+	}
+
+	if (WARN_ON(i == ARRAY_SIZE(formats)))
+		return 0;
+
+	min_bpl = pix->width * ALIGN(formats[i].bpp, 8) / 8;
+
+	/* Clamp the requested bytes per line value. If the maximum bytes per
+	 * line value is zero, the module doesn't support user configurable line
+	 * sizes. Override the requested value with the minimum in that case.
+	 */
+	if (video->bpl_max)
+		bpl = clamp(bpl, min_bpl, video->bpl_max);
+	else
+		bpl = min_bpl;
+
+	if (!video->bpl_zero_padding || bpl != min_bpl)
+		bpl = ALIGN(bpl, video->bpl_alignment);
+
+	pix->pixelformat = formats[i].pixelformat;
+	pix->bytesperline = bpl;
+	pix->sizeimage = pix->bytesperline * pix->height;
+	pix->colorspace = mbus->colorspace;
+	pix->field = mbus->field;
+
+	return bpl - min_bpl;
+}
+
+static void isp_video_pix_to_mbus(const struct v4l2_pix_format *pix,
+				  struct v4l2_mbus_framefmt *mbus)
+{
+	unsigned int i;
+
+	memset(mbus, 0, sizeof(*mbus));
+	mbus->width = pix->width;
+	mbus->height = pix->height;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		if (formats[i].pixelformat == pix->pixelformat)
+			break;
+	}
+
+	if (WARN_ON(i == ARRAY_SIZE(formats)))
+		return;
+
+	mbus->code = formats[i].code;
+	mbus->colorspace = pix->colorspace;
+	mbus->field = pix->field;
+}
+
+static struct v4l2_subdev *
+isp_video_remote_subdev(struct isp_video *video, u32 *pad)
+{
+	struct media_pad *remote;
+
+	remote = media_entity_remote_source(&video->pad);
+
+	if (remote == NULL ||
+	    media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+		return NULL;
+
+	if (pad)
+		*pad = remote->index;
+
+	return media_entity_to_v4l2_subdev(remote->entity);
+}
+
+/* Return a pointer to the ISP video instance at the far end of the pipeline. */
+static struct isp_video *
+isp_video_far_end(struct isp_video *video)
+{
+	struct media_entity_graph graph;
+	struct media_entity *entity = &video->video.entity;
+	struct media_device *mdev = entity->parent;
+	struct isp_video *far_end = NULL;
+
+	mutex_lock(&mdev->graph_mutex);
+	media_entity_graph_walk_start(&graph, entity);
+
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+		if (entity == &video->video.entity)
+			continue;
+
+		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
+			continue;
+
+		far_end = to_isp_video(media_entity_to_video_device(entity));
+		if (far_end->type != video->type)
+			break;
+
+		far_end = NULL;
+	}
+
+	mutex_unlock(&mdev->graph_mutex);
+	return far_end;
+}
+
+/*
+ * Validate a pipeline by checking both ends of all links for format
+ * discrepancies.
+ *
+ * Compute the minimum time per frame value as the maximum of time per frame
+ * limits reported by every block in the pipeline.
+ *
+ * Return 0 if all formats match, or -EPIPE if at least one link is found with
+ * different formats on its two ends.
+ */
+static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
+{
+	struct isp_device *isp = pipe->output->isp;
+	struct v4l2_subdev_format fmt_source;
+	struct v4l2_subdev_format fmt_sink;
+	struct media_pad *pad;
+	struct v4l2_subdev *subdev;
+	int ret;
+
+	pipe->max_rate = pipe->l3_ick;
+
+	subdev = isp_video_remote_subdev(pipe->output, NULL);
+	if (subdev == NULL)
+		return -EPIPE;
+
+	while (1) {
+		/* Retrieve the sink format */
+		pad = &subdev->entity.pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+
+		fmt_sink.pad = pad->index;
+		fmt_sink.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt_sink);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return -EPIPE;
+
+		/* Update the maximum frame rate */
+		if (subdev == &isp->isp_res.subdev)
+			omap3isp_resizer_max_rate(&isp->isp_res,
+						  &pipe->max_rate);
+
+		/* Check ccdc maximum data rate when data comes from sensor
+		 * TODO: Include ccdc rate in pipe->max_rate and compare the
+		 *       total pipe rate with the input data rate from sensor.
+		 */
+		if (subdev == &isp->isp_ccdc.subdev && pipe->input == NULL) {
+			unsigned int rate = UINT_MAX;
+
+			omap3isp_ccdc_max_rate(&isp->isp_ccdc, &rate);
+			if (isp->isp_ccdc.vpcfg.pixelclk > rate)
+				return -ENOSPC;
+		}
+
+		/* Retrieve the source format */
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		subdev = media_entity_to_v4l2_subdev(pad->entity);
+
+		fmt_source.pad = pad->index;
+		fmt_source.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt_source);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return -EPIPE;
+
+		/* Check if the two ends match */
+		if (fmt_source.format.code != fmt_sink.format.code ||
+		    fmt_source.format.width != fmt_sink.format.width ||
+		    fmt_source.format.height != fmt_sink.format.height)
+			return -EPIPE;
+	}
+
+	return 0;
+}
+
+static int
+__isp_video_get_format(struct isp_video *video, struct v4l2_format *format)
+{
+	struct v4l2_subdev_format fmt;
+	struct v4l2_subdev *subdev;
+	u32 pad;
+	int ret;
+
+	subdev = isp_video_remote_subdev(video, &pad);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	mutex_lock(&video->mutex);
+
+	fmt.pad = pad;
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
+	if (ret == -ENOIOCTLCMD)
+		ret = -EINVAL;
+
+	mutex_unlock(&video->mutex);
+
+	if (ret)
+		return ret;
+
+	format->type = video->type;
+	return isp_video_mbus_to_pix(video, &fmt.format, &format->fmt.pix);
+}
+
+static int
+isp_video_check_format(struct isp_video *video, struct isp_video_fh *vfh)
+{
+	struct v4l2_format format;
+	int ret;
+
+	memcpy(&format, &vfh->format, sizeof(format));
+	ret = __isp_video_get_format(video, &format);
+	if (ret < 0)
+		return ret;
+
+	if (vfh->format.fmt.pix.pixelformat != format.fmt.pix.pixelformat ||
+	    vfh->format.fmt.pix.height != format.fmt.pix.height ||
+	    vfh->format.fmt.pix.width != format.fmt.pix.width ||
+	    vfh->format.fmt.pix.bytesperline != format.fmt.pix.bytesperline ||
+	    vfh->format.fmt.pix.sizeimage != format.fmt.pix.sizeimage)
+		return -EINVAL;
+
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * IOMMU management
+ */
+
+#define IOMMU_FLAG	(IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_8)
+
+/*
+ * ispmmu_vmap - Wrapper for Virtual memory mapping of a scatter gather list
+ * @dev: Device pointer specific to the OMAP3 ISP.
+ * @sglist: Pointer to source Scatter gather list to allocate.
+ * @sglen: Number of elements of the scatter-gatter list.
+ *
+ * Returns a resulting mapped device address by the ISP MMU, or -ENOMEM if
+ * we ran out of memory.
+ */
+static dma_addr_t
+ispmmu_vmap(struct isp_device *isp, const struct scatterlist *sglist, int sglen)
+{
+	struct sg_table *sgt;
+	u32 da;
+
+	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
+	if (sgt == NULL)
+		return -ENOMEM;
+
+	sgt->sgl = (struct scatterlist *)sglist;
+	sgt->nents = sglen;
+	sgt->orig_nents = sglen;
+
+	da = iommu_vmap(isp->iommu, 0, sgt, IOMMU_FLAG);
+	if (IS_ERR_VALUE(da))
+		kfree(sgt);
+
+	return da;
+}
+
+/*
+ * ispmmu_vunmap - Unmap a device address from the ISP MMU
+ * @dev: Device pointer specific to the OMAP3 ISP.
+ * @da: Device address generated from a ispmmu_vmap call.
+ */
+static void ispmmu_vunmap(struct isp_device *isp, dma_addr_t da)
+{
+	struct sg_table *sgt;
+
+	sgt = iommu_vunmap(isp->iommu, (u32)da);
+	kfree(sgt);
+}
+
+/* -----------------------------------------------------------------------------
+ * Video queue operations
+ */
+
+static void isp_video_queue_prepare(struct isp_video_queue *queue,
+				    unsigned int *nbuffers, unsigned int *size)
+{
+	struct isp_video_fh *vfh =
+		container_of(queue, struct isp_video_fh, queue);
+	struct isp_video *video = vfh->video;
+
+	*size = vfh->format.fmt.pix.sizeimage;
+	if (*size == 0)
+		return;
+
+	*nbuffers = min(*nbuffers, video->capture_mem / PAGE_ALIGN(*size));
+}
+
+static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
+{
+	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
+	struct isp_buffer *buffer = to_isp_buffer(buf);
+	struct isp_video *video = vfh->video;
+
+	if (buffer->isp_addr) {
+		ispmmu_vunmap(video->isp, buffer->isp_addr);
+		buffer->isp_addr = 0;
+	}
+}
+
+static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
+{
+	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
+	struct isp_buffer *buffer = to_isp_buffer(buf);
+	struct isp_video *video = vfh->video;
+	unsigned long addr;
+
+	addr = ispmmu_vmap(video->isp, buf->sglist, buf->sglen);
+	if (IS_ERR_VALUE(addr))
+		return -EIO;
+
+	if (!IS_ALIGNED(addr, 32)) {
+		dev_dbg(video->isp->dev, "Buffer address must be "
+			"aligned to 32 bytes boundary.\n");
+		ispmmu_vunmap(video->isp, buffer->isp_addr);
+		return -EINVAL;
+	}
+
+	buf->vbuf.bytesused = vfh->format.fmt.pix.sizeimage;
+	buffer->isp_addr = addr;
+	return 0;
+}
+
+/*
+ * isp_video_buffer_queue - Add buffer to streaming queue
+ * @buf: Video buffer
+ *
+ * In memory-to-memory mode, start streaming on the pipeline if buffers are
+ * queued on both the input and the output, if the pipeline isn't already busy.
+ * If the pipeline is busy, it will be restarted in the output module interrupt
+ * handler.
+ */
+static void isp_video_buffer_queue(struct isp_video_buffer *buf)
+{
+	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
+	struct isp_buffer *buffer = to_isp_buffer(buf);
+	struct isp_video *video = vfh->video;
+	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
+	enum isp_pipeline_state state;
+	unsigned long flags;
+	unsigned int empty;
+	unsigned int start;
+
+	empty = list_empty(&video->dmaqueue);
+	list_add_tail(&buffer->buffer.irqlist, &video->dmaqueue);
+
+	if (empty) {
+		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			state = ISP_PIPELINE_QUEUE_OUTPUT;
+		else
+			state = ISP_PIPELINE_QUEUE_INPUT;
+
+		spin_lock_irqsave(&pipe->lock, flags);
+		pipe->state |= state;
+		video->ops->queue(video, buffer);
+		video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_QUEUED;
+
+		start = isp_pipeline_ready(pipe);
+		if (start)
+			pipe->state |= ISP_PIPELINE_STREAM;
+		spin_unlock_irqrestore(&pipe->lock, flags);
+
+		if (start)
+			omap3isp_pipeline_set_stream(pipe,
+						ISP_PIPELINE_STREAM_SINGLESHOT);
+	}
+}
+
+static const struct isp_video_queue_operations isp_video_queue_ops = {
+	.queue_prepare = &isp_video_queue_prepare,
+	.buffer_prepare = &isp_video_buffer_prepare,
+	.buffer_queue = &isp_video_buffer_queue,
+	.buffer_cleanup = &isp_video_buffer_cleanup,
+};
+
+/*
+ * omap3isp_video_buffer_next - Complete the current buffer and return the next
+ * @video: ISP video object
+ * @error: Whether an error occured during capture
+ *
+ * Remove the current video buffer from the DMA queue and fill its timestamp,
+ * field count and state fields before waking up its completion handler.
+ *
+ * The buffer state is set to VIDEOBUF_DONE if no error occured (@error is 0)
+ * or VIDEOBUF_ERROR otherwise (@error is non-zero).
+ *
+ * The DMA queue is expected to contain at least one buffer.
+ *
+ * Return a pointer to the next buffer in the DMA queue, or NULL if the queue is
+ * empty.
+ */
+struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video,
+					      unsigned int error)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
+	struct isp_video_queue *queue = video->queue;
+	enum isp_pipeline_state state;
+	struct isp_video_buffer *buf;
+	unsigned long flags;
+	struct timespec ts;
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+	if (WARN_ON(list_empty(&video->dmaqueue))) {
+		spin_unlock_irqrestore(&queue->irqlock, flags);
+		return NULL;
+	}
+
+	buf = list_first_entry(&video->dmaqueue, struct isp_video_buffer,
+			       irqlist);
+	list_del(&buf->irqlist);
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+
+	ktime_get_ts(&ts);
+	buf->vbuf.timestamp.tv_sec = ts.tv_sec;
+	buf->vbuf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+
+	/* Do frame number propagation only if this is the output video node.
+	 * Frame number either comes from the CSI receivers or it gets
+	 * incremented here if H3A is not active.
+	 * Note: There is no guarantee that the output buffer will finish
+	 * first, so the input number might lag behind by 1 in some cases.
+	 */
+	if (video == pipe->output && !pipe->do_propagation)
+		buf->vbuf.sequence = atomic_inc_return(&pipe->frame_number);
+	else
+		buf->vbuf.sequence = atomic_read(&pipe->frame_number);
+
+	buf->state = error ? ISP_BUF_STATE_ERROR : ISP_BUF_STATE_DONE;
+
+	wake_up(&buf->wait);
+
+	if (list_empty(&video->dmaqueue)) {
+		if (queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			state = ISP_PIPELINE_QUEUE_OUTPUT
+			      | ISP_PIPELINE_STREAM;
+		else
+			state = ISP_PIPELINE_QUEUE_INPUT
+			      | ISP_PIPELINE_STREAM;
+
+		spin_lock_irqsave(&pipe->lock, flags);
+		pipe->state &= ~state;
+		if (video->pipe.stream_state == ISP_PIPELINE_STREAM_CONTINUOUS)
+			video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_UNDERRUN;
+		spin_unlock_irqrestore(&pipe->lock, flags);
+		return NULL;
+	}
+
+	if (queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->input != NULL) {
+		spin_lock_irqsave(&pipe->lock, flags);
+		pipe->state &= ~ISP_PIPELINE_STREAM;
+		spin_unlock_irqrestore(&pipe->lock, flags);
+	}
+
+	buf = list_first_entry(&video->dmaqueue, struct isp_video_buffer,
+			       irqlist);
+	buf->state = ISP_BUF_STATE_ACTIVE;
+	return to_isp_buffer(buf);
+}
+
+/*
+ * omap3isp_video_resume - Perform resume operation on the buffers
+ * @video: ISP video object
+ * @continuous: Pipeline is in single shot mode if 0 or continous mode otherwise
+ *
+ * This function is intended to be used on suspend/resume scenario. It
+ * requests video queue layer to discard buffers marked as DONE if it's in
+ * continuous mode and requests ISP modules to queue again the ACTIVE buffer
+ * if there's any.
+ */
+void omap3isp_video_resume(struct isp_video *video, int continuous)
+{
+	struct isp_buffer *buf = NULL;
+
+	if (continuous && video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		omap3isp_video_queue_discard_done(video->queue);
+
+	if (!list_empty(&video->dmaqueue)) {
+		buf = list_first_entry(&video->dmaqueue,
+				       struct isp_buffer, buffer.irqlist);
+		video->ops->queue(video, buf);
+		video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_QUEUED;
+	} else {
+		if (continuous)
+			video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_UNDERRUN;
+	}
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 ioctls
+ */
+
+static int
+isp_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
+{
+	struct isp_video *video = video_drvdata(file);
+
+	strlcpy(cap->driver, ISP_VIDEO_DRIVER_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, video->video.name, sizeof(cap->card));
+	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
+	cap->version = ISP_VIDEO_DRIVER_VERSION;
+
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	else
+		cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int
+isp_video_get_format(struct file *file, void *fh, struct v4l2_format *format)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+	struct isp_video *video = video_drvdata(file);
+
+	if (format->type != video->type)
+		return -EINVAL;
+
+	mutex_lock(&video->mutex);
+	*format = vfh->format;
+	mutex_unlock(&video->mutex);
+
+	return 0;
+}
+
+static int
+isp_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+	struct isp_video *video = video_drvdata(file);
+	struct v4l2_mbus_framefmt fmt;
+
+	if (format->type != video->type)
+		return -EINVAL;
+
+	mutex_lock(&video->mutex);
+
+	/* Fill the bytesperline and sizeimage fields by converting to media bus
+	 * format and back to pixel format.
+	 */
+	isp_video_pix_to_mbus(&format->fmt.pix, &fmt);
+	isp_video_mbus_to_pix(video, &fmt, &format->fmt.pix);
+
+	vfh->format = *format;
+
+	mutex_unlock(&video->mutex);
+	return 0;
+}
+
+static int
+isp_video_try_format(struct file *file, void *fh, struct v4l2_format *format)
+{
+	struct isp_video *video = video_drvdata(file);
+	struct v4l2_subdev_format fmt;
+	struct v4l2_subdev *subdev;
+	u32 pad;
+	int ret;
+
+	if (format->type != video->type)
+		return -EINVAL;
+
+	subdev = isp_video_remote_subdev(video, &pad);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	isp_video_pix_to_mbus(&format->fmt.pix, &fmt.format);
+
+	fmt.pad = pad;
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
+	if (ret)
+		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+
+	isp_video_mbus_to_pix(video, &fmt.format, &format->fmt.pix);
+	return 0;
+}
+
+static int
+isp_video_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cropcap)
+{
+	struct isp_video *video = video_drvdata(file);
+	struct v4l2_subdev *subdev;
+	int ret;
+
+	subdev = isp_video_remote_subdev(video, NULL);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	mutex_lock(&video->mutex);
+	ret = v4l2_subdev_call(subdev, video, cropcap, cropcap);
+	mutex_unlock(&video->mutex);
+
+	return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+}
+
+static int
+isp_video_get_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+{
+	struct isp_video *video = video_drvdata(file);
+	struct v4l2_subdev_format format;
+	struct v4l2_subdev *subdev;
+	u32 pad;
+	int ret;
+
+	subdev = isp_video_remote_subdev(video, &pad);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	/* Try the get crop operation first and fallback to get format if not
+	 * implemented.
+	 */
+	ret = v4l2_subdev_call(subdev, video, g_crop, crop);
+	if (ret != -ENOIOCTLCMD)
+		return ret;
+
+	format.pad = pad;
+	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &format);
+	if (ret < 0)
+		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+
+	crop->c.left = 0;
+	crop->c.top = 0;
+	crop->c.width = format.format.width;
+	crop->c.height = format.format.height;
+
+	return 0;
+}
+
+static int
+isp_video_set_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+{
+	struct isp_video *video = video_drvdata(file);
+	struct v4l2_subdev *subdev;
+	int ret;
+
+	subdev = isp_video_remote_subdev(video, NULL);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	mutex_lock(&video->mutex);
+	ret = v4l2_subdev_call(subdev, video, s_crop, crop);
+	mutex_unlock(&video->mutex);
+
+	return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+}
+
+static int
+isp_video_get_param(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+	struct isp_video *video = video_drvdata(file);
+
+	if (video->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
+	    video->type != a->type)
+		return -EINVAL;
+
+	memset(a, 0, sizeof(*a));
+	a->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	a->parm.output.capability = V4L2_CAP_TIMEPERFRAME;
+	a->parm.output.timeperframe = vfh->timeperframe;
+
+	return 0;
+}
+
+static int
+isp_video_set_param(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+	struct isp_video *video = video_drvdata(file);
+
+	if (video->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
+	    video->type != a->type)
+		return -EINVAL;
+
+	if (a->parm.output.timeperframe.denominator == 0)
+		a->parm.output.timeperframe.denominator = 1;
+
+	vfh->timeperframe = a->parm.output.timeperframe;
+
+	return 0;
+}
+
+static int
+isp_video_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *rb)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+
+	return omap3isp_video_queue_reqbufs(&vfh->queue, rb);
+}
+
+static int
+isp_video_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+
+	return omap3isp_video_queue_querybuf(&vfh->queue, b);
+}
+
+static int
+isp_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+
+	return omap3isp_video_queue_qbuf(&vfh->queue, b);
+}
+
+static int
+isp_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+
+	return omap3isp_video_queue_dqbuf(&vfh->queue, b,
+					  file->f_flags & O_NONBLOCK);
+}
+
+/*
+ * Stream management
+ *
+ * Every ISP pipeline has a single input and a single output. The input can be
+ * either a sensor or a video node. The output is always a video node.
+ *
+ * As every pipeline has an output video node, the ISP video objects at the
+ * pipeline output stores the pipeline state. It tracks the streaming state of
+ * both the input and output, as well as the availability of buffers.
+ *
+ * In sensor-to-memory mode, frames are always available at the pipeline input.
+ * Starting the sensor usually requires I2C transfers and must be done in
+ * interruptible context. The pipeline is started and stopped synchronously
+ * to the stream on/off commands. All modules in the pipeline will get their
+ * subdev set stream handler called. The module at the end of the pipeline must
+ * delay starting the hardware until buffers are available at its output.
+ *
+ * In memory-to-memory mode, starting/stopping the stream requires
+ * synchronization between the input and output. ISP modules can't be stopped
+ * in the middle of a frame, and at least some of the modules seem to become
+ * busy as soon as they're started, even if they don't receive a frame start
+ * event. For that reason frames need to be processed in single-shot mode. The
+ * driver needs to wait until a frame is completely processed and written to
+ * memory before restarting the pipeline for the next frame. Pipelined
+ * processing might be possible but requires more testing.
+ *
+ * Stream start must be delayed until buffers are available at both the input
+ * and output. The pipeline must be started in the videobuf queue callback with
+ * the buffers queue spinlock held. The modules subdev set stream operation must
+ * not sleep.
+ */
+static int
+isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+	struct isp_video *video = video_drvdata(file);
+	enum isp_pipeline_state state;
+	struct isp_pipeline *pipe;
+	struct isp_video *far_end;
+	unsigned long flags;
+	int ret;
+
+	if (type != video->type)
+		return -EINVAL;
+
+	mutex_lock(&video->stream_lock);
+
+	if (video->streaming) {
+		mutex_unlock(&video->stream_lock);
+		return -EBUSY;
+	}
+
+	/* Start streaming on the pipeline. No link touching an entity in the
+	 * pipeline can be activated or deactivated once streaming is started.
+	 */
+	pipe = video->video.entity.pipe
+	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
+	media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
+
+	/* Verify that the currently configured format matches the output of
+	 * the connected subdev.
+	 */
+	ret = isp_video_check_format(video, vfh);
+	if (ret < 0)
+		goto error;
+
+	video->bpl_padding = ret;
+	video->bpl_value = vfh->format.fmt.pix.bytesperline;
+
+	/* Find the ISP video node connected at the far end of the pipeline and
+	 * update the pipeline.
+	 */
+	far_end = isp_video_far_end(video);
+
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		state = ISP_PIPELINE_STREAM_OUTPUT | ISP_PIPELINE_IDLE_OUTPUT;
+		pipe->input = far_end;
+		pipe->output = video;
+	} else {
+		if (far_end == NULL) {
+			ret = -EPIPE;
+			goto error;
+		}
+
+		state = ISP_PIPELINE_STREAM_INPUT | ISP_PIPELINE_IDLE_INPUT;
+		pipe->input = video;
+		pipe->output = far_end;
+	}
+
+	/* Make sure the interconnect clock runs fast enough.
+	 *
+	 * Formula from: resource34xx.c set_opp()
+	 * If MPU freq is above 500MHz, make sure the interconnect
+	 * is at 100Mhz or above.
+	 * throughput in KiB/s for 100 Mhz = 100 * 1000 * 4.
+	 *
+	 * We want to be fast enough then set OCP clock to be max as
+	 * possible, in that case 185Mhz then:
+	 * throughput in KiB/s for 185Mhz = 185 * 1000 * 4 = 740000 KiB/s
+	 */
+	omap_pm_set_min_bus_tput(video->isp->dev, OCP_INITIATOR_AGENT, 740000);
+	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
+
+	/* Validate the pipeline and update its state. */
+	ret = isp_video_validate_pipeline(pipe);
+	if (ret < 0)
+		goto error;
+
+	spin_lock_irqsave(&pipe->lock, flags);
+	pipe->state &= ~ISP_PIPELINE_STREAM;
+	pipe->state |= state;
+	spin_unlock_irqrestore(&pipe->lock, flags);
+
+	/* Set the maximum time per frame as the value requested by userspace.
+	 * This is a soft limit that can be overridden if the hardware doesn't
+	 * support the request limit.
+	 */
+	if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		pipe->max_timeperframe = vfh->timeperframe;
+
+	video->queue = &vfh->queue;
+	INIT_LIST_HEAD(&video->dmaqueue);
+	atomic_set(&pipe->frame_number, -1);
+
+	ret = omap3isp_video_queue_streamon(&vfh->queue);
+	if (ret < 0)
+		goto error;
+
+	/* In sensor-to-memory mode, the stream can be started synchronously
+	 * to the stream on command. In memory-to-memory mode, it will be
+	 * started when buffers are queued on both the input and output.
+	 */
+	if (pipe->input == NULL) {
+		ret = omap3isp_pipeline_set_stream(pipe,
+					      ISP_PIPELINE_STREAM_CONTINUOUS);
+		if (ret < 0)
+			goto error;
+		spin_lock_irqsave(&video->queue->irqlock, flags);
+		if (list_empty(&video->dmaqueue))
+			video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_UNDERRUN;
+		spin_unlock_irqrestore(&video->queue->irqlock, flags);
+	}
+
+error:
+	if (ret < 0) {
+		omap3isp_video_queue_streamoff(&vfh->queue);
+		omap_pm_set_min_bus_tput(video->isp->dev,
+					 OCP_INITIATOR_AGENT, 0);
+		media_entity_pipeline_stop(&video->video.entity);
+		video->queue = NULL;
+	}
+
+	if (!ret)
+		video->streaming = 1;
+
+	mutex_unlock(&video->stream_lock);
+	return ret;
+}
+
+static int
+isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+	struct isp_video *video = video_drvdata(file);
+	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
+	enum isp_pipeline_state state;
+	unsigned int streaming;
+	unsigned long flags;
+
+	if (type != video->type)
+		return -EINVAL;
+
+	mutex_lock(&video->stream_lock);
+
+	/* Make sure we're not streaming yet. */
+	mutex_lock(&vfh->queue.lock);
+	streaming = vfh->queue.streaming;
+	mutex_unlock(&vfh->queue.lock);
+
+	if (!streaming)
+		goto done;
+
+	/* Update the pipeline state. */
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		state = ISP_PIPELINE_STREAM_OUTPUT
+		      | ISP_PIPELINE_QUEUE_OUTPUT;
+	else
+		state = ISP_PIPELINE_STREAM_INPUT
+		      | ISP_PIPELINE_QUEUE_INPUT;
+
+	spin_lock_irqsave(&pipe->lock, flags);
+	pipe->state &= ~state;
+	spin_unlock_irqrestore(&pipe->lock, flags);
+
+	/* Stop the stream. */
+	omap3isp_pipeline_set_stream(pipe, ISP_PIPELINE_STREAM_STOPPED);
+	omap3isp_video_queue_streamoff(&vfh->queue);
+	video->queue = NULL;
+	video->streaming = 0;
+
+	omap_pm_set_min_bus_tput(video->isp->dev, OCP_INITIATOR_AGENT, 0);
+	media_entity_pipeline_stop(&video->video.entity);
+
+done:
+	mutex_unlock(&video->stream_lock);
+	return 0;
+}
+
+static int
+isp_video_enum_input(struct file *file, void *fh, struct v4l2_input *input)
+{
+	if (input->index > 0)
+		return -EINVAL;
+
+	strlcpy(input->name, "camera", sizeof(input->name));
+	input->type = V4L2_INPUT_TYPE_CAMERA;
+
+	return 0;
+}
+
+static int
+isp_video_g_input(struct file *file, void *fh, unsigned int *input)
+{
+	*input = 0;
+
+	return 0;
+}
+
+static int
+isp_video_s_input(struct file *file, void *fh, unsigned int input)
+{
+	return input == 0 ? 0 : -EINVAL;
+}
+
+static const struct v4l2_ioctl_ops isp_video_ioctl_ops = {
+	.vidioc_querycap		= isp_video_querycap,
+	.vidioc_g_fmt_vid_cap		= isp_video_get_format,
+	.vidioc_s_fmt_vid_cap		= isp_video_set_format,
+	.vidioc_try_fmt_vid_cap		= isp_video_try_format,
+	.vidioc_g_fmt_vid_out		= isp_video_get_format,
+	.vidioc_s_fmt_vid_out		= isp_video_set_format,
+	.vidioc_try_fmt_vid_out		= isp_video_try_format,
+	.vidioc_cropcap			= isp_video_cropcap,
+	.vidioc_g_crop			= isp_video_get_crop,
+	.vidioc_s_crop			= isp_video_set_crop,
+	.vidioc_g_parm			= isp_video_get_param,
+	.vidioc_s_parm			= isp_video_set_param,
+	.vidioc_reqbufs			= isp_video_reqbufs,
+	.vidioc_querybuf		= isp_video_querybuf,
+	.vidioc_qbuf			= isp_video_qbuf,
+	.vidioc_dqbuf			= isp_video_dqbuf,
+	.vidioc_streamon		= isp_video_streamon,
+	.vidioc_streamoff		= isp_video_streamoff,
+	.vidioc_enum_input		= isp_video_enum_input,
+	.vidioc_g_input			= isp_video_g_input,
+	.vidioc_s_input			= isp_video_s_input,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 file operations
+ */
+
+static int isp_video_open(struct file *file)
+{
+	struct isp_video *video = video_drvdata(file);
+	struct isp_video_fh *handle;
+	int ret = 0;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (handle == NULL)
+		return -ENOMEM;
+
+	v4l2_fh_init(&handle->vfh, &video->video);
+	v4l2_fh_add(&handle->vfh);
+
+	/* If this is the first user, initialise the pipeline. */
+	if (omap3isp_get(video->isp) == NULL) {
+		ret = -EBUSY;
+		goto done;
+	}
+
+	ret = omap3isp_pipeline_pm_use(&video->video.entity, 1);
+	if (ret < 0) {
+		omap3isp_put(video->isp);
+		goto done;
+	}
+
+	omap3isp_video_queue_init(&handle->queue, video->type,
+				  &isp_video_queue_ops, video->isp->dev,
+				  sizeof(struct isp_buffer));
+
+	memset(&handle->format, 0, sizeof(handle->format));
+	handle->format.type = video->type;
+	handle->timeperframe.denominator = 1;
+
+	handle->video = video;
+	file->private_data = &handle->vfh;
+
+done:
+	if (ret < 0) {
+		v4l2_fh_del(&handle->vfh);
+		kfree(handle);
+	}
+
+	return ret;
+}
+
+static int isp_video_release(struct file *file)
+{
+	struct isp_video *video = video_drvdata(file);
+	struct v4l2_fh *vfh = file->private_data;
+	struct isp_video_fh *handle = to_isp_video_fh(vfh);
+
+	/* Disable streaming and free the buffers queue resources. */
+	isp_video_streamoff(file, vfh, video->type);
+
+	mutex_lock(&handle->queue.lock);
+	omap3isp_video_queue_cleanup(&handle->queue);
+	mutex_unlock(&handle->queue.lock);
+
+	omap3isp_pipeline_pm_use(&video->video.entity, 0);
+
+	/* Release the file handle. */
+	v4l2_fh_del(vfh);
+	kfree(handle);
+	file->private_data = NULL;
+
+	omap3isp_put(video->isp);
+
+	return 0;
+}
+
+static unsigned int isp_video_poll(struct file *file, poll_table *wait)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(file->private_data);
+	struct isp_video_queue *queue = &vfh->queue;
+
+	return omap3isp_video_queue_poll(queue, file, wait);
+}
+
+static int isp_video_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(file->private_data);
+
+	return omap3isp_video_queue_mmap(&vfh->queue, vma);
+}
+
+static struct v4l2_file_operations isp_video_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = video_ioctl2,
+	.open = isp_video_open,
+	.release = isp_video_release,
+	.poll = isp_video_poll,
+	.mmap = isp_video_mmap,
+};
+
+/* -----------------------------------------------------------------------------
+ * ISP video core
+ */
+
+static const struct isp_video_operations isp_video_dummy_ops = {
+};
+
+int omap3isp_video_init(struct isp_video *video, const char *name)
+{
+	const char *direction;
+	int ret;
+
+	switch (video->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		direction = "output";
+		video->pad.flags = MEDIA_PAD_FL_SINK;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		direction = "input";
+		video->pad.flags = MEDIA_PAD_FL_SOURCE;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	ret = media_entity_init(&video->video.entity, 1, &video->pad, 0);
+	if (ret < 0)
+		return ret;
+
+	mutex_init(&video->mutex);
+	atomic_set(&video->active, 0);
+
+	spin_lock_init(&video->pipe.lock);
+	mutex_init(&video->stream_lock);
+
+	/* Initialize the video device. */
+	if (video->ops == NULL)
+		video->ops = &isp_video_dummy_ops;
+
+	video->video.fops = &isp_video_fops;
+	snprintf(video->video.name, sizeof(video->video.name),
+		 "OMAP3 ISP %s %s", name, direction);
+	video->video.vfl_type = VFL_TYPE_GRABBER;
+	video->video.release = video_device_release_empty;
+	video->video.ioctl_ops = &isp_video_ioctl_ops;
+	video->pipe.stream_state = ISP_PIPELINE_STREAM_STOPPED;
+
+	video_set_drvdata(&video->video, video);
+
+	return 0;
+}
+
+int omap3isp_video_register(struct isp_video *video, struct v4l2_device *vdev)
+{
+	int ret;
+
+	video->video.v4l2_dev = vdev;
+
+	ret = video_register_device(&video->video, VFL_TYPE_GRABBER, -1);
+	if (ret < 0)
+		printk(KERN_ERR "%s: could not register video device (%d)\n",
+			__func__, ret);
+
+	return ret;
+}
+
+void omap3isp_video_unregister(struct isp_video *video)
+{
+	if (video_is_registered(&video->video)) {
+		media_entity_cleanup(&video->video.entity);
+		video_unregister_device(&video->video);
+	}
+}
diff --git a/drivers/media/video/omap3-isp/ispvideo.h b/drivers/media/video/omap3-isp/ispvideo.h
new file mode 100644
index 0000000..e15cdd8
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispvideo.h
@@ -0,0 +1,202 @@
+/*
+ * ispvideo.h
+ *
+ * TI OMAP3 ISP - Generic video node
+ *
+ * Copyright (C) 2009-2010 Nokia Corporation
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef OMAP3_ISP_VIDEO_H
+#define OMAP3_ISP_VIDEO_H
+
+#include <linux/v4l2-mediabus.h>
+#include <linux/version.h>
+#include <media/media-entity.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
+
+#include "ispqueue.h"
+
+#define ISP_VIDEO_DRIVER_NAME		"ispvideo"
+#define ISP_VIDEO_DRIVER_VERSION	KERNEL_VERSION(0, 0, 1)
+
+struct isp_device;
+struct isp_video;
+struct v4l2_mbus_framefmt;
+struct v4l2_pix_format;
+
+/*
+ * struct isp_format_info - ISP media bus format information
+ * @code: V4L2 media bus format code
+ * @truncated: V4L2 media bus format code for the same format truncated to 10
+ * 	bits. Identical to @code if the format is 10 bits wide or less.
+ * @uncompressed: V4L2 media bus format code for the corresponding uncompressed
+ * 	format. Identical to @code if the format is not DPCM compressed.
+ * @pixelformat: V4L2 pixel format FCC identifier
+ * @bpp: Bits per pixel
+ */
+struct isp_format_info {
+	enum v4l2_mbus_pixelcode code;
+	enum v4l2_mbus_pixelcode truncated;
+	enum v4l2_mbus_pixelcode uncompressed;
+	u32 pixelformat;
+	unsigned int bpp;
+};
+
+enum isp_pipeline_stream_state {
+	ISP_PIPELINE_STREAM_STOPPED = 0,
+	ISP_PIPELINE_STREAM_CONTINUOUS = 1,
+	ISP_PIPELINE_STREAM_SINGLESHOT = 2,
+};
+
+enum isp_pipeline_state {
+	/* The stream has been started on the input video node. */
+	ISP_PIPELINE_STREAM_INPUT = 1,
+	/* The stream has been started on the output video node. */
+	ISP_PIPELINE_STREAM_OUTPUT = 2,
+	/* At least one buffer is queued on the input video node. */
+	ISP_PIPELINE_QUEUE_INPUT = 4,
+	/* At least one buffer is queued on the output video node. */
+	ISP_PIPELINE_QUEUE_OUTPUT = 8,
+	/* The input entity is idle, ready to be started. */
+	ISP_PIPELINE_IDLE_INPUT = 16,
+	/* The output entity is idle, ready to be started. */
+	ISP_PIPELINE_IDLE_OUTPUT = 32,
+	/* The pipeline is currently streaming. */
+	ISP_PIPELINE_STREAM = 64,
+};
+
+struct isp_pipeline {
+	struct media_pipeline pipe;
+	spinlock_t lock;
+	unsigned int state;
+	enum isp_pipeline_stream_state stream_state;
+	struct isp_video *input;
+	struct isp_video *output;
+	unsigned long l3_ick;
+	unsigned int max_rate;
+	atomic_t frame_number;
+	bool do_propagation; /* of frame number */
+	struct v4l2_fract max_timeperframe;
+};
+
+#define to_isp_pipeline(__e) \
+	container_of((__e)->pipe, struct isp_pipeline, pipe)
+
+static inline int isp_pipeline_ready(struct isp_pipeline *pipe)
+{
+	return pipe->state == (ISP_PIPELINE_STREAM_INPUT |
+			       ISP_PIPELINE_STREAM_OUTPUT |
+			       ISP_PIPELINE_QUEUE_INPUT |
+			       ISP_PIPELINE_QUEUE_OUTPUT |
+			       ISP_PIPELINE_IDLE_INPUT |
+			       ISP_PIPELINE_IDLE_OUTPUT);
+}
+
+/*
+ * struct isp_buffer - ISP buffer
+ * @buffer: ISP video buffer
+ * @isp_addr: MMU mapped address (a.k.a. device address) of the buffer.
+ */
+struct isp_buffer {
+	struct isp_video_buffer buffer;
+	dma_addr_t isp_addr;
+};
+
+#define to_isp_buffer(buf)	container_of(buf, struct isp_buffer, buffer)
+
+enum isp_video_dmaqueue_flags {
+	/* Set if DMA queue becomes empty when ISP_PIPELINE_STREAM_CONTINUOUS */
+	ISP_VIDEO_DMAQUEUE_UNDERRUN = (1 << 0),
+	/* Set when queuing buffer to an empty DMA queue */
+	ISP_VIDEO_DMAQUEUE_QUEUED = (1 << 1),
+};
+
+#define isp_video_dmaqueue_flags_clr(video)	\
+			({ (video)->dmaqueue_flags = 0; })
+
+/*
+ * struct isp_video_operations - ISP video operations
+ * @queue:	Resume streaming when a buffer is queued. Called on VIDIOC_QBUF
+ *		if there was no buffer previously queued.
+ */
+struct isp_video_operations {
+	int(*queue)(struct isp_video *video, struct isp_buffer *buffer);
+};
+
+struct isp_video {
+	struct video_device video;
+	enum v4l2_buf_type type;
+	struct media_pad pad;
+
+	struct mutex mutex;
+	atomic_t active;
+
+	struct isp_device *isp;
+
+	unsigned int capture_mem;
+	unsigned int bpl_alignment;	/* alignment value */
+	unsigned int bpl_zero_padding;	/* whether the alignment is optional */
+	unsigned int bpl_max;		/* maximum bytes per line value */
+	unsigned int bpl_value;		/* bytes per line value */
+	unsigned int bpl_padding;	/* padding at end of line */
+
+	/* Entity video node streaming */
+	unsigned int streaming:1;
+
+	/* Pipeline state */
+	struct isp_pipeline pipe;
+	struct mutex stream_lock;
+
+	/* Video buffers queue */
+	struct isp_video_queue *queue;
+	struct list_head dmaqueue;
+	enum isp_video_dmaqueue_flags dmaqueue_flags;
+
+	const struct isp_video_operations *ops;
+};
+
+#define to_isp_video(vdev)	container_of(vdev, struct isp_video, video)
+
+struct isp_video_fh {
+	struct v4l2_fh vfh;
+	struct isp_video *video;
+	struct isp_video_queue queue;
+	struct v4l2_format format;
+	struct v4l2_fract timeperframe;
+};
+
+#define to_isp_video_fh(fh)	container_of(fh, struct isp_video_fh, vfh)
+#define isp_video_queue_to_isp_video_fh(q) \
+				container_of(q, struct isp_video_fh, queue)
+
+int omap3isp_video_init(struct isp_video *video, const char *name);
+int omap3isp_video_register(struct isp_video *video,
+			    struct v4l2_device *vdev);
+void omap3isp_video_unregister(struct isp_video *video);
+struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video,
+					      unsigned int error);
+void omap3isp_video_resume(struct isp_video *video, int continuous);
+struct media_pad *omap3isp_video_remote_pad(struct isp_video *video);
+
+const struct isp_format_info *
+omap3isp_video_format_info(enum v4l2_mbus_pixelcode code);
+
+#endif /* OMAP3_ISP_VIDEO_H */
-- 
1.7.3.4

