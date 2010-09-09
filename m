Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36758 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0IIJUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 05:20:12 -0400
Received: from eu_spt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L8H001UK39JVQ@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Sep 2010 10:20:07 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8H00HAK39H94@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Sep 2010 10:20:06 +0100 (BST)
Date: Thu, 09 Sep 2010 11:19:45 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v1 4/7] v4l: videobuf2: add vmalloc allocator
In-reply-to: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Message-id: <1284023988-23351-5-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Add an implementation of contiguous virtual memory allocator and handling
routines for videobuf2, implemented on top of vmalloc()/vfree() calls.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig             |    5 +
 drivers/media/video/Makefile            |    4 +
 drivers/media/video/videobuf2-vmalloc.c |  177 +++++++++++++++++++++++++++++++
 include/media/videobuf2-vmalloc.h       |   16 +++
 4 files changed, 202 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-vmalloc.c
 create mode 100644 include/media/videobuf2-vmalloc.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index c2f99d8..aae7a30 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -55,6 +55,11 @@ config VIDEOBUF2_CORE
 config VIDEOBUF2_MEMOPS
 	tristate
 
+config VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_GEN_MEMOPS
+	tristate
+
 
 #
 # Multimedia Video device configuration
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index ab5b521..b7c15ae 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -120,6 +120,10 @@ obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o
 obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
 
+obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2_vmalloc.o
+videobuf2_vmalloc-y			:= videobuf2-vmalloc.o \
+					   videobuf2-memops.o
+
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
diff --git a/drivers/media/video/videobuf2-vmalloc.c b/drivers/media/video/videobuf2-vmalloc.c
new file mode 100644
index 0000000..3310900
--- /dev/null
+++ b/drivers/media/video/videobuf2-vmalloc.c
@@ -0,0 +1,177 @@
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
+struct vb2_vmalloc_conf {
+	struct vb2_alloc_ctx	alloc_ctx;
+};
+
+struct vb2_vmalloc_buf {
+	void			*vaddr;
+	unsigned long		size;
+	unsigned int		refcount;
+};
+
+static void *vb2_vmalloc_alloc(const struct vb2_alloc_ctx *alloc_ctx,
+				unsigned long size)
+{
+	struct vb2_vmalloc_buf *buf;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->size = size;
+	buf->vaddr = vmalloc_user(buf->size);
+	if (!buf->vaddr) {
+		printk(KERN_ERR "vmalloc of size %ld failed\n", buf->size);
+		kfree(buf);
+		return NULL;
+	}
+
+	buf->refcount++;
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
+	buf->refcount--;
+
+	if (0 == buf->refcount) {
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
+		printk(KERN_ERR "Address of an unallocated "
+				"plane requested\n");
+		return NULL;
+	}
+
+	return buf->vaddr;
+}
+
+static unsigned int vb2_vmalloc_num_users(void *buf_priv)
+{
+	struct vb2_vmalloc_buf *buf = buf_priv;
+
+	return buf->refcount;
+}
+
+/* TODO generalize and extract to core as much as possible */
+static void vb2_vmalloc_vm_open(struct vm_area_struct *vma)
+{
+	struct vb2_vmalloc_buf *buf = vma->vm_private_data;
+
+	printk(KERN_DEBUG "%s vmalloc_priv: %p, refcount: %d, "
+			"vma: %08lx-%08lx\n", __func__, buf, buf->refcount,
+			vma->vm_start, vma->vm_end);
+
+	buf->refcount++;
+}
+
+static void vb2_vmalloc_vm_close(struct vm_area_struct *vma)
+{
+	struct vb2_vmalloc_buf *buf = vma->vm_private_data;
+
+	printk(KERN_DEBUG "%s vmalloc_priv: %p, refcount: %d, "
+			"vma: %08lx-%08lx\n", __func__, buf, buf->refcount,
+			vma->vm_start, vma->vm_end);
+
+	vb2_vmalloc_put(buf);
+}
+
+static const struct vm_operations_struct vb2_vmalloc_vm_ops = {
+	.open = vb2_vmalloc_vm_open,
+	.close = vb2_vmalloc_vm_close,
+};
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
+	vma->vm_flags		|= VM_DONTEXPAND | VM_RESERVED;
+	vma->vm_private_data	= buf;
+	vma->vm_ops		= &vb2_vmalloc_vm_ops;
+
+	vb2_vmalloc_vm_open(vma);
+
+	return 0;
+}
+
+static const struct vb2_mem_ops vb2_vmalloc_ops = {
+	.alloc		= vb2_vmalloc_alloc,
+	.put		= vb2_vmalloc_put,
+	.vaddr		= vb2_vmalloc_vaddr,
+	.mmap		= vb2_vmalloc_mmap,
+	.num_users	= vb2_vmalloc_num_users,
+};
+
+struct vb2_alloc_ctx *vb2_vmalloc_init(void)
+{
+	struct vb2_vmalloc_conf *conf;
+
+	conf = kzalloc(sizeof *conf, GFP_KERNEL);
+	if (!conf)
+		return ERR_PTR(-ENOMEM);
+
+	conf->alloc_ctx.mem_ops = &vb2_vmalloc_ops;
+
+	return &conf->alloc_ctx;
+}
+EXPORT_SYMBOL_GPL(vb2_vmalloc_init);
+
+void vb2_vmalloc_cleanup(struct vb2_alloc_ctx *alloc_ctx)
+{
+	struct vb2_vmalloc_conf *conf =
+		container_of(alloc_ctx, struct vb2_vmalloc_conf, alloc_ctx);
+
+	kfree(conf);
+}
+EXPORT_SYMBOL_GPL(vb2_vmalloc_cleanup);
+
+MODULE_DESCRIPTION("vmalloc memory handling routines for videobuf2");
+MODULE_AUTHOR("Pawel Osciak");
+MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-vmalloc.h b/include/media/videobuf2-vmalloc.h
new file mode 100644
index 0000000..7612f9f
--- /dev/null
+++ b/include/media/videobuf2-vmalloc.h
@@ -0,0 +1,16 @@
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
+#include <media/videobuf2-core.h>
+
+struct vb2_alloc_ctx *vb2_vmalloc_init(void);
+void vb2_vmalloc_cleanup(struct vb2_alloc_ctx *alloc_ctx);
-- 
1.7.2.1.97.g3235b.dirty

