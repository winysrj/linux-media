Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33912 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933847AbeFLNmW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 09:42:22 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH v3 7/9] xen/gntdev: Add initial support for dma-buf UAPI
Date: Tue, 12 Jun 2018 16:41:58 +0300
Message-Id: <20180612134200.17456-8-andr2000@gmail.com>
In-Reply-To: <20180612134200.17456-1-andr2000@gmail.com>
References: <20180612134200.17456-1-andr2000@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Add UAPI and IOCTLs for dma-buf grant device driver extension:
the extension allows userspace processes and kernel modules to
use Xen backed dma-buf implementation. With this extension grant
references to the pages of an imported dma-buf can be exported
for other domain use and grant references coming from a foreign
domain can be converted into a local dma-buf for local export.
Implement basic initialization and stubs for Xen DMA buffers'
support.

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
---
 drivers/xen/Kconfig         |  10 +++
 drivers/xen/Makefile        |   1 +
 drivers/xen/gntdev-common.h |   6 ++
 drivers/xen/gntdev-dmabuf.c |  72 ++++++++++++++++++++
 drivers/xen/gntdev-dmabuf.h |  39 +++++++++++
 drivers/xen/gntdev.c        | 132 ++++++++++++++++++++++++++++++++++++
 include/uapi/xen/gntdev.h   |  91 +++++++++++++++++++++++++
 7 files changed, 351 insertions(+)
 create mode 100644 drivers/xen/gntdev-dmabuf.c
 create mode 100644 drivers/xen/gntdev-dmabuf.h

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 39536ddfbce4..52d64e4b6b81 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -152,6 +152,16 @@ config XEN_GNTDEV
 	help
 	  Allows userspace processes to use grants.
 
+config XEN_GNTDEV_DMABUF
+	bool "Add support for dma-buf grant access device driver extension"
+	depends on XEN_GNTDEV && XEN_GRANT_DMA_ALLOC && DMA_SHARED_BUFFER
+	help
+	  Allows userspace processes and kernel modules to use Xen backed
+	  dma-buf implementation. With this extension grant references to
+	  the pages of an imported dma-buf can be exported for other domain
+	  use and grant references coming from a foreign domain can be
+	  converted into a local dma-buf for local export.
+
 config XEN_GRANT_DEV_ALLOC
 	tristate "User-space grant reference allocator driver"
 	depends on XEN
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 3c87b0c3aca6..33afb7b2b227 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -41,5 +41,6 @@ obj-$(CONFIG_XEN_PVCALLS_BACKEND)	+= pvcalls-back.o
 obj-$(CONFIG_XEN_PVCALLS_FRONTEND)	+= pvcalls-front.o
 xen-evtchn-y				:= evtchn.o
 xen-gntdev-y				:= gntdev.o
+xen-gntdev-$(CONFIG_XEN_GNTDEV_DMABUF)	+= gntdev-dmabuf.o
 xen-gntalloc-y				:= gntalloc.o
 xen-privcmd-y				:= privcmd.o
diff --git a/drivers/xen/gntdev-common.h b/drivers/xen/gntdev-common.h
index 7a9845a6bee9..a3408fd39b07 100644
--- a/drivers/xen/gntdev-common.h
+++ b/drivers/xen/gntdev-common.h
@@ -16,6 +16,8 @@
 #include <linux/mmu_notifier.h>
 #include <linux/types.h>
 
+struct gntdev_dmabuf_priv;
+
 struct gntdev_priv {
 	/* maps with visible offsets in the file descriptor */
 	struct list_head maps;
@@ -31,6 +33,10 @@ struct gntdev_priv {
 	/* Device for which DMA memory is allocated. */
 	struct device *dma_dev;
 #endif
+
+#ifdef CONFIG_XEN_GNTDEV_DMABUF
+	struct gntdev_dmabuf_priv *dmabuf_priv;
+#endif
 };
 
 struct gntdev_unmap_notify {
diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
new file mode 100644
index 000000000000..dc57c6a25525
--- /dev/null
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Xen dma-buf functionality for gntdev.
+ *
+ * Copyright (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
+ */
+
+#include <linux/slab.h>
+
+#include "gntdev-dmabuf.h"
+
+struct gntdev_dmabuf_priv {
+	/* List of exported DMA buffers. */
+	struct list_head exp_list;
+	/* List of wait objects. */
+	struct list_head exp_wait_list;
+	/* This is the lock which protects dma_buf_xxx lists. */
+	struct mutex lock;
+};
+
+/* DMA buffer export support. */
+
+/* Implementation of wait for exported DMA buffer to be released. */
+
+int gntdev_dmabuf_exp_wait_released(struct gntdev_dmabuf_priv *priv, int fd,
+				    int wait_to_ms)
+{
+	return -EINVAL;
+}
+
+int gntdev_dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
+				int count, u32 domid, u32 *refs, u32 *fd)
+{
+	*fd = -1;
+	return -EINVAL;
+}
+
+/* DMA buffer import support. */
+
+struct gntdev_dmabuf *
+gntdev_dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
+			  int fd, int count, int domid)
+{
+	return ERR_PTR(-ENOMEM);
+}
+
+u32 *gntdev_dmabuf_imp_get_refs(struct gntdev_dmabuf *gntdev_dmabuf)
+{
+	return NULL;
+}
+
+int gntdev_dmabuf_imp_release(struct gntdev_dmabuf_priv *priv, u32 fd)
+{
+	return -EINVAL;
+}
+
+struct gntdev_dmabuf_priv *gntdev_dmabuf_init(void)
+{
+	struct gntdev_dmabuf_priv *priv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+
+	return priv;
+}
+
+void gntdev_dmabuf_fini(struct gntdev_dmabuf_priv *priv)
+{
+	kfree(priv);
+}
diff --git a/drivers/xen/gntdev-dmabuf.h b/drivers/xen/gntdev-dmabuf.h
new file mode 100644
index 000000000000..75324ecd3e62
--- /dev/null
+++ b/drivers/xen/gntdev-dmabuf.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Xen dma-buf functionality for gntdev.
+ *
+ * Copyright (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
+ */
+
+#ifndef _GNTDEV_DMABUF_H
+#define _GNTDEV_DMABUF_H
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+
+struct gntdev_priv;
+struct gntdev_dmabuf_priv;
+struct gntdev_dmabuf;
+struct device;
+
+struct gntdev_dmabuf_priv *gntdev_dmabuf_init(void);
+
+void gntdev_dmabuf_fini(struct gntdev_dmabuf_priv *priv);
+
+int gntdev_dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
+				int count, u32 domid, u32 *refs, u32 *fd);
+
+int gntdev_dmabuf_exp_wait_released(struct gntdev_dmabuf_priv *priv, int fd,
+				    int wait_to_ms);
+
+struct gntdev_dmabuf *
+gntdev_dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
+			  int fd, int count, int domid);
+
+u32 *gntdev_dmabuf_imp_get_refs(struct gntdev_dmabuf *gntdev_dmabuf);
+
+int gntdev_dmabuf_imp_release(struct gntdev_dmabuf_priv *priv, u32 fd);
+
+#endif
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index a09db23e9663..e82660d81d7e 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -48,6 +48,9 @@
 #include <asm/xen/hypercall.h>
 
 #include "gntdev-common.h"
+#ifdef CONFIG_XEN_GNTDEV_DMABUF
+#include "gntdev-dmabuf.h"
+#endif
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Derek G. Murray <Derek.Murray@cl.cam.ac.uk>, "
@@ -566,6 +569,15 @@ static int gntdev_open(struct inode *inode, struct file *flip)
 	INIT_LIST_HEAD(&priv->freeable_maps);
 	mutex_init(&priv->lock);
 
+#ifdef CONFIG_XEN_GNTDEV_DMABUF
+	priv->dmabuf_priv = gntdev_dmabuf_init();
+	if (IS_ERR(priv->dmabuf_priv)) {
+		ret = PTR_ERR(priv->dmabuf_priv);
+		kfree(priv);
+		return ret;
+	}
+#endif
+
 	if (use_ptemod) {
 		priv->mm = get_task_mm(current);
 		if (!priv->mm) {
@@ -616,8 +628,13 @@ static int gntdev_release(struct inode *inode, struct file *flip)
 	WARN_ON(!list_empty(&priv->freeable_maps));
 	mutex_unlock(&priv->lock);
 
+#ifdef CONFIG_XEN_GNTDEV_DMABUF
+	gntdev_dmabuf_fini(priv->dmabuf_priv);
+#endif
+
 	if (use_ptemod)
 		mmu_notifier_unregister(&priv->mn, priv->mm);
+
 	kfree(priv);
 	return 0;
 }
@@ -987,6 +1004,107 @@ static long gntdev_ioctl_grant_copy(struct gntdev_priv *priv, void __user *u)
 	return ret;
 }
 
+#ifdef CONFIG_XEN_GNTDEV_DMABUF
+static long
+gntdev_ioctl_dmabuf_exp_from_refs(struct gntdev_priv *priv,
+				  struct ioctl_gntdev_dmabuf_exp_from_refs __user *u)
+{
+	struct ioctl_gntdev_dmabuf_exp_from_refs op;
+	u32 *refs;
+	long ret;
+
+	if (use_ptemod) {
+		pr_debug("Cannot provide dma-buf: use_ptemode %d\n",
+			 use_ptemod);
+		return -EINVAL;
+	}
+
+	if (copy_from_user(&op, u, sizeof(op)) != 0)
+		return -EFAULT;
+
+	if (unlikely(op.count <= 0))
+		return -EINVAL;
+
+	refs = kcalloc(op.count, sizeof(*refs), GFP_KERNEL);
+	if (!refs)
+		return -ENOMEM;
+
+	if (copy_from_user(refs, u->refs, sizeof(*refs) * op.count) != 0) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = gntdev_dmabuf_exp_from_refs(priv, op.flags, op.count,
+					  op.domid, refs, &op.fd);
+	if (ret)
+		goto out;
+
+	if (copy_to_user(u, &op, sizeof(op)) != 0)
+		ret = -EFAULT;
+
+out:
+	kfree(refs);
+	return ret;
+}
+
+static long
+gntdev_ioctl_dmabuf_exp_wait_released(struct gntdev_priv *priv,
+				      struct ioctl_gntdev_dmabuf_exp_wait_released __user *u)
+{
+	struct ioctl_gntdev_dmabuf_exp_wait_released op;
+
+	if (copy_from_user(&op, u, sizeof(op)) != 0)
+		return -EFAULT;
+
+	return gntdev_dmabuf_exp_wait_released(priv->dmabuf_priv, op.fd,
+					       op.wait_to_ms);
+}
+
+static long
+gntdev_ioctl_dmabuf_imp_to_refs(struct gntdev_priv *priv,
+				struct ioctl_gntdev_dmabuf_imp_to_refs __user *u)
+{
+	struct ioctl_gntdev_dmabuf_imp_to_refs op;
+	struct gntdev_dmabuf *gntdev_dmabuf;
+	long ret;
+
+	if (copy_from_user(&op, u, sizeof(op)) != 0)
+		return -EFAULT;
+
+	if (unlikely(op.count <= 0))
+		return -EINVAL;
+
+	gntdev_dmabuf = gntdev_dmabuf_imp_to_refs(priv->dmabuf_priv,
+						  priv->dma_dev, op.fd,
+						  op.count, op.domid);
+	if (IS_ERR(gntdev_dmabuf))
+		return PTR_ERR(gntdev_dmabuf);
+
+	if (copy_to_user(u->refs, gntdev_dmabuf_imp_get_refs(gntdev_dmabuf),
+			 sizeof(*u->refs) * op.count) != 0) {
+		ret = -EFAULT;
+		goto out_release;
+	}
+	return 0;
+
+out_release:
+	gntdev_dmabuf_imp_release(priv->dmabuf_priv, op.fd);
+	return ret;
+}
+
+static long
+gntdev_ioctl_dmabuf_imp_release(struct gntdev_priv *priv,
+				struct ioctl_gntdev_dmabuf_imp_release __user *u)
+{
+	struct ioctl_gntdev_dmabuf_imp_release op;
+
+	if (copy_from_user(&op, u, sizeof(op)) != 0)
+		return -EFAULT;
+
+	return gntdev_dmabuf_imp_release(priv->dmabuf_priv, op.fd);
+}
+#endif
+
 static long gntdev_ioctl(struct file *flip,
 			 unsigned int cmd, unsigned long arg)
 {
@@ -1009,6 +1127,20 @@ static long gntdev_ioctl(struct file *flip,
 	case IOCTL_GNTDEV_GRANT_COPY:
 		return gntdev_ioctl_grant_copy(priv, ptr);
 
+#ifdef CONFIG_XEN_GNTDEV_DMABUF
+	case IOCTL_GNTDEV_DMABUF_EXP_FROM_REFS:
+		return gntdev_ioctl_dmabuf_exp_from_refs(priv, ptr);
+
+	case IOCTL_GNTDEV_DMABUF_EXP_WAIT_RELEASED:
+		return gntdev_ioctl_dmabuf_exp_wait_released(priv, ptr);
+
+	case IOCTL_GNTDEV_DMABUF_IMP_TO_REFS:
+		return gntdev_ioctl_dmabuf_imp_to_refs(priv, ptr);
+
+	case IOCTL_GNTDEV_DMABUF_IMP_RELEASE:
+		return gntdev_ioctl_dmabuf_imp_release(priv, ptr);
+#endif
+
 	default:
 		pr_debug("priv %p, unknown cmd %x\n", priv, cmd);
 		return -ENOIOCTLCMD;
diff --git a/include/uapi/xen/gntdev.h b/include/uapi/xen/gntdev.h
index 4b9d498a31d4..fe4423e518c6 100644
--- a/include/uapi/xen/gntdev.h
+++ b/include/uapi/xen/gntdev.h
@@ -5,6 +5,7 @@
  * Interface to /dev/xen/gntdev.
  * 
  * Copyright (c) 2007, D G Murray
+ * Copyright (c) 2018, Oleksandr Andrushchenko, EPAM Systems Inc.
  * 
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version 2
@@ -215,4 +216,94 @@ struct ioctl_gntdev_grant_copy {
  */
 #define GNTDEV_DMA_FLAG_COHERENT	(1 << 1)
 
+/*
+ * Create a dma-buf [1] from grant references @refs of count @count provided
+ * by the foreign domain @domid with flags @flags.
+ *
+ * By default dma-buf is backed by system memory pages, but by providing
+ * one of the GNTDEV_DMA_FLAG_XXX flags it can also be created as
+ * a DMA write-combine or coherent buffer, e.g. allocated with dma_alloc_wc/
+ * dma_alloc_coherent.
+ *
+ * Returns 0 if dma-buf was successfully created and the corresponding
+ * dma-buf's file descriptor is returned in @fd.
+ *
+ * [1] Documentation/driver-api/dma-buf.rst
+ */
+
+#define IOCTL_GNTDEV_DMABUF_EXP_FROM_REFS \
+	_IOC(_IOC_NONE, 'G', 9, \
+	     sizeof(struct ioctl_gntdev_dmabuf_exp_from_refs))
+struct ioctl_gntdev_dmabuf_exp_from_refs {
+	/* IN parameters. */
+	/* Specific options for this dma-buf: see GNTDEV_DMA_FLAG_XXX. */
+	__u32 flags;
+	/* Number of grant references in @refs array. */
+	__u32 count;
+	/* OUT parameters. */
+	/* File descriptor of the dma-buf. */
+	__u32 fd;
+	/* The domain ID of the grant references to be mapped. */
+	__u32 domid;
+	/* Variable IN parameter. */
+	/* Array of grant references of size @count. */
+	__u32 refs[1];
+};
+
+/*
+ * This will block until the dma-buf with the file descriptor @fd is
+ * released. This is only valid for buffers created with
+ * IOCTL_GNTDEV_DMABUF_EXP_FROM_REFS.
+ *
+ * If within @wait_to_ms milliseconds the buffer is not released
+ * then -ETIMEDOUT error is returned.
+ * If the buffer with the file descriptor @fd does not exist or has already
+ * been released, then -ENOENT is returned. For valid file descriptors
+ * this must not be treated as error.
+ */
+#define IOCTL_GNTDEV_DMABUF_EXP_WAIT_RELEASED \
+	_IOC(_IOC_NONE, 'G', 10, \
+	     sizeof(struct ioctl_gntdev_dmabuf_exp_wait_released))
+struct ioctl_gntdev_dmabuf_exp_wait_released {
+	/* IN parameters */
+	__u32 fd;
+	__u32 wait_to_ms;
+};
+
+/*
+ * Import a dma-buf with file descriptor @fd and export granted references
+ * to the pages of that dma-buf into array @refs of size @count.
+ */
+#define IOCTL_GNTDEV_DMABUF_IMP_TO_REFS \
+	_IOC(_IOC_NONE, 'G', 11, \
+	     sizeof(struct ioctl_gntdev_dmabuf_imp_to_refs))
+struct ioctl_gntdev_dmabuf_imp_to_refs {
+	/* IN parameters. */
+	/* File descriptor of the dma-buf. */
+	__u32 fd;
+	/* Number of grant references in @refs array. */
+	__u32 count;
+	/* The domain ID for which references to be granted. */
+	__u32 domid;
+	/* Reserved - must be zero. */
+	__u32 reserved;
+	/* OUT parameters. */
+	/* Array of grant references of size @count. */
+	__u32 refs[1];
+};
+
+/*
+ * This will close all references to the imported buffer with file descriptor
+ * @fd, so it can be released by the owner. This is only valid for buffers
+ * created with IOCTL_GNTDEV_DMABUF_IMP_TO_REFS.
+ */
+#define IOCTL_GNTDEV_DMABUF_IMP_RELEASE \
+	_IOC(_IOC_NONE, 'G', 12, \
+	     sizeof(struct ioctl_gntdev_dmabuf_imp_release))
+struct ioctl_gntdev_dmabuf_imp_release {
+	/* IN parameters */
+	__u32 fd;
+	__u32 reserved;
+};
+
 #endif /* __LINUX_PUBLIC_GNTDEV_H__ */
-- 
2.17.1
