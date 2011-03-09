Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:40622 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1CINjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 08:39:40 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: jaeryul.oh@samsung.com, kgene.kim@samsung.com,
	jonghun.han@samsung.com, Jeongtae Park <jtp.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 1/1] v4l: videobuf2: Add DMA pool allocator
Date: Wed,  9 Mar 2011 22:11:31 +0900
Message-Id: <1299676291-14036-2-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1299676291-14036-1-git-send-email-jtp.park@samsung.com>
References: <1299676291-14036-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add an implementation of DMA pool memory allocator and handling
routines for videobuf2. The DMA pool allocator allocates a memory
using dma_alloc_coherent(), creates a pool using generic allocator
in the initialization. For every allocation requests, the allocator
returns a part of its memory pool using generic allocator instead
of new memory allocation.

This allocator used for devices have below limitations.
- the start address should be aligned
- the range of memory access limited to the offset from the start
  address (= the allocation address should be existed in a
  constant offset from the start address)
- the allocation address should be aligned

Reviewed-by: Jonghun Han <jonghun.han@samsung.com>
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
This allocator used for s5p-mfc. s5p-mfc has above limitations.
The CMA and CMA allocator for videobuf2 can be resolve all of
described limitations, but the CMA merge schedule is not fixed yet.
Therefore CMA allocator for videobuf2 also cannot be used in the
driver currently. The s5p-mfc v4l2 driver can be validated with
the DMA pool allocator without CMA dependency.

 drivers/media/video/Kconfig              |    7 +
 drivers/media/video/Makefile             |    1 +
 drivers/media/video/videobuf2-dma-pool.c |  310 ++++++++++++++++++++++++++++++
 include/media/videobuf2-dma-pool.h       |   37 ++++
 4 files changed, 355 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-dma-pool.c
 create mode 100644 include/media/videobuf2-dma-pool.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index e2f5a69..986019f 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -66,6 +66,13 @@ config VIDEOBUF2_DMA_SG
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
 	tristate
+
+config VIDEOBUF2_DMA_POOL
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	select GENERIC_ALLOCATOR
+	tristate
+
 #
 # Multimedia Video device configuration
 #
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index ac54652..12fca52 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -118,6 +118,7 @@ obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG)	+= videobuf2-dma-contig.o
 obj-$(CONFIG_VIDEOBUF2_DMA_SG)		+= videobuf2-dma-sg.o
+obj-$(CONFIG_VIDEOBUF2_DMA_POOL)	+= videobuf2-dma-pool.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
diff --git a/drivers/media/video/videobuf2-dma-pool.c b/drivers/media/video/videobuf2-dma-pool.c
new file mode 100644
index 0000000..59f4cba
--- /dev/null
+++ b/drivers/media/video/videobuf2-dma-pool.c
@@ -0,0 +1,310 @@
+/*
+ * videobuf2-dma-pool.c - DMA pool memory allocator for videobuf2
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+#include <linux/genalloc.h>
+
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-memops.h>
+
+#define DMA_POOL_MAGIC	0x706F6F6C
+#define MAGIC_CHECK(is, should)					\
+	if (unlikely((is) != (should))) {			\
+		pr_err("magic mismatch: %x (expected %x)\n",	\
+				(is), (should));		\
+		BUG();						\
+	}
+
+static int debug;
+module_param(debug, int, 0644);
+
+#define dprintk(level, fmt, arg...)					\
+	do {								\
+		if (debug >= level)					\
+			printk(KERN_DEBUG "vb2_dp: " fmt, ## arg);	\
+	} while (0)
+
+struct vb2_dma_pool_conf {
+	struct device		*dev;
+	struct gen_pool		*pool;
+	dma_addr_t		paddr;
+	void			*vaddr;
+	unsigned long		size;
+	u32			magic;
+};
+
+struct vb2_dma_pool_buf {
+	struct vb2_dma_pool_conf	*conf;
+	void				*vaddr;
+	dma_addr_t			paddr;
+	unsigned long			size;
+	struct vm_area_struct		*vma;
+	atomic_t			refcount;
+	struct vb2_vmarea_handler	handler;
+};
+
+static void vb2_dma_pool_put(void *buf_priv);
+
+static void *vb2_dma_pool_alloc(void *alloc_ctx, unsigned long size)
+{
+	struct vb2_dma_pool_conf *conf = alloc_ctx;
+	struct vb2_dma_pool_buf *buf;
+
+	BUG_ON(!conf);
+	MAGIC_CHECK(conf->magic, DMA_POOL_MAGIC);
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	buf->paddr = gen_pool_alloc(conf->pool, size);
+	if (!buf->paddr) {
+		dev_err(conf->dev, "failed to get buffer from pool: %ld\n",
+			size);
+		kfree(buf);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	buf->conf = conf;
+	buf->vaddr = conf->vaddr + (buf->paddr - conf->paddr);
+	buf->size = size;
+
+	buf->handler.refcount = &buf->refcount;
+	buf->handler.put = vb2_dma_pool_put;
+	buf->handler.arg = buf;
+
+	atomic_inc(&buf->refcount);
+
+	dprintk(2, "alloc-> vaddr: %p, paddr: 0x%08x, size: %ld\n",
+		buf->vaddr, buf->paddr, size);
+
+	return buf;
+}
+
+static void vb2_dma_pool_put(void *buf_priv)
+{
+	struct vb2_dma_pool_buf *buf = buf_priv;
+
+	dprintk(3, "put-> refcount: %d\n", atomic_read(&buf->refcount));
+
+	if (atomic_dec_and_test(&buf->refcount)) {
+		dprintk(2, "put-> paddr: 0x%08x, size: %ld\n",
+			buf->paddr, buf->size);
+
+		gen_pool_free(buf->conf->pool, buf->paddr, buf->size);
+		kfree(buf);
+	}
+}
+
+static void *vb2_dma_pool_cookie(void *buf_priv)
+{
+	struct vb2_dma_pool_buf *buf = buf_priv;
+
+	if (!buf) {
+		pr_err("failed to get buffer\n");
+		return NULL;
+	}
+
+	return (void *)buf->paddr;
+}
+
+static void *vb2_dma_pool_vaddr(void *buf_priv)
+{
+	struct vb2_dma_pool_buf *buf = buf_priv;
+
+	if (!buf) {
+		pr_err("failed to get buffer\n");
+		return NULL;
+	}
+
+	return buf->vaddr;
+}
+
+static unsigned int vb2_dma_pool_num_users(void *buf_priv)
+{
+	struct vb2_dma_pool_buf *buf = buf_priv;
+
+	if (!buf) {
+		pr_err("failed to get buffer\n");
+		return 0;
+	}
+
+	return atomic_read(&buf->refcount);
+}
+
+static int vb2_dma_pool_mmap(void *buf_priv, struct vm_area_struct *vma)
+{
+	struct vb2_dma_pool_buf *buf = buf_priv;
+
+	if (!buf) {
+		pr_err("no buffer to map\n");
+		return -EINVAL;
+	}
+
+	return vb2_mmap_pfn_range(vma, buf->paddr, buf->size,
+				  &vb2_common_vm_ops, &buf->handler);
+}
+
+const struct vb2_mem_ops vb2_dma_pool_memops = {
+	.alloc		= vb2_dma_pool_alloc,
+	.put		= vb2_dma_pool_put,
+	.cookie		= vb2_dma_pool_cookie,
+	.vaddr		= vb2_dma_pool_vaddr,
+	.mmap		= vb2_dma_pool_mmap,
+	.num_users	= vb2_dma_pool_num_users,
+};
+EXPORT_SYMBOL_GPL(vb2_dma_pool_memops);
+
+void *vb2_dma_pool_init(struct device *dev, unsigned long base_order,
+			unsigned long alloc_order, unsigned long size)
+{
+	struct vb2_dma_pool_conf *conf;
+	int ret;
+	unsigned long margin, margin_order;
+
+	if (!(size >> alloc_order))
+		return ERR_PTR(-EINVAL);
+
+	conf = kzalloc(sizeof *conf, GFP_KERNEL);
+	if (!conf)
+		return ERR_PTR(-ENOMEM);
+
+	conf->magic = DMA_POOL_MAGIC;
+	conf->dev = dev;
+	conf->size = size;
+
+	conf->vaddr = dma_alloc_coherent(conf->dev, conf->size,
+					 &conf->paddr, GFP_KERNEL);
+	if (!conf->vaddr) {
+		dev_err(dev, "dma_alloc_coherent of size %ld failed\n",
+			size);
+		ret = -ENOMEM;
+		goto fail_dma_alloc;
+	}
+
+	dprintk(1, "init-> vaddr: %p, paddr: 0x%08x, size: %ld\n",
+		conf->vaddr, conf->paddr, conf->size);
+
+	margin_order = (base_order > alloc_order) ? base_order : alloc_order;
+	margin = ALIGN(conf->paddr, (1 << margin_order)) - conf->paddr;
+
+	dprintk(1, "init-> margin_order: %ld, margin: %ld\n",
+		margin_order, margin);
+
+	if (margin >= conf->size) {
+		ret = -ENOMEM;
+		goto fail_base_align;
+	}
+
+	if (!((conf->size - margin) >> alloc_order)) {
+		ret = -ENOMEM;
+		goto fail_base_align;
+	}
+
+	conf->pool = gen_pool_create(alloc_order, -1);
+	if (!conf->pool) {
+		dev_err(conf->dev, "failed to create pool\n");
+		ret = -ENOMEM;
+		goto fail_pool_create;
+	}
+
+	ret = gen_pool_add(conf->pool, (conf->paddr + margin),
+			   (conf->size - margin), -1);
+	if (ret) {
+		dev_err(conf->dev, "could not add buffer to pool");
+		goto fail_pool_add;
+	}
+
+	return conf;
+
+fail_pool_add:
+	gen_pool_destroy(conf->pool);
+fail_base_align:
+fail_pool_create:
+	dma_free_coherent(conf->dev, conf->size, conf->vaddr, conf->paddr);
+fail_dma_alloc:
+	kfree(conf);
+
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(vb2_dma_pool_init);
+
+void vb2_dma_pool_cleanup(void *conf)
+{
+	struct vb2_dma_pool_conf *_conf;
+
+	_conf = (struct vb2_dma_pool_conf *)conf;
+
+	BUG_ON(!_conf);
+	MAGIC_CHECK(_conf->magic, DMA_POOL_MAGIC);
+
+	gen_pool_destroy(_conf->pool);
+	dma_free_coherent(_conf->dev, _conf->size, _conf->vaddr,
+			  _conf->paddr);
+
+	kfree(conf);
+}
+EXPORT_SYMBOL_GPL(vb2_dma_pool_cleanup);
+
+void **vb2_dma_pool_init_multi(struct device *dev, unsigned int num_planes,
+			       unsigned long base_orders[],
+			       unsigned long alloc_orders[],
+			       unsigned long sizes[])
+{
+	struct vb2_dma_pool_conf *conf;
+	void **alloc_ctxes;
+	int i, j;
+
+	alloc_ctxes = kzalloc(sizeof *alloc_ctxes * num_planes, GFP_KERNEL);
+	if (!alloc_ctxes)
+		return ERR_PTR(-ENOMEM);
+
+	conf = (void *)(alloc_ctxes + num_planes);
+
+	for (i = 0; i < num_planes; ++i, ++conf) {
+		dprintk(1, "init_multi-> index: %d, orders: %ld, %ld\n",
+			i, base_orders[i], alloc_orders[i]);
+
+		conf = vb2_dma_pool_init(dev, base_orders[i],
+					 alloc_orders[i], sizes[i]);
+		if (IS_ERR(conf)) {
+			for (j = i - 1; j >= 0; j--)
+				vb2_dma_pool_cleanup(alloc_ctxes[j]);
+
+			kfree(alloc_ctxes);
+			return ERR_PTR(PTR_ERR(conf));
+		}
+
+		alloc_ctxes[i] = conf;
+	}
+
+	return alloc_ctxes;
+}
+EXPORT_SYMBOL_GPL(vb2_dma_pool_init_multi);
+
+void vb2_dma_pool_cleanup_multi(void **alloc_ctxes, unsigned int num_planes)
+{
+	int i;
+
+	for (i = 0; i < num_planes; i++)
+		vb2_dma_pool_cleanup(alloc_ctxes[i]);
+
+	kfree(alloc_ctxes);
+}
+EXPORT_SYMBOL_GPL(vb2_dma_pool_cleanup_multi);
+
+MODULE_DESCRIPTION("DMA-pool handling routines for videobuf2");
+MODULE_AUTHOR("Jeongtae Park");
+MODULE_LICENSE("GPL");
+
diff --git a/include/media/videobuf2-dma-pool.h b/include/media/videobuf2-dma-pool.h
new file mode 100644
index 0000000..3cad846
--- /dev/null
+++ b/include/media/videobuf2-dma-pool.h
@@ -0,0 +1,37 @@
+/*
+ * videobuf2-dma-pool.h - DMA pool memory allocator for videobuf2
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _MEDIA_VIDEOBUF2_DMA_POOL_H
+#define _MEDIA_VIDEOBUF2_DMA_POOL_H
+
+#include <media/videobuf2-core.h>
+
+static inline unsigned long vb2_dma_pool_plane_paddr(struct vb2_buffer *vb,
+						     unsigned int plane_no)
+{
+	return (unsigned long)vb2_plane_cookie(vb, plane_no);
+}
+
+void *vb2_dma_pool_init(struct device *dev, unsigned long base_order,
+			unsigned long alloc_order, unsigned long size);
+void vb2_dma_pool_cleanup(struct vb2_alloc_ctx *alloc_ctx);
+
+void **vb2_dma_pool_init_multi(struct device *dev, unsigned int num_planes,
+			       unsigned long base_orders[],
+			       unsigned long alloc_orders[],
+			       unsigned long sizes[]);
+void vb2_dma_pool_cleanup_multi(void **alloc_ctxes,
+				unsigned int num_planes);
+
+extern const struct vb2_mem_ops vb2_dma_pool_memops;
+
+#endif /* _MEDIA_VIDEOBUF2_DMA_POOL_H */
-- 
1.7.1

