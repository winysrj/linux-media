Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55638 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750988AbdJTJTf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 05:19:35 -0400
Date: Fri, 20 Oct 2017 12:19:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, jerry.w.hu@intel.com, arnd@arndb.de,
        hch@lst.de, robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        Tomasz Figa <tfiga@chromium.org>
Subject: Re: [PATCH v4 03/12] intel-ipu3: Add IOMMU based dmamap support
Message-ID: <20171020091932.hcizvgo6mm6whivq@valkosipuli.retiisi.org.uk>
References: <1508298539-25965-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508298539-25965-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Tue, Oct 17, 2017 at 10:48:59PM -0500, Yong Zhi wrote:
> From: Tomasz Figa <tfiga@chromium.org>
> 
> This patch adds driver to support IPU3-specific
> MMU-aware memory alloc/free and sg mapping functions.
> 
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/Kconfig       |   7 +
>  drivers/media/pci/intel/ipu3/Makefile      |   2 +-
>  drivers/media/pci/intel/ipu3/ipu3-dmamap.c | 342 +++++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-dmamap.h |  33 +++
>  4 files changed, 383 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.h
> 
> diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
> index 46ff138f3e50..d7dab52dc881 100644
> --- a/drivers/media/pci/intel/ipu3/Kconfig
> +++ b/drivers/media/pci/intel/ipu3/Kconfig
> @@ -26,3 +26,10 @@ config INTEL_IPU3_MMU
>  	---help---
>  	  For IPU3, this option enables its MMU driver to translate its internal
>  	  virtual address to 39 bits wide physical address for 64GBytes space access.
> +
> +config INTEL_IPU3_DMAMAP
> +	tristate
> +	default n
> +	select IOMMU_IOVA
> +	---help---
> +	  This is IPU3 IOMMU domain specific DMA driver.
> diff --git a/drivers/media/pci/intel/ipu3/Makefile b/drivers/media/pci/intel/ipu3/Makefile
> index 91cac9cb7401..651773231496 100644
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
> index 000000000000..e54bd9dfa302
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-dmamap.c
> @@ -0,0 +1,342 @@
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
> +#include <linux/dma-direction.h>
> +#include <linux/highmem.h>
> +#include <linux/iommu.h>
> +#include <linux/iova.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/version.h>

Do you need this for something?

> +#include <linux/vmalloc.h>
> +
> +#include "ipu3-css-pool.h"
> +#include "ipu3.h"
> +
> +/*
> + * Based on arch/arm64/mm/dma-mapping.c, with simplifications possible due
> + * to driver-specific character of this file.
> + */
> +
> +static int dma_direction_to_prot(enum dma_data_direction dir, bool coherent)
> +{
> +	int prot = coherent ? IOMMU_CACHE : 0;
> +
> +	switch (dir) {
> +	case DMA_BIDIRECTIONAL:
> +		return prot | IOMMU_READ | IOMMU_WRITE;
> +	case DMA_TO_DEVICE:
> +		return prot | IOMMU_READ;
> +	case DMA_FROM_DEVICE:
> +		return prot | IOMMU_WRITE;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +/*
> + * Free a buffer allocated by ipu3_dmamap_alloc_buffer()
> + */
> +static void ipu3_dmamap_free_buffer(struct page **pages,
> +				    size_t size)
> +{
> +	int count = size >> PAGE_SHIFT;
> +
> +	while (count--)
> +		__free_page(pages[count]);
> +	kvfree(pages);
> +}
> +
> +/*
> + * Based on the implementation of __iommu_dma_alloc_pages()
> + * defined in drivers/iommu/dma-iommu.c
> + */
> +static struct page **ipu3_dmamap_alloc_buffer(size_t size,
> +					      unsigned long order_mask,
> +					      gfp_t gfp)
> +{
> +	struct page **pages;
> +	unsigned int i = 0, count = size >> PAGE_SHIFT;
> +	const gfp_t high_order_gfp = __GFP_NOWARN | __GFP_NORETRY;
> +
> +	/* Allocate mem for array of page ptrs */
> +	pages = kvmalloc_array(count, sizeof(struct page *), GFP_KERNEL);
> +
> +	if (!pages)
> +		return NULL;
> +
> +	order_mask &= (2U << MAX_ORDER) - 1;
> +	if (!order_mask)
> +		return NULL;
> +
> +	gfp |= __GFP_NOWARN | __GFP_HIGHMEM | __GFP_ZERO;
> +
> +	while (count) {
> +		struct page *page = NULL;
> +		unsigned int order_size;
> +
> +		for (order_mask &= (2U << __fls(count)) - 1;
> +		     order_mask; order_mask &= ~order_size) {
> +			unsigned int order = __fls(order_mask);
> +
> +			order_size = 1U << order;
> +			page = alloc_pages((order_mask - order_size) ?
> +					   gfp | high_order_gfp : gfp, order);
> +			if (!page)
> +				continue;
> +			if (!order)
> +				break;
> +			if (!PageCompound(page)) {
> +				split_page(page, order);
> +				break;
> +			}
> +
> +			__free_pages(page, order);
> +		}
> +		if (!page) {
> +			ipu3_dmamap_free_buffer(pages, i << PAGE_SHIFT);
> +			return NULL;
> +		}
> +		count -= order_size;
> +		while (order_size--)
> +			pages[i++] = page++;
> +	}
> +
> +	return pages;
> +}
> +
> +/**
> + * ipu3_dmamap_alloc - allocate and map a buffer into KVA
> + * @dev: struct device pointer
> + * @map: struct to store mapping variables
> + * @len: size required
> + *
> + * Return KVA on success or NULL on failure
> + */
> +void *ipu3_dmamap_alloc(struct imgu_device *imgu, struct ipu3_css_map *map,
> +			size_t len)
> +{
> +	unsigned long shift = iova_shift(&imgu->iova_domain);
> +	unsigned int alloc_sizes = imgu->domain->pgsize_bitmap;
> +	size_t size = PAGE_ALIGN(len);
> +	struct page **pages;
> +	dma_addr_t iovaddr;
> +	struct iova *iova;
> +	int i, rval;
> +
> +	if (WARN(!(&imgu->pci_dev->dev),
> +		 "cannot create IOMMU mapping for unknown device\n"))
> +		return NULL;
> +
> +	dev_dbg(&imgu->pci_dev->dev, "%s: allocating %zu\n", __func__, size);
> +
> +	iova = alloc_iova(&imgu->iova_domain, size >> shift,
> +			  imgu->domain->geometry.aperture_end >> shift, 0);
> +	if (!iova)
> +		return NULL;
> +
> +	pages = ipu3_dmamap_alloc_buffer(size, alloc_sizes >> PAGE_SHIFT,
> +					 GFP_KERNEL);
> +	if (!pages)
> +		goto out_free_iova;
> +
> +	/* Call IOMMU driver to setup pgt */
> +	iovaddr = iova_dma_addr(&imgu->iova_domain, iova);
> +	for (i = 0; i < size / PAGE_SIZE; ++i) {
> +		rval = iommu_map(imgu->domain, iovaddr,
> +				 page_to_phys(pages[i]), PAGE_SIZE, 0);

In the current implementation, you don't have much benefit from the use of
the IOMMU framework left: it's more or less a wrapper between this and the
MMU driver.

Could you remove it, and use the MMU driver directly?

Neither should need to be a separate module anymore.

> +		if (rval)
> +			goto out_unmap;
> +
> +		iovaddr += PAGE_SIZE;
> +	}
> +
> +	/* Now grab a virtual region */
> +	map->vma = __get_vm_area(size, VM_USERMAP, VMALLOC_START, VMALLOC_END);
> +	if (!map->vma)
> +		goto out_unmap;
> +
> +	map->vma->pages = pages;
> +	/* And map it in KVA */
> +	if (map_vm_area(map->vma, PAGE_KERNEL, pages))
> +		goto out_vunmap;
> +
> +	map->size = size;
> +	map->daddr = iova_dma_addr(&imgu->iova_domain, iova);
> +	map->vaddr = map->vma->addr;
> +
> +	dev_dbg(&imgu->pci_dev->dev, "%s: allocated %zu @ IOVA %pad @ VA %p\n",
> +		__func__, size, &map->daddr, map->vma->addr);
> +
> +	return map->vma->addr;
> +
> +out_vunmap:
> +	vunmap(map->vma->addr);
> +
> +out_unmap:
> +	ipu3_dmamap_free_buffer(pages, size);
> +	iommu_unmap(imgu->domain, iova_dma_addr(&imgu->iova_domain, iova),
> +		    i * PAGE_SIZE);
> +	map->vma = NULL;
> +
> +out_free_iova:
> +	__free_iova(&imgu->iova_domain, iova);
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(ipu3_dmamap_alloc);
> +
> +void ipu3_dmamap_unmap(struct imgu_device *imgu, struct ipu3_css_map *map)
> +{
> +	struct iova *iova;
> +
> +	iova = find_iova(&imgu->iova_domain,
> +			 iova_pfn(&imgu->iova_domain, map->daddr));
> +	if (WARN_ON(!iova))
> +		return;
> +
> +	iommu_unmap(imgu->domain, iova_dma_addr(&imgu->iova_domain, iova),
> +		    iova_size(iova) << iova_shift(&imgu->iova_domain));
> +
> +	__free_iova(&imgu->iova_domain, iova);
> +}
> +EXPORT_SYMBOL_GPL(ipu3_dmamap_unmap);
> +
> +/*
> + * Counterpart of ipu3_dmamap_alloc
> + */
> +void ipu3_dmamap_free(struct imgu_device *imgu, struct ipu3_css_map *map)
> +{
> +	struct vm_struct *area = map->vma;
> +
> +	dev_dbg(&imgu->pci_dev->dev, "%s: freeing %zu @ IOVA %pad @ VA %p\n",
> +		__func__, map->size, &map->daddr, map->vaddr);
> +
> +	if (!map->vaddr)
> +		return;
> +
> +	ipu3_dmamap_unmap(imgu, map);
> +
> +	if (WARN_ON(!area) || WARN_ON(!area->pages))
> +		return;
> +
> +	ipu3_dmamap_free_buffer(area->pages, map->size);
> +	vunmap(map->vaddr);
> +	map->vaddr = NULL;
> +}
> +EXPORT_SYMBOL_GPL(ipu3_dmamap_free);
> +
> +int ipu3_dmamap_map_sg(struct imgu_device *imgu, struct scatterlist *sglist,
> +		       int nents, enum dma_data_direction dir,
> +		       struct ipu3_css_map *map)
> +{
> +	unsigned long shift = iova_shift(&imgu->iova_domain);
> +	struct scatterlist *sg;
> +	struct iova *iova;
> +	size_t size = 0;
> +	size_t size_aligned;
> +	int i;
> +
> +	for_each_sg(sglist, sg, nents, i) {
> +		if (sg->offset)
> +			return -EINVAL;
> +
> +		if (i != nents - 1 && !PAGE_ALIGNED(sg->length))
> +			return -EINVAL;
> +
> +		size += sg->length;
> +	}
> +	size_aligned = PAGE_ALIGN(size);
> +
> +	dev_dbg(&imgu->pci_dev->dev, "dmamap: mapping sg %d entries, %zu pages\n",
> +		nents, size_aligned >> shift);
> +
> +	iova = alloc_iova(&imgu->iova_domain, size_aligned >> shift,
> +			  imgu->domain->geometry.aperture_end >> shift, 0);
> +	if (!iova)
> +		return -ENOMEM;
> +
> +	dev_dbg(&imgu->pci_dev->dev, "dmamap: iova low pfn %lu, high pfn %lu\n",
> +		iova->pfn_lo, iova->pfn_hi);
> +
> +	if (iommu_map_sg(imgu->domain,
> +			 iova_dma_addr(&imgu->iova_domain, iova),
> +			 sglist, nents, dma_direction_to_prot(dir, true))
> +			 < size)
> +		goto out_fail;
> +
> +	memset(map, 0, sizeof(*map));
> +	map->daddr = iova_dma_addr(&imgu->iova_domain, iova);
> +	map->size = size_aligned;
> +
> +	return 0;
> +
> +out_fail:
> +	__free_iova(&imgu->iova_domain, iova);
> +
> +	return -EFAULT;
> +}
> +EXPORT_SYMBOL_GPL(ipu3_dmamap_map_sg);
> +
> +int ipu3_dmamap_init(struct imgu_device *imgu)
> +{
> +	unsigned long order, base_pfn, end_pfn;
> +	int ret;
> +
> +	imgu->domain = iommu_domain_alloc(imgu->mmu->bus);
> +	if (!imgu->domain)
> +		return -ENOMEM;
> +
> +	ret = iova_cache_get();
> +	if (ret)
> +		goto out_domain;
> +
> +	order = __ffs(imgu->domain->pgsize_bitmap);
> +	base_pfn = max_t(unsigned long, 1,
> +			 imgu->domain->geometry.aperture_start >> order);
> +	end_pfn = imgu->domain->geometry.aperture_end >> order;
> +
> +	init_iova_domain(&imgu->iova_domain, 1UL << order, base_pfn, end_pfn);
> +
> +	ret = iommu_attach_device(imgu->domain, imgu->mmu);
> +	if (ret)
> +		goto out_iova_cache;
> +
> +	return 0;
> +
> +out_iova_cache:
> +	iova_cache_put();
> +	put_iova_domain(&imgu->iova_domain);
> +out_domain:
> +	iommu_domain_free(imgu->domain);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ipu3_dmamap_init);
> +
> +void ipu3_dmamap_exit(struct imgu_device *imgu)
> +{
> +	put_iova_domain(&imgu->iova_domain);
> +	iova_cache_put();
> +	iommu_detach_device(imgu->domain, imgu->mmu);
> +	iommu_domain_free(imgu->domain);
> +	imgu->domain = NULL;
> +}
> +EXPORT_SYMBOL_GPL(ipu3_dmamap_exit);
> +
> +MODULE_AUTHOR("Tomasz Figa <tfiga@chromium.org>");
> +MODULE_AUTHOR("Yong Zhi <yong.zhi@intel.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("IPU3 DMA mapping support");
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-dmamap.h b/drivers/media/pci/intel/ipu3/ipu3-dmamap.h
> new file mode 100644
> index 000000000000..9b442a40ee06
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-dmamap.h
> @@ -0,0 +1,33 @@
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
> +struct imgu_device;
> +
> +void *ipu3_dmamap_alloc(struct imgu_device *imgu, struct ipu3_css_map *map,
> +			size_t len);
> +void ipu3_dmamap_free(struct imgu_device *imgu, struct ipu3_css_map *map);
> +
> +int ipu3_dmamap_map_sg(struct imgu_device *imgu, struct scatterlist *sglist,
> +		       int nents, enum dma_data_direction dir,
> +		       struct ipu3_css_map *map);
> +void ipu3_dmamap_unmap(struct imgu_device *imgu, struct ipu3_css_map *map);
> +
> +int ipu3_dmamap_init(struct imgu_device *imgu);
> +void ipu3_dmamap_exit(struct imgu_device *imgu);
> +
> +#endif
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
