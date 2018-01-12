Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:41668 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932414AbeALJrc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 04:47:32 -0500
Received: by mail-wm0-f65.google.com with SMTP id g75so10894176wme.0
        for <linux-media@vger.kernel.org>; Fri, 12 Jan 2018 01:47:32 -0800 (PST)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: daniel@ffwll.ch, sumit.semwal@linaro.org, gustavo@padovan.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH 1/3] dma-buf: make returning the exclusive fence optional
Date: Fri, 12 Jan 2018 10:47:27 +0100
Message-Id: <20180112094729.17491-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change reservation_object_get_fences_rcu to make the exclusive fence
pointer optional.

If not specified the exclusive fence is put into the fence array as
well.

This is helpful for a couple of cases where we need all fences in a
single array.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/dma-buf/reservation.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index b759a569b7b8..461afa9febd4 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -374,8 +374,9 @@ EXPORT_SYMBOL(reservation_object_copy_fences);
  * @pshared: the array of shared fence ptrs returned (array is krealloc'd to
  * the required size, and must be freed by caller)
  *
- * RETURNS
- * Zero or -errno
+ * Retrieve all fences from the reservation object. If the pointer for the
+ * exclusive fence is not specified the fence is put into the array of the
+ * shared fences as well. Returns either zero or -ENOMEM.
  */
 int reservation_object_get_fences_rcu(struct reservation_object *obj,
 				      struct dma_fence **pfence_excl,
@@ -389,8 +390,8 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
 
 	do {
 		struct reservation_object_list *fobj;
-		unsigned seq;
-		unsigned int i;
+		unsigned int i, seq;
+		size_t sz = 0;
 
 		shared_count = i = 0;
 
@@ -402,9 +403,14 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
 			goto unlock;
 
 		fobj = rcu_dereference(obj->fence);
-		if (fobj) {
+		if (fobj)
+			sz += sizeof(*shared) * fobj->shared_max;
+
+		if (!pfence_excl && fence_excl)
+			sz += sizeof(*shared);
+
+		if (sz) {
 			struct dma_fence **nshared;
-			size_t sz = sizeof(*shared) * fobj->shared_max;
 
 			nshared = krealloc(shared, sz,
 					   GFP_NOWAIT | __GFP_NOWARN);
@@ -420,13 +426,19 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
 				break;
 			}
 			shared = nshared;
-			shared_count = fobj->shared_count;
-
+			shared_count = fobj ? fobj->shared_count : 0;
 			for (i = 0; i < shared_count; ++i) {
 				shared[i] = rcu_dereference(fobj->shared[i]);
 				if (!dma_fence_get_rcu(shared[i]))
 					break;
 			}
+
+			if (!pfence_excl && fence_excl) {
+				shared[i] = fence_excl;
+				fence_excl = NULL;
+				++i;
+				++shared_count;
+			}
 		}
 
 		if (i != shared_count || read_seqcount_retry(&obj->seq, seq)) {
@@ -448,7 +460,8 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
 
 	*pshared_count = shared_count;
 	*pshared = shared;
-	*pfence_excl = fence_excl;
+	if (pfence_excl)
+		*pfence_excl = fence_excl;
 
 	return ret;
 }
-- 
2.14.1
