Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34954 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1GNUfv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 16:35:51 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/2] videobuf2: Add a non-coherent contiguous DMA mode
Date: Thu, 14 Jul 2011 14:35:10 -0600
Message-Id: <1310675711-39744-2-git-send-email-corbet@lwn.net>
In-Reply-To: <1310675711-39744-1-git-send-email-corbet@lwn.net>
References: <1310675711-39744-1-git-send-email-corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds videobuf2-dma-nc.c and related stuff; it implements a new
contiguous DMA mode which uses non-coherent memory.  Going non-coherent can
improve performance greatly (3x frame rate increase over coherent on the
Marvell Armada 610 controller), relieves pressure on coherent memory pools,
and avoids possible page attribute conflict problems.  It also is easy to
support within the VB2 framework.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/Kconfig            |    5 ++
 drivers/media/video/Makefile           |    1 +
 drivers/media/video/videobuf2-dma-nc.c |  125 ++++++++++++++++++++++++++++++++
 include/media/videobuf2-dma-nc.h       |    9 +++
 4 files changed, 140 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-dma-nc.c
 create mode 100644 include/media/videobuf2-dma-nc.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 7c88e0c..92be525 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -55,6 +55,11 @@ config VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_MEMOPS
 	tristate
 
+config VIDEOBUF2_DMA_NC
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
+
 config VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 5bb3b6e..11539d8 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -118,6 +118,7 @@ obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG)	+= videobuf2-dma-contig.o
 obj-$(CONFIG_VIDEOBUF2_DMA_SG)		+= videobuf2-dma-sg.o
+obj-$(CONFIG_VIDEOBUF2_DMA_NC)		+= videobuf2-dma-nc.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
diff --git a/drivers/media/video/videobuf2-dma-nc.c b/drivers/media/video/videobuf2-dma-nc.c
new file mode 100644
index 0000000..fecda72
--- /dev/null
+++ b/drivers/media/video/videobuf2-dma-nc.c
@@ -0,0 +1,125 @@
+/*
+ * This is a videobuf2 memory allocator for contiguous but noncoherent
+ * memory.  With luck, it will prove faster and will not strain
+ * the (possibly limited) supplies of coherent memory.
+ *
+ * Some constraints:
+ *
+ * - The userptr hack used by videobuf2-dma-contig is not supported
+ *   here; it is only usable by out-of-tree code anyway.
+ *
+ * - Drivers are charged with creating and tearing down the streaming
+ *   mappings, probably in their buf_prepare() and buf_finish() functions.
+ *
+ * Copyright 2011 Jonathan Corbet <corbet@lwn.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/atomic.h>
+#include <linux/mm.h>
+
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-memops.h>
+
+
+struct vb2_nc_buf {
+	void	*vaddr;		/* The actual buffer */
+	unsigned long size;
+	atomic_t refcount;
+	struct vb2_vmarea_handler vm_handler;
+};
+
+/*
+ * Weird VB2 reference counting: the core increments the atomic_t
+ * count directly, but calls back to us to query or decrement it.
+ */
+static void vb2_dma_nc_put(void *vbuf)
+{
+	struct vb2_nc_buf *buf = vbuf;
+
+	if (atomic_dec_and_test(&buf->refcount)) {
+		free_pages_exact(buf->vaddr, buf->size);
+		kfree(buf);
+	}
+}
+
+static unsigned int vb2_dma_nc_num_users(void *vbuf)
+{
+	struct vb2_nc_buf *buf = vbuf;
+
+	return atomic_read(&buf->refcount);
+	/* Let's hope they don't fork() about now... */
+}
+
+/*
+ * Allocate a buffer and associated pages.
+ */
+static void *vb2_dma_nc_alloc(void *alloc_ctx, unsigned long size)
+{
+	struct vb2_nc_buf *buf;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+	buf->vaddr = alloc_pages_exact(size, GFP_KERNEL);
+	if (!buf->vaddr) {
+		kfree(buf);
+		return ERR_PTR(-ENOMEM);
+	}
+	buf->size = size;
+	atomic_set(&buf->refcount, 1);
+
+	buf->vm_handler.refcount = &buf->refcount;
+	buf->vm_handler.put = vb2_dma_nc_put;
+	buf->vm_handler.arg = buf;
+	return buf;
+}
+
+static void *vb2_dma_nc_vaddr(void *vbuf)
+{
+	struct vb2_nc_buf *buf = vbuf;
+
+	if (!buf)
+		return NULL;
+	return buf->vaddr;
+}
+
+
+static int vb2_dma_nc_mmap(void *vbuf, struct vm_area_struct *vma)
+{
+	struct vb2_nc_buf *buf = vbuf;
+	unsigned long uaddr = vma->vm_start;
+	void *vaddr;
+	int ret;
+
+	if (!buf)
+		return -EINVAL; /* Can this really happen? */
+	for (vaddr = buf->vaddr; uaddr < vma->vm_end;
+	     uaddr += PAGE_SIZE, vaddr += PAGE_SIZE) {
+		ret = vm_insert_page(vma, uaddr, virt_to_page(vaddr));
+		if (ret)
+			return ret;  /* Undo partial mapping?? */
+	}
+	vma->vm_private_data = &buf->vm_handler;
+	vma->vm_ops = &vb2_common_vm_ops;
+	vma->vm_ops->open(vma);
+	return 0;
+}
+
+const struct vb2_mem_ops vb2_dma_nc_memops = {
+	.alloc		= vb2_dma_nc_alloc,
+	.put		= vb2_dma_nc_put,
+	.vaddr		= vb2_dma_nc_vaddr,
+	.mmap		= vb2_dma_nc_mmap,
+	.num_users	= vb2_dma_nc_num_users
+};
+EXPORT_SYMBOL_GPL(vb2_dma_nc_memops);
+
+MODULE_DESCRIPTION("Non-coherent videobuf2 memory operations");
+MODULE_AUTHOR("Jonathan Corbet");
+MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-dma-nc.h b/include/media/videobuf2-dma-nc.h
new file mode 100644
index 0000000..a234dce
--- /dev/null
+++ b/include/media/videobuf2-dma-nc.h
@@ -0,0 +1,9 @@
+/*
+ * Noncoherent contiguous DMA support for videobuf2
+ */
+#ifndef _MEDIA_VIDEOBUF2_DMA_NC_H
+#define _MEDIA_VIDEOBUF2_DMA_NC_H
+
+extern const struct vb2_mem_ops vb2_dma_nc_memops;
+
+#endif
-- 
1.7.6

