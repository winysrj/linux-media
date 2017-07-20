Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37299 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936208AbdGTMvP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 08:51:15 -0400
Received: by mail-wm0-f68.google.com with SMTP id m4so3435916wmi.4
        for <linux-media@vger.kernel.org>; Thu, 20 Jul 2017 05:51:14 -0700 (PDT)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: DRI Development <dri-devel@lists.freedesktop.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH] dma-fence: Don't BUG_ON when not absolutely needed
Date: Thu, 20 Jul 2017 14:51:07 +0200
Message-Id: <20170720125107.26693-1-daniel.vetter@ffwll.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It makes debugging a massive pain.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org
---
 drivers/dma-buf/dma-fence.c | 4 ++--
 include/linux/dma-fence.h   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 56e0a0e1b600..9a302799040e 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -48,7 +48,7 @@ static atomic64_t dma_fence_context_counter = ATOMIC64_INIT(0);
  */
 u64 dma_fence_context_alloc(unsigned num)
 {
-	BUG_ON(!num);
+	WARN_ON(!num);
 	return atomic64_add_return(num, &dma_fence_context_counter) - num;
 }
 EXPORT_SYMBOL(dma_fence_context_alloc);
@@ -172,7 +172,7 @@ void dma_fence_release(struct kref *kref)
 
 	trace_dma_fence_destroy(fence);
 
-	BUG_ON(!list_empty(&fence->cb_list));
+	WARN_ON(!list_empty(&fence->cb_list));
 
 	if (fence->ops->release)
 		fence->ops->release(fence);
diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index 9342cf0dada4..171895072435 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -431,8 +431,8 @@ int dma_fence_get_status(struct dma_fence *fence);
 static inline void dma_fence_set_error(struct dma_fence *fence,
 				       int error)
 {
-	BUG_ON(test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags));
-	BUG_ON(error >= 0 || error < -MAX_ERRNO);
+	WARN_ON(test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags));
+	WARN_ON(error >= 0 || error < -MAX_ERRNO);
 
 	fence->error = error;
 }
-- 
2.13.2
