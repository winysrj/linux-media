Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:38706 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965628Ab3GSH74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 03:59:56 -0400
Received: by mail-la0-f52.google.com with SMTP id fo12so3208006lab.11
        for <linux-media@vger.kernel.org>; Fri, 19 Jul 2013 00:59:54 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	=?UTF-8?q?=C2=A0Mauro=20Carvalho=20Chehab?= <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	=?UTF-8?q?=C2=A0Ismael=20Luceno?=
	<ismael.luceno@corp.bluecherry.net>,
	=?UTF-8?q?=C2=A0Greg=20Kroah-Hartman?= <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 2/4] videobuf2-dma-sg: Replace vb2_dma_sg_desc with sg_table
Date: Fri, 19 Jul 2013 09:58:47 +0200
Message-Id: <1374220729-8304-3-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1374220729-8304-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1374220729-8304-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the private struct vb2_dma_sg_desc with the struct sg_table so
we can benefit from all the helping functions in lib/scatterlist.c for
things like allocating the sg or compacting the descriptor

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c |  103 ++++++++++++----------------
 include/media/videobuf2-dma-sg.h           |   10 +--
 2 files changed, 45 insertions(+), 68 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 9bf02c3..5baf03d 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -35,7 +35,9 @@ struct vb2_dma_sg_buf {
 	struct page			**pages;
 	int				write;
 	int				offset;
-	struct vb2_dma_sg_desc		sg_desc;
+	struct sg_table			sg_table;
+	size_t				size;
+	unsigned int			num_pages;
 	atomic_t			refcount;
 	struct vb2_vmarea_handler	handler;
 };
@@ -46,7 +48,7 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
 		gfp_t gfp_flags)
 {
 	unsigned int last_page = 0;
-	int size = buf->sg_desc.size;
+	int size = buf->size;
 
 	while (size > 0) {
 		struct page *pages;
@@ -74,12 +76,8 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
 		}
 
 		split_page(pages, order);
-		for (i = 0; i < (1<<order); i++) {
-			buf->pages[last_page] = pages + i;
-			sg_set_page(&buf->sg_desc.sglist[last_page],
-					buf->pages[last_page], PAGE_SIZE, 0);
-			last_page++;
-		}
+		for (i = 0; i < (1<<order); i++)
+			buf->pages[last_page++] = pages + i;
 
 		size -= PAGE_SIZE << order;
 	}
@@ -91,6 +89,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
 {
 	struct vb2_dma_sg_buf *buf;
 	int ret;
+	int num_pages;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -99,17 +98,11 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
 	buf->vaddr = NULL;
 	buf->write = 0;
 	buf->offset = 0;
-	buf->sg_desc.size = size;
+	buf->size = size;
 	/* size is already page aligned */
-	buf->sg_desc.num_pages = size >> PAGE_SHIFT;
-
-	buf->sg_desc.sglist = vzalloc(buf->sg_desc.num_pages *
-				      sizeof(*buf->sg_desc.sglist));
-	if (!buf->sg_desc.sglist)
-		goto fail_sglist_alloc;
-	sg_init_table(buf->sg_desc.sglist, buf->sg_desc.num_pages);
+	buf->num_pages = size >> PAGE_SHIFT;
 
-	buf->pages = kzalloc(buf->sg_desc.num_pages * sizeof(struct page *),
+	buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
 			     GFP_KERNEL);
 	if (!buf->pages)
 		goto fail_pages_array_alloc;
@@ -118,6 +111,11 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
 	if (ret)
 		goto fail_pages_alloc;
 
+	ret = sg_alloc_table_from_pages(&buf->sg_table, buf->pages,
+			buf->num_pages, 0, size, gfp_flags);
+	if (ret)
+		goto fail_table_alloc;
+
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_dma_sg_put;
 	buf->handler.arg = buf;
@@ -125,16 +123,16 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
 	atomic_inc(&buf->refcount);
 
 	dprintk(1, "%s: Allocated buffer of %d pages\n",
-		__func__, buf->sg_desc.num_pages);
+		__func__, buf->num_pages);
 	return buf;
 
+fail_table_alloc:
+	num_pages = buf->num_pages;
+	while (--num_pages >= 0)
+		__free_page(buf->pages[num_pages]);
 fail_pages_alloc:
 	kfree(buf->pages);
-
 fail_pages_array_alloc:
-	vfree(buf->sg_desc.sglist);
-
-fail_sglist_alloc:
 	kfree(buf);
 	return NULL;
 }
@@ -142,14 +140,14 @@ fail_sglist_alloc:
 static void vb2_dma_sg_put(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
-	int i = buf->sg_desc.num_pages;
+	int i = buf->num_pages;
 
 	if (atomic_dec_and_test(&buf->refcount)) {
 		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
-			buf->sg_desc.num_pages);
+			buf->num_pages);
 		if (buf->vaddr)
-			vm_unmap_ram(buf->vaddr, buf->sg_desc.num_pages);
-		vfree(buf->sg_desc.sglist);
+			vm_unmap_ram(buf->vaddr, buf->num_pages);
+		sg_free_table(&buf->sg_table);
 		while (--i >= 0)
 			__free_page(buf->pages[i]);
 		kfree(buf->pages);
@@ -162,7 +160,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 {
 	struct vb2_dma_sg_buf *buf;
 	unsigned long first, last;
-	int num_pages_from_user, i;
+	int num_pages_from_user;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -171,56 +169,41 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	buf->vaddr = NULL;
 	buf->write = write;
 	buf->offset = vaddr & ~PAGE_MASK;
-	buf->sg_desc.size = size;
+	buf->size = size;
 
 	first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
 	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
-	buf->sg_desc.num_pages = last - first + 1;
-
-	buf->sg_desc.sglist = vzalloc(
-		buf->sg_desc.num_pages * sizeof(*buf->sg_desc.sglist));
-	if (!buf->sg_desc.sglist)
-		goto userptr_fail_sglist_alloc;
+	buf->num_pages = last - first + 1;
 
-	sg_init_table(buf->sg_desc.sglist, buf->sg_desc.num_pages);
-
-	buf->pages = kzalloc(buf->sg_desc.num_pages * sizeof(struct page *),
+	buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
 			     GFP_KERNEL);
 	if (!buf->pages)
-		goto userptr_fail_pages_array_alloc;
+		return NULL;
 
 	num_pages_from_user = get_user_pages(current, current->mm,
 					     vaddr & PAGE_MASK,
-					     buf->sg_desc.num_pages,
+					     buf->num_pages,
 					     write,
 					     1, /* force */
 					     buf->pages,
 					     NULL);
 
-	if (num_pages_from_user != buf->sg_desc.num_pages)
+	if (num_pages_from_user != buf->num_pages)
 		goto userptr_fail_get_user_pages;
 
-	sg_set_page(&buf->sg_desc.sglist[0], buf->pages[0],
-		    PAGE_SIZE - buf->offset, buf->offset);
-	size -= PAGE_SIZE - buf->offset;
-	for (i = 1; i < buf->sg_desc.num_pages; ++i) {
-		sg_set_page(&buf->sg_desc.sglist[i], buf->pages[i],
-			    min_t(size_t, PAGE_SIZE, size), 0);
-		size -= min_t(size_t, PAGE_SIZE, size);
-	}
+	if (sg_alloc_table_from_pages(&buf->sg_table, buf->pages,
+			buf->num_pages, buf->offset, size, 0))
+		goto userptr_fail_alloc_table_from_pages;
+
 	return buf;
 
+userptr_fail_alloc_table_from_pages:
 userptr_fail_get_user_pages:
 	dprintk(1, "get_user_pages requested/got: %d/%d]\n",
-	       num_pages_from_user, buf->sg_desc.num_pages);
+	       num_pages_from_user, buf->num_pages);
 	while (--num_pages_from_user >= 0)
 		put_page(buf->pages[num_pages_from_user]);
 	kfree(buf->pages);
-
-userptr_fail_pages_array_alloc:
-	vfree(buf->sg_desc.sglist);
-
-userptr_fail_sglist_alloc:
 	kfree(buf);
 	return NULL;
 }
@@ -232,18 +215,18 @@ userptr_fail_sglist_alloc:
 static void vb2_dma_sg_put_userptr(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
-	int i = buf->sg_desc.num_pages;
+	int i = buf->num_pages;
 
 	dprintk(1, "%s: Releasing userspace buffer of %d pages\n",
-	       __func__, buf->sg_desc.num_pages);
+	       __func__, buf->num_pages);
 	if (buf->vaddr)
-		vm_unmap_ram(buf->vaddr, buf->sg_desc.num_pages);
+		vm_unmap_ram(buf->vaddr, buf->num_pages);
+	sg_free_table(&buf->sg_table);
 	while (--i >= 0) {
 		if (buf->write)
 			set_page_dirty_lock(buf->pages[i]);
 		put_page(buf->pages[i]);
 	}
-	vfree(buf->sg_desc.sglist);
 	kfree(buf->pages);
 	kfree(buf);
 }
@@ -256,7 +239,7 @@ static void *vb2_dma_sg_vaddr(void *buf_priv)
 
 	if (!buf->vaddr)
 		buf->vaddr = vm_map_ram(buf->pages,
-					buf->sg_desc.num_pages,
+					buf->num_pages,
 					-1,
 					PAGE_KERNEL);
 
@@ -312,7 +295,7 @@ static void *vb2_dma_sg_cookie(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
 
-	return &buf->sg_desc;
+	return &buf->sg_table;
 }
 
 const struct vb2_mem_ops vb2_dma_sg_memops = {
diff --git a/include/media/videobuf2-dma-sg.h b/include/media/videobuf2-dma-sg.h
index 0038526..7b89852 100644
--- a/include/media/videobuf2-dma-sg.h
+++ b/include/media/videobuf2-dma-sg.h
@@ -15,16 +15,10 @@
 
 #include <media/videobuf2-core.h>
 
-struct vb2_dma_sg_desc {
-	unsigned long		size;
-	unsigned int		num_pages;
-	struct scatterlist	*sglist;
-};
-
-static inline struct vb2_dma_sg_desc *vb2_dma_sg_plane_desc(
+static inline struct sg_table *vb2_dma_sg_plane_desc(
 		struct vb2_buffer *vb, unsigned int plane_no)
 {
-	return (struct vb2_dma_sg_desc *)vb2_plane_cookie(vb, plane_no);
+	return (struct sg_table *)vb2_plane_cookie(vb, plane_no);
 }
 
 extern const struct vb2_mem_ops vb2_dma_sg_memops;
-- 
1.7.10.4

