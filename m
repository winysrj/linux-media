Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34307 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbcCRUCr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 16:02:47 -0400
Received: by mail-wm0-f42.google.com with SMTP id p65so83137215wmp.1
        for <linux-media@vger.kernel.org>; Fri, 18 Mar 2016 13:02:46 -0700 (PDT)
From: Chris Wilson <chris@chris-wilson.co.uk>
To: intel-gfx@lists.freedesktop.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
	Tiago Vignatti <tiago.vignatti@intel.com>,
	=?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
	David Herrmann <dh.herrmann@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, devel@driverdev.osuosl.org
Subject: [PATCH] dma-buf,drm,ion: Propagate error code from dma_buf_start_cpu_access()
Date: Fri, 18 Mar 2016 20:02:39 +0000
Message-Id: <1458331359-2634-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers, especially i915.ko, can fail during the initial migration of a
dma-buf for CPU access. However, the error code from the driver was not
being propagated back to ioctl and so userspace was blissfully ignorant
of the failure. Rendering corruption ensues.

Whilst fixing the ioctl to return the error code from
dma_buf_start_cpu_access(), also do the same for
dma_buf_end_cpu_access().  For most drivers, dma_buf_end_cpu_access()
cannot fail. i915.ko however, as most drivers would, wants to avoid being
uninterruptible (as would be required to guarrantee no failure when
flushing the buffer to the device). As userspace already has to handle
errors from the SYNC_IOCTL, take advantage of this to be able to restart
the syscall across signals.

This fixes a coherency issue for i915.ko as well as reducing the
uninterruptible hold upon its BKL, the struct_mutex.

Fixes commit c11e391da2a8fe973c3c2398452000bed505851e
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Feb 11 20:04:51 2016 -0200

    dma-buf: Add ioctls to allow userspace to flush

Testcase: igt/gem_concurrent_blit/*dmabuf*interruptible
Testcase: igt/prime_mmap_coherency/ioctl-errors
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tiago Vignatti <tiago.vignatti@intel.com>
Cc: Stéphane Marchesin <marcheu@chromium.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Daniel Vetter <daniel.vetter@intel.com>
CC: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: intel-gfx@lists.freedesktop.org
Cc: devel@driverdev.osuosl.org
---
 drivers/dma-buf/dma-buf.c                 | 17 +++++++++++------
 drivers/gpu/drm/i915/i915_gem_dmabuf.c    | 15 +++++----------
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c |  5 +++--
 drivers/gpu/drm/udl/udl_fb.c              |  4 ++--
 drivers/staging/android/ion/ion.c         |  6 ++++--
 include/linux/dma-buf.h                   |  6 +++---
 6 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 9810d1df0691..774a60f4309a 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -259,6 +259,7 @@ static long dma_buf_ioctl(struct file *file,
 	struct dma_buf *dmabuf;
 	struct dma_buf_sync sync;
 	enum dma_data_direction direction;
+	int ret;
 
 	dmabuf = file->private_data;
 
@@ -285,11 +286,11 @@ static long dma_buf_ioctl(struct file *file,
 		}
 
 		if (sync.flags & DMA_BUF_SYNC_END)
-			dma_buf_end_cpu_access(dmabuf, direction);
+			ret = dma_buf_end_cpu_access(dmabuf, direction);
 		else
-			dma_buf_begin_cpu_access(dmabuf, direction);
+			ret = dma_buf_begin_cpu_access(dmabuf, direction);
 
-		return 0;
+		return ret;
 	default:
 		return -ENOTTY;
 	}
@@ -613,13 +614,17 @@ EXPORT_SYMBOL_GPL(dma_buf_begin_cpu_access);
  *
  * This call must always succeed.
  */
-void dma_buf_end_cpu_access(struct dma_buf *dmabuf,
-			    enum dma_data_direction direction)
+int dma_buf_end_cpu_access(struct dma_buf *dmabuf,
+			   enum dma_data_direction direction)
 {
+	int ret = 0;
+
 	WARN_ON(!dmabuf);
 
 	if (dmabuf->ops->end_cpu_access)
-		dmabuf->ops->end_cpu_access(dmabuf, direction);
+		ret = dmabuf->ops->end_cpu_access(dmabuf, direction);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(dma_buf_end_cpu_access);
 
diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index 1f3eef6fb345..0506016e18e0 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -228,25 +228,20 @@ static int i915_gem_begin_cpu_access(struct dma_buf *dma_buf, enum dma_data_dire
 	return ret;
 }
 
-static void i915_gem_end_cpu_access(struct dma_buf *dma_buf, enum dma_data_direction direction)
+static int i915_gem_end_cpu_access(struct dma_buf *dma_buf, enum dma_data_direction direction)
 {
 	struct drm_i915_gem_object *obj = dma_buf_to_obj(dma_buf);
 	struct drm_device *dev = obj->base.dev;
-	struct drm_i915_private *dev_priv = to_i915(dev);
-	bool was_interruptible;
 	int ret;
 
-	mutex_lock(&dev->struct_mutex);
-	was_interruptible = dev_priv->mm.interruptible;
-	dev_priv->mm.interruptible = false;
+	ret = i915_mutex_lock_interruptible(dev);
+	if (ret)
+		return ret;
 
 	ret = i915_gem_object_set_to_gtt_domain(obj, false);
-
-	dev_priv->mm.interruptible = was_interruptible;
 	mutex_unlock(&dev->struct_mutex);
 
-	if (unlikely(ret))
-		DRM_ERROR("unable to flush buffer following CPU access; rendering may be corrupt\n");
+	return ret;
 }
 
 static const struct dma_buf_ops i915_dmabuf_ops =  {
diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
index 3cf8aab23a39..af267c35d813 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
@@ -97,11 +97,12 @@ static int omap_gem_dmabuf_begin_cpu_access(struct dma_buf *buffer,
 	return omap_gem_get_pages(obj, &pages, true);
 }
 
-static void omap_gem_dmabuf_end_cpu_access(struct dma_buf *buffer,
-		enum dma_data_direction dir)
+static int omap_gem_dmabuf_end_cpu_access(struct dma_buf *buffer,
+					  enum dma_data_direction dir)
 {
 	struct drm_gem_object *obj = buffer->priv;
 	omap_gem_put_pages(obj);
+	return 0;
 }
 
 
diff --git a/drivers/gpu/drm/udl/udl_fb.c b/drivers/gpu/drm/udl/udl_fb.c
index c427499133d6..33239a2b264a 100644
--- a/drivers/gpu/drm/udl/udl_fb.c
+++ b/drivers/gpu/drm/udl/udl_fb.c
@@ -423,8 +423,8 @@ static int udl_user_framebuffer_dirty(struct drm_framebuffer *fb,
 	}
 
 	if (ufb->obj->base.import_attach) {
-		dma_buf_end_cpu_access(ufb->obj->base.import_attach->dmabuf,
-				       DMA_FROM_DEVICE);
+		ret = dma_buf_end_cpu_access(ufb->obj->base.import_attach->dmabuf,
+					     DMA_FROM_DEVICE);
 	}
 
  unlock:
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 0754a37c9674..49436b4510f4 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1075,14 +1075,16 @@ static int ion_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
 	return PTR_ERR_OR_ZERO(vaddr);
 }
 
-static void ion_dma_buf_end_cpu_access(struct dma_buf *dmabuf,
-				       enum dma_data_direction direction)
+static int ion_dma_buf_end_cpu_access(struct dma_buf *dmabuf,
+				      enum dma_data_direction direction)
 {
 	struct ion_buffer *buffer = dmabuf->priv;
 
 	mutex_lock(&buffer->lock);
 	ion_buffer_kmap_put(buffer);
 	mutex_unlock(&buffer->lock);
+
+	return 0;
 }
 
 static struct dma_buf_ops dma_buf_ops = {
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 532108ea0c1c..3fe90d494edb 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -94,7 +94,7 @@ struct dma_buf_ops {
 	void (*release)(struct dma_buf *);
 
 	int (*begin_cpu_access)(struct dma_buf *, enum dma_data_direction);
-	void (*end_cpu_access)(struct dma_buf *, enum dma_data_direction);
+	int (*end_cpu_access)(struct dma_buf *, enum dma_data_direction);
 	void *(*kmap_atomic)(struct dma_buf *, unsigned long);
 	void (*kunmap_atomic)(struct dma_buf *, unsigned long, void *);
 	void *(*kmap)(struct dma_buf *, unsigned long);
@@ -224,8 +224,8 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
 				enum dma_data_direction);
 int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
 			     enum dma_data_direction dir);
-void dma_buf_end_cpu_access(struct dma_buf *dma_buf,
-			    enum dma_data_direction dir);
+int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
+			   enum dma_data_direction dir);
 void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long);
 void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long, void *);
 void *dma_buf_kmap(struct dma_buf *, unsigned long);
-- 
2.8.0.rc3

