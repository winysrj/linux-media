Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f189.google.com ([209.85.222.189]:59038 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab0BDVco (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2010 16:32:44 -0500
Received: by pzk27 with SMTP id 27so3311691pzk.33
        for <linux-media@vger.kernel.org>; Thu, 04 Feb 2010 13:32:43 -0800 (PST)
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH v3 6/6] DaVinci - Adding platform & board changes for vpfe capture on DM365
References: <1265063933-2425-1-git-send-email-m-karicheri2@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Thu, 04 Feb 2010 13:32:39 -0800
In-Reply-To: <1265063933-2425-1-git-send-email-m-karicheri2@ti.com> (m-karicheri2@ti.com's message of "Mon\,  1 Feb 2010 17\:38\:53 -0500")
Message-ID: <877hqs3cw8.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

m-karicheri2@ti.com writes:

> From: Murali Karicheri <m-karicheri2@ti.com>
>
> This patch adds following changes:-
> 	1) add sub device configuration data for TVP5146 used by vpfe capture
> 	2) registers platform devices for vpfe_capture, isif and vpss
> 	3) defines hardware resources for the devices listed under 2)
> 	4) defines clock aliase for isif driver
> 	5) adding setup_pinmux() for isif
>
> Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>

Mauro, please go ahead and merge this via your tree along with the
rest of the series.

Thanks,

Kevin


> ---
> Applies to linux-next of v4l-dvb
>  - removing some white spaces and re-resending........
>  - updated to add clock aliase (v3) and rebased to latest for merge
>  - review comments incorporated (v2)
>  arch/arm/mach-davinci/board-dm365-evm.c    |   71 +++++++++++++++++++
>  arch/arm/mach-davinci/dm365.c              |  102 +++++++++++++++++++++++++++-
>  arch/arm/mach-davinci/include/mach/dm365.h |    2 +
>  3 files changed, 174 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
> index b476395..38e9033 100644
> --- a/arch/arm/mach-davinci/board-dm365-evm.c
> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> @@ -37,6 +37,8 @@
>  #include <mach/nand.h>
>  #include <mach/keyscan.h>
>  
> +#include <media/tvp514x.h>
> +
>  static inline int have_imager(void)
>  {
>  	/* REVISIT when it's supported, trigger via Kconfig */
> @@ -306,6 +308,73 @@ static void dm365evm_mmc_configure(void)
>  	davinci_cfg_reg(DM365_SD1_DATA0);
>  }
>  
> +static struct tvp514x_platform_data tvp5146_pdata = {
> +	.clk_polarity = 0,
> +	.hs_polarity = 1,
> +	.vs_polarity = 1
> +};
> +
> +#define TVP514X_STD_ALL        (V4L2_STD_NTSC | V4L2_STD_PAL)
> +/* Inputs available at the TVP5146 */
> +static struct v4l2_input tvp5146_inputs[] = {
> +	{
> +		.index = 0,
> +		.name = "Composite",
> +		.type = V4L2_INPUT_TYPE_CAMERA,
> +		.std = TVP514X_STD_ALL,
> +	},
> +	{
> +		.index = 1,
> +		.name = "S-Video",
> +		.type = V4L2_INPUT_TYPE_CAMERA,
> +		.std = TVP514X_STD_ALL,
> +	},
> +};
> +
> +/*
> + * this is the route info for connecting each input to decoder
> + * ouput that goes to vpfe. There is a one to one correspondence
> + * with tvp5146_inputs
> + */
> +static struct vpfe_route tvp5146_routes[] = {
> +	{
> +		.input = INPUT_CVBS_VI2B,
> +		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
> +	},
> +{
> +		.input = INPUT_SVIDEO_VI2C_VI1C,
> +		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
> +	},
> +};
> +
> +static struct vpfe_subdev_info vpfe_sub_devs[] = {
> +	{
> +		.name = "tvp5146",
> +		.grp_id = 0,
> +		.num_inputs = ARRAY_SIZE(tvp5146_inputs),
> +		.inputs = tvp5146_inputs,
> +		.routes = tvp5146_routes,
> +		.can_route = 1,
> +		.ccdc_if_params = {
> +			.if_type = VPFE_BT656,
> +			.hdpol = VPFE_PINPOL_POSITIVE,
> +			.vdpol = VPFE_PINPOL_POSITIVE,
> +		},
> +		.board_info = {
> +			I2C_BOARD_INFO("tvp5146", 0x5d),
> +			.platform_data = &tvp5146_pdata,
> +		},
> +	},
> +};
> +
> +static struct vpfe_config vpfe_cfg = {
> +	.num_subdevs = ARRAY_SIZE(vpfe_sub_devs),
> +	.sub_devs = vpfe_sub_devs,
> +	.i2c_adapter_id = 1,
> +	.card_name = "DM365 EVM",
> +	.ccdc = "ISIF",
> +};
> +
>  static void __init evm_init_i2c(void)
>  {
>  	davinci_init_i2c(&i2c_pdata);
> @@ -497,6 +566,8 @@ static struct davinci_uart_config uart_config __initdata = {
>  
>  static void __init dm365_evm_map_io(void)
>  {
> +	/* setup input configuration for VPFE input devices */
> +	dm365_set_vpfe_config(&vpfe_cfg);
>  	dm365_init();
>  }
>  
> diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
> index f53735c..ce9da43 100644
> --- a/arch/arm/mach-davinci/dm365.c
> +++ b/arch/arm/mach-davinci/dm365.c
> @@ -1008,6 +1008,97 @@ void __init dm365_init(void)
>  	davinci_common_init(&davinci_soc_info_dm365);
>  }
>  
> +static struct resource dm365_vpss_resources[] = {
> +	{
> +		/* VPSS ISP5 Base address */
> +		.name           = "isp5",
> +		.start          = 0x01c70000,
> +		.end            = 0x01c70000 + 0xff,
> +		.flags          = IORESOURCE_MEM,
> +	},
> +	{
> +		/* VPSS CLK Base address */
> +		.name           = "vpss",
> +		.start          = 0x01c70200,
> +		.end            = 0x01c70200 + 0xff,
> +		.flags          = IORESOURCE_MEM,
> +	},
> +};
> +
> +static struct platform_device dm365_vpss_device = {
> +       .name                   = "vpss",
> +       .id                     = -1,
> +       .dev.platform_data      = "dm365_vpss",
> +       .num_resources          = ARRAY_SIZE(dm365_vpss_resources),
> +       .resource               = dm365_vpss_resources,
> +};
> +
> +static struct resource vpfe_resources[] = {
> +	{
> +		.start          = IRQ_VDINT0,
> +		.end            = IRQ_VDINT0,
> +		.flags          = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start          = IRQ_VDINT1,
> +		.end            = IRQ_VDINT1,
> +		.flags          = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
> +static struct platform_device vpfe_capture_dev = {
> +	.name           = CAPTURE_DRV_NAME,
> +	.id             = -1,
> +	.num_resources  = ARRAY_SIZE(vpfe_resources),
> +	.resource       = vpfe_resources,
> +	.dev = {
> +		.dma_mask               = &vpfe_capture_dma_mask,
> +		.coherent_dma_mask      = DMA_BIT_MASK(32),
> +	},
> +};
> +
> +static void dm365_isif_setup_pinmux(void)
> +{
> +	davinci_cfg_reg(DM365_VIN_CAM_WEN);
> +	davinci_cfg_reg(DM365_VIN_CAM_VD);
> +	davinci_cfg_reg(DM365_VIN_CAM_HD);
> +	davinci_cfg_reg(DM365_VIN_YIN4_7_EN);
> +	davinci_cfg_reg(DM365_VIN_YIN0_3_EN);
> +}
> +
> +static struct resource isif_resource[] = {
> +	/* ISIF Base address */
> +	{
> +		.start          = 0x01c71000,
> +		.end            = 0x01c71000 + 0x1ff,
> +		.flags          = IORESOURCE_MEM,
> +	},
> +	/* ISIF Linearization table 0 */
> +	{
> +		.start          = 0x1C7C000,
> +		.end            = 0x1C7C000 + 0x2ff,
> +		.flags          = IORESOURCE_MEM,
> +	},
> +	/* ISIF Linearization table 1 */
> +	{
> +		.start          = 0x1C7C400,
> +		.end            = 0x1C7C400 + 0x2ff,
> +		.flags          = IORESOURCE_MEM,
> +	},
> +};
> +static struct platform_device dm365_isif_dev = {
> +	.name           = "isif",
> +	.id             = -1,
> +	.num_resources  = ARRAY_SIZE(isif_resource),
> +	.resource       = isif_resource,
> +	.dev = {
> +		.dma_mask               = &vpfe_capture_dma_mask,
> +		.coherent_dma_mask      = DMA_BIT_MASK(32),
> +		.platform_data		= dm365_isif_setup_pinmux,
> +	},
> +};
> +
>  static int __init dm365_init_devices(void)
>  {
>  	if (!cpu_is_davinci_dm365())
> @@ -1016,7 +1107,16 @@ static int __init dm365_init_devices(void)
>  	davinci_cfg_reg(DM365_INT_EDMA_CC);
>  	platform_device_register(&dm365_edma_device);
>  	platform_device_register(&dm365_emac_device);
> -
> +	/* Add isif clock alias */
> +	clk_add_alias("master", dm365_isif_dev.name, "vpss_master", NULL);
> +	platform_device_register(&dm365_vpss_device);
> +	platform_device_register(&dm365_isif_dev);
> +	platform_device_register(&vpfe_capture_dev);
>  	return 0;
>  }
>  postcore_initcall(dm365_init_devices);
> +
> +void dm365_set_vpfe_config(struct vpfe_config *cfg)
> +{
> +       vpfe_capture_dev.dev.platform_data = cfg;
> +}
> diff --git a/arch/arm/mach-davinci/include/mach/dm365.h b/arch/arm/mach-davinci/include/mach/dm365.h
> index f1710a3..9fc5a64 100644
> --- a/arch/arm/mach-davinci/include/mach/dm365.h
> +++ b/arch/arm/mach-davinci/include/mach/dm365.h
> @@ -18,6 +18,7 @@
>  #include <mach/emac.h>
>  #include <mach/asp.h>
>  #include <mach/keyscan.h>
> +#include <media/davinci/vpfe_capture.h>
>  
>  #define DM365_EMAC_BASE			(0x01D07000)
>  #define DM365_EMAC_CNTRL_OFFSET		(0x0000)
> @@ -36,4 +37,5 @@ void __init dm365_init_asp(struct snd_platform_data *pdata);
>  void __init dm365_init_ks(struct davinci_ks_platform_data *pdata);
>  void __init dm365_init_rtc(void);
>  
> +void dm365_set_vpfe_config(struct vpfe_config *cfg);
>  #endif /* __ASM_ARCH_DM365_H */
> -- 
> 1.6.0.4
