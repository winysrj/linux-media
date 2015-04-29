Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>, Pawel Osciak <pawel@osciak.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-media@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda <ricardo.ribalda@gmail.com>
Subject: [RESEND PATCH v2 1/3] media/videobuf2-dma-sg: Fix handling of sg_table
 structure
Date: Wed, 29 Apr 2015 14:00:45 +0200
Message-id: <1430308847-32140-2-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1430308847-32140-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1430308847-32140-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

From: Ricardo Ribalda <ricardo.ribalda@gmail.com>

When sg_alloc_table_from_pages() does not fail it returns a sg_table
structure with nents and nents_orig initialized to the same value.

dma_map_sg returns the number of areas mapped by the hardware,
which could be different than the areas given as an input.
The output must be saved to nent.

The output of dma_map, should be used to transverse the scatter list.

dma_unmap_sg needs the value passed to dma_map_sg (nents_orig).

sg_free_tables uses also orig_nent.

This patch fix the file to follow this paradigm.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 45c708e463b9..7289b81bd7b7 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -147,8 +147,9 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
 	 * No need to sync to the device, this will happen later when the
 	 * prepare() memop is called.
 	 */
-	if (dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->nents,
-			     buf->dma_dir, &attrs) == 0)
+	sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
+				      buf->dma_dir, &attrs);
+	if (!sgt->nents)
 		goto fail_map;
 
 	buf->handler.refcount = &buf->refcount;
@@ -187,7 +188,7 @@ static void vb2_dma_sg_put(void *buf_priv)
 		dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
 			buf->num_pages);
-		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->nents,
+		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
 				   buf->dma_dir, &attrs);
 		if (buf->vaddr)
 			vm_unmap_ram(buf->vaddr, buf->num_pages);
@@ -314,9 +315,11 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	 * No need to sync to the device, this will happen later when the
 	 * prepare() memop is called.
 	 */
-	if (dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->nents,
-			     buf->dma_dir, &attrs) == 0)
+	sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
+				      buf->dma_dir, &attrs);
+	if (!sgt->nents)
 		goto userptr_fail_map;
+
 	return buf;
 
 userptr_fail_map:
@@ -351,7 +354,8 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
 
 	dprintk(1, "%s: Releasing userspace buffer of %d pages\n",
 	       __func__, buf->num_pages);
-	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir, &attrs);
+	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir,
+			   &attrs);
 	if (buf->vaddr)
 		vm_unmap_ram(buf->vaddr, buf->num_pages);
 	sg_free_table(buf->dma_sgt);
@@ -502,7 +506,6 @@ static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
 	/* stealing dmabuf mutex to serialize map/unmap operations */
 	struct mutex *lock = &db_attach->dmabuf->lock;
 	struct sg_table *sgt;
-	int ret;
 
 	mutex_lock(lock);
 
@@ -521,8 +524,9 @@ static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
 	}
 
 	/* mapping to the client with new direction */
-	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dma_dir);
-	if (ret <= 0) {
+	sgt->nents = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
+				dma_dir);
+	if (!sgt->nents) {
 		pr_err("failed to map scatterlist\n");
 		mutex_unlock(lock);
 		return ERR_PTR(-EIO);
-- 
2.1.4
