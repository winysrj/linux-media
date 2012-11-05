Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:50636 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab2KEJKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 04:10:24 -0500
Date: Mon, 5 Nov 2012 10:10:07 +0100
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
Subject: Re: [PATCH v7 8/8] drm_modes: add of_videomode helpers
Message-ID: <20121105091007.GB5847@avionic-0098.mockup.avionic-design.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
 <1351675689-26814-9-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <1351675689-26814-9-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 31, 2012 at 10:28:08AM +0100, Steffen Trumtrar wrote:
[...]
> +/**
> + * of_get_drm_display_mode - get a drm_display_mode from devicetree
> + * @np: device_node with the timing specification
> + * @dmode: will be set to the return value
> + * @index: index into the list of display timings in devicetree
> + *=20
> + * DESCRIPTION:

I don't think this is necessary.

> + * This function is expensive and should only be used, if only one mode =
is to be
> + * read from DT. To get multiple modes start with of_get_display_timing_=
list ond

You probably meant "and" at the end of this line. Also I'm not even sure
that we should be exposing this function, but rather provide a helper
which automatically adds the parsed modes to a DRM connector object.

Thierry

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQl4JvAAoJEN0jrNd/PrOhnLcP/2pY88TYGt1myWEkjdDL+819
d3Xc5e0Rex7nShtT2FRj7HIRdpFtsqApYOlzxwrojhf23BAOFpSxvwd5lDWL3Cus
kH3eStFlmAWNAyzxPanOuLLIZlrDIkyC1iY/1c8YkEpqEgdE9BlT7/437RUHdKRP
HC8E59K5sZYTintnE1/JzFB50IWXGs81egtGy7qe4nR/7vkj2K6Bl3WnHvNck8Uk
DYLxW0qYww5R0gimqrFX1hSzTS+wzjx87AxQRoqhnHe2WCHWgPnIrRqkP2raP/Wk
sqta0hO9JrFhGDkeFKo35UE02M7/ect7WrOzfI+1LImCtXRvv9ZymoHpPQUCvntm
fQwAgF8h8bJFI9J2FB7DmsuuAobBtX7M+etUqZnGcTVdfBXKrvuJsB9Qjhhm+AGF
A4Sku/9c9Nzc2kp0HUX0kyDXDhM36f9WfN++rnPbflpq6MeSitQ5MVAh5tWR9EiW
YrQ/b35STvdvLFMSzGiz7bYhi+8OS8MkzYLaf0p74m9JUnHtxhmcP8gkK3JMtVYf
RPSIZPR6ezGFCYYu0ZPBB0qWYaD9Lj4maR5hF9wrvJSXPqj+gCTEjxXAh/NB+2s+
ziq1ZIcr1mShfrwAb5WNkKxOGdkQ0X6ucBMVEtBFqrVZdw5gSRIDBb4DcIF+lo3U
PV6aG4auUgdRdKKoocaE
=DQBQ
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
