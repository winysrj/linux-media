Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:38208 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752735AbeCPNU5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 09:20:57 -0400
Received: by mail-wr0-f196.google.com with SMTP id l8so11704054wrg.5
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2018 06:20:56 -0700 (PDT)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: [PATCH 4/5] drm/amdgpu: add independent DMA-buf export v2
Date: Fri, 16 Mar 2018 14:20:48 +0100
Message-Id: <20180316132049.1748-5-christian.koenig@amd.com>
In-Reply-To: <20180316132049.1748-1-christian.koenig@amd.com>
References: <20180316132049.1748-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of relying on the DRM functions just implement our own export
functions. This adds support for taking care of unpinned DMA-buf.

v2: fix unintended recursion, remove debugging leftovers

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c    |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |   5 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c  | 110 ++++++++++++++++++-----------
 4 files changed, 73 insertions(+), 44 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 96bcdb97e7e2..909dc9764a22 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -371,7 +371,6 @@ int amdgpu_gem_object_open(struct drm_gem_object *obj,
 void amdgpu_gem_object_close(struct drm_gem_object *obj,
 				struct drm_file *file_priv);
 unsigned long amdgpu_gem_timeout(uint64_t timeout_ns);
-struct sg_table *amdgpu_gem_prime_get_sg_table(struct drm_gem_object *obj);
 struct drm_gem_object *
 amdgpu_gem_prime_import_sg_table(struct drm_device *dev,
 				 struct dma_buf_attachment *attach,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index e6709362994a..e32dcdf8d3db 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -886,7 +886,6 @@ static struct drm_driver kms_driver = {
 	.gem_prime_export = amdgpu_gem_prime_export,
 	.gem_prime_import = amdgpu_gem_prime_import,
 	.gem_prime_res_obj = amdgpu_gem_prime_res_obj,
-	.gem_prime_get_sg_table = amdgpu_gem_prime_get_sg_table,
 	.gem_prime_import_sg_table = amdgpu_gem_prime_import_sg_table,
 	.gem_prime_vmap = amdgpu_gem_prime_vmap,
 	.gem_prime_vunmap = amdgpu_gem_prime_vunmap,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 48e0115d4f76..18483a79dcdd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -31,6 +31,7 @@
  */
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/dma-buf.h>
 #include <drm/drmP.h>
 #include <drm/amdgpu_drm.h>
 #include <drm/drm_cache.h>
@@ -931,6 +932,10 @@ void amdgpu_bo_move_notify(struct ttm_buffer_object *bo,
 
 	amdgpu_bo_kunmap(abo);
 
+	if (abo->gem_base.dma_buf && !abo->gem_base.import_attach &&
+	    bo->mem.mem_type != TTM_PL_SYSTEM)
+		dma_buf_invalidate_mappings(abo->gem_base.dma_buf);
+
 	/* remember the eviction */
 	if (evict)
 		atomic64_inc(&adev->num_evictions);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
index 1c9991738477..7b9edbc938eb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
@@ -32,14 +32,6 @@
 
 static const struct dma_buf_ops amdgpu_dmabuf_ops;
 
-struct sg_table *amdgpu_gem_prime_get_sg_table(struct drm_gem_object *obj)
-{
-	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
-	int npages = bo->tbo.num_pages;
-
-	return drm_prime_pages_to_sg(bo->tbo.ttm->pages, npages);
-}
-
 void *amdgpu_gem_prime_vmap(struct drm_gem_object *obj)
 {
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
@@ -126,22 +118,21 @@ amdgpu_gem_prime_import_sg_table(struct drm_device *dev,
 	return ERR_PTR(ret);
 }
 
-static int amdgpu_gem_map_attach(struct dma_buf *dma_buf,
-				 struct device *target_dev,
-				 struct dma_buf_attachment *attach)
+static struct sg_table *
+amdgpu_gem_map_dma_buf(struct dma_buf_attachment *attach,
+		       enum dma_data_direction dir)
 {
+	struct dma_buf *dma_buf = attach->dmabuf;
 	struct drm_gem_object *obj = dma_buf->priv;
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
+	struct sg_table *sgt;
 	long r;
 
-	r = drm_gem_map_attach(dma_buf, target_dev, attach);
-	if (r)
-		return r;
-
-	r = amdgpu_bo_reserve(bo, false);
-	if (unlikely(r != 0))
-		goto error_detach;
-
+	if (!attach->invalidate_mappings) {
+		r = amdgpu_bo_reserve(bo, false);
+		if (unlikely(r != 0))
+			return ERR_PTR(r);
+	}
 
 	if (dma_buf->ops != &amdgpu_dmabuf_ops) {
 		/*
@@ -157,41 +148,77 @@ static int amdgpu_gem_map_attach(struct dma_buf *dma_buf,
 		}
 	}
 
-	/* pin buffer into GTT */
-	r = amdgpu_bo_pin(bo, AMDGPU_GEM_DOMAIN_GTT, NULL);
-	if (r)
+	if (!attach->invalidate_mappings) {
+		/* pin buffer into GTT */
+		r = amdgpu_bo_pin(bo, AMDGPU_GEM_DOMAIN_GTT, NULL);
+		if (r)
+			goto error_unreserve;
+
+	} else {
+		/* move buffer into GTT */
+		struct ttm_operation_ctx ctx = { false, false };
+
+		amdgpu_ttm_placement_from_domain(bo, AMDGPU_GEM_DOMAIN_GTT);
+		r = ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
+		if (r)
+			goto error_unreserve;
+	}
+
+	sgt = drm_prime_pages_to_sg(bo->tbo.ttm->pages, bo->tbo.num_pages);
+	if (IS_ERR(sgt)) {
+		r = PTR_ERR(sgt);
 		goto error_unreserve;
+	}
+
+	if (!dma_map_sg_attrs(attach->dev, sgt->sgl, sgt->nents, dir,
+			      DMA_ATTR_SKIP_CPU_SYNC))
+		goto error_free;
 
 	if (dma_buf->ops != &amdgpu_dmabuf_ops)
 		bo->prime_shared_count++;
 
+	if (!attach->invalidate_mappings)
+		amdgpu_bo_unreserve(bo);
+
+	return sgt;
+
+error_free:
+	sg_free_table(sgt);
+	kfree(sgt);
+	r = -ENOMEM;
+
 error_unreserve:
-	amdgpu_bo_unreserve(bo);
+	if (!attach->invalidate_mappings)
+		amdgpu_bo_unreserve(bo);
 
-error_detach:
-	if (r)
-		drm_gem_map_detach(dma_buf, attach);
-	return r;
+	return ERR_PTR(r);
 }
 
-static void amdgpu_gem_map_detach(struct dma_buf *dma_buf,
-				  struct dma_buf_attachment *attach)
+static void amdgpu_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
+				     struct sg_table *sgt,
+				     enum dma_data_direction dir)
 {
+	struct dma_buf *dma_buf = attach->dmabuf;
 	struct drm_gem_object *obj = dma_buf->priv;
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
-	int ret = 0;
 
-	ret = amdgpu_bo_reserve(bo, true);
-	if (unlikely(ret != 0))
-		goto error;
+	if (!attach->invalidate_mappings) {
+		amdgpu_bo_reserve(bo, true);
+		amdgpu_bo_unpin(bo);
+	}
 
-	amdgpu_bo_unpin(bo);
-	if (dma_buf->ops != &amdgpu_dmabuf_ops && bo->prime_shared_count)
+	if (dma_buf->ops != &amdgpu_dmabuf_ops &&
+	    bo->prime_shared_count)
 		bo->prime_shared_count--;
-	amdgpu_bo_unreserve(bo);
 
-error:
-	drm_gem_map_detach(dma_buf, attach);
+	if (!attach->invalidate_mappings)
+		amdgpu_bo_unreserve(bo);
+
+	if (sgt) {
+		dma_unmap_sg(attach->dev, sgt->sgl, sgt->nents, dir);
+		sg_free_table(sgt);
+		kfree(sgt);
+	}
 }
 
 struct reservation_object *amdgpu_gem_prime_res_obj(struct drm_gem_object *obj)
@@ -230,10 +257,9 @@ static int amdgpu_gem_begin_cpu_access(struct dma_buf *dma_buf,
 }
 
 static const struct dma_buf_ops amdgpu_dmabuf_ops = {
-	.attach = amdgpu_gem_map_attach,
-	.detach = amdgpu_gem_map_detach,
-	.map_dma_buf = drm_gem_map_dma_buf,
-	.unmap_dma_buf = drm_gem_unmap_dma_buf,
+	.supports_mapping_invalidation = true,
+	.map_dma_buf = amdgpu_gem_map_dma_buf,
+	.unmap_dma_buf = amdgpu_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.begin_cpu_access = amdgpu_gem_begin_cpu_access,
 	.map = drm_gem_dmabuf_kmap,
-- 
2.14.1
