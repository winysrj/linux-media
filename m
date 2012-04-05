Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30891 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2DEOAg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 10:00:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2000870EWHBP70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:17 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2000IDPEWUVF@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:31 +0100 (BST)
Date: Thu, 05 Apr 2012 16:00:05 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 08/11] v4l: vb2-dma-contig: add support for scatterlist in
 userptr mode
In-reply-to: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Message-id: <1333634408-4960-9-git-send-email-t.stanislaws@samsung.com>
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

This patch introduces usage of dma_map_sg to map memory behind
a userspace pointer to a device as dma-contiguous mapping.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
	[bugfixing]
Signed-off-by: Kamil Debski <k.debski@samsung.com>
	[bugfixing]
Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
	[add sglist subroutines/code refactoring]
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |  282 ++++++++++++++++++++++++++--
 1 files changed, 265 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 476e536..6ab3165 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -11,6 +11,8 @@
  */
 
 #include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 
@@ -22,6 +24,8 @@ struct vb2_dc_buf {
 	void				*vaddr;
 	unsigned long			size;
 	dma_addr_t			dma_addr;
+	enum dma_data_direction		dma_dir;
+	struct sg_table			*dma_sgt;
 
 	/* MMAP related */
 	struct vb2_vmarea_handler	handler;
@@ -32,6 +36,98 @@ struct vb2_dc_buf {
 };
 
 /*********************************************/
+/*        scatterlist table functions        */
+/*********************************************/
+
+static struct sg_table *vb2_dc_pages_to_sgt(struct page **pages,
+	unsigned long n_pages, size_t offset, size_t offset2)
+{
+	struct sg_table *sgt;
+	int i, j; /* loop counters */
+	int cur_page, chunks;
+	int ret;
+	struct scatterlist *s;
+
+	sgt = kzalloc(sizeof *sgt, GFP_KERNEL);
+	if (!sgt)
+		return ERR_PTR(-ENOMEM);
+
+	/* compute number of chunks */
+	chunks = 1;
+	for (i = 1; i < n_pages; ++i)
+		if (pages[i] != pages[i - 1] + 1)
+			++chunks;
+
+	ret = sg_alloc_table(sgt, chunks, GFP_KERNEL);
+	if (ret) {
+		kfree(sgt);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* merging chunks and putting them into the scatterlist */
+	cur_page = 0;
+	for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
+		size_t size = PAGE_SIZE;
+
+		for (j = cur_page + 1; j < n_pages; ++j) {
+			if (pages[j] != pages[j - 1] + 1)
+				break;
+			size += PAGE_SIZE;
+		}
+
+		/* cut offset if chunk starts at the first page */
+		if (cur_page == 0)
+			size -= offset;
+		/* cut offset2 if chunk ends at the last page */
+		if (j == n_pages)
+			size -= offset2;
+
+		sg_set_page(s, pages[cur_page], size, offset);
+		offset = 0;
+		cur_page = j;
+	}
+
+	return sgt;
+}
+
+static void vb2_dc_release_sgtable(struct sg_table *sgt)
+{
+	sg_free_table(sgt);
+	kfree(sgt);
+}
+
+static void vb2_dc_sgt_foreach_page(struct sg_table *sgt,
+	void (*cb)(struct page *pg))
+{
+	struct scatterlist *s;
+	int i, j;
+
+	for_each_sg(sgt->sgl, s, sgt->nents, i) {
+		struct page *page = sg_page(s);
+		int n_pages = PAGE_ALIGN(s->offset + s->length) >> PAGE_SHIFT;
+
+		for (j = 0; j < n_pages; ++j, ++page)
+			cb(page);
+	}
+}
+
+static unsigned long vb2_dc_get_contiguous_size(struct sg_table *sgt)
+{
+	struct scatterlist *s;
+	dma_addr_t expected = sg_dma_address(sgt->sgl);
+	int i;
+	unsigned long size = 0;
+
+	for_each_sg(sgt->sgl, s, sgt->nents, i) {
+		if (sg_dma_address(s) != expected)
+			break;
+		expected = sg_dma_address(s) + sg_dma_len(s);
+		size += sg_dma_len(s);
+	}
+	return size;
+}
+
+/*********************************************/
 /*         callbacks for all buffers         */
 /*********************************************/
 
@@ -116,42 +212,194 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 /*       callbacks for USERPTR buffers       */
 /*********************************************/
 
+static inline int vma_is_io(struct vm_area_struct *vma)
+{
+	return !!(vma->vm_flags & (VM_IO | VM_PFNMAP));
+}
+
+static struct vm_area_struct *vb2_dc_get_user_vma(
+	unsigned long start, unsigned long size)
+{
+	struct vm_area_struct *vma;
+
+	/* current->mm->mmap_sem is taken by videobuf2 core */
+	vma = find_vma(current->mm, start);
+	if (!vma) {
+		printk(KERN_ERR "no vma for address %lu\n", start);
+		return ERR_PTR(-EFAULT);
+	}
+
+	if (vma->vm_end - vma->vm_start < size) {
+		printk(KERN_ERR "vma at %lu is too small for %lu bytes\n",
+			start, size);
+		return ERR_PTR(-EFAULT);
+	}
+
+	vma = vb2_get_vma(vma);
+	if (!vma) {
+		printk(KERN_ERR "failed to copy vma\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return vma;
+}
+
+static int vb2_dc_get_user_pages(unsigned long start, struct page **pages,
+	int n_pages, struct vm_area_struct *vma, int write)
+{
+	int n;
+
+	if (vma_is_io(vma)) {
+		for (n = 0; n < n_pages; ++n, start += PAGE_SIZE) {
+			unsigned long pfn;
+			int ret = follow_pfn(vma, start, &pfn);
+
+			if (ret) {
+				printk(KERN_ERR "no page for address %lu\n",
+					start);
+				return ret;
+			}
+			pages[n] = pfn_to_page(pfn);
+		}
+	} else {
+		n = get_user_pages(current, current->mm, start & PAGE_MASK,
+			n_pages, write, 1, pages, NULL);
+		if (n != n_pages) {
+			printk(KERN_ERR "got only %d of %d user pages\n",
+				n, n_pages);
+			while (n)
+				put_page(pages[--n]);
+			return -EFAULT;
+		}
+	}
+
+	return 0;
+}
+
+static void vb2_dc_set_page_dirty(struct page *page)
+{
+	set_page_dirty_lock(page);
+}
+
+static void vb2_dc_put_userptr(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	dma_unmap_sg(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
+	if (!vma_is_io(buf->vma)) {
+		vb2_dc_sgt_foreach_page(sgt, vb2_dc_set_page_dirty);
+		vb2_dc_sgt_foreach_page(sgt, put_page);
+	}
+
+	vb2_dc_release_sgtable(sgt);
+	vb2_put_vma(buf->vma);
+	kfree(buf);
+}
+
 static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
-					unsigned long size, int write)
+	unsigned long size, int write)
 {
 	struct vb2_dc_buf *buf;
-	struct vm_area_struct *vma;
-	dma_addr_t dma_addr = 0;
-	int ret;
+	unsigned long start, end, offset, offset2;
+	struct page **pages;
+	int n_pages;
+	int ret = 0;
+	struct sg_table *sgt;
+	unsigned long contig_size;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	ret = vb2_get_contig_userptr(vaddr, size, &vma, &dma_addr);
+	buf->dev = alloc_ctx;
+	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+
+	start = (unsigned long)vaddr & PAGE_MASK;
+	offset = (unsigned long)vaddr & ~PAGE_MASK;
+	end = PAGE_ALIGN((unsigned long)vaddr + size);
+	offset2 = end - (unsigned long)vaddr - size;
+	n_pages = (end - start) >> PAGE_SHIFT;
+
+	pages = kmalloc(n_pages * sizeof pages[0], GFP_KERNEL);
+	if (!pages) {
+		ret = -ENOMEM;
+		printk(KERN_ERR "failed to allocate pages table\n");
+		goto fail_buf;
+	}
+
+	buf->vma = vb2_dc_get_user_vma(start, end - start);
+	if (IS_ERR(buf->vma)) {
+		printk(KERN_ERR "failed to get VMA\n");
+		ret = PTR_ERR(buf->vma);
+		goto fail_pages;
+	}
+
+	/* extract page list from userspace mapping */
+	ret = vb2_dc_get_user_pages(start, pages, n_pages, buf->vma, write);
 	if (ret) {
-		printk(KERN_ERR "Failed acquiring VMA for vaddr 0x%08lx\n",
-				vaddr);
-		kfree(buf);
-		return ERR_PTR(ret);
+		printk(KERN_ERR "failed to get user pages\n");
+		goto fail_vma;
+	}
+
+	sgt = vb2_dc_pages_to_sgt(pages, n_pages, offset, offset2);
+	if (IS_ERR(sgt)) {
+		printk(KERN_ERR "failed to create scatterlist table\n");
+		ret = -ENOMEM;
+		goto fail_get_user_pages;
+	}
+
+	/* pages are no longer needed */
+	kfree(pages);
+	pages = NULL;
+
+	sgt->nents = dma_map_sg(buf->dev, sgt->sgl, sgt->orig_nents,
+		buf->dma_dir);
+	if (sgt->nents <= 0) {
+		printk(KERN_ERR "failed to map scatterlist\n");
+		ret = -EIO;
+		goto fail_sgt;
+	}
+
+	contig_size = vb2_dc_get_contiguous_size(sgt);
+	if (contig_size < size) {
+		printk(KERN_ERR "contiguous mapping is too small %lu/%lu\n",
+			contig_size, size);
+		ret = -EFAULT;
+		goto fail_map_sg;
 	}
 
+	buf->dma_addr = sg_dma_address(sgt->sgl);
 	buf->size = size;
-	buf->dma_addr = dma_addr;
-	buf->vma = vma;
+	buf->dma_sgt = sgt;
+
+	atomic_inc(&buf->refcount);
 
 	return buf;
-}
 
-static void vb2_dc_put_userptr(void *mem_priv)
-{
-	struct vb2_dc_buf *buf = mem_priv;
+fail_map_sg:
+	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 
-	if (!buf)
-		return;
+fail_sgt:
+	if (!vma_is_io(buf->vma))
+		vb2_dc_sgt_foreach_page(sgt, put_page);
+	vb2_dc_release_sgtable(sgt);
+
+fail_get_user_pages:
+	if (pages && !vma_is_io(buf->vma))
+		while (n_pages)
+			put_page(pages[--n_pages]);
 
+fail_vma:
 	vb2_put_vma(buf->vma);
+
+fail_pages:
+	kfree(pages); /* kfree is NULL-proof */
+
+fail_buf:
 	kfree(buf);
+
+	return ERR_PTR(ret);
 }
 
 /*********************************************/
-- 
1.7.5.4

