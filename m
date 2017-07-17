Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44482 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751336AbdGQWUz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 18:20:55 -0400
Date: Tue, 18 Jul 2017 01:20:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 11/13] gpio-switch is for some reason neccessary for camera
 to work.
Message-ID: <20170717222051.byilkg3x7lljlyja@valkosipuli.retiisi.org.uk>
References: <20170214134019.GA8631@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170214134019.GA8631@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tue, Feb 14, 2017 at 02:40:19PM +0100, Pavel Machek wrote:
> Probably something fun happening in userspace.

What's the status of this one?

I don't think it has a chance to be merged in the foreseeable future. Why
is it needed?

> ---
>  arch/arm/mach-omap2/Makefile                 |  1 +
>  arch/arm/mach-omap2/board-rx51-peripherals.c | 51 ++++++++++++++++++++++++++++
>  2 files changed, 52 insertions(+)
>  create mode 100644 arch/arm/mach-omap2/board-rx51-peripherals.c
> 
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index 4698940..d536b1a 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -229,6 +229,7 @@ obj-$(CONFIG_SOC_OMAP2420)		+= msdi.o
>  # Specific board support
>  obj-$(CONFIG_MACH_OMAP_GENERIC)		+= board-generic.o pdata-quirks.o
>  obj-$(CONFIG_MACH_NOKIA_N8X0)		+= board-n8x0.o
> +obj-y					+= board-rx51-peripherals.o
>  
>  # Platform specific device init code
>  
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> new file mode 100644
> index 0000000..641c2be
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -0,0 +1,51 @@
> +/*
> + * linux/arch/arm/mach-omap2/board-rx51-peripherals.c
> + *
> + * Copyright (C) 2008-2009 Nokia
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/gpio_keys.h>
> +#include <linux/gpio/machine.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/timer.h>
> +
> +static struct platform_driver gpio_sw_driver = {
> +	.driver		= {
> +		.name	= "gpio-switch",
> +	},
> +};
> +
> +static int __init gpio_sw_init(void)
> +{
> +	int r;
> +
> +	printk(KERN_INFO "OMAP GPIO switch handler initializing\n");
> +
> +	r = platform_driver_register(&gpio_sw_driver);
> +	if (r)
> +		return r;
> +
> +	platform_device_register_simple("gpio-switch",
> +							       -1, NULL, 0);
> +	return 0;
> +}
> +
> +static void __exit gpio_sw_exit(void)
> +{
> +}
> +
> +#ifndef MODULE
> +late_initcall(gpio_sw_init);
> +#else
> +module_init(gpio_sw_init);
> +#endif
> +module_exit(gpio_sw_exit);
> -- 
> 2.1.4

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
