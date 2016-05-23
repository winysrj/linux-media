Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37472 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbcEWIJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 04:09:24 -0400
Received: by mail-wm0-f53.google.com with SMTP id z87so37627004wmh.0
        for <linux-media@vger.kernel.org>; Mon, 23 May 2016 01:09:23 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, zoltan.kuscsik@linaro.org,
	sumit.semwal@linaro.org, cc.ma@mediatek.com,
	pascal.brand@linaro.org, joakim.bech@linaro.org,
	dan.caprita@windriver.com, emil.l.velikov@gmail.com
Cc: linaro-mm-sig@lists.linaro.org,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v8 2/3] SMAF: add CMA allocator
Date: Mon, 23 May 2016 10:09:02 +0200
Message-Id: <1463990943-10068-3-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1463990943-10068-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1463990943-10068-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SMAF CMA allocator implement helpers functions to allow SMAF
to allocate contiguous memory.

match() each if at least one of the attached devices have coherent_dma_mask
set to DMA_BIT_MASK(32).

For allocation it use dma_alloc_attrs() with DMA_ATTR_WRITE_COMBINE and not
dma_alloc_writecombine to be compatible with ARM 64bits architecture

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/smaf/Kconfig    |   6 ++
 drivers/smaf/Makefile   |   1 +
 drivers/smaf/smaf-cma.c | 188 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 195 insertions(+)
 create mode 100644 drivers/smaf/smaf-cma.c

diff --git a/drivers/smaf/Kconfig b/drivers/smaf/Kconfig
index d36651a..058ec4c 100644
--- a/drivers/smaf/Kconfig
+++ b/drivers/smaf/Kconfig
@@ -3,3 +3,9 @@ config SMAF
 	depends on DMA_SHARED_BUFFER
 	help
 	  Choose this option to enable Secure Memory Allocation Framework
+
+config SMAF_CMA
+	tristate "SMAF CMA allocator"
+	depends on SMAF && HAVE_DMA_ATTRS
+	help
+	  Choose this option to enable CMA allocation within SMAF
diff --git a/drivers/smaf/Makefile b/drivers/smaf/Makefile
index 40cd882..05bab01b 100644
--- a/drivers/smaf/Makefile
+++ b/drivers/smaf/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_SMAF) += smaf-core.o
+obj-$(CONFIG_SMAF_CMA) += smaf-cma.o
diff --git a/drivers/smaf/smaf-cma.c b/drivers/smaf/smaf-cma.c
new file mode 100644
index 0000000..cabe440
--- /dev/null
+++ b/drivers/smaf/smaf-cma.c
@@ -0,0 +1,188 @@
+/*
+ * smaf-cma.c
+ *
+ * Copyright (C) Linaro SA 2015
+ * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org> for Linaro.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/smaf-allocator.h>
+
+struct smaf_cma_buffer_info {
+	struct device *dev;
+	size_t size;
+	void *vaddr;
+	dma_addr_t paddr;
+	struct dma_attrs attrs;
+};
+
+/**
+ * find_matching_device - iterate over the attached devices to find one
+ * with coherent_dma_mask correctly set to DMA_BIT_MASK(32).
+ * Matching device (if any) will be used to aim CMA area.
+ */
+static struct device *find_matching_device(struct dma_buf *dmabuf)
+{
+	struct dma_buf_attachment *attach_obj;
+
+	list_for_each_entry(attach_obj, &dmabuf->attachments, node) {
+		if (attach_obj->dev->coherent_dma_mask == DMA_BIT_MASK(32))
+			return attach_obj->dev;
+	}
+
+	return NULL;
+}
+
+/**
+ * smaf_cma_match - return true if at least one device has been found
+ */
+static bool smaf_cma_match(struct dma_buf *dmabuf)
+{
+	return !!find_matching_device(dmabuf);
+}
+
+static void smaf_cma_release(struct dma_buf *dmabuf)
+{
+	struct smaf_cma_buffer_info *info = dmabuf->priv;
+
+	dma_free_attrs(info->dev, info->size, info->vaddr,
+		       info->paddr, &info->attrs);
+
+	kfree(info);
+}
+
+static struct sg_table *smaf_cma_map(struct dma_buf_attachment *attachment,
+				     enum dma_data_direction direction)
+{
+	struct smaf_cma_buffer_info *info = attachment->dmabuf->priv;
+	struct sg_table *sgt;
+	int ret;
+
+	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
+	if (!sgt)
+		return NULL;
+
+	ret = dma_get_sgtable(info->dev, sgt, info->vaddr,
+			      info->paddr, info->size);
+	if (ret < 0)
+		goto out;
+
+	sg_dma_address(sgt->sgl) = info->paddr;
+	return sgt;
+
+out:
+	kfree(sgt);
+	return NULL;
+}
+
+static void smaf_cma_unmap(struct dma_buf_attachment *attachment,
+			   struct sg_table *sgt,
+			   enum dma_data_direction direction)
+{
+	/* do nothing */
+}
+
+static int smaf_cma_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
+{
+	struct smaf_cma_buffer_info *info = dmabuf->priv;
+
+	if (info->size < vma->vm_end - vma->vm_start)
+		return -EINVAL;
+
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
+	return dma_mmap_attrs(info->dev, vma, info->vaddr, info->paddr,
+			      info->size, &info->attrs);
+}
+
+static void *smaf_cma_vmap(struct dma_buf *dmabuf)
+{
+	struct smaf_cma_buffer_info *info = dmabuf->priv;
+
+	return info->vaddr;
+}
+
+static void *smaf_kmap_atomic(struct dma_buf *dmabuf, unsigned long offset)
+{
+	struct smaf_cma_buffer_info *info = dmabuf->priv;
+
+	return (void *)info->vaddr + offset;
+}
+
+static const struct dma_buf_ops smaf_cma_ops = {
+	.map_dma_buf = smaf_cma_map,
+	.unmap_dma_buf = smaf_cma_unmap,
+	.mmap = smaf_cma_mmap,
+	.release = smaf_cma_release,
+	.kmap_atomic = smaf_kmap_atomic,
+	.kmap = smaf_kmap_atomic,
+	.vmap = smaf_cma_vmap,
+};
+
+static struct dma_buf *smaf_cma_allocate(struct dma_buf *dmabuf, size_t length)
+{
+	struct dma_buf_attachment *attach_obj;
+	struct smaf_cma_buffer_info *info;
+	struct dma_buf *cma_dmabuf;
+
+	DEFINE_DMA_BUF_EXPORT_INFO(export);
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return NULL;
+
+	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &info->attrs);
+
+	info->dev = find_matching_device(dmabuf);
+	info->size = length;
+	info->vaddr = dma_alloc_attrs(info->dev, info->size, &info->paddr,
+				      GFP_KERNEL | __GFP_NOWARN, &info->attrs);
+	if (!info->vaddr)
+		goto alloc_error;
+
+	export.ops = &smaf_cma_ops;
+	export.size = info->size;
+	export.priv = info;
+
+	cma_dmabuf = dma_buf_export(&export);
+	if (IS_ERR(cma_dmabuf))
+		goto export_error;
+
+	list_for_each_entry(attach_obj, &dmabuf->attachments, node) {
+		dma_buf_attach(cma_dmabuf, attach_obj->dev);
+	}
+
+	return cma_dmabuf;
+
+export_error:
+	dma_free_attrs(info->dev, info->size, &info->paddr,
+		       GFP_KERNEL | __GFP_NOWARN, &info->attrs);
+alloc_error:
+	kfree(info);
+	return NULL;
+}
+
+static struct smaf_allocator smaf_cma = {
+	.match = smaf_cma_match,
+	.allocate = smaf_cma_allocate,
+	.name = "smaf-cma",
+	.ranking = 0,
+};
+
+static int __init smaf_cma_init(void)
+{
+	return smaf_register_allocator(&smaf_cma);
+}
+module_init(smaf_cma_init);
+
+static void __exit smaf_cma_deinit(void)
+{
+	smaf_unregister_allocator(&smaf_cma);
+}
+module_exit(smaf_cma_deinit);
+
+MODULE_DESCRIPTION("SMAF CMA module");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard@linaro.org>");
-- 
1.9.1

