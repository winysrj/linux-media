Return-path: <mchehab@pedra>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:37862 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753507Ab1BNMee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:34:34 -0500
Date: Mon, 14 Feb 2011 14:34:30 +0200
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH v6 03/10] omap3: Add function to register omap3isp
 platform device structure
Message-ID: <20110214123430.GX2549@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1297686097-9804-4-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297686097-9804-4-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Mon, Feb 14, 2011 at 01:21:30PM +0100, Laurent Pinchart wrote:
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index d389756..4cf48ea 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -34,6 +34,8 @@
>  #include "mux.h"
>  #include "control.h"
>  
> +#include "devices.h"
> +
>  #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
>  
>  static struct resource cam_resources[] = {
> @@ -59,8 +61,11 @@ static inline void omap_init_camera(void)
>  {
>  	platform_device_register(&omap_cam_device);
>  }
> -
> -#elif defined(CONFIG_VIDEO_OMAP3) || defined(CONFIG_VIDEO_OMAP3_MODULE)
> +#else
> +static inline void omap_init_camera(void)
> +{
> +}
> +#endif
>  
>  static struct resource omap3isp_resources[] = {
>  	{
> @@ -146,15 +151,12 @@ static struct platform_device omap3isp_device = {
>  	.resource	= omap3isp_resources,
>  };
>  
> -static inline void omap_init_camera(void)
> -{
> -	platform_device_register(&omap3isp_device);
> -}
> -#else
> -static inline void omap_init_camera(void)
> +int omap3_init_camera(void *pdata)
>  {
> +	omap3isp_device.dev.platform_data = pdata;
> +	return platform_device_register(&omap3isp_device);
>  }
> -#endif
> +EXPORT_SYMBOL_GPL(omap3_init_camera);

if you EXPORT_SYMBOL_GPL() then also modules can poke with this, right ?
isn't it enough to just put an "extern int omap3_init_camera(void *);"
on a header ?

BTW, you know the correct type of the platform_data, so why not passing
the correct type instead of void * ?? Then, compile will help you if you
pass wrong type, right ?

> diff --git a/arch/arm/mach-omap2/devices.h b/arch/arm/mach-omap2/devices.h
> new file mode 100644
> index 0000000..12ddb8a
> --- /dev/null
> +++ b/arch/arm/mach-omap2/devices.h
> @@ -0,0 +1,17 @@
> +/*
> + * arch/arm/mach-omap2/devices.h
> + *
> + * OMAP2 platform device setup/initialization
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef __ARCH_ARM_MACH_OMAP_DEVICES_H
> +#define __ARCH_ARM_MACH_OMAP_DEVICES_H
> +
> +int omap3_init_camera(void *pdata);

missing extern ?

-- 
balbi
