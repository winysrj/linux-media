Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45616 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729848AbeGTJt3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jul 2018 05:49:29 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH v5 7/8] xen/gntdev: Implement dma-buf export functionality
Date: Fri, 20 Jul 2018 12:01:49 +0300
Message-Id: <20180720090150.24560-8-andr2000@gmail.com>
In-Reply-To: <20180720090150.24560-1-andr2000@gmail.com>
References: <20180720090150.24560-1-andr2000@gmail.com>
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

3. Make gntdev's common code and structures available to dma-buf.

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 drivers/xen/gntdev-dmabuf.c | 455 +++++++++++++++++++++++++++++++++++-
 1 file changed, 452 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index af782c0a8a19..cc4f16c81919 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -3,11 +3,14 @@
 /*
  * Xen dma-buf functionality for gntdev.
  *
+ * DMA buffer implementation is based on drivers/gpu/drm/drm_prime.c.
+ *
  * Copyright (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
  */
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/dma-buf.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
@@ -18,6 +21,39 @@
 #include "gntdev-common.h"
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
+			struct gntdev_grant_map *map;
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
 	/* List of exported DMA buffers. */
 	struct list_head exp_list;
@@ -31,17 +67,426 @@ struct gntdev_dmabuf_priv {
 
 /* Implementation of wait for exported DMA buffer to be released. */
 
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
+	mutex_lock(&priv->lock);
+	list_del(&obj->next);
+	mutex_unlock(&priv->lock);
+	kfree(obj);
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
+	struct gntdev_dmabuf_wait_obj *obj;
+
+	list_for_each_entry(obj, &priv->exp_wait_list, next)
+		if (obj->gntdev_dmabuf == gntdev_dmabuf) {
+			pr_debug("Found gntdev_dmabuf in the wait list, wake\n");
+			complete_all(&obj->completion);
+			break;
+		}
+}
+
+static struct gntdev_dmabuf *
+dmabuf_exp_wait_obj_get_dmabuf(struct gntdev_dmabuf_priv *priv, int fd)
+{
+	struct gntdev_dmabuf *gntdev_dmabuf, *ret = ERR_PTR(-ENOENT);
+
+	mutex_lock(&priv->lock);
+	list_for_each_entry(gntdev_dmabuf, &priv->exp_list, next)
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
 static int dmabuf_exp_wait_released(struct gntdev_dmabuf_priv *priv, int fd,
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
+	gntdev_dmabuf = dmabuf_exp_wait_obj_get_dmabuf(priv, fd);
+	if (IS_ERR(gntdev_dmabuf))
+		return PTR_ERR(gntdev_dmabuf);
+
+	/*
+	 * gntdev_dmabuf still exists and is reference count locked by us now,
+	 * so prepare to wait: allocate wait object and add it to the wait list,
+	 * so we can find it on release.
+	 */
+	obj = dmabuf_exp_wait_obj_new(priv, gntdev_dmabuf);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
+
+	ret = dmabuf_exp_wait_obj_wait(obj, wait_to_ms);
+	dmabuf_exp_wait_obj_free(priv, obj);
+	return ret;
+}
+
+/* DMA buffer export support. */
+
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
+	if (dir == DMA_NONE || !gntdev_dmabuf_attach)
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
+	if (gntdev_dmabuf_attach->dir != DMA_NONE)
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
+		pr_debug("Failed to map sg table for dev %p\n", attach->dev);
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
+static void dmabuf_exp_remove_map(struct gntdev_priv *priv,
+				  struct gntdev_grant_map *map)
+{
+	mutex_lock(&priv->lock);
+	list_del(&map->next);
+	gntdev_put_map(NULL /* already removed */, map);
+	mutex_unlock(&priv->lock);
+}
+
+static void dmabuf_exp_ops_release(struct dma_buf *dma_buf)
+{
+	struct gntdev_dmabuf *gntdev_dmabuf = dma_buf->priv;
+	struct gntdev_dmabuf_priv *priv = gntdev_dmabuf->priv;
+
+	dmabuf_exp_remove_map(gntdev_dmabuf->u.exp.priv,
+			      gntdev_dmabuf->u.exp.map);
+	mutex_lock(&priv->lock);
+	kref_put(&gntdev_dmabuf->u.exp.refcount, dmabuf_exp_release);
+	mutex_unlock(&priv->lock);
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
+	.unmap = dmabuf_exp_ops_kunmap,
+	.mmap = dmabuf_exp_ops_mmap,
+};
+
+struct gntdev_dmabuf_export_args {
+	struct gntdev_priv *priv;
+	struct gntdev_grant_map *map;
+	struct gntdev_dmabuf_priv *dmabuf_priv;
+	struct device *dev;
+	int count;
+	struct page **pages;
+	u32 fd;
+};
+
+static int dmabuf_exp_from_pages(struct gntdev_dmabuf_export_args *args)
+{
+	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
+	struct gntdev_dmabuf *gntdev_dmabuf;
+	int ret;
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
+}
+
+static struct gntdev_grant_map *
+dmabuf_exp_alloc_backing_storage(struct gntdev_priv *priv, int dmabuf_flags,
+				 int count)
+{
+	struct gntdev_grant_map *map;
+
+	if (unlikely(count <= 0))
+		return ERR_PTR(-EINVAL);
+
+	if ((dmabuf_flags & GNTDEV_DMA_FLAG_WC) &&
+	    (dmabuf_flags & GNTDEV_DMA_FLAG_COHERENT)) {
+		pr_debug("Wrong dma-buf flags: 0x%x\n", dmabuf_flags);
+		return ERR_PTR(-EINVAL);
+	}
+
+	map = gntdev_alloc_map(priv, count, dmabuf_flags);
+	if (!map)
+		return ERR_PTR(-ENOMEM);
+
+	if (unlikely(gntdev_account_mapped_pages(count))) {
+		pr_debug("can't map %d pages: over limit\n", count);
+		gntdev_put_map(NULL, map);
+		return ERR_PTR(-ENOMEM);
+	}
+	return map;
 }
 
 static int dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
 				int count, u32 domid, u32 *refs, u32 *fd)
 {
-	*fd = -1;
-	return -EINVAL;
+	struct gntdev_grant_map *map;
+	struct gntdev_dmabuf_export_args args;
+	int i, ret;
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
+	ret = gntdev_map_grant_pages(map);
+	if (ret < 0)
+		goto out;
+
+	args.priv = priv;
+	args.map = map;
+	args.dev = priv->dma_dev;
+	args.dmabuf_priv = priv->dmabuf_priv;
+	args.count = map->count;
+	args.pages = map->pages;
+
+	ret = dmabuf_exp_from_pages(&args);
+	if (ret < 0)
+		goto out;
+
+	*fd = args.fd;
+	return 0;
+
+out:
+	dmabuf_exp_remove_map(priv, map);
+	return ret;
 }
 
 /* DMA buffer import support. */
@@ -168,6 +613,10 @@ struct gntdev_dmabuf_priv *gntdev_dmabuf_init(void)
 	if (!priv)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&priv->lock);
+	INIT_LIST_HEAD(&priv->exp_list);
+	INIT_LIST_HEAD(&priv->exp_wait_list);
+
 	return priv;
 }
 
-- 
2.18.0
