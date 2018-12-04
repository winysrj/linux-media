Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:39826 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726226AbeLDPtC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Dec 2018 10:49:02 -0500
Date: Tue, 4 Dec 2018 16:48:47 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
Subject: Re: [PATCH v2 4/9] phy: dphy: Add configuration helpers
Message-ID: <20181204154847.f2cclpxa6a7v2ffx@flea>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
 <4d44460c4ecbd47f4cbd9141c6bf2632b6c21e1e.1541516029.git-series.maxime.ripard@bootlin.com>
 <20181119134357.743nskpkqqfkrjux@valkosipuli.retiisi.org.uk>
 <20181121093353.p3gnj4ebel4h4ya4@flea>
 <01829f2e-871e-cdea-afab-0ae1360464a4@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5oliesnrm3ovw6vm"
Content-Disposition: inline
In-Reply-To: <01829f2e-871e-cdea-afab-0ae1360464a4@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5oliesnrm3ovw6vm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 04, 2018 at 11:28:37AM +0530, Kishon Vijay Abraham I wrote:
> Hi Maxime,
>=20
> On 21/11/18 3:03 PM, Maxime Ripard wrote:
> > Hi Sakari,
> >=20
> > Thanks for your review.
> >=20
> > On Mon, Nov 19, 2018 at 03:43:57PM +0200, Sakari Ailus wrote:
> >>> +/*
> >>> + * Minimum D-PHY timings based on MIPI D-PHY specification. Derived
> >>> + * from the valid ranges specified in Section 6.9, Table 14, Page 41
> >>> + * of the D-PHY specification (v2.1).
> >>
> >> I assume these values are compliant with the earlier spec releases.
> >=20
> > I have access to the versions 1.2 and 2.1 of the spec and as far as I
> > can tell, they match here. I can't really say for other releases, but
> > I wouldn't expect any changes (and it can always be adjusted later on
> > if needed).
> >=20
> >>> + */
> >>> +int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
> >>
> >> How about using the bus frequency instead of the pixel clock? Chances =
are
> >> that the caller already has that information, instead of calculating it
> >> here?
> >=20
> > I went for the pixel clock since it's something that all drivers will
> > have access too without any computation. The bus frequency can be
> > available as well in v4l2, but won't be in DRM, and that would require
> > for all drivers to duplicate that computation, which doesn't seem like
> > a good choice.
> >=20
> >>> +				     unsigned int bpp,
> >>> +				     unsigned int lanes,
> >>> +				     struct phy_configure_opts_mipi_dphy *cfg)
> >>> +{
> >>> +	unsigned long hs_clk_rate;
> >>> +	unsigned long ui;
> >>> +
> >>> +	if (!cfg)
> >>> +		return -EINVAL;
> >>> +
> >>> +	hs_clk_rate =3D pixel_clock * bpp / lanes;
> >>> +	ui =3D DIV_ROUND_UP(NSEC_PER_SEC, hs_clk_rate);
> >>
> >> Nanoseconds may not be precise enough for practical computations on th=
ese
> >> values. At 1 GHz, this ends up being precisely 1. At least Intel hardw=
are
> >> has some more precision, I presume others do, too. How about using
> >> picoseconds instead?
> >=20
> > Sounds like a good idea.
>=20
> Would you be fixing this? Or this can be a later patch?

I have fixed this locally, but I wanted to wait a bit for more
feedback. I can send a new version if you prefer.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--5oliesnrm3ovw6vm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXAah3wAKCRDj7w1vZxhR
xQ0DAQCq/Z7HwPgo9Em4i2reOkIJK2X0mOhO3ckssP8Qk+5gIwD/QWh2B62EiAp7
UcfddZ+Zj6+oKYSH+/U77jyhEjqyQA4=
=H7cv
-----END PGP SIGNATURE-----

--5oliesnrm3ovw6vm--
