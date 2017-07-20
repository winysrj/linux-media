Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43142 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934927AbdGTVzO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 17:55:14 -0400
Date: Fri, 21 Jul 2017 00:55:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com, jerry.w.hu@intel.com, arnd@arndb.de,
        hch@lst.de, robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        Tomasz Figa <tfiga@chromium.org>
Subject: Re: [PATCH v3 03/12] intel-ipu3: Add DMA API implementation
Message-ID: <20170720215511.ejztqforel333uv5@valkosipuli.retiisi.org.uk>
References: <1500433978-2350-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500433978-2350-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Tue, Jul 18, 2017 at 10:12:58PM -0500, Yong Zhi wrote:
> From: Tomasz Figa <tfiga@chromium.org>
> 
> This patch adds support for the IPU3 DMA mapping API.
> 
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/Kconfig       |   8 +
>  drivers/media/pci/intel/ipu3/Makefile      |   2 +-
>  drivers/media/pci/intel/ipu3/ipu3-dmamap.c | 302 +++++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-dmamap.h |  22 +++
>  4 files changed, 333 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.h
> 
> diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
> index 7bcdfa5..d503806 100644
> --- a/drivers/media/pci/intel/ipu3/Kconfig
> +++ b/drivers/media/pci/intel/ipu3/Kconfig
> @@ -24,3 +24,11 @@ config INTEL_IPU3_MMU
>  	---help---
>  	  For IPU3, this option enables its MMU driver to translate its internal
>  	  virtual address to 39 bits wide physical address for 64GBytes space access.
> +
> +config INTEL_IPU3_DMAMAP
> +	tristate
> +	default n
> +	select IOMMU_DMA
> +	select IOMMU_IOVA
> +	---help---
> +	  This is IPU3 IOMMU domain specific DMA driver.
> diff --git a/drivers/media/pci/intel/ipu3/Makefile b/drivers/media/pci/intel/ipu3/Makefile
> index 91cac9c..6517732 100644
> --- a/drivers/media/pci/intel/ipu3/Makefile
> +++ b/drivers/media/pci/intel/ipu3/Makefile
> @@ -13,4 +13,4 @@
>  
>  obj-$(CONFIG_VIDEO_IPU3_CIO2) += ipu3-cio2.o
>  obj-$(CONFIG_INTEL_IPU3_MMU) += ipu3-mmu.o
> -
> +obj-$(CONFIG_INTEL_IPU3_DMAMAP) += ipu3-dmamap.o
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-dmamap.c b/drivers/media/pci/intel/ipu3/ipu3-dmamap.c
> new file mode 100644
> index 0000000..86a0e15
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-dmamap.c
> @@ -0,0 +1,302 @@
> +/*
> + * Copyright (c) 2017 Intel Corporation.
> + * Copyright (C) 2017 Google, Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +#include <linux/types.h>
> +#include <linux/dma-iommu.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/highmem.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/version.h>
> +#include <linux/vmalloc.h>
> +#include "ipu3-mmu.h"
> +
> +/*
> + * Based on arch/arm64/mm/dma-mapping.c, with simplifications possible due
> + * to driver-specific character of this file.
> + */
> +
> +static pgprot_t __get_dma_pgprot(unsigned long attrs, pgprot_t prot)
> +{
> +	if (DMA_ATTR_NON_CONSISTENT & attrs)
> +		return prot;
> +	return pgprot_writecombine(prot);
> +}
> +
> +static void flush_page(struct device *dev, const void *virt, phys_addr_t phys)
> +{
> +	/*
> +	 * FIXME: Yes, casting to override the const specifier is ugly.
> +	 * However, for some reason, this callback is intended to flush cache
> +	 * for a page pointed to by a const pointer, even though the cach
> +	 * flush operation by definition does not keep the affected memory
> +	 * constant...
> +	 */
> +	clflush_cache_range((void *)virt, PAGE_SIZE);

Hmm. Is this needed? The hardware is coherent --- apart from the MMU
tables.

Same for the flushes below.

> +}
> +
> +static void *ipu3_dmamap_alloc(struct device *dev, size_t size,
> +			       dma_addr_t *handle, gfp_t gfp,
> +			       unsigned long attrs)
> +{
> +	int ioprot = dma_info_to_prot(DMA_BIDIRECTIONAL, false, attrs);
> +	size_t iosize = size;
> +	struct page **pages;
> +	pgprot_t prot;
> +	void *addr;
> +
> +	if (WARN(!dev, "cannot create IOMMU mapping for unknown device\n"))
> +		return NULL;
> +
> +	if (WARN(!gfpflags_allow_blocking(gfp),
> +		 "atomic allocations not supported\n") ||
> +	    WARN((DMA_ATTR_FORCE_CONTIGUOUS & attrs),
> +	         "contiguous allocations not supported\n"))
> +		return NULL;
> +
> +	size = PAGE_ALIGN(size);
> +
> +	dev_dbg(dev, "%s: allocating %zu\n", __func__, size);
> +
> +	/*
> +	 * Some drivers rely on this, and we probably don't want the
> +	 * possibility of stale kernel data being read by devices anyway.
> +	 */
> +	gfp |= __GFP_ZERO;
> +
> +	/*
> +	 * On x86, __GFP_DMA or __GFP_DMA32 might be added implicitly, based
> +	 * on device DMA mask. However the mask does not apply to the IOMMU,
> +	 * which is expected to be able to map any physical page.
> +	 */
> +	gfp &= ~(__GFP_DMA | __GFP_DMA32);
> +
> +	pages = iommu_dma_alloc(dev, iosize, gfp, attrs, ioprot,
> +				handle, flush_page);
> +	if (!pages)
> +		return NULL;
> +
> +	prot = __get_dma_pgprot(attrs, PAGE_KERNEL);
> +	addr = dma_common_pages_remap(pages, size, VM_USERMAP, prot,
> +				      __builtin_return_address(0));
> +	if (!addr)
> +		iommu_dma_free(dev, pages, iosize, handle);
> +
> +	dev_dbg(dev, "%s: allocated %zu @ IOVA %pad @ VA %p\n",
> +		__func__, size, handle, addr);
> +
> +	return addr;
> +}
> +
> +static void ipu3_dmamap_free(struct device *dev, size_t size, void *cpu_addr,
> +			     dma_addr_t handle, unsigned long attrs)
> +{
> +	struct page **pages;
> +	size_t iosize = size;
> +
> +	size = PAGE_ALIGN(size);
> +
> +	pages = dma_common_get_mapped_pages(cpu_addr, VM_USERMAP);
> +	if (WARN_ON(!pages))
> +		return;
> +
> +	dev_dbg(dev, "%s: freeing %zu @ IOVA %pad @ VA %p\n",
> +		__func__, size, &handle, cpu_addr);
> +
> +	iommu_dma_free(dev, pages, iosize, &handle);
> +
> +	dma_common_free_remap(cpu_addr, size, VM_USERMAP);
> +}
> +
> +static int ipu3_dmamap_mmap(struct device *dev, struct vm_area_struct *vma,
> +			    void *cpu_addr, dma_addr_t dma_addr, size_t size,
> +			    unsigned long attrs)
> +{
> +	struct page **pages;
> +
> +	vma->vm_page_prot = __get_dma_pgprot(attrs, vma->vm_page_prot);
> +
> +	pages = dma_common_get_mapped_pages(cpu_addr, VM_USERMAP);
> +	if (WARN_ON(!pages))
> +		return -ENXIO;
> +
> +	return iommu_dma_mmap(pages, size, vma);
> +}
> +
> +static int ipu3_dmamap_get_sgtable(struct device *dev, struct sg_table *sgt,
> +				   void *cpu_addr, dma_addr_t dma_addr,
> +				   size_t size, unsigned long attrs)
> +{
> +	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
> +	struct page **pages;
> +
> +	pages = dma_common_get_mapped_pages(cpu_addr, VM_USERMAP);
> +	if (WARN_ON(!pages))
> +		return -ENXIO;
> +
> +	return sg_alloc_table_from_pages(sgt, pages, count, 0, size,
> +					 GFP_KERNEL);
> +}
> +
> +static void ipu3_dmamap_sync_single_for_cpu(struct device *dev,
> +					dma_addr_t dev_addr, size_t size,
> +					enum dma_data_direction dir)
> +{
> +	phys_addr_t phys;
> +
> +	phys = iommu_iova_to_phys(iommu_get_domain_for_dev(dev), dev_addr);
> +	clflush_cache_range(phys_to_virt(phys), size);
> +}
> +
> +static void ipu3_dmamap_sync_single_for_device(struct device *dev,
> +					   dma_addr_t dev_addr, size_t size,
> +					   enum dma_data_direction dir)
> +{
> +	phys_addr_t phys;
> +
> +	phys = iommu_iova_to_phys(iommu_get_domain_for_dev(dev), dev_addr);
> +	clflush_cache_range(phys_to_virt(phys), size);
> +}
> +
> +static dma_addr_t ipu3_dmamap_map_page(struct device *dev, struct page *page,
> +				   unsigned long offset, size_t size,
> +				   enum dma_data_direction dir,
> +				   unsigned long attrs)
> +{
> +	int prot = dma_info_to_prot(dir, false, attrs);
> +	dma_addr_t dev_addr = iommu_dma_map_page(dev, page, offset, size, prot);
> +
> +	if (!iommu_dma_mapping_error(dev, dev_addr) &&
> +	    (DMA_ATTR_SKIP_CPU_SYNC & attrs) == 0)
> +		ipu3_dmamap_sync_single_for_device(dev, dev_addr, size, dir);
> +
> +	return dev_addr;
> +}
> +
> +static void ipu3_dmamap_unmap_page(struct device *dev, dma_addr_t dev_addr,
> +			       size_t size, enum dma_data_direction dir,
> +			       unsigned long attrs)
> +{
> +	if ((DMA_ATTR_SKIP_CPU_SYNC & attrs) == 0)
> +		ipu3_dmamap_sync_single_for_cpu(dev, dev_addr, size, dir);
> +
> +	iommu_dma_unmap_page(dev, dev_addr, size, dir, attrs);
> +}
> +
> +static void ipu3_dmamap_sync_sg_for_cpu(struct device *dev,
> +				    struct scatterlist *sgl, int nelems,
> +				    enum dma_data_direction dir)
> +{
> +	struct scatterlist *sg;
> +	int i;
> +
> +	for_each_sg(sgl, sg, nelems, i)
> +		clflush_cache_range(sg_virt(sg), sg->length);
> +}
> +
> +static void ipu3_dmamap_sync_sg_for_device(struct device *dev,
> +				       struct scatterlist *sgl, int nelems,
> +				       enum dma_data_direction dir)
> +{
> +	struct scatterlist *sg;
> +	int i;
> +
> +	for_each_sg(sgl, sg, nelems, i)
> +		clflush_cache_range(sg_virt(sg), sg->length);
> +}
> +
> +static int ipu3_dmamap_map_sg(struct device *dev, struct scatterlist *sgl,
> +			      int nents, enum dma_data_direction dir,
> +			      unsigned long attrs)
> +{
> +	if ((DMA_ATTR_SKIP_CPU_SYNC & attrs) == 0)
> +		ipu3_dmamap_sync_sg_for_device(dev, sgl, nents, dir);
> +
> +	return iommu_dma_map_sg(dev, sgl, nents,
> +				dma_info_to_prot(dir, false, attrs));
> +}
> +
> +static void ipu3_dmamap_unmap_sg(struct device *dev, struct scatterlist *sgl,
> +				 int nents, enum dma_data_direction dir,
> +				 unsigned long attrs)
> +{
> +	if ((DMA_ATTR_SKIP_CPU_SYNC & attrs) == 0)
> +		ipu3_dmamap_sync_sg_for_cpu(dev, sgl, nents, dir);
> +
> +	iommu_dma_unmap_sg(dev, sgl, nents, dir, attrs);
> +}
> +
> +static struct dma_map_ops ipu3_dmamap_ops = {

const?

> +	.alloc = ipu3_dmamap_alloc,
> +	.free = ipu3_dmamap_free,
> +	.mmap = ipu3_dmamap_mmap,
> +	.get_sgtable = ipu3_dmamap_get_sgtable,
> +	.map_page = ipu3_dmamap_map_page,
> +	.unmap_page = ipu3_dmamap_unmap_page,
> +	.map_sg = ipu3_dmamap_map_sg,
> +	.unmap_sg = ipu3_dmamap_unmap_sg,
> +	.sync_single_for_cpu = ipu3_dmamap_sync_single_for_cpu,
> +	.sync_single_for_device = ipu3_dmamap_sync_single_for_device,
> +	.sync_sg_for_cpu = ipu3_dmamap_sync_sg_for_cpu,
> +	.sync_sg_for_device = ipu3_dmamap_sync_sg_for_device,
> +	.mapping_error = iommu_dma_mapping_error,
> +};
> +
> +int ipu3_dmamap_init(struct device *dev, u64 dma_base, u64 size)
> +{
> +	struct iommu_domain *domain;
> +	int ret;
> +
> +	ret = iommu_dma_init();
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * The IOMMU core code allocates the default DMA domain, which the
> +	 * underlying IOMMU driver needs to support via the dma-iommu layer.
> +	 */
> +	domain = iommu_get_domain_for_dev(dev);
> +	if (!domain) {
> +		pr_warn("Failed to get IOMMU domain for device %s\n",
> +			dev_name(dev));
> +		return -ENODEV;
> +	}
> +
> +	if (WARN(domain->type != IOMMU_DOMAIN_DMA, "device %s already managed?\n",
> +		 dev_name(dev)))
> +		return -EINVAL;
> +
> +	ret = iommu_dma_init_domain(domain, dma_base, size, dev);
> +	if (ret) {
> +		pr_warn("Failed to init IOMMU domain for device %s\n",
> +			dev_name(dev));
> +		return ret;
> +	}
> +
> +	dev->dma_ops = &ipu3_dmamap_ops;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu3_dmamap_init);
> +
> +void ipu3_dmamap_cleanup(struct device *dev)
> +{
> +	dev->dma_ops = &ipu3_dmamap_ops;
> +	iommu_dma_cleanup();
> +}
> +EXPORT_SYMBOL_GPL(ipu3_dmamap_cleanup);
> +
> +MODULE_AUTHOR("Tomasz Figa <tfiga@chromium.org>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("IPU3 DMA mapping support");
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-dmamap.h b/drivers/media/pci/intel/ipu3/ipu3-dmamap.h
> new file mode 100644
> index 0000000..fe5d0a4
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-dmamap.h
> @@ -0,0 +1,22 @@
> +/*
> + * Copyright (c) 2017 Intel Corporation.
> + * Copyright (C) 2017 Google, Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __IPU3_DMAMAP_H
> +#define __IPU3_DMAMAP_H
> +
> +int ipu3_dmamap_init(struct device *dev, u64 dma_base, u64 size);
> +void ipu3_dmamap_cleanup(struct device *dev);
> +
> +#endif

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
