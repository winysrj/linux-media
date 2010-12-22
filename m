Return-path: <mchehab@gaivota>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26423 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab0LVOa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 09:30:27 -0500
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LDU00GQX2YPT9@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 14:30:25 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDU00LQA2YOWA@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 14:30:25 +0000 (GMT)
Date: Wed, 22 Dec 2010 15:30:14 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 10/13] v4l: videobuf2: add DMA coherent allocator
In-reply-to: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	andrzej.p@samsung.com
Message-id: <1293028217-23151-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com>
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
 drivers/media/video/Kconfig                |    5 +
 drivers/media/video/Makefile               |    1 +
 drivers/media/video/videobuf2-dma-contig.c |  186 ++++++++++++++++++++++++++++
 include/media/videobuf2-dma-contig.h       |   29 +++++
 4 files changed, 221 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-dma-contig.c
 create mode 100644 include/media/videobuf2-dma-contig.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 66d0a60..4fa2c4c 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -55,6 +55,11 @@ config VIDEOBUF2_CORE
 config VIDEOBUF2_MEMOPS
 	tristate
 
+config VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
+
 config VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 803c8e2..d7137e9 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -118,6 +118,7 @@ obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o
 obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
+obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG)	+= videobuf2-dma-contig.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
new file mode 100644
index 0000000..7fe7fce
--- /dev/null
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -0,0 +1,186 @@
+/*
+ * videobuf2-dma-contig.c - DMA contig memory allocator for videobuf2
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
+	struct device		*dev;
+};
+
+struct vb2_dc_buf {
+	struct vb2_dc_conf		*conf;
+	void				*vaddr;
+	dma_addr_t			paddr;
+	unsigned long			size;
+	struct vm_area_struct		*vma;
+	atomic_t			refcount;
+	struct vb2_vmarea_handler	handler;
+};
+
+static void vb2_dma_contig_put(void *buf_priv);
+
+static void *vb2_dma_contig_alloc(void *alloc_ctx, unsigned long size)
+{
+	struct vb2_dc_conf *conf = alloc_ctx;
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
+	buf->handler.refcount = &buf->refcount;
+	buf->handler.put = vb2_dma_contig_put;
+	buf->handler.arg = buf;
+
+	atomic_inc(&buf->refcount);
+
+	return buf;
+}
+
+static void vb2_dma_contig_put(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+
+	if (atomic_dec_and_test(&buf->refcount)) {
+		dma_free_coherent(buf->conf->dev, buf->size, buf->vaddr,
+				  buf->paddr);
+		kfree(buf);
+	}
+}
+
+static void *vb2_dma_contig_cookie(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+
+	return (void *)buf->paddr;
+}
+
+static void *vb2_dma_contig_vaddr(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+	if (!buf)
+		return 0;
+
+	return buf->vaddr;
+}
+
+static unsigned int vb2_dma_contig_num_users(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+
+	return atomic_read(&buf->refcount);
+}
+
+static int vb2_dma_contig_mmap(void *buf_priv, struct vm_area_struct *vma)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+
+	if (!buf) {
+		printk(KERN_ERR "No buffer to map\n");
+		return -EINVAL;
+	}
+
+	return vb2_mmap_pfn_range(vma, buf->paddr, buf->size,
+				  &vb2_common_vm_ops, &buf->handler);
+}
+
+static void *vb2_dma_contig_get_userptr(void *alloc_ctx, unsigned long vaddr,
+					unsigned long size, int write)
+{
+	struct vb2_dc_buf *buf;
+	struct vm_area_struct *vma;
+	dma_addr_t paddr = 0;
+	int ret;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	ret = vb2_get_contig_userptr(vaddr, size, &vma, &paddr);
+	if (ret) {
+		printk(KERN_ERR "Failed acquiring VMA for vaddr 0x%08lx\n",
+				vaddr);
+		kfree(buf);
+		return ERR_PTR(ret);
+	}
+
+	buf->size = size;
+	buf->paddr = paddr;
+	buf->vma = vma;
+
+	return buf;
+}
+
+static void vb2_dma_contig_put_userptr(void *mem_priv)
+{
+	struct vb2_dc_buf *buf = mem_priv;
+
+	if (!buf)
+		return;
+
+	vb2_put_vma(buf->vma);
+	kfree(buf);
+}
+
+const struct vb2_mem_ops vb2_dma_contig_memops = {
+	.alloc		= vb2_dma_contig_alloc,
+	.put		= vb2_dma_contig_put,
+	.cookie		= vb2_dma_contig_cookie,
+	.vaddr		= vb2_dma_contig_vaddr,
+	.mmap		= vb2_dma_contig_mmap,
+	.get_userptr	= vb2_dma_contig_get_userptr,
+	.put_userptr	= vb2_dma_contig_put_userptr,
+	.num_users	= vb2_dma_contig_num_users,
+};
+EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
+
+void *vb2_dma_contig_init_ctx(struct device *dev)
+{
+	struct vb2_dc_conf *conf;
+
+	conf = kzalloc(sizeof *conf, GFP_KERNEL);
+	if (!conf)
+		return ERR_PTR(-ENOMEM);
+
+	conf->dev = dev;
+
+	return conf;
+}
+EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
+
+void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
+{
+	kfree(alloc_ctx);
+}
+EXPORT_SYMBOL_GPL(vb2_dma_contig_cleanup_ctx);
+
+MODULE_DESCRIPTION("DMA-contig memory handling routines for videobuf2");
+MODULE_AUTHOR("Pawel Osciak");
+MODULE_LICENSE("GPL");
+
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
new file mode 100644
index 0000000..fb7ca84
--- /dev/null
+++ b/include/media/videobuf2-dma-contig.h
@@ -0,0 +1,29 @@
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
+static inline unsigned long vb2_dma_contig_plane_paddr(
+		struct vb2_buffer *vb, unsigned int plane_no)
+{
+	return (unsigned long)vb2_plane_cookie(vb, plane_no);
+}
+
+void *vb2_dma_contig_init_ctx(struct device *dev);
+void vb2_dma_contig_cleanup_ctx(void *alloc_ctx);
+
+extern const struct vb2_mem_ops vb2_dma_contig_memops;
+
+#endif
-- 
1.7.1.569.g6f426

