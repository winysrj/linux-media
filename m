Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:60075 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751678AbdDMH6g (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 03:58:36 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC v3 12/14] vb2: dma-sg: Let drivers decide DMA attrs of MMAP and USERPTR bufs
Date: Thu, 13 Apr 2017 10:57:17 +0300
Message-Id: <1492070239-21532-13-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The desirable DMA attributes are not generic for all devices using
Videobuf2 scatter-gather DMA ops. Let the drivers decide.

As a result, also the DMA-BUF exporter must provide ops for synchronising
the cache. This adds begin_cpu_access and end_cpu_access ops to
vb2_dc_dmabuf_ops.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c | 81 +++++++++++++++++++++++-------
 1 file changed, 62 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 102ddb2..5662f00 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -38,6 +38,7 @@ struct vb2_dma_sg_buf {
 	struct frame_vector		*vec;
 	int				offset;
 	enum dma_data_direction		dma_dir;
+	unsigned long			dma_attrs;
 	struct sg_table			sg_table;
 	/*
 	 * This will point to sg_table when used with the MMAP or USERPTR
@@ -114,6 +115,7 @@ static void *vb2_dma_sg_alloc(struct device *dev, unsigned long dma_attrs,
 
 	buf->vaddr = NULL;
 	buf->dma_dir = dma_dir;
+	buf->dma_attrs = dma_attrs;
 	buf->offset = 0;
 	buf->size = size;
 	/* size is already page aligned */
@@ -143,7 +145,7 @@ static void *vb2_dma_sg_alloc(struct device *dev, unsigned long dma_attrs,
 	 * prepare() memop is called.
 	 */
 	sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-				      buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
+				      buf->dma_dir, dma_attrs);
 	if (!sgt->nents)
 		goto fail_map;
 
@@ -181,7 +183,7 @@ static void vb2_dma_sg_put(void *buf_priv)
 		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
 			buf->num_pages);
 		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-				   buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
+				   buf->dma_dir, buf->dma_attrs);
 		if (buf->vaddr)
 			vm_unmap_ram(buf->vaddr, buf->num_pages);
 		sg_free_table(buf->dma_sgt);
@@ -198,12 +200,13 @@ static void vb2_dma_sg_prepare(void *buf_priv)
 	struct vb2_dma_sg_buf *buf = buf_priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	/* DMABUF exporter will flush the cache for us */
-	if (buf->db_attach)
-		return;
-
-	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
-			       buf->dma_dir);
+	/*
+	 * DMABUF exporter will flush the cache for us; only USERPTR
+	 * and MMAP buffers with non-coherent memory will be flushed.
+	 */
+	if (buf->dma_attrs & DMA_ATTR_NON_CONSISTENT)
+		dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
+				       buf->dma_dir);
 }
 
 static void vb2_dma_sg_finish(void *buf_priv)
@@ -211,11 +214,13 @@ static void vb2_dma_sg_finish(void *buf_priv)
 	struct vb2_dma_sg_buf *buf = buf_priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	/* DMABUF exporter will flush the cache for us */
-	if (buf->db_attach)
-		return;
-
-	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
+	/*
+	 * DMABUF exporter will flush the cache for us; only USERPTR
+	 * and MMAP buffers with non-coherent memory will be flushed.
+	 */
+	if (buf->dma_attrs & DMA_ATTR_NON_CONSISTENT)
+		dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents,
+				    buf->dma_dir);
 }
 
 static void *vb2_dma_sg_get_userptr(struct device *dev, unsigned long vaddr,
@@ -237,6 +242,7 @@ static void *vb2_dma_sg_get_userptr(struct device *dev, unsigned long vaddr,
 	buf->vaddr = NULL;
 	buf->dev = dev;
 	buf->dma_dir = dma_dir;
+	buf->dma_attrs = dma_attrs;
 	buf->offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
 	buf->dma_sgt = &buf->sg_table;
@@ -260,7 +266,7 @@ static void *vb2_dma_sg_get_userptr(struct device *dev, unsigned long vaddr,
 	 * prepare() memop is called.
 	 */
 	sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-				      buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
+				      buf->dma_dir, dma_attrs);
 	if (!sgt->nents)
 		goto userptr_fail_map;
 
@@ -288,7 +294,7 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
 	dprintk(1, "%s: Releasing userspace buffer of %d pages\n",
 	       __func__, buf->num_pages);
 	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir,
-			   DMA_ATTR_SKIP_CPU_SYNC);
+			   buf->dma_attrs);
 	if (buf->vaddr)
 		vm_unmap_ram(buf->vaddr, buf->num_pages);
 	sg_free_table(buf->dma_sgt);
@@ -433,6 +439,7 @@ static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
 	struct dma_buf_attachment *db_attach, enum dma_data_direction dma_dir)
 {
 	struct vb2_dma_sg_attachment *attach = db_attach->priv;
+	struct vb2_dma_sg_buf *buf = db_attach->dmabuf->priv;
 	/* stealing dmabuf mutex to serialize map/unmap operations */
 	struct mutex *lock = &db_attach->dmabuf->lock;
 	struct sg_table *sgt;
@@ -448,14 +455,14 @@ static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
 
 	/* release any previous cache */
 	if (attach->dma_dir != DMA_NONE) {
-		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
-			attach->dma_dir);
+		dma_unmap_sg_attrs(db_attach->dev, sgt->sgl, sgt->orig_nents,
+				   attach->dma_dir, buf->dma_attrs);
 		attach->dma_dir = DMA_NONE;
 	}
 
 	/* mapping to the client with new direction */
-	sgt->nents = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
-				dma_dir);
+	sgt->nents = dma_map_sg_attrs(db_attach->dev, sgt->sgl, sgt->orig_nents,
+				      dma_dir, buf->dma_attrs);
 	if (!sgt->nents) {
 		pr_err("failed to map scatterlist\n");
 		mutex_unlock(lock);
@@ -488,6 +495,40 @@ static void *vb2_dma_sg_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnu
 	return buf->vaddr ? buf->vaddr + pgnum * PAGE_SIZE : NULL;
 }
 
+static int vb2_dma_sg_dmabuf_ops_begin_cpu_access(
+	struct dma_buf *dbuf, enum dma_data_direction direction)
+{
+	struct vb2_dma_sg_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	/*
+	 * DMABUF exporter will flush the cache for us; only USERPTR
+	 * and MMAP buffers with non-coherent memory will be flushed.
+	 */
+	if (buf->dma_attrs & DMA_ATTR_NON_CONSISTENT)
+		dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents,
+				    buf->dma_dir);
+
+	return 0;
+}
+
+static int vb2_dma_sg_dmabuf_ops_end_cpu_access(
+	struct dma_buf *dbuf, enum dma_data_direction direction)
+{
+	struct vb2_dma_sg_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	/*
+	 * DMABUF exporter will flush the cache for us; only USERPTR
+	 * and MMAP buffers with non-coherent memory will be flushed.
+	 */
+	if (buf->dma_attrs & DMA_ATTR_NON_CONSISTENT)
+		dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents,
+				       buf->dma_dir);
+
+	return 0;
+}
+
 static void *vb2_dma_sg_dmabuf_ops_vmap(struct dma_buf *dbuf)
 {
 	struct vb2_dma_sg_buf *buf = dbuf->priv;
@@ -508,6 +549,8 @@ static struct dma_buf_ops vb2_dma_sg_dmabuf_ops = {
 	.unmap_dma_buf = vb2_dma_sg_dmabuf_ops_unmap,
 	.kmap = vb2_dma_sg_dmabuf_ops_kmap,
 	.kmap_atomic = vb2_dma_sg_dmabuf_ops_kmap,
+	.begin_cpu_access = vb2_dma_sg_dmabuf_ops_begin_cpu_access,
+	.end_cpu_access = vb2_dma_sg_dmabuf_ops_end_cpu_access,
 	.vmap = vb2_dma_sg_dmabuf_ops_vmap,
 	.mmap = vb2_dma_sg_dmabuf_ops_mmap,
 	.release = vb2_dma_sg_dmabuf_ops_release,
-- 
2.7.4
