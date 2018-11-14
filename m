Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbeKNWXi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 17:23:38 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: gurchetansingh@chromium.org, Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] udmabuf: set read/write flag when exporting
Date: Wed, 14 Nov 2018 13:20:29 +0100
Message-Id: <20181114122029.16766-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise, mmap fails when done with PROT_WRITE.

Suggested-by: Gurchetan Singh <gurchetansingh@chromium.org>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/dma-buf/udmabuf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index e70328ab7e..d9ff246093 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -189,6 +189,7 @@ static long udmabuf_create(const struct udmabuf_create_list *head,
 	exp_info.ops  = &udmabuf_ops;
 	exp_info.size = ubuf->pagecount << PAGE_SHIFT;
 	exp_info.priv = ubuf;
+	exp_info.flags = O_RDWR;
 
 	buf = dma_buf_export(&exp_info);
 	if (IS_ERR(buf)) {
-- 
2.9.3
