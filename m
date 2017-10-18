Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:12688 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754150AbdJRDsr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 23:48:47 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, jerry.w.hu@intel.com, arnd@arndb.de,
        hch@lst.de, robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        Tomasz Figa <tfiga@chromium.org>, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v4 02/12] intel-ipu3: Add mmu driver
Date: Tue, 17 Oct 2017 22:48:34 -0500
Message-Id: <1508298514-25919-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Figa <tfiga@chromium.org>

IPU3 is capable to deal with a virtual address space with
a dedicated MMU. The driver supports address translation
from virtual(IPU3 internal) to 39 bit wide physical(system).

Build has dependency on exported symbols from:

<URL:https://patchwork.kernel.org/patch/9825939/>

Signed-off-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/pci/intel/ipu3/Kconfig    |   9 +
 drivers/media/pci/intel/ipu3/Makefile   |  15 +
 drivers/media/pci/intel/ipu3/ipu3-mmu.c | 580 ++++++++++++++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-mmu.h |  26 ++
 4 files changed, 630 insertions(+)
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.h

diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
index 0861077a4dae..46ff138f3e50 100644
--- a/drivers/media/pci/intel/ipu3/Kconfig
+++ b/drivers/media/pci/intel/ipu3/Kconfig
@@ -17,3 +17,12 @@ config VIDEO_IPU3_CIO2
 	Say Y or M here if you have a Skylake/Kaby Lake SoC with MIPI CSI-2
 	connected camera.
 	The module will be called ipu3-cio2.
+
+config INTEL_IPU3_MMU
+	tristate
+	default n
+	select IOMMU_API
+	select IOMMU_IOVA
+	---help---
+	  For IPU3, this option enables its MMU driver to translate its internal
+	  virtual address to 39 bits wide physical address for 64GBytes space access.
diff --git a/drivers/media/pci/intel/ipu3/Makefile b/drivers/media/pci/intel/ipu3/Makefile
index 20186e3ff2ae..91cac9cb7401 100644
--- a/drivers/media/pci/intel/ipu3/Makefile
+++ b/drivers/media/pci/intel/ipu3/Makefile
@@ -1 +1,16 @@
+#
+#  Copyright (c) 2017, Intel Corporation.
+#
+#  This program is free software; you can redistribute it and/or modify it
+#  under the terms and conditions of the GNU General Public License,
+#  version 2, as published by the Free Software Foundation.
+#
+#  This program is distributed in the hope it will be useful, but WITHOUT
+#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+#  more details.
+#
+
 obj-$(CONFIG_VIDEO_IPU3_CIO2) += ipu3-cio2.o
+obj-$(CONFIG_INTEL_IPU3_MMU) += ipu3-mmu.o
+
diff --git a/drivers/media/pci/intel/ipu3/ipu3-mmu.c b/drivers/media/pci/intel/ipu3/ipu3-mmu.c
new file mode 100644
index 000000000000..05d001319aca
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3-mmu.c
@@ -0,0 +1,580 @@
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
+#include <linux/dma-mapping.h>
+#include <linux/iommu.h>
+#include <linux/iopoll.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include <asm/set_memory.h>
+
+#include "ipu3-mmu.h"
+
+#define IMGU_DMA_NAME		"ipu3-imgu-dma"
+#define IMGU_DMA_BUS_NAME	"ipu3-imgu-bus"
+
+#define IPU3_PAGE_SHIFT		12
+#define IPU3_PAGE_SIZE		(1UL << IPU3_PAGE_SHIFT)
+
+#define IPU3_PT_BITS		10
+#define IPU3_PT_PTES		(1UL << IPU3_PT_BITS)
+#define IPU3_PT_SIZE		(IPU3_PT_PTES << 2)
+#define IPU3_PT_ORDER		(IPU3_PT_SIZE >> PAGE_SHIFT)
+
+#define IPU3_ADDR2PTE(addr)	((addr) >> IPU3_PAGE_SHIFT)
+#define IPU3_PTE2ADDR(pte)	((phys_addr_t)(pte) << IPU3_PAGE_SHIFT)
+
+#define IPU3_L2PT_SHIFT		IPU3_PT_BITS
+#define IPU3_L2PT_MASK		((1UL << IPU3_L2PT_SHIFT) - 1)
+
+#define IPU3_L1PT_SHIFT		IPU3_PT_BITS
+#define IPU3_L1PT_MASK		((1UL << IPU3_L1PT_SHIFT) - 1)
+
+#define IPU3_MMU_ADDRESS_BITS	(IPU3_PAGE_SHIFT + \
+				 IPU3_L2PT_SHIFT + \
+				 IPU3_L1PT_SHIFT)
+
+#define IMGU_REG_BASE		0x4000
+#define REG_TLB_INVALIDATE	(IMGU_REG_BASE + 0x300)
+#define TLB_INVALIDATE		1
+#define REG_L1_PHYS		(IMGU_REG_BASE + 0x304) /* 27-bit pfn */
+#define REG_GP_HALT		(IMGU_REG_BASE + 0x5dc)
+#define REG_GP_HALTED		(IMGU_REG_BASE + 0x5e0)
+
+struct ipu3_mmu_domain {
+	struct iommu_domain domain;
+	struct ipu3_mmu *mmu;
+};
+
+struct ipu3_mmu {
+	struct bus_type bus;
+	struct device *dev;
+	struct device dma_dev;
+	void __iomem *base;
+	struct iommu_group *group;
+	spinlock_t lock;
+
+	void *dummy_page;
+	u32 dummy_page_pteval;
+
+	u32 *dummy_l2pt;
+	u32 dummy_l2pt_pteval;
+
+	u32 **l2pts;
+	u32 *l1pt;
+};
+
+static inline struct ipu3_mmu_domain *
+to_ipu3_mmu_domain(struct iommu_domain *domain)
+{
+	return container_of(domain, struct ipu3_mmu_domain, domain);
+}
+
+/**
+ * ipu3_mmu_tlb_invalidate - invalidate translation look-aside buffer
+ * @mmu: MMU to perform the invalidate operation on
+ *
+ * This function invalidates the whole TLB. Must be called when the hardware
+ * is powered on.
+ */
+static void ipu3_mmu_tlb_invalidate(struct ipu3_mmu *mmu)
+{
+	writel(TLB_INVALIDATE, mmu->base + REG_TLB_INVALIDATE);
+}
+
+static void call_if_ipu3_is_powered(struct ipu3_mmu *mmu,
+				    void (*func)(struct ipu3_mmu *mmu))
+{
+	pm_runtime_get_noresume(mmu->dev);
+	if (pm_runtime_active(mmu->dev))
+		func(mmu);
+	pm_runtime_put(mmu->dev);
+}
+
+/**
+ * ipu3_mmu_set_halt - set CIO gate halt bit
+ * @mmu: MMU to set the CIO gate bit in.
+ * @halt: Desired state of the gate bit.
+ *
+ * This function sets the CIO gate bit that controls whether external memory
+ * accesses are allowed. Must be called when the hardware is powered on.
+ */
+static void ipu3_mmu_set_halt(struct ipu3_mmu *mmu, bool halt)
+{
+	int ret;
+	u32 val;
+
+	writel(halt, mmu->base + REG_GP_HALT);
+	ret = readl_poll_timeout(mmu->base + REG_GP_HALTED,
+				 val, (val & 1) == halt, 1000, 100000);
+
+	if (ret)
+		dev_err(mmu->dev, "failed to %s CIO gate halt\n",
+			halt ? "set" : "clear");
+}
+
+/**
+ * ipu3_mmu_alloc_page_table - allocate a pre-filled page table
+ * @pteval: Value to initialize for page table entries with.
+ *
+ * Return: Pointer to allocated page table or NULL on failure.
+ */
+static u32 *ipu3_mmu_alloc_page_table(u32 pteval)
+{
+	u32 *pt;
+	int pte;
+
+	pt = kmalloc_array(IPU3_PT_PTES, sizeof(*pt), GFP_KERNEL);
+
+	if (!pt)
+		return NULL;
+
+	for (pte = 0; pte < IPU3_PT_PTES; pte++)
+		pt[pte] = pteval;
+
+	set_memory_uc((unsigned long int)pt, IPU3_PT_ORDER);
+
+	return pt;
+}
+
+/**
+ * ipu3_mmu_free_page_table - free page table
+ * @pt: Page table to free.
+ */
+static void ipu3_mmu_free_page_table(u32 *pt)
+{
+	set_memory_wb((unsigned long int)pt, IPU3_PT_ORDER);
+	kfree(pt);
+}
+
+/**
+ * address_to_pte_idx - split IOVA into L1 and L2 page table indices
+ * @iova: IOVA to split.
+ * @l1pt_idx: Output for the L1 page table index.
+ * @l2pt_idx: Output for the L2 page index.
+ */
+static inline void address_to_pte_idx(unsigned long iova, u32 *l1pt_idx,
+			       u32 *l2pt_idx)
+{
+	iova >>= IPU3_PAGE_SHIFT;
+
+	if (l2pt_idx)
+		*l2pt_idx = iova & IPU3_L2PT_MASK;
+
+	iova >>= IPU3_L2PT_SHIFT;
+
+	if (l1pt_idx)
+		*l1pt_idx = iova & IPU3_L1PT_MASK;
+}
+
+static struct iommu_domain *ipu3_mmu_domain_alloc(unsigned int type)
+{
+	struct ipu3_mmu_domain *mmu_dom;
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
+	return &mmu_dom->domain;
+}
+
+static void ipu3_mmu_domain_free(struct iommu_domain *domain)
+{
+	struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
+
+	/* We expect the domain to be detached already. */
+	WARN_ON(mmu_dom->mmu);
+	kfree(mmu_dom);
+}
+
+static void ipu3_mmu_detach_dev(struct iommu_domain *domain,
+				struct device *dev)
+{
+	struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
+
+	mmu_dom->mmu = NULL;
+}
+
+static int ipu3_mmu_attach_dev(struct iommu_domain *domain,
+			       struct device *dev)
+{
+	struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
+	struct ipu3_mmu *mmu = dev_get_drvdata(dev);
+
+	mmu_dom->mmu = mmu;
+	return 0;
+}
+
+static u32 *ipu3_mmu_get_l2pt(struct ipu3_mmu *mmu, u32 l1pt_idx)
+{
+	unsigned long flags;
+	u32 *l2pt, *new_l2pt;
+	u32 pteval;
+
+	spin_lock_irqsave(&mmu->lock, flags);
+
+	l2pt = mmu->l2pts[l1pt_idx];
+	if (l2pt)
+		goto done;
+
+	spin_unlock_irqrestore(&mmu->lock, flags);
+
+	new_l2pt = ipu3_mmu_alloc_page_table(mmu->dummy_page_pteval);
+	if (!new_l2pt)
+		return NULL;
+
+	spin_lock_irqsave(&mmu->lock, flags);
+
+	dev_dbg(mmu->dev,
+		"allocated page table %p for l1pt_idx %u\n",
+		new_l2pt, l1pt_idx);
+
+	l2pt = mmu->l2pts[l1pt_idx];
+	if (l2pt) {
+		ipu3_mmu_free_page_table(new_l2pt);
+		goto done;
+	}
+
+	l2pt = new_l2pt;
+	mmu->l2pts[l1pt_idx] = new_l2pt;
+
+	pteval = IPU3_ADDR2PTE(virt_to_phys(new_l2pt));
+	mmu->l1pt[l1pt_idx] = pteval;
+
+done:
+	spin_unlock_irqrestore(&mmu->lock, flags);
+	return l2pt;
+}
+
+static int ipu3_mmu_map(struct iommu_domain *domain, unsigned long iova,
+			phys_addr_t paddr, size_t size, int prot)
+{
+	struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
+	struct ipu3_mmu *mmu = mmu_dom->mmu;
+	u32 l1pt_idx, l2pt_idx;
+	unsigned long flags;
+	u32 *l2pt;
+
+	if (!mmu)
+		return -ENODEV;
+
+	address_to_pte_idx(iova, &l1pt_idx, &l2pt_idx);
+
+	l2pt = ipu3_mmu_get_l2pt(mmu, l1pt_idx);
+	if (!l2pt)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&mmu->lock, flags);
+
+	if (l2pt[l2pt_idx] != mmu->dummy_page_pteval) {
+		spin_unlock_irqrestore(&mmu->lock, flags);
+		return -EBUSY;
+	}
+
+	l2pt[l2pt_idx] = IPU3_ADDR2PTE(paddr);
+	call_if_ipu3_is_powered(mmu, ipu3_mmu_tlb_invalidate);
+
+	spin_unlock_irqrestore(&mmu->lock, flags);
+
+	return 0;
+}
+
+static size_t ipu3_mmu_unmap(struct iommu_domain *domain, unsigned long iova,
+			     size_t size)
+{
+	struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
+	struct ipu3_mmu *mmu = mmu_dom->mmu;
+	u32 l1pt_idx, l2pt_idx;
+	unsigned long flags;
+	u32 *l2pt;
+
+	if (!mmu)
+		return 0;
+
+	address_to_pte_idx(iova, &l1pt_idx, &l2pt_idx);
+
+	spin_lock_irqsave(&mmu->lock, flags);
+
+	l2pt = mmu->l2pts[l1pt_idx];
+	if (!l2pt) {
+		spin_unlock_irqrestore(&mmu->lock, flags);
+		return 0;
+	}
+
+	if (l2pt[l2pt_idx] == mmu->dummy_page_pteval)
+		size = 0;
+
+	l2pt[l2pt_idx] = mmu->dummy_page_pteval;
+	call_if_ipu3_is_powered(mmu, ipu3_mmu_tlb_invalidate);
+
+	spin_unlock_irqrestore(&mmu->lock, flags);
+
+	return size;
+}
+
+static phys_addr_t ipu3_mmu_iova_to_phys(struct iommu_domain *domain,
+					 dma_addr_t iova)
+{
+	struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
+	struct ipu3_mmu *mmu = mmu_dom->mmu;
+	u32 l1pt_idx, l2pt_idx;
+	unsigned long flags;
+	u32 pteval;
+	u32 *l2pt;
+
+	if (!mmu)
+		return 0;
+
+	address_to_pte_idx(iova, &l1pt_idx, &l2pt_idx);
+
+	spin_lock_irqsave(&mmu->lock, flags);
+
+	l2pt = mmu->l2pts[l1pt_idx];
+
+	spin_unlock_irqrestore(&mmu->lock, flags);
+
+	if (!l2pt)
+		return 0;
+
+	pteval = l2pt[l2pt_idx];
+	if (pteval == mmu->dummy_page_pteval)
+		return 0;
+
+	return IPU3_PTE2ADDR(pteval);
+}
+
+static struct iommu_group *ipu3_mmu_device_group(struct device *dev)
+{
+	struct ipu3_mmu *mmu = dev_get_drvdata(dev);
+
+	return iommu_group_ref_get(mmu->group);
+}
+
+static int ipu3_mmu_add_device(struct device *dev)
+{
+	struct iommu_group *group;
+
+	group = iommu_group_get_for_dev(dev);
+	if (IS_ERR(group))
+		return PTR_ERR(group);
+
+	iommu_group_put(group);
+	return 0;
+}
+
+static void ipu3_mmu_remove_device(struct device *dev)
+{
+	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
+
+	if (!domain)
+		return;
+
+	iommu_group_remove_device(dev);
+}
+
+static struct iommu_ops ipu3_iommu_ops = {
+	.domain_alloc   = ipu3_mmu_domain_alloc,
+	.domain_free    = ipu3_mmu_domain_free,
+	.attach_dev	= ipu3_mmu_attach_dev,
+	.detach_dev	= ipu3_mmu_detach_dev,
+	.map		= ipu3_mmu_map,
+	.unmap		= ipu3_mmu_unmap,
+	.map_sg		= default_iommu_map_sg,
+	.iova_to_phys	= ipu3_mmu_iova_to_phys,
+	.device_group	= ipu3_mmu_device_group,
+	.add_device	= ipu3_mmu_add_device,
+	.remove_device	= ipu3_mmu_remove_device,
+	.pgsize_bitmap	= IPU3_PAGE_SIZE,
+};
+
+static void ipu3_mmu_dev_release(struct device *dev)
+{
+	/* Nothing to do here. */
+}
+
+/**
+ * ipu3_mmu_init() - initialize IPU3 MMU block
+ * @base:	IOMEM base of hardware registers.
+ *
+ * Return: Pointer to IPU3 MMU private data pointer or ERR_PTR() on error.
+ */
+struct device *ipu3_mmu_init(struct device *parent, void __iomem *base)
+{
+	struct ipu3_mmu *mmu;
+	u32 pteval;
+	int ret;
+
+	mmu = kzalloc(sizeof(*mmu), GFP_KERNEL);
+	if (!mmu)
+		return ERR_PTR(-ENOMEM);
+
+	mmu->dev = parent;
+	mmu->base = base;
+	spin_lock_init(&mmu->lock);
+
+	/* Disallow external memory access when having no valid page tables. */
+	ipu3_mmu_set_halt(mmu, true);
+
+	mmu->bus.name = IMGU_DMA_BUS_NAME;
+	ret = bus_register(&mmu->bus);
+	if (ret)
+		goto fail_mmu;
+
+	mmu->dma_dev.release = ipu3_mmu_dev_release;
+	ret = dev_set_name(&mmu->dma_dev, IMGU_DMA_NAME);
+	if (ret)
+		goto fail_bus;
+
+	mmu->dma_dev.bus = &mmu->bus;
+	ret = device_register(&mmu->dma_dev);
+	if (ret)
+		goto fail_bus;
+	dev_set_drvdata(&mmu->dma_dev, mmu);
+
+	mmu->group = iommu_group_alloc();
+	if (!mmu->group) {
+		ret = -ENOMEM;
+		goto fail_device;
+	}
+
+	/*
+	 * The MMU does not have a "valid" bit, so we have to use a dummy
+	 * page for invalid entries.
+	 */
+	mmu->dummy_page = kzalloc(IPU3_PAGE_SIZE, GFP_KERNEL);
+	if (!mmu->dummy_page)
+		goto fail_group;
+	pteval = IPU3_ADDR2PTE(virt_to_phys(mmu->dummy_page));
+	mmu->dummy_page_pteval = pteval;
+
+	/*
+	 * Allocate a dummy L2 page table with all entries pointing to
+	 * the dummy page.
+	 */
+	mmu->dummy_l2pt = ipu3_mmu_alloc_page_table(pteval);
+	if (!mmu->dummy_l2pt)
+		goto fail_dummy_page;
+	pteval = IPU3_ADDR2PTE(virt_to_phys(mmu->dummy_l2pt));
+	mmu->dummy_l2pt_pteval = pteval;
+
+	/*
+	 * Allocate the array of L2PT CPU pointers, initialized to zero,
+	 * which means the dummy L2PT allocated above.
+	 */
+	mmu->l2pts = vzalloc(IPU3_PT_PTES * sizeof(*mmu->l2pts));
+	if (!mmu->l2pts)
+		goto fail_l2pt;
+
+	/* Allocate the L1 page table. */
+	mmu->l1pt = ipu3_mmu_alloc_page_table(mmu->dummy_l2pt_pteval);
+	if (!mmu->l1pt) {
+		ret = -ENOMEM;
+		goto fail_l2pts;
+	}
+
+	pteval = IPU3_ADDR2PTE(virt_to_phys(mmu->l1pt));
+	writel(pteval, mmu->base + REG_L1_PHYS);
+	ipu3_mmu_tlb_invalidate(mmu);
+	ipu3_mmu_set_halt(mmu, false);
+
+	bus_set_iommu(&mmu->bus, &ipu3_iommu_ops);
+
+	return &mmu->dma_dev;
+
+fail_l2pts:
+	vfree(mmu->l2pts);
+fail_l2pt:
+	ipu3_mmu_free_page_table(mmu->dummy_l2pt);
+fail_dummy_page:
+	kfree(mmu->dummy_page);
+fail_group:
+	iommu_group_put(mmu->group);
+fail_device:
+	device_unregister(&mmu->dma_dev);
+fail_bus:
+	bus_unregister(&mmu->bus);
+fail_mmu:
+	kfree(mmu);
+
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(ipu3_mmu_init);
+
+/**
+ * ipu3_mmu_exit() - clean up IPU3 MMU block
+ * @mmu: IPU3 MMU private data
+ */
+void ipu3_mmu_exit(struct device *dev)
+{
+	struct ipu3_mmu *mmu = dev_get_drvdata(dev);
+
+	device_unregister(&mmu->dma_dev);
+	bus_unregister(&mmu->bus);
+
+	bus_set_iommu(&mmu->bus, NULL);
+
+	/* We are going to free our page tables, no more memory access. */
+	ipu3_mmu_set_halt(mmu, true);
+	ipu3_mmu_tlb_invalidate(mmu);
+
+	ipu3_mmu_free_page_table(mmu->l1pt);
+	vfree(mmu->l2pts);
+	ipu3_mmu_free_page_table(mmu->dummy_l2pt);
+	kfree(mmu->dummy_page);
+	iommu_group_put(mmu->group);
+	kfree(mmu);
+}
+EXPORT_SYMBOL_GPL(ipu3_mmu_exit);
+
+void ipu3_mmu_suspend(struct device *dev)
+{
+	struct ipu3_mmu *mmu = dev_get_drvdata(dev);
+
+	ipu3_mmu_set_halt(mmu, true);
+}
+EXPORT_SYMBOL_GPL(ipu3_mmu_suspend);
+
+void ipu3_mmu_resume(struct device *dev)
+{
+	struct ipu3_mmu *mmu = dev_get_drvdata(dev);
+	u32 pteval;
+
+	ipu3_mmu_set_halt(mmu, true);
+
+	pteval = IPU3_ADDR2PTE(virt_to_phys(mmu->l1pt));
+	writel(pteval, mmu->base + REG_L1_PHYS);
+
+	ipu3_mmu_tlb_invalidate(mmu);
+	ipu3_mmu_set_halt(mmu, false);
+}
+EXPORT_SYMBOL_GPL(ipu3_mmu_resume);
+
+MODULE_AUTHOR("Tuukka Toivonen <tuukka.toivonen@intel.com>");
+MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
+MODULE_AUTHOR("Samu Onkalo <samu.onkalo@intel.com>");
+MODULE_AUTHOR("Tomasz Figa <tfiga@chromium.org>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("IPU3 MMU driver");
diff --git a/drivers/media/pci/intel/ipu3/ipu3-mmu.h b/drivers/media/pci/intel/ipu3/ipu3-mmu.h
new file mode 100644
index 000000000000..7ac13c701caf
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3-mmu.h
@@ -0,0 +1,26 @@
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
+#ifndef __IPU3_MMU_H
+#define __IPU3_MMU_H
+
+struct device;
+
+struct device *ipu3_mmu_init(struct device *parent, void __iomem *base);
+void ipu3_mmu_exit(struct device *dev);
+void ipu3_mmu_suspend(struct device *dev);
+void ipu3_mmu_resume(struct device *dev);
+
+#endif
-- 
2.7.4
