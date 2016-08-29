Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35202 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbcH2HZg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 03:25:36 -0400
Received: by mail-wm0-f68.google.com with SMTP id i5so8260679wmg.2
        for <linux-media@vger.kernel.org>; Mon, 29 Aug 2016 00:25:36 -0700 (PDT)
From: Chris Wilson <chris@chris-wilson.co.uk>
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH 06/11] dma-buf: Introduce fence_get_rcu_safe()
Date: Mon, 29 Aug 2016 08:08:29 +0100
Message-Id: <20160829070834.22296-6-chris@chris-wilson.co.uk>
In-Reply-To: <20160829070834.22296-1-chris@chris-wilson.co.uk>
References: <20160829070834.22296-1-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This variant of fence_get_rcu() takes an RCU protected pointer to a
fence and carefully returns a reference to the fence ensuring that it is
not reallocated as it does. This is required when mixing fences and
SLAB_DESTROY_BY_RCU - although it serves a more pedagogical function atm

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 include/linux/fence.h | 56 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 5 deletions(-)

diff --git a/include/linux/fence.h b/include/linux/fence.h
index 0d763053f97a..c9c5ba98c302 100644
--- a/include/linux/fence.h
+++ b/include/linux/fence.h
@@ -183,6 +183,16 @@ void fence_release(struct kref *kref);
 void fence_free(struct fence *fence);
 
 /**
+ * fence_put - decreases refcount of the fence
+ * @fence:	[in]	fence to reduce refcount of
+ */
+static inline void fence_put(struct fence *fence)
+{
+	if (fence)
+		kref_put(&fence->refcount, fence_release);
+}
+
+/**
  * fence_get - increases refcount of the fence
  * @fence:	[in]	fence to increase refcount of
  *
@@ -210,13 +220,49 @@ static inline struct fence *fence_get_rcu(struct fence *fence)
 }
 
 /**
- * fence_put - decreases refcount of the fence
- * @fence:	[in]	fence to reduce refcount of
+ * fence_get_rcu_safe  - acquire a reference to an RCU tracked fence
+ * @fence:	[in]	pointer to fence to increase refcount of
+ *
+ * Function returns NULL if no refcount could be obtained, or the fence.
+ * This function handles acquiring a reference to a fence that may be
+ * reallocated within the RCU grace period (such as with SLAB_DESTROY_BY_RCU),
+ * so long as the caller is using RCU on the pointer to the fence.
+ *
+ * An alternative mechanism is to employ a seqlock to protect a bunch of
+ * fences, such as used by struct reservation_object. When using a seqlock,
+ * the seqlock must be taken before and checked after a reference to the
+ * fence is acquired (as shown here).
+ *
+ * The caller is required to hold the RCU read lock.
  */
-static inline void fence_put(struct fence *fence)
+static inline struct fence *fence_get_rcu_safe(struct fence * __rcu *fencep)
 {
-	if (fence)
-		kref_put(&fence->refcount, fence_release);
+	do {
+		struct fence *fence;
+
+		fence = rcu_dereference(*fencep);
+		if (!fence || !fence_get_rcu(fence))
+			return NULL;
+
+		/* The atomic_inc_not_zero() inside fence_get_rcu()
+		 * provides a full memory barrier upon success (such as now).
+		 * This is paired with the write barrier from assigning
+		 * to the __rcu protected fence pointer so that if that
+		 * pointer still matches the current fence, we know we
+		 * have successfully acquire a reference to it. If it no
+		 * longer matches, we are holding a reference to some other
+		 * reallocated pointer. This is possible if the allocator
+		 * is using a freelist like SLAB_DESTROY_BY_RCU where the
+		 * fence remains valid for the RCU grace period, but it
+		 * may be reallocated. When using such allocators, we are
+		 * responsible for ensuring the reference we get is to
+		 * the right fence, as below.
+		 */
+		if (fence == rcu_access_pointer(*fencep))
+			return rcu_pointer_handoff(fence);
+
+		fence_put(fence);
+	} while (1);
 }
 
 int fence_signal(struct fence *fence);
-- 
2.9.3

