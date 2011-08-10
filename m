Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46934 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1HJIXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2011 04:23:50 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LPP00MG6DZP52@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Aug 2011 09:23:49 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPP00LRGDZORQ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Aug 2011 09:23:48 +0100 (BST)
Date: Wed, 10 Aug 2011 10:23:37 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: dma-sg allocator: change scatterlist allocation
 method
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <1312964617-3192-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

Scatter-gather lib provides a helper functions to allocate scatter list,
so there is no need to use vmalloc for it. sg_alloc_table() splits
allocation into page size chunks and links them together into a chain.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-dma-sg.c |   54 +++++++++++++++++++------------
 1 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-sg.c b/drivers/media/video/videobuf2-dma-sg.c
index 065f468..e1158f9 100644
--- a/drivers/media/video/videobuf2-dma-sg.c
+++ b/drivers/media/video/videobuf2-dma-sg.c
@@ -36,6 +36,8 @@ static void vb2_dma_sg_put(void *buf_priv);
 static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size)
 {
 	struct vb2_dma_sg_buf *buf;
+	struct sg_table sgt;
+	struct scatterlist *sl;
 	int i;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
@@ -48,23 +50,21 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size)
 	buf->sg_desc.size = size;
 	buf->sg_desc.num_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
-	buf->sg_desc.sglist = vzalloc(buf->sg_desc.num_pages *
-				      sizeof(*buf->sg_desc.sglist));
-	if (!buf->sg_desc.sglist)
+	if (sg_alloc_table(&sgt, buf->sg_desc.num_pages, GFP_KERNEL))
 		goto fail_sglist_alloc;
-	sg_init_table(buf->sg_desc.sglist, buf->sg_desc.num_pages);
+	buf->sg_desc.sglist = sgt.sgl;
 
 	buf->pages = kzalloc(buf->sg_desc.num_pages * sizeof(struct page *),
 			     GFP_KERNEL);
 	if (!buf->pages)
 		goto fail_pages_array_alloc;
 
-	for (i = 0; i < buf->sg_desc.num_pages; ++i) {
-		buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN);
+	for_each_sg(buf->sg_desc.sglist, sl, buf->sg_desc.num_pages, i) {
+		buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO |
+					   __GFP_NOWARN);
 		if (NULL == buf->pages[i])
 			goto fail_pages_alloc;
-		sg_set_page(&buf->sg_desc.sglist[i],
-			    buf->pages[i], PAGE_SIZE, 0);
+		sg_set_page(sl, buf->pages[i], PAGE_SIZE, 0);
 	}
 
 	buf->handler.refcount = &buf->refcount;
@@ -89,7 +89,7 @@ fail_pages_alloc:
 	kfree(buf->pages);
 
 fail_pages_array_alloc:
-	vfree(buf->sg_desc.sglist);
+	sg_free_table(&sgt);
 
 fail_sglist_alloc:
 	kfree(buf);
@@ -99,6 +99,7 @@ fail_sglist_alloc:
 static void vb2_dma_sg_put(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
+	struct sg_table sgt;
 	int i = buf->sg_desc.num_pages;
 
 	if (atomic_dec_and_test(&buf->refcount)) {
@@ -106,7 +107,9 @@ static void vb2_dma_sg_put(void *buf_priv)
 			buf->sg_desc.num_pages);
 		if (buf->vaddr)
 			vm_unmap_ram(buf->vaddr, buf->sg_desc.num_pages);
-		vfree(buf->sg_desc.sglist);
+		sgt.sgl = buf->sg_desc.sglist;
+		sgt.orig_nents = sgt.nents = i;
+		sg_free_table(&sgt);
 		while (--i >= 0)
 			__free_page(buf->pages[i]);
 		kfree(buf->pages);
@@ -118,6 +121,8 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 				    unsigned long size, int write)
 {
 	struct vb2_dma_sg_buf *buf;
+	struct sg_table sgt;
+	struct scatterlist *sl;
 	unsigned long first, last;
 	int num_pages_from_user, i;
 
@@ -134,12 +139,9 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
 	buf->sg_desc.num_pages = last - first + 1;
 
-	buf->sg_desc.sglist = vzalloc(
-		buf->sg_desc.num_pages * sizeof(*buf->sg_desc.sglist));
-	if (!buf->sg_desc.sglist)
+	if (sg_alloc_table(&sgt, buf->sg_desc.num_pages, GFP_KERNEL))
 		goto userptr_fail_sglist_alloc;
-
-	sg_init_table(buf->sg_desc.sglist, buf->sg_desc.num_pages);
+	buf->sg_desc.sglist = sgt.sgl;
 
 	buf->pages = kzalloc(buf->sg_desc.num_pages * sizeof(struct page *),
 			     GFP_KERNEL);
@@ -158,12 +160,12 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	if (num_pages_from_user != buf->sg_desc.num_pages)
 		goto userptr_fail_get_user_pages;
 
-	sg_set_page(&buf->sg_desc.sglist[0], buf->pages[0],
-		    PAGE_SIZE - buf->offset, buf->offset);
+	sl = buf->sg_desc.sglist;
+	sg_set_page(sl, buf->pages[0], PAGE_SIZE - buf->offset, buf->offset);
 	size -= PAGE_SIZE - buf->offset;
 	for (i = 1; i < buf->sg_desc.num_pages; ++i) {
-		sg_set_page(&buf->sg_desc.sglist[i], buf->pages[i],
-			    min_t(size_t, PAGE_SIZE, size), 0);
+		sl = sg_next(sl);
+		sg_set_page(sl, buf->pages[i], min_t(size_t, PAGE_SIZE, size), 0);
 		size -= min_t(size_t, PAGE_SIZE, size);
 	}
 	return buf;
@@ -176,7 +178,7 @@ userptr_fail_get_user_pages:
 	kfree(buf->pages);
 
 userptr_fail_pages_array_alloc:
-	vfree(buf->sg_desc.sglist);
+	sg_free_table(&sgt);
 
 userptr_fail_sglist_alloc:
 	kfree(buf);
@@ -190,6 +192,8 @@ userptr_fail_sglist_alloc:
 static void vb2_dma_sg_put_userptr(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
+	struct sg_table sgt;
+
 	int i = buf->sg_desc.num_pages;
 
 	printk(KERN_DEBUG "%s: Releasing userspace buffer of %d pages\n",
@@ -201,7 +205,9 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
 			set_page_dirty_lock(buf->pages[i]);
 		put_page(buf->pages[i]);
 	}
-	vfree(buf->sg_desc.sglist);
+	sgt.sgl = buf->sg_desc.sglist;
+	sgt.orig_nents = sgt.nents = buf->sg_desc.num_pages;
+	sg_free_table(&sgt);
 	kfree(buf->pages);
 	kfree(buf);
 }
@@ -218,6 +224,12 @@ static void *vb2_dma_sg_vaddr(void *buf_priv)
 					-1,
 					PAGE_KERNEL);
 
+	if (!buf->vaddr) {
+		printk(KERN_ERR "Cannot map buffer memory "
+				"into kernel address space\n");
+		return NULL;
+	}
+
 	/* add offset in case userptr is not page-aligned */
 	return buf->vaddr + buf->offset;
 }
-- 
1.7.1.569.g6f426

