Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53578 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbbHTSaF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 14:30:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] media: atmel-isi: add sanity check for supported formats in set_fmt()
Date: Thu, 20 Aug 2015 21:30:01 +0300
Message-ID: <3666856.U1g2Q81eEo@avalon>
In-Reply-To: <1438745190-21020-3-git-send-email-josh.wu@atmel.com>
References: <1438745190-21020-1-git-send-email-josh.wu@atmel.com> <1438745190-21020-3-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

Thank you for the patch.

On Wednesday 05 August 2015 11:26:29 Josh Wu wrote:
> After adding the format check in set_fmt(), we don't need any format check
> in configure_geometry(). So make configure_geometry() as void type.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
> 
> Changes in v2:
> - new added patch
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 39 ++++++++++++++++++------
>  1 file changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
> b/drivers/media/platform/soc_camera/atmel-isi.c index cb46aec..d0df518
> 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -103,17 +103,19 @@ static u32 isi_readl(struct atmel_isi *isi, u32 reg)
>  	return readl(isi->regs + reg);
>  }
> 
> -static int configure_geometry(struct atmel_isi *isi, u32 width,
> +static void configure_geometry(struct atmel_isi *isi, u32 width,
>  			u32 height, u32 code)
>  {
>  	u32 cfg2;
> 
>  	/* According to sensor's output format to set cfg2 */
>  	switch (code) {
> -	/* YUV, including grey */
> +	default:
> +	/* Grey */
>  	case MEDIA_BUS_FMT_Y8_1X8:
>  		cfg2 = ISI_CFG2_GRAYSCALE;
>  		break;
> +	/* YUV */
>  	case MEDIA_BUS_FMT_VYUY8_2X8:
>  		cfg2 = ISI_CFG2_YCC_SWAP_MODE_3;
>  		break;
> @@ -127,8 +129,6 @@ static int configure_geometry(struct atmel_isi *isi, u32
> width, cfg2 = ISI_CFG2_YCC_SWAP_DEFAULT;
>  		break;
>  	/* RGB, TODO */
> -	default:
> -		return -EINVAL;
>  	}
> 
>  	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> @@ -139,8 +139,29 @@ static int configure_geometry(struct atmel_isi *isi,
> u32 width, cfg2 |= ((height - 1) << ISI_CFG2_IM_VSIZE_OFFSET)
>  			& ISI_CFG2_IM_VSIZE_MASK;
>  	isi_writel(isi, ISI_CFG2, cfg2);
> +}
> 
> -	return 0;
> +static bool is_supported(struct soc_camera_device *icd,
> +		const struct soc_camera_format_xlate *xlate)
> +{
> +	bool ret = true;
> +
> +	switch (xlate->code) {
> +	/* YUV, including grey */
> +	case MEDIA_BUS_FMT_Y8_1X8:
> +	case MEDIA_BUS_FMT_VYUY8_2X8:
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
> +	case MEDIA_BUS_FMT_YVYU8_2X8:
> +	case MEDIA_BUS_FMT_YUYV8_2X8:

I would just return true here and false below, and remove the ret variable.

> +		break;
> +	/* RGB, TODO */
> +	default:
> +		dev_err(icd->parent, "not supported format: %d\n",
> +					xlate->code);

If this can happen when userspace asks for an unsupported format I don't think 
you should print an error message to the kernel log.

> +		ret = false;
> +	}
> +
> +	return ret;
>  }
> 
>  static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
> @@ -391,10 +412,8 @@ static int start_streaming(struct vb2_queue *vq,
> unsigned int count) /* Disable all interrupts */
>  	isi_writel(isi, ISI_INTDIS, (u32)~0UL);
> 
> -	ret = configure_geometry(isi, icd->user_width, icd->user_height,
> +	configure_geometry(isi, icd->user_width, icd->user_height,
>  				icd->current_fmt->code);
> -	if (ret < 0)
> -		return ret;
> 
>  	spin_lock_irq(&isi->lock);
>  	/* Clear any pending interrupt */
> @@ -515,6 +534,10 @@ static int isi_camera_set_fmt(struct soc_camera_device
> *icd, if (mf->code != xlate->code)
>  		return -EINVAL;
> 
> +	/* check with atmel-isi support format */
> +	if (!is_supported(icd, xlate))
> +		return -EINVAL;
> +

S_FMT is supposed to pick a suitable default format when the requested format 
isn't supported. It shouldn't return an error.

>  	pix->width		= mf->width;
>  	pix->height		= mf->height;
>  	pix->field		= mf->field;

-- 
Regards,

Laurent Pinchart

