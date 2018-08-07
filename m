Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:52020 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389559AbeHGUwt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 16:52:49 -0400
From: Chris Wilson <chris@chris-wilson.co.uk>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH] dma-buf: Remove requirement for ops->map() from dma_buf_export
Date: Tue,  7 Aug 2018 19:36:47 +0100
Message-Id: <20180807183647.22626-1-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 9ea0dfbf972 ("dma-buf: make map_atomic and map function
pointers optional"), the core provides the no-op functions when map and
map_atomic are not provided, so we no longer need assert that are
supplied by a dma-buf exporter.

Fixes: 09ea0dfbf972 ("dma-buf: make map_atomic and map function pointers optional")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
---
 drivers/dma-buf/dma-buf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 13884474d158..02f7f9a89979 100644
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
2.18.0
