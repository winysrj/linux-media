Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbaCQTtp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 15:49:45 -0400
From: Jan Kara <jack@suse.cz>
To: linux-mm@kvack.org
Cc: linux-media@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 5/9] media: vb2: Convert vb2_vmalloc_get_userptr() to use pfns vector
Date: Mon, 17 Mar 2014 20:49:32 +0100
Message-Id: <1395085776-8626-6-git-send-email-jack@suse.cz>
In-Reply-To: <1395085776-8626-1-git-send-email-jack@suse.cz>
References: <1395085776-8626-1-git-send-email-jack@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert vb2_vmalloc_get_userptr() to use passed vector of pfns. When we
are doing that there's no need to allocate page array and some code can
be simplified.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/media/v4l2-core/videobuf2-vmalloc.c | 86 +++++++++++------------------
 1 file changed, 33 insertions(+), 53 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index ab38e054d1a0..3b4e53bd97d7 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -23,11 +23,9 @@
 
 struct vb2_vmalloc_buf {
 	void				*vaddr;
-	struct page			**pages;
-	struct vm_area_struct		*vma;
+	struct pinned_pfns		*pfns;
 	int				write;
 	unsigned long			size;
-	unsigned int			n_pages;
 	atomic_t			refcount;
 	struct vb2_vmarea_handler	handler;
 	struct dma_buf			*dbuf;
@@ -74,10 +72,8 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, struct pinned_pfns **ppfn,
 				     int write)
 {
 	struct vb2_vmalloc_buf *buf;
-	unsigned long first, last;
-	int n_pages, offset;
-	struct vm_area_struct *vma;
-	dma_addr_t physp;
+	struct pinned_pfns *pfns = *ppfn;
+	int n_pages, offset, i;
 
 	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
@@ -87,49 +83,32 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, struct pinned_pfns **ppfn,
 	offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
 
-
-	vma = find_vma(current->mm, vaddr);
-	if (vma && (vma->vm_flags & VM_PFNMAP) && (vma->vm_pgoff)) {
-		if (vb2_get_contig_userptr(vaddr, size, &vma, &physp))
-			goto fail_pages_array_alloc;
-		buf->vma = vma;
-		buf->vaddr = ioremap_nocache(physp, size);
-		if (!buf->vaddr)
-			goto fail_pages_array_alloc;
+	n_pages = pfns_vector_count(pfns);
+	if (pfns_vector_to_pages(pfns) < 0) {
+		unsigned long *nums = pfns_vector_pfns(pfns);
+
+		/*
+		 * We cannot get page pointers for these pfns. Check memory is
+ 		 * physically contiguous and use direct mapping.
+		 */
+		for (i = 1; i < n_pages; i++)
+			if (nums[i-1] + 1 != nums[i])
+				goto out_buf;
+		buf->vaddr = ioremap_nocache(nums[0] << PAGE_SHIFT, size);
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
-					 write, 1, /* force */
-					 buf->pages, NULL);
-		if (n_pages != buf->n_pages)
-			goto fail_get_user_pages;
-
-		buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1,
+		buf->vaddr = vm_map_ram(pfns_vector_pages(pfns), n_pages, -1,
 					PAGE_KERNEL);
-		if (!buf->vaddr)
-			goto fail_get_user_pages;
 	}
 
+	if (!buf->vaddr)
+		goto out_buf;
+	buf->pfns = pfns;
+	/* Clear the pointer so that the vector isn't freed by the caller */
+	*ppfn = NULL;
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
+out_buf:
 	kfree(buf);
 
 	return NULL;
@@ -140,21 +119,22 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
 	struct vb2_vmalloc_buf *buf = buf_priv;
 	unsigned long vaddr = (unsigned long)buf->vaddr & PAGE_MASK;
 	unsigned int i;
+	struct page **pages;
+	unsigned int n_pages;
 
-	if (buf->pages) {
+	if (buf->pfns->is_pages) {
+		n_pages = pfns_vector_count(buf->pfns);
+		pages = pfns_vector_pages(buf->pfns);
 		if (vaddr)
-			vm_unmap_ram((void *)vaddr, buf->n_pages);
-		for (i = 0; i < buf->n_pages; ++i) {
-			if (buf->write)
-				set_page_dirty_lock(buf->pages[i]);
-			put_page(buf->pages[i]);
-		}
-		kfree(buf->pages);
+			vm_unmap_ram((void *)vaddr, n_pages);
+		if (buf->write)
+			for (i = 0; i < n_pages; i++)
+				set_page_dirty_lock(pages[i]);
 	} else {
-		if (buf->vma)
-			vb2_put_vma(buf->vma);
 		iounmap(buf->vaddr);
 	}
+	put_vaddr_pfns(buf->pfns);
+	pfns_vector_destroy(buf->pfns);
 	kfree(buf);
 }
 
-- 
1.8.1.4

