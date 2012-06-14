Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30886 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab2FNOcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 10:32:41 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5M00AL7338QK80@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 15:33:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M5M00COX32BHO@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 15:32:36 +0100 (BST)
Date: Thu, 14 Jun 2012 16:32:25 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 5/9] v4l: vb2-dma-contig: add support for DMABUF exporting
In-reply-to: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1339684349-28882-6-git-send-email-t.stanislaws@samsung.com>
Content-transfer-encoding: 7BIT
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for exporting a dma-contig buffer using
DMABUF interface.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |  248 ++++++++++++++++++++++++++++
 1 file changed, 248 insertions(+)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 00b776c..a845ff7 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -36,6 +36,7 @@ struct vb2_dc_buf {
 	/* MMAP related */
 	struct vb2_vmarea_handler	handler;
 	atomic_t			refcount;
+	struct sg_table			*sgt_base;
 
 	/* USERPTR related */
 	struct vm_area_struct		*vma;
@@ -142,6 +143,10 @@ static void vb2_dc_put(void *buf_priv)
 	if (!atomic_dec_and_test(&buf->refcount))
 		return;
 
+	if (buf->sgt_base) {
+		sg_free_table(buf->sgt_base);
+		kfree(buf->sgt_base);
+	}
 	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
 	kfree(buf);
 }
@@ -213,6 +218,248 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 }
 
 /*********************************************/
+/*         DMABUF ops for exporters          */
+/*********************************************/
+
+struct vb2_dc_attachment {
+	struct sg_table sgt;
+	enum dma_data_direction dir;
+};
+
+static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
+	struct dma_buf_attachment *dbuf_attach)
+{
+	struct vb2_dc_attachment *attach;
+	unsigned int i;
+	struct scatterlist *rd, *wr;
+	struct sg_table *sgt;
+	struct vb2_dc_buf *buf = dbuf->priv;
+	int ret;
+
+	attach = kzalloc(sizeof *attach, GFP_KERNEL);
+	if (!attach)
+		return -ENOMEM;
+
+	sgt = &attach->sgt;
+	/* Copy the buf->base_sgt scatter list to the attachment, as we can't
+	 * map the same scatter list to multiple attachments at the same time.
+	 */
+	ret = sg_alloc_table(sgt, buf->sgt_base->orig_nents, GFP_KERNEL);
+	if (ret) {
+		kfree(attach);
+		return -ENOMEM;
+	}
+
+	rd = buf->sgt_base->sgl;
+	wr = sgt->sgl;
+	for (i = 0; i < sgt->orig_nents; ++i) {
+		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
+		rd = sg_next(rd);
+		wr = sg_next(wr);
+	}
+
+	attach->dir = DMA_NONE;
+	dbuf_attach->priv = attach;
+
+	return 0;
+}
+
+static void vb2_dc_dmabuf_ops_detach(struct dma_buf *dbuf,
+	struct dma_buf_attachment *db_attach)
+{
+	struct vb2_dc_attachment *attach = db_attach->priv;
+	struct sg_table *sgt;
+
+	if (!attach)
+		return;
+
+	sgt = &attach->sgt;
+
+	/* release the scatterlist cache */
+	if (attach->dir != DMA_NONE)
+		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
+			attach->dir);
+	sg_free_table(sgt);
+	kfree(attach);
+	db_attach->priv = NULL;
+}
+
+static struct sg_table *vb2_dc_dmabuf_ops_map(
+	struct dma_buf_attachment *db_attach, enum dma_data_direction dir)
+{
+	struct vb2_dc_attachment *attach = db_attach->priv;
+	/* stealing dmabuf mutex to serialize map/unmap operations */
+	struct mutex *lock = &db_attach->dmabuf->lock;
+	struct sg_table *sgt;
+	int ret;
+
+	mutex_lock(lock);
+
+	sgt = &attach->sgt;
+	/* return previously mapped sg table */
+	if (attach->dir == dir) {
+		mutex_unlock(lock);
+		return sgt;
+	}
+
+	/* release any previous cache */
+	if (attach->dir != DMA_NONE) {
+		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
+			attach->dir);
+		attach->dir = DMA_NONE;
+	}
+
+	/* mapping to the client with new direction */
+	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dir);
+	if (ret <= 0) {
+		printk(KERN_ERR "failed to map scatterlist\n");
+		mutex_unlock(lock);
+		return ERR_PTR(-EIO);
+	}
+
+	attach->dir = dir;
+
+	mutex_unlock(lock);
+
+	return sgt;
+}
+
+static void vb2_dc_dmabuf_ops_unmap(struct dma_buf_attachment *db_attach,
+	struct sg_table *sgt, enum dma_data_direction dir)
+{
+	/* nothing to be done here */
+}
+
+static void vb2_dc_dmabuf_ops_release(struct dma_buf *dbuf)
+{
+	/* drop reference obtained in vb2_dc_get_dmabuf */
+	vb2_dc_put(dbuf->priv);
+}
+
+static void *vb2_dc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
+{
+	struct vb2_dc_buf *buf = dbuf->priv;
+
+	return buf->vaddr + pgnum * PAGE_SIZE;
+}
+
+static void *vb2_dc_dmabuf_ops_vmap(struct dma_buf *dbuf)
+{
+	struct vb2_dc_buf *buf = dbuf->priv;
+
+	return buf->vaddr;
+}
+
+static struct dma_buf_ops vb2_dc_dmabuf_ops = {
+	.attach = vb2_dc_dmabuf_ops_attach,
+	.detach = vb2_dc_dmabuf_ops_detach,
+	.map_dma_buf = vb2_dc_dmabuf_ops_map,
+	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
+	.kmap = vb2_dc_dmabuf_ops_kmap,
+	.kmap_atomic = vb2_dc_dmabuf_ops_kmap,
+	.vmap = vb2_dc_dmabuf_ops_vmap,
+	.release = vb2_dc_dmabuf_ops_release,
+};
+
+/**
+ * vb2_dc_kaddr_to_pages() - extract list of struct pages from a kernel
+ * pointer.  This function is a workaround to extract pages from a pointer
+ * returned by dma_alloc_coherent. The pages are obtained by creating an
+ * artificial vma and using follow_pfn to do a page walk to find a PFN
+ */
+static int vb2_dc_kaddr_to_pages(unsigned long kaddr,
+	struct page **pages, unsigned int n_pages)
+{
+	unsigned int i;
+	unsigned long pfn;
+	/* create an artificial VMA */
+	struct vm_area_struct vma = {
+		.vm_flags = VM_IO | VM_PFNMAP,
+		.vm_mm = &init_mm,
+	};
+
+	for (i = 0; i < n_pages; ++i, kaddr += PAGE_SIZE) {
+		if (follow_pfn(&vma, kaddr, &pfn))
+			break;
+		pages[i] = pfn_to_page(pfn);
+	}
+
+	return i;
+}
+
+static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
+{
+	int n_pages;
+	struct page **pages = NULL;
+	int ret;
+	struct sg_table *sgt;
+
+	n_pages = PAGE_ALIGN(buf->size) >> PAGE_SHIFT;
+
+	pages = kmalloc(n_pages * sizeof pages[0], GFP_KERNEL);
+	if (!pages) {
+		dev_err(buf->dev, "failed to alloc page table\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ret = vb2_dc_kaddr_to_pages((unsigned long)buf->vaddr, pages, n_pages);
+	if (ret < 0) {
+		dev_err(buf->dev, "failed to get buffer pages from DMA API\n");
+		kfree(pages);
+		return ERR_PTR(ret);
+	}
+	if (ret != n_pages) {
+		dev_err(buf->dev, "got only %d of %d pages from DMA API\n",
+			ret, n_pages);
+		kfree(pages);
+		return ERR_PTR(-EFAULT);
+	}
+
+	sgt = kmalloc(sizeof *sgt, GFP_KERNEL);
+	if (!sgt) {
+		dev_err(buf->dev, "failed to alloc sg table\n");
+		kfree(pages);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ret = sg_alloc_table_from_pages(sgt, pages, n_pages, 0,
+		buf->size, GFP_KERNEL);
+	/* failure or not, pages are no longer needed */
+	kfree(pages);
+	if (ret) {
+		dev_err(buf->dev, "failed to covert pages to sg table\n");
+		kfree(sgt);
+		return ERR_PTR(ret);
+	}
+
+	return sgt;
+}
+
+static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+	struct dma_buf *dbuf;
+	struct sg_table *sgt = buf->sgt_base;
+
+	if (!sgt)
+		sgt = vb2_dc_get_base_sgt(buf);
+	if (WARN_ON(IS_ERR(sgt)))
+		return NULL;
+
+	/* cache base sgt for future use */
+	buf->sgt_base = sgt;
+
+	dbuf = dma_buf_export(buf, &vb2_dc_dmabuf_ops, buf->size, 0);
+	if (IS_ERR(dbuf))
+		return NULL;
+
+	/* dmabuf keeps reference to vb2 buffer */
+	atomic_inc(&buf->refcount);
+
+	return dbuf;
+}
+
+/*********************************************/
 /*       callbacks for USERPTR buffers       */
 /*********************************************/
 
@@ -522,6 +769,7 @@ static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 const struct vb2_mem_ops vb2_dma_contig_memops = {
 	.alloc		= vb2_dc_alloc,
 	.put		= vb2_dc_put,
+	.get_dmabuf	= vb2_dc_get_dmabuf,
 	.cookie		= vb2_dc_cookie,
 	.vaddr		= vb2_dc_vaddr,
 	.mmap		= vb2_dc_mmap,
-- 
1.7.9.5

