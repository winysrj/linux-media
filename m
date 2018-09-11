Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57486 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727789AbeIKSln (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 14:41:43 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com, daniel@ffwll.ch,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 08/13] udmabuf: improve udmabuf_create error handling
Date: Tue, 11 Sep 2018 15:42:11 +0200
Message-Id: <20180911134216.9760-9-kraxel@redhat.com>
In-Reply-To: <20180911134216.9760-1-kraxel@redhat.com>
References: <20180911134216.9760-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/dma-buf/udmabuf.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index a01fcf6a66..e821361566 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -126,7 +126,7 @@ static long udmabuf_create(const struct udmabuf_create_list *head,
 	struct file *memfd = NULL;
 	struct udmabuf *ubuf;
 	struct dma_buf *buf;
-	pgoff_t pgoff, pgcnt, pgidx, pgbuf, pglimit;
+	pgoff_t pgoff, pgcnt, pgidx, pgbuf = 0, pglimit;
 	struct page *page;
 	int seals, ret = -EINVAL;
 	u32 i, flags;
@@ -138,32 +138,32 @@ static long udmabuf_create(const struct udmabuf_create_list *head,
 	pglimit = (size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
 	for (i = 0; i < head->count; i++) {
 		if (!IS_ALIGNED(list[i].offset, PAGE_SIZE))
-			goto err_free_ubuf;
+			goto err;
 		if (!IS_ALIGNED(list[i].size, PAGE_SIZE))
-			goto err_free_ubuf;
+			goto err;
 		ubuf->pagecount += list[i].size >> PAGE_SHIFT;
 		if (ubuf->pagecount > pglimit)
-			goto err_free_ubuf;
+			goto err;
 	}
 	ubuf->pages = kmalloc_array(ubuf->pagecount, sizeof(struct page *),
 				    GFP_KERNEL);
 	if (!ubuf->pages) {
 		ret = -ENOMEM;
-		goto err_free_ubuf;
+		goto err;
 	}
 
 	pgbuf = 0;
 	for (i = 0; i < head->count; i++) {
 		memfd = fget(list[i].memfd);
 		if (!memfd)
-			goto err_put_pages;
+			goto err;
 		if (!shmem_mapping(file_inode(memfd)->i_mapping))
-			goto err_put_pages;
+			goto err;
 		seals = memfd_fcntl(memfd, F_GET_SEALS, 0);
 		if (seals == -EINVAL ||
 		    (seals & SEALS_WANTED) != SEALS_WANTED ||
 		    (seals & SEALS_DENIED) != 0)
-			goto err_put_pages;
+			goto err;
 		pgoff = list[i].offset >> PAGE_SHIFT;
 		pgcnt = list[i].size   >> PAGE_SHIFT;
 		for (pgidx = 0; pgidx < pgcnt; pgidx++) {
@@ -171,13 +171,13 @@ static long udmabuf_create(const struct udmabuf_create_list *head,
 				file_inode(memfd)->i_mapping, pgoff + pgidx);
 			if (IS_ERR(page)) {
 				ret = PTR_ERR(page);
-				goto err_put_pages;
+				goto err;
 			}
 			ubuf->pages[pgbuf++] = page;
 		}
 		fput(memfd);
+		memfd = NULL;
 	}
-	memfd = NULL;
 
 	exp_info.ops  = &udmabuf_ops;
 	exp_info.size = ubuf->pagecount << PAGE_SHIFT;
@@ -186,7 +186,7 @@ static long udmabuf_create(const struct udmabuf_create_list *head,
 	buf = dma_buf_export(&exp_info);
 	if (IS_ERR(buf)) {
 		ret = PTR_ERR(buf);
-		goto err_put_pages;
+		goto err;
 	}
 
 	flags = 0;
@@ -194,10 +194,9 @@ static long udmabuf_create(const struct udmabuf_create_list *head,
 		flags |= O_CLOEXEC;
 	return dma_buf_fd(buf, flags);
 
-err_put_pages:
+err:
 	while (pgbuf > 0)
 		put_page(ubuf->pages[--pgbuf]);
-err_free_ubuf:
 	if (memfd)
 		fput(memfd);
 	kfree(ubuf->pages);
-- 
2.9.3
