Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34654 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbcH2HUv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 03:20:51 -0400
Received: by mail-wm0-f65.google.com with SMTP id q128so8245975wma.1
        for <linux-media@vger.kernel.org>; Mon, 29 Aug 2016 00:20:50 -0700 (PDT)
From: Chris Wilson <chris@chris-wilson.co.uk>
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH 10/11] dma-buf: Use seqlock to close RCU race in test_signaled_single
Date: Mon, 29 Aug 2016 08:08:33 +0100
Message-Id: <20160829070834.22296-10-chris@chris-wilson.co.uk>
In-Reply-To: <20160829070834.22296-1-chris@chris-wilson.co.uk>
References: <20160829070834.22296-1-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the seqlock now extended to cover the lookup of the fence and its
testing, we can perform that testing solely under the seqlock guard and
avoid the effective locking and serialisation of acquiring a reference to
the request.  As the fence is RCU protected we know it cannot disappear
as we test it, the same guarantee that made it safe to acquire the
reference previously.  The seqlock tests whether the fence was replaced
as we are testing it telling us whether or not we can trust the result
(if not, we just repeat the test until stable).

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 drivers/dma-buf/reservation.c | 32 ++++----------------------------
 1 file changed, 4 insertions(+), 28 deletions(-)

diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index e74493e7332b..1ddffa5adb5a 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -442,24 +442,6 @@ unlock_retry:
 }
 EXPORT_SYMBOL_GPL(reservation_object_wait_timeout_rcu);
 
-
-static inline int
-reservation_object_test_signaled_single(struct fence *passed_fence)
-{
-	struct fence *fence, *lfence = passed_fence;
-	int ret = 1;
-
-	if (!test_bit(FENCE_FLAG_SIGNALED_BIT, &lfence->flags)) {
-		fence = fence_get_rcu(lfence);
-		if (!fence)
-			return -1;
-
-		ret = !!fence_is_signaled(fence);
-		fence_put(fence);
-	}
-	return ret;
-}
-
 /**
  * reservation_object_test_signaled_rcu - Test if a reservation object's
  * fences have been signaled.
@@ -474,7 +456,7 @@ bool reservation_object_test_signaled_rcu(struct reservation_object *obj,
 					  bool test_all)
 {
 	unsigned seq, shared_count;
-	int ret;
+	bool ret;
 
 	rcu_read_lock();
 retry:
@@ -494,10 +476,8 @@ retry:
 		for (i = 0; i < shared_count; ++i) {
 			struct fence *fence = rcu_dereference(fobj->shared[i]);
 
-			ret = reservation_object_test_signaled_single(fence);
-			if (ret < 0)
-				goto retry;
-			else if (!ret)
+			ret = fence_is_signaled(fence);
+			if (!ret)
 				break;
 		}
 
@@ -509,11 +489,7 @@ retry:
 		struct fence *fence_excl = rcu_dereference(obj->fence_excl);
 
 		if (fence_excl) {
-			ret = reservation_object_test_signaled_single(
-								fence_excl);
-			if (ret < 0)
-				goto retry;
-
+			ret = fence_is_signaled(fence_excl);
 			if (read_seqcount_retry(&obj->seq, seq))
 				goto retry;
 		}
-- 
2.9.3

