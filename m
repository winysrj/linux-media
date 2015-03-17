Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209AbbCQL5D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2015 07:57:03 -0400
From: Jan Kara <jack@suse.cz>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
	David Airlie <airlied@linux.ie>, Jan Kara <jack@suse.cz>
Subject: [PATCH 9/9] drm/exynos: Convert g2d_userptr_get_dma_addr() to use get_vaddr_pfn()
Date: Tue, 17 Mar 2015 12:56:39 +0100
Message-Id: <1426593399-6549-10-git-send-email-jack@suse.cz>
In-Reply-To: <1426593399-6549-1-git-send-email-jack@suse.cz>
References: <1426593399-6549-1-git-send-email-jack@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert g2d_userptr_get_dma_addr() to pin pages using get_vaddr_pfn().
This removes the knowledge about vmas and mmap_sem locking from exynos
driver. Also it fixes a problem that the function has been mapping user
provided address without holding mmap_sem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/gpu/drm/exynos/exynos_drm_g2d.c | 91 ++++++++++---------------------
 drivers/gpu/drm/exynos/exynos_drm_gem.c | 97 ---------------------------------
 2 files changed, 30 insertions(+), 158 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index 81a250830808..8949354a85a1 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -190,10 +190,8 @@ struct g2d_cmdlist_userptr {
 	dma_addr_t		dma_addr;
 	unsigned long		userptr;
 	unsigned long		size;
-	struct page		**pages;
-	unsigned int		npages;
+	struct pinned_pfns	*pfns;
 	struct sg_table		*sgt;
-	struct vm_area_struct	*vma;
 	atomic_t		refcount;
 	bool			in_pool;
 	bool			out_of_list;
@@ -363,6 +361,7 @@ static void g2d_userptr_put_dma_addr(struct drm_device *drm_dev,
 {
 	struct g2d_cmdlist_userptr *g2d_userptr =
 					(struct g2d_cmdlist_userptr *)obj;
+	struct page **pages;
 
 	if (!obj)
 		return;
@@ -382,19 +381,21 @@ out:
 	exynos_gem_unmap_sgt_from_dma(drm_dev, g2d_userptr->sgt,
 					DMA_BIDIRECTIONAL);
 
-	exynos_gem_put_pages_to_userptr(g2d_userptr->pages,
-					g2d_userptr->npages,
-					g2d_userptr->vma);
+	pages = pfns_vector_pages(g2d_userptr->pfns);
+	if (pages) {
+		int i;
 
-	exynos_gem_put_vma(g2d_userptr->vma);
+		for (i = 0; i < pfns_vector_count(g2d_userptr->pfns); i++)
+			set_page_dirty_lock(pages[i]);
+	}
+	put_vaddr_pfns(g2d_userptr->pfns);
+	pfns_vector_destroy(g2d_userptr->pfns);
 
 	if (!g2d_userptr->out_of_list)
 		list_del_init(&g2d_userptr->list);
 
 	sg_free_table(g2d_userptr->sgt);
 	kfree(g2d_userptr->sgt);
-
-	drm_free_large(g2d_userptr->pages);
 	kfree(g2d_userptr);
 }
 
@@ -413,6 +414,7 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struct drm_device *drm_dev,
 	struct vm_area_struct *vma;
 	unsigned long start, end;
 	unsigned int npages, offset;
+	struct pinned_pfns *pfns;
 	int ret;
 
 	if (!size) {
@@ -456,65 +458,37 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struct drm_device *drm_dev,
 		return ERR_PTR(-ENOMEM);
 
 	atomic_set(&g2d_userptr->refcount, 1);
+	g2d_userptr->size = size;
 
 	start = userptr & PAGE_MASK;
 	offset = userptr & ~PAGE_MASK;
 	end = PAGE_ALIGN(userptr + size);
 	npages = (end - start) >> PAGE_SHIFT;
-	g2d_userptr->npages = npages;
+	pfns = g2d_userptr->pfns = pfns_vector_create(npages);
+	if (!pfns)
+		goto out_free;
 
-	pages = drm_calloc_large(npages, sizeof(struct page *));
-	if (!pages) {
-		DRM_ERROR("failed to allocate pages.\n");
-		ret = -ENOMEM;
-		goto err_free;
-	}
-
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma(current->mm, userptr);
-	if (!vma) {
-		up_read(&current->mm->mmap_sem);
-		DRM_ERROR("failed to get vm region.\n");
+	ret = get_vaddr_pfn(start, npages, 1, 1, pfns);
+	if (ret != npages) {
+		DRM_ERROR("failed to get user pages from userptr.\n");
+		if (ret < 0)
+			goto err_destroy_pfns;
 		ret = -EFAULT;
-		goto err_free_pages;
+		goto err_put_pfns;
 	}
-
-	if (vma->vm_end < userptr + size) {
-		up_read(&current->mm->mmap_sem);
-		DRM_ERROR("vma is too small.\n");
+	if (pfns_vector_to_pages(pfns) < 0) {
 		ret = -EFAULT;
-		goto err_free_pages;
+		goto err_put_pfns;
 	}
 
-	g2d_userptr->vma = exynos_gem_get_vma(vma);
-	if (!g2d_userptr->vma) {
-		up_read(&current->mm->mmap_sem);
-		DRM_ERROR("failed to copy vma.\n");
-		ret = -ENOMEM;
-		goto err_free_pages;
-	}
-
-	g2d_userptr->size = size;
-
-	ret = exynos_gem_get_pages_from_userptr(start & PAGE_MASK,
-						npages, pages, vma);
-	if (ret < 0) {
-		up_read(&current->mm->mmap_sem);
-		DRM_ERROR("failed to get user pages from userptr.\n");
-		goto err_put_vma;
-	}
-
-	up_read(&current->mm->mmap_sem);
-	g2d_userptr->pages = pages;
-
 	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
 	if (!sgt) {
 		ret = -ENOMEM;
-		goto err_free_userptr;
+		goto err_put_pfns;
 	}
 
-	ret = sg_alloc_table_from_pages(sgt, pages, npages, offset,
-					size, GFP_KERNEL);
+	ret = sg_alloc_table_from_pages(sgt, pfns_vector_pages(pfns), npages,
+					offset, size, GFP_KERNEL);
 	if (ret < 0) {
 		DRM_ERROR("failed to get sgt from pages.\n");
 		goto err_free_sgt;
@@ -549,16 +523,11 @@ err_sg_free_table:
 err_free_sgt:
 	kfree(sgt);
 
-err_free_userptr:
-	exynos_gem_put_pages_to_userptr(g2d_userptr->pages,
-					g2d_userptr->npages,
-					g2d_userptr->vma);
-
-err_put_vma:
-	exynos_gem_put_vma(g2d_userptr->vma);
+err_put_pfns:
+	put_vaddr_pfns(pfns);
 
-err_free_pages:
-	drm_free_large(pages);
+err_destroy_pfns:
+	pfns_vector_destroy(pfns);
 
 err_free:
 	kfree(g2d_userptr);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_gem.c b/drivers/gpu/drm/exynos/exynos_drm_gem.c
index 0d5b9698d384..47068ae44ced 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -378,103 +378,6 @@ int exynos_drm_gem_get_ioctl(struct drm_device *dev, void *data,
 	return 0;
 }
 
-struct vm_area_struct *exynos_gem_get_vma(struct vm_area_struct *vma)
-{
-	struct vm_area_struct *vma_copy;
-
-	vma_copy = kmalloc(sizeof(*vma_copy), GFP_KERNEL);
-	if (!vma_copy)
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
-
-void exynos_gem_put_vma(struct vm_area_struct *vma)
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
-
-int exynos_gem_get_pages_from_userptr(unsigned long start,
-						unsigned int npages,
-						struct page **pages,
-						struct vm_area_struct *vma)
-{
-	int get_npages;
-
-	/* the memory region mmaped with VM_PFNMAP. */
-	if (vma_is_io(vma)) {
-		unsigned int i;
-
-		for (i = 0; i < npages; ++i, start += PAGE_SIZE) {
-			unsigned long pfn;
-			int ret = follow_pfn(vma, start, &pfn);
-			if (ret)
-				return ret;
-
-			pages[i] = pfn_to_page(pfn);
-		}
-
-		if (i != npages) {
-			DRM_ERROR("failed to get user_pages.\n");
-			return -EINVAL;
-		}
-
-		return 0;
-	}
-
-	get_npages = get_user_pages(current, current->mm, start,
-					npages, 1, 1, pages, NULL);
-	get_npages = max(get_npages, 0);
-	if (get_npages != npages) {
-		DRM_ERROR("failed to get user_pages.\n");
-		while (get_npages)
-			put_page(pages[--get_npages]);
-		return -EFAULT;
-	}
-
-	return 0;
-}
-
-void exynos_gem_put_pages_to_userptr(struct page **pages,
-					unsigned int npages,
-					struct vm_area_struct *vma)
-{
-	if (!vma_is_io(vma)) {
-		unsigned int i;
-
-		for (i = 0; i < npages; i++) {
-			set_page_dirty_lock(pages[i]);
-
-			/*
-			 * undo the reference we took when populating
-			 * the table.
-			 */
-			put_page(pages[i]);
-		}
-	}
-}
-
 int exynos_gem_map_sgt_with_dma(struct drm_device *drm_dev,
 				struct sg_table *sgt,
 				enum dma_data_direction dir)
-- 
2.1.4

