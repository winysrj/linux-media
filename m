Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:59692 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbaKGIuq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 03:50:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	Hans Verkuil <hansverk@cisco.com>
Subject: [RFCv5 PATCH 06/15] vb2-vmalloc: add get_dmabuf support
Date: Fri,  7 Nov 2014 09:50:25 +0100
Message-Id: <1415350234-9826-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
References: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Add support for DMABUF exporting to the vb2-vmalloc implementation.

All memory models now have support for both importing and exporting of DMABUFs.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-vmalloc.c | 174 ++++++++++++++++++++++++++++
 1 file changed, 174 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index d77e397..437fbcd 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -31,6 +31,9 @@ struct vb2_vmalloc_buf {
 	atomic_t			refcount;
 	struct vb2_vmarea_handler	handler;
 	struct dma_buf			*dbuf;
+
+	/* DMABUF related */
+	struct dma_buf_attachment	*db_attach;
 };
 
 static void vb2_vmalloc_put(void *buf_priv);
@@ -210,6 +213,176 @@ static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
 }
 
 /*********************************************/
+/*         DMABUF ops for exporters          */
+/*********************************************/
+
+struct vb2_vmalloc_attachment {
+	struct sg_table sgt;
+	enum dma_data_direction dir;
+};
+
+static int vb2_vmalloc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
+	struct dma_buf_attachment *dbuf_attach)
+{
+	struct vb2_vmalloc_attachment *attach;
+	struct vb2_vmalloc_buf *buf = dbuf->priv;
+	int num_pages = PAGE_ALIGN(buf->size) / PAGE_SIZE;
+	struct sg_table *sgt;
+	struct scatterlist *sg;
+	void *vaddr = buf->vaddr;
+	int ret;
+	int i;
+
+	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
+	if (!attach)
+		return -ENOMEM;
+
+	sgt = &attach->sgt;
+	ret = sg_alloc_table(sgt, num_pages, GFP_KERNEL);
+	if (ret) {
+		kfree(attach);
+		return ret;
+	}
+	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
+		struct page *page = vmalloc_to_page(vaddr);
+
+		if (!page) {
+			sg_free_table(sgt);
+			kfree(attach);
+			return -ENOMEM;
+		}
+		sg_set_page(sg, page, PAGE_SIZE, 0);
+		vaddr += PAGE_SIZE;
+	}
+
+	attach->dir = DMA_NONE;
+	dbuf_attach->priv = attach;
+	return 0;
+}
+
+static void vb2_vmalloc_dmabuf_ops_detach(struct dma_buf *dbuf,
+	struct dma_buf_attachment *db_attach)
+{
+	struct vb2_vmalloc_attachment *attach = db_attach->priv;
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
+static struct sg_table *vb2_vmalloc_dmabuf_ops_map(
+	struct dma_buf_attachment *db_attach, enum dma_data_direction dir)
+{
+	struct vb2_vmalloc_attachment *attach = db_attach->priv;
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
+		pr_err("failed to map scatterlist\n");
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
+static void vb2_vmalloc_dmabuf_ops_unmap(struct dma_buf_attachment *db_attach,
+	struct sg_table *sgt, enum dma_data_direction dir)
+{
+	/* nothing to be done here */
+}
+
+static void vb2_vmalloc_dmabuf_ops_release(struct dma_buf *dbuf)
+{
+	/* drop reference obtained in vb2_vmalloc_get_dmabuf */
+	vb2_vmalloc_put(dbuf->priv);
+}
+
+static void *vb2_vmalloc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
+{
+	struct vb2_vmalloc_buf *buf = dbuf->priv;
+
+	return buf->vaddr + pgnum * PAGE_SIZE;
+}
+
+static void *vb2_vmalloc_dmabuf_ops_vmap(struct dma_buf *dbuf)
+{
+	struct vb2_vmalloc_buf *buf = dbuf->priv;
+
+	return buf->vaddr;
+}
+
+static int vb2_vmalloc_dmabuf_ops_mmap(struct dma_buf *dbuf,
+	struct vm_area_struct *vma)
+{
+	return vb2_vmalloc_mmap(dbuf->priv, vma);
+}
+
+static struct dma_buf_ops vb2_vmalloc_dmabuf_ops = {
+	.attach = vb2_vmalloc_dmabuf_ops_attach,
+	.detach = vb2_vmalloc_dmabuf_ops_detach,
+	.map_dma_buf = vb2_vmalloc_dmabuf_ops_map,
+	.unmap_dma_buf = vb2_vmalloc_dmabuf_ops_unmap,
+	.kmap = vb2_vmalloc_dmabuf_ops_kmap,
+	.kmap_atomic = vb2_vmalloc_dmabuf_ops_kmap,
+	.vmap = vb2_vmalloc_dmabuf_ops_vmap,
+	.mmap = vb2_vmalloc_dmabuf_ops_mmap,
+	.release = vb2_vmalloc_dmabuf_ops_release,
+};
+
+static struct dma_buf *vb2_vmalloc_get_dmabuf(void *buf_priv, unsigned long flags)
+{
+	struct vb2_vmalloc_buf *buf = buf_priv;
+	struct dma_buf *dbuf;
+
+	if (WARN_ON(!buf->vaddr))
+		return NULL;
+
+	dbuf = dma_buf_export(buf, &vb2_vmalloc_dmabuf_ops, buf->size, flags, NULL);
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
 /*       callbacks for DMABUF buffers        */
 /*********************************************/
 
@@ -265,6 +438,7 @@ const struct vb2_mem_ops vb2_vmalloc_memops = {
 	.put		= vb2_vmalloc_put,
 	.get_userptr	= vb2_vmalloc_get_userptr,
 	.put_userptr	= vb2_vmalloc_put_userptr,
+	.get_dmabuf	= vb2_vmalloc_get_dmabuf,
 	.map_dmabuf	= vb2_vmalloc_map_dmabuf,
 	.unmap_dmabuf	= vb2_vmalloc_unmap_dmabuf,
 	.attach_dmabuf	= vb2_vmalloc_attach_dmabuf,
-- 
2.1.1

