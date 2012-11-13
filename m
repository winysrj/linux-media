Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:65302 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2KMLJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 06:09:08 -0500
Date: Tue, 13 Nov 2012 12:08:37 +0100
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
Message-ID: <20121113110837.GA30049@avionic-0098.mockup.avionic-design.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-3-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <1352734626-27412-3-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 12, 2012 at 04:37:02PM +0100, Steffen Trumtrar wrote:
> This adds support for reading display timings from DT or/and convert one =
of those
> timings to a videomode.
> The of_display_timing implementation supports multiple children where each
> property can have up to 3 values. All children are read into an array, th=
at
> can be queried.
> of_get_videomode converts exactly one of that timings to a struct videomo=
de.
>=20
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  .../devicetree/bindings/video/display-timings.txt  |  107 +++++++++++
>  drivers/video/Kconfig                              |   13 ++
>  drivers/video/Makefile                             |    2 +
>  drivers/video/of_display_timing.c                  |  186 ++++++++++++++=
++++++
>  drivers/video/of_videomode.c                       |   47 +++++
>  include/linux/of_display_timings.h                 |   19 ++
>  include/linux/of_videomode.h                       |   15 ++
>  7 files changed, 389 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/display-timin=
gs.txt
>  create mode 100644 drivers/video/of_display_timing.c
>  create mode 100644 drivers/video/of_videomode.c
>  create mode 100644 include/linux/of_display_timings.h
>  create mode 100644 include/linux/of_videomode.h
>=20
> diff --git a/Documentation/devicetree/bindings/video/display-timings.txt =
b/Documentation/devicetree/bindings/video/display-timings.txt
> new file mode 100644
> index 0000000..e22e2fd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/display-timings.txt
> @@ -0,0 +1,107 @@
> +display-timings bindings
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +display-timings-node
> +--------------------

Maybe leave away the last -, so that it reads "display-timings node"? I
think that makes it more obvious that the node is supposed to be called
"display-timings".

> +
> +required properties:
> + - none
> +
> +optional properties:
> + - native-mode: the native mode for the display, in case multiple modes =
are
> +		provided. When omitted, assume the first node is the native.
> +
> +timings-subnode
> +---------------

Same here: "timing subnodes"?

> +
> +required properties:
> + - hactive, vactive: Display resolution
> + - hfront-porch, hback-porch, hsync-len: Horizontal Display timing param=
eters

"display"?

> +   in pixels
> +   vfront-porch, vback-porch, vsync-len: Vertical display timing paramet=
ers in
> +   lines
> + - clock-frequency: displayclock in Hz

"display clock"?

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

Nitpick: You use space before : in the optional properties, but not in
the required properties above.

> +
> +There are different ways of describing the capabilities of a display. Th=
e devicetree
> +representation corresponds to the one commonly found in datasheets for d=
isplays.
> +If a display supports multiple signal timings, the native-mode can be sp=
ecified.
> +
> +The parameters are defined as
> +
> +struct display_timing
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

struct display_timing has no meaning in device tree documentation. Maybe
this line can just go away?

> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 2a23b18..a324457 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -39,6 +39,19 @@ config DISPLAY_TIMING
>  config VIDEOMODE
>         bool
> =20
> +config OF_DISPLAY_TIMING

OF_DISPLAY_TIMINGS?

> diff --git a/drivers/video/of_display_timing.c b/drivers/video/of_display=
_timing.c

of_display_timings.c?

> +/**
> + * of_get_display_timings - parse all display_timing entries from a devi=
ce_node
> + * @np: device_node with the subnodes
> + **/
> +struct display_timings *of_get_display_timings(struct device_node *np)
[...]
> +	for_each_child_of_node(timings_np, entry) {
> +		struct display_timing *dt;
> +
> +		dt =3D of_get_display_timing(entry);
> +		if (!dt) {
> +			/* to not encourage wrong devicetrees, fail in case of an error */
> +			pr_err("%s: error in timing %d\n", __func__, disp->num_timings+1);
> +			return NULL;
> +		}

In case of a parsing error, of_get_display_timing() already shows an
error message, so I don't think we need another one here.

> +/**
> + * of_display_timings_exists - check if a display-timings node is provid=
ed
> + * @np: device_node with the timing
> + **/
> +int of_display_timings_exists(struct device_node *np)
> +{
> +	struct device_node *timings_np;
> +
> +	if (!np)
> +		return -EINVAL;
> +
> +	timings_np =3D of_parse_phandle(np, "display-timings", 0);
> +	if (!timings_np)
> +		return -EINVAL;
> +
> +	return 1;

I think this is missing of_node_put(timings_np) in both failure and
success cases. Also, maybe this should really return a bool instead?

Also, why do you use of_parse_phandle() for this? Aren't the
display-timings nodes expected to be children of some other node like an
output/display device?

> diff --git a/include/linux/of_videomode.h b/include/linux/of_videomode.h
[...]
> +
> +int of_get_videomode(struct device_node *np, struct videomode *vm, int i=
ndex);
> +#endif /* __LINUX_OF_VIDEOMODE_H */

There should be a blank line between the last two lines I think.

Thierry

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQoio1AAoJEN0jrNd/PrOhBXIQAKv+R2gftKy4N5jh0pgRPrGm
PqVn7rorCefHW4InCF1yvq44uVtjmeNbmjfBP2CEEOrJcbq5XUdiqs+ZuVPobTsM
RYfto9LaM2VUj7qCkJsg9YTHwLQ1FTAkbwpf3FAOmklhAalIMBGGy86QeTuNQoSK
CYdZr+ZXas2Svm5136hHXCr0Oel/IOD74GhLzy8DD8tT4oT7v/syhZ3v74P+pxcD
uNWstALYlsD222R67SPGv52HXTCzYVBeDVk1kbHMpalVaOIMwnAkI802i/fF/Iip
d3uyyAJ28HoAgP9+zoFsHbgyZ3GhiuS5NyPwIzzgXtPwt4Gg9ta2DsieY67Ol60q
yn0SW5wmwI3MDn5rxhqunl//+RU+An5pDLcQUvzAekuOGwxRtFHTYh64lVw4uMD6
Ht0rsi3ehhh2fjRsYGqq0iS4x1b3eGeiH6ZwxE0kMejBaGf7KceJCmDjfsElV5w5
n5+pvcvMdr1g6/ApVSDk3ftaNTM9CPwbJ8AkCwtxOVayFqdXoa6jxy9KEts/Id+/
KDICAcNdttmUA8YrJVQZ/EQXt2ol4kpSPToXBk5lN/Gdeh2e2Sv800v1veZto4S5
1AT7kdTjZB12TiSEx00tFwu/vL1RgYKxSMY2TQ7YJN4ISWXK53bERU5oX2xylwPR
F7wbtKydAageCg1jUBgk
=RCqb
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
