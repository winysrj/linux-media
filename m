Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46078 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2EWMKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 08:10:50 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4H00EGA5TLFE@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 13:10:37 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H00KTG5TVMD@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 13:10:44 +0100 (BST)
Date: Wed, 23 May 2012 14:10:22 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv6 08/13] v4l: vb2-dma-contig: add support for scatterlist in
 userptr mode
In-reply-to: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337775027-9489-9-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces usage of dma_map_sg to map memory behind
a userspace pointer to a device as dma-contiguous mapping.

This patch contains some of the code kindly provided by Marek Szyprowski
<m.szyprowski@samsung.com> and Kamil Debski <k.debski@samsung.com> and Andrzej
Pietrasiewicz <andrzej.p@samsung.com>. Kind thanks for bug reports from Laurent
Pinchart <laurent.pinchart@ideasonboard.com> and Seung-Woo Kim
<sw0312.kim@samsung.com>.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf2-dma-contig.c |  268 ++++++++++++++++++++++++++--
 1 file changed, 252 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 42c6431..068ec11 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -11,6 +11,8 @@
  */
 
 #include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 
@@ -23,6 +25,8 @@ struct vb2_dc_buf {
 	void				*vaddr;
 	unsigned long			size;
 	dma_addr_t			dma_addr;
+	enum dma_data_direction		dma_dir;
+	struct sg_table			*dma_sgt;
 
 	/* MMAP related */
 	struct vb2_vmarea_handler	handler;
@@ -33,6 +37,95 @@ struct vb2_dc_buf {
 };
 
 /*********************************************/
+/*        scatterlist table functions        */
+/*********************************************/
+
+static struct sg_table *vb2_dc_pages_to_sgt(struct page **pages,
+	unsigned int n_pages, unsigned long offset, unsigned long size)
+{
+	struct sg_table *sgt;
+	unsigned int chunks;
+	unsigned int i;
+	unsigned int cur_page;
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
+		unsigned long chunk_size;
+		unsigned int j;
+
+		for (j = cur_page + 1; j < n_pages; ++j)
+			if (pages[j] != pages[j - 1] + 1)
+				break;
+
+		chunk_size = ((j - cur_page) << PAGE_SHIFT) - offset;
+		sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
+		size -= chunk_size;
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
+	unsigned int i;
+
+	for_each_sg(sgt->sgl, s, sgt->nents, i) {
+		struct page *page = sg_page(s);
+		unsigned int n_pages = PAGE_ALIGN(s->offset + s->length)
+			>> PAGE_SHIFT;
+		unsigned int j;
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
+	unsigned int i;
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
 
@@ -117,42 +210,185 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 /*       callbacks for USERPTR buffers       */
 /*********************************************/
 
+static inline int vma_is_io(struct vm_area_struct *vma)
+{
+	return !!(vma->vm_flags & (VM_IO | VM_PFNMAP));
+}
+
+static int vb2_dc_get_user_pages(unsigned long start, struct page **pages,
+	int n_pages, struct vm_area_struct *vma, int write)
+{
+	if (vma_is_io(vma)) {
+		unsigned int i;
+
+		for (i = 0; i < n_pages; ++i, start += PAGE_SIZE) {
+			unsigned long pfn;
+			int ret = follow_pfn(vma, start, &pfn);
+
+			if (ret) {
+				printk(KERN_ERR "no page for address %lu\n",
+					start);
+				return ret;
+			}
+			pages[i] = pfn_to_page(pfn);
+		}
+	} else {
+		int n;
+
+		n = get_user_pages(current, current->mm, start & PAGE_MASK,
+			n_pages, write, 1, pages, NULL);
+		/* negative error means that no page was pinned */
+		n = max(n, 0);
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
+static void vb2_dc_put_dirty_page(struct page *page)
+{
+	set_page_dirty_lock(page);
+	put_page(page);
+}
+
+static void vb2_dc_put_userptr(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	dma_unmap_sg(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
+	if (!vma_is_io(buf->vma))
+		vb2_dc_sgt_foreach_page(sgt, vb2_dc_put_dirty_page);
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
+	unsigned long start;
+	unsigned long end;
+	unsigned long offset;
+	struct page **pages;
+	int n_pages;
+	int ret = 0;
 	struct vm_area_struct *vma;
-	dma_addr_t dma_addr = 0;
-	int ret;
+	struct sg_table *sgt;
+	unsigned long contig_size;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	ret = vb2_get_contig_userptr(vaddr, size, &vma, &dma_addr);
+	buf->dev = alloc_ctx;
+	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+
+	start = vaddr & PAGE_MASK;
+	offset = vaddr & ~PAGE_MASK;
+	end = PAGE_ALIGN(vaddr + size);
+	n_pages = (end - start) >> PAGE_SHIFT;
+
+	pages = kmalloc(n_pages * sizeof pages[0], GFP_KERNEL);
+	if (!pages) {
+		ret = -ENOMEM;
+		printk(KERN_ERR "failed to allocate pages table\n");
+		goto fail_buf;
+	}
+
+	/* current->mm->mmap_sem is taken by videobuf2 core */
+	vma = find_vma(current->mm, vaddr);
+	if (!vma) {
+		printk(KERN_ERR "no vma for address %lu\n", vaddr);
+		ret = -EFAULT;
+		goto fail_pages;
+	}
+
+	if (vma->vm_end < vaddr + size) {
+		printk(KERN_ERR "vma at %lu is too small for %lu bytes\n",
+			vaddr, size);
+		ret = -EFAULT;
+		goto fail_pages;
+	}
+
+	buf->vma = vb2_get_vma(vma);
+	if (!buf->vma) {
+		printk(KERN_ERR "failed to copy vma\n");
+		ret = -ENOMEM;
+		goto fail_pages;
+	}
+
+	/* extract page list from userspace mapping */
+	ret = vb2_dc_get_user_pages(start, pages, n_pages, vma, write);
 	if (ret) {
-		printk(KERN_ERR "Failed acquiring VMA for vaddr 0x%08lx\n",
-				vaddr);
-		kfree(buf);
-		return ERR_PTR(ret);
+		printk(KERN_ERR "failed to get user pages\n");
+		goto fail_vma;
+	}
+
+	sgt = vb2_dc_pages_to_sgt(pages, n_pages, offset, size);
+	if (IS_ERR(sgt)) {
+		printk(KERN_ERR "failed to create scatterlist table\n");
+		ret = -ENOMEM;
+		goto fail_get_user_pages;
 	}
 
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
 	buf->size = size;
-	buf->dma_addr = dma_addr;
-	buf->vma = vma;
+	buf->dma_sgt = sgt;
 
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
 
+fail_get_user_pages:
+	if (pages && !vma_is_io(buf->vma))
+		while (n_pages)
+			put_page(pages[--n_pages]);
+
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
1.7.9.5

