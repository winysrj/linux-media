Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62162 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0LPOYS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 09:24:18 -0500
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LDI00856YOFME@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Dec 2010 14:24:15 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDI00JJ6YOE4G@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Dec 2010 14:24:15 +0000 (GMT)
Date: Thu, 16 Dec 2010 15:24:00 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 3/8] v4l: videobuf2: add vmalloc allocator
In-reply-to: <1292509445-15100-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, andrzej.p@samsung.com
Message-id: <1292509445-15100-4-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1292509445-15100-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Pawel Osciak <p.osciak@samsung.com>

Add an implementation of contiguous virtual memory allocator and handling
routines for videobuf2, implemented on top of vmalloc()/vfree() calls.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/Kconfig             |    5 +
 drivers/media/video/Makefile            |    1 +
 drivers/media/video/videobuf2-vmalloc.c |  132 +++++++++++++++++++++++++++++++
 include/media/videobuf2-vmalloc.h       |   20 +++++
 4 files changed, 158 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-vmalloc.c
 create mode 100644 include/media/videobuf2-vmalloc.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 3c239fa..2606f49 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -55,6 +55,11 @@ config VIDEOBUF2_CORE
 config VIDEOBUF2_MEMOPS
 	tristate
 
+config VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
+
 #
 # Multimedia Video device configuration
 #
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index a97a2a0..538bee9 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -116,6 +116,7 @@ obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 
 obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o
 obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
+obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
diff --git a/drivers/media/video/videobuf2-vmalloc.c b/drivers/media/video/videobuf2-vmalloc.c
new file mode 100644
index 0000000..b5e6936
--- /dev/null
+++ b/drivers/media/video/videobuf2-vmalloc.c
@@ -0,0 +1,132 @@
+/*
+ * videobuf2-vmalloc.c - vmalloc memory allocator for videobuf2
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
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-memops.h>
+
+struct vb2_vmalloc_buf {
+	void				*vaddr;
+	unsigned long			size;
+	atomic_t			refcount;
+	struct vb2_vmarea_handler	handler;
+};
+
+static void vb2_vmalloc_put(void *buf_priv);
+
+static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size)
+{
+	struct vb2_vmalloc_buf *buf;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->size = size;
+	buf->vaddr = vmalloc_user(buf->size);
+	buf->handler.refcount = &buf->refcount;
+	buf->handler.put = vb2_vmalloc_put;
+	buf->handler.arg = buf;
+
+	if (!buf->vaddr) {
+		printk(KERN_ERR "vmalloc of size %ld failed\n", buf->size);
+		kfree(buf);
+		return NULL;
+	}
+
+	atomic_inc(&buf->refcount);
+	printk(KERN_DEBUG "Allocated vmalloc buffer of size %ld at vaddr=%p\n",
+			buf->size, buf->vaddr);
+
+	return buf;
+}
+
+static void vb2_vmalloc_put(void *buf_priv)
+{
+	struct vb2_vmalloc_buf *buf = buf_priv;
+
+	if (atomic_dec_and_test(&buf->refcount)) {
+		printk(KERN_DEBUG "%s: Freeing vmalloc mem at vaddr=%p\n",
+			__func__, buf->vaddr);
+		vfree(buf->vaddr);
+		kfree(buf);
+	}
+}
+
+static void *vb2_vmalloc_vaddr(void *buf_priv)
+{
+	struct vb2_vmalloc_buf *buf = buf_priv;
+
+	BUG_ON(!buf);
+
+	if (!buf->vaddr) {
+		printk(KERN_ERR "Address of an unallocated plane requested\n");
+		return NULL;
+	}
+
+	return buf->vaddr;
+}
+
+static unsigned int vb2_vmalloc_num_users(void *buf_priv)
+{
+	struct vb2_vmalloc_buf *buf = buf_priv;
+	return atomic_read(&buf->refcount);
+}
+
+static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
+{
+	struct vb2_vmalloc_buf *buf = buf_priv;
+	int ret;
+
+	if (!buf) {
+		printk(KERN_ERR "No memory to map\n");
+		return -EINVAL;
+	}
+
+	ret = remap_vmalloc_range(vma, buf->vaddr, 0);
+	if (ret) {
+		printk(KERN_ERR "Remapping vmalloc memory, error: %d\n", ret);
+		return ret;
+	}
+
+	/*
+	 * Make sure that vm_areas for 2 buffers won't be merged together
+	 */
+	vma->vm_flags		|= VM_DONTEXPAND;
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
+const struct vb2_mem_ops vb2_vmalloc_memops = {
+	.alloc		= vb2_vmalloc_alloc,
+	.put		= vb2_vmalloc_put,
+	.vaddr		= vb2_vmalloc_vaddr,
+	.mmap		= vb2_vmalloc_mmap,
+	.num_users	= vb2_vmalloc_num_users,
+};
+EXPORT_SYMBOL_GPL(vb2_vmalloc_memops);
+
+MODULE_DESCRIPTION("vmalloc memory handling routines for videobuf2");
+MODULE_AUTHOR("Pawel Osciak");
+MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-vmalloc.h b/include/media/videobuf2-vmalloc.h
new file mode 100644
index 0000000..a76b8af
--- /dev/null
+++ b/include/media/videobuf2-vmalloc.h
@@ -0,0 +1,20 @@
+/*
+ * videobuf2-vmalloc.h - vmalloc memory allocator for videobuf2
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
+#ifndef _MEDIA_VIDEOBUF2_VMALLOC_H
+#define _MEDIA_VIDEOBUF2_VMALLOC_H
+
+#include <media/videobuf2-core.h>
+
+extern const struct vb2_mem_ops vb2_vmalloc_memops;
+
+#endif
-- 
1.7.1.569.g6f426

