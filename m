Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-200.synserver.de ([212.40.185.200]:1070 "EHLO
	smtp-out-200.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbbHMMkt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 08:40:49 -0400
Message-ID: <55CC904E.4040907@metafoo.de>
Date: Thu, 13 Aug 2015 14:40:46 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2] media: videobuf2-dc: set properly dma_max_segment_size
References: <1439373533-23299-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1439373533-23299-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/12/2015 11:58 AM, Marek Szyprowski wrote:
> If device has no DMA max_seg_size set, we assume that there is no limit
> and it is safe to force it to use DMA_BIT_MASK(32) as max_seg_size to
> let DMA-mapping API always create contiguous mappings in DMA address
> space. This is essential for all devices, which use dma-contig
> videobuf2 memory allocator.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
> Changelog:
> v2:
> - set max segment size only if a new dma params structure has been
>   allocated, as suggested by Laurent Pinchart
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index 94c1e64..455e925 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -862,6 +862,21 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
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
> +		if (!dev->dma_parms)
> +			return ERR_PTR(-ENOMEM);
> +		err = dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
> +		if (err)
> +			return ERR_PTR(err);
> +	}

I'm not sure if this is such a good idea. The DMA provider is responsible
for setting this up. We shouldn't be overwriting this here on the DMA
consumer side. This will just mask the bug that the provider didn't setup
this correctly and might cause bugs on its own if it is not correct. It will
lead to conflicts with DMA providers that have multiple consumers (e.g.
shared DMA core). And also the current assumption is that if a driver
doesn't set this up explicitly the maximum segement size is 65536.

>  
>  	conf = kzalloc(sizeof *conf, GFP_KERNEL);
>  	if (!conf)
> 

