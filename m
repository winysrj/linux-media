Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29213 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab0IIJUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 05:20:10 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L8H0032O39JTU60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Sep 2010 10:20:07 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8H0058E39I1E@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Sep 2010 10:20:07 +0100 (BST)
Date: Thu, 09 Sep 2010 11:19:46 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v1 5/7] v4l: videobuf2: add DMA coherent allocator
In-reply-to: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Message-id: <1284023988-23351-6-git-send-email-p.osciak@samsung.com>
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Add an implementation of DMA coherent memory allocator and handling
routines for videobuf2, implemented on top of dma_alloc_coherent() call.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig                  |    5 +
 drivers/media/video/Makefile                 |    4 +
 drivers/media/video/videobuf2-dma-coherent.c |  208 ++++++++++++++++++++++++++
 include/media/videobuf2-dma-coherent.h       |   16 ++
 4 files changed, 233 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-dma-coherent.c
 create mode 100644 include/media/videobuf2-dma-coherent.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index aae7a30..5286b2f 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -55,6 +55,11 @@ config VIDEOBUF2_CORE
 config VIDEOBUF2_MEMOPS
 	tristate
 
+config VIDEOBUF2_DMA_COHERENT
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_GEN_MEMOPS
+	tristate
+
 config VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_GEN_MEMOPS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index b7c15ae..20d359d 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -120,6 +120,10 @@ obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o
 obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
 
+obj-$(CONFIG_VIDEOBUF2_DMA_COHERENT)	+= videobuf2_dma_coherent.o
+videobuf2_dma_coherent-y		:= videobuf2-dma-coherent.o \
+					   videobuf2-memops.o
+
 obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2_vmalloc.o
 videobuf2_vmalloc-y			:= videobuf2-vmalloc.o \
 					   videobuf2-memops.o
diff --git a/drivers/media/video/videobuf2-dma-coherent.c b/drivers/media/video/videobuf2-dma-coherent.c
new file mode 100644
index 0000000..8c77f9d
--- /dev/null
+++ b/drivers/media/video/videobuf2-dma-coherent.c
@@ -0,0 +1,208 @@
+/*
+ * videobuf2-dma-coherent.c - DMA coherent memory allocator for videobuf2
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
+#include <linux/dma-mapping.h>
+
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-memops.h>
+
+struct vb2_dc_conf {
+	struct vb2_alloc_ctx	alloc_ctx;
+	struct device		*dev;
+};
+
+struct vb2_dc_buf {
+	struct vb2_dc_conf	*conf;
+	void			*vaddr;
+	dma_addr_t		paddr;
+	unsigned long		size;
+	unsigned int		refcount;
+	struct vm_area_struct	*vma;
+};
+
+struct vb2_alloc_ctx *vb2_dma_coherent_init(struct device *dev)
+{
+	struct vb2_dc_conf *conf;
+
+	conf = kzalloc(sizeof *conf, GFP_KERNEL);
+	if (!conf)
+		return ERR_PTR(-ENOMEM);
+
+	conf->dev = dev;
+
+	return &conf->alloc_ctx;
+}
+EXPORT_SYMBOL_GPL(vb2_dma_coherent_init);
+
+void vb2_dma_coherent_cleanup(struct vb2_alloc_ctx *alloc_ctx)
+{
+	struct vb2_dc_conf *conf =
+		container_of(alloc_ctx, struct vb2_dc_conf, alloc_ctx);
+
+	kfree(conf);
+}
+EXPORT_SYMBOL_GPL(vb2_dma_coherent_cleanup);
+
+static void *vb2_dma_coherent_alloc(const struct vb2_alloc_ctx *alloc_ctx,
+					unsigned long size)
+{
+	struct vb2_dc_conf *conf =
+		container_of(alloc_ctx, struct vb2_dc_conf, alloc_ctx);
+	struct vb2_dc_buf *buf;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);;
+
+	buf->vaddr = dma_alloc_coherent(conf->dev, buf->size,
+					&buf->paddr, GFP_KERNEL);
+	if (!buf->vaddr) {
+		dev_err(conf->dev, "dma_alloc_coherent of size %ld failed\n",
+			buf->size);
+		kfree(buf);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	buf->conf = conf;
+	buf->size = size;
+
+	return buf;
+}
+
+static void vb2_dma_coherent_put(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+
+	buf->refcount--;
+
+	if (0 == buf->refcount) {
+		dma_free_coherent(buf->conf->dev, buf->size, buf->vaddr,
+					buf->paddr);
+		kfree(buf);
+	}
+}
+
+static unsigned long vb2_dma_coherent_paddr(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+
+	return buf->paddr;
+}
+
+static unsigned int vb2_dma_coherent_num_users(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+
+	return buf->refcount;
+}
+
+static void vb2_dma_coherent_vm_open(struct vm_area_struct *vma)
+{
+	struct vb2_dc_buf *buf = vma->vm_private_data;
+
+	printk(KERN_DEBUG "%s cma_priv: %p, refcount: %d, "
+			"vma: %08lx-%08lx\n", __func__, buf, buf->refcount,
+			vma->vm_start, vma->vm_end);
+
+	buf->refcount++;
+}
+
+static void vb2_dma_coherent_vm_close(struct vm_area_struct *vma)
+{
+	struct vb2_dc_buf *buf = vma->vm_private_data;
+
+	printk(KERN_DEBUG "%s cma_priv: %p, refcount: %d, "
+			"vma: %08lx-%08lx\n", __func__, buf, buf->refcount,
+			vma->vm_start, vma->vm_end);
+
+	vb2_dma_coherent_put(buf);
+}
+
+static const struct vm_operations_struct vb2_dma_coherent_vm_ops = {
+	.open = vb2_dma_coherent_vm_open,
+	.close = vb2_dma_coherent_vm_close,
+};
+
+static int vb2_dma_coherent_mmap(void *buf_priv, struct vm_area_struct *vma)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+
+	if (!buf) {
+		printk(KERN_ERR "No memory to map\n");
+		return -EINVAL;
+	}
+
+	return vb2_mmap_pfn_range(vma, buf->paddr, buf->size,
+					&vb2_dma_coherent_vm_ops, buf);
+}
+
+static void *vb2_dma_coherent_get_userptr(unsigned long vaddr,
+						unsigned long size)
+{
+	struct vb2_dc_buf *buf;
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
+static void vb2_dma_coherent_put_userptr(void *mem_priv)
+{
+	struct vb2_dc_buf *buf = mem_priv;
+
+	if (!buf)
+		return;
+
+	vb2_put_userptr(buf->vma);
+	kfree(buf);
+}
+
+const struct vb2_mem_ops vb2_dma_coherent_ops = {
+	.alloc		= vb2_dma_coherent_alloc,
+	.put		= vb2_dma_coherent_put,
+	.paddr		= vb2_dma_coherent_paddr,
+	.mmap		= vb2_dma_coherent_mmap,
+	.get_userptr	= vb2_dma_coherent_get_userptr,
+	.put_userptr	= vb2_dma_coherent_put_userptr,
+	.num_users	= vb2_dma_coherent_num_users,
+};
+
+MODULE_DESCRIPTION("DMA-coherent memory handling routines for videobuf2");
+MODULE_AUTHOR("Pawel Osciak");
+MODULE_LICENSE("GPL");
+
diff --git a/include/media/videobuf2-dma-coherent.h b/include/media/videobuf2-dma-coherent.h
new file mode 100644
index 0000000..c7fce51
--- /dev/null
+++ b/include/media/videobuf2-dma-coherent.h
@@ -0,0 +1,16 @@
+/*
+ * videobuf2-dma-coherent.h - DMA coherent memory allocator for videobuf2
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
+#include <media/videobuf2-core.h>
+
+void *vb2_dma_coherent_init(struct device *dev);
+void vb2_dma_coherent_cleanup(struct vb2_alloc_ctx *alloc_ctx);
-- 
1.7.2.1.97.g3235b.dirty

