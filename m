Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33779 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbeFALlw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 07:41:52 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH v2 7/9] xen/gntdev: Implement dma-buf export functionality
Date: Fri,  1 Jun 2018 14:41:30 +0300
Message-Id: <20180601114132.22596-8-andr2000@gmail.com>
In-Reply-To: <20180601114132.22596-1-andr2000@gmail.com>
References: <20180601114132.22596-1-andr2000@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

1. Create a dma-buf from grant references provided by the foreign
   domain. By default dma-buf is backed by system memory pages, but
   by providing GNTDEV_DMA_FLAG_XXX flags it can also be created
   as a DMA write-combine/coherent buffer, e.g. allocated with
   corresponding dma_alloc_xxx API.
   Export the resulting buffer as a new dma-buf.

2. Implement waiting for the dma-buf to be released: block until the
   dma-buf with the file descriptor provided is released.
   If within the time-out provided the buffer is not released then
   -ETIMEDOUT error is returned. If the buffer with the file descriptor
   does not exist or has already been released, then -ENOENT is
   returned. For valid file descriptors this must not be treated as
   error.

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
---
 drivers/xen/gntdev-dmabuf.c | 393 +++++++++++++++++++++++++++++++++++-
 drivers/xen/gntdev-dmabuf.h |   9 +-
 drivers/xen/gntdev.c        |  90 ++++++++-
 3 files changed, 486 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 6bedd1387bd9..f612468879b4 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -3,15 +3,58 @@
 /*
  * Xen dma-buf functionality for gntdev.
  *
+ * DMA buffer implementation is based on drivers/gpu/drm/drm_prime.c.
+ *
  * Copyright (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
  */
 
+#include <linux/dma-buf.h>
 #include <linux/slab.h>
 
 #include "gntdev-dmabuf.h"
 
+struct gntdev_dmabuf {
+	struct gntdev_dmabuf_priv *priv;
+	struct dma_buf *dmabuf;
+	struct list_head next;
+	int fd;
+
+	union {
+		struct {
+			/* Exported buffers are reference counted. */
+			struct kref refcount;
+
+			struct gntdev_priv *priv;
+			struct grant_map *map;
+			void (*release)(struct gntdev_priv *priv,
+					struct grant_map *map);
+		} exp;
+	} u;
+
+	/* Number of pages this buffer has. */
+	int nr_pages;
+	/* Pages of this buffer. */
+	struct page **pages;
+};
+
+struct gntdev_dmabuf_wait_obj {
+	struct list_head next;
+	struct gntdev_dmabuf *gntdev_dmabuf;
+	struct completion completion;
+};
+
+struct gntdev_dmabuf_attachment {
+	struct sg_table *sgt;
+	enum dma_data_direction dir;
+};
+
 struct gntdev_dmabuf_priv {
-	int dummy;
+	/* List of exported DMA buffers. */
+	struct list_head exp_list;
+	/* List of wait objects. */
+	struct list_head exp_wait_list;
+	/* This is the lock which protects dma_buf_xxx lists. */
+	struct mutex lock;
 };
 
 /* ------------------------------------------------------------------ */
@@ -22,19 +65,359 @@ struct gntdev_dmabuf_priv {
 /* Implementation of wait for exported DMA buffer to be released.     */
 /* ------------------------------------------------------------------ */
 
+static void dmabuf_exp_release(struct kref *kref);
+
+static struct gntdev_dmabuf_wait_obj *
+dmabuf_exp_wait_obj_new(struct gntdev_dmabuf_priv *priv,
+			struct gntdev_dmabuf *gntdev_dmabuf)
+{
+	struct gntdev_dmabuf_wait_obj *obj;
+
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return ERR_PTR(-ENOMEM);
+
+	init_completion(&obj->completion);
+	obj->gntdev_dmabuf = gntdev_dmabuf;
+
+	mutex_lock(&priv->lock);
+	list_add(&obj->next, &priv->exp_wait_list);
+	/* Put our reference and wait for gntdev_dmabuf's release to fire. */
+	kref_put(&gntdev_dmabuf->u.exp.refcount, dmabuf_exp_release);
+	mutex_unlock(&priv->lock);
+	return obj;
+}
+
+static void dmabuf_exp_wait_obj_free(struct gntdev_dmabuf_priv *priv,
+				     struct gntdev_dmabuf_wait_obj *obj)
+{
+	struct gntdev_dmabuf_wait_obj *cur_obj, *q;
+
+	mutex_lock(&priv->lock);
+	list_for_each_entry_safe(cur_obj, q, &priv->exp_wait_list, next)
+		if (cur_obj == obj) {
+			list_del(&obj->next);
+			kfree(obj);
+			break;
+		}
+	mutex_unlock(&priv->lock);
+}
+
+static int dmabuf_exp_wait_obj_wait(struct gntdev_dmabuf_wait_obj *obj,
+				    u32 wait_to_ms)
+{
+	if (wait_for_completion_timeout(&obj->completion,
+			msecs_to_jiffies(wait_to_ms)) <= 0)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static void dmabuf_exp_wait_obj_signal(struct gntdev_dmabuf_priv *priv,
+				       struct gntdev_dmabuf *gntdev_dmabuf)
+{
+	struct gntdev_dmabuf_wait_obj *obj, *q;
+
+	list_for_each_entry_safe(obj, q, &priv->exp_wait_list, next)
+		if (obj->gntdev_dmabuf == gntdev_dmabuf) {
+			pr_debug("Found gntdev_dmabuf in the wait list, wake\n");
+			complete_all(&obj->completion);
+		}
+}
+
+static struct gntdev_dmabuf *
+dmabuf_exp_wait_obj_get_by_fd(struct gntdev_dmabuf_priv *priv, int fd)
+{
+	struct gntdev_dmabuf *q, *gntdev_dmabuf, *ret = ERR_PTR(-ENOENT);
+
+	mutex_lock(&priv->lock);
+	list_for_each_entry_safe(gntdev_dmabuf, q, &priv->exp_list, next)
+		if (gntdev_dmabuf->fd == fd) {
+			pr_debug("Found gntdev_dmabuf in the wait list\n");
+			kref_get(&gntdev_dmabuf->u.exp.refcount);
+			ret = gntdev_dmabuf;
+			break;
+		}
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
 int gntdev_dmabuf_exp_wait_released(struct gntdev_dmabuf_priv *priv, int fd,
 				    int wait_to_ms)
 {
-	return -EINVAL;
+	struct gntdev_dmabuf *gntdev_dmabuf;
+	struct gntdev_dmabuf_wait_obj *obj;
+	int ret;
+
+	pr_debug("Will wait for dma-buf with fd %d\n", fd);
+	/*
+	 * Try to find the DMA buffer: if not found means that
+	 * either the buffer has already been released or file descriptor
+	 * provided is wrong.
+	 */
+	gntdev_dmabuf = dmabuf_exp_wait_obj_get_by_fd(priv, fd);
+	if (IS_ERR(gntdev_dmabuf))
+		return PTR_ERR(gntdev_dmabuf);
+
+	/*
+	 * gntdev_dmabuf still exists and is reference count locked by us now,
+	 * so prepare to wait: allocate wait object and add it to the wait list,
+	 * so we can find it on release.
+	 */
+	obj = dmabuf_exp_wait_obj_new(priv, gntdev_dmabuf);
+	if (IS_ERR(obj)) {
+		pr_err("Failed to setup wait object, ret %ld\n", PTR_ERR(obj));
+		return PTR_ERR(obj);
+}
+
+	ret = dmabuf_exp_wait_obj_wait(obj, wait_to_ms);
+	dmabuf_exp_wait_obj_free(priv, obj);
+	return ret;
 }
 
 /* ------------------------------------------------------------------ */
 /* DMA buffer export support.                                         */
 /* ------------------------------------------------------------------ */
 
+static struct sg_table *
+dmabuf_pages_to_sgt(struct page **pages, unsigned int nr_pages)
+{
+	struct sg_table *sgt;
+	int ret;
+
+	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
+	if (!sgt) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = sg_alloc_table_from_pages(sgt, pages, nr_pages, 0,
+					nr_pages << PAGE_SHIFT,
+					GFP_KERNEL);
+	if (ret)
+		goto out;
+
+	return sgt;
+
+out:
+	kfree(sgt);
+	return ERR_PTR(ret);
+}
+
+static int dmabuf_exp_ops_attach(struct dma_buf *dma_buf,
+				 struct device *target_dev,
+				 struct dma_buf_attachment *attach)
+{
+	struct gntdev_dmabuf_attachment *gntdev_dmabuf_attach;
+
+	gntdev_dmabuf_attach = kzalloc(sizeof(*gntdev_dmabuf_attach),
+				       GFP_KERNEL);
+	if (!gntdev_dmabuf_attach)
+		return -ENOMEM;
+
+	gntdev_dmabuf_attach->dir = DMA_NONE;
+	attach->priv = gntdev_dmabuf_attach;
+	/* Might need to pin the pages of the buffer now. */
+	return 0;
+}
+
+static void dmabuf_exp_ops_detach(struct dma_buf *dma_buf,
+				  struct dma_buf_attachment *attach)
+{
+	struct gntdev_dmabuf_attachment *gntdev_dmabuf_attach = attach->priv;
+
+	if (gntdev_dmabuf_attach) {
+		struct sg_table *sgt = gntdev_dmabuf_attach->sgt;
+
+		if (sgt) {
+			if (gntdev_dmabuf_attach->dir != DMA_NONE)
+				dma_unmap_sg_attrs(attach->dev, sgt->sgl,
+						   sgt->nents,
+						   gntdev_dmabuf_attach->dir,
+						   DMA_ATTR_SKIP_CPU_SYNC);
+			sg_free_table(sgt);
+		}
+
+		kfree(sgt);
+		kfree(gntdev_dmabuf_attach);
+		attach->priv = NULL;
+	}
+	/* Might need to unpin the pages of the buffer now. */
+}
+
+static struct sg_table *
+dmabuf_exp_ops_map_dma_buf(struct dma_buf_attachment *attach,
+			   enum dma_data_direction dir)
+{
+	struct gntdev_dmabuf_attachment *gntdev_dmabuf_attach = attach->priv;
+	struct gntdev_dmabuf *gntdev_dmabuf = attach->dmabuf->priv;
+	struct sg_table *sgt;
+
+	pr_debug("Mapping %d pages for dev %p\n", gntdev_dmabuf->nr_pages,
+		 attach->dev);
+
+	if (WARN_ON(dir == DMA_NONE || !gntdev_dmabuf_attach))
+		return ERR_PTR(-EINVAL);
+
+	/* Return the cached mapping when possible. */
+	if (gntdev_dmabuf_attach->dir == dir)
+		return gntdev_dmabuf_attach->sgt;
+
+	/*
+	 * Two mappings with different directions for the same attachment are
+	 * not allowed.
+	 */
+	if (WARN_ON(gntdev_dmabuf_attach->dir != DMA_NONE))
+		return ERR_PTR(-EBUSY);
+
+	sgt = dmabuf_pages_to_sgt(gntdev_dmabuf->pages,
+				  gntdev_dmabuf->nr_pages);
+	if (!IS_ERR(sgt)) {
+		if (!dma_map_sg_attrs(attach->dev, sgt->sgl, sgt->nents, dir,
+				      DMA_ATTR_SKIP_CPU_SYNC)) {
+			sg_free_table(sgt);
+			kfree(sgt);
+			sgt = ERR_PTR(-ENOMEM);
+		} else {
+			gntdev_dmabuf_attach->sgt = sgt;
+			gntdev_dmabuf_attach->dir = dir;
+		}
+	}
+	if (IS_ERR(sgt))
+		pr_err("Failed to map sg table for dev %p\n", attach->dev);
+	return sgt;
+}
+
+static void dmabuf_exp_ops_unmap_dma_buf(struct dma_buf_attachment *attach,
+					 struct sg_table *sgt,
+					 enum dma_data_direction dir)
+{
+	/* Not implemented. The unmap is done at dmabuf_exp_ops_detach(). */
+}
+
+static void dmabuf_exp_release(struct kref *kref)
+{
+	struct gntdev_dmabuf *gntdev_dmabuf =
+		container_of(kref, struct gntdev_dmabuf, u.exp.refcount);
+
+	dmabuf_exp_wait_obj_signal(gntdev_dmabuf->priv, gntdev_dmabuf);
+	list_del(&gntdev_dmabuf->next);
+	kfree(gntdev_dmabuf);
+}
+
+static void dmabuf_exp_ops_release(struct dma_buf *dma_buf)
+{
+	struct gntdev_dmabuf *gntdev_dmabuf = dma_buf->priv;
+	struct gntdev_dmabuf_priv *priv = gntdev_dmabuf->priv;
+
+	gntdev_dmabuf->u.exp.release(gntdev_dmabuf->u.exp.priv,
+				     gntdev_dmabuf->u.exp.map);
+	mutex_lock(&priv->lock);
+	kref_put(&gntdev_dmabuf->u.exp.refcount, dmabuf_exp_release);
+	mutex_unlock(&priv->lock);
+}
+
+static void *dmabuf_exp_ops_kmap_atomic(struct dma_buf *dma_buf,
+					unsigned long page_num)
+{
+	/* Not implemented. */
+	return NULL;
+}
+
+static void dmabuf_exp_ops_kunmap_atomic(struct dma_buf *dma_buf,
+					 unsigned long page_num, void *addr)
+{
+	/* Not implemented. */
+}
+
+static void *dmabuf_exp_ops_kmap(struct dma_buf *dma_buf,
+				 unsigned long page_num)
+{
+	/* Not implemented. */
+	return NULL;
+}
+
+static void dmabuf_exp_ops_kunmap(struct dma_buf *dma_buf,
+				  unsigned long page_num, void *addr)
+{
+	/* Not implemented. */
+}
+
+static int dmabuf_exp_ops_mmap(struct dma_buf *dma_buf,
+			       struct vm_area_struct *vma)
+{
+	/* Not implemented. */
+	return 0;
+}
+
+static const struct dma_buf_ops dmabuf_exp_ops =  {
+	.attach = dmabuf_exp_ops_attach,
+	.detach = dmabuf_exp_ops_detach,
+	.map_dma_buf = dmabuf_exp_ops_map_dma_buf,
+	.unmap_dma_buf = dmabuf_exp_ops_unmap_dma_buf,
+	.release = dmabuf_exp_ops_release,
+	.map = dmabuf_exp_ops_kmap,
+	.map_atomic = dmabuf_exp_ops_kmap_atomic,
+	.unmap = dmabuf_exp_ops_kunmap,
+	.unmap_atomic = dmabuf_exp_ops_kunmap_atomic,
+	.mmap = dmabuf_exp_ops_mmap,
+};
+
 int gntdev_dmabuf_exp_from_pages(struct gntdev_dmabuf_export_args *args)
 {
-	return -EINVAL;
+	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
+	struct gntdev_dmabuf *gntdev_dmabuf;
+	int ret = 0;
+
+	gntdev_dmabuf = kzalloc(sizeof(*gntdev_dmabuf), GFP_KERNEL);
+	if (!gntdev_dmabuf)
+		return -ENOMEM;
+
+	kref_init(&gntdev_dmabuf->u.exp.refcount);
+
+	gntdev_dmabuf->priv = args->dmabuf_priv;
+	gntdev_dmabuf->nr_pages = args->count;
+	gntdev_dmabuf->pages = args->pages;
+	gntdev_dmabuf->u.exp.priv = args->priv;
+	gntdev_dmabuf->u.exp.map = args->map;
+	gntdev_dmabuf->u.exp.release = args->release;
+
+	exp_info.exp_name = KBUILD_MODNAME;
+	if (args->dev->driver && args->dev->driver->owner)
+		exp_info.owner = args->dev->driver->owner;
+	else
+		exp_info.owner = THIS_MODULE;
+	exp_info.ops = &dmabuf_exp_ops;
+	exp_info.size = args->count << PAGE_SHIFT;
+	exp_info.flags = O_RDWR;
+	exp_info.priv = gntdev_dmabuf;
+
+	gntdev_dmabuf->dmabuf = dma_buf_export(&exp_info);
+	if (IS_ERR(gntdev_dmabuf->dmabuf)) {
+		ret = PTR_ERR(gntdev_dmabuf->dmabuf);
+		gntdev_dmabuf->dmabuf = NULL;
+		goto fail;
+	}
+
+	ret = dma_buf_fd(gntdev_dmabuf->dmabuf, O_CLOEXEC);
+	if (ret < 0)
+		goto fail;
+
+	gntdev_dmabuf->fd = ret;
+	args->fd = ret;
+
+	pr_debug("Exporting DMA buffer with fd %d\n", ret);
+
+	mutex_lock(&args->dmabuf_priv->lock);
+	list_add(&gntdev_dmabuf->next, &args->dmabuf_priv->exp_list);
+	mutex_unlock(&args->dmabuf_priv->lock);
+	return 0;
+
+fail:
+	if (gntdev_dmabuf->dmabuf)
+		dma_buf_put(gntdev_dmabuf->dmabuf);
+	kfree(gntdev_dmabuf);
+	return ret;
 }
 
 /* ------------------------------------------------------------------ */
@@ -66,6 +449,10 @@ struct gntdev_dmabuf_priv *gntdev_dmabuf_init(void)
 	if (!priv)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&priv->lock);
+	INIT_LIST_HEAD(&priv->exp_list);
+	INIT_LIST_HEAD(&priv->exp_wait_list);
+
 	return priv;
 }
 
diff --git a/drivers/xen/gntdev-dmabuf.h b/drivers/xen/gntdev-dmabuf.h
index 040b2de904ac..95c23a24f640 100644
--- a/drivers/xen/gntdev-dmabuf.h
+++ b/drivers/xen/gntdev-dmabuf.h
@@ -18,7 +18,14 @@ struct gntdev_dmabuf;
 struct device;
 
 struct gntdev_dmabuf_export_args {
-	int dummy;
+	struct gntdev_priv *priv;
+	struct grant_map *map;
+	void (*release)(struct gntdev_priv *priv, struct grant_map *map);
+	struct gntdev_dmabuf_priv *dmabuf_priv;
+	struct device *dev;
+	int count;
+	struct page **pages;
+	u32 fd;
 };
 
 struct gntdev_dmabuf_priv *gntdev_dmabuf_init(void);
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 7d58dfb3e5e8..cf255d45f20f 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -319,6 +319,16 @@ static void gntdev_put_map(struct gntdev_priv *priv, struct grant_map *map)
 	gntdev_free_map(map);
 }
 
+#ifdef CONFIG_XEN_GNTDEV_DMABUF
+static void gntdev_remove_map(struct gntdev_priv *priv, struct grant_map *map)
+{
+	mutex_lock(&priv->lock);
+	list_del(&map->next);
+	gntdev_put_map(NULL /* already removed */, map);
+	mutex_unlock(&priv->lock);
+}
+#endif
+
 /* ------------------------------------------------------------------ */
 
 static int find_grant_ptes(pte_t *pte, pgtable_t token,
@@ -1063,12 +1073,88 @@ static long gntdev_ioctl_grant_copy(struct gntdev_priv *priv, void __user *u)
 /* DMA buffer export support.                                         */
 /* ------------------------------------------------------------------ */
 
+static struct grant_map *
+dmabuf_exp_alloc_backing_storage(struct gntdev_priv *priv, int dmabuf_flags,
+				 int count)
+{
+	struct grant_map *map;
+
+	if (unlikely(count <= 0))
+		return ERR_PTR(-EINVAL);
+
+	if ((dmabuf_flags & GNTDEV_DMA_FLAG_WC) &&
+	    (dmabuf_flags & GNTDEV_DMA_FLAG_COHERENT)) {
+		pr_err("Wrong dma-buf flags: either WC or coherent, not both\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	map = gntdev_alloc_map(priv, count, dmabuf_flags);
+	if (!map)
+		return ERR_PTR(-ENOMEM);
+
+	if (unlikely(atomic_add_return(count, &pages_mapped) > limit)) {
+		pr_err("can't map: over limit\n");
+		gntdev_put_map(NULL, map);
+		return ERR_PTR(-ENOMEM);
+	}
+	return map;
+}
+
 int gntdev_dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
 				int count, u32 domid, u32 *refs, u32 *fd)
 {
-	/* XXX: this will need to work with gntdev's map, so leave it here. */
+	struct grant_map *map;
+	struct gntdev_dmabuf_export_args args;
+	int i, ret;
+
 	*fd = -1;
-	return -EINVAL;
+
+	if (use_ptemod) {
+		pr_err("Cannot provide dma-buf: use_ptemode %d\n",
+		       use_ptemod);
+		return -EINVAL;
+	}
+
+	map = dmabuf_exp_alloc_backing_storage(priv, flags, count);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
+
+	for (i = 0; i < count; i++) {
+		map->grants[i].domid = domid;
+		map->grants[i].ref = refs[i];
+	}
+
+	mutex_lock(&priv->lock);
+	gntdev_add_map(priv, map);
+	mutex_unlock(&priv->lock);
+
+	map->flags |= GNTMAP_host_map;
+#if defined(CONFIG_X86)
+	map->flags |= GNTMAP_device_map;
+#endif
+
+	ret = map_grant_pages(map);
+	if (ret < 0)
+		goto out;
+
+	args.priv = priv;
+	args.map = map;
+	args.release = gntdev_remove_map;
+	args.dev = priv->dma_dev;
+	args.dmabuf_priv = priv->dmabuf_priv;
+	args.count = map->count;
+	args.pages = map->pages;
+
+	ret = gntdev_dmabuf_exp_from_pages(&args);
+	if (ret < 0)
+		goto out;
+
+	*fd = args.fd;
+	return 0;
+
+out:
+	gntdev_remove_map(priv, map);
+	return ret;
 }
 
 /* ------------------------------------------------------------------ */
-- 
2.17.0
