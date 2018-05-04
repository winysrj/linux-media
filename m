Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54322 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbeEDOKl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 10:10:41 -0400
Received: by mail-wm0-f65.google.com with SMTP id f6so4261655wmc.4
        for <linux-media@vger.kernel.org>; Fri, 04 May 2018 07:10:40 -0700 (PDT)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: DRI Development <dri-devel@lists.freedesktop.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH] dma-fence: Make ->enable_signaling optional
Date: Fri,  4 May 2018 16:10:34 +0200
Message-Id: <20180504141034.27727-1-daniel.vetter@ffwll.ch>
In-Reply-To: <20180503142603.28513-3-daniel.vetter@ffwll.ch>
References: <20180503142603.28513-3-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many drivers have a trivial implementation for ->enable_signaling.
Let's make it optional by assuming that signalling is already
available when the callback isn't present.

v2: Don't do the trick to set the ENABLE_SIGNAL_BIT
unconditionally, it results in an expensive spinlock take for
everyone. Instead just check if the callback is present. Suggested by
Maarten.

Also move misplaced kerneldoc hunk to the right patch.

Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com> (v1)
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org
---
 drivers/dma-buf/dma-fence.c | 9 +++++----
 include/linux/dma-fence.h   | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 4edb9fd3cf47..dd01a1720be9 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -200,7 +200,8 @@ void dma_fence_enable_sw_signaling(struct dma_fence *fence)
 
 	if (!test_and_set_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT,
 			      &fence->flags) &&
-	    !test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
+	    !test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags) &&
+	    fence->ops->enable_signaling) {
 		trace_dma_fence_enable_signal(fence);
 
 		spin_lock_irqsave(fence->lock, flags);
@@ -260,7 +261,7 @@ int dma_fence_add_callback(struct dma_fence *fence, struct dma_fence_cb *cb,
 
 	if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
 		ret = -ENOENT;
-	else if (!was_set) {
+	else if (!was_set && fence->ops->enable_signaling) {
 		trace_dma_fence_enable_signal(fence);
 
 		if (!fence->ops->enable_signaling(fence)) {
@@ -388,7 +389,7 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 	if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
 		goto out;
 
-	if (!was_set) {
+	if (!was_set && fence->ops->enable_signaling) {
 		trace_dma_fence_enable_signal(fence);
 
 		if (!fence->ops->enable_signaling(fence)) {
@@ -560,7 +561,7 @@ dma_fence_init(struct dma_fence *fence, const struct dma_fence_ops *ops,
 	       spinlock_t *lock, u64 context, unsigned seqno)
 {
 	BUG_ON(!lock);
-	BUG_ON(!ops || !ops->wait || !ops->enable_signaling ||
+	BUG_ON(!ops || !ops->wait ||
 	       !ops->get_driver_name || !ops->get_timeline_name);
 
 	kref_init(&fence->refcount);
diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index 111aefe1c956..c053d19e1e24 100644
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
