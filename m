Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:51643 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759898AbbBIQOc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2015 11:14:32 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 2/3] media/videobuf2-dma-contig: Fix handling of sg_table structure
Date: Mon,  9 Feb 2015 17:14:25 +0100
Message-Id: <1423498466-16718-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1423498466-16718-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1423498466-16718-1-git-send-email-ricardo.ribalda@gmail.com>
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
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index b481d20..c7e4bdd 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -56,7 +56,7 @@ static void vb2_dc_sgt_foreach_page(struct sg_table *sgt,
 	struct scatterlist *s;
 	unsigned int i;
 
-	for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
+	for_each_sg(sgt->sgl, s, sgt->nents, i) {
 		struct page *page = sg_page(s);
 		unsigned int n_pages = PAGE_ALIGN(s->offset + s->length)
 			>> PAGE_SHIFT;
@@ -260,7 +260,7 @@ static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
 
 	rd = buf->sgt_base->sgl;
 	wr = sgt->sgl;
-	for (i = 0; i < sgt->orig_nents; ++i) {
+	for (i = 0; i < sgt->nents; ++i) {
 		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
 		rd = sg_next(rd);
 		wr = sg_next(wr);
@@ -324,6 +324,7 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 		mutex_unlock(lock);
 		return ERR_PTR(-EIO);
 	}
+	sgt->nents = ret;
 
 	attach->dma_dir = dma_dir;
 
@@ -669,13 +670,14 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	 * No need to sync to the device, this will happen later when the
 	 * prepare() memop is called.
 	 */
-	sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
+	ret = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
 				      buf->dma_dir, &attrs);
-	if (sgt->nents <= 0) {
+	if (ret <= 0) {
 		pr_err("failed to map scatterlist\n");
 		ret = -EIO;
 		goto fail_sgt_init;
 	}
+	sgt->nents = ret;
 
 	contig_size = vb2_dc_get_contiguous_size(sgt);
 	if (contig_size < size) {
-- 
2.1.4

