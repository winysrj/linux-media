Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33597 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdKUOIy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 09:08:54 -0500
From: Rob Clark <robdclark@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Rob Clark <robdclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] reservation: don't wait when timeout=0
Date: Tue, 21 Nov 2017 09:08:46 -0500
Message-Id: <20171121140850.23401-1-robdclark@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If we are testing if a reservation object's fences have been
signaled with timeout=0 (non-blocking), we need to pass 0 for
timeout to dma_fence_wait_timeout().

Plus bonus spelling correction.

Signed-off-by: Rob Clark <robdclark@gmail.com>
---
 drivers/dma-buf/reservation.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index dec3a815455d..71f51140a9ad 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -420,7 +420,7 @@ EXPORT_SYMBOL_GPL(reservation_object_get_fences_rcu);
  *
  * RETURNS
  * Returns -ERESTARTSYS if interrupted, 0 if the wait timed out, or
- * greater than zer on success.
+ * greater than zero on success.
  */
 long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
 					 bool wait_all, bool intr,
@@ -483,7 +483,14 @@ long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
 			goto retry;
 		}
 
-		ret = dma_fence_wait_timeout(fence, intr, ret);
+		/*
+		 * Note that dma_fence_wait_timeout() will return 1 if
+		 * the fence is already signaled, so in the wait_all
+		 * case when we go through the retry loop again, ret
+		 * will be greater than 0 and we don't want this to
+		 * cause _wait_timeout() to block
+		 */
+		ret = dma_fence_wait_timeout(fence, intr, timeout ? ret : 0);
 		dma_fence_put(fence);
 		if (ret > 0 && wait_all && (i + 1 < shared_count))
 			goto retry;
-- 
2.13.6
