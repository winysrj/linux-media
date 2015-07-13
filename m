Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbbGMO4B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 10:56:01 -0400
From: Jan Kara <jack@suse.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 8/9] media: vb2: Remove unused functions
Date: Mon, 13 Jul 2015 16:55:50 +0200
Message-Id: <1436799351-21975-9-git-send-email-jack@suse.com>
In-Reply-To: <1436799351-21975-1-git-send-email-jack@suse.com>
References: <1436799351-21975-1-git-send-email-jack@suse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Conversion to the use of pinned pfns made some functions unused. Remove
them. Also there's no need to lock mmap_sem in __buf_prepare() anymore.

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/media/v4l2-core/videobuf2-memops.c | 114 -----------------------------
 include/media/videobuf2-memops.h           |   6 --
 2 files changed, 120 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
index 0ec186d41b9b..48c6a49c4928 100644
--- a/drivers/media/v4l2-core/videobuf2-memops.c
+++ b/drivers/media/v4l2-core/videobuf2-memops.c
@@ -23,120 +23,6 @@
 #include <media/videobuf2-memops.h>
 
 /**
- * vb2_get_vma() - acquire and lock the virtual memory area
- * @vma:	given virtual memory area
- *
- * This function attempts to acquire an area mapped in the userspace for
- * the duration of a hardware operation. The area is "locked" by performing
- * the same set of operation that are done when process calls fork() and
- * memory areas are duplicated.
- *
- * Returns a copy of a virtual memory region on success or NULL.
- */
-struct vm_area_struct *vb2_get_vma(struct vm_area_struct *vma)
-{
-	struct vm_area_struct *vma_copy;
-
-	vma_copy = kmalloc(sizeof(*vma_copy), GFP_KERNEL);
-	if (vma_copy == NULL)
-		return NULL;
-
-	if (vma->vm_ops && vma->vm_ops->open)
-		vma->vm_ops->open(vma);
-
-	if (vma->vm_file)
-		get_file(vma->vm_file);
-
-	memcpy(vma_copy, vma, sizeof(*vma));
-
-	vma_copy->vm_mm = NULL;
-	vma_copy->vm_next = NULL;
-	vma_copy->vm_prev = NULL;
-
-	return vma_copy;
-}
-EXPORT_SYMBOL_GPL(vb2_get_vma);
-
-/**
- * vb2_put_userptr() - release a userspace virtual memory area
- * @vma:	virtual memory region associated with the area to be released
- *
- * This function releases the previously acquired memory area after a hardware
- * operation.
- */
-void vb2_put_vma(struct vm_area_struct *vma)
-{
-	if (!vma)
-		return;
-
-	if (vma->vm_ops && vma->vm_ops->close)
-		vma->vm_ops->close(vma);
-
-	if (vma->vm_file)
-		fput(vma->vm_file);
-
-	kfree(vma);
-}
-EXPORT_SYMBOL_GPL(vb2_put_vma);
-
-/**
- * vb2_get_contig_userptr() - lock physically contiguous userspace mapped memory
- * @vaddr:	starting virtual address of the area to be verified
- * @size:	size of the area
- * @res_paddr:	will return physical address for the given vaddr
- * @res_vma:	will return locked copy of struct vm_area for the given area
- *
- * This function will go through memory area of size @size mapped at @vaddr and
- * verify that the underlying physical pages are contiguous. If they are
- * contiguous the virtual memory area is locked and a @res_vma is filled with
- * the copy and @res_pa set to the physical address of the buffer.
- *
- * Returns 0 on success.
- */
-int vb2_get_contig_userptr(unsigned long vaddr, unsigned long size,
-			   struct vm_area_struct **res_vma, dma_addr_t *res_pa)
-{
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-	unsigned long offset, start, end;
-	unsigned long this_pfn, prev_pfn;
-	dma_addr_t pa = 0;
-
-	start = vaddr;
-	offset = start & ~PAGE_MASK;
-	end = start + size;
-
-	vma = find_vma(mm, start);
-
-	if (vma == NULL || vma->vm_end < end)
-		return -EFAULT;
-
-	for (prev_pfn = 0; start < end; start += PAGE_SIZE) {
-		int ret = follow_pfn(vma, start, &this_pfn);
-		if (ret)
-			return ret;
-
-		if (prev_pfn == 0)
-			pa = this_pfn << PAGE_SHIFT;
-		else if (this_pfn != prev_pfn + 1)
-			return -EFAULT;
-
-		prev_pfn = this_pfn;
-	}
-
-	/*
-	 * Memory is contigous, lock vma and return to the caller
-	 */
-	*res_vma = vb2_get_vma(vma);
-	if (*res_vma == NULL)
-		return -ENOMEM;
-
-	*res_pa = pa + offset;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vb2_get_contig_userptr);
-
-/**
  * vb2_create_framevec() - map virtual addresses to pfns
  * @start:	Virtual user address where we start mapping
  * @length:	Length of a range to map
diff --git a/include/media/videobuf2-memops.h b/include/media/videobuf2-memops.h
index 2f0564ff5f31..830b5239fd8b 100644
--- a/include/media/videobuf2-memops.h
+++ b/include/media/videobuf2-memops.h
@@ -31,12 +31,6 @@ struct vb2_vmarea_handler {
 
 extern const struct vm_operations_struct vb2_common_vm_ops;
 
-int vb2_get_contig_userptr(unsigned long vaddr, unsigned long size,
-			   struct vm_area_struct **res_vma, dma_addr_t *res_pa);
-
-struct vm_area_struct *vb2_get_vma(struct vm_area_struct *vma);
-void vb2_put_vma(struct vm_area_struct *vma);
-
 struct frame_vector *vb2_create_framevec(unsigned long start,
 					 unsigned long length,
 					 bool write);
-- 
2.1.4

