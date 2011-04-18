Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27329 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab1DRJ0y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 05:26:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 18 Apr 2011 11:26:41 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 4/7] v4l: videobuf2: add IOMMU based DMA memory allocator
In-reply-to: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Pietrasiwiecz <andrzej.p@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Kukjin Kim <kgene.kim@samsung.com>
Message-id: <1303118804-5575-5-git-send-email-m.szyprowski@samsung.com>
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

This patch adds new videobuf2 memory allocator dedicated to devices that
supports IOMMU DMA mappings. A device with IOMMU module and a driver
with include/iommu.h compatible interface is required. This allocator
aquires memory with standard alloc_page() call and doesn't suffer from
memory fragmentation issues. The allocator support following page sizes:
4KiB, 64KiB, 1MiB and 16MiB to reduce iommu translation overhead.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/Kconfig               |    8 +-
 drivers/media/video/Makefile              |    1 +
 drivers/media/video/videobuf2-dma-iommu.c |  762 +++++++++++++++++++++++++++++
 include/media/videobuf2-dma-iommu.h       |   48 ++
 4 files changed, 818 insertions(+), 1 deletions(-)
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
index 0000000..7ccb51a
--- /dev/null
+++ b/drivers/media/video/videobuf2-dma-iommu.c
@@ -0,0 +1,762 @@
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
+	struct device		*dev;
+	struct gen_pool		*pool;
+	unsigned int		order;
+	struct iommu_domain	*domain;
+};
+
+struct vb2_dma_iommu_desc {
+	unsigned long		size;
+	unsigned int		num_pages;
+	struct page		**pages;
+	unsigned long		*pg_map;
+	bool			contig;
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
+
+	struct vb2_vmarea_handler	handler;
+
+	struct vb2_dma_iommu_alloc_ctx	*ctx;
+};
+
+#define pages_4k(size) \
+			(((size) + PAGE_SIZE - 1) >> PAGE_SHIFT)
+
+#define pages_order(size, order) \
+			((pages_4k(size) >> (order)) & 0xF)
+
+#define for_each_compound_page(bitmap, size, idx) \
+			for ((idx) = find_first_bit((bitmap), (size)); \
+			     (idx) < (size); \
+			     (idx) = find_next_bit((bitmap), (size), (idx) + 1))
+
+static int vb2_dma_iommu_max_order(unsigned long size)
+{
+	if ((size & 0xFFFF) == size) /* < 64k */
+		return 0;
+	if ((size & 0xFFFFF) == size) /* < 1M */
+		return 4;
+	if ((size & 0xFFFFFF) == size) /* < 16M */
+		return 8;
+	return 12; /* >= 16M */
+}
+
+/*
+ * num_pg must be 1, 16, 256 or 4096
+ */
+static int vb2_dma_iommu_pg_order(int num_pg)
+{
+	if (num_pg & 0x1)
+		return 0;
+	if (num_pg & 0x10)
+		return 4;
+	if (num_pg & 0x100)
+		return 8;
+	return 12;
+}
+
+/*
+ * size must be multiple of PAGE_SIZE
+ */
+static int vb2_dma_iommu_get_pages(struct vb2_dma_iommu_desc *desc,
+				   unsigned long size)
+{
+	int order, num_pg_order, curr_4k_page, bit, max_order_ret;
+	unsigned long curr_size;
+
+	curr_4k_page = 0;
+	max_order_ret = 0;
+	curr_size = size; /* allocate (compound) pages until nothing remains */
+
+	order = vb2_dma_iommu_max_order(curr_size);
+	num_pg_order = pages_order(curr_size, order);
+
+	while (curr_size > 0 && order >= 0) {
+		int i, max_order;
+
+		printk(KERN_DEBUG "%s %d page(s) of %d order\n", __func__,
+		       num_pg_order, order);
+
+		for (i = 0; i < num_pg_order; ++i) {
+			struct page *pg;
+			int j, compound_sz;
+
+			pg = alloc_pages(GFP_KERNEL | __GFP_ZERO | __GFP_COMP,
+					 order);
+			if (!pg)
+				break;
+
+
+			if (order > max_order_ret)
+				max_order_ret = order;
+
+			compound_sz = 0x1 << order;
+			/* need to zero bitmap parts only for orders > 0 */
+			if (order)
+				bitmap_clear(desc->pg_map, curr_4k_page + 1,
+					     compound_sz - 1);
+			for (j = 0; j < compound_sz; ++j)
+				desc->pages[curr_4k_page + j] = (pg + j);
+			curr_4k_page += compound_sz;
+		}
+		/*
+		 * after the above for ends either way (loop condition not
+		 * fulfilled/break) the i contains number of (compound) pages
+		 * we managed to allocate
+		 */
+		curr_size -= i * (PAGE_SIZE << order);
+		max_order = vb2_dma_iommu_max_order(curr_size);
+		/*
+		 * max_order >= current order means that some allocations
+		 * with order >= current order have failed, so we cannot attempt
+		 * any greater orders again, we need to try an order smaller
+		 * than the current order instead
+		 */
+		if (max_order >= order)
+			max_order = order - 4;
+		order = max_order;
+		num_pg_order = pages_order(curr_size, order);
+	}
+
+	if (curr_size != 0)
+		goto get_pages_rollback;
+
+	return max_order_ret;
+
+get_pages_rollback:
+	for_each_compound_page(desc->pg_map, curr_4k_page, bit) {
+		int next_bit;
+
+		next_bit = find_next_bit(desc->pg_map, curr_4k_page, bit + 1);
+		order = vb2_dma_iommu_pg_order(next_bit - bit);
+		__free_pages(desc->pages[bit], order);
+	}
+
+	return -1;
+}
+
+static int vb2_dma_iommu_pg_sizes(struct vb2_dma_iommu_desc *desc)
+{
+	int i, order, max_order;
+
+	i = 0;
+	/* max order is 12, set to something greater */
+	order = 12 + 1;
+	max_order = 0;
+	while (i < desc->num_pages) {
+		unsigned long first, curr, next, curr_size;
+		int adjacent, j, new_order, num_pg_order;
+
+		first = 0;
+		j = i;
+		if (desc->contig) {
+			first = page_to_phys(desc->pages[0]);
+			adjacent = desc->num_pages;
+		} else {
+			curr = page_to_phys(desc->pages[i]);
+			if (order > 12)
+				first = curr;
+			while (++j < desc->num_pages) {
+				next = page_to_phys(desc->pages[j]);
+				if (curr + PAGE_SIZE != next)
+					break;
+				curr = next;
+			}
+			adjacent = j - i;
+		}
+		curr_size = adjacent << PAGE_SHIFT;
+		new_order = vb2_dma_iommu_max_order(curr_size);
+		/*
+		 * by design decision max order in a sequence of blocks of
+		 * zero-order pages must be monotonicaly decreasing
+		 */
+		if (new_order > order) {
+			bitmap_fill(desc->pg_map, desc->num_pages);
+			return 0;
+		}
+		/*
+		 * by design decision the first compound page of the buffer
+		 * must be aligned according to its size
+		 */
+		if (order > 12)
+			if (first & ((PAGE_SIZE << new_order) - 1)) {
+				bitmap_fill(desc->pg_map, desc->num_pages);
+				return 0;
+			}
+		order = new_order;
+		if (order > max_order)
+			max_order = order;
+		num_pg_order = pages_order(curr_size, order);
+		while (curr_size > 0) {
+			int compound_sz;
+
+			printk(KERN_DEBUG "%s %d page(s) of %d order\n",
+			       __func__, num_pg_order, order);
+			compound_sz = 0x1 << order;
+			/* need to zero bitmap parts only for orders > 0 */
+			if (order)
+				for (j = 0; j < num_pg_order; ++j)
+					bitmap_clear(desc->pg_map,
+						     i + j * compound_sz + 1,
+						     compound_sz - 1);
+			i += num_pg_order * compound_sz;
+			curr_size -= num_pg_order * (PAGE_SIZE << order);
+			if (curr_size) {
+				order = vb2_dma_iommu_max_order(curr_size);
+				num_pg_order = pages_order(curr_size, order);
+			}
+		}
+	}
+	return max_order;
+}
+
+static int vb2_dma_iommu_map(struct iommu_domain *domain,
+			     unsigned long drv_addr,
+			     struct vb2_dma_iommu_desc *desc)
+{
+	int i, j, ret, order;
+	unsigned long pg_addr;
+
+	pg_addr = drv_addr;
+	ret = 0;
+	for_each_compound_page(desc->pg_map, desc->num_pages, i) {
+		int next_bit;
+		unsigned long paddr, compound_sz;
+
+		next_bit = find_next_bit(desc->pg_map, desc->num_pages, i + 1);
+		order = vb2_dma_iommu_pg_order(next_bit - i);
+		compound_sz = 0x1 << order << PAGE_SHIFT;
+		paddr = page_to_phys(desc->pages[i]);
+		ret = iommu_map(domain, pg_addr, paddr, order, 0);
+		if (ret < 0)
+			goto fail_map_area;
+		pg_addr += compound_sz;
+	}
+
+	return ret;
+
+fail_map_area:
+	pg_addr = drv_addr;
+	for_each_compound_page(desc->pg_map, i, j) {
+		int next_bit;
+
+		next_bit = find_next_bit(desc->pg_map, i, j + 1);
+		order = vb2_dma_iommu_pg_order(next_bit - j);
+		iommu_unmap(domain, pg_addr, order);
+		pg_addr += 0x1 << order << PAGE_SHIFT;
+	}
+	return ret;
+}
+
+static void vb2_dma_iommu_unmap(struct iommu_domain *domain,
+			       unsigned long drv_addr,
+			       struct vb2_dma_iommu_desc *desc)
+{
+	int i;
+
+	for_each_compound_page(desc->pg_map, desc->num_pages, i) {
+		int next_bit, order;
+
+		next_bit = find_next_bit(desc->pg_map, desc->num_pages, i + 1);
+		order = vb2_dma_iommu_pg_order(next_bit - i);
+		iommu_unmap(domain, drv_addr, order);
+		drv_addr += 0x1 << order << PAGE_SHIFT;
+	}
+}
+
+static void vb2_dma_iommu_put(void *buf_priv);
+
+static void *vb2_dma_iommu_alloc(void *alloc_ctx, unsigned long size)
+{
+	struct vb2_dma_iommu_alloc_ctx *ctx = alloc_ctx;
+	struct vb2_dma_iommu_buf *buf;
+	unsigned long size_pg, pg_map_size;
+	int i, ret, max_order;
+	void *rv;
+
+	BUG_ON(NULL == alloc_ctx);
+
+	rv = NULL;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	buf->ctx = ctx;
+	buf->info.size = size;
+	buf->info.num_pages = size_pg = pages_4k(size);
+
+	buf->info.pages = kzalloc(size_pg * sizeof(struct page *), GFP_KERNEL);
+	if (!buf->info.pages) {
+		rv = ERR_PTR(-ENOMEM);
+		goto buf_alloc_rollback;
+	}
+
+	pg_map_size = BITS_TO_LONGS(size_pg) * sizeof(unsigned long);
+	buf->info.pg_map = kzalloc(pg_map_size, GFP_KERNEL);
+	if (!buf->info.pg_map) {
+		rv = ERR_PTR(-ENOMEM);
+		goto pg_array_alloc_rollback;
+	}
+	bitmap_fill(buf->info.pg_map, size_pg);
+
+	max_order = vb2_dma_iommu_get_pages(&buf->info, size_pg * PAGE_SIZE);
+	if (max_order < 0) {
+		rv = ERR_PTR(-ENOMEM);
+		goto pg_map_alloc_rollback;
+	}
+
+	/* max_order is for number of pages; order of bytes: += 12 */
+	max_order += PAGE_SHIFT;
+	/* we need to keep the contract of vb2_dma_iommu_request */
+	if (max_order < ctx->order)
+		max_order = ctx->order;
+	buf->drv_addr = gen_pool_alloc_aligned(ctx->pool, size, max_order);
+	if (0 == buf->drv_addr) {
+		rv = ERR_PTR(-ENOMEM);
+		goto pages_alloc_rollback;
+	}
+
+	buf->handler.refcount = &buf->refcount;
+	buf->handler.put = vb2_dma_iommu_put;
+	buf->handler.arg = buf;
+
+	atomic_inc(&buf->refcount);
+
+	printk(KERN_DEBUG
+	       "%s: Context 0x%lx mapping buffer of %d pages @0x%lx\n",
+	       __func__ , (unsigned long)ctx, buf->info.num_pages,
+	       buf->drv_addr);
+	ret = vb2_dma_iommu_map(ctx->domain, buf->drv_addr, &buf->info);
+	if (ret < 0) {
+		rv = ERR_PTR(ret);
+		goto gen_pool_alloc_rollback;
+	}
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
+gen_pool_alloc_rollback:
+	gen_pool_free(ctx->pool, buf->drv_addr, size);
+
+pages_alloc_rollback:
+	for_each_compound_page(buf->info.pg_map, buf->info.num_pages, i) {
+		int next_bit;
+
+		next_bit = find_next_bit(buf->info.pg_map, buf->info.num_pages,
+					 i + 1);
+		max_order = vb2_dma_iommu_pg_order(next_bit - i);
+		__free_pages(buf->info.pages[i], max_order);
+	}
+
+pg_map_alloc_rollback:
+	kfree(buf->info.pg_map);
+
+pg_array_alloc_rollback:
+	kfree(buf->info.pages);
+
+buf_alloc_rollback:
+	kfree(buf);
+	return rv;
+}
+
+static void vb2_dma_iommu_put(void *buf_priv)
+{
+	struct vb2_dma_iommu_buf *buf = buf_priv;
+
+	if (atomic_dec_and_test(&buf->refcount)) {
+		int i, order;
+
+		printk(KERN_DEBUG
+		"%s: Context 0x%lx releasing buffer of %d pages @0x%lx\n",
+		       __func__, (unsigned long)buf->ctx, buf->info.num_pages,
+		       buf->drv_addr);
+
+		vb2_dma_iommu_unmap(buf->ctx->domain, buf->drv_addr,
+				    &buf->info);
+		if (buf->vaddr)
+			vm_unmap_ram((void *)buf->vaddr, buf->info.num_pages);
+
+		gen_pool_free(buf->ctx->pool, buf->drv_addr, buf->info.size);
+		for_each_compound_page(buf->info.pg_map,
+				       buf->info.num_pages, i) {
+			int next_bit;
+
+			next_bit = find_next_bit(buf->info.pg_map,
+						 buf->info.num_pages, i + 1);
+			order = vb2_dma_iommu_pg_order(next_bit - i);
+			__free_pages(buf->info.pages[i], order);
+		}
+		kfree(buf->info.pg_map);
+		kfree(buf->info.pages);
+		kfree(buf);
+	}
+}
+
+static void *vb2_dma_iommu_get_userptr(void *alloc_ctx, unsigned long vaddr,
+				    unsigned long size, int write)
+{
+	struct vb2_dma_iommu_alloc_ctx *ctx = alloc_ctx;
+	struct vb2_dma_iommu_buf *buf;
+	unsigned long first, last, size_pg, pg_map_size;
+	int num_pages_from_user, max_order, ret;
+	void *rv;
+
+	BUG_ON(NULL == alloc_ctx);
+
+	rv = NULL;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	buf->ctx = ctx;
+	buf->info.size = size;
+	/*
+	 * Page numbers of the first and the last byte of the buffer
+	 */
+	first = vaddr >> PAGE_SHIFT;
+	last  = (vaddr + size - 1) >> PAGE_SHIFT;
+	buf->info.num_pages = size_pg = last - first + 1;
+	buf->offset = vaddr & ~PAGE_MASK;
+	buf->write = write;
+
+	buf->info.pages = kzalloc(size_pg * sizeof(struct page *), GFP_KERNEL);
+	if (!buf->info.pages) {
+		rv = ERR_PTR(-ENOMEM);
+		goto buf_alloc_rollback;
+	}
+
+	pg_map_size = BITS_TO_LONGS(size_pg) * sizeof(unsigned long);
+	buf->info.pg_map = kzalloc(pg_map_size, GFP_KERNEL);
+	if (!buf->info.pg_map) {
+		rv = ERR_PTR(-ENOMEM);
+		goto pg_array_alloc_rollback;
+	}
+	bitmap_fill(buf->info.pg_map, size_pg);
+
+	num_pages_from_user = vb2_get_user_pages(vaddr, buf->info.num_pages,
+						 buf->info.pages, write,
+						 &buf->vma);
+
+	/* do not accept partial success */
+	if (num_pages_from_user >= 0 && num_pages_from_user < size_pg) {
+		rv = ERR_PTR(-EFAULT);
+		goto get_user_pages_rollback;
+	}
+
+	if (num_pages_from_user < 0) {
+		struct vm_area_struct *vma;
+		int i;
+		dma_addr_t paddr;
+
+		paddr = 0;
+		ret = vb2_get_contig_userptr(vaddr, size, &vma, &paddr);
+		if (ret) {
+			rv = ERR_PTR(ret);
+			goto get_user_pages_rollback;
+		}
+
+		buf->vma = vma;
+		buf->info.contig = true;
+		paddr -= buf->offset;
+
+		for (i = 0; i < size_pg; paddr += PAGE_SIZE, ++i)
+			buf->info.pages[i] = phys_to_page(paddr);
+	}
+	max_order = vb2_dma_iommu_pg_sizes(&buf->info);
+
+	/* max_order is for number of pages; order of bytes: += 12 */
+	max_order += PAGE_SHIFT;
+	/* we need to keep the contract of vb2_dma_iommu_request */
+	if (max_order < ctx->order)
+		max_order = ctx->order;
+
+	buf->drv_addr = gen_pool_alloc_aligned(ctx->pool, size, max_order);
+	if (0 == buf->drv_addr) {
+		rv = ERR_PTR(-ENOMEM);
+		goto get_user_pages_rollback;
+	}
+	printk(KERN_DEBUG
+	"%s: Context 0x%lx mapping buffer of %ld user pages @0x%lx\n",
+	       __func__ , (unsigned long)ctx, size_pg, buf->drv_addr);
+	ret = vb2_dma_iommu_map(ctx->domain, buf->drv_addr, &buf->info);
+	if (ret < 0) {
+		rv = ERR_PTR(ret);
+		goto gen_pool_alloc_rollback;
+	}
+
+	return buf;
+
+gen_pool_alloc_rollback:
+	gen_pool_free(ctx->pool, buf->drv_addr, size);
+
+get_user_pages_rollback:
+	while (--num_pages_from_user >= 0)
+		put_page(buf->info.pages[num_pages_from_user]);
+	if (buf->vma)
+		vb2_put_vma(buf->vma);
+	kfree(buf->info.pg_map);
+
+pg_array_alloc_rollback:
+	kfree(buf->info.pages);
+
+buf_alloc_rollback:
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
+	int i;
+
+	printk(KERN_DEBUG
+	       "%s: Context 0x%lx releasing buffer of %d user pages @0x%lx\n",
+	       __func__, (unsigned long)buf->ctx, buf->info.num_pages,
+	       buf->drv_addr);
+	vb2_dma_iommu_unmap(buf->ctx->domain, buf->drv_addr, &buf->info);
+	if (buf->vaddr)
+		vm_unmap_ram((void *)buf->vaddr, buf->info.num_pages);
+
+	gen_pool_free(buf->ctx->pool, buf->drv_addr, buf->info.size);
+
+	if (buf->vma)
+		vb2_put_vma(buf->vma);
+
+	i = buf->info.num_pages;
+	if (!buf->info.contig) {
+		while (--i >= 0) {
+			if (buf->write)
+				set_page_dirty_lock(buf->info.pages[i]);
+			put_page(buf->info.pages[i]);
+		}
+	}
+	kfree(buf->info.pg_map);
+	kfree(buf->info.pages);
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
+					pgprot_dmacoherent(PAGE_KERNEL));
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
+	vma->vm_page_prot = pgprot_dmacoherent(vma->vm_page_prot);
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
+	ctx->order = align_order;
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
