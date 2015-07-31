Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59057 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbbGaObx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2015 10:31:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media: atmel-isi: setup the ISI_CFG2 register directly
Date: Fri, 31 Jul 2015 17:32:28 +0300
Message-ID: <5801982.V6EPzmjqi1@avalon>
In-Reply-To: <1434537579-23417-1-git-send-email-josh.wu@atmel.com>
References: <1434537579-23417-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

Thank you for the patch.

On Wednesday 17 June 2015 18:39:38 Josh Wu wrote:
> In the function configure_geometry(), we will setup the ISI CFG2
> according to the sensor output format.
> 
> It make no sense to just read back the CFG2 register and just set part
> of it.
> 
> So just set up this register directly makes things simpler.
> Currently only support YUV format from camera sensor.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>

The default value of the register is all 0 so this should be good.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
> b/drivers/media/platform/soc_camera/atmel-isi.c index 9070172..8bc40ca
> 100644
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
> @@ -130,17 +131,10 @@ static int configure_geometry(struct atmel_isi *isi,
> u32 width, }
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

-- 
Regards,

Laurent Pinchart

