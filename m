Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:15724 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932497AbdKBUDy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Nov 2017 16:03:54 -0400
From: Ville Syrjala <ville.syrjala@linux.intel.com>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@redhat.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH 3/4] drm/syncobj: Use proper methods for accessing rcu protected pointers
Date: Thu,  2 Nov 2017 22:03:35 +0200
Message-Id: <20171102200336.23347-4-ville.syrjala@linux.intel.com>
In-Reply-To: <20171102200336.23347-1-ville.syrjala@linux.intel.com>
References: <20171102200336.23347-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Use rcu_dereference_protected() and rcu_assign_pointer() for accessing
the rcu protected syncobj->fence pointer. This eliminates several sparse
warnings.

Cc: Dave Airlie <airlied@redhat.com>
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: linaro-mm-sig@lists.linaro.org
Cc: linux-media@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/drm_syncobj.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
index f776fc1cc543..9b733c510cbf 100644
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -106,7 +106,8 @@ static int drm_syncobj_fence_get_or_add_callback(struct drm_syncobj *syncobj,
 	 * callback when a fence has already been set.
 	 */
 	if (syncobj->fence) {
-		*fence = dma_fence_get(syncobj->fence);
+		*fence = dma_fence_get(rcu_dereference_protected(syncobj->fence,
+								 lockdep_is_held(&syncobj->lock)));
 		ret = 1;
 	} else {
 		*fence = NULL;
@@ -168,8 +169,9 @@ void drm_syncobj_replace_fence(struct drm_syncobj *syncobj,
 
 	spin_lock(&syncobj->lock);
 
-	old_fence = syncobj->fence;
-	syncobj->fence = fence;
+	old_fence = rcu_dereference_protected(syncobj->fence,
+					      lockdep_is_held(&syncobj->lock));
+	rcu_assign_pointer(syncobj->fence, fence);
 
 	if (fence != old_fence) {
 		list_for_each_entry_safe(cur, tmp, &syncobj->cb_list, node) {
@@ -659,7 +661,8 @@ static void syncobj_wait_syncobj_func(struct drm_syncobj *syncobj,
 		container_of(cb, struct syncobj_wait_entry, syncobj_cb);
 
 	/* This happens inside the syncobj lock */
-	wait->fence = dma_fence_get(syncobj->fence);
+	wait->fence = dma_fence_get(rcu_dereference_protected(syncobj->fence,
+							      lockdep_is_held(&syncobj->lock)));
 	wake_up_process(wait->task);
 }
 
-- 
2.13.6
