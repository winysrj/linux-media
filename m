Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:37228 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759816AbbBIQOc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2015 11:14:32 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 1/3] media/videobuf2-dma-sg: Fix handling of sg_table structure
Date: Mon,  9 Feb 2015 17:14:24 +0100
Message-Id: <1423498466-16718-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

when sg_alloc_table_from_pages() does not fail it returns a sg_table
structure with nents and nents_orig initialized to the same value.

dma_map_sg returns the dma_map_sg returns the number of areas mapped
by the hardware, which could be different than the areas given as an input.
The output must be saved to nent.
Unfortunately nent differs in sign to the output of dma_map_sg, so an
intermediate value must be used.

The output of dma_map, should be used to transverse the scatter list.

dma_unmap_sg needs the value passed to dma_map_sg (nents_orig).

sg_free_tables uses also orig_nent.

This patch fix the file to follow this paradigm.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index b1838ab..30bac99 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -147,9 +147,11 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
 	 * No need to sync to the device, this will happen later when the
 	 * prepare() memop is called.
 	 */
-	if (dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->nents,
-			     buf->dma_dir, &attrs) == 0)
+	ret = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
+			buf->dma_dir, &attrs);
+	if (ret <= 0)
 		goto fail_map;
+	sgt->nents = ret;
 
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_dma_sg_put;
@@ -187,7 +189,7 @@ static void vb2_dma_sg_put(void *buf_priv)
 		dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
 			buf->num_pages);
-		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->nents,
+		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
 				   buf->dma_dir, &attrs);
 		if (buf->vaddr)
 			vm_unmap_ram(buf->vaddr, buf->num_pages);
@@ -240,6 +242,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	struct vm_area_struct *vma;
 	struct sg_table *sgt;
 	DEFINE_DMA_ATTRS(attrs);
+	int ret;
 
 	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 
@@ -314,9 +317,12 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	 * No need to sync to the device, this will happen later when the
 	 * prepare() memop is called.
 	 */
-	if (dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->nents,
-			     buf->dma_dir, &attrs) == 0)
+	ret = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
+			     buf->dma_dir, &attrs);
+	if (ret <= 0)
 		goto userptr_fail_map;
+	sgt->nents = ret;
+
 	return buf;
 
 userptr_fail_map:
@@ -351,7 +357,8 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
 
 	dprintk(1, "%s: Releasing userspace buffer of %d pages\n",
 	       __func__, buf->num_pages);
-	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir, &attrs);
+	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir,
+			&attrs);
 	if (buf->vaddr)
 		vm_unmap_ram(buf->vaddr, buf->num_pages);
 	sg_free_table(buf->dma_sgt);
@@ -463,7 +470,7 @@ static int vb2_dma_sg_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev
 
 	rd = buf->dma_sgt->sgl;
 	wr = sgt->sgl;
-	for (i = 0; i < sgt->orig_nents; ++i) {
+	for (i = 0; i < sgt->nents; ++i) {
 		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
 		rd = sg_next(rd);
 		wr = sg_next(wr);
@@ -527,6 +534,7 @@ static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
 		mutex_unlock(lock);
 		return ERR_PTR(-EIO);
 	}
+	sgt->nents = ret;
 
 	attach->dma_dir = dma_dir;
 
-- 
2.1.4

