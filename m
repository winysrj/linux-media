Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:40515 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751486AbdLBEda (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 23:33:30 -0500
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        hyungwoo.yang@intel.com, chiranjeevi.rapolu@intel.com,
        jerry.w.hu@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v5 04/12] intel-ipu3: Implement DMA mapping functions
Date: Fri,  1 Dec 2017 22:32:14 -0600
Message-Id: <1512189142-19863-5-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1512189142-19863-1-git-send-email-yong.zhi@intel.com>
References: <1512189142-19863-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Figa <tfiga@chromium.org>

This driver uses IOVA space for buffer mapping through IPU3 MMU
to transfer data between imaging pipelines and system DDR.

Signed-off-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/pci/intel/ipu3/Kconfig         |   8 +
 drivers/media/pci/intel/ipu3/Makefile        |   2 +-
 drivers/media/pci/intel/ipu3/ipu3-css-pool.h |  53 +++++
 drivers/media/pci/intel/ipu3/ipu3-dmamap.c   | 291 +++++++++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-dmamap.h   |  33 +++
 drivers/media/pci/intel/ipu3/ipu3.h          | 165 +++++++++++++++
 6 files changed, 551 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.h
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.h
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3.h

diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
index 6beb11189ed2..91312cd8a26e 100644
--- a/drivers/media/pci/intel/ipu3/Kconfig
+++ b/drivers/media/pci/intel/ipu3/Kconfig
@@ -24,3 +24,11 @@ config INTEL_IPU3_MMU
 	---help---
 	  For IPU3, this option enables its MMU driver to translate its internal
 	  virtual address to 39 bits wide physical address for 64GBytes space access.
+
+config INTEL_IPU3_DMAMAP
+	tristate
+	default n
+	select IOMMU_IOVA
+	select INTEL_IPU3_MMU
+	---help---
+	  This is IPU3 IOMMU domain specific DMA driver.
diff --git a/drivers/media/pci/intel/ipu3/Makefile b/drivers/media/pci/intel/ipu3/Makefile
index 1cbb3cab83ef..d2e655b11802 100644
--- a/drivers/media/pci/intel/ipu3/Makefile
+++ b/drivers/media/pci/intel/ipu3/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_VIDEO_IPU3_CIO2) += ipu3-cio2.o
 obj-$(CONFIG_INTEL_IPU3_MMU) += ipu3-mmu.o
-
+obj-$(CONFIG_INTEL_IPU3_DMAMAP) += ipu3-dmamap.o
diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-pool.h b/drivers/media/pci/intel/ipu3/ipu3-css-pool.h
new file mode 100644
index 000000000000..b60bcf2ad432
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3-css-pool.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2017 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __IPU3_UTIL_H
+#define __IPU3_UTIL_H
+
+struct device;
+
+#define sqr(x)				((x) * (x))
+#define DIV_ROUND_CLOSEST_DOWN(a, b)	(((a) + (b / 2) - 1) / (b))
+#define roundclosest_down(a, b)		(DIV_ROUND_CLOSEST_DOWN(a, b) * (b))
+#define roundclosest(n, di)				\
+	({ typeof(n) __n = (n); typeof(di) __di = (di); \
+	DIV_ROUND_CLOSEST(__n, __di) * __di; })
+
+#define IPU3_CSS_POOL_SIZE		4
+
+struct ipu3_css_map {
+	size_t size;
+	void *vaddr;
+	dma_addr_t daddr;
+	struct vm_struct *vma;
+};
+
+struct ipu3_css_pool {
+	struct {
+		struct ipu3_css_map param;
+		long framenum;
+	} entry[IPU3_CSS_POOL_SIZE];
+	unsigned int last; /* Latest entry */
+};
+
+int ipu3_css_dma_buffer_resize(struct device *dev, struct ipu3_css_map *map,
+			       size_t size);
+void ipu3_css_pool_cleanup(struct device *dev, struct ipu3_css_pool *pool);
+int ipu3_css_pool_init(struct device *dev, struct ipu3_css_pool *pool,
+		       int size);
+int ipu3_css_pool_get(struct ipu3_css_pool *pool, long framenum);
+void ipu3_css_pool_put(struct ipu3_css_pool *pool);
+const struct ipu3_css_map *ipu3_css_pool_last(struct ipu3_css_pool *pool,
+					      unsigned int last);
+
+#endif
diff --git a/drivers/media/pci/intel/ipu3/ipu3-dmamap.c b/drivers/media/pci/intel/ipu3/ipu3-dmamap.c
new file mode 100644
index 000000000000..db33572b5feb
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3-dmamap.c
@@ -0,0 +1,291 @@
+/*
+ * Copyright (c) 2017 Intel Corporation.
+ * Copyright (C) 2017 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+
+#include "ipu3.h"
+#include "ipu3-css-pool.h"
+#include "ipu3-mmu.h"
+
+static void ipu3_dmamap_free_buffer(struct page **pages,
+				    size_t size)
+{
+	int count = size >> PAGE_SHIFT;
+
+	while (count--)
+		__free_page(pages[count]);
+	kvfree(pages);
+}
+
+/*
+ * Based on the implementation of __iommu_dma_alloc_pages()
+ * defined in drivers/iommu/dma-iommu.c
+ */
+static struct page **ipu3_dmamap_alloc_buffer(size_t size,
+					      unsigned long order_mask,
+					      gfp_t gfp)
+{
+	struct page **pages;
+	unsigned int i = 0, count = size >> PAGE_SHIFT;
+	const gfp_t high_order_gfp = __GFP_NOWARN | __GFP_NORETRY;
+
+	/* Allocate mem for array of page ptrs */
+	pages = kvmalloc_array(count, sizeof(struct page *), GFP_KERNEL);
+
+	if (!pages)
+		return NULL;
+
+	order_mask &= (2U << MAX_ORDER) - 1;
+	if (!order_mask)
+		return NULL;
+
+	gfp |= __GFP_HIGHMEM | __GFP_ZERO;
+
+	while (count) {
+		struct page *page = NULL;
+		unsigned int order_size;
+
+		for (order_mask &= (2U << __fls(count)) - 1;
+		     order_mask; order_mask &= ~order_size) {
+			unsigned int order = __fls(order_mask);
+
+			order_size = 1U << order;
+			page = alloc_pages((order_mask - order_size) ?
+					   gfp | high_order_gfp : gfp, order);
+			if (!page)
+				continue;
+			if (!order)
+				break;
+			if (!PageCompound(page)) {
+				split_page(page, order);
+				break;
+			}
+
+			__free_pages(page, order);
+		}
+		if (!page) {
+			ipu3_dmamap_free_buffer(pages, i << PAGE_SHIFT);
+			return NULL;
+		}
+		count -= order_size;
+		while (order_size--)
+			pages[i++] = page++;
+	}
+
+	return pages;
+}
+
+/**
+ * ipu3_dmamap_alloc - allocate and map a buffer into KVA
+ * @dev: struct device pointer
+ * @map: struct to store mapping variables
+ * @len: size required
+ *
+ * Return KVA on success or NULL on failure
+ */
+void *ipu3_dmamap_alloc(struct device *dev, struct ipu3_css_map *map,
+			size_t len)
+{
+	struct imgu_device *imgu = dev_get_drvdata(dev);
+	unsigned long shift = iova_shift(&imgu->iova_domain);
+	unsigned int alloc_sizes = imgu->mmu->pgsize_bitmap;
+	size_t size = PAGE_ALIGN(len);
+	struct page **pages;
+	dma_addr_t iovaddr;
+	struct iova *iova;
+	int i, rval;
+
+	if (WARN_ON(!dev))
+		return NULL;
+
+	dev_dbg(dev, "%s: allocating %zu\n", __func__, size);
+
+	iova = alloc_iova(&imgu->iova_domain, size >> shift,
+			  imgu->mmu->aperture_end >> shift, 0);
+	if (!iova)
+		return NULL;
+
+	pages = ipu3_dmamap_alloc_buffer(size, alloc_sizes >> PAGE_SHIFT,
+					 GFP_KERNEL);
+	if (!pages)
+		goto out_free_iova;
+
+	/* Call mmu driver to setup pgt */
+	iovaddr = iova_dma_addr(&imgu->iova_domain, iova);
+	for (i = 0; i < size / PAGE_SIZE; ++i) {
+		rval = ipu3_mmu_map(imgu->mmu, iovaddr,
+				    page_to_phys(pages[i]), PAGE_SIZE);
+		if (rval)
+			goto out_unmap;
+
+		iovaddr += PAGE_SIZE;
+	}
+
+	/* Now grab a virtual region */
+	map->vma = __get_vm_area(size, VM_USERMAP, VMALLOC_START, VMALLOC_END);
+	if (!map->vma)
+		goto out_unmap;
+
+	map->vma->pages = pages;
+	/* And map it in KVA */
+	if (map_vm_area(map->vma, PAGE_KERNEL, pages))
+		goto out_vunmap;
+
+	map->size = size;
+	map->daddr = iova_dma_addr(&imgu->iova_domain, iova);
+	map->vaddr = map->vma->addr;
+
+	dev_dbg(dev, "%s: allocated %zu @ IOVA %pad @ VA %p\n", __func__,
+		size, &map->daddr, map->vma->addr);
+
+	return map->vma->addr;
+
+out_vunmap:
+	vunmap(map->vma->addr);
+
+out_unmap:
+	ipu3_dmamap_free_buffer(pages, size);
+	ipu3_mmu_unmap(imgu->mmu, iova_dma_addr(&imgu->iova_domain, iova),
+		       i * PAGE_SIZE);
+	map->vma = NULL;
+
+out_free_iova:
+	__free_iova(&imgu->iova_domain, iova);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(ipu3_dmamap_alloc);
+
+void ipu3_dmamap_unmap(struct device *dev, struct ipu3_css_map *map)
+{
+	struct imgu_device *imgu = dev_get_drvdata(dev);
+	struct iova *iova;
+
+	iova = find_iova(&imgu->iova_domain,
+			 iova_pfn(&imgu->iova_domain, map->daddr));
+	if (WARN_ON(!iova))
+		return;
+
+	ipu3_mmu_unmap(imgu->mmu, iova_dma_addr(&imgu->iova_domain, iova),
+		       iova_size(iova) << iova_shift(&imgu->iova_domain));
+
+	__free_iova(&imgu->iova_domain, iova);
+}
+EXPORT_SYMBOL_GPL(ipu3_dmamap_unmap);
+
+void ipu3_dmamap_free(struct device *dev, struct ipu3_css_map *map)
+{
+	struct vm_struct *area = map->vma;
+
+	dev_dbg(dev, "%s: freeing %zu @ IOVA %pad @ VA %p\n",
+		__func__, map->size, &map->daddr, map->vaddr);
+
+	if (!map->vaddr)
+		return;
+
+	ipu3_dmamap_unmap(dev, map);
+
+	if (WARN_ON(!area) || WARN_ON(!area->pages))
+		return;
+
+	ipu3_dmamap_free_buffer(area->pages, map->size);
+	vunmap(map->vaddr);
+	map->vaddr = NULL;
+}
+EXPORT_SYMBOL_GPL(ipu3_dmamap_free);
+
+int ipu3_dmamap_map_sg(struct device *dev, struct scatterlist *sglist,
+		       int nents, struct ipu3_css_map *map)
+{
+	struct imgu_device *imgu = dev_get_drvdata(dev);
+	unsigned long shift = iova_shift(&imgu->iova_domain);
+	struct scatterlist *sg;
+	struct iova *iova;
+	size_t size = 0;
+	int i;
+
+	for_each_sg(sglist, sg, nents, i) {
+		if (sg->offset)
+			return -EINVAL;
+
+		if (i != nents - 1 && !PAGE_ALIGNED(sg->length))
+			return -EINVAL;
+
+		size += sg->length;
+	}
+
+	size = iova_align(&imgu->iova_domain, size);
+	dev_dbg(dev, "dmamap: mapping sg %d entries, %zu pages\n",
+		nents, size >> shift);
+
+	iova = alloc_iova(&imgu->iova_domain, size >> shift,
+			  imgu->mmu->aperture_end >> shift, 0);
+	if (!iova)
+		return -ENOMEM;
+
+	dev_dbg(dev, "dmamap: iova low pfn %lu, high pfn %lu\n",
+		iova->pfn_lo, iova->pfn_hi);
+
+	if (ipu3_mmu_map_sg(imgu->mmu, iova_dma_addr(&imgu->iova_domain, iova),
+			    sglist, nents) < size)
+		goto out_fail;
+
+	memset(map, 0, sizeof(*map));
+	map->daddr = iova_dma_addr(&imgu->iova_domain, iova);
+	map->size = size;
+
+	return 0;
+
+out_fail:
+	__free_iova(&imgu->iova_domain, iova);
+
+	return -EFAULT;
+}
+EXPORT_SYMBOL_GPL(ipu3_dmamap_map_sg);
+
+int ipu3_dmamap_init(struct device *dev)
+{
+	struct imgu_device *imgu = dev_get_drvdata(dev);
+	unsigned long order, base_pfn;
+	int ret;
+
+	ret = iova_cache_get();
+	if (ret)
+		return ret;
+
+	order = __ffs(imgu->mmu->pgsize_bitmap);
+	base_pfn = max_t(unsigned long, 1, imgu->mmu->aperture_start >> order);
+
+	init_iova_domain(&imgu->iova_domain, 1UL << order, base_pfn);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu3_dmamap_init);
+
+void ipu3_dmamap_exit(struct device *dev)
+{
+	struct imgu_device *imgu = dev_get_drvdata(dev);
+
+	put_iova_domain(&imgu->iova_domain);
+	iova_cache_put();
+	imgu->mmu = NULL;
+}
+EXPORT_SYMBOL_GPL(ipu3_dmamap_exit);
+
+MODULE_AUTHOR("Tomasz Figa <tfiga@chromium.org>");
+MODULE_AUTHOR("Yong Zhi <yong.zhi@intel.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("IPU3 DMA mapping support");
diff --git a/drivers/media/pci/intel/ipu3/ipu3-dmamap.h b/drivers/media/pci/intel/ipu3/ipu3-dmamap.h
new file mode 100644
index 000000000000..ee1321406972
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3-dmamap.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (c) 2017 Intel Corporation.
+ * Copyright (C) 2017 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __IPU3_DMAMAP_H
+#define __IPU3_DMAMAP_H
+
+struct imgu_device;
+struct scatterlist;
+
+void *ipu3_dmamap_alloc(struct device *dev, struct ipu3_css_map *map,
+			size_t len);
+void ipu3_dmamap_free(struct device *dev, struct ipu3_css_map *map);
+
+int ipu3_dmamap_map_sg(struct device *dev, struct scatterlist *sglist,
+		       int nents, struct ipu3_css_map *map);
+void ipu3_dmamap_unmap(struct device *dev, struct ipu3_css_map *map);
+
+int ipu3_dmamap_init(struct device *dev);
+void ipu3_dmamap_exit(struct device *dev);
+
+#endif
diff --git a/drivers/media/pci/intel/ipu3/ipu3.h b/drivers/media/pci/intel/ipu3/ipu3.h
new file mode 100644
index 000000000000..ad2b43943b5f
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3.h
@@ -0,0 +1,165 @@
+/*
+ * Copyright (c) 2017 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __IPU3_H
+#define __IPU3_H
+
+#include <linux/iova.h>
+#include <linux/pci.h>
+
+#include <media/v4l2-device.h>
+#include <media/videobuf2-dma-sg.h>
+
+#include "ipu3-css.h"
+
+#define IMGU_NAME			"ipu3-imgu"
+
+/*
+ * The semantics of the driver is that whenever there is a buffer available in
+ * master queue, the driver queues a buffer also to all other active nodes.
+ * If user space hasn't provided a buffer to all other video nodes first,
+ * the driver gets an internal dummy buffer and queues it.
+ */
+#define IMGU_QUEUE_MASTER		IPU3_CSS_QUEUE_IN
+#define IMGU_QUEUE_FIRST_INPUT		IPU3_CSS_QUEUE_OUT
+#define IMGU_MAX_QUEUE_DEPTH		(2 + 2)
+
+#define IMGU_NODE_IN			0 /* Input RAW image */
+#define IMGU_NODE_PARAMS		1 /* Input parameters */
+#define IMGU_NODE_OUT			2 /* Main output for still or video */
+#define IMGU_NODE_VF			3 /* Preview */
+#define IMGU_NODE_PV			4 /* Postview for still capture */
+#define IMGU_NODE_STAT_3A		5 /* 3A statistics */
+#define IMGU_NODE_STAT_DVS		6 /* DVS statistics */
+#define IMGU_NODE_NUM			7
+
+#define file_to_intel_ipu3_node(__file) \
+	container_of(video_devdata(__file), struct imgu_video_device, vdev)
+
+#define IPU3_INPUT_MIN_WIDTH		0U
+#define IPU3_INPUT_MIN_HEIGHT		0U
+#define IPU3_INPUT_MAX_WIDTH		5120U
+#define IPU3_INPUT_MAX_HEIGHT		38404U
+#define IPU3_OUTPUT_MIN_WIDTH		2U
+#define IPU3_OUTPUT_MIN_HEIGHT		2U
+#define IPU3_OUTPUT_MAX_WIDTH		4480U
+#define IPU3_OUTPUT_MAX_HEIGHT		34004U
+
+struct ipu3_vb2_buffer {
+	/* Public fields */
+	struct vb2_v4l2_buffer vbb;	/* Must be the first field */
+
+	/* Private fields */
+	struct list_head list;
+};
+
+struct imgu_buffer {
+	struct ipu3_vb2_buffer vid_buf;	/* Must be the first field */
+	struct ipu3_css_buffer css_buf;
+	struct ipu3_css_map map;
+};
+
+struct imgu_node_mapping {
+	unsigned int css_queue;
+	const char *name;
+};
+
+/**
+ * struct imgu_video_device
+ * each node registers as video device and maintains its
+ * own vb2_queue.
+ */
+struct imgu_video_device {
+	const char *name;
+	bool output;		/* Frames to the driver? */
+	bool immutable;		/* Can not be enabled/disabled */
+	bool enabled;
+	int queued;		/* Buffers already queued */
+	struct v4l2_format vdev_fmt;	/* Currently set format */
+
+	/* Private fields */
+	struct video_device vdev;
+	struct media_pad vdev_pad;
+	struct v4l2_mbus_framefmt pad_fmt;
+	struct vb2_queue vbq;
+	struct list_head buffers;
+	/* Protect vb2_queue and vdev structs*/
+	struct mutex lock;
+	atomic_t sequence;
+};
+
+/*
+ * imgu_device -- ImgU (Imaging Unit) driver
+ */
+struct imgu_device {
+	struct pci_dev *pci_dev;
+	void __iomem *base;
+
+	/* Internally enabled queues */
+	struct {
+		struct ipu3_css_map dmap;
+		struct ipu3_css_buffer dummybufs[IMGU_MAX_QUEUE_DEPTH];
+	} queues[IPU3_CSS_QUEUES];
+	struct imgu_video_device nodes[IMGU_NODE_NUM];
+	bool queue_enabled[IMGU_NODE_NUM];
+
+	/* Public fields, fill before registering */
+	unsigned int buf_struct_size;
+	bool streaming;		/* Public read only */
+	struct v4l2_ctrl_handler *ctrl_handler;
+
+	/* Private fields */
+	struct v4l2_device v4l2_dev;
+	struct media_device media_dev;
+	struct media_pipeline pipeline;
+	struct v4l2_subdev subdev;
+	struct media_pad *subdev_pads;
+	struct v4l2_file_operations v4l2_file_ops;
+
+	/* MMU driver for css */
+	struct ipu3_mmu_info *mmu;
+	struct iova_domain iova_domain;
+
+	/* css - Camera Sub-System */
+	struct ipu3_css css;
+
+	/*
+	 * Coarse-grained lock to protect
+	 * vid_buf.list and css->queue
+	 */
+	struct mutex lock;
+	/* Forbit streaming and buffer queuing during system suspend. */
+	struct mutex qbuf_lock;
+	struct {
+		struct v4l2_rect eff; /* effective resolution */
+		struct v4l2_rect bds; /* bayer-domain scaled resolution*/
+		struct v4l2_rect gdc; /* gdc output resolution */
+	} rect;
+	/* Indicate if system suspend take place while imgu is streaming. */
+	bool suspend_in_stream;
+	/* Used to wait for FW buffer queue drain. */
+	wait_queue_head_t buf_drain_wq;
+};
+
+unsigned int imgu_node_to_queue(unsigned int node);
+unsigned int imgu_map_node(struct imgu_device *imgu, unsigned int css_queue);
+int imgu_queue_buffers(struct imgu_device *imgu, bool initial);
+
+int ipu3_v4l2_register(struct imgu_device *dev);
+int ipu3_v4l2_unregister(struct imgu_device *dev);
+void ipu3_v4l2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
+
+int imgu_s_stream(struct imgu_device *imgu, int enable);
+
+#endif
-- 
2.7.4
