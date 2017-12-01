Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42830 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752172AbdLAAYR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 19:24:17 -0500
From: Lyude Paul <lyude@redhat.com>
To: stable@vger.kernel.org
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] dma-buf: make reservation_object_copy_fences rcu save
Date: Thu, 30 Nov 2017 19:23:04 -0500
Message-Id: <20171201002311.28098-3-lyude@redhat.com>
In-Reply-To: <20171201002311.28098-1-lyude@redhat.com>
References: <20171201002311.28098-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Christian König <christian.koenig@amd.com>

Stop requiring that the src reservation object is locked for this operation.

commit 39e16ba16c147e662bf9fbcee9a99d70d420382f upstream

Acked-by: Chunming Zhou <david1.zhou@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1504551766-5093-1-git-send-email-deathsimple@vodafone.de
Signed-off-by: Lyude Paul <lyude@redhat.com>
---
 drivers/dma-buf/reservation.c | 56 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index dec3a815455d..b44d9d7db347 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -266,8 +266,7 @@ EXPORT_SYMBOL(reservation_object_add_excl_fence);
 * @dst: the destination reservation object
 * @src: the source reservation object
 *
-* Copy all fences from src to dst. Both src->lock as well as dst-lock must be
-* held.
+* Copy all fences from src to dst. dst-lock must be held.
 */
 int reservation_object_copy_fences(struct reservation_object *dst,
 				   struct reservation_object *src)
@@ -277,33 +276,62 @@ int reservation_object_copy_fences(struct reservation_object *dst,
 	size_t size;
 	unsigned i;
 
-	src_list = reservation_object_get_list(src);
+	rcu_read_lock();
+	src_list = rcu_dereference(src->fence);
 
+retry:
 	if (src_list) {
-		size = offsetof(typeof(*src_list),
-				shared[src_list->shared_count]);
+		unsigned shared_count = src_list->shared_count;
+
+		size = offsetof(typeof(*src_list), shared[shared_count]);
+		rcu_read_unlock();
+
 		dst_list = kmalloc(size, GFP_KERNEL);
 		if (!dst_list)
 			return -ENOMEM;
 
-		dst_list->shared_count = src_list->shared_count;
-		dst_list->shared_max = src_list->shared_count;
-		for (i = 0; i < src_list->shared_count; ++i)
-			dst_list->shared[i] =
-				dma_fence_get(src_list->shared[i]);
+		rcu_read_lock();
+		src_list = rcu_dereference(src->fence);
+		if (!src_list || src_list->shared_count > shared_count) {
+			kfree(dst_list);
+			goto retry;
+		}
+
+		dst_list->shared_count = 0;
+		dst_list->shared_max = shared_count;
+		for (i = 0; i < src_list->shared_count; ++i) {
+			struct dma_fence *fence;
+
+			fence = rcu_dereference(src_list->shared[i]);
+			if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT,
+				     &fence->flags))
+				continue;
+
+			if (!dma_fence_get_rcu(fence)) {
+				kfree(dst_list);
+				src_list = rcu_dereference(src->fence);
+				goto retry;
+			}
+
+			if (dma_fence_is_signaled(fence)) {
+				dma_fence_put(fence);
+				continue;
+			}
+
+			dst_list->shared[dst_list->shared_count++] = fence;
+		}
 	} else {
 		dst_list = NULL;
 	}
 
+	new = dma_fence_get_rcu_safe(&src->fence_excl);
+	rcu_read_unlock();
+
 	kfree(dst->staged);
 	dst->staged = NULL;
 
 	src_list = reservation_object_get_list(dst);
-
 	old = reservation_object_get_excl(dst);
-	new = reservation_object_get_excl(src);
-
-	dma_fence_get(new);
 
 	preempt_disable();
 	write_seqcount_begin(&dst->seq);
-- 
2.14.3
