Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62549 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161139Ab2KNMBC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 07:01:02 -0500
Date: Wed, 14 Nov 2012 13:00:45 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v9 2/6] video: add of helper for videomode
Message-ID: <20121114120045.GA2803@avionic-0098.mockup.avionic-design.de>
References: <1352893403-21168-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352893403-21168-3-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <1352893403-21168-3-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 12:43:19PM +0100, Steffen Trumtrar wrote:
[...]
> +display-timings bindings
> +========================
> +
> +display timings node

I didn't express myself very clearly here =). The way I think this
should be written is "display-timings node".

> +required properties:
> + - hactive, vactive: Display resolution
> + - hfront-porch, hback-porch, hsync-len: Horizontal Display timing parameters
> +   in pixels
> +   vfront-porch, vback-porch, vsync-len: Vertical display timing parameters in
> +   lines
> + - clock-frequency: displayclock in Hz

I still think "displayclock" should be two words: "display clock".

> +/**
> + * of_get_display_timings - parse all display_timing entries from a device_node
> + * @np: device_node with the subnodes
> + **/
> +struct display_timings *of_get_display_timings(struct device_node *np)
> +{
[...]
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
> +			goto timingfail;

I believe you're still potentially leaking memory here. In case you have
5 entries for instance, and the last one fails to parse, then this will
cause the memory allocated for the 4 correct entries to be lost.

Can't you just call display_timings_release() in this case and then jump
to dispfail? That would still leak the native_mode device node. Maybe it
would be better to keep timingfail but modify it to free the display
timings with display_timings_release() instead? See below.

> +		}
> +
> +		if (native_mode == entry)
> +			disp->native_mode = disp->num_timings;
> +
> +		disp->timings[disp->num_timings] = dt;
> +		disp->num_timings++;
> +	}
> +	of_node_put(timings_np);
> +	of_node_put(native_mode);
> +
> +	if (disp->num_timings > 0)
> +		pr_info("%s: got %d timings. Using timing #%d as default\n", __func__,
> +			disp->num_timings , disp->native_mode + 1);
> +	else {
> +		pr_err("%s: no valid timings specified\n", __func__);
> +		display_timings_release(disp);
> +		return NULL;
> +	}
> +	return disp;
> +
> +timingfail:
> +	if (native_mode)
> +		of_node_put(native_mode);
> +	kfree(disp->timings);

Call display_timings_release(disp) instead of kfree(disp->timings)?

> diff --git a/include/linux/of_videomode.h b/include/linux/of_videomode.h
> new file mode 100644
> index 0000000..4138758
> --- /dev/null
> +++ b/include/linux/of_videomode.h
> @@ -0,0 +1,16 @@
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
> +int of_get_videomode(struct device_node *np, struct videomode *vm, int index);
> +#endif /* __LINUX_OF_VIDEOMODE_H */

Nit: should have a blank line before #endif.

Thierry

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo4ftAAoJEN0jrNd/PrOhNXgP/R1YEGtJlaF5M8tYBg8PMv5z
Y1IbzrrOvGHFWAPS6VVJn+/YdbNbTvKx+cI897SRmqY4rk4pyWmai8cjgAWL5zi2
aZ7nhWSyLDkKOixNl+SGA1VWuLy1vik4N45xy2UB3sEqZzoHjkFYqjzxh04LUsYR
sgmBzNo7aNKakRjUeNup0u2kNe/FtvVe4Hkg4n0j9drK8OPKlm00XjHtdBntYRhE
5n/wS2+J4dONLicTwVDcLCA1vko2W/NsWjggKLVlAb/HRyoV+qjqxp1Zoncdimak
wUSnPHKfpPBPo/wrELfU4R7js2S6ouOHdrKODAAzvVRTSvQn+AQ73WvZoM7GeBN7
WL0d2/nuU5flwocNGbIyEb2hcOz0kbTdOUedhcXFlRLbAsNco8/gg3lhJJT6VHRR
m4oR25htlw3eHTO47dWB52ljVM5P+ETnQW4HSKAaaK4N5PNNPK1uuGZzuAFLhEnP
5rc7ht5WP7+SfNESGJFknALp6HCtNv2JSMa+pzQTN73VabVQxZbcAghFTY9uiliN
2qsk7gOTmKizodyZWFQqNzXIWPglrXVkiZS/yLFFErRmDWHn3VNI8hBG8nvBkkcR
BNebxMbzrLkxIO/6+X7IiXEW9m+Za+o9TkvUobufnK1MHJXVh6p1nvkqC/fmYXOc
0MUTXck3jaMD9fLIfRiI
=XhZ/
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
