Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:61812 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab2JJPA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 11:00:59 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO00GOGN1MP590@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Oct 2012 00:00:58 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBO002YDME0EC70@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Oct 2012 00:00:58 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: [PATCHv10 20/26] v4l: vb2-dma-contig: add support for DMABUF exporting
Date: Wed, 10 Oct 2012 16:46:39 +0200
Message-id: <1349880405-26049-21-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for exporting a dma-contig buffer using
DMABUF interface.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c |  200 ++++++++++++++++++++++++
 1 file changed, 200 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 0e065ce..b138b5c 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
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
@@ -213,6 +218,200 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
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
+	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
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
+static int vb2_dc_dmabuf_ops_mmap(struct dma_buf *dbuf,
+	struct vm_area_struct *vma)
+{
+	return vb2_dc_mmap(dbuf->priv, vma);
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
+	.mmap = vb2_dc_dmabuf_ops_mmap,
+	.release = vb2_dc_dmabuf_ops_release,
+};
+
+static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
+{
+	int ret;
+	struct sg_table *sgt;
+
+	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
+	if (!sgt) {
+		dev_err(buf->dev, "failed to alloc sg table\n");
+		return NULL;
+	}
+
+	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
+		buf->size);
+	if (ret < 0) {
+		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
+		kfree(sgt);
+		return NULL;
+	}
+
+	return sgt;
+}
+
+static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+	struct dma_buf *dbuf;
+
+	if (!buf->sgt_base)
+		buf->sgt_base = vb2_dc_get_base_sgt(buf);
+
+	if (WARN_ON(!buf->sgt_base))
+		return NULL;
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
 
@@ -519,6 +718,7 @@ static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 const struct vb2_mem_ops vb2_dma_contig_memops = {
 	.alloc		= vb2_dc_alloc,
 	.put		= vb2_dc_put,
+	.get_dmabuf	= vb2_dc_get_dmabuf,
 	.cookie		= vb2_dc_cookie,
 	.vaddr		= vb2_dc_vaddr,
 	.mmap		= vb2_dc_mmap,
-- 
1.7.9.5

