Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0051.outbound.protection.outlook.com ([104.47.38.51]:59456
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755898AbeBPRGy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 12:06:54 -0500
Date: Fri, 16 Feb 2018 09:06:44 -0800
From: Hyun Kwon <hyun.kwon@xilinx.com>
To: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        Satish Kumar Nagireddy <SATISHNA@xilinx.com>
Subject: Re: [PATCH v3 9/9] v4l: xilinx: dma: Get scaling and padding factor
 to calculate DMA params
Message-ID: <20180216170643.GC9719@smtp.xilinx.com>
References: <1518676980-19750-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1518676980-19750-1-git-send-email-satishna@xilinx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Satish,

Thanks for that patch.

On Wed, 2018-02-14 at 22:43:00 -0800, Satish Kumar Nagireddy wrote:
> Get multiplying factor to calculate bpp especially
> in case of 10 bit formats.
> Get multiplying factor to calculate padding width
> 
> Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
> ---
>  drivers/media/platform/xilinx/xilinx-dma.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> index 664981b..3c2fd02 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -417,6 +417,7 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
>  	struct xvip_dma_buffer *buf = to_xvip_dma_buffer(vbuf);
>  	struct dma_async_tx_descriptor *desc;
>  	u32 flags, luma_size;
> +	u32 padding_factor_nume, padding_factor_deno, bpl_nume, bpl_deno;
>  	dma_addr_t addr = vb2_dma_contig_plane_dma_addr(vb, 0);
>  
>  	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> @@ -442,8 +443,15 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
>  		struct v4l2_pix_format_mplane *pix_mp;
>  
>  		pix_mp = &dma->format.fmt.pix_mp;
> +		xvip_width_padding_factor(pix_mp->pixelformat,
> +					  &padding_factor_nume,
> +					  &padding_factor_deno);
> +		xvip_bpl_scaling_factor(pix_mp->pixelformat, &bpl_nume,
> +					&bpl_deno);
>  		dma->xt.frame_size = dma->fmtinfo->num_planes;
> -		dma->sgl[0].size = pix_mp->width * dma->fmtinfo->bpl_factor;
> +		dma->sgl[0].size = (pix_mp->width * dma->fmtinfo->bpl_factor *
> +				    padding_factor_nume * bpl_nume) /
> +				    (padding_factor_deno * bpl_deno);

We don't want to lose fractional here. DIV_ROUND_UP()? Then just nit, my personal
preference is not to use extra parenthesis where order is clear.

>  		dma->sgl[0].icg = pix_mp->plane_fmt[0].bytesperline -
>  							dma->sgl[0].size;
>  		dma->xt.numf = pix_mp->height;
> @@ -472,8 +480,15 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
>  		struct v4l2_pix_format *pix;
>  
>  		pix = &dma->format.fmt.pix;
> +		xvip_width_padding_factor(pix->pixelformat,
> +					  &padding_factor_nume,
> +					  &padding_factor_deno);
> +		xvip_bpl_scaling_factor(pix->pixelformat, &bpl_nume,
> +					&bpl_deno);
>  		dma->xt.frame_size = dma->fmtinfo->num_planes;
> -		dma->sgl[0].size = pix->width * dma->fmtinfo->bpl_factor;
> +		dma->sgl[0].size = (pix->width * dma->fmtinfo->bpl_factor *
> +				    padding_factor_nume * bpl_nume) /
> +				    (padding_factor_deno * bpl_deno);
>  		dma->sgl[0].icg = pix->bytesperline - dma->sgl[0].size;
>  		dma->xt.numf = pix->height;
>  		dma->sgl[0].dst_icg = dma->sgl[0].size;
> @@ -682,6 +697,8 @@ __xvip_dma_try_format(struct xvip_dma *dma,
>  	unsigned int align;
>  	unsigned int bpl;
>  	unsigned int i, hsub, vsub, plane_width, plane_height;
> +	unsigned int padding_factor_nume, padding_factor_deno;
> +	unsigned int bpl_nume, bpl_deno;
>  
>  	/* Retrieve format information and select the default format if the
>  	 * requested format isn't supported.
> @@ -694,6 +711,10 @@ __xvip_dma_try_format(struct xvip_dma *dma,
>  	if (IS_ERR(info))
>  		info = xvip_get_format_by_fourcc(XVIP_DMA_DEF_FORMAT);
>  
> +	xvip_width_padding_factor(info->fourcc, &padding_factor_nume,
> +				  &padding_factor_deno);
> +	xvip_bpl_scaling_factor(info->fourcc, &bpl_nume, &bpl_deno);
> +
>  	/* The transfer alignment requirements are expressed in bytes. Compute
>  	 * the minimum and maximum values, clamp the requested width and convert
>  	 * it back to pixels.
> @@ -737,7 +758,9 @@ __xvip_dma_try_format(struct xvip_dma *dma,
>  			for (i = 0; i < info->num_planes; i++) {
>  				plane_width = pix_mp->width / (i ? hsub : 1);
>  				plane_height = pix_mp->height / (i ? vsub : 1);
> -				min_bpl = plane_width * info->bpl_factor;
> +				min_bpl = (plane_width * info->bpl_factor *
> +					   padding_factor_nume * bpl_nume) /
> +					   (padding_factor_deno * bpl_deno);

Ditto as above.

This can be squashed into the previous patch that addsfunctions, but I let you decide.
Please consider if use of macro-pixel or any other approach can simplify this change.

Thanks,
-hyun


>  				max_bpl = rounddown(XVIP_DMA_MAX_WIDTH,
>  						    dma->align);
>  				bpl = pix_mp->plane_fmt[i].bytesperline;
> -- 
> 2.7.4
> 
