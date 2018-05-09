Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57578 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934932AbeEIUQO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 16:16:14 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        kernel@collabora.com, Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] dma-fence: Make dma_fence_add_callback() fail if signaled with error
Date: Wed,  9 May 2018 17:14:49 -0300
Message-Id: <20180509201449.27452-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change how dma_fence_add_callback() behaves, when the fence
has error-signaled by the time it is being add. After this commit,
dma_fence_add_callback() returns the fence error, if it
has error-signaled before dma_fence_add_callback() is called.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/dma-buf/dma-fence.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 4edb9fd3cf47..298b440c5b68 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -226,7 +226,8 @@ EXPORT_SYMBOL(dma_fence_enable_sw_signaling);
  *
  * Note that the callback can be called from an atomic context.  If
  * fence is already signaled, this function will return -ENOENT (and
- * *not* call the callback)
+ * *not* call the callback). If the fence is error-signaled, this
+ * function returns the fence error.
  *
  * Add a software callback to the fence. Same restrictions apply to
  * refcount as it does to dma_fence_wait, however the caller doesn't need to
@@ -235,8 +236,8 @@ EXPORT_SYMBOL(dma_fence_enable_sw_signaling);
  * after it signals with dma_fence_signal. The callback itself can be called
  * from irq context.
  *
- * Returns 0 in case of success, -ENOENT if the fence is already signaled
- * and -EINVAL in case of error.
+ * Returns 0 in case of success, -ENOENT (or the error value) if the fence is
+ * already signaled and -EINVAL in case of error.
  */
 int dma_fence_add_callback(struct dma_fence *fence, struct dma_fence_cb *cb,
 			   dma_fence_func_t func)
@@ -250,7 +251,8 @@ int dma_fence_add_callback(struct dma_fence *fence, struct dma_fence_cb *cb,
 
 	if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
 		INIT_LIST_HEAD(&cb->node);
-		return -ENOENT;
+		ret = (fence->error < 0) ? fence->error : -ENOENT;
+		return ret;
 	}
 
 	spin_lock_irqsave(fence->lock, flags);
-- 
2.16.3
