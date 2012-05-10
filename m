Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34784 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab2EJWhQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 18:37:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 10/9] sh_mobile_ceu_camera: Support user-configurable line stride
Date: Fri, 11 May 2012 00:37:19 +0200
Message-ID: <2953286.QxYqXLRVN6@avalon>
In-Reply-To: <Pine.LNX.4.64.1205092355260.8599@axis700.grange>
References: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com> <1332328565-6260-1-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1205092355260.8599@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 09 May 2012 23:56:49 Guennadi Liakhovetski wrote:
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> In image mode, the CEU allows configurable line strides up to 8188
> pixels.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> [g.liakhovetski@gmx.de: unify sh_mobile_ceu_set_rect() in data-fetch mode]
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> Laurent, are you ok with this version?

It looks good to me, thank you.

>  drivers/media/video/sh_mobile_ceu_camera.c |   33 +++++++++++++------------
>  1 files changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c
> b/drivers/media/video/sh_mobile_ceu_camera.c index 79bec15..2ffeb21 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -342,19 +342,15 @@ static int sh_mobile_ceu_capture(struct
> sh_mobile_ceu_dev *pcdev)
> 
>  	ceu_write(pcdev, top1, phys_addr_top);
>  	if (V4L2_FIELD_NONE != pcdev->field) {
> -		if (planar)
> -			phys_addr_bottom = phys_addr_top + icd->user_width;
> -		else
> -			phys_addr_bottom = phys_addr_top + icd->bytesperline;
> +		phys_addr_bottom = phys_addr_top + icd->bytesperline;
>  		ceu_write(pcdev, bottom1, phys_addr_bottom);
>  	}
> 
>  	if (planar) {
> -		phys_addr_top += icd->user_width *
> -			icd->user_height;
> +		phys_addr_top += icd->bytesperline * icd->user_height;
>  		ceu_write(pcdev, top2, phys_addr_top);
>  		if (V4L2_FIELD_NONE != pcdev->field) {
> -			phys_addr_bottom = phys_addr_top + icd->user_width;
> +			phys_addr_bottom = phys_addr_top + icd->bytesperline;
>  			ceu_write(pcdev, bottom2, phys_addr_bottom);
>  		}
>  	}
> @@ -681,10 +677,7 @@ static void sh_mobile_ceu_set_rect(struct
> soc_camera_device *icd) in_width *= 2;
>  			left_offset *= 2;
>  		}
> -		cdwdr_width = width;
>  	} else {
> -		int bytes_per_line = soc_mbus_bytes_per_line(width,
> -						icd->current_fmt->host_fmt);
>  		unsigned int w_factor;
> 
>  		switch (icd->current_fmt->host_fmt->packing) {
> @@ -697,13 +690,10 @@ static void sh_mobile_ceu_set_rect(struct
> soc_camera_device *icd)
> 
>  		in_width = cam->width * w_factor;
>  		left_offset *= w_factor;
> -
> -		if (bytes_per_line < 0)
> -			cdwdr_width = width;
> -		else
> -			cdwdr_width = bytes_per_line;
>  	}
> 
> +	cdwdr_width = icd->bytesperline;
> +
>  	height = icd->user_height;
>  	in_height = cam->height;
>  	if (V4L2_FIELD_NONE != pcdev->field) {
> @@ -1848,6 +1838,8 @@ static int sh_mobile_ceu_set_fmt(struct
> soc_camera_device *icd, return 0;
>  }
> 
> +#define CEU_CHDW_MAX	8188U	/* Maximum line stride */
> +
>  static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
>  				 struct v4l2_format *f)
>  {
> @@ -1926,10 +1918,20 @@ static int sh_mobile_ceu_try_fmt(struct
> soc_camera_device *icd, pix->width = width;
>  		if (mf.height > height)
>  			pix->height = height;
> +
> +		pix->bytesperline = max(pix->bytesperline, pix->width);
> +		pix->bytesperline = min(pix->bytesperline, CEU_CHDW_MAX);
> +		pix->bytesperline &= ~3;
> +		break;
> +
> +	default:
> +		/* Configurable stride isn't supported in pass-through mode. */
> +		pix->bytesperline  = 0;
>  	}
> 
>  	pix->width	&= ~3;
>  	pix->height	&= ~3;
> +	pix->sizeimage	= 0;
> 
>  	dev_geo(icd->parent, "%s(): return %d, fmt 0x%x, %ux%u\n",
>  		__func__, ret, pix->pixelformat, pix->width, pix->height);
> @@ -2148,6 +2150,7 @@ static int __devinit sh_mobile_ceu_probe(struct
> platform_device *pdev) pcdev->ici.nr = pdev->id;
>  	pcdev->ici.drv_name = dev_name(&pdev->dev);
>  	pcdev->ici.ops = &sh_mobile_ceu_host_ops;
> +	pcdev->ici.capabilities = SOCAM_HOST_CAP_STRIDE;
> 
>  	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
>  	if (IS_ERR(pcdev->alloc_ctx)) {
-- 
Regards,

Laurent Pinchart

