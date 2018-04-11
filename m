Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:51734 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753185AbeDKNkC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 09:40:02 -0400
Received: by mail-wm0-f66.google.com with SMTP id u189so4259117wmd.1
        for <linux-media@vger.kernel.org>; Wed, 11 Apr 2018 06:40:01 -0700 (PDT)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: [PATCH 1/5] dma-buf: use parameter structure for dma_buf_attach
Date: Wed, 11 Apr 2018 15:39:55 +0200
Message-Id: <20180411133959.4257-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the parameters into a structure to make it simpler to extend it in
follow up patches.

This also adds the importer private as parameter so that we can directly
work with a completely filled in attachment structure.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/dma-buf/dma-buf.c                             | 15 ++++++++-------
 drivers/gpu/drm/armada/armada_gem.c                   |  6 +++++-
 drivers/gpu/drm/drm_prime.c                           |  6 +++++-
 drivers/gpu/drm/i915/i915_gem_dmabuf.c                |  6 +++++-
 drivers/gpu/drm/tegra/gem.c                           |  6 +++++-
 drivers/gpu/drm/udl/udl_dmabuf.c                      |  6 +++++-
 drivers/media/common/videobuf2/videobuf2-dma-contig.c |  6 +++++-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c     |  6 +++++-
 drivers/staging/media/tegra-vde/tegra-vde.c           |  6 +++++-
 include/linux/dma-buf.h                               | 17 +++++++++++++++--
 10 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index d78d5fc173dc..4b46982c6d9c 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -534,8 +534,9 @@ EXPORT_SYMBOL_GPL(dma_buf_put);
 /**
  * dma_buf_attach - Add the device to dma_buf's attachments list; optionally,
  * calls attach() of dma_buf_ops to allow device-specific attach functionality
- * @dmabuf:	[in]	buffer to attach device to.
- * @dev:	[in]	device to be attached.
+ * @info:	[in]	holds all the attach related information provided
+ *			by the importer. see &struct dma_buf_attach_info
+ *			for further details.
  *
  * Returns struct dma_buf_attachment pointer for this attachment. Attachments
  * must be cleaned up by calling dma_buf_detach().
@@ -549,26 +550,26 @@ EXPORT_SYMBOL_GPL(dma_buf_put);
  * accessible to @dev, and cannot be moved to a more suitable place. This is
  * indicated with the error code -EBUSY.
  */
-struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
-					  struct device *dev)
+struct dma_buf_attachment *dma_buf_attach(const struct dma_buf_attach_info *info)
 {
+	struct dma_buf *dmabuf = info->dmabuf;
 	struct dma_buf_attachment *attach;
 	int ret;
 
-	if (WARN_ON(!dmabuf || !dev))
+	if (WARN_ON(!dmabuf || !info->dev))
 		return ERR_PTR(-EINVAL);
 
 	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
 	if (!attach)
 		return ERR_PTR(-ENOMEM);
 
-	attach->dev = dev;
+	attach->dev = info->dev;
 	attach->dmabuf = dmabuf;
 
 	mutex_lock(&dmabuf->lock);
 
 	if (dmabuf->ops->attach) {
-		ret = dmabuf->ops->attach(dmabuf, dev, attach);
+		ret = dmabuf->ops->attach(dmabuf, info->dev, attach);
 		if (ret)
 			goto err_attach;
 	}
diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index a97f509743a5..f4d1c11f57ea 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -514,6 +514,10 @@ armada_gem_prime_export(struct drm_device *dev, struct drm_gem_object *obj,
 struct drm_gem_object *
 armada_gem_prime_import(struct drm_device *dev, struct dma_buf *buf)
 {
+	struct dma_buf_attach_info attach_info = {
+		.dev = dev->dev,
+		.dmabuf = buf
+	};
 	struct dma_buf_attachment *attach;
 	struct armada_gem_object *dobj;
 
@@ -529,7 +533,7 @@ armada_gem_prime_import(struct drm_device *dev, struct dma_buf *buf)
 		}
 	}
 
-	attach = dma_buf_attach(buf, dev->dev);
+	attach = dma_buf_attach(&attach_info);
 	if (IS_ERR(attach))
 		return ERR_CAST(attach);
 
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 7856a9b3f8a8..4da242de51c2 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -707,6 +707,10 @@ struct drm_gem_object *drm_gem_prime_import_dev(struct drm_device *dev,
 					    struct dma_buf *dma_buf,
 					    struct device *attach_dev)
 {
+	struct dma_buf_attach_info attach_info = {
+		.dev = attach_dev,
+		.dmabuf = dma_buf
+	};
 	struct dma_buf_attachment *attach;
 	struct sg_table *sgt;
 	struct drm_gem_object *obj;
@@ -727,7 +731,7 @@ struct drm_gem_object *drm_gem_prime_import_dev(struct drm_device *dev,
 	if (!dev->driver->gem_prime_import_sg_table)
 		return ERR_PTR(-EINVAL);
 
-	attach = dma_buf_attach(dma_buf, attach_dev);
+	attach = dma_buf_attach(&attach_info);
 	if (IS_ERR(attach))
 		return ERR_CAST(attach);
 
diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index 69a7aec49e84..7b737a883106 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -288,6 +288,10 @@ static const struct drm_i915_gem_object_ops i915_gem_object_dmabuf_ops = {
 struct drm_gem_object *i915_gem_prime_import(struct drm_device *dev,
 					     struct dma_buf *dma_buf)
 {
+	struct dma_buf_attach_info attach_info = {
+		.dev = dev->dev,
+		.dmabuf = dma_buf
+	};
 	struct dma_buf_attachment *attach;
 	struct drm_i915_gem_object *obj;
 	int ret;
@@ -306,7 +310,7 @@ struct drm_gem_object *i915_gem_prime_import(struct drm_device *dev,
 	}
 
 	/* need to attach */
-	attach = dma_buf_attach(dma_buf, dev->dev);
+	attach = dma_buf_attach(&attach_info);
 	if (IS_ERR(attach))
 		return ERR_CAST(attach);
 
diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index 8b0b4ff64bb4..1f2bee91e0ad 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -332,6 +332,10 @@ struct tegra_bo *tegra_bo_create_with_handle(struct drm_file *file,
 static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
 					struct dma_buf *buf)
 {
+	struct dma_buf_attach_info attach_info = {
+		.dev = drm->dev,
+		.dmabuf = buf
+	};
 	struct tegra_drm *tegra = drm->dev_private;
 	struct dma_buf_attachment *attach;
 	struct tegra_bo *bo;
@@ -341,7 +345,7 @@ static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
 	if (IS_ERR(bo))
 		return bo;
 
-	attach = dma_buf_attach(buf, drm->dev);
+	attach = dma_buf_attach(&attach_info);
 	if (IS_ERR(attach)) {
 		err = PTR_ERR(attach);
 		goto free;
diff --git a/drivers/gpu/drm/udl/udl_dmabuf.c b/drivers/gpu/drm/udl/udl_dmabuf.c
index 2867ed155ff6..c4db84abe231 100644
--- a/drivers/gpu/drm/udl/udl_dmabuf.c
+++ b/drivers/gpu/drm/udl/udl_dmabuf.c
@@ -243,6 +243,10 @@ static int udl_prime_create(struct drm_device *dev,
 struct drm_gem_object *udl_gem_prime_import(struct drm_device *dev,
 				struct dma_buf *dma_buf)
 {
+	struct dma_buf_attach_info attach_info = {
+		.dev = dev->dev,
+		.dmabuf = dma_buf
+	};
 	struct dma_buf_attachment *attach;
 	struct sg_table *sg;
 	struct udl_gem_object *uobj;
@@ -250,7 +254,7 @@ struct drm_gem_object *udl_gem_prime_import(struct drm_device *dev,
 
 	/* need to attach */
 	get_device(dev->dev);
-	attach = dma_buf_attach(dma_buf, dev->dev);
+	attach = dma_buf_attach(&attach_info);
 	if (IS_ERR(attach)) {
 		put_device(dev->dev);
 		return ERR_CAST(attach);
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index f1178f6f434d..93bd1f40f756 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -677,6 +677,10 @@ static void vb2_dc_detach_dmabuf(void *mem_priv)
 static void *vb2_dc_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 	unsigned long size, enum dma_data_direction dma_dir)
 {
+	struct dma_buf_attach_info attach_info = {
+		.dev = dev,
+		.dmabuf = dbuf
+	};
 	struct vb2_dc_buf *buf;
 	struct dma_buf_attachment *dba;
 
@@ -692,7 +696,7 @@ static void *vb2_dc_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 
 	buf->dev = dev;
 	/* create attachment for the dmabuf with the user device */
-	dba = dma_buf_attach(dbuf, buf->dev);
+	dba = dma_buf_attach(&attach_info);
 	if (IS_ERR(dba)) {
 		pr_err("failed to attach dmabuf\n");
 		kfree(buf);
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index 753ed3138dcc..4e61050ba87f 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -609,6 +609,10 @@ static void vb2_dma_sg_detach_dmabuf(void *mem_priv)
 static void *vb2_dma_sg_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 	unsigned long size, enum dma_data_direction dma_dir)
 {
+	struct dma_buf_attach_info attach_info = {
+		.dev = dev,
+		.dmabuf = dbuf
+	};
 	struct vb2_dma_sg_buf *buf;
 	struct dma_buf_attachment *dba;
 
@@ -624,7 +628,7 @@ static void *vb2_dma_sg_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 
 	buf->dev = dev;
 	/* create attachment for the dmabuf with the user device */
-	dba = dma_buf_attach(dbuf, buf->dev);
+	dba = dma_buf_attach(&attach_info);
 	if (IS_ERR(dba)) {
 		pr_err("failed to attach dmabuf\n");
 		kfree(buf);
diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index c47659e96089..25d112443b0d 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -529,6 +529,10 @@ static int tegra_vde_attach_dmabuf(struct device *dev,
 				   size_t *size,
 				   enum dma_data_direction dma_dir)
 {
+	struct dma_buf_attach_info attach_info = {
+		.dev = dev,
+		.dmabuf = dmabuf
+	};
 	struct dma_buf_attachment *attachment;
 	struct dma_buf *dmabuf;
 	struct sg_table *sgt;
@@ -547,7 +551,7 @@ static int tegra_vde_attach_dmabuf(struct device *dev,
 		return -EINVAL;
 	}
 
-	attachment = dma_buf_attach(dmabuf, dev);
+	attachment = dma_buf_attach(&attach_info);
 	if (IS_ERR(attachment)) {
 		dev_err(dev, "Failed to attach dmabuf\n");
 		err = PTR_ERR(attachment);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 085db2fee2d7..414b4dde5eb7 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -362,6 +362,19 @@ struct dma_buf_export_info {
 	struct dma_buf_export_info name = { .exp_name = KBUILD_MODNAME, \
 					 .owner = THIS_MODULE }
 
+/**
+ * struct dma_buf_attach_info - holds information needed to attach to a dma_buf
+ * @dmabuf:	the exported dma_buf
+ * @dev:	the device which wants to import the attachment
+ *
+ * This structure holds the information required to attach to a buffer. Used
+ * with dma_buf_attach() only.
+ */
+struct dma_buf_attach_info {
+	struct dma_buf *dmabuf;
+	struct device *dev;
+};
+
 /**
  * get_dma_buf - convenience wrapper for get_file.
  * @dmabuf:	[in]	pointer to dma_buf
@@ -376,8 +389,8 @@ static inline void get_dma_buf(struct dma_buf *dmabuf)
 	get_file(dmabuf->file);
 }
 
-struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
-							struct device *dev);
+struct dma_buf_attachment *
+dma_buf_attach(const struct dma_buf_attach_info *info);
 void dma_buf_detach(struct dma_buf *dmabuf,
 				struct dma_buf_attachment *dmabuf_attach);
 
-- 
2.14.1
