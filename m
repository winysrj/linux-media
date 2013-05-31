Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:12026 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3EaIyk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 04:54:40 -0400
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch,
	inki.dae@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com
Subject: [RFC][PATCH 2/2] drm/prime: find gem object from the reimported dma-buf
Date: Fri, 31 May 2013 17:54:47 +0900
Message-id: <1369990487-23510-3-git-send-email-sw0312.kim@samsung.com>
In-reply-to: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reimported dma-buf can reuse same gem object only when prime import
is done with same drm open context. So prime import is done with
other drm open context, gem object is newly created and mapped even
there is already mapped gem object. To avoid recreating gem object,
importer private data can be used at reimport time if it is assigned
with drm gem object at first import.
This can also remove remapping dma address for the hardware having
its own iommu.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
---
 drivers/gpu/drm/drm_prime.c                |   19 ++++++++++++++-----
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    1 +
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    1 +
 drivers/gpu/drm/udl/udl_gem.c              |    1 +
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index dcde352..78a3c7d 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -294,6 +294,7 @@ struct drm_gem_object *drm_gem_prime_import(struct drm_device *dev,
 	}
 
 	obj->import_attach = attach;
+	attach->importer_priv = obj;
 
 	return obj;
 
@@ -312,6 +313,7 @@ int drm_gem_prime_fd_to_handle(struct drm_device *dev,
 {
 	struct dma_buf *dma_buf;
 	struct drm_gem_object *obj;
+	struct dma_buf_attachment *attach;
 	int ret;
 
 	dma_buf = dma_buf_get(prime_fd);
@@ -327,11 +329,18 @@ int drm_gem_prime_fd_to_handle(struct drm_device *dev,
 		goto out_put;
 	}
 
-	/* never seen this one, need to import */
-	obj = dev->driver->gem_prime_import(dev, dma_buf);
-	if (IS_ERR(obj)) {
-		ret = PTR_ERR(obj);
-		goto out_put;
+	attach = dma_buf_get_attachment(dma_buf, dev->dev);
+	if (IS_ERR(attach)) {
+		/* never seen this one, need to import */
+		obj = dev->driver->gem_prime_import(dev, dma_buf);
+		if (IS_ERR(obj)) {
+			ret = PTR_ERR(obj);
+			goto out_put;
+		}
+	} else {
+		/* found attachment to same device */
+		obj = attach->importer_priv;
+		drm_gem_object_reference(obj);
 	}
 
 	ret = drm_gem_handle_create(file_priv, obj, handle);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
index ff7f2a8..268da36 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
@@ -285,6 +285,7 @@ struct drm_gem_object *exynos_dmabuf_prime_import(struct drm_device *drm_dev,
 	exynos_gem_obj->buffer = buffer;
 	buffer->sgt = sgt;
 	exynos_gem_obj->base.import_attach = attach;
+	attach->importer_priv = &exynos_gem_obj->base;
 
 	DRM_DEBUG_PRIME("dma_addr = 0x%x, size = 0x%lx\n", buffer->dma_addr,
 								buffer->size);
diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index dc53a52..75ef28c 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -297,6 +297,7 @@ struct drm_gem_object *i915_gem_prime_import(struct drm_device *dev,
 
 	i915_gem_object_init(obj, &i915_gem_object_dmabuf_ops);
 	obj->base.import_attach = attach;
+	attach->importer_priv = &obj->base;
 
 	return &obj->base;
 
diff --git a/drivers/gpu/drm/udl/udl_gem.c b/drivers/gpu/drm/udl/udl_gem.c
index ef034fa..0652db1 100644
--- a/drivers/gpu/drm/udl/udl_gem.c
+++ b/drivers/gpu/drm/udl/udl_gem.c
@@ -317,6 +317,7 @@ struct drm_gem_object *udl_gem_prime_import(struct drm_device *dev,
 	}
 
 	uobj->base.import_attach = attach;
+	attach->importer_priv = &uobj->base;
 
 	return &uobj->base;
 
-- 
1.7.4.1

