Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34301 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752628AbeCYLAJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 07:00:09 -0400
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] drm/amdgpu: add support for exporting VRAM using DMA-buf
Date: Sun, 25 Mar 2018 13:00:00 +0200
Message-Id: <20180325110000.2238-8-christian.koenig@amd.com>
In-Reply-To: <20180325110000.2238-1-christian.koenig@amd.com>
References: <20180325110000.2238-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should be able to do this now after checking all the prerequisites.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c    | 44 +++++++++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h      |  9 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 91 ++++++++++++++++++++++++++++
 3 files changed, 135 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
index 133596df0775..86d983a0678b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
@@ -197,23 +197,44 @@ amdgpu_gem_map_dma_buf(struct dma_buf_attachment *attach,
 	} else {
 		/* move buffer into GTT */
 		struct ttm_operation_ctx ctx = { false, false };
+		unsigned domains = AMDGPU_GEM_DOMAIN_GTT;
 
-		amdgpu_ttm_placement_from_domain(bo, AMDGPU_GEM_DOMAIN_GTT);
+		if (bo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM &&
+		    attach->peer2peer) {
+			bo->flags |= AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED;
+			domains |= AMDGPU_GEM_DOMAIN_VRAM;
+		}
+		amdgpu_ttm_placement_from_domain(bo, domains);
 		r = ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
 		if (r)
 			goto error_unreserve;
 	}
 
-	sgt = drm_prime_pages_to_sg(bo->tbo.ttm->pages, bo->tbo.num_pages);
-	if (IS_ERR(sgt)) {
-		r = PTR_ERR(sgt);
+	switch (bo->tbo.mem.mem_type) {
+	case TTM_PL_TT:
+		sgt = drm_prime_pages_to_sg(bo->tbo.ttm->pages,
+					    bo->tbo.num_pages);
+		if (IS_ERR(sgt)) {
+			r = PTR_ERR(sgt);
+			goto error_unreserve;
+		}
+
+		if (!dma_map_sg_attrs(attach->dev, sgt->sgl, sgt->nents, dir,
+				      DMA_ATTR_SKIP_CPU_SYNC))
+			goto error_free;
+		break;
+
+	case TTM_PL_VRAM:
+		r = amdgpu_vram_mgr_alloc_sgt(adev, &bo->tbo.mem, attach->dev,
+					      dir, &sgt);
+		if (r)
+			goto error_unreserve;
+		break;
+	default:
+		r = -EINVAL;
 		goto error_unreserve;
 	}
 
-	if (!dma_map_sg_attrs(attach->dev, sgt->sgl, sgt->nents, dir,
-			      DMA_ATTR_SKIP_CPU_SYNC))
-		goto error_free;
-
 	if (attach->dev->driver != adev->dev->driver)
 		bo->prime_shared_count++;
 
@@ -254,10 +275,15 @@ static void amdgpu_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
 	if (!attach->invalidate)
 		amdgpu_bo_unreserve(bo);
 
-	if (sgt) {
+	if (!sgt)
+		return;
+
+	if (sgt->sgl->page_link) {
 		dma_unmap_sg(attach->dev, sgt->sgl, sgt->nents, dir);
 		sg_free_table(sgt);
 		kfree(sgt);
+	} else {
+		amdgpu_vram_mgr_free_sgt(adev, attach->dev, dir, sgt);
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
index 6ea7de863041..b483900abed2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
@@ -73,6 +73,15 @@ bool amdgpu_gtt_mgr_has_gart_addr(struct ttm_mem_reg *mem);
 uint64_t amdgpu_gtt_mgr_usage(struct ttm_mem_type_manager *man);
 int amdgpu_gtt_mgr_recover(struct ttm_mem_type_manager *man);
 
+int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
+			      struct ttm_mem_reg *mem,
+			      struct device *dev,
+			      enum dma_data_direction dir,
+			      struct sg_table **sgt);
+void amdgpu_vram_mgr_free_sgt(struct amdgpu_device *adev,
+			      struct device *dev,
+			      enum dma_data_direction dir,
+			      struct sg_table *sgt);
 uint64_t amdgpu_vram_mgr_usage(struct ttm_mem_type_manager *man);
 uint64_t amdgpu_vram_mgr_vis_usage(struct ttm_mem_type_manager *man);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 9aca653bec07..eb8f75525a81 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -233,6 +233,97 @@ static void amdgpu_vram_mgr_del(struct ttm_mem_type_manager *man,
 	mem->mm_node = NULL;
 }
 
+/**
+ * amdgpu_vram_mgr_alloc_sgt - allocate and fill a sg table
+ *
+ * @adev: amdgpu device pointer
+ * @mem: TTM memory object
+ * @dev: the other device
+ * @dir: dma direction
+ * @sgt: resulting sg table
+ *
+ * Allocate and fill a sg table from a VRAM allocation.
+ */
+int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
+			      struct ttm_mem_reg *mem,
+			      struct device *dev,
+			      enum dma_data_direction dir,
+			      struct sg_table **sgt)
+{
+	struct drm_mm_node *node = mem->mm_node;
+	struct scatterlist *sg;
+	int num_entries;
+	int i, r;
+
+	*sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
+	if (!*sgt)
+		return -ENOMEM;
+
+	num_entries = DIV_ROUND_UP(mem->num_pages, node->size);
+	r = sg_alloc_table(*sgt, num_entries, GFP_KERNEL);
+	if (r)
+		goto error_free;
+
+	for_each_sg((*sgt)->sgl, sg, num_entries, i)
+		sg->length = 0;
+
+	for_each_sg((*sgt)->sgl, sg, num_entries, i) {
+		phys_addr_t phys = (node->start << PAGE_SHIFT) +
+			adev->gmc.aper_base;
+		size_t size = node->size << PAGE_SHIFT;
+		dma_addr_t addr;
+
+		++node;
+		addr = dma_map_resource(dev, phys, size, dir,
+					DMA_ATTR_SKIP_CPU_SYNC);
+		r = dma_mapping_error(dev, addr);
+		if (r)
+			goto error_unmap;
+
+		sg_set_dma_addr(sg, addr, size, 0);
+	}
+	return 0;
+
+error_unmap:
+	for_each_sg((*sgt)->sgl, sg, num_entries, i) {
+		if (!sg->length)
+			continue;
+
+		dma_unmap_resource(dev, sg->dma_address,
+				   sg->length, dir,
+				   DMA_ATTR_SKIP_CPU_SYNC);
+	}
+	sg_free_table(*sgt);
+
+error_free:
+	kfree(*sgt);
+	return r;
+}
+
+/**
+ * amdgpu_vram_mgr_alloc_sgt - allocate and fill a sg table
+ *
+ * @adev: amdgpu device pointer
+ * @sgt: sg table to free
+ *
+ * Free a previously allocate sg table.
+ */
+void amdgpu_vram_mgr_free_sgt(struct amdgpu_device *adev,
+			      struct device *dev,
+			      enum dma_data_direction dir,
+			      struct sg_table *sgt)
+{
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(sgt->sgl, sg, sgt->nents, i)
+		dma_unmap_resource(dev, sg->dma_address,
+				   sg->length, dir,
+				   DMA_ATTR_SKIP_CPU_SYNC);
+	sg_free_table(sgt);
+	kfree(sgt);
+}
+
 /**
  * amdgpu_vram_mgr_usage - how many bytes are used in this domain
  *
-- 
2.14.1
