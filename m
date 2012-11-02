Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33621 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758141Ab2KBRUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2012 13:20:08 -0400
MIME-Version: 1.0
In-Reply-To: <1351675689-26814-3-git-send-email-s.trumtrar@pengutronix.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de> <1351675689-26814-3-git-send-email-s.trumtrar@pengutronix.de>
From: Leela Krishna Amudala <l.krishna@samsung.com>
Date: Fri, 2 Nov 2012 22:49:47 +0530
Message-ID: <CAL1wa8dGiS-UDk7vjPKBaxQHB2FyNgLRYr5jsJZe4GjdzHELLQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/8] of: add helper to parse display timings
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Steffen,

On Wed, Oct 31, 2012 at 2:58 PM, Steffen Trumtrar
<s.trumtrar@pengutronix.de> wrote:
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
>  .../devicetree/bindings/video/display-timings.txt  |  139 +++++++++++++++
>  drivers/of/Kconfig                                 |    6 +
>  drivers/of/Makefile                                |    1 +
>  drivers/of/of_display_timings.c                    |  185 ++++++++++++++++++++
>  include/linux/of_display_timings.h                 |   20 +++
>  5 files changed, 351 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/display-timings.txt
>  create mode 100644 drivers/of/of_display_timings.c
>  create mode 100644 include/linux/of_display_timings.h
>
> diff --git a/Documentation/devicetree/bindings/video/display-timings.txt b/Documentation/devicetree/bindings/video/display-timings.txt
> new file mode 100644
> index 0000000..04c94a3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/display-timings.txt
> @@ -0,0 +1,139 @@
> +display-timings bindings
> +==================
> +
> +display-timings-node
> +------------
> +
> +required properties:
> + - none
> +
> +optional properties:
> + - native-mode: the native mode for the display, in case multiple modes are
> +               provided. When omitted, assume the first node is the native.
> +
> +timings-subnode
> +---------------
> +
> +required properties:
> + - hactive, vactive: Display resolution
> + - hfront-porch, hback-porch, hsync-len: Horizontal Display timing parameters
> +   in pixels
> +   vfront-porch, vback-porch, vsync-len: Vertical display timing parameters in
> +   lines
> + - clock-frequency: displayclock in Hz
> +
> +optional properties:
> + - hsync-active : Hsync pulse is active low/high/ignored
> + - vsync-active : Vsync pulse is active low/high/ignored
> + - de-active : Data-Enable pulse is active low/high/ignored
> + - pixelclk-inverted : pixelclock is inverted/non-inverted/ignored
> + - interlaced (bool)
> + - doublescan (bool)
> +
> +All the optional properties that are not bool follow the following logic:
> +    <1> : high active
> +    <0> : low active
> +    omitted : not used on hardware
> +
> +There are different ways of describing the capabilities of a display. The devicetree
> +representation corresponds to the one commonly found in datasheets for displays.
> +If a display supports multiple signal timings, the native-mode can be specified.
> +
> +The parameters are defined as
> +
> +struct display_timing
> +===================
> +
> +  +----------+---------------------------------------------+----------+-------+
> +  |          |                ↑                            |          |       |
> +  |          |                |vback_porch                 |          |       |
> +  |          |                ↓                            |          |       |
> +  +----------###############################################----------+-------+
> +  |          #                ↑                            #          |       |
> +  |          #                |                            #          |       |
> +  |  hback   #                |                            #  hfront  | hsync |
> +  |   porch  #                |       hactive              #  porch   |  len  |
> +  |<-------->#<---------------+--------------------------->#<-------->|<----->|
> +  |          #                |                            #          |       |
> +  |          #                |vactive                     #          |       |
> +  |          #                |                            #          |       |
> +  |          #                ↓                            #          |       |
> +  +----------###############################################----------+-------+
> +  |          |                ↑                            |          |       |
> +  |          |                |vfront_porch                |          |       |
> +  |          |                ↓                            |          |       |
> +  +----------+---------------------------------------------+----------+-------+
> +  |          |                ↑                            |          |       |
> +  |          |                |vsync_len                   |          |       |
> +  |          |                ↓                            |          |       |
> +  +----------+---------------------------------------------+----------+-------+
> +
> +
> +Example:
> +
> +       display-timings {
> +               native-mode = <&timing0>;
> +               timing0: 1920p24 {
> +                       /* 1920x1080p24 */
> +                       clock = <52000000>;
> +                       hactive = <1920>;
> +                       vactive = <1080>;
> +                       hfront-porch = <25>;
> +                       hback-porch = <25>;
> +                       hsync-len = <25>;
> +                       vback-porch = <2>;
> +                       vfront-porch = <2>;
> +                       vsync-len = <2>;
> +                       hsync-active = <1>;
> +               };
> +       };
> +
> +Every required property also supports the use of ranges, so the commonly used
> +datasheet description with <min typ max>-tuples can be used.
> +
> +Example:
> +
> +       timing1: timing {
> +               /* 1920x1080p24 */
> +               clock = <148500000>;
> +               hactive = <1920>;
> +               vactive = <1080>;
> +               hsync-len = <0 44 60>;
> +               hfront-porch = <80 88 95>;
> +               hback-porch = <100 148 160>;
> +               vfront-porch = <0 4 6>;
> +               vback-porch = <0 36 50>;
> +               vsync-len = <0 5 6>;
> +       };
> +
> +
> +Usage in backend
> +================
> +
> +A backend driver may choose to use the display-timings directly and convert the timing
> +ranges to a suitable mode. Or it may just use the conversion of the display timings
> +to the required mode via the generic videomode struct.
> +
> +                                       dtb
> +                                        |
> +                                        |  of_get_display_timing_list
> +                                        ↓
> +                             struct display_timings
> +                                        |
> +                                        |  videomode_from_timing
> +                                        ↓
> +                           ---  struct videomode ---
> +                           |                       |
> + videomode_to_displaymode   |                      |   videomode_to_fb_videomode
> +                           ↓                       ↓
> +                    drm_display_mode         fb_videomode
> +
> +The functions of_get_fb_videomode and of_get_display_mode are provided
> +to conveniently get the respective mode representation from the devicetree.
> +
> +Conversion to videomode
> +=======================
> +
> +As device drivers normally work with some kind of video mode, the timings can be
> +converted (may be just a simple copying of the typical value) to a generic videomode
> +structure which then can be converted to the according mode used by the backend.
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index dfba3e6..781e773 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -83,4 +83,10 @@ config OF_MTD
>         depends on MTD
>         def_bool y
>
> +config OF_DISPLAY_TIMINGS
> +       def_bool y
> +       depends on DISPLAY_TIMING
> +       help
> +         helper to parse display timings from the devicetree
> +
>  endmenu # OF
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index e027f44..c8e9603 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -11,3 +11,4 @@ obj-$(CONFIG_OF_MDIO) += of_mdio.o
>  obj-$(CONFIG_OF_PCI)   += of_pci.o
>  obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
>  obj-$(CONFIG_OF_MTD)   += of_mtd.o
> +obj-$(CONFIG_OF_DISPLAY_TIMINGS) += of_display_timings.o
> diff --git a/drivers/of/of_display_timings.c b/drivers/of/of_display_timings.c
> new file mode 100644
> index 0000000..388fe4c
> --- /dev/null
> +++ b/drivers/of/of_display_timings.c
> @@ -0,0 +1,185 @@
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
> +static int parse_property(struct device_node *np, char *name,
> +                               struct timing_entry *result)
> +{
> +       struct property *prop;
> +       int length;
> +       int cells;
> +       int ret;
> +
> +       prop = of_find_property(np, name, &length);
> +       if (!prop) {
> +               pr_err("%s: could not find property %s\n", __func__, name);
> +               return -EINVAL;
> +       }
> +
> +       cells = length / sizeof(u32);
> +       if (cells == 1) {
> +               ret = of_property_read_u32_array(np, name, &result->typ, cells);

As you are reading only one vaue, you can use of_property_read_u32 instead.

> +               result->min = result->typ;
> +               result->max = result->typ;
> +       } else if (cells == 3) {
> +               ret = of_property_read_u32_array(np, name, &result->min, cells);

You are considering only min element, what about typ and max elements?

> +       } else {
> +               pr_err("%s: illegal timing specification in %s\n", __func__, name);
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
> +struct display_timing *of_get_display_timing(struct device_node *np)
> +{
> +       struct display_timing *dt;
> +       int ret = 0;
> +
> +       dt = kzalloc(sizeof(*dt), GFP_KERNEL);
> +       if (!dt) {
> +               pr_err("%s: could not allocate display_timing struct\n", __func__);
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
> +               return NULL;
> +       }
> +
> +       return dt;
> +}
> +EXPORT_SYMBOL_GPL(of_get_display_timing);
> +
> +/**
> + * of_get_display_timing_list - parse all display_timing entries from a device_node
> + * @np: device_node with the subnodes
> + **/
> +struct display_timings *of_get_display_timing_list(struct device_node *np)
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
> +
> +       entry = of_parse_phandle(timings_np, "native-mode", 0);
> +       /* assume first child as native mode if none provided */
> +       if (!entry)
> +               entry = of_get_next_child(np, NULL);
> +       if (!entry) {
> +               pr_err("%s: no timing specifications given\n", __func__);
> +               return NULL;
> +       }
> +
> +       pr_info("%s: using %s as default timing\n", __func__, entry->name);
> +
> +       native_mode = entry;
> +
> +       disp->num_timings = of_get_child_count(timings_np);
> +       disp->timings = kzalloc(sizeof(struct display_timing *)*disp->num_timings,
> +                               GFP_KERNEL);
> +       disp->num_timings = 0;
> +       disp->native_mode = 0;
> +
> +       for_each_child_of_node(timings_np, entry) {
> +               struct display_timing *dt;
> +
> +               dt = of_get_display_timing(entry);
> +               if (!dt) {
> +                       /* to not encourage wrong devicetrees, fail in case of an error */
> +                       pr_err("%s: error in timing %d\n", __func__, disp->num_timings+1);
> +                       return NULL;
> +               }
> +
> +               if (native_mode == entry)
> +                       disp->native_mode = disp->num_timings;
> +
> +               disp->timings[disp->num_timings] = dt;
> +               disp->num_timings++;
> +       }
> +       of_node_put(timings_np);
> +
> +       if (disp->num_timings > 0)
> +               pr_info("%s: got %d timings. Using timing #%d as default\n", __func__,
> +                       disp->num_timings , disp->native_mode + 1);
> +       else {
> +               pr_err("%s: no valid timings specified\n", __func__);
> +               return NULL;
> +       }
> +       return disp;
> +}
> +EXPORT_SYMBOL_GPL(of_get_display_timing_list);
> +
> +/**
> + * of_display_timings_exists - check if a display-timings node is provided
> + * @np: device_node with the timing
> + **/
> +int of_display_timings_exists(struct device_node *np)
> +{
> +       struct device_node *timings_np;
> +       struct device_node *default_np;
> +
> +       if (!np)
> +               return -EINVAL;
> +
> +       timings_np = of_parse_phandle(np, "display-timings", 0);
> +       if (!timings_np)
> +               return -EINVAL;
> +
> +       return -EINVAL;

Here it should return success instead of -EINVAL.

And one query.. are the binding properties names and "display-timings"
node structure template  finalized..?

Best Wishes,
Leela Krishna Amudala.

> +}
> +EXPORT_SYMBOL_GPL(of_display_timings_exists);
> diff --git a/include/linux/of_display_timings.h b/include/linux/of_display_timings.h
> new file mode 100644
> index 0000000..e4e1f22
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
> +
> +#define OF_USE_NATIVE_MODE -1
> +
> +struct display_timings *of_get_display_timing_list(struct device_node *np);
> +struct display_timing *of_get_display_timing(struct device_node *np);
> +int of_display_timings_exists(struct device_node *np);
> +
> +#endif
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
