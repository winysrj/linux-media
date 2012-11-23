Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52375 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2KWKex (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 05:34:53 -0500
Date: Fri, 23 Nov 2012 11:34:42 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Leela Krishna Amudala <l.krishna@samsung.com>
Cc: devicetree-discuss@lists.ozlabs.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCHv14 3/7] video: add of helper for display timings/videomode
Message-ID: <20121123103442.GA1106@pengutronix.de>
References: <1353661467-28545-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353661467-28545-4-git-send-email-s.trumtrar@pengutronix.de>
 <CAL1wa8e1KBrikuP-CQdM3hO_LaNN-1=XuPe728XKqRERQm-EFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1wa8e1KBrikuP-CQdM3hO_LaNN-1=XuPe728XKqRERQm-EFg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 23, 2012 at 03:49:37PM +0530, Leela Krishna Amudala wrote:
> Hello Steffen,
> 
> On Fri, Nov 23, 2012 at 2:34 PM, Steffen Trumtrar
> <s.trumtrar@pengutronix.de> wrote:
> > This adds support for reading display timings from DT into a struct
> > display_timings. The of_display_timing implementation supports multiple
> > subnodes. All children are read into an array, that can be queried.
> >
> > If no native mode is specified, the first subnode will be used.
> >
> > For cases, where the graphics drivers knows, there can be only one
> > mode description or where the driver only supports one mode, a helper
> > function of_get_videomode is added, that gets a struct videomode from DT.
> > (As this function is implemented in an expensive fashion, it should only
> > be used in the aforementioned case).
> >
> > This also demonstrates how of_display_timings may be utilized.
> >
> > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Acked-by: Stephen Warren <swarren@nvidia.com>
> > Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  .../devicetree/bindings/video/display-timings.txt  |  107 ++++++++++
> >  drivers/video/Kconfig                              |   15 ++
> >  drivers/video/Makefile                             |    2 +
> >  drivers/video/of_display_timing.c                  |  223 ++++++++++++++++++++
> >  drivers/video/of_videomode.c                       |   48 +++++
> >  include/linux/of_display_timings.h                 |   20 ++
> >  include/linux/of_videomode.h                       |   18 ++
> >  7 files changed, 433 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/video/display-timings.txt
> >  create mode 100644 drivers/video/of_display_timing.c
> >  create mode 100644 drivers/video/of_videomode.c
> >  create mode 100644 include/linux/of_display_timings.h
> >  create mode 100644 include/linux/of_videomode.h
> >
> 
> <<<snip>>>
> 
> > diff --git a/drivers/video/of_display_timing.c b/drivers/video/of_display_timing.c
> > new file mode 100644
> > index 0000000..645f43d
> > --- /dev/null
> > +++ b/drivers/video/of_display_timing.c
> > @@ -0,0 +1,223 @@
> > +/*
> > + * OF helpers for parsing display timings
> > + *
> > + * Copyright (c) 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>, Pengutronix
> > + *
> > + * based on of_videomode.c by Sascha Hauer <s.hauer@pengutronix.de>
> > + *
> > + * This file is released under the GPLv2
> > + */
> > +#include <linux/of.h>
> > +#include <linux/slab.h>
> > +#include <linux/export.h>
> > +#include <linux/of_display_timings.h>
> > +
> > +/**
> > + * parse_property - parse timing_entry from device_node
> > + * @np: device_node with the property
> > + * @name: name of the property
> > + * @result: will be set to the return value
> > + *
> > + * DESCRIPTION:
> > + * Every display_timing can be specified with either just the typical value or
> > + * a range consisting of min/typ/max. This function helps handling this
> > + **/
> > +static int parse_property(const struct device_node *np, const char *name,
> > +                         struct timing_entry *result)
> > +{
> > +       struct property *prop;
> > +       int length, cells, ret;
> > +
> > +       prop = of_find_property(np, name, &length);
> > +       if (!prop) {
> > +               pr_err("%s: could not find property %s\n", __func__, name);
> > +               return -EINVAL;
> > +       }
> > +
> > +       cells = length / sizeof(u32);
> > +       if (cells == 1) {
> > +               ret = of_property_read_u32(np, name, &result->typ);
> > +               result->min = result->typ;
> > +               result->max = result->typ;
> > +       } else if (cells == 3) {
> > +               ret = of_property_read_u32_array(np, name, &result->min, cells);
> > +       } else {
> > +               pr_err("%s: illegal timing specification in %s\n", __func__,
> > +                       name);
> > +               return -EINVAL;
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +/**
> > + * of_get_display_timing - parse display_timing entry from device_node
> > + * @np: device_node with the properties
> > + **/
> > +static struct display_timing *of_get_display_timing(const struct device_node
> > +                                                   *np)
> > +{
> > +       struct display_timing *dt;
> > +       int ret = 0;
> > +
> > +       dt = kzalloc(sizeof(*dt), GFP_KERNEL);
> > +       if (!dt) {
> > +               pr_err("%s: could not allocate display_timing struct\n",
> > +                       __func__);
> > +               return NULL;
> > +       }
> > +
> > +       ret |= parse_property(np, "hback-porch", &dt->hback_porch);
> > +       ret |= parse_property(np, "hfront-porch", &dt->hfront_porch);
> > +       ret |= parse_property(np, "hactive", &dt->hactive);
> > +       ret |= parse_property(np, "hsync-len", &dt->hsync_len);
> > +       ret |= parse_property(np, "vback-porch", &dt->vback_porch);
> > +       ret |= parse_property(np, "vfront-porch", &dt->vfront_porch);
> > +       ret |= parse_property(np, "vactive", &dt->vactive);
> > +       ret |= parse_property(np, "vsync-len", &dt->vsync_len);
> > +       ret |= parse_property(np, "clock-frequency", &dt->pixelclock);
> > +
> > +       of_property_read_u32(np, "vsync-active", &dt->vsync_pol_active);
> > +       of_property_read_u32(np, "hsync-active", &dt->hsync_pol_active);
> > +       of_property_read_u32(np, "de-active", &dt->de_pol_active);
> > +       of_property_read_u32(np, "pixelclk-inverted", &dt->pixelclk_pol);
> > +       dt->interlaced = of_property_read_bool(np, "interlaced");
> > +       dt->doublescan = of_property_read_bool(np, "doublescan");
> > +
> > +       if (ret) {
> > +               pr_err("%s: error reading timing properties\n", __func__);
> > +               kfree(dt);
> > +               return NULL;
> > +       }
> > +
> > +       return dt;
> > +}
> > +
> > +/**
> > + * of_get_display_timings - parse all display_timing entries from a device_node
> > + * @np: device_node with the subnodes
> > + **/
> > +struct display_timings *of_get_display_timings(struct device_node *np)
> > +{
> > +       struct device_node *timings_np;
> > +       struct device_node *entry;
> > +       struct device_node *native_mode;
> > +       struct display_timings *disp;
> > +
> > +       if (!np) {
> > +               pr_err("%s: no devicenode given\n", __func__);
> > +               return NULL;
> > +       }
> > +
> > +       timings_np = of_find_node_by_name(np, "display-timings");
> > +       if (!timings_np) {
> > +               pr_err("%s: could not find display-timings node\n", __func__);
> > +               return NULL;
> > +       }
> > +
> > +       disp = kzalloc(sizeof(*disp), GFP_KERNEL);
> > +       if (!disp) {
> > +               pr_err("%s: could not allocate struct disp'\n", __func__);
> > +               goto dispfail;
> > +       }
> > +
> > +       entry = of_parse_phandle(timings_np, "native-mode", 0);
> > +       /* assume first child as native mode if none provided */
> > +       if (!entry)
> > +               entry = of_get_next_child(np, NULL);
> > +       /* if there is no child, it is useless to go on */
> > +       if (!entry) {
> > +               pr_err("%s: no timing specifications given\n", __func__);
> > +               goto entryfail;
> > +       }
> > +
> > +       pr_info("%s: using %s as default timing\n", __func__, entry->name);
> > +
> > +       native_mode = entry;
> > +
> > +       disp->num_timings = of_get_child_count(timings_np);
> > +       if (disp->num_timings == 0) {
> > +               /* should never happen, as entry was already found above */
> > +               pr_err("%s: no timings specified\n", __func__);
> > +               goto entryfail;
> > +       }
> > +
> > +       disp->timings = kzalloc(sizeof(struct display_timing *) * disp->num_timings,
> > +                               GFP_KERNEL);
> > +       if (!disp->timings) {
> > +               pr_err("%s: could not allocate timings array\n", __func__);
> > +               goto entryfail;
> > +       }
> > +
> > +       disp->num_timings = 0;
> > +       disp->native_mode = 0;
> > +
> > +       for_each_child_of_node(timings_np, entry) {
> > +               struct display_timing *dt;
> > +
> > +               dt = of_get_display_timing(entry);
> > +               if (!dt) {
> > +                       /*
> > +                        * to not encourage wrong devicetrees, fail in case of
> > +                        * an error
> > +                        */
> > +                       pr_err("%s: error in timing %d\n", __func__,
> > +                              disp->num_timings + 1);
> > +                       goto timingfail;
> > +               }
> > +
> > +               if (native_mode == entry)
> > +                       disp->native_mode = disp->num_timings;
> > +
> > +               disp->timings[disp->num_timings] = dt;
> > +               disp->num_timings++;
> > +       }
> > +       of_node_put(timings_np);
> > +       /*
> > +        * native_mode points to the device_node returned by of_parse_phandle
> > +        * therefore call of_node_put on it
> > +        */
> > +       of_node_put(native_mode);
> > +
> > +       if (disp->num_timings > 0)
> > +               pr_info("%s: got %d timings. Using timing #%d as default\n",
> > +                       __func__, disp->num_timings, disp->native_mode + 1);
> > +       else {
> > +               pr_err("%s: no valid timings specified\n", __func__);
> > +               display_timings_release(disp);
> > +               return NULL;
> > +       }
> > +       return disp;
> > +
> > +timingfail:
> > +       if (native_mode)
> > +               of_node_put(native_mode);
> > +       display_timings_release(disp);
> > +entryfail:
> > +       if (disp)
> > +               kfree(disp);
> > +dispfail:
> > +       of_node_put(timings_np);
> > +       return NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(of_get_display_timings);
> > +
> > +/**
> > + * of_display_timings_exists - check if a display-timings node is provided
> > + * @np: device_node with the timing
> > + **/
> > +int of_display_timings_exists(const struct device_node *np)
> > +{
> > +       struct device_node *timings_np;
> > +
> > +       if (!np)
> > +               return -EINVAL;
> > +
> > +       timings_np = of_parse_phandle(np, "display-timings", 0);
> 
> I'm seeing warning for the above call
> "passing argument 1 of 'of_parse_phandle' discards qualifiers from
> pointer target type
> expected 'struct device_node *' but argument is of type 'const struct
> device_node *' "
> Please take care of it.
> 

I already sent a patch for of_parse_phandle that makes its device_node pointer
const. That fixes this warning. As I got that patch also on my tree, I did
miss removing the const for the time being.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
