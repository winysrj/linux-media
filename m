Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36758 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab0IIJUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 05:20:15 -0400
Received: from eu_spt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L8H001UK39JVQ@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Sep 2010 10:20:08 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8H00HAJ39H94@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Sep 2010 10:20:06 +0100 (BST)
Date: Thu, 09 Sep 2010 11:19:43 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v1 2/7] v4l: videobuf2: add generic memory handling routines
In-reply-to: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Message-id: <1284023988-23351-3-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Add generic memory handling routines for userspace pointer handling,
contiguous memory verification and mapping.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig            |    3 +
 drivers/media/video/Makefile           |    2 +
 drivers/media/video/videobuf2-memops.c |  181 ++++++++++++++++++++++++++++++++
 include/media/videobuf2-memops.h       |   27 +++++
 4 files changed, 213 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-memops.c
 create mode 100644 include/media/videobuf2-memops.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 5764443..e4ac3e2 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -51,6 +51,9 @@ config V4L2_MEM2MEM_DEV
 config VIDEOBUF2_CORE
 	tristate
 
+config VIDEOBUF2_MEMOPS
+	tristate
+
 
 #
 # Multimedia Video device configuration
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index e66f53b..ab5b521 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -118,6 +118,8 @@ obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
 obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 
 obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o
+obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
+
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
diff --git a/drivers/media/video/videobuf2-memops.c b/drivers/media/video/videobuf2-memops.c
new file mode 100644
index 0000000..fa76983
--- /dev/null
+++ b/drivers/media/video/videobuf2-memops.c
@@ -0,0 +1,181 @@
+/*
+ * videobuf2-memops.c - generic memory handling routines for videobuf2
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
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/vmalloc.h>
+#include <linux/cma.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/file.h>
+
+#include <media/videobuf2-core.h>
+
+/**
+ * vb2_contig_verify_userptr() - verify contiguity of a userspace-mapped memory
+ * @vma:	virtual memory region which maps the physical memory
+ *		to be verified
+ * @vaddr:	starting virtual address of the area to be verified
+ * @size:	size of the area to be verified
+ * @paddr:	will return physical address for the given vaddr
+ *
+ * This function will go through memory area of size size mapped at vaddr and
+ * verify that the underlying physical pages are contiguous.
+ *
+ * Returns 0 on success and a physical address to the memory pointed
+ * to by vaddr in paddr.
+ */
+int vb2_contig_verify_userptr(struct vm_area_struct *vma,
+				unsigned long vaddr, unsigned long size,
+				unsigned long *paddr)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long offset;
+	unsigned long vma_size;
+	unsigned long curr_pfn, prev_pfn;
+	unsigned long num_pages;
+	int ret = -EINVAL;
+	unsigned int i;
+
+	offset = vaddr & ~PAGE_MASK;
+
+	down_read(&mm->mmap_sem);
+
+	vma = find_vma(mm, vaddr);
+	if (!vma) {
+		printk(KERN_ERR "Invalid userspace address\n");
+		goto done;
+	}
+
+	vma_size = vma->vm_end - vma->vm_start;
+
+	if (size > vma_size - offset) {
+		printk(KERN_ERR "Region too small\n");
+		goto done;
+	}
+	num_pages = (size + offset) >> PAGE_SHIFT;
+
+	ret = follow_pfn(vma, vaddr, &curr_pfn);
+	if (ret) {
+		printk(KERN_ERR "Invalid userspace address\n");
+		goto done;
+	}
+
+	*paddr = (curr_pfn << PAGE_SHIFT) + offset;
+
+	for (i = 1; i < num_pages; ++i) {
+		prev_pfn = curr_pfn;
+		vaddr += PAGE_SIZE;
+
+		ret = follow_pfn(vma, vaddr, &curr_pfn);
+		if (ret || curr_pfn != prev_pfn + 1) {
+			printk(KERN_ERR "Invalid userspace address\n");
+			ret = -EINVAL;
+			break;
+		}
+	}
+
+done:
+	up_read(&mm->mmap_sem);
+	return ret;
+}
+
+/**
+ * vb2_mmap_pfn_range() - map physical pages to userspace
+ * @vma:	virtual memory region for the mapping
+ * @paddr:	starting physical address of the memory to be mapped
+ * @size:	size of the memory to be mapped
+ * @vm_ops:	vm operations to be assigned to the created area
+ * @priv:	private data to be associated with the area
+ *
+ * Returns 0 on success.
+ */
+int vb2_mmap_pfn_range(struct vm_area_struct *vma, unsigned long paddr,
+				unsigned long size,
+				const struct vm_operations_struct *vm_ops,
+				void *priv)
+{
+	int ret;
+
+	size = min_t(unsigned long, vma->vm_end - vma->vm_start, size);
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	ret = remap_pfn_range(vma, vma->vm_start, paddr >> PAGE_SHIFT,
+				size, vma->vm_page_prot);
+	if (ret) {
+		printk(KERN_ERR "Remapping memory failed, error: %d\n", ret);
+		return ret;
+	}
+
+	vma->vm_flags		|= VM_DONTEXPAND | VM_RESERVED;
+	vma->vm_private_data	= priv;
+	vma->vm_ops		= vm_ops;
+
+	vm_ops->open(vma);
+
+	printk(KERN_DEBUG "%s: mapped paddr 0x%08lx at 0x%08lx, size %ld\n",
+			__func__, paddr, vma->vm_start, size);
+
+	return 0;
+}
+
+/**
+ * vb2_get_userptr() - acquire an area pointed to by userspace addres vaddr
+ * @vaddr:	virtual userspace address to the given area
+ *
+ * This function attempts to acquire an area mapped in the userspace for
+ * the duration of a hardware operation.
+ *
+ * Returns a virtual memory region associated with the given vaddr on success
+ * or NULL.
+ */
+struct vm_area_struct *vb2_get_userptr(unsigned long vaddr)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+
+	down_read(&mm->mmap_sem);
+
+	vma = find_vma(mm, vaddr);
+	if (!vma)
+		goto done;
+
+	if (vma->vm_ops && vma->vm_ops->open)
+		vma->vm_ops->open(vma);
+
+	if (vma->vm_file)
+		get_file(vma->vm_file);
+
+done:
+	up_read(&mm->mmap_sem);
+	return vma;
+}
+
+/**
+ * vb2_put_userptr() - release a userspace memory area
+ * @vma:	virtual memory region associated with the area to be released
+ *
+ * This function releases the previously acquired memory area after a hardware
+ * operation.
+ */
+void vb2_put_userptr(struct vm_area_struct *vma)
+{
+	if (!vma)
+		return;
+
+	if (vma->vm_file)
+		fput(vma->vm_file);
+
+	if (vma->vm_ops && vma->vm_ops->close)
+		vma->vm_ops->close(vma);
+}
diff --git a/include/media/videobuf2-memops.h b/include/media/videobuf2-memops.h
new file mode 100644
index 0000000..23db249
--- /dev/null
+++ b/include/media/videobuf2-memops.h
@@ -0,0 +1,27 @@
+/*
+ * videobuf2-memops.h - generic memory handling routines for videobuf2
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
+int vb2_contig_verify_userptr(struct vm_area_struct *vma,
+				unsigned long vaddr, unsigned long size,
+				unsigned long *paddr);
+
+int vb2_mmap_pfn_range(struct vm_area_struct *vma, unsigned long paddr,
+				unsigned long size,
+				const struct vm_operations_struct *vm_ops,
+				void *priv);
+
+struct vm_area_struct *vb2_get_userptr(unsigned long vaddr);
+
+void vb2_put_userptr(struct vm_area_struct *vma);
+
-- 
1.7.2.1.97.g3235b.dirty

