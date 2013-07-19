Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:36848 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3GSRCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 13:02:46 -0400
Received: by mail-la0-f46.google.com with SMTP id hi8so835353lab.19
        for <linux-media@vger.kernel.org>; Fri, 19 Jul 2013 10:02:44 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, Andre Heider <a.heider@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 1/2] videobuf2-dma-sg: Allocate pages as contiguous as possible
Date: Fri, 19 Jul 2013 19:02:33 +0200
Message-Id: <1374253355-3788-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1374253355-3788-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1374253355-3788-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most DMA engines have limitations regarding the number of DMA segments
(sg-buffers) that they can handle. Videobuffers can easily spread
through houndreds of pages.

In the previous aproach, the pages were allocated individually, this
could led to the creation houndreds of dma segments (sg-buffers) that
could not be handled by some DMA engines.

This patch tries to minimize the number of DMA segments by using
alloc_pages. In the worst case it will behave as before, but most
of the times it will reduce the number of dma segments

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c |   60 +++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 16ae3dc..c053605 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -42,10 +42,55 @@ struct vb2_dma_sg_buf {
 
 static void vb2_dma_sg_put(void *buf_priv);
 
+static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
+		gfp_t gfp_flags)
+{
+	unsigned int last_page = 0;
+	int size = buf->sg_desc.size;
+
+	while (size > 0) {
+		struct page *pages;
+		int order;
+		int i;
+
+		order = get_order(size);
+		/* Dont over allocate*/
+		if ((PAGE_SIZE << order) > size)
+			order--;
+
+		pages = NULL;
+		while (!pages) {
+			pages = alloc_pages(GFP_KERNEL | __GFP_ZERO |
+					__GFP_NOWARN | gfp_flags, order);
+			if (pages)
+				break;
+
+			if (order == 0)
+				while (last_page--) {
+					__free_page(buf->pages[last_page]);
+					return -ENOMEM;
+				}
+			order--;
+		}
+
+		split_page(pages, order);
+		for (i = 0; i < (1<<order); i++) {
+			buf->pages[last_page] = pages[i];
+			sg_set_page(&buf->sg_desc.sglist[last_page],
+					buf->pages[last_page], PAGE_SIZE, 0);
+			last_page++;
+		}
+
+		size -= PAGE_SIZE << order;
+	}
+
+	return 0;
+}
+
 static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
 {
 	struct vb2_dma_sg_buf *buf;
-	int i;
+	int ret;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -69,14 +114,9 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
 	if (!buf->pages)
 		goto fail_pages_array_alloc;
 
-	for (i = 0; i < buf->sg_desc.num_pages; ++i) {
-		buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO |
-					   __GFP_NOWARN | gfp_flags);
-		if (NULL == buf->pages[i])
-			goto fail_pages_alloc;
-		sg_set_page(&buf->sg_desc.sglist[i],
-			    buf->pages[i], PAGE_SIZE, 0);
-	}
+	ret = vb2_dma_sg_alloc_compacted(buf, gfp_flags);
+	if (ret)
+		goto fail_pages_alloc;
 
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_dma_sg_put;
@@ -89,8 +129,6 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
 	return buf;
 
 fail_pages_alloc:
-	while (--i >= 0)
-		__free_page(buf->pages[i]);
 	kfree(buf->pages);
 
 fail_pages_array_alloc:
-- 
1.7.10.4

