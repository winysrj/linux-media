Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48262 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755611AbeFSGKP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 02:10:15 -0400
From: Akhil P Oommen <akhilpo@codeaurora.org>
To: sumit.semwal@linaro.org, gustavo@padovan.org
Cc: linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, jcrouse@codeaurora.org,
        smasetty@codeaurora.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH] dma-buf/fence: Take refcount on the module that owns the fence
Date: Tue, 19 Jun 2018 11:40:05 +0530
Message-Id: <1529388605-10044-1-git-send-email-akhilpo@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each fence object holds function pointers of the module that initialized
it. Allowing the module to unload before this fence's release is
catastrophic. So, keep a refcount on the module until the fence is
released.

Signed-off-by: Akhil P Oommen <akhilpo@codeaurora.org>
---
 drivers/dma-buf/dma-fence.c | 15 ++++++++++++---
 include/linux/dma-fence.h   | 10 ++++++++--
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 4edb9fd..0be8053 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -18,6 +18,7 @@
  * more details.
  */
 
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/atomic.h>
@@ -168,6 +169,7 @@ void dma_fence_release(struct kref *kref)
 {
 	struct dma_fence *fence =
 		container_of(kref, struct dma_fence, refcount);
+	struct module *module = fence->owner;
 
 	trace_dma_fence_destroy(fence);
 
@@ -178,6 +180,8 @@ void dma_fence_release(struct kref *kref)
 		fence->ops->release(fence);
 	else
 		dma_fence_free(fence);
+
+	module_put(module);
 }
 EXPORT_SYMBOL(dma_fence_release);
 
@@ -556,8 +560,9 @@ struct default_wait_cb {
  * to check which fence is later by simply using dma_fence_later.
  */
 void
-dma_fence_init(struct dma_fence *fence, const struct dma_fence_ops *ops,
-	       spinlock_t *lock, u64 context, unsigned seqno)
+_dma_fence_init(struct module *module, struct dma_fence *fence,
+		const struct dma_fence_ops *ops, spinlock_t *lock,
+		u64 context, unsigned seqno)
 {
 	BUG_ON(!lock);
 	BUG_ON(!ops || !ops->wait || !ops->enable_signaling ||
@@ -571,7 +576,11 @@ struct default_wait_cb {
 	fence->seqno = seqno;
 	fence->flags = 0UL;
 	fence->error = 0;
+	fence->owner = module;
+
+	if (!try_module_get(module))
+		fence->owner = NULL;
 
 	trace_dma_fence_init(fence);
 }
-EXPORT_SYMBOL(dma_fence_init);
+EXPORT_SYMBOL(_dma_fence_init);
diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index eb9b05a..8159125 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -36,6 +36,8 @@
 
 /**
  * struct dma_fence - software synchronization primitive
+ * @owner: the module that contains fence_ops functions.
+ *	   Usually THIS_MODULE.
  * @refcount: refcount for this fence
  * @ops: dma_fence_ops associated with this fence
  * @rcu: used for releasing fence with kfree_rcu
@@ -71,6 +73,7 @@
  * been completed, or never called at all.
  */
 struct dma_fence {
+	struct module *owner;
 	struct kref refcount;
 	const struct dma_fence_ops *ops;
 	struct rcu_head rcu;
@@ -249,8 +252,11 @@ struct dma_fence_ops {
 				   char *str, int size);
 };
 
-void dma_fence_init(struct dma_fence *fence, const struct dma_fence_ops *ops,
-		    spinlock_t *lock, u64 context, unsigned seqno);
+#define dma_fence_init(fence, ops, lock, context, seqno) _dma_fence_init( \
+		THIS_MODULE, fence, ops, lock, context, seqno)
+void _dma_fence_init(struct module *module, struct dma_fence *fence,
+		const struct dma_fence_ops *ops, spinlock_t *lock, u64 context,
+		unsigned seqno);
 
 void dma_fence_release(struct kref *kref);
 void dma_fence_free(struct dma_fence *fence);
-- 
1.9.1
