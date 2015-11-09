Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu-smtp-delivery-143.mimecast.com ([146.101.78.143]:37090 "EHLO
	eu-smtp-delivery-143.mimecast.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbbKINLQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2015 08:11:16 -0500
Subject: Re: [PATCH v6 1/3] iommu: Implement common IOMMU ops for DMA mapping
To: Tomasz Figa <tfiga@chromium.org>
References: <cover.1443718557.git.robin.murphy@arm.com>
 <ab8e1caa40d6da1afa4a49f30242ef4e6e1f17df.1443718557.git.robin.murphy@arm.com>
 <1445867094.30736.14.camel@mhfsdcap03> <562E5AE4.9070001@arm.com>
 <CAGS+omAWCQsqk56iv0PW2ZhTJ1342GufUsJCP=VYSgCxZNLJpA@mail.gmail.com>
 <56337E4D.1010304@arm.com>
 <CAGS+omAmxbb4uVzaQh1xPmkFtcF6KP-HSV-40=sm1BRTdh+=OQ@mail.gmail.com>
 <CAAFQd5C_dkWBZrQXtyO59ARw7q-0fg-Wk98yApC5VHdQ8-AmNw@mail.gmail.com>
 <5638F1C4.3000900@arm.com>
 <CAAFQd5A4TcvkDMFezqEpkfWL+7yO2v=Hm=twk=p-NpADPpvqEQ@mail.gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>,
	Lin PoChun <pochun.lin@mediatek.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	Will Deacon <will.deacon@arm.com>, linux-media@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>,
	"open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
	"Bobby Batacharia (via Google Docs)" <Bobby.Batacharia@arm.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Yong Wu <yong.wu@mediatek.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Joerg Roedel <joro@8bytes.org>, thunder.leizhen@huawei.com,
	Catalin Marinas <catalin.marinas@arm.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-mediatek@lists.infradead.org
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <56409B6D.5090903@arm.com>
Date: Mon, 9 Nov 2015 13:11:09 +0000
MIME-Version: 1.0
In-Reply-To: <CAAFQd5A4TcvkDMFezqEpkfWL+7yO2v=Hm=twk=p-NpADPpvqEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/11/15 05:12, Tomasz Figa wrote:
> On Wed, Nov 4, 2015 at 2:41 AM, Robin Murphy <robin.murphy@arm.com> wrote:
>> Hi Tomasz,
>>
>> On 02/11/15 13:43, Tomasz Figa wrote:
>>>
>>> I'd like to know what is the boundary mask and what hardware imposes
>>> requirements like this. The cost here is not only over-allocating a
>>> little, but making many, many buffers contiguously mappable on the
>>> CPU, unmappable contiguously in IOMMU, which just defeats the purpose
>>> of having an IOMMU, which I believe should be there for simple IP
>>> blocks taking one DMA address to be able to view the buffer the same
>>> way as the CPU.
>>
>>
>> The expectation with dma_map_sg() is that you're either going to be
>> iterating over the buffer segments, handing off each address to the device
>> to process one by one;
>
> My understanding of a scatterlist was that it represents a buffer as a
> whole, by joining together its physically discontinuous segments.

It can, but there are also cases where a single scatterlist is used to 
batch up multiple I/O requests - see the stuff in block/blk-merge.c as 
described in section 2.2 of Documentation/biodoc.txt, and AFAICS anyone 
could quite happily use the dmaengine API, and possibly others, in the 
same way. Ultimately a scatterlist is no more specific than "a list of 
blocks of physical memory that each want giving a DMA address".

> I don't see how single segments (layout of which is completely up to
> the allocator; often just single pages) would be usable for hardware
> that needs to do some work more serious than just writing a byte
> stream continuously to subsequent buffers. In case of such simple
> devices you don't even need an IOMMU (for means other than protection
> and/or getting over address space limitations).
>
> However, IMHO the most important use case of an IOMMU is to make
> buffers, which are contiguous in CPU virtual address space (VA),
> contiguous in device's address space (IOVA). Your implementation of
> dma_map_sg() effectively breaks this ability, so I'm not really
> following why it's located under drivers/iommu and supposed to be used
> with IOMMU-enabled platforms...
>
>> or you have a scatter-gather-capable device, in which
>> case you hand off the whole list at once.
>
> No need for mapping ability of the IOMMU here as well (except for
> working around address space issues, as I mentioned above).

Ok, now I'm starting to wonder if you're wilfully choosing to miss the 
point. Look at 64-bit systems of any architecture, and those address 
space issues are pretty much the primary consideration for including an 
IOMMU in the first place (behind virtualisation, which we can forget 
about here). Take the Juno board on my desk - most of the peripherals 
cannot address 75% of the RAM, and CPU bounce buffers are both not 
overly efficient and a limited resource (try using dmatest with 
sufficiently large buffers to stress/measure memory bandwidth and watch 
it take down the kernel, and that's without any other SWIOTLB 
contention). The only one that really cares at all about contiguous 
buffers is the HDLCD, but that's perfectly happy when it calls 
dma_alloc_coherent() via drm_fb_cma_helper and pulls a contiguous 8MB 
framebuffer out of thin air, without even knowing that CMA itself is 
disabled and it couldn't natively address 75% of the memory that might 
be backing that buffer.

That last point also illustrates that the thing for providing 
DMA-contiguous buffers is indeed very good at providing DMA-contiguous 
buffers when backed by an IOMMU.

>> It's in the latter case where you
>> have to make sure the list doesn't exceed the hardware limitations of that
>> device. I believe the original concern was disk controllers (the
>> introduction of dma_parms seems to originate from the linux-scsi list), but
>> most scatter-gather engines are going to have some limit on how much they
>> can handle per entry (IMO the dmaengine drivers are the easiest example to
>> look at).
>>
>> Segment boundaries are a little more arcane, but my assumption is that they
>> relate to the kind of devices whose addressing is not flat but relative to
>> some separate segment register (The "64-bit" mode of USB EHCI is one
>> concrete example I can think of) - since you cannot realistically change the
>> segment register while the device is in the middle of accessing a single
>> buffer entry, that entry must not fall across a segment boundary or at some
>> point the device's accesses are going to overflow the offset address bits
>> and wrap around to bogus addresses at the bottom of the segment.
>
> The two requirements above sound like something really specific to
> scatter-gather-capable hardware, which as I pointed above, barely need
> an IOMMU (at least its mapping capabilities). We are talking here
> about very IOMMU-specific code, though...
>
> Now, while I see that on some systems there might be IOMMU used for
> improving protection and working around addressing issues with
> SG-capable hardware, the code shouldn't be breaking the majority of
> systems with IOMMU used as the only possible way to make physically
> discontinuous appear (IO-virtually) continuous to devices incapable of
> scatter-gather.

Unless this majority of systems are all 64-bit ARMv8 ones running code 
that works perfectly _with the existing SWIOTLB DMA API implementation_ 
but not with this implementation, then I disagree that anything is being 
broken that wasn't already broken with respect to portability. 
Otherwise, please give me the details of any regressions with these 
patches relative to SWIOTLB DMA on arm64 so I can look into them.

>> Now yes, it will be possible under _most_ circumstances to use an IOMMU to
>> lay out a list of segments with page-aligned lengths within a single IOVA
>> allocation whilst still meeting all the necessary constraints. It just needs
>> some unavoidably complicated calculations - quite likely significantly more
>> complex than my v5 version of map_sg() that tried to do that and merge
>> segments but failed to take the initial alignment into account properly -
>> since there are much simpler ways to enforce just the _necessary_ behaviour
>> for the DMA API, I put the complicated stuff to one side for now to prevent
>> it holding up getting the basic functional support in place.
>
> Somehow just whatever currently done in arch/arm/mm/dma-mapping.c was
> sufficient and not overly complicated.
>
> See http://lxr.free-electrons.com/source/arch/arm/mm/dma-mapping.c#L1547 .
>
> I can see that the code there at least tries to comply with maximum
> segment size constraint. Segment boundary seems to be ignored, though.

It certainly doesn't map the entire list into a single IOVA allocation 
as here (such that everything is laid out in contiguous IOVA pages 
_regardless_ of the segment lengths, and unmapping becomes nicely 
trivial). That it also is the only implementation which fails to respect 
segment boundaries really just implies that it's probably not seen much 
use beyond supporting graphics hardware on 32-bit systems, and/or has 
just got lucky otherwise.

> However, I'm convinced that in most (if not all) cases where IOMMU
> IOVA-contiguous mapping is needed, those two requirements don't exist.
> Do we really have to break the good hardware only because the
> bad^Wlimited one is broken?

Where "is broken" at least encompasses "is a SATA controller", 
presumably. Here's an example I've actually played with:

http://lxr.free-electrons.com/source/drivers/ata/sata_sil24.c#L390

It doesn't seem all that unreasonable that hardware that fundamentally 
works in fixed-size blocks of data wants its data aligned to its block 
size (or some efficient multiple). Implementing an API which has 
guaranteed support for that requirement from the outset necessitates 
supporting that requirement. I'm not going to buy the argument that 
having some video device DMA into userspace pages is more important than 
being able to boot at all (and not corrupting your filesystem).

> Couldn't we preserve the ARM-like behavior whenever
> dma_parms->segment_boundary_mask is set to all 1s and
> dma_parms->max_segment_size to UINT_MAX (what currently drivers used
> to set) or 0 (sounds more logical for the meaning of "no maximum
> given")?

Sure, I was always aiming to ultimately improve on the arch/arm 
implementation (i.e. with the single allocation thing), but for a common 
general-purpose implementation that's going to be shared by multiple 
architectures, correctness comes way before optimisation for one 
specific use-case. Thus we start with a baseline version that we know 
correctly implements all the required behaviour specified by the DMA 
API, then start tweaking it for other considerations later.

FWIW, I've already sketched out such a follow-on patch to start 
tightening up map_sg (because exposing any pages to the device more than 
absolutely necessary is not what we want in the long run). The thought 
that it's likely to be jumped on and used as an excuse to justify bad 
code elsewhere does rather sour the idea, though.

>>>>>> Hmm, I thought the DMA API maps a (possibly) non-contiguous set of
>>>>>> memory pages into a contiguous block in device memory address space.
>>>>>> This would allow passing a dma mapped buffer to device dma using just
>>>>>> a device address and length.
>>>>>
>>>>>
>>>>>
>>>>> Not at all. The streaming DMA API (dma_map_* and friends) has two
>>>>> responsibilities: performing any necessary cache maintenance to ensure the
>>>>> device will correctly see data from the CPU, and the CPU will correctly see
>>>>> data from the device; and working out an address for that buffer from the
>>>>> device's point of view to actually hand off to the hardware (which is
>>>>> perfectly well allowed to fail).
>>>
>>>
>>> Agreed. The dma_map_*() API is not guaranteed to return a single
>>> contiguous part of virtual address space for any given SG list.
>>> However it was understood to be able to map buffers contiguously
>>> mappable by the CPU into a single segment and users,
>>> videobuf2-dma-contig in particular, relied on this.
>>
>>
>> I don't follow that - _any_ buffer made of page-sized chunks is going to be
>> mappable contiguously by the CPU;'
>
> Yes it is. Actually the last chunk might not even need to be
> page-sized. However I believe we can have a scatterlist consisting of
> non-page-sized chunks in the middle as well, which is obviously not
> mappable in a contiguous way even for the CPU.
>
>> it's clearly impossible for the streaming
>> DMA API itself to offer such a guarantee, because it's entirely orthogonal
>> to the presence or otherwise of an IOMMU.
>
> But we are talking here about the very IOMMU-specific implementation of DMA API.

Exactly, therein lies the problem! The whole point of an API is that we 
write code against the provided _interface_, not against some particular 
implementation detail. To quote Raymond Chen, "I can't believe I had to 
write that".

I fail to see how anyone would be surprised that code which is reliant 
on specific non-contractual behaviour of a particular API implementation 
is not portable to other implementations of that API.

>> Furthermore, I can't see any existing dma_map_sg implementation (between
>> arm/64 and x86, at least), that _won't_ break that expectation under certain
>> conditions (ranging from "relatively pathological" to "always"), so it still
>> seems questionable to have a dependency on it.
>
> The current implementation for arch/arm doesn't break that
> expectation. As long as we fit inside the maximum segment size (which
> in most, if not all, cases of the hardware that actually requires such
> contiguous mapping to be created, is UINT_MAX).

Well, yes, that just restates my point exactly; outside of certain 
conditions you will still get a non-contiguous mapping. Put that exact 
code on a 64-bit system, throw a scatterlist describing a "relatively 
pathological" 5GB buffer into it, and see what you get out.

> http://lxr.free-electrons.com/source/arch/arm/mm/dma-mapping.c#L1547
>
>>
>>>>> Consider SWIOTLB's implementation - segments which already lie at
>>>>> physical addresses within the device's DMA mask just get passed through,
>>>>> while those that lie outside it get mapped into the bounce buffer, but still
>>>>> as individual allocations (arch code just handles cache maintenance on the
>>>>> resulting physical addresses and can apply any hard-wired DMA offset for the
>>>>> device concerned).
>>>
>>>
>>> And this is fine for vb2-dma-contig, which was made for devices that
>>> require buffers contiguous in its address space. Without IOMMU it will
>>> allow only physically contiguous buffers and fails otherwise, which is
>>> fine, because it's a hardware requirement.
>>
>>
>> If it depends on having contiguous-from-the-device's-view DMA buffers either
>> way, that's a sign it should perhaps be using the coherent DMA API instead,
>> which _does_ give such a guarantee. I'm well aware of the "but the
>> noncacheable mappings make userspace access unacceptably slow!" issue many
>> folks have with that, though, and don't particularly fancy going off on that
>> tangent here.
>
> The keywords here are DMA-BUF and user pointer. Neither of these cases
> can use coherent DMA API, because the buffer is already allocated, so
> it just needs to be mapped into another device's (or its IOMMU's)
> address space. Obviously we can't guarantee mappability of such
> buffers, e.g. in case of importing non-contiguous buffers to a device
> without an IOMMU, However we expect the pipelines to be sane
> (physically contiguous buffers or both devices IOMMU-enabled), so that
> such things won't happen.

The "guarantee to map these scatterlist pages contiguously in IOVA space 
if an IOMMU is present" function is named iommu_map_sg(). There is 
nothing in the DMA API offering that behaviour. How well does 
vb2-dma-contig work with the x86 IOMMUs?

>>>>>> IIUC, the change above breaks this model by inserting gaps in how the
>>>>>> buffer is mapped to device memory, such that the buffer is no longer
>>>>>> contiguous in dma address space.
>>>>>
>>>>>
>>>>>
>>>>> Even the existing arch/arm IOMMU DMA code which I guess this implicitly
>>>>> relies on doesn't guarantee that behaviour - if the mapping happens to reach
>>>>> one of the segment length/boundary limits it won't just leave a gap, it'll
>>>>> start an entirely new IOVA allocation which could well start at a wildly
>>>>> different address[0].
>>>
>>>
>>> Could you explain segment length/boundary limits and when buffers can
>>> reach them? Sorry, i haven't been following all the discussions, but
>>> I'm not aware of any similar requirements of the IOMMU hardware I
>>> worked with.
>>
>>
>> I hope the explanation at the top makes sense - it's purely about the
>> requirements of the DMA master device itself, nothing to do with the IOMMU
>> (or lack of) in the middle. Devices with scatter-gather DMA limitations
>> exist, therefore the API for scatter-gather DMA is designed to represent and
>> respect such limitations.
>
> Yes, it makes sense, thanks for the explanation. However there also
> exist devices with no scatter-gather capability, but behind an IOMMU
> without such fancy mapping limitations. I believe we should also
> respect the limitation of such setups, which is the lack of support
> for multiple IOVA segments.
>
>>>>>> So, is the videobuf2-dma-contig.c based on an incorrect assumption
>>>>>> about how the DMA API is supposed to work?
>>>>>> Is it even possible to map a "contiguous-in-iova-range" mapping for a
>>>>>> buffer given as an sg_table with an arbitrary set of pages?
>>>>>
>>>>>
>>>>>
>>>>>   From the Streaming DMA mappings section of Documentation/DMA-API.txt:
>>>>>
>>>>>     Note also that the above constraints on physical contiguity and
>>>>>     dma_mask may not apply if the platform has an IOMMU (a device which
>>>>>     maps an I/O DMA address to a physical memory address).  However, to
>>>>> be
>>>>>     portable, device driver writers may *not* assume that such an IOMMU
>>>>>     exists.
>>>>>
>>>>> There's not strictly any harm in using the DMA API this way and *hoping*
>>>>> you get what you want, as long as you're happy for it to fail pretty much
>>>>> 100% of the time on some systems, and still in a minority of corner cases on
>>>>> any system.
>>>
>>>
>>> Could you please elaborate? I'd like to see examples, because I can't
>>> really imagine buffers mappable contiguously on CPU, but not on IOMMU.
>>> Also, as I said, the hardware I worked with didn't suffer from
>>> problems like this.
>>
>>
>> "...device driver writers may *not* assume that such an IOMMU exists."
>>
>
> And this is exactly why they _should_ use dma_map_sg(), because it was
> supposed to work correctly for both physically contiguous (i.e. 1
> segment) buffers and non-IOMMU-enabled devices, as well as with
> non-contiguous (i.e. > 1 segment) buffers and IOMMU-enabled devices.

Note that the number of segments has nothing to do with whether they are 
contiguous (in any address space) or not.

In fact, while I've been thinking about this I realise we have another 
misapprehension here: the point of dma_parms is to expose a device's 
scatter-gather capabilities to _restrict_ what an IOMMU-based DMA API 
implementation can do (see 6b7b65105522) - thus setting fake 
"restrictions" for non-scatter-gather hardware in an attempt to force an 
implementation into merging segments is entirely backwards.

>>>>> However, if there's a real dependency on IOMMUs and tight control of
>>>>> IOVA allocation here, then the DMA API isn't really the right tool for the
>>>>> job, and maybe it's time to start looking to how to better fit these
>>>>> multimedia-subsystem-type use cases into the IOMMU API - as far as I
>>>>> understand it there's at least some conceptual overlap with the HSA PASID
>>>>> stuff being prototyped in PCI/x86-land at the moment, so it could be an
>>>>> apposite time to try and bang out some common requirements.
>>>
>>>
>>> The DMA API is actually the only good tool to use here to keep the
>>> videobuf2-dma-contig code away from the knowledge about platform
>>> specific data, e.g. presence of IOMMU. The only thing it knows is that
>>> the target hardware requires a single contiguous buffer and it relies
>>> on the fact that in correct cases the buffer given to it will meet
>>> this requirement (i.e. physically contiguous w/o IOMMU; CPU mappable
>>> with IOMMU).
>>
>>
>> As above; the DMA API guarantees only what the DMA API guarantees. An
>> IOMMU-based implementation of streaming DMA is free to identity-map pages if
>> it only cares about device isolation; a non-IOMMU implementation is free to
>> provide streaming DMA remapping via some elaborate bounce-buffering scheme
>
> I guess this is the area where our understandings of IOMMU-backed DMA
> API differ.

The DMA API provides a hardware-independent abstraction of a set of 
operations for exposing kernel memory to devices. When someone calls a 
DMA API function, they don't get to choose the details of that 
abstraction, and they don't get to choose the semantics of those operations.

Of course they can always go ahead and propose adding something to the 
API, if they really believe there's something else it needs to offer.

>> if it really wants to. GART-type IOMMUs... let's not even go there.
>
> I believe that's how IOMMU-based implementation of DMA API was
> supposed to work when first implemented for ARM...
 >
>> If v4l needs a guarantee of a single contiguous DMA buffer, then it needs to
>> use dma_alloc_coherent() for that, not streaming mappings.
>
> Except that it can't use it, because the buffers are already allocated
> by another entity.

	dma_alloc_coherent(...
	for_each_sg(..
		memcpy(...

Or v4l is rearchitected such that the userspace pages came from 
mmap()ing a guaranteed-contiguous DMA buffer in the first place. Or 
vb2-dma-contig is rearchitected to use the IOMMU API directly where it 
has an IOMMU dependency. Or someone posts a patch to extend the DMA API 
with a dma_try_to_map_sg_as_contiguously_as_you_can_manage() operation 
that doesn't even necessarily have to depend on an IOMMU... Plenty of 
ways to replace incorrect assumptions with reliable ones.

Or to put it another way; Fast, Easy to implement, Correct: pick two.

With the caveat that for upstream, one of the two _must_ be "Correct".

Robin.

