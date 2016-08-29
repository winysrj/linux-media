Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34874 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756135AbcH2HWc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 03:22:32 -0400
Received: by mail-wm0-f65.google.com with SMTP id i5so8250480wmg.2
        for <linux-media@vger.kernel.org>; Mon, 29 Aug 2016 00:22:01 -0700 (PDT)
From: Chris Wilson <chris@chris-wilson.co.uk>
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH 08/11] dma-buf: Restart reservation_object_wait_timeout_rcu() after writes
Date: Mon, 29 Aug 2016 08:08:31 +0100
Message-Id: <20160829070834.22296-8-chris@chris-wilson.co.uk>
In-Reply-To: <20160829070834.22296-1-chris@chris-wilson.co.uk>
References: <20160829070834.22296-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to be completely generic, we have to double check the read
seqlock after acquiring a reference to the fence. If the driver is
allocating fences from a SLAB_DESTROY_BY_RCU, or similar freelist, then
within an RCU grace period a fence may be freed and reallocated. The RCU
read side critical section does not prevent this reallocation, instead
we have to inspect the reservation's seqlock to double check if the
fences have been reassigned as we were acquiring our reference.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 drivers/dma-buf/reservation.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index 10fd441dd4ed..3369e4668e96 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -388,9 +388,6 @@ retry:
 		if (fobj)
 			shared_count = fobj->shared_count;
 
-		if (read_seqcount_retry(&obj->seq, seq))
-			goto unlock_retry;
-
 		for (i = 0; i < shared_count; ++i) {
 			struct fence *lfence = rcu_dereference(fobj->shared[i]);
 
@@ -413,9 +410,6 @@ retry:
 	if (!shared_count) {
 		struct fence *fence_excl = rcu_dereference(obj->fence_excl);
 
-		if (read_seqcount_retry(&obj->seq, seq))
-			goto unlock_retry;
-
 		if (fence_excl &&
 		    !test_bit(FENCE_FLAG_SIGNALED_BIT, &fence_excl->flags)) {
 			if (!fence_get_rcu(fence_excl))
@@ -430,6 +424,11 @@ retry:
 
 	rcu_read_unlock();
 	if (fence) {
+		if (read_seqcount_retry(&obj->seq, seq)) {
+			fence_put(fence);
+			goto retry;
+		}
+
 		ret = fence_wait_timeout(fence, intr, ret);
 		fence_put(fence);
 		if (ret > 0 && wait_all && (i + 1 < shared_count))
-- 
2.9.3

