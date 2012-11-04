Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52083 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2KDRX1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2012 12:23:27 -0500
Date: Sun, 4 Nov 2012 18:23:13 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Leela Krishna Amudala <l.krishna@samsung.com>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v7 2/8] of: add helper to parse display timings
Message-ID: <20121104172312.GC5894@pengutronix.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
 <1351675689-26814-3-git-send-email-s.trumtrar@pengutronix.de>
 <CAL1wa8dGiS-UDk7vjPKBaxQHB2FyNgLRYr5jsJZe4GjdzHELLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1wa8dGiS-UDk7vjPKBaxQHB2FyNgLRYr5jsJZe4GjdzHELLQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On Fri, Nov 02, 2012 at 10:49:47PM +0530, Leela Krishna Amudala wrote:
> Hello Steffen,
> 
> On Wed, Oct 31, 2012 at 2:58 PM, Steffen Trumtrar
> > +static int parse_property(struct device_node *np, char *name,
> > +                               struct timing_entry *result)
> > +{
> > +       struct property *prop;
> > +       int length;
> > +       int cells;
> > +       int ret;
> > +
> > +       prop = of_find_property(np, name, &length);
> > +       if (!prop) {
> > +               pr_err("%s: could not find property %s\n", __func__, name);
> > +               return -EINVAL;
> > +       }
> > +
> > +       cells = length / sizeof(u32);
> > +       if (cells == 1) {
> > +               ret = of_property_read_u32_array(np, name, &result->typ, cells);
> 
> As you are reading only one vaue, you can use of_property_read_u32 instead.
> 

Yes, thats copypasta, no need for _array here.

> > +               result->min = result->typ;
> > +               result->max = result->typ;
> > +       } else if (cells == 3) {
> > +               ret = of_property_read_u32_array(np, name, &result->min, cells);
> 
> You are considering only min element, what about typ and max elements?
> 

I start at the address of result->min and read three u32-values, therefore all
three (min,typ,max) are filled with values.

> > +
> > +/**
> > + * of_display_timings_exists - check if a display-timings node is provided
> > + * @np: device_node with the timing
> > + **/
> > +int of_display_timings_exists(struct device_node *np)
> > +{
> > +       struct device_node *timings_np;
> > +       struct device_node *default_np;
> > +
> > +       if (!np)
> > +               return -EINVAL;
> > +
> > +       timings_np = of_parse_phandle(np, "display-timings", 0);
> > +       if (!timings_np)
> > +               return -EINVAL;
> > +
> > +       return -EINVAL;
> 
> Here it should return success instead of -EINVAL.
> 

Yes.

> And one query.. are the binding properties names and "display-timings"
> node structure template  finalized..?
> 

I sure hope so. There actually is one error in the examples though.
The property clock is called clock-frequency. I included it correctly
at the top of display-timings.txt, but overlooked it in the examples.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
