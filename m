Return-path: <mchehab@pedra>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:35363 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311Ab1BNNSe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 08:18:34 -0500
Date: Mon, 14 Feb 2011 15:18:29 +0200
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: balbi@ti.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH v6 03/10] omap3: Add function to register omap3isp
 platform device structure
Message-ID: <20110214131829.GC2549@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1297686097-9804-4-git-send-email-laurent.pinchart@ideasonboard.com>
 <20110214123430.GX2549@legolas.emea.dhcp.ti.com>
 <201102141407.09449.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102141407.09449.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Mon, Feb 14, 2011 at 02:07:08PM +0100, Laurent Pinchart wrote:
> > > diff --git a/arch/arm/mach-omap2/devices.h
> > > b/arch/arm/mach-omap2/devices.h new file mode 100644
> > > index 0000000..12ddb8a
> > > --- /dev/null
> > > +++ b/arch/arm/mach-omap2/devices.h
> > > @@ -0,0 +1,17 @@
> > > +/*
> > > + * arch/arm/mach-omap2/devices.h
> > > + *
> > > + * OMAP2 platform device setup/initialization
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License as published by
> > > + * the Free Software Foundation; either version 2 of the License, or
> > > + * (at your option) any later version.
> > > + */
> > > +
> > > +#ifndef __ARCH_ARM_MACH_OMAP_DEVICES_H
> > > +#define __ARCH_ARM_MACH_OMAP_DEVICES_H
> > > +
> > > +int omap3_init_camera(void *pdata);
> > 
> > missing extern ?
> 
> Is that mandatory ? Many (most ?) headers in the kernel don't use the extern 
> keyword when declaring functions.

maybe not mandatory, worth checking what sparse would say though :-p

-- 
balbi
