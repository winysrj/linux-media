Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56726 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2KUQLR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 11:11:17 -0500
Date: Wed, 21 Nov 2012 17:11:03 +0100
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
Subject: Re: [PATCH v12 1/6] video: add display_timing and videomode
Message-ID: <20121121161103.GA12657@pengutronix.de>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353426896-6045-2-git-send-email-s.trumtrar@pengutronix.de>
 <50ACBCE4.60701@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50ACBCE4.60701@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, Nov 21, 2012 at 01:37:08PM +0200, Tomi Valkeinen wrote:
> Hi,
> 
> On 2012-11-20 17:54, Steffen Trumtrar wrote:
> > Add display_timing structure and the according helper functions. This allows
> > the description of a display via its supported timing parameters.
> > 
> > Every timing parameter can be specified as a single value or a range
> > <min typ max>.
> > 
> > Also, add helper functions to convert from display timings to a generic videomode
> > structure. This videomode can then be converted to the corresponding subsystem
> > mode representation (e.g. fb_videomode).
> 
> Sorry for reviewing this so late.
> 
> One thing I'd like to see is some explanation of the structs involved.
> For example, in this patch you present structs videomode, display_timing
> and display_timings without giving any hint what they represent.
> 
> I'm not asking for you to write a long documentation, but perhaps the
> header files could include a few lines of comments above the structs,
> explaining the idea.
> 

Okay. Will do.

> > +void display_timings_release(struct display_timings *disp)
> > +{
> > +	if (disp->timings) {
> > +		unsigned int i;
> > +
> > +		for (i = 0; i < disp->num_timings; i++)
> > +			kfree(disp->timings[i]);
> > +		kfree(disp->timings);
> > +	}
> > +	kfree(disp);
> > +}
> > +EXPORT_SYMBOL_GPL(display_timings_release);
> 
> Perhaps this will become clearer after reading the following patches,
> but it feels a bit odd to add a release function, without anything in
> this patch that would actually allocate the timings.
> 

2/6 uses this function. And as this does not belong to the DT part, it
is added in this patch.

> > diff --git a/drivers/video/videomode.c b/drivers/video/videomode.c
> > new file mode 100644
> > index 0000000..e24f879
> > --- /dev/null
> > +++ b/drivers/video/videomode.c
> > @@ -0,0 +1,46 @@
> > +/*
> > + * generic display timing functions
> > + *
> > + * Copyright (c) 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>, Pengutronix
> > + *
> > + * This file is released under the GPLv2
> > + */
> > +
> > +#include <linux/export.h>
> > +#include <linux/errno.h>
> > +#include <linux/display_timing.h>
> > +#include <linux/kernel.h>
> > +#include <linux/videomode.h>
> > +
> > +int videomode_from_timing(const struct display_timings *disp,
> > +			  struct videomode *vm, unsigned int index)
> > +{
> > +	struct display_timing *dt;
> > +
> > +	dt = display_timings_get(disp, index);
> > +	if (!dt)
> > +		return -EINVAL;
> > +
> > +	vm->pixelclock = display_timing_get_value(&dt->pixelclock, 0);
> > +	vm->hactive = display_timing_get_value(&dt->hactive, 0);
> > +	vm->hfront_porch = display_timing_get_value(&dt->hfront_porch, 0);
> > +	vm->hback_porch = display_timing_get_value(&dt->hback_porch, 0);
> > +	vm->hsync_len = display_timing_get_value(&dt->hsync_len, 0);
> > +
> > +	vm->vactive = display_timing_get_value(&dt->vactive, 0);
> > +	vm->vfront_porch = display_timing_get_value(&dt->vfront_porch, 0);
> > +	vm->vback_porch = display_timing_get_value(&dt->vback_porch, 0);
> > +	vm->vsync_len = display_timing_get_value(&dt->vsync_len, 0);
> 
> Shouldn't all these calls get the typical value, with index 1?
> 

Yes. I omitted the indexing until now. So it didn't matter what value was used.
But I will integrate it in the next version.

> > +
> > +	vm->vah = dt->vsync_pol_active;
> > +	vm->hah = dt->hsync_pol_active;
> > +	vm->de = dt->de_pol_active;
> > +	vm->pixelclk_pol = dt->pixelclk_pol;
> > +
> > +	vm->interlaced = dt->interlaced;
> > +	vm->doublescan = dt->doublescan;
> > +
> > +	return 0;
> > +}
> > +
> > +EXPORT_SYMBOL_GPL(videomode_from_timing);
> > diff --git a/include/linux/display_timing.h b/include/linux/display_timing.h
> > new file mode 100644
> > index 0000000..d5bf03f
> > --- /dev/null
> > +++ b/include/linux/display_timing.h
> > @@ -0,0 +1,70 @@
> > +/*
> > + * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > + *
> > + * description of display timings
> > + *
> > + * This file is released under the GPLv2
> > + */
> > +
> > +#ifndef __LINUX_DISPLAY_TIMINGS_H
> > +#define __LINUX_DISPLAY_TIMINGS_H
> > +
> > +#include <linux/types.h>
> 
> What is this needed for? u32? I don't see it defined in types.h
> 

Yes, u32. What would be the right header for that if not types.h?

> > +
> > +struct timing_entry {
> > +	u32 min;
> > +	u32 typ;
> > +	u32 max;
> > +};
> > +
> > +struct display_timing {
> > +	struct timing_entry pixelclock;
> > +
> > +	struct timing_entry hactive;
> > +	struct timing_entry hfront_porch;
> > +	struct timing_entry hback_porch;
> > +	struct timing_entry hsync_len;
> > +
> > +	struct timing_entry vactive;
> > +	struct timing_entry vfront_porch;
> > +	struct timing_entry vback_porch;
> > +	struct timing_entry vsync_len;
> > +
> > +	unsigned int vsync_pol_active;
> > +	unsigned int hsync_pol_active;
> > +	unsigned int de_pol_active;
> > +	unsigned int pixelclk_pol;
> > +	bool interlaced;
> > +	bool doublescan;
> > +};
> > +
> > +struct display_timings {
> > +	unsigned int num_timings;
> > +	unsigned int native_mode;
> > +
> > +	struct display_timing **timings;
> > +};
> > +
> > +/*
> > + * placeholder function until ranges are really needed
> > + * the index parameter should then be used to select one of [min typ max]
> > + */
> > +static inline u32 display_timing_get_value(const struct timing_entry *te,
> > +					   unsigned int index)
> > +{
> > +	return te->typ;
> > +}
> 
> Why did you opt for a placeholder here? It feels trivial to me to have
> support to get the min/typ/max value properly.
> 

I will add that in the next version.

> > +static inline struct display_timing *display_timings_get(const struct
> > +							 display_timings *disp,
> > +							 unsigned int index)
> > +{
> > +	if (disp->num_timings > index)
> > +		return disp->timings[index];
> > +	else
> > +		return NULL;
> > +}
> > +
> > +void display_timings_release(struct display_timings *disp);
> > +
> > +#endif
> > diff --git a/include/linux/videomode.h b/include/linux/videomode.h
> > new file mode 100644
> > index 0000000..5d3e796
> > --- /dev/null
> > +++ b/include/linux/videomode.h
> > @@ -0,0 +1,40 @@
> > +/*
> > + * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > + *
> > + * generic videomode description
> > + *
> > + * This file is released under the GPLv2
> > + */
> > +
> > +#ifndef __LINUX_VIDEOMODE_H
> > +#define __LINUX_VIDEOMODE_H
> > +
> > +#include <linux/display_timing.h>
> 
> This is not needed, just add:
> 
> struct display_timings;
> 

Okay.

> > +struct videomode {
> > +	u32 pixelclock;
> > +	u32 refreshrate;
> > +
> > +	u32 hactive;
> > +	u32 hfront_porch;
> > +	u32 hback_porch;
> > +	u32 hsync_len;
> > +
> > +	u32 vactive;
> > +	u32 vfront_porch;
> > +	u32 vback_porch;
> > +	u32 vsync_len;
> > +
> > +	u32 hah;
> > +	u32 vah;
> > +	u32 de;
> > +	u32 pixelclk_pol;
> > +
> > +	bool interlaced;
> > +	bool doublescan;
> > +};
> > +
> > +int videomode_from_timing(const struct display_timings *disp,
> > +			  struct videomode *vm, unsigned int index);
> > +
> 
> Are this and the few other functions above meant to be used from
> drivers? If so, some explanation of the parameters here would be nice.
> If they are just framework internal, they don't probably need that.
>

Okay. I will add some more documentation.

Regards,
Steffen


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
