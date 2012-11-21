Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59617 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab2KULtI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 06:49:08 -0500
Date: Wed, 21 Nov 2012 12:48:43 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
Cc: "devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robherring2@gmail.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12 2/6] video: add of helper for videomode
Message-ID: <20121121114843.GC14013@pengutronix.de>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353426896-6045-3-git-send-email-s.trumtrar@pengutronix.de>
 <A73F36158E33644199EB82C5EC81C7BC3E9FA7A0@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A73F36158E33644199EB82C5EC81C7BC3E9FA7A0@DBDE01.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On Wed, Nov 21, 2012 at 10:12:43AM +0000, Manjunathappa, Prakash wrote:
> Hi Steffen,
> 
> On Tue, Nov 20, 2012 at 21:24:52, Steffen Trumtrar wrote:
> > +/**
> > + * of_get_display_timings - parse all display_timing entries from a device_node
> > + * @np: device_node with the subnodes
> > + **/
> > +struct display_timings *of_get_display_timings(const struct device_node *np)
> > +{
> > +	struct device_node *timings_np;
> > +	struct device_node *entry;
> > +	struct device_node *native_mode;
> > +	struct display_timings *disp;
> > +
> > +	if (!np) {
> > +		pr_err("%s: no devicenode given\n", __func__);
> > +		return NULL;
> > +	}
> > +
> > +	timings_np = of_find_node_by_name(np, "display-timings");
> 
> I get below build warnings on this line
> drivers/video/of_display_timing.c: In function 'of_get_display_timings':
> drivers/video/of_display_timing.c:109:2: warning: passing argument 1 of 'of_find_node_by_name' discards qualifiers from pointer target type
> include/linux/of.h:167:28: note: expected 'struct device_node *' but argument is of type 'const struct device_node *'
> 
> > + * of_display_timings_exists - check if a display-timings node is provided
> > + * @np: device_node with the timing
> > + **/
> > +int of_display_timings_exists(const struct device_node *np)
> > +{
> > +	struct device_node *timings_np;
> > +
> > +	if (!np)
> > +		return -EINVAL;
> > +
> > +	timings_np = of_parse_phandle(np, "display-timings", 0);
> 
> Also here:
> drivers/video/of_display_timing.c: In function 'of_display_timings_exists':
> drivers/video/of_display_timing.c:209:2: warning: passing argument 1 of 'of_parse_phandle' discards qualifiers from pointer target type
> include/linux/of.h:258:28: note: expected 'struct device_node *' but argument is of type 'const struct device_node *'
> 

The warnings are because the of-functions do not use const pointers where they
should. I had two options: don't use const pointers even if they should be and
have no warnings or use const pointers and have a correct API. (Third option:
send patches for of-functions). I chose the second option.

Regards,
Steffen


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
