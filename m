Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55780 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab2JHHte (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 03:49:34 -0400
Date: Mon, 8 Oct 2012 09:49:21 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
Message-ID: <20121008074921.GB20800@pengutronix.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
 <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de>
 <1349680065.3227.25.camel@deskari>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1349680065.3227.25.camel@deskari>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Oct 08, 2012 at 10:07:45AM +0300, Tomi Valkeinen wrote:
> Hi,
> 
> On Thu, 2012-10-04 at 19:59 +0200, Steffen Trumtrar wrote:
> > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > ---
> >  .../devicetree/bindings/video/display-timings.txt  |  222 ++++++++++++++++++++
> >  drivers/of/Kconfig                                 |    5 +
> >  drivers/of/Makefile                                |    1 +
> >  drivers/of/of_display_timings.c                    |  183 ++++++++++++++++
> >  include/linux/of_display_timings.h                 |   85 ++++++++
> >  5 files changed, 496 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/video/display-timings.txt
> >  create mode 100644 drivers/of/of_display_timings.c
> >  create mode 100644 include/linux/of_display_timings.h
> > 
> > diff --git a/Documentation/devicetree/bindings/video/display-timings.txt b/Documentation/devicetree/bindings/video/display-timings.txt
> > new file mode 100644
> > index 0000000..45e39bd
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/video/display-timings.txt
> > @@ -0,0 +1,222 @@
> > +display-timings bindings
> > +==================
> > +
> > +display-timings-node
> > +------------
> > +
> > +required properties:
> > + - none
> > +
> > +optional properties:
> > + - default-timing: the default timing value
> > +
> > +timings-subnode
> > +---------------
> > +
> > +required properties:
> > + - hactive, vactive: Display resolution
> > + - hfront-porch, hback-porch, hsync-len: Horizontal Display timing parameters
> > +   in pixels
> > +   vfront-porch, vback-porch, vsync-len: Vertical display timing parameters in
> > +   lines
> > + - clock: displayclock in Hz
> > +
> > +optional properties:
> > + - hsync-active-high (bool): Hsync pulse is active high
> > + - vsync-active-high (bool): Vsync pulse is active high
> > + - de-active-high (bool): Data-Enable pulse is active high
> > + - pixelclk-inverted (bool): pixelclock is inverted
> > + - interlaced (bool)
> > + - doublescan (bool)
> 
> I think bool should be generally used for things that are on/off, like
> interlace. For hsync-active-high & others I'd rather have 0/1 values as
> others already suggested.
> 
> > +There are different ways of describing the capabilities of a display. The devicetree
> > +representation corresponds to the one commonly found in datasheets for displays.
> > +If a display supports multiple signal timings, the default-timing can be specified.
> > +
> > +The parameters are defined as
> > +
> > +struct signal_timing
> > +===================
> > +
> > +  +----------+---------------------------------------------+----------+-------+
> > +  |          |                ↑                            |          |       |
> > +  |          |                |vback_porch                 |          |       |
> > +  |          |                ↓                            |          |       |
> > +  +----------###############################################----------+-------+
> > +  |          #                ↑                            #          |       |
> > +  |          #                |                            #          |       |
> > +  |  hback   #                |                            #  hfront  | hsync |
> > +  |   porch  #                |       hactive              #  porch   |  len  |
> > +  |<-------->#<---------------+--------------------------->#<-------->|<----->|
> > +  |          #                |                            #          |       |
> > +  |          #                |vactive                     #          |       |
> > +  |          #                |                            #          |       |
> > +  |          #                ↓                            #          |       |
> > +  +----------###############################################----------+-------+
> > +  |          |                ↑                            |          |       |
> > +  |          |                |vfront_porch                |          |       |
> > +  |          |                ↓                            |          |       |
> > +  +----------+---------------------------------------------+----------+-------+
> > +  |          |                ↑                            |          |       |
> > +  |          |                |vsync_len                   |          |       |
> > +  |          |                ↓                            |          |       |
> > +  +----------+---------------------------------------------+----------+-------+
> > +
> > +
> > +Example:
> > +
> > +	display-timings {
> > +		default-timing = <&timing0>;
> > +		timing0: 1920p24 {
> > +			/* 1920x1080p24 */
> 
> I think this is commonly called 1080p24.
> 

Oops. Yes, you are right.

> > +			clock = <52000000>;
> > +			hactive = <1920>;
> > +			vactive = <1080>;
> > +			hfront-porch = <25>;
> > +			hback-porch = <25>;
> > +			hsync-len = <25>;
> > +			vback-porch = <2>;
> > +			vfront-porch = <2>;
> > +			vsync-len = <2>;
> > +			hsync-active-high;
> > +		};
> > +	};
> > +
> > +Every property also supports the use of ranges, so the commonly used datasheet
> > +description with <min typ max>-tuples can be used.
> > +
> > +Example:
> > +
> > +	timing1: timing {
> > +		/* 1920x1080p24 */
> > +		clock = <148500000>;
> > +		hactive = <1920>;
> > +		vactive = <1080>;
> > +		hsync-len = <0 44 60>;
> > +		hfront-porch = <80 88 95>;
> > +		hback-porch = <100 148 160>;
> > +		vfront-porch = <0 4 6>;
> > +		vback-porch = <0 36 50>;
> > +		vsync-len = <0 5 6>;
> > +	};
> > +
> > +Usage in backend
> > +================
> > +
> > +A backend driver may choose to use the display-timings directly and convert the timing
> > +ranges to a suitable mode. Or it may just use the conversion of the display timings
> > +to the required mode via the generic videomode struct.
> > +
> > +					dtb
> > +					 |
> > +					 |  of_get_display_timing_list
> > +					 ↓
> > +			      struct display_timings
> > +					 |
> > +					 |  videomode_from_timing
> > +					 ↓
> > +			    ---  struct videomode ---
> > +			    |			    |
> > + videomode_to_displaymode   |			    |   videomode_to_fb_videomode
> > +		            ↓			    ↓
> > +		     drm_display_mode         fb_videomode
> > +
> > +The functions of_get_fb_videomode and of_get_display_mode are provided
> > +to conveniently get the respective mode representation from the devicetree.
> > +
> > +Conversion to videomode
> > +=======================
> > +
> > +As device drivers normally work with some kind of video mode, the timings can be
> > +converted (may be just a simple copying of the typical value) to a generic videomode
> > +structure which then can be converted to the according mode used by the backend.
> > +
> > +Supported modes
> > +===============
> > +
> > +The generic videomode read in by the driver can be converted to the following
> > +modes with the following parameters
> > +
> > +struct fb_videomode
> > +===================
> > +
> > +  +----------+---------------------------------------------+----------+-------+
> > +  |          |                ↑                            |          |       |
> > +  |          |                |upper_margin                |          |       |
> > +  |          |                ↓                            |          |       |
> > +  +----------###############################################----------+-------+
> > +  |          #                ↑                            #          |       |
> > +  |          #                |                            #          |       |
> > +  |          #                |                            #          |       |
> > +  |          #                |                            #          |       |
> > +  |   left   #                |                            #  right   | hsync |
> > +  |  margin  #                |       xres                 #  margin  |  len  |
> > +  |<-------->#<---------------+--------------------------->#<-------->|<----->|
> > +  |          #                |                            #          |       |
> > +  |          #                |                            #          |       |
> > +  |          #                |                            #          |       |
> > +  |          #                |yres                        #          |       |
> > +  |          #                |                            #          |       |
> > +  |          #                |                            #          |       |
> > +  |          #                |                            #          |       |
> > +  |          #                |                            #          |       |
> > +  |          #                |                            #          |       |
> > +  |          #                |                            #          |       |
> > +  |          #                |                            #          |       |
> > +  |          #                |                            #          |       |
> > +  |          #                ↓                            #          |       |
> > +  +----------###############################################----------+-------+
> > +  |          |                ↑                            |          |       |
> > +  |          |                |lower_margin                |          |       |
> > +  |          |                ↓                            |          |       |
> > +  +----------+---------------------------------------------+----------+-------+
> > +  |          |                ↑                            |          |       |
> > +  |          |                |vsync_len                   |          |       |
> > +  |          |                ↓                            |          |       |
> > +  +----------+---------------------------------------------+----------+-------+
> > +
> > +clock in nanoseconds
> > +
> > +struct drm_display_mode
> > +=======================
> > +
> > +  +----------+---------------------------------------------+----------+-------+
> > +  |          |                                             |          |       |  ↑
> > +  |          |                                             |          |       |  |
> > +  |          |                                             |          |       |  |
> > +  +----------###############################################----------+-------+  |
> > +  |          #   ↑         ↑          ↑                    #          |       |  |
> > +  |          #   |         |          |                    #          |       |  |
> > +  |          #   |         |          |                    #          |       |  |
> > +  |          #   |         |          |                    #          |       |  |
> > +  |          #   |         |          |                    #          |       |  |
> > +  |          #   |         |          |       hdisplay     #          |       |  |
> > +  |          #<--+--------------------+------------------->#          |       |  |
> > +  |          #   |         |          |                    #          |       |  |
> > +  |          #   |vsync_start         |                    #          |       |  |
> > +  |          #   |         |          |                    #          |       |  |
> > +  |          #   |         |vsync_end |                    #          |       |  |
> > +  |          #   |         |          |vdisplay            #          |       |  |
> > +  |          #   |         |          |                    #          |       |  |
> > +  |          #   |         |          |                    #          |       |  |
> > +  |          #   |         |          |                    #          |       |  | vtotal
> > +  |          #   |         |          |                    #          |       |  |
> > +  |          #   |         |          |     hsync_start    #          |       |  |
> > +  |          #<--+---------+----------+------------------------------>|       |  |
> > +  |          #   |         |          |                    #          |       |  |
> > +  |          #   |         |          |     hsync_end      #          |       |  |
> > +  |          #<--+---------+----------+-------------------------------------->|  |
> > +  |          #   |         |          ↓                    #          |       |  |
> > +  +----------####|#########|################################----------+-------+  |
> > +  |          |   |         |                               |          |       |  |
> > +  |          |   |         |                               |          |       |  |
> > +  |          |   ↓         |                               |          |       |  |
> > +  +----------+-------------+-------------------------------+----------+-------+  |
> > +  |          |             |                               |          |       |  |
> > +  |          |             |                               |          |       |  |
> > +  |          |             ↓                               |          |       |  ↓
> > +  +----------+---------------------------------------------+----------+-------+
> > +                                   htotal
> > +   <------------------------------------------------------------------------->
> > +
> > +clock in kilohertz
> > diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> > index dfba3e6..646deb0 100644
> > --- a/drivers/of/Kconfig
> > +++ b/drivers/of/Kconfig
> > @@ -83,4 +83,9 @@ config OF_MTD
> >  	depends on MTD
> >  	def_bool y
> >  
> > +config OF_DISPLAY_TIMINGS
> > +	def_bool y
> > +	help
> > +	  helper to parse display timings from the devicetree
> > +
> >  endmenu # OF
> > diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> > index e027f44..c8e9603 100644
> > --- a/drivers/of/Makefile
> > +++ b/drivers/of/Makefile
> > @@ -11,3 +11,4 @@ obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
> >  obj-$(CONFIG_OF_PCI)	+= of_pci.o
> >  obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
> >  obj-$(CONFIG_OF_MTD)	+= of_mtd.o
> > +obj-$(CONFIG_OF_DISPLAY_TIMINGS) += of_display_timings.o
> > diff --git a/drivers/of/of_display_timings.c b/drivers/of/of_display_timings.c
> > new file mode 100644
> > index 0000000..e47bc63
> > --- /dev/null
> > +++ b/drivers/of/of_display_timings.c
> > @@ -0,0 +1,183 @@
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
> > +/* every signal_timing can be specified with either
> > + * just the typical value or a range consisting of
> > + * min/typ/max.
> > + * This function helps handling this
> > + */
> 
> The comment is not according to kernel coding style. And I'd start the
> sentence with a capital letter =).
> 
> > +static int parse_property(struct device_node *np, char *name,
> > +				struct timing_entry *result)
> > +{
> > +	struct property *prop;
> > +	int length;
> > +	int cells;
> > +	int ret;
> > +
> > +	prop = of_find_property(np, name, &length);
> > +	if (!prop) {
> > +		pr_err("%s: could not find property %s\n", __func__, name);
> > +		return -EINVAL;
> > +	}
> > +
> > +	cells = length / sizeof(u32);
> > +
> > +	if (cells == 1)
> > +		ret = of_property_read_u32_array(np, name, &result->typ, cells);
> > +	else if (cells == 3)
> > +		ret = of_property_read_u32_array(np, name, &result->min, cells);
> > +	else {
> > +		pr_err("%s: illegal timing specification in %s\n", __func__,
> > +			name);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +struct signal_timing *of_get_display_timing(struct device_node *np)
> > +{
> > +	struct signal_timing *st;
> > +	int ret = 0;
> > +
> > +	st = kzalloc(sizeof(*st), GFP_KERNEL);
> > +
> > +	if (!st) {
> > +		pr_err("%s: could not allocate signal_timing struct\n", __func__);
> > +		return NULL;
> > +	}
> > +
> > +	ret |= parse_property(np, "hback-porch", &st->hback_porch);
> > +	ret |= parse_property(np, "hfront-porch", &st->hfront_porch);
> > +	ret |= parse_property(np, "hactive", &st->hactive);
> > +	ret |= parse_property(np, "hsync-len", &st->hsync_len);
> > +	ret |= parse_property(np, "vback-porch", &st->vback_porch);
> > +	ret |= parse_property(np, "vfront-porch", &st->vfront_porch);
> > +	ret |= parse_property(np, "vactive", &st->vactive);
> > +	ret |= parse_property(np, "vsync-len", &st->vsync_len);
> > +	ret |= parse_property(np, "clock", &st->pixelclock);
> > +
> > +	st->vsync_pol_active_high = of_property_read_bool(np, "vsync-active-high");
> > +	st->hsync_pol_active_high = of_property_read_bool(np, "hsync-active-high");
> > +	st->de_pol_active_high = of_property_read_bool(np, "de-active-high");
> > +	st->pixelclk_pol_inverted = of_property_read_bool(np, "pixelclk-inverted");
> > +	st->interlaced = of_property_read_bool(np, "interlaced");
> > +	st->doublescan = of_property_read_bool(np, "doublescan");
> > +
> > +	if (ret) {
> > +		pr_err("%s: error reading timing properties\n", __func__);
> > +		return NULL;
> > +	}
> > +
> > +	return st;
> > +}
> > +EXPORT_SYMBOL_GPL(of_get_display_timing);
> > +
> > +struct display_timings *of_get_display_timing_list(struct device_node *np)
> > +{
> > +	struct device_node *timings_np;
> > +	struct device_node *entry;
> > +	struct display_timings *disp;
> > +	char *default_timing;
> > +
> > +	if (!np) {
> > +		pr_err("%s: no devicenode given\n", __func__);
> > +		return NULL;
> > +	}
> > +
> > +	timings_np = of_find_node_by_name(np, "display-timings");
> > +
> > +	if (!timings_np) {
> > +		pr_err("%s: could not find display-timings node\n", __func__);
> > +		return NULL;
> > +	}
> > +
> > +	disp = kzalloc(sizeof(*disp), GFP_KERNEL);
> > +
> > +	entry = of_parse_phandle(timings_np, "default-timing", 0);
> > +
> > +	if (!entry) {
> > +		pr_info("%s: no default-timing specified\n", __func__);
> > +		entry = of_find_node_by_name(np, "timing");
> > +	}
> 
> If "default-timing" property is optional, I don't see any need for the
> pr_info above, as it should be business as usual if the property doesn't
> exist.
> 
> If the default-timing property doesn't exist, wouldn't it be simpler to
> get the first subnode, instead of looking one with "timing" name?
> 

Yes. I will fix that.

> > +
> > +	if (!entry) {
> > +		pr_info("%s: no timing specifications given\n", __func__);
> > +		return disp;
> > +	}
> 
> Again, I don't think the pr_info is needed if this is a normal case.
> Then again, perhaps this could be an error? Why would there be a display
> node without any timings?
> 
This should be an error. It is a relict from trying to define the display instead
of just the timings. I need to rework the whole no/wrong timings thing.

> > +
> > +	pr_info("%s: using %s as default timing\n", __func__, entry->name);
> > +
> > +	default_timing = (char *)entry->full_name;
> 
> const char *?
> 

> > +
> > +	disp->num_timings = 0;
> > +
> > +	for_each_child_of_node(timings_np, entry) {
> > +		disp->num_timings++;
> > +	}
> 
> No need for { }
> 

Okay.

> > +	disp->timings = kzalloc(sizeof(struct signal_timing *)*disp->num_timings,
> > +				GFP_KERNEL);
> > +
> > +	disp->num_timings = 0;
> > +
> > +	for_each_child_of_node(timings_np, entry) {
> > +		struct signal_timing *st;
> > +
> > +		st = of_get_display_timing(entry);
> > +
> > +		if (!st)
> > +			continue;
> > +
> > +		if (strcmp(default_timing, entry->full_name) == 0)
> > +			disp->default_timing = disp->num_timings;
> 
> I don't see you setting disp->default_timing to OF_DEFAULT_TIMING in
> case there's no default_timing found.
> 
> Or, at least I presume OF_DEFAULT_TIMING is meant to mark non-existing
> default timing. The name OF_DEFAULT_TIMING is not very descriptive to
> me.
> 
> Would it make more sense to have the disp->default_timing as a pointer
> to the timing, instead of index? Then a NULL value would mark a
> non-existing default timing.
> 
> > +		disp->timings[disp->num_timings] = st;
> > +		disp->num_timings++;
> > +	}
> > +
> > +
> > +	of_node_put(timings_np);
> > +
> > +	if (disp->num_timings >= 0)
> > +		pr_info("%s: got %d timings. Using timing #%d as default\n", __func__,
> > +			disp->num_timings , disp->default_timing + 1);
> > +	else
> > +		pr_info("%s: no timings specified\n", __func__);
> > +
> > +	return disp;
> > +}
> > +EXPORT_SYMBOL_GPL(of_get_display_timing_list);
> > +
> > +int of_display_timings_exists(struct device_node *np)
> > +{
> > +	struct device_node *timings_np;
> > +	struct device_node *default_np;
> > +
> > +	if (!np)
> > +		return -EINVAL;
> > +
> > +	timings_np = of_parse_phandle(np, "display-timings", 0);
> > +
> > +	if (!timings_np)
> > +		return -EINVAL;
> > +
> > +	default_np = of_parse_phandle(np, "default-timing", 0);
> > +
> > +	if (default_np)
> > +		return 0;
> > +
> > +	return -EINVAL;
> > +}
> > +EXPORT_SYMBOL_GPL(of_display_timings_exists);
> > diff --git a/include/linux/of_display_timings.h b/include/linux/of_display_timings.h
> > new file mode 100644
> > index 0000000..1ad719e
> > --- /dev/null
> > +++ b/include/linux/of_display_timings.h
> > @@ -0,0 +1,85 @@
> > +/*
> > + * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > + *
> > + * description of display timings
> > + *
> > + * This file is released under the GPLv2
> > + */
> > +
> > +#ifndef __LINUX_OF_DISPLAY_TIMINGS_H
> > +#define __LINUX_OF_DISPLAY_TIMINGS_H
> > +
> > +#define OF_DEFAULT_TIMING -1
> > +
> > +struct display_timings {
> > +	unsigned int num_timings;
> > +	unsigned int default_timing;
> > +
> > +	struct signal_timing **timings;
> 
> Should this be a pointer to a const array of const data? Is there ever
> need to change them after they've been read from DT?
> 

No, there isn't. Will change to const.

> > +};
> > +
> > +struct timing_entry {
> > +	u32 min;
> > +	u32 typ;
> > +	u32 max;
> > +};
> > +
> > +struct signal_timing {
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
> > +	bool vsync_pol_active_high;
> > +	bool hsync_pol_active_high;
> > +	bool de_pol_active_high;
> > +	bool pixelclk_pol_inverted;
> > +	bool interlaced;
> > +	bool doublescan;
> > +};
> > +
> > +struct display_timings *of_get_display_timing_list(struct device_node *np);
> > +struct signal_timing *of_get_display_timing(struct device_node *np);
> > +int of_display_timings_exists(struct device_node *np);
> > +
> > +/* placeholder function until ranges are really needed */
> > +static inline u32 signal_timing_get_value(struct timing_entry *te, int index)
> > +{
> > +	return te->typ;
> > +}
> > +
> > +static inline void timings_release(struct display_timings *disp)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < disp->num_timings; i++)
> > +		kfree(disp->timings[i]);
> > +}
> > +
> > +static inline void display_timings_release(struct display_timings *disp)
> > +{
> > +	timings_release(disp);
> > +	kfree(disp->timings);
> > +}
> > +
> > +static inline struct signal_timing *display_timings_get(struct display_timings *disp,
> > +							 int index)
> > +{
> > +	struct signal_timing *st;
> > +
> > +	if (disp->num_timings > index) {
> > +		st = disp->timings[index];
> > +		return st;
> > +	}
> > +	else
> > +		return NULL;
> > +}
> 
> Why do you have these functions in the header file?
> 

Well, ... there actually isn't any reason any longer. I will move them.


Thanks and regards,
Steffen


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
