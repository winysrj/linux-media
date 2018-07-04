Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.netline.ch ([148.251.143.178]:38153 "EHLO
        netline-mail3.netline.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752533AbeGDPOJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 11:14:09 -0400
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>
To: =?UTF-8?q?Christian=20K=C3=B6nig?=
        <ckoenig.leichtzumerken@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        amd-gfx@lists.freedesktop.org
Subject: [PATCH v2] dma-buf: Move BUG_ON from _add_shared_fence to _add_shared_inplace
Date: Wed,  4 Jul 2018 17:14:05 +0200
Message-Id: <20180704151405.10357-1-michel@daenzer.net>
In-Reply-To: <20180626143147.14296-1-michel@daenzer.net>
References: <20180626143147.14296-1-michel@daenzer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michel Dänzer <michel.daenzer@amd.com>

Fixes the BUG_ON spuriously triggering under the following
circumstances:

* reservation_object_reserve_shared is called with shared_count ==
  shared_max - 1, so obj->staged is freed in preparation of an in-place
  update.

* reservation_object_add_shared_fence is called with the first fence,
  after which shared_count == shared_max.

* reservation_object_add_shared_fence is called with a follow-up fence
  from the same context.

In the second reservation_object_add_shared_fence call, the BUG_ON
triggers. However, nothing bad would happen in
reservation_object_add_shared_inplace, since both fences are from the
same context, so they only occupy a single slot.

Prevent this by moving the BUG_ON to where an overflow would actually
happen (e.g. if a buggy caller didn't call
reservation_object_reserve_shared before).

v2:
* Fix description of breaking scenario (Christian König)
* Add bugzilla reference

Cc: stable@vger.kernel.org
Bugzilla: https://bugs.freedesktop.org/106418
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk> # v1
Reviewed-by: Christian König <christian.koenig@amd.com> # v1
Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
---
 drivers/dma-buf/reservation.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index 314eb1071cce..532545b9488e 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -141,6 +141,7 @@ reservation_object_add_shared_inplace(struct reservation_object *obj,
 	if (signaled) {
 		RCU_INIT_POINTER(fobj->shared[signaled_idx], fence);
 	} else {
+		BUG_ON(fobj->shared_count >= fobj->shared_max);
 		RCU_INIT_POINTER(fobj->shared[fobj->shared_count], fence);
 		fobj->shared_count++;
 	}
@@ -230,10 +231,9 @@ void reservation_object_add_shared_fence(struct reservation_object *obj,
 	old = reservation_object_get_list(obj);
 	obj->staged = NULL;
 
-	if (!fobj) {
-		BUG_ON(old->shared_count >= old->shared_max);
+	if (!fobj)
 		reservation_object_add_shared_inplace(obj, old, fence);
-	} else
+	else
 		reservation_object_add_shared_replace(obj, old, fobj, fence);
 }
 EXPORT_SYMBOL(reservation_object_add_shared_fence);
-- 
2.18.0
