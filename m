Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38683 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaDUM3X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 25/26] omap3isp: Move to videobuf2
Date: Mon, 21 Apr 2014 14:29:11 +0200
Message-Id: <1398083352-8451-26-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the custom buffers queue implementation with a videobuf2 queue.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/Makefile   |    2 +-
 drivers/media/platform/omap3isp/ispqueue.c | 1031 ----------------------------
 drivers/media/platform/omap3isp/ispqueue.h |  171 -----
 drivers/media/platform/omap3isp/ispvideo.c |  167 +++--
 drivers/media/platform/omap3isp/ispvideo.h |   23 +-
 drivers/staging/media/omap4iss/iss_video.c |    2 +-
 6 files changed, 109 insertions(+), 1287 deletions(-)
 delete mode 100644 drivers/media/platform/omap3isp/ispqueue.c
 delete mode 100644 drivers/media/platform/omap3isp/ispqueue.h

diff --git a/drivers/media/platform/omap3isp/Makefile b/drivers/media/platform/omap3isp/Makefile
index e8847e7..254975a 100644
--- a/drivers/media/platform/omap3isp/Makefile
+++ b/drivers/media/platform/omap3isp/Makefile
@@ -3,7 +3,7 @@
 ccflags-$(CONFIG_VIDEO_OMAP3_DEBUG) += -DDEBUG
 
 omap3-isp-objs += \
-	isp.o ispqueue.o ispvideo.o \
+	isp.o ispvideo.o \
 	ispcsiphy.o ispccp2.o ispcsi2.o \
 	ispccdc.o isppreview.o ispresizer.o \
 	ispstat.o isph3a_aewb.o isph3a_af.o isphist.o
diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
deleted file mode 100644
index 77afb63..0000000
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ /dev/null
@@ -1,1031 +0,0 @@
-/*
- * ispqueue.c
- *
- * TI OMAP3 ISP - Video buffers queue handling
- *
- * Copyright (C) 2010 Nokia Corporation
- *
- * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *	     Sakari Ailus <sakari.ailus@iki.fi>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-
-#include <asm/cacheflush.h>
-#include <linux/dma-mapping.h>
-#include <linux/mm.h>
-#include <linux/pagemap.h>
-#include <linux/poll.h>
-#include <linux/scatterlist.h>
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-
-#include "isp.h"
-#include "ispqueue.h"
-#include "ispvideo.h"
-
-/* -----------------------------------------------------------------------------
- * Video buffers management
- */
-
-/*
- * isp_video_buffer_cache_sync - Keep the buffers coherent between CPU and ISP
- *
- * The typical operation required here is Cache Invalidation across
- * the (user space) buffer address range. And this _must_ be done
- * at QBUF stage (and *only* at QBUF).
- *
- * We try to use optimal cache invalidation function:
- * - dmac_map_area:
- *    - used when the number of pages are _low_.
- *    - it becomes quite slow as the number of pages increase.
- *       - for 648x492 viewfinder (150 pages) it takes 1.3 ms.
- *       - for 5 Mpix buffer (2491 pages) it takes between 25-50 ms.
- *
- * - flush_cache_all:
- *    - used when the number of pages are _high_.
- *    - time taken in the range of 500-900 us.
- *    - has a higher penalty but, as whole dcache + icache is invalidated
- */
-/*
- * FIXME: dmac_inv_range crashes randomly on the user space buffer
- *        address. Fall back to flush_cache_all for now.
- */
-#define ISP_CACHE_FLUSH_PAGES_MAX       0
-
-static void isp_video_buffer_cache_sync(struct isp_video_buffer *buf)
-{
-	if (buf->skip_cache)
-		return;
-
-	if (buf->vbuf.m.userptr == 0 || buf->npages == 0 ||
-	    buf->npages > ISP_CACHE_FLUSH_PAGES_MAX)
-		flush_cache_all();
-	else {
-		dmac_map_area((void *)buf->vbuf.m.userptr, buf->vbuf.length,
-			      DMA_FROM_DEVICE);
-		outer_inv_range(buf->vbuf.m.userptr,
-				buf->vbuf.m.userptr + buf->vbuf.length);
-	}
-}
-
-/*
- * isp_video_buffer_lock_vma - Prevent VMAs from being unmapped
- *
- * Lock the VMAs underlying the given buffer into memory. This avoids the
- * userspace buffer mapping from being swapped out, making VIPT cache handling
- * easier.
- *
- * Note that the pages will not be freed as the buffers have been locked to
- * memory using by a call to get_user_pages(), but the userspace mapping could
- * still disappear if the VMAs are not locked. This is caused by the memory
- * management code trying to be as lock-less as possible, which results in the
- * userspace mapping manager not finding out that the pages are locked under
- * some conditions.
- */
-static int isp_video_buffer_lock_vma(struct isp_video_buffer *buf, int lock)
-{
-	struct vm_area_struct *vma;
-	unsigned long start;
-	unsigned long end;
-	int ret = 0;
-
-	if (buf->vbuf.memory == V4L2_MEMORY_MMAP)
-		return 0;
-
-	/* We can be called from workqueue context if the current task dies to
-	 * unlock the VMAs. In that case there's no current memory management
-	 * context so unlocking can't be performed, but the VMAs have been or
-	 * are getting destroyed anyway so it doesn't really matter.
-	 */
-	if (!current || !current->mm)
-		return lock ? -EINVAL : 0;
-
-	start = buf->vbuf.m.userptr;
-	end = buf->vbuf.m.userptr + buf->vbuf.length - 1;
-
-	down_write(&current->mm->mmap_sem);
-	spin_lock(&current->mm->page_table_lock);
-
-	do {
-		vma = find_vma(current->mm, start);
-		if (vma == NULL) {
-			ret = -EFAULT;
-			goto out;
-		}
-
-		if (lock)
-			vma->vm_flags |= VM_LOCKED;
-		else
-			vma->vm_flags &= ~VM_LOCKED;
-
-		start = vma->vm_end + 1;
-	} while (vma->vm_end < end);
-
-	if (lock)
-		buf->vm_flags |= VM_LOCKED;
-	else
-		buf->vm_flags &= ~VM_LOCKED;
-
-out:
-	spin_unlock(&current->mm->page_table_lock);
-	up_write(&current->mm->mmap_sem);
-	return ret;
-}
-
-/*
- * isp_video_buffer_cleanup - Release pages for a userspace VMA.
- *
- * Release pages locked by a call isp_video_buffer_prepare_user and free the
- * pages table.
- */
-static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
-{
-	enum dma_data_direction direction;
-	DEFINE_DMA_ATTRS(attrs);
-	unsigned int i;
-
-	if (buf->vbuf.memory == V4L2_MEMORY_USERPTR) {
-		if (buf->skip_cache)
-			dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
-
-		direction = buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE
-			  ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-		dma_unmap_sg_attrs(buf->queue->dev, buf->sgt.sgl,
-				   buf->sgt.orig_nents, direction, &attrs);
-		sg_free_table(&buf->sgt);
-	}
-
-	if (buf->pages != NULL) {
-		isp_video_buffer_lock_vma(buf, 0);
-
-		for (i = 0; i < buf->npages; ++i)
-			page_cache_release(buf->pages[i]);
-
-		vfree(buf->pages);
-		buf->pages = NULL;
-	}
-
-	buf->npages = 0;
-	buf->skip_cache = false;
-}
-
-/*
- * isp_video_buffer_prepare_user - Prepare a userspace buffer.
- *
- * This function creates a scatter list with a 1:1 mapping for a userspace VMA.
- * The number of pages is first computed based on the buffer size, and pages are
- * then retrieved by a call to get_user_pages.
- *
- * Pages are pinned to memory by get_user_pages, making them available for DMA
- * transfers. However, due to memory management optimization, it seems the
- * get_user_pages doesn't guarantee that the pinned pages will not be written
- * to swap and removed from the userspace mapping(s). When this happens, a page
- * fault can be generated when accessing those unmapped pages.
- *
- * If the fault is triggered by a page table walk caused by VIPT cache
- * management operations, the page fault handler might oops if the MM semaphore
- * is held, as it can't handle kernel page faults in that case. To fix that, a
- * fixup entry needs to be added to the cache management code, or the userspace
- * VMA must be locked to avoid removing pages from the userspace mapping in the
- * first place.
- *
- * If the number of pages retrieved is smaller than the number required by the
- * buffer size, the function returns -EFAULT.
- */
-static int isp_video_buffer_prepare_user(struct isp_video_buffer *buf)
-{
-	unsigned int offset;
-	unsigned long data;
-	unsigned int first;
-	unsigned int last;
-	int ret;
-
-	data = buf->vbuf.m.userptr;
-	first = (data & PAGE_MASK) >> PAGE_SHIFT;
-	last = ((data + buf->vbuf.length - 1) & PAGE_MASK) >> PAGE_SHIFT;
-	offset = data & ~PAGE_MASK;
-
-	buf->npages = last - first + 1;
-	buf->pages = vmalloc(buf->npages * sizeof(buf->pages[0]));
-	if (buf->pages == NULL)
-		return -ENOMEM;
-
-	down_read(&current->mm->mmap_sem);
-	ret = get_user_pages(current, current->mm, data & PAGE_MASK,
-			     buf->npages,
-			     buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE, 0,
-			     buf->pages, NULL);
-	up_read(&current->mm->mmap_sem);
-
-	if (ret != buf->npages) {
-		buf->npages = ret < 0 ? 0 : ret;
-		return -EFAULT;
-	}
-
-	ret = isp_video_buffer_lock_vma(buf, 1);
-	if (ret < 0)
-		return ret;
-
-	ret = sg_alloc_table_from_pages(&buf->sgt, buf->pages, buf->npages,
-					offset, buf->vbuf.length, GFP_KERNEL);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-/*
- * isp_video_buffer_prepare_pfnmap - Prepare a VM_PFNMAP userspace buffer
- *
- * Userspace VM_PFNMAP buffers are supported only if they are contiguous in
- * memory and if they span a single VMA. Start by validating the user pointer to
- * make sure it fulfils that condition, and then build a scatter list of
- * physically contiguous pages starting at the buffer memory physical address.
- *
- * Return 0 on success, -EFAULT if the buffer isn't valid or -ENOMEM if memory
- * can't be allocated.
- */
-static int isp_video_buffer_prepare_pfnmap(struct isp_video_buffer *buf)
-{
-	struct vm_area_struct *vma;
-	struct scatterlist *sg;
-	unsigned long prev_pfn;
-	unsigned long this_pfn;
-	unsigned long start;
-	unsigned int offset;
-	unsigned long end;
-	unsigned long pfn;
-	unsigned int i;
-	int ret = 0;
-
-	start = buf->vbuf.m.userptr;
-	end = buf->vbuf.m.userptr + buf->vbuf.length - 1;
-	offset = start & ~PAGE_MASK;
-
-	buf->npages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
-	buf->pages = NULL;
-
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma(current->mm, start);
-	if (vma == NULL || vma->vm_end < end) {
-		ret = -EFAULT;
-		goto unlock;
-	}
-
-	for (prev_pfn = 0; start <= end; start += PAGE_SIZE) {
-		ret = follow_pfn(vma, start, &this_pfn);
-		if (ret < 0)
-			goto unlock;
-
-		if (prev_pfn == 0)
-			pfn = this_pfn;
-		else if (this_pfn != prev_pfn + 1) {
-			ret = -EFAULT;
-			goto unlock;
-		}
-
-		prev_pfn = this_pfn;
-	}
-
-unlock:
-	up_read(&current->mm->mmap_sem);
-	if (ret < 0)
-		return ret;
-
-	ret = sg_alloc_table(&buf->sgt, buf->npages, GFP_KERNEL);
-	if (ret < 0)
-		return ret;
-
-	for (sg = buf->sgt.sgl, i = 0; i < buf->npages; ++i, ++pfn) {
-		sg_set_page(sg, pfn_to_page(pfn), PAGE_SIZE - offset, offset);
-		sg = sg_next(sg);
-		offset = 0;
-	}
-
-	return 0;
-}
-
-/*
- * isp_video_buffer_prepare_vm_flags - Get VMA flags for a userspace address
- *
- * This function locates the VMAs for the buffer's userspace address and checks
- * that their flags match. The only flag that we need to care for at the moment
- * is VM_PFNMAP.
- *
- * The buffer vm_flags field is set to the first VMA flags.
- *
- * Return -EFAULT if no VMA can be found for part of the buffer, or if the VMAs
- * have incompatible flags.
- */
-static int isp_video_buffer_prepare_vm_flags(struct isp_video_buffer *buf)
-{
-	struct vm_area_struct *vma;
-	pgprot_t uninitialized_var(vm_page_prot);
-	unsigned long start;
-	unsigned long end;
-	int ret = -EFAULT;
-
-	start = buf->vbuf.m.userptr;
-	end = buf->vbuf.m.userptr + buf->vbuf.length - 1;
-
-	down_read(&current->mm->mmap_sem);
-
-	do {
-		vma = find_vma(current->mm, start);
-		if (vma == NULL)
-			goto done;
-
-		if (start == buf->vbuf.m.userptr) {
-			buf->vm_flags = vma->vm_flags;
-			vm_page_prot = vma->vm_page_prot;
-		}
-
-		if ((buf->vm_flags ^ vma->vm_flags) & VM_PFNMAP)
-			goto done;
-
-		if (vm_page_prot != vma->vm_page_prot)
-			goto done;
-
-		start = vma->vm_end + 1;
-	} while (vma->vm_end < end);
-
-	/* Skip cache management to enhance performances for non-cached or
-	 * write-combining buffers.
-	 */
-	if (vm_page_prot == pgprot_noncached(vm_page_prot) ||
-	    vm_page_prot == pgprot_writecombine(vm_page_prot))
-		buf->skip_cache = true;
-
-	ret = 0;
-
-done:
-	up_read(&current->mm->mmap_sem);
-	return ret;
-}
-
-/*
- * isp_video_buffer_prepare - Make a buffer ready for operation
- *
- * Preparing a buffer involves:
- *
- * - validating VMAs (userspace buffers only)
- * - locking pages and VMAs into memory (userspace buffers only)
- * - building page and scatter-gather lists (userspace buffers only)
- * - mapping buffers for DMA operation
- * - performing driver-specific preparation
- *
- * The function must be called in userspace context with a valid mm context
- * (this excludes cleanup paths such as sys_close when the userspace process
- * segfaults).
- */
-static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
-{
-	enum dma_data_direction direction;
-	DEFINE_DMA_ATTRS(attrs);
-	int ret;
-
-	switch (buf->vbuf.memory) {
-	case V4L2_MEMORY_MMAP:
-		ret = 0;
-		break;
-
-	case V4L2_MEMORY_USERPTR:
-		ret = isp_video_buffer_prepare_vm_flags(buf);
-		if (ret < 0)
-			return ret;
-
-		if (buf->vm_flags & VM_PFNMAP)
-			ret = isp_video_buffer_prepare_pfnmap(buf);
-		else
-			ret = isp_video_buffer_prepare_user(buf);
-
-		if (ret < 0)
-			goto done;
-
-		if (buf->skip_cache)
-			dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
-
-		direction = buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE
-			  ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-		ret = dma_map_sg_attrs(buf->queue->dev, buf->sgt.sgl,
-				       buf->sgt.orig_nents, direction, &attrs);
-		if (ret <= 0) {
-			ret = -EFAULT;
-			goto done;
-		}
-
-		buf->dma = sg_dma_address(buf->sgt.sgl);
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	if (!IS_ALIGNED(buf->dma, 32)) {
-		dev_dbg(buf->queue->dev,
-			"Buffer address must be aligned to 32 bytes boundary.\n");
-		ret = -EINVAL;
-		goto done;
-	}
-
-	if (buf->queue->ops->buffer_prepare)
-		ret = buf->queue->ops->buffer_prepare(buf);
-
-done:
-	if (ret < 0) {
-		isp_video_buffer_cleanup(buf);
-		return ret;
-	}
-
-	return ret;
-}
-
-/*
- * isp_video_queue_query - Query the status of a given buffer
- *
- * Locking: must be called with the queue lock held.
- */
-static void isp_video_buffer_query(struct isp_video_buffer *buf,
-				   struct v4l2_buffer *vbuf)
-{
-	memcpy(vbuf, &buf->vbuf, sizeof(*vbuf));
-
-	if (buf->vma_use_count)
-		vbuf->flags |= V4L2_BUF_FLAG_MAPPED;
-
-	switch (buf->state) {
-	case ISP_BUF_STATE_ERROR:
-		vbuf->flags |= V4L2_BUF_FLAG_ERROR;
-		/* Fallthrough */
-	case ISP_BUF_STATE_DONE:
-		vbuf->flags |= V4L2_BUF_FLAG_DONE;
-		break;
-	case ISP_BUF_STATE_QUEUED:
-	case ISP_BUF_STATE_ACTIVE:
-		vbuf->flags |= V4L2_BUF_FLAG_QUEUED;
-		break;
-	case ISP_BUF_STATE_IDLE:
-	default:
-		break;
-	}
-}
-
-/*
- * isp_video_buffer_wait - Wait for a buffer to be ready
- *
- * In non-blocking mode, return immediately with 0 if the buffer is ready or
- * -EAGAIN if the buffer is in the QUEUED or ACTIVE state.
- *
- * In blocking mode, wait (interruptibly but with no timeout) on the buffer wait
- * queue using the same condition.
- */
-static int isp_video_buffer_wait(struct isp_video_buffer *buf, int nonblocking)
-{
-	if (nonblocking) {
-		return (buf->state != ISP_BUF_STATE_QUEUED &&
-			buf->state != ISP_BUF_STATE_ACTIVE)
-			? 0 : -EAGAIN;
-	}
-
-	return wait_event_interruptible(buf->wait,
-		buf->state != ISP_BUF_STATE_QUEUED &&
-		buf->state != ISP_BUF_STATE_ACTIVE);
-}
-
-/* -----------------------------------------------------------------------------
- * Queue management
- */
-
-/*
- * isp_video_queue_free - Free video buffers memory
- *
- * Buffers can only be freed if the queue isn't streaming and if no buffer is
- * mapped to userspace. Return -EBUSY if those conditions aren't satisfied.
- *
- * This function must be called with the queue lock held.
- */
-static int isp_video_queue_free(struct isp_video_queue *queue)
-{
-	unsigned int i;
-
-	if (queue->streaming)
-		return -EBUSY;
-
-	for (i = 0; i < queue->count; ++i) {
-		if (queue->buffers[i]->vma_use_count != 0)
-			return -EBUSY;
-	}
-
-	for (i = 0; i < queue->count; ++i) {
-		struct isp_video_buffer *buf = queue->buffers[i];
-
-		isp_video_buffer_cleanup(buf);
-
-		if (buf->vaddr) {
-			dma_free_coherent(queue->dev,
-					  PAGE_ALIGN(buf->vbuf.length),
-					  buf->vaddr, buf->dma);
-			buf->vaddr = NULL;
-		}
-
-		kfree(buf);
-		queue->buffers[i] = NULL;
-	}
-
-	INIT_LIST_HEAD(&queue->queue);
-	queue->count = 0;
-	return 0;
-}
-
-/*
- * isp_video_queue_alloc - Allocate video buffers memory
- *
- * This function must be called with the queue lock held.
- */
-static int isp_video_queue_alloc(struct isp_video_queue *queue,
-				 unsigned int nbuffers,
-				 unsigned int size, enum v4l2_memory memory)
-{
-	struct isp_video_buffer *buf;
-	dma_addr_t dma;
-	unsigned int i;
-	void *mem;
-	int ret;
-
-	/* Start by freeing the buffers. */
-	ret = isp_video_queue_free(queue);
-	if (ret < 0)
-		return ret;
-
-	/* Bail out if no buffers should be allocated. */
-	if (nbuffers == 0)
-		return 0;
-
-	/* Initialize the allocated buffers. */
-	for (i = 0; i < nbuffers; ++i) {
-		buf = kzalloc(queue->bufsize, GFP_KERNEL);
-		if (buf == NULL)
-			break;
-
-		if (memory == V4L2_MEMORY_MMAP) {
-			/* Allocate video buffers memory for mmap mode. Align
-			 * the size to the page size.
-			 */
-			mem = dma_alloc_coherent(queue->dev, PAGE_ALIGN(size),
-						 &dma, GFP_KERNEL);
-			if (mem == NULL) {
-				kfree(buf);
-				break;
-			}
-
-			buf->vbuf.m.offset = i * PAGE_ALIGN(size);
-			buf->vaddr = mem;
-			buf->dma = dma;
-		}
-
-		buf->vbuf.index = i;
-		buf->vbuf.length = size;
-		buf->vbuf.type = queue->type;
-		buf->vbuf.flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-		buf->vbuf.field = V4L2_FIELD_NONE;
-		buf->vbuf.memory = memory;
-
-		buf->queue = queue;
-		init_waitqueue_head(&buf->wait);
-
-		queue->buffers[i] = buf;
-	}
-
-	if (i == 0)
-		return -ENOMEM;
-
-	queue->count = i;
-	return nbuffers;
-}
-
-/**
- * omap3isp_video_queue_cleanup - Clean up the video buffers queue
- * @queue: Video buffers queue
- *
- * Free all allocated resources and clean up the video buffers queue. The queue
- * must not be busy (no ongoing video stream) and buffers must have been
- * unmapped.
- *
- * Return 0 on success or -EBUSY if the queue is busy or buffers haven't been
- * unmapped.
- */
-int omap3isp_video_queue_cleanup(struct isp_video_queue *queue)
-{
-	return isp_video_queue_free(queue);
-}
-
-/**
- * omap3isp_video_queue_init - Initialize the video buffers queue
- * @queue: Video buffers queue
- * @type: V4L2 buffer type (capture or output)
- * @ops: Driver-specific queue operations
- * @dev: Device used for DMA operations
- * @bufsize: Size of the driver-specific buffer structure
- *
- * Initialize the video buffers queue with the supplied parameters.
- *
- * The queue type must be one of V4L2_BUF_TYPE_VIDEO_CAPTURE or
- * V4L2_BUF_TYPE_VIDEO_OUTPUT. Other buffer types are not supported yet.
- *
- * Buffer objects will be allocated using the given buffer size to allow room
- * for driver-specific fields. Driver-specific buffer structures must start
- * with a struct isp_video_buffer field. Drivers with no driver-specific buffer
- * structure must pass the size of the isp_video_buffer structure in the bufsize
- * parameter.
- *
- * Return 0 on success.
- */
-int omap3isp_video_queue_init(struct isp_video_queue *queue,
-			      enum v4l2_buf_type type,
-			      const struct isp_video_queue_operations *ops,
-			      struct device *dev, unsigned int bufsize)
-{
-	INIT_LIST_HEAD(&queue->queue);
-
-	queue->type = type;
-	queue->ops = ops;
-	queue->dev = dev;
-	queue->bufsize = bufsize;
-
-	return 0;
-}
-
-/* -----------------------------------------------------------------------------
- * V4L2 operations
- */
-
-/**
- * omap3isp_video_queue_reqbufs - Allocate video buffers memory
- *
- * This function is intended to be used as a VIDIOC_REQBUFS ioctl handler. It
- * allocated video buffer objects and, for MMAP buffers, buffer memory.
- *
- * If the number of buffers is 0, all buffers are freed and the function returns
- * without performing any allocation.
- *
- * If the number of buffers is not 0, currently allocated buffers (if any) are
- * freed and the requested number of buffers are allocated. Depending on
- * driver-specific requirements and on memory availability, a number of buffer
- * smaller or bigger than requested can be allocated. This isn't considered as
- * an error.
- *
- * Return 0 on success or one of the following error codes:
- *
- * -EINVAL if the buffer type or index are invalid
- * -EBUSY if the queue is busy (streaming or buffers mapped)
- * -ENOMEM if the buffers can't be allocated due to an out-of-memory condition
- */
-int omap3isp_video_queue_reqbufs(struct isp_video_queue *queue,
-				 struct v4l2_requestbuffers *rb)
-{
-	unsigned int nbuffers = rb->count;
-	unsigned int size;
-	int ret;
-
-	if (rb->type != queue->type)
-		return -EINVAL;
-
-	queue->ops->queue_prepare(queue, &nbuffers, &size);
-	if (size == 0)
-		return -EINVAL;
-
-	nbuffers = min_t(unsigned int, nbuffers, ISP_VIDEO_MAX_BUFFERS);
-
-	ret = isp_video_queue_alloc(queue, nbuffers, size, rb->memory);
-	if (ret < 0)
-		return ret;
-
-	rb->count = ret;
-	return 0;
-}
-
-/**
- * omap3isp_video_queue_querybuf - Query the status of a buffer in a queue
- *
- * This function is intended to be used as a VIDIOC_QUERYBUF ioctl handler. It
- * returns the status of a given video buffer.
- *
- * Return 0 on success or -EINVAL if the buffer type or index are invalid.
- */
-int omap3isp_video_queue_querybuf(struct isp_video_queue *queue,
-				  struct v4l2_buffer *vbuf)
-{
-	struct isp_video_buffer *buf;
-
-	if (vbuf->type != queue->type)
-		return -EINVAL;
-
-	if (vbuf->index >= queue->count)
-		return -EINVAL;
-
-	buf = queue->buffers[vbuf->index];
-	isp_video_buffer_query(buf, vbuf);
-
-	return 0;
-}
-
-/**
- * omap3isp_video_queue_qbuf - Queue a buffer
- *
- * This function is intended to be used as a VIDIOC_QBUF ioctl handler.
- *
- * The v4l2_buffer structure passed from userspace is first sanity tested. If
- * sane, the buffer is then processed and added to the main queue and, if the
- * queue is streaming, to the IRQ queue.
- *
- * Before being enqueued, USERPTR buffers are checked for address changes. If
- * the buffer has a different userspace address, the old memory area is unlocked
- * and the new memory area is locked.
- */
-int omap3isp_video_queue_qbuf(struct isp_video_queue *queue,
-			      struct v4l2_buffer *vbuf)
-{
-	struct isp_video_buffer *buf;
-	int ret;
-
-	if (vbuf->type != queue->type)
-		return -EINVAL;
-
-	if (vbuf->index >= queue->count)
-		return -EINVAL;
-
-	buf = queue->buffers[vbuf->index];
-
-	if (vbuf->memory != buf->vbuf.memory)
-		return -EINVAL;
-
-	if (buf->state != ISP_BUF_STATE_IDLE)
-		return -EINVAL;
-
-	if (vbuf->memory == V4L2_MEMORY_USERPTR &&
-	    vbuf->length < buf->vbuf.length)
-		return -EINVAL;
-
-	if (vbuf->memory == V4L2_MEMORY_USERPTR &&
-	    vbuf->m.userptr != buf->vbuf.m.userptr) {
-		isp_video_buffer_cleanup(buf);
-		buf->vbuf.m.userptr = vbuf->m.userptr;
-		buf->prepared = 0;
-	}
-
-	if (!buf->prepared) {
-		ret = isp_video_buffer_prepare(buf);
-		if (ret < 0)
-			return ret;
-		buf->prepared = 1;
-	}
-
-	isp_video_buffer_cache_sync(buf);
-
-	buf->state = ISP_BUF_STATE_QUEUED;
-	list_add_tail(&buf->stream, &queue->queue);
-
-	if (queue->streaming)
-		queue->ops->buffer_queue(buf);
-
-	return 0;
-}
-
-/**
- * omap3isp_video_queue_dqbuf - Dequeue a buffer
- *
- * This function is intended to be used as a VIDIOC_DQBUF ioctl handler.
- *
- * Wait until a buffer is ready to be dequeued, remove it from the queue and
- * copy its information to the v4l2_buffer structure.
- *
- * If the nonblocking argument is not zero and no buffer is ready, return
- * -EAGAIN immediately instead of waiting.
- *
- * If no buffer has been enqueued, or if the requested buffer type doesn't match
- * the queue type, return -EINVAL.
- */
-int omap3isp_video_queue_dqbuf(struct isp_video_queue *queue,
-			       struct v4l2_buffer *vbuf, int nonblocking)
-{
-	struct isp_video_buffer *buf;
-	int ret;
-
-	if (vbuf->type != queue->type)
-		return -EINVAL;
-
-	if (list_empty(&queue->queue))
-		return -EINVAL;
-
-	buf = list_first_entry(&queue->queue, struct isp_video_buffer, stream);
-	ret = isp_video_buffer_wait(buf, nonblocking);
-	if (ret < 0)
-		return ret;
-
-	list_del(&buf->stream);
-
-	isp_video_buffer_query(buf, vbuf);
-	buf->state = ISP_BUF_STATE_IDLE;
-	vbuf->flags &= ~V4L2_BUF_FLAG_QUEUED;
-
-	return 0;
-}
-
-/**
- * omap3isp_video_queue_streamon - Start streaming
- *
- * This function is intended to be used as a VIDIOC_STREAMON ioctl handler. It
- * starts streaming on the queue and calls the buffer_queue operation for all
- * queued buffers.
- *
- * Return 0 on success.
- */
-int omap3isp_video_queue_streamon(struct isp_video_queue *queue)
-{
-	struct isp_video_buffer *buf;
-
-	if (queue->streaming)
-		return 0;
-
-	queue->streaming = 1;
-
-	list_for_each_entry(buf, &queue->queue, stream)
-		queue->ops->buffer_queue(buf);
-
-	return 0;
-}
-
-/**
- * omap3isp_video_queue_streamoff - Stop streaming
- *
- * This function is intended to be used as a VIDIOC_STREAMOFF ioctl handler. It
- * stops streaming on the queue and wakes up all the buffers.
- *
- * Drivers must stop the hardware and synchronize with interrupt handlers and/or
- * delayed works before calling this function to make sure no buffer will be
- * touched by the driver and/or hardware.
- */
-void omap3isp_video_queue_streamoff(struct isp_video_queue *queue)
-{
-	struct isp_video_buffer *buf;
-	unsigned int i;
-
-	if (!queue->streaming)
-		return;
-
-	queue->streaming = 0;
-
-	for (i = 0; i < queue->count; ++i) {
-		buf = queue->buffers[i];
-
-		if (buf->state == ISP_BUF_STATE_ACTIVE)
-			wake_up(&buf->wait);
-
-		buf->state = ISP_BUF_STATE_IDLE;
-	}
-
-	INIT_LIST_HEAD(&queue->queue);
-}
-
-/**
- * omap3isp_video_queue_discard_done - Discard all buffers marked as DONE
- *
- * This function is intended to be used with suspend/resume operations. It
- * discards all 'done' buffers as they would be too old to be requested after
- * resume.
- *
- * Drivers must stop the hardware and synchronize with interrupt handlers and/or
- * delayed works before calling this function to make sure no buffer will be
- * touched by the driver and/or hardware.
- */
-void omap3isp_video_queue_discard_done(struct isp_video_queue *queue)
-{
-	struct isp_video_buffer *buf;
-	unsigned int i;
-
-	if (!queue->streaming)
-		return;
-
-	for (i = 0; i < queue->count; ++i) {
-		buf = queue->buffers[i];
-
-		if (buf->state == ISP_BUF_STATE_DONE)
-			buf->state = ISP_BUF_STATE_ERROR;
-	}
-}
-
-static void isp_video_queue_vm_open(struct vm_area_struct *vma)
-{
-	struct isp_video_buffer *buf = vma->vm_private_data;
-
-	buf->vma_use_count++;
-}
-
-static void isp_video_queue_vm_close(struct vm_area_struct *vma)
-{
-	struct isp_video_buffer *buf = vma->vm_private_data;
-
-	buf->vma_use_count--;
-}
-
-static const struct vm_operations_struct isp_video_queue_vm_ops = {
-	.open = isp_video_queue_vm_open,
-	.close = isp_video_queue_vm_close,
-};
-
-/**
- * omap3isp_video_queue_mmap - Map buffers to userspace
- *
- * This function is intended to be used as an mmap() file operation handler. It
- * maps a buffer to userspace based on the VMA offset.
- *
- * Only buffers of memory type MMAP are supported.
- */
-int omap3isp_video_queue_mmap(struct isp_video_queue *queue,
-			 struct vm_area_struct *vma)
-{
-	struct isp_video_buffer *uninitialized_var(buf);
-	unsigned long size;
-	unsigned int i;
-	int ret = 0;
-
-	for (i = 0; i < queue->count; ++i) {
-		buf = queue->buffers[i];
-		if ((buf->vbuf.m.offset >> PAGE_SHIFT) == vma->vm_pgoff)
-			break;
-	}
-
-	if (i == queue->count)
-		return -EINVAL;
-
-	size = vma->vm_end - vma->vm_start;
-
-	if (buf->vbuf.memory != V4L2_MEMORY_MMAP ||
-	    size != PAGE_ALIGN(buf->vbuf.length))
-		return -EINVAL;
-
-	/* dma_mmap_coherent() uses vm_pgoff as an offset inside the buffer
-	 * while we used it to identify the buffer and want to map the whole
-	 * buffer.
-	 */
-	vma->vm_pgoff = 0;
-
-	ret = dma_mmap_coherent(queue->dev, vma, buf->vaddr, buf->dma, size);
-	if (ret < 0)
-		return ret;
-
-	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
-	vma->vm_ops = &isp_video_queue_vm_ops;
-	vma->vm_private_data = buf;
-	isp_video_queue_vm_open(vma);
-
-	return 0;
-}
-
-/**
- * omap3isp_video_queue_poll - Poll video queue state
- *
- * This function is intended to be used as a poll() file operation handler. It
- * polls the state of the video buffer at the front of the queue and returns an
- * events mask.
- *
- * If no buffer is present at the front of the queue, POLLERR is returned.
- */
-unsigned int omap3isp_video_queue_poll(struct isp_video_queue *queue,
-				       struct file *file, poll_table *wait)
-{
-	struct isp_video_buffer *buf;
-	unsigned int mask = 0;
-
-	if (list_empty(&queue->queue)) {
-		mask |= POLLERR;
-		goto done;
-	}
-	buf = list_first_entry(&queue->queue, struct isp_video_buffer, stream);
-
-	poll_wait(file, &buf->wait, wait);
-	if (buf->state == ISP_BUF_STATE_DONE ||
-	    buf->state == ISP_BUF_STATE_ERROR) {
-		if (queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-			mask |= POLLIN | POLLRDNORM;
-		else
-			mask |= POLLOUT | POLLWRNORM;
-	}
-
-done:
-	return mask;
-}
diff --git a/drivers/media/platform/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
deleted file mode 100644
index ff18208..0000000
--- a/drivers/media/platform/omap3isp/ispqueue.h
+++ /dev/null
@@ -1,171 +0,0 @@
-/*
- * ispqueue.h
- *
- * TI OMAP3 ISP - Video buffers queue handling
- *
- * Copyright (C) 2010 Nokia Corporation
- *
- * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *	     Sakari Ailus <sakari.ailus@iki.fi>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-
-#ifndef OMAP3_ISP_QUEUE_H
-#define OMAP3_ISP_QUEUE_H
-
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/mm_types.h>
-#include <linux/mutex.h>
-#include <linux/videodev2.h>
-#include <linux/wait.h>
-
-struct isp_video_queue;
-struct page;
-struct scatterlist;
-
-#define ISP_VIDEO_MAX_BUFFERS		16
-
-/**
- * enum isp_video_buffer_state - ISP video buffer state
- * @ISP_BUF_STATE_IDLE:	The buffer is under userspace control (dequeued
- *	or not queued yet).
- * @ISP_BUF_STATE_QUEUED: The buffer has been queued but isn't used by the
- *	device yet.
- * @ISP_BUF_STATE_ACTIVE: The buffer is in use for an active video transfer.
- * @ISP_BUF_STATE_ERROR: The device is done with the buffer and an error
- *	occurred. For capture device the buffer likely contains corrupted data or
- *	no data at all.
- * @ISP_BUF_STATE_DONE: The device is done with the buffer and no error occurred.
- *	For capture devices the buffer contains valid data.
- */
-enum isp_video_buffer_state {
-	ISP_BUF_STATE_IDLE,
-	ISP_BUF_STATE_QUEUED,
-	ISP_BUF_STATE_ACTIVE,
-	ISP_BUF_STATE_ERROR,
-	ISP_BUF_STATE_DONE,
-};
-
-/**
- * struct isp_video_buffer - ISP video buffer
- * @vma_use_count: Number of times the buffer is mmap'ed to userspace
- * @stream: List head for insertion into main queue
- * @queue: ISP buffers queue this buffer belongs to
- * @prepared: Whether the buffer has been prepared
- * @skip_cache: Whether to skip cache management operations for this buffer
- * @vaddr: Memory virtual address (for kernel buffers)
- * @vm_flags: Buffer VMA flags (for userspace buffers)
- * @npages: Number of pages (for userspace buffers)
- * @sgt: Scatter gather table (for userspace buffers)
- * @pages: Pages table (for userspace non-VM_PFNMAP buffers)
- * @vbuf: V4L2 buffer
- * @state: Current buffer state
- * @wait: Wait queue to signal buffer completion
- */
-struct isp_video_buffer {
-	unsigned long vma_use_count;
-	struct list_head stream;
-	struct isp_video_queue *queue;
-	unsigned int prepared:1;
-	bool skip_cache;
-
-	/* For kernel buffers. */
-	void *vaddr;
-
-	/* For userspace buffers. */
-	vm_flags_t vm_flags;
-	unsigned int npages;
-	struct sg_table sgt;
-
-	/* For non-VM_PFNMAP userspace buffers. */
-	struct page **pages;
-
-	/* Touched by the interrupt handler. */
-	struct v4l2_buffer vbuf;
-	enum isp_video_buffer_state state;
-	wait_queue_head_t wait;
-	dma_addr_t dma;
-};
-
-#define to_isp_video_buffer(vb)	container_of(vb, struct isp_video_buffer, vb)
-
-/**
- * struct isp_video_queue_operations - Driver-specific operations
- * @queue_prepare: Called before allocating buffers. Drivers should clamp the
- *	number of buffers according to their requirements, and must return the
- *	buffer size in bytes.
- * @buffer_prepare: Called the first time a buffer is queued, or after changing
- *	the userspace memory address for a USERPTR buffer, with the queue lock
- *	held. Drivers should perform device-specific buffer preparation (such as
- *	mapping the buffer memory in an IOMMU). This operation is optional.
- * @buffer_queue: Called when a buffer is being added.
- */
-struct isp_video_queue_operations {
-	void (*queue_prepare)(struct isp_video_queue *queue,
-			      unsigned int *nbuffers, unsigned int *size);
-	int  (*buffer_prepare)(struct isp_video_buffer *buf);
-	void (*buffer_queue)(struct isp_video_buffer *buf);
-};
-
-/**
- * struct isp_video_queue - ISP video buffers queue
- * @type: Type of video buffers handled by this queue
- * @ops: Queue operations
- * @dev: Device used for DMA operations
- * @bufsize: Size of a driver-specific buffer object
- * @count: Number of currently allocated buffers
- * @buffers: ISP video buffers
- * @streaming: Queue state, indicates whether the queue is streaming
- * @queue: List of all queued buffers
- */
-struct isp_video_queue {
-	enum v4l2_buf_type type;
-	const struct isp_video_queue_operations *ops;
-	struct device *dev;
-	unsigned int bufsize;
-
-	unsigned int count;
-	struct isp_video_buffer *buffers[ISP_VIDEO_MAX_BUFFERS];
-
-	unsigned int streaming:1;
-
-	struct list_head queue;
-};
-
-int omap3isp_video_queue_cleanup(struct isp_video_queue *queue);
-int omap3isp_video_queue_init(struct isp_video_queue *queue,
-			      enum v4l2_buf_type type,
-			      const struct isp_video_queue_operations *ops,
-			      struct device *dev, unsigned int bufsize);
-
-int omap3isp_video_queue_reqbufs(struct isp_video_queue *queue,
-				 struct v4l2_requestbuffers *rb);
-int omap3isp_video_queue_querybuf(struct isp_video_queue *queue,
-				  struct v4l2_buffer *vbuf);
-int omap3isp_video_queue_qbuf(struct isp_video_queue *queue,
-			      struct v4l2_buffer *vbuf);
-int omap3isp_video_queue_dqbuf(struct isp_video_queue *queue,
-			       struct v4l2_buffer *vbuf, int nonblocking);
-int omap3isp_video_queue_streamon(struct isp_video_queue *queue);
-void omap3isp_video_queue_streamoff(struct isp_video_queue *queue);
-void omap3isp_video_queue_discard_done(struct isp_video_queue *queue);
-int omap3isp_video_queue_mmap(struct isp_video_queue *queue,
-			      struct vm_area_struct *vma);
-unsigned int omap3isp_video_queue_poll(struct isp_video_queue *queue,
-				       struct file *file, poll_table *wait);
-
-#endif /* OMAP3_ISP_QUEUE_H */
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index ffe56ad..c4a2f76 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -34,6 +34,7 @@
 #include <linux/vmalloc.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
 
 #include "ispvideo.h"
 #include "isp.h"
@@ -328,25 +329,33 @@ isp_video_check_format(struct isp_video *video, struct isp_video_fh *vfh)
  * Video queue operations
  */
 
-static void isp_video_queue_prepare(struct isp_video_queue *queue,
-				    unsigned int *nbuffers, unsigned int *size)
+static int isp_video_queue_setup(struct vb2_queue *queue,
+				 const struct v4l2_format *fmt,
+				 unsigned int *count, unsigned int *num_planes,
+				 unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct isp_video_fh *vfh =
-		container_of(queue, struct isp_video_fh, queue);
+	struct isp_video_fh *vfh = vb2_get_drv_priv(queue);
 	struct isp_video *video = vfh->video;
 
-	*size = vfh->format.fmt.pix.sizeimage;
-	if (*size == 0)
-		return;
+	*num_planes = 1;
+
+	sizes[0] = vfh->format.fmt.pix.sizeimage;
+	if (sizes[0] == 0)
+		return -EINVAL;
+
+	alloc_ctxs[0] = video->alloc_ctx;
+
+	*count = min(*count, video->capture_mem / PAGE_ALIGN(sizes[0]));
 
-	*nbuffers = min(*nbuffers, video->capture_mem / PAGE_ALIGN(*size));
+	return 0;
 }
 
-static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
+static int isp_video_buffer_prepare(struct vb2_buffer *buf)
 {
-	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
+	struct isp_video_fh *vfh = vb2_get_drv_priv(buf->vb2_queue);
 	struct isp_buffer *buffer = to_isp_buffer(buf);
 	struct isp_video *video = vfh->video;
+	dma_addr_t addr;
 
 	/* Refuse to prepare the buffer is the video node has registered an
 	 * error. We don't need to take any lock here as the operation is
@@ -357,7 +366,16 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 	if (unlikely(video->error))
 		return -EIO;
 
-	buffer->isp_addr = buf->dma;
+	addr = vb2_dma_contig_plane_dma_addr(buf, 0);
+	if (!IS_ALIGNED(addr, 32)) {
+		dev_dbg(video->isp->dev,
+			"Buffer address must be aligned to 32 bytes boundary.\n");
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(&buffer->vb, 0, vfh->format.fmt.pix.sizeimage);
+	buffer->isp_addr = addr;
+
 	return 0;
 }
 
@@ -370,9 +388,9 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
  * If the pipeline is busy, it will be restarted in the output module interrupt
  * handler.
  */
-static void isp_video_buffer_queue(struct isp_video_buffer *buf)
+static void isp_video_buffer_queue(struct vb2_buffer *buf)
 {
-	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
+	struct isp_video_fh *vfh = vb2_get_drv_priv(buf->vb2_queue);
 	struct isp_buffer *buffer = to_isp_buffer(buf);
 	struct isp_video *video = vfh->video;
 	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
@@ -384,8 +402,7 @@ static void isp_video_buffer_queue(struct isp_video_buffer *buf)
 	spin_lock_irqsave(&video->irqlock, flags);
 
 	if (unlikely(video->error)) {
-		buf->state = ISP_BUF_STATE_ERROR;
-		wake_up(&buf->wait);
+		vb2_buffer_done(&buffer->vb, VB2_BUF_STATE_ERROR);
 		spin_unlock_irqrestore(&video->irqlock, flags);
 		return;
 	}
@@ -417,22 +434,22 @@ static void isp_video_buffer_queue(struct isp_video_buffer *buf)
 	}
 }
 
-static const struct isp_video_queue_operations isp_video_queue_ops = {
-	.queue_prepare = &isp_video_queue_prepare,
-	.buffer_prepare = &isp_video_buffer_prepare,
-	.buffer_queue = &isp_video_buffer_queue,
+static const struct vb2_ops isp_video_queue_ops = {
+	.queue_setup = isp_video_queue_setup,
+	.buf_prepare = isp_video_buffer_prepare,
+	.buf_queue = isp_video_buffer_queue,
 };
 
 /*
  * omap3isp_video_buffer_next - Complete the current buffer and return the next
  * @video: ISP video object
  *
- * Remove the current video buffer from the DMA queue and fill its timestamp,
- * field count and state fields before waking up its completion handler.
+ * Remove the current video buffer from the DMA queue and fill its timestamp and
+ * field count before handing it back to videobuf2.
  *
- * For capture video nodes the buffer state is set to ISP_BUF_STATE_DONE if no
- * error has been flagged in the pipeline, or to ISP_BUF_STATE_ERROR otherwise.
- * For video output nodes the buffer state is always set to ISP_BUF_STATE_DONE.
+ * For capture video nodes the buffer state is set to VB2_BUF_STATE_DONE if no
+ * error has been flagged in the pipeline, or to VB2_BUF_STATE_ERROR otherwise.
+ * For video output nodes the buffer state is always set to VB2_BUF_STATE_DONE.
  *
  * The DMA queue is expected to contain at least one buffer.
  *
@@ -442,9 +459,6 @@ static const struct isp_video_queue_operations isp_video_queue_ops = {
 struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 {
 	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
-	struct isp_video_queue *queue = video->queue;
-	struct isp_video_fh *vfh =
-		container_of(queue, struct isp_video_fh, queue);
 	enum isp_pipeline_state state;
 	struct isp_buffer *buf;
 	unsigned long flags;
@@ -461,11 +475,9 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	list_del(&buf->irqlist);
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
-	buf->buffer.vbuf.bytesused = vfh->format.fmt.pix.sizeimage;
-
 	ktime_get_ts(&ts);
-	buf->buffer.vbuf.timestamp.tv_sec = ts.tv_sec;
-	buf->buffer.vbuf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+	buf->vb.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
+	buf->vb.v4l2_buf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 
 	/* Do frame number propagation only if this is the output video node.
 	 * Frame number either comes from the CSI receivers or it gets
@@ -474,23 +486,27 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	 * first, so the input number might lag behind by 1 in some cases.
 	 */
 	if (video == pipe->output && !pipe->do_propagation)
-		buf->buffer.vbuf.sequence =
+		buf->vb.v4l2_buf.sequence =
 			atomic_inc_return(&pipe->frame_number);
 	else
-		buf->buffer.vbuf.sequence = atomic_read(&pipe->frame_number);
+		buf->vb.v4l2_buf.sequence = atomic_read(&pipe->frame_number);
 
 	/* Report pipeline errors to userspace on the capture device side. */
-	if (queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->error) {
-		buf->buffer.state = ISP_BUF_STATE_ERROR;
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->error) {
+		state = VB2_BUF_STATE_ERROR;
 		pipe->error = false;
 	} else {
-		buf->buffer.state = ISP_BUF_STATE_DONE;
+		state = VB2_BUF_STATE_DONE;
 	}
 
-	wake_up(&buf->buffer.wait);
+	vb2_buffer_done(&buf->vb, state);
+
+	spin_lock_irqsave(&video->irqlock, flags);
 
 	if (list_empty(&video->dmaqueue)) {
-		if (queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		spin_unlock_irqrestore(&video->irqlock, flags);
+
+		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 			state = ISP_PIPELINE_QUEUE_OUTPUT
 			      | ISP_PIPELINE_STREAM;
 		else
@@ -505,15 +521,18 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 		return NULL;
 	}
 
-	if (queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->input != NULL) {
-		spin_lock_irqsave(&pipe->lock, flags);
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->input != NULL) {
+		spin_lock(&pipe->lock);
 		pipe->state &= ~ISP_PIPELINE_STREAM;
-		spin_unlock_irqrestore(&pipe->lock, flags);
+		spin_unlock(&pipe->lock);
 	}
 
 	buf = list_first_entry(&video->dmaqueue, struct isp_buffer,
 			       irqlist);
-	buf->buffer.state = ISP_BUF_STATE_ACTIVE;
+	buf->vb.state = VB2_BUF_STATE_ACTIVE;
+
+	spin_unlock_irqrestore(&video->irqlock, flags);
+
 	return buf;
 }
 
@@ -536,9 +555,7 @@ void omap3isp_video_cancel_stream(struct isp_video *video)
 		buf = list_first_entry(&video->dmaqueue,
 				       struct isp_buffer, irqlist);
 		list_del(&buf->irqlist);
-
-		buf->buffer.state = ISP_BUF_STATE_ERROR;
-		wake_up(&buf->buffer.wait);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
 
 	video->error = true;
@@ -562,7 +579,7 @@ void omap3isp_video_resume(struct isp_video *video, int continuous)
 
 	if (continuous && video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		mutex_lock(&video->queue_lock);
-		omap3isp_video_queue_discard_done(video->queue);
+		vb2_discard_done(video->queue);
 		mutex_unlock(&video->queue_lock);
 	}
 
@@ -780,7 +797,7 @@ isp_video_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *rb)
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = omap3isp_video_queue_reqbufs(&vfh->queue, rb);
+	ret = vb2_reqbufs(&vfh->queue, rb);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -794,7 +811,7 @@ isp_video_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = omap3isp_video_queue_querybuf(&vfh->queue, b);
+	ret = vb2_querybuf(&vfh->queue, b);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -808,7 +825,7 @@ isp_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = omap3isp_video_queue_qbuf(&vfh->queue, b);
+	ret = vb2_qbuf(&vfh->queue, b);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -822,8 +839,7 @@ isp_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = omap3isp_video_queue_dqbuf(&vfh->queue, b,
-					 file->f_flags & O_NONBLOCK);
+	ret = vb2_dqbuf(&vfh->queue, b, file->f_flags & O_NONBLOCK);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -966,11 +982,6 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	mutex_lock(&video->stream_lock);
 
-	if (video->streaming) {
-		mutex_unlock(&video->stream_lock);
-		return -EBUSY;
-	}
-
 	/* Start streaming on the pipeline. No link touching an entity in the
 	 * pipeline can be activated or deactivated once streaming is started.
 	 */
@@ -1030,7 +1041,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	atomic_set(&pipe->frame_number, -1);
 
 	mutex_lock(&video->queue_lock);
-	ret = omap3isp_video_queue_streamon(&vfh->queue);
+	ret = vb2_streamon(&vfh->queue, type);
 	mutex_unlock(&video->queue_lock);
 	if (ret < 0)
 		goto err_check_format;
@@ -1050,14 +1061,12 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 		spin_unlock_irqrestore(&video->irqlock, flags);
 	}
 
-	video->streaming = 1;
-
 	mutex_unlock(&video->stream_lock);
 	return 0;
 
 err_set_stream:
 	mutex_lock(&video->queue_lock);
-	omap3isp_video_queue_streamoff(&vfh->queue);
+	vb2_streamoff(&vfh->queue, type);
 	mutex_unlock(&video->queue_lock);
 err_check_format:
 	media_entity_pipeline_stop(&video->video.entity);
@@ -1095,7 +1104,7 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	/* Make sure we're not streaming yet. */
 	mutex_lock(&video->queue_lock);
-	streaming = vfh->queue.streaming;
+	streaming = vb2_is_streaming(&vfh->queue);
 	mutex_unlock(&video->queue_lock);
 
 	if (!streaming)
@@ -1118,10 +1127,9 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	omap3isp_video_cancel_stream(video);
 
 	mutex_lock(&video->queue_lock);
-	omap3isp_video_queue_streamoff(&vfh->queue);
+	vb2_streamoff(&vfh->queue, type);
 	mutex_unlock(&video->queue_lock);
 	video->queue = NULL;
-	video->streaming = 0;
 	video->error = false;
 
 	if (video->isp->pdata->set_constraints)
@@ -1191,6 +1199,7 @@ static int isp_video_open(struct file *file)
 {
 	struct isp_video *video = video_drvdata(file);
 	struct isp_video_fh *handle;
+	struct vb2_queue *queue;
 	int ret = 0;
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
@@ -1212,9 +1221,20 @@ static int isp_video_open(struct file *file)
 		goto done;
 	}
 
-	omap3isp_video_queue_init(&handle->queue, video->type,
-				  &isp_video_queue_ops, video->isp->dev,
-				  sizeof(struct isp_buffer));
+	queue = &handle->queue;
+	queue->type = video->type;
+	queue->io_modes = VB2_MMAP | VB2_USERPTR;
+	queue->drv_priv = handle;
+	queue->ops = &isp_video_queue_ops;
+	queue->mem_ops = &vb2_dma_contig_memops;
+	queue->buf_struct_size = sizeof(struct isp_buffer);
+	queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+
+	ret = vb2_queue_init(&handle->queue);
+	if (ret < 0) {
+		omap3isp_put(video->isp);
+		goto done;
+	}
 
 	memset(&handle->format, 0, sizeof(handle->format));
 	handle->format.type = video->type;
@@ -1242,7 +1262,7 @@ static int isp_video_release(struct file *file)
 	isp_video_streamoff(file, vfh, video->type);
 
 	mutex_lock(&video->queue_lock);
-	omap3isp_video_queue_cleanup(&handle->queue);
+	vb2_queue_release(&handle->queue);
 	mutex_unlock(&video->queue_lock);
 
 	omap3isp_pipeline_pm_use(&video->video.entity, 0);
@@ -1264,7 +1284,7 @@ static unsigned int isp_video_poll(struct file *file, poll_table *wait)
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = omap3isp_video_queue_poll(&vfh->queue, file, wait);
+	ret = vb2_poll(&vfh->queue, file, wait);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -1277,7 +1297,7 @@ static int isp_video_mmap(struct file *file, struct vm_area_struct *vma)
 	int ret;
 
 	mutex_lock(&video->queue_lock);
-	ret = omap3isp_video_queue_mmap(&vfh->queue, vma);
+	ret = vb2_mmap(&vfh->queue, vma);
 	mutex_unlock(&video->queue_lock);
 
 	return ret;
@@ -1321,9 +1341,15 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 		return -EINVAL;
 	}
 
+	video->alloc_ctx = vb2_dma_contig_init_ctx(video->isp->dev);
+	if (IS_ERR(video->alloc_ctx))
+		return PTR_ERR(video->alloc_ctx);
+
 	ret = media_entity_init(&video->video.entity, 1, &video->pad, 0);
-	if (ret < 0)
+	if (ret < 0) {
+		vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
 		return ret;
+	}
 
 	mutex_init(&video->mutex);
 	atomic_set(&video->active, 0);
@@ -1352,6 +1378,7 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 
 void omap3isp_video_cleanup(struct isp_video *video)
 {
+	vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
 	media_entity_cleanup(&video->video.entity);
 	mutex_destroy(&video->queue_lock);
 	mutex_destroy(&video->stream_lock);
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 1e3d17a..1015505 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -30,8 +30,7 @@
 #include <media/media-entity.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
-
-#include "ispqueue.h"
+#include <media/videobuf2-core.h>
 
 #define ISP_VIDEO_DRIVER_NAME		"ispvideo"
 #define ISP_VIDEO_DRIVER_VERSION	"0.0.2"
@@ -124,19 +123,19 @@ static inline int isp_pipeline_ready(struct isp_pipeline *pipe)
 			       ISP_PIPELINE_IDLE_OUTPUT);
 }
 
-/*
- * struct isp_buffer - ISP buffer
- * @buffer: ISP video buffer
+/**
+ * struct isp_buffer - ISP video buffer
+ * @vb: videobuf2 buffer
  * @irqlist: List head for insertion into IRQ queue
- * @isp_addr: MMU mapped address (a.k.a. device address) of the buffer.
+ * @isp_addr: DMA address
  */
 struct isp_buffer {
-	struct isp_video_buffer buffer;
+	struct vb2_buffer vb;
 	struct list_head irqlist;
 	dma_addr_t isp_addr;
 };
 
-#define to_isp_buffer(buf)	container_of(buf, struct isp_buffer, buffer)
+#define to_isp_buffer(buf)	container_of(buf, struct isp_buffer, vb)
 
 enum isp_video_dmaqueue_flags {
 	/* Set if DMA queue becomes empty when ISP_PIPELINE_STREAM_CONTINUOUS */
@@ -174,16 +173,14 @@ struct isp_video {
 	unsigned int bpl_value;		/* bytes per line value */
 	unsigned int bpl_padding;	/* padding at end of line */
 
-	/* Entity video node streaming */
-	unsigned int streaming:1;
-
 	/* Pipeline state */
 	struct isp_pipeline pipe;
 	struct mutex stream_lock;	/* pipeline and stream states */
 	bool error;
 
 	/* Video buffers queue */
-	struct isp_video_queue *queue;
+	void *alloc_ctx;
+	struct vb2_queue *queue;
 	struct mutex queue_lock;	/* protects the queue */
 	spinlock_t irqlock;		/* protects dmaqueue */
 	struct list_head dmaqueue;
@@ -197,7 +194,7 @@ struct isp_video {
 struct isp_video_fh {
 	struct v4l2_fh vfh;
 	struct isp_video *video;
-	struct isp_video_queue queue;
+	struct vb2_queue queue;
 	struct v4l2_format format;
 	struct v4l2_fract timeperframe;
 };
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index ded31ea..cbf455d 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -396,7 +396,7 @@ static void iss_video_buf_queue(struct vb2_buffer *vb)
 	}
 }
 
-static struct vb2_ops iss_video_vb2ops = {
+static const struct vb2_ops iss_video_vb2ops = {
 	.queue_setup	= iss_video_queue_setup,
 	.buf_prepare	= iss_video_buf_prepare,
 	.buf_queue	= iss_video_buf_queue,
-- 
1.8.3.2

