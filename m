Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53581 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2JIH0R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 03:26:17 -0400
Date: Tue, 9 Oct 2012 09:26:08 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 2/2 v6] of: add generic videomode description
Message-ID: <20121009072608.GA2519@pengutronix.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
 <12272414.930KpWciBg@avalon>
 <20121008124801.GD20800@pengutronix.de>
 <1737299.6PuzOm7XuT@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1737299.6PuzOm7XuT@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Oct 08, 2012 at 10:52:04PM +0200, Laurent Pinchart wrote:
> Hi Steffen,
> 
> On Monday 08 October 2012 14:48:01 Steffen Trumtrar wrote:
> > On Mon, Oct 08, 2012 at 02:13:50PM +0200, Laurent Pinchart wrote:
> > > On Thursday 04 October 2012 19:59:20 Steffen Trumtrar wrote:
> > > > Get videomode from devicetree in a format appropriate for the
> > > > backend. drm_display_mode and fb_videomode are supported atm.
> > > > Uses the display signal timings from of_display_timings
> > > > 
> > > > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > > > ---
> > > > 
> > > >  drivers/of/Kconfig           |    5 +
> > > >  drivers/of/Makefile          |    1 +
> > > >  drivers/of/of_videomode.c    |  212 +++++++++++++++++++++++++++++++++++
> > > >  include/linux/of_videomode.h |   41 ++++++++
> > > >  4 files changed, 259 insertions(+)
> > > >  create mode 100644 drivers/of/of_videomode.c
> > > >  create mode 100644 include/linux/of_videomode.h
> 
> [snip]
> 
> > > > diff --git a/drivers/of/of_videomode.c b/drivers/of/of_videomode.c
> > > > new file mode 100644
> > > > index 0000000..76ac16e
> > > > --- /dev/null
> > > > +++ b/drivers/of/of_videomode.c
> 
> [snip]
> 
> > > > +int videomode_from_timing(struct display_timings *disp, struct
> > > > videomode *vm,
> > > > +			int index)
> > > > +{
> > > > +	struct signal_timing *st = NULL;
> > > > +
> > > > +	if (!vm)
> > > > +		return -EINVAL;
> > > > +
> > > 
> > > What about making vm a mandatory argument ? It looks to me like a caller
> > > bug if vm is NULL.
> > 
> > The caller must provide the struct videomode, yes. Wouldn't the kernel hang
> > itself with a NULL pointer exception, if I just work with it ?
> 
> The kernel would oops, clearly showing the caller that a non-null vm is needed 
> :-)
> 

Okay. No error checking it is then.

> > > > +	st = display_timings_get(disp, index);
> > > > +
> > > 
> > > You can remove the blank line.
> > > 
> > > > +	if (!st) {
> > > > +		pr_err("%s: no signal timings found\n", __func__);
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	vm->pixelclock = signal_timing_get_value(&st->pixelclock, 0);
> > > > +	vm->hactive = signal_timing_get_value(&st->hactive, 0);
> > > > +	vm->hfront_porch = signal_timing_get_value(&st->hfront_porch, 0);
> > > > +	vm->hback_porch = signal_timing_get_value(&st->hback_porch, 0);
> > > > +	vm->hsync_len = signal_timing_get_value(&st->hsync_len, 0);
> > > > +
> > > > +	vm->vactive = signal_timing_get_value(&st->vactive, 0);
> > > > +	vm->vfront_porch = signal_timing_get_value(&st->vfront_porch, 0);
> > > > +	vm->vback_porch = signal_timing_get_value(&st->vback_porch, 0);
> > > > +	vm->vsync_len = signal_timing_get_value(&st->vsync_len, 0);
> > > > +
> > > > +	vm->vah = st->vsync_pol_active_high;
> > > > +	vm->hah = st->hsync_pol_active_high;
> > > > +	vm->interlaced = st->interlaced;
> > > > +	vm->doublescan = st->doublescan;
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +int of_get_videomode(struct device_node *np, struct videomode *vm, int
> > > > index)
> > > 
> > > I wonder how to avoid abuse of this functions. It's a useful helper for
> > > drivers that need to get a video mode once only, but would result in lower
> > > performances if a driver calls it for every mode. Drivers must call
> > > of_get_display_timing_list instead in that case and case the display
> > > timings. I'm wondering whether we should really expose of_get_videomode.
> > 
> > The intent was to let the driver decide. That way all the other overhead may
> > be skipped.
> 
> My point is that driver writers might just call of_get_videomode() in a loop, 
> not knowing that it's expensive. I want to avoid that. We need to at least add 
> kerneldoc to the function stating that this shouldn't be done.
> 

You're right. That should be made clear in the code.

> > > > +{
> > > > +	struct display_timings *disp;
> > > > +	int ret = 0;
> > > 
> > > No need to assign ret to 0 here.
> > 
> > Ah, yes. Unneeded in this case.
> > 
> > > > +
> > > > +	disp = of_get_display_timing_list(np);
> > > > +
> > > 
> > > You can remove the blank line.
> > > 
> > > > +	if (!disp) {
> > > > +		pr_err("%s: no timings specified\n", __func__);
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	if (index == OF_DEFAULT_TIMING)
> > > > +		index = disp->default_timing;
> > > > +
> > > > +	ret = videomode_from_timing(disp, vm, index);
> > > > +
> > > 
> > > No need for a blank line.
> > > 
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	display_timings_release(disp);
> > > > +
> > > > +	if (!vm) {
> > > > +		pr_err("%s: could not get videomode %d\n", __func__, index);
> > > > +		return -EINVAL;
> > > > +	}
> > > 
> > > This can't happen. If vm is NULL the videomode_from_timing call above will
> > > return -EINVAL, and this function will then return immediately without
> > > reaching this code block.
> > 
> > Okay.
> > 
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(of_get_videomode);
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 

Regards,

Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
