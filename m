Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50361 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab1IVHij (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 03:38:39 -0400
Date: Thu, 22 Sep 2011 09:35:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: linux-media@vger.kernel.org, plagnioj@jcrosoft.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	nicolas.ferre@atmel.com, s.nawrocki@samsung.com
Subject: Re: [PATCH v3 2/2] at91: add Atmel ISI and ov2640 support on
 sam9m10/sam9g45 board.
In-Reply-To: <1316664661-11383-2-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1109220911500.11164@axis700.grange>
References: <1316664661-11383-1-git-send-email-josh.wu@atmel.com>
 <1316664661-11383-2-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 22 Sep 2011, Josh Wu wrote:

> This patch
> 1. add ISI_MCK parent setting code when add ISI device.
> 2. add ov2640 support on board file.
> 3. define isi_mck clock in sam9g45 chip file.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
>  arch/arm/mach-at91/at91sam9g45.c         |    3 +
>  arch/arm/mach-at91/at91sam9g45_devices.c |  105 +++++++++++++++++++++++++++++-
>  arch/arm/mach-at91/board-sam9m10g45ek.c  |   85 ++++++++++++++++++++++++-
>  arch/arm/mach-at91/include/mach/board.h  |    3 +-

Personally, I think, it would be better to separate this into two patches 
at least: one for at91 core and one for the specific board, but that's up 
to arch maintainers to decide.

You also want to patch arch/arm/mach-at91/at91sam9263_devices.c, don't 
you?

>  4 files changed, 193 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
> index e04c5fb..5e23d6d 100644
> --- a/arch/arm/mach-at91/at91sam9g45.c
> +++ b/arch/arm/mach-at91/at91sam9g45.c
> @@ -201,6 +201,7 @@ static struct clk *periph_clocks[] __initdata = {
>  	// irq0
>  };
>  
> +static struct clk pck1;

Hm, it really doesn't need any initialisation, not even for the .type 
field? .type=0 doesn't seem to be valid.

>  static struct clk_lookup periph_clocks_lookups[] = {
>  	/* One additional fake clock for ohci */
>  	CLKDEV_CON_ID("ohci_clk", &uhphs_clk),
> @@ -215,6 +216,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
>  	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.1", &tcb0_clk),
>  	CLKDEV_CON_DEV_ID("pclk", "ssc.0", &ssc0_clk),
>  	CLKDEV_CON_DEV_ID("pclk", "ssc.1", &ssc1_clk),
> +	/* ISI_MCK, which is provided by programmable clock(PCK1) */
> +	CLKDEV_CON_DEV_ID("isi_mck", "atmel_isi.0", &pck1),
>  };
>  
>  static struct clk_lookup usart_clocks_lookups[] = {
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index 600bffb..82eeac8 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -16,7 +16,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/i2c-gpio.h>
>  #include <linux/atmel-mci.h>
> -
> +#include <linux/clk.h>
>  #include <linux/fb.h>
>  #include <video/atmel_lcdc.h>
>  
> @@ -28,6 +28,8 @@
>  #include <mach/at_hdmac.h>
>  #include <mach/atmel-mci.h>
>  
> +#include <media/atmel-isi.h>
> +
>  #include "generic.h"
>  
>  
> @@ -863,6 +865,107 @@ void __init at91_add_device_ac97(struct ac97c_platform_data *data)
>  void __init at91_add_device_ac97(struct ac97c_platform_data *data) {}
>  #endif
>  
> +/* --------------------------------------------------------------------
> + *  Image Sensor Interface
> + * -------------------------------------------------------------------- */
> +#if defined(CONFIG_VIDEO_ATMEL_ISI) || defined(CONFIG_VIDEO_ATMEL_ISI_MODULE)
> +static u64 isi_dmamask = DMA_BIT_MASK(32);
> +static struct isi_platform_data isi_data;
> +
> +struct resource isi_resources[] = {
> +	[0] = {
> +		.start	= AT91SAM9G45_BASE_ISI,
> +		.end	= AT91SAM9G45_BASE_ISI + SZ_16K - 1,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	[1] = {
> +		.start	= AT91SAM9G45_ID_ISI,
> +		.end	= AT91SAM9G45_ID_ISI,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct platform_device at91sam9g45_isi_device = {
> +	.name		= "atmel_isi",
> +	.id		= 0,
> +	.dev		= {
> +			.dma_mask		= &isi_dmamask,
> +			.coherent_dma_mask	= DMA_BIT_MASK(32),
> +			.platform_data		= &isi_data,
> +	},
> +	.resource	= isi_resources,
> +	.num_resources	= ARRAY_SIZE(isi_resources),
> +};
> +
> +static int __init isi_set_clk_parent(void)
> +{
> +	struct clk *pck1;
> +	struct clk *plla;
> +	int ret;
> +
> +	/* ISI_MCK is supplied by PCK1 - set parent for it. */
> +	pck1 = clk_get(NULL, "pck1");
> +	if (IS_ERR(pck1)) {
> +		printk(KERN_ERR "Failed to get PCK1\n");
> +		ret = PTR_ERR(pck1);
> +		goto err;
> +	}
> +
> +	plla = clk_get(NULL, "plla");
> +	if (IS_ERR(plla)) {
> +		printk(KERN_ERR "Failed to get PLLA\n");
> +		ret = PTR_ERR(plla);
> +		goto err_pck1;
> +	}
> +	ret = clk_set_parent(pck1, plla);
> +	clk_put(plla);
> +	if (ret != 0) {
> +		printk(KERN_ERR "Failed to set PCK1 parent\n");
> +		goto err_pck1;
> +	}
> +	return ret;
> +
> +err_pck1:
> +	clk_put(pck1);
> +err:
> +	return ret;
> +}
> +
> +void __init at91_add_device_isi(struct isi_platform_data * data)
> +{
> +	if (!data)
> +		return;
> +	isi_data = *data;
> +
> +	at91_set_A_periph(AT91_PIN_PB20, 0);	/* ISI_D0 */
> +	at91_set_A_periph(AT91_PIN_PB21, 0);	/* ISI_D1 */
> +	at91_set_A_periph(AT91_PIN_PB22, 0);	/* ISI_D2 */
> +	at91_set_A_periph(AT91_PIN_PB23, 0);	/* ISI_D3 */
> +	at91_set_A_periph(AT91_PIN_PB24, 0);	/* ISI_D4 */
> +	at91_set_A_periph(AT91_PIN_PB25, 0);	/* ISI_D5 */
> +	at91_set_A_periph(AT91_PIN_PB26, 0);	/* ISI_D6 */
> +	at91_set_A_periph(AT91_PIN_PB27, 0);	/* ISI_D7 */
> +	at91_set_A_periph(AT91_PIN_PB28, 0);	/* ISI_PCK */
> +	at91_set_A_periph(AT91_PIN_PB30, 0);	/* ISI_HSYNC */
> +	at91_set_A_periph(AT91_PIN_PB29, 0);	/* ISI_VSYNC */
> +	at91_set_B_periph(AT91_PIN_PB31, 0);	/* ISI_MCK (PCK1) */
> +	at91_set_B_periph(AT91_PIN_PB8, 0);	/* ISI_PD8 */
> +	at91_set_B_periph(AT91_PIN_PB9, 0);	/* ISI_PD9 */
> +	at91_set_B_periph(AT91_PIN_PB10, 0);	/* ISI_PD10 */
> +	at91_set_B_periph(AT91_PIN_PB11, 0);	/* ISI_PD11 */
> +
> +	platform_device_register(&at91sam9g45_isi_device);
> +
> +	if (isi_set_clk_parent())
> +		printk(KERN_ERR "Fail to set parent for ISI_MCK.\n");
> +
> +	return;
> +}
> +#else
> +static int __init isi_set_clk_parent(void) { }
> +void __init at91_add_device_isi(struct isi_platform_data * data) { }
> +#endif
> +
>  
>  /* --------------------------------------------------------------------
>   *  LCD Controller
> diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
> index ad234cc..d5293fb 100644
> --- a/arch/arm/mach-at91/board-sam9m10g45ek.c
> +++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
> @@ -23,11 +23,13 @@
>  #include <linux/gpio_keys.h>
>  #include <linux/input.h>
>  #include <linux/leds.h>
> -#include <linux/clk.h>
>  #include <linux/atmel-mci.h>
> +#include <linux/delay.h>
>  
>  #include <mach/hardware.h>
>  #include <video/atmel_lcdc.h>
> +#include <media/soc_camera.h>
> +#include <media/atmel-isi.h>
>  
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
> @@ -185,6 +187,83 @@ static void __init ek_add_device_nand(void)
>  	at91_add_device_nand(&ek_nand_data);
>  }
>  
> +/*
> + *  ISI
> + */
> +#if defined(CONFIG_VIDEO_ATMEL_ISI) || defined(CONFIG_VIDEO_ATMEL_ISI_MODULE)
> +static struct isi_platform_data __initdata isi_data = {
> +	.frate		= ISI_CFG1_FRATE_CAPTURE_ALL,
> +	.has_emb_sync	= 0,
> +	.emb_crc_sync = 0,
> +	.hsync_act_low = 0,
> +	.vsync_act_low = 0,
> +	.pclk_act_falling = 0,

You don't need all the "= 0" assignments above - all uninitialised fields 
will be = 0. Also, if you have started aligning assignments, as in .frate 
and .has_emb_sync, would be better to align all of them.

> +	/* to use codec and preview path simultaneously */
> +	.isi_full_mode = 1,
> +	.data_width_flags = ISI_DATAWIDTH_8 | ISI_DATAWIDTH_10,
> +	/* ISI_MCK is provided by PCK1  */
> +	.isi_mck_hz = 25000000,
> +};
> +
> +#else
> +static struct isi_platform_data __initdata isi_data;

Hmm, that doesn't help a lot, does it? Either do not allocate isi_data if 
ISI is not selected in .config, or just remove the "#if" completely.

> +#endif
> +
> +/*
> + * soc-camera OV2640
> + */
> +#if defined(CONFIG_SOC_CAMERA_OV2640)

... || defined(CONFIG_SOC_CAMERA_OV2640_MODULE)

> +static unsigned long isi_camera_query_bus_param(struct soc_camera_link *link)
> +{
> +	/* ISI board for ek using default 8-bits connection */
> +	return SOCAM_DATAWIDTH_8;
> +}
> +
> +static int i2c_camera_power(struct device *dev, int on)
> +{
> +	/* enable or disable the camera */
> +	pr_debug("%s: %s the camera\n", __func__, on ? "ENABLE" : "DISABLE");
> +	at91_set_gpio_output(AT91_PIN_PD13, on ? 0 : 1);

maybe just

	at91_set_gpio_output(AT91_PIN_PD13, !on);

> +
> +	if (!on)
> +		goto out;
> +
> +	/* If enabled, give a reset impulse */
> +	at91_set_gpio_output(AT91_PIN_PD12, 0);
> +	msleep(20);
> +	at91_set_gpio_output(AT91_PIN_PD12, 1);
> +	msleep(100);
> +
> +out:
> +	return 0;
> +}
> +
> +static struct i2c_board_info i2c_camera = {
> +	I2C_BOARD_INFO("ov2640", 0x30),
> +};
> +
> +static struct soc_camera_link iclink_ov2640 = {
> +	.bus_id		= 0,
> +	.board_info	= &i2c_camera,
> +	.i2c_adapter_id	= 0,
> +	.power		= i2c_camera_power,
> +	.query_bus_param	= isi_camera_query_bus_param,

You could as well make this alignment look better.

> +};
> +
> +static struct platform_device isi_ov2640 = {
> +	.name	= "soc-camera-pdrv",
> +	.id	= 0,
> +	.dev	= {
> +		.platform_data = &iclink_ov2640,
> +	},
> +};
> +
> +static struct platform_device *devices[] __initdata = {
> +	&isi_ov2640,
> +};
> +#else
> +static struct platform_device *devices[] __initdata = {};
> +#endif
>  
>  /*
>   * LCD Controller
> @@ -400,6 +479,10 @@ static void __init ek_board_init(void)
>  	ek_add_device_nand();
>  	/* I2C */
>  	at91_add_device_i2c(0, NULL, 0);
> +	/* ISI */
> +	platform_add_devices(devices, ARRAY_SIZE(devices));

"devices" is a generic name, but you make it depend on 
CONFIG_SOC_CAMERA_OV2640. Why don't you do

static struct platform_device *devices[] __initdata = {
#if defined(CONFIG_SOC_CAMERA_OV2640) || defined(CONFIG_SOC_CAMERA_OV2640_MODULE)
	&isi_ov2640,
#endif
};

and move

+	platform_add_devices(devices, ARRAY_SIZE(devices));

out of the /* ISI */ section to a more generic location?

> +	at91_add_device_isi(&isi_data);
> +
>  	/* LCD Controller */
>  	at91_add_device_lcdc(&ek_lcdc_data);
>  	/* Touch Screen */
> diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
> index ed544a0..276d63a 100644
> --- a/arch/arm/mach-at91/include/mach/board.h
> +++ b/arch/arm/mach-at91/include/mach/board.h
> @@ -183,7 +183,8 @@ extern void __init at91_add_device_lcdc(struct atmel_lcdfb_info *data);
>  extern void __init at91_add_device_ac97(struct ac97c_platform_data *data);
>  
>   /* ISI */
> -extern void __init at91_add_device_isi(void);
> +struct isi_platform_data;
> +extern void __init at91_add_device_isi(struct isi_platform_data *data);
>  
>   /* Touchscreen Controller */
>  struct at91_tsadcc_data {
> -- 
> 1.6.3.3

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
