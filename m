Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48357 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab2KMN24 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 08:28:56 -0500
Date: Tue, 13 Nov 2012 14:28:46 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v8 3/6] fbmon: add videomode helpers
Message-ID: <20121113132846.GF27797@pengutronix.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-4-git-send-email-s.trumtrar@pengutronix.de>
 <20121113112257.GB30049@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113112257.GB30049@avionic-0098.mockup.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 13, 2012 at 12:22:58PM +0100, Thierry Reding wrote:
> On Mon, Nov 12, 2012 at 04:37:03PM +0100, Steffen Trumtrar wrote:
> [...]
> > +#if IS_ENABLED(CONFIG_VIDEOMODE)
> > +int videomode_to_fb_videomode(struct videomode *vm, struct fb_videomode *fbmode)
> 
> The other helpers are named <destination-type>_from_<source-type>(),
> maybe this should follow that example for consistency?
> 

Hm, not a bad idea.

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
> > +	fbmode->refresh = 60;
> 
> Can the refresh rate not be computed from the pixel clock and the
> horizontal and vertical timings?
> 

Yes. That totally got lost on the way.

> > +	fbmode->flag = 0;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(videomode_to_fb_videomode);
> > +#endif
> > +
> > +
> 
> There's a gratuitous blank line here.
> 
> >  #else
> >  int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
> >  {
> > diff --git a/include/linux/fb.h b/include/linux/fb.h
> > index c7a9571..46c665b 100644
> > --- a/include/linux/fb.h
> > +++ b/include/linux/fb.h
> > @@ -714,6 +714,8 @@ extern void fb_destroy_modedb(struct fb_videomode *modedb);
> >  extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb);
> >  extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
> >  
> > +extern int videomode_to_fb_videomode(struct videomode *vm, struct fb_videomode *fbmode);
> > +
> 
> Should you provide a dummy in the !CONFIG_VIDEOMODE case?
> 

Okay

Steffen


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
