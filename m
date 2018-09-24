Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:58408 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725982AbeIXP4C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 11:56:02 -0400
Date: Mon, 24 Sep 2018 11:54:35 +0200
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
Message-ID: <20180924095435.77hh7lrpq7wkss2o@flea>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
 <a739a2d623c3e60373a73e1ec206c2aa35c4a742.1536138624.git-series.maxime.ripard@bootlin.com>
 <1ed01c1f-76d5-fa96-572b-9bfd269ad11b@ti.com>
 <20180906145622.kwxvkcuerbeqsj6b@flea>
 <1a169fad-72b7-fac0-1254-cac5d8304740@ti.com>
 <20180912084242.skxbwbgluakakyg6@flea>
 <e0d7db11-7ec1-cb98-4e62-12d78d1ba65b@ti.com>
 <20180919121436.ztjnxofe66quddeq@flea>
 <93088385-126b-6bfb-70e4-16f7b949d299@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4pbg56coqo4uhuid"
Content-Disposition: inline
In-Reply-To: <93088385-126b-6bfb-70e4-16f7b949d299@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4pbg56coqo4uhuid
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 24, 2018 at 02:18:35PM +0530, Kishon Vijay Abraham I wrote:
> On Wednesday 19 September 2018 05:44 PM, Maxime Ripard wrote:
> > Hi,
> >=20
> > On Fri, Sep 14, 2018 at 02:18:37PM +0530, Kishon Vijay Abraham I wrote:
> >>>>>>> +/**
> >>>>>>> + * phy_validate() - Checks the phy parameters
> >>>>>>> + * @phy: the phy returned by phy_get()
> >>>>>>> + * @mode: phy_mode the configuration is applicable to.
> >>>>>>> + * @opts: Configuration to check
> >>>>>>> + *
> >>>>>>> + * Used to check that the current set of parameters can be handl=
ed by
> >>>>>>> + * the phy. Implementations are free to tune the parameters pass=
ed as
> >>>>>>> + * arguments if needed by some implementation detail or
> >>>>>>> + * constraints. It will not change any actual configuration of t=
he
> >>>>>>> + * PHY, so calling it as many times as deemed fit will have no s=
ide
> >>>>>>> + * effect.
> >>>>>>> + *
> >>>>>>> + * Returns: 0 if successful, an negative error code otherwise
> >>>>>>> + */
> >>>>>>> +int phy_validate(struct phy *phy, enum phy_mode mode,
> >>>>>>> +		  union phy_configure_opts *opts)
> >>>>>>
> >>>>>> IIUC the consumer driver will pass configuration options (or PHY p=
arameters)
> >>>>>> which will be validated by the PHY driver and in some cases the PH=
Y driver can
> >>>>>> modify the configuration options? And these modified configuration=
 options will
> >>>>>> again be given to phy_configure?
> >>>>>>
> >>>>>> Looks like it's a round about way of doing the same thing.
> >>>>>
> >>>>> Not really. The validate callback allows to check whether a particu=
lar
> >>>>> configuration would work, and try to negotiate a set of configurati=
ons
> >>>>> that both the consumer and the PHY could work with.
> >>>>
> >>>> Maybe the PHY should provide the list of supported features to the c=
onsumer
> >>>> driver and the consumer should select a supported feature?
> >>>
> >>> It's not really about the features it supports, but the boundaries it
> >>> might have on those features. For example, the same phy integrated in
> >>> two different SoCs will probably have some limit on the clock rate it
> >>> can output because of the phy design itself, but also because of the
> >>> clock that is fed into that phy, and that will be different from one
> >>> SoC to the other.
> >>>
> >>> This integration will prevent us to use some clock rates on the first
> >>> SoC, while the second one would be totally fine with it.
> >>
> >> If there's a clock that is fed to the PHY from the consumer, then the =
consumer
> >> driver should model a clock provider and the PHY can get a reference t=
o it
> >> using clk_get(). Rockchip and Arasan eMMC PHYs has already used someth=
ing like
> >> that.
> >=20
> > That would be doable, but no current driver has had this in their
> > binding. So that would prevent any further rework, and make that whole
> > series moot. And while I could live without the Allwinner part, the
> > Cadence one is really needed.
>=20
> We could add a binding and modify the driver to to register a clock provi=
der.
> That could be included in this series itself.

That wouldn't work for device whose bindings need to remain backward
compatible. And the Allwinner part at least is in that case.

I think we should aim at making it a norm for newer bindings, but we
still have to support the old ones that cannot be changed.

> >> Assuming the PHY can get a reference to the clock provided by the cons=
umer,
> >> what are the parameters we'll be able to get rid of in struct
> >> phy_configure_opts_mipi_dphy?
> >=20
> > hs_clock_rate and lp_clock_rate. All the other ones are needed.
>=20
> For a start we could use that and get rid of hs_clock_rate and lp_clock_r=
ate in
> phy_configure_opts_mipi_dphy.

As I was saying above, I'm not sure we can do that.

> We could also use phy_set_bus_width() for lanes.

I overlooked this function somehow, it indeed looks like we can remove
the lanes part in favor of this function.

> >=20
> >> I'm sorry but I'm not convinced a consumer driver should have all the =
details
> >> that are added in phy_configure_opts_mipi_dphy.
> >=20
> > If it can convince you, here is the parameters that are needed by all
> > the MIPI-DSI drivers currently in Linux to configure their PHY:
> >=20
> >   - cdns-dsi (drivers/gpu/drm/bridge/cdns-dsi.c)
> >     - hs_clk_rate
> >     - lanes
> >     - videomode
> >=20
> >   - kirin (drivers/gpu/drm/hisilicon/kirin/dw_drm_dsi.c)
> >     - hs_exit
> >     - hs_prepare
> >     - hs_trail
> >     - hs_zero
> >     - lpx
> >     - ta_get
> >     - ta_go
> >     - wakeup
> >=20
> >   - msm (drivers/gpu/drm/msm/dsi/*)
> >     - clk_post
> >     - clk_pre
> >     - clk_prepare
> >     - clk_trail
> >     - clk_zero
> >     - hs_clk_rate
> >     - hs_exit
> >     - hs_prepare
> >     - hs_trail
> >     - hs_zero
> >     - lp_clk_rate
> >     - ta_get
> >     - ta_go
> >     - ta_sure
> >=20
> >   - mtk (drivers/gpu/drm/mediatek/mtk_dsi.c)
> >     - hs_clk_rate
> >     - hs_exit
> >     - hs_prepare
> >     - hs_trail
> >     - hs_zero
> >     - lpx
> >=20
> >   - sun4i (drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c)
> >     - clk_post
> >     - clk_pre
> >     - clk_prepare
> >     - clk_zero
> >     - hs_prepare
> >     - hs_trail
> >     - lanes
> >     - lp_clk_rate
> >=20
> >   - tegra (drivers/gpu/drm/tegra/dsi.c)
> >     - clk_post
> >     - clk_pre
> >     - clk_prepare
> >     - clk_trail
> >     - clk_zero
> >     - hs_exit
> >     - hs_prepare
> >     - hs_trail
> >     - hs_zero
> >     - lpx
> >     - ta_get
> >     - ta_go
> >     - ta_sure
> >=20
> >   - vc4 (drivers/gpu/drm/vc4/vc4_dsi.c)
> >     - hs_clk_rate
> >     - lanes
> >=20
> > Now, for MIPI-CSI receivers:
> >=20
> >   - marvell-ccic (drivers/media/platform/marvell-ccic/mcam-core.c)
> >     - clk_term_en
> >     - clk_settle
> >     - d_term_en
> >     - hs_settle
> >     - lp_clk_rate
> >=20
> >   - omap4iss (drivers/staging/media/omap4iss/iss_csiphy.c)
> >     - clk_miss
> >     - clk_settle
> >     - clk_term
> >     - hs_settle
> >     - hs_term
> >     - lanes
> >=20
> >   - rcar-vin (drivers/media/platform/rcar-vin/rcar-csi2.c)
> >     - hs_clk_rate
> >     - lanes
> >=20
> >   - ti-vpe (drivers/media/platform/ti-vpe/cal.c)
> >     - clk_term_en
> >     - d_term_en
> >     - hs_settle
> >     - hs_term
>=20
> Thank you for providing the exhaustive list.
>
> > So the timings expressed in the structure are the set of all the ones
> > currently used in the tree by DSI and CSI drivers. I would consider
> > that a good proof that it would be useful.
>=20
> The problem I see here is each platform (PHY) will have it's own set of
> parameters and we have to keep adding members to phy_configure_opts which=
 is
> not scalable. We should try to find a correlation between generic PHY mod=
es and
> these parameters (at-least for a subset).

I definitely understand you skepticism towards someone coming in and
dropping such a big list of obscure parameters :)

However, those values are actually the whole list of parameters
defined by the MIPI-DPHY standard, so I really don't expect drivers to
need more than that. As you can see, most drivers allow less
parameters to be configured, but all of them are defined within those
parameters. So I'm not sure we need to worry about an ever-expanding
list of parameters: we have a limited set of parameters defined, and
=66rom an authoritative source, so we can also push back if someone
wants to add a parameter that is implementation specific.


Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--4pbg56coqo4uhuid
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluotFoACgkQ0rTAlCFN
r3Qk2hAAl8VsjDArszFyuzTttIzHoC0cmEvdwX5coXyspOqwvHKWBVGci1v3R1Rv
vq5ElXdJWe/UznFA3RDcd9Xssa9haZ09I1SuuTPm/9lFZO7izjqvdOKd+K/ZpGHX
w76soTksEq72FjsjBCc/ww1mvJLeBDAedbSTpgiEx3xkEWLyOO7JepRrxOQGAjHw
UWS+dnVTcG0B//sv2Cx/belydQoEIFAnVD/8ddOgSBhZGRMuX3YN/xNhSlefWzVm
zERu8t//AL53nUy/sk7ngZePm0VDUsM2jQ8FqqqoQgnKLDv+7mOwXLoN762+1/T/
8M6AnPj6K1NZXTT7CkOr6zjd2zH8BA2aMwPVacy6Pclzp2Vn9DooGRlEf06NDrR8
xe2ChLnV/uO9186FDVxCV5NYaY9ThqXxsztXH/5GWBOKBpUtmpUY6FgiiYPhv6tZ
D3LHTbYJd4BFqYqW2apt4uLAPM/sOYKYXGisvySzLSDdwRagrvDdcLSx+pRMTUPd
nMImIr+D6xOkkHp0WpN8kiM+X91HOEmsJdlAaIIEeto4fGZisSlvopZqGkzPjE6r
/8MQP870/4AYJslIEZy2Orp9KsTCOXPbbtDtXSG7jo+wOzyzitqpgaujPkHxkAlH
uFanKUZhsELxy+zfySLW7lSH2UMF152/fFhF/7hPGCYU/ag8+fo=
=7Ujp
-----END PGP SIGNATURE-----

--4pbg56coqo4uhuid--
