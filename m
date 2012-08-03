Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42815 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab2HCORh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 10:17:37 -0400
Date: Fri, 3 Aug 2012 16:17:33 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH 2/2 v2] i.MX27: Visstrim_M10: Add support for
 deinterlacing driver.
Message-ID: <20120803141733.GW1451@pengutronix.de>
References: <1342092929-31590-1-git-send-email-javier.martin@vista-silicon.com>
 <1342092929-31590-2-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342092929-31590-2-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 12, 2012 at 01:35:29PM +0200, Javier Martin wrote:
> Visstrim_M10 have a tvp5150 whose video output must be deinterlaced.
> The new mem2mem deinterlacing driver is very useful for that purpose.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
> Changes since v1:
>  - Removed commented out code.
> 
> ---
>  arch/arm/mach-imx/mach-imx27_visstrim_m10.c |   27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> index 214e4ff..dbef59d 100644
> --- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> +++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> @@ -232,7 +232,7 @@ static void __init visstrim_camera_init(void)
>  static void __init visstrim_reserve(void)
>  {
>  	/* reserve 4 MiB for mx2-camera */
> -	mx2_camera_base = arm_memblock_steal(2 * MX2_CAMERA_BUF_SIZE,
> +	mx2_camera_base = arm_memblock_steal(3 * MX2_CAMERA_BUF_SIZE,
>  			MX2_CAMERA_BUF_SIZE);
>  }
>  
> @@ -419,6 +419,30 @@ static void __init visstrim_coda_init(void)
>  		return;
>  }
>  
> +/* DMA deinterlace */
> +static struct platform_device visstrim_deinterlace = {
> +	.name = "m2m-deinterlace",
> +	.id = 0,
> +};
> +
> +static void __init visstrim_deinterlace_init(void)
> +{
> +	int ret = -ENOMEM;
> +	struct platform_device *pdev = &visstrim_deinterlace;
> +	int dma;
> +
> +	ret = platform_device_register(pdev);

ret is unused.

Better use platform_device_register_simple().

> +
> +	dma = dma_declare_coherent_memory(&pdev->dev,
> +					  mx2_camera_base + 2 * MX2_CAMERA_BUF_SIZE,
> +					  mx2_camera_base + 2 * MX2_CAMERA_BUF_SIZE,
> +					  MX2_CAMERA_BUF_SIZE,
> +					  DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);

Shouldn't this be done before registering the device?

> +	if (!(dma & DMA_MEMORY_MAP))
> +		return;
> +}

if (!flag) return; else return ?

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
