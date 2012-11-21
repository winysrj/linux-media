Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:39732 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab2KUMWz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 07:22:55 -0500
Message-ID: <50ACC781.7010502@ti.com>
Date: Wed, 21 Nov 2012 14:22:25 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <devicetree-discuss@lists.ozlabs.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robherring2@gmail.com>,
	<linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	<kernel@pengutronix.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12 2/6] video: add of helper for videomode
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de> <1353426896-6045-3-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1353426896-6045-3-git-send-email-s.trumtrar@pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig12E9ABBEA5C99874EEA541A7"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enig12E9ABBEA5C99874EEA541A7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2012-11-20 17:54, Steffen Trumtrar wrote:

> +timings subnode
> +---------------
> +
> +required properties:
> + - hactive, vactive: Display resolution
> + - hfront-porch, hback-porch, hsync-len: Horizontal Display timing par=
ameters
> +   in pixels
> +   vfront-porch, vback-porch, vsync-len: Vertical display timing param=
eters in
> +   lines
> + - clock-frequency: display clock in Hz
> +
> +optional properties:
> + - hsync-active: Hsync pulse is active low/high/ignored
> + - vsync-active: Vsync pulse is active low/high/ignored
> + - de-active: Data-Enable pulse is active low/high/ignored
> + - pixelclk-inverted: pixelclock is inverted/non-inverted/ignored

Inverted related to what? And isn't this a bool? Pixel clock is either
normal (whatever that is), or inverted. It can't be "not used".

I guess normal case is "pixel data is driven on the rising edge of pixel
clock"? If that's common knowledge, I guess it doesn't need to be
mentioned. But I always have to verify from the documentation what
"normal" means on this particular panel/soc =3D).

> + - interlaced (bool)
> + - doublescan (bool)
> +
> +All the optional properties that are not bool follow the following log=
ic:
> +    <1>: high active
> +    <0>: low active
> +    omitted: not used on hardware

Perhaps it's obvious, but no harm being explicit: mention that the bool
properties are off is omitted.

And I didn't read the rest of the patches yet, so perhaps this is
already correct, but as I think this framework is usable without DT
also, the meanings of the fields in the structs should be explained in
the header files also in case they are not obvious.

> +Example:
> +
> +	display-timings {
> +		native-mode =3D <&timing0>;
> +		timing0: 1920p24 {

This should still be 1080p24, not 1920p24 =3D).

> +			/* 1920x1080p24 */
> +			clock-frequency =3D <52000000>;
> +			hactive =3D <1920>;
> +			vactive =3D <1080>;
> +			hfront-porch =3D <25>;
> +			hback-porch =3D <25>;
> +			hsync-len =3D <25>;
> +			vback-porch =3D <2>;
> +			vfront-porch =3D <2>;
> +			vsync-len =3D <2>;
> +			hsync-active =3D <1>;
> +		};
> +	};
> +

> diff --git a/include/linux/of_display_timings.h b/include/linux/of_disp=
lay_timings.h
> new file mode 100644
> index 0000000..2b4fa0a
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

No need to include these, just add "struct ...;".

> +#define OF_USE_NATIVE_MODE -1
> +
> +struct display_timings *of_get_display_timings(const struct device_nod=
e *np);
> +int of_display_timings_exists(const struct device_node *np);
> +
> +#endif
> diff --git a/include/linux/of_videomode.h b/include/linux/of_videomode.=
h
> new file mode 100644
> index 0000000..4de5fcc
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

Same here.

> +int of_get_videomode(const struct device_node *np, struct videomode *v=
m,
> +		     int index);
> +
> +#endif /* __LINUX_OF_VIDEOMODE_H */
>=20

 Tomi



--------------enig12E9ABBEA5C99874EEA541A7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQrMeBAAoJEPo9qoy8lh71i+QQAJf9vz9dhW7LwdL8cNrrLG/J
fzKj70w79KPvu7c48IqFi2YlanB/WDhpdgJzoGXNADzvzd2iHgks3T6FQ2Q10ebg
PWFtSK+KqxaYQZzX98hjaMQgrx2zuFYC/TANa5WSLJ+0SsCqwVgKmXxCbPkYMGuY
LGwKTZmbg/Bc/kOxR50OKURPJOpk8UrfixbRrGOhhJV9kkG/AFnsDcAWrSkam6he
zwBPmdOfBPe/y/0xAkaY39tvPefop/rIQnRopQEymRCPS6jDdVN6vEPmJjAJfKww
VHG8X9CSIvuvnm08eXKKLZJUOSnxdnsymQ0JPeBUoGK7WwkaBkTCBtb2CTwa3m+l
MPQV4KI3AFaBdX0lqQdZZbfr2lAmFEswBAphSTACDS/FGjo4w3d0YfiI9+BedSQc
PNVqUhZKo5bC6ygPU+ojYqTFaZpdgeFQX+EwLHxBKO3aGhXzA4LC0dxB9DsgMi4G
eKaZphvN7fOEJ1sIcCUjLUcYfb17WNawnW6Iq7e7USErG7xt84jOBcF1tT/JbUI3
cvhqTjmTUZQ6FNHy7FvyMlsoewZGfbZ5qbyofzzKON8S3iwfoliWJ+6TO3B8BRCl
Hg/QUhPn0aa1OBafi5mJbyj3baw66+8hIkNF4w2OFStPwwH1Usc+lZSGHoQd602s
M+TrueDNuXOhiMVBtmfs
=ERtZ
-----END PGP SIGNATURE-----

--------------enig12E9ABBEA5C99874EEA541A7--
