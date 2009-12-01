Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:48223 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbZLATao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 14:30:44 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 2 Dec 2009 01:00:40 +0530
Subject: RE: [PATCH 2/2] DaVinci - vpfe capture - converting ccdc to
 platform driver
Message-ID: <19F8576C6E063C45BE387C64729E7394043716AE12@dbde02.ent.ti.com>
References: <1259691333-32164-1-git-send-email-m-karicheri2@ti.com>
 <1259691333-32164-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1259691333-32164-2-git-send-email-m-karicheri2@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Karicheri, Muralidharan
> Sent: Tuesday, December 01, 2009 11:46 PM
> To: linux-media@vger.kernel.org; hverkuil@xs4all.nl;
> khilman@deeprootsystems.com
> Cc: davinci-linux-open-source@linux.davincidsp.com; Hiremath,
> Vaibhav; Karicheri, Muralidharan
> Subject: [PATCH 2/2] DaVinci - vpfe capture - converting ccdc to
> platform driver
> 
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
> 
> This is the platform part for converting ccdc to platform driver.
> 
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to linux-davinci tree
>  arch/arm/mach-davinci/dm355.c  |   27 +++++++++++++++------------
>  arch/arm/mach-davinci/dm644x.c |   18 +++++++++++++++++-
>  2 files changed, 32 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-
> davinci/dm355.c
> index dedf4d4..045cb0d 100644
> --- a/arch/arm/mach-davinci/dm355.c
> +++ b/arch/arm/mach-davinci/dm355.c
> @@ -701,6 +701,10 @@ static struct resource vpfe_resources[] = {
>  		.end            = IRQ_VDINT1,
>  		.flags          = IORESOURCE_IRQ,
>  	},
> +};
> +
> +static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
> +static struct resource dm355_ccdc_resource[] = {
>  	/* CCDC Base address */
>  	{
>  		.flags          = IORESOURCE_MEM,
> @@ -708,8 +712,17 @@ static struct resource vpfe_resources[] = {
>  		.end            = 0x01c70600 + 0x1ff,
>  	},
>  };
> +static struct platform_device dm355_ccdc_dev = {
> +	.name           = "dm355_ccdc",
> +	.id             = -1,
> +	.num_resources  = ARRAY_SIZE(dm355_ccdc_resource),
> +	.resource       = dm355_ccdc_resource,
> +	.dev = {
> +		.dma_mask               = &vpfe_capture_dma_mask,
> +		.coherent_dma_mask      = DMA_BIT_MASK(32),
> +	},
> +};
> 
> -static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
>  static struct platform_device vpfe_capture_dev = {
>  	.name		= CAPTURE_DRV_NAME,
>  	.id		= -1,
> @@ -860,17 +873,7 @@ static int __init dm355_init_devices(void)
>  	davinci_cfg_reg(DM355_INT_EDMA_CC);
>  	platform_device_register(&dm355_edma_device);
>  	platform_device_register(&dm355_vpss_device);
> -	/*
> -	 * setup Mux configuration for vpfe input and register
> -	 * vpfe capture platform device
> -	 */
> -	davinci_cfg_reg(DM355_VIN_PCLK);
> -	davinci_cfg_reg(DM355_VIN_CAM_WEN);
> -	davinci_cfg_reg(DM355_VIN_CAM_VD);
> -	davinci_cfg_reg(DM355_VIN_CAM_HD);
> -	davinci_cfg_reg(DM355_VIN_YIN_EN);
> -	davinci_cfg_reg(DM355_VIN_CINL_EN);
> -	davinci_cfg_reg(DM355_VIN_CINH_EN);
[Hiremath, Vaibhav] Why have you removed mux configuration from here and moved to CCDC driver? Any specific reason?

> +	platform_device_register(&dm355_ccdc_dev);
>  	platform_device_register(&vpfe_capture_dev);
> 
>  	return 0;
> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-
> davinci/dm644x.c
> index 2cd0081..982be1f 100644
> --- a/arch/arm/mach-davinci/dm644x.c
> +++ b/arch/arm/mach-davinci/dm644x.c
> @@ -612,6 +612,11 @@ static struct resource vpfe_resources[] = {
>  		.end            = IRQ_VDINT1,
>  		.flags          = IORESOURCE_IRQ,
>  	},
> +};
> +
> +static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
> +static struct resource dm644x_ccdc_resource[] = {
> +	/* CCDC Base address */
>  	{
>  		.start          = 0x01c70400,
>  		.end            = 0x01c70400 + 0xff,
> @@ -619,7 +624,17 @@ static struct resource vpfe_resources[] = {
>  	},
>  };
> 
> -static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
> +static struct platform_device dm644x_ccdc_dev = {
> +	.name           = "dm644x_ccdc",
> +	.id             = -1,
> +	.num_resources  = ARRAY_SIZE(dm644x_ccdc_resource),
> +	.resource       = dm644x_ccdc_resource,
> +	.dev = {
> +		.dma_mask               = &vpfe_capture_dma_mask,
> +		.coherent_dma_mask      = DMA_BIT_MASK(32),
> +	},
> +};
> +
>  static struct platform_device vpfe_capture_dev = {
>  	.name		= CAPTURE_DRV_NAME,
>  	.id		= -1,
> @@ -772,6 +787,7 @@ static int __init dm644x_init_devices(void)
>  	platform_device_register(&dm644x_edma_device);
>  	platform_device_register(&dm644x_emac_device);
>  	platform_device_register(&dm644x_vpss_device);
> +	platform_device_register(&dm644x_ccdc_dev);
>  	platform_device_register(&vpfe_capture_dev);
> 
>  	return 0;
> --
> 1.6.0.4

