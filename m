Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60068 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422950Ab2KNOHF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 09:07:05 -0500
Date: Wed, 14 Nov 2012 15:06:47 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v9 3/6] fbmon: add videomode helpers
Message-ID: <20121114140647.GD18579@pengutronix.de>
References: <1352893403-21168-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352893403-21168-4-git-send-email-s.trumtrar@pengutronix.de>
 <20121114121207.GD2803@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114121207.GD2803@avionic-0098.mockup.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2012 at 01:12:07PM +0100, Thierry Reding wrote:
> On Wed, Nov 14, 2012 at 12:43:20PM +0100, Steffen Trumtrar wrote:
> > Add a function to convert from the generic videomode to a fb_videomode.
> > 
> > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > ---
> >  drivers/video/fbmon.c |   38 ++++++++++++++++++++++++++++++++++++++
> >  include/linux/fb.h    |    5 +++++
> >  2 files changed, 43 insertions(+)
> > 
> > diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> > index cef6557..cccef17 100644
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
> > @@ -1373,6 +1374,43 @@ int fb_get_mode(int flags, u32 val, struct fb_var_screeninfo *var, struct fb_inf
> >  	kfree(timings);
> >  	return err;
> >  }
> > +
> > +#if IS_ENABLED(CONFIG_VIDEOMODE)
> > +int fb_videomode_from_videomode(struct videomode *vm, struct fb_videomode *fbmode)
> > +{
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
> > +	if (vm->de)
> > +		fbmode->sync |= FB_SYNC_DATA_ENABLE_HIGH_ACT;
> > +	fbmode->refresh = (vm->pixelclock*1000) / (vm->hactive * vm->vactive);
> 
> CodingStyle that you should have spaces around '*'. Also I'm not sure if
> that formula is correct. Shouldn't the blanking intervals be counted as
> well? So:
> 
> 	unsigned int htotal = vm->hactive + vm->hfront_porch +
> 			      vm->hback_porch + vm->hsync_len;
> 	unsigned int vtotal = vm->vactive + vm->vfront_porch +
> 			      vm->vback_porch + vm->vsync_len;
> 
> 	fbmode->refresh = (vm->pixelclock * 1000) / (htotal * vtotal);
> 
> ?
> 

Sounds correct. Done.

> > +	fbmode->flag = 0;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(fb_videomode_from_videomode);
> > +#endif
> > +
> > +
> 
> Gratuitous blank line.
> 
> >  #else
> >  int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
> >  {
> > diff --git a/include/linux/fb.h b/include/linux/fb.h
> > index c7a9571..6a3a675 100644
> > --- a/include/linux/fb.h
> > +++ b/include/linux/fb.h
> > @@ -14,6 +14,7 @@
> >  #include <linux/backlight.h>
> >  #include <linux/slab.h>
> >  #include <asm/io.h>
> > +#include <linux/videomode.h>
> >  
> >  struct vm_area_struct;
> >  struct fb_info;
> > @@ -714,6 +715,10 @@ extern void fb_destroy_modedb(struct fb_videomode *modedb);
> >  extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb);
> >  extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
> >  
> > +#if IS_ENABLED(CONFIG_VIDEOMODE)
> > +extern int fb_videomode_from_videomode(struct videomode *vm,
> > +				       struct fb_videomode *fbmode);
> > +#endif
> >  /* drivers/video/modedb.c */
> 
> These in turn could use an extra blank line.
> 
> Thierry



> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
