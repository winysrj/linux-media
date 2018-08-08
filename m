Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726756AbeHHIou (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Aug 2018 04:44:50 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dma-buf: fix sanity check in dma_buf_export
Date: Wed,  8 Aug 2018 08:25:40 +0200
Message-Id: <20180808062540.13545-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 09ea0dfbf972 made map_atomic and map function pointers optional,
but didn't adapt the sanity check in dma_buf_export.  Fix that.

Note that the atomic map interface has been removed altogether meanwhile
(commit f664a52695), therefore we have to remove the map check only.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/dma-buf/dma-buf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 13884474d1..02f7f9a899 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -405,7 +405,6 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 			  || !exp_info->ops->map_dma_buf
 			  || !exp_info->ops->unmap_dma_buf
 			  || !exp_info->ops->release
-			  || !exp_info->ops->map
 			  || !exp_info->ops->mmap)) {
 		return ERR_PTR(-EINVAL);
 	}
-- 
2.9.3
