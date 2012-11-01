Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992467Ab2KAUPQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2012 16:15:16 -0400
Date: Thu, 1 Nov 2012 21:15:10 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v7 2/8] of: add helper to parse display timings
Message-ID: <20121101201510.GB13137@avionic-0098.mockup.avionic-design.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
 <1351675689-26814-3-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
In-Reply-To: <1351675689-26814-3-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 31, 2012 at 10:28:02AM +0100, Steffen Trumtrar wrote:
[...]
> diff --git a/Documentation/devicetree/bindings/video/display-timings.txt b/Documentation/devicetree/bindings/video/display-timings.txt
[...]
> @@ -0,0 +1,139 @@
> +display-timings bindings
> +==================
> +
> +display-timings-node
> +------------

Maybe extend the underline to the length of the section and subsection
titles respectively?

> +struct display_timing
> +===================

Same here.

> +config OF_DISPLAY_TIMINGS
> +	def_bool y
> +	depends on DISPLAY_TIMING

Maybe this should be called OF_DISPLAY_TIMING to match DISPLAY_TIMING,
or rename DISPLAY_TIMING to DISPLAY_TIMINGS for the sake of consistency?

> +/**
> + * of_get_display_timing_list - parse all display_timing entries from a device_node
> + * @np: device_node with the subnodes
> + **/
> +struct display_timings *of_get_display_timing_list(struct device_node *np)

Perhaps this would better be named of_get_display_timings() to match the
return type?

> +	disp = kzalloc(sizeof(*disp), GFP_KERNEL);

Shouldn't you be checking this for allocation failures?

> +	disp->timings = kzalloc(sizeof(struct display_timing *)*disp->num_timings,
> +				GFP_KERNEL);

Same here.

Thierry

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQkthOAAoJEN0jrNd/PrOh5oQQAKMOCiP5VHl1/kmm6+vDnRYl
cLpDZftk5BNOTWtHtCBLZXZSvao+77Q33rTdsNBX+2R+5EIhE39DttNdGGnmIvuX
XLqSbeswInP+HrsPgLJAG85V0lwgJxE8MlLe9L2Gb2P1tcgeTdcMbNPAMQ6d5caI
fUS+b6oCg3yBqcHA93LQbKM7bhO3v5PoaQ4KVc/cK13+ohz/X+ekqm7e8EZG635T
SN1HkQPH9vwcxPRa0Tr1W2fyYQXeT+dY76tRCQkgWkAVXRtbroqVtSIc7lOpm9Ix
E9LXXs09zu0MGWzxXm1bzoBBqcIsu8KonImVwlQTyop2UJ5vmFjvSoPUm/20vyM4
xe3Mne4y7NDQeWaGNWm3F16C74+WDS+SJskrY3FJk3uKNVwp7eCBtAaFDJRc2vfC
767YAtBst6ZcS+CGoApywbJttZDqRwLvSMG3RXaectXoS4/32fZQDODCIAlnOy8E
RzKQ9BTwsZjLP0vn7NLmo45yw4Lglc55hCEIsiOcxNw4TypSWDNDH9z9g4l4estN
AyizcdnlQEkjv16Iv4npffmIp/soCFJdgBMb/60Z5fP9uiES2E/y5euWocOOmB5y
0dfNJ7NhL9lLoAm7yUWOtTm4yW592WLFPIinXKxQ2yRysGWNRLVwJSQ8Zg25C/OL
kGdy3JzMseTNog2fKV9e
=EPmH
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
