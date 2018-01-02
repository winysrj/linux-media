Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50813 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbeABP1E (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 10:27:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/9] arch: sh: migor: Use new renesas-ceu camera driver
Date: Tue, 02 Jan 2018 17:27:23 +0200
Message-ID: <2694494.0TyqU6XxnB@avalon>
In-Reply-To: <1514469681-15602-6-git-send-email-jacopo+renesas@jmondi.org>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org> <1514469681-15602-6-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

As pointed out by the 0day bot, you should move this patch to the end of the 
series to avoid breaking compilation.

On Thursday, 28 December 2017 16:01:17 EET Jacopo Mondi wrote:
> Migo-R platform uses sh_mobile_ceu camera driver, which is now being
> replaced by a proper V4L2 camera driver named 'renesas-ceu'.
> 
> Move Migo-R platform to use the v4l2 renesas-ceu camera driver
> interface and get rid of soc_camera defined components used to register
> sensor drivers and of platform specific enable/disable routines.
> 
> Register clock source and GPIOs for sensor drivers, so they can use
> clock and gpio APIs.
> 
> Also, memory for CEU video buffers is now reserved with membocks APIs,
> and need to be declared as dma_coherent during machine initialization to
> remove that architecture specific part from CEU driver.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  arch/sh/boards/mach-migor/setup.c      | 213 +++++++++++++----------------
>  arch/sh/kernel/cpu/sh4a/clock-sh7722.c |   2 +-
>  2 files changed, 89 insertions(+), 126 deletions(-)
> 
> diff --git a/arch/sh/boards/mach-migor/setup.c
> b/arch/sh/boards/mach-migor/setup.c index 0bcbe58..6eab2ac 100644
> --- a/arch/sh/boards/mach-migor/setup.c
> +++ b/arch/sh/boards/mach-migor/setup.c

[snip]

> @@ -301,65 +304,24 @@ static struct platform_device migor_lcdc_device = {
>  	},
>  };
> 
> -static struct clk *camera_clk;
> -static DEFINE_MUTEX(camera_lock);
> -
> -static void camera_power_on(int is_tw)
> -{
> -	mutex_lock(&camera_lock);
> -
> -	/* Use 10 MHz VIO_CKO instead of 24 MHz to work
> -	 * around signal quality issues on Panel Board V2.1.
> -	 */
> -	camera_clk = clk_get(NULL, "video_clk");
> -	clk_set_rate(camera_clk, 10000000);
> -	clk_enable(camera_clk);	/* start VIO_CKO */
> -
> -	/* use VIO_RST to take camera out of reset */
> -	mdelay(10);
> -	if (is_tw) {
> -		gpio_set_value(GPIO_PTT2, 0);
> -		gpio_set_value(GPIO_PTT0, 0);
> -	} else {
> -		gpio_set_value(GPIO_PTT0, 1);
> -	}
> -	gpio_set_value(GPIO_PTT3, 0);
> -	mdelay(10);
> -	gpio_set_value(GPIO_PTT3, 1);
> -	mdelay(10); /* wait to let chip come out of reset */
> -}
> -
> -static void camera_power_off(void)
> -{
> -	clk_disable(camera_clk); /* stop VIO_CKO */
> -	clk_put(camera_clk);
> -
> -	gpio_set_value(GPIO_PTT3, 0);
> -	mutex_unlock(&camera_lock);
> -}
> -
> -static int ov7725_power(struct device *dev, int mode)
> -{
> -	if (mode)
> -		camera_power_on(0);
> -	else
> -		camera_power_off();
> -
> -	return 0;
> -}
> -
> -static int tw9910_power(struct device *dev, int mode)
> -{
> -	if (mode)
> -		camera_power_on(1);
> -	else
> -		camera_power_off();
> -
> -	return 0;
> -}

I really like this :-)

> -static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
> -	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
> +static struct ceu_info ceu_info = {
> +	.num_subdevs			= 2,
> +	.subdevs = {
> +		{ /* [0] = ov772x */
> +			.flags		= 0,
> +			.bus_width	= 8,
> +			.bus_shift	= 0,
> +			.i2c_adapter_id	= 0,
> +			.i2c_address	= 0x21,
> +		},
> +		{ /* [1] = tw9910 */
> +			.flags		= 0,
> +			.bus_width	= 8,
> +			.bus_shift	= 0,
> +			.i2c_adapter_id	= 0,
> +			.i2c_address	= 0x45,
> +		},
> +	},
>  };

Shouldn't this be const ?
> 
>  static struct resource migor_ceu_resources[] = {
> @@ -373,18 +335,32 @@ static struct resource migor_ceu_resources[] = {
>  		.start  = evt2irq(0x880),
>  		.flags  = IORESOURCE_IRQ,
>  	},
> -	[2] = {
> -		/* place holder for contiguous memory */
> -	},
>  };
> 
>  static struct platform_device migor_ceu_device = {
> -	.name		= "sh_mobile_ceu",
> -	.id             = 0, /* "ceu0" clock */
> +	.name		= "renesas-ceu",
> +	.id             = 0, /* ceu.0 */
>  	.num_resources	= ARRAY_SIZE(migor_ceu_resources),
>  	.resource	= migor_ceu_resources,
>  	.dev	= {
> -		.platform_data	= &sh_mobile_ceu_info,
> +		.platform_data	= &ceu_info,
> +	},
> +};
> +
> +/* Powerdown/reset gpios for CEU image sensors */
> +static struct gpiod_lookup_table ov7725_gpios = {
> +	.dev_id		= "0-0021",
> +	.table		= {
> +		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT0, "pwdn", GPIO_ACTIVE_HIGH),
> +		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT3, "rstb", GPIO_ACTIVE_HIGH),
> +	},
> +};
> +
> +static struct gpiod_lookup_table tw9910_gpios = {
> +	.dev_id		= "0-0045",
> +	.table		= {
> +		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT2, "pdn", GPIO_ACTIVE_HIGH),
> +		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT3, "rstb", GPIO_ACTIVE_HIGH),
>  	},
>  };

This looks good to me. We still have the issue of the shared PTT3 GPIO that we 
should fix somehow. I see you've solved that by only requesting the GPIO when 
powering up the OV7725 and TW9910 in the respective drivers but that's more a 
workaround than a proper solution. In any case I'm fine with the board file 
here.

> @@ -423,6 +399,15 @@ static struct platform_device sdhi_cn9_device = {
>  	},
>  };
> 
> +static struct ov772x_camera_info ov7725_info = {
> +	.xclk_rate	= 10000000,
> +};
> +
> +static struct tw9910_video_info tw9910_info = {
> +	.buswidth       = 8,
> +	.mpout          = TW9910_MPO_FIELD,
> +};

Shouldn't those two structures be const ?

>  static struct i2c_board_info migor_i2c_devices[] = {
>  	{
>  		I2C_BOARD_INFO("rs5c372b", 0x32),

[snip]

> @@ -647,9 +579,26 @@ static int __init migor_devices_setup(void)
>  	 */
>  	__raw_writew(__raw_readw(PORT_MSELCRA) | 1, PORT_MSELCRA);
> 
> +	/* Add a clock alias for ov7725 xclk source. */
> +	clk_add_alias("xclk", NULL, "video_clk", NULL);

The second argument should be the ov7725 device name as the clock is not 
global.

> +	/* Register GPIOs for image sensors. */

Technically speaking the tw9910 is not a sensor. Maybe "for video sources" ?

> +	gpiod_add_lookup_table(&ov7725_gpios);
> +	gpiod_add_lookup_table(&tw9910_gpios);
> +
>  	i2c_register_board_info(0, migor_i2c_devices,
>  				ARRAY_SIZE(migor_i2c_devices));
> 
> +	/* Initialize CEU platform device separately to map memory first */
> +	device_initialize(&migor_ceu_device.dev);
> +	arch_setup_pdev_archdata(&migor_ceu_device);
> +	dma_declare_coherent_memory(&migor_ceu_device.dev,
> +				    ceu_dma_membase, ceu_dma_membase,
> +				    ceu_dma_membase + CEU_BUFFER_MEMORY_SIZE - 1,
> +				    DMA_MEMORY_EXCLUSIVE);
> +
> +	platform_device_add(&migor_ceu_device);
> +
>  	return platform_add_devices(migor_devices, ARRAY_SIZE(migor_devices));
>  }
>  arch_initcall(migor_devices_setup);

[snip]

With all these minor issues fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
