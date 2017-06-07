Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:35071 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751428AbdFGIfh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 04:35:37 -0400
Received: by mail-yw0-f171.google.com with SMTP id 141so1791588ywe.2
        for <linux-media@vger.kernel.org>; Wed, 07 Jun 2017 01:35:36 -0700 (PDT)
Received: from mail-yw0-f174.google.com (mail-yw0-f174.google.com. [209.85.161.174])
        by smtp.gmail.com with ESMTPSA id u187sm390328ywd.22.2017.06.07.01.35.34
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jun 2017 01:35:34 -0700 (PDT)
Received: by mail-yw0-f174.google.com with SMTP id l14so1798772ywk.1
        for <linux-media@vger.kernel.org>; Wed, 07 Jun 2017 01:35:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BZGVBdbN-8L+pvAf4AkBkB9UFy7_mmMpusFUMxDugQDw@mail.gmail.com>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-3-git-send-email-yong.zhi@intel.com> <CAAFQd5BZGVBdbN-8L+pvAf4AkBkB9UFy7_mmMpusFUMxDugQDw@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 7 Jun 2017 17:35:13 +0900
Message-ID: <CAAFQd5CdV4ZfAYHH7DBBfOY=c4_Lwnuf8COs=JUKRSjp1VTn7Q@mail.gmail.com>
Subject: Re: [PATCH 02/12] intel-ipu3: mmu: implement driver
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong, Tuukka,

Continuing from yesterday. Please see comments inline.

> On Tue, Jun 6, 2017 at 5:39 AM, Yong Zhi <yong.zhi@intel.com> wrote:
[snip]
>> +       ptr = ipu3_mmu_alloc_page_table(mmu_dom, false);
>> +       if (!ptr)
>> +               goto fail_page_table;
>> +
>> +       /*
>> +        * We always map the L1 page table (a single page as well as
>> +        * the L2 page tables).
>> +        */
>> +       mmu_dom->dummy_l2_tbl = virt_to_phys(ptr) >> IPU3_MMU_PAGE_SHIFT;
>> +       mmu_dom->pgtbl = ipu3_mmu_alloc_page_table(mmu_dom, true);
>> +       if (!mmu_dom->pgtbl)
>> +               goto fail_page_table;
>> +
>> +       spin_lock_init(&mmu_dom->lock);
>> +       return &mmu_dom->domain;
>> +
>> +fail_page_table:
>> +       free_page((unsigned long)TBL_VIRT_ADDR(mmu_dom->dummy_page));
>> +       free_page((unsigned long)TBL_VIRT_ADDR(mmu_dom->dummy_l2_tbl));
>> +fail_get_page:
>> +       kfree(mmu_dom);
>> +       return NULL;
>> +}
>> +
>> +static void ipu3_mmu_domain_free(struct iommu_domain *dom)
>> +{
>> +       struct ipu3_mmu_domain *mmu_dom =
>> +               container_of(dom, struct ipu3_mmu_domain, domain);
>> +       uint32_t l1_idx;
>> +
>> +       for (l1_idx = 0; l1_idx < IPU3_MMU_L1PT_PTES; l1_idx++)
>> +               if (mmu_dom->pgtbl[l1_idx] != mmu_dom->dummy_l2_tbl)
>> +                       free_page((unsigned long)
>> +                                 TBL_VIRT_ADDR(mmu_dom->pgtbl[l1_idx]));
>> +
>> +       free_page((unsigned long)TBL_VIRT_ADDR(mmu_dom->dummy_page));
>> +       free_page((unsigned long)TBL_VIRT_ADDR(mmu_dom->dummy_l2_tbl));

I might be overly paranoid, but reading back kernel virtual pointers
from device accessible memory doesn't seem safe to me. Other drivers
keep kernel pointers of page tables in a dedicated array (it's only 8K
of memory, but much better safety).

>> +       free_page((unsigned long)mmu_dom->pgtbl);
>> +       kfree(mmu_dom);
>> +}
>> +
>> +/**
>> + * ipu3_mmu_map - mapping iova allocated cache to phy addr
>> + * @domain: iommu domain
>> + * @iova: virtual address
>> + * @paddr: physical address
>> + * @size: size to be mapped
>> + * Allocate L2 pgt if needed and establish the mapping between
>> + * iova address space and pfn
>> + *
>> + * Return: 0 for success
>> + * or negative on failure.
>> + */
>> +static int ipu3_mmu_map(struct iommu_domain *domain, unsigned long iova,
>> +                       phys_addr_t paddr, size_t size, int prot)
>> +{
>> +       struct ipu3_mmu_domain *mmu_dom =
>> +               container_of(domain, struct ipu3_mmu_domain, domain);

Please add a static inline function for this conversion.

>> +       uint32_t iova_start = round_down(iova, IPU3_MMU_PAGE_SIZE);
>> +       uint32_t iova_end = ALIGN(iova + size, IPU3_MMU_PAGE_SIZE);
>> +       uint32_t l1_idx = iova >> IPU3_MMU_L1PT_SHIFT;
>> +       uint32_t l1_entry = mmu_dom->pgtbl[l1_idx];
>> +       uint32_t *l2_pt;
>> +       uint32_t l2_idx;
>> +       unsigned long flags;
>> +
>> +       /* map to single PAGE */
>> +       WARN_ON(size != IPU3_MMU_PAGE_SIZE);

If we already check this, we could fail as well, i.e.

        if (WARN_ON(size != IPU3_MMU_PAGE_SIZE))
                return -EINVAL;

>> +
>> +       dev_dbg(mmu_dom->mmu->dev,
>> +               "mapping iova 0x%8.8x--0x%8.8x, size %zu at paddr 0x%pa\n",
>> +               iova_start, iova_end, size, &paddr);
>> +       dev_dbg(mmu_dom->mmu->dev,
>> +               "mapping l2 page table for l1 index %u (iova 0x%8.8lx)\n",
>> +               l1_idx, iova);
>> +
>> +       if (l1_entry == mmu_dom->dummy_l2_tbl) {
>> +               uint32_t *l2_virt = ipu3_mmu_alloc_page_table(mmu_dom, false);
>> +
>> +               if (!l2_virt)
>> +                       return -ENOMEM;
>> +
>> +               l1_entry = virt_to_phys(l2_virt) >> IPU3_MMU_PAGE_SHIFT;
>> +               dev_dbg(mmu_dom->mmu->dev,
>> +                       "allocated page for l1_idx %u\n", l1_idx);
>> +
>> +               spin_lock_irqsave(&mmu_dom->lock, flags);
>> +               if (mmu_dom->pgtbl[l1_idx] == mmu_dom->dummy_l2_tbl) {
>> +                       mmu_dom->pgtbl[l1_idx] = l1_entry;
>> +                       clflush_cache_range(&mmu_dom->pgtbl[l1_idx],
>> +                                           sizeof(mmu_dom->pgtbl[l1_idx]));
>> +               } else {
>> +                       spin_unlock_irqrestore(&mmu_dom->lock, flags);
>> +                       free_page((unsigned long)TBL_VIRT_ADDR(l1_entry));
>> +                       spin_lock_irqsave(&mmu_dom->lock, flags);
>> +               }
>> +       } else {
>> +               spin_lock_irqsave(&mmu_dom->lock, flags);
>> +       }
>> +
>> +       l2_pt = TBL_VIRT_ADDR(mmu_dom->pgtbl[l1_idx]);
>> +
>> +       dev_dbg(mmu_dom->mmu->dev, "l2_pt at %p\n", l2_pt);
>> +
>> +       paddr = ALIGN(paddr, IPU3_MMU_PAGE_SIZE);
>> +
>> +       l2_idx = (iova_start & IPU3_MMU_L2PT_MASK) >> IPU3_MMU_L2PT_SHIFT;
>> +
>> +       dev_dbg(mmu_dom->mmu->dev,
>> +               "l2_idx %u, phys 0x%8.8x\n", l2_idx, l2_pt[l2_idx]);
>> +       if (l2_pt[l2_idx] != mmu_dom->dummy_page) {
>> +               spin_unlock_irqrestore(&mmu_dom->lock, flags);
>> +               return -EBUSY;
>> +       }
>> +
>> +       /* write 27 bit phy addr to L2 pgt*/
>> +       l2_pt[l2_idx] = paddr >> IPU3_MMU_PAGE_SHIFT;
>> +
>> +       spin_unlock_irqrestore(&mmu_dom->lock, flags);
>> +
>> +       clflush_cache_range(&l2_pt[l2_idx], sizeof(l2_pt[l2_idx]));
>> +
>> +       dev_dbg(mmu_dom->mmu->dev,
>> +               "l2 index %u mapped as 0x%8.8x\n", l2_idx, l2_pt[l2_idx]);
>> +
>> +       ipu3_mmu_tlb_invalidate(mmu_dom->mmu->base);
>> +
>> +       return 0;
>> +}
>> +
>> +static size_t ipu3_mmu_unmap(struct iommu_domain *domain, unsigned long iova,
>> +                            size_t size)
>> +{
>> +       struct ipu3_mmu_domain *mmu_dom =
>> +               container_of(domain, struct ipu3_mmu_domain, domain);
>> +       uint32_t l1_idx = iova >> IPU3_MMU_L1PT_SHIFT;
>> +       uint32_t *l2_pt = TBL_VIRT_ADDR(mmu_dom->pgtbl[l1_idx]);
>> +       uint32_t iova_start = iova;
>> +       unsigned int l2_idx;
>> +       size_t unmapped = 0;
>> +
>> +       dev_dbg(mmu_dom->mmu->dev,
>> +               "unmapping l2 page table for l1 index %u (iova 0x%8.8lx)\n",
>> +               l1_idx, iova);
>> +
>> +       if (mmu_dom->pgtbl[l1_idx] == mmu_dom->dummy_l2_tbl)
>> +               return -EINVAL;
>> +
>> +       dev_dbg(mmu_dom->mmu->dev, "l2_pt at %p\n", l2_pt);
>> +
>> +       for (l2_idx = (iova_start & IPU3_MMU_L2PT_MASK) >> IPU3_MMU_L2PT_SHIFT;
>> +            (iova_start & IPU3_MMU_L1PT_MASK) + (l2_idx << IPU3_MMU_PAGE_SHIFT)
>> +                     < iova_start + size && l2_idx < IPU3_MMU_L2PT_PTES;

Could you define macros for these two calculations?

>> +             l2_idx++) {
>> +               unsigned long flags;
>> +
>> +               dev_dbg(mmu_dom->mmu->dev,
>> +                       "l2 index %u unmapped, was 0x%10.10lx\n",
>> +                       l2_idx, (unsigned long)TBL_PHYS_ADDR(l2_pt[l2_idx]));
>> +               spin_lock_irqsave(&mmu_dom->lock, flags);
>> +               l2_pt[l2_idx] = mmu_dom->dummy_page;
>> +               spin_unlock_irqrestore(&mmu_dom->lock, flags);
>> +               clflush_cache_range(&l2_pt[l2_idx], sizeof(l2_pt[l2_idx]));

I think it would make more sense from performance point of view to
flush the whole range outside the loop. However...

>> +               unmapped++;
>> +       }

The core iommu_unmap() already splits the unmap operation into biggest
valid page sizes
(http://elixir.free-electrons.com/linux/latest/source/drivers/iommu/iommu.c#L1540)
and this driver only sets 4K as the allowed page size, so this
function will always be called with size == 4K and the loop above can
iterate at most once.

>> +
>> +       ipu3_mmu_tlb_invalidate(mmu_dom->mmu->base);
>> +
>> +       return unmapped << IPU3_MMU_PAGE_SHIFT;
>> +}
>> +
>> +static phys_addr_t ipu3_mmu_iova_to_phys(struct iommu_domain *domain,
>> +                                        dma_addr_t iova)
>> +{
>> +       struct ipu3_mmu_domain *d =
>> +               container_of(domain, struct ipu3_mmu_domain, domain);
>> +       uint32_t *l2_pt = TBL_VIRT_ADDR(d->pgtbl[iova >> IPU3_MMU_L1PT_SHIFT]);
>> +
>> +       return (phys_addr_t)l2_pt[(iova & IPU3_MMU_L2PT_MASK)
>> +                               >> IPU3_MMU_L2PT_SHIFT] << IPU3_MMU_PAGE_SHIFT;

Could we avoid this TBL_VIRT_ADDR() here too? The memory cost to store
the page table CPU pointers is really small, but safety seems much
better. Moreover, it should make it possible to use the VT-d IOMMU to
further secure the system.

>> +}
>> +
>> +static struct iommu_ops ipu3_mmu_ops = {
>> +       .add_device     = ipu3_mmu_add_device,
>> +       .domain_alloc   = ipu3_mmu_domain_alloc,
>> +       .domain_free    = ipu3_mmu_domain_free,
>> +       .map            = ipu3_mmu_map,
>> +       .unmap          = ipu3_mmu_unmap,
>> +       .iova_to_phys   = ipu3_mmu_iova_to_phys,
>> +       .pgsize_bitmap  = SZ_4K,
>> +};
>> +
>> +static int ipu3_mmu_bus_match(struct device *dev, struct device_driver *drv)
>> +{
>> +       return !strcmp(dev_name(dev), drv->name);
>> +}
>> +
>> +static int ipu3_mmu_bus_probe(struct device *dev)
>> +{
>> +       struct ipu3_mmu *mmu = dev_get_drvdata(dev);
>> +       struct ipu3_mmu_domain *mmu_domain;
>> +       int r;
>> +
>> +       r = bus_set_iommu(dev->bus, &ipu3_mmu_ops);
>> +       if (r)
>> +               return r;
>> +
>> +       /* mmu_domain allocated */
>> +       mmu->domain = iommu_domain_alloc(dev->bus);
>> +       if (!mmu->domain)
>> +               return -ENOMEM;

Something is not right here. Normally the IOMMU core allocates a
default domain for your iommu_group automatically. Then when
bus_set_iommu() is called, it goes over all the devices on the bus and
tries to add them to the group, which also means attaching to the
default domain.

>> +
>> +       /* Write page table address */
>> +       mmu_domain = container_of(mmu->domain, struct ipu3_mmu_domain, domain);
>> +       /* Write L1 pgt addr to config reg*/
>> +       mmu_domain->mmu = mmu;
>> +
>> +       writel((phys_addr_t)virt_to_phys(mmu_domain->pgtbl)
>> +               >> IPU3_MMU_PAGE_SHIFT, mmu->base + REG_L1_PHYS);
>> +       ipu3_mmu_tlb_invalidate(mmu->base);
>> +       /* 4K page granularity, start and end pfn */
>> +       init_iova_domain(&mmu->iova_domain, SZ_4K, 1,
>> +                        dma_get_mask(dev) >> PAGE_SHIFT);

This is typically done in .attach_device() callback.

>> +
>> +       r = iova_cache_get();

This is normally not necessary and your DMA mapping code should do it
(or even better, your DMA mapping code should use the generic DMA
mapping helpers, which already call this).

>> +       if (r)
>> +               goto fail_cache;
>> +
>> +       return 0;
>> +
>> +fail_cache:
>> +       put_iova_domain(&mmu->iova_domain);
>> +       iommu_domain_free(mmu->domain);
>> +       return r;
>> +}
>> +
>> +static void ipu3_mmu_release(struct device *dev)
>> +{
>> +}
>> +
>> +static int ipu3_mmu_bus_remove(struct device *dev)
>> +{
>> +       struct ipu3_mmu *mmu = dev_get_drvdata(dev);
>> +
>> +       put_iova_domain(&mmu->iova_domain);
>> +       iova_cache_put();

Don't we need to set the L1 table address to something invalid and
invalidate the TLB, so that the IOMMU doesn't reference the page freed
below anymore?

>> +       iommu_domain_free(mmu->domain);
>> +
>> +       return 0;
>> +}
>> +
>> +static struct bus_type ipu3_mmu_bus = {
>> +       .name   = IPU3_MMU_BUS_NAME,
>> +       .match  = ipu3_mmu_bus_match,
>> +       .probe  = ipu3_mmu_bus_probe,
>> +       .remove = ipu3_mmu_bus_remove,
>> +};
>> +
>> +static struct device ipu3_mmu_device = {
>> +       .bus     = &ipu3_mmu_bus,
>> +       .release = ipu3_mmu_release,
>> +};
>> +
>> +static struct device_driver ipu3_mmu_driver = {
>> +       .name  = IPU3_MMU_NAME,
>> +       .owner = THIS_MODULE,
>> +       .bus   = &ipu3_mmu_bus,
>> +};
>> +
>> +int ipu3_mmu_init(struct ipu3_mmu *mmu, void __iomem *base, struct device *dev)
>> +{
>> +       struct ipu3_mmu_domain *mmu_dom;
>> +       int r;
>> +
>> +       mmu->base = base;
>> +       mmu->dev  = &ipu3_mmu_device;
>> +
>> +       r = bus_register(&ipu3_mmu_bus);
>> +       if (r)
>> +               goto fail_bus;
>> +
>> +       r = dev_set_name(mmu->dev, IPU3_MMU_NAME);

Hmm, this device is not the MMU, but rather the master behind the MMU,
which is subject to the memory mapping.

Also I might have forgotten to mentioned before, but this MMU is a
part of the PCI device and I believe that it might be subject to
another memory mapping as well (e.g. VT-d IOMMU). So DMA mapping API
must be used to obtain DMA addresses of the pages that are supposed to
be accessed by or over this MMU.

>> +       if (r)
>> +               goto fail_device;
>> +       if (dev->dma_mask) {
>> +               mmu->dma_mask = DMA_BIT_MASK(IPU3_MMU_ADDRESS_BITS);
>> +               mmu->dev->dma_mask = &mmu->dma_mask;
>> +       }
>> +       mmu->dev->coherent_dma_mask = mmu->dma_mask;
>> +       dev_set_drvdata(mmu->dev, mmu);
>> +       r = device_register(mmu->dev);
>> +       if (r) {
>> +               put_device(mmu->dev);
>> +               goto fail_device;
>> +       }
>> +
>> +       r = driver_register(&ipu3_mmu_driver);
>> +       if (r)
>> +               goto fail_driver;
>> +
>> +       mmu_dom = container_of(mmu->domain, struct ipu3_mmu_domain, domain);
>> +       mmu->pgtbl = virt_to_phys(mmu_dom->pgtbl);
>> +
>> +       return 0;
>> +
>> +fail_driver:
>> +       device_unregister(mmu->dev);
>> +fail_device:
>> +       bus_unregister(&ipu3_mmu_bus);
>> +fail_bus:
>> +       return r;
>> +}
>> +EXPORT_SYMBOL_GPL(ipu3_mmu_init);
>> +
>> +void ipu3_mmu_exit(struct ipu3_mmu *mmu)
>> +{
>> +       driver_unregister(&ipu3_mmu_driver);
>> +       device_unregister(mmu->dev);
>> +       bus_unregister(&ipu3_mmu_bus);
>> +}
>> +EXPORT_SYMBOL_GPL(ipu3_mmu_exit);
>> +
>> +MODULE_AUTHOR("Tuukka Toivonen <tuukka.toivonen@intel.com>");
>> +MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>> +MODULE_AUTHOR("Samu Onkalo <samu.onkalo@intel.com>");
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_DESCRIPTION("ipu3 mmu driver");
>> diff --git a/drivers/media/pci/intel/ipu3/ipu3-mmu.h b/drivers/media/pci/intel/ipu3/ipu3-mmu.h
>> new file mode 100644
>> index 0000000..45ad400
>> --- /dev/null
>> +++ b/drivers/media/pci/intel/ipu3/ipu3-mmu.h
>> @@ -0,0 +1,73 @@
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
>> +#ifndef __IPU3_MMU_H
>> +#define __IPU3_MMU_H
>> +
>> +#include <linux/iova.h>
>> +#include <linux/iommu.h>
>> +
>> +#define to_ipu3_mmu(dev)       dev_get_drvdata(dev)

Please use static inline for proper type checks.

>> +
>> +#define IPU3_MMU_NAME          "ipu3-mmu"
>> +#define IPU3_MMU_BUS_NAME      "ipu3-bus"
>> +
>> +#define IPU3_MMU_ADDRESS_BITS  32
>> +
>> +#define IPU3_MMU_PAGE_SHIFT    12
>> +#define IPU3_MMU_PAGE_SIZE     (1U << IPU3_MMU_PAGE_SHIFT)
>> +#define IPU3_MMU_PAGE_MASK     (~(IPU3_MMU_PAGE_SIZE - 1))
>> +
>> +#define IPU3_MMU_L1PT_SHIFT    22
>> +#define IPU3_MMU_L1PT_MASK     (~((1U << IPU3_MMU_L1PT_SHIFT) - 1))
>> +#define IPU3_MMU_L1PT_PTES     1024
>> +
>> +#define IPU3_MMU_L2PT_SHIFT    IPU3_MMU_PAGE_SHIFT
>> +#define IPU3_MMU_L2PT_MASK     (~(IPU3_MMU_L1PT_MASK | \
>> +                                (~(IPU3_MMU_PAGE_MASK))))
>> +#define IPU3_MMU_L2PT_PTES     1024
>> +
>> +#define REG_TLB_INVALIDATE     0x0300
>> +#define TLB_INVALIDATE         1
>> +#define IMGU_REG_BASE          0x4000
>> +#define REG_L1_PHYS            (IMGU_REG_BASE + 0x304) /* 27-bit pfn */
>> +
>> +#define TBL_VIRT_ADDR(a)       ((a) ? phys_to_virt(TBL_PHYS_ADDR(a)) : NULL)
>> +#define TBL_PHYS_ADDR(a)       ((phys_addr_t)(a) << \
>> +                                       IPU3_MMU_PAGE_SHIFT)

We should avoid reading back from the device memory, as I mentioned earlier.

>> +
>> +struct ipu3_mmu_domain {
>> +       struct ipu3_mmu *mmu;
>> +       struct iommu_domain domain;
>> +       spinlock_t lock;

Please add a comment explaining what is protected by this spinlock.

(Which also raises a question if this patch was checked with checkpatch.)

Best regards,
Tomasz
