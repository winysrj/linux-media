Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:33953 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752212AbdG1Otb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 10:49:31 -0400
Received: by mail-yw0-f181.google.com with SMTP id i6so91222874ywb.1
        for <linux-media@vger.kernel.org>; Fri, 28 Jul 2017 07:49:31 -0700 (PDT)
Received: from mail-yw0-f178.google.com (mail-yw0-f178.google.com. [209.85.161.178])
        by smtp.gmail.com with ESMTPSA id j11sm7951126ywj.96.2017.07.28.07.49.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jul 2017 07:49:29 -0700 (PDT)
Received: by mail-yw0-f178.google.com with SMTP id l82so66759173ywc.2
        for <linux-media@vger.kernel.org>; Fri, 28 Jul 2017 07:49:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f3dab4c1-069a-812d-ba0a-0090c13bb9fc@arm.com>
References: <1500433958-2304-1-git-send-email-yong.zhi@intel.com>
 <efc5aab9-9f4e-fba3-034b-185d3d7e0fcd@arm.com> <CAAFQd5BN9+zv5ZizX6y+EAi6MvBrVycptjXREaGm3iKqH6F_Og@mail.gmail.com>
 <f3dab4c1-069a-812d-ba0a-0090c13bb9fc@arm.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 28 Jul 2017 23:49:08 +0900
Message-ID: <CAAFQd5DXNoq4+jWmF+SAu3nD+me4eQaNiT8eDSPg2cZXLt50Ag@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] intel-ipu3: mmu: implement driver
To: Robin Murphy <robin.murphy@arm.com>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 28, 2017 at 11:10 PM, Robin Murphy <robin.murphy@arm.com> wrote:
> On 26/07/17 11:38, Tomasz Figa wrote:
>> Hi Robin,
>>
>> On Wed, Jul 19, 2017 at 10:37 PM, Robin Murphy <robin.murphy@arm.com> wrote:
>>> On 19/07/17 04:12, Yong Zhi wrote:
>>>> From: Tomasz Figa <tfiga@chromium.org>
>>>>
>>>> This driver translates Intel IPU3 internal virtual
>>>> address to physical address.
>>>>
>>>> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
>>>> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
>>>> ---
>>>>  drivers/media/pci/intel/ipu3/Kconfig    |   9 +
>>>>  drivers/media/pci/intel/ipu3/Makefile   |  15 +
>>>>  drivers/media/pci/intel/ipu3/ipu3-mmu.c | 639 ++++++++++++++++++++++++++++++++
>>>>  drivers/media/pci/intel/ipu3/ipu3-mmu.h |  27 ++
>>>>  4 files changed, 690 insertions(+)
>>>>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.c
>>>>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.h
>>>>
>>>> diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
>>>> index 2a895d6..7bcdfa5 100644
>>>> --- a/drivers/media/pci/intel/ipu3/Kconfig
>>>> +++ b/drivers/media/pci/intel/ipu3/Kconfig
>>>> @@ -15,3 +15,12 @@ config VIDEO_IPU3_CIO2
>>>>       Say Y or M here if you have a Skylake/Kaby Lake SoC with MIPI CSI-2
>>>>       connected camera.
>>>>       The module will be called ipu3-cio2.
>>>> +
>>>> +config INTEL_IPU3_MMU
>>>> +     tristate
>>>
>>> Shouldn't this be bool now?
>>
>> Well, depends on what we expect it to be. I still didn't see any good
>> reason not to make it a loadable module.
>
> Sure, conceptually there's no real reason it shouldn't be *allowed* to
> be built as a module, but without all the necessary symbols exported, a
> tristate here is only going to make allmodconfig builds fail.

Have we already completely dismissed the idea of exporting the IOMMU
symbols needed to make this driver a loadable module? I think the most
problematic ones were around the DMA mapping stuff, but IOMMU could be
still a module. Anyway, I think we might be removing the DMA mapping
implementation from the driver as the opinion of few other reviewers
seemed to be that this is reserved only to arch code.

>>>> +static struct iommu_domain *ipu3_mmu_domain_alloc(unsigned int type)
>>>> +{
>>>> +     struct ipu3_mmu_domain *mmu_dom;
>>>> +     u32 pteval;
>>>> +
>>>> +     if (WARN(type != IOMMU_DOMAIN_DMA,
>>>> +              "IPU3 MMU only supports DMA domains\n"))
>>>> +             return NULL;
>>>> +
>>>> +     mmu_dom = kzalloc(sizeof(*mmu_dom), GFP_KERNEL);
>>>> +     if (!mmu_dom)
>>>> +             return NULL;
>>>> +
>>>> +     if (iommu_get_dma_cookie(&mmu_dom->domain))
>>>> +             goto fail_domain;
>>>> +
>>>> +     mmu_dom->domain.geometry.aperture_start = 0;
>>>> +     mmu_dom->domain.geometry.aperture_end =
>>>> +             DMA_BIT_MASK(IPU3_MMU_ADDRESS_BITS);
>>>> +     mmu_dom->domain.geometry.force_aperture = true;
>>>> +
>>>> +     /*
>>>> +      * The MMU does not have a "valid" bit, so we have to use a dummy
>>>> +      * page for invalid entries.
>>>> +      */
>>>> +     mmu_dom->dummy_page = kzalloc(IPU3_PAGE_SIZE, GFP_KERNEL);
>>>> +     if (!mmu_dom->dummy_page)
>>>> +             goto fail_cookie;
>>>> +     pteval = IPU3_ADDR2PTE(virt_to_phys(mmu_dom->dummy_page));
>>>> +     mmu_dom->dummy_page_pteval = pteval;
>>>
>>> Conceptually, would it make sense for the dummy page to be per-mmu,
>>> rather than per-domain? I realise it doesn't make much practical
>>> difference if you only expect to ever use a single DMA ops domain, but
>>> it would neatly mirror existing drivers which do a similar thing (e.g.
>>> the Mediatek IOMMUs).
>>
>> It makes it a bit complicated to achieve correctness against the IOMMU
>> API, because it would leave the page tables invalid if the domain is
>> detached from the MMU.
>
> In general, I'm not convinced it's sane for anyone to be calling
> iommu_map/unmap on a domain that isn't live. However, since this driver
> only supports DMA ops domains anyway, I don't see how that could happen
> at all - a device is always attached to its default domain well before
> its driver has a chance to probe and start making DMA API calls. For the
> default domain to be detached, all the devices would have to be removed,
> at which point there's nobody left to be making DMA API calls (plus it
> would have been torn down along with the group anyway).
>
> That said, another way to safely have no MMU dependency at all would be
> to just allocate it globally at driver init. Even if you ever did have
> multiple IPUs in a system, I don't see that any harm could come of them
> sharing the same scratch page either.
>

Yeah, allocating them globally at driver init could simplify the
things a bit indeed. Let me take a look.

>>>> +     /*
>>>> +      * Allocate a dummy L2 page table with all entries pointing to
>>>> +      * the dummy page.
>>>> +      */
>>>> +     mmu_dom->dummy_l2pt = ipu3_mmu_alloc_page_table(pteval);
>>>> +     if (!mmu_dom->dummy_l2pt)
>>>> +             goto fail_page;
>>>> +     pteval = IPU3_ADDR2PTE(virt_to_phys(mmu_dom->dummy_l2pt));
>>>> +     mmu_dom->dummy_l2pt_pteval = pteval;
>
> Thinking about it further, if you did have a single common scratch page,
> you should only ever need one common dummy_l2pt to point at it as well.

Right.

>>>> +static void ipu3_mmu_detach_dev(struct iommu_domain *domain,
>>>> +                             struct device *dev)
>>>> +{
>>>> +     struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
>>>> +     struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
>>>> +     unsigned long flags;
>>>> +
>>>> +     if (mmu->domain != mmu_dom)
>>>> +             return;
>>>> +
>>>> +     /* Disallow external memory access when having no valid page tables. */
>>>> +     call_if_ipu3_is_powered(mmu, ipu3_mmu_disable);
>>>> +
>>>> +     spin_lock_irqsave(&mmu_dom->lock, flags);
>>>> +
>>>> +     mmu->domain = NULL;
>>>> +     mmu_dom->mmu = NULL;
>>>> +
>>>> +     dev_dbg(dev, "%s: Detached from domain %p\n", __func__, mmu_dom);
>>>> +
>>>> +     spin_unlock_irqrestore(&mmu_dom->lock, flags);
>>>> +
>>>> +     memset(mmu->l1pt, 0, IPU3_PT_PTES * sizeof(*mmu->l1pt));
>>>
>>> Would it not make more sense to install all the dummy entries here...
>>
>> Well, it doesn't matter, because we disabled the MMU (locked the
>> external memory gate) and flushed the TLB. It will be only able to
>> read the page directory once again after we fill it with proper values
>> and re-enable.
>
> In which case, is there any need to even bother zeroing the l1pt at all,
> given that that's still going to be a "valid" translation to wherever,
> depending on what the bottom end of memory contains?
>

That's a good point. :)

On the other hand, yes, I'm overly paranoid, I don't like leaving
invalid addresses in pointers and that's why this memset(). Single
dummy page and l2pt should let us get rid of this.

>>>> +
>>>> +     address_to_pte_idx(iova, &l1pt_idx, &l2pt_idx);
>>>> +
>>>> +     l2pt = ipu3_mmu_get_l2pt(mmu_dom, l1pt_idx, true);
>>>> +     if (!l2pt)
>>>> +             return -ENOMEM;
>>>> +
>>>> +     spin_lock_irqsave(&mmu_dom->lock, flags);
>>>> +
>>>> +     if (l2pt[l2pt_idx] != mmu_dom->dummy_page_pteval) {
>>>> +             spin_unlock_irqrestore(&mmu_dom->lock, flags);
>>>> +             return -EBUSY;
>>>> +     }
>>>> +
>>>> +     l2pt[l2pt_idx] = IPU3_ADDR2PTE(paddr);
>>>> +
>>>> +     clflush_cache_range(&l2pt[l2pt_idx], sizeof(*l2pt));
>>>> +
>>>> +     if (mmu_dom->mmu)
>>>
>>> Yikes, are there actually users in the kernel which allocate domains and
>>> try to create mappings in them before attaching any devices? In general,
>>> that poses an ugly problem for certain IOMMU drivers :(
>>
>> I believe in our use case it probably wouldn't matter as we attach the
>> device very early at driver initialization. We could probably just
>> assert mmu_dom->mmu here, but not sure what it gives us over current
>> code, which is of the same complexity and also behaves correctly for
>> such case already.
>>
>> On the other hand, does it really sound semantically wrong to do so?
>> If you can switch a device between different domains, you might want
>> to prepare mappings first and then attach the device.
>
> It's exceedingly problematic when you can have multiple IOMMUs with
> different capabilities in the system, so until you've attached a device
> you don't know which IOMMU is relevant, thus which pagetable
> formats/page sizes/etc. it supports and the domain can use, or even
> whether the desired IOVA/PA would be valid or not. We're making gradual
> progress in moving the API from per-bus ops towards the notion of
> individual IOMMUs, but until we have some new way to allocate domains
> directly by IOMMU instance (or associated client device), some IOMMU
> drivers simply can't support map-before-initial-attach (and I'm not sure
> how many would currently cope with unmap-after-detach without going
> wrong somehow).

Fair enough. I was incorrectly assuming that since domains are
allocated by particular IOMMU drivers, they already know the
capabilities.

>>>> +};
>>>> +
>>>> +/**
>>>> + * ipu3_mmu_init() - initialize IPU3 MMU block
>>>> + * @parent:  Parent IPU device.
>>>> + * @base:    IOMEM base of hardware registers.
>>>> + * @bus:     Bus on which DMA devices are registered.
>>>> + *
>>>> + * Return: Pointer to IPU3 MMU private data pointer or ERR_PTR() on error.
>>>> + */
>>>> +struct ipu3_mmu *ipu3_mmu_init(struct device *parent, void __iomem *base,
>>>> +                            struct bus_type *bus)
>>>> +{
>>>> +     struct ipu3_mmu *mmu;
>>>> +     u32 pteval;
>>>> +     int ret;
>>>> +
>>>> +     mmu = kzalloc(sizeof(*mmu), GFP_KERNEL);
>>>> +     if (!mmu)
>>>> +             return ERR_PTR(-ENOMEM);
>>>> +     mmu->base = base;
>>>> +     mmu->dev = parent;
>>>> +     mmu->bus = bus;
>>>> +     mmu->ops = ipu3_iommu_ops_template;
>>>> +
>>>> +     /* Disallow external memory access when having no valid page tables. */
>>>> +     ipu3_mmu_set_halt(mmu, true);
>>>> +
>>>> +     /*
>>>> +      * Allocate the L1 page table.
>>>> +      *
>>>> +      * NOTE that the hardware does not allow changing the L1 page table
>>>> +      * at runtime, so we use shadow L1 tables with CPU L2 table pointers
>>>> +      * per-domain and update the L1 table on domain attach and detach.
>>>> +      */
>>>> +     mmu->l1pt = ipu3_mmu_alloc_page_table(0);
>>>> +     if (!mmu->l1pt) {
>>>> +             ret = -ENOMEM;
>>>> +             goto fail_mmu;
>>>> +     }
>>>> +
>>>> +     mmu->group = iommu_group_alloc();
>>>> +     if (!mmu->group) {
>>>> +             ret = -ENOMEM;
>>>> +             goto fail_l1pt;
>>>> +     }
>>>> +
>>>> +     pteval = IPU3_ADDR2PTE(virt_to_phys(mmu->l1pt));
>>>> +     writel(pteval, mmu->base + REG_L1_PHYS);
>>>> +     ipu3_mmu_tlb_invalidate(mmu);
>>>> +
>>>> +     bus_set_iommu(bus, &mmu->ops);
>>>> +
>>>> +     return mmu;
>>>
>>> Rather than playing tricks with bus->ops, it's probably better for the
>>> bus code to stash imgu->mmu directly in the other subdevices' archdata
>>> as it creates them; that seems the cleanest way.
>>
>> Let me check. It would be indeed much better to just avoid all the
>> tricks with custom buses. On the other hand, it kind of resembles the
>> real hardware architecture, i.e. a local bus inside the PCI device, on
>> which the DMA engine is located.
>
> I don't think you can get away without the local bus altogether (and I
> agree it's nice to model real the hardware topology), since then you'd
> have to install your IOMMU ops for all PCI devices, which would get
> messy fast.

As I mentioned above, we're probably going to get rid of custom DMA
ops and just use IOMMU API and clflush_cache_range() directly, as it
doesn't look like the former is going to be accepted upstream.

Best regards,
Tomasz
