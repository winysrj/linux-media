Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:47598 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731254AbeISRwS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 13:52:18 -0400
Date: Wed, 19 Sep 2018 14:14:36 +0200
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
Subject: Re: [PATCH 02/10] phy: Add configuration interface
Message-ID: <20180919121436.ztjnxofe66quddeq@flea>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
 <a739a2d623c3e60373a73e1ec206c2aa35c4a742.1536138624.git-series.maxime.ripard@bootlin.com>
 <1ed01c1f-76d5-fa96-572b-9bfd269ad11b@ti.com>
 <20180906145622.kwxvkcuerbeqsj6b@flea>
 <1a169fad-72b7-fac0-1254-cac5d8304740@ti.com>
 <20180912084242.skxbwbgluakakyg6@flea>
 <e0d7db11-7ec1-cb98-4e62-12d78d1ba65b@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uyfantarlu64mp2r"
Content-Disposition: inline
In-Reply-To: <e0d7db11-7ec1-cb98-4e62-12d78d1ba65b@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--uyfantarlu64mp2r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 14, 2018 at 02:18:37PM +0530, Kishon Vijay Abraham I wrote:
> >>>>> +/**
> >>>>> + * phy_validate() - Checks the phy parameters
> >>>>> + * @phy: the phy returned by phy_get()
> >>>>> + * @mode: phy_mode the configuration is applicable to.
> >>>>> + * @opts: Configuration to check
> >>>>> + *
> >>>>> + * Used to check that the current set of parameters can be handled=
 by
> >>>>> + * the phy. Implementations are free to tune the parameters passed=
 as
> >>>>> + * arguments if needed by some implementation detail or
> >>>>> + * constraints. It will not change any actual configuration of the
> >>>>> + * PHY, so calling it as many times as deemed fit will have no side
> >>>>> + * effect.
> >>>>> + *
> >>>>> + * Returns: 0 if successful, an negative error code otherwise
> >>>>> + */
> >>>>> +int phy_validate(struct phy *phy, enum phy_mode mode,
> >>>>> +		  union phy_configure_opts *opts)
> >>>>
> >>>> IIUC the consumer driver will pass configuration options (or PHY par=
ameters)
> >>>> which will be validated by the PHY driver and in some cases the PHY =
driver can
> >>>> modify the configuration options? And these modified configuration o=
ptions will
> >>>> again be given to phy_configure?
> >>>>
> >>>> Looks like it's a round about way of doing the same thing.
> >>>
> >>> Not really. The validate callback allows to check whether a particular
> >>> configuration would work, and try to negotiate a set of configurations
> >>> that both the consumer and the PHY could work with.
> >>
> >> Maybe the PHY should provide the list of supported features to the con=
sumer
> >> driver and the consumer should select a supported feature?
> >=20
> > It's not really about the features it supports, but the boundaries it
> > might have on those features. For example, the same phy integrated in
> > two different SoCs will probably have some limit on the clock rate it
> > can output because of the phy design itself, but also because of the
> > clock that is fed into that phy, and that will be different from one
> > SoC to the other.
> >=20
> > This integration will prevent us to use some clock rates on the first
> > SoC, while the second one would be totally fine with it.
>=20
> If there's a clock that is fed to the PHY from the consumer, then the con=
sumer
> driver should model a clock provider and the PHY can get a reference to it
> using clk_get(). Rockchip and Arasan eMMC PHYs has already used something=
 like
> that.

That would be doable, but no current driver has had this in their
binding. So that would prevent any further rework, and make that whole
series moot. And while I could live without the Allwinner part, the
Cadence one is really needed.

> Assuming the PHY can get a reference to the clock provided by the consume=
r,
> what are the parameters we'll be able to get rid of in struct
> phy_configure_opts_mipi_dphy?

hs_clock_rate and lp_clock_rate. All the other ones are needed.

> I'm sorry but I'm not convinced a consumer driver should have all the det=
ails
> that are added in phy_configure_opts_mipi_dphy.

If it can convince you, here is the parameters that are needed by all
the MIPI-DSI drivers currently in Linux to configure their PHY:

  - cdns-dsi (drivers/gpu/drm/bridge/cdns-dsi.c)
    - hs_clk_rate
    - lanes
    - videomode

  - kirin (drivers/gpu/drm/hisilicon/kirin/dw_drm_dsi.c)
    - hs_exit
    - hs_prepare
    - hs_trail
    - hs_zero
    - lpx
    - ta_get
    - ta_go
    - wakeup

  - msm (drivers/gpu/drm/msm/dsi/*)
    - clk_post
    - clk_pre
    - clk_prepare
    - clk_trail
    - clk_zero
    - hs_clk_rate
    - hs_exit
    - hs_prepare
    - hs_trail
    - hs_zero
    - lp_clk_rate
    - ta_get
    - ta_go
    - ta_sure

  - mtk (drivers/gpu/drm/mediatek/mtk_dsi.c)
    - hs_clk_rate
    - hs_exit
    - hs_prepare
    - hs_trail
    - hs_zero
    - lpx

  - sun4i (drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c)
    - clk_post
    - clk_pre
    - clk_prepare
    - clk_zero
    - hs_prepare
    - hs_trail
    - lanes
    - lp_clk_rate

  - tegra (drivers/gpu/drm/tegra/dsi.c)
    - clk_post
    - clk_pre
    - clk_prepare
    - clk_trail
    - clk_zero
    - hs_exit
    - hs_prepare
    - hs_trail
    - hs_zero
    - lpx
    - ta_get
    - ta_go
    - ta_sure

  - vc4 (drivers/gpu/drm/vc4/vc4_dsi.c)
    - hs_clk_rate
    - lanes

Now, for MIPI-CSI receivers:

  - marvell-ccic (drivers/media/platform/marvell-ccic/mcam-core.c)
    - clk_term_en
    - clk_settle
    - d_term_en
    - hs_settle
    - lp_clk_rate

  - omap4iss (drivers/staging/media/omap4iss/iss_csiphy.c)
    - clk_miss
    - clk_settle
    - clk_term
    - hs_settle
    - hs_term
    - lanes

  - rcar-vin (drivers/media/platform/rcar-vin/rcar-csi2.c)
    - hs_clk_rate
    - lanes

  - ti-vpe (drivers/media/platform/ti-vpe/cal.c)
    - clk_term_en
    - d_term_en
    - hs_settle
    - hs_term

So the timings expressed in the structure are the set of all the ones
currently used in the tree by DSI and CSI drivers. I would consider
that a good proof that it would be useful.

Note that at least cdns-dsi, exynos4-is
(drivers/media/platform/exynos4-is/mipi-csis.c), kirin, sun4i, msm,
mtk, omap4iss, plus the v4l2 drivers cdns-csi2tx and cdns-csi2rx I
want to convert, have already either a driver for their DPHY using the
phy framework plus a configuration function, or a design very similar
that could be migrated to such an API.

> > Obviously, the consumer driver shouldn't care about the phy
> > integration details, especially since some of those consumer drivers
> > need to interact with multiple phy designs (or the same phy design can
> > be used by multiple consumers).
> >=20
> > So knowing that a feature is supported is really not enough.
> >=20
> > With MIPI-DPHY at least, the API is generic enough so that another
> > mode where the features would make sense could implement a feature
> > flag if that makes sense.
> >=20
> >>> For example, DRM requires this to filter out display modes (ie,
> >>> resolutions) that wouldn't be achievable by the PHY so that it's never
> >>
> >> Can't the consumer driver just tell the required resolution to the PHY=
 and PHY
> >> figuring out all the parameters for the resolution or an error if that
> >> resolution cannot be supported?
> >=20
> > Not really either. With MIPI D-PHY, the phy is fed a clock that is
> > generated by the phy consumer, which might or might not be an exact
> > fit for the resolution. There's so many resolutions that in most case,
> > the clock factors don't allow you to have a perfect match. And
> > obviously, this imprecision should be taken into account by the PHY as
> > well.
> >=20
> > And then, there's also the matter than due to design constraints, some
> > consumers would have fixed timings that are not at the spec default
> > value, but still within the acceptable range. We need to communicate
> > that to the PHY.
>=20
> Here do you mean videomode timings?

No, I mean the DPHY timings.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--uyfantarlu64mp2r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluiPZYACgkQ0rTAlCFN
r3SSgg//TgIXKMj3aorpQVeNrCShzijBM07J3jlnP0D+H78n4mCHqQGUHsnmLc3J
yD+13reP2LsO0vEw0FjBkLMgqR97WKJ3x/1DCSuz68F0m14o6fYtT1VoNEnxb0QZ
8RKCMRP6SbXArjRjOh4eNMlUexwF5uB5QJuFtEuvAGt3S5gEJPUQogChNL1jifCX
zY2xN/hrD6sqnna2YhUTQstf2Z/n4KAcac45zxLLeQI5BkujALHK63rJPtkEDn62
EOSLCgTCL+jZDd4GZuKyjcCwEy2tGRkRGd3HXg23YXASh0lTd3aWCsR/qi1RlVeF
U1lfR8l7DL/pf/kncWcSPQzGKMy84JpBJy7l22W8e/ER9YqoVgSW5WmSTRY2zYYJ
dH37Wpnf/Do+qItT/8qYFkHTJvcbvxf4ix3SL42Y8Bp3MLNXxZ79uDioXupuvHj4
vOEdYmZqaxf4J+cQdIFx64JrnSIPJGylqe626UzYKPQkKg6SaqXzZ0i2pFufcggY
6XhsMIf2cc7hxpzqdlOtUcunkgIY6pjn3HHYe2JFZ9iCFfzn3m6CGttr8pgrh6bH
VRgN6CrYVlZ93e8lgVPU3V3NeMS84dgvfYCPAWI8N1FFoa29Llt9kIfBaIdPvzFt
deLe7pa/q5hqAVCXRqKPh+OYJiKW4K91A9GTfENq3NC6Ap9f/A8=
=T9T3
-----END PGP SIGNATURE-----

--uyfantarlu64mp2r--
