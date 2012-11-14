Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:51846 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab2KNK7p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 05:59:45 -0500
Date: Wed, 14 Nov 2012 11:59:40 +0100
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
Subject: Re: [PATCH v8 2/6] video: add of helper for videomode
Message-ID: <20121114105940.GB31801@avionic-0098.mockup.avionic-design.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-3-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <1352734626-27412-3-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 12, 2012 at 04:37:02PM +0100, Steffen Trumtrar wrote:
[...]
> diff --git a/include/linux/of_display_timings.h b/include/linux/of_display_timings.h
[...]
> +#ifndef __LINUX_OF_DISPLAY_TIMINGS_H
> +#define __LINUX_OF_DISPLAY_TIMINGS_H
> +
> +#include <linux/display_timing.h>
> +
> +#define OF_USE_NATIVE_MODE -1
> +
> +struct display_timings *of_get_display_timings(struct device_node *np);
> +int of_display_timings_exists(struct device_node *np);

This either needs to include linux/of.h or a forward declaration of
struct device_node. Otherwise this will fail to compile if the file
where this is included from doesn't pull linux/of.h in explicitly.

> diff --git a/include/linux/of_videomode.h b/include/linux/of_videomode.h
[...]
> +#ifndef __LINUX_OF_VIDEOMODE_H
> +#define __LINUX_OF_VIDEOMODE_H
> +
> +#include <linux/videomode.h>
> +
> +int of_get_videomode(struct device_node *np, struct videomode *vm, int index);

Same here.

Thierry

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo3mcAAoJEN0jrNd/PrOhnCEP/jfAyewli0dTH1Wk4Av6dIxc
MClbwimHsgufRK4xJ5U7UAH0JB9x9uZ+CSW2s+1covSJ6vHNtBTvzsmn9WZjMO7P
cWVqLwRDc7Kdn3iNbG3dp87A/G7l98ZGP9JG8fm2zItMFhH6wuMK8Gq43sJjA9jj
JIaZ8MoD4JCTsKXYH/zdtXSxOdfJIK86z5mPGpAV++tbCLk8Y+aCy41mNbu9I/sz
gZPaT6n+FPSJi0CSIcGQeIlZHlaprWEy+oMPpCsjaNRF8GQ0PCxZBIavpW0ZPMfo
N5BMyU31jeK4KAPhRgOMyxH7xySgEgvx2lRjUGRAM4NmKMS4kLGVlXP/NJSpSW1/
spzTxY8p4Plrom9p6NOJj8v8l0fuqdqrA2ShBE48sBt0cYI2sIhj9SKA/3THjUac
eYXeCcTXcKg1yLixm7N4pAph7Wy5tS8LXfP3+vSkzIsC8yUWijbMwlsu0SZT7/sM
JqQzqf7w436VWKAd5tqtS9T3mAE9OJiZnJ4yOUWYNjwf7UVUNm8ZKnhHksmckQFk
JFG/uya+tinSHySbXZvmwCK3j1/ZJVEqJqKRUFTVpyTV150JhQzEDBNpUVKVJnYn
4rUj61D71+q5dEVXMLmxrmGShvbnZ3ce+o517wXxtyPivu41Sbr5i8sHd8OZp7+G
IzJpiANv+hegtxiP2cXi
=Fyuk
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
