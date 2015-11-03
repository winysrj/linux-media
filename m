Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu-smtp-delivery-143.mimecast.com ([146.101.78.143]:36218 "EHLO
	eu-smtp-delivery-143.mimecast.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440AbbKCRlc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Nov 2015 12:41:32 -0500
Subject: Re: [PATCH v6 1/3] iommu: Implement common IOMMU ops for DMA mapping
To: Tomasz Figa <tfiga@chromium.org>,
	Daniel Kurtz <djkurtz@chromium.org>
References: <cover.1443718557.git.robin.murphy@arm.com>
 <ab8e1caa40d6da1afa4a49f30242ef4e6e1f17df.1443718557.git.robin.murphy@arm.com>
 <1445867094.30736.14.camel@mhfsdcap03> <562E5AE4.9070001@arm.com>
 <CAGS+omAWCQsqk56iv0PW2ZhTJ1342GufUsJCP=VYSgCxZNLJpA@mail.gmail.com>
 <56337E4D.1010304@arm.com>
 <CAGS+omAmxbb4uVzaQh1xPmkFtcF6KP-HSV-40=sm1BRTdh+=OQ@mail.gmail.com>
 <CAAFQd5C_dkWBZrQXtyO59ARw7q-0fg-Wk98yApC5VHdQ8-AmNw@mail.gmail.com>
Cc: Lin PoChun <pochun.lin@mediatek.com>,
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
Message-ID: <5638F1C4.3000900@arm.com>
Date: Tue, 3 Nov 2015 17:41:24 +0000
MIME-Version: 1.0
In-Reply-To: <CAAFQd5C_dkWBZrQXtyO59ARw7q-0fg-Wk98yApC5VHdQ8-AmNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 02/11/15 13:43, Tomasz Figa wrote:
> I'd like to know what is the boundary mask and what hardware imposes
> requirements like this. The cost here is not only over-allocating a
> little, but making many, many buffers contiguously mappable on the
> CPU, unmappable contiguously in IOMMU, which just defeats the purpose
> of having an IOMMU, which I believe should be there for simple IP
> blocks taking one DMA address to be able to view the buffer the same
> way as the CPU.

The expectation with dma_map_sg() is that you're either going to be 
iterating over the buffer segments, handing off each address to the 
device to process one by one; or you have a scatter-gather-capable 
device, in which case you hand off the whole list at once. It's in the 
latter case where you have to make sure the list doesn't exceed the 
hardware limitations of that device. I believe the original concern was 
disk controllers (the introduction of dma_parms seems to originate from 
the linux-scsi list), but most scatter-gather engines are going to have 
some limit on how much they can handle per entry (IMO the dmaengine 
drivers are the easiest example to look at).

Segment boundaries are a little more arcane, but my assumption is that 
they relate to the kind of devices whose addressing is not flat but 
relative to some separate segment register (The "64-bit" mode of USB 
EHCI is one concrete example I can think of) - since you cannot 
realistically change the segment register while the device is in the 
middle of accessing a single buffer entry, that entry must not fall 
across a segment boundary or at some point the device's accesses are 
going to overflow the offset address bits and wrap around to bogus 
addresses at the bottom of the segment.

Now yes, it will be possible under _most_ circumstances to use an IOMMU 
to lay out a list of segments with page-aligned lengths within a single 
IOVA allocation whilst still meeting all the necessary constraints. It 
just needs some unavoidably complicated calculations - quite likely 
significantly more complex than my v5 version of map_sg() that tried to 
do that and merge segments but failed to take the initial alignment into 
account properly - since there are much simpler ways to enforce just the 
_necessary_ behaviour for the DMA API, I put the complicated stuff to 
one side for now to prevent it holding up getting the basic functional 
support in place.

>>>> Hmm, I thought the DMA API maps a (possibly) non-contiguous set of
>>>> memory pages into a contiguous block in device memory address space.
>>>> This would allow passing a dma mapped buffer to device dma using just
>>>> a device address and length.
>>>
>>>
>>> Not at all. The streaming DMA API (dma_map_* and friends) has two responsibilities: performing any necessary cache maintenance to ensure the device will correctly see data from the CPU, and the CPU will correctly see data from the device; and working out an address for that buffer from the device's point of view to actually hand off to the hardware (which is perfectly well allowed to fail).
>
> Agreed. The dma_map_*() API is not guaranteed to return a single
> contiguous part of virtual address space for any given SG list.
> However it was understood to be able to map buffers contiguously
> mappable by the CPU into a single segment and users,
> videobuf2-dma-contig in particular, relied on this.

I don't follow that - _any_ buffer made of page-sized chunks is going to 
be mappable contiguously by the CPU; it's clearly impossible for the 
streaming DMA API itself to offer such a guarantee, because it's 
entirely orthogonal to the presence or otherwise of an IOMMU.

Furthermore, I can't see any existing dma_map_sg implementation (between 
arm/64 and x86, at least), that _won't_ break that expectation under 
certain conditions (ranging from "relatively pathological" to "always"), 
so it still seems questionable to have a dependency on it.

>>> Consider SWIOTLB's implementation - segments which already lie at physical addresses within the device's DMA mask just get passed through, while those that lie outside it get mapped into the bounce buffer, but still as individual allocations (arch code just handles cache maintenance on the resulting physical addresses and can apply any hard-wired DMA offset for the device concerned).
>
> And this is fine for vb2-dma-contig, which was made for devices that
> require buffers contiguous in its address space. Without IOMMU it will
> allow only physically contiguous buffers and fails otherwise, which is
> fine, because it's a hardware requirement.

If it depends on having contiguous-from-the-device's-view DMA buffers 
either way, that's a sign it should perhaps be using the coherent DMA 
API instead, which _does_ give such a guarantee. I'm well aware of the 
"but the noncacheable mappings make userspace access unacceptably slow!" 
issue many folks have with that, though, and don't particularly fancy 
going off on that tangent here.

>>>> IIUC, the change above breaks this model by inserting gaps in how the
>>>> buffer is mapped to device memory, such that the buffer is no longer
>>>> contiguous in dma address space.
>>>
>>>
>>> Even the existing arch/arm IOMMU DMA code which I guess this implicitly relies on doesn't guarantee that behaviour - if the mapping happens to reach one of the segment length/boundary limits it won't just leave a gap, it'll start an entirely new IOVA allocation which could well start at a wildly different address[0].
>
> Could you explain segment length/boundary limits and when buffers can
> reach them? Sorry, i haven't been following all the discussions, but
> I'm not aware of any similar requirements of the IOMMU hardware I
> worked with.

I hope the explanation at the top makes sense - it's purely about the 
requirements of the DMA master device itself, nothing to do with the 
IOMMU (or lack of) in the middle. Devices with scatter-gather DMA 
limitations exist, therefore the API for scatter-gather DMA is designed 
to represent and respect such limitations.

>>>> Here is the code in question from
>>>> drivers/media/v4l2-core/videobuf2-dma-contig.c :
[...]
>>>> static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
>>>>           unsigned long size, enum dma_data_direction dma_dir)
>>>> {
[...]
>>>>           sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
>>>>                                         buf->dma_dir, &attrs);
>>>>
>>>>           contig_size = vb2_dc_get_contiguous_size(sgt);
>>>
>>>
>>> (as an aside, it's rather unintuitive that the handling of the dma_map_sg call actually failing is entirely implicit here)
>
> I'm not sure what you mean, please elaborate. The code considers only
> the case of contiguously mapping at least the requested size as a
> success, because anything else is useless with the hardware.

My bad; having now compared against the actual file I see this is just a 
cherry-picking of relevant lines with all the error checking stripped 
out. Objection withdrawn ;)

>>>> So, is the videobuf2-dma-contig.c based on an incorrect assumption
>>>> about how the DMA API is supposed to work?
>>>> Is it even possible to map a "contiguous-in-iova-range" mapping for a
>>>> buffer given as an sg_table with an arbitrary set of pages?
>>>
>>>
>>>  From the Streaming DMA mappings section of Documentation/DMA-API.txt:
>>>
>>>    Note also that the above constraints on physical contiguity and
>>>    dma_mask may not apply if the platform has an IOMMU (a device which
>>>    maps an I/O DMA address to a physical memory address).  However, to be
>>>    portable, device driver writers may *not* assume that such an IOMMU
>>>    exists.
>>>
>>> There's not strictly any harm in using the DMA API this way and *hoping* you get what you want, as long as you're happy for it to fail pretty much 100% of the time on some systems, and still in a minority of corner cases on any system.
>
> Could you please elaborate? I'd like to see examples, because I can't
> really imagine buffers mappable contiguously on CPU, but not on IOMMU.
> Also, as I said, the hardware I worked with didn't suffer from
> problems like this.

"...device driver writers may *not* assume that such an IOMMU exists."

>>> However, if there's a real dependency on IOMMUs and tight control of IOVA allocation here, then the DMA API isn't really the right tool for the job, and maybe it's time to start looking to how to better fit these multimedia-subsystem-type use cases into the IOMMU API - as far as I understand it there's at least some conceptual overlap with the HSA PASID stuff being prototyped in PCI/x86-land at the moment, so it could be an apposite time to try and bang out some common requirements.
>
> The DMA API is actually the only good tool to use here to keep the
> videobuf2-dma-contig code away from the knowledge about platform
> specific data, e.g. presence of IOMMU. The only thing it knows is that
> the target hardware requires a single contiguous buffer and it relies
> on the fact that in correct cases the buffer given to it will meet
> this requirement (i.e. physically contiguous w/o IOMMU; CPU mappable
> with IOMMU).

As above; the DMA API guarantees only what the DMA API guarantees. An 
IOMMU-based implementation of streaming DMA is free to identity-map 
pages if it only cares about device isolation; a non-IOMMU 
implementation is free to provide streaming DMA remapping via some 
elaborate bounce-buffering scheme if it really wants to. GART-type 
IOMMUs... let's not even go there.

If v4l needs a guarantee of a single contiguous DMA buffer, then it 
needs to use dma_alloc_coherent() for that, not streaming mappings.

Robin.

