Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36153 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbeFVOLM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 10:11:12 -0400
Received: by mail-wm0-f67.google.com with SMTP id v131-v6so2795676wma.1
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2018 07:11:11 -0700 (PDT)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: daniel@ffwll.ch, sumit.semwal@linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org
Subject: [PATCH 4/4] drm/amdgpu: add independent DMA-buf import v4
Date: Fri, 22 Jun 2018 16:11:03 +0200
Message-Id: <20180622141103.1787-5-christian.koenig@amd.com>
In-Reply-To: <20180622141103.1787-1-christian.koenig@amd.com>
References: <20180622141103.1787-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of relying on the DRM functions just implement our own import
functions. This prepares support for taking care of unpinned DMA-buf.

v2: enable for all exporters, not just amdgpu, fix invalidation
    handling, lock reservation object while setting callback
v3: change to new dma_buf attach interface
v4: split out from unpinned DMA-buf work

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h       |  4 ----
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c   |  1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c | 38 +++++++++++++++++++------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c   | 34 +++++++++++++++++++++++----
 4 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 5e71af8dd3a7..391c171f814e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -373,10 +373,6 @@ int amdgpu_gem_object_open(struct drm_gem_object *obj,
 void amdgpu_gem_object_close(struct drm_gem_object *obj,
 				struct drm_file *file_priv);
 unsigned long amdgpu_gem_timeout(uint64_t timeout_ns);
-struct drm_gem_object *
-amdgpu_gem_prime_import_sg_table(struct drm_device *dev,
-				 struct dma_buf_attachment *attach,
-				 struct sg_table *sg);
 struct dma_buf *amdgpu_gem_prime_export(struct drm_device *dev,
 					struct drm_gem_object *gobj,
 					int flags);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index cdf0be85d361..ad0a8b3f90b2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -919,7 +919,6 @@ static struct drm_driver kms_driver = {
 	.gem_prime_export = amdgpu_gem_prime_export,
 	.gem_prime_import = amdgpu_gem_prime_import,
 	.gem_prime_res_obj = amdgpu_gem_prime_res_obj,
-	.gem_prime_import_sg_table = amdgpu_gem_prime_import_sg_table,
 	.gem_prime_vmap = amdgpu_gem_prime_vmap,
 	.gem_prime_vunmap = amdgpu_gem_prime_vunmap,
 	.gem_prime_mmap = amdgpu_gem_prime_mmap,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
index 038a8c8488b7..5cc4c09d720e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
@@ -122,31 +122,28 @@ int amdgpu_gem_prime_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma
 }
 
 /**
- * amdgpu_gem_prime_import_sg_table - &drm_driver.gem_prime_import_sg_table
- * implementation
+ * amdgpu_gem_prime_create_obj - create BO for DMA-buf import
+ *
  * @dev: DRM device
- * @attach: DMA-buf attachment
- * @sg: Scatter/gather table
+ * @dma_buf: DMA-buf
  *
- * Import shared DMA buffer memory exported by another device.
+ * Creates an empty SG BO for DMA-buf import.
  *
  * Returns:
  * A new GEM buffer object of the given DRM device, representing the memory
  * described by the given DMA-buf attachment and scatter/gather table.
  */
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
 	struct amdgpu_bo_param bp;
 	int ret;
 
 	memset(&bp, 0, sizeof(bp));
-	bp.size = attach->dmabuf->size;
+	bp.size = dma_buf->size;
 	bp.byte_align = PAGE_SIZE;
 	bp.domain = AMDGPU_GEM_DOMAIN_CPU;
 	bp.flags = 0;
@@ -157,11 +154,9 @@ amdgpu_gem_prime_import_sg_table(struct drm_device *dev,
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
@@ -376,6 +371,7 @@ struct dma_buf *amdgpu_gem_prime_export(struct drm_device *dev,
 struct drm_gem_object *amdgpu_gem_prime_import(struct drm_device *dev,
 					    struct dma_buf *dma_buf)
 {
+	struct dma_buf_attachment *attach;
 	struct drm_gem_object *obj;
 
 	if (dma_buf->ops == &amdgpu_dmabuf_ops) {
@@ -390,5 +386,17 @@ struct drm_gem_object *amdgpu_gem_prime_import(struct drm_device *dev,
 		}
 	}
 
-	return drm_gem_prime_import(dev, dma_buf);
+	obj = amdgpu_gem_prime_create_obj(dev, dma_buf);
+	if (IS_ERR(obj))
+		return obj;
+
+	attach = dma_buf_attach(dma_buf, dev->dev);
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
index 0c084d3d0865..f2903054db9e 100644
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
@@ -798,6 +799,7 @@ struct amdgpu_ttm_gup_task_list {
 
 struct amdgpu_ttm_tt {
 	struct ttm_dma_tt	ttm;
+	struct drm_gem_object	*gobj;
 	u64			offset;
 	uint64_t		userptr;
 	struct task_struct	*usertask;
@@ -1222,6 +1224,7 @@ static struct ttm_tt *amdgpu_ttm_tt_create(struct ttm_buffer_object *bo,
 		return NULL;
 	}
 	gtt->ttm.ttm.func = &amdgpu_backend_func;
+	gtt->gobj = &ttm_to_amdgpu_bo(bo)->gem_base;
 
 	/* allocate space for the uninitialized page entries */
 	if (ttm_sg_tt_init(&gtt->ttm, bo, page_flags)) {
@@ -1242,7 +1245,6 @@ static int amdgpu_ttm_tt_populate(struct ttm_tt *ttm,
 {
 	struct amdgpu_device *adev = amdgpu_ttm_adev(ttm->bdev);
 	struct amdgpu_ttm_tt *gtt = (void *)ttm;
-	bool slave = !!(ttm->page_flags & TTM_PAGE_FLAG_SG);
 
 	/* user pages are bound by amdgpu_ttm_tt_pin_userptr() */
 	if (gtt && gtt->userptr) {
@@ -1255,7 +1257,20 @@ static int amdgpu_ttm_tt_populate(struct ttm_tt *ttm,
 		return 0;
 	}
 
-	if (slave && ttm->sg) {
+	if (ttm->page_flags & TTM_PAGE_FLAG_SG) {
+		if (!ttm->sg) {
+			struct dma_buf_attachment *attach;
+			struct sg_table *sgt;
+
+			attach = gtt->gobj->import_attach;
+			sgt = dma_buf_map_attachment_locked(attach,
+							    DMA_BIDIRECTIONAL);
+			if (IS_ERR(sgt))
+				return PTR_ERR(sgt);
+
+			ttm->sg = sgt;
+		}
+
 		drm_prime_sg_to_page_addr_arrays(ttm->sg, ttm->pages,
 						 gtt->ttm.dma_address,
 						 ttm->num_pages);
@@ -1282,9 +1297,8 @@ static int amdgpu_ttm_tt_populate(struct ttm_tt *ttm,
  */
 static void amdgpu_ttm_tt_unpopulate(struct ttm_tt *ttm)
 {
-	struct amdgpu_device *adev;
 	struct amdgpu_ttm_tt *gtt = (void *)ttm;
-	bool slave = !!(ttm->page_flags & TTM_PAGE_FLAG_SG);
+	struct amdgpu_device *adev;
 
 	if (gtt && gtt->userptr) {
 		amdgpu_ttm_tt_set_user_pages(ttm, NULL);
@@ -1293,7 +1307,17 @@ static void amdgpu_ttm_tt_unpopulate(struct ttm_tt *ttm)
 		return;
 	}
 
-	if (slave)
+	if (ttm->sg && gtt->gobj->import_attach) {
+		struct dma_buf_attachment *attach;
+
+		attach = gtt->gobj->import_attach;
+		dma_buf_unmap_attachment_locked(attach, ttm->sg,
+						DMA_BIDIRECTIONAL);
+		ttm->sg = NULL;
+		return;
+	}
+
+	if (ttm->page_flags & TTM_PAGE_FLAG_SG)
 		return;
 
 	adev = amdgpu_ttm_adev(ttm->bdev);
-- 
2.14.1
