Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36357 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932656AbeCITLw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 14:11:52 -0500
Received: by mail-wr0-f196.google.com with SMTP id v111so10007474wrb.3
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2018 11:11:51 -0800 (PST)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Cc: sumit.semwal@linaro.org
Subject: [PATCH 4/4] drm/amdgpu: add independent DMA-buf import
Date: Fri,  9 Mar 2018 20:11:44 +0100
Message-Id: <20180309191144.1817-5-christian.koenig@amd.com>
In-Reply-To: <20180309191144.1817-1-christian.koenig@amd.com>
References: <20180309191144.1817-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of relying on the DRM functions just implement our own import
functions. This adds support for taking care of unpinned DMA-buf.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c | 64 +++++++++++++++++++++++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c   | 32 +++++++++++++---
 2 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
index f575fb46d7a8..7963ce329519 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
@@ -298,22 +298,64 @@ struct dma_buf *amdgpu_gem_prime_export(struct drm_device *dev,
 	return buf;
 }
 
+static void
+amdgpu_gem_prime_invalidate_mappings(struct dma_buf_attachment *attach)
+{
+	struct ttm_operation_ctx ctx = { false, false };
+	struct drm_gem_object *obj = attach->priv;
+	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
+	int r;
+
+	amdgpu_ttm_placement_from_domain(bo, AMDGPU_GEM_DOMAIN_CPU);
+	r = ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
+	if (r)
+		DRM_ERROR("Failed to unmap DMA-buf import (%d))\n", r);
+}
+
 struct drm_gem_object *amdgpu_gem_prime_import(struct drm_device *dev,
 					    struct dma_buf *dma_buf)
 {
+	struct dma_buf_attachment *attach;
 	struct drm_gem_object *obj;
+	int ret;
 
-	if (dma_buf->ops == &amdgpu_dmabuf_ops) {
-		obj = dma_buf->priv;
-		if (obj->dev == dev) {
-			/*
-			 * Importing dmabuf exported from out own gem increases
-			 * refcount on gem itself instead of f_count of dmabuf.
-			 */
-			drm_gem_object_get(obj);
-			return obj;
-		}
+	if (dma_buf->ops != &amdgpu_dmabuf_ops)
+		return drm_gem_prime_import(dev, dma_buf);
+
+	obj = dma_buf->priv;
+	if (obj->dev == dev) {
+		/*
+		 * Importing dmabuf exported from out own gem increases
+		 * refcount on gem itself instead of f_count of dmabuf.
+		 */
+		drm_gem_object_get(obj);
+		return obj;
+	}
+
+	/*
+	 * Attach, but don't map other amdgpu BOs
+	 */
+	attach = dma_buf_attach(dma_buf, dev->dev);
+	if (IS_ERR(attach))
+		return ERR_CAST(attach);
+
+	get_dma_buf(dma_buf);
+
+	obj = amdgpu_gem_prime_import_sg_table(dev, attach, NULL);
+	if (IS_ERR(obj)) {
+		ret = PTR_ERR(obj);
+		goto fail_detach;
 	}
 
-	return drm_gem_prime_import(dev, dma_buf);
+	obj->import_attach = attach;
+	attach->invalidate_mappings = amdgpu_gem_prime_invalidate_mappings;
+	attach->priv = obj;
+
+	return obj;
+
+fail_detach:
+	dma_buf_detach(dma_buf, attach);
+	dma_buf_put(dma_buf);
+
+	return ERR_PTR(ret);
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 291dd3d600cd..aeead0281e92 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -43,6 +43,7 @@
 #include <linux/pagemap.h>
 #include <linux/debugfs.h>
 #include <linux/iommu.h>
+#include <linux/dma-buf.h>
 #include "amdgpu.h"
 #include "amdgpu_object.h"
 #include "amdgpu_trace.h"
@@ -685,6 +686,7 @@ struct amdgpu_ttm_gup_task_list {
 
 struct amdgpu_ttm_tt {
 	struct ttm_dma_tt	ttm;
+	struct amdgpu_bo	*bo;
 	u64			offset;
 	uint64_t		userptr;
 	struct mm_struct	*usermm;
@@ -993,6 +995,7 @@ static struct ttm_tt *amdgpu_ttm_tt_create(struct ttm_buffer_object *bo,
 		return NULL;
 	}
 	gtt->ttm.ttm.func = &amdgpu_backend_func;
+	gtt->bo = ttm_to_amdgpu_bo(bo);
 	if (ttm_sg_tt_init(&gtt->ttm, bo, page_flags)) {
 		kfree(gtt);
 		return NULL;
@@ -1005,7 +1008,6 @@ static int amdgpu_ttm_tt_populate(struct ttm_tt *ttm,
 {
 	struct amdgpu_device *adev = amdgpu_ttm_adev(ttm->bdev);
 	struct amdgpu_ttm_tt *gtt = (void *)ttm;
-	bool slave = !!(ttm->page_flags & TTM_PAGE_FLAG_SG);
 
 	if (gtt && gtt->userptr) {
 		ttm->sg = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
@@ -1017,7 +1019,19 @@ static int amdgpu_ttm_tt_populate(struct ttm_tt *ttm,
 		return 0;
 	}
 
-	if (slave && ttm->sg) {
+	if (ttm->page_flags & TTM_PAGE_FLAG_SG) {
+		if (!ttm->sg) {
+			struct dma_buf_attachment *attach;
+			struct sg_table *sgt;
+
+			attach = gtt->bo->gem_base.import_attach;
+			sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+			if (IS_ERR(sgt))
+				return PTR_ERR(sgt);
+
+			ttm->sg = sgt;
+		}
+
 		drm_prime_sg_to_page_addr_arrays(ttm->sg, ttm->pages,
 						 gtt->ttm.dma_address,
 						 ttm->num_pages);
@@ -1036,9 +1050,8 @@ static int amdgpu_ttm_tt_populate(struct ttm_tt *ttm,
 
 static void amdgpu_ttm_tt_unpopulate(struct ttm_tt *ttm)
 {
-	struct amdgpu_device *adev;
 	struct amdgpu_ttm_tt *gtt = (void *)ttm;
-	bool slave = !!(ttm->page_flags & TTM_PAGE_FLAG_SG);
+	struct amdgpu_device *adev;
 
 	if (gtt && gtt->userptr) {
 		amdgpu_ttm_tt_set_user_pages(ttm, NULL);
@@ -1047,7 +1060,16 @@ static void amdgpu_ttm_tt_unpopulate(struct ttm_tt *ttm)
 		return;
 	}
 
-	if (slave)
+	if (ttm->sg && !gtt->bo->tbo.sg) {
+		struct dma_buf_attachment *attach;
+
+		attach = gtt->bo->gem_base.import_attach;
+		dma_buf_unmap_attachment(attach, ttm->sg, DMA_BIDIRECTIONAL);
+		ttm->sg = NULL;
+		return;
+	}
+
+	if (ttm->page_flags & TTM_PAGE_FLAG_SG)
 		return;
 
 	adev = amdgpu_ttm_adev(ttm->bdev);
-- 
2.14.1
