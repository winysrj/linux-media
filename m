Return-path: <linux-media-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:59270 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751628AbdG1OK7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 10:10:59 -0400
From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 02/12] intel-ipu3: mmu: implement driver
To: Tomasz Figa <tfiga@chromium.org>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>
References: <1500433958-2304-1-git-send-email-yong.zhi@intel.com>
 <efc5aab9-9f4e-fba3-034b-185d3d7e0fcd@arm.com>
 <CAAFQd5BN9+zv5ZizX6y+EAi6MvBrVycptjXREaGm3iKqH6F_Og@mail.gmail.com>
Message-ID: <f3dab4c1-069a-812d-ba0a-0090c13bb9fc@arm.com>
Date: Fri, 28 Jul 2017 15:10:56 +0100
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BN9+zv5ZizX6y+EAi6MvBrVycptjXREaGm3iKqH6F_Og@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/07/17 11:38, Tomasz Figa wrote:
> Hi Robin,
> 
> On Wed, Jul 19, 2017 at 10:37 PM, Robin Murphy <robin.murphy@arm.com> wrote:
>> On 19/07/17 04:12, Yong Zhi wrote:
>>> From: Tomasz Figa <tfiga@chromium.org>
>>>
>>> This driver translates Intel IPU3 internal virtual
>>> address to physical address.
>>>
>>> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
>>> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
>>> ---
>>>  drivers/media/pci/intel/ipu3/Kconfig    |   9 +
>>>  drivers/media/pci/intel/ipu3/Makefile   |  15 +
>>>  drivers/media/pci/intel/ipu3/ipu3-mmu.c | 639 ++++++++++++++++++++++++++++++++
>>>  drivers/media/pci/intel/ipu3/ipu3-mmu.h |  27 ++
>>>  4 files changed, 690 insertions(+)
>>>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.c
>>>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.h
>>>
>>> diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
>>> index 2a895d6..7bcdfa5 100644
>>> --- a/drivers/media/pci/intel/ipu3/Kconfig
>>> +++ b/drivers/media/pci/intel/ipu3/Kconfig
>>> @@ -15,3 +15,12 @@ config VIDEO_IPU3_CIO2
>>>       Say Y or M here if you have a Skylake/Kaby Lake SoC with MIPI CSI-2
>>>       connected camera.
>>>       The module will be called ipu3-cio2.
>>> +
>>> +config INTEL_IPU3_MMU
>>> +     tristate
>>
>> Shouldn't this be bool now?
> 
> Well, depends on what we expect it to be. I still didn't see any good
> reason not to make it a loadable module.

Sure, conceptually there's no real reason it shouldn't be *allowed* to
be built as a module, but without all the necessary symbols exported, a
tristate here is only going to make allmodconfig builds fail.

>>> +     default n
>>> +     select IOMMU_API
>>> +     select IOMMU_IOVA
>>> +     ---help---
>>> +       For IPU3, this option enables its MMU driver to translate its internal
>>> +       virtual address to 39 bits wide physical address for 64GBytes space access.
>>> diff --git a/drivers/media/pci/intel/ipu3/Makefile b/drivers/media/pci/intel/ipu3/Makefile
>>> index 20186e3..91cac9c 100644
>>> --- a/drivers/media/pci/intel/ipu3/Makefile
>>> +++ b/drivers/media/pci/intel/ipu3/Makefile
>>> @@ -1 +1,16 @@
>>> +#
>>> +#  Copyright (c) 2017, Intel Corporation.
>>> +#
>>> +#  This program is free software; you can redistribute it and/or modify it
>>> +#  under the terms and conditions of the GNU General Public License,
>>> +#  version 2, as published by the Free Software Foundation.
>>> +#
>>> +#  This program is distributed in the hope it will be useful, but WITHOUT
>>> +#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>>> +#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>>> +#  more details.
>>> +#
>>> +
>>>  obj-$(CONFIG_VIDEO_IPU3_CIO2) += ipu3-cio2.o
>>> +obj-$(CONFIG_INTEL_IPU3_MMU) += ipu3-mmu.o
>>> +
>>> diff --git a/drivers/media/pci/intel/ipu3/ipu3-mmu.c b/drivers/media/pci/intel/ipu3/ipu3-mmu.c
>>> new file mode 100644
>>> index 0000000..093b821
>>> --- /dev/null
>>> +++ b/drivers/media/pci/intel/ipu3/ipu3-mmu.c
>>> @@ -0,0 +1,639 @@
>>> +/*
>>> + * Copyright (c) 2017 Intel Corporation.
>>> + * Copyright (C) 2017 Google, Inc.
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>>> + * modify it under the terms of the GNU General Public License version
>>> + * 2 as published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + *
>>> + */
>>> +
>>> +#include <linux/dma-iommu.h>
>>> +#include <linux/iova.h>
>>> +#include <linux/iommu.h>
>>> +#include <linux/iopoll.h>
>>> +#include <linux/module.h>
>>> +#include <linux/pm_runtime.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/vmalloc.h>
>>> +
>>> +#include <asm/cacheflush.h>
>>> +
>>> +#include "ipu3-mmu.h"
>>> +
>>> +#define IPU3_PAGE_SHIFT              12
>>> +#define IPU3_PAGE_SIZE               (1UL << IPU3_PAGE_SHIFT)
>>> +
>>> +#define IPU3_PT_BITS         10
>>> +#define IPU3_PT_PTES         (1UL << IPU3_PT_BITS)
>>> +
>>> +#define IPU3_ADDR2PTE(addr)  ((addr) >> IPU3_PAGE_SHIFT)
>>> +#define IPU3_PTE2ADDR(pte)   ((phys_addr_t)(pte) << IPU3_PAGE_SHIFT)
>>> +
>>> +#define IPU3_L2PT_SHIFT              IPU3_PT_BITS
>>> +#define IPU3_L2PT_MASK               ((1UL << IPU3_L2PT_SHIFT) - 1)
>>> +
>>> +#define IPU3_L1PT_SHIFT              IPU3_PT_BITS
>>> +#define IPU3_L1PT_MASK               ((1UL << IPU3_L1PT_SHIFT) - 1)
>>> +
>>> +#define IPU3_MMU_ADDRESS_BITS        (IPU3_PAGE_SHIFT + \
>>> +                              IPU3_L2PT_SHIFT + \
>>> +                              IPU3_L1PT_SHIFT)
>>> +
>>> +#define IMGU_REG_BASE                0x4000
>>> +#define REG_TLB_INVALIDATE   (IMGU_REG_BASE + 0x300)
>>> +#define TLB_INVALIDATE               1
>>> +#define REG_L1_PHYS          (IMGU_REG_BASE + 0x304) /* 27-bit pfn */
>>> +#define REG_GP_HALT          (IMGU_REG_BASE + 0x5dc)
>>> +#define REG_GP_HALTED                (IMGU_REG_BASE + 0x5e0)
>>> +
>>> +struct ipu3_mmu_domain {
>>> +     struct iommu_domain domain;
>>> +
>>> +     struct ipu3_mmu *mmu;
>>> +     spinlock_t lock;
>>> +
>>> +     void *dummy_page;
>>> +     u32 dummy_page_pteval;
>>> +
>>> +     u32 *dummy_l2pt;
>>> +     u32 dummy_l2pt_pteval;
>>> +
>>> +     u32 **l2pts;
>>> +};
>>> +
>>> +struct ipu3_mmu {
>>> +     struct device *dev;
>>> +     struct bus_type *bus;
>>> +     void __iomem *base;
>>> +     struct iommu_group *group;
>>> +     struct iommu_ops ops;
>>
>> The usual pattern is to have a static const set of ops per driver. Do
>> these actually need to be per-instance and/or mutable?
> 
> It's convenient to switch from iommu_ops to ipu3_mmu struct. Although
> I guess we could do away without it after a small redesign.
> 
>>
>>> +     struct ipu3_mmu_domain *domain;
>>
>> Strictly, you shouldn't need to track this as the group will already
>> enforce only a single domain active at any given time, but I guess it's
>> to avoid redundantly reinstalling the pagetable multiple times on attach
>> when the group has multiple devices.
>>
>> It ought to be sufficient to use domain->mmu to indicate whether the
>> hardware is up-to-date, and call iommu_get_domain_for_dev() from
>> .attach_dev() to get the old domain to be detached from (if any), but
>> I'm not necessarily sure that works out any nicer in the end :/
> 
> It might be possible to remove this, let me check.
> 
>>
>>> +
>>> +     u32 *l1pt;
>>> +};
>>> +
>>> +static inline struct ipu3_mmu *to_ipu3_mmu(struct device *dev)
>>> +{
>>> +     const struct iommu_ops *iommu_ops = dev->bus->iommu_ops;
>>> +
>>> +     return container_of(iommu_ops, struct ipu3_mmu, ops);
>>
>> If you don't have any per-device state to warrant using
>> dev->iommu_fwspec, I'd just stash the ipu3_mmu pointer in
>> dev->archdata.iommu for each master.
> 
> dev->archdata.iommu seems to be reserved for Intel or AMD IOMMU in
> current code [1]. Should I add one more alternative for
> CONFIG_INTEL_IPU3_MMU? To be honest, I don't see a reason for such
> #ifdef at all...

Ah right, I'd forgotten that dependency isn't CONFIG_IOMMU_API as it is
for ARM - it probably could be, though.

> [1] http://elixir.free-electrons.com/linux/v4.13-rc2/source/arch/x86/include/asm/device.h#L4
> 
>>
>>> +}
>>> +
>>> +static inline struct ipu3_mmu_domain *
>>> +to_ipu3_mmu_domain(struct iommu_domain *domain)
>>> +{
>>> +     return container_of(domain, struct ipu3_mmu_domain, domain);
>>> +}
>>> +
>>> +/**
>>> + * ipu3_mmu_tlb_invalidate - invalidate translation look-aside buffer
>>> + * @mmu: MMU to perform the invalidate operation on
>>> + *
>>> + * This function invalidates the whole TLB. Must be called when the hardware
>>> + * is powered on.
>>> + */
>>> +static void ipu3_mmu_tlb_invalidate(struct ipu3_mmu *mmu)
>>> +{
>>> +     writel(TLB_INVALIDATE, mmu->base + REG_TLB_INVALIDATE);
>>> +}
>>> +
>>> +static void call_if_ipu3_is_powered(struct ipu3_mmu *mmu,
>>> +                                 void (*func)(struct ipu3_mmu *mmu))
>>> +{
>>> +     pm_runtime_get_noresume(mmu->dev);
>>> +     if (pm_runtime_active(mmu->dev))
>>> +             func(mmu);
>>> +     pm_runtime_put(mmu->dev);
>>> +}
>>> +
>>> +/**
>>> + * ipu3_mmu_set_halt - set CIO gate halt bit
>>> + * @mmu: MMU to set the CIO gate bit in.
>>> + * @halt: Desired state of the gate bit.
>>> + *
>>> + * This function sets the CIO gate bit that controls whether external memory
>>> + * accesses are allowed. Must be called when the hardware is powered on.
>>> + */
>>> +static void ipu3_mmu_set_halt(struct ipu3_mmu *mmu, bool halt)
>>> +{
>>> +     int ret;
>>> +     u32 val;
>>> +
>>> +     writel(halt, mmu->base + REG_GP_HALT);
>>> +     ret = readl_poll_timeout(mmu->base + REG_GP_HALTED,
>>> +                              val, (val & 1) == halt, 1000, 100000);
>>> +
>>> +     if (ret)
>>> +             dev_err(mmu->dev, "failed to %s CIO gate halt\n",
>>> +                     halt ? "set" : "clear");
>>> +}
>>> +
>>> +/**
>>> + * ipu3_mmu_alloc_page_table - allocate a pre-filled page table
>>> + * @pteval: Value to initialize for page table entries with.
>>> + *
>>> + * Return: Pointer to allocated page table or NULL on failure.
>>> + */
>>> +static u32 *ipu3_mmu_alloc_page_table(u32 pteval)
>>> +{
>>> +     u32 *pt;
>>> +     int pte;
>>> +
>>> +     pt = kmalloc_array(IPU3_PT_PTES, sizeof(*pt), GFP_KERNEL);
>>> +     if (!pt)
>>> +             return NULL;
>>> +
>>> +     for (pte = 0; pte < IPU3_PT_PTES; pte++)
>>> +             pt[pte] = pteval;
>>> +
>>> +     clflush_cache_range(pt, IPU3_PT_PTES * sizeof(*pt));
>>> +
>>> +     return pt;
>>> +}
>>> +
>>> +/**
>>> + * ipu3_mmu_free_page_table - free page table
>>> + * @pt: Page table to free.
>>> + */
>>> +static void ipu3_mmu_free_page_table(u32 *pt)
>>> +{
>>> +     kfree(pt);
>>> +}
>>> +
>>> +/**
>>> + * address_to_pte_idx - split IOVA into L1 and L2 page table indices
>>> + * @iova: IOVA to split.
>>> + * @l1pt_idx: Output for the L1 page table index.
>>> + * @l2pt_idx: Output for the L2 page index.
>>> + */
>>> +static void address_to_pte_idx(unsigned long iova, u32 *l1pt_idx,
>>> +                            u32 *l2pt_idx)
>>> +{
>>> +     iova >>= IPU3_PAGE_SHIFT;
>>> +
>>> +     if (l2pt_idx)
>>> +             *l2pt_idx = iova & IPU3_L2PT_MASK;
>>> +
>>> +     iova >>= IPU3_L2PT_SHIFT;
>>> +
>>> +     if (l1pt_idx)
>>> +             *l1pt_idx = iova & IPU3_L1PT_MASK;
>>> +}
>>> +
>>> +static struct iommu_domain *ipu3_mmu_domain_alloc(unsigned int type)
>>> +{
>>> +     struct ipu3_mmu_domain *mmu_dom;
>>> +     u32 pteval;
>>> +
>>> +     if (WARN(type != IOMMU_DOMAIN_DMA,
>>> +              "IPU3 MMU only supports DMA domains\n"))
>>> +             return NULL;
>>> +
>>> +     mmu_dom = kzalloc(sizeof(*mmu_dom), GFP_KERNEL);
>>> +     if (!mmu_dom)
>>> +             return NULL;
>>> +
>>> +     if (iommu_get_dma_cookie(&mmu_dom->domain))
>>> +             goto fail_domain;
>>> +
>>> +     mmu_dom->domain.geometry.aperture_start = 0;
>>> +     mmu_dom->domain.geometry.aperture_end =
>>> +             DMA_BIT_MASK(IPU3_MMU_ADDRESS_BITS);
>>> +     mmu_dom->domain.geometry.force_aperture = true;
>>> +
>>> +     /*
>>> +      * The MMU does not have a "valid" bit, so we have to use a dummy
>>> +      * page for invalid entries.
>>> +      */
>>> +     mmu_dom->dummy_page = kzalloc(IPU3_PAGE_SIZE, GFP_KERNEL);
>>> +     if (!mmu_dom->dummy_page)
>>> +             goto fail_cookie;
>>> +     pteval = IPU3_ADDR2PTE(virt_to_phys(mmu_dom->dummy_page));
>>> +     mmu_dom->dummy_page_pteval = pteval;
>>
>> Conceptually, would it make sense for the dummy page to be per-mmu,
>> rather than per-domain? I realise it doesn't make much practical
>> difference if you only expect to ever use a single DMA ops domain, but
>> it would neatly mirror existing drivers which do a similar thing (e.g.
>> the Mediatek IOMMUs).
> 
> It makes it a bit complicated to achieve correctness against the IOMMU
> API, because it would leave the page tables invalid if the domain is
> detached from the MMU.

In general, I'm not convinced it's sane for anyone to be calling
iommu_map/unmap on a domain that isn't live. However, since this driver
only supports DMA ops domains anyway, I don't see how that could happen
at all - a device is always attached to its default domain well before
its driver has a chance to probe and start making DMA API calls. For the
default domain to be detached, all the devices would have to be removed,
at which point there's nobody left to be making DMA API calls (plus it
would have been torn down along with the group anyway).

That said, another way to safely have no MMU dependency at all would be
to just allocate it globally at driver init. Even if you ever did have
multiple IPUs in a system, I don't see that any harm could come of them
sharing the same scratch page either.

>>> +     /*
>>> +      * Allocate a dummy L2 page table with all entries pointing to
>>> +      * the dummy page.
>>> +      */
>>> +     mmu_dom->dummy_l2pt = ipu3_mmu_alloc_page_table(pteval);
>>> +     if (!mmu_dom->dummy_l2pt)
>>> +             goto fail_page;
>>> +     pteval = IPU3_ADDR2PTE(virt_to_phys(mmu_dom->dummy_l2pt));
>>> +     mmu_dom->dummy_l2pt_pteval = pteval;

Thinking about it further, if you did have a single common scratch page,
you should only ever need one common dummy_l2pt to point at it as well.

>>> +
>>> +     /*
>>> +      * Allocate the array of L2PT CPU pointers, initialized to zero,
>>> +      * which means the dummy L2PT allocated above.
>>> +      */
>>> +     mmu_dom->l2pts = vzalloc(IPU3_PT_PTES * sizeof(*mmu_dom->l2pts));
>>> +     if (!mmu_dom->l2pts)
>>> +             goto fail_l2pt;
>>> +
>>> +     spin_lock_init(&mmu_dom->lock);
>>> +     return &mmu_dom->domain;
>>> +
>>> +fail_l2pt:
>>> +     ipu3_mmu_free_page_table(mmu_dom->dummy_l2pt);
>>> +fail_page:
>>> +     kfree(mmu_dom->dummy_page);
>>> +fail_cookie:
>>> +     iommu_put_dma_cookie(&mmu_dom->domain);
>>> +fail_domain:
>>> +     kfree(mmu_dom);
>>> +     return NULL;
>>> +}
>>> +
>>> +static void ipu3_mmu_domain_free(struct iommu_domain *domain)
>>> +{
>>> +     struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
>>> +     int pte;
>>> +
>>> +     /* We expect the domain to be detached already. */
>>> +     WARN_ON(mmu_dom->mmu);
>>> +
>>> +     for (pte = 0; pte < IPU3_PT_PTES; ++pte)
>>> +             ipu3_mmu_free_page_table(mmu_dom->l2pts[pte]); /* NULL-safe */
>>> +     vfree(mmu_dom->l2pts);
>>> +
>>> +     ipu3_mmu_free_page_table(mmu_dom->dummy_l2pt);
>>> +     kfree(mmu_dom->dummy_page);
>>> +     iommu_put_dma_cookie(domain);
>>> +
>>> +     kfree(mmu_dom);
>>> +}
>>> +
>>> +static void ipu3_mmu_disable(struct ipu3_mmu *mmu)
>>> +{
>>> +     ipu3_mmu_set_halt(mmu, true);
>>> +     ipu3_mmu_tlb_invalidate(mmu);
>>> +}
>>> +
>>> +static void ipu3_mmu_detach_dev(struct iommu_domain *domain,
>>> +                             struct device *dev)
>>> +{
>>> +     struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
>>> +     struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
>>> +     unsigned long flags;
>>> +
>>> +     if (mmu->domain != mmu_dom)
>>> +             return;
>>> +
>>> +     /* Disallow external memory access when having no valid page tables. */
>>> +     call_if_ipu3_is_powered(mmu, ipu3_mmu_disable);
>>> +
>>> +     spin_lock_irqsave(&mmu_dom->lock, flags);
>>> +
>>> +     mmu->domain = NULL;
>>> +     mmu_dom->mmu = NULL;
>>> +
>>> +     dev_dbg(dev, "%s: Detached from domain %p\n", __func__, mmu_dom);
>>> +
>>> +     spin_unlock_irqrestore(&mmu_dom->lock, flags);
>>> +
>>> +     memset(mmu->l1pt, 0, IPU3_PT_PTES * sizeof(*mmu->l1pt));
>>
>> Would it not make more sense to install all the dummy entries here...
> 
> Well, it doesn't matter, because we disabled the MMU (locked the
> external memory gate) and flushed the TLB. It will be only able to
> read the page directory once again after we fill it with proper values
> and re-enable.

In which case, is there any need to even bother zeroing the l1pt at all,
given that that's still going to be a "valid" translation to wherever,
depending on what the bottom end of memory contains?

>>> +     clflush_cache_range(mmu->l1pt, IPU3_PT_PTES * sizeof(*mmu->l1pt));
>>> +}
>>> +
>>> +static void ipu3_mmu_enable(struct ipu3_mmu *mmu)
>>> +{
>>> +     ipu3_mmu_tlb_invalidate(mmu);
>>> +     ipu3_mmu_set_halt(mmu, false);
>>> +}
>>> +
>>> +static int ipu3_mmu_attach_dev(struct iommu_domain *domain,
>>> +                            struct device *dev)
>>> +{
>>> +     struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
>>> +     struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
>>> +     unsigned long flags;
>>> +     unsigned int pte;
>>> +
>>> +     if (mmu->domain == mmu_dom)
>>> +             return 0;
>>> +
>>> +     if (mmu->domain)
>>> +             ipu3_mmu_detach_dev(&mmu->domain->domain, dev);
>>> +
>>> +     spin_lock_irqsave(&mmu_dom->lock, flags);
>>> +
>>> +     for (pte = 0; pte < IPU3_PT_PTES; ++pte) {
>>> +             u32 *l2pt = mmu_dom->l2pts[pte];
>>> +             u32 pteval = mmu_dom->dummy_l2pt_pteval;
>>> +
>>> +             if (l2pt)
>>> +                     pteval = IPU3_ADDR2PTE(virt_to_phys(l2pt));
>>> +
>>> +             mmu->l1pt[pte] = pteval;
>>> +     }
>>
>> ...and just the real ones here?
> 
> I guess we could do it, but we would still need to keep dummy pages
> mapped in real L2PTs and that would mean having one dummy page for MMU
> and one dummy page for each domain. I'm not sure what it would give
> us, though.

Sure, it's not a big deal, it was just a little non-obvious what was
going on between detach and attach at first glance. However I've also
now realised the obvious that if attach did expect a dummy-initialised
l1pt already, then that has to be done from both detach and initial
reset, so it probably is cleaner code-wise to do it here.

>>> +
>>> +     clflush_cache_range(mmu->l1pt, IPU3_PT_PTES * sizeof(*mmu->l1pt));
>>> +
>>> +     mmu->domain = mmu_dom;
>>> +     mmu_dom->mmu = mmu;
>>> +
>>> +     dev_dbg(dev, "%s: Attached to domain %p\n", __func__, mmu_dom);
>>> +
>>> +     spin_unlock_irqrestore(&mmu_dom->lock, flags);
>>> +
>>> +     /* We have valid page tables, allow external memory access. */
>>> +     call_if_ipu3_is_powered(mmu, ipu3_mmu_enable);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static u32 *ipu3_mmu_get_l2pt(struct ipu3_mmu_domain *mmu_dom, u32 l1pt_idx,
>>> +                           bool allocate)
>>> +{
>>> +     unsigned long flags;
>>> +     u32 *l2pt, *new_l2pt;
>>> +
>>> +     spin_lock_irqsave(&mmu_dom->lock, flags);
>>> +
>>> +     l2pt = mmu_dom->l2pts[l1pt_idx];
>>> +     if (l2pt || !allocate)
>>> +             goto done;
>>> +
>>> +     spin_unlock_irqrestore(&mmu_dom->lock, flags);
>>> +
>>> +     new_l2pt = ipu3_mmu_alloc_page_table(mmu_dom->dummy_page_pteval);
>>> +     if (!new_l2pt)
>>> +             return NULL;
>>> +
>>> +     spin_lock_irqsave(&mmu_dom->lock, flags);
>>> +
>>> +     dev_dbg(mmu_dom->mmu->dev,
>>> +             "allocated page table %p for l1pt_idx %u\n",
>>> +             new_l2pt, l1pt_idx);
>>> +
>>> +     l2pt = mmu_dom->l2pts[l1pt_idx];
>>> +     if (l2pt) {
>>> +             ipu3_mmu_free_page_table(new_l2pt);
>>> +             goto done;
>>> +     }
>>> +
>>> +     l2pt = new_l2pt;
>>> +     mmu_dom->l2pts[l1pt_idx] = new_l2pt;
>>> +
>>> +     if (mmu_dom->mmu) {
>>> +             u32 pteval;
>>> +
>>> +             pteval = IPU3_ADDR2PTE(virt_to_phys(new_l2pt));
>>> +             mmu_dom->mmu->l1pt[l1pt_idx] = pteval;
>>> +             clflush_cache_range(&mmu_dom->mmu->l1pt[l1pt_idx],
>>> +                                 sizeof(*mmu_dom->mmu->l1pt));
>>> +     }
>>> +
>>> +done:
>>> +     spin_unlock_irqrestore(&mmu_dom->lock, flags);
>>> +     return l2pt;
>>> +}
>>> +
>>> +static int ipu3_mmu_map(struct iommu_domain *domain, unsigned long iova,
>>> +                     phys_addr_t paddr, size_t size, int prot)
>>> +{
>>> +     struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
>>> +     u32 l1pt_idx, l2pt_idx;
>>> +     unsigned long flags;
>>> +     u32 *l2pt;
>>> +
>>> +     /* We assume a page by page mapping. */
>>> +     if (WARN_ON(size != IPU3_PAGE_SIZE))
>>> +             return -EINVAL;
>>
>> The core API already enforces this, so drivers shouldn't need to be
>> paranoid.
> 
> Makes sense, will remove.
> 
>>
>>> +
>>> +     address_to_pte_idx(iova, &l1pt_idx, &l2pt_idx);
>>> +
>>> +     l2pt = ipu3_mmu_get_l2pt(mmu_dom, l1pt_idx, true);
>>> +     if (!l2pt)
>>> +             return -ENOMEM;
>>> +
>>> +     spin_lock_irqsave(&mmu_dom->lock, flags);
>>> +
>>> +     if (l2pt[l2pt_idx] != mmu_dom->dummy_page_pteval) {
>>> +             spin_unlock_irqrestore(&mmu_dom->lock, flags);
>>> +             return -EBUSY;
>>> +     }
>>> +
>>> +     l2pt[l2pt_idx] = IPU3_ADDR2PTE(paddr);
>>> +
>>> +     clflush_cache_range(&l2pt[l2pt_idx], sizeof(*l2pt));
>>> +
>>> +     if (mmu_dom->mmu)
>>
>> Yikes, are there actually users in the kernel which allocate domains and
>> try to create mappings in them before attaching any devices? In general,
>> that poses an ugly problem for certain IOMMU drivers :(
> 
> I believe in our use case it probably wouldn't matter as we attach the
> device very early at driver initialization. We could probably just
> assert mmu_dom->mmu here, but not sure what it gives us over current
> code, which is of the same complexity and also behaves correctly for
> such case already.
> 
> On the other hand, does it really sound semantically wrong to do so?
> If you can switch a device between different domains, you might want
> to prepare mappings first and then attach the device.

It's exceedingly problematic when you can have multiple IOMMUs with
different capabilities in the system, so until you've attached a device
you don't know which IOMMU is relevant, thus which pagetable
formats/page sizes/etc. it supports and the domain can use, or even
whether the desired IOVA/PA would be valid or not. We're making gradual
progress in moving the API from per-bus ops towards the notion of
individual IOMMUs, but until we have some new way to allocate domains
directly by IOMMU instance (or associated client device), some IOMMU
drivers simply can't support map-before-initial-attach (and I'm not sure
how many would currently cope with unmap-after-detach without going
wrong somehow).

>>> +             call_if_ipu3_is_powered(mmu_dom->mmu, ipu3_mmu_tlb_invalidate);
>>> +
>>> +     spin_unlock_irqrestore(&mmu_dom->lock, flags);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static size_t ipu3_mmu_unmap(struct iommu_domain *domain, unsigned long iova,
>>> +                          size_t size)
>>> +{
>>> +     struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
>>> +     u32 l1pt_idx, l2pt_idx;
>>> +     unsigned long flags;
>>> +     u32 *l2pt;
>>> +
>>> +     /* We assume a page by page unmapping. */
>>> +     if (WARN_ON(size != IPU3_PAGE_SIZE))
>>> +             return 0;
>>
>> As above.
> 
> Ack.
> 
>>
>>> +
>>> +     address_to_pte_idx(iova, &l1pt_idx, &l2pt_idx);
>>> +
>>> +     l2pt = ipu3_mmu_get_l2pt(mmu_dom, l1pt_idx, false);
>>> +     if (!l2pt)
>>> +             return 0;
>>> +
>>> +     spin_lock_irqsave(&mmu_dom->lock, flags);
>>> +
>>> +     if (l2pt[l2pt_idx] == mmu_dom->dummy_page_pteval)
>>> +             size = 0;
>>> +     l2pt[l2pt_idx] = mmu_dom->dummy_page_pteval;
>>> +
>>> +     clflush_cache_range(&l2pt[l2pt_idx], sizeof(*l2pt));
>>> +
>>> +     if (mmu_dom->mmu)
>>> +             call_if_ipu3_is_powered(mmu_dom->mmu, ipu3_mmu_tlb_invalidate);
>>> +
>>> +     spin_unlock_irqrestore(&mmu_dom->lock, flags);
>>> +
>>> +     return size;
>>> +}
>>> +
>>> +static phys_addr_t ipu3_mmu_iova_to_phys(struct iommu_domain *domain,
>>> +                                      dma_addr_t iova)
>>> +{
>>> +     struct ipu3_mmu_domain *d = to_ipu3_mmu_domain(domain);
>>> +     u32 l1pt_idx, l2pt_idx;
>>> +     u32 pteval;
>>> +     u32 *l2pt;
>>> +
>>> +     address_to_pte_idx(iova, &l1pt_idx, &l2pt_idx);
>>> +
>>> +     l2pt = ipu3_mmu_get_l2pt(d, l1pt_idx, false);
>>> +     if (!l2pt)
>>> +             return 0;
>>> +
>>> +     pteval = l2pt[l2pt_idx];
>>> +     if (pteval == d->dummy_page_pteval)
>>> +             return 0;
>>> +
>>> +     return IPU3_PTE2ADDR(pteval);
>>> +}
>>> +
>>> +static struct iommu_group *ipu3_mmu_device_group(struct device *dev)
>>> +{
>>> +     struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
>>> +
>>> +     return mmu->group;
>>
>>         return iommu_group_ref_get(mmu->group);
>>
>> Otherwise, add 2 or more devices, remove 1 again, and watch the
>> still-live group disappear from under your feet.
> 
> Ah, that might explain why I needed cleanup order not symmetric to
> initialization order in probe of the main PCI driver.
> 
>>
>>> +}
>>> +
>>> +static int ipu3_mmu_add_device(struct device *dev)
>>> +{
>>> +     struct iommu_group *group;
>>> +
>>> +     group = iommu_group_get_for_dev(dev);
>>> +     if (IS_ERR(group))
>>> +             return PTR_ERR(group);
>>> +
>>> +     iommu_group_put(group);
>>> +     return 0;
>>> +}
>>> +
>>> +static void ipu3_mmu_remove_device(struct device *dev)
>>> +{
>>> +     struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
>>> +
>>> +     if (!domain)
>>> +             return;
>>> +
>>> +     ipu3_mmu_detach_dev(domain, dev);
>>
>> Ah, so you avoid the refcount bug by forgetting to remove the device
>> from the group at all, but then go and implement the unpleasant
>> consequences of tearing down a potentially-live domain manually :)
>>
>> You should call iommu_group_remove_device() here (i.e. undoing what
>> iommu_group_get_for_dev() did), and let that take care of the domain as
>> necessary.
> 
> Surprisingly enough it works. I can even compile all the code as
> modules and load/unload them freely without any crashes. Possibly
> because I unregister the DMA device in the main PCI driver, before
> calling ipu3_mmu_exit(), which triggers the group notifier and removes
> the device from the group. But maybe I can get the normal cleanup
> order with your suggestion, so let me try.

Actually, I think it works out OK because there's only ever the single
dma_dev involved anyway (Before I'd looked at patch #12 I was
automatically assuming the other sub-drivers would use their own devices
for DMA API calls). Still, it would be nicest to follow the expected
pattern, if only not to confuse the next guy writing a new driver and
looking around for reference.

>>> +}
>>> +
>>> +static struct iommu_ops ipu3_iommu_ops_template = {
>>> +     .domain_alloc   = ipu3_mmu_domain_alloc,
>>> +     .domain_free    = ipu3_mmu_domain_free,
>>> +     .attach_dev     = ipu3_mmu_attach_dev,
>>> +     .detach_dev     = ipu3_mmu_detach_dev,
>>> +     .map            = ipu3_mmu_map,
>>> +     .unmap          = ipu3_mmu_unmap,
>>> +     .map_sg         = default_iommu_map_sg,
>>> +     .iova_to_phys   = ipu3_mmu_iova_to_phys,
>>> +     .device_group   = ipu3_mmu_device_group,
>>> +     .add_device     = ipu3_mmu_add_device,
>>> +     .remove_device  = ipu3_mmu_remove_device,
>>> +     .pgsize_bitmap  = SZ_4K,
>>
>> Nit: should probably be IPU3_PAGE_SIZE for consistency.
> 
> Ack.
> 
>>
>>> +};
>>> +
>>> +/**
>>> + * ipu3_mmu_init() - initialize IPU3 MMU block
>>> + * @parent:  Parent IPU device.
>>> + * @base:    IOMEM base of hardware registers.
>>> + * @bus:     Bus on which DMA devices are registered.
>>> + *
>>> + * Return: Pointer to IPU3 MMU private data pointer or ERR_PTR() on error.
>>> + */
>>> +struct ipu3_mmu *ipu3_mmu_init(struct device *parent, void __iomem *base,
>>> +                            struct bus_type *bus)
>>> +{
>>> +     struct ipu3_mmu *mmu;
>>> +     u32 pteval;
>>> +     int ret;
>>> +
>>> +     mmu = kzalloc(sizeof(*mmu), GFP_KERNEL);
>>> +     if (!mmu)
>>> +             return ERR_PTR(-ENOMEM);
>>> +     mmu->base = base;
>>> +     mmu->dev = parent;
>>> +     mmu->bus = bus;
>>> +     mmu->ops = ipu3_iommu_ops_template;
>>> +
>>> +     /* Disallow external memory access when having no valid page tables. */
>>> +     ipu3_mmu_set_halt(mmu, true);
>>> +
>>> +     /*
>>> +      * Allocate the L1 page table.
>>> +      *
>>> +      * NOTE that the hardware does not allow changing the L1 page table
>>> +      * at runtime, so we use shadow L1 tables with CPU L2 table pointers
>>> +      * per-domain and update the L1 table on domain attach and detach.
>>> +      */
>>> +     mmu->l1pt = ipu3_mmu_alloc_page_table(0);
>>> +     if (!mmu->l1pt) {
>>> +             ret = -ENOMEM;
>>> +             goto fail_mmu;
>>> +     }
>>> +
>>> +     mmu->group = iommu_group_alloc();
>>> +     if (!mmu->group) {
>>> +             ret = -ENOMEM;
>>> +             goto fail_l1pt;
>>> +     }
>>> +
>>> +     pteval = IPU3_ADDR2PTE(virt_to_phys(mmu->l1pt));
>>> +     writel(pteval, mmu->base + REG_L1_PHYS);
>>> +     ipu3_mmu_tlb_invalidate(mmu);
>>> +
>>> +     bus_set_iommu(bus, &mmu->ops);
>>> +
>>> +     return mmu;
>>
>> Rather than playing tricks with bus->ops, it's probably better for the
>> bus code to stash imgu->mmu directly in the other subdevices' archdata
>> as it creates them; that seems the cleanest way.
> 
> Let me check. It would be indeed much better to just avoid all the
> tricks with custom buses. On the other hand, it kind of resembles the
> real hardware architecture, i.e. a local bus inside the PCI device, on
> which the DMA engine is located.

I don't think you can get away without the local bus altogether (and I
agree it's nice to model real the hardware topology), since then you'd
have to install your IOMMU ops for all PCI devices, which would get
messy fast.

Robin.
