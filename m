Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC124C67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82FD820645
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82FD820645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbeLMJvR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:51:17 -0500
Received: from mga07.intel.com ([134.134.136.100]:51733 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728008AbeLMJvQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:51:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 01:51:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="303483707"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga005.fm.intel.com with ESMTP; 13 Dec 2018 01:51:14 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id BB9422029C;
        Thu, 13 Dec 2018 11:51:13 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXNeB-0003tX-8L; Thu, 13 Dec 2018 11:51:11 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, laurent.pinchart@ideasonboard.com,
        rajmohan.mani@intel.com
Subject: [PATCH v9 06/22] media: staging/intel-ipu3: Implement DMA mapping functions
Date:   Thu, 13 Dec 2018 11:50:51 +0200
Message-Id: <20181213095107.14894-7-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
References: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Tomasz Figa <tfiga@chromium.org>

This driver uses IOVA space for buffer mapping through IPU3 MMU
to transfer data between imaging pipelines and system DDR.

Signed-off-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/ipu3/ipu3-dmamap.c | 270 +++++++++++++++++++++++++++++++
 drivers/staging/media/ipu3/ipu3-dmamap.h |  22 +++
 2 files changed, 292 insertions(+)
 create mode 100644 drivers/staging/media/ipu3/ipu3-dmamap.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-dmamap.h

diff --git a/drivers/staging/media/ipu3/ipu3-dmamap.c b/drivers/staging/media/ipu3/ipu3-dmamap.c
new file mode 100644
index 0000000000000..93a393d4e15e5
--- /dev/null
+++ b/drivers/staging/media/ipu3/ipu3-dmamap.c
@@ -0,0 +1,270 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018 Intel Corporation
+ * Copyright 2018 Google LLC.
+ *
+ * Author: Tomasz Figa <tfiga@chromium.org>
+ * Author: Yong Zhi <yong.zhi@intel.com>
+ */
+
+#include <linux/vmalloc.h>
+
+#include "ipu3.h"
+#include "ipu3-css-pool.h"
+#include "ipu3-mmu.h"
+
+/*
+ * Free a buffer allocated by ipu3_dmamap_alloc_buffer()
+ */
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
+	pages = kvmalloc_array(count, sizeof(*pages), GFP_KERNEL);
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
+ * @imgu: struct device pointer
+ * @map: struct to store mapping variables
+ * @len: size required
+ *
+ * Returns:
+ *  KVA on success
+ *  %NULL on failure
+ */
+void *ipu3_dmamap_alloc(struct imgu_device *imgu, struct ipu3_css_map *map,
+			size_t len)
+{
+	unsigned long shift = iova_shift(&imgu->iova_domain);
+	unsigned int alloc_sizes = imgu->mmu->pgsize_bitmap;
+	struct device *dev = &imgu->pci_dev->dev;
+	size_t size = PAGE_ALIGN(len);
+	struct page **pages;
+	dma_addr_t iovaddr;
+	struct iova *iova;
+	int i, rval;
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
+	/* Call IOMMU driver to setup pgt */
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
+
+void ipu3_dmamap_unmap(struct imgu_device *imgu, struct ipu3_css_map *map)
+{
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
+
+/*
+ * Counterpart of ipu3_dmamap_alloc
+ */
+void ipu3_dmamap_free(struct imgu_device *imgu, struct ipu3_css_map *map)
+{
+	struct vm_struct *area = map->vma;
+
+	dev_dbg(&imgu->pci_dev->dev, "%s: freeing %zu @ IOVA %pad @ VA %p\n",
+		__func__, map->size, &map->daddr, map->vaddr);
+
+	if (!map->vaddr)
+		return;
+
+	ipu3_dmamap_unmap(imgu, map);
+
+	if (WARN_ON(!area) || WARN_ON(!area->pages))
+		return;
+
+	ipu3_dmamap_free_buffer(area->pages, map->size);
+	vunmap(map->vaddr);
+	map->vaddr = NULL;
+}
+
+int ipu3_dmamap_map_sg(struct imgu_device *imgu, struct scatterlist *sglist,
+		       int nents, struct ipu3_css_map *map)
+{
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
+	dev_dbg(&imgu->pci_dev->dev, "dmamap: mapping sg %d entries, %zu pages\n",
+		nents, size >> shift);
+
+	iova = alloc_iova(&imgu->iova_domain, size >> shift,
+			  imgu->mmu->aperture_end >> shift, 0);
+	if (!iova)
+		return -ENOMEM;
+
+	dev_dbg(&imgu->pci_dev->dev, "dmamap: iova low pfn %lu, high pfn %lu\n",
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
+
+int ipu3_dmamap_init(struct imgu_device *imgu)
+{
+	unsigned long order, base_pfn;
+	int ret = iova_cache_get();
+
+	if (ret)
+		return ret;
+
+	order = __ffs(imgu->mmu->pgsize_bitmap);
+	base_pfn = max_t(unsigned long, 1, imgu->mmu->aperture_start >> order);
+	init_iova_domain(&imgu->iova_domain, 1UL << order, base_pfn);
+
+	return 0;
+}
+
+void ipu3_dmamap_exit(struct imgu_device *imgu)
+{
+	put_iova_domain(&imgu->iova_domain);
+	iova_cache_put();
+}
diff --git a/drivers/staging/media/ipu3/ipu3-dmamap.h b/drivers/staging/media/ipu3/ipu3-dmamap.h
new file mode 100644
index 0000000000000..b9d224a332733
--- /dev/null
+++ b/drivers/staging/media/ipu3/ipu3-dmamap.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018 Intel Corporation */
+/* Copyright 2018 Google LLC. */
+
+#ifndef __IPU3_DMAMAP_H
+#define __IPU3_DMAMAP_H
+
+struct imgu_device;
+struct scatterlist;
+
+void *ipu3_dmamap_alloc(struct imgu_device *imgu, struct ipu3_css_map *map,
+			size_t len);
+void ipu3_dmamap_free(struct imgu_device *imgu, struct ipu3_css_map *map);
+
+int ipu3_dmamap_map_sg(struct imgu_device *imgu, struct scatterlist *sglist,
+		       int nents, struct ipu3_css_map *map);
+void ipu3_dmamap_unmap(struct imgu_device *imgu, struct ipu3_css_map *map);
+
+int ipu3_dmamap_init(struct imgu_device *imgu);
+void ipu3_dmamap_exit(struct imgu_device *imgu);
+
+#endif
-- 
2.11.0

