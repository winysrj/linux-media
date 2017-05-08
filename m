Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62269 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755087AbdEHPEd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 11:04:33 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 10/18] vb2: dma-contig: Fix DMA attribute and cache management
Date: Mon,  8 May 2017 18:03:22 +0300
Message-Id: <1494255810-12672-11-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch ccc66e73 ("ARM: 8508/2: videobuf2-dc: Let drivers specify DMA
attrs") added support for driver specific DMA attributes to
videobuf2-dma-contig but it had several issues in it.

In particular,

- cache operations were only performed on USERPTR buffers,

- DMA attributes were set only for MMAP buffers and

- it did not provide begin_cpu_access() and end_cpu_access() dma_buf_ops
  callbacks for cache syncronisation on exported MMAP buffers.

This patch corrects these issues.

Also arrange the header files alphabetically.

Fixes: ccc66e73 ("ARM: 8508/2: videobuf2-dc: Let drivers specify DMA attrs")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 94 ++++++++++++++++++++------
 1 file changed, 72 insertions(+), 22 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 0afc3da..8b0298a 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -11,12 +11,12 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/refcount.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/dma-mapping.h>
 
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
@@ -97,12 +97,13 @@ static void vb2_dc_prepare(void *buf_priv)
 	struct vb2_dc_buf *buf = buf_priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	/* DMABUF exporter will flush the cache for us */
-	if (!buf->vec)
-		return;
-
-	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
-			       buf->dma_dir);
+	/*
+	 * DMABUF exporter will flush the cache for us; only USERPTR
+	 * and MMAP buffers with non-coherent memory will be flushed.
+	 */
+	if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
+		dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
+				       buf->dma_dir);
 }
 
 static void vb2_dc_finish(void *buf_priv)
@@ -110,11 +111,13 @@ static void vb2_dc_finish(void *buf_priv)
 	struct vb2_dc_buf *buf = buf_priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	/* DMABUF exporter will flush the cache for us */
-	if (!buf->vec)
-		return;
-
-	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
+	/*
+	 * DMABUF exporter will flush the cache for us; only USERPTR
+	 * and MMAP buffers with non-coherent memory will be flushed.
+	 */
+	if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
+		dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents,
+				    buf->dma_dir);
 }
 
 /*********************************************/
@@ -142,6 +145,7 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 			  gfp_t gfp_flags)
 {
 	struct vb2_dc_buf *buf;
+	int ret;
 
 	if (WARN_ON(!dev))
 		return ERR_PTR(-EINVAL);
@@ -152,9 +156,9 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 
 	buf->attrs = attrs;
 	buf->cookie = dma_alloc_attrs(dev, size, &buf->dma_addr,
-					GFP_KERNEL | gfp_flags, buf->attrs);
+				      GFP_KERNEL | gfp_flags, buf->attrs);
 	if (!buf->cookie) {
-		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
+		dev_err(dev, "dma_alloc_attrs of size %ld failed\n", size);
 		kfree(buf);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -167,6 +171,16 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 	buf->size = size;
 	buf->dma_dir = dma_dir;
 
+	ret = dma_get_sgtable_attrs(buf->dev, &buf->__dma_sgt, buf->cookie,
+				    buf->dma_addr, buf->size, buf->attrs);
+	if (ret < 0) {
+		dma_free_attrs(dev, size, buf->cookie, buf->dma_addr,
+			       buf->attrs);
+		put_device(dev);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	buf->dma_sgt = &buf->__dma_sgt;
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_dc_put;
 	buf->handler.arg = buf;
@@ -339,6 +353,40 @@ static void *vb2_dc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
 	return buf->vaddr ? buf->vaddr + pgnum * PAGE_SIZE : NULL;
 }
 
+static int vb2_dc_dmabuf_ops_begin_cpu_access(struct dma_buf *dbuf,
+					      enum dma_data_direction direction)
+{
+	struct vb2_dc_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	/*
+	 * DMABUF exporter will flush the cache for us; only USERPTR
+	 * and MMAP buffers with non-coherent memory will be flushed.
+	 */
+	if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
+		dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents,
+				    buf->dma_dir);
+
+	return 0;
+}
+
+static int vb2_dc_dmabuf_ops_end_cpu_access(struct dma_buf *dbuf,
+					    enum dma_data_direction direction)
+{
+	struct vb2_dc_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	/*
+	 * DMABUF exporter will flush the cache for us; only USERPTR
+	 * and MMAP buffers with non-coherent memory will be flushed.
+	 */
+	if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
+		dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents,
+				       buf->dma_dir);
+
+	return 0;
+}
+
 static void *vb2_dc_dmabuf_ops_vmap(struct dma_buf *dbuf)
 {
 	struct vb2_dc_buf *buf = dbuf->priv;
@@ -359,6 +407,8 @@ static struct dma_buf_ops vb2_dc_dmabuf_ops = {
 	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
 	.kmap = vb2_dc_dmabuf_ops_kmap,
 	.kmap_atomic = vb2_dc_dmabuf_ops_kmap,
+	.begin_cpu_access = vb2_dc_dmabuf_ops_begin_cpu_access,
+	.end_cpu_access = vb2_dc_dmabuf_ops_end_cpu_access,
 	.vmap = vb2_dc_dmabuf_ops_vmap,
 	.mmap = vb2_dc_dmabuf_ops_mmap,
 	.release = vb2_dc_dmabuf_ops_release,
@@ -412,11 +462,12 @@ static void vb2_dc_put_userptr(void *buf_priv)
 
 	if (sgt) {
 		/*
-		 * No need to sync to CPU, it's already synced to the CPU
-		 * since the finish() memop will have been called before this.
+		 * Don't ask to skip cache sync in case if the user
+		 * did ask to skip cache flush the last time the
+		 * buffer was dequeued.
 		 */
 		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-				   buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
+				   buf->dma_dir, buf->attrs);
 		pages = frame_vector_pages(buf->vec);
 		/* sgt should exist only if vector contains pages... */
 		BUG_ON(IS_ERR(pages));
@@ -491,6 +542,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 
 	buf->dev = dev;
 	buf->dma_dir = dma_dir;
+	buf->attrs = attrs;
 
 	offset = vaddr & ~PAGE_MASK;
 	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
@@ -526,13 +578,11 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 	buf->dma_sgt = &buf->__dma_sgt;
 
 	/*
-	 * No need to sync to the device, this will happen later when the
-	 * prepare() memop is called.
+	 * Sync the cache now; the user might not ever ask for it.
 	 */
 	buf->dma_sgt->nents = dma_map_sg_attrs(buf->dev, buf->dma_sgt->sgl,
 					       buf->dma_sgt->orig_nents,
-					       buf->dma_dir,
-					       DMA_ATTR_SKIP_CPU_SYNC);
+					       buf->dma_dir, buf->attrs);
 	if (buf->dma_sgt->nents <= 0) {
 		pr_err("failed to map scatterlist\n");
 		ret = -EIO;
@@ -556,7 +606,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 fail_map_sg:
 	dma_unmap_sg_attrs(buf->dev, buf->dma_sgt->sgl,
 			   buf->dma_sgt->orig_nents, buf->dma_dir,
-			   DMA_ATTR_SKIP_CPU_SYNC);
+			   buf->attrs);
 
 fail_sgt_init:
 	sg_free_table(buf->dma_sgt);
-- 
2.7.4
