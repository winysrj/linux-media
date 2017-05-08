Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:24873 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754916AbdEHPEs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 11:04:48 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 09/18] vb2: dma-contig: Allocate sgt as part of struct vb2_dc_buf
Date: Mon,  8 May 2017 18:03:21 +0300
Message-Id: <1494255810-12672-10-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The scatterlist table is needed in the vast majority of the cases.
Allocate struct sg_table as part of the struct. This has the benefit of
making managing the buffer data structure allocation, setup and release
more simple.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 83 ++++++++++----------------
 1 file changed, 32 insertions(+), 51 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 22636cd..0afc3da 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -30,6 +30,7 @@ struct vb2_dc_buf {
 	dma_addr_t			dma_addr;
 	unsigned long			attrs;
 	enum dma_data_direction		dma_dir;
+	struct sg_table			__dma_sgt;
 	struct sg_table			*dma_sgt;
 
 	/* MMAP related */
@@ -127,10 +128,9 @@ static void vb2_dc_put(void *buf_priv)
 	if (!refcount_dec_and_test(&buf->refcount))
 		return;
 
-	if (buf->dma_sgt) {
+	if (buf->dma_sgt)
 		sg_free_table(buf->dma_sgt);
-		kfree(buf->dma_sgt);
-	}
+
 	dma_free_attrs(buf->dev, buf->size, buf->cookie, buf->dma_addr,
 		       buf->attrs);
 	put_device(buf->dev);
@@ -364,26 +364,6 @@ static struct dma_buf_ops vb2_dc_dmabuf_ops = {
 	.release = vb2_dc_dmabuf_ops_release,
 };
 
-static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
-{
-	int ret;
-	struct sg_table *sgt;
-
-	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
-	if (!sgt)
-		return NULL;
-
-	ret = dma_get_sgtable_attrs(buf->dev, sgt, buf->cookie, buf->dma_addr,
-		buf->size, buf->attrs);
-	if (ret < 0) {
-		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
-		kfree(sgt);
-		return NULL;
-	}
-
-	return sgt;
-}
-
 static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
 {
 	struct vb2_dc_buf *buf = buf_priv;
@@ -395,11 +375,19 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
 	exp_info.flags = flags;
 	exp_info.priv = buf;
 
-	if (!buf->dma_sgt)
-		buf->dma_sgt = vb2_dc_get_base_sgt(buf);
+	if (!buf->dma_sgt) {
+		int ret;
 
-	if (!buf->dma_sgt)
-		return NULL;
+		ret = dma_get_sgtable_attrs(buf->dev, &buf->__dma_sgt,
+					    buf->cookie, buf->dma_addr,
+					    buf->size, buf->attrs);
+		if (ret < 0) {
+			dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
+			return NULL;
+		}
+
+		buf->dma_sgt = &buf->__dma_sgt;
+	}
 
 	dbuf = dma_buf_export(&exp_info);
 	if (IS_ERR(dbuf))
@@ -435,7 +423,6 @@ static void vb2_dc_put_userptr(void *buf_priv)
 		for (i = 0; i < frame_vector_count(buf->vec); i++)
 			set_page_dirty_lock(pages[i]);
 		sg_free_table(sgt);
-		kfree(sgt);
 	}
 	vb2_destroy_framevec(buf->vec);
 	kfree(buf);
@@ -481,7 +468,6 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 	unsigned long offset;
 	int n_pages, i;
 	int ret = 0;
-	struct sg_table *sgt;
 	unsigned long contig_size;
 	unsigned long dma_align = dma_get_cache_alignment();
 
@@ -529,33 +515,31 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 		goto out;
 	}
 
-	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
-	if (!sgt) {
-		pr_err("failed to allocate sg table\n");
-		ret = -ENOMEM;
-		goto fail_pfnvec;
-	}
-
-	ret = sg_alloc_table_from_pages(sgt, frame_vector_pages(vec), n_pages,
-		offset, size, GFP_KERNEL);
+	ret = sg_alloc_table_from_pages(&buf->__dma_sgt,
+					frame_vector_pages(vec), n_pages,
+					offset, size, GFP_KERNEL);
 	if (ret) {
 		pr_err("failed to initialize sg table\n");
-		goto fail_sgt;
+		goto fail_pfnvec;
 	}
 
+	buf->dma_sgt = &buf->__dma_sgt;
+
 	/*
 	 * No need to sync to the device, this will happen later when the
 	 * prepare() memop is called.
 	 */
-	sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-				      buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
-	if (sgt->nents <= 0) {
+	buf->dma_sgt->nents = dma_map_sg_attrs(buf->dev, buf->dma_sgt->sgl,
+					       buf->dma_sgt->orig_nents,
+					       buf->dma_dir,
+					       DMA_ATTR_SKIP_CPU_SYNC);
+	if (buf->dma_sgt->nents <= 0) {
 		pr_err("failed to map scatterlist\n");
 		ret = -EIO;
 		goto fail_sgt_init;
 	}
 
-	contig_size = vb2_dc_get_contiguous_size(sgt);
+	contig_size = vb2_dc_get_contiguous_size(buf->dma_sgt);
 	if (contig_size < size) {
 		pr_err("contiguous mapping is too small %lu/%lu\n",
 			contig_size, size);
@@ -563,22 +547,19 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 		goto fail_map_sg;
 	}
 
-	buf->dma_addr = sg_dma_address(sgt->sgl);
-	buf->dma_sgt = sgt;
+	buf->dma_addr = sg_dma_address(buf->dma_sgt->sgl);
 out:
 	buf->size = size;
 
 	return buf;
 
 fail_map_sg:
-	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
-			   buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
+	dma_unmap_sg_attrs(buf->dev, buf->dma_sgt->sgl,
+			   buf->dma_sgt->orig_nents, buf->dma_dir,
+			   DMA_ATTR_SKIP_CPU_SYNC);
 
 fail_sgt_init:
-	sg_free_table(sgt);
-
-fail_sgt:
-	kfree(sgt);
+	sg_free_table(buf->dma_sgt);
 
 fail_pfnvec:
 	vb2_destroy_framevec(vec);
-- 
2.7.4
