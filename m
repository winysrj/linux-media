Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59633 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbbH3ItH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2015 04:49:07 -0400
Date: Sun, 30 Aug 2015 10:48:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media: atmel-isi: setup the ISI_CFG2 register directly
In-Reply-To: <1434537579-23417-1-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1508301019340.29683@axis700.grange>
References: <1434537579-23417-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Wed, 17 Jun 2015, Josh Wu wrote:

> In the function configure_geometry(), we will setup the ISI CFG2
> according to the sensor output format.
> 
> It make no sense to just read back the CFG2 register and just set part
> of it.
> 
> So just set up this register directly makes things simpler.

Simpler doesn't necessarily mean better or more correct:) There are other 
fields in that register and currently the driver preserves them, with this 
patch you overwrite them with 0. 0 happens to be the reset value of that 
register. So, you should at least mention that in this patch description, 
just saying "simpler" doesn't convince me. So, at least I'd modify that, I 
can do that myself. But in general I'm not even sure why this patch is 
needed. Yes, currently those fields of that register are unused, so, we 
can assume they stay at their reset values. But firstly the hardware can 
change and at some point the reset value can change, or those other fields 
will get set indirectly by something. Or the driver will change at some 
point to support more fields of that register and then this code will have 
to be changed again. So, I'd ask you again - do you really want this 
patch? If you insist - I'll take it, but I'd add the "reset value" 
reasoning. Otherwise maybe just drop it?

Thanks
Guennadi

> Currently only support YUV format from camera sensor.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 9070172..8bc40ca 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -105,24 +105,25 @@ static u32 isi_readl(struct atmel_isi *isi, u32 reg)
>  static int configure_geometry(struct atmel_isi *isi, u32 width,
>  			u32 height, u32 code)
>  {
> -	u32 cfg2, cr;
> +	u32 cfg2;
>  
> +	/* According to sensor's output format to set cfg2 */
>  	switch (code) {
>  	/* YUV, including grey */
>  	case MEDIA_BUS_FMT_Y8_1X8:
> -		cr = ISI_CFG2_GRAYSCALE;
> +		cfg2 = ISI_CFG2_GRAYSCALE;
>  		break;
>  	case MEDIA_BUS_FMT_VYUY8_2X8:
> -		cr = ISI_CFG2_YCC_SWAP_MODE_3;
> +		cfg2 = ISI_CFG2_YCC_SWAP_MODE_3;
>  		break;
>  	case MEDIA_BUS_FMT_UYVY8_2X8:
> -		cr = ISI_CFG2_YCC_SWAP_MODE_2;
> +		cfg2 = ISI_CFG2_YCC_SWAP_MODE_2;
>  		break;
>  	case MEDIA_BUS_FMT_YVYU8_2X8:
> -		cr = ISI_CFG2_YCC_SWAP_MODE_1;
> +		cfg2 = ISI_CFG2_YCC_SWAP_MODE_1;
>  		break;
>  	case MEDIA_BUS_FMT_YUYV8_2X8:
> -		cr = ISI_CFG2_YCC_SWAP_DEFAULT;
> +		cfg2 = ISI_CFG2_YCC_SWAP_DEFAULT;
>  		break;
>  	/* RGB, TODO */
>  	default:
> @@ -130,17 +131,10 @@ static int configure_geometry(struct atmel_isi *isi, u32 width,
>  	}
>  
>  	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> -
> -	cfg2 = isi_readl(isi, ISI_CFG2);
> -	/* Set YCC swap mode */
> -	cfg2 &= ~ISI_CFG2_YCC_SWAP_MODE_MASK;
> -	cfg2 |= cr;
>  	/* Set width */
> -	cfg2 &= ~(ISI_CFG2_IM_HSIZE_MASK);
>  	cfg2 |= ((width - 1) << ISI_CFG2_IM_HSIZE_OFFSET) &
>  			ISI_CFG2_IM_HSIZE_MASK;
>  	/* Set height */
> -	cfg2 &= ~(ISI_CFG2_IM_VSIZE_MASK);
>  	cfg2 |= ((height - 1) << ISI_CFG2_IM_VSIZE_OFFSET)
>  			& ISI_CFG2_IM_VSIZE_MASK;
>  	isi_writel(isi, ISI_CFG2, cfg2);
> -- 
> 1.9.1
> 
