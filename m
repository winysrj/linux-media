Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59329 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab2KUQYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 11:24:47 -0500
Date: Wed, 21 Nov 2012 17:24:36 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12 4/6] fbmon: add of_videomode helpers
Message-ID: <20121121162436.GB12657@pengutronix.de>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353426896-6045-5-git-send-email-s.trumtrar@pengutronix.de>
 <50ACCDDA.2070606@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50ACCDDA.2070606@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 21, 2012 at 02:49:30PM +0200, Tomi Valkeinen wrote:
> On 2012-11-20 17:54, Steffen Trumtrar wrote:
> > Add helper to get fb_videomode from devicetree.
> > 
> > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  drivers/video/fbmon.c |   42 +++++++++++++++++++++++++++++++++++++++++-
> >  include/linux/fb.h    |    7 +++++++
> >  2 files changed, 48 insertions(+), 1 deletion(-)
> 
> 
> > diff --git a/include/linux/fb.h b/include/linux/fb.h
> > index 920cbe3..41b5e49 100644
> > --- a/include/linux/fb.h
> > +++ b/include/linux/fb.h
> > @@ -15,6 +15,8 @@
> >  #include <linux/slab.h>
> >  #include <asm/io.h>
> >  #include <linux/videomode.h>
> > +#include <linux/of.h>
> > +#include <linux/of_videomode.h>
> 
> Guess what? =)
> 
> To be honest, I don't know what the general opinion is about including
> header files from header files. But I always leave them out if they are
> not strictly needed.
> 

Okay. Seems to fit with the rest of the file;

> >  struct vm_area_struct;
> >  struct fb_info;
> > @@ -715,6 +717,11 @@ extern void fb_destroy_modedb(struct fb_videomode *modedb);
> >  extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb);
> >  extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
> >  
> > +#if IS_ENABLED(CONFIG_OF_VIDEOMODE)
> > +extern int of_get_fb_videomode(const struct device_node *np,
> > +			       struct fb_videomode *fb,
> > +			       unsigned int index);
> > +#endif
> >  #if IS_ENABLED(CONFIG_VIDEOMODE)
> >  extern int fb_videomode_from_videomode(const struct videomode *vm,
> >  				       struct fb_videomode *fbmode);
> 
> Do you really need these #ifs in the header files? They do make it look
> a bit messy. If somebody uses the functions and CONFIG_VIDEOMODE is not
> enabled, he'll get a linker error anyway.
> 

Well, I don't remember at the moment who requested this, but it was not my
idea to put them there. So, this is a matter of style I guess.
But maybe I understood that wrong.


Regards,
Steffen



-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
