Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1195 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaJKJXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Oct 2014 05:23:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 05/10] vb2-dma-sg: add dmabuf import support
Date: Sat, 11 Oct 2014 11:22:32 +0200
Message-Id: <1413019357-12382-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1413019357-12382-1-git-send-email-hverkuil@xs4all.nl>
References: <1413019357-12382-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for dmabuf to vb2-dma-sg.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c | 126 +++++++++++++++++++++++++++--
 1 file changed, 119 insertions(+), 7 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index bd2cc7e..54c399b 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -42,11 +42,15 @@ struct vb2_dma_sg_buf {
 	int				offset;
 	enum dma_data_direction		dma_dir;
 	struct sg_table			sg_table;
+	struct sg_table			*dma_sgt;
 	size_t				size;
 	unsigned int			num_pages;
 	atomic_t			refcount;
 	struct vb2_vmarea_handler	handler;
 	struct vm_area_struct		*vma;
+
+	/* DMABUF related */
+	struct dma_buf_attachment	*db_attach;
 };
 
 static void vb2_dma_sg_put(void *buf_priv);
@@ -114,6 +118,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, int write,
 	/* size is already page aligned */
 	buf->num_pages = size >> PAGE_SHIFT;
 	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	buf->dma_sgt = &buf->sg_table;
 
 	buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
 			     GFP_KERNEL);
@@ -124,7 +129,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, int write,
 	if (ret)
 		goto fail_pages_alloc;
 
-	ret = sg_alloc_table_from_pages(&buf->sg_table, buf->pages,
+	ret = sg_alloc_table_from_pages(buf->dma_sgt, buf->pages,
 			buf->num_pages, 0, size, gfp_flags);
 	if (ret)
 		goto fail_table_alloc;
@@ -173,7 +178,7 @@ static void vb2_dma_sg_put(void *buf_priv)
 		dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 		if (buf->vaddr)
 			vm_unmap_ram(buf->vaddr, buf->num_pages);
-		sg_free_table(&buf->sg_table);
+		sg_free_table(buf->dma_sgt);
 		while (--i >= 0)
 			__free_page(buf->pages[i]);
 		kfree(buf->pages);
@@ -185,7 +190,11 @@ static void vb2_dma_sg_put(void *buf_priv)
 static void vb2_dma_sg_prepare(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
-	struct sg_table *sgt = &buf->sg_table;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	/* DMABUF exporter will flush the cache for us */
+	if (buf->db_attach)
+		return;
 
 	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 }
@@ -193,7 +202,11 @@ static void vb2_dma_sg_prepare(void *buf_priv)
 static void vb2_dma_sg_finish(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
-	struct sg_table *sgt = &buf->sg_table;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	/* DMABUF exporter will flush the cache for us */
+	if (buf->db_attach)
+		return;
 
 	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 }
@@ -222,6 +235,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	buf->offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
 	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	buf->dma_sgt = &buf->sg_table;
 
 	first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
 	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
@@ -274,7 +288,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	if (num_pages_from_user != buf->num_pages)
 		goto userptr_fail_get_user_pages;
 
-	if (sg_alloc_table_from_pages(&buf->sg_table, buf->pages,
+	if (sg_alloc_table_from_pages(buf->dma_sgt, buf->pages,
 			buf->num_pages, buf->offset, size, 0))
 		goto userptr_fail_alloc_table_from_pages;
 
@@ -319,7 +333,7 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
 	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 	if (buf->vaddr)
 		vm_unmap_ram(buf->vaddr, buf->num_pages);
-	sg_free_table(&buf->sg_table);
+	sg_free_table(buf->dma_sgt);
 	while (--i >= 0) {
 		if (buf->write)
 			set_page_dirty_lock(buf->pages[i]);
@@ -392,11 +406,105 @@ static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
 	return 0;
 }
 
+/*********************************************/
+/*       callbacks for DMABUF buffers        */
+/*********************************************/
+
+static int vb2_dma_sg_map_dmabuf(void *mem_priv)
+{
+	struct vb2_dma_sg_buf *buf = mem_priv;
+	struct sg_table *sgt;
+
+	if (WARN_ON(!buf->db_attach)) {
+		pr_err("trying to pin a non attached buffer\n");
+		return -EINVAL;
+	}
+
+	if (WARN_ON(buf->dma_sgt)) {
+		pr_err("dmabuf buffer is already pinned\n");
+		return 0;
+	}
+
+	/* get the associated scatterlist for this buffer */
+	sgt = dma_buf_map_attachment(buf->db_attach, buf->dma_dir);
+	if (IS_ERR_OR_NULL(sgt)) {
+		pr_err("Error getting dmabuf scatterlist\n");
+		return -EINVAL;
+	}
+
+	buf->dma_sgt = sgt;
+
+	return 0;
+}
+
+static void vb2_dma_sg_unmap_dmabuf(void *mem_priv)
+{
+	struct vb2_dma_sg_buf *buf = mem_priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	if (WARN_ON(!buf->db_attach)) {
+		pr_err("trying to unpin a not attached buffer\n");
+		return;
+	}
+
+	if (WARN_ON(!sgt)) {
+		pr_err("dmabuf buffer is already unpinned\n");
+		return;
+	}
+
+	dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
+
+	buf->dma_sgt = NULL;
+}
+
+static void vb2_dma_sg_detach_dmabuf(void *mem_priv)
+{
+	struct vb2_dma_sg_buf *buf = mem_priv;
+
+	/* if vb2 works correctly you should never detach mapped buffer */
+	if (WARN_ON(buf->dma_sgt))
+		vb2_dma_sg_unmap_dmabuf(buf);
+
+	/* detach this attachment */
+	dma_buf_detach(buf->db_attach->dmabuf, buf->db_attach);
+	kfree(buf);
+}
+
+static void *vb2_dma_sg_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
+	unsigned long size, int write)
+{
+	struct vb2_dma_sg_conf *conf = alloc_ctx;
+	struct vb2_dma_sg_buf *buf;
+	struct dma_buf_attachment *dba;
+
+	if (dbuf->size < size)
+		return ERR_PTR(-EFAULT);
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	buf->dev = conf->dev;
+	/* create attachment for the dmabuf with the user device */
+	dba = dma_buf_attach(dbuf, buf->dev);
+	if (IS_ERR(dba)) {
+		pr_err("failed to attach dmabuf\n");
+		kfree(buf);
+		return dba;
+	}
+
+	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	buf->size = size;
+	buf->db_attach = dba;
+
+	return buf;
+}
+
 static void *vb2_dma_sg_cookie(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
 
-	return &buf->sg_table;
+	return buf->dma_sgt;
 }
 
 const struct vb2_mem_ops vb2_dma_sg_memops = {
@@ -409,6 +517,10 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
 	.vaddr		= vb2_dma_sg_vaddr,
 	.mmap		= vb2_dma_sg_mmap,
 	.num_users	= vb2_dma_sg_num_users,
+	.map_dmabuf	= vb2_dma_sg_map_dmabuf,
+	.unmap_dmabuf	= vb2_dma_sg_unmap_dmabuf,
+	.attach_dmabuf	= vb2_dma_sg_attach_dmabuf,
+	.detach_dmabuf	= vb2_dma_sg_detach_dmabuf,
 	.cookie		= vb2_dma_sg_cookie,
 };
 EXPORT_SYMBOL_GPL(vb2_dma_sg_memops);
-- 
2.1.1

