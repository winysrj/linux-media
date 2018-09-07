Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:59925 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbeIGNr4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 09:47:56 -0400
Date: Fri, 7 Sep 2018 11:07:44 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
Subject: Re: [PATCH 02/10] phy: Add configuration interface
Message-ID: <20180907090744.5mkcw4odtu7iypbm@flea>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
 <8397722.XVQDA25ZU6@avalon>
 <20180906144807.pn753tgfyovvheil@flea>
 <2403687.Gdit31W5bd@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aamqqanzorijin73"
Content-Disposition: inline
In-Reply-To: <2403687.Gdit31W5bd@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--aamqqanzorijin73
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 06, 2018 at 07:51:05PM +0300, Laurent Pinchart wrote:
> On Thursday, 6 September 2018 17:48:07 EEST Maxime Ripard wrote:
> > On Wed, Sep 05, 2018 at 04:39:46PM +0300, Laurent Pinchart wrote:
> > > On Wednesday, 5 September 2018 12:16:33 EEST Maxime Ripard wrote:
> > >> The phy framework is only allowing to configure the power state of t=
he
> > >> PHY using the init and power_on hooks, and their power_off and exit
> > >> counterparts.
> > >>=20
> > >> While it works for most, simple, PHYs supported so far, some more
> > >> advanced PHYs need some configuration depending on runtime parameter=
s.
> > >> These PHYs have been supported by a number of means already, often by
> > >> using ad-hoc drivers in their consumer drivers.
> > >>=20
> > >> That doesn't work too well however, when a consumer device needs to =
deal
> > >=20
> > > s/deal/deal with/
> > >=20
> > >> multiple PHYs, or when multiple consumers need to deal with the same=
 PHY
> > >> (a DSI driver and a CSI driver for example).
> > >>=20
> > >> So we'll add a new interface, through two funtions, phy_validate and
> > >> phy_configure. The first one will allow to check that a current
> > >> configuration, for a given mode, is applicable. It will also allow t=
he
> > >> PHY driver to tune the settings given as parameters as it sees fit.
> > >>=20
> > >> phy_configure will actually apply that configuration in the phy itse=
lf.
> > >>=20
> > >> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > >> ---
> > >>=20
> > >>  drivers/phy/phy-core.c  | 62 ++++++++++++++++++++++++++++++++++++++=
+++-
> > >>  include/linux/phy/phy.h | 42 ++++++++++++++++++++++++++++-
> > >>  2 files changed, 104 insertions(+)
> > >>=20
> > >> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> > >> index 35fd38c5a4a1..6eaf655e370f 100644
> > >> --- a/drivers/phy/phy-core.c
> > >> +++ b/drivers/phy/phy-core.c
> > >> @@ -408,6 +408,68 @@ int phy_calibrate(struct phy *phy)
> > >>  EXPORT_SYMBOL_GPL(phy_calibrate);
> > >> =20
> > >>  /**
> > >> + * phy_configure() - Changes the phy parameters
> > >> + * @phy: the phy returned by phy_get()
> > >> + * @mode: phy_mode the configuration is applicable to.
> > >> + * @opts: New configuration to apply
> > >> + *
> > >> + * Used to change the PHY parameters. phy_init() must have
> > >> + * been called on the phy.
> > >> + *
> > >> + * Returns: 0 if successful, an negative error code otherwise
> > >> + */
> > >> +int phy_configure(struct phy *phy, enum phy_mode mode,
> > >> +		  union phy_configure_opts *opts)
> > >> +{
> > >> +	int ret;
> > >> +
> > >> +	if (!phy)
> > >> +		return -EINVAL;
> > >> +
> > >> +	if (!phy->ops->configure)
> > >> +		return 0;
> > >=20
> > > Shouldn't you report an error to the caller ? If a caller expects the=
 PHY
> > > to be configurable, I would assume that silently ignoring the request=
ed
> > > configuration won't work great.
> >=20
> > I'm not sure. I also expect a device having to interact with multiple
> > PHYs, some of them needing some configuration while some other do
> > not. In that scenario, returning 0 seems to be the right thing to do.
>=20
> It could be up to the caller to decide whether to ignore the error or not=
 when=20
> the operation isn't implemented. I expect that a call requiring specific=
=20
> configuration parameters for a given PHY might want to bail out if the=20
> configuration can't be applied. On the other hand that should never happe=
n=20
> when the system is designed correctly, as vendors are not supposed to shi=
p=20
> kernels that would be broken by design (as in requiring a configure opera=
tion=20
> but not providing it).

I'll do as Andrew (and you) suggested then.

> > >> @@ -60,6 +66,38 @@ struct phy_ops {
> > >>  	int	(*power_on)(struct phy *phy);
> > >>  	int	(*power_off)(struct phy *phy);
> > >>  	int	(*set_mode)(struct phy *phy, enum phy_mode mode);
> > >> +
> > >> +	/**
> > >> +	 * @configure:
> > >> +	 *
> > >> +	 * Optional.
> > >> +	 *
> > >> +	 * Used to change the PHY parameters. phy_init() must have
> > >> +	 * been called on the phy.
> > >> +	 *
> > >> +	 * Returns: 0 if successful, an negative error code otherwise
> > >> +	 */
> > >> +	int	(*configure)(struct phy *phy, enum phy_mode mode,
> > >> +			     union phy_configure_opts *opts);
> > >=20
> > > Is this function allowed to modify opts ? If so, to what extent ? If =
not,
> > > the pointer should be made const.
> >=20
> > That's a pretty good question. I guess it could modify it to the same
> > extent than validate could. Would that make sense?
>=20
> It would, or we could say that PHY users are required to call the validat=
e=20
> function first, and the the configure function will return an error if th=
e=20
> passed configuration isn't valid. That would avoid double-validation when=
 the=20
> PHY user uses .validate().

I usually prefer to have a function being able to check its input on
its own. Especially, the sole use case we have right now is DRM, and
DRM would typically call phy_validate X+1 times (X being the number of
modes), once for each mode in mode_valid and once in atomic_check.

> > >> +	/**
> > >> +	 * @validate:
> > >> +	 *
> > >> +	 * Optional.
> > >> +	 *
> > >> +	 * Used to check that the current set of parameters can be
> > >> +	 * handled by the phy. Implementations are free to tune the
> > >> +	 * parameters passed as arguments if needed by some
> > >> +	 * implementation detail or constraints. It must not change
> > >> +	 * any actual configuration of the PHY, so calling it as many
> > >> +	 * times as deemed fit by the consumer must have no side
> > >> +	 * effect.
> > >> +	 *
> > >> +	 * Returns: 0 if the configuration can be applied, an negative
> > >> +	 * error code otherwise
> > >=20
> > > When should this operation modify the passed parameters, and when sho=
uld
> > > it return an error ? I understand that your goal is to implement a
> > > negotiation mechanism for the PHY parameters, and to be really useful=
 I
> > > think we need to document it more precisely.
> >=20
> > My initial idea was to reject a configuration that wouldn't be
> > achievable by the PHY, ie you're asking something that is outside of
> > the operating boundaries, while you would be able to change settings
> > that would be operational, but sub-optimal.
>=20
> I'm fine with that, let's document it explicitly.

ACK.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--aamqqanzorijin73
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluSP98ACgkQ0rTAlCFN
r3Squg//X11u4l+Nts+h9ENgjjrqLmtUBSWEM3fTSep0c/HEZgDME5Cco5O8IiJ9
wiUAJL0A2FMgXsVfEDe0lfQ7kUh6lI3ADHajtmmCdx7r8Q14MQQAHVVb+BFjIqbs
pwGzjhgX+9K+8a94LvIFjCNg+0tauj0IB8XXi3DSHpcWLKz5M+eYTiy/kTUe8eIu
qbENL+/k8zOzxpzXxrHHoUDYhCB5sVCh1me+DX5P34rMy5tjzeLf7FHnJgYTyyNC
wEFbEpSGD2Xy52gTKHlaqjb0SbcDJLYWzzq7Vw3S4DgcIMggBv0KDT18Ggco0Vv9
whUfszicI5T5qtROCzqGV6ajiO/3GfTzoiN17d2q3obIrnmVUvpwm/WUm9TvawgE
hJLv11or1t8PSqSy3YDSf2lmPEsPWuLvtWixPDmzJdAIRWnGuIdn8KRuQpcbIqjz
0P1VxwOiy7w+LXLeZHImIwJgx+Mpj6Os/FDsFXT71wVDRRj6D30CF40azKsiAWkh
/FgF7DTFlEkYLj1ndLtHksk5XwGfdvj1pqvaOKfcC5ozocLTwV4JGcxJ3gyVghOd
UHNbcfZc7DiYY4Scoq95GV/lHPORrdPpJiPV5AZq+TckbqLwksc3Rml+oYZMjJkO
/BmbiOfQKxlXavbpB4MM4Zj2s4jcsljzqdbFNe9aEoBcG6GMEu0=
=sm0Q
-----END PGP SIGNATURE-----

--aamqqanzorijin73--
