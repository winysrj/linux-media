Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35479 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752495AbdATPcp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 10:32:45 -0500
Received: by mail-wm0-f52.google.com with SMTP id r126so42131031wmr.0
        for <linux-media@vger.kernel.org>; Fri, 20 Jan 2017 07:32:45 -0800 (PST)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linaro-kernel@lists.linaro.org, arnd@arndb.de, labbott@redhat.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, daniel.vetter@ffwll.ch,
        laurent.pinchart@ideasonboard.com, robdclark@gmail.com
Cc: broonie@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [RFC simple allocator v1 2/2] add CMA simple allocator module
Date: Fri, 20 Jan 2017 16:32:31 +0100
Message-Id: <1484926351-30185-3-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1484926351-30185-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1484926351-30185-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add simple allocator for CMA regions

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/simpleallocator/Kconfig                |   7 +
 drivers/simpleallocator/Makefile               |   1 +
 drivers/simpleallocator/simple-allocator-cma.c | 187 +++++++++++++++++++++++++
 3 files changed, 195 insertions(+)
 create mode 100644 drivers/simpleallocator/simple-allocator-cma.c

diff --git a/drivers/simpleallocator/Kconfig b/drivers/simpleallocator/Kconfig
index c6fc2e3..788fb0b 100644
--- a/drivers/simpleallocator/Kconfig
+++ b/drivers/simpleallocator/Kconfig
@@ -7,4 +7,11 @@ config SIMPLE_ALLOCATOR
 	   The Simple Allocator Framework adds an API to allocate and share
 	   memory in userland.
 
+config SIMPLE_ALLOCATOR_CMA
+	tristate "Simple Allocator CMA"
+	select SIMPLE_ALLOCATOR
+	depends on DMA_CMA
+	---help---
+	   Select this option to enable Simple Allocator on CMA area.
+
 endmenu
diff --git a/drivers/simpleallocator/Makefile b/drivers/simpleallocator/Makefile
index e27c6ad..4e11611 100644
--- a/drivers/simpleallocator/Makefile
+++ b/drivers/simpleallocator/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_SIMPLE_ALLOCATOR) += simple-allocator.o
+obj-$(CONFIG_SIMPLE_ALLOCATOR_CMA) += simple-allocator-cma.o
diff --git a/drivers/simpleallocator/simple-allocator-cma.c b/drivers/simpleallocator/simple-allocator-cma.c
new file mode 100644
index 0000000..b240913
--- /dev/null
+++ b/drivers/simpleallocator/simple-allocator-cma.c
@@ -0,0 +1,187 @@
+/*
+ * Copyright (C) Linaro 2017
+ *
+ * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org>
+ *
+ * License terms:  GNU General Public License (GPL)
+ */
+
+#include <linux/cma.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include "simple-allocator-priv.h"
+#include "../mm/cma.h"
+
+struct sa_cma_device {
+	struct sa_device parent;
+	struct cma *cma;
+};
+
+struct sa_cma_buffer_info {
+	void *vaddr;
+	size_t count;
+	size_t size;
+	struct page *pages;
+	struct sa_cma_device *sa_cma;
+};
+
+static struct sa_cma_device *sa_cma[MAX_CMA_AREAS];
+
+static inline struct sa_cma_device *to_sa_cma(struct sa_device *sadev)
+{
+	return container_of(sadev, struct sa_cma_device, parent);
+}
+
+static struct sg_table *sa_cma_map_dma_buf(struct dma_buf_attachment *attach,
+					   enum dma_data_direction direction)
+{
+	struct dma_buf *dmabuf = attach->dmabuf;
+	struct sa_cma_buffer_info *info = dmabuf->priv;
+	struct sg_table *sgt;
+	int ret;
+
+	ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
+	if (unlikely(ret))
+		return NULL;
+
+	sg_set_page(sgt->sgl, info->pages, PAGE_ALIGN(info->size), 0);
+	sg_dma_address(sgt->sgl) = (dma_addr_t) page_address(info->pages);
+	sg_dma_len(sgt->sgl) = PAGE_ALIGN(info->size);
+
+	return sgt;
+}
+
+static void sa_cma_unmap_dma_buf(struct dma_buf_attachment *attach,
+				 struct sg_table *sgt,
+				 enum dma_data_direction dir)
+{
+	kfree(sgt);
+}
+
+static int sa_cma_mmap_dma_buf(struct dma_buf *dmabuf,
+			       struct vm_area_struct *vma)
+{
+	struct sa_cma_buffer_info *info = dmabuf->priv;
+	unsigned long user_count = vma_pages(vma);
+	unsigned long count = info->count;
+	unsigned long pfn = page_to_pfn(info->pages);
+	unsigned long off = vma->vm_pgoff;
+	int ret = -ENXIO;
+
+	if (off < count && user_count <= (count - off)) {
+		ret = remap_pfn_range(vma, vma->vm_start,
+				      pfn + off,
+				      user_count << PAGE_SHIFT,
+				      vma->vm_page_prot);
+	}
+
+	return ret;
+}
+
+static void sa_cma_release_dma_buf(struct dma_buf *dmabuf)
+{
+	struct sa_cma_buffer_info *info = dmabuf->priv;
+
+	cma_release(info->sa_cma->cma, info->pages, info->count);
+
+	kfree(info);
+}
+
+static void *sa_cma_kmap_dma_buf(struct dma_buf *dmabuf, unsigned long offset)
+{
+	struct sa_cma_buffer_info *info = dmabuf->priv;
+
+	return page_address(info->pages) + offset;
+}
+
+static struct dma_buf_ops sa_dma_buf_ops = {
+	.map_dma_buf = sa_cma_map_dma_buf,
+	.unmap_dma_buf = sa_cma_unmap_dma_buf,
+	.mmap = sa_cma_mmap_dma_buf,
+	.release = sa_cma_release_dma_buf,
+	.kmap_atomic = sa_cma_kmap_dma_buf,
+	.kmap = sa_cma_kmap_dma_buf,
+};
+
+static struct dma_buf *sa_cma_allocate(struct sa_device *sadev,
+				       u64 length, u32 flags)
+{
+	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
+	struct sa_cma_buffer_info *info;
+	struct dma_buf *dmabuf;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return NULL;
+
+	info->count = round_up(length, PAGE_SIZE);
+	info->size = length;
+	info->sa_cma = to_sa_cma(sadev);
+
+	info->pages = cma_alloc(info->sa_cma->cma, info->count, 0);
+
+	if (!info->pages)
+		goto cleanup;
+
+	exp_info.ops = &sa_dma_buf_ops;
+	exp_info.size = info->size;
+	exp_info.flags = flags;
+	exp_info.priv = info;
+
+	dmabuf = dma_buf_export(&exp_info);
+	if (IS_ERR(dmabuf))
+		goto export_failed;
+
+	return dmabuf;
+
+export_failed:
+	cma_release(info->sa_cma->cma, info->pages, info->count);
+cleanup:
+	kfree(info);
+	return NULL;
+}
+
+struct sa_cma_device *simple_allocator_register_cma(struct cma *cma)
+{
+	struct sa_cma_device *sa_cma;
+	int ret;
+
+	sa_cma = kzalloc(sizeof(*sa_cma), GFP_KERNEL);
+	if (!sa_cma)
+		return NULL;
+
+	sa_cma->cma = cma;
+	sa_cma->parent.owner = THIS_MODULE;
+	sa_cma->parent.name = "cma";
+	sa_cma->parent.allocate = sa_cma_allocate;
+
+	ret = simple_allocator_register(&sa_cma->parent);
+	if (ret) {
+		kfree(sa_cma);
+		return NULL;
+	}
+
+	return sa_cma;
+}
+
+static int __init sa_cma_init(void)
+{
+	int i;
+
+	for (i = 0; i < cma_area_count; i++)
+		sa_cma[i] = simple_allocator_register_cma(&cma_areas[i]);
+
+	return 0;
+}
+
+static void __exit sa_cma_exit(void)
+{
+	int i;
+
+	for (i = 0; i < cma_area_count; i++)
+		simple_allocator_unregister(&sa_cma[i]->parent);
+}
+
+module_init(sa_cma_init);
+module_exit(sa_cma_exit);
-- 
1.9.1

