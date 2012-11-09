Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49934 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2KITbq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2012 14:31:46 -0500
Date: Fri, 9 Nov 2012 20:31:33 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v7 5/8] fbmon: add videomode helpers
Message-ID: <20121109193133.GD3660@pengutronix.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
 <1351675689-26814-6-git-send-email-s.trumtrar@pengutronix.de>
 <A73F36158E33644199EB82C5EC81C7BC3E9E1B39@DBDE01.ent.ti.com>
 <20121108212545.GA32605@pengutronix.de>
 <A73F36158E33644199EB82C5EC81C7BC3E9E614A@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A73F36158E33644199EB82C5EC81C7BC3E9E614A@DBDE01.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On Fri, Nov 09, 2012 at 04:54:16PM +0000, Manjunathappa, Prakash wrote:
> Hi Steffen,
> 
> On Fri, Nov 09, 2012 at 02:55:45, Steffen Trumtrar wrote:
> > Hi!
> > 
> > On Wed, Oct 31, 2012 at 03:30:03PM +0000, Manjunathappa, Prakash wrote:
> > > Hi Steffen,
> > > 
> > > On Wed, Oct 31, 2012 at 14:58:05, Steffen Trumtrar wrote:
> > > > +#if IS_ENABLED(CONFIG_VIDEOMODE)
> > > > +int videomode_to_fb_videomode(struct videomode *vm, struct fb_videomode *fbmode)
> > > > +{
> > > > +	fbmode->xres = vm->hactive;
> > > > +	fbmode->left_margin = vm->hback_porch;
> > > > +	fbmode->right_margin = vm->hfront_porch;
> > > > +	fbmode->hsync_len = vm->hsync_len;
> > > > +
> > > > +	fbmode->yres = vm->vactive;
> > > > +	fbmode->upper_margin = vm->vback_porch;
> > > > +	fbmode->lower_margin = vm->vfront_porch;
> > > > +	fbmode->vsync_len = vm->vsync_len;
> > > > +
> > > > +	fbmode->pixclock = KHZ2PICOS(vm->pixelclock / 1000);
> > > > +
> > > > +	fbmode->sync = 0;
> > > > +	fbmode->vmode = 0;
> > > > +	if (vm->hah)
> > > > +		fbmode->sync |= FB_SYNC_HOR_HIGH_ACT;
> > > > +	if (vm->vah)
> > > > +		fbmode->sync |= FB_SYNC_VERT_HIGH_ACT;
> > > > +	if (vm->interlaced)
> > > > +		fbmode->vmode |= FB_VMODE_INTERLACED;
> > > > +	if (vm->doublescan)
> > > > +		fbmode->vmode |= FB_VMODE_DOUBLE;
> > > > +
> > > 
> > > "pixelclk-inverted" property of the panel is not percolated fb_videomode.
> > > Please let me know if I am missing something.
> > > 
> > 
> > The next version is almost finished. Only thing I'm missing is this.
> > And I actually do not know which flag would represent an inverted pixelclock
> > in fb_videomode. Does anybody have any idea what I have to do here?
> > 
> > 	if (vm->pixelclk_pol)
> > 		fbmode->sync = ???
> > 
> > That's as far as I have come and I don't see a flag that seems right.
> > Is this even a valid property of fb_videomode?
> > 
> 
> Thanks for considering it, I see IMX addresses it as proprietary FB_SYNC_ flag.
> FB_SYNC_CLK_INVERT: arch/arm/plat-mxc/include/mach/mx3fb.h
> 

No problem. So, it seems this flag has to be set in some imx-specific
videomode_to_fb_videomode function. It is included in the
struct videomode, so that should be no problem. But it will not be
part of this series.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
