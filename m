Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:37234 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab1AJPJO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 10:09:14 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 10 Jan 2011 20:38:54 +0530
Subject: RE: [PATCH 5/8] davinci vpbe: platform specific additions
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024829B81C@dbde02.ent.ti.com>
References: <1294666057-17491-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1294666057-17491-1-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Manju,

Please CC linux-arm-kernel@lists.infradead.org for mach-davinci
patches.

On Mon, Jan 10, 2011 at 18:57:37, Hadli, Manjunath wrote:
> This patch implements the overall device creation for the Video
> display driver.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  arch/arm/mach-davinci/dm644x.c              |  172 +++++++++++++++++++++++++--
>  arch/arm/mach-davinci/include/mach/dm644x.h |   13 ++-
>  2 files changed, 172 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
> index 9a2376b..f2d24fb 100644
> --- a/arch/arm/mach-davinci/dm644x.c
> +++ b/arch/arm/mach-davinci/dm644x.c
> @@ -5,7 +5,7 @@
>   *
>   * 2007 (c) Deep Root Systems, LLC. This file is licensed under
>   * the terms of the GNU General Public License version 2. This program
> - * is licensed "as is" without any warranty of any kind, whether express
> + * is licensed without any warranty of any kind, whether express

Please don't change the license text of existing licenses.

>   * or implied.
>   */
>  #include <linux/init.h>
> @@ -590,8 +590,8 @@ static struct resource dm644x_vpss_resources[] = {
>  	{
>  		/* VPSS Base address */
>  		.name		= "vpss",
> -		.start          = 0x01c73400,
> -		.end            = 0x01c73400 + 0xff,
> +		.start          = DM644X_VPSS_REG_BASE,
> +		.end            = DM644X_VPSS_REG_BASE + 0xff,
>  		.flags          = IORESOURCE_MEM,
>  	},
>  };
> @@ -618,6 +618,7 @@ static struct resource vpfe_resources[] = {
>  };
>  
>  static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
> +

Random new line?

>  static struct resource dm644x_ccdc_resource[] = {
>  	/* CCDC Base address */
>  	{
> @@ -654,6 +655,138 @@ void dm644x_set_vpfe_config(struct vpfe_config *cfg)
>  	vpfe_capture_dev.dev.platform_data = cfg;
>  }
>  
> +static struct resource dm644x_osd_resources[] = {
> +	{
> +		.start  = DM644X_OSD_REG_BASE,
> +		.end    = DM644X_OSD_REG_BASE + 0x1ff,
> +		.flags  = IORESOURCE_MEM,
> +	},
> +};
> +
> +static u64 dm644x_osd_dma_mask = DMA_BIT_MASK(32);
> +
> +static struct osd_platform_data osd_data = {
> +	.vpbe_type     = DM644X_VPBE,
> +	.field_inv_wa_enable = 0,

No need of zero initialization.

> +};
> +
> +static struct platform_device dm644x_osd_dev = {
> +	.name           = VPBE_OSD_SUBDEV_NAME,
> +	.id             = -1,
> +	.num_resources  = ARRAY_SIZE(dm644x_osd_resources),
> +	.resource       = dm644x_osd_resources,
> +	.dev = {
> +		.dma_mask               = &dm644x_osd_dma_mask,
> +		.coherent_dma_mask      = DMA_BIT_MASK(32),
> +		.platform_data          = &osd_data,
> +	},
> +};
> +
> +static struct resource dm644x_venc_resources[] = {
> +	/* venc registers io space */
> +	{
> +		.start  = DM644X_VENC_REG_BASE,
> +		.end    = DM644X_VENC_REG_BASE + 0x17f,
> +		.flags  = IORESOURCE_MEM,
> +	},
> +};
> +
> +static u64 dm644x_venc_dma_mask = DMA_BIT_MASK(32);
> +
> +#define VPSS_CLKCTL	0x01C40044

There is already a DAVINCI_SYSTEM_MODULE_BASE defined. This
should be defined as an offset from that base. 

> +
> +static void __iomem *vpss_clkctl_reg;
> +
> +static int dm644x_venc_setup_clock(enum vpbe_enc_timings_type type, __u64 mode)
> +{
> +	int ret = 0;
> +
> +	if (NULL == vpss_clkctl_reg)
> +		return -EINVAL;
> +	switch (type) {
> +	case VPBE_ENC_STD:
> +		writel(0x18, vpss_clkctl_reg);
> +		break;
> +	case VPBE_ENC_DV_PRESET:
> +		switch ((unsigned int)mode) {
> +		case V4L2_DV_480P59_94:
> +		case V4L2_DV_576P50:
> +			 writel(0x19, vpss_clkctl_reg);

Additional space in indentation.

> +			break;
> +		case V4L2_DV_720P60:
> +		case V4L2_DV_1080I60:
> +		case V4L2_DV_1080P30:
> +			/*
> +			 * For HD, use external clock source since
> +			 * HD requires higher clock rate
> +			 */
> +			writel(0xa, vpss_clkctl_reg);
> +			break;
> +		default:
> +			ret  = -EINVAL;
> +			break;
> +		}
> +		break;
> +	default:
> +		ret  = -EINVAL;
> +	}
> +	return ret;
> +}
> +
> +static u64 vpbe_display_dma_mask = DMA_BIT_MASK(32);
> +
> +static struct resource dm644x_v4l2_disp_resources[] = {
> +	{
> +		.start  = IRQ_VENCINT,
> +		.end    = IRQ_VENCINT,
> +		.flags  = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct platform_device vpbe_v4l2_display = {

dm644x_vpbe_v4l2_display

> +	.name           = "vpbe-v4l2",
> +	.id             = -1,
> +	.num_resources  = ARRAY_SIZE(dm644x_v4l2_disp_resources),
> +	.resource       = dm644x_v4l2_disp_resources,
> +	.dev = {
> +		.dma_mask               = &vpbe_display_dma_mask,
> +		.coherent_dma_mask      = DMA_BIT_MASK(32),
> +	},
> +};
> +
> +struct venc_platform_data dm644x_venc_pdata = {
> +	.venc_type	= DM644X_VPBE,
> +	.setup_clock	= dm644x_venc_setup_clock,
> +};
> +
> +static struct platform_device dm644x_venc_dev = {
> +	.name           = VPBE_VENC_SUBDEV_NAME,
> +	.id             = -1,
> +	.num_resources  = ARRAY_SIZE(dm644x_venc_resources),
> +	.resource       = dm644x_venc_resources,
> +	.dev = {
> +		.dma_mask               = &dm644x_venc_dma_mask,
> +		.coherent_dma_mask      = DMA_BIT_MASK(32),
> +		.platform_data          = &dm644x_venc_pdata,
> +	},
> +};
> +
> +static u64 dm644x_vpbe_dma_mask = DMA_BIT_MASK(32);
> +
> +static struct platform_device dm644x_vpbe_dev = {
> +	.name           = "vpbe_controller",
> +	.id             = -1,
> +	.dev = {
> +		.dma_mask               = &dm644x_vpbe_dma_mask,
> +		.coherent_dma_mask      = DMA_BIT_MASK(32),
> +	},
> +};
> +
> +void dm644x_set_vpbe_display_config(struct vpbe_display_config *cfg)
> +{
> +	dm644x_vpbe_dev.dev.platform_data = cfg;
> +}
> +
>  /*----------------------------------------------------------------------*/
>  
>  static struct map_desc dm644x_io_desc[] = {
> @@ -781,25 +914,42 @@ void __init dm644x_init(void)
>  	davinci_common_init(&davinci_soc_info_dm644x);
>  }
>  
> +static struct platform_device *dm644x_video_devices[] __initdata = {
> +	&dm644x_vpss_device,
> +	&dm644x_ccdc_dev,
> +	&vpfe_capture_dev,
> +	&dm644x_osd_dev,
> +	&dm644x_venc_dev,
> +	&dm644x_vpbe_dev,
> +	&vpbe_v4l2_display,
> +};
> +
> +static int __init dm644x_init_video(void)
> +{
> +	/* Add ccdc clock aliases */
> +	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
> +	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
> +	vpss_clkctl_reg = ioremap_nocache(VPSS_CLKCTL, 4);
> +	if (!vpss_clkctl_reg)
> +		return -ENODEV;

There should be a better way than mapping sysmodule again and again.
Elsewhere in code, IO_ADDRESS() is being used to access system module
base, but usage of IO_ADDRESS() is now deprecated. So, you will need to
define some macro of the sort DAVINCI_SYSMODULE_VIRT(x) which will return
the sysmodule virtual address for a given offset. Something like this
was done for DA8xx by me here:

http://patchwork.kernel.org/patch/54384/

You should also convert the existing sysmodule users to use this
method.

> +	platform_add_devices(dm644x_video_devices,
> +				ARRAY_SIZE(dm644x_video_devices));
> +	return 0;
> +}
> +
>  static int __init dm644x_init_devices(void)
>  {
>  	if (!cpu_is_davinci_dm644x())
>  		return 0;
>  
> -	/* Add ccdc clock aliases */
> -	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
> -	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
>  	platform_device_register(&dm644x_edma_device);
> -
>  	platform_device_register(&dm644x_mdio_device);
>  	platform_device_register(&dm644x_emac_device);
> +
>  	clk_add_alias(NULL, dev_name(&dm644x_mdio_device.dev),
>  		      NULL, &dm644x_emac_device.dev);
>  
> -	platform_device_register(&dm644x_vpss_device);
> -	platform_device_register(&dm644x_ccdc_dev);
> -	platform_device_register(&vpfe_capture_dev);
> -
> +	dm644x_init_video();
>  	return 0;
>  }
>  postcore_initcall(dm644x_init_devices);
> diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
> index 5a1b26d..a63fd67 100644
> --- a/arch/arm/mach-davinci/include/mach/dm644x.h
> +++ b/arch/arm/mach-davinci/include/mach/dm644x.h
> @@ -6,8 +6,7 @@
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> + * the Free Software Foundation version 2.

Please don't change license for existing files.

>   *
>   * This program is distributed in the hope that it will be useful,
>   * but WITHOUT ANY WARRANTY; without even the implied warranty of
> @@ -26,6 +25,10 @@
>  #include <mach/hardware.h>
>  #include <mach/asp.h>
>  #include <media/davinci/vpfe_capture.h>
> +#include <media/davinci/vpbe_types.h>
> +#include <media/davinci/vpbe.h>
> +#include <media/davinci/vpss.h>
> +#include <media/davinci/vpbe_osd.h>
>  
>  #define DM644X_EMAC_BASE		(0x01C80000)
>  #define DM644X_EMAC_MDIO_BASE		(DM644X_EMAC_BASE + 0x4000)
> @@ -40,8 +43,14 @@
>  #define DM644X_ASYNC_EMIF_DATA_CE2_BASE 0x06000000
>  #define DM644X_ASYNC_EMIF_DATA_CE3_BASE 0x08000000
>  
> +/* VPBE register base addresses */
> +#define DM644X_VPSS_REG_BASE		0x01c73400
> +#define DM644X_VENC_REG_BASE		0x01C72400
> +#define DM644X_OSD_REG_BASE		0x01C72600

Since these are not used elsewhere, you can define
these in the dm644x.c file itself - where they are
used.


Thanks,
Sekhar

> +
>  void __init dm644x_init(void);
>  void __init dm644x_init_asp(struct snd_platform_data *pdata);
>  void dm644x_set_vpfe_config(struct vpfe_config *cfg);
> +void dm644x_set_vpbe_display_config(struct vpbe_display_config *cfg);
>  
>  #endif /* __ASM_ARCH_DM644X_H */
> -- 
> 1.6.2.4
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 

