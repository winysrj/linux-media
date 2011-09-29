Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:21566 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753892Ab1I2Qht (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 12:37:49 -0400
Date: Thu, 29 Sep 2011 09:37:40 -0700
From: Tony Lindgren <tony@atomide.com>
To: Deepthy Ravi <deepthy.ravi@ti.com>
Cc: laurent.pinchart@ideasonboard.com, mchehab@infradead.org,
	hvaibhav@ti.com, linux-media@vger.kernel.org,
	linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	m.szyprowski@samsung.com, g.liakhovetski@gmx.de,
	santosh.shilimkar@ti.com, khilman@deeprootsystems.com,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 3/5] omap3evm: Add Camera board init/hookup file
Message-ID: <20110929163740.GH6324@atomide.com>
References: <1317130848-21136-1-git-send-email-deepthy.ravi@ti.com>
 <1317130848-21136-4-git-send-email-deepthy.ravi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317130848-21136-4-git-send-email-deepthy.ravi@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Few comments below.

* Deepthy Ravi <deepthy.ravi@ti.com> [110927 06:07]:
> +
> +#include <linux/io.h>
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/gpio.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <mach/gpio.h>

You can leave out mach/gpio.h as you already have linux/gpio.h
included.

> +static int __init omap3evm_cam_init(void)
> +{
> +	int ret;
> +
> +	ret = gpio_request_array(omap3evm_gpios,
> +			ARRAY_SIZE(omap3evm_gpios));
> +	if (ret < 0) {
> +		printk(KERN_ERR "Unable to get GPIO pins\n");
> +		return ret;
> +	}
> +
> +	omap3_init_camera(&omap3evm_isp_platform_data);
> +
> +	printk(KERN_INFO "omap3evm camera init done successfully...\n");
> +	return 0;
> +}
> +
> +static void __exit omap3evm_cam_exit(void)
> +{
> +	gpio_free_array(omap3evm_gpios,
> +			ARRAY_SIZE(omap3evm_gpios));
> +}
> +
> +module_init(omap3evm_cam_init);
> +module_exit(omap3evm_cam_exit);

Looks like most of this file should be under drivers/media.

For initializing the module you should pass some platform_data
(until we have DT doing it) so you know that the camera is
available on the booted board or not. Now the init tries to
wrongly initialize things on other boards too.


> --- a/arch/arm/mach-omap2/board-omap3evm.c
> +++ b/arch/arm/mach-omap2/board-omap3evm.c
> @@ -573,6 +573,8 @@ static struct omap_board_mux omap35x_board_mux[] __initdata = {
>  				OMAP_PIN_OFF_NONE),
>  	OMAP3_MUX(GPMC_WAIT2, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP |
>  				OMAP_PIN_OFF_NONE),
> +	OMAP3_MUX(MCBSP1_FSR, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP |
> +				OMAP_PIN_OFF_NONE),
>  #ifdef CONFIG_WL12XX_PLATFORM_DATA
>  	/* WLAN IRQ - GPIO 149 */
>  	OMAP3_MUX(UART1_RTS, OMAP_MUX_MODE4 | OMAP_PIN_INPUT),
> @@ -598,6 +600,8 @@ static struct omap_board_mux omap36x_board_mux[] __initdata = {
>  	OMAP3_MUX(MCSPI1_CS1, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP |
>  				OMAP_PIN_OFF_INPUT_PULLUP | OMAP_PIN_OFF_OUTPUT_LOW |
>  				OMAP_PIN_OFF_WAKEUPENABLE),
> +	OMAP3_MUX(MCBSP1_FSR, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP |
> +				OMAP_PIN_OFF_NONE),
>  	/* AM/DM37x EVM: DSS data bus muxed with sys_boot */
>  	OMAP3_MUX(DSS_DATA18, OMAP_MUX_MODE3 | OMAP_PIN_OFF_NONE),
>  	OMAP3_MUX(DSS_DATA19, OMAP_MUX_MODE3 | OMAP_PIN_OFF_NONE),

Is this safe to do on all boards, or only if you have the camera
board attached?

Regards,

Tony
