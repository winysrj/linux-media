Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:47607 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751767Ab0IVGxN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 02:53:13 -0400
Date: Wed, 22 Sep 2010 08:53:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v2 2/6] OMAP1: Add support for SoC camera interface
In-Reply-To: <201009110323.12250.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1009220848580.32562@axis700.grange>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
 <201009110323.12250.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

That's up to the platform maintainer to review / apply this one, but if 
you like, a couple of nit-picks from me:

On Sat, 11 Sep 2010, Janusz Krzysztofik wrote:

> This patch adds support for SoC camera interface to OMAP1 devices.
> 
> Created and tested against linux-2.6.36-rc3 on Amstrad Delta.
> 
> For successfull compilation, requires a header file provided by PATCH 1/6 from 
> this series, "SoC Camera: add driver for OMAP1 camera interface".
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
> v1->v2 changes:
> - no functional changes,
> - refreshed against linux-2.6.36-rc3
> 
> 
>  arch/arm/mach-omap1/devices.c             |   43 
> ++++++++++++++++++++++++++++++
>  arch/arm/mach-omap1/include/mach/camera.h |    8 +++++
>  2 files changed, 51 insertions(+)
> 
> 
> diff -upr linux-2.6.36-rc3.orig/arch/arm/mach-omap1/devices.c 
> linux-2.6.36-rc3/arch/arm/mach-omap1/devices.c
> --- linux-2.6.36-rc3.orig/arch/arm/mach-omap1/devices.c	2010-09-03 
> 22:29:00.000000000 +0200
> +++ linux-2.6.36-rc3/arch/arm/mach-omap1/devices.c	2010-09-09 
> 18:42:30.000000000 +0200
> @@ -15,6 +15,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/spi/spi.h>
> +#include <linux/dma-mapping.h>
>  
>  #include <mach/hardware.h>
>  #include <asm/mach/map.h>
> @@ -25,6 +26,7 @@
>  #include <mach/gpio.h>
>  #include <plat/mmc.h>
>  #include <plat/omap7xx.h>
> +#include <mach/camera.h>

You might want to try to group headers according to their location, i.e., 
put <mach/...> higher - together with <mach/gpio.h>, also it helps to have 
headers alphabetically ordered.

>  
>  /*-------------------------------------------------------------------------*/
>  
> @@ -191,6 +193,47 @@ static inline void omap_init_spi100k(voi
>  }
>  #endif
>  
> +
> +#define OMAP1_CAMERA_BASE	0xfffb6800
> +
> +static struct resource omap1_camera_resources[] = {
> +	[0] = {
> +		.start	= OMAP1_CAMERA_BASE,
> +		.end	= OMAP1_CAMERA_BASE + OMAP1_CAMERA_IOSIZE - 1,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	[1] = {
> +		.start	= INT_CAMERA,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static u64 omap1_camera_dma_mask = DMA_BIT_MASK(32);
> +
> +static struct platform_device omap1_camera_device = {
> +	.name		= "omap1-camera",
> +	.id		= 0, /* This is used to put cameras on this interface */
> +	.dev		= {
> +		.dma_mask		= &omap1_camera_dma_mask,
> +		.coherent_dma_mask	= DMA_BIT_MASK(32),
> +	},
> +	.num_resources	= ARRAY_SIZE(omap1_camera_resources),
> +	.resource	= omap1_camera_resources,
> +};
> +
> +void __init omap1_set_camera_info(struct omap1_cam_platform_data *info)
> +{
> +	struct platform_device *dev = &omap1_camera_device;
> +	int ret;
> +
> +	dev->dev.platform_data = info;
> +
> +	ret = platform_device_register(dev);
> +	if (ret)
> +		dev_err(&dev->dev, "unable to register device: %d\n", ret);
> +}
> +
> +
>  /*-------------------------------------------------------------------------*/
>  
>  static inline void omap_init_sti(void) {}
> diff -upr linux-2.6.36-rc3.orig/arch/arm/mach-omap1/include/mach/camera.h 
> linux-2.6.36-rc3/arch/arm/mach-omap1/include/mach/camera.h
> --- linux-2.6.36-rc3.orig/arch/arm/mach-omap1/include/mach/camera.h	2010-09-03 
> 22:34:03.000000000 +0200
> +++ linux-2.6.36-rc3/arch/arm/mach-omap1/include/mach/camera.h	2010-09-09 
> 18:42:30.000000000 +0200
> @@ -0,0 +1,8 @@
> +#ifndef __ASM_ARCH_CAMERA_H_
> +#define __ASM_ARCH_CAMERA_H_
> +
> +#include <media/omap1_camera.h>
> +
> +extern void omap1_set_camera_info(struct omap1_cam_platform_data *);

function declarations don't need an "extern" - something I've also been 
doing needlessly for a few years...

> +
> +#endif /* __ASM_ARCH_CAMERA_H_ */

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
