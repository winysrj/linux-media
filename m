Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33034 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2KVXJ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 18:09:58 -0500
Date: Fri, 23 Nov 2012 00:09:49 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	devicetree-discuss@lists.ozlabs.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>, kernel@pengutronix.de,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCHv13 4/7] fbmon: add videomode helpers
Message-ID: <20121122230949.GA8698@pengutronix.de>
References: <1353600015-6974-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353600015-6974-5-git-send-email-s.trumtrar@pengutronix.de>
 <2107534.vAYnU9M0ZA@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2107534.vAYnU9M0ZA@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 22, 2012 at 07:31:39PM +0100, Laurent Pinchart wrote:
> Hi Steffen,
> 
> On Thursday 22 November 2012 17:00:12 Steffen Trumtrar wrote:
> > Add a function to convert from the generic videomode to a fb_videomode.
> > 
> > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > ---
> >  drivers/video/fbmon.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/fb.h    |    6 ++++++
> >  2 files changed, 50 insertions(+)
> > 
> > diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> > index cef6557..a6a564d 100644
> > --- a/drivers/video/fbmon.c
> > +++ b/drivers/video/fbmon.c
> > @@ -31,6 +31,7 @@
> >  #include <linux/pci.h>
> >  #include <linux/slab.h>
> >  #include <video/edid.h>
> > +#include <linux/videomode.h>
> >  #ifdef CONFIG_PPC_OF
> >  #include <asm/prom.h>
> >  #include <asm/pci-bridge.h>
> > @@ -1373,6 +1374,49 @@ int fb_get_mode(int flags, u32 val, struct
> > fb_var_screeninfo *var, struct fb_inf kfree(timings);
> >  	return err;
> >  }
> > +
> > +#if IS_ENABLED(CONFIG_VIDEOMODE)
> > +int fb_videomode_from_videomode(const struct videomode *vm,
> > +				struct fb_videomode *fbmode)
> > +{
> > +	unsigned int htotal, vtotal;
> > +
> > +	fbmode->xres = vm->hactive;
> > +	fbmode->left_margin = vm->hback_porch;
> > +	fbmode->right_margin = vm->hfront_porch;
> > +	fbmode->hsync_len = vm->hsync_len;
> > +
> > +	fbmode->yres = vm->vactive;
> > +	fbmode->upper_margin = vm->vback_porch;
> > +	fbmode->lower_margin = vm->vfront_porch;
> > +	fbmode->vsync_len = vm->vsync_len;
> > +
> > +	fbmode->pixclock = KHZ2PICOS(vm->pixelclock / 1000);
> 
> This results in a division by 0 if vm->pixelclock is equal to zero. As the 
> information is missing from many board files, what would you think about the 
> following ?
> 
> 	fbmode->pixclock = vm->pixelclock ? KHZ2PICOS(vm->pixelclock / 1000) : 0;
> 

Grrr...you are right. I will fix that...

> > +	htotal = vm->hactive + vm->hfront_porch + vm->hback_porch +
> > +		 vm->hsync_len;
> > +	vtotal = vm->vactive + vm->vfront_porch + vm->vback_porch +
> > +		 vm->vsync_len;
> > +	fbmode->refresh = vm->pixelclock / (htotal * vtotal);
> > +

...and obviously this, too.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
