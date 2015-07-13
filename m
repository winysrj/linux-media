Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbbGMOz7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 10:55:59 -0400
From: Jan Kara <jack@suse.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6/9] media: vb2: Convert vb2_vmalloc_get_userptr() to use frame vector
Date: Mon, 13 Jul 2015 16:55:48 +0200
Message-Id: <1436799351-21975-7-git-send-email-jack@suse.com>
In-Reply-To: <1436799351-21975-1-git-send-email-jack@suse.com>
References: <1436799351-21975-1-git-send-email-jack@suse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Convert vb2_vmalloc_get_userptr() to use frame vector infrastructure.
When we are doing that there's no need to allocate page array and some
code can be simplified.

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/media/v4l2-core/videobuf2-vmalloc.c | 92 +++++++++++------------------
 1 file changed, 36 insertions(+), 56 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 63bef959623e..ecb8f0c7f025 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -23,11 +23,9 @@
 
 struct vb2_vmalloc_buf {
 	void				*vaddr;
-	struct page			**pages;
-	struct vm_area_struct		*vma;
+	struct frame_vector		*vec;
 	enum dma_data_direction		dma_dir;
 	unsigned long			size;
-	unsigned int			n_pages;
 	atomic_t			refcount;
 	struct vb2_vmarea_handler	handler;
 	struct dma_buf			*dbuf;
@@ -76,10 +74,8 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 				     enum dma_data_direction dma_dir)
 {
 	struct vb2_vmalloc_buf *buf;
-	unsigned long first, last;
-	int n_pages, offset;
-	struct vm_area_struct *vma;
-	dma_addr_t physp;
+	struct frame_vector *vec;
+	int n_pages, offset, i;
 
 	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
@@ -88,53 +84,36 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	buf->dma_dir = dma_dir;
 	offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
-
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma(current->mm, vaddr);
-	if (vma && (vma->vm_flags & VM_PFNMAP) && (vma->vm_pgoff)) {
-		if (vb2_get_contig_userptr(vaddr, size, &vma, &physp))
-			goto fail_pages_array_alloc;
-		buf->vma = vma;
-		buf->vaddr = (__force void *)ioremap_nocache(physp, size);
-		if (!buf->vaddr)
-			goto fail_pages_array_alloc;
+	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
+	if (IS_ERR(vec))
+		goto fail_pfnvec_create;
+	buf->vec = vec;
+	n_pages = frame_vector_count(vec);
+	if (frame_vector_to_pages(vec) < 0) {
+		unsigned long *nums = frame_vector_pfns(vec);
+
+		/*
+		 * We cannot get page pointers for these pfns. Check memory is
+		 * physically contiguous and use direct mapping.
+		 */
+		for (i = 1; i < n_pages; i++)
+			if (nums[i-1] + 1 != nums[i])
+				goto fail_map;
+		buf->vaddr = (__force void *)
+				ioremap_nocache(nums[0] << PAGE_SHIFT, size);
 	} else {
-		first = vaddr >> PAGE_SHIFT;
-		last  = (vaddr + size - 1) >> PAGE_SHIFT;
-		buf->n_pages = last - first + 1;
-		buf->pages = kzalloc(buf->n_pages * sizeof(struct page *),
-				     GFP_KERNEL);
-		if (!buf->pages)
-			goto fail_pages_array_alloc;
-
-		/* current->mm->mmap_sem is taken by videobuf2 core */
-		n_pages = get_user_pages(current, current->mm,
-					 vaddr & PAGE_MASK, buf->n_pages,
-					 dma_dir == DMA_FROM_DEVICE,
-					 1, /* force */
-					 buf->pages, NULL);
-		if (n_pages != buf->n_pages)
-			goto fail_get_user_pages;
-
-		buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1,
+		buf->vaddr = vm_map_ram(frame_vector_pages(vec), n_pages, -1,
 					PAGE_KERNEL);
-		if (!buf->vaddr)
-			goto fail_get_user_pages;
 	}
-	up_read(&current->mm->mmap_sem);
 
+	if (!buf->vaddr)
+		goto fail_map;
 	buf->vaddr += offset;
 	return buf;
 
-fail_get_user_pages:
-	pr_debug("get_user_pages requested/got: %d/%d]\n", n_pages,
-		 buf->n_pages);
-	while (--n_pages >= 0)
-		put_page(buf->pages[n_pages]);
-	kfree(buf->pages);
-
-fail_pages_array_alloc:
-	up_read(&current->mm->mmap_sem);
+fail_map:
+	vb2_destroy_framevec(vec);
+fail_pfnvec_create:
 	kfree(buf);
 
 	return NULL;
@@ -145,20 +124,21 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
 	struct vb2_vmalloc_buf *buf = buf_priv;
 	unsigned long vaddr = (unsigned long)buf->vaddr & PAGE_MASK;
 	unsigned int i;
+	struct page **pages;
+	unsigned int n_pages;
 
-	if (buf->pages) {
+	if (!buf->vec->is_pfns) {
+		n_pages = frame_vector_count(buf->vec);
+		pages = frame_vector_pages(buf->vec);
 		if (vaddr)
-			vm_unmap_ram((void *)vaddr, buf->n_pages);
-		for (i = 0; i < buf->n_pages; ++i) {
-			if (buf->dma_dir == DMA_FROM_DEVICE)
-				set_page_dirty_lock(buf->pages[i]);
-			put_page(buf->pages[i]);
-		}
-		kfree(buf->pages);
+			vm_unmap_ram((void *)vaddr, n_pages);
+		if (buf->dma_dir == DMA_FROM_DEVICE)
+			for (i = 0; i < n_pages; i++)
+				set_page_dirty_lock(pages[i]);
 	} else {
-		vb2_put_vma(buf->vma);
 		iounmap((__force void __iomem *)buf->vaddr);
 	}
+	vb2_destroy_framevec(buf->vec);
 	kfree(buf);
 }
 
-- 
2.1.4

