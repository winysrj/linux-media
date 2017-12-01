Return-path: <linux-media-owner@vger.kernel.org>
From: Lucas Stach <l.stach@pengutronix.de>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de
Subject: [PATCH] dma-buf: add some lockdep asserts to the reservation object implementation
Date: Fri,  1 Dec 2017 12:12:16 +0100
Message-Id: <20171201111216.7050-1-l.stach@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds lockdep asserts to the reservation functions which state in their
documentation that obj->lock must be held. Allows builds with PROVE_LOCKING
enabled to check that the locking requirements are met.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/dma-buf/reservation.c | 8 ++++++++
 include/linux/reservation.h   | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index b44d9d7db347..accd398e2ea6 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -71,6 +71,8 @@ int reservation_object_reserve_shared(struct reservation_object *obj)
 	struct reservation_object_list *fobj, *old;
 	u32 max;
 
+	reservation_object_assert_held(obj);
+
 	old = reservation_object_get_list(obj);
 
 	if (old && old->shared_max) {
@@ -211,6 +213,8 @@ void reservation_object_add_shared_fence(struct reservation_object *obj,
 {
 	struct reservation_object_list *old, *fobj = obj->staged;
 
+	reservation_object_assert_held(obj);
+
 	old = reservation_object_get_list(obj);
 	obj->staged = NULL;
 
@@ -236,6 +240,8 @@ void reservation_object_add_excl_fence(struct reservation_object *obj,
 	struct reservation_object_list *old;
 	u32 i = 0;
 
+	reservation_object_assert_held(obj);
+
 	old = reservation_object_get_list(obj);
 	if (old)
 		i = old->shared_count;
@@ -276,6 +282,8 @@ int reservation_object_copy_fences(struct reservation_object *dst,
 	size_t size;
 	unsigned i;
 
+	reservation_object_assert_held(dst);
+
 	rcu_read_lock();
 	src_list = rcu_dereference(src->fence);
 
diff --git a/include/linux/reservation.h b/include/linux/reservation.h
index 21fc84d82d41..55e7318800fd 100644
--- a/include/linux/reservation.h
+++ b/include/linux/reservation.h
@@ -212,6 +212,8 @@ reservation_object_unlock(struct reservation_object *obj)
 static inline struct dma_fence *
 reservation_object_get_excl(struct reservation_object *obj)
 {
+	reservation_object_assert_held(obj);
+
 	return rcu_dereference_protected(obj->fence_excl,
 					 reservation_object_held(obj));
 }
-- 
2.11.0
