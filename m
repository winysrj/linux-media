Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:34266 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161082Ab2KWKUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 05:20:00 -0500
MIME-Version: 1.0
In-Reply-To: <1353661467-28545-4-git-send-email-s.trumtrar@pengutronix.de>
References: <1353661467-28545-1-git-send-email-s.trumtrar@pengutronix.de> <1353661467-28545-4-git-send-email-s.trumtrar@pengutronix.de>
From: Leela Krishna Amudala <l.krishna@samsung.com>
Date: Fri, 23 Nov 2012 15:49:37 +0530
Message-ID: <CAL1wa8e1KBrikuP-CQdM3hO_LaNN-1=XuPe728XKqRERQm-EFg@mail.gmail.com>
Subject: Re: [PATCHv14 3/7] video: add of helper for display timings/videomode
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Steffen,

On Fri, Nov 23, 2012 at 2:34 PM, Steffen Trumtrar
<s.trumtrar@pengutronix.de> wrote:
> This adds support for reading display timings from DT into a struct
> display_timings. The of_display_timing implementation supports multiple
> subnodes. All children are read into an array, that can be queried.
>
> If no native mode is specified, the first subnode will be used.
>
> For cases, where the graphics drivers knows, there can be only one
> mode description or where the driver only supports one mode, a helper
> function of_get_videomode is added, that gets a struct videomode from DT.
> (As this function is implemented in an expensive fashion, it should only
> be used in the aforementioned case).
>
> This also demonstrates how of_display_timings may be utilized.
>
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  .../devicetree/bindings/video/display-timings.txt  |  107 ++++++++++
>  drivers/video/Kconfig                              |   15 ++
>  drivers/video/Makefile                             |    2 +
>  drivers/video/of_display_timing.c                  |  223 ++++++++++++++++++++
>  drivers/video/of_videomode.c                       |   48 +++++
>  include/linux/of_display_timings.h                 |   20 ++
>  include/linux/of_videomode.h                       |   18 ++
>  7 files changed, 433 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/display-timings.txt
>  create mode 100644 drivers/video/of_display_timing.c
>  create mode 100644 drivers/video/of_videomode.c
>  create mode 100644 include/linux/of_display_timings.h
>  create mode 100644 include/linux/of_videomode.h
>

<<<snip>>>

> diff --git a/drivers/video/of_display_timing.c b/drivers/video/of_display_timing.c
> new file mode 100644
> index 0000000..645f43d
> --- /dev/null
> +++ b/drivers/video/of_display_timing.c
> @@ -0,0 +1,223 @@
> +/*
> + * OF helpers for parsing display timings
> + *
> + * Copyright (c) 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>, Pengutronix
> + *
> + * based on of_videomode.c by Sascha Hauer <s.hauer@pengutronix.de>
> + *
> + * This file is released under the GPLv2
> + */
> +#include <linux/of.h>
> +#include <linux/slab.h>
> +#include <linux/export.h>
> +#include <linux/of_display_timings.h>
> +
> +/**
> + * parse_property - parse timing_entry from device_node
> + * @np: device_node with the property
> + * @name: name of the property
> + * @result: will be set to the return value
> + *
> + * DESCRIPTION:
> + * Every display_timing can be specified with either just the typical value or
> + * a range consisting of min/typ/max. This function helps handling this
> + **/
> +static int parse_property(const struct device_node *np, const char *name,
> +                         struct timing_entry *result)
> +{
> +       struct property *prop;
> +       int length, cells, ret;
> +
> +       prop = of_find_property(np, name, &length);
> +       if (!prop) {
> +               pr_err("%s: could not find property %s\n", __func__, name);
> +               return -EINVAL;
> +       }
> +
> +       cells = length / sizeof(u32);
> +       if (cells == 1) {
> +               ret = of_property_read_u32(np, name, &result->typ);
> +               result->min = result->typ;
> +               result->max = result->typ;
> +       } else if (cells == 3) {
> +               ret = of_property_read_u32_array(np, name, &result->min, cells);
> +       } else {
> +               pr_err("%s: illegal timing specification in %s\n", __func__,
> +                       name);
> +               return -EINVAL;
> +       }
> +
> +       return ret;
> +}
> +
> +/**
> + * of_get_display_timing - parse display_timing entry from device_node
> + * @np: device_node with the properties
> + **/
> +static struct display_timing *of_get_display_timing(const struct device_node
> +                                                   *np)
> +{
> +       struct display_timing *dt;
> +       int ret = 0;
> +
> +       dt = kzalloc(sizeof(*dt), GFP_KERNEL);
> +       if (!dt) {
> +               pr_err("%s: could not allocate display_timing struct\n",
> +                       __func__);
> +               return NULL;
> +       }
> +
> +       ret |= parse_property(np, "hback-porch", &dt->hback_porch);
> +       ret |= parse_property(np, "hfront-porch", &dt->hfront_porch);
> +       ret |= parse_property(np, "hactive", &dt->hactive);
> +       ret |= parse_property(np, "hsync-len", &dt->hsync_len);
> +       ret |= parse_property(np, "vback-porch", &dt->vback_porch);
> +       ret |= parse_property(np, "vfront-porch", &dt->vfront_porch);
> +       ret |= parse_property(np, "vactive", &dt->vactive);
> +       ret |= parse_property(np, "vsync-len", &dt->vsync_len);
> +       ret |= parse_property(np, "clock-frequency", &dt->pixelclock);
> +
> +       of_property_read_u32(np, "vsync-active", &dt->vsync_pol_active);
> +       of_property_read_u32(np, "hsync-active", &dt->hsync_pol_active);
> +       of_property_read_u32(np, "de-active", &dt->de_pol_active);
> +       of_property_read_u32(np, "pixelclk-inverted", &dt->pixelclk_pol);
> +       dt->interlaced = of_property_read_bool(np, "interlaced");
> +       dt->doublescan = of_property_read_bool(np, "doublescan");
> +
> +       if (ret) {
> +               pr_err("%s: error reading timing properties\n", __func__);
> +               kfree(dt);
> +               return NULL;
> +       }
> +
> +       return dt;
> +}
> +
> +/**
> + * of_get_display_timings - parse all display_timing entries from a device_node
> + * @np: device_node with the subnodes
> + **/
> +struct display_timings *of_get_display_timings(struct device_node *np)
> +{
> +       struct device_node *timings_np;
> +       struct device_node *entry;
> +       struct device_node *native_mode;
> +       struct display_timings *disp;
> +
> +       if (!np) {
> +               pr_err("%s: no devicenode given\n", __func__);
> +               return NULL;
> +       }
> +
> +       timings_np = of_find_node_by_name(np, "display-timings");
> +       if (!timings_np) {
> +               pr_err("%s: could not find display-timings node\n", __func__);
> +               return NULL;
> +       }
> +
> +       disp = kzalloc(sizeof(*disp), GFP_KERNEL);
> +       if (!disp) {
> +               pr_err("%s: could not allocate struct disp'\n", __func__);
> +               goto dispfail;
> +       }
> +
> +       entry = of_parse_phandle(timings_np, "native-mode", 0);
> +       /* assume first child as native mode if none provided */
> +       if (!entry)
> +               entry = of_get_next_child(np, NULL);
> +       /* if there is no child, it is useless to go on */
> +       if (!entry) {
> +               pr_err("%s: no timing specifications given\n", __func__);
> +               goto entryfail;
> +       }
> +
> +       pr_info("%s: using %s as default timing\n", __func__, entry->name);
> +
> +       native_mode = entry;
> +
> +       disp->num_timings = of_get_child_count(timings_np);
> +       if (disp->num_timings == 0) {
> +               /* should never happen, as entry was already found above */
> +               pr_err("%s: no timings specified\n", __func__);
> +               goto entryfail;
> +       }
> +
> +       disp->timings = kzalloc(sizeof(struct display_timing *) * disp->num_timings,
> +                               GFP_KERNEL);
> +       if (!disp->timings) {
> +               pr_err("%s: could not allocate timings array\n", __func__);
> +               goto entryfail;
> +       }
> +
> +       disp->num_timings = 0;
> +       disp->native_mode = 0;
> +
> +       for_each_child_of_node(timings_np, entry) {
> +               struct display_timing *dt;
> +
> +               dt = of_get_display_timing(entry);
> +               if (!dt) {
> +                       /*
> +                        * to not encourage wrong devicetrees, fail in case of
> +                        * an error
> +                        */
> +                       pr_err("%s: error in timing %d\n", __func__,
> +                              disp->num_timings + 1);
> +                       goto timingfail;
> +               }
> +
> +               if (native_mode == entry)
> +                       disp->native_mode = disp->num_timings;
> +
> +               disp->timings[disp->num_timings] = dt;
> +               disp->num_timings++;
> +       }
> +       of_node_put(timings_np);
> +       /*
> +        * native_mode points to the device_node returned by of_parse_phandle
> +        * therefore call of_node_put on it
> +        */
> +       of_node_put(native_mode);
> +
> +       if (disp->num_timings > 0)
> +               pr_info("%s: got %d timings. Using timing #%d as default\n",
> +                       __func__, disp->num_timings, disp->native_mode + 1);
> +       else {
> +               pr_err("%s: no valid timings specified\n", __func__);
> +               display_timings_release(disp);
> +               return NULL;
> +       }
> +       return disp;
> +
> +timingfail:
> +       if (native_mode)
> +               of_node_put(native_mode);
> +       display_timings_release(disp);
> +entryfail:
> +       if (disp)
> +               kfree(disp);
> +dispfail:
> +       of_node_put(timings_np);
> +       return NULL;
> +}
> +EXPORT_SYMBOL_GPL(of_get_display_timings);
> +
> +/**
> + * of_display_timings_exists - check if a display-timings node is provided
> + * @np: device_node with the timing
> + **/
> +int of_display_timings_exists(const struct device_node *np)
> +{
> +       struct device_node *timings_np;
> +
> +       if (!np)
> +               return -EINVAL;
> +
> +       timings_np = of_parse_phandle(np, "display-timings", 0);

I'm seeing warning for the above call
"passing argument 1 of 'of_parse_phandle' discards qualifiers from
pointer target type
expected 'struct device_node *' but argument is of type 'const struct
device_node *' "
Please take care of it.

Best Wishes,
Leela Krishna Amudala

> +       if (!timings_np)
> +               return -EINVAL;
> +
> +       of_node_put(timings_np);
> +       return 1;
> +}
> +EXPORT_SYMBOL_GPL(of_display_timings_exists);
> diff --git a/drivers/video/of_videomode.c b/drivers/video/of_videomode.c
> new file mode 100644
> index 0000000..358aa56
> --- /dev/null
> +++ b/drivers/video/of_videomode.c
> @@ -0,0 +1,48 @@
> +/*
> + * generic videomode helper
> + *
> + * Copyright (c) 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>, Pengutronix
> + *
> + * This file is released under the GPLv2
> + */
> +#include <linux/of.h>
> +#include <linux/of_display_timings.h>
> +#include <linux/of_videomode.h>
> +#include <linux/export.h>
> +
> +/**
> + * of_get_videomode - get the videomode #<index> from devicetree
> + * @np - devicenode with the display_timings
> + * @vm - set to return value
> + * @index - index into list of display_timings
> + * DESCRIPTION:
> + * Get a list of all display timings and put the one
> + * specified by index into *vm. This function should only be used, if
> + * only one videomode is to be retrieved. A driver that needs to work
> + * with multiple/all videomodes should work with
> + * of_get_display_timings instead.
> + **/
> +int of_get_videomode(struct device_node *np, struct videomode *vm,
> +                    int index)
> +{
> +       struct display_timings *disp;
> +       int ret;
> +
> +       disp = of_get_display_timings(np);
> +       if (!disp) {
> +               pr_err("%s: no timings specified\n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       if (index == OF_USE_NATIVE_MODE)
> +               index = disp->native_mode;
> +
> +       ret = videomode_from_timing(disp, vm, index);
> +       if (ret)
> +               return ret;
> +
> +       display_timings_release(disp);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_get_videomode);
> diff --git a/include/linux/of_display_timings.h b/include/linux/of_display_timings.h
> new file mode 100644
> index 0000000..b3e3455
> --- /dev/null
> +++ b/include/linux/of_display_timings.h
> @@ -0,0 +1,20 @@
> +/*
> + * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
> + *
> + * display timings of helpers
> + *
> + * This file is released under the GPLv2
> + */
> +
> +#ifndef __LINUX_OF_DISPLAY_TIMINGS_H
> +#define __LINUX_OF_DISPLAY_TIMINGS_H
> +
> +#include <linux/display_timing.h>
> +#include <linux/of.h>
> +
> +#define OF_USE_NATIVE_MODE -1
> +
> +struct display_timings *of_get_display_timings(struct device_node *np);
> +int of_display_timings_exists(const struct device_node *np);
> +
> +#endif
> diff --git a/include/linux/of_videomode.h b/include/linux/of_videomode.h
> new file mode 100644
> index 0000000..a72ad78
> --- /dev/null
> +++ b/include/linux/of_videomode.h
> @@ -0,0 +1,18 @@
> +/*
> + * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
> + *
> + * videomode of-helpers
> + *
> + * This file is released under the GPLv2
> + */
> +
> +#ifndef __LINUX_OF_VIDEOMODE_H
> +#define __LINUX_OF_VIDEOMODE_H
> +
> +#include <linux/videomode.h>
> +#include <linux/of.h>
> +
> +int of_get_videomode(struct device_node *np, struct videomode *vm,
> +                    int index);
> +
> +#endif /* __LINUX_OF_VIDEOMODE_H */
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
