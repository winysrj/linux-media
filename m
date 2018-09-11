Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727796AbeIKSln (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 14:41:43 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com, daniel@ffwll.ch,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 12/13] udmabuf: use sizeof(variable) instead of sizeof(type)
Date: Tue, 11 Sep 2018 15:42:15 +0200
Message-Id: <20180911134216.9760-13-kraxel@redhat.com>
In-Reply-To: <20180911134216.9760-1-kraxel@redhat.com>
References: <20180911134216.9760-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/dma-buf/udmabuf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 7a4fd2194d..92af9b5300 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -128,7 +128,7 @@ static long udmabuf_create(const struct udmabuf_create_list *head,
 	int seals, ret = -EINVAL;
 	u32 i, flags;
 
-	ubuf = kzalloc(sizeof(struct udmabuf), GFP_KERNEL);
+	ubuf = kzalloc(sizeof(*ubuf), GFP_KERNEL);
 	if (!ubuf)
 		return -ENOMEM;
 
@@ -142,7 +142,7 @@ static long udmabuf_create(const struct udmabuf_create_list *head,
 		if (ubuf->pagecount > pglimit)
 			goto err;
 	}
-	ubuf->pages = kmalloc_array(ubuf->pagecount, sizeof(struct page *),
+	ubuf->pages = kmalloc_array(ubuf->pagecount, sizeof(*ubuf->pages),
 				    GFP_KERNEL);
 	if (!ubuf->pages) {
 		ret = -ENOMEM;
@@ -211,7 +211,7 @@ static long udmabuf_ioctl_create(struct file *filp, unsigned long arg)
 	struct udmabuf_create_item list;
 
 	if (copy_from_user(&create, (void __user *)arg,
-			   sizeof(struct udmabuf_create)))
+			   sizeof(create)))
 		return -EFAULT;
 
 	head.flags  = create.flags;
-- 
2.9.3
