Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:65266 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab1LNSWo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 13:22:44 -0500
Date: Wed, 14 Dec 2011 19:22:29 +0100
From: martin@neutronstar.dyndns.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	Hiremath Vaibhav <hvaibhav@ti.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] arm: omap3evm: Add support for an MT9M032 based
 camera board.
References: <1323825934-13320-1-git-send-email-martin@neutronstar.dyndns.org>
 <4EE86CF7.1010002@compulab.co.il>
 <201112141415.23885.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112141415.23885.laurent.pinchart@ideasonboard.com>
Message-Id: <1323886950.295978.31313@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 14, 2011 at 02:15:22PM +0100, Laurent Pinchart wrote:
> Hi Igor,
> 
> On Wednesday 14 December 2011 10:31:35 Igor Grinberg wrote:
> > On 12/14/11 03:25, Martin Hostettler wrote:
> > > Adds board support for an MT9M032 based camera to omap3evm.
> > > 
> > > Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> 
> [snip]
> 
> > > diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c
> > > b/arch/arm/mach-omap2/board-omap3evm-camera.c new file mode 100644
> > > index 0000000..bffd5b8
> > > --- /dev/null
> > > +++ b/arch/arm/mach-omap2/board-omap3evm-camera.c
> > > @@ -0,0 +1,155 @@
> 
> [snip]
> 
> > > +#include <linux/i2c.h>
> > > +#include <linux/init.h>
> > > +#include <linux/platform_device.h>
> > > +
> > > +#include <linux/gpio.h>
> > > +#include <plat/mux.h>
> > > +#include "mux.h"
> > > +
> > > +#include "../../../drivers/media/video/omap3isp/isp.h"
> > 
> > Laurent,
> > In one of the previous reviews, you stated:
> > "I'll probably split it and move the part required by board files to
> > include/media/omap3isp.h".
> > Is there any progress on that?
> 
> Yes, it has been half-fixed in mainline. Half only because all the structures 
> and macros that should be used by board code are now in <media/omap3isp.h>, 
> but some boards need to access OMAP3 ISP internals from board code, which 
> still requires drivers/media/video/omap3isp/isp.h. This will eventually be 
> fixed, when the generic struct clk object will be available.
> 
> After a quick look at this patch it seems that <media/omap3isp.h> should be 
> enough here.

Almost. The code uses ISPCTRL_PAR_BRIDGE_DISABLE which is only available
from drivers/media/video/omap3isp/ispreg.h.

So i'd say it's better to keep that include than to duplicate this constant
in the code.

What do you think?

By the way, it seems drivers/media/video/omap3isp/ispvideo.c is missing a 
#include <linux/module.h> at the moment. I had to patch that line in to get
omap3isp to compile as module.

> 
> > > +#include "media/mt9m032.h"
> 
> And this should be <media/mt9m032.h>

I'll change this.

Regards,
 - Martin Hostettler

> 
> > > +#include "devices.h"
> 
> -- 
> Regards,
> 
> Laurent Pinchart
