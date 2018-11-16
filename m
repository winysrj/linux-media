Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:39567 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbeKPT3D (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 14:29:03 -0500
Date: Fri, 16 Nov 2018 10:17:24 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Boris Brezillon <boris.brezillon@bootlin.com>,
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
Subject: Re: [PATCH v2 8/9] phy: Add Cadence D-PHY support
Message-ID: <20181116091724.4wwdrgn5hfcdao6b@flea>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
 <4ec9e47fb5aa9794f69a8e75a04108055094c056.1541516029.git-series.maxime.ripard@bootlin.com>
 <5f5bcc06-51b2-d565-56a0-083c66c1f01a@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uc64lachslxgmbyo"
Content-Disposition: inline
In-Reply-To: <5f5bcc06-51b2-d565-56a0-083c66c1f01a@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--uc64lachslxgmbyo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Mon, Nov 12, 2018 at 03:21:56PM +0530, Kishon Vijay Abraham I wrote:
> > +static int cdns_dphy_validate(struct phy *phy, enum phy_mode mode,
> > +			      union phy_configure_opts *opts)
> > +{
> > +	struct cdns_dphy_cfg cfg =3D { 0 };
> > +
> > +	if (mode !=3D PHY_MODE_MIPI_DPHY)
> > +		return -EINVAL;
> > +
> > +	return cdns_dphy_config_from_opts(phy, &opts->mipi_dphy, &cfg);
> > +}
> > +
> > +static int cdns_dphy_configure(struct phy *phy, union phy_configure_op=
ts *opts)
> > +{
> > +	struct cdns_dphy *dphy =3D phy_get_drvdata(phy);
> > +	struct cdns_dphy_cfg cfg =3D { 0 };
> > +	int ret;
> > +
> > +	ret =3D cdns_dphy_config_from_opts(phy, &opts->mipi_dphy, &cfg);
> > +	if (ret)
> > +		return ret;
>=20
> Can you explain why you need the same function to be invoked from both va=
lidate
> and configure callback? I see this to be redundant.

Sure.

Validate and configure serve two rather different purposes. validate
is here to make sure that a configuration can work with the PHY, and
to let the phy adjust the configuration to find a more optimal one.

configure, on the other hand, apply a configuration. We still have to
make sure that the configuration can work, since:
  - We might have called validate any number of times, with any number
    of configurations before calling configure, so we don't know which
    configuration we validate is actually going to be applied later on
    (if it's even applied)
  - If we don't care about the validation at all, we might just call
    configure directly

Does that make sense?

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--uc64lachslxgmbyo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW+6LJAAKCRDj7w1vZxhR
xSWBAQCmgYOEv+SL77dNspKxnISB6Gso1LtX5HPhFyi7cRTEpAD/R7o4MVLw3hB1
QlJ4skrsaZk6gX3M2UEfNBPPc+bZZAE=
=vaZn
-----END PGP SIGNATURE-----

--uc64lachslxgmbyo--
