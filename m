Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41516 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0FCHTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jun 2010 03:19:30 -0400
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Thu, 3 Jun 2010 12:49:06 +0530
Subject: RE: [PATCH-V1 2/2] AM3517: Add VPFE Capture driver support to board
 file
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB0323207C30@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1275547321-31406-3-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1275547321-31406-3-git-send-email-hvaibhav@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vaibhav,


> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Hiremath, Vaibhav
> Sent: Thursday, June 03, 2010 12:12 PM
> To: linux-media@vger.kernel.org
> Cc: mchehab@redhat.com; Karicheri, Muralidharan; linux-
> omap@vger.kernel.org; Hiremath, Vaibhav
> Subject: [PATCH-V1 2/2] AM3517: Add VPFE Capture driver support to board
> file
> 
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> Also created vpfe master/slave clock aliases, since naming
> convention is different in both Davinci and AM3517 devices.
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  arch/arm/mach-omap2/board-am3517evm.c |  161
> +++++++++++++++++++++++++++++++++
>  1 files changed, 161 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-
> omap2/board-am3517evm.c
> index c1c4389..f2ff751 100644
> --- a/arch/arm/mach-omap2/board-am3517evm.c
> +++ b/arch/arm/mach-omap2/board-am3517evm.c
> @@ -30,15 +30,168 @@
> 
>  #include <plat/board.h>
>  #include <plat/common.h>
> +#include <plat/control.h>
>  #include <plat/usb.h>
>  #include <plat/display.h>
> 
> +#include <media/tvp514x.h>
> +#include <media/davinci/vpfe_capture.h>
> +
>  #include "mux.h"
> 
>  #define LCD_PANEL_PWR		176
>  #define LCD_PANEL_BKLIGHT_PWR	182
>  #define LCD_PANEL_PWM		181
> 
> +/*
> + * VPFE - Video Decoder interface
> + */
> +#define TVP514X_STD_ALL		(V4L2_STD_NTSC | V4L2_STD_PAL)
> +
> +/* Inputs available at the TVP5146 */
> +static struct v4l2_input tvp5146_inputs[] = {
> +	{
> +		.index	= 0,
> +		.name	= "Composite",
> +		.type	= V4L2_INPUT_TYPE_CAMERA,
> +		.std	= TVP514X_STD_ALL,
> +	},
> +	{
> +		.index	= 1,
> +		.name	= "S-Video",
> +		.type	= V4L2_INPUT_TYPE_CAMERA,
> +		.std	= TVP514X_STD_ALL,
> +	},
> +};
> +
> +static struct tvp514x_platform_data tvp5146_pdata = {
> +	.clk_polarity	= 0,
> +	.hs_polarity	= 1,
> +	.vs_polarity	= 1
> +};
> +
> +static struct vpfe_route tvp5146_routes[] = {
> +	{
> +		.input	= INPUT_CVBS_VI1A,
> +		.output	= OUTPUT_10BIT_422_EMBEDDED_SYNC,
> +	},
> +	{
> +		.input	= INPUT_SVIDEO_VI2C_VI1C,
> +		.output	= OUTPUT_10BIT_422_EMBEDDED_SYNC,
> +	},
> +};
> +
> +static struct vpfe_subdev_info vpfe_sub_devs[] = {
> +	{
> +		.name		= "tvp5146",
> +		.grp_id		= 0,
> +		.num_inputs	= ARRAY_SIZE(tvp5146_inputs),
> +		.inputs		= tvp5146_inputs,
> +		.routes		= tvp5146_routes,
> +		.can_route	= 1,
> +		.ccdc_if_params	= {
> +			.if_type = VPFE_BT656,
> +			.hdpol	= VPFE_PINPOL_POSITIVE,
> +			.vdpol	= VPFE_PINPOL_POSITIVE,
> +		},
> +		.board_info	= {
> +			I2C_BOARD_INFO("tvp5146", 0x5C),
> +			.platform_data = &tvp5146_pdata,
> +		},
> +	},
> +};
> +
> +static void am3517_evm_clear_vpfe_intr(int vdint)
> +{
> +	unsigned int vpfe_int_clr;
> +
> +	vpfe_int_clr = omap_ctrl_readl(AM35XX_CONTROL_LVL_INTR_CLEAR);
> +
> +	switch (vdint) {
> +	/* VD0 interrrupt */
> +	case INT_35XX_CCDC_VD0_IRQ:
> +		vpfe_int_clr &= ~AM35XX_VPFE_CCDC_VD0_INT_CLR;
> +		vpfe_int_clr |= AM35XX_VPFE_CCDC_VD0_INT_CLR;
> +		break;
> +	/* VD1 interrrupt */
> +	case INT_35XX_CCDC_VD1_IRQ:
> +		vpfe_int_clr &= ~AM35XX_VPFE_CCDC_VD1_INT_CLR;
> +		vpfe_int_clr |= AM35XX_VPFE_CCDC_VD1_INT_CLR;
> +		break;
> +	/* VD2 interrrupt */
> +	case INT_35XX_CCDC_VD2_IRQ:
> +		vpfe_int_clr &= ~AM35XX_VPFE_CCDC_VD2_INT_CLR;
> +		vpfe_int_clr |= AM35XX_VPFE_CCDC_VD2_INT_CLR;
> +		break;
> +	/* Clear all interrrupts */
> +	default:
> +		vpfe_int_clr &= ~(AM35XX_VPFE_CCDC_VD0_INT_CLR |
> +				AM35XX_VPFE_CCDC_VD1_INT_CLR |
> +				AM35XX_VPFE_CCDC_VD2_INT_CLR);
> +		vpfe_int_clr |= (AM35XX_VPFE_CCDC_VD0_INT_CLR |
> +				AM35XX_VPFE_CCDC_VD1_INT_CLR |
> +				AM35XX_VPFE_CCDC_VD2_INT_CLR);
> +		break;
> +	}
> +	omap_ctrl_writel(vpfe_int_clr, AM35XX_CONTROL_LVL_INTR_CLEAR);
> +	vpfe_int_clr = omap_ctrl_readl(AM35XX_CONTROL_LVL_INTR_CLEAR);

Is it necessary to assign to the local variable (vpfe_int_clr)? If not, we can reduce the size of this routine by two assembly instructions:
One: copying the result to a register
Two: pushing the register value to stack

-Tarun
 

> +}
> +
> +static struct vpfe_config vpfe_cfg = {
> +	.num_subdevs	= ARRAY_SIZE(vpfe_sub_devs),
> +	.i2c_adapter_id	= 3,
> +	.sub_devs	= vpfe_sub_devs,
> +	.clr_intr	= am3517_evm_clear_vpfe_intr,
> +	.card_name	= "AM3517 EVM",
> +	.ccdc		= "DM6446 CCDC",
> +};
> +
> +static struct resource vpfe_resources[] = {
> +	{
> +		.start	= INT_35XX_CCDC_VD0_IRQ,
> +		.end	= INT_35XX_CCDC_VD0_IRQ,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	{
> +		.start	= INT_35XX_CCDC_VD1_IRQ,
> +		.end	= INT_35XX_CCDC_VD1_IRQ,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
> +static struct platform_device vpfe_capture_dev = {
> +	.name		= CAPTURE_DRV_NAME,
> +	.id		= -1,
> +	.num_resources	= ARRAY_SIZE(vpfe_resources),
> +	.resource	= vpfe_resources,
> +	.dev = {
> +		.dma_mask		= &vpfe_capture_dma_mask,
> +		.coherent_dma_mask	= DMA_BIT_MASK(32),
> +		.platform_data		= &vpfe_cfg,
> +	},
> +};
> +
> +static struct resource am3517_ccdc_resource[] = {
> +	/* CCDC Base address */
> +	{
> +		.start	= AM35XX_IPSS_VPFE_BASE,
> +		.end	= AM35XX_IPSS_VPFE_BASE + 0xffff,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +};
> +
> +static struct platform_device am3517_ccdc_dev = {
> +	.name		= "dm644x_ccdc",
> +	.id		= -1,
> +	.num_resources	= ARRAY_SIZE(am3517_ccdc_resource),
> +	.resource	= am3517_ccdc_resource,
> +	.dev = {
> +		.dma_mask		= &vpfe_capture_dma_mask,
> +		.coherent_dma_mask	= DMA_BIT_MASK(32),
> +	},
> +};
> +
>  static struct i2c_board_info __initdata am3517evm_i2c_boardinfo[] = {
>  	{
>  		I2C_BOARD_INFO("s35390a", 0x30),
> @@ -46,6 +199,7 @@ static struct i2c_board_info __initdata
> am3517evm_i2c_boardinfo[] = {
>  	},
>  };
> 
> +
>  /*
>   * RTC - S35390A
>   */
> @@ -261,6 +415,8 @@ static struct omap_board_config_kernel
> am3517_evm_config[] __initdata = {
> 
>  static struct platform_device *am3517_evm_devices[] __initdata = {
>  	&am3517_evm_dss_device,
> +	&am3517_ccdc_dev,
> +	&vpfe_capture_dev,
>  };
> 
>  static void __init am3517_evm_init_irq(void)
> @@ -313,6 +469,11 @@ static void __init am3517_evm_init(void)
> 
>  	i2c_register_board_info(1, am3517evm_i2c_boardinfo,
>  				ARRAY_SIZE(am3517evm_i2c_boardinfo));
> +
> +	clk_add_alias("master", "dm644x_ccdc", "master",
> +			&vpfe_capture_dev.dev);
> +	clk_add_alias("slave", "dm644x_ccdc", "slave",
> +			&vpfe_capture_dev.dev);
>  }
> 
>  static void __init am3517_evm_map_io(void)
> --
> 1.6.2.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
