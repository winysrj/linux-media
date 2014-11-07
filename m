Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:52126 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbaKGJAD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 04:00:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv5 PATCH 10/15] vb2: use dma_map_sg_attrs to prevent unnecessary sync
Date: Fri,  7 Nov 2014 09:50:29 +0100
Message-Id: <1415350234-9826-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
References: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

By default dma_map_sg syncs the mapped buffer to the device. But
buf_prepare expects a buffer syncs for the cpu and the buffer
will be synced to the device in the prepare memop.

The reverse is true for dma_unmap_sg, buf_finish and the finish
memop.

To prevent unnecessary syncs we ask dma_(un)map_sg to skip the
sync.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 29 +++++++++++++++++-----
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 33 +++++++++++++++++++++-----
 2 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index c4305bf..27f5926 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -317,8 +317,9 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 		attach->dma_dir = DMA_NONE;
 	}
 
-	/* mapping to the client with new direction */
-	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dma_dir);
+	/* Mapping to the client with new direction */
+	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
+			 dma_dir);
 	if (ret <= 0) {
 		pr_err("failed to map scatterlist\n");
 		mutex_unlock(lock);
@@ -511,7 +512,15 @@ static void vb2_dc_put_userptr(void *buf_priv)
 	struct sg_table *sgt = buf->dma_sgt;
 
 	if (sgt) {
-		dma_unmap_sg(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
+		DEFINE_DMA_ATTRS(attrs);
+
+		dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
+		/*
+		 * No need to sync to CPU, it's already synced to the CPU
+		 * since the finish() memop will have been called before this.
+		 */
+		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
+				   buf->dma_dir, &attrs);
 		if (!vma_is_io(buf->vma))
 			vb2_dc_sgt_foreach_page(sgt, vb2_dc_put_dirty_page);
 
@@ -568,6 +577,9 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	struct sg_table *sgt;
 	unsigned long contig_size;
 	unsigned long dma_align = dma_get_cache_alignment();
+	DEFINE_DMA_ATTRS(attrs);
+
+	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 
 	/* Only cache aligned DMA transfers are reliable */
 	if (!IS_ALIGNED(vaddr | size, dma_align)) {
@@ -654,8 +666,12 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	kfree(pages);
 	pages = NULL;
 
-	sgt->nents = dma_map_sg(buf->dev, sgt->sgl, sgt->orig_nents,
-		buf->dma_dir);
+	/*
+	 * No need to sync to the device, this will happen later when the
+	 * prepare() memop is called.
+	 */
+	sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
+				      buf->dma_dir, &attrs);
 	if (sgt->nents <= 0) {
 		pr_err("failed to map scatterlist\n");
 		ret = -EIO;
@@ -677,7 +693,8 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	return buf;
 
 fail_map_sg:
-	dma_unmap_sg(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
+	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
+			   buf->dma_dir, &attrs);
 
 fail_sgt_init:
 	if (!vma_is_io(buf->vma))
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 49ba502..4d0e552 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -103,6 +103,9 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
 	struct sg_table *sgt;
 	int ret;
 	int num_pages;
+	DEFINE_DMA_ATTRS(attrs);
+
+	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 
 	if (WARN_ON(alloc_ctx == NULL))
 		return NULL;
@@ -136,9 +139,13 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
 	buf->dev = get_device(conf->dev);
 
 	sgt = &buf->sg_table;
-	if (dma_map_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir) == 0)
+	/*
+	 * No need to sync to the device, this will happen later when the
+	 * prepare() memop is called.
+	 */
+	if (dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->nents,
+			     buf->dma_dir, &attrs) == 0)
 		goto fail_map;
-	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_dma_sg_put;
@@ -171,9 +178,13 @@ static void vb2_dma_sg_put(void *buf_priv)
 	int i = buf->num_pages;
 
 	if (atomic_dec_and_test(&buf->refcount)) {
+		DEFINE_DMA_ATTRS(attrs);
+
+		dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
 			buf->num_pages);
-		dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->nents,
+				   buf->dma_dir, &attrs);
 		if (buf->vaddr)
 			vm_unmap_ram(buf->vaddr, buf->num_pages);
 		sg_free_table(buf->dma_sgt);
@@ -224,6 +235,9 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	int num_pages_from_user;
 	struct vm_area_struct *vma;
 	struct sg_table *sgt;
+	DEFINE_DMA_ATTRS(attrs);
+
+	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -294,9 +308,13 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	buf->dev = get_device(conf->dev);
 
 	sgt = &buf->sg_table;
-	if (dma_map_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir) == 0)
+	/*
+	 * No need to sync to the device, this will happen later when the
+	 * prepare() memop is called.
+	 */
+	if (dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->nents,
+			     buf->dma_dir, &attrs) == 0)
 		goto userptr_fail_map;
-	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 	return buf;
 
 userptr_fail_map:
@@ -325,10 +343,13 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
 	struct vb2_dma_sg_buf *buf = buf_priv;
 	struct sg_table *sgt = &buf->sg_table;
 	int i = buf->num_pages;
+	DEFINE_DMA_ATTRS(attrs);
+
+	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 
 	dprintk(1, "%s: Releasing userspace buffer of %d pages\n",
 	       __func__, buf->num_pages);
-	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir, &attrs);
 	if (buf->vaddr)
 		vm_unmap_ram(buf->vaddr, buf->num_pages);
 	sg_free_table(buf->dma_sgt);
-- 
2.1.1

