Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx009.vodafonemail.xion.oxcs.net ([153.92.174.39]:57890 "EHLO
        mx009.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750980AbdGYNfZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 09:35:25 -0400
From: =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Cc: sumit.semwal@linaro.org, daniel@ffwll.ch
Subject: [PATCH] dma-buf: fix reservation_object_wait_timeout_rcu to wait correctly v2
Date: Tue, 25 Jul 2017 15:35:10 +0200
Message-Id: <1500989710-12982-1-git-send-email-deathsimple@vodafone.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Christian König <christian.koenig@amd.com>

With hardware resets in mind it is possible that all shared fences are
signaled, but the exlusive isn't. Fix waiting for everything in this situation.

v2: make sure we always wait for the exclusive fence

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/dma-buf/reservation.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index 393817e..9d4316d 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -373,12 +373,25 @@ long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
 	long ret = timeout ? timeout : 1;
 
 retry:
-	fence = NULL;
 	shared_count = 0;
 	seq = read_seqcount_begin(&obj->seq);
 	rcu_read_lock();
 
-	if (wait_all) {
+	fence = rcu_dereference(obj->fence_excl);
+	if (fence && !test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
+		if (!dma_fence_get_rcu(fence))
+			goto unlock_retry;
+
+		if (dma_fence_is_signaled(fence)) {
+			dma_fence_put(fence);
+			fence = NULL;
+		}
+
+	} else {
+		fence = NULL;
+	}
+
+	if (!fence && wait_all) {
 		struct reservation_object_list *fobj =
 						rcu_dereference(obj->fence);
 
@@ -405,22 +418,6 @@ long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
 		}
 	}
 
-	if (!shared_count) {
-		struct dma_fence *fence_excl = rcu_dereference(obj->fence_excl);
-
-		if (fence_excl &&
-		    !test_bit(DMA_FENCE_FLAG_SIGNALED_BIT,
-			      &fence_excl->flags)) {
-			if (!dma_fence_get_rcu(fence_excl))
-				goto unlock_retry;
-
-			if (dma_fence_is_signaled(fence_excl))
-				dma_fence_put(fence_excl);
-			else
-				fence = fence_excl;
-		}
-	}
-
 	rcu_read_unlock();
 	if (fence) {
 		if (read_seqcount_retry(&obj->seq, seq)) {
-- 
2.7.4
