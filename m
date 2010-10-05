Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:50767 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246Ab0JEQJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 12:09:54 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Tue, 5 Oct 2010 11:09:45 -0500
Subject: RE: [RFC/PATCH v2 5/6] omap3: Export omap3isp platform device
 structure
Message-ID: <A24693684029E5489D1D202277BE894472B4F82F@dlee02.ent.ti.com>
References: <1286284734-12292-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1286284734-12292-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286284734-12292-6-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Tuesday, October 05, 2010 8:19 AM
> To: linux-media@vger.kernel.org
> Cc: sakari.ailus@maxwell.research.nokia.com
> Subject: [RFC/PATCH v2 5/6] omap3: Export omap3isp platform device
> structure
> 
> From: Stanimir Varbanov <svarbanov@mm-sol.com>
> 
> The omap3isp platform device requires platform data. As the data can be
> provided by a kernel module, the device can't be registered during arch
> initialization.
> 
> Remove the omap3isp platform device registration from
> omap_init_camera(), and export the platform device structure to let
> board code register/unregister it.
> 

This patch needs to go through linux-omap ML.

Regards,
Sergio

> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  arch/arm/mach-omap2/devices.c |   18 ++++++++++++++++--
>  arch/arm/mach-omap2/devices.h |   17 +++++++++++++++++
>  2 files changed, 33 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/devices.h
> 
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index ade8db0..f9bc507 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -31,6 +31,8 @@
> 
>  #include "mux.h"
> 
> +#include "devices.h"
> +
>  #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
> 
>  static struct resource cam_resources[] = {
> @@ -141,16 +143,28 @@ static struct resource omap3isp_resources[] = {
>  	}
>  };
> 
> -static struct platform_device omap3isp_device = {
> +static void omap3isp_release(struct device *dev)
> +{
> +	/* Zero the device structure to avoid re-initialization complaints
> from
> +	 * kobject when the device will be re-registered.
> +	 */
> +	memset(dev, 0, sizeof(*dev));
> +	dev->release = omap3isp_release;
> +}
> +
> +struct platform_device omap3isp_device = {
>  	.name		= "omap3isp",
>  	.id		= -1,
>  	.num_resources	= ARRAY_SIZE(omap3isp_resources),
>  	.resource	= omap3isp_resources,
> +	.dev = {
> +		.release	= omap3isp_release,
> +	},
>  };
> +EXPORT_SYMBOL_GPL(omap3isp_device);
> 
>  static inline void omap_init_camera(void)
>  {
> -	platform_device_register(&omap3isp_device);
>  }
>  #else
>  static inline void omap_init_camera(void)
> diff --git a/arch/arm/mach-omap2/devices.h b/arch/arm/mach-omap2/devices.h
> new file mode 100644
> index 0000000..f312d49
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
> +extern struct platform_device omap3isp_device;
> +
> +#endif
> --
> 1.7.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
