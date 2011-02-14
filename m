Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45289 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab1BNNHG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 08:07:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: balbi@ti.com
Subject: Re: [PATCH v6 03/10] omap3: Add function to register omap3isp platform device structure
Date: Mon, 14 Feb 2011 14:07:08 +0100
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com> <1297686097-9804-4-git-send-email-laurent.pinchart@ideasonboard.com> <20110214123430.GX2549@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110214123430.GX2549@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102141407.09449.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Felipe,

On Monday 14 February 2011 13:34:30 Felipe Balbi wrote:
> On Mon, Feb 14, 2011 at 01:21:30PM +0100, Laurent Pinchart wrote:
> > diff --git a/arch/arm/mach-omap2/devices.c
> > b/arch/arm/mach-omap2/devices.c index d389756..4cf48ea 100644
> > --- a/arch/arm/mach-omap2/devices.c
> > +++ b/arch/arm/mach-omap2/devices.c
> > @@ -34,6 +34,8 @@

[snip]

> > +int omap3_init_camera(void *pdata)
> >  {
> > +	omap3isp_device.dev.platform_data = pdata;
> > +	return platform_device_register(&omap3isp_device);
> >  }
> > -#endif
> > +EXPORT_SYMBOL_GPL(omap3_init_camera);
> 
> if you EXPORT_SYMBOL_GPL() then also modules can poke with this, right ?
> isn't it enough to just put an "extern int omap3_init_camera(void *);"
> on a header ?

It wasn't before as board code needed to be compiled as a module, but we've 
fixed that. I'll remove the EXPORT_SYMBOL_GPL.

> BTW, you know the correct type of the platform_data, so why not passing
> the correct type instead of void * ?? Then, compile will help you if you
> pass wrong type, right ?

Agreed. I'll fix that.

> > diff --git a/arch/arm/mach-omap2/devices.h
> > b/arch/arm/mach-omap2/devices.h new file mode 100644
> > index 0000000..12ddb8a
> > --- /dev/null
> > +++ b/arch/arm/mach-omap2/devices.h
> > @@ -0,0 +1,17 @@
> > +/*
> > + * arch/arm/mach-omap2/devices.h
> > + *
> > + * OMAP2 platform device setup/initialization
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#ifndef __ARCH_ARM_MACH_OMAP_DEVICES_H
> > +#define __ARCH_ARM_MACH_OMAP_DEVICES_H
> > +
> > +int omap3_init_camera(void *pdata);
> 
> missing extern ?

Is that mandatory ? Many (most ?) headers in the kernel don't use the extern 
keyword when declaring functions.

-- 
Regards,

Laurent Pinchart
