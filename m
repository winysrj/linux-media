Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:56974 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752048AbdCMN2v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 09:28:51 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: elena.reshetova@intel.com
Subject: [PATCH 2/2] vb2: convert vb2_vmarea_handler refcount from atomic_t to refcount_t
Date: Mon, 13 Mar 2017 15:24:56 +0200
Message-Id: <1489411496-31240-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1489411496-31240-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1489411496-31240-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Elena Reshetova <elena.reshetova@intel.com>

Use refcount_t to manage the refcount to the memory type specific buffer
videobuf2 buffer implementations. refcount_t is better suitable for the
purpose than atomic_t.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 11 ++++++-----
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 11 ++++++-----
 drivers/media/v4l2-core/videobuf2-memops.c     |  6 +++---
 drivers/media/v4l2-core/videobuf2-vmalloc.c    | 11 ++++++-----
 include/media/videobuf2-memops.h               |  3 ++-
 5 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index fb6a177..d29a07f 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -12,6 +12,7 @@
 
 #include <linux/dma-buf.h>
 #include <linux/module.h>
+#include <linux/refcount.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -34,7 +35,7 @@ struct vb2_dc_buf {
 
 	/* MMAP related */
 	struct vb2_vmarea_handler	handler;
-	atomic_t			refcount;
+	refcount_t			refcount;
 	struct sg_table			*sgt_base;
 
 	/* DMABUF related */
@@ -86,7 +87,7 @@ static unsigned int vb2_dc_num_users(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
-	return atomic_read(&buf->refcount);
+	return refcount_read(&buf->refcount);
 }
 
 static void vb2_dc_prepare(void *buf_priv)
@@ -122,7 +123,7 @@ static void vb2_dc_put(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 
-	if (!atomic_dec_and_test(&buf->refcount))
+	if (!refcount_dec_and_test(&buf->refcount))
 		return;
 
 	if (buf->sgt_base) {
@@ -170,7 +171,7 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
 	buf->handler.put = vb2_dc_put;
 	buf->handler.arg = buf;
 
-	atomic_inc(&buf->refcount);
+	refcount_set(&buf->refcount, 1);
 
 	return buf;
 }
@@ -407,7 +408,7 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
 		return NULL;
 
 	/* dmabuf keeps reference to vb2 buffer */
-	atomic_inc(&buf->refcount);
+	refcount_inc(&buf->refcount);
 
 	return dbuf;
 }
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index ecff8f4..29fde1a 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/refcount.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -46,7 +47,7 @@ struct vb2_dma_sg_buf {
 	struct sg_table			*dma_sgt;
 	size_t				size;
 	unsigned int			num_pages;
-	atomic_t			refcount;
+	refcount_t			refcount;
 	struct vb2_vmarea_handler	handler;
 
 	struct dma_buf_attachment	*db_attach;
@@ -150,7 +151,7 @@ static void *vb2_dma_sg_alloc(struct device *dev, unsigned long dma_attrs,
 	buf->handler.put = vb2_dma_sg_put;
 	buf->handler.arg = buf;
 
-	atomic_inc(&buf->refcount);
+	refcount_set(&buf->refcount, 1);
 
 	dprintk(1, "%s: Allocated buffer of %d pages\n",
 		__func__, buf->num_pages);
@@ -176,7 +177,7 @@ static void vb2_dma_sg_put(void *buf_priv)
 	struct sg_table *sgt = &buf->sg_table;
 	int i = buf->num_pages;
 
-	if (atomic_dec_and_test(&buf->refcount)) {
+	if (refcount_dec_and_test(&buf->refcount)) {
 		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
 			buf->num_pages);
 		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
@@ -320,7 +321,7 @@ static unsigned int vb2_dma_sg_num_users(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
 
-	return atomic_read(&buf->refcount);
+	return refcount_read(&buf->refcount);
 }
 
 static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
@@ -530,7 +531,7 @@ static struct dma_buf *vb2_dma_sg_get_dmabuf(void *buf_priv, unsigned long flags
 		return NULL;
 
 	/* dmabuf keeps reference to vb2 buffer */
-	atomic_inc(&buf->refcount);
+	refcount_inc(&buf->refcount);
 
 	return dbuf;
 }
diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
index 1cd322e..4bb8424 100644
--- a/drivers/media/v4l2-core/videobuf2-memops.c
+++ b/drivers/media/v4l2-core/videobuf2-memops.c
@@ -96,10 +96,10 @@ static void vb2_common_vm_open(struct vm_area_struct *vma)
 	struct vb2_vmarea_handler *h = vma->vm_private_data;
 
 	pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
-	       __func__, h, atomic_read(h->refcount), vma->vm_start,
+	       __func__, h, refcount_read(h->refcount), vma->vm_start,
 	       vma->vm_end);
 
-	atomic_inc(h->refcount);
+	refcount_inc(h->refcount);
 }
 
 /**
@@ -114,7 +114,7 @@ static void vb2_common_vm_close(struct vm_area_struct *vma)
 	struct vb2_vmarea_handler *h = vma->vm_private_data;
 
 	pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
-	       __func__, h, atomic_read(h->refcount), vma->vm_start,
+	       __func__, h, refcount_read(h->refcount), vma->vm_start,
 	       vma->vm_end);
 
 	h->put(h->arg);
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 3f77814..f83253a 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/refcount.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -26,7 +27,7 @@ struct vb2_vmalloc_buf {
 	struct frame_vector		*vec;
 	enum dma_data_direction		dma_dir;
 	unsigned long			size;
-	atomic_t			refcount;
+	refcount_t			refcount;
 	struct vb2_vmarea_handler	handler;
 	struct dma_buf			*dbuf;
 };
@@ -56,7 +57,7 @@ static void *vb2_vmalloc_alloc(struct device *dev, unsigned long attrs,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	atomic_inc(&buf->refcount);
+	refcount_set(&buf->refcount, 1);
 	return buf;
 }
 
@@ -64,7 +65,7 @@ static void vb2_vmalloc_put(void *buf_priv)
 {
 	struct vb2_vmalloc_buf *buf = buf_priv;
 
-	if (atomic_dec_and_test(&buf->refcount)) {
+	if (refcount_dec_and_test(&buf->refcount)) {
 		vfree(buf->vaddr);
 		kfree(buf);
 	}
@@ -161,7 +162,7 @@ static void *vb2_vmalloc_vaddr(void *buf_priv)
 static unsigned int vb2_vmalloc_num_users(void *buf_priv)
 {
 	struct vb2_vmalloc_buf *buf = buf_priv;
-	return atomic_read(&buf->refcount);
+	return refcount_read(&buf->refcount);
 }
 
 static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
@@ -368,7 +369,7 @@ static struct dma_buf *vb2_vmalloc_get_dmabuf(void *buf_priv, unsigned long flag
 		return NULL;
 
 	/* dmabuf keeps reference to vb2 buffer */
-	atomic_inc(&buf->refcount);
+	refcount_inc(&buf->refcount);
 
 	return dbuf;
 }
diff --git a/include/media/videobuf2-memops.h b/include/media/videobuf2-memops.h
index 36565c7a..a6ed091 100644
--- a/include/media/videobuf2-memops.h
+++ b/include/media/videobuf2-memops.h
@@ -16,6 +16,7 @@
 
 #include <media/videobuf2-v4l2.h>
 #include <linux/mm.h>
+#include <linux/refcount.h>
 
 /**
  * struct vb2_vmarea_handler - common vma refcount tracking handler
@@ -25,7 +26,7 @@
  * @arg:	argument for @put callback
  */
 struct vb2_vmarea_handler {
-	atomic_t		*refcount;
+	refcount_t		*refcount;
 	void			(*put)(void *arg);
 	void			*arg;
 };
-- 
2.7.4
