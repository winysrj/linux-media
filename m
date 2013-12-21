Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:59769 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3LUAnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 19:43:55 -0500
Received: by mail-qc0-f201.google.com with SMTP id r5so203392qcx.2
        for <linux-media@vger.kernel.org>; Fri, 20 Dec 2013 16:43:54 -0800 (PST)
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Airlie <airlied@linux.ie>,
	Inki Dae <inki.dae@samsung.com>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org (open list:DMA BUFFER SHARIN...),
	dri-devel@lists.freedesktop.org (open list:DMA BUFFER SHARIN...),
	linaro-mm-sig@lists.linaro.org (open list:DMA BUFFER SHARIN...),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/S5P EXYNOS
	AR...),
	linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...)
Subject: [PATCH] dma-buf: avoid using IS_ERR_OR_NULL
Date: Fri, 20 Dec 2013 16:43:50 -0800
Message-Id: <1387586630-1954-1-git-send-email-ccross@android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dma_buf_map_attachment and dma_buf_vmap can return NULL or
ERR_PTR on a error.  This encourages a common buggy pattern in
callers:
	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
	if (IS_ERR_OR_NULL(sgt))
                return PTR_ERR(sgt);

This causes the caller to return 0 on an error.  IS_ERR_OR_NULL
is almost always a sign of poorly-defined error handling.

This patch converts dma_buf_map_attachment to always return
ERR_PTR, and fixes the callers that incorrectly handled NULL.
There are a few more callers that were not checking for NULL
at all, which would have dereferenced a NULL pointer later.
There are also a few more callers that correctly handled NULL
and ERR_PTR differently, I left those alone but they could also
be modified to delete the NULL check.

This patch also converts dma_buf_vmap to always return NULL.
All the callers to dma_buf_vmap only check for NULL, and would
have dereferenced an ERR_PTR and panic'd if one was ever
returned. This is not consistent with the rest of the dma buf
APIs, but matches the expectations of all of the callers.

Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/base/dma-buf.c                         | 18 +++++++++++-------
 drivers/gpu/drm/drm_prime.c                    |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c     |  2 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c |  2 +-
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 1e16cbd61da2..cfe1d8bc7bb8 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -251,9 +251,8 @@ EXPORT_SYMBOL_GPL(dma_buf_put);
  * @dmabuf:	[in]	buffer to attach device to.
  * @dev:	[in]	device to be attached.
  *
- * Returns struct dma_buf_attachment * for this attachment; may return negative
- * error codes.
- *
+ * Returns struct dma_buf_attachment * for this attachment; returns ERR_PTR on
+ * error.
  */
 struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 					  struct device *dev)
@@ -319,9 +318,8 @@ EXPORT_SYMBOL_GPL(dma_buf_detach);
  * @attach:	[in]	attachment whose scatterlist is to be returned
  * @direction:	[in]	direction of DMA transfer
  *
- * Returns sg_table containing the scatterlist to be returned; may return NULL
- * or ERR_PTR.
- *
+ * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
+ * on error.
  */
 struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 					enum dma_data_direction direction)
@@ -334,6 +332,8 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 		return ERR_PTR(-EINVAL);
 
 	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
+	if (!sg_table)
+		sg_table = ERR_PTR(-ENOMEM);
 
 	return sg_table;
 }
@@ -544,6 +544,8 @@ EXPORT_SYMBOL_GPL(dma_buf_mmap);
  * These calls are optional in drivers. The intended use for them
  * is for mapping objects linear in kernel space for high use objects.
  * Please attempt to use kmap/kunmap before thinking about these interfaces.
+ *
+ * Returns NULL on error.
  */
 void *dma_buf_vmap(struct dma_buf *dmabuf)
 {
@@ -566,7 +568,9 @@ void *dma_buf_vmap(struct dma_buf *dmabuf)
 	BUG_ON(dmabuf->vmap_ptr);
 
 	ptr = dmabuf->ops->vmap(dmabuf);
-	if (IS_ERR_OR_NULL(ptr))
+	if (WARN_ON_ONCE(IS_ERR(ptr)))
+		ptr = NULL;
+	if (!ptr)
 		goto out_unlock;
 
 	dmabuf->vmap_ptr = ptr;
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 56805c39c906..bb516fdd195d 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -471,7 +471,7 @@ struct drm_gem_object *drm_gem_prime_import(struct drm_device *dev,
 	get_dma_buf(dma_buf);
 
 	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
-	if (IS_ERR_OR_NULL(sgt)) {
+	if (IS_ERR(sgt)) {
 		ret = PTR_ERR(sgt);
 		goto fail_detach;
 	}
diff --git a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
index 59827cc5e770..c786cd4f457b 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
@@ -224,7 +224,7 @@ struct drm_gem_object *exynos_dmabuf_prime_import(struct drm_device *drm_dev,
 	get_dma_buf(dma_buf);
 
 	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
-	if (IS_ERR_OR_NULL(sgt)) {
+	if (IS_ERR(sgt)) {
 		ret = PTR_ERR(sgt);
 		goto err_buf_detach;
 	}
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 33d3871d1e13..880be0782dd9 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -719,7 +719,7 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
 
 	/* get the associated scatterlist for this buffer */
 	sgt = dma_buf_map_attachment(buf->db_attach, buf->dma_dir);
-	if (IS_ERR_OR_NULL(sgt)) {
+	if (IS_ERR(sgt)) {
 		pr_err("Error getting dmabuf scatterlist\n");
 		return -EINVAL;
 	}
-- 
1.8.5.1

