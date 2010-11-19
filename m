Return-path: <mchehab@gaivota>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25368 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab0KSP4C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 10:56:02 -0500
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LC500AGQ2X8EL@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Nov 2010 15:55:57 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LC500BKY2X8OC@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Nov 2010 15:55:56 +0000 (GMT)
Date: Fri, 19 Nov 2010 16:55:41 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 4/7] v4l: videobuf2: add DMA coherent allocator
In-reply-to: <1290182144-10878-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com
Message-id: <1290182144-10878-5-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1290182144-10878-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Pawel Osciak <p.osciak@samsung.com>

Add an implementation of DMA coherent memory allocator and handling
routines for videobuf2, implemented on top of dma_alloc_coherent() call.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/Kconfig                  |    5 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/videobuf2-dma-coherent.c |  211 ++++++++++++++++++++++++++
 include/media/videobuf2-dma-coherent.h       |   27 ++++
 4 files changed, 244 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-dma-coherent.c
 create mode 100644 include/media/videobuf2-dma-coherent.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9351423..e7752ee1 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -55,6 +55,11 @@ config VIDEOBUF2_CORE
 config VIDEOBUF2_MEMOPS
 	tristate
 
+config VIDEOBUF2_DMA_COHERENT
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
+
 config VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 538bee9..ede588d 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -117,6 +117,7 @@ obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o
 obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
+obj-$(CONFIG_VIDEOBUF2_DMA_COHERENT)	+= videobuf2-dma-coherent.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
diff --git a/drivers/media/video/videobuf2-dma-coherent.c b/drivers/media/video/videobuf2-dma-coherent.c
new file mode 100644
index 0000000..965a80a
--- /dev/null
+++ b/drivers/media/video/videobuf2-dma-coherent.c
@@ -0,0 +1,211 @@
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
+#include <linux/slab.h>
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
+static void *vb2_dma_coherent_alloc(const struct vb2_alloc_ctx *alloc_ctx,
+					unsigned long size)
+{
+	struct vb2_dc_conf *conf =
+		container_of(alloc_ctx, struct vb2_dc_conf, alloc_ctx);
+	struct vb2_dc_buf *buf;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	buf->vaddr = dma_alloc_coherent(conf->dev, size, &buf->paddr,
+					GFP_KERNEL);
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
+static void *vb2_dma_coherent_cookie(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+
+	return (void *)buf->paddr;
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
+static const struct vb2_mem_ops vb2_dma_coherent_ops = {
+	.alloc		= vb2_dma_coherent_alloc,
+	.put		= vb2_dma_coherent_put,
+	.cookie		= vb2_dma_coherent_cookie,
+	.mmap		= vb2_dma_coherent_mmap,
+	.get_userptr	= vb2_dma_coherent_get_userptr,
+	.put_userptr	= vb2_dma_coherent_put_userptr,
+	.num_users	= vb2_dma_coherent_num_users,
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
+	conf->alloc_ctx.mem_ops = &vb2_dma_coherent_ops;
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
+
+MODULE_DESCRIPTION("DMA-coherent memory handling routines for videobuf2");
+MODULE_AUTHOR("Pawel Osciak");
+MODULE_LICENSE("GPL");
+
diff --git a/include/media/videobuf2-dma-coherent.h b/include/media/videobuf2-dma-coherent.h
new file mode 100644
index 0000000..88342db
--- /dev/null
+++ b/include/media/videobuf2-dma-coherent.h
@@ -0,0 +1,27 @@
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
+#ifndef _MEDIA_VIDEOBUF2_DMA_COHERENT_H
+#define _MEDIA_VIDEOBUF2_DMA_COHERENT_H
+
+#include <media/videobuf2-core.h>
+
+static inline unsigned long vb2_dma_coherent_plane_paddr(
+		struct vb2_buffer *vb, unsigned int plane_no)
+{
+	return (unsigned long)vb2_plane_cookie(vb, plane_no);
+}
+
+struct vb2_alloc_ctx *vb2_dma_coherent_init(struct device *dev);
+void vb2_dma_coherent_cleanup(struct vb2_alloc_ctx *alloc_ctx);
+
+#endif
-- 
1.7.1.569.g6f426

