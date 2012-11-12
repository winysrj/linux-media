Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44936 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2KLS6v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 13:58:51 -0500
Date: Mon, 12 Nov 2012 19:58:40 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
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
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v8 2/6] video: add of helper for videomode
Message-ID: <20121112185840.GX10369@pengutronix.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-3-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352734626-27412-3-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steffen,

You lose memory in several places:

On Mon, Nov 12, 2012 at 04:37:02PM +0100, Steffen Trumtrar wrote:
> +static struct display_timing *of_get_display_timing(struct device_node *np)
> +{
> +	struct display_timing *dt;
> +	int ret = 0;
> +
> +	dt = kzalloc(sizeof(*dt), GFP_KERNEL);
> +	if (!dt) {
> +		pr_err("%s: could not allocate display_timing struct\n", __func__);
> +		return NULL;
> +	}
> +
> +	ret |= parse_property(np, "hback-porch", &dt->hback_porch);
> +	ret |= parse_property(np, "hfront-porch", &dt->hfront_porch);
> +	ret |= parse_property(np, "hactive", &dt->hactive);
> +	ret |= parse_property(np, "hsync-len", &dt->hsync_len);
> +	ret |= parse_property(np, "vback-porch", &dt->vback_porch);
> +	ret |= parse_property(np, "vfront-porch", &dt->vfront_porch);
> +	ret |= parse_property(np, "vactive", &dt->vactive);
> +	ret |= parse_property(np, "vsync-len", &dt->vsync_len);
> +	ret |= parse_property(np, "clock-frequency", &dt->pixelclock);
> +
> +	of_property_read_u32(np, "vsync-active", &dt->vsync_pol_active);
> +	of_property_read_u32(np, "hsync-active", &dt->hsync_pol_active);
> +	of_property_read_u32(np, "de-active", &dt->de_pol_active);
> +	of_property_read_u32(np, "pixelclk-inverted", &dt->pixelclk_pol);
> +	dt->interlaced = of_property_read_bool(np, "interlaced");
> +	dt->doublescan = of_property_read_bool(np, "doublescan");
> +
> +	if (ret) {
> +		pr_err("%s: error reading timing properties\n", __func__);
> +		return NULL;

Here

> +	}
> +
> +	return dt;
> +}
> +
> +/**
> + * of_get_display_timings - parse all display_timing entries from a device_node
> + * @np: device_node with the subnodes
> + **/
> +struct display_timings *of_get_display_timings(struct device_node *np)
> +{
> +	struct device_node *timings_np;
> +	struct device_node *entry;
> +	struct device_node *native_mode;
> +	struct display_timings *disp;
> +
> +	if (!np) {
> +		pr_err("%s: no devicenode given\n", __func__);
> +		return NULL;
> +	}
> +
> +	timings_np = of_find_node_by_name(np, "display-timings");
> +	if (!timings_np) {
> +		pr_err("%s: could not find display-timings node\n", __func__);
> +		return NULL;
> +	}
> +
> +	disp = kzalloc(sizeof(*disp), GFP_KERNEL);
> +	if (!disp)
> +		return -ENOMEM;
> +
> +	entry = of_parse_phandle(timings_np, "native-mode", 0);
> +	/* assume first child as native mode if none provided */
> +	if (!entry)
> +		entry = of_get_next_child(np, NULL);
> +	if (!entry) {
> +		pr_err("%s: no timing specifications given\n", __func__);
> +		return NULL;

Here

> +	}
> +
> +	pr_info("%s: using %s as default timing\n", __func__, entry->name);
> +
> +	native_mode = entry;
> +
> +	disp->num_timings = of_get_child_count(timings_np);
> +	disp->timings = kzalloc(sizeof(struct display_timing *)*disp->num_timings,
> +				GFP_KERNEL);
> +	if (!disp->timings)
> +		return -ENOMEM;

Here

> +
> +	disp->num_timings = 0;
> +	disp->native_mode = 0;
> +
> +	for_each_child_of_node(timings_np, entry) {
> +		struct display_timing *dt;
> +
> +		dt = of_get_display_timing(entry);
> +		if (!dt) {
> +			/* to not encourage wrong devicetrees, fail in case of an error */
> +			pr_err("%s: error in timing %d\n", __func__, disp->num_timings+1);
> +			return NULL;

Here

> +		}
> +
> +		if (native_mode == entry)
> +			disp->native_mode = disp->num_timings;
> +
> +		disp->timings[disp->num_timings] = dt;
> +		disp->num_timings++;
> +	}
> +	of_node_put(timings_np);
> +
> +	if (disp->num_timings > 0)
> +		pr_info("%s: got %d timings. Using timing #%d as default\n", __func__,
> +			disp->num_timings , disp->native_mode + 1);
> +	else {
> +		pr_err("%s: no valid timings specified\n", __func__);
> +		return NULL;

and here

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
