Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39769 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbeD0GRd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 02:17:33 -0400
Received: by mail-wm0-f66.google.com with SMTP id b21so801577wme.4
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 23:17:33 -0700 (PDT)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: DRI Development <dri-devel@lists.freedesktop.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH 03/17] dma-fence: Make ->enable_signaling optional
Date: Fri, 27 Apr 2018 08:17:10 +0200
Message-Id: <20180427061724.28497-4-daniel.vetter@ffwll.ch>
In-Reply-To: <20180427061724.28497-1-daniel.vetter@ffwll.ch>
References: <20180427061724.28497-1-daniel.vetter@ffwll.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many drivers have a trivial implementation for ->enable_signaling.
Let's make it optional by assuming that signalling is already
available when the callback isn't present.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org
---
 drivers/dma-buf/dma-fence.c | 13 ++++++++++++-
 include/linux/dma-fence.h   |  3 ++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 4edb9fd3cf47..7b5b40d6b70e 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -181,6 +181,13 @@ void dma_fence_release(struct kref *kref)
 }
 EXPORT_SYMBOL(dma_fence_release);
 
+/**
+ * dma_fence_free - default release function for &dma_fence.
+ * @fence: fence to release
+ *
+ * This is the default implementation for &dma_fence_ops.release. It calls
+ * kfree_rcu() on @fence.
+ */
 void dma_fence_free(struct dma_fence *fence)
 {
 	kfree_rcu(fence, rcu);
@@ -560,7 +567,7 @@ dma_fence_init(struct dma_fence *fence, const struct dma_fence_ops *ops,
 	       spinlock_t *lock, u64 context, unsigned seqno)
 {
 	BUG_ON(!lock);
-	BUG_ON(!ops || !ops->wait || !ops->enable_signaling ||
+	BUG_ON(!ops || !ops->wait ||
 	       !ops->get_driver_name || !ops->get_timeline_name);
 
 	kref_init(&fence->refcount);
@@ -572,6 +579,10 @@ dma_fence_init(struct dma_fence *fence, const struct dma_fence_ops *ops,
 	fence->flags = 0UL;
 	fence->error = 0;
 
+	if (!ops->enable_signaling)
+		set_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT,
+			&fence->flags);
+
 	trace_dma_fence_init(fence);
 }
 EXPORT_SYMBOL(dma_fence_init);
diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index f9a6848f8558..c730f569621a 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -166,7 +166,8 @@ struct dma_fence_ops {
 	 * released when the fence is signalled (through e.g. the interrupt
 	 * handler).
 	 *
-	 * This callback is mandatory.
+	 * This callback is optional. If this callback is not present, then the
+	 * driver must always have signaling enabled.
 	 */
 	bool (*enable_signaling)(struct dma_fence *fence);
 
-- 
2.17.0
