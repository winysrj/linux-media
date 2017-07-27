Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:49506 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751551AbdG0Qcl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 12:32:41 -0400
Subject: Re: [PATCH v3 02/12] intel-ipu3: mmu: implement driver
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        rajmohan.mani@intel.com, hyungwoo.yang@intel.com,
        jerry.w.hu@intel.com, arnd@arndb.de, hch@lst.de,
        iommu@lists.linux-foundation.org, Tomasz Figa <tfiga@chromium.org>
References: <1500433958-2304-1-git-send-email-yong.zhi@intel.com>
 <efc5aab9-9f4e-fba3-034b-185d3d7e0fcd@arm.com>
 <20170720214925.shnfmpjrvouzuyyc@valkosipuli.retiisi.org.uk>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <22a8defd-a4fe-4a70-c3ad-2c174a878676@arm.com>
Date: Thu, 27 Jul 2017 17:32:37 +0100
MIME-Version: 1.0
In-Reply-To: <20170720214925.shnfmpjrvouzuyyc@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/07/17 22:49, Sakari Ailus wrote:
> Hi Robin,
> 
> On Wed, Jul 19, 2017 at 02:37:12PM +0100, Robin Murphy wrote:
> ...
>>> +static int ipu3_mmu_map(struct iommu_domain *domain, unsigned long iova,
>>> +			phys_addr_t paddr, size_t size, int prot)
>>> +{
>>> +	struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
>>> +	u32 l1pt_idx, l2pt_idx;
>>> +	unsigned long flags;
>>> +	u32 *l2pt;
>>> +
>>> +	/* We assume a page by page mapping. */
>>> +	if (WARN_ON(size != IPU3_PAGE_SIZE))
>>> +		return -EINVAL;
>>
>> The core API already enforces this, so drivers shouldn't need to be
>> paranoid.
>>
>>> +
>>> +	address_to_pte_idx(iova, &l1pt_idx, &l2pt_idx);
>>> +
>>> +	l2pt = ipu3_mmu_get_l2pt(mmu_dom, l1pt_idx, true);
>>> +	if (!l2pt)
>>> +		return -ENOMEM;
>>> +
>>> +	spin_lock_irqsave(&mmu_dom->lock, flags);
>>> +
>>> +	if (l2pt[l2pt_idx] != mmu_dom->dummy_page_pteval) {
>>> +		spin_unlock_irqrestore(&mmu_dom->lock, flags);
>>> +		return -EBUSY;
>>> +	}
>>> +
>>> +	l2pt[l2pt_idx] = IPU3_ADDR2PTE(paddr);
>>> +
>>> +	clflush_cache_range(&l2pt[l2pt_idx], sizeof(*l2pt));
>>> +
>>> +	if (mmu_dom->mmu)
>>
>> Yikes, are there actually users in the kernel which allocate domains and
>> try to create mappings in them before attaching any devices? In general,
>> that poses an ugly problem for certain IOMMU drivers :(
> 
> This case is a bit special. The MMU is part of a PCI device which is also
> behind the MMU itself.
> 
> Just the existence of mapped memory (or the mapping operation itself)
> shouldn't require powering on or keeping the device powered on. Hence this.

Oh, I understand not invalidating the TLBs if they're already powered
off, it's the "if (mmu_dom->mmu)" check itself that's worrying me, since
that is only NULL until the first device is attached to the domain. What
I'm asking is whether it's actually possible in practice to get here
before mmu_dom->mmu is set (I hope not).

>>> +		call_if_ipu3_is_powered(mmu_dom->mmu, ipu3_mmu_tlb_invalidate);
>>> +
>>> +	spin_unlock_irqrestore(&mmu_dom->lock, flags);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static size_t ipu3_mmu_unmap(struct iommu_domain *domain, unsigned long iova,
>>> +			     size_t size)
>>> +{
>>> +	struct ipu3_mmu_domain *mmu_dom = to_ipu3_mmu_domain(domain);
>>> +	u32 l1pt_idx, l2pt_idx;
>>> +	unsigned long flags;
>>> +	u32 *l2pt;
>>> +
>>> +	/* We assume a page by page unmapping. */
>>> +	if (WARN_ON(size != IPU3_PAGE_SIZE))
>>> +		return 0;
>>
>> As above.
>>
>>> +
>>> +	address_to_pte_idx(iova, &l1pt_idx, &l2pt_idx);
>>> +
>>> +	l2pt = ipu3_mmu_get_l2pt(mmu_dom, l1pt_idx, false);
>>> +	if (!l2pt)
>>> +		return 0;
>>> +
>>> +	spin_lock_irqsave(&mmu_dom->lock, flags);
>>> +
>>> +	if (l2pt[l2pt_idx] == mmu_dom->dummy_page_pteval)
>>> +		size = 0;
>>> +	l2pt[l2pt_idx] = mmu_dom->dummy_page_pteval;
>>> +
>>> +	clflush_cache_range(&l2pt[l2pt_idx], sizeof(*l2pt));
>>> +
>>> +	if (mmu_dom->mmu)
>>> +		call_if_ipu3_is_powered(mmu_dom->mmu, ipu3_mmu_tlb_invalidate);
>>> +
>>> +	spin_unlock_irqrestore(&mmu_dom->lock, flags);
>>> +
>>> +	return size;
>>> +}
>>> +
>>> +static phys_addr_t ipu3_mmu_iova_to_phys(struct iommu_domain *domain,
>>> +					 dma_addr_t iova)
>>> +{
>>> +	struct ipu3_mmu_domain *d = to_ipu3_mmu_domain(domain);
>>> +	u32 l1pt_idx, l2pt_idx;
>>> +	u32 pteval;
>>> +	u32 *l2pt;
>>> +
>>> +	address_to_pte_idx(iova, &l1pt_idx, &l2pt_idx);
>>> +
>>> +	l2pt = ipu3_mmu_get_l2pt(d, l1pt_idx, false);
>>> +	if (!l2pt)
>>> +		return 0;
>>> +
>>> +	pteval = l2pt[l2pt_idx];
>>> +	if (pteval == d->dummy_page_pteval)
>>> +		return 0;
>>> +
>>> +	return IPU3_PTE2ADDR(pteval);
>>> +}
>>> +
>>> +static struct iommu_group *ipu3_mmu_device_group(struct device *dev)
>>> +{
>>> +	struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
>>> +
>>> +	return mmu->group;
>>
>> 	return iommu_group_ref_get(mmu->group);
>>
>> Otherwise, add 2 or more devices, remove 1 again, and watch the
>> still-live group disappear from under your feet.
>>
>>> +}
>>> +
>>> +static int ipu3_mmu_add_device(struct device *dev)
>>> +{
>>> +	struct iommu_group *group;
>>> +
>>> +	group = iommu_group_get_for_dev(dev);
>>> +	if (IS_ERR(group))
>>> +		return PTR_ERR(group);
>>> +
>>> +	iommu_group_put(group);
>>> +	return 0;
>>> +}
>>> +
>>> +static void ipu3_mmu_remove_device(struct device *dev)
>>> +{
>>> +	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
>>> +
>>> +	if (!domain)
>>> +		return;
>>> +
>>> +	ipu3_mmu_detach_dev(domain, dev);
>>
>> Ah, so you avoid the refcount bug by forgetting to remove the device
>> from the group at all, but then go and implement the unpleasant
>> consequences of tearing down a potentially-live domain manually :)
>>
>> You should call iommu_group_remove_device() here (i.e. undoing what
>> iommu_group_get_for_dev() did), and let that take care of the domain as
>> necessary.
>>
>>> +}
>>> +
>>> +static struct iommu_ops ipu3_iommu_ops_template = {
>>> +	.domain_alloc   = ipu3_mmu_domain_alloc,
>>> +	.domain_free    = ipu3_mmu_domain_free,
>>> +	.attach_dev	= ipu3_mmu_attach_dev,
>>> +	.detach_dev	= ipu3_mmu_detach_dev,
>>> +	.map		= ipu3_mmu_map,
>>> +	.unmap		= ipu3_mmu_unmap,
>>> +	.map_sg		= default_iommu_map_sg,
>>> +	.iova_to_phys	= ipu3_mmu_iova_to_phys,
>>> +	.device_group	= ipu3_mmu_device_group,
>>> +	.add_device	= ipu3_mmu_add_device,
>>> +	.remove_device	= ipu3_mmu_remove_device,
>>> +	.pgsize_bitmap	= SZ_4K,
>>
>> Nit: should probably be IPU3_PAGE_SIZE for consistency.
>>
>>> +};
>>> +
>>> +/**
>>> + * ipu3_mmu_init() - initialize IPU3 MMU block
>>> + * @parent:	Parent IPU device.
>>> + * @base:	IOMEM base of hardware registers.
>>> + * @bus:	Bus on which DMA devices are registered.
>>> + *
>>> + * Return: Pointer to IPU3 MMU private data pointer or ERR_PTR() on error.
>>> + */
>>> +struct ipu3_mmu *ipu3_mmu_init(struct device *parent, void __iomem *base,
>>> +			       struct bus_type *bus)
>>> +{
>>> +	struct ipu3_mmu *mmu;
>>> +	u32 pteval;
>>> +	int ret;
>>> +
>>> +	mmu = kzalloc(sizeof(*mmu), GFP_KERNEL);
>>> +	if (!mmu)
>>> +		return ERR_PTR(-ENOMEM);
>>> +	mmu->base = base;
>>> +	mmu->dev = parent;
>>> +	mmu->bus = bus;
>>> +	mmu->ops = ipu3_iommu_ops_template;
>>> +
>>> +	/* Disallow external memory access when having no valid page tables. */
>>> +	ipu3_mmu_set_halt(mmu, true);
>>> +
>>> +	/*
>>> +	 * Allocate the L1 page table.
>>> +	 *
>>> +	 * NOTE that the hardware does not allow changing the L1 page table
>>> +	 * at runtime, so we use shadow L1 tables with CPU L2 table pointers
>>> +	 * per-domain and update the L1 table on domain attach and detach.
>>> +	 */
>>> +	mmu->l1pt = ipu3_mmu_alloc_page_table(0);
>>> +	if (!mmu->l1pt) {
>>> +		ret = -ENOMEM;
>>> +		goto fail_mmu;
>>> +	}
>>> +
>>> +	mmu->group = iommu_group_alloc();
>>> +	if (!mmu->group) {
>>> +		ret = -ENOMEM;
>>> +		goto fail_l1pt;
>>> +	}
>>> +
>>> +	pteval = IPU3_ADDR2PTE(virt_to_phys(mmu->l1pt));
>>> +	writel(pteval, mmu->base + REG_L1_PHYS);
>>> +	ipu3_mmu_tlb_invalidate(mmu);
>>> +
>>> +	bus_set_iommu(bus, &mmu->ops);
>>> +> 
>>> +	return mmu;
>>
>> Rather than playing tricks with bus->ops, it's probably better for the
>> bus code to stash imgu->mmu directly in the other subdevices' archdata
>> as it creates them; that seems the cleanest way.
> 
> Right now there aren't any: there's a PCI device + the MMU struct device
> created by the PCI device driver, while the MMU itself is part of that PCI
> device. I guess you could alternatively create another on the bus and
> designate that for the "real" driver to control the PCI device.

It looks to me like having imgu_pci_probe() or imgu_dma_dev_init() do:

	imgu.dma_dev->archdata.iommu = imgu->mmu;

would be enough, since as far as I can tell dma_dev is the only one the
DMA ops should ever see.

Robin.
