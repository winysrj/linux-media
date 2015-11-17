Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46778 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbbKQMCQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 07:02:16 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NXY0012BK3P6430@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Nov 2015 12:02:13 +0000 (GMT)
Subject: Re: [PATCH v6 1/3] iommu: Implement common IOMMU ops for DMA mapping
To: Daniel Kurtz <djkurtz@chromium.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Pawel Osciak <pawel@osciak.com>
References: <cover.1443718557.git.robin.murphy@arm.com>
 <ab8e1caa40d6da1afa4a49f30242ef4e6e1f17df.1443718557.git.robin.murphy@arm.com>
 <1445867094.30736.14.camel@mhfsdcap03> <562E5AE4.9070001@arm.com>
 <CAGS+omAWCQsqk56iv0PW2ZhTJ1342GufUsJCP=VYSgCxZNLJpA@mail.gmail.com>
Cc: Yong Wu <yong.wu@mediatek.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will.deacon@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, thunder.leizhen@huawei.com,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	laurent.pinchart+renesas@ideasonboard.com,
	Thierry Reding <treding@nvidia.com>,
	Lin PoChun <pochun.lin@mediatek.com>,
	"Bobby Batacharia (via Google Docs)" <Bobby.Batacharia@arm.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <564B1743.3030407@samsung.com>
Date: Tue, 17 Nov 2015 13:02:11 +0100
MIME-version: 1.0
In-reply-to: <CAGS+omAWCQsqk56iv0PW2ZhTJ1342GufUsJCP=VYSgCxZNLJpA@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm really sorry do late joining this discussion, but I was terribly 
busy with other things.

On 2015-10-30 02:17, Daniel Kurtz wrote:
> +linux-media & VIDEOBUF2 FRAMEWORK maintainers since this is about the
> v4l2-contig's usage of the DMA API.
>
> Hi Robin,
>
> On Tue, Oct 27, 2015 at 12:55 AM, Robin Murphy <robin.murphy@arm.com> wrote:
>> On 26/10/15 13:44, Yong Wu wrote:
>>> On Thu, 2015-10-01 at 20:13 +0100, Robin Murphy wrote:
>>> [...]
>>>> +/*
>>>> + * The DMA API client is passing in a scatterlist which could describe
>>>> + * any old buffer layout, but the IOMMU API requires everything to be
>>>> + * aligned to IOMMU pages. Hence the need for this complicated bit of
>>>> + * impedance-matching, to be able to hand off a suitably-aligned list,
>>>> + * but still preserve the original offsets and sizes for the caller.
>>>> + */
>>>> +int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
>>>> +               int nents, int prot)
>>>> +{
>>>> +       struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
>>>> +       struct iova_domain *iovad = domain->iova_cookie;
>>>> +       struct iova *iova;
>>>> +       struct scatterlist *s, *prev = NULL;
>>>> +       dma_addr_t dma_addr;
>>>> +       size_t iova_len = 0;
>>>> +       int i;
>>>> +
>>>> +       /*
>>>> +        * Work out how much IOVA space we need, and align the segments
>>>> to
>>>> +        * IOVA granules for the IOMMU driver to handle. With some clever
>>>> +        * trickery we can modify the list in-place, but reversibly, by
>>>> +        * hiding the original data in the as-yet-unused DMA fields.
>>>> +        */
>>>> +       for_each_sg(sg, s, nents, i) {
>>>> +               size_t s_offset = iova_offset(iovad, s->offset);
>>>> +               size_t s_length = s->length;
>>>> +
>>>> +               sg_dma_address(s) = s->offset;
>>>> +               sg_dma_len(s) = s_length;
>>>> +               s->offset -= s_offset;
>>>> +               s_length = iova_align(iovad, s_length + s_offset);
>>>> +               s->length = s_length;
>>>> +
>>>> +               /*
>>>> +                * The simple way to avoid the rare case of a segment
>>>> +                * crossing the boundary mask is to pad the previous one
>>>> +                * to end at a naturally-aligned IOVA for this one's
>>>> size,
>>>> +                * at the cost of potentially over-allocating a little.
>>>> +                */
>>>> +               if (prev) {
>>>> +                       size_t pad_len = roundup_pow_of_two(s_length);
>>>> +
>>>> +                       pad_len = (pad_len - iova_len) & (pad_len - 1);
>>>> +                       prev->length += pad_len;
>>>
>>> Hi Robin,
>>>         While our v4l2 testing, It seems that we met a problem here.
>>>         Here we update prev->length again, Do we need update
>>> sg_dma_len(prev) again too?
>>>
>>>         Some function like vb2_dc_get_contiguous_size[1] always get
>>> sg_dma_len(s) to compare instead of s->length. so it may break
>>> unexpectedly while sg_dma_len(s) is not same with s->length.
>>
>> This is just tweaking the faked-up length that we hand off to iommu_map_sg()
>> (see also the iova_align() above), to trick it into bumping this segment up
>> to a suitable starting IOVA. The real length at this point is stashed in
>> sg_dma_len(s), and will be copied back into s->length in __finalise_sg(), so
>> both will hold the same true length once we return to the caller.
>>
>> Yes, it does mean that if you have a list where the segment lengths are page
>> aligned but not monotonically decreasing, e.g. {64k, 16k, 64k}, then you'll
>> still end up with a gap between the second and third segments, but that's
>> fine because the DMA API offers no guarantees about what the resulting DMA
>> addresses will be (consider the no-IOMMU case where they would each just be
>> "mapped" to their physical address). If that breaks v4l, then it's probably
>> v4l's DMA API use that needs looking at (again).
> Hmm, I thought the DMA API maps a (possibly) non-contiguous set of
> memory pages into a contiguous block in device memory address space.
> This would allow passing a dma mapped buffer to device dma using just
> a device address and length.
> IIUC, the change above breaks this model by inserting gaps in how the
> buffer is mapped to device memory, such that the buffer is no longer
> contiguous in dma address space.
>
> Here is the code in question from
> drivers/media/v4l2-core/videobuf2-dma-contig.c :
>
> static unsigned long vb2_dc_get_contiguous_size(struct sg_table *sgt)
> {
>          struct scatterlist *s;
>          dma_addr_t expected = sg_dma_address(sgt->sgl);
>          unsigned int i;
>          unsigned long size = 0;
>
>          for_each_sg(sgt->sgl, s, sgt->nents, i) {
>                  if (sg_dma_address(s) != expected)
>                          break;
>                  expected = sg_dma_address(s) + sg_dma_len(s);
>                  size += sg_dma_len(s);
>          }
>          return size;
> }
>
>
> static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
>          unsigned long size, enum dma_data_direction dma_dir)
> {
>          struct vb2_dc_conf *conf = alloc_ctx;
>          struct vb2_dc_buf *buf;
>          struct frame_vector *vec;
>          unsigned long offset;
>          int n_pages, i;
>          int ret = 0;
>          struct sg_table *sgt;
>          unsigned long contig_size;
>          unsigned long dma_align = dma_get_cache_alignment();
>          DEFINE_DMA_ATTRS(attrs);
>
>          dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
>
>          buf = kzalloc(sizeof *buf, GFP_KERNEL);
>          buf->dma_dir = dma_dir;
>
>          offset = vaddr & ~PAGE_MASK;
>          vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
>          buf->vec = vec;
>          n_pages = frame_vector_count(vec);
>
>          sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
>
>          ret = sg_alloc_table_from_pages(sgt, frame_vector_pages(vec), n_pages,
>                  offset, size, GFP_KERNEL);
>
>          sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
>                                        buf->dma_dir, &attrs);
>
>          contig_size = vb2_dc_get_contiguous_size(sgt);
>          if (contig_size < size) {
>
>      <<<===   if the original buffer had sg entries that were not
> aligned on the "natural" alignment for their size, the new arm64 iommu
> core code inserts  a 'gap' in the iommu mapping, which causes
> vb2_dc_get_contiguous_size() to exit early (and return a smaller size
> than expected).
>
>                  pr_err("contiguous mapping is too small %lu/%lu\n",
>                          contig_size, size);
>                  ret = -EFAULT;
>                  goto fail_map_sg;
>          }
>
>
> So, is the videobuf2-dma-contig.c based on an incorrect assumption
> about how the DMA API is supposed to work?
> Is it even possible to map a "contiguous-in-iova-range" mapping for a
> buffer given as an sg_table with an arbitrary set of pages?
>
> Thanks for helping to move this forward.

As I'm responsible for the code of both dma-mapping IOMMU integration 
code for
ARM and videobuf2-dc subdriver, I would like to share the background behind
them.

This code is a result of our (Samsung R&D Institute Poland) works on 
mainlining
drivers for various multimedia devices found in Exynos SoCs. All those 
devices
can only process buffers, which are contiguous in the DMA address space. 
This
is requirement was one of the fundamental reason for using IOMMU modules.
However it turned out that there was no straightforward way of 
integrating it
for our purposes and some extension to core frameworks were needed.

Our initial proposal integrated IOMMU drivers directly to the V4L2 
helper code,
as a separate memory managing subdriver for videobuf2:
http://www.spinics.net/lists/linux-media/msg31455.html

Then I've been suggested to use dma-mapping API and hide IOMMU behind it.

Allocating a buffer suitable for DMA with IOMMU mapper enabled was easy.
However creating a contiguous mapping in DMA address space for a buffer
scattered in the physical memory was still a bit tricky. The only 
possible way
was to use scatter-list and assume that DMA-mapping will do it right (will
create only one segment for the whole scatter list). I found no other
possibility. This part of the IOMMU and DMA-mapping was especially 
problematic
when buffer sharing (dma-buf) has been introduced and it turned out that
there are different ways of interpreting scatter lists done by different
drivers.

 From the time I see that I focused mainly on re-using existing 
DMA-mapping API,
what shouldn't be the main goal. This resulted in somehow tricky way of 
doing
one of the most common operation for existing multimedia devices. 
Scatter lists
are also a bit over-engineered for doing a such simple operation like 
mapping
scattered memory into single contiguous DMA address space. They waste memory
for storing useless parameters like per-page offset and dma address/len.

Maybe it would be better if something like page vector (or PFN vector to 
solve
the problem of mapping buffers that cannot be described by pages) have been
introduced and operations like dma_map_vector() will make thing much 
more clear.
I can provide a proof-of-concept code for further discussion if needed.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

