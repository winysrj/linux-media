Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51102 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966743AbeEYPd6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 11:33:58 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH 8/8] xen/gntdev: Expose gntdev's dma-buf API for in-kernel use
Date: Fri, 25 May 2018 18:33:31 +0300
Message-Id: <20180525153331.31188-9-andr2000@gmail.com>
In-Reply-To: <20180525153331.31188-1-andr2000@gmail.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Allow creating grant device context for use by kernel modules which
require functionality, provided by gntdev. Export symbols for dma-buf
API provided by the module.

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
---
 drivers/xen/gntdev.c    | 116 ++++++++++++++++++++++++++--------------
 include/xen/grant_dev.h |  37 +++++++++++++
 2 files changed, 113 insertions(+), 40 deletions(-)
 create mode 100644 include/xen/grant_dev.h

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index d8b6168f2cd9..912056f3e909 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -684,14 +684,33 @@ static const struct mmu_notifier_ops gntdev_mmu_ops = {
 
 /* ------------------------------------------------------------------ */
 
-static int gntdev_open(struct inode *inode, struct file *flip)
+void gntdev_free_context(struct gntdev_priv *priv)
+{
+	struct grant_map *map;
+
+	pr_debug("priv %p\n", priv);
+
+	mutex_lock(&priv->lock);
+	while (!list_empty(&priv->maps)) {
+		map = list_entry(priv->maps.next, struct grant_map, next);
+		list_del(&map->next);
+		gntdev_put_map(NULL /* already removed */, map);
+	}
+	WARN_ON(!list_empty(&priv->freeable_maps));
+
+	mutex_unlock(&priv->lock);
+
+	kfree(priv);
+}
+EXPORT_SYMBOL(gntdev_free_context);
+
+struct gntdev_priv *gntdev_alloc_context(struct device *dev)
 {
 	struct gntdev_priv *priv;
-	int ret = 0;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&priv->maps);
 	INIT_LIST_HEAD(&priv->freeable_maps);
@@ -704,6 +723,32 @@ static int gntdev_open(struct inode *inode, struct file *flip)
 	INIT_LIST_HEAD(&priv->dmabuf_imp_list);
 #endif
 
+#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
+	priv->dma_dev = dev;
+
+	/*
+	 * The device is not spawn from a device tree, so arch_setup_dma_ops
+	 * is not called, thus leaving the device with dummy DMA ops.
+	 * Fix this call of_dma_configure() with a NULL node to set
+	 * default DMA ops.
+	 */
+	of_dma_configure(priv->dma_dev, NULL);
+#endif
+	pr_debug("priv %p\n", priv);
+
+	return priv;
+}
+EXPORT_SYMBOL(gntdev_alloc_context);
+
+static int gntdev_open(struct inode *inode, struct file *flip)
+{
+	struct gntdev_priv *priv;
+	int ret = 0;
+
+	priv = gntdev_alloc_context(gntdev_miscdev.this_device);
+	if (IS_ERR(priv))
+		return PTR_ERR(priv);
+
 	if (use_ptemod) {
 		priv->mm = get_task_mm(current);
 		if (!priv->mm) {
@@ -716,23 +761,11 @@ static int gntdev_open(struct inode *inode, struct file *flip)
 	}
 
 	if (ret) {
-		kfree(priv);
+		gntdev_free_context(priv);
 		return ret;
 	}
 
 	flip->private_data = priv;
-#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
-	priv->dma_dev = gntdev_miscdev.this_device;
-
-	/*
-	 * The device is not spawn from a device tree, so arch_setup_dma_ops
-	 * is not called, thus leaving the device with dummy DMA ops.
-	 * Fix this call of_dma_configure() with a NULL node to set
-	 * default DMA ops.
-	 */
-	of_dma_configure(priv->dma_dev, NULL);
-#endif
-	pr_debug("priv %p\n", priv);
 
 	return 0;
 }
@@ -740,22 +773,11 @@ static int gntdev_open(struct inode *inode, struct file *flip)
 static int gntdev_release(struct inode *inode, struct file *flip)
 {
 	struct gntdev_priv *priv = flip->private_data;
-	struct grant_map *map;
-
-	pr_debug("priv %p\n", priv);
-
-	mutex_lock(&priv->lock);
-	while (!list_empty(&priv->maps)) {
-		map = list_entry(priv->maps.next, struct grant_map, next);
-		list_del(&map->next);
-		gntdev_put_map(NULL /* already removed */, map);
-	}
-	WARN_ON(!list_empty(&priv->freeable_maps));
-	mutex_unlock(&priv->lock);
 
 	if (use_ptemod)
 		mmu_notifier_unregister(&priv->mn, priv->mm);
-	kfree(priv);
+
+	gntdev_free_context(priv);
 	return 0;
 }
 
@@ -1210,7 +1232,7 @@ dmabuf_exp_wait_obj_get_by_fd(struct gntdev_priv *priv, int fd)
 	return ret;
 }
 
-static int dmabuf_exp_wait_released(struct gntdev_priv *priv, int fd,
+int gntdev_dmabuf_exp_wait_released(struct gntdev_priv *priv, int fd,
 				    int wait_to_ms)
 {
 	struct xen_dmabuf *xen_dmabuf;
@@ -1242,6 +1264,7 @@ static int dmabuf_exp_wait_released(struct gntdev_priv *priv, int fd,
 	dmabuf_exp_wait_obj_free(priv, obj);
 	return ret;
 }
+EXPORT_SYMBOL(gntdev_dmabuf_exp_wait_released);
 
 /* ------------------------------------------------------------------ */
 /* DMA buffer export support.                                         */
@@ -1511,7 +1534,7 @@ dmabuf_exp_alloc_backing_storage(struct gntdev_priv *priv, int dmabuf_flags,
 	return map;
 }
 
-static int dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
+int gntdev_dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
 				int count, u32 domid, u32 *refs, u32 *fd)
 {
 	struct grant_map *map;
@@ -1557,6 +1580,7 @@ static int dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
 	gntdev_remove_map(priv, map);
 	return ret;
 }
+EXPORT_SYMBOL(gntdev_dmabuf_exp_from_refs);
 
 /* ------------------------------------------------------------------ */
 /* DMA buffer import support.                                         */
@@ -1646,8 +1670,9 @@ static struct xen_dmabuf *dmabuf_imp_alloc_storage(int count)
 	return ERR_PTR(-ENOMEM);
 }
 
-static struct xen_dmabuf *
-dmabuf_imp_to_refs(struct gntdev_priv *priv, int fd, int count, int domid)
+struct xen_dmabuf *
+gntdev_dmabuf_imp_to_refs(struct gntdev_priv *priv, int fd,
+			  int count, int domid)
 {
 	struct xen_dmabuf *xen_dmabuf, *ret;
 	struct dma_buf *dma_buf;
@@ -1736,6 +1761,16 @@ dmabuf_imp_to_refs(struct gntdev_priv *priv, int fd, int count, int domid)
 	dma_buf_put(dma_buf);
 	return ret;
 }
+EXPORT_SYMBOL(gntdev_dmabuf_imp_to_refs);
+
+u32 *gntdev_dmabuf_imp_get_refs(struct xen_dmabuf *xen_dmabuf)
+{
+	if (xen_dmabuf)
+		return xen_dmabuf->u.imp.refs;
+
+	return NULL;
+}
+EXPORT_SYMBOL(gntdev_dmabuf_imp_get_refs);
 
 /*
  * Find the hyper dma-buf by its file descriptor and remove
@@ -1759,7 +1794,7 @@ dmabuf_imp_find_unlink(struct gntdev_priv *priv, int fd)
 	return ret;
 }
 
-static int dmabuf_imp_release(struct gntdev_priv *priv, u32 fd)
+int gntdev_dmabuf_imp_release(struct gntdev_priv *priv, u32 fd)
 {
 	struct xen_dmabuf *xen_dmabuf;
 	struct dma_buf_attachment *attach;
@@ -1785,6 +1820,7 @@ static int dmabuf_imp_release(struct gntdev_priv *priv, u32 fd)
 	dmabuf_imp_free_storage(xen_dmabuf);
 	return 0;
 }
+EXPORT_SYMBOL(gntdev_dmabuf_imp_release);
 
 /* ------------------------------------------------------------------ */
 /* DMA buffer IOCTL support.                                          */
@@ -1810,8 +1846,8 @@ gntdev_ioctl_dmabuf_exp_from_refs(struct gntdev_priv *priv,
 		goto out;
 	}
 
-	ret = dmabuf_exp_from_refs(priv, op.flags, op.count,
-				   op.domid, refs, &op.fd);
+	ret = gntdev_dmabuf_exp_from_refs(priv, op.flags, op.count,
+					  op.domid, refs, &op.fd);
 	if (ret)
 		goto out;
 
@@ -1832,7 +1868,7 @@ gntdev_ioctl_dmabuf_exp_wait_released(struct gntdev_priv *priv,
 	if (copy_from_user(&op, u, sizeof(op)) != 0)
 		return -EFAULT;
 
-	return dmabuf_exp_wait_released(priv, op.fd, op.wait_to_ms);
+	return gntdev_dmabuf_exp_wait_released(priv, op.fd, op.wait_to_ms);
 }
 
 static long
@@ -1846,7 +1882,7 @@ gntdev_ioctl_dmabuf_imp_to_refs(struct gntdev_priv *priv,
 	if (copy_from_user(&op, u, sizeof(op)) != 0)
 		return -EFAULT;
 
-	xen_dmabuf = dmabuf_imp_to_refs(priv, op.fd, op.count, op.domid);
+	xen_dmabuf = gntdev_dmabuf_imp_to_refs(priv, op.fd, op.count, op.domid);
 	if (IS_ERR(xen_dmabuf))
 		return PTR_ERR(xen_dmabuf);
 
@@ -1858,7 +1894,7 @@ gntdev_ioctl_dmabuf_imp_to_refs(struct gntdev_priv *priv,
 	return 0;
 
 out_release:
-	dmabuf_imp_release(priv, op.fd);
+	gntdev_dmabuf_imp_release(priv, op.fd);
 	return ret;
 }
 
@@ -1871,7 +1907,7 @@ gntdev_ioctl_dmabuf_imp_release(struct gntdev_priv *priv,
 	if (copy_from_user(&op, u, sizeof(op)) != 0)
 		return -EFAULT;
 
-	return dmabuf_imp_release(priv, op.fd);
+	return gntdev_dmabuf_imp_release(priv, op.fd);
 }
 #endif
 
diff --git a/include/xen/grant_dev.h b/include/xen/grant_dev.h
new file mode 100644
index 000000000000..faccc9170174
--- /dev/null
+++ b/include/xen/grant_dev.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+
+/*
+ * Grant device kernel API
+ *
+ * Copyright (C) 2018 EPAM Systems Inc.
+ *
+ * Author: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
+ */
+
+#ifndef _GRANT_DEV_H
+#define _GRANT_DEV_H
+
+#include <linux/types.h>
+
+struct device;
+struct gntdev_priv;
+#ifdef CONFIG_XEN_GNTDEV_DMABUF
+struct xen_dmabuf;
+#endif
+
+struct gntdev_priv *gntdev_alloc_context(struct device *dev);
+void gntdev_free_context(struct gntdev_priv *priv);
+
+#ifdef CONFIG_XEN_GNTDEV_DMABUF
+int gntdev_dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
+				int count, u32 domid, u32 *refs, u32 *fd);
+int gntdev_dmabuf_exp_wait_released(struct gntdev_priv *priv, int fd,
+				    int wait_to_ms);
+
+struct xen_dmabuf *gntdev_dmabuf_imp_to_refs(struct gntdev_priv *priv,
+					     int fd, int count, int domid);
+u32 *gntdev_dmabuf_imp_get_refs(struct xen_dmabuf *xen_dmabuf);
+int gntdev_dmabuf_imp_release(struct gntdev_priv *priv, u32 fd);
+#endif
+
+#endif
-- 
2.17.0
