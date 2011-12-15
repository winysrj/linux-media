Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34647 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab1LOMCB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 07:02:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: martin@neutronstar.dyndns.org
Subject: Re: [PATCH v3] arm: omap3evm: Add support for an MT9M032 based camera board.
Date: Thu, 15 Dec 2011 13:02:17 +0100
Cc: Igor Grinberg <grinberg@compulab.co.il>,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	Hiremath Vaibhav <hvaibhav@ti.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1323825934-13320-1-git-send-email-martin@neutronstar.dyndns.org> <201112141415.23885.laurent.pinchart@ideasonboard.com> <1323886950.295978.31313@localhost>
In-Reply-To: <1323886950.295978.31313@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112151302.18508.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Wednesday 14 December 2011 19:22:29 martin@neutronstar.dyndns.org wrote:
> On Wed, Dec 14, 2011 at 02:15:22PM +0100, Laurent Pinchart wrote:
> > On Wednesday 14 December 2011 10:31:35 Igor Grinberg wrote:
> > > On 12/14/11 03:25, Martin Hostettler wrote:
> > > > Adds board support for an MT9M032 based camera to omap3evm.
> > > > 
> > > > Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> > 
> > [snip]
> > 
> > > > diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c
> > > > b/arch/arm/mach-omap2/board-omap3evm-camera.c new file mode 100644
> > > > index 0000000..bffd5b8
> > > > --- /dev/null
> > > > +++ b/arch/arm/mach-omap2/board-omap3evm-camera.c
> > > > @@ -0,0 +1,155 @@
> > 
> > [snip]
> > 
> > > > +#include <linux/i2c.h>
> > > > +#include <linux/init.h>
> > > > +#include <linux/platform_device.h>
> > > > +
> > > > +#include <linux/gpio.h>
> > > > +#include <plat/mux.h>
> > > > +#include "mux.h"
> > > > +
> > > > +#include "../../../drivers/media/video/omap3isp/isp.h"
> > > 
> > > Laurent,
> > > In one of the previous reviews, you stated:
> > > "I'll probably split it and move the part required by board files to
> > > include/media/omap3isp.h".
> > > Is there any progress on that?
> > 
> > Yes, it has been half-fixed in mainline. Half only because all the
> > structures and macros that should be used by board code are now in
> > <media/omap3isp.h>, but some boards need to access OMAP3 ISP internals
> > from board code, which still requires
> > drivers/media/video/omap3isp/isp.h. This will eventually be fixed, when
> > the generic struct clk object will be available.
> > 
> > After a quick look at this patch it seems that <media/omap3isp.h> should
> > be enough here.
> 
> Almost. The code uses ISPCTRL_PAR_BRIDGE_DISABLE which is only available
> from drivers/media/video/omap3isp/ispreg.h.
>
> So i'd say it's better to keep that include than to duplicate this constant
> in the code.
> 
> What do you think?

You should use ISP_BRIDGE_DISABLE instead. That one is defined in 
<media/omap3isp.h>
 
> By the way, it seems drivers/media/video/omap3isp/ispvideo.c is missing a
> #include <linux/module.h> at the moment. I had to patch that line in to get
> omap3isp to compile as module.

http://patchwork.linuxtv.org/patch/8510/

The fix should get in v3.2.

-- 
Regards,

Laurent Pinchart
