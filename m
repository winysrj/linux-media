Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsmx011.vodafonemail.xion.oxcs.net ([153.92.174.89]:52081 "EHLO
        vsmx011.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751996AbdGUQaP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 12:30:15 -0400
From: =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Cc: sumit.semwal@linaro.org
Subject: [PATCH] dma-buf: fix reservation_object_wait_timeout_rcu to wait correctly
Date: Fri, 21 Jul 2017 18:20:01 +0200
Message-Id: <1500654001-20899-1-git-send-email-deathsimple@vodafone.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Christian König <christian.koenig@amd.com>

With hardware resets in mind it is possible that all shared fences are
signaled, but the exlusive isn't. Fix waiting for everything in this situation.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/dma-buf/reservation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index e2eff86..ce3f9c1 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -461,7 +461,7 @@ long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
 		}
 	}
 
-	if (!shared_count) {
+	if (!fence) {
 		struct dma_fence *fence_excl = rcu_dereference(obj->fence_excl);
 
 		if (fence_excl &&
-- 
2.7.4
