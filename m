Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56103 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbbJMAg0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 20:36:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] media: videobuf2-dc: set properly dma_max_segment_size
Date: Tue, 13 Oct 2015 03:36:38 +0300
Message-ID: <2676972.ipVyBBXXrt@avalon>
In-Reply-To: <55CCAF84.3010605@metafoo.de>
References: <1439373533-23299-1-git-send-email-m.szyprowski@samsung.com> <55CCA07A.2090904@samsung.com> <55CCAF84.3010605@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 13 August 2015 16:53:56 Lars-Peter Clausen wrote:
> On 08/13/2015 03:49 PM, Marek Szyprowski wrote:
> > On 2015-08-13 14:40, Lars-Peter Clausen wrote:
> >> On 08/12/2015 11:58 AM, Marek Szyprowski wrote:
> >>> If device has no DMA max_seg_size set, we assume that there is no limit
> >>> and it is safe to force it to use DMA_BIT_MASK(32) as max_seg_size to
> >>> let DMA-mapping API always create contiguous mappings in DMA address
> >>> space. This is essential for all devices, which use dma-contig
> >>> videobuf2 memory allocator.
> >>> 
> >>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >>> ---
> >>> Changelog:
> >>> v2:
> >>> - set max segment size only if a new dma params structure has been
> >>> 
> >>>    allocated, as suggested by Laurent Pinchart
> >>> 
> >>> ---
> >>> 
> >>>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 15 +++++++++++++++
> >>>   1 file changed, 15 insertions(+)
> >>> 
> >>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >>> b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >>> index 94c1e64..455e925 100644
> >>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >>> @@ -862,6 +862,21 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
> >>>   void *vb2_dma_contig_init_ctx(struct device *dev)
> >>>   {
> >>>       struct vb2_dc_conf *conf;
> >>> +    int err;
> >>> +
> >>> +    /*
> >>> +     * if device has no max_seg_size set, we assume that there is no
> >>> limit
> >>> +     * and force it to DMA_BIT_MASK(32) to always use contiguous
> >>> mappings
> >>> +     * in DMA address space
> >>> +     */
> >>> +    if (!dev->dma_parms) {
> >>> +        dev->dma_parms = kzalloc(sizeof(*dev->dma_parms), GFP_KERNEL);
> >>> +        if (!dev->dma_parms)
> >>> +            return ERR_PTR(-ENOMEM);
> >>> +        err = dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
> >>> +        if (err)
> >>> +            return ERR_PTR(err);
> >>> +    }
> >> 
> >> I'm not sure if this is such a good idea. The DMA provider is responsible
> >> for setting this up. We shouldn't be overwriting this here on the DMA
> >> consumer side. This will just mask the bug that the provider didn't setup
> >> this correctly and might cause bugs on its own if it is not correct. It
> >> will lead to conflicts with DMA providers that have multiple consumers
> >> (e.g. shared DMA core). And also the current assumption is that if a
> >> driver doesn't set this up explicitly the maximum segement size is
> >> 65536.
> >
> > The problem is that there is no good place for changing this extremely low
> > default value. V4L2 media devices, which use videobuf2-dc expects to get
> > buffers mapped contiguous in the DMA/IO address space. Initially I wanted
> > to have a code for setting dma max segment size directly in the dma-
> > mapping subsystem. This however causeed problems in the other places, as
> > mentioned in the following mail:
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305913
> > .html
>
> And the same reasoning in that reply still applies here. Try to fix the DMA
> provider drivers to setup the correct value.

Would it make sense to create a helper functions that drivers could use ? I 
expect all drivers that require contiguous memory buffers larger than 64kB to 
be broken if they don't set the maximum segment size, which very few of them 
do.

-- 
Regards,

Laurent Pinchart

