Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51125 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753151AbZKTJs4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 04:48:56 -0500
Date: Fri, 20 Nov 2009 10:49:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux-V4L2 <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc-camera: sh_mobile_ceu_camera: Add support sync
 polarity selection
In-Reply-To: <ueintq5ee.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0911201029330.4438@axis700.grange>
References: <ueintq5ee.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 20 Nov 2009, Kuninori Morimoto wrote:

> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/sh_mobile_ceu_camera.c |   25 +++++++++++++++++++++++++
>  include/media/sh_mobile_ceu.h              |    3 +++
>  2 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 746aed0..e5cee0f 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -660,6 +660,31 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
>  	if (!common_flags)
>  		return -EINVAL;
>  
> +	/* Make choises, based on platform preferences */
> +	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
> +	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
> +		if (pcdev->pdata->flags & SH_CEU_FLAG_HSP)
> +			common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH;
> +		else
> +			common_flags &= ~SOCAM_HSYNC_ACTIVE_LOW;
> +	}

Right, that's exactly what I mean, thanks! And, I presume, it fixes your 
problem with tm9910, right? The only change to this patch: please, rename 
macros. From the above it looks like "if SH_CEU_FLAG_HSP is set platform 
wanted HSYNC active low." In the PXA case HSP, VSP, and PCP are names for 
respective fields in the datasheet, and, as I just notice the datasheet 
has a bug describing them. In the descriptive part it says:

HSP: set => HSYNC active high, clear => HSYNC active low
VSP: set => VSYNC active low, clear => VSYNC active high
PCP: set => PIXCLK falling edge, clear => PIXCLK rising edge

But then in register field description it says both HSP and VSP if set are 
active low... And this is also what the driver implements, and it seems to 
work.

In any case, this confirms, how important good name choice is:-) Now, HSP, 
etc. have nothing to do with SH, on CEU these fields are called HDPOL and 
VDPOL. But I would suggest some descriptive names, like 
SH_CEU_FLAG_HSYNC_HIGH or similar.

> +
> +	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
> +	    (common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
> +		if (pcdev->pdata->flags & SH_CEU_FLAG_VSP)
> +			common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
> +		else
> +			common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
> +	}
> +
> +	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
> +	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
> +		if (pcdev->pdata->flags & SH_CEU_FLAG_PCP)
> +			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
> +		else
> +			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
> +	}

This is not needed, CEU only supports sampling on PCLK rising edge.

> +
>  	ret = icd->ops->set_bus_param(icd, common_flags);
>  	if (ret < 0)
>  		return ret;
> diff --git a/include/media/sh_mobile_ceu.h b/include/media/sh_mobile_ceu.h
> index 0f3524c..3726daf 100644
> --- a/include/media/sh_mobile_ceu.h
> +++ b/include/media/sh_mobile_ceu.h
> @@ -3,6 +3,9 @@
>  
>  #define SH_CEU_FLAG_USE_8BIT_BUS	(1 << 0) /* use  8bit bus width */
>  #define SH_CEU_FLAG_USE_16BIT_BUS	(1 << 1) /* use 16bit bus width */
> +#define SH_CEU_FLAG_PCP			(1 << 2) /* Pixel clock polarity */

ditto - this one is not needed.

> +#define SH_CEU_FLAG_HSP			(1 << 3) /* Horizontal sync polarity */
> +#define SH_CEU_FLAG_VSP			(1 << 4) /* Vertical sync polarity */
>  
>  struct sh_mobile_ceu_info {
>  	unsigned long flags;
> -- 
> 1.6.3.3
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
