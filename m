Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49429 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2IXKz6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 06:55:58 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory allocator
Date: Mon, 24 Sep 2012 12:58:50 +0200
Message-Id: <1348484332-8106-2-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DMA streaming allocator is similar to the DMA contig but it use the
DMA streaming interface (dma_map_single, dma_unmap_single). The
allocator allocates buffers and immediately map the memory for DMA
transfer. For each buffer prepare/finish it does a DMA synchronization.

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/media/v4l2-core/Kconfig                   |   5 +
 drivers/media/v4l2-core/Makefile                  |   1 +
 drivers/media/v4l2-core/videobuf2-dma-streaming.c | 205 ++++++++++++++++++++++
 include/media/videobuf2-dma-streaming.h           |  32 ++++
 4 file modificati, 243 inserzioni(+)
 create mode 100644 drivers/media/v4l2-core/videobuf2-dma-streaming.c
 create mode 100644 include/media/videobuf2-dma-streaming.h

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 0c54e19..60548a7 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -79,3 +79,8 @@ config VIDEOBUF2_DMA_SG
 	#depends on HAS_DMA
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
+
+config VIDEOBUF2_DMA_STREAMING
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index c2d61d4..0b2756f 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_VIDEOBUF2_MEMOPS) += videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC) += videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
 obj-$(CONFIG_VIDEOBUF2_DMA_SG) += videobuf2-dma-sg.o
+obj-$(CONFIG_VIDEOBUF2_DMA_STREAMING) += videobuf2-dma-streaming.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/v4l2-core/videobuf2-dma-streaming.c b/drivers/media/v4l2-core/videobuf2-dma-streaming.c
new file mode 100644
index 0000000..c839e05
--- /dev/null
+++ b/drivers/media/v4l2-core/videobuf2-dma-streaming.c
@@ -0,0 +1,205 @@
+/*
+ * videobuf2-dma-streaming.c - DMA streaming memory allocator for videobuf2
+ *
+ * Copyright (C) 2012 Federico Vaga <federico.vaga@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/pagemap.h>
+#include <linux/dma-mapping.h>
+
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-streaming.h>
+#include <media/videobuf2-memops.h>
+
+struct vb2_streaming_conf {
+	struct device			*dev;
+};
+struct vb2_streaming_buf {
+	struct vb2_streaming_conf	*conf;
+	void				*vaddr;
+
+	dma_addr_t			dma_handle;
+
+	unsigned long			size;
+	struct vm_area_struct		*vma;
+
+	atomic_t			refcount;
+	struct vb2_vmarea_handler	handler;
+};
+
+static void vb2_dma_streaming_put(void *buf_priv)
+{
+	struct vb2_streaming_buf *buf = buf_priv;
+
+	if (atomic_dec_and_test(&buf->refcount)) {
+		dma_unmap_single(buf->conf->dev, buf->dma_handle, buf->size,
+				 DMA_FROM_DEVICE);
+		free_pages_exact(buf->vaddr, buf->size);
+		kfree(buf);
+	}
+
+}
+
+static void *vb2_dma_streaming_alloc(void *alloc_ctx, unsigned long size)
+{
+	struct vb2_streaming_conf *conf = alloc_ctx;
+	struct vb2_streaming_buf *buf;
+	int err;
+
+	buf = kzalloc(sizeof(struct vb2_streaming_buf), GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+	buf->vaddr = alloc_pages_exact(size, GFP_KERNEL | GFP_DMA);
+	if (!buf->vaddr) {
+		err = -ENOMEM;
+		goto out;
+	}
+	buf->dma_handle = dma_map_single(conf->dev, buf->vaddr, size,
+					 DMA_FROM_DEVICE);
+	err = dma_mapping_error(conf->dev, buf->dma_handle);
+	if (err) {
+		dev_err(conf->dev, "dma_map_single failed\n");
+
+		free_pages_exact(buf->vaddr, size);
+		buf->vaddr = NULL;
+		goto out_pages;
+	}
+	buf->conf = conf;
+	buf->size = size;
+	buf->handler.refcount = &buf->refcount;
+	buf->handler.put = vb2_dma_streaming_put;
+	buf->handler.arg = buf;
+
+	atomic_inc(&buf->refcount);
+	return buf;
+
+out_pages:
+	free_pages_exact(buf->vaddr, buf->size);
+out:
+	kfree(buf);
+	return ERR_PTR(err);
+}
+
+static void *vb2_dma_streaming_cookie(void *buf_priv)
+{
+	struct vb2_streaming_buf *buf = buf_priv;
+
+	return &buf->dma_handle;
+}
+
+static void *vb2_dma_streaming_vaddr(void *buf_priv)
+{
+	struct vb2_streaming_buf *buf = buf_priv;
+
+	if (!buf)
+		return NULL;
+	return buf->vaddr;
+}
+
+static unsigned int vb2_dma_streaming_num_users(void *buf_priv)
+{
+	struct vb2_streaming_buf *buf = buf_priv;
+
+	return atomic_read(&buf->refcount);
+}
+
+static int vb2_dma_streaming_mmap(void *buf_priv, struct vm_area_struct *vma)
+{
+	struct vb2_streaming_buf *buf = buf_priv;
+	unsigned long pos, start = vma->vm_start;
+	unsigned long size;
+	struct page *page;
+	int err;
+
+	/* Try to remap memory */
+	size = vma->vm_end - vma->vm_start;
+	size = (size < buf->size) ? size : buf->size;
+	pos = (unsigned long)buf->vaddr;
+
+	while (size > 0) {
+		page = virt_to_page((void *)pos);
+		if (!page) {
+			dev_err(buf->conf->dev, "mmap: virt_to_page failed\n");
+			return -ENOMEM;
+		}
+		err = vm_insert_page(vma, start, page);
+		if (err) {
+			dev_err(buf->conf->dev, "mmap: insert failed %d\n", err);
+			return -ENOMEM;
+		}
+		start += PAGE_SIZE;
+		pos += PAGE_SIZE;
+
+		if (size > PAGE_SIZE)
+			size -= PAGE_SIZE;
+		else
+			size = 0;
+	}
+
+
+	vma->vm_ops = &vb2_common_vm_ops;
+	vma->vm_flags |= VM_DONTEXPAND;
+	vma->vm_private_data = &buf->handler;
+
+	vma->vm_ops->open(vma);
+
+	return 0;
+}
+
+static void vb2_dma_streaming_prepare(void *buf_priv)
+{
+	struct vb2_streaming_buf *buf = buf_priv;
+
+	dma_sync_single_for_device(buf->conf->dev, buf->dma_handle,
+				   buf->size, DMA_FROM_DEVICE);
+}
+
+static void vb2_dma_streaming_finish(void *buf_priv)
+{
+	struct vb2_streaming_buf *buf = buf_priv;
+
+	dma_sync_single_for_cpu(buf->conf->dev, buf->dma_handle,
+				buf->size, DMA_FROM_DEVICE);
+}
+
+const struct vb2_mem_ops vb2_dma_streaming_memops = {
+	.alloc		= vb2_dma_streaming_alloc,
+	.put		= vb2_dma_streaming_put,
+	.cookie		= vb2_dma_streaming_cookie,
+	.vaddr		= vb2_dma_streaming_vaddr,
+	.mmap		= vb2_dma_streaming_mmap,
+	.num_users	= vb2_dma_streaming_num_users,
+	.prepare	= vb2_dma_streaming_prepare,
+	.finish		= vb2_dma_streaming_finish,
+};
+EXPORT_SYMBOL_GPL(vb2_dma_streaming_memops);
+
+void *vb2_dma_streaming_init_ctx(struct device *dev)
+{
+	struct vb2_streaming_conf *conf;
+
+	conf = kmalloc(sizeof(struct vb2_streaming_conf), GFP_KERNEL);
+	if (!conf)
+		return ERR_PTR(-ENOMEM);
+
+	conf->dev = dev;
+
+	return conf;
+}
+EXPORT_SYMBOL_GPL(vb2_dma_streaming_init_ctx);
+
+void vb2_dma_streaming_cleanup_ctx(void *alloc_ctx)
+{
+	kfree(alloc_ctx);
+}
+EXPORT_SYMBOL_GPL(vb2_dma_streaming_cleanup_ctx);
+
+MODULE_DESCRIPTION("DMA-streaming memory allocator for videobuf2");
+MODULE_AUTHOR("Federico Vaga <federico.vaga@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/media/videobuf2-dma-streaming.h b/include/media/videobuf2-dma-streaming.h
new file mode 100644
index 0000000..2a62d93
--- /dev/null
+++ b/include/media/videobuf2-dma-streaming.h
@@ -0,0 +1,32 @@
+/*
+ * videobuf2-dma-streaming.h - DMA streaming memory allocator for videobuf2
+ *
+ * Copyright (C) 2012 Federico Vaga
+ *
+ * Author: Federico Vaga <federico.vaga@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _MEDIA_VIDEOBUF2_DMA_STREAMING_H
+#define _MEDIA_VIDEOBUF2_DMA_STREAMING_H
+
+#include <media/videobuf2-core.h>
+#include <linux/dma-mapping.h>
+
+void *vb2_dma_streaming_init_ctx(struct device *dev);
+void vb2_dma_streaming_cleanup_ctx(void *alloc_ctx);
+
+extern const struct vb2_mem_ops vb2_dma_streaming_memops;
+
+static inline dma_addr_t
+vb2_dma_streaming_plane_paddr(struct vb2_buffer *vb, unsigned int plane_no)
+{
+	dma_addr_t *dma_addr = vb2_plane_cookie(vb, plane_no);
+
+	return *dma_addr;
+}
+
+#endif
-- 
1.7.11.4

