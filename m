Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39711 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2KMNOc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 08:14:32 -0500
Date: Tue, 13 Nov 2012 14:14:23 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v8 1/6] video: add display_timing and videomode
Message-ID: <20121113131423.GE27797@pengutronix.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-2-git-send-email-s.trumtrar@pengutronix.de>
 <20121113104159.GA18645@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113104159.GA18645@avionic-0098.mockup.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 13, 2012 at 11:41:59AM +0100, Thierry Reding wrote:
> On Mon, Nov 12, 2012 at 04:37:01PM +0100, Steffen Trumtrar wrote:
> [...]
> > diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> > index d08d799..2a23b18 100644
> > --- a/drivers/video/Kconfig
> > +++ b/drivers/video/Kconfig
> > @@ -33,6 +33,12 @@ config VIDEO_OUTPUT_CONTROL
> >  	  This framework adds support for low-level control of the video 
> >  	  output switch.
> >  
> > +config DISPLAY_TIMING
> 
> DISPLAY_TIMINGS?
> 
> >  #video output switch sysfs driver
> >  obj-$(CONFIG_VIDEO_OUTPUT_CONTROL) += output.o
> > +obj-$(CONFIG_DISPLAY_TIMING) += display_timing.o
> 
> display_timings.o?
> 
> > +obj-$(CONFIG_VIDEOMODE) += videomode.o
> > diff --git a/drivers/video/display_timing.c b/drivers/video/display_timing.c
> 
> display_timings.c?
> 

I originally had that and changed it by request to the singular form.
(Can't find the mail atm). And I think this fits better with all the other drivers.

> > +int videomode_from_timing(struct display_timings *disp, struct videomode *vm,
> > +			  unsigned int index)
> 
> I find the indexing API a bit confusing. But that's perhaps just a
> matter of personal preference.
> 
> Also the ordering of arguments seems a little off. I find it more
> natural to have the destination pointer in the first argument, similar
> to the memcpy() function, so this would be:
> 
> int videomode_from_timing(struct videomode *vm, struct display_timings *disp,
> 			  unsigned int index);
> 
> Actually, when reading videomode_from_timing() I'd expect the argument
> list to be:
> 
> int videomode_from_timing(struct videomode *vm, struct display_timing *timing);
> 
> Am I the only one confused by this?
> 

I went with the of_xxx-functions that have fname(from_node, to_property)
and personally prefer it this way. Therefore I'd like to keep it as is.

> > diff --git a/include/linux/display_timing.h b/include/linux/display_timing.h
> 
> display_timings.h?
> 
> > +/* placeholder function until ranges are really needed 
> 
> The above line has trailing whitespace. Also the block comment should
> have the opening /* on a separate line.
> 

Okay.

> > + * the index parameter should then be used to select one of [min typ max]
> 
> If index is supposed to select min, typ or max, then maybe an enum would
> be a better candidate? Or alternatively provide separate accessors, like
> display_timing_get_{minimum,typical,maximum}().
> 

Hm, I'm not so sure about this one. I'd prefer the enum.

> > + */
> > +static inline u32 display_timing_get_value(struct timing_entry *te,
> > +					   unsigned int index)
> > +{
> > +	return te->typ;
> > +}
> > +
> > +static inline struct display_timing *display_timings_get(struct display_timings *disp,
> > +							 unsigned int index)
> > +{
> > +	if (disp->num_timings > index)
> > +		return disp->timings[index];
> > +	else
> > +		return NULL;
> > +}
> > +
> > +void timings_release(struct display_timings *disp);
> 
> This function no longer exists.
> 
Right.

Steffen

> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
