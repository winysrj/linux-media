Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3170 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZFNOW5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 10:22:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Subject: Re: [PATCH 7/10 - v2] DM355 platform changes for vpfe capture driver
Date: Sun, 14 Jun 2009 16:22:54 +0200
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com> <1244739649-27466-7-git-send-email-m-karicheri2@ti.com> <1244739649-27466-8-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1244739649-27466-8-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141622.55197.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 11 June 2009 19:00:46 m-karicheri2@ti.com wrote:
> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
> 
> DM355 platform and board setup
> 
> This has platform and board setup changes to support vpfe capture
> driver for DM355 EVMs.
> 
> Added registration of vpss platform driver based on last review
> 
> Reviewed By "Hans Verkuil".
> Reviewed By "Laurent Pinchart".
> 
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to Davinci GIT Tree
> 
>  arch/arm/mach-davinci/board-dm355-evm.c    |   72 +++++++++++++++++++++++-
>  arch/arm/mach-davinci/dm355.c              |   83 ++++++++++++++++++++++++++++
>  arch/arm/mach-davinci/include/mach/dm355.h |    2 +
>  arch/arm/mach-davinci/include/mach/mux.h   |    9 +++
>  4 files changed, 163 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
> index 5ac2f56..cf87e21 100644
> --- a/arch/arm/mach-davinci/board-dm355-evm.c
> +++ b/arch/arm/mach-davinci/board-dm355-evm.c
> @@ -20,6 +20,8 @@
>  #include <linux/io.h>
>  #include <linux/gpio.h>
>  #include <linux/clk.h>
> +#include <linux/videodev2.h>
> +#include <media/tvp514x.h>
>  #include <linux/spi/spi.h>
>  #include <linux/spi/eeprom.h>
>  
> @@ -134,12 +136,23 @@ static void dm355evm_mmcsd_gpios(unsigned gpio)
>  	dm355evm_mmc_gpios = gpio;
>  }
>  
> +#define TVP5146_I2C_ADDR		0x5D
> +static struct tvp514x_platform_data tvp5146_pdata = {
> +	.clk_polarity = 0,
> +	.hs_polarity = 1,
> +	.vs_polarity = 1
> +};
> +
>  static struct i2c_board_info dm355evm_i2c_info[] = {
> -	{ I2C_BOARD_INFO("dm355evm_msp", 0x25),
> +	{	I2C_BOARD_INFO("dm355evm_msp", 0x25),
>  		.platform_data = dm355evm_mmcsd_gpios,
> -		/* plus irq */ },
> +	},
> +	{
> +		I2C_BOARD_INFO("tvp5146", TVP5146_I2C_ADDR),
> +		.platform_data = &tvp5146_pdata,
> +	},
> +	/* { plus irq  }, */
>  	/* { I2C_BOARD_INFO("tlv320aic3x", 0x1b), }, */

Huh? What's this? I only know the tlv320aic23b and that's an audio driver.

> -	/* { I2C_BOARD_INFO("tvp5146", 0x5d), }, */
>  };
>  
>  static void __init evm_init_i2c(void)
> @@ -178,6 +191,57 @@ static struct platform_device dm355evm_dm9000 = {
>  	.num_resources	= ARRAY_SIZE(dm355evm_dm9000_rsrc),
>  };
>  
> +#define TVP514X_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
> +/* Inputs available at the TVP5146 */
> +static struct v4l2_input tvp5146_inputs[] = {
> +	{
> +		.index = 0,
> +		.name = "COMPOSITE",

Please, don't use all-caps. Just use "Composite" and "S-Video". 

> +		.type = V4L2_INPUT_TYPE_CAMERA,
> +		.std = TVP514X_STD_ALL,
> +	},
> +	{
> +		.index = 1,
> +		.name = "SVIDEO",
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
> +static struct v4l2_routing tvp5146_routes[] = {

As mentioned elsewhere: v4l2_routing will disappear, so please don't use it.

> +	{
> +		.input = INPUT_CVBS_VI2B,
> +		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
> +	},
> +	{
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
> +	}
> +};

A general remark: currently you link your inputs directly to a subdev. This
approach has two disadvantages:

1) It doesn't work if there are no subdevs at all (e.g. because everything
goes through an fpga).

2) It fixes the reported order of the inputs to the order of the subdevs.

I think it is better to have a separate array of input descriptions that
refer to a subdev when an input is associated with that subdev. It's more
flexible that way, and I actually think that the vpfe driver will be
simplified as well.

> +
> +static struct vpfe_config vpfe_cfg = {
> +	.num_subdevs = ARRAY_SIZE(vpfe_sub_devs),
> +	.sub_devs = vpfe_sub_devs,
> +	.card_name = "DM355 EVM",
> +	.ccdc = "DM355 CCDC",
> +};
> +
>  static struct platform_device *davinci_evm_devices[] __initdata = {
>  	&dm355evm_dm9000,
>  	&davinci_nand_device,
> @@ -189,6 +253,8 @@ static struct davinci_uart_config uart_config __initdata = {
>  
>  static void __init dm355_evm_map_io(void)
>  {
> +	/* setup input configuration for VPFE input devices */
> +	dm355_set_vpfe_config(&vpfe_cfg);
>  	dm355_init();
>  }
>  
> diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
> index 9baeed3..3263af8 100644
> --- a/arch/arm/mach-davinci/dm355.c
> +++ b/arch/arm/mach-davinci/dm355.c
> @@ -481,6 +481,14 @@ INT_CFG(DM355,  INT_EDMA_TC1_ERR,     4,    1,    1,     false)
>  EVT_CFG(DM355,  EVT8_ASP1_TX,	      0,    1,    0,     false)
>  EVT_CFG(DM355,  EVT9_ASP1_RX,	      1,    1,    0,     false)
>  EVT_CFG(DM355,  EVT26_MMC0_RX,	      2,    1,    0,     false)
> +
> +MUX_CFG(DM355,	VIN_PCLK,	0,   14,    1,    1,	 false)
> +MUX_CFG(DM355,	VIN_CAM_WEN,	0,   13,    1,    1,	 false)
> +MUX_CFG(DM355,	VIN_CAM_VD,	0,   12,    1,    1,	 false)
> +MUX_CFG(DM355,	VIN_CAM_HD,	0,   11,    1,    1,	 false)
> +MUX_CFG(DM355,	VIN_YIN_EN,	0,   10,    1,    1,	 false)
> +MUX_CFG(DM355,	VIN_CINL_EN,	0,   0,   0xff, 0x55,	 false)
> +MUX_CFG(DM355,	VIN_CINH_EN,	0,   8,     3,    3,	 false)
>  #endif
>  };
>  
> @@ -623,6 +631,67 @@ static struct platform_device dm355_edma_device = {
>  	.resource		= edma_resources,
>  };
>  
> +static struct resource dm355_vpss_resources[] = {
> +	{
> +		/* VPSS BL Base address */
> +		.name		= "vpss",
> +		.start          = 0x01c70800,
> +		.end            = 0x01c70800 + 0xff,
> +		.flags          = IORESOURCE_MEM,
> +	},
> +	{
> +		/* VPSS CLK Base address */
> +		.name		= "vpss",
> +		.start          = 0x01c70000,
> +		.end            = 0x01c70000 + 0xf,
> +		.flags          = IORESOURCE_MEM,
> +	},
> +};
> +
> +static struct platform_device dm355_vpss_device = {
> +	.name			= "vpss",
> +	.id			= -1,
> +	.dev.platform_data	= "dm355_vpss",
> +	.num_resources		= ARRAY_SIZE(dm355_vpss_resources),
> +	.resource		= dm355_vpss_resources,
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
> +	/* CCDC Base address */
> +	{
> +		.flags          = IORESOURCE_MEM,
> +		.start          = 0x01c70600,
> +		.end            = 0x01c70600 + 0x1ff,
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
> +	},
> +};
> +
> +void dm355_set_vpfe_config(struct vpfe_config *cfg)
> +{
> +	vpfe_capture_dev.dev.platform_data = cfg;
> +}
> +
>  /*----------------------------------------------------------------------*/
>  
>  static struct map_desc dm355_io_desc[] = {
> @@ -744,6 +813,20 @@ static int __init dm355_init_devices(void)
>  
>  	davinci_cfg_reg(DM355_INT_EDMA_CC);
>  	platform_device_register(&dm355_edma_device);
> +	platform_device_register(&dm355_vpss_device);
> +	/*
> +	 * setup Mux configuration for vpfe input and register
> +	 * vpfe capture platform device
> +	 */
> +	davinci_cfg_reg(DM355_VIN_PCLK);
> +	davinci_cfg_reg(DM355_VIN_CAM_WEN);
> +	davinci_cfg_reg(DM355_VIN_CAM_VD);
> +	davinci_cfg_reg(DM355_VIN_CAM_HD);
> +	davinci_cfg_reg(DM355_VIN_YIN_EN);
> +	davinci_cfg_reg(DM355_VIN_CINL_EN);
> +	davinci_cfg_reg(DM355_VIN_CINH_EN);
> +	platform_device_register(&vpfe_capture_dev);
> +
>  	return 0;
>  }
>  postcore_initcall(dm355_init_devices);
> diff --git a/arch/arm/mach-davinci/include/mach/dm355.h b/arch/arm/mach-davinci/include/mach/dm355.h
> index 54903b7..e28713c 100644
> --- a/arch/arm/mach-davinci/include/mach/dm355.h
> +++ b/arch/arm/mach-davinci/include/mach/dm355.h
> @@ -12,11 +12,13 @@
>  #define __ASM_ARCH_DM355_H
>  
>  #include <mach/hardware.h>
> +#include <media/davinci/vpfe_capture.h>
>  
>  struct spi_board_info;
>  
>  void __init dm355_init(void);
>  void dm355_init_spi0(unsigned chipselect_mask,
>  		struct spi_board_info *info, unsigned len);
> +void dm355_set_vpfe_config(struct vpfe_config *cfg);
>  
>  #endif /* __ASM_ARCH_DM355_H */
> diff --git a/arch/arm/mach-davinci/include/mach/mux.h b/arch/arm/mach-davinci/include/mach/mux.h
> index 2737845..f288063 100644
> --- a/arch/arm/mach-davinci/include/mach/mux.h
> +++ b/arch/arm/mach-davinci/include/mach/mux.h
> @@ -154,6 +154,15 @@ enum davinci_dm355_index {
>  	DM355_EVT8_ASP1_TX,
>  	DM355_EVT9_ASP1_RX,
>  	DM355_EVT26_MMC0_RX,
> +
> +	/* Video In Pin Mux */
> +	DM355_VIN_PCLK,
> +	DM355_VIN_CAM_WEN,
> +	DM355_VIN_CAM_VD,
> +	DM355_VIN_CAM_HD,
> +	DM355_VIN_YIN_EN,
> +	DM355_VIN_CINL_EN,
> +	DM355_VIN_CINH_EN,
>  };
>  
>  #ifdef CONFIG_DAVINCI_MUX

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
