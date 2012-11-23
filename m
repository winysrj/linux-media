Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37145 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2KWMCT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 07:02:19 -0500
Date: Fri, 23 Nov 2012 13:02:08 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCHv14 4/7] fbmon: add videomode helpers
Message-ID: <20121123120208.GB1106@pengutronix.de>
References: <1353661467-28545-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353661467-28545-5-git-send-email-s.trumtrar@pengutronix.de>
 <2828625.Bdym394lFc@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2828625.Bdym394lFc@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Nov 23, 2012 at 11:53:10AM +0100, Laurent Pinchart wrote:
> Hi Steffen,
> 
> On Friday 23 November 2012 10:04:24 Steffen Trumtrar wrote:
> > Add a function to convert from the generic videomode to a fb_videomode.
> > 
> > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  drivers/video/fbmon.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/fb.h    |    6 ++++++
> >  2 files changed, 55 insertions(+)
> > 
> > diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> > index cef6557..bcbfe8f 100644
> > --- a/drivers/video/fbmon.c
> > +++ b/drivers/video/fbmon.c
> > @@ -31,6 +31,7 @@
> >  #include <linux/pci.h>
> >  #include <linux/slab.h>
> >  #include <video/edid.h>
> > +#include <linux/videomode.h>
> 
> You could move this one line up to keep headers sorted alphabetically 
> (assuming they are in the first place).
> 

Because of the careless mistake below, I will do that.

> >  #ifdef CONFIG_PPC_OF
> >  #include <asm/prom.h>
> >  #include <asm/pci-bridge.h>
> > @@ -1373,6 +1374,54 @@ int fb_get_mode(int flags, u32 val, struct
> > fb_var_screeninfo *var, struct fb_inf kfree(timings);
> >  	return err;
> >  }
> > +
> > +#if IS_ENABLED(CONFIG_VIDEOMODE)
> > +int fb_videomode_from_videomode(const struct videomode *vm,
> > +				struct fb_videomode *fbmode)
> 
> This is inside the #if CONFIG_FB_MODE_HELPERS block, is that intentional ?
> 

Yes. Intentional. It is a fb_mode helper, that is why ... oh, wait. I should
add a "depends on" to the Kconfig then.

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
> > +	/* prevent division by zero in KHZ2PICOS macro */
> > +	fbmode->pixclock = vm->pixelclock ? KHZ2PICOS(vm->pixelclock / 1000) : 0;
> > +
> > +	fbmode->sync = 0;
> > +	fbmode->vmode = 0;
> > +	if (vm->hah)
> > +		fbmode->sync |= FB_SYNC_HOR_HIGH_ACT;
> > +	if (vm->vah)
> > +		fbmode->sync |= FB_SYNC_VERT_HIGH_ACT;
> > +	if (vm->interlaced)
> > +		fbmode->vmode |= FB_VMODE_INTERLACED;
> > +	if (vm->doublescan)
> > +		fbmode->vmode |= FB_VMODE_DOUBLE;
> > +	fbmode->flag = 0;
> > +
> > +	htotal = vm->hactive + vm->hfront_porch + vm->hback_porch +
> > +		 vm->hsync_len;
> > +	vtotal = vm->vactive + vm->vfront_porch + vm->vback_porch +
> > +		 vm->vsync_len;
> > +	/* prevent division by zero */
> > +	if (htotal && vtotal)
> > +		fbmode->refresh = vm->pixelclock / (htotal * vtotal);
> > +	else
> > +		fbmode->refresh = vm->pixelclock;
> 
> What about returning an error if htotal * vtotal == 0 ? The input is clearly 
> invalid in that case. I would then set fbmode->refresh to 0, setting it to vm-
> >pixelclock doesn't really make sense.
> 

Yes, pixelclock makes no sense. It was supposed to be 0. I was careless here.

> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(fb_videomode_from_videomode);
> > +#endif
> > +
> > +
> 
> A single blank line should be enough.
> 

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
