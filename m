Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726587AbeIKL5R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 07:57:17 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 07/10] udmabuf: rework limits
Date: Tue, 11 Sep 2018 08:59:18 +0200
Message-Id: <20180911065921.23818-8-kraxel@redhat.com>
In-Reply-To: <20180911065921.23818-1-kraxel@redhat.com>
References: <20180911065921.23818-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create variable for the list length limit.  Serves as documentation,
also allows to make it a module parameter if needed.

Also add a total size limit.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/dma-buf/udmabuf.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 0cf7e85585..cb99a7886a 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -12,6 +12,9 @@
 #include <linux/shmem_fs.h>
 #include <linux/udmabuf.h>
 
+static int list_limit = 1024;  /* udmabuf_create_list->count limit */
+static int size_limit_mb = 64; /* total dmabuf size, in megabytes  */
+
 struct udmabuf {
 	pgoff_t pagecount;
 	struct page **pages;
@@ -123,7 +126,7 @@ static long udmabuf_create(struct const udmabuf_create_list *head,
 	struct file *memfd = NULL;
 	struct udmabuf *ubuf;
 	struct dma_buf *buf;
-	pgoff_t pgoff, pgcnt, pgidx, pgbuf;
+	pgoff_t pgoff, pgcnt, pgidx, pgbuf, pglimit;
 	struct page *page;
 	int seals, ret = -EINVAL;
 	u32 i, flags;
@@ -132,12 +135,15 @@ static long udmabuf_create(struct const udmabuf_create_list *head,
 	if (!ubuf)
 		return -ENOMEM;
 
+	pglimit = (size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
 	for (i = 0; i < head->count; i++) {
 		if (!IS_ALIGNED(list[i].offset, PAGE_SIZE))
 			goto err_free_ubuf;
 		if (!IS_ALIGNED(list[i].size, PAGE_SIZE))
 			goto err_free_ubuf;
 		ubuf->pagecount += list[i].size >> PAGE_SHIFT;
+		if (ubuf->pagecount > pglimit)
+			goto err_free_ubuf;
 	}
 	ubuf->pages = kmalloc_array(ubuf->pagecount, sizeof(struct page *),
 				    GFP_KERNEL);
@@ -227,7 +233,7 @@ static long udmabuf_ioctl_create_list(struct file *filp, unsigned long arg)
 
 	if (copy_from_user(&head, (void __user *)arg, sizeof(head)))
 		return -EFAULT;
-	if (head.count > 1024)
+	if (head.count > list_limit)
 		return -EINVAL;
 	lsize = sizeof(struct udmabuf_create_item) * head.count;
 	list = memdup_user((void __user *)(arg + sizeof(head)), lsize);
-- 
2.9.3
