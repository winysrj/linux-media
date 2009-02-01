Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56989 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751264AbZBATMX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 14:12:23 -0500
Date: Sun, 1 Feb 2009 20:12:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Magnus <magnus.damm@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] sh_mobile_ceu: Add FLDPOL operation
In-Reply-To: <uskn1m9qt.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902012008530.17985@axis700.grange>
References: <uskn1m9qt.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Jan 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/sh_mobile_ceu_camera.c |    7 +++++++
>  include/media/sh_mobile_ceu.h              |    2 ++
>  2 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 07b7b4c..366e5f5 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -118,6 +118,12 @@ static unsigned long make_bus_param(struct sh_mobile_ceu_dev *pcdev)
>  	if (pcdev->pdata->flags & SH_CEU_FLAG_USE_16BIT_BUS)
>  		flags |= SOCAM_DATAWIDTH_16;
>  
> +	if (pcdev->pdata->flags & SH_CEU_FLAG_USE_FLDPOL_HIGH)
> +		flags |= SOCAM_FLDPOL_ACTIVE_HIGH;
> +
> +	if (pcdev->pdata->flags & SH_CEU_FLAG_USE_FLDPOL_LOW)
> +		flags |= SOCAM_FLDPOL_ACTIVE_LOW;
> +
>  	if (flags & SOCAM_DATAWIDTH_MASK)
>  		return flags;
>  
> @@ -474,6 +480,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
>  	    icd->current_fmt->fourcc == V4L2_PIX_FMT_NV61)
>  		value ^= 0x00000100; /* swap U, V to change from NV1x->NVx1 */
>  
> +	value |= common_flags & SOCAM_FLDPOL_ACTIVE_LOW ? 1 << 16 : 0;
>  	value |= common_flags & SOCAM_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
>  	value |= common_flags & SOCAM_HSYNC_ACTIVE_LOW ? 1 << 0 : 0;
>  	value |= buswidth == 16 ? 1 << 12 : 0;

Why are you basing your decision to use active low or high level of the 
Field ID signal upon the platform data? Doesn't it depend on the 
configuration of the connected device, and, possibly, an inverter between 
them? So, looks like it should be handled in exactly the same way as all 
other signals - negotiate with the connected device (sensor / decoder / 
...) and apply platform-defined inverters if any?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
