Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:50110 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab2JDSrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 14:47:20 -0400
Message-ID: <506DD9B4.40409@wwwdotorg.org>
Date: Thu, 04 Oct 2012 12:47:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de> <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/04/2012 11:59 AM, Steffen Trumtrar wrote:

A patch description would be useful for something like this.

> diff --git a/Documentation/devicetree/bindings/video/display-timings.txt b/Documentation/devicetree/bindings/video/display-timings.txt
> new file mode 100644
...
> +Usage in backend
> +================

Everything before that point in the file looks fine to me.

Everything after this point in the file seems to be Linux-specific
implementation details. Does it really belong in the DT binding
documentation, rather than some Linux-specific documentation file?

> +struct drm_display_mode
> +=======================
> +
> +  +----------+---------------------------------------------+----------+-------+
> +  |          |                                             |          |       |  ↑
> +  |          |                                             |          |       |  |
> +  |          |                                             |          |       |  |
> +  +----------###############################################----------+-------+  |

I suspect the entire horizontal box above (and the entire vertical box
all the way down the left-hand side) should be on the bottom/right
instead of top/left. The reason I think this is because all of
vsync_start, vsync_end, vdisplay have to be referenced to some known
point, which is usually zero or the start of the timing definition, /or/
there would be some value indicating the size of the top marging/porch
in order to say where those other values are referenced to.

> +  |          #   ↑         ↑          ↑                    #          |       |  |
> +  |          #   |         |          |                    #          |       |  |
> +  |          #   |         |          |                    #          |       |  |
> +  |          #   |         |          |                    #          |       |  |
> +  |          #   |         |          |                    #          |       |  |
> +  |          #   |         |          |       hdisplay     #          |       |  |
> +  |          #<--+--------------------+------------------->#          |       |  |
> +  |          #   |         |          |                    #          |       |  |
> +  |          #   |vsync_start         |                    #          |       |  |
> +  |          #   |         |          |                    #          |       |  |
> +  |          #   |         |vsync_end |                    #          |       |  |
> +  |          #   |         |          |vdisplay            #          |       |  |
> +  |          #   |         |          |                    #          |       |  |
> +  |          #   |         |          |                    #          |       |  |
> +  |          #   |         |          |                    #          |       |  | vtotal
> +  |          #   |         |          |                    #          |       |  |
> +  |          #   |         |          |     hsync_start    #          |       |  |
> +  |          #<--+---------+----------+------------------------------>|       |  |
> +  |          #   |         |          |                    #          |       |  |
> +  |          #   |         |          |     hsync_end      #          |       |  |
> +  |          #<--+---------+----------+-------------------------------------->|  |
> +  |          #   |         |          ↓                    #          |       |  |
> +  +----------####|#########|################################----------+-------+  |
> +  |          |   |         |                               |          |       |  |
> +  |          |   |         |                               |          |       |  |
> +  |          |   ↓         |                               |          |       |  |
> +  +----------+-------------+-------------------------------+----------+-------+  |
> +  |          |             |                               |          |       |  |
> +  |          |             |                               |          |       |  |
> +  |          |             ↓                               |          |       |  ↓
> +  +----------+---------------------------------------------+----------+-------+
> +                                   htotal
> +   <------------------------------------------------------------------------->

> diff --git a/drivers/of/of_display_timings.c b/drivers/of/of_display_timings.c

> +static int parse_property(struct device_node *np, char *name,
> +				struct timing_entry *result)

> +	if (cells == 1)
> +		ret = of_property_read_u32_array(np, name, &result->typ, cells);

Should that branch not just set result->min/max to typ as well?
Presumably it'd prevent any code that interprets struct timing_entry
from having to check if those values were 0 or not?

> +	else if (cells == 3)
> +		ret = of_property_read_u32_array(np, name, &result->min, cells);

> +struct display_timings *of_get_display_timing_list(struct device_node *np)

> +	entry = of_parse_phandle(timings_np, "default-timing", 0);
> +
> +	if (!entry) {
> +		pr_info("%s: no default-timing specified\n", __func__);
> +		entry = of_find_node_by_name(np, "timing");

I don't think you want to require the node have an explicit name; I
don't recall the DT binding documentation making that a requirement.
Instead, can't you either just leave the default unset, or pick the
first DT child node, irrespective of name?

> +	if (!entry) {
> +		pr_info("%s: no timing specifications given\n", __func__);
> +		return disp;
> +	}

The DT bindings don't state that it's mandatory to have some timing
specified, although I agree that it makes sense in practice.

> +	for_each_child_of_node(timings_np, entry) {
> +		struct signal_timing *st;
> +
> +		st = of_get_display_timing(entry);
> +
> +		if (!st)
> +			continue;

I wonder if that shouldn't be an error?

> +		if (strcmp(default_timing, entry->full_name) == 0)
> +			disp->default_timing = disp->num_timings;

Hmm. Why not compare the node pointers rather than the name? Also, if
the parsing failed, then this can lead to default_timing being
uninitialized anyway...

> +		disp->timings[disp->num_timings] = st;
> +		disp->num_timings++;
> +	}

> +	if (disp->num_timings >= 0)
> +		pr_info("%s: got %d timings. Using timing #%d as default\n", __func__,
> +			disp->num_timings , disp->default_timing + 1);
> +	else
> +		pr_info("%s: no timings specified\n", __func__);

The message in the else clause is not necessarily true; there may have
been some specified, but they just couldn't be parsed.

> +int of_display_timings_exists(struct device_node *np)
> +{
> +	struct device_node *timings_np;
> +	struct device_node *default_np;
> +
> +	if (!np)
> +		return -EINVAL;
> +
> +	timings_np = of_parse_phandle(np, "display-timings", 0);
> +
> +	if (!timings_np)
> +		return -EINVAL;
> +
> +	default_np = of_parse_phandle(np, "default-timing", 0);
> +
> +	if (default_np)
> +		return 0;

If this function checks that a default-timing property exists, shouldn't
the function be named of_display_default_timing_exists()?
