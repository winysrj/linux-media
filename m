Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33644 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751571AbZBATVQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 14:21:16 -0500
Date: Sun, 1 Feb 2009 20:21:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Magnus <magnus.damm@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] sh_mobile_ceu: SOCAM flags are prepared at itself.
In-Reply-To: <uvdrxm9sd.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902012017230.17985@axis700.grange>
References: <uvdrxm9sd.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Jan 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
>  drivers/media/video/sh_mobile_ceu_camera.c |   27 +++++++++++++++++++++++++--
>  include/media/sh_mobile_ceu.h              |    5 +++--
>  2 files changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 9cde91a..07b7b4c 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -101,6 +101,29 @@ struct sh_mobile_ceu_dev {
>  	const struct soc_camera_data_format *camera_fmt;
>  };
>  
> +static unsigned long make_bus_param(struct sh_mobile_ceu_dev *pcdev)
> +{
> +	unsigned long flags;
> +
> +	flags = SOCAM_SLAVE |

Guys, are you both sure this should be SLAVE, not MASTER? Have you tested 
it? Both tw9910 and ov772x register themselves as MASTER and from the 
datasheet the interface seems to be a typical master parallel to me... I 
think with this patch you would neither be able to use your driver with 
tw9910 nor with ov772x...

Thanks
Guennadi

> +		SOCAM_PCLK_SAMPLE_RISING |
> +		SOCAM_HSYNC_ACTIVE_HIGH |
> +		SOCAM_HSYNC_ACTIVE_LOW |
> +		SOCAM_VSYNC_ACTIVE_HIGH |
> +		SOCAM_VSYNC_ACTIVE_LOW;
> +
> +	if (pcdev->pdata->flags & SH_CEU_FLAG_USE_8BIT_BUS)
> +		flags |= SOCAM_DATAWIDTH_8;
> +
> +	if (pcdev->pdata->flags & SH_CEU_FLAG_USE_16BIT_BUS)
> +		flags |= SOCAM_DATAWIDTH_16;
> +
> +	if (flags & SOCAM_DATAWIDTH_MASK)
> +		return flags;
> +
> +	return 0;
> +}
> +
>  static void ceu_write(struct sh_mobile_ceu_dev *priv,
>  		      unsigned long reg_offs, u32 data)
>  {
> @@ -396,7 +419,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
>  
>  	camera_flags = icd->ops->query_bus_param(icd);
>  	common_flags = soc_camera_bus_param_compatible(camera_flags,
> -						       pcdev->pdata->flags);
> +						       make_bus_param(pcdev));
>  	if (!common_flags)
>  		return -EINVAL;
>  
> @@ -517,7 +540,7 @@ static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd)
>  
>  	camera_flags = icd->ops->query_bus_param(icd);
>  	common_flags = soc_camera_bus_param_compatible(camera_flags,
> -						       pcdev->pdata->flags);
> +						       make_bus_param(pcdev));
>  	if (!common_flags)
>  		return -EINVAL;
>  
> diff --git a/include/media/sh_mobile_ceu.h b/include/media/sh_mobile_ceu.h
> index b5dbefe..0f3524c 100644
> --- a/include/media/sh_mobile_ceu.h
> +++ b/include/media/sh_mobile_ceu.h
> @@ -1,10 +1,11 @@
>  #ifndef __ASM_SH_MOBILE_CEU_H__
>  #define __ASM_SH_MOBILE_CEU_H__
>  
> -#include <media/soc_camera.h>
> +#define SH_CEU_FLAG_USE_8BIT_BUS	(1 << 0) /* use  8bit bus width */
> +#define SH_CEU_FLAG_USE_16BIT_BUS	(1 << 1) /* use 16bit bus width */
>  
>  struct sh_mobile_ceu_info {
> -	unsigned long flags; /* SOCAM_... */
> +	unsigned long flags;
>  };
>  
>  #endif /* __ASM_SH_MOBILE_CEU_H__ */
> -- 
> 1.5.6.3
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
