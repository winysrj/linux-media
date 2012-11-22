Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60361 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2KVXvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 18:51:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	devicetree-discuss@lists.ozlabs.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>, kernel@pengutronix.de,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCHv13 4/7] fbmon: add videomode helpers
Date: Fri, 23 Nov 2012 00:52:08 +0100
Message-ID: <2692338.s0PjnOCRb5@avalon>
In-Reply-To: <20121122230949.GA8698@pengutronix.de>
References: <1353600015-6974-1-git-send-email-s.trumtrar@pengutronix.de> <2107534.vAYnU9M0ZA@avalon> <20121122230949.GA8698@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 23 November 2012 00:09:49 Steffen Trumtrar wrote:
> On Thu, Nov 22, 2012 at 07:31:39PM +0100, Laurent Pinchart wrote:
> > On Thursday 22 November 2012 17:00:12 Steffen Trumtrar wrote:
> > > Add a function to convert from the generic videomode to a fb_videomode.
> > > 
> > > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > > Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > > ---
> > > 
> > >  drivers/video/fbmon.c |   44 ++++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/fb.h    |    6 ++++++
> > >  2 files changed, 50 insertions(+)
> > > 
> > > diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> > > index cef6557..a6a564d 100644
> > > --- a/drivers/video/fbmon.c
> > > +++ b/drivers/video/fbmon.c
> > > @@ -31,6 +31,7 @@
> > > 
> > >  #include <linux/pci.h>
> > >  #include <linux/slab.h>
> > >  #include <video/edid.h>
> > > 
> > > +#include <linux/videomode.h>
> > > 
> > >  #ifdef CONFIG_PPC_OF
> > >  #include <asm/prom.h>
> > >  #include <asm/pci-bridge.h>
> > > 
> > > @@ -1373,6 +1374,49 @@ int fb_get_mode(int flags, u32 val, struct
> > > fb_var_screeninfo *var, struct fb_inf kfree(timings);
> > > 
> > >  	return err;
> > >  
> > >  }
> > > 
> > > +
> > > +#if IS_ENABLED(CONFIG_VIDEOMODE)
> > > +int fb_videomode_from_videomode(const struct videomode *vm,
> > > +				struct fb_videomode *fbmode)
> > > +{
> > > +	unsigned int htotal, vtotal;
> > > +
> > > +	fbmode->xres = vm->hactive;
> > > +	fbmode->left_margin = vm->hback_porch;
> > > +	fbmode->right_margin = vm->hfront_porch;
> > > +	fbmode->hsync_len = vm->hsync_len;
> > > +
> > > +	fbmode->yres = vm->vactive;
> > > +	fbmode->upper_margin = vm->vback_porch;
> > > +	fbmode->lower_margin = vm->vfront_porch;
> > > +	fbmode->vsync_len = vm->vsync_len;
> > > +
> > > +	fbmode->pixclock = KHZ2PICOS(vm->pixelclock / 1000);
> > 
> > This results in a division by 0 if vm->pixelclock is equal to zero. As the
> > information is missing from many board files, what would you think about
> > the following ?
> > 
> > 	fbmode->pixclock = vm->pixelclock ? KHZ2PICOS(vm->pixelclock / 1000) : 0;
> 
> Grrr...you are right. I will fix that...

Thank you.

> > > +	htotal = vm->hactive + vm->hfront_porch + vm->hback_porch +
> > > +		 vm->hsync_len;
> > > +	vtotal = vm->vactive + vm->vfront_porch + vm->vback_porch +
> > > +		 vm->vsync_len;
> > > +	fbmode->refresh = vm->pixelclock / (htotal * vtotal);
> > > +
> 
> ...and obviously this, too.

That one is less of an issue in my opinion. A mode with a zero htotal or 
vtotal is clearly invalid, while we have modes with no pixel clock value.

-- 
Regards,

Laurent Pinchart

