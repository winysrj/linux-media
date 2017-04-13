Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:11521 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751228AbdDMH6D (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 03:58:03 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC v3 10/14] vb2: dma-contig: Fix DMA attribute and cache management
Date: Thu, 13 Apr 2017 10:57:15 +0300
Message-Id: <1492070239-21532-11-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
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
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 90 ++++++++++++++++++++------
 1 file changed, 69 insertions(+), 21 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 8ea9ab9..6a707d3 100644
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
@@ -116,12 +116,13 @@ static void vb2_dc_prepare(void *buf_priv)
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
@@ -129,11 +130,13 @@ static void vb2_dc_finish(void *buf_priv)
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
@@ -172,9 +175,9 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 
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
@@ -187,6 +190,14 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 	buf->size = size;
 	buf->dma_dir = dma_dir;
 
+	buf->dma_sgt = vb2_dc_get_base_sgt(buf);
+	if (!buf->dma_sgt) {
+		dma_free_attrs(dev, size, buf->cookie, buf->dma_addr,
+			       buf->attrs);
+		put_device(dev);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_dc_put;
 	buf->handler.arg = buf;
@@ -359,6 +370,40 @@ static void *vb2_dc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
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
@@ -379,6 +424,8 @@ static struct dma_buf_ops vb2_dc_dmabuf_ops = {
 	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
 	.kmap = vb2_dc_dmabuf_ops_kmap,
 	.kmap_atomic = vb2_dc_dmabuf_ops_kmap,
+	.begin_cpu_access = vb2_dc_dmabuf_ops_begin_cpu_access,
+	.end_cpu_access = vb2_dc_dmabuf_ops_end_cpu_access,
 	.vmap = vb2_dc_dmabuf_ops_vmap,
 	.mmap = vb2_dc_dmabuf_ops_mmap,
 	.release = vb2_dc_dmabuf_ops_release,
@@ -424,11 +471,12 @@ static void vb2_dc_put_userptr(void *buf_priv)
 
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
@@ -505,6 +553,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 
 	buf->dev = dev;
 	buf->dma_dir = dma_dir;
+	buf->attrs = attrs;
 
 	offset = vaddr & ~PAGE_MASK;
 	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
@@ -544,11 +593,10 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 	}
 
 	/*
-	 * No need to sync to the device, this will happen later when the
-	 * prepare() memop is called.
+	 * Sync the cache now; the user might not ever ask for it.
 	 */
 	sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-				      buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
+				      buf->dma_dir, buf->attrs);
 	if (sgt->nents <= 0) {
 		pr_err("failed to map scatterlist\n");
 		ret = -EIO;
@@ -572,7 +620,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 
 fail_map_sg:
 	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-			   buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
+			   buf->dma_dir, buf->attrs);
 
 fail_sgt_init:
 	sg_free_table(sgt);
-- 
2.7.4
