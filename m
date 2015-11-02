Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33707 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbKBNn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2015 08:43:27 -0500
Received: by obbwb3 with SMTP id wb3so94941969obb.0
        for <linux-media@vger.kernel.org>; Mon, 02 Nov 2015 05:43:26 -0800 (PST)
Received: from mail-ob0-f172.google.com (mail-ob0-f172.google.com. [209.85.214.172])
        by smtp.gmail.com with ESMTPSA id m203sm8906981oif.19.2015.11.02.05.43.25
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 02 Nov 2015 05:43:25 -0800 (PST)
Received: by obbwb3 with SMTP id wb3so94941532obb.0
        for <linux-media@vger.kernel.org>; Mon, 02 Nov 2015 05:43:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGS+omAmxbb4uVzaQh1xPmkFtcF6KP-HSV-40=sm1BRTdh+=OQ@mail.gmail.com>
References: <cover.1443718557.git.robin.murphy@arm.com> <ab8e1caa40d6da1afa4a49f30242ef4e6e1f17df.1443718557.git.robin.murphy@arm.com>
 <1445867094.30736.14.camel@mhfsdcap03> <562E5AE4.9070001@arm.com>
 <CAGS+omAWCQsqk56iv0PW2ZhTJ1342GufUsJCP=VYSgCxZNLJpA@mail.gmail.com>
 <56337E4D.1010304@arm.com> <CAGS+omAmxbb4uVzaQh1xPmkFtcF6KP-HSV-40=sm1BRTdh+=OQ@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 2 Nov 2015 22:43:05 +0900
Message-ID: <CAAFQd5C_dkWBZrQXtyO59ARw7q-0fg-Wk98yApC5VHdQ8-AmNw@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] iommu: Implement common IOMMU ops for DMA mapping
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Robin Murphy <robin.murphy@arm.com>,
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 2, 2015 at 10:11 PM, Daniel Kurtz <djkurtz@chromium.org> wrote:
>
> +Tomasz, so he can reply to the thread
> +Marek and Russell as recommended by Tomasz
>
> On Oct 30, 2015 22:27, "Robin Murphy" <robin.murphy@arm.com> wrote:
> >
> > Hi Dan,
> >
> > On 30/10/15 01:17, Daniel Kurtz wrote:
> >>
> >> +linux-media & VIDEOBUF2 FRAMEWORK maintainers since this is about the
> >> v4l2-contig's usage of the DMA API.
> >>
> >> Hi Robin,
> >>
> >> On Tue, Oct 27, 2015 at 12:55 AM, Robin Murphy <robin.murphy@arm.com> wrote:
> >>>
> >>> On 26/10/15 13:44, Yong Wu wrote:
> >>>>
> >>>>
> >>>> On Thu, 2015-10-01 at 20:13 +0100, Robin Murphy wrote:
> >>>> [...]
> >>>>>
> >>>>>
> >>>>> +/*
> >>>>> + * The DMA API client is passing in a scatterlist which could describe
> >>>>> + * any old buffer layout, but the IOMMU API requires everything to be
> >>>>> + * aligned to IOMMU pages. Hence the need for this complicated bit of
> >>>>> + * impedance-matching, to be able to hand off a suitably-aligned list,
> >>>>> + * but still preserve the original offsets and sizes for the caller.
> >>>>> + */
> >>>>> +int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
> >>>>> +               int nents, int prot)
> >>>>> +{
> >>>>> +       struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
> >>>>> +       struct iova_domain *iovad = domain->iova_cookie;
> >>>>> +       struct iova *iova;
> >>>>> +       struct scatterlist *s, *prev = NULL;
> >>>>> +       dma_addr_t dma_addr;
> >>>>> +       size_t iova_len = 0;
> >>>>> +       int i;
> >>>>> +
> >>>>> +       /*
> >>>>> +        * Work out how much IOVA space we need, and align the segments
> >>>>> to
> >>>>> +        * IOVA granules for the IOMMU driver to handle. With some clever
> >>>>> +        * trickery we can modify the list in-place, but reversibly, by
> >>>>> +        * hiding the original data in the as-yet-unused DMA fields.
> >>>>> +        */
> >>>>> +       for_each_sg(sg, s, nents, i) {
> >>>>> +               size_t s_offset = iova_offset(iovad, s->offset);
> >>>>> +               size_t s_length = s->length;
> >>>>> +
> >>>>> +               sg_dma_address(s) = s->offset;
> >>>>> +               sg_dma_len(s) = s_length;
> >>>>> +               s->offset -= s_offset;
> >>>>> +               s_length = iova_align(iovad, s_length + s_offset);
> >>>>> +               s->length = s_length;
> >>>>> +
> >>>>> +               /*
> >>>>> +                * The simple way to avoid the rare case of a segment
> >>>>> +                * crossing the boundary mask is to pad the previous one
> >>>>> +                * to end at a naturally-aligned IOVA for this one's
> >>>>> size,
> >>>>> +                * at the cost of potentially over-allocating a little.

I'd like to know what is the boundary mask and what hardware imposes
requirements like this. The cost here is not only over-allocating a
little, but making many, many buffers contiguously mappable on the
CPU, unmappable contiguously in IOMMU, which just defeats the purpose
of having an IOMMU, which I believe should be there for simple IP
blocks taking one DMA address to be able to view the buffer the same
way as the CPU.

> >>>>> +                */
> >>>>> +               if (prev) {
> >>>>> +                       size_t pad_len = roundup_pow_of_two(s_length);
> >>>>> +
> >>>>> +                       pad_len = (pad_len - iova_len) & (pad_len - 1);
> >>>>> +                       prev->length += pad_len;
> >>>>
> >>>>
> >>>>
> >>>> Hi Robin,
> >>>>         While our v4l2 testing, It seems that we met a problem here.
> >>>>         Here we update prev->length again, Do we need update
> >>>> sg_dma_len(prev) again too?
> >>>>
> >>>>         Some function like vb2_dc_get_contiguous_size[1] always get
> >>>> sg_dma_len(s) to compare instead of s->length. so it may break
> >>>> unexpectedly while sg_dma_len(s) is not same with s->length.
> >>>
> >>>
> >>>
> >>> This is just tweaking the faked-up length that we hand off to iommu_map_sg()
> >>> (see also the iova_align() above), to trick it into bumping this segment up
> >>> to a suitable starting IOVA. The real length at this point is stashed in
> >>> sg_dma_len(s), and will be copied back into s->length in __finalise_sg(), so
> >>> both will hold the same true length once we return to the caller.
> >>>
> >>> Yes, it does mean that if you have a list where the segment lengths are page
> >>> aligned but not monotonically decreasing, e.g. {64k, 16k, 64k}, then you'll
> >>> still end up with a gap between the second and third segments, but that's
> >>> fine because the DMA API offers no guarantees about what the resulting DMA
> >>> addresses will be (consider the no-IOMMU case where they would each just be
> >>> "mapped" to their physical address). If that breaks v4l, then it's probably
> >>> v4l's DMA API use that needs looking at (again).
> >>
> >>
> >> Hmm, I thought the DMA API maps a (possibly) non-contiguous set of
> >> memory pages into a contiguous block in device memory address space.
> >> This would allow passing a dma mapped buffer to device dma using just
> >> a device address and length.
> >
> >
> > Not at all. The streaming DMA API (dma_map_* and friends) has two responsibilities: performing any necessary cache maintenance to ensure the device will correctly see data from the CPU, and the CPU will correctly see data from the device; and working out an address for that buffer from the device's point of view to actually hand off to the hardware (which is perfectly well allowed to fail).

Agreed. The dma_map_*() API is not guaranteed to return a single
contiguous part of virtual address space for any given SG list.
However it was understood to be able to map buffers contiguously
mappable by the CPU into a single segment and users,
videobuf2-dma-contig in particular, relied on this.

> >
> > Consider SWIOTLB's implementation - segments which already lie at physical addresses within the device's DMA mask just get passed through, while those that lie outside it get mapped into the bounce buffer, but still as individual allocations (arch code just handles cache maintenance on the resulting physical addresses and can apply any hard-wired DMA offset for the device concerned).

And this is fine for vb2-dma-contig, which was made for devices that
require buffers contiguous in its address space. Without IOMMU it will
allow only physically contiguous buffers and fails otherwise, which is
fine, because it's a hardware requirement.

> >
> >> IIUC, the change above breaks this model by inserting gaps in how the
> >> buffer is mapped to device memory, such that the buffer is no longer
> >> contiguous in dma address space.
> >
> >
> > Even the existing arch/arm IOMMU DMA code which I guess this implicitly relies on doesn't guarantee that behaviour - if the mapping happens to reach one of the segment length/boundary limits it won't just leave a gap, it'll start an entirely new IOVA allocation which could well start at a wildly different address[0].

Could you explain segment length/boundary limits and when buffers can
reach them? Sorry, i haven't been following all the discussions, but
I'm not aware of any similar requirements of the IOMMU hardware I
worked with.

> >
> >> Here is the code in question from
> >> drivers/media/v4l2-core/videobuf2-dma-contig.c :
> >>
> >> static unsigned long vb2_dc_get_contiguous_size(struct sg_table *sgt)
> >> {
> >>          struct scatterlist *s;
> >>          dma_addr_t expected = sg_dma_address(sgt->sgl);
> >>          unsigned int i;
> >>          unsigned long size = 0;
> >>
> >>          for_each_sg(sgt->sgl, s, sgt->nents, i) {
> >>                  if (sg_dma_address(s) != expected)
> >>                          break;
> >>                  expected = sg_dma_address(s) + sg_dma_len(s);
> >>                  size += sg_dma_len(s);
> >>          }
> >>          return size;
> >> }
> >>
> >>
> >> static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
> >>          unsigned long size, enum dma_data_direction dma_dir)
> >> {
> >>          struct vb2_dc_conf *conf = alloc_ctx;
> >>          struct vb2_dc_buf *buf;
> >>          struct frame_vector *vec;
> >>          unsigned long offset;
> >>          int n_pages, i;
> >>          int ret = 0;
> >>          struct sg_table *sgt;
> >>          unsigned long contig_size;
> >>          unsigned long dma_align = dma_get_cache_alignment();
> >>          DEFINE_DMA_ATTRS(attrs);
> >>
> >>          dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
> >>
> >>          buf = kzalloc(sizeof *buf, GFP_KERNEL);
> >>          buf->dma_dir = dma_dir;
> >>
> >>          offset = vaddr & ~PAGE_MASK;
> >>          vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
> >>          buf->vec = vec;
> >>          n_pages = frame_vector_count(vec);
> >>
> >>          sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
> >>
> >>          ret = sg_alloc_table_from_pages(sgt, frame_vector_pages(vec), n_pages,
> >>                  offset, size, GFP_KERNEL);
> >>
> >>          sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
> >>                                        buf->dma_dir, &attrs);
> >>
> >>          contig_size = vb2_dc_get_contiguous_size(sgt);
> >
> >
> > (as an aside, it's rather unintuitive that the handling of the dma_map_sg call actually failing is entirely implicit here)

I'm not sure what you mean, please elaborate. The code considers only
the case of contiguously mapping at least the requested size as a
success, because anything else is useless with the hardware.

> >
> >>          if (contig_size < size) {
> >>
> >>      <<<===   if the original buffer had sg entries that were not
> >> aligned on the "natural" alignment for their size, the new arm64 iommu
> >> core code inserts  a 'gap' in the iommu mapping, which causes
> >> vb2_dc_get_contiguous_size() to exit early (and return a smaller size
> >> than expected).
> >>
> >>                  pr_err("contiguous mapping is too small %lu/%lu\n",
> >>                          contig_size, size);
> >>                  ret = -EFAULT;
> >>                  goto fail_map_sg;
> >>          }
> >>
> >>
> >> So, is the videobuf2-dma-contig.c based on an incorrect assumption
> >> about how the DMA API is supposed to work?
> >> Is it even possible to map a "contiguous-in-iova-range" mapping for a
> >> buffer given as an sg_table with an arbitrary set of pages?
> >
> >
> > From the Streaming DMA mappings section of Documentation/DMA-API.txt:
> >
> >   Note also that the above constraints on physical contiguity and
> >   dma_mask may not apply if the platform has an IOMMU (a device which
> >   maps an I/O DMA address to a physical memory address).  However, to be
> >   portable, device driver writers may *not* assume that such an IOMMU
> >   exists.
> >
> > There's not strictly any harm in using the DMA API this way and *hoping* you get what you want, as long as you're happy for it to fail pretty much 100% of the time on some systems, and still in a minority of corner cases on any system.

Could you please elaborate? I'd like to see examples, because I can't
really imagine buffers mappable contiguously on CPU, but not on IOMMU.
Also, as I said, the hardware I worked with didn't suffer from
problems like this.

> > However, if there's a real dependency on IOMMUs and tight control of IOVA allocation here, then the DMA API isn't really the right tool for the job, and maybe it's time to start looking to how to better fit these multimedia-subsystem-type use cases into the IOMMU API - as far as I understand it there's at least some conceptual overlap with the HSA PASID stuff being prototyped in PCI/x86-land at the moment, so it could be an apposite time to try and bang out some common requirements.

The DMA API is actually the only good tool to use here to keep the
videobuf2-dma-contig code away from the knowledge about platform
specific data, e.g. presence of IOMMU. The only thing it knows is that
the target hardware requires a single contiguous buffer and it relies
on the fact that in correct cases the buffer given to it will meet
this requirement (i.e. physically contiguous w/o IOMMU; CPU mappable
with IOMMU).

Best regards,
Tomasz
