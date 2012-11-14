Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48534 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab2KNNcF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 08:32:05 -0500
Date: Wed, 14 Nov 2012 14:31:54 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-fbdev@vger.kernel.org, kernel@pengutronix.de,
	devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v9 2/6] video: add of helper for videomode
Message-ID: <20121114133154.GC18579@pengutronix.de>
References: <1352893403-21168-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352893403-21168-3-git-send-email-s.trumtrar@pengutronix.de>
 <20121114120045.GA2803@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114120045.GA2803@avionic-0098.mockup.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2012 at 01:00:45PM +0100, Thierry Reding wrote:
> On Wed, Nov 14, 2012 at 12:43:19PM +0100, Steffen Trumtrar wrote:
> [...]
> > +display-timings bindings
> > +========================
> > +
> > +display timings node
> 
> I didn't express myself very clearly here =). The way I think this
> should be written is "display-timings node".
> 
> > +required properties:
> > + - hactive, vactive: Display resolution
> > + - hfront-porch, hback-porch, hsync-len: Horizontal Display timing parameters
> > +   in pixels
> > +   vfront-porch, vback-porch, vsync-len: Vertical display timing parameters in
> > +   lines
> > + - clock-frequency: displayclock in Hz
> 
> I still think "displayclock" should be two words: "display clock".
> 
> > +/**
> > + * of_get_display_timings - parse all display_timing entries from a device_node
> > + * @np: device_node with the subnodes
> > + **/
> > +struct display_timings *of_get_display_timings(struct device_node *np)
> > +{
> [...]
> > +	disp->num_timings = 0;
> > +	disp->native_mode = 0;
> > +
> > +	for_each_child_of_node(timings_np, entry) {
> > +		struct display_timing *dt;
> > +
> > +		dt = of_get_display_timing(entry);
> > +		if (!dt) {
> > +			/* to not encourage wrong devicetrees, fail in case of an error */
> > +			pr_err("%s: error in timing %d\n", __func__, disp->num_timings+1);
> > +			goto timingfail;
> 
> I believe you're still potentially leaking memory here. In case you have
> 5 entries for instance, and the last one fails to parse, then this will
> cause the memory allocated for the 4 correct entries to be lost.
> 
> Can't you just call display_timings_release() in this case and then jump
> to dispfail? That would still leak the native_mode device node. Maybe it
> would be better to keep timingfail but modify it to free the display
> timings with display_timings_release() instead? See below.
> 
> > +		}
> > +
> > +		if (native_mode == entry)
> > +			disp->native_mode = disp->num_timings;
> > +
> > +		disp->timings[disp->num_timings] = dt;
> > +		disp->num_timings++;
> > +	}
> > +	of_node_put(timings_np);
> > +	of_node_put(native_mode);
> > +
> > +	if (disp->num_timings > 0)
> > +		pr_info("%s: got %d timings. Using timing #%d as default\n", __func__,
> > +			disp->num_timings , disp->native_mode + 1);
> > +	else {
> > +		pr_err("%s: no valid timings specified\n", __func__);
> > +		display_timings_release(disp);
> > +		return NULL;
> > +	}
> > +	return disp;
> > +
> > +timingfail:
> > +	if (native_mode)
> > +		of_node_put(native_mode);
> > +	kfree(disp->timings);
> 
> Call display_timings_release(disp) instead of kfree(disp->timings)?
> 

Yes. That would be the appropriate way to fail here. Done.

> > diff --git a/include/linux/of_videomode.h b/include/linux/of_videomode.h
> > new file mode 100644
> > index 0000000..4138758
> > --- /dev/null
> > +++ b/include/linux/of_videomode.h
> > @@ -0,0 +1,16 @@
> > +/*
> > + * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > + *
> > + * videomode of-helpers
> > + *
> > + * This file is released under the GPLv2
> > + */
> > +
> > +#ifndef __LINUX_OF_VIDEOMODE_H
> > +#define __LINUX_OF_VIDEOMODE_H
> > +
> > +#include <linux/videomode.h>
> > +#include <linux/of.h>
> > +
> > +int of_get_videomode(struct device_node *np, struct videomode *vm, int index);
> > +#endif /* __LINUX_OF_VIDEOMODE_H */
> 
> Nit: should have a blank line before #endif.
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
