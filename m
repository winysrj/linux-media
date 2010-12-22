Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28083 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab0LVOab (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 09:30:31 -0500
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LDU001V02YSG9@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 14:30:29 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDU006VF2YRVI@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 14:30:28 +0000 (GMT)
Date: Wed, 22 Dec 2010 15:30:15 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 11/13] v4l: videobuf2: add DMA scatter/gather allocator
In-reply-to: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	andrzej.p@samsung.com
Message-id: <1293028217-23151-2-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

Add an implementation of DMA scatter/gather allocator and handling
routines for videobuf2.

For mmap operation mode it is implemented on top of
alloc_page + sg_set_page/_free_page.

For userptr operation mode it is impelmented on top of
get_user_pages + sg_set_page/put_page.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/Kconfig            |    6 +
 drivers/media/video/Makefile           |    1 +
 drivers/media/video/videobuf2-dma-sg.c |  292 ++++++++++++++++++++++++++++++++
 include/media/videobuf2-dma-sg.h       |   32 ++++
 4 files changed, 331 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-dma-sg.c
 create mode 100644 include/media/videobuf2-dma-sg.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 4fa2c4c..d193125 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -65,6 +65,12 @@ config VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_MEMOPS
 	tristate
 
+
+config VIDEOBUF2_DMA_SG
+	#depends on HAS_DMA
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
 #
 # Multimedia Video device configuration
 #
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index d7137e9..af33c30 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -119,6 +119,7 @@ obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o
 obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG)	+= videobuf2-dma-contig.o
+obj-$(CONFIG_VIDEOBUF2_DMA_SG)		+= videobuf2-dma-sg.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
diff --git a/drivers/media/video/videobuf2-dma-sg.c b/drivers/media/video/videobuf2-dma-sg.c
new file mode 100644
index 0000000..20b5c5d
--- /dev/null
+++ b/drivers/media/video/videobuf2-dma-sg.c
@@ -0,0 +1,292 @@
+/*
+ * videobuf2-dma-sg.c - dma scatter/gather memory allocator for videobuf2
+ *
+ * Copyright (C) 2010 Samsung Electronics
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
+
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-memops.h>
+#include <media/videobuf2-dma-sg.h>
+
+struct vb2_dma_sg_buf {
+	void				*vaddr;
+	struct page			**pages;
+	int				write;
+	int				offset;
+	struct vb2_dma_sg_desc		sg_desc;
+	atomic_t			refcount;
+	struct vb2_vmarea_handler	handler;
+};
+
+static void vb2_dma_sg_put(void *buf_priv);
+
+static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size)
+{
+	struct vb2_dma_sg_buf *buf;
+	int i;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->vaddr = NULL;
+	buf->write = 0;
+	buf->offset = 0;
+	buf->sg_desc.size = size;
+	buf->sg_desc.num_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
+	buf->sg_desc.sglist = vmalloc(buf->sg_desc.num_pages *
+				      sizeof(*buf->sg_desc.sglist));
+	if (!buf->sg_desc.sglist)
+		goto fail_sglist_alloc;
+	memset(buf->sg_desc.sglist, 0, buf->sg_desc.num_pages *
+	       sizeof(*buf->sg_desc.sglist));
+	sg_init_table(buf->sg_desc.sglist, buf->sg_desc.num_pages);
+
+	buf->pages = kzalloc(buf->sg_desc.num_pages * sizeof(struct page *),
+			     GFP_KERNEL);
+	if (!buf->pages)
+		goto fail_pages_array_alloc;
+
+	for (i = 0; i < buf->sg_desc.num_pages; ++i) {
+		buf->pages[i] = alloc_page(GFP_KERNEL);
+		if (NULL == buf->pages[i])
+			goto fail_pages_alloc;
+		sg_set_page(&buf->sg_desc.sglist[i],
+			    buf->pages[i], PAGE_SIZE, 0);
+	}
+
+	buf->handler.refcount = &buf->refcount;
+	buf->handler.put = vb2_dma_sg_put;
+	buf->handler.arg = buf;
+
+	atomic_inc(&buf->refcount);
+
+	printk(KERN_DEBUG "%s: Allocated buffer of %d pages\n",
+		__func__, buf->sg_desc.num_pages);
+
+	if (!buf->vaddr)
+		buf->vaddr = vm_map_ram(buf->pages,
+					buf->sg_desc.num_pages,
+					-1,
+					PAGE_KERNEL);
+	return buf;
+
+fail_pages_alloc:
+	while (--i >= 0)
+		__free_page(buf->pages[i]);
+
+fail_pages_array_alloc:
+	vfree(buf->sg_desc.sglist);
+
+fail_sglist_alloc:
+	kfree(buf);
+	return NULL;
+}
+
+static void vb2_dma_sg_put(void *buf_priv)
+{
+	struct vb2_dma_sg_buf *buf = buf_priv;
+	int i = buf->sg_desc.num_pages;
+
+	if (atomic_dec_and_test(&buf->refcount)) {
+		printk(KERN_DEBUG "%s: Freeing buffer of %d pages\n", __func__,
+			buf->sg_desc.num_pages);
+		if (buf->vaddr)
+			vm_unmap_ram(buf->vaddr, buf->sg_desc.num_pages);
+		vfree(buf->sg_desc.sglist);
+		while (--i >= 0)
+			__free_page(buf->pages[i]);
+		kfree(buf->pages);
+		kfree(buf);
+	}
+}
+
+static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
+				    unsigned long size, int write)
+{
+	struct vb2_dma_sg_buf *buf;
+	unsigned long first, last;
+	int num_pages_from_user, i;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->vaddr = NULL;
+	buf->write = write;
+	buf->offset = vaddr & ~PAGE_MASK;
+	buf->sg_desc.size = size;
+
+	first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
+	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
+	buf->sg_desc.num_pages = last - first + 1;
+
+	buf->sg_desc.sglist = vmalloc(
+		buf->sg_desc.num_pages * sizeof(*buf->sg_desc.sglist));
+	if (!buf->sg_desc.sglist)
+		goto userptr_fail_sglist_alloc;
+
+	memset(buf->sg_desc.sglist, 0,
+		buf->sg_desc.num_pages * sizeof(*buf->sg_desc.sglist));
+	sg_init_table(buf->sg_desc.sglist, buf->sg_desc.num_pages);
+
+	buf->pages = kzalloc(buf->sg_desc.num_pages * sizeof(struct page *),
+			     GFP_KERNEL);
+	if (!buf->pages)
+		goto userptr_fail_pages_array_alloc;
+
+	down_read(&current->mm->mmap_sem);
+	num_pages_from_user = get_user_pages(current, current->mm,
+					     vaddr & PAGE_MASK,
+					     buf->sg_desc.num_pages,
+					     write,
+					     1, /* force */
+					     buf->pages,
+					     NULL);
+	up_read(&current->mm->mmap_sem);
+	if (num_pages_from_user != buf->sg_desc.num_pages)
+		goto userptr_fail_get_user_pages;
+
+	sg_set_page(&buf->sg_desc.sglist[0], buf->pages[0],
+		    PAGE_SIZE - buf->offset, buf->offset);
+	size -= PAGE_SIZE - buf->offset;
+	for (i = 1; i < buf->sg_desc.num_pages; ++i) {
+		sg_set_page(&buf->sg_desc.sglist[i], buf->pages[i],
+			    min_t(size_t, PAGE_SIZE, size), 0);
+		size -= min_t(size_t, PAGE_SIZE, size);
+	}
+	return buf;
+
+userptr_fail_get_user_pages:
+	printk(KERN_DEBUG "get_user_pages requested/got: %d/%d]\n",
+	       num_pages_from_user, buf->sg_desc.num_pages);
+	while (--num_pages_from_user >= 0)
+		put_page(buf->pages[num_pages_from_user]);
+
+userptr_fail_pages_array_alloc:
+	vfree(buf->sg_desc.sglist);
+
+userptr_fail_sglist_alloc:
+	kfree(buf);
+	return NULL;
+}
+
+/*
+ * @put_userptr: inform the allocator that a USERPTR buffer will no longer
+ *		 be used
+ */
+static void vb2_dma_sg_put_userptr(void *buf_priv)
+{
+	struct vb2_dma_sg_buf *buf = buf_priv;
+	int i = buf->sg_desc.num_pages;
+
+	printk(KERN_DEBUG "%s: Releasing userspace buffer of %d pages\n",
+	       __func__, buf->sg_desc.num_pages);
+	if (buf->vaddr)
+		vm_unmap_ram(buf->vaddr, buf->sg_desc.num_pages);
+	while (--i >= 0) {
+		if (buf->write)
+			set_page_dirty_lock(buf->pages[i]);
+		put_page(buf->pages[i]);
+	}
+	vfree(buf->sg_desc.sglist);
+	kfree(buf->pages);
+	kfree(buf);
+}
+
+static void *vb2_dma_sg_vaddr(void *buf_priv)
+{
+	struct vb2_dma_sg_buf *buf = buf_priv;
+
+	BUG_ON(!buf);
+
+	if (!buf->vaddr)
+		buf->vaddr = vm_map_ram(buf->pages,
+					buf->sg_desc.num_pages,
+					-1,
+					PAGE_KERNEL);
+
+	/* add offset in case userptr is not page-aligned */
+	return buf->vaddr + buf->offset;
+}
+
+static unsigned int vb2_dma_sg_num_users(void *buf_priv)
+{
+	struct vb2_dma_sg_buf *buf = buf_priv;
+
+	return atomic_read(&buf->refcount);
+}
+
+static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
+{
+	struct vb2_dma_sg_buf *buf = buf_priv;
+	unsigned long uaddr = vma->vm_start;
+	unsigned long usize = vma->vm_end - vma->vm_start;
+	int i = 0;
+
+	if (!buf) {
+		printk(KERN_ERR "No memory to map\n");
+		return -EINVAL;
+	}
+
+	do {
+		int ret;
+
+		ret = vm_insert_page(vma, uaddr, buf->pages[i++]);
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
+static void *vb2_dma_sg_cookie(void *buf_priv)
+{
+	struct vb2_dma_sg_buf *buf = buf_priv;
+
+	return &buf->sg_desc;
+}
+
+const struct vb2_mem_ops vb2_dma_sg_memops = {
+	.alloc		= vb2_dma_sg_alloc,
+	.put		= vb2_dma_sg_put,
+	.get_userptr	= vb2_dma_sg_get_userptr,
+	.put_userptr	= vb2_dma_sg_put_userptr,
+	.vaddr		= vb2_dma_sg_vaddr,
+	.mmap		= vb2_dma_sg_mmap,
+	.num_users	= vb2_dma_sg_num_users,
+	.cookie		= vb2_dma_sg_cookie,
+};
+EXPORT_SYMBOL_GPL(vb2_dma_sg_memops);
+
+MODULE_DESCRIPTION("dma scatter/gather memory handling routines for videobuf2");
+MODULE_AUTHOR("Andrzej Pietrasiewicz");
+MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-dma-sg.h b/include/media/videobuf2-dma-sg.h
new file mode 100644
index 0000000..0038526
--- /dev/null
+++ b/include/media/videobuf2-dma-sg.h
@@ -0,0 +1,32 @@
+/*
+ * videobuf2-dma-sg.h - DMA scatter/gather memory allocator for videobuf2
+ *
+ * Copyright (C) 2010 Samsung Electronics
+ *
+ * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _MEDIA_VIDEOBUF2_DMA_SG_H
+#define _MEDIA_VIDEOBUF2_DMA_SG_H
+
+#include <media/videobuf2-core.h>
+
+struct vb2_dma_sg_desc {
+	unsigned long		size;
+	unsigned int		num_pages;
+	struct scatterlist	*sglist;
+};
+
+static inline struct vb2_dma_sg_desc *vb2_dma_sg_plane_desc(
+		struct vb2_buffer *vb, unsigned int plane_no)
+{
+	return (struct vb2_dma_sg_desc *)vb2_plane_cookie(vb, plane_no);
+}
+
+extern const struct vb2_mem_ops vb2_dma_sg_memops;
+
+#endif
-- 
1.7.1.569.g6f426

