Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:11673 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752097AbdFNWTy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 18:19:54 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v2 02/12] intel-ipu3: mmu: implement driver
Date: Wed, 14 Jun 2017 17:19:17 -0500
Message-Id: <1497478767-10270-3-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tuukka Toivonen <tuukka.toivonen@intel.com>

This driver translates Intel IPU3 internal virtual
address to physical address.

Signed-off-by: Tuukka Toivonen <tuukka.toivonen@intel.com>
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/pci/intel/ipu3/Kconfig    |  11 +
 drivers/media/pci/intel/ipu3/Makefile   |   1 +
 drivers/media/pci/intel/ipu3/ipu3-mmu.c | 422 ++++++++++++++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-mmu.h |  73 ++++++
 4 files changed, 507 insertions(+)
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.h

diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
index 2a895d6..ab2edcb 100644
--- a/drivers/media/pci/intel/ipu3/Kconfig
+++ b/drivers/media/pci/intel/ipu3/Kconfig
@@ -15,3 +15,14 @@ config VIDEO_IPU3_CIO2
 	Say Y or M here if you have a Skylake/Kaby Lake SoC with MIPI CSI-2
 	connected camera.
 	The module will be called ipu3-cio2.
+
+config INTEL_IPU3_MMU
+	tristate "Intel ipu3-mmu driver"
+	select IOMMU_API
+	select IOMMU_IOVA
+	---help---
+	  For IPU3, this option enables its MMU driver to translate its internal
+	  virtual address to 39 bits wide physical address for 64GBytes space access.
+
+	  Say Y here if you have Skylake/Kaby Lake SoC with IPU3.
+	  Say N if un-sure.
diff --git a/drivers/media/pci/intel/ipu3/Makefile b/drivers/media/pci/intel/ipu3/Makefile
index 20186e3..2b669df 100644
--- a/drivers/media/pci/intel/ipu3/Makefile
+++ b/drivers/media/pci/intel/ipu3/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_VIDEO_IPU3_CIO2) += ipu3-cio2.o
+obj-$(CONFIG_INTEL_IPU3_MMU) += ipu3-mmu.o
diff --git a/drivers/media/pci/intel/ipu3/ipu3-mmu.c b/drivers/media/pci/intel/ipu3/ipu3-mmu.c
new file mode 100644
index 0000000..26ef045
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3-mmu.c
@@ -0,0 +1,422 @@
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
+#include <asm/cacheflush.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include "ipu3-mmu.h"
+
+/**
+ * ipu3_mmu_tlb_invalidate - invalidate translation look-aside buffer
+ * @addr: base address to access REG_TLB_INVALIDATE
+ *
+ * This function must be called when MMU has power
+ */
+static void ipu3_mmu_tlb_invalidate(const struct ipu3_mmu *mmu)
+{
+	writel(TLB_INVALIDATE, mmu->base + REG_TLB_INVALIDATE);
+}
+
+static int ipu3_mmu_add_device(struct device *dev)
+{
+	struct ipu3_mmu *mmu = dev_get_drvdata(dev);
+
+	/* mapping domain must be prepared */
+	if (!mmu->domain)
+		return 0;
+
+	return iommu_attach_device(mmu->domain, dev);
+}
+
+/**
+ * ipu3_mmu_alloc_page_table - get page to fill entries with dummy defaults
+ * @u32: default value of page table entry
+ *
+ * Index of L1 page table points to L2 tbl
+ *
+ * Return: Pointer to allocated page table
+ * or NULL on failure.
+ */
+static u32 *ipu3_mmu_alloc_page_table(u32 default_entry)
+{
+	u32 *pt = (u32 *)__get_free_page(GFP_KERNEL);
+	int i;
+
+	if (!pt)
+		return NULL;
+
+	for (i = 0; i < IPU3_MMU_L1PT_PTES; i++)
+		pt[i] = default_entry;
+
+	return pt;
+}
+
+/**
+ * ipu3_mmu_domain_alloc - initialize and allocate pgt for domain
+ * @type: possible domain-types
+ *
+ * Allocate dummy page, L2 tbl and L1 tbl in that order
+ *
+ * Return: Pointer to allocated iommu_domain instance
+ * or NULL on failure.
+ */
+static struct iommu_domain *ipu3_mmu_domain_alloc(unsigned int type)
+{
+	struct ipu3_mmu_domain *mmu_dom;
+	void *ptr;
+
+	if (type != IOMMU_DOMAIN_UNMANAGED)
+		return NULL;
+
+	mmu_dom = kzalloc(sizeof(*mmu_dom), GFP_KERNEL);
+	if (!mmu_dom)
+		return NULL;
+
+	mmu_dom->domain.geometry.aperture_start = 0;
+	mmu_dom->domain.geometry.aperture_end =
+		DMA_BIT_MASK(IPU3_MMU_ADDRESS_BITS);
+	mmu_dom->domain.geometry.force_aperture = true;
+
+	ptr = (void *)__get_free_page(GFP_KERNEL);
+	if (!ptr)
+		goto fail_get_page;
+	mmu_dom->dummy_page = virt_to_phys(ptr) >> IPU3_MMU_PAGE_SHIFT;
+	ptr = ipu3_mmu_alloc_page_table(mmu_dom->dummy_page);
+	if (!ptr)
+		goto fail_page_table;
+
+	/*
+	 * We always map the L1 page table (a single page as well as
+	 * the L2 page tables).
+	 */
+	mmu_dom->dummy_l2_tbl = virt_to_phys(ptr) >> IPU3_MMU_PAGE_SHIFT;
+	mmu_dom->pgtbl = ipu3_mmu_alloc_page_table(mmu_dom->dummy_l2_tbl);
+	if (!mmu_dom->pgtbl)
+		goto fail_page_table;
+
+	spin_lock_init(&mmu_dom->lock);
+	return &mmu_dom->domain;
+
+fail_page_table:
+	free_page((unsigned long)TBL_VIRT_ADDR(mmu_dom->dummy_page));
+	free_page((unsigned long)TBL_VIRT_ADDR(mmu_dom->dummy_l2_tbl));
+fail_get_page:
+	kfree(mmu_dom);
+	return NULL;
+}
+
+static void ipu3_mmu_domain_free(struct iommu_domain *dom)
+{
+	struct ipu3_mmu_domain *mmu_dom =
+		container_of(dom, struct ipu3_mmu_domain, domain);
+	u32 l1_idx;
+
+	for (l1_idx = 0; l1_idx < IPU3_MMU_L1PT_PTES; l1_idx++)
+		if (mmu_dom->pgtbl[l1_idx] != mmu_dom->dummy_l2_tbl)
+			free_page((unsigned long)
+				  TBL_VIRT_ADDR(mmu_dom->pgtbl[l1_idx]));
+
+	free_page((unsigned long)TBL_VIRT_ADDR(mmu_dom->dummy_page));
+	free_page((unsigned long)TBL_VIRT_ADDR(mmu_dom->dummy_l2_tbl));
+	free_page((unsigned long)mmu_dom->pgtbl);
+	kfree(mmu_dom);
+}
+
+/**
+ * ipu3_mmu_map - mapping iova allocated cache to phy addr
+ * @domain: iommu domain
+ * @iova: virtual address
+ * @paddr: physical address
+ * @size: size to be mapped
+ * Allocate L2 pgt if needed and establish the mapping between
+ * iova address space and pfn
+ *
+ * Return: 0 for success
+ * or negative on failure.
+ */
+static int ipu3_mmu_map(struct iommu_domain *domain, unsigned long iova,
+			phys_addr_t paddr, size_t size, int prot)
+{
+	struct ipu3_mmu_domain *mmu_dom =
+		container_of(domain, struct ipu3_mmu_domain, domain);
+	u32 iova_start = round_down(iova, IPU3_MMU_PAGE_SIZE);
+	u32 iova_end = ALIGN(iova + size, IPU3_MMU_PAGE_SIZE);
+	u32 l1_idx = iova >> IPU3_MMU_L1PT_SHIFT;
+	u32 l1_entry = mmu_dom->pgtbl[l1_idx];
+	u32 *l2_pt;
+	u32 l2_idx;
+	unsigned long flags;
+
+	/* map to single PAGE */
+	WARN_ON(size != IPU3_MMU_PAGE_SIZE);
+
+	dev_dbg(mmu_dom->mmu->dev,
+		"mapping iova 0x%8.8x--0x%8.8x, size %zu at paddr 0x%pa\n",
+		iova_start, iova_end, size, &paddr);
+	dev_dbg(mmu_dom->mmu->dev,
+		"mapping l2 page table for l1 index %u (iova 0x%8.8lx)\n",
+		l1_idx, iova);
+
+	if (l1_entry == mmu_dom->dummy_l2_tbl) {
+		u32 *l2_virt = ipu3_mmu_alloc_page_table(mmu_dom->dummy_page);
+
+		if (!l2_virt)
+			return -ENOMEM;
+
+		l1_entry = virt_to_phys(l2_virt) >> IPU3_MMU_PAGE_SHIFT;
+		dev_dbg(mmu_dom->mmu->dev,
+			"allocated page for l1_idx %u\n", l1_idx);
+
+		spin_lock_irqsave(&mmu_dom->lock, flags);
+		if (mmu_dom->pgtbl[l1_idx] == mmu_dom->dummy_l2_tbl) {
+			mmu_dom->pgtbl[l1_idx] = l1_entry;
+			clflush_cache_range(&mmu_dom->pgtbl[l1_idx],
+					    sizeof(mmu_dom->pgtbl[l1_idx]));
+		} else {
+			spin_unlock_irqrestore(&mmu_dom->lock, flags);
+			free_page((unsigned long)TBL_VIRT_ADDR(l1_entry));
+			spin_lock_irqsave(&mmu_dom->lock, flags);
+		}
+	} else {
+		spin_lock_irqsave(&mmu_dom->lock, flags);
+	}
+
+	l2_pt = TBL_VIRT_ADDR(mmu_dom->pgtbl[l1_idx]);
+
+	dev_dbg(mmu_dom->mmu->dev, "l2_pt at %p\n", l2_pt);
+
+	paddr = ALIGN(paddr, IPU3_MMU_PAGE_SIZE);
+
+	l2_idx = (iova_start & IPU3_MMU_L2PT_MASK) >> IPU3_MMU_L2PT_SHIFT;
+
+	dev_dbg(mmu_dom->mmu->dev,
+		"l2_idx %u, phys 0x%8.8x\n", l2_idx, l2_pt[l2_idx]);
+	if (l2_pt[l2_idx] != mmu_dom->dummy_page) {
+		spin_unlock_irqrestore(&mmu_dom->lock, flags);
+		return -EBUSY;
+	}
+
+	/* write 27 bit phy addr to L2 pgt*/
+	l2_pt[l2_idx] = paddr >> IPU3_MMU_PAGE_SHIFT;
+
+	spin_unlock_irqrestore(&mmu_dom->lock, flags);
+
+	clflush_cache_range(&l2_pt[l2_idx], sizeof(l2_pt[l2_idx]));
+
+	dev_dbg(mmu_dom->mmu->dev,
+		"l2 index %u mapped as 0x%8.8x\n", l2_idx, l2_pt[l2_idx]);
+
+	ipu3_mmu_tlb_invalidate(mmu_dom->mmu);
+
+	return 0;
+}
+
+static size_t ipu3_mmu_unmap(struct iommu_domain *domain, unsigned long iova,
+			     size_t size)
+{
+	struct ipu3_mmu_domain *mmu_dom =
+		container_of(domain, struct ipu3_mmu_domain, domain);
+	u32 l1_idx = iova >> IPU3_MMU_L1PT_SHIFT;
+	u32 *l2_pt = TBL_VIRT_ADDR(mmu_dom->pgtbl[l1_idx]);
+	u32 iova_start = iova;
+	unsigned int l2_idx;
+	size_t unmapped = 0;
+
+	dev_dbg(mmu_dom->mmu->dev,
+		"unmapping l2 page table for l1 index %u (iova 0x%8.8lx)\n",
+		l1_idx, iova);
+
+	if (mmu_dom->pgtbl[l1_idx] == mmu_dom->dummy_l2_tbl)
+		return -EINVAL;
+
+	dev_dbg(mmu_dom->mmu->dev, "l2_pt at %p\n", l2_pt);
+
+	for (l2_idx = (iova_start & IPU3_MMU_L2PT_MASK) >> IPU3_MMU_L2PT_SHIFT;
+	     (iova_start & IPU3_MMU_L1PT_MASK) + (l2_idx << IPU3_MMU_PAGE_SHIFT)
+		      < iova_start + size && l2_idx < IPU3_MMU_L2PT_PTES;
+	      l2_idx++) {
+		unsigned long flags;
+
+		dev_dbg(mmu_dom->mmu->dev,
+			"l2 index %u unmapped, was 0x%10.10lx\n",
+			l2_idx, (unsigned long)TBL_PHYS_ADDR(l2_pt[l2_idx]));
+		spin_lock_irqsave(&mmu_dom->lock, flags);
+		l2_pt[l2_idx] = mmu_dom->dummy_page;
+		spin_unlock_irqrestore(&mmu_dom->lock, flags);
+		clflush_cache_range(&l2_pt[l2_idx], sizeof(l2_pt[l2_idx]));
+		unmapped++;
+	}
+
+	ipu3_mmu_tlb_invalidate(mmu_dom->mmu);
+
+	return unmapped << IPU3_MMU_PAGE_SHIFT;
+}
+
+static phys_addr_t ipu3_mmu_iova_to_phys(struct iommu_domain *domain,
+					 dma_addr_t iova)
+{
+	struct ipu3_mmu_domain *d =
+		container_of(domain, struct ipu3_mmu_domain, domain);
+	u32 *l2_pt = TBL_VIRT_ADDR(d->pgtbl[iova >> IPU3_MMU_L1PT_SHIFT]);
+
+	return (phys_addr_t)l2_pt[(iova & IPU3_MMU_L2PT_MASK)
+				>> IPU3_MMU_L2PT_SHIFT] << IPU3_MMU_PAGE_SHIFT;
+}
+
+static struct iommu_ops ipu3_mmu_ops = {
+	.add_device	= ipu3_mmu_add_device,
+	.domain_alloc   = ipu3_mmu_domain_alloc,
+	.domain_free    = ipu3_mmu_domain_free,
+	.map		= ipu3_mmu_map,
+	.unmap		= ipu3_mmu_unmap,
+	.iova_to_phys	= ipu3_mmu_iova_to_phys,
+	.pgsize_bitmap	= SZ_4K,
+};
+
+static int ipu3_mmu_bus_match(struct device *dev, struct device_driver *drv)
+{
+	return !strcmp(dev_name(dev), drv->name);
+}
+
+static int ipu3_mmu_bus_probe(struct device *dev)
+{
+	struct ipu3_mmu *mmu = dev_get_drvdata(dev);
+	struct ipu3_mmu_domain *mmu_domain;
+	int r;
+
+	r = bus_set_iommu(dev->bus, &ipu3_mmu_ops);
+	if (r)
+		return r;
+
+	/* mmu_domain allocated */
+	mmu->domain = iommu_domain_alloc(dev->bus);
+	if (!mmu->domain)
+		return -ENOMEM;
+
+	/* Write page table address */
+	mmu_domain = container_of(mmu->domain, struct ipu3_mmu_domain, domain);
+	/* Write L1 pgt addr to config reg*/
+	mmu_domain->mmu = mmu;
+
+	writel((phys_addr_t)virt_to_phys(mmu_domain->pgtbl)
+		>> IPU3_MMU_PAGE_SHIFT, mmu->base + REG_L1_PHYS);
+	ipu3_mmu_tlb_invalidate(mmu);
+	/* 4K page granularity, start and end pfn */
+	init_iova_domain(&mmu->iova_domain, SZ_4K, 1,
+			 dma_get_mask(dev) >> PAGE_SHIFT);
+
+	r = iova_cache_get();
+	if (r)
+		goto fail_cache;
+
+	return 0;
+
+fail_cache:
+	put_iova_domain(&mmu->iova_domain);
+	iommu_domain_free(mmu->domain);
+	return r;
+}
+
+static void ipu3_mmu_release(struct device *dev)
+{
+}
+
+static int ipu3_mmu_bus_remove(struct device *dev)
+{
+	struct ipu3_mmu *mmu = dev_get_drvdata(dev);
+
+	put_iova_domain(&mmu->iova_domain);
+	iova_cache_put();
+	iommu_domain_free(mmu->domain);
+
+	return 0;
+}
+
+static struct bus_type ipu3_mmu_bus = {
+	.name   = IPU3_MMU_BUS_NAME,
+	.match  = ipu3_mmu_bus_match,
+	.probe  = ipu3_mmu_bus_probe,
+	.remove = ipu3_mmu_bus_remove,
+};
+
+static struct device ipu3_mmu_device = {
+	.bus     = &ipu3_mmu_bus,
+	.release = ipu3_mmu_release,
+};
+
+static struct device_driver ipu3_mmu_driver = {
+	.name  = IPU3_MMU_NAME,
+	.owner = THIS_MODULE,
+	.bus   = &ipu3_mmu_bus,
+};
+
+int ipu3_mmu_init(struct ipu3_mmu *mmu, void __iomem *base, struct device *dev)
+{
+	struct ipu3_mmu_domain *mmu_dom;
+	int r;
+
+	mmu->base = base;
+	mmu->dev  = &ipu3_mmu_device;
+
+	r = bus_register(&ipu3_mmu_bus);
+	if (r)
+		goto fail_bus;
+
+	r = dev_set_name(mmu->dev, IPU3_MMU_NAME);
+	if (r)
+		goto fail_device;
+	if (dev->dma_mask) {
+		mmu->dma_mask = DMA_BIT_MASK(IPU3_MMU_ADDRESS_BITS);
+		mmu->dev->dma_mask = &mmu->dma_mask;
+	}
+	mmu->dev->coherent_dma_mask = mmu->dma_mask;
+	dev_set_drvdata(mmu->dev, mmu);
+	r = device_register(mmu->dev);
+	if (r) {
+		put_device(mmu->dev);
+		goto fail_device;
+	}
+
+	r = driver_register(&ipu3_mmu_driver);
+	if (r)
+		goto fail_driver;
+
+	mmu_dom = container_of(mmu->domain, struct ipu3_mmu_domain, domain);
+	mmu->pgtbl = virt_to_phys(mmu_dom->pgtbl);
+
+	return 0;
+
+fail_driver:
+	device_unregister(mmu->dev);
+fail_device:
+	bus_unregister(&ipu3_mmu_bus);
+fail_bus:
+	return r;
+}
+EXPORT_SYMBOL_GPL(ipu3_mmu_init);
+
+void ipu3_mmu_exit(struct ipu3_mmu *mmu)
+{
+	driver_unregister(&ipu3_mmu_driver);
+	device_unregister(mmu->dev);
+	bus_unregister(&ipu3_mmu_bus);
+}
+EXPORT_SYMBOL_GPL(ipu3_mmu_exit);
+
+MODULE_AUTHOR("Tuukka Toivonen <tuukka.toivonen@intel.com>");
+MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
+MODULE_AUTHOR("Samu Onkalo <samu.onkalo@intel.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("ipu3 mmu driver");
diff --git a/drivers/media/pci/intel/ipu3/ipu3-mmu.h b/drivers/media/pci/intel/ipu3/ipu3-mmu.h
new file mode 100644
index 0000000..a458235
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3-mmu.h
@@ -0,0 +1,73 @@
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
+#ifndef __IPU3_MMU_H
+#define __IPU3_MMU_H
+
+#include <linux/iova.h>
+#include <linux/iommu.h>
+
+#define to_ipu3_mmu(dev)	dev_get_drvdata(dev)
+
+#define IPU3_MMU_NAME		"ipu3-mmu"
+#define IPU3_MMU_BUS_NAME	"ipu3-bus"
+
+#define IPU3_MMU_ADDRESS_BITS	32
+
+#define IPU3_MMU_PAGE_SHIFT	12
+#define IPU3_MMU_PAGE_SIZE	(1U << IPU3_MMU_PAGE_SHIFT)
+#define IPU3_MMU_PAGE_MASK	(~(IPU3_MMU_PAGE_SIZE - 1))
+
+#define IPU3_MMU_L1PT_SHIFT	22
+#define IPU3_MMU_L1PT_MASK	(~((1U << IPU3_MMU_L1PT_SHIFT) - 1))
+#define IPU3_MMU_L1PT_PTES	1024
+
+#define IPU3_MMU_L2PT_SHIFT	IPU3_MMU_PAGE_SHIFT
+#define IPU3_MMU_L2PT_MASK	(~(IPU3_MMU_L1PT_MASK | \
+				 (~(IPU3_MMU_PAGE_MASK))))
+#define IPU3_MMU_L2PT_PTES	1024
+
+#define IMGU_REG_BASE		0x4000
+#define REG_TLB_INVALIDATE	(IMGU_REG_BASE + 0x300)
+#define TLB_INVALIDATE		1
+#define REG_L1_PHYS		(IMGU_REG_BASE + 0x304) /* 27-bit pfn */
+
+#define TBL_VIRT_ADDR(a)	((a) ? phys_to_virt(TBL_PHYS_ADDR(a)) : NULL)
+#define TBL_PHYS_ADDR(a)	((phys_addr_t)(a) << \
+					IPU3_MMU_PAGE_SHIFT)
+
+struct ipu3_mmu_domain {
+	struct ipu3_mmu *mmu;
+	struct iommu_domain domain;
+	spinlock_t lock;
+
+	u32 __iomem *pgtbl;
+	u32 dummy_l2_tbl;
+	u32 dummy_page;
+};
+
+struct ipu3_mmu {
+	struct device *dev;
+	struct iommu_domain *domain;
+	struct iova_domain iova_domain;
+	phys_addr_t pgtbl;
+	u64 dma_mask;
+	void __iomem *base;
+};
+
+void ipu3_mmu_dump_page_table(struct ipu3_mmu *mmu);
+int ipu3_mmu_init(struct ipu3_mmu *mmu, void __iomem *base, struct device *dev);
+void ipu3_mmu_exit(struct ipu3_mmu *mmu);
+
+#endif
-- 
2.7.4
