Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:39386 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932657AbeCITLu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 14:11:50 -0500
Received: by mail-wm0-f65.google.com with SMTP id i3so5680373wmi.4
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2018 11:11:49 -0800 (PST)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Cc: sumit.semwal@linaro.org
Subject: [PATCH 2/4] drm/ttm: keep a reference to transfer pipelined BOs
Date: Fri,  9 Mar 2018 20:11:42 +0100
Message-Id: <20180309191144.1817-3-christian.koenig@amd.com>
In-Reply-To: <20180309191144.1817-1-christian.koenig@amd.com>
References: <20180309191144.1817-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure the transfered BO is never destroy before the transfer BO.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c | 50 +++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 1f730b3f18e5..1ee20558ee31 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -39,6 +39,11 @@
 #include <linux/module.h>
 #include <linux/reservation.h>
 
+struct ttm_transfer_obj {
+	struct ttm_buffer_object base;
+	struct ttm_buffer_object *bo;
+};
+
 void ttm_bo_free_old_node(struct ttm_buffer_object *bo)
 {
 	ttm_bo_mem_put(bo, &bo->mem);
@@ -435,7 +440,11 @@ EXPORT_SYMBOL(ttm_bo_move_memcpy);
 
 static void ttm_transfered_destroy(struct ttm_buffer_object *bo)
 {
-	kfree(bo);
+	struct ttm_transfer_obj *fbo;
+
+	fbo = container_of(bo, struct ttm_transfer_obj, base);
+	ttm_bo_unref(&fbo->bo);
+	kfree(fbo);
 }
 
 /**
@@ -456,14 +465,15 @@ static void ttm_transfered_destroy(struct ttm_buffer_object *bo)
 static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
 				      struct ttm_buffer_object **new_obj)
 {
-	struct ttm_buffer_object *fbo;
+	struct ttm_transfer_obj *fbo;
 	int ret;
 
 	fbo = kmalloc(sizeof(*fbo), GFP_KERNEL);
 	if (!fbo)
 		return -ENOMEM;
 
-	*fbo = *bo;
+	fbo->base = *bo;
+	fbo->bo = ttm_bo_reference(bo);
 
 	/**
 	 * Fix up members that we shouldn't copy directly:
@@ -471,25 +481,25 @@ static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
 	 */
 
 	atomic_inc(&bo->bdev->glob->bo_count);
-	INIT_LIST_HEAD(&fbo->ddestroy);
-	INIT_LIST_HEAD(&fbo->lru);
-	INIT_LIST_HEAD(&fbo->swap);
-	INIT_LIST_HEAD(&fbo->io_reserve_lru);
-	mutex_init(&fbo->wu_mutex);
-	fbo->moving = NULL;
-	drm_vma_node_reset(&fbo->vma_node);
-	atomic_set(&fbo->cpu_writers, 0);
-
-	kref_init(&fbo->list_kref);
-	kref_init(&fbo->kref);
-	fbo->destroy = &ttm_transfered_destroy;
-	fbo->acc_size = 0;
-	fbo->resv = &fbo->ttm_resv;
-	reservation_object_init(fbo->resv);
-	ret = reservation_object_trylock(fbo->resv);
+	INIT_LIST_HEAD(&fbo->base.ddestroy);
+	INIT_LIST_HEAD(&fbo->base.lru);
+	INIT_LIST_HEAD(&fbo->base.swap);
+	INIT_LIST_HEAD(&fbo->base.io_reserve_lru);
+	mutex_init(&fbo->base.wu_mutex);
+	fbo->base.moving = NULL;
+	drm_vma_node_reset(&fbo->base.vma_node);
+	atomic_set(&fbo->base.cpu_writers, 0);
+
+	kref_init(&fbo->base.list_kref);
+	kref_init(&fbo->base.kref);
+	fbo->base.destroy = &ttm_transfered_destroy;
+	fbo->base.acc_size = 0;
+	fbo->base.resv = &fbo->base.ttm_resv;
+	reservation_object_init(fbo->base.resv);
+	ret = reservation_object_trylock(fbo->base.resv);
 	WARN_ON(!ret);
 
-	*new_obj = fbo;
+	*new_obj = &fbo->base;
 	return 0;
 }
 
-- 
2.14.1
