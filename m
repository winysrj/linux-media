Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56767 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1DEOJD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 10:09:03 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 05 Apr 2011 16:06:47 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 4/7] v4l: videobuf2: add IOMMU based DMA memory allocator
In-reply-to: <1302012410-17984-1-git-send-email-m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Pietrasiwiecz <andrzej.p@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Kukjin Kim <kgene.kim@samsung.com>
Message-id: <1302012410-17984-5-git-send-email-m.szyprowski@samsung.com>
References: <1302012410-17984-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

This patch adds new videobuf2 memory allocator dedicated to devices that
supports IOMMU DMA mappings. A device with IOMMU module and a driver
with include/iommu.h compatible interface is required. This allocator
aquires memory with standard alloc_page() call and doesn't suffer from
memory fragmentation issues.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/Kconfig               |    8 +-
 drivers/media/video/Makefile              |    1 +
 drivers/media/video/videobuf2-dma-iommu.c |  469 +++++++++++++++++++++++++++++
 include/media/videobuf2-dma-iommu.h       |   48 +++
 4 files changed, 525 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-dma-iommu.c
 create mode 100644 include/media/videobuf2-dma-iommu.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 4498b94..40d7bcc 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -60,12 +60,18 @@ config VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_MEMOPS
 	tristate
 
-
 config VIDEOBUF2_DMA_SG
 	#depends on HAS_DMA
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
 	tristate
+
+config VIDEOBUF2_DMA_IOMMU
+	select GENERIC_ALLOCATOR
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
+
 #
 # Multimedia Video device configuration
 #
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index ace5d8b..04136f6 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -118,6 +118,7 @@ obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG)	+= videobuf2-dma-contig.o
 obj-$(CONFIG_VIDEOBUF2_DMA_SG)		+= videobuf2-dma-sg.o
+obj-$(CONFIG_VIDEOBUF2_DMA_IOMMU)	+= videobuf2-dma-iommu.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
diff --git a/drivers/media/video/videobuf2-dma-iommu.c b/drivers/media/video/videobuf2-dma-iommu.c
new file mode 100644
index 0000000..c208e6d
--- /dev/null
+++ b/drivers/media/video/videobuf2-dma-iommu.c
@@ -0,0 +1,469 @@
+/*
+ * videobuf2-dma-iommu.c - IOMMU based memory allocator for videobuf2
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ *
+ * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/genalloc.h>
+#include <linux/device.h>
+#include <linux/iommu.h>
+#include <asm/cacheflush.h>
+#include <asm/page.h>
+
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-memops.h>
+#include <media/videobuf2-dma-iommu.h>
+
+/*
+ * 17: single piece of memory (one bitmap entry) equals 128k,
+ * so by default the genalloc's bitmap occupies 4kB (one page
+ * for a number of architectures)
+ */
+#define VB2_DMA_IOMMU_PIECE_ORDER	17
+
+/* -1: use default node id to allocate gen_pool/gen_pool_chunk structure from */
+#define VB2_DMA_IOMMU_NODE_ID		-1
+
+/*
+ * starting address of the virtual address space of the client device
+ * must not be zero
+ */
+#define VB2_DMA_IOMMU_MEM_BASE		0x30000000
+
+/* size of the virtual address space of the client device */
+#define VB2_DMA_IOMMU_MEM_SIZE		0x40000000
+
+struct vb2_dma_iommu_alloc_ctx {
+	struct device *dev;
+	struct gen_pool *pool;
+	struct iommu_domain *domain;
+};
+
+struct vb2_dma_iommu_desc {
+	unsigned long		size;
+	unsigned int		num_pages;
+	struct page		**pages;
+};
+
+struct vb2_dma_iommu_buf {
+	unsigned long			drv_addr;
+	unsigned long			vaddr;
+
+	struct vb2_dma_iommu_desc	info;
+	int				offset;
+	atomic_t			refcount;
+	int				write;
+	struct vm_area_struct		*vma;
+	bool				contig;
+
+	struct vb2_vmarea_handler	handler;
+
+	struct vb2_dma_iommu_alloc_ctx	*ctx;
+};
+
+static void vb2_dma_iommu_put(void *buf_priv);
+
+static void *vb2_dma_iommu_alloc(void *alloc_ctx, unsigned long size)
+{
+	struct vb2_dma_iommu_alloc_ctx *ctx = alloc_ctx;
+	struct vb2_dma_iommu_buf *buf;
+	unsigned long tmp;
+	int i, ret;
+
+	BUG_ON(NULL == alloc_ctx);
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->drv_addr = gen_pool_alloc(ctx->pool, size);
+	if (0 == buf->drv_addr)
+		goto gen_pool_alloc_fail;
+
+	buf->info.size = size;
+	buf->info.num_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	buf->ctx = ctx;
+	buf->info.pages = kzalloc(
+		buf->info.num_pages * sizeof(struct page *), GFP_KERNEL);
+	if (!buf->info.pages)
+		goto fail_pages_array_alloc;
+
+	for (i = 0; i < buf->info.num_pages; ++i) {
+		buf->info.pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (NULL == buf->info.pages[i])
+			goto fail_pages_alloc;
+	}
+
+	buf->handler.refcount = &buf->refcount;
+	buf->handler.put = vb2_dma_iommu_put;
+	buf->handler.arg = buf;
+
+	atomic_inc(&buf->refcount);
+
+	tmp = buf->drv_addr;
+	printk(KERN_DEBUG "%s: Map buffer of %d pages @0x%lx\n",
+	       __func__ , buf->info.num_pages, buf->drv_addr);
+	for (i = 0; i < buf->info.num_pages; tmp += PAGE_SIZE, ++i) {
+		ret = iommu_map(ctx->domain, tmp, page_to_phys(buf->info.pages[i]), 0, 0);
+		if (ret < 0)
+			goto fail_map_area;
+	}
+
+
+	/*
+	 * TODO: Ensure no one else flushes the cache later onto our memory
+	 * which already contains important data.
+	 * Perhaps find a better way to do it.
+	 */
+	flush_cache_all();
+	outer_flush_all();
+	return buf;
+
+fail_map_area:
+	tmp -= PAGE_SIZE;
+	while (--i >= 0) {
+		iommu_unmap(ctx->domain, tmp, 0);
+		tmp -= PAGE_SIZE;
+	}
+	i = buf->info.num_pages;
+fail_pages_alloc:
+	while (--i >= 0)
+		__free_page(buf->info.pages[i]);
+	kfree(buf->info.pages);
+
+fail_pages_array_alloc:
+	gen_pool_free(ctx->pool, buf->drv_addr, size);
+
+gen_pool_alloc_fail:
+	kfree(buf);
+	return NULL;
+}
+
+static void vb2_dma_iommu_put(void *buf_priv)
+{
+	struct vb2_dma_iommu_buf *buf = buf_priv;
+	int i;
+	unsigned long tmp;
+
+	if (atomic_dec_and_test(&buf->refcount)) {
+		tmp = buf->drv_addr;
+		printk(KERN_DEBUG "%s: Releasing buffer of %d pages @0x%lx\n",
+		       __func__, buf->info.num_pages, buf->drv_addr);
+		for (i = 0; i < buf->info.num_pages; tmp += PAGE_SIZE, ++i)
+			iommu_unmap(buf->ctx->domain, tmp, 0);
+
+		i = buf->info.num_pages;
+		if (buf->vaddr)
+			vm_unmap_ram((void *)buf->vaddr, buf->info.num_pages);
+		while (--i >= 0)
+			__free_page(buf->info.pages[i]);
+		kfree(buf->info.pages);
+		gen_pool_free(buf->ctx->pool, buf->drv_addr, buf->info.size);
+		kfree(buf);
+	}
+}
+
+static void *vb2_dma_iommu_get_userptr(void *alloc_ctx, unsigned long vaddr,
+				    unsigned long size, int write)
+{
+	struct vb2_dma_iommu_alloc_ctx *ctx = alloc_ctx;
+	struct vb2_dma_iommu_buf *buf;
+	unsigned long first, last, tmp, tmp_phys;
+	int num_pages_from_user, ret;
+	void *rv = NULL;
+	int i = 0;
+
+	BUG_ON(NULL == alloc_ctx);
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return rv;
+
+	buf->drv_addr = gen_pool_alloc(ctx->pool, size);
+	if (0 == buf->drv_addr) {
+		rv = ERR_PTR(-ENOMEM);
+		goto userptr_gen_pool_alloc_fail;
+	}
+
+	buf->write = write;
+	buf->offset = vaddr & ~PAGE_MASK;
+	buf->info.size = size;
+	first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
+	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
+	buf->info.num_pages = last - first + 1;
+	buf->ctx = ctx;
+	buf->info.pages = kzalloc(buf->info.num_pages * sizeof(struct page *),
+				  GFP_KERNEL);
+	if (!buf->info.pages) {
+		rv = ERR_PTR(-ENOMEM);
+		goto userptr_fail_pages_array_alloc;
+	}
+
+	num_pages_from_user = vb2_get_user_pages(vaddr, buf->info.num_pages,
+						 buf->info.pages, write,
+						 &buf->vma);
+
+	tmp = buf->drv_addr;
+	if (num_pages_from_user == buf->info.num_pages) {
+		printk(KERN_DEBUG "%s: Map buffer of %d pages @0x%lx\n",
+		       __func__ , buf->info.num_pages, buf->drv_addr);
+		for (i = 0; i < buf->info.num_pages; tmp += PAGE_SIZE, ++i) {
+			ret = iommu_map(ctx->domain, tmp,
+					page_to_phys(buf->info.pages[i]), 0, 0);
+			if (ret)
+				goto userptr_fail_map_area;
+		}
+
+		return buf;
+	} else if (num_pages_from_user < 0) {
+		struct vm_area_struct *vma;
+		dma_addr_t paddr = 0;
+
+		ret = vb2_get_contig_userptr(vaddr, size, &vma, &paddr);
+
+		if (ret) {
+			rv = ERR_PTR(ret);
+			goto userptr_fail_get_contig;
+		}
+
+		buf->vma = vma;
+		buf->contig = true;
+
+		tmp_phys = paddr;
+		printk(KERN_DEBUG "%s: Map buffer of %d pages @0x%lx\n",
+		       __func__ , buf->info.num_pages, buf->drv_addr);
+		for (i = 0; i < buf->info.num_pages; tmp += PAGE_SIZE,
+						tmp_phys += PAGE_SIZE, ++i) {
+			iommu_map(ctx->domain, tmp, tmp_phys, 0, 0);
+			if (ret)
+				goto userptr_fail_map_area;
+		}
+
+		return buf;
+	}
+	/* else fail */
+
+userptr_fail_map_area:
+	tmp -= PAGE_SIZE;
+	while (--i >= 0) {
+		iommu_unmap(ctx->domain, tmp, 0);
+		tmp -= PAGE_SIZE;
+	}
+	while (--num_pages_from_user >= 0)
+		put_page(buf->info.pages[num_pages_from_user]);
+	if (buf->vma)
+		vb2_put_vma(buf->vma);
+userptr_fail_get_contig:
+	kfree(buf->info.pages);
+
+userptr_fail_pages_array_alloc:
+	gen_pool_free(ctx->pool, buf->drv_addr, size);
+
+userptr_gen_pool_alloc_fail:
+	kfree(buf);
+	return rv;
+}
+
+/*
+ * @put_userptr: inform the allocator that a USERPTR buffer will no longer
+ *		 be used
+ */
+static void vb2_dma_iommu_put_userptr(void *buf_priv)
+{
+	struct vb2_dma_iommu_buf *buf = buf_priv;
+	int i = buf->info.num_pages;
+	unsigned long tmp;
+
+	printk(KERN_DEBUG "%s: Releasing buffer of %d pages @0x%lx\n",
+	       __func__, buf->info.num_pages, buf->drv_addr);
+	if (buf->vaddr)
+		vm_unmap_ram((void *)buf->vaddr, buf->info.num_pages);
+
+	tmp = buf->drv_addr;
+	for (i = 0; i < buf->info.num_pages; tmp += PAGE_SIZE, ++i)
+		iommu_unmap(buf->ctx->domain, tmp, 0);
+
+	i = buf->info.num_pages;
+
+	if (buf->vma)
+		vb2_put_vma(buf->vma);
+	if (!buf->contig) {
+		while (--i >= 0) {
+			if (buf->write)
+				set_page_dirty_lock(buf->info.pages[i]);
+			put_page(buf->info.pages[i]);
+		}
+	}
+	kfree(buf->info.pages);
+	gen_pool_free(buf->ctx->pool, buf->drv_addr, buf->info.size);
+	kfree(buf);
+}
+
+static void *vb2_dma_iommu_vaddr(void *buf_priv)
+{
+	struct vb2_dma_iommu_buf *buf = buf_priv;
+
+	BUG_ON(!buf);
+
+	if (!buf->vaddr)
+		buf->vaddr = (unsigned long)vm_map_ram(buf->info.pages,
+					buf->info.num_pages,
+					-1,
+					pgprot_writecombine(PAGE_KERNEL));
+
+	/* add offset in case userptr is not page-aligned */
+	return (void *)(buf->vaddr + buf->offset);
+}
+
+static unsigned int vb2_dma_iommu_num_users(void *buf_priv)
+{
+	struct vb2_dma_iommu_buf *buf = buf_priv;
+
+	return atomic_read(&buf->refcount);
+}
+
+static int vb2_dma_iommu_mmap(void *buf_priv, struct vm_area_struct *vma)
+{
+	struct vb2_dma_iommu_buf *buf = buf_priv;
+	int ret;
+
+	if (!buf) {
+		printk(KERN_ERR "No memory to map\n");
+		return -EINVAL;
+	}
+
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+
+	ret = vb2_insert_pages(vma, buf->info.pages);
+	if (ret)
+		return ret;
+
+	/*
+	 * Use common vm_area operations to track buffer refcount.
+	 */
+	vma->vm_private_data	= &buf->handler;
+	vma->vm_ops		= &vb2_common_vm_ops;
+
+	vma->vm_ops->open(vma);
+
+	return 0;
+}
+
+static void *vb2_dma_iommu_cookie(void *buf_priv)
+{
+	struct vb2_dma_iommu_buf *buf = buf_priv;
+
+	return (void *)buf->drv_addr + buf->offset;
+}
+
+const struct vb2_mem_ops vb2_dma_iommu_memops = {
+	.alloc		= vb2_dma_iommu_alloc,
+	.put		= vb2_dma_iommu_put,
+	.get_userptr	= vb2_dma_iommu_get_userptr,
+	.put_userptr	= vb2_dma_iommu_put_userptr,
+	.vaddr		= vb2_dma_iommu_vaddr,
+	.mmap		= vb2_dma_iommu_mmap,
+	.num_users	= vb2_dma_iommu_num_users,
+	.cookie		= vb2_dma_iommu_cookie,
+};
+EXPORT_SYMBOL_GPL(vb2_dma_iommu_memops);
+
+void *vb2_dma_iommu_init(struct device *dev, struct device *iommu_dev,
+			 struct vb2_dma_iommu_request *iommu_req)
+{
+	struct vb2_dma_iommu_alloc_ctx *ctx;
+	unsigned long mem_base, mem_size;
+	int align_order;
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	align_order = VB2_DMA_IOMMU_PIECE_ORDER;
+	mem_base = VB2_DMA_IOMMU_MEM_BASE;
+	mem_size = VB2_DMA_IOMMU_MEM_SIZE;
+
+	if (iommu_req) {
+		if (iommu_req->align_order)
+			align_order = iommu_req->align_order;
+		if (iommu_req->mem_base)
+			mem_base = iommu_req->mem_base;
+		if (iommu_req->mem_size)
+			mem_size = iommu_req->mem_size;
+	}
+
+	ctx->pool = gen_pool_create(align_order, VB2_DMA_IOMMU_NODE_ID);
+
+	if (!ctx->pool)
+		goto pool_alloc_fail;
+
+	if (gen_pool_add(ctx->pool, mem_base, mem_size, VB2_DMA_IOMMU_NODE_ID))
+		goto chunk_add_fail;
+
+	ctx->domain = iommu_domain_alloc();
+	if (!ctx->domain) {
+		dev_err(dev, "IOMMU domain alloc failed\n");
+		goto chunk_add_fail;
+	}
+
+	ctx->dev = iommu_dev;
+
+	return ctx;
+
+chunk_add_fail:
+	gen_pool_destroy(ctx->pool);
+pool_alloc_fail:
+	kfree(ctx);
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL_GPL(vb2_dma_iommu_init);
+
+void vb2_dma_iommu_cleanup(void *alloc_ctx)
+{
+	struct vb2_dma_iommu_alloc_ctx *ctx = alloc_ctx;
+
+	BUG_ON(NULL == alloc_ctx);
+
+	iommu_domain_free(ctx->domain);
+	gen_pool_destroy(ctx->pool);
+	kfree(alloc_ctx);
+}
+EXPORT_SYMBOL_GPL(vb2_dma_iommu_cleanup);
+
+int vb2_dma_iommu_enable(void *alloc_ctx)
+{
+	struct vb2_dma_iommu_alloc_ctx *ctx = alloc_ctx;
+
+	BUG_ON(NULL == alloc_ctx);
+
+	return iommu_attach_device(ctx->domain, ctx->dev);
+}
+EXPORT_SYMBOL_GPL(vb2_dma_iommu_enable);
+
+int vb2_dma_iommu_disable(void *alloc_ctx)
+{
+	struct vb2_dma_iommu_alloc_ctx *ctx = alloc_ctx;
+
+	BUG_ON(NULL == alloc_ctx);
+
+	iommu_detach_device(ctx->domain, ctx->dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_dma_iommu_disable);
+
+MODULE_DESCRIPTION("iommu memory handling routines for videobuf2");
+MODULE_AUTHOR("Andrzej Pietrasiewicz");
+MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-dma-iommu.h b/include/media/videobuf2-dma-iommu.h
new file mode 100644
index 0000000..02d3b14
--- /dev/null
+++ b/include/media/videobuf2-dma-iommu.h
@@ -0,0 +1,48 @@
+/*
+ * videobuf2-dma-iommu.h - IOMMU based memory allocator for videobuf2
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ *
+ * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _MEDIA_VIDEOBUF2_DMA_IOMMU_H
+#define _MEDIA_VIDEOBUF2_DMA_IOMMU_H
+
+#include <media/videobuf2-core.h>
+
+struct device;
+
+struct vb2_dma_iommu_request {
+	/* mem_base and mem_size both 0 => use allocator's default */
+	unsigned long		mem_base;
+	unsigned long		mem_size;
+	/*
+	 * align_order 0 => use allocator's default
+	 * 0 < align_order < PAGE_SHIFT => rounded to PAGE_SHIFT by allocator
+	 */
+	int			align_order;
+};
+
+static inline unsigned long vb2_dma_iommu_plane_addr(
+		struct vb2_buffer *vb, unsigned int plane_no)
+{
+	return (unsigned long)vb2_plane_cookie(vb, plane_no);
+}
+
+extern const struct vb2_mem_ops vb2_dma_iommu_memops;
+
+void *vb2_dma_iommu_init(struct device *dev, struct device *iommu_dev,
+			 struct vb2_dma_iommu_request *req);
+
+void vb2_dma_iommu_cleanup(void *alloc_ctx);
+
+int vb2_dma_iommu_enable(void *alloc_ctx);
+
+int vb2_dma_iommu_disable(void *alloc_ctx);
+
+#endif
-- 
1.7.1.569.g6f426
