Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22339 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759289Ab1CDJBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 04:01:30 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 04 Mar 2011 10:01:11 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 4/7] v4l: videobuf2: add Samsung SYSMMU (IOMMU) based allocator
In-reply-to: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
To: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, andrzej.p@samsung.com,
	t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Message-id: <1299229274-9753-5-git-send-email-m.szyprowski@samsung.com>
References: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

This patch adds new videobuf2 memory allocator dedicated to Samsung SoC
series with IOMMU module. It requires s5p-sysmmu low level driver for
controlling iommu. This allocator aquires memory with standard
alloc_page() call and doesn't suffer from memory fragmentation issues.
Curretnly it supports only iommu module on Sasmung S5PV310 SoC series.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/Kconfig               |    8 +-
 drivers/media/video/Makefile              |    1 +
 drivers/media/video/videobuf2-s5p-iommu.c |  444 +++++++++++++++++++++++++++++
 include/media/videobuf2-s5p-iommu.h       |   50 ++++
 4 files changed, 502 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-s5p-iommu.c
 create mode 100644 include/media/videobuf2-s5p-iommu.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index e2f5a69..9806505 100644
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
+config VIDEOBUF2_S5P_IOMMU
+	select GENERIC_ALLOCATOR
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
+
 #
 # Multimedia Video device configuration
 #
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index ac54652..fd9488d 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -118,6 +118,7 @@ obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG)	+= videobuf2-dma-contig.o
 obj-$(CONFIG_VIDEOBUF2_DMA_SG)		+= videobuf2-dma-sg.o
+obj-$(CONFIG_VIDEOBUF2_S5P_IOMMU)	+= videobuf2-s5p-iommu.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
diff --git a/drivers/media/video/videobuf2-s5p-iommu.c b/drivers/media/video/videobuf2-s5p-iommu.c
new file mode 100644
index 0000000..5826fe0
--- /dev/null
+++ b/drivers/media/video/videobuf2-s5p-iommu.c
@@ -0,0 +1,444 @@
+/*
+ * videobuf2-s5p-iommu.c - SYSMMU (IOMMU) based memory allocator for videobuf2
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
+#include <asm/cacheflush.h>
+#include <asm/page.h>
+
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-memops.h>
+#include <media/videobuf2-s5p-iommu.h>
+
+/*
+ * 17: single piece of memory (one bitmap entry) equals 128k,
+ * so by default the genalloc's bitmap occupies 4kB (one page
+ * for a number of architectures)
+ */
+#define VB2_S5P_IOMMU_PIECE_ORDER	17
+
+/* -1: use default node id to allocate gen_pool/gen_pool_chunk structure from */
+#define VB2_S5P_IOMMU_NODE_ID		-1
+
+/*
+ * starting address of the virtual address space of the client device
+ * must not be zero
+ */
+#define VB2_S5P_IOMMU_MEM_BASE		0x30000000
+
+/* size of the virtual address space of the client device */
+#define VB2_S5P_IOMMU_MEM_SIZE		0x40000000
+
+struct vb2_s5p_iommu_alloc_ctx {
+	/* not interpreted here; only passed to the sysmmu driver */
+	void *sysmmu;
+
+	struct gen_pool *pool;
+};
+
+struct vb2_s5p_iommu_desc {
+	unsigned long		size;
+	unsigned int		num_pages;
+	struct page		**pages;
+};
+
+struct vb2_s5p_iommu_buf {
+	unsigned long			drv_addr;
+	unsigned long			vaddr;
+
+	struct vb2_s5p_iommu_desc	info;
+	int				offset;
+	atomic_t			refcount;
+	int				write;
+	struct vm_area_struct		*vma;
+
+	struct vb2_vmarea_handler	handler;
+
+	struct vb2_s5p_iommu_alloc_ctx	*ctx;
+};
+
+static void vb2_s5p_iommu_put(void *buf_priv);
+
+static void *vb2_s5p_iommu_alloc(void *alloc_ctx, unsigned long size)
+{
+	struct vb2_s5p_iommu_alloc_ctx *ctx = alloc_ctx;
+	struct vb2_s5p_iommu_buf *buf;
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
+	buf->handler.put = vb2_s5p_iommu_put;
+	buf->handler.arg = buf;
+
+	atomic_inc(&buf->refcount);
+
+	ret = s5p_sysmmu_map_area(ctx->sysmmu, buf->drv_addr,
+		buf->info.num_pages, buf->info.pages);
+
+	if (ret < 0)
+		goto fail_sysmmu_map_area;
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
+fail_sysmmu_map_area:
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
+static void vb2_s5p_iommu_put(void *buf_priv)
+{
+	struct vb2_s5p_iommu_buf *buf = buf_priv;
+	int i = buf->info.num_pages;
+
+	if (atomic_dec_and_test(&buf->refcount)) {
+		s5p_sysmmu_unmap_area(buf->ctx->sysmmu, buf->drv_addr,
+				      buf->info.num_pages);
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
+static void *vb2_s5p_iommu_get_userptr(void *alloc_ctx, unsigned long vaddr,
+				    unsigned long size, int write)
+{
+	struct vb2_s5p_iommu_alloc_ctx *ctx = alloc_ctx;
+	struct vb2_s5p_iommu_buf *buf;
+	unsigned long first, last;
+	int num_pages_from_user, ret;
+	void *rv = NULL;
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
+	down_read(&current->mm->mmap_sem);
+	num_pages_from_user = get_user_pages(current, current->mm,
+					     vaddr & PAGE_MASK,
+					     buf->info.num_pages,
+					     write,
+					     1, /* force */
+					     buf->info.pages,
+					     NULL);
+	up_read(&current->mm->mmap_sem);
+
+	if (num_pages_from_user == buf->info.num_pages) {
+		ret = s5p_sysmmu_map_area(ctx->sysmmu, buf->drv_addr,
+			buf->info.num_pages, buf->info.pages);
+
+		if (ret)
+			goto userptr_fail_sysmmu_map_area;
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
+
+		ret = s5p_sysmmu_map_phys_area(ctx->sysmmu, buf->drv_addr,
+					       paddr, buf->info.num_pages);
+		if (ret)
+			goto userptr_fail_sysmmu_map_area;
+
+		return buf;
+	}
+	/* else fail */
+
+userptr_fail_sysmmu_map_area:
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
+static void vb2_s5p_iommu_put_userptr(void *buf_priv)
+{
+	struct vb2_s5p_iommu_buf *buf = buf_priv;
+	int i = buf->info.num_pages;
+
+	printk(KERN_DEBUG "%s: Releasing userspace buffer of %d pages\n",
+	       __func__, buf->info.num_pages);
+	if (buf->vaddr)
+		vm_unmap_ram((void *)buf->vaddr, buf->info.num_pages);
+	s5p_sysmmu_unmap_area(buf->ctx->sysmmu, buf->drv_addr,
+			      buf->info.num_pages);
+	if (buf->vma) {
+		vb2_put_vma(buf->vma);
+	} else {
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
+static void *vb2_s5p_iommu_vaddr(void *buf_priv)
+{
+	struct vb2_s5p_iommu_buf *buf = buf_priv;
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
+static unsigned int vb2_s5p_iommu_num_users(void *buf_priv)
+{
+	struct vb2_s5p_iommu_buf *buf = buf_priv;
+
+	return atomic_read(&buf->refcount);
+}
+
+static int vb2_s5p_iommu_mmap(void *buf_priv, struct vm_area_struct *vma)
+{
+	struct vb2_s5p_iommu_buf *buf = buf_priv;
+	unsigned long uaddr = vma->vm_start;
+	unsigned long usize = vma->vm_end - vma->vm_start;
+	int i = 0;
+
+	if (!buf) {
+		printk(KERN_ERR "No memory to map\n");
+		return -EINVAL;
+	}
+
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	do {
+		int ret;
+
+		ret = vm_insert_page(vma, uaddr, buf->info.pages[i++]);
+		if (ret) {
+			printk(KERN_ERR "Remapping memory, error: %d\n", ret);
+			return ret;
+		}
+
+		uaddr += PAGE_SIZE;
+		usize -= PAGE_SIZE;
+	} while (usize > 0);
+
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
+static void *vb2_s5p_iommu_cookie(void *buf_priv)
+{
+	struct vb2_s5p_iommu_buf *buf = buf_priv;
+
+	return (void *)buf->drv_addr + buf->offset;
+}
+
+const struct vb2_mem_ops vb2_s5p_iommu_memops = {
+	.alloc		= vb2_s5p_iommu_alloc,
+	.put		= vb2_s5p_iommu_put,
+	.get_userptr	= vb2_s5p_iommu_get_userptr,
+	.put_userptr	= vb2_s5p_iommu_put_userptr,
+	.vaddr		= vb2_s5p_iommu_vaddr,
+	.mmap		= vb2_s5p_iommu_mmap,
+	.num_users	= vb2_s5p_iommu_num_users,
+	.cookie		= vb2_s5p_iommu_cookie,
+};
+EXPORT_SYMBOL_GPL(vb2_s5p_iommu_memops);
+
+void
+*vb2_s5p_iommu_init(struct device *dev, struct vb2_s5p_iommu_request *iommu_req)
+{
+	struct vb2_s5p_iommu_alloc_ctx *ctx;
+	unsigned long mem_base, mem_size;
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	if (iommu_req->align_order && iommu_req->align_order < PAGE_SHIFT)
+		iommu_req->align_order = PAGE_SHIFT;
+
+	ctx->pool = gen_pool_create(
+		iommu_req->align_order ? iommu_req->align_order :
+		VB2_S5P_IOMMU_PIECE_ORDER,
+		VB2_S5P_IOMMU_NODE_ID);
+
+	if (!ctx->pool)
+		goto pool_alloc_fail;
+
+	if (0 == iommu_req->mem_base && 0 == iommu_req->mem_size) {
+		mem_base = VB2_S5P_IOMMU_MEM_BASE;
+		mem_size = VB2_S5P_IOMMU_MEM_SIZE;
+	} else {
+		mem_base = iommu_req->mem_base;
+		mem_size = iommu_req->mem_size;
+	}
+
+	if (gen_pool_add(ctx->pool, mem_base, mem_size, VB2_S5P_IOMMU_NODE_ID))
+		goto chunk_add_fail;
+
+	ctx->sysmmu = s5p_sysmmu_get(dev, iommu_req->ip);
+	if (!ctx->sysmmu) {
+		dev_err(dev, "SYSMMU get failed\n");
+		goto chunk_add_fail;
+	}
+
+	return ctx;
+
+chunk_add_fail:
+	gen_pool_destroy(ctx->pool);
+pool_alloc_fail:
+	kfree(ctx);
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL_GPL(vb2_s5p_iommu_init);
+
+void vb2_s5p_iommu_cleanup(void *alloc_ctx)
+{
+	struct vb2_s5p_iommu_alloc_ctx *ctx = alloc_ctx;
+
+	BUG_ON(NULL == alloc_ctx);
+
+	s5p_sysmmu_put(ctx->sysmmu);
+
+	gen_pool_destroy(ctx->pool);
+
+	kfree(alloc_ctx);
+}
+EXPORT_SYMBOL_GPL(vb2_s5p_iommu_cleanup);
+
+int vb2_s5p_iommu_enable(void *alloc_ctx)
+{
+	struct vb2_s5p_iommu_alloc_ctx *ctx = alloc_ctx;
+
+	BUG_ON(NULL == alloc_ctx);
+
+	return s5p_sysmmu_control(ctx->sysmmu, S5P_SYSMMU_ENABLE_PRIVATE);
+}
+EXPORT_SYMBOL_GPL(vb2_s5p_iommu_enable);
+
+int vb2_s5p_iommu_disable(void *alloc_ctx)
+{
+	struct vb2_s5p_iommu_alloc_ctx *ctx = alloc_ctx;
+
+	BUG_ON(NULL == alloc_ctx);
+
+	return s5p_sysmmu_control(ctx->sysmmu, S5P_SYSMMU_DISABLE);
+}
+EXPORT_SYMBOL_GPL(vb2_s5p_iommu_disable);
+
+MODULE_DESCRIPTION("s5p iommu memory handling routines for videobuf2");
+MODULE_AUTHOR("Andrzej Pietrasiewicz");
+MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-s5p-iommu.h b/include/media/videobuf2-s5p-iommu.h
new file mode 100644
index 0000000..5bad763
--- /dev/null
+++ b/include/media/videobuf2-s5p-iommu.h
@@ -0,0 +1,50 @@
+/*
+ * videobuf2-s5p-iommu.h - SYSMMU (IOMMU)-based memory allocator for videobuf2
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
+#ifndef _MEDIA_VIDEOBUF2_S5P_IOMMU_H
+#define _MEDIA_VIDEOBUF2_S5P_IOMMU_H
+
+#include <media/videobuf2-core.h>
+#include <plat/sysmmu.h>
+
+struct device;
+
+struct vb2_s5p_iommu_request {
+	/* mem_base and mem_size both 0 => use allocator's default */
+	unsigned long		mem_base;
+	unsigned long		mem_size;
+	enum s5p_sysmmu_ip	ip;
+	/*
+	 * align_order 0 => use allocator's default
+	 * 0 < align_order < PAGE_SHIFT => rounded to PAGE_SHIFT by allocator
+	 */
+	int			align_order;
+};
+
+static inline unsigned long vb2_s5p_iommu_plane_addr(
+		struct vb2_buffer *vb, unsigned int plane_no)
+{
+	return (unsigned long)vb2_plane_cookie(vb, plane_no);
+}
+
+extern const struct vb2_mem_ops vb2_s5p_iommu_memops;
+
+void *vb2_s5p_iommu_init(struct device *dev,
+			 struct vb2_s5p_iommu_request *iommu_req);
+
+void vb2_s5p_iommu_cleanup(void *alloc_ctx);
+
+int vb2_s5p_iommu_enable(void *alloc_ctx);
+
+int vb2_s5p_iommu_disable(void *alloc_ctx);
+
+#endif
-- 
1.7.1.569.g6f426
