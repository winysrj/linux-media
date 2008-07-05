Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m652s5mI001152
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 22:54:05 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m652rXmA024038
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 22:53:54 -0400
Received: by wf-out-1314.google.com with SMTP id 25so1337629wfc.6
	for <video4linux-list@redhat.com>; Fri, 04 Jul 2008 19:53:54 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Sat, 05 Jul 2008 11:54:05 +0900
Message-Id: <20080705025405.27137.16206.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080705025335.27137.98068.sendpatchset@rx1.opensource.se>
References: <20080705025335.27137.98068.sendpatchset@rx1.opensource.se>
Cc: paulius.zaleckas@teltonika.lt, linux-sh@vger.kernel.org,
	mchehab@infradead.org, lethal@linux-sh.org,
	akpm@linux-foundation.org, g.liakhovetski@gmx.de
Subject: [PATCH 03/04] videobuf: Add physically contiguous queue code V2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is V2 of the physically contiguous videobuf queues patch.
Useful for hardware such as the SuperH Mobile CEU which doesn't
support scatter gatter bus mastering.

Since it may be difficult to allocate large chunks of physically
contiguous memory after some uptime due to fragmentation, this code
allocates memory using dma_alloc_coherent(). Architectures supporting
dma_declare_coherent_memory() can easily avoid fragmentation issues
by using dma_declare_coherent_memory() to force dma_alloc_coherent()
to allocate from a certain pre-allocated memory area.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Changes since V1:
  - use dev_err() instead of pr_err()
  - remember size in struct videobuf_dma_contig_memory
  - keep struct videobuf_dma_contig_memory in .c file
  - let videobuf_to_dma_contig() return dma_addr_t
  - implement __videobuf_sync()
  - return statements, white space and other minor fixes

 drivers/media/video/Kconfig               |    5 
 drivers/media/video/Makefile              |    1 
 drivers/media/video/videobuf-dma-contig.c |  417 +++++++++++++++++++++++++++++
 include/media/videobuf-dma-contig.h       |   32 ++
 4 files changed, 455 insertions(+)

--- 0002/drivers/media/video/Kconfig
+++ work/drivers/media/video/Kconfig	2008-07-05 09:47:22.000000000 +0900
@@ -24,6 +24,11 @@ config VIDEOBUF_VMALLOC
 	select VIDEOBUF_GEN
 	tristate
 
+config VIDEOBUF_DMA_CONTIG
+	depends on HAS_DMA
+	select VIDEOBUF_GEN
+	tristate
+
 config VIDEOBUF_DVB
 	tristate
 	select VIDEOBUF_GEN
--- 0001/drivers/media/video/Makefile
+++ work/drivers/media/video/Makefile	2008-07-05 09:47:22.000000000 +0900
@@ -88,6 +88,7 @@ obj-$(CONFIG_VIDEO_TUNER) += tuner.o
 
 obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
 obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
+obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
 obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
 obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
 obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
--- /dev/null
+++ work/drivers/media/video/videobuf-dma-contig.c	2008-07-05 10:09:12.000000000 +0900
@@ -0,0 +1,417 @@
+/*
+ * helper functions for physically contiguous capture buffers
+ *
+ * The functions support hardware lacking scatter gatter support
+ * (i.e. the buffers must be linear in physical memory)
+ *
+ * Copyright (c) 2008 Magnus Damm
+ *
+ * Based on videobuf-vmalloc.c,
+ * (c) 2007 Mauro Carvalho Chehab, <mchehab@infradead.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <media/videobuf-dma-contig.h>
+
+struct videobuf_dma_contig_memory {
+	u32 magic;
+	void *vaddr;
+	dma_addr_t dma_handle;
+	unsigned long size;
+};
+
+#define MAGIC_DC_MEM 0x0733ac61
+#define MAGIC_CHECK(is, should)						\
+	if (unlikely((is) != (should)))	{				\
+		pr_err("magic mismatch: %x expected %x\n", is, should); \
+		BUG();							\
+	}
+
+static void
+videobuf_vm_open(struct vm_area_struct *vma)
+{
+	struct videobuf_mapping *map = vma->vm_private_data;
+
+	dev_dbg(map->q->dev, "vm_open %p [count=%u,vma=%08lx-%08lx]\n",
+		map, map->count, vma->vm_start, vma->vm_end);
+
+	map->count++;
+}
+
+static void videobuf_vm_close(struct vm_area_struct *vma)
+{
+	struct videobuf_mapping *map = vma->vm_private_data;
+	struct videobuf_queue *q = map->q;
+	int i;
+
+	dev_dbg(map->q->dev, "vm_close %p [count=%u,vma=%08lx-%08lx]\n",
+		map, map->count, vma->vm_start, vma->vm_end);
+
+	map->count--;
+	if (0 == map->count) {
+		struct videobuf_dma_contig_memory *mem;
+
+		dev_dbg(map->q->dev, "munmap %p q=%p\n", map, q);
+		mutex_lock(&q->vb_lock);
+
+		/* We need first to cancel streams, before unmapping */
+		if (q->streaming)
+			videobuf_queue_cancel(q);
+
+		for (i = 0; i < VIDEO_MAX_FRAME; i++) {
+			if (NULL == q->bufs[i])
+				continue;
+
+			if (q->bufs[i]->map != map)
+				continue;
+
+			mem = q->bufs[i]->priv;
+			if (mem) {
+				/* This callback is called only if kernel has
+				   allocated memory and this memory is mmapped.
+				   In this case, memory should be freed,
+				   in order to do memory unmap.
+				 */
+
+				MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+				/* vfree is not atomic - can't be
+				   called with IRQ's disabled
+				 */
+				dev_dbg(map->q->dev, "buf[%d] freeing %p\n",
+					i, mem->vaddr);
+
+				dma_free_coherent(q->dev, mem->size,
+						  mem->vaddr, mem->dma_handle);
+				mem->vaddr = NULL;
+			}
+
+			q->bufs[i]->map   = NULL;
+			q->bufs[i]->baddr = 0;
+		}
+
+		kfree(map);
+
+		mutex_unlock(&q->vb_lock);
+	}
+}
+
+static struct vm_operations_struct videobuf_vm_ops = {
+	.open     = videobuf_vm_open,
+	.close    = videobuf_vm_close,
+};
+
+static void *__videobuf_alloc(size_t size)
+{
+	struct videobuf_dma_contig_memory *mem;
+	struct videobuf_buffer *vb;
+
+	vb = kzalloc(size + sizeof(*mem), GFP_KERNEL);
+	if (vb) {
+		mem = vb->priv = ((char *)vb) + size;
+		mem->magic = MAGIC_DC_MEM;
+	}
+
+	return vb;
+}
+
+static void *__videobuf_to_vmalloc(struct videobuf_buffer *buf)
+{
+	struct videobuf_dma_contig_memory *mem = buf->priv;
+
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	return mem->vaddr;
+}
+
+static int __videobuf_iolock(struct videobuf_queue *q,
+			     struct videobuf_buffer *vb,
+			     struct v4l2_framebuffer *fbuf)
+{
+	struct videobuf_dma_contig_memory *mem = vb->priv;
+
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	switch (vb->memory) {
+	case V4L2_MEMORY_MMAP:
+		dev_dbg(q->dev, "%s memory method MMAP\n", __func__);
+
+		/* All handling should be done by __videobuf_mmap_mapper() */
+		if (!mem->vaddr) {
+			dev_err(q->dev, "memory is not alloced/mmapped.\n");
+			return -EINVAL;
+		}
+		break;
+	case V4L2_MEMORY_USERPTR:
+		dev_dbg(q->dev, "%s memory method USERPTR\n", __func__);
+
+		/* The only USERPTR currently supported is the one needed for
+		   read() method.
+		 */
+		if (vb->baddr)
+			return -EINVAL;
+
+		mem->size = PAGE_ALIGN(vb->size);
+		mem->vaddr = dma_alloc_coherent(q->dev, mem->size,
+						&mem->dma_handle, GFP_KERNEL);
+		if (!mem->vaddr) {
+			dev_err(q->dev, "dma_alloc_coherent %ld failed\n",
+					 mem->size);
+			return -ENOMEM;
+		}
+
+		dev_dbg(q->dev, "dma_alloc_coherent data is at %p (%ld)\n",
+			mem->vaddr, mem->size);
+		break;
+	case V4L2_MEMORY_OVERLAY:
+	default:
+		dev_dbg(q->dev, "%s memory method OVERLAY/unknown\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __videobuf_sync(struct videobuf_queue *q,
+			   struct videobuf_buffer *buf)
+{
+	struct videobuf_dma_contig_memory *mem = buf->priv;
+
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	dma_sync_single_for_cpu(q->dev, mem->dma_handle, mem->size,
+				DMA_FROM_DEVICE);
+	return 0;
+}
+
+static int __videobuf_mmap_free(struct videobuf_queue *q)
+{
+	unsigned int i;
+
+	dev_dbg(q->dev, "%s\n", __func__);
+	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
+		if (q->bufs[i] && q->bufs[i]->map)
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int __videobuf_mmap_mapper(struct videobuf_queue *q,
+				  struct vm_area_struct *vma)
+{
+	struct videobuf_dma_contig_memory *mem;
+	struct videobuf_mapping *map;
+	unsigned int first;
+	int retval;
+	unsigned long size, offset = vma->vm_pgoff << PAGE_SHIFT;
+
+	dev_dbg(q->dev, "%s\n", __func__);
+	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
+	/* look for first buffer to map */
+	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
+		if (!q->bufs[first])
+			continue;
+
+		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
+			continue;
+		if (q->bufs[first]->boff == offset)
+			break;
+	}
+	if (VIDEO_MAX_FRAME == first) {
+		dev_dbg(q->dev, "invalid user space offset [offset=0x%lx]\n",
+			offset);
+		return -EINVAL;
+	}
+
+	/* create mapping + update buffer list */
+	map = kzalloc(sizeof(struct videobuf_mapping), GFP_KERNEL);
+	if (!map)
+		return -ENOMEM;
+
+	q->bufs[first]->map = map;
+	map->start = vma->vm_start;
+	map->end = vma->vm_end;
+	map->q = q;
+
+	q->bufs[first]->baddr = vma->vm_start;
+
+	mem = q->bufs[first]->priv;
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	mem->size = PAGE_ALIGN(q->bufs[first]->bsize);
+	mem->vaddr = dma_alloc_coherent(q->dev, mem->size,
+					&mem->dma_handle, GFP_KERNEL);
+	if (!mem->vaddr) {
+		dev_err(q->dev, "dma_alloc_coherent size %ld failed\n",
+			mem->size);
+		goto error;
+	}
+	dev_dbg(q->dev, "dma_alloc_coherent data is at addr %p (size %ld)\n",
+		mem->vaddr, mem->size);
+
+	/* Try to remap memory */
+
+	size = vma->vm_end - vma->vm_start;
+	size = (size < mem->size) ? size : mem->size;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	retval = remap_pfn_range(vma, vma->vm_start,
+				 __pa(mem->vaddr) >> PAGE_SHIFT,
+				 size, vma->vm_page_prot);
+	if (retval) {
+		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
+		dma_free_coherent(q->dev, mem->size,
+				  mem->vaddr, mem->dma_handle);
+		goto error;
+	}
+
+	vma->vm_ops          = &videobuf_vm_ops;
+	vma->vm_flags       |= VM_DONTEXPAND;
+	vma->vm_private_data = map;
+
+	dev_dbg(q->dev, "mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
+		map, q, vma->vm_start, vma->vm_end,
+		(long int) q->bufs[first]->bsize,
+		vma->vm_pgoff, first);
+
+	videobuf_vm_open(vma);
+
+	return 0;
+
+error:
+	kfree(map);
+	return -ENOMEM;
+}
+
+static int __videobuf_copy_to_user(struct videobuf_queue *q,
+				   char __user *data, size_t count,
+				   int nonblocking)
+{
+	struct videobuf_dma_contig_memory *mem = q->read_buf->priv;
+	void *vaddr;
+
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+	BUG_ON(!mem->vaddr);
+
+	/* copy to userspace */
+	if (count > q->read_buf->size - q->read_off)
+		count = q->read_buf->size - q->read_off;
+
+	vaddr = mem->vaddr;
+
+	if (copy_to_user(data, vaddr + q->read_off, count))
+		return -EFAULT;
+
+	return count;
+}
+
+static int __videobuf_copy_stream(struct videobuf_queue *q,
+				  char __user *data, size_t count, size_t pos,
+				  int vbihack, int nonblocking)
+{
+	unsigned int  *fc;
+	struct videobuf_dma_contig_memory *mem = q->read_buf->priv;
+
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	if (vbihack) {
+		/* dirty, undocumented hack -- pass the frame counter
+			* within the last four bytes of each vbi data block.
+			* We need that one to maintain backward compatibility
+			* to all vbi decoding software out there ... */
+		fc = (unsigned int *)mem->vaddr;
+		fc += (q->read_buf->size >> 2) - 1;
+		*fc = q->read_buf->field_count >> 1;
+		dev_dbg(q->dev, "vbihack: %d\n", *fc);
+	}
+
+	/* copy stuff using the common method */
+	count = __videobuf_copy_to_user(q, data, count, nonblocking);
+
+	if ((count == -EFAULT) && (pos == 0))
+		return -EFAULT;
+
+	return count;
+}
+
+static struct videobuf_qtype_ops qops = {
+	.magic        = MAGIC_QTYPE_OPS,
+
+	.alloc        = __videobuf_alloc,
+	.iolock       = __videobuf_iolock,
+	.sync         = __videobuf_sync,
+	.mmap_free    = __videobuf_mmap_free,
+	.mmap_mapper  = __videobuf_mmap_mapper,
+	.video_copy_to_user = __videobuf_copy_to_user,
+	.copy_stream  = __videobuf_copy_stream,
+	.vmalloc      = __videobuf_to_vmalloc,
+};
+
+void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
+				    struct videobuf_queue_ops *ops,
+				    struct device *dev,
+				    spinlock_t *irqlock,
+				    enum v4l2_buf_type type,
+				    enum v4l2_field field,
+				    unsigned int msize,
+				    void *priv)
+{
+	videobuf_queue_core_init(q, ops, dev, irqlock, type, field, msize,
+				 priv, &qops);
+}
+EXPORT_SYMBOL_GPL(videobuf_queue_dma_contig_init);
+
+dma_addr_t videobuf_to_dma_contig(struct videobuf_buffer *buf)
+{
+	struct videobuf_dma_contig_memory *mem = buf->priv;
+
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	return mem->dma_handle;
+}
+EXPORT_SYMBOL_GPL(videobuf_to_dma_contig);
+
+void videobuf_dma_contig_free(struct videobuf_queue *q,
+			      struct videobuf_buffer *buf)
+{
+	struct videobuf_dma_contig_memory *mem = buf->priv;
+
+	/* mmapped memory can't be freed here, otherwise mmapped region
+	   would be released, while still needed. In this case, the memory
+	   release should happen inside videobuf_vm_close().
+	   So, it should free memory only if the memory were allocated for
+	   read() operation.
+	 */
+	if ((buf->memory != V4L2_MEMORY_USERPTR) || !buf->baddr)
+		return;
+
+	if (!mem)
+		return;
+
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	dma_free_coherent(q->dev, mem->size, mem->vaddr, mem->dma_handle);
+	mem->vaddr = NULL;
+}
+EXPORT_SYMBOL_GPL(videobuf_dma_contig_free);
+
+MODULE_DESCRIPTION("helper module to manage video4linux dma contig buffers");
+MODULE_AUTHOR("Magnus Damm");
+MODULE_LICENSE("GPL");
--- /dev/null
+++ work/include/media/videobuf-dma-contig.h	2008-07-05 09:47:22.000000000 +0900
@@ -0,0 +1,32 @@
+/*
+ * helper functions for physically contiguous capture buffers
+ *
+ * The functions support hardware lacking scatter gatter support
+ * (i.e. the buffers must be linear in physical memory)
+ *
+ * Copyright (c) 2008 Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2
+ */
+#ifndef _VIDEOBUF_DMA_CONTIG_H
+#define _VIDEOBUF_DMA_CONTIG_H
+
+#include <linux/dma-mapping.h>
+#include <media/videobuf-core.h>
+
+void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
+				    struct videobuf_queue_ops *ops,
+				    struct device *dev,
+				    spinlock_t *irqlock,
+				    enum v4l2_buf_type type,
+				    enum v4l2_field field,
+				    unsigned int msize,
+				    void *priv);
+
+dma_addr_t videobuf_to_dma_contig(struct videobuf_buffer *buf);
+void videobuf_dma_contig_free(struct videobuf_queue *q,
+			      struct videobuf_buffer *buf);
+
+#endif /* _VIDEOBUF_DMA_CONTIG_H */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
