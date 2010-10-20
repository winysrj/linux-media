Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30588 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000Ab0JTGl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 02:41:27 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LAK00B5XT90QA@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Oct 2010 07:41:24 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LAK001KFT8Z9R@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Oct 2010 07:41:24 +0100 (BST)
Date: Wed, 20 Oct 2010 08:41:13 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 7/7] v4l: videobuf2: add CMA allocator
In-reply-to: <1287556873-23179-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com
Message-id: <1287556873-23179-8-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1287556873-23179-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Pawel Osciak <p.osciak@samsung.com>

Add support for the CMA contiguous memory allocator to videobuf2.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/Kconfig         |    5 +
 drivers/media/video/Makefile        |    1 +
 drivers/media/video/videobuf2-cma.c |  250 +++++++++++++++++++++++++++++++++++
 include/media/videobuf2-cma.h       |   25 ++++
 4 files changed, 281 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-cma.c
 create mode 100644 include/media/videobuf2-cma.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 4dd14c2..2da9254 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -65,6 +65,11 @@ config VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_MEMOPS
 	tristate
 
+config VIDEOBUF2_CMA
+	depends on CMA
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
 #
 # Multimedia Video device configuration
 #
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index b3ae7d4..d1fc8cf 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -121,6 +121,7 @@ obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o
 obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_COHERENT)	+= videobuf2-dma_coherent.o
+obj-$(CONFIG_VIDEOBUF2_CMA)		+= videobuf2-cma.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
diff --git a/drivers/media/video/videobuf2-cma.c b/drivers/media/video/videobuf2-cma.c
new file mode 100644
index 0000000..d949c25
--- /dev/null
+++ b/drivers/media/video/videobuf2-cma.c
@@ -0,0 +1,250 @@
+/*
+ * videobuf2-cma.c - CMA memory allocator for videobuf2
+ *
+ * Copyright (C) 2010 Samsung Electronics
+ *
+ * Author: Pawel Osciak <p.osciak@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/cma.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/file.h>
+
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-memops.h>
+
+struct vb2_cma_conf {
+	struct vb2_alloc_ctx	alloc_ctx;
+	struct device		*dev;
+	const char		*type;
+	unsigned long		alignment;
+};
+
+struct vb2_cma_buf {
+	struct vb2_cma_conf	*conf;
+	dma_addr_t		paddr;
+	unsigned long		size;
+	unsigned int		refcount;
+	struct vm_area_struct	*vma;
+};
+
+static void *vb2_cma_alloc(const struct vb2_alloc_ctx *alloc_ctx,
+				unsigned long size)
+{
+	struct vb2_cma_conf *conf =
+		container_of(alloc_ctx, struct vb2_cma_conf, alloc_ctx);
+	struct vb2_cma_buf *buf;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	buf->paddr = cma_alloc(conf->dev, conf->type, size, conf->alignment);
+	if (IS_ERR((void *)buf->paddr)) {
+		printk(KERN_ERR "cma_alloc of size %ld failed\n", size);
+		kfree(buf);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	buf->conf = conf;
+	buf->size = size;
+	buf->refcount++;
+
+	printk(KERN_DEBUG "Allocated cma mem of size %ld at paddr=0x%08x\n",
+			buf->size, buf->paddr);
+
+	return buf;
+}
+
+static void vb2_cma_put(void *buf_priv)
+{
+	struct vb2_cma_buf *buf = buf_priv;
+
+	buf->refcount--;
+
+	if (0 == buf->refcount) {
+		cma_free(buf->paddr);
+		kfree(buf);
+	}
+}
+
+static unsigned long vb2_cma_paddr(void *buf_priv)
+{
+	struct vb2_cma_buf *buf = buf_priv;
+
+	return buf->paddr;
+}
+
+static unsigned int vb2_cma_num_users(void *buf_priv)
+{
+	struct vb2_cma_buf *buf = buf_priv;
+
+	return buf->refcount;
+}
+
+static void vb2_cma_vm_open(struct vm_area_struct *vma)
+{
+	struct vb2_cma_buf *buf = vma->vm_private_data;
+
+	printk(KERN_DEBUG "%s cma_priv: %p, refcount: %d, "
+			"vma: %08lx-%08lx\n", __func__, buf, buf->refcount,
+			vma->vm_start, vma->vm_end);
+
+	buf->refcount++;
+}
+
+static void vb2_cma_vm_close(struct vm_area_struct *vma)
+{
+	struct vb2_cma_buf *buf = vma->vm_private_data;
+
+	printk(KERN_DEBUG "%s cma_priv: %p, refcount: %d, "
+			"vma: %08lx-%08lx\n", __func__, buf, buf->refcount,
+			vma->vm_start, vma->vm_end);
+
+	vb2_cma_put(buf);
+}
+
+static const struct vm_operations_struct vb2_cma_vm_ops = {
+	.open = vb2_cma_vm_open,
+	.close = vb2_cma_vm_close,
+};
+
+static int vb2_cma_mmap(void *buf_priv, struct vm_area_struct *vma)
+{
+	struct vb2_cma_buf *buf = buf_priv;
+
+	if (!buf) {
+		printk(KERN_ERR "No memory to map\n");
+		return -EINVAL;
+	}
+
+	return vb2_mmap_pfn_range(vma, buf->paddr, buf->size,
+					&vb2_cma_vm_ops, buf);
+}
+
+static void *vb2_cma_get_userptr(unsigned long vaddr, unsigned long size)
+{
+	struct vb2_cma_buf *buf;
+	unsigned long paddr = 0;
+	int ret;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	buf->vma = vb2_get_userptr(vaddr);
+	if (!buf->vma) {
+		printk(KERN_ERR "Failed acquiring VMA for vaddr 0x%08lx\n",
+				vaddr);
+		ret = -EINVAL;
+		goto done;
+	}
+
+	ret = vb2_contig_verify_userptr(buf->vma, vaddr, size, &paddr);
+	if (ret) {
+		vb2_put_userptr(buf->vma);
+		goto done;
+	}
+
+	buf->size = size;
+	buf->paddr = paddr;
+
+	return buf;
+
+done:
+	kfree(buf);
+	return ERR_PTR(ret);
+}
+
+static void vb2_cma_put_userptr(void *mem_priv)
+{
+	struct vb2_cma_buf *buf = mem_priv;
+
+	if (!buf)
+		return;
+
+	vb2_put_userptr(buf->vma);
+	kfree(buf);
+}
+
+static const struct vb2_mem_ops vb2_cma_ops = {
+	.alloc		= vb2_cma_alloc,
+	.put		= vb2_cma_put,
+	.paddr		= vb2_cma_paddr,
+	.mmap		= vb2_cma_mmap,
+	.get_userptr	= vb2_cma_get_userptr,
+	.put_userptr	= vb2_cma_put_userptr,
+	.num_users	= vb2_cma_num_users,
+};
+
+struct vb2_alloc_ctx *vb2_cma_init(struct device *dev, const char *type,
+					unsigned long alignment)
+{
+	struct vb2_cma_conf *conf;
+
+	conf = kzalloc(sizeof *conf, GFP_KERNEL);
+	if (!conf)
+		return ERR_PTR(-ENOMEM);
+
+	conf->dev = dev;
+	conf->type = type;
+	conf->alignment = alignment;
+	conf->alloc_ctx.mem_ops = &vb2_cma_ops;
+
+	return &conf->alloc_ctx;
+}
+EXPORT_SYMBOL_GPL(vb2_cma_init);
+
+void vb2_cma_cleanup(struct vb2_alloc_ctx *alloc_ctx)
+{
+	struct vb2_cma_conf *conf =
+		container_of(alloc_ctx, struct vb2_cma_conf, alloc_ctx);
+
+	kfree(conf);
+}
+EXPORT_SYMBOL_GPL(vb2_cma_cleanup);
+
+struct vb2_alloc_ctx **vb2_cma_init_multi(struct device *dev,
+					  unsigned int num_planes,
+					  const char *types[],
+					  unsigned long alignments[])
+{
+	struct vb2_alloc_ctx	**alloc_ctxes;
+	struct vb2_cma_conf	*cma_conf;
+	unsigned int i;
+
+	alloc_ctxes = kzalloc((sizeof *alloc_ctxes + sizeof *cma_conf)
+				* num_planes, GFP_KERNEL);
+	if (!alloc_ctxes)
+		return ERR_PTR(-ENOMEM);
+
+	cma_conf = (void *)(alloc_ctxes + num_planes);
+
+	for (i = 0; i < num_planes; ++i, ++cma_conf) {
+		alloc_ctxes[i] = &cma_conf->alloc_ctx;
+		cma_conf->dev = dev;
+		cma_conf->type = types[i];
+		cma_conf->alignment = alignments[i];
+		cma_conf->alloc_ctx.mem_ops = &vb2_cma_ops;
+	}
+
+	return alloc_ctxes;
+}
+EXPORT_SYMBOL_GPL(vb2_cma_init_multi);
+
+void vb2_cma_cleanup_multi(struct vb2_alloc_ctx **alloc_ctxes)
+{
+	kfree(alloc_ctxes);
+}
+EXPORT_SYMBOL_GPL(vb2_cma_cleanup_multi);
+
+MODULE_DESCRIPTION("CMA allocator handling routines for videobuf2");
+MODULE_AUTHOR("Pawel Osciak");
+MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-cma.h b/include/media/videobuf2-cma.h
new file mode 100644
index 0000000..557eeb0
--- /dev/null
+++ b/include/media/videobuf2-cma.h
@@ -0,0 +1,25 @@
+/*
+ * videobuf2-cma.h - CMA memory allocator for videobuf2
+ *
+ * Copyright (C) 2010 Samsung Electronics
+ *
+ * Author: Pawel Osciak <p.osciak@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+struct vb2_alloc_ctx *vb2_cma_init(struct device *dev, const char *type,
+					unsigned long alignment);
+void vb2_cma_cleanup(struct vb2_alloc_ctx *alloc_ctx);
+
+struct vb2_alloc_ctx **vb2_cma_init_multi(struct device *dev,
+				  unsigned int num_planes, const char *types[],
+				  unsigned long alignments[]);
+void vb2_cma_cleanup_multi(struct vb2_alloc_ctx **alloc_ctxes);
+
+struct vb2_alloc_ctx *vb2_cma_init(struct device *dev, const char *type,
+					unsigned long alignment);
+void vb2_cma_cleanup(struct vb2_alloc_ctx *alloc_ctx);
+
-- 
1.7.1.569.g6f426

