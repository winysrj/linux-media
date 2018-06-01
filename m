Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:43578 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751938AbeFALlz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 07:41:55 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH v2 9/9] xen/gntdev: Expose gntdev's dma-buf API for in-kernel use
Date: Fri,  1 Jun 2018 14:41:32 +0300
Message-Id: <20180601114132.22596-10-andr2000@gmail.com>
In-Reply-To: <20180601114132.22596-1-andr2000@gmail.com>
References: <20180601114132.22596-1-andr2000@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Allow creating grant device context for use by kernel modules which
require functionality, provided by gntdev. Export symbols for dma-buf
API provided by the module.

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
---
 drivers/xen/gntdev-dmabuf.c |  6 +++
 drivers/xen/gntdev.c        | 92 +++++++++++++++++++++++--------------
 include/xen/grant_dev.h     | 37 +++++++++++++++
 3 files changed, 101 insertions(+), 34 deletions(-)
 create mode 100644 include/xen/grant_dev.h

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index b5569a220f03..3890ac9dfab6 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -196,6 +196,7 @@ int gntdev_dmabuf_exp_wait_released(struct gntdev_dmabuf_priv *priv, int fd,
 	dmabuf_exp_wait_obj_free(priv, obj);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(gntdev_dmabuf_exp_wait_released);
 
 /* ------------------------------------------------------------------ */
 /* DMA buffer export support.                                         */
@@ -621,6 +622,7 @@ gntdev_dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
 	dma_buf_put(dma_buf);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(gntdev_dmabuf_imp_to_refs);
 
 u32 *gntdev_dmabuf_imp_get_refs(struct gntdev_dmabuf *gntdev_dmabuf)
 {
@@ -629,6 +631,7 @@ u32 *gntdev_dmabuf_imp_get_refs(struct gntdev_dmabuf *gntdev_dmabuf)
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(gntdev_dmabuf_imp_get_refs);
 
 /*
  * Find the hyper dma-buf by its file descriptor and remove
@@ -678,6 +681,7 @@ int gntdev_dmabuf_imp_release(struct gntdev_dmabuf_priv *priv, u32 fd)
 	dmabuf_imp_free_storage(gntdev_dmabuf);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(gntdev_dmabuf_imp_release);
 
 struct gntdev_dmabuf_priv *gntdev_dmabuf_init(void)
 {
@@ -694,8 +698,10 @@ struct gntdev_dmabuf_priv *gntdev_dmabuf_init(void)
 
 	return priv;
 }
+EXPORT_SYMBOL_GPL(gntdev_dmabuf_init);
 
 void gntdev_dmabuf_fini(struct gntdev_dmabuf_priv *priv)
 {
 	kfree(priv);
 }
+EXPORT_SYMBOL_GPL(gntdev_dmabuf_fini);
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index cf255d45f20f..63902f5298c9 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -621,14 +621,37 @@ static const struct mmu_notifier_ops gntdev_mmu_ops = {
 
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
+#ifdef CONFIG_XEN_GNTDEV_DMABUF
+	gntdev_dmabuf_fini(priv->dmabuf_priv);
+#endif
+
+	kfree(priv);
+}
+EXPORT_SYMBOL_GPL(gntdev_free_context);
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
@@ -637,12 +660,40 @@ static int gntdev_open(struct inode *inode, struct file *flip)
 #ifdef CONFIG_XEN_GNTDEV_DMABUF
 	priv->dmabuf_priv = gntdev_dmabuf_init();
 	if (IS_ERR(priv->dmabuf_priv)) {
-		ret = PTR_ERR(priv->dmabuf_priv);
+		struct gntdev_priv *ret;
+
+		ret = ERR_CAST(priv->dmabuf_priv);
 		kfree(priv);
 		return ret;
 	}
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
+EXPORT_SYMBOL_GPL(gntdev_alloc_context);
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
@@ -655,23 +706,11 @@ static int gntdev_open(struct inode *inode, struct file *flip)
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
@@ -679,27 +718,11 @@ static int gntdev_open(struct inode *inode, struct file *flip)
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
-
-#ifdef CONFIG_XEN_GNTDEV_DMABUF
-	gntdev_dmabuf_fini(priv->dmabuf_priv);
-#endif
 
 	if (use_ptemod)
 		mmu_notifier_unregister(&priv->mn, priv->mm);
 
-	kfree(priv);
+	gntdev_free_context(priv);
 	return 0;
 }
 
@@ -1156,6 +1179,7 @@ int gntdev_dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
 	gntdev_remove_map(priv, map);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(gntdev_dmabuf_exp_from_refs);
 
 /* ------------------------------------------------------------------ */
 /* DMA buffer IOCTL support.                                          */
diff --git a/include/xen/grant_dev.h b/include/xen/grant_dev.h
new file mode 100644
index 000000000000..b7d0abd1ab16
--- /dev/null
+++ b/include/xen/grant_dev.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
