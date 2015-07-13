Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbbGMO4B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 10:56:01 -0400
From: Jan Kara <jack@suse.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5/9] media: vb2: Convert vb2_dma_sg_get_userptr() to use frame vector
Date: Mon, 13 Jul 2015 16:55:47 +0200
Message-Id: <1436799351-21975-6-git-send-email-jack@suse.com>
In-Reply-To: <1436799351-21975-1-git-send-email-jack@suse.com>
References: <1436799351-21975-1-git-send-email-jack@suse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c | 95 +++++-------------------------
 1 file changed, 15 insertions(+), 80 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index d2cf113d1933..be7bd6535c9d 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -38,6 +38,7 @@ struct vb2_dma_sg_buf {
 	struct device			*dev;
 	void				*vaddr;
 	struct page			**pages;
+	struct frame_vector		*vec;
 	int				offset;
 	enum dma_data_direction		dma_dir;
 	struct sg_table			sg_table;
@@ -51,7 +52,6 @@ struct vb2_dma_sg_buf {
 	unsigned int			num_pages;
 	atomic_t			refcount;
 	struct vb2_vmarea_handler	handler;
-	struct vm_area_struct		*vma;
 
 	struct dma_buf_attachment	*db_attach;
 };
@@ -225,25 +225,17 @@ static void vb2_dma_sg_finish(void *buf_priv)
 	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 }
 
-static inline int vma_is_io(struct vm_area_struct *vma)
-{
-	return !!(vma->vm_flags & (VM_IO | VM_PFNMAP));
-}
-
 static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 				    unsigned long size,
 				    enum dma_data_direction dma_dir)
 {
 	struct vb2_dma_sg_conf *conf = alloc_ctx;
 	struct vb2_dma_sg_buf *buf;
-	unsigned long first, last;
-	int num_pages_from_user;
-	struct vm_area_struct *vma;
 	struct sg_table *sgt;
 	DEFINE_DMA_ATTRS(attrs);
+	struct frame_vector *vec;
 
 	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
-
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
 		return NULL;
@@ -254,63 +246,19 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	buf->offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
 	buf->dma_sgt = &buf->sg_table;
+	vec = vb2_create_framevec(vaddr, size, buf->dma_dir == DMA_FROM_DEVICE);
+	if (IS_ERR(vec))
+		goto userptr_fail_pfnvec;
+	buf->vec = vec;
 
-	first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
-	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
-	buf->num_pages = last - first + 1;
-
-	buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
-			     GFP_KERNEL);
-	if (!buf->pages)
-		goto userptr_fail_alloc_pages;
-
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma(current->mm, vaddr);
-	if (!vma) {
-		dprintk(1, "no vma for address %lu\n", vaddr);
-		goto userptr_fail_find_vma;
-	}
-
-	if (vma->vm_end < vaddr + size) {
-		dprintk(1, "vma at %lu is too small for %lu bytes\n",
-			vaddr, size);
-		goto userptr_fail_find_vma;
-	}
-
-	buf->vma = vb2_get_vma(vma);
-	if (!buf->vma) {
-		dprintk(1, "failed to copy vma\n");
-		goto userptr_fail_find_vma;
-	}
-
-	if (vma_is_io(buf->vma)) {
-		for (num_pages_from_user = 0;
-		     num_pages_from_user < buf->num_pages;
-		     ++num_pages_from_user, vaddr += PAGE_SIZE) {
-			unsigned long pfn;
-
-			if (follow_pfn(vma, vaddr, &pfn)) {
-				dprintk(1, "no page for address %lu\n", vaddr);
-				break;
-			}
-			buf->pages[num_pages_from_user] = pfn_to_page(pfn);
-		}
-	} else
-		num_pages_from_user = get_user_pages(current, current->mm,
-					     vaddr & PAGE_MASK,
-					     buf->num_pages,
-					     buf->dma_dir == DMA_FROM_DEVICE,
-					     1, /* force */
-					     buf->pages,
-					     NULL);
-	up_read(&current->mm->mmap_sem);
-
-	if (num_pages_from_user != buf->num_pages)
-		goto userptr_fail_get_user_pages;
+	buf->pages = frame_vector_pages(vec);
+	if (IS_ERR(buf->pages))
+		goto userptr_fail_sgtable;
+	buf->num_pages = frame_vector_count(vec);
 
 	if (sg_alloc_table_from_pages(buf->dma_sgt, buf->pages,
 			buf->num_pages, buf->offset, size, 0))
-		goto userptr_fail_alloc_table_from_pages;
+		goto userptr_fail_sgtable;
 
 	sgt = &buf->sg_table;
 	/*
@@ -326,19 +274,9 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 
 userptr_fail_map:
 	sg_free_table(&buf->sg_table);
-userptr_fail_alloc_table_from_pages:
-userptr_fail_get_user_pages:
-	dprintk(1, "get_user_pages requested/got: %d/%d]\n",
-		buf->num_pages, num_pages_from_user);
-	if (!vma_is_io(buf->vma))
-		while (--num_pages_from_user >= 0)
-			put_page(buf->pages[num_pages_from_user]);
-	down_read(&current->mm->mmap_sem);
-	vb2_put_vma(buf->vma);
-userptr_fail_find_vma:
-	up_read(&current->mm->mmap_sem);
-	kfree(buf->pages);
-userptr_fail_alloc_pages:
+userptr_fail_sgtable:
+	vb2_destroy_framevec(vec);
+userptr_fail_pfnvec:
 	kfree(buf);
 	return NULL;
 }
@@ -366,11 +304,8 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
 	while (--i >= 0) {
 		if (buf->dma_dir == DMA_FROM_DEVICE)
 			set_page_dirty_lock(buf->pages[i]);
-		if (!vma_is_io(buf->vma))
-			put_page(buf->pages[i]);
 	}
-	kfree(buf->pages);
-	vb2_put_vma(buf->vma);
+	vb2_destroy_framevec(buf->vec);
 	kfree(buf);
 }
 
-- 
2.1.4

