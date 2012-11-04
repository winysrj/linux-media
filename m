Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34257 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2KDRKa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2012 12:10:30 -0500
Date: Sun, 4 Nov 2012 18:10:20 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v7 2/8] of: add helper to parse display timings
Message-ID: <20121104171020.GB5894@pengutronix.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
 <1351675689-26814-3-git-send-email-s.trumtrar@pengutronix.de>
 <20121101201510.GB13137@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101201510.GB13137@avionic-0098.mockup.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 01, 2012 at 09:15:10PM +0100, Thierry Reding wrote:
> On Wed, Oct 31, 2012 at 10:28:02AM +0100, Steffen Trumtrar wrote:
> [...]
> > diff --git a/Documentation/devicetree/bindings/video/display-timings.txt b/Documentation/devicetree/bindings/video/display-timings.txt
> [...]
> > @@ -0,0 +1,139 @@
> > +display-timings bindings
> > +==================
> > +
> > +display-timings-node
> > +------------
> 
> Maybe extend the underline to the length of the section and subsection
> titles respectively?
> 
> > +struct display_timing
> > +===================
> 
> Same here.
> 
> > +config OF_DISPLAY_TIMINGS
> > +	def_bool y
> > +	depends on DISPLAY_TIMING
> 
> Maybe this should be called OF_DISPLAY_TIMING to match DISPLAY_TIMING,
> or rename DISPLAY_TIMING to DISPLAY_TIMINGS for the sake of consistency?
> 

Yes, to all three above.

> > +/**
> > + * of_get_display_timing_list - parse all display_timing entries from a device_node
> > + * @np: device_node with the subnodes
> > + **/
> > +struct display_timings *of_get_display_timing_list(struct device_node *np)
> 
> Perhaps this would better be named of_get_display_timings() to match the
> return type?
> 

Hm, I'm not really sure about that. I found it to error prone, to have a function
of_get_display_timing and of_get_display_timings. That's why I chose
of_get_display_timing_list. But you are correct, that it doesn't match the return
value. Maybe I should just make the first function static and change the name as you
suggested.

> > +	disp = kzalloc(sizeof(*disp), GFP_KERNEL);
> 
> Shouldn't you be checking this for allocation failures?
> 
> > +	disp->timings = kzalloc(sizeof(struct display_timing *)*disp->num_timings,
> > +				GFP_KERNEL);
> 
> Same here.
> 

Yes, to both.

Regards,
Steffen


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
