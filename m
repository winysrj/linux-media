Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63229 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab2AWNvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 08:51:38 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LY900A0W7TZVI@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:35 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LY900GK67TYU2@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:35 +0000 (GMT)
Date: Mon, 23 Jan 2012 14:51:06 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 01/10] arm: dma: support for dma_get_pages
In-reply-to: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Cc: sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	pawel@osciak.com
Message-id: <1327326675-8431-2-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch provides reliable mechanism for obtaining pages associated with a
given dma_mapping.  This is a proof-of-concept patch.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/include/asm/dma-mapping.h |    8 ++++++
 arch/arm/mm/dma-mapping.c          |   44 ++++++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h        |    2 +
 3 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index ca7a378..79b6c3d 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -196,6 +196,14 @@ static inline int dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 	return ops->mmap(dev, vma, cpu_addr, dma_addr, size, attrs);
 }
 
+static inline int dma_get_pages(struct device *dev, void *cpu_addr,
+	dma_addr_t dma_addr, struct page **pages, size_t n_pages)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+	BUG_ON(!ops);
+	return ops->get_pages(dev, cpu_addr, dma_addr, pages, n_pages);
+}
+
 static inline void *dma_alloc_writecombine(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag)
 {
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 2287b01..93a3508 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -116,10 +116,14 @@ static void arm_dma_sync_single_for_device(struct device *dev,
 
 static int arm_dma_set_mask(struct device *dev, u64 dma_mask);
 
+static int arm_dma_get_pages(struct device *dev, void *cpu_addr,
+	dma_addr_t dma_addr, struct page **pages, size_t n_pages);
+
 struct dma_map_ops arm_dma_ops = {
 	.alloc			= arm_dma_alloc,
 	.free			= arm_dma_free,
 	.mmap			= arm_dma_mmap,
+	.get_pages		= arm_dma_get_pages,
 	.map_page		= arm_dma_map_page,
 	.unmap_page		= arm_dma_unmap_page,
 	.map_sg			= arm_dma_map_sg,
@@ -531,6 +535,25 @@ int arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 }
 
 /*
+ * Get pages for the DMA-coherent memory.
+ */
+static int arm_dma_get_pages(struct device *dev, void *cpu_addr,
+	dma_addr_t dma_addr, struct page **pages, size_t n_pages)
+{
+#ifdef CONFIG_MMU
+	int i;
+	unsigned long pfn = dma_to_pfn(dev, dma_addr);
+
+	for (i = 0; i < n_pages; ++i)
+		pages[i] = pfn_to_page(pfn + i);
+
+	return n_pages;
+#else
+	return -ENXIO;
+#endif	/* CONFIG_MMU */
+}
+
+/*
  * free a page as defined by the above mapping.
  * Must not be called with IRQs disabled.
  */
@@ -1033,6 +1056,26 @@ static int arm_iommu_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 	return 0;
 }
 
+static int arm_iommu_get_pages(struct device *dev, void *cpu_addr,
+	dma_addr_t dma_addr, struct page **pages, size_t n_pages)
+{
+	struct arm_vmregion *c;
+	int n_valid_pages;
+
+	c = arm_vmregion_find(&consistent_head, (unsigned long)cpu_addr);
+
+	if (!c)
+		return -ENXIO;
+
+	n_valid_pages = (c->vm_end - c->vm_start) >> PAGE_SHIFT;
+	if (n_valid_pages < n_pages)
+		n_pages = n_valid_pages;
+
+	memcpy(pages, c->priv, n_pages * sizeof pages[0]);
+
+	return n_pages;
+}
+
 /*
  * free a page as defined by the above mapping.
  * Must not be called with IRQs disabled.
@@ -1271,6 +1314,7 @@ struct dma_map_ops iommu_ops = {
 	.alloc		= arm_iommu_alloc_attrs,
 	.free		= arm_iommu_free_attrs,
 	.mmap		= arm_iommu_mmap_attrs,
+	.get_pages	= arm_iommu_get_pages,
 
 	.map_page		= arm_iommu_map_page,
 	.unmap_page		= arm_iommu_unmap_page,
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index b903a20..409d3a9 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -17,6 +17,8 @@ struct dma_map_ops {
 			      struct dma_attrs *attrs);
 	int (*mmap)(struct device *, struct vm_area_struct *,
 			  void *, dma_addr_t, size_t, struct dma_attrs *attrs);
+	int (*get_pages)(struct device *dev, void *vaddr, dma_addr_t dma_addr,
+			struct page **pages, size_t n_pages);
 
 	dma_addr_t (*map_page)(struct device *dev, struct page *page,
 			       unsigned long offset, size_t size,
-- 
1.7.5.4

