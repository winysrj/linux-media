Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:35160 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab0ALA2S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 19:28:18 -0500
Received: by ywh6 with SMTP id 6so21996673ywh.4
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2010 16:28:17 -0800 (PST)
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl, davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH - v4 4/4] DaVinci-vpfe-capture-converting-ccdc-drivers-to-platform-drivers
References: <1263252977-27457-1-git-send-email-m-karicheri2@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Mon, 11 Jan 2010 16:28:15 -0800
In-Reply-To: <1263252977-27457-1-git-send-email-m-karicheri2@ti.com> (m-karicheri2@ti.com's message of "Mon\, 11 Jan 2010 18\:36\:14 -0500")
Message-ID: <87ocl0jheo.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

m-karicheri2@ti.com writes:

> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>
> Following are the changes from v3 :-
>
>  - added ccdc clocks through clk_add_alias() calls

All the 'changes from vN' comments are not really relevant to the
final git history.  Please add them after the '---' as well.  Thanks.

> This combines the two patches sent earlier to change the clock configuration
> and converting ccdc drivers to platform drivers. This has updated comments
> against v2 of these patches. Two new clocks "master" and "slave" are defined for ccdc driver
> as per comments from Kevin Hilman.

This also isn't really relevant for the final git history.

> This adds platform code for ccdc driver on DM355 and DM6446.

And this isn't an adequate description of all the things happening in
this patch.  You need to describe not only what is happening but why
for all of the below:

- new CCDC platform_devices
- new clock aliases for CCDC clocks
- pin-mux setup hook now in platform_data

Kevin

> Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Re-sending the patches based on Kevin's comments.
> Applies to Linus tree
>  arch/arm/mach-davinci/dm355.c  |   43 +++++++++++++++++++++++++++------------
>  arch/arm/mach-davinci/dm644x.c |   21 ++++++++++++++++++-
>  2 files changed, 50 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
> index dedf4d4..d84e854 100644
> --- a/arch/arm/mach-davinci/dm355.c
> +++ b/arch/arm/mach-davinci/dm355.c
> @@ -125,7 +125,6 @@ static struct clk vpss_slave_clk = {
>  	.lpsc = DAVINCI_LPSC_VPSSSLV,
>  };
>  
> -
>  static struct clk clkout1_clk = {
>  	.name = "clkout1",
>  	.parent = &pll1_aux_clk,
> @@ -665,6 +664,17 @@ static struct platform_device dm355_asp1_device = {
>  	.resource	= dm355_asp1_resources,
>  };
>  
> +static void dm355_ccdc_setup_pinmux(void)
> +{
> +	davinci_cfg_reg(DM355_VIN_PCLK);
> +	davinci_cfg_reg(DM355_VIN_CAM_WEN);
> +	davinci_cfg_reg(DM355_VIN_CAM_VD);
> +	davinci_cfg_reg(DM355_VIN_CAM_HD);
> +	davinci_cfg_reg(DM355_VIN_YIN_EN);
> +	davinci_cfg_reg(DM355_VIN_CINL_EN);
> +	davinci_cfg_reg(DM355_VIN_CINH_EN);
> +}
> +
>  static struct resource dm355_vpss_resources[] = {
>  	{
>  		/* VPSS BL Base address */
> @@ -701,6 +711,10 @@ static struct resource vpfe_resources[] = {
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
> @@ -708,8 +722,18 @@ static struct resource vpfe_resources[] = {
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
> +		.platform_data		= dm355_ccdc_setup_pinmux,
> +	},
> +};
>  
> -static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
>  static struct platform_device vpfe_capture_dev = {
>  	.name		= CAPTURE_DRV_NAME,
>  	.id		= -1,
> @@ -857,20 +881,13 @@ static int __init dm355_init_devices(void)
>  	if (!cpu_is_davinci_dm355())
>  		return 0;
>  
> +	/* Add ccdc clock aliases */
> +	clk_add_alias("master", dm355_ccdc_dev.name, "vpss_master", NULL);
> +	clk_add_alias("slave", dm355_ccdc_dev.name, "vpss_master", NULL);
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
> +	platform_device_register(&dm355_ccdc_dev);
>  	platform_device_register(&vpfe_capture_dev);
>  
>  	return 0;
> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
> index 2cd0081..92aeb56 100644
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
> @@ -769,9 +784,13 @@ static int __init dm644x_init_devices(void)
>  	if (!cpu_is_davinci_dm644x())
>  		return 0;
>  
> +	/* Add ccdc clock aliases */
> +	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
> +	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
>  	platform_device_register(&dm644x_edma_device);
>  	platform_device_register(&dm644x_emac_device);
>  	platform_device_register(&dm644x_vpss_device);
> +	platform_device_register(&dm644x_ccdc_dev);
>  	platform_device_register(&vpfe_capture_dev);
>  
>  	return 0;
> -- 
> 1.6.0.4
