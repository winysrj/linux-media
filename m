Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:40256 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751535AbdFINFz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 09:05:55 -0400
Subject: Re: [PATCH 03/12] intel-ipu3: Add DMA API implementation
To: Tomasz Figa <tfiga@chromium.org>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-4-git-send-email-yong.zhi@intel.com>
 <CAAFQd5CLXUsDv6H1C22tc4qjG9e7tm5jtxwYBjV5gx9qrDw50A@mail.gmail.com>
 <73992991-65a9-915b-a450-b23aeb3baaed@arm.com>
 <CAAFQd5AWGN_qSXGG32D-eWKZRoRme+XCD9v1r8qJ5bthtS9z9w@mail.gmail.com>
 <949a467a-e711-d746-859d-fc006bf59773@arm.com>
 <CAAFQd5A=PLHXCA60Rv1T1A=kKQRg4AC3hd-NC798dkqQBJZj3Q@mail.gmail.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <c5bc8a22-22cd-6453-2597-f25ed736d5b6@arm.com>
Date: Fri, 9 Jun 2017 14:05:51 +0100
MIME-Version: 1.0
In-Reply-To: <CAAFQd5A=PLHXCA60Rv1T1A=kKQRg4AC3hd-NC798dkqQBJZj3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/17 07:20, Tomasz Figa wrote:
> On Fri, Jun 9, 2017 at 3:07 AM, Robin Murphy <robin.murphy@arm.com> wrote:
>> On 08/06/17 15:35, Tomasz Figa wrote:
>>> On Thu, Jun 8, 2017 at 10:22 PM, Robin Murphy <robin.murphy@arm.com> wrote:
>>>> On 07/06/17 10:47, Tomasz Figa wrote:
>>>>> Hi Yong,
>>>>>
>>>>> +Robin, Joerg, IOMMU ML
>>>>>
>>>>> Please see my comments inline.
>>>>>
>>>>> On Tue, Jun 6, 2017 at 5:39 AM, Yong Zhi <yong.zhi@intel.com> wrote:
>>> [snip]
>>>>>> +
>>>>>> +/* End of things adapted from arch/arm/mm/dma-mapping.c */
>>>>>> +static void ipu3_dmamap_sync_single_for_cpu(struct device *dev,
>>>>>> +                                           dma_addr_t dma_handle, size_t size,
>>>>>> +                                           enum dma_data_direction dir)
>>>>>> +{
>>>>>> +       struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
>>>>>> +       dma_addr_t daddr = iommu_iova_to_phys(mmu->domain, dma_handle);
>>>>>> +
>>>>>> +       clflush_cache_range(phys_to_virt(daddr), size);
>>>>>
>>>>> You might need to consider another IOMMU on the way here. Generally,
>>>>> given that daddr is your MMU DMA address (not necessarily CPU physical
>>>>> address), you should be able to call
>>>>>
>>>>> dma_sync_single_for_cpu(<your pci device>, daddr, size, dir)
>>>>
>>>> I'd hope that this IPU complex is some kind of embedded endpoint thing
>>>> that bypasses the VT-d IOMMU or is always using its own local RAM,
>>>> because it would be pretty much unworkable otherwise.
>>>
>>> It uses system RAM and, as far as my understanding goes, by default it
>>> operates without the VT-d IOMMU and that's how it's used right now.
>>
>> OK, if it *is* behind a DMAR unit then booting with "iommu=force" (or
>> whatever the exact incantation for intel-iommu is) should be fun...
>>
>>> I'm suggesting VT-d IOMMU as a way to further strengthen the security
>>> and error resilience in future (due to the IPU complex being
>>> non-coherent and also running a closed source firmware).
>>
>> TBH, doing DMA remapping through *two* IOMMUS will add horrible hardware
>> overhead,
> 
> Not necessarily, if done right and with right hardware (I lack the
> details about Intel hardware unfortunately). One can for example
> notice the fact that the IOVA ranges from the parent IOMMU are going
> to be contiguous for the child IOMMU, so one could use huge pages in
> the child IOMMU and essentially make a selective 1:1 mapping.

Note that many IOMMUs don't actually implement TLBs for larger page
sizes, even if they support them. And that still doesn't really help the
main issue of the way in which nested table walks blow up exponentially:
For a n-level pagetable at the first level and an m-level table at the
second level, a single access by the device can become m * (n + 1)
memory accesses (and that's generously ignoring additional things like
source-ID-to-context lookups).

>> increase the scope for kernel-side bugs, and not much more. If
>> we don't trust this IOMMU to behave, why are we trying to drive it in
>> the first place? If we do, then a second IOMMU behind it won't protect
>> anything that the first one doesn't already.
> 
> That's a valid point, right. But on the other hand, I lack the
> hardware details on whether we can just disable the internal IOMMU and
> use DMAR alone instead.
> 
>>
>>>> The whole
>>>> infrastructure isn't really capable of dealing with nested IOMMUs, and
>>>> nested DMA ops would be an equally horrible idea.
>>>
>>> Could you elaborate a bit more on this? I think we should be able to
>>> deal with this in a way I suggested before:
>>>
>>> a) the PCI device would use the system DMA ops,
>>> b) the PCI device would implement a secondary bus for which it would
>>> provide its own DMA and IOMMU ops.
>>> c) a secondary device would be registered on the secondary bus,
>>> d) all memory for the IPU would be managed on behalf of the secondary device.
>>>
>>> In fact, the driver already is designed in a way that all the points
>>> above are true. If I'm not missing something, the only significant
>>> missing point is calling into system DMA ops from IPU DMA ops.
>>
>> I don't believe x86 has any non-coherent DMA ops, therefore the IPU DMA
>> ops would still probably have to do all their own cache maintenance.
> 
> I'd argue that it means that we need to add non-coherent DMA ops on
> x86, as we have on other archs, which can have both coherent and
> non-coherent devices in the same system.

I'd argue that that's what this patch *is* doing - x86 already has DMA
ops all over the place for special cases, and this is really just
another special case. I think trying to introduce some notion of
non-coherent devices to the arch code, plus some generic way to identify
them, plus some way to make sure everywhere else that overrides DMA ops
still does the right thing, would be a lot more work for very little gain.

>> Allocation/mapping, though, would have to be done with the parent DMA
>> ops first (in case DMA address != physical address), *then* mapped at
>> the IPU MMU, which is the real killer - if the PCI DMA ops are from
>> intel-iommu, then there's little need for the IPU MMU mapping to be
>> anything other than 1:1, so you may as well not bother.
> 
> Okay, I think I can agree with you on this. It indeed makes little
> sense to use both MMUs at the same time, if there is a way to disable
> one of them.
> 
> Let's just keep this unaware of DMAR at this point of time, as a
> starter, and get back to it later whenever someone wants to use DMAR
> instead. I guess the way to proceed then would be either disabling the
> internal MMU, if possible, or making it use a 1:1 (huge page, if
> possible) mapping, if not.

Generally, when you have a device-specific IOMMU like this, that's the
one you'd want to keep using because it'll be optimised for the device's
workload (e.g. the fact that it's non-coherent here is very likely the
appropriate performance choice).

>> If the PCI DMA
>> ops are from SWIOTLB, then the constraints of having to go through that
>> first eliminate all the scatter-gather benefit of the IPU MMU.
> 
> Does the SWIOTLB give you a physically contiguous memory? If not, you
> still need the IPU MMU to actually be able to access the memory.

The SWIOTLB itself is really only for streaming mappings - coherent
allocations come from CMA (although it may fall back to allocating
directly out of its bounce buffers in certain circumstances). Either
way, yes, everything's physically contiguous, because it's designed for
when there is no hardware IOMMU available. I can well imagine video/ISP
workloads being able to exhaust CMA at the drop of a hat too, which
makes the idea all the worse.

>>
>> The IOMMU API ops would have to be handled similarly, by checking for
>> ops on the parent bus, calling those first if present, then running the
>> intermediate results through the IPU MMU's own functions. Sure, it's not
>> impossible, but it's really really grim. Not to mention that all the IPU
>> MMU's page tables/control structures/etc. would also have to be
>> DMA-allocated/mapped because it may or may not be operating in physical
>> address space.
> 
> DMA-allocation isn't really good for this use case, but is a DMA
> mapping operation really such a bad thing?

Not really, although it's still a bit of extra complication. We do it in
io-pgtable for the sake of coherency, but we enforce that DMA == phys so
that we don't have to double the memory overhead to keep track of the
kernel VAs as well. I think the Tegra IOMMU driver is one that does go
the whole way. Coming back to the earlier point, though, if you'd end up
back in your driver's own DMA ops anyway then there seems very little
justification for going the long way round.

>> The reasonable option - assuming the topology really is this way - would
>> seem to be special-casing the IPU in intel-iommu in a similar manner to
>> integrated graphics, to make sure it gets a passthrough domain for DMA
>> ops, but still allowing the whole PCI device to be passed through to a
>> guest VM via VFIO if desired (which is really the only case where nested
>> translation does start to make sense).
> 
> Yeah, given that we need some start, it sounds sane to me. We can then
> revisit different options later. Thanks a lot for your input.

Thankfully, it seems like this will remain a theoretical problem. Phew!

Robin.

> 
> Best regards,
> Tomasz
> 
