Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:59961 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbeKNUyh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 15:54:37 -0500
Date: Wed, 14 Nov 2018 11:51:52 +0100
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
Subject: Re: [PATCH v2 2/9] phy: Add configuration interface
Message-ID: <20181114105152.sgk454t34hmzstkn@flea>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
 <4d0506aa0a61d234610b42a268a8326d9ea18466.1541516029.git-series.maxime.ripard@bootlin.com>
 <3a9a28df-8139-1036-a884-0de64aa07df1@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="32jb3i42ot3gk2nm"
Content-Disposition: inline
In-Reply-To: <3a9a28df-8139-1036-a884-0de64aa07df1@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--32jb3i42ot3gk2nm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kishon

On Mon, Nov 12, 2018 at 03:32:25PM +0530, Kishon Vijay Abraham I wrote:
> On 06/11/18 8:24 PM, Maxime Ripard wrote:
> > The phy framework is only allowing to configure the power state of the =
PHY
> > using the init and power_on hooks, and their power_off and exit
> > counterparts.
> >=20
> > While it works for most, simple, PHYs supported so far, some more advan=
ced
> > PHYs need some configuration depending on runtime parameters. These PHYs
> > have been supported by a number of means already, often by using ad-hoc
> > drivers in their consumer drivers.
> >=20
> > That doesn't work too well however, when a consumer device needs to deal
> > with multiple PHYs, or when multiple consumers need to deal with the sa=
me
> > PHY (a DSI driver and a CSI driver for example).
> >=20
> > So we'll add a new interface, through two funtions, phy_validate and
> > phy_configure. The first one will allow to check that a current
> > configuration, for a given mode, is applicable. It will also allow the =
PHY
> > driver to tune the settings given as parameters as it sees fit.
> >=20
> > phy_configure will actually apply that configuration in the phy itself.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  drivers/phy/phy-core.c  | 61 +++++++++++++++++++++++++++++++++++++++++=
+-
> >  include/linux/phy/phy.h | 58 ++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 119 insertions(+)
> >=20
> > diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> > index 35fd38c5a4a1..7bd3ed65c708 100644
> > --- a/drivers/phy/phy-core.c
> > +++ b/drivers/phy/phy-core.c
> > @@ -408,6 +408,67 @@ int phy_calibrate(struct phy *phy)
> >  EXPORT_SYMBOL_GPL(phy_calibrate);
> > =20
> >  /**
> > + * phy_configure() - Changes the phy parameters
> > + * @phy: the phy returned by phy_get()
> > + * @opts: New configuration to apply
> > + *
> > + * Used to change the PHY parameters. phy_init() must have been called
> > + * on the phy. The configuration will be applied on the current phy
> > + * mode, that can be changed using phy_set_mode().
> > + *
> > + * Returns: 0 if successful, an negative error code otherwise
> > + */
> > +int phy_configure(struct phy *phy, union phy_configure_opts *opts)
> > +{
> > +	int ret;
> > +
> > +	if (!phy)
> > +		return -EINVAL;
> > +
> > +	if (!phy->ops->configure)
> > +		return -EOPNOTSUPP;
> > +
> > +	mutex_lock(&phy->mutex);
> > +	ret =3D phy->ops->configure(phy, opts);
> > +	mutex_unlock(&phy->mutex);
> > +
> > +	return ret;
> > +}
>=20
> EXPORT_SYMBOL_GPL is missing here and below.

Consider it done.

> > +
> > +/**
> > + * phy_validate() - Checks the phy parameters
> > + * @phy: the phy returned by phy_get()
> > + * @mode: phy_mode the configuration is applicable to.
> > + * @opts: Configuration to check
> > + *
> > + * Used to check that the current set of parameters can be handled by
> > + * the phy. Implementations are free to tune the parameters passed as
> > + * arguments if needed by some implementation detail or
> > + * constraints. It will not change any actual configuration of the
> > + * PHY, so calling it as many times as deemed fit will have no side
> > + * effect.
> > + *
> > + * Returns: 0 if successful, an negative error code otherwise
> > + */
> > +int phy_validate(struct phy *phy, enum phy_mode mode,
> > +		  union phy_configure_opts *opts)
>=20
> We are planning to switch to mode/submode combination [1], so this might =
have
> to change.

Yes, I'm aware of that. If needed, it shouldn't be too hard to rework.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--32jb3i42ot3gk2nm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW+v+SAAKCRDj7w1vZxhR
xd4KAQCgTxP0Iny1S4qIKFkd8A9D3wnv7pIQyNYHX9WZ3veABAD/dx5YKRWQmCSz
Jg6veFo/A77Cfj3GCfGHzvgtgD3I4gY=
=XbmS
-----END PGP SIGNATURE-----

--32jb3i42ot3gk2nm--
