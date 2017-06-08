Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:47654 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750788AbdFHNWt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 09:22:49 -0400
Subject: Re: [PATCH 03/12] intel-ipu3: Add DMA API implementation
To: Tomasz Figa <tfiga@chromium.org>, Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-4-git-send-email-yong.zhi@intel.com>
 <CAAFQd5CLXUsDv6H1C22tc4qjG9e7tm5jtxwYBjV5gx9qrDw50A@mail.gmail.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <73992991-65a9-915b-a450-b23aeb3baaed@arm.com>
Date: Thu, 8 Jun 2017 14:22:41 +0100
MIME-Version: 1.0
In-Reply-To: <CAAFQd5CLXUsDv6H1C22tc4qjG9e7tm5jtxwYBjV5gx9qrDw50A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/06/17 10:47, Tomasz Figa wrote:
> Hi Yong,
> 
> +Robin, Joerg, IOMMU ML
> 
> Please see my comments inline.
> 
> On Tue, Jun 6, 2017 at 5:39 AM, Yong Zhi <yong.zhi@intel.com> wrote:
>> IPU3 mmu based DMA mapping driver
>>
>> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
>> ---
>>  drivers/media/pci/intel/ipu3/Kconfig       |   6 +
>>  drivers/media/pci/intel/ipu3/Makefile      |   1 +
>>  drivers/media/pci/intel/ipu3/ipu3-dmamap.c | 408 +++++++++++++++++++++++++++++
>>  drivers/media/pci/intel/ipu3/ipu3-dmamap.h |  20 ++
>>  4 files changed, 435 insertions(+)
>>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.c
>>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.h
>>
>> diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
>> index ab2edcb..2030be7 100644
>> --- a/drivers/media/pci/intel/ipu3/Kconfig
>> +++ b/drivers/media/pci/intel/ipu3/Kconfig
>> @@ -26,3 +26,9 @@ config INTEL_IPU3_MMU
>>
>>           Say Y here if you have Skylake/Kaby Lake SoC with IPU3.
>>           Say N if un-sure.
>> +
>> +config INTEL_IPU3_DMAMAP
>> +       bool "Intel ipu3 DMA mapping driver"
>> +       select IOMMU_IOVA
>> +       ---help---
>> +         This is IPU3 IOMMU domain specific DMA driver.
>> diff --git a/drivers/media/pci/intel/ipu3/Makefile b/drivers/media/pci/intel/ipu3/Makefile
>> index 2b669df..2c2a035 100644
>> --- a/drivers/media/pci/intel/ipu3/Makefile
>> +++ b/drivers/media/pci/intel/ipu3/Makefile
>> @@ -1,2 +1,3 @@
>>  obj-$(CONFIG_VIDEO_IPU3_CIO2) += ipu3-cio2.o
>>  obj-$(CONFIG_INTEL_IPU3_MMU) += ipu3-mmu.o
>> +obj-$(CONFIG_INTEL_IPU3_DMAMAP) += ipu3-dmamap.o
>> diff --git a/drivers/media/pci/intel/ipu3/ipu3-dmamap.c b/drivers/media/pci/intel/ipu3/ipu3-dmamap.c
>> new file mode 100644
>> index 0000000..74704d9
>> --- /dev/null
>> +++ b/drivers/media/pci/intel/ipu3/ipu3-dmamap.c
>> @@ -0,0 +1,408 @@
>> +/*
>> + * Copyright (c) 2017 Intel Corporation.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License version
>> + * 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +#include <linux/highmem.h>
>> +#include <linux/slab.h>
>> +#include <linux/version.h>
>> +#include <linux/vmalloc.h>
>> +#include "ipu3-mmu.h"
>> +
>> +/* Begin of things adapted from arch/arm/mm/dma-mapping.c */
> 
> ARM's DMA ops are not a good example of today's coding standards.
> There are already generic DMA mapping helpers available in
> drivers/iommu/dma-iommu.c and drivers/base/dma-*. (Hmm, I remember
> writing this already, déjà vu maybe...)

Yes, dma-iommu exists for precisely this purpose -
arch/arm64/mm/dma-mapping.c would have been a better point of reference.

>> +static void ipu3_dmamap_clear_buffer(struct page *page, size_t size,
>> +                                    unsigned long attrs)
>> +{
>> +       /*
>> +        * Ensure that the allocated pages are zeroed, and that any data
>> +        * lurking in the kernel direct-mapped region is invalidated.
>> +        */
>> +       if (PageHighMem(page)) {
>> +               while (size > 0) {
>> +                       void *ptr = kmap_atomic(page);
>> +
>> +                       memset(ptr, 0, PAGE_SIZE);
>> +                       if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
>> +                               clflush_cache_range(ptr, PAGE_SIZE);
>> +                       kunmap_atomic(ptr);
>> +                       page++;
>> +                       size -= PAGE_SIZE;
>> +               }
>> +       } else {
>> +               void *ptr = page_address(page);
>> +
>> +               memset(ptr, 0, size);
>> +               if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
>> +                       clflush_cache_range(ptr, size);
>> +       }
>> +}
>> +
>> +/**
>> + * ipu3_dmamap_alloc_buffer - allocate buffer based on attributes
>> + * @dev: struct device pointer
>> + * @size: size of buffer in bytes
>> + * @gfp: specify the free page type
>> + * @attrs: defined in linux/dma-attrs.h
>> + *
>> + * This is a helper function for physical page allocation
>> + *
>> + * Return array representing buffer from alloc_pages() on success
>> + * or NULL on failure
>> + *
>> + * Must be freed with ipu3_dmamap_free_buffer.
>> + */
>> +static struct page **ipu3_dmamap_alloc_buffer(struct device *dev, size_t size,
>> +                                             gfp_t gfp, unsigned long attrs)
>> +{
>> +       struct page **pages;
>> +       int count = size >> PAGE_SHIFT;
>> +       int array_size = count * sizeof(struct page *);
>> +       int i = 0;
>> +
>> +       /* Allocate mem for array of page ptrs */
>> +       if (array_size <= PAGE_SIZE)
>> +               pages = kzalloc(array_size, GFP_KERNEL);
>> +       else
>> +               pages = vzalloc(array_size);
>> +       if (!pages)
>> +               return NULL;
>> +
>> +       gfp |= __GFP_NOWARN;
>> +
>> +       while (count) {
>> +               int j, order = __fls(count);
>> +
>> +               pages[i] = alloc_pages(gfp, order);
>> +               while (!pages[i] && order)
>> +                       pages[i] = alloc_pages(gfp, --order);
>> +               if (!pages[i])
>> +                       goto error;
>> +
>> +               if (order) {
>> +                       split_page(pages[i], order);
>> +                       j = 1 << order;
>> +                       while (--j)
>> +                               pages[i + j] = pages[i] + j;
>> +               }
>> +               /* Zero and invalidate */
>> +               ipu3_dmamap_clear_buffer(pages[i], PAGE_SIZE << order, attrs);
>> +               i += 1 << order;
>> +               count -= 1 << order;
>> +       }
>> +
>> +       return pages;
>> +
>> +error:
>> +       while (i--)
>> +               if (pages[i])
>> +                       __free_pages(pages[i], 0);
>> +       if (array_size <= PAGE_SIZE)
>> +               kfree(pages);
>> +       else
>> +               vfree(pages);
>> +
>> +       return NULL;
>> +}
>> +
>> +/*
>> + * Free a buffer allocated by ipu3_dmamap_alloc_buffer()
>> + */
>> +static int ipu3_dmamap_free_buffer(struct device *dev, struct page **pages,
>> +                                  size_t size, unsigned long attrs)
>> +{
>> +       int count = size >> PAGE_SHIFT;
>> +       int array_size = count * sizeof(struct page *);
>> +       int i;
>> +
>> +       for (i = 0; i < count; i++) {
>> +               if (pages[i]) {
>> +                       ipu3_dmamap_clear_buffer(pages[i], PAGE_SIZE, attrs);
>> +                       __free_pages(pages[i], 0);
>> +               }
>> +       }
>> +
>> +       if (array_size <= PAGE_SIZE)
>> +               kfree(pages);
>> +       else
>> +               vfree(pages);
>> +       return 0;
>> +}
> 
> I believe you don't need the 3 functions above if you use the helpers
> I mentioned.
> 
>> +
>> +/* End of things adapted from arch/arm/mm/dma-mapping.c */
>> +static void ipu3_dmamap_sync_single_for_cpu(struct device *dev,
>> +                                           dma_addr_t dma_handle, size_t size,
>> +                                           enum dma_data_direction dir)
>> +{
>> +       struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
>> +       dma_addr_t daddr = iommu_iova_to_phys(mmu->domain, dma_handle);
>> +
>> +       clflush_cache_range(phys_to_virt(daddr), size);
> 
> You might need to consider another IOMMU on the way here. Generally,
> given that daddr is your MMU DMA address (not necessarily CPU physical
> address), you should be able to call
> 
> dma_sync_single_for_cpu(<your pci device>, daddr, size, dir)

I'd hope that this IPU complex is some kind of embedded endpoint thing
that bypasses the VT-d IOMMU or is always using its own local RAM,
because it would be pretty much unworkable otherwise. The whole
infrastructure isn't really capable of dealing with nested IOMMUs, and
nested DMA ops would be an equally horrible idea.

>> +}
>> +
>> +/*
>> + * Synchronization function to transfer ownership to CPU
>> + */
>> +static void ipu3_dmamap_sync_sg_for_cpu(struct device *dev,
>> +                                       struct scatterlist *sglist, int nents,
>> +                                       enum dma_data_direction dir)
>> +{
>> +       struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
>> +       struct scatterlist *sg;
>> +       int i;
>> +
>> +       for_each_sg(sglist, sg, nents, i) {
>> +               clflush_cache_range(
>> +                       phys_to_virt(iommu_iova_to_phys(mmu->domain,
>> +                       sg_dma_address(sg))), sg->length);

Reverse-engineering the IOVA instead of just using sg_phys() here seems
a little needless.

>> +       }
> 
> Similarly here.
> 
>> +}
>> +
>> +/**
>> + * ipu3_dmamap_alloc - allocate and map a buffer into KVA
>> + * @dev: struct device pointer
>> + * @size: size of buffer in bytes
>> + * @gfp: specify the get free page type
>> + * @attrs: defined in linux/dma-attrs.h
>> + *
>> + * Return KVA on success or NULL on failure
>> + *
>> + */
>> +static void *ipu3_dmamap_alloc(struct device *dev, size_t size,
>> +                              dma_addr_t *dma_handle, gfp_t gfp,
>> +                              unsigned long attrs)
>> +{
>> +       struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
>> +       struct page **pages;
>> +       struct iova *iova;
>> +       struct vm_struct *area;
>> +       int i;
>> +       int rval;
>> +
>> +       size = PAGE_ALIGN(size);
>> +
>> +       iova = alloc_iova(&mmu->iova_domain, size >> PAGE_SHIFT,
>> +                       dma_get_mask(dev) >> PAGE_SHIFT, 0);
>> +       if (!iova)
>> +               return NULL;
>> +
>> +       pages = ipu3_dmamap_alloc_buffer(dev, size, gfp, attrs);
>> +       if (!pages)
>> +               goto out_free_iova;
>> +
>> +       /* Call IOMMU driver to setup pgt */
>> +       for (i = 0; iova->pfn_lo + i <= iova->pfn_hi; i++) {
>> +               rval = iommu_map(mmu->domain,
>> +                                (iova->pfn_lo + i) << PAGE_SHIFT,
>> +                                page_to_phys(pages[i]), PAGE_SIZE, 0);
>> +               if (rval)
>> +                       goto out_unmap;
>> +       }
> 
> I think most of the code above is already implemented in
> drivers/iommu/dma-iommu.c.
> 
>> +       /* Now grab a virtual region */
>> +       area = __get_vm_area(size, 0, VMALLOC_START, VMALLOC_END);
>> +       if (!area)
>> +               goto out_unmap;
>> +
>> +       area->pages = pages;
>> +       /* And map it in KVA */
>> +       if (map_vm_area(area, PAGE_KERNEL, pages))
>> +               goto out_vunmap;
>> +
>> +       *dma_handle = iova->pfn_lo << PAGE_SHIFT;
>> +
>> +       return area->addr;
>> +
>> +out_vunmap:
>> +       vunmap(area->addr);
>> +
>> +out_unmap:
>> +       ipu3_dmamap_free_buffer(dev, pages, size, attrs);
>> +       for (i--; i >= 0; i--) {
>> +               iommu_unmap(mmu->domain, (iova->pfn_lo + i) << PAGE_SHIFT,
>> +                           PAGE_SIZE);
>> +       }
>> +
>> +out_free_iova:
>> +       __free_iova(&mmu->iova_domain, iova);
>> +
>> +       return NULL;
>> +}
>> +
>> +/*
>> + * Counterpart of ipu3_dmamap_alloc
>> + */
>> +static void ipu3_dmamap_free(struct device *dev, size_t size, void *vaddr,
>> +                            dma_addr_t dma_handle, unsigned long attrs)
>> +{
>> +       struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
>> +       struct vm_struct *area = find_vm_area(vaddr);
>> +       struct iova *iova = find_iova(&mmu->iova_domain,
>> +                                     dma_handle >> PAGE_SHIFT);
>> +
>> +       if (WARN_ON(!area) || WARN_ON(!iova))
>> +               return;
>> +
>> +       if (WARN_ON(!area->pages))
>> +               return;
>> +
>> +       size = PAGE_ALIGN(size);
>> +
>> +       iommu_unmap(mmu->domain, iova->pfn_lo << PAGE_SHIFT,
>> +               (iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT);
>> +
>> +       __free_iova(&mmu->iova_domain, iova);
>> +
>> +       ipu3_dmamap_free_buffer(dev, area->pages, size, attrs);
>> +
>> +       vunmap(vaddr);
>> +}
>> +
>> +/*
>> + * Insert each page into user VMA
>> + */
>> +static int ipu3_dmamap_mmap(struct device *dev, struct vm_area_struct *vma,
>> +                           void *addr, dma_addr_t iova, size_t size,
>> +                           unsigned long attrs)
>> +{
>> +       struct vm_struct *area = find_vm_area(addr);
>> +       size_t count = PAGE_ALIGN(size) >> PAGE_SHIFT;
>> +       size_t i;
>> +
>> +       if (!area)
>> +               return -EFAULT;
>> +
>> +       if (vma->vm_start & ~PAGE_MASK)
>> +               return -EINVAL;
>> +
>> +       if (size > area->size)
>> +               return -EFAULT;
>> +
>> +       for (i = 0; i < count; i++)
>> +               vm_insert_page(vma, vma->vm_start + (i << PAGE_SHIFT),
>> +                               area->pages[i]);
> 
> Already implemented in dma-iommu.c.
> 
> Generally it looks like most of the code in this file can be removed
> by using the generic helpers.
> 
> (Preserving rest of the code for added recipients.)
> 
> Best regards,
> Tomasz
> 
>> +
>> +       return 0;
>> +}
>> +
>> +static void ipu3_dmamap_unmap_sg(struct device *dev, struct scatterlist *sglist,
>> +                                int nents, enum dma_data_direction dir,
>> +                                unsigned long attrs)
>> +{
>> +       struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
>> +       struct iova *iova = find_iova(&mmu->iova_domain,
>> +                                       sg_dma_address(sglist) >> PAGE_SHIFT);
>> +
>> +       if (!nents || WARN_ON(!iova))
>> +               return;
>> +
>> +       if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
>> +               ipu3_dmamap_sync_sg_for_cpu(dev, sglist, nents,
>> +                                           DMA_BIDIRECTIONAL);

You have the correct DMA direction from the caller, there's no need to
hard-code one like this (even if it is ultimately ignored).

>> +       iommu_unmap(mmu->domain, iova->pfn_lo << PAGE_SHIFT,
>> +                       (iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT);
>> +
>> +       __free_iova(&mmu->iova_domain, iova);
>> +}
>> +
>> +static int ipu3_dmamap_map_sg(struct device *dev, struct scatterlist *sglist,
>> +                             int nents, enum dma_data_direction dir,
>> +                             unsigned long attrs)
>> +{
>> +       struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
>> +       struct scatterlist *sg;
>> +       struct iova *iova;
>> +       size_t size = 0;
>> +       uint32_t iova_addr;
>> +       int i;
>> +
>> +       for_each_sg(sglist, sg, nents, i)
>> +               size += PAGE_ALIGN(sg->length) >> PAGE_SHIFT;
>> +
>> +       dev_dbg(dev, "dmamap: mapping sg %d entries, %zu pages\n", nents, size);
>> +
>> +       iova = alloc_iova(&mmu->iova_domain, size,
>> +                         dma_get_mask(dev) >> PAGE_SHIFT, 0);
>> +       if (!iova)
>> +               return 0;
>> +
>> +       dev_dbg(dev, "dmamap: iova low pfn %lu, high pfn %lu\n", iova->pfn_lo,
>> +               iova->pfn_hi);
>> +
>> +       iova_addr = iova->pfn_lo;
>> +
>> +       for_each_sg(sglist, sg, nents, i) {
>> +               int rval;
>> +
>> +               dev_dbg(dev,
>> +                       "dmamap: entry %d: iova 0x%8.8x, phys 0x%16.16llx\n",
>> +                       i, iova_addr << PAGE_SHIFT, page_to_phys(sg_page(sg)));
>> +               rval = iommu_map(mmu->domain, iova_addr << PAGE_SHIFT,
>> +                                page_to_phys(sg_page(sg)),
>> +                                PAGE_ALIGN(sg->length), 0);
>> +               if (rval)
>> +                       goto out_fail;
>> +               sg_dma_address(sg) = iova_addr << PAGE_SHIFT;
>> +#ifdef CONFIG_NEED_SG_DMA_LENGTH
>> +               sg_dma_len(sg) = sg->length;
>> +#endif /* CONFIG_NEED_SG_DMA_LENGTH */
>> +
>> +               iova_addr += PAGE_ALIGN(sg->length) >> PAGE_SHIFT;
>> +       }
>> +
>> +       if ((attrs & DMA_ATTR_SKIP_CPU_SYNC) == 0)
>> +               ipu3_dmamap_sync_sg_for_cpu(dev, sglist, nents,
>> +                                           DMA_BIDIRECTIONAL);

Ditto here.

To echo Tomasz' point, all you should really need to implement here is
the cache maintenance and VMA management - everything else can just be
handed off to dma-iommu provided your IOMMU driver sets up the domain
appropriately (see e.g. drivers/iommu/mtk-iommu.c for a reasonably
similar exmaple of a media-subsystem kind of IOMMU).

Robin.

>> +
>> +       return nents;
>> +
>> +out_fail:
>> +       ipu3_dmamap_unmap_sg(dev, sglist, i, dir, attrs);
>> +
>> +       return 0;
>> +}
>> +
>> +/*
>> + * Create scatter-list for the already allocated DMA buffer
>> + */
>> +static int ipu3_dmamap_get_sgtable(struct device *dev, struct sg_table *sgt,
>> +                                  void *cpu_addr, dma_addr_t handle,
>> +                                  size_t size, unsigned long attrs)
>> +{
>> +       struct vm_struct *area = find_vm_area(cpu_addr);
>> +       int n_pages;
>> +       int ret;
>> +
>> +       if (!area || (WARN_ON(!area->pages)))
>> +               return -ENOMEM;
>> +
>> +       n_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
>> +
>> +       ret = sg_alloc_table_from_pages(sgt, area->pages, n_pages, 0, size,
>> +                                       GFP_KERNEL);
>> +       if (ret)
>> +               dev_dbg(dev, "failed to get sgt table\n");
>> +
>> +       return ret;
>> +}
>> +
>> +struct dma_map_ops ipu3_dmamap_ops = {
>> +       .alloc = ipu3_dmamap_alloc,
>> +       .free = ipu3_dmamap_free,
>> +       .mmap = ipu3_dmamap_mmap,
>> +       .map_sg = ipu3_dmamap_map_sg,
>> +       .unmap_sg = ipu3_dmamap_unmap_sg,
>> +       .sync_single_for_cpu = ipu3_dmamap_sync_single_for_cpu,
>> +       .sync_single_for_device = ipu3_dmamap_sync_single_for_cpu,
>> +       .sync_sg_for_cpu = ipu3_dmamap_sync_sg_for_cpu,
>> +       .sync_sg_for_device = ipu3_dmamap_sync_sg_for_cpu,
>> +       .get_sgtable = ipu3_dmamap_get_sgtable,
>> +};
>> +EXPORT_SYMBOL_GPL(ipu3_dmamap_ops);
>> diff --git a/drivers/media/pci/intel/ipu3/ipu3-dmamap.h b/drivers/media/pci/intel/ipu3/ipu3-dmamap.h
>> new file mode 100644
>> index 0000000..714bac0
>> --- /dev/null
>> +++ b/drivers/media/pci/intel/ipu3/ipu3-dmamap.h
>> @@ -0,0 +1,20 @@
>> +/*
>> + * Copyright (c) 2017 Intel Corporation.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License version
>> + * 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#ifndef __IPU3_DMAMAP_H
>> +#define __IPU3_DMAMAP_H
>> +
>> +extern struct dma_map_ops ipu3_dmamap_ops;
>> +
>> +#endif
>> --
>> 2.7.4
>>
