Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:16984 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab2HIJgu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 05:36:50 -0400
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@linaro.org,
	inki.dae@samsung.com, daniel.vetter@ffwll.ch, rob@ti.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
	jy0922.shim@samsung.com, sw0312.kim@samsung.com,
	dan.j.williams@intel.com
Subject: [PATCH v2 2/2] drm: set owner field to for all DMABUF exporters
Date: Thu, 09 Aug 2012 11:36:22 +0200
Message-id: <1344504982-30415-3-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1344504982-30415-1-git-send-email-t.stanislaws@samsung.com>
References: <1344504982-30415-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch sets owner field in DMABUF operations for all DMABUF exporters in
DRM subsystem.  This prevents an exporting module from being unloaded while
exported DMABUF descriptor is in use.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    1 +
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    1 +
 drivers/gpu/drm/nouveau/nouveau_prime.c    |    1 +
 drivers/gpu/drm/radeon/radeon_prime.c      |    1 +
 drivers/staging/omapdrm/omap_gem_dmabuf.c  |    1 +
 5 files changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
index 613bf8a..cf3bc6d 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
@@ -164,6 +164,7 @@ static void exynos_gem_dmabuf_kunmap(struct dma_buf *dma_buf,
 }
 
 static struct dma_buf_ops exynos_dmabuf_ops = {
+	.owner			= THIS_MODULE,
 	.map_dma_buf		= exynos_gem_map_dma_buf,
 	.unmap_dma_buf		= exynos_gem_unmap_dma_buf,
 	.kmap			= exynos_gem_dmabuf_kmap,
diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index aa308e1..07ff03b 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -152,6 +152,7 @@ static int i915_gem_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struct *
 }
 
 static const struct dma_buf_ops i915_dmabuf_ops =  {
+	.owner = THIS_MODULE,
 	.map_dma_buf = i915_gem_map_dma_buf,
 	.unmap_dma_buf = i915_gem_unmap_dma_buf,
 	.release = i915_gem_dmabuf_release,
diff --git a/drivers/gpu/drm/nouveau/nouveau_prime.c b/drivers/gpu/drm/nouveau/nouveau_prime.c
index a25cf2c..8605033 100644
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -127,6 +127,7 @@ static void nouveau_gem_prime_vunmap(struct dma_buf *dma_buf, void *vaddr)
 }
 
 static const struct dma_buf_ops nouveau_dmabuf_ops =  {
+	.owner = THIS_MODULE,
 	.map_dma_buf = nouveau_gem_map_dma_buf,
 	.unmap_dma_buf = nouveau_gem_unmap_dma_buf,
 	.release = nouveau_gem_dmabuf_release,
diff --git a/drivers/gpu/drm/radeon/radeon_prime.c b/drivers/gpu/drm/radeon/radeon_prime.c
index 6bef46a..4061fd3 100644
--- a/drivers/gpu/drm/radeon/radeon_prime.c
+++ b/drivers/gpu/drm/radeon/radeon_prime.c
@@ -127,6 +127,7 @@ static void radeon_gem_prime_vunmap(struct dma_buf *dma_buf, void *vaddr)
 	mutex_unlock(&dev->struct_mutex);
 }
 const static struct dma_buf_ops radeon_dmabuf_ops =  {
+	.owner = THIS_MODULE,
 	.map_dma_buf = radeon_gem_map_dma_buf,
 	.unmap_dma_buf = radeon_gem_unmap_dma_buf,
 	.release = radeon_gem_dmabuf_release,
diff --git a/drivers/staging/omapdrm/omap_gem_dmabuf.c b/drivers/staging/omapdrm/omap_gem_dmabuf.c
index 42728e0..6a4dd67 100644
--- a/drivers/staging/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/staging/omapdrm/omap_gem_dmabuf.c
@@ -179,6 +179,7 @@ out_unlock:
 }
 
 struct dma_buf_ops omap_dmabuf_ops = {
+		.owner = THIS_MODULE,
 		.map_dma_buf = omap_gem_map_dma_buf,
 		.unmap_dma_buf = omap_gem_unmap_dma_buf,
 		.release = omap_gem_dmabuf_release,
-- 
1.7.9.5

