Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53447 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2EWNHr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 09:07:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4H00B1E8HCEU30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:08:00 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H00KL28GX5D@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:45 +0100 (BST)
Date: Wed, 23 May 2012 15:07:34 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 11/12] v4l: vb2-dma-contig: use sg_alloc_table_from_pages
 function
In-reply-to: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337778455-27912-12-git-send-email-t.stanislaws@samsung.com>
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch makes use of sg_alloc_table_from_pages to simplify
handling of sg tables.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   90 ++++++++--------------------
 1 file changed, 25 insertions(+), 65 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 59ee81c..b5caf1d 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -32,7 +32,7 @@ struct vb2_dc_buf {
 	/* MMAP related */
 	struct vb2_vmarea_handler	handler;
 	atomic_t			refcount;
-	struct sg_table			*sgt_base;
+	struct sg_table			sgt_base;
 
 	/* USERPTR related */
 	struct vm_area_struct		*vma;
@@ -45,57 +45,6 @@ struct vb2_dc_buf {
 /*        scatterlist table functions        */
 /*********************************************/
 
-static struct sg_table *vb2_dc_pages_to_sgt(struct page **pages,
-	unsigned int n_pages, unsigned long offset, unsigned long size)
-{
-	struct sg_table *sgt;
-	unsigned int chunks;
-	unsigned int i;
-	unsigned int cur_page;
-	int ret;
-	struct scatterlist *s;
-
-	sgt = kzalloc(sizeof *sgt, GFP_KERNEL);
-	if (!sgt)
-		return ERR_PTR(-ENOMEM);
-
-	/* compute number of chunks */
-	chunks = 1;
-	for (i = 1; i < n_pages; ++i)
-		if (pages[i] != pages[i - 1] + 1)
-			++chunks;
-
-	ret = sg_alloc_table(sgt, chunks, GFP_KERNEL);
-	if (ret) {
-		kfree(sgt);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	/* merging chunks and putting them into the scatterlist */
-	cur_page = 0;
-	for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
-		unsigned long chunk_size;
-		unsigned int j;
-
-		for (j = cur_page + 1; j < n_pages; ++j)
-			if (pages[j] != pages[j - 1] + 1)
-				break;
-
-		chunk_size = ((j - cur_page) << PAGE_SHIFT) - offset;
-		sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
-		size -= chunk_size;
-		offset = 0;
-		cur_page = j;
-	}
-
-	return sgt;
-}
-
-static void vb2_dc_release_sgtable(struct sg_table *sgt)
-{
-	sg_free_table(sgt);
-	kfree(sgt);
-}
 
 static void vb2_dc_sgt_foreach_page(struct sg_table *sgt,
 	void (*cb)(struct page *pg))
@@ -190,7 +139,7 @@ static void vb2_dc_put(void *buf_priv)
 	if (!atomic_dec_and_test(&buf->refcount))
 		return;
 
-	vb2_dc_release_sgtable(buf->sgt_base);
+	sg_free_table(&buf->sgt_base);
 	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
 	kfree(buf);
 }
@@ -254,9 +203,9 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 		goto fail_pages;
 	}
 
-	buf->sgt_base = vb2_dc_pages_to_sgt(pages, n_pages, 0, size);
-	if (IS_ERR(buf->sgt_base)) {
-		ret = PTR_ERR(buf->sgt_base);
+	ret = sg_alloc_table_from_pages(&buf->sgt_base,
+		pages, n_pages, 0, size, GFP_KERNEL);
+	if (ret) {
 		dev_err(dev, "failed to prepare sg table\n");
 		goto fail_pages;
 	}
@@ -379,13 +328,13 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 	attach->dir = dir;
 
 	/* copying the buf->base_sgt to attachment */
-	ret = sg_alloc_table(sgt, buf->sgt_base->orig_nents, GFP_KERNEL);
+	ret = sg_alloc_table(sgt, buf->sgt_base.orig_nents, GFP_KERNEL);
 	if (ret) {
 		kfree(attach);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	rd = buf->sgt_base->sgl;
+	rd = buf->sgt_base.sgl;
 	wr = sgt->sgl;
 	for (i = 0; i < sgt->orig_nents; ++i) {
 		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
@@ -519,7 +468,8 @@ static void vb2_dc_put_userptr(void *buf_priv)
 	if (!vma_is_io(buf->vma))
 		vb2_dc_sgt_foreach_page(sgt, vb2_dc_put_dirty_page);
 
-	vb2_dc_release_sgtable(sgt);
+	sg_free_table(sgt);
+	kfree(sgt);
 	vb2_put_vma(buf->vma);
 	kfree(buf);
 }
@@ -586,13 +536,20 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 		goto fail_vma;
 	}
 
-	sgt = vb2_dc_pages_to_sgt(pages, n_pages, offset, size);
-	if (IS_ERR(sgt)) {
-		printk(KERN_ERR "failed to create scatterlist table\n");
+	sgt = kzalloc(sizeof *sgt, GFP_KERNEL);
+	if (!sgt) {
+		printk(KERN_ERR "failed to allocate sg table\n");
 		ret = -ENOMEM;
 		goto fail_get_user_pages;
 	}
 
+	ret = sg_alloc_table_from_pages(sgt, pages, n_pages,
+		offset, size, GFP_KERNEL);
+	if (ret) {
+		printk(KERN_ERR "failed to initialize sg table\n");
+		goto fail_sgt;
+	}
+
 	/* pages are no longer needed */
 	kfree(pages);
 	pages = NULL;
@@ -602,7 +559,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	if (sgt->nents <= 0) {
 		printk(KERN_ERR "failed to map scatterlist\n");
 		ret = -EIO;
-		goto fail_sgt;
+		goto fail_sgt_init;
 	}
 
 	contig_size = vb2_dc_get_contiguous_size(sgt);
@@ -622,10 +579,13 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 fail_map_sg:
 	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 
-fail_sgt:
+fail_sgt_init:
 	if (!vma_is_io(buf->vma))
 		vb2_dc_sgt_foreach_page(sgt, put_page);
-	vb2_dc_release_sgtable(sgt);
+	sg_free_table(sgt);
+
+fail_sgt:
+	kfree(sgt);
 
 fail_get_user_pages:
 	if (pages && !vma_is_io(buf->vma))
-- 
1.7.9.5

