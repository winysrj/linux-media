Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24329 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbbIHKf7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Sep 2015 06:35:59 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Subject: [RFC 10/11] vb2: dma-contig: Let drivers decide DMA attrs of MMAP and USERPTR bufs
Date: Tue,  8 Sep 2015 13:33:54 +0300
Message-Id: <1441708435-12736-11-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441708435-12736-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441708435-12736-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The desirable DMA attributes are not generic for all devices using
Videobuf2 contiguous DMA ops. Let the drivers decide.

This change also results in MMAP buffers always having an sg_table
(dma_sgt field).

Also arrange the header files alphabetically.

As a result, also the DMA-BUF exporter must provide ops for synchronising
the cache. This adds begin_cpu_access and end_cpu_access ops to
vb2_dc_dmabuf_ops.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 104 ++++++++++++++++++-------
 include/media/videobuf2-dma-contig.h           |   3 +-
 2 files changed, 79 insertions(+), 28 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 65bc687..65ee122 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -11,11 +11,11 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/dma-mapping.h>
 
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
@@ -23,6 +23,7 @@
 
 struct vb2_dc_conf {
 	struct device		*dev;
+	struct dma_attrs	attrs;
 };
 
 struct vb2_dc_buf {
@@ -34,6 +35,7 @@ struct vb2_dc_buf {
 	struct sg_table			*dma_sgt;
 
 	/* MMAP related */
+	struct dma_attrs		*attrs;
 	struct vb2_vmarea_handler	handler;
 	atomic_t			refcount;
 
@@ -135,8 +137,12 @@ static void vb2_dc_prepare(void *buf_priv)
 	struct vb2_dc_buf *buf = buf_priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	/* DMABUF exporter will flush the cache for us */
-	if (!buf->vma)
+	/*
+	 * DMABUF exporter will flush the cache for us; only USERPTR
+	 * and MMAP buffers with non-coherent memory will be flushed.
+	 */
+	if (!buf->attrs ||
+	    !dma_get_attr(DMA_ATTR_NON_CONSISTENT, buf->attrs))
 		return;
 
 	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
@@ -147,8 +153,12 @@ static void vb2_dc_finish(void *buf_priv)
 	struct vb2_dc_buf *buf = buf_priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	/* DMABUF exporter will flush the cache for us */
-	if (!buf->vma)
+	/*
+	 * DMABUF exporter will flush the cache for us; only USERPTR
+	 * and MMAP buffers with non-coherent memory will be flushed.
+	 */
+	if (!buf->attrs ||
+	    !dma_get_attr(DMA_ATTR_NON_CONSISTENT, buf->attrs))
 		return;
 
 	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
@@ -169,7 +179,8 @@ static void vb2_dc_put(void *buf_priv)
 		sg_free_table(buf->dma_sgt);
 		kfree(buf->dma_sgt);
 	}
-	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
+	dma_free_attrs(buf->dev, buf->size, buf->vaddr, buf->dma_addr,
+		       buf->attrs);
 	put_device(buf->dev);
 	kfree(buf);
 }
@@ -185,14 +196,25 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
-						GFP_KERNEL | gfp_flags);
+	buf->attrs = &conf->attrs;
+
+	buf->vaddr = dma_alloc_attrs(dev, size, &buf->dma_addr,
+				     GFP_KERNEL | gfp_flags, buf->attrs);
 	if (!buf->vaddr) {
-		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
+		dev_err(dev, "dma_alloc_attrs of size %ld failed\n", size);
 		kfree(buf);
 		return ERR_PTR(-ENOMEM);
 	}
 
+	if (dma_get_attr(DMA_ATTR_NON_CONSISTENT, buf->attrs)) {
+		buf->dma_sgt = vb2_dc_get_base_sgt(buf);
+		if (!buf->dma_sgt) {
+			dma_free_attrs(dev, size, buf->vaddr, buf->dma_addr,
+				       buf->attrs);
+			return ERR_PTR(-ENOMEM);
+		}
+	}
+
 	/* Prevent the device from being released while the buffer is used */
 	buf->dev = get_device(dev);
 	buf->size = size;
@@ -223,8 +245,8 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 	 */
 	vma->vm_pgoff = 0;
 
-	ret = dma_mmap_coherent(buf->dev, vma, buf->vaddr,
-		buf->dma_addr, buf->size);
+	ret = dma_mmap_attrs(buf->dev, vma, buf->vaddr, buf->dma_addr,
+			     buf->size, buf->attrs);
 
 	if (ret) {
 		pr_err("Remapping memory failed, error: %d\n", ret);
@@ -370,6 +392,34 @@ static void *vb2_dc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
 	return buf->vaddr + pgnum * PAGE_SIZE;
 }
 
+static int vb2_dc_dmabuf_ops_begin_cpu_access(
+	struct dma_buf *dbuf, size_t start, size_t len,
+	enum dma_data_direction direction)
+{
+	struct vb2_dc_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	if (!dma_get_attr(DMA_ATTR_NON_CONSISTENT, buf->attrs))
+		return 0;
+
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+
+	return 0;
+}
+
+static void vb2_dc_dmabuf_ops_end_cpu_access(
+	struct dma_buf *dbuf, size_t start, size_t len,
+	enum dma_data_direction direction)
+{
+	struct vb2_dc_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	if (!dma_get_attr(DMA_ATTR_NON_CONSISTENT, buf->attrs))
+		return;
+
+	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+}
+
 static void *vb2_dc_dmabuf_ops_vmap(struct dma_buf *dbuf)
 {
 	struct vb2_dc_buf *buf = dbuf->priv;
@@ -390,6 +440,8 @@ static struct dma_buf_ops vb2_dc_dmabuf_ops = {
 	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
 	.kmap = vb2_dc_dmabuf_ops_kmap,
 	.kmap_atomic = vb2_dc_dmabuf_ops_kmap,
+	.begin_cpu_access = vb2_dc_dmabuf_ops_begin_cpu_access,
+	.end_cpu_access = vb2_dc_dmabuf_ops_end_cpu_access,
 	.vmap = vb2_dc_dmabuf_ops_vmap,
 	.mmap = vb2_dc_dmabuf_ops_mmap,
 	.release = vb2_dc_dmabuf_ops_release,
@@ -514,15 +566,13 @@ static void vb2_dc_put_userptr(void *buf_priv)
 	struct sg_table *sgt = buf->dma_sgt;
 
 	if (sgt) {
-		DEFINE_DMA_ATTRS(attrs);
-
-		dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 		/*
-		 * No need to sync to CPU, it's already synced to the CPU
-		 * since the finish() memop will have been called before this.
+		 * Don't ask to skip cache sync in case if the user
+		 * did ask to skip cache flush the last time the
+		 * buffer was dequeued.
 		 */
 		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-				   buf->dma_dir, &attrs);
+				   buf->dma_dir, buf->attrs);
 		if (!vma_is_io(buf->vma))
 			vb2_dc_sgt_foreach_page(sgt, vb2_dc_put_dirty_page);
 
@@ -579,9 +629,6 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	struct sg_table *sgt;
 	unsigned long contig_size;
 	unsigned long dma_align = dma_get_cache_alignment();
-	DEFINE_DMA_ATTRS(attrs);
-
-	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 
 	/* Only cache aligned DMA transfers are reliable */
 	if (!IS_ALIGNED(vaddr | size, dma_align)) {
@@ -598,6 +645,8 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
+	buf->attrs = &conf->attrs;
+
 	buf->dev = conf->dev;
 	buf->dma_dir = dma_dir;
 
@@ -667,12 +716,8 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	kfree(pages);
 	pages = NULL;
 
-	/*
-	 * No need to sync to the device, this will happen later when the
-	 * prepare() memop is called.
-	 */
 	sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-				      buf->dma_dir, &attrs);
+				      buf->dma_dir, buf->attrs);
 	if (sgt->nents <= 0) {
 		pr_err("failed to map scatterlist\n");
 		ret = -EIO;
@@ -695,7 +740,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 
 fail_map_sg:
 	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-			   buf->dma_dir, &attrs);
+			   buf->dma_dir, buf->attrs);
 
 fail_sgt_init:
 	if (!vma_is_io(buf->vma))
@@ -856,7 +901,7 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
 };
 EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
 
-void *vb2_dma_contig_init_ctx(struct device *dev)
+void *vb2_dma_contig_init_ctx(struct device *dev, struct dma_attrs *attrs)
 {
 	struct vb2_dc_conf *conf;
 
@@ -866,6 +911,11 @@ void *vb2_dma_contig_init_ctx(struct device *dev)
 
 	conf->dev = dev;
 
+	if (!attrs)
+		init_dma_attrs(&conf->attrs);
+	else
+		conf->attrs = *attrs;
+
 	return conf;
 }
 EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index 8197f87..1b85282 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -24,7 +24,8 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
 	return *addr;
 }
 
-void *vb2_dma_contig_init_ctx(struct device *dev);
+void *vb2_dma_contig_init_ctx(struct device *dev,
+			      struct dma_attrs *attrs);
 void vb2_dma_contig_cleanup_ctx(void *alloc_ctx);
 
 extern const struct vb2_mem_ops vb2_dma_contig_memops;
-- 
2.1.0.231.g7484e3b

