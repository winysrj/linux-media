Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32922 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966646AbeEYPdw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 11:33:52 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH 5/8] xen/gntdev: Add initial support for dma-buf UAPI
Date: Fri, 25 May 2018 18:33:28 +0300
Message-Id: <20180525153331.31188-6-andr2000@gmail.com>
In-Reply-To: <20180525153331.31188-1-andr2000@gmail.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
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
 drivers/xen/Kconfig       |  10 +++
 drivers/xen/gntdev.c      | 148 ++++++++++++++++++++++++++++++++++++++
 include/uapi/xen/gntdev.h |  91 +++++++++++++++++++++++
 3 files changed, 249 insertions(+)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 3431fe210624..eaf63a2c7ae6 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -152,6 +152,16 @@ config XEN_GNTDEV
 	help
 	  Allows userspace processes to use grants.
 
+config XEN_GNTDEV_DMABUF
+	bool "Add support for dma-buf grant access device driver extension"
+	depends on XEN_GNTDEV && XEN_GRANT_DMA_ALLOC
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
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 640a579f42ea..9e450622af1a 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -6,6 +6,7 @@
  *
  * Copyright (c) 2006-2007, D G Murray.
  *           (c) 2009 Gerd Hoffmann <kraxel@redhat.com>
+ *           (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -122,6 +123,17 @@ struct grant_map {
 #endif
 };
 
+#ifdef CONFIG_XEN_GNTDEV_DMABUF
+struct xen_dmabuf {
+	union {
+		struct {
+			/* Granted references of the imported buffer. */
+			grant_ref_t *refs;
+		} imp;
+	} u;
+};
+#endif
+
 static int unmap_grant_pages(struct grant_map *map, int offset, int pages);
 
 static struct miscdevice gntdev_miscdev;
@@ -1036,6 +1048,128 @@ static long gntdev_ioctl_grant_copy(struct gntdev_priv *priv, void __user *u)
 	return ret;
 }
 
+#ifdef CONFIG_XEN_GNTDEV_DMABUF
+/* ------------------------------------------------------------------ */
+/* DMA buffer export support.                                         */
+/* ------------------------------------------------------------------ */
+
+static int dmabuf_exp_wait_released(struct gntdev_priv *priv, int fd,
+				    int wait_to_ms)
+{
+	return -ETIMEDOUT;
+}
+
+static int dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
+				int count, u32 domid, u32 *refs, u32 *fd)
+{
+	*fd = -1;
+	return -EINVAL;
+}
+
+/* ------------------------------------------------------------------ */
+/* DMA buffer import support.                                         */
+/* ------------------------------------------------------------------ */
+
+static int dmabuf_imp_release(struct gntdev_priv *priv, u32 fd)
+{
+	return 0;
+}
+
+static struct xen_dmabuf *
+dmabuf_imp_to_refs(struct gntdev_priv *priv, int fd, int count, int domid)
+{
+	return ERR_PTR(-ENOMEM);
+}
+
+/* ------------------------------------------------------------------ */
+/* DMA buffer IOCTL support.                                          */
+/* ------------------------------------------------------------------ */
+
+static long
+gntdev_ioctl_dmabuf_exp_from_refs(struct gntdev_priv *priv,
+				  struct ioctl_gntdev_dmabuf_exp_from_refs __user *u)
+{
+	struct ioctl_gntdev_dmabuf_exp_from_refs op;
+	u32 *refs;
+	long ret;
+
+	if (copy_from_user(&op, u, sizeof(op)) != 0)
+		return -EFAULT;
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
+	ret = dmabuf_exp_from_refs(priv, op.flags, op.count,
+				   op.domid, refs, &op.fd);
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
+	return dmabuf_exp_wait_released(priv, op.fd, op.wait_to_ms);
+}
+
+static long
+gntdev_ioctl_dmabuf_imp_to_refs(struct gntdev_priv *priv,
+				struct ioctl_gntdev_dmabuf_imp_to_refs __user *u)
+{
+	struct ioctl_gntdev_dmabuf_imp_to_refs op;
+	struct xen_dmabuf *xen_dmabuf;
+	long ret;
+
+	if (copy_from_user(&op, u, sizeof(op)) != 0)
+		return -EFAULT;
+
+	xen_dmabuf = dmabuf_imp_to_refs(priv, op.fd, op.count, op.domid);
+	if (IS_ERR(xen_dmabuf))
+		return PTR_ERR(xen_dmabuf);
+
+	if (copy_to_user(u->refs, xen_dmabuf->u.imp.refs,
+			 sizeof(*u->refs) * op.count) != 0) {
+		ret = -EFAULT;
+		goto out_release;
+	}
+	return 0;
+
+out_release:
+	dmabuf_imp_release(priv, op.fd);
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
+	return dmabuf_imp_release(priv, op.fd);
+}
+#endif
+
 static long gntdev_ioctl(struct file *flip,
 			 unsigned int cmd, unsigned long arg)
 {
@@ -1058,6 +1192,20 @@ static long gntdev_ioctl(struct file *flip,
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
index 2d5a4672f07c..568d5cb522e9 100644
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
 #define GNTDEV_DMA_FLAG_COHERENT	(1 << 2)
 
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
+ * [1] https://elixir.bootlin.com/linux/latest/source/Documentation/driver-api/dma-buf.rst
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
2.17.0
