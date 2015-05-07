Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33139 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbEGHbQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 03:31:16 -0400
Received: by pdbnk13 with SMTP id nk13so33848075pdb.0
        for <linux-media@vger.kernel.org>; Thu, 07 May 2015 00:31:16 -0700 (PDT)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, rmk+kernel@arm.linux.org.uk,
	airlied@linux.ie, kgene@kernel.org, thierry.reding@gmail.com,
	pawel@osciak.com, m.szyprowski@samsung.com,
	mchehab@osg.samsung.com, gregkh@linuxfoundation.org
Cc: linaro-kernel@lists.linaro.org, robdclark@gmail.com,
	daniel@ffwll.ch, intel-gfx@lists.freedesktop.org,
	linux-tegra@vger.kernel.org, inki.dae@samsung.com,
	maarten.lankhorst@canonical.com,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH] dma-buf: add ref counting for module as exporter
Date: Thu,  7 May 2015 13:00:52 +0530
Message-Id: <1430983852-19267-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add reference counting on a kernel module that exports dma-buf and
implements its operations. This prevents the module from being unloaded
while DMABUF file is in use.

The original patch [1] was submitted by Tomasz, but he's since shifted
jobs and a ping didn't elicit any response.

  [tomasz: Original author]
Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Acked-by: Daniel Vetter <daniel@ffwll.ch>
  [sumits: updated & rebased as per review comments]
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>

[1]: https://lkml.org/lkml/2012/8/8/163
---
 drivers/dma-buf/dma-buf.c                      | 9 ++++++++-
 drivers/gpu/drm/armada/armada_gem.c            | 1 +
 drivers/gpu/drm/drm_prime.c                    | 1 +
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c     | 1 +
 drivers/gpu/drm/i915/i915_gem_dmabuf.c         | 1 +
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c      | 1 +
 drivers/gpu/drm/tegra/gem.c                    | 1 +
 drivers/gpu/drm/udl/udl_dmabuf.c               | 1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_prime.c          | 1 +
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 1 +
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 1 +
 drivers/media/v4l2-core/videobuf2-vmalloc.c    | 1 +
 drivers/staging/android/ion/ion.c              | 1 +
 include/linux/dma-buf.h                        | 2 ++
 14 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index c5a9138a6a8d..9583eac0238f 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -29,6 +29,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/export.h>
 #include <linux/debugfs.h>
+#include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/poll.h>
 #include <linux/reservation.h>
@@ -64,6 +65,7 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 	BUG_ON(dmabuf->cb_shared.active || dmabuf->cb_excl.active);
 
 	dmabuf->ops->release(dmabuf);
+	module_put(dmabuf->ops->owner);
 
 	mutex_lock(&db_list.lock);
 	list_del(&dmabuf->list_node);
@@ -302,9 +304,14 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (!try_module_get(exp_info->ops->owner))
+		return ERR_PTR(-ENOENT);
+
 	dmabuf = kzalloc(alloc_size, GFP_KERNEL);
-	if (dmabuf == NULL)
+	if (!dmabuf) {
+		module_put(exp_info->ops->owner);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	dmabuf->priv = exp_info->priv;
 	dmabuf->ops = exp_info->ops;
diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index 580e10acaa3a..d2c5fc1269b7 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -524,6 +524,7 @@ armada_gem_dmabuf_mmap(struct dma_buf *buf, struct vm_area_struct *vma)
 }
 
 static const struct dma_buf_ops armada_gem_prime_dmabuf_ops = {
+	.owner = THIS_MODULE,
 	.map_dma_buf	= armada_gem_prime_map_dma_buf,
 	.unmap_dma_buf	= armada_gem_prime_unmap_dma_buf,
 	.release	= drm_gem_dmabuf_release,
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 7fec191b45f7..ed4a6e35dd91 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -289,6 +289,7 @@ static int drm_gem_dmabuf_mmap(struct dma_buf *dma_buf,
 }
 
 static const struct dma_buf_ops drm_gem_prime_dmabuf_ops =  {
+	.owner = THIS_MODULE,
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
 	.map_dma_buf = drm_gem_map_dma_buf,
diff --git a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
index cd485c091b30..35fa029353e9 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
@@ -169,6 +169,7 @@ static int exynos_gem_dmabuf_mmap(struct dma_buf *dma_buf,
 }
 
 static struct dma_buf_ops exynos_dmabuf_ops = {
+	.owner			= THIS_MODULE,
 	.attach			= exynos_gem_attach_dma_buf,
 	.detach			= exynos_gem_detach_dma_buf,
 	.map_dma_buf		= exynos_gem_map_dma_buf,
diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index 7998da27c500..b9355d8d4862 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -213,6 +213,7 @@ static int i915_gem_begin_cpu_access(struct dma_buf *dma_buf, size_t start, size
 }
 
 static const struct dma_buf_ops i915_dmabuf_ops =  {
+	.owner = THIS_MODULE,
 	.map_dma_buf = i915_gem_map_dma_buf,
 	.unmap_dma_buf = i915_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
index 344fd789170d..977ece9be62c 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
@@ -156,6 +156,7 @@ static int omap_gem_dmabuf_mmap(struct dma_buf *buffer,
 }
 
 static struct dma_buf_ops omap_dmabuf_ops = {
+	.owner = THIS_MODULE,
 	.map_dma_buf = omap_gem_map_dma_buf,
 	.unmap_dma_buf = omap_gem_unmap_dma_buf,
 	.release = omap_gem_dmabuf_release,
diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index 1217272a51f2..7af37a445524 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -611,6 +611,7 @@ static void tegra_gem_prime_vunmap(struct dma_buf *buf, void *vaddr)
 }
 
 static const struct dma_buf_ops tegra_gem_prime_dmabuf_ops = {
+	.owner = THIS_MODULE,
 	.map_dma_buf = tegra_gem_prime_map_dma_buf,
 	.unmap_dma_buf = tegra_gem_prime_unmap_dma_buf,
 	.release = tegra_gem_prime_release,
diff --git a/drivers/gpu/drm/udl/udl_dmabuf.c b/drivers/gpu/drm/udl/udl_dmabuf.c
index e2243edd1ce3..b67bd66c4636 100644
--- a/drivers/gpu/drm/udl/udl_dmabuf.c
+++ b/drivers/gpu/drm/udl/udl_dmabuf.c
@@ -187,6 +187,7 @@ static int udl_dmabuf_mmap(struct dma_buf *dma_buf,
 }
 
 static struct dma_buf_ops udl_dmabuf_ops = {
+	.owner			= THIS_MODULE,
 	.attach			= udl_attach_dma_buf,
 	.detach			= udl_detach_dma_buf,
 	.map_dma_buf		= udl_map_dma_buf,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
index 31fe32d8d65a..81aa6eae9031 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
@@ -103,6 +103,7 @@ static int vmw_prime_dmabuf_mmap(struct dma_buf *dma_buf,
 }
 
 const struct dma_buf_ops vmw_prime_dmabuf_ops =  {
+	.owner = THIS_MODULE,
 	.attach = vmw_prime_map_attach,
 	.detach = vmw_prime_map_detach,
 	.map_dma_buf = vmw_prime_map_dma_buf,
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 644dec73d220..22cb21480fb8 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -365,6 +365,7 @@ static int vb2_dc_dmabuf_ops_mmap(struct dma_buf *dbuf,
 }
 
 static struct dma_buf_ops vb2_dc_dmabuf_ops = {
+	.owner = THIS_MODULE,
 	.attach = vb2_dc_dmabuf_ops_attach,
 	.detach = vb2_dc_dmabuf_ops_detach,
 	.map_dma_buf = vb2_dc_dmabuf_ops_map,
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 45c708e463b9..f659ee409148 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -568,6 +568,7 @@ static int vb2_dma_sg_dmabuf_ops_mmap(struct dma_buf *dbuf,
 }
 
 static struct dma_buf_ops vb2_dma_sg_dmabuf_ops = {
+	.owner = THIS_MODULE,
 	.attach = vb2_dma_sg_dmabuf_ops_attach,
 	.detach = vb2_dma_sg_dmabuf_ops_detach,
 	.map_dma_buf = vb2_dma_sg_dmabuf_ops_map,
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 657ab302a5cf..a76ce4d989c8 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -353,6 +353,7 @@ static int vb2_vmalloc_dmabuf_ops_mmap(struct dma_buf *dbuf,
 }
 
 static struct dma_buf_ops vb2_vmalloc_dmabuf_ops = {
+	.owner = THIS_MODULE,
 	.attach = vb2_vmalloc_dmabuf_ops_attach,
 	.detach = vb2_vmalloc_dmabuf_ops_detach,
 	.map_dma_buf = vb2_vmalloc_dmabuf_ops_map,
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index b0b96ab31954..5af1355c874c 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1088,6 +1088,7 @@ static void ion_dma_buf_end_cpu_access(struct dma_buf *dmabuf, size_t start,
 }
 
 static struct dma_buf_ops dma_buf_ops = {
+	.owner = THIS_MODULE,
 	.map_dma_buf = ion_map_dma_buf,
 	.unmap_dma_buf = ion_unmap_dma_buf,
 	.mmap = ion_mmap,
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 2f0b431b73e0..22d367080943 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -39,6 +39,7 @@ struct dma_buf_attachment;
 
 /**
  * struct dma_buf_ops - operations possible on struct dma_buf
+ * @owner: the module that implements dma_buf operations
  * @attach: [optional] allows different devices to 'attach' themselves to the
  *	    given buffer. It might return -EBUSY to signal that backing storage
  *	    is already allocated and incompatible with the requirements
@@ -72,6 +73,7 @@ struct dma_buf_attachment;
  * @vunmap: [optional] unmaps a vmap from the buffer
  */
 struct dma_buf_ops {
+	struct module *owner;
 	int (*attach)(struct dma_buf *, struct device *,
 			struct dma_buf_attachment *);
 
-- 
1.9.1

