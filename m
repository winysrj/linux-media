Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:48282 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576AbaKJMtl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 07:49:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	Hans Verkuil <hansverk@cisco.com>
Subject: [RFCv6 PATCH 07/16] vb2-dma-sg: add support for dmabuf exports
Date: Mon, 10 Nov 2014 13:49:22 +0100
Message-Id: <1415623771-29634-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl>
References: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Add DMABUF export support to vb2-dma-sg.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c | 170 +++++++++++++++++++++++++++++
 1 file changed, 170 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 85e2e09..0f7d293 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -411,6 +411,175 @@ static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
 }
 
 /*********************************************/
+/*         DMABUF ops for exporters          */
+/*********************************************/
+
+struct vb2_dma_sg_attachment {
+	struct sg_table sgt;
+	enum dma_data_direction dma_dir;
+};
+
+static int vb2_dma_sg_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
+	struct dma_buf_attachment *dbuf_attach)
+{
+	struct vb2_dma_sg_attachment *attach;
+	unsigned int i;
+	struct scatterlist *rd, *wr;
+	struct sg_table *sgt;
+	struct vb2_dma_sg_buf *buf = dbuf->priv;
+	int ret;
+
+	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
+	if (!attach)
+		return -ENOMEM;
+
+	sgt = &attach->sgt;
+	/* Copy the buf->base_sgt scatter list to the attachment, as we can't
+	 * map the same scatter list to multiple attachments at the same time.
+	 */
+	ret = sg_alloc_table(sgt, buf->dma_sgt->orig_nents, GFP_KERNEL);
+	if (ret) {
+		kfree(attach);
+		return -ENOMEM;
+	}
+
+	rd = buf->dma_sgt->sgl;
+	wr = sgt->sgl;
+	for (i = 0; i < sgt->orig_nents; ++i) {
+		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
+		rd = sg_next(rd);
+		wr = sg_next(wr);
+	}
+
+	attach->dma_dir = DMA_NONE;
+	dbuf_attach->priv = attach;
+
+	return 0;
+}
+
+static void vb2_dma_sg_dmabuf_ops_detach(struct dma_buf *dbuf,
+	struct dma_buf_attachment *db_attach)
+{
+	struct vb2_dma_sg_attachment *attach = db_attach->priv;
+	struct sg_table *sgt;
+
+	if (!attach)
+		return;
+
+	sgt = &attach->sgt;
+
+	/* release the scatterlist cache */
+	if (attach->dma_dir != DMA_NONE)
+		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
+			attach->dma_dir);
+	sg_free_table(sgt);
+	kfree(attach);
+	db_attach->priv = NULL;
+}
+
+static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
+	struct dma_buf_attachment *db_attach, enum dma_data_direction dma_dir)
+{
+	struct vb2_dma_sg_attachment *attach = db_attach->priv;
+	/* stealing dmabuf mutex to serialize map/unmap operations */
+	struct mutex *lock = &db_attach->dmabuf->lock;
+	struct sg_table *sgt;
+	int ret;
+
+	mutex_lock(lock);
+
+	sgt = &attach->sgt;
+	/* return previously mapped sg table */
+	if (attach->dma_dir == dma_dir) {
+		mutex_unlock(lock);
+		return sgt;
+	}
+
+	/* release any previous cache */
+	if (attach->dma_dir != DMA_NONE) {
+		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
+			attach->dma_dir);
+		attach->dma_dir = DMA_NONE;
+	}
+
+	/* mapping to the client with new direction */
+	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dma_dir);
+	if (ret <= 0) {
+		pr_err("failed to map scatterlist\n");
+		mutex_unlock(lock);
+		return ERR_PTR(-EIO);
+	}
+
+	attach->dma_dir = dma_dir;
+
+	mutex_unlock(lock);
+
+	return sgt;
+}
+
+static void vb2_dma_sg_dmabuf_ops_unmap(struct dma_buf_attachment *db_attach,
+	struct sg_table *sgt, enum dma_data_direction dma_dir)
+{
+	/* nothing to be done here */
+}
+
+static void vb2_dma_sg_dmabuf_ops_release(struct dma_buf *dbuf)
+{
+	/* drop reference obtained in vb2_dma_sg_get_dmabuf */
+	vb2_dma_sg_put(dbuf->priv);
+}
+
+static void *vb2_dma_sg_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
+{
+	struct vb2_dma_sg_buf *buf = dbuf->priv;
+
+	return buf->vaddr ? buf->vaddr + pgnum * PAGE_SIZE : NULL;
+}
+
+static void *vb2_dma_sg_dmabuf_ops_vmap(struct dma_buf *dbuf)
+{
+	struct vb2_dma_sg_buf *buf = dbuf->priv;
+
+	return vb2_dma_sg_vaddr(buf);
+}
+
+static int vb2_dma_sg_dmabuf_ops_mmap(struct dma_buf *dbuf,
+	struct vm_area_struct *vma)
+{
+	return vb2_dma_sg_mmap(dbuf->priv, vma);
+}
+
+static struct dma_buf_ops vb2_dma_sg_dmabuf_ops = {
+	.attach = vb2_dma_sg_dmabuf_ops_attach,
+	.detach = vb2_dma_sg_dmabuf_ops_detach,
+	.map_dma_buf = vb2_dma_sg_dmabuf_ops_map,
+	.unmap_dma_buf = vb2_dma_sg_dmabuf_ops_unmap,
+	.kmap = vb2_dma_sg_dmabuf_ops_kmap,
+	.kmap_atomic = vb2_dma_sg_dmabuf_ops_kmap,
+	.vmap = vb2_dma_sg_dmabuf_ops_vmap,
+	.mmap = vb2_dma_sg_dmabuf_ops_mmap,
+	.release = vb2_dma_sg_dmabuf_ops_release,
+};
+
+static struct dma_buf *vb2_dma_sg_get_dmabuf(void *buf_priv, unsigned long flags)
+{
+	struct vb2_dma_sg_buf *buf = buf_priv;
+	struct dma_buf *dbuf;
+
+	if (WARN_ON(!buf->dma_sgt))
+		return NULL;
+
+	dbuf = dma_buf_export(buf, &vb2_dma_sg_dmabuf_ops, buf->size, flags, NULL);
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
 
@@ -526,6 +695,7 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
 	.vaddr		= vb2_dma_sg_vaddr,
 	.mmap		= vb2_dma_sg_mmap,
 	.num_users	= vb2_dma_sg_num_users,
+	.get_dmabuf	= vb2_dma_sg_get_dmabuf,
 	.map_dmabuf	= vb2_dma_sg_map_dmabuf,
 	.unmap_dmabuf	= vb2_dma_sg_unmap_dmabuf,
 	.attach_dmabuf	= vb2_dma_sg_attach_dmabuf,
-- 
2.1.1

