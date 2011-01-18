Return-path: <mchehab@pedra>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:56547 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541Ab1ARSis (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 13:38:48 -0500
Received: by mail-iw0-f177.google.com with SMTP id 38so8148016iwn.22
        for <linux-media@vger.kernel.org>; Tue, 18 Jan 2011 10:38:47 -0800 (PST)
From: Kevin Hilman <khilman@ti.com>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v16 2/3] davinci vpbe: platform specific additions
References: <1295357974-17798-1-git-send-email-manjunath.hadli@ti.com>
Date: Tue, 18 Jan 2011 10:38:44 -0800
In-Reply-To: <1295357974-17798-1-git-send-email-manjunath.hadli@ti.com>
	(Manjunath Hadli's message of "Tue, 18 Jan 2011 19:09:34 +0530")
Message-ID: <874o96xdjf.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Manjunath Hadli <manjunath.hadli@ti.com> writes:

> This patch implements the overall device creation for the Video
> display driver, initializes the platform variables and implements
> platform functions including setting video clocks.

This is dm644x specific.  Please use 'davinci: dm644x: VPBE' as subject
prefix.

Kevin


> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  arch/arm/mach-davinci/dm644x.c              |  169 +++++++++++++++++++++++++--
>  arch/arm/mach-davinci/include/mach/dm644x.h |    5 +
>  2 files changed, 163 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
> index 9a2376b..45a89a8 100644
> --- a/arch/arm/mach-davinci/dm644x.c
> +++ b/arch/arm/mach-davinci/dm644x.c
> @@ -586,12 +586,14 @@ static struct platform_device dm644x_asp_device = {
>  	.resource	= dm644x_asp_resources,
>  };
>  
> +#define DM644X_VPSS_REG_BASE		0x01c73400
> +
>  static struct resource dm644x_vpss_resources[] = {
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
> @@ -618,6 +620,7 @@ static struct resource vpfe_resources[] = {
>  };
>  
>  static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
> +
>  static struct resource dm644x_ccdc_resource[] = {
>  	/* CCDC Base address */
>  	{
> @@ -654,6 +657,137 @@ void dm644x_set_vpfe_config(struct vpfe_config *cfg)
>  	vpfe_capture_dev.dev.platform_data = cfg;
>  }
>  
> +#define DM644X_OSD_REG_BASE		0x01C72600
> +
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
> +#define DM644X_VENC_REG_BASE		0x01C72400
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
> +static void __iomem *vpss_clkctl_reg;
> +
> +static int dm644x_venc_setup_clock(enum vpbe_enc_timings_type type, __u64 mode)
> +{
> +	int ret = 0;
> +
> +	switch (type) {
> +	case VPBE_ENC_STD:
> +		writel(0x18, vpss_clkctl_reg);
> +		break;
> +	case VPBE_ENC_DV_PRESET:
> +		switch ((unsigned int)mode) {
> +		case V4L2_DV_480P59_94:
> +		case V4L2_DV_576P50:
> +			writel(0x19, vpss_clkctl_reg);
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
> @@ -781,25 +915,38 @@ void __init dm644x_init(void)
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
> +	vpss_clkctl_reg = DAVINCI_SYSMODULE_VIRT(0x44);
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
>  	clk_add_alias(NULL, dev_name(&dm644x_mdio_device.dev),
>  		      NULL, &dm644x_emac_device.dev);
> -
> -	platform_device_register(&dm644x_vpss_device);
> -	platform_device_register(&dm644x_ccdc_dev);
> -	platform_device_register(&vpfe_capture_dev);
> -
> +	dm644x_init_video();
>  	return 0;
>  }
>  postcore_initcall(dm644x_init_devices);
> diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
> index 5a1b26d..5134da0 100644
> --- a/arch/arm/mach-davinci/include/mach/dm644x.h
> +++ b/arch/arm/mach-davinci/include/mach/dm644x.h
> @@ -26,6 +26,10 @@
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
> @@ -43,5 +47,6 @@
>  void __init dm644x_init(void);
>  void __init dm644x_init_asp(struct snd_platform_data *pdata);
>  void dm644x_set_vpfe_config(struct vpfe_config *cfg);
> +void dm644x_set_vpbe_display_config(struct vpbe_display_config *cfg);
>  
>  #endif /* __ASM_ARCH_DM644X_H */
