Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49531 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbbFCBWO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2015 21:22:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: videobuf2-dc: set properly dma_max_segment_size
Date: Wed, 03 Jun 2015 04:22:17 +0300
Message-ID: <6344262.Bi3ADFT2cX@avalon>
In-Reply-To: <1433160857-11124-1-git-send-email-m.szyprowski@samsung.com>
References: <1433160857-11124-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

Thank you for the patch.

On Monday 01 June 2015 14:14:17 Marek Szyprowski wrote:
> If device has no DMA max_seg_size set, we assume that there is no limit
> and it is safe to force it to use DMA_BIT_MASK(32) as max_seg_size to
> let DMA-mapping API always create contiguous mappings in DMA address
> space. This is essential for all devices, which use dma-contig
> videobuf2 memory allocator.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index
> 644dec73d220..9d7c1814b0f3 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -862,6 +862,23 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
>  void *vb2_dma_contig_init_ctx(struct device *dev)
>  {
>  	struct vb2_dc_conf *conf;
> +	int err;
> +
> +	/*
> +	 * if device has no max_seg_size set, we assume that there is no limit
> +	 * and force it to DMA_BIT_MASK(32) to always use contiguous mappings
> +	 * in DMA address space
> +	 */
> +	if (!dev->dma_parms) {
> +		dev->dma_parms = kzalloc(sizeof(*dev->dma_parms), GFP_KERNEL);

I was checking how dma_parms was usually allocated and freed, and was shocked 
to find that the memory is never freed. OK, actually not shocked, I had a bad 
feeling about it already, but it's still not good :-/

This goes beyond the scope of this patch, but I think we need to clean up 
dma_parms. The structure is 8 bytes long on 32-bit systems and 16 bytes long 
on 64-bit systems. I wonder if it's really worth it to allocate it separately 
from struct device. It might if we moved more DMA-related fields to struct 
device_dma_parameters but that hasn't happened since 2008 when the structure 
was introduced (yes that's more than 7 years ago).

If we consider it's worth it (and I believe Josh Triplett might, in the 
context of the Linux kernel tinification project), we should at least handle 
allocation and free of the field coherently across drivers.

> +		if (!dev->dma_parms)
> +			return ERR_PTR(-ENOMEM);
> +	}
> +	if (dma_get_max_seg_size(dev) < DMA_BIT_MASK(32)) {
> +		err = dma_set_max_seg_size(dev, DMA_BIT_MASK(32));

What if the device has set a maximum segment size smaller than 4GB because of 
hardware limitations ?

I also wonder whether this is the correct place to solve the issue. Why is the 
default value returned by dma_get_max_seg_size() set to 64kB ?

> +		if (err)
> +			return ERR_PTR(err);
> +	}
> 
>  	conf = kzalloc(sizeof *conf, GFP_KERNEL);
>  	if (!conf)

-- 
Regards,

Laurent Pinchart
