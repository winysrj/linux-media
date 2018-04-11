Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:46572 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751961AbeDKNkG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 09:40:06 -0400
Received: by mail-wr0-f195.google.com with SMTP id d1so1820306wrj.13
        for <linux-media@vger.kernel.org>; Wed, 11 Apr 2018 06:40:06 -0700 (PDT)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: [PATCH 5/5] drm/amdgpu: add independent DMA-buf import v3
Date: Wed, 11 Apr 2018 15:39:59 +0200
Message-Id: <20180411133959.4257-5-christian.koenig@amd.com>
In-Reply-To: <20180411133959.4257-1-christian.koenig@amd.com>
References: <20180411133959.4257-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of relying on the DRM functions just implement our own import
functions. This adds support for taking care of unpinned DMA-buf.

v2: enable for all exporters, not just amdgpu, fix invalidation
    handling, lock reservation object while setting callback
v3: change to new dma_buf attach interface

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c | 72 ++++++++++++++++++++++++++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c   | 32 +++++++++++---
 2 files changed, 89 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
index 7fef95f0fed1..58dcfba0225a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
@@ -86,28 +86,24 @@ int amdgpu_gem_prime_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma
 	return ret;
 }
 
-struct drm_gem_object *
-amdgpu_gem_prime_import_sg_table(struct drm_device *dev,
-				 struct dma_buf_attachment *attach,
-				 struct sg_table *sg)
+static struct drm_gem_object *
+amdgpu_gem_prime_create_obj(struct drm_device *dev, struct dma_buf *dma_buf)
 {
-	struct reservation_object *resv = attach->dmabuf->resv;
+	struct reservation_object *resv = dma_buf->resv;
 	struct amdgpu_device *adev = dev->dev_private;
 	struct amdgpu_bo *bo;
 	int ret;
 
 	ww_mutex_lock(&resv->lock, NULL);
-	ret = amdgpu_bo_create(adev, attach->dmabuf->size, PAGE_SIZE,
+	ret = amdgpu_bo_create(adev, dma_buf->size, PAGE_SIZE,
 			       AMDGPU_GEM_DOMAIN_CPU, 0, ttm_bo_type_sg,
 			       resv, &bo);
 	if (ret)
 		goto error;
 
-	bo->tbo.sg = sg;
-	bo->tbo.ttm->sg = sg;
 	bo->allowed_domains = AMDGPU_GEM_DOMAIN_GTT;
 	bo->preferred_domains = AMDGPU_GEM_DOMAIN_GTT;
-	if (attach->dmabuf->ops != &amdgpu_dmabuf_ops)
+	if (dma_buf->ops != &amdgpu_dmabuf_ops)
 		bo->prime_shared_count = 1;
 
 	ww_mutex_unlock(&resv->lock);
@@ -118,6 +114,26 @@ amdgpu_gem_prime_import_sg_table(struct drm_device *dev,
 	return ERR_PTR(ret);
 }
 
+struct drm_gem_object *
+amdgpu_gem_prime_import_sg_table(struct drm_device *dev,
+				 struct dma_buf_attachment *attach,
+				 struct sg_table *sg)
+{
+	struct drm_gem_object *obj;
+	struct amdgpu_bo *bo;
+
+	obj = amdgpu_gem_prime_create_obj(dev, attach->dmabuf);
+	if (IS_ERR(obj))
+		return obj;
+
+	bo = gem_to_amdgpu_bo(obj);
+	amdgpu_bo_reserve(bo, true);
+	bo->tbo.sg = sg;
+	bo->tbo.ttm->sg = sg;
+	amdgpu_bo_unreserve(bo);
+	return obj;
+}
+
 static struct sg_table *
 amdgpu_gem_map_dma_buf(struct dma_buf_attachment *attach,
 		       enum dma_data_direction dir)
@@ -293,9 +309,29 @@ struct dma_buf *amdgpu_gem_prime_export(struct drm_device *dev,
 	return buf;
 }
 
+static void
+amdgpu_gem_prime_invalidate_mappings(struct dma_buf_attachment *attach)
+{
+	struct ttm_operation_ctx ctx = { false, false };
+	struct drm_gem_object *obj = attach->priv;
+	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
+	struct ttm_placement placement = {};
+	int r;
+
+	r = ttm_bo_validate(&bo->tbo, &placement, &ctx);
+	if (r)
+		DRM_ERROR("Failed to unmap DMA-buf import (%d))\n", r);
+}
+
 struct drm_gem_object *amdgpu_gem_prime_import(struct drm_device *dev,
 					    struct dma_buf *dma_buf)
 {
+	struct dma_buf_attach_info attach_info = {
+		.dev = dev->dev,
+		.dmabuf = dma_buf,
+		.invalidate = amdgpu_gem_prime_invalidate_mappings
+	};
+	struct dma_buf_attachment *attach;
 	struct drm_gem_object *obj;
 
 	if (dma_buf->ops == &amdgpu_dmabuf_ops) {
@@ -310,5 +346,21 @@ struct drm_gem_object *amdgpu_gem_prime_import(struct drm_device *dev,
 		}
 	}
 
-	return drm_gem_prime_import(dev, dma_buf);
+	if (!dma_buf->invalidation_supported)
+		return drm_gem_prime_import(dev, dma_buf);
+
+	obj = amdgpu_gem_prime_create_obj(dev, dma_buf);
+	if (IS_ERR(obj))
+		return obj;
+
+	attach_info.importer_priv = obj;
+	attach = dma_buf_attach(&attach_info);
+	if (IS_ERR(attach)) {
+		drm_gem_object_put(obj);
+		return ERR_CAST(attach);
+	}
+
+	get_dma_buf(dma_buf);
+	obj->import_attach = attach;
+	return obj;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index ab73300e6c7f..2a8f328918cb 100644
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
@@ -680,6 +681,7 @@ struct amdgpu_ttm_gup_task_list {
 
 struct amdgpu_ttm_tt {
 	struct ttm_dma_tt	ttm;
+	struct amdgpu_bo	*bo;
 	u64			offset;
 	uint64_t		userptr;
 	struct mm_struct	*usermm;
@@ -988,6 +990,7 @@ static struct ttm_tt *amdgpu_ttm_tt_create(struct ttm_buffer_object *bo,
 		return NULL;
 	}
 	gtt->ttm.ttm.func = &amdgpu_backend_func;
+	gtt->bo = ttm_to_amdgpu_bo(bo);
 	if (ttm_sg_tt_init(&gtt->ttm, bo, page_flags)) {
 		kfree(gtt);
 		return NULL;
@@ -1000,7 +1003,6 @@ static int amdgpu_ttm_tt_populate(struct ttm_tt *ttm,
 {
 	struct amdgpu_device *adev = amdgpu_ttm_adev(ttm->bdev);
 	struct amdgpu_ttm_tt *gtt = (void *)ttm;
-	bool slave = !!(ttm->page_flags & TTM_PAGE_FLAG_SG);
 
 	if (gtt && gtt->userptr) {
 		ttm->sg = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
@@ -1012,7 +1014,19 @@ static int amdgpu_ttm_tt_populate(struct ttm_tt *ttm,
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
@@ -1031,9 +1045,8 @@ static int amdgpu_ttm_tt_populate(struct ttm_tt *ttm,
 
 static void amdgpu_ttm_tt_unpopulate(struct ttm_tt *ttm)
 {
-	struct amdgpu_device *adev;
 	struct amdgpu_ttm_tt *gtt = (void *)ttm;
-	bool slave = !!(ttm->page_flags & TTM_PAGE_FLAG_SG);
+	struct amdgpu_device *adev;
 
 	if (gtt && gtt->userptr) {
 		amdgpu_ttm_tt_set_user_pages(ttm, NULL);
@@ -1042,7 +1055,16 @@ static void amdgpu_ttm_tt_unpopulate(struct ttm_tt *ttm)
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
