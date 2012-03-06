Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22414 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101Ab2CFLiQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 06:38:16 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0G00J5AOBQ8P80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:15 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0G0071NOBQLO@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:14 +0000 (GMT)
Date: Tue, 06 Mar 2012 12:38:03 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFCv2 PATCH 2/9] v4l: vb2-dma-contig: update and code refactoring
In-reply-to: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Message-id: <1331033890-10350-3-git-send-email-t.stanislaws@samsung.com>
References: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch combines updates and fixes to dma-contig allocator.
Moreover the allocator code was refactored.
The most important changes are:
- functions were reordered
- move compression of scatterlist to separete function
- add support for multichunk but contiguous scatterlists
- simplified implementation of vb2-dma-contig context structure
- let mmap method to use dma_mmap_writecombine
- add support for scatterlist in userptr mode

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
	[mmap method]
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
	[scatterlist in userptr mode]
Signed-off-by: Kamil Debski <k.debski@samsung.com>
	[bugfixing]
Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
	[core refactoring, helper functions]
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |  495 +++++++++++++++++++++++-----
 1 files changed, 414 insertions(+), 81 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index f17ad98..c1dc043 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -10,173 +10,506 @@
  * the Free Software Foundation.
  */
 
+#include <linux/dma-buf.h>
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/dma-mapping.h>
 
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-memops.h>
 
-struct vb2_dc_conf {
-	struct device		*dev;
-};
-
 struct vb2_dc_buf {
-	struct vb2_dc_conf		*conf;
+	struct device			*dev;
 	void				*vaddr;
-	dma_addr_t			dma_addr;
 	unsigned long			size;
-	struct vm_area_struct		*vma;
-	atomic_t			refcount;
+	dma_addr_t			dma_addr;
+	struct sg_table			*dma_sgt;
+	enum dma_data_direction		dma_dir;
+
+	/* MMAP related */
 	struct vb2_vmarea_handler	handler;
+	atomic_t			refcount;
+	struct sg_table			*sgt_base;
+
+	/* USERPTR related */
+	struct vm_area_struct		*vma;
 };
 
-static void vb2_dma_contig_put(void *buf_priv);
+/*********************************************/
+/*        scatterlist table functions        */
+/*********************************************/
 
-static void *vb2_dma_contig_alloc(void *alloc_ctx, unsigned long size)
+static struct sg_table *vb2_dc_pages_to_sgt(struct page **pages,
+	unsigned long n_pages, size_t offset, size_t offset2)
 {
-	struct vb2_dc_conf *conf = alloc_ctx;
-	struct vb2_dc_buf *buf;
+	struct sg_table *sgt;
+	int i, j; /* loop counters */
+	int cur_page, chunks;
+	int ret;
+	struct scatterlist *s;
 
-	buf = kzalloc(sizeof *buf, GFP_KERNEL);
-	if (!buf)
+	sgt = kzalloc(sizeof *sgt, GFP_KERNEL);
+	if (!sgt)
 		return ERR_PTR(-ENOMEM);
 
-	buf->vaddr = dma_alloc_coherent(conf->dev, size, &buf->dma_addr,
-					GFP_KERNEL);
-	if (!buf->vaddr) {
-		dev_err(conf->dev, "dma_alloc_coherent of size %ld failed\n",
-			size);
-		kfree(buf);
+	/* compute number of chunks */
+	chunks = 1;
+	for (i = 1; i < n_pages; ++i)
+		if (pages[i] != pages[i - 1] + 1)
+			++chunks;
+
+	ret = sg_alloc_table(sgt, chunks, GFP_KERNEL);
+	if (ret) {
+		kfree(sgt);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	buf->conf = conf;
-	buf->size = size;
-
-	buf->handler.refcount = &buf->refcount;
-	buf->handler.put = vb2_dma_contig_put;
-	buf->handler.arg = buf;
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
 
-	atomic_inc(&buf->refcount);
+	return sgt;
+}
 
-	return buf;
+static void vb2_dc_release_sgtable(struct sg_table *sgt)
+{
+	sg_free_table(sgt);
+	kfree(sgt);
 }
 
-static void vb2_dma_contig_put(void *buf_priv)
+static void vb2_dc_put_sgtable(struct sg_table *sgt, int dirty)
 {
-	struct vb2_dc_buf *buf = buf_priv;
+	struct scatterlist *s;
+	int i, j;
+
+	for_each_sg(sgt->sgl, s, sgt->nents, i) {
+		struct page *page = sg_page(s);
+		int n_pages = PAGE_ALIGN(s->offset + s->length) >> PAGE_SHIFT;
+
+		for (j = 0; j < n_pages; ++j, ++page) {
+			if (dirty)
+				set_page_dirty_lock(page);
+			put_page(page);
+		}
+	}
+
+	vb2_dc_release_sgtable(sgt);
+}
 
-	if (atomic_dec_and_test(&buf->refcount)) {
-		dma_free_coherent(buf->conf->dev, buf->size, buf->vaddr,
-				  buf->dma_addr);
-		kfree(buf);
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
 	}
+	return size;
 }
 
-static void *vb2_dma_contig_cookie(void *buf_priv)
+/*********************************************/
+/*         callbacks for all buffers         */
+/*********************************************/
+
+static void *vb2_dc_cookie(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
 	return &buf->dma_addr;
 }
 
-static void *vb2_dma_contig_vaddr(void *buf_priv)
+static void *vb2_dc_vaddr(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
-	if (!buf)
-		return 0;
 
 	return buf->vaddr;
 }
 
-static unsigned int vb2_dma_contig_num_users(void *buf_priv)
+static unsigned int vb2_dc_num_users(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
 	return atomic_read(&buf->refcount);
 }
 
-static int vb2_dma_contig_mmap(void *buf_priv, struct vm_area_struct *vma)
+static void vb2_dc_prepare(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
+	struct sg_table *sgt = buf->dma_sgt;
 
-	if (!buf) {
-		printk(KERN_ERR "No buffer to map\n");
-		return -EINVAL;
-	}
+	if (!sgt)
+		return;
+
+	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+}
+
+static void vb2_dc_finish(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	if (!sgt)
+		return;
+
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+}
+
+/*********************************************/
+/*        callbacks for MMAP buffers         */
+/*********************************************/
+
+static void vb2_dc_put(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
 
-	return vb2_mmap_pfn_range(vma, buf->dma_addr, buf->size,
-				  &vb2_common_vm_ops, &buf->handler);
+	if (!atomic_dec_and_test(&buf->refcount))
+		return;
+
+	vb2_dc_release_sgtable(buf->sgt_base);
+	dma_free_coherent(buf->dev, buf->size, buf->vaddr,
+		buf->dma_addr);
+	kfree(buf);
 }
 
-static void *vb2_dma_contig_get_userptr(void *alloc_ctx, unsigned long vaddr,
-					unsigned long size, int write)
+static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 {
+	struct device *dev = alloc_ctx;
 	struct vb2_dc_buf *buf;
-	struct vm_area_struct *vma;
-	dma_addr_t dma_addr = 0;
 	int ret;
+	int n_pages;
+	struct page **pages = NULL;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	ret = vb2_get_contig_userptr(vaddr, size, &vma, &dma_addr);
-	if (ret) {
-		printk(KERN_ERR "Failed acquiring VMA for vaddr 0x%08lx\n",
-				vaddr);
-		kfree(buf);
-		return ERR_PTR(ret);
+	buf->dev = dev;
+	buf->size = size;
+	buf->vaddr = dma_alloc_coherent(buf->dev, buf->size, &buf->dma_addr,
+		GFP_KERNEL);
+
+	ret = -ENOMEM;
+	if (!buf->vaddr) {
+		dev_err(dev, "dma_alloc_coherent of size %ld failed\n",
+			size);
+		goto fail_buf;
 	}
 
-	buf->size = size;
-	buf->dma_addr = dma_addr;
-	buf->vma = vma;
+	WARN_ON((unsigned long)buf->vaddr & ~PAGE_MASK);
+	WARN_ON(buf->dma_addr & ~PAGE_MASK);
+
+	n_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+
+	pages = kmalloc(n_pages * sizeof pages[0], GFP_KERNEL);
+	if (!pages) {
+		printk(KERN_ERR "failed to alloc page table\n");
+		goto fail_dma;
+	}
+
+	ret = dma_get_pages(dev, buf->vaddr, buf->dma_addr, pages, n_pages);
+	if (ret < 0) {
+		printk(KERN_ERR "failed to get buffer pages from DMA API\n");
+		goto fail_pages;
+	}
+	if (ret != n_pages) {
+		ret = -EFAULT;
+		printk(KERN_ERR "failed to get all pages from DMA API\n");
+		goto fail_pages;
+	}
+
+	buf->sgt_base = vb2_dc_pages_to_sgt(pages, n_pages, 0, 0);
+	if (IS_ERR(buf->sgt_base)) {
+		ret = PTR_ERR(buf->sgt_base);
+		printk(KERN_ERR "failed to prepare sg table\n");
+		goto fail_pages;
+	}
+
+	/* pages are no longer needed */
+	kfree(pages);
+
+	buf->handler.refcount = &buf->refcount;
+	buf->handler.put = vb2_dc_put;
+	buf->handler.arg = buf;
+
+	atomic_inc(&buf->refcount);
 
 	return buf;
+
+fail_pages:
+	kfree(pages);
+
+fail_dma:
+	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
+
+fail_buf:
+	kfree(buf);
+
+	return ERR_PTR(ret);
+}
+
+static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+	int ret;
+
+	/*
+	 * dma_mmap_* uses vm_pgoff as in-buffer offset, but we want to
+	 * map whole buffer
+	 */
+	vma->vm_pgoff = 0;
+
+	ret = dma_mmap_writecombine(buf->dev, vma, buf->vaddr,
+		buf->dma_addr, buf->size);
+
+	if (ret) {
+		printk(KERN_ERR "Remapping memory failed, error: %d\n", ret);
+		return ret;
+	}
+
+	vma->vm_flags		|= VM_DONTEXPAND | VM_RESERVED;
+	vma->vm_private_data	= &buf->handler;
+	vma->vm_ops		= &vb2_common_vm_ops;
+
+	vma->vm_ops->open(vma);
+
+	printk(KERN_DEBUG "%s: mapped dma addr 0x%08lx at 0x%08lx, size %ld\n",
+		__func__, (unsigned long)buf->dma_addr, vma->vm_start,
+		buf->size);
+
+	return 0;
 }
 
-static void vb2_dma_contig_put_userptr(void *mem_priv)
+/*********************************************/
+/*       callbacks for USERPTR buffers       */
+/*********************************************/
+
+static inline int vma_is_io(struct vm_area_struct *vma)
 {
-	struct vb2_dc_buf *buf = mem_priv;
+	return !!(vma->vm_flags & (VM_IO | VM_PFNMAP));
+}
 
+static int vb2_dc_get_pages(unsigned long start, struct page **pages,
+	int n_pages, struct vm_area_struct **copy_vma, int write)
+{
+	struct vm_area_struct *vma;
+	int n = 0; /* number of get pages */
+	int ret = -EFAULT;
+
+	/* entering critical section for mm access */
+	down_read(&current->mm->mmap_sem);
+
+	vma = find_vma(current->mm, start);
+	if (!vma) {
+		printk(KERN_ERR "no vma for address %lu\n", start);
+		goto cleanup;
+	}
+
+	if (vma_is_io(vma)) {
+		unsigned long pfn;
+
+		if (vma->vm_end - start < n_pages * PAGE_SIZE) {
+			printk(KERN_ERR "vma is too small\n");
+			goto cleanup;
+		}
+
+		for (n = 0; n < n_pages; ++n, start += PAGE_SIZE) {
+			ret = follow_pfn(vma, start, &pfn);
+			if (ret) {
+				printk(KERN_ERR "no page for address %lu\n",
+					start);
+				goto cleanup;
+			}
+			pages[n] = pfn_to_page(pfn);
+			get_page(pages[n]);
+		}
+	} else {
+		n = get_user_pages(current, current->mm, start & PAGE_MASK,
+			n_pages, write, 1, pages, NULL);
+		if (n != n_pages) {
+			printk(KERN_ERR "got only %d of %d user pages\n",
+				n, n_pages);
+			goto cleanup;
+		}
+	}
+
+	*copy_vma = vb2_get_vma(vma);
+	if (!*copy_vma) {
+		printk(KERN_ERR "failed to copy vma\n");
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	/* leaving critical section for mm access */
+	up_read(&current->mm->mmap_sem);
+
+	return 0;
+
+cleanup:
+	up_read(&current->mm->mmap_sem);
+
+	/* putting user pages if used, can be done wothout the lock */
+	while (n)
+		put_page(pages[--n]);
+
+	return ret;
+}
+
+static void vb2_dc_put_userptr(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	dma_unmap_sg(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
+	vb2_dc_put_sgtable(sgt, !vma_is_io(buf->vma));
+	vb2_put_vma(buf->vma);
+	kfree(buf);
+}
+
+static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
+	unsigned long size, int write)
+{
+	struct vb2_dc_buf *buf;
+	unsigned long start, end, offset, offset2;
+	struct page **pages;
+	int n_pages;
+	int ret = 0;
+	struct sg_table *sgt;
+	unsigned long contig_size;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
-		return;
+		return ERR_PTR(-ENOMEM);
+
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
+	/* extract page list from userspace mapping */
+	ret = vb2_dc_get_pages(start, pages, n_pages, &buf->vma, write);
+	if (ret) {
+		printk(KERN_ERR "failed to get user pages\n");
+		goto fail_pages;
+	}
+
+	sgt = vb2_dc_pages_to_sgt(pages, n_pages, offset, offset2);
+	if (!sgt) {
+		printk(KERN_ERR "failed to create scatterlist table\n");
+		ret = -ENOMEM;
+		goto fail_get_pages;
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
+	}
+
+	buf->dma_addr = sg_dma_address(sgt->sgl);
+	buf->size = size;
+	buf->dma_sgt = sgt;
+
+	atomic_inc(&buf->refcount);
+
+	return buf;
+
+fail_map_sg:
+	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 
+fail_sgt:
+	vb2_dc_put_sgtable(sgt, 0);
+
+fail_get_pages:
+	while (pages && n_pages)
+		put_page(pages[--n_pages]);
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
 
+/*********************************************/
+/*       DMA CONTIG exported functions       */
+/*********************************************/
+
 const struct vb2_mem_ops vb2_dma_contig_memops = {
-	.alloc		= vb2_dma_contig_alloc,
-	.put		= vb2_dma_contig_put,
-	.cookie		= vb2_dma_contig_cookie,
-	.vaddr		= vb2_dma_contig_vaddr,
-	.mmap		= vb2_dma_contig_mmap,
-	.get_userptr	= vb2_dma_contig_get_userptr,
-	.put_userptr	= vb2_dma_contig_put_userptr,
-	.num_users	= vb2_dma_contig_num_users,
+	.alloc		= vb2_dc_alloc,
+	.put		= vb2_dc_put,
+	.cookie		= vb2_dc_cookie,
+	.vaddr		= vb2_dc_vaddr,
+	.mmap		= vb2_dc_mmap,
+	.get_userptr	= vb2_dc_get_userptr,
+	.put_userptr	= vb2_dc_put_userptr,
+	.prepare	= vb2_dc_prepare,
+	.finish		= vb2_dc_finish,
+	.num_users	= vb2_dc_num_users,
 };
 EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
 
 void *vb2_dma_contig_init_ctx(struct device *dev)
 {
-	struct vb2_dc_conf *conf;
-
-	conf = kzalloc(sizeof *conf, GFP_KERNEL);
-	if (!conf)
-		return ERR_PTR(-ENOMEM);
-
-	conf->dev = dev;
-
-	return conf;
+	return dev;
 }
 EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
 
 void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
 {
-	kfree(alloc_ctx);
 }
 EXPORT_SYMBOL_GPL(vb2_dma_contig_cleanup_ctx);
 
-- 
1.7.5.4

