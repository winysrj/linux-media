Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:35533 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab0IVSVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 14:21:21 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2 2/6] OMAP1: Add support for SoC camera interface
Date: Wed, 22 Sep 2010 20:20:52 +0200
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl> <201009110323.12250.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1009220848580.32562@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1009220848580.32562@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201009222020.53798.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Wednesday 22 September 2010 08:53:19 Guennadi Liakhovetski napisał(a):
> That's up to the platform maintainer to review / apply this one, but if
> you like, a couple of nit-picks from me:

Guennadi,
Thanks for also looking at this!

> On Sat, 11 Sep 2010, Janusz Krzysztofik wrote:
> > This patch adds support for SoC camera interface to OMAP1 devices.
> >
> > Created and tested against linux-2.6.36-rc3 on Amstrad Delta.
> >
> > For successfull compilation, requires a header file provided by PATCH 1/6
> > from this series, "SoC Camera: add driver for OMAP1 camera interface".
> >
> > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > ---
> > v1->v2 changes:
> > - no functional changes,
> > - refreshed against linux-2.6.36-rc3
> >
> >
> >  arch/arm/mach-omap1/devices.c             |   43
> > ++++++++++++++++++++++++++++++
> >  arch/arm/mach-omap1/include/mach/camera.h |    8 +++++
> >  2 files changed, 51 insertions(+)
> >
> >
> > diff -upr linux-2.6.36-rc3.orig/arch/arm/mach-omap1/devices.c
> > linux-2.6.36-rc3/arch/arm/mach-omap1/devices.c
> > --- linux-2.6.36-rc3.orig/arch/arm/mach-omap1/devices.c	2010-09-03
> > 22:29:00.000000000 +0200
> > +++ linux-2.6.36-rc3/arch/arm/mach-omap1/devices.c	2010-09-09
> > 18:42:30.000000000 +0200
> > @@ -15,6 +15,7 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/io.h>
> >  #include <linux/spi/spi.h>
> > +#include <linux/dma-mapping.h>
> >
> >  #include <mach/hardware.h>
> >  #include <asm/mach/map.h>
> > @@ -25,6 +26,7 @@
> >  #include <mach/gpio.h>
> >  #include <plat/mmc.h>
> >  #include <plat/omap7xx.h>
> > +#include <mach/camera.h>
>
> You might want to try to group headers according to their location, i.e.,
> put <mach/...> higher - together with <mach/gpio.h>, also it helps to have
> headers alphabetically ordered.

Yes, I will, thank you.

> > 
> > /*-----------------------------------------------------------------------
> >--*/
> >
> > @@ -191,6 +193,47 @@ static inline void omap_init_spi100k(voi
> >  }
> >  #endif
> >
> > +
> > +#define OMAP1_CAMERA_BASE	0xfffb6800
> > +
> > +static struct resource omap1_camera_resources[] = {
> > +	[0] = {
> > +		.start	= OMAP1_CAMERA_BASE,
> > +		.end	= OMAP1_CAMERA_BASE + OMAP1_CAMERA_IOSIZE - 1,
> > +		.flags	= IORESOURCE_MEM,
> > +	},
> > +	[1] = {
> > +		.start	= INT_CAMERA,
> > +		.flags	= IORESOURCE_IRQ,
> > +	},
> > +};
> > +
> > +static u64 omap1_camera_dma_mask = DMA_BIT_MASK(32);
> > +
> > +static struct platform_device omap1_camera_device = {
> > +	.name		= "omap1-camera",
> > +	.id		= 0, /* This is used to put cameras on this interface */
> > +	.dev		= {
> > +		.dma_mask		= &omap1_camera_dma_mask,
> > +		.coherent_dma_mask	= DMA_BIT_MASK(32),
> > +	},
> > +	.num_resources	= ARRAY_SIZE(omap1_camera_resources),
> > +	.resource	= omap1_camera_resources,
> > +};
> > +
> > +void __init omap1_set_camera_info(struct omap1_cam_platform_data *info)
> > +{
> > +	struct platform_device *dev = &omap1_camera_device;
> > +	int ret;
> > +
> > +	dev->dev.platform_data = info;
> > +
> > +	ret = platform_device_register(dev);
> > +	if (ret)
> > +		dev_err(&dev->dev, "unable to register device: %d\n", ret);
> > +}
> > +
> > +
> > 
> > /*-----------------------------------------------------------------------
> >--*/
> >
> >  static inline void omap_init_sti(void) {}
> > diff -upr linux-2.6.36-rc3.orig/arch/arm/mach-omap1/include/mach/camera.h
> > linux-2.6.36-rc3/arch/arm/mach-omap1/include/mach/camera.h
> > ---
> > linux-2.6.36-rc3.orig/arch/arm/mach-omap1/include/mach/camera.h	2010-09-0
> >3 22:34:03.000000000 +0200
> > +++ linux-2.6.36-rc3/arch/arm/mach-omap1/include/mach/camera.h	2010-09-09
> > 18:42:30.000000000 +0200
> > @@ -0,0 +1,8 @@
> > +#ifndef __ASM_ARCH_CAMERA_H_
> > +#define __ASM_ARCH_CAMERA_H_
> > +
> > +#include <media/omap1_camera.h>
> > +
> > +extern void omap1_set_camera_info(struct omap1_cam_platform_data *);
>
> function declarations don't need an "extern" - something I've also been
> doing needlessly for a few years...

Good to know. I'll drop it.

Tony,
Any comments from you before I submit a hopefully final version?

Thanks,
Janusz

> > +
> > +#endif /* __ASM_ARCH_CAMERA_H_ */
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


