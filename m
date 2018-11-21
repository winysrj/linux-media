Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49564 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729179AbeKVAWi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 19:22:38 -0500
Date: Wed, 21 Nov 2018 14:47:56 +0100
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
Message-ID: <20181121134756.aoj6otdcl4stpd6p@flea>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
 <4ec9e47fb5aa9794f69a8e75a04108055094c056.1541516029.git-series.maxime.ripard@bootlin.com>
 <5f5bcc06-51b2-d565-56a0-083c66c1f01a@ti.com>
 <8536050b-40ab-1ec4-d325-e59bb3a92e73@ti.com>
 <20181121101121.7rhe2hz2mnmc72cu@flea>
 <20c0fd85-95f6-9849-c10b-998a1e0f527d@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iu5ypcxah5lvujer"
Content-Disposition: inline
In-Reply-To: <20c0fd85-95f6-9849-c10b-998a1e0f527d@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--iu5ypcxah5lvujer
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kishon,

On Wed, Nov 21, 2018 at 03:59:43PM +0530, Kishon Vijay Abraham I wrote:
> On 21/11/18 3:41 PM, Maxime Ripard wrote:
> > Hi Kishon,
> >=20
> > On Tue, Nov 20, 2018 at 11:02:34AM +0530, Kishon Vijay Abraham I wrote:
> >>>> +static int cdns_dphy_config_from_opts(struct phy *phy,
> >>>> +				      struct phy_configure_opts_mipi_dphy *opts,
> >>>> +				      struct cdns_dphy_cfg *cfg)
> >>>> +{
> >>>> +	struct cdns_dphy *dphy =3D phy_get_drvdata(phy);
> >>>> +	unsigned int dsi_hfp_ext =3D 0;
> >>>> +	int ret;
> >>>> +
> >>>> +	ret =3D phy_mipi_dphy_config_validate(opts);
> >>>> +	if (ret)
> >>>> +		return ret;
> >>>> +
> >>>> +	ret =3D cdns_dsi_get_dphy_pll_cfg(dphy, cfg,
> >>>> +					opts, &dsi_hfp_ext);
> >>>> +	if (ret)
> >>>> +		return ret;
> >>>> +
> >>>> +	opts->wakeup =3D cdns_dphy_get_wakeup_time_ns(dphy);
> >>
> >> Is the wakeup populated here used by the consumer driver?
> >=20
> > It's supposed to, if it can yes.
>=20
> But I guess right now it's not using. I'm thinking the usefulness of vali=
date
> callback (only from this series point of view). Why should a consumer dri=
ver
> invoke validate if it doesn't intend to configure the PHY?
>=20
> The 3 steps required are
> 	* The consumer driver gets the default config
> 	* The consumer driver changes some of the configuration and
> 	* The consumer driver invokes phy configure callback.
>=20
> phy_configure anyways can validate the config before actually configuring=
 the phy.

If you only want to configure the PHY, then yes, sure.

However, the point here is that validate helps negotiating what the
source device (DSI controller for example) and what the sink device
(say a panel) are capable of.

A panel for example might very well have multiple resolutions that it
supports, and the DSI controller will have some as well. And the PHY
will only be able to operate within certain boundaries too. However,
they don't necessarily match, since there's so many panels, and so
many SoCs.

Let's say our (very weird) panel is able to do 640x480, 1024x768 and
1280x800. Our DSI driver can only operate with 1024 pixels in both
dimensions, and the PHY can only reach the bus frequency needed for
around 800x600.

We'll want to filter out 1280x800 (because the DSI controller can't
provide that) and 1024x768 (because the PHY can go fast enough), to
only provide the 640x480 option to the user.

That's what validate bring you. The option to test whether a given
configuration *would* work, without actually wanting to apply it right
now.

Does that make sense?

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--iu5ypcxah5lvujer
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW/ViDAAKCRDj7w1vZxhR
xa3GAP0ZHJFfdP8AHbU/zVcZO1407Vempr4G9duf1m2fclsISAEAhbmlotNSdZ5P
EEO4XJflXWB0UOENX9goeLsVFreSHAo=
=M7Mr
-----END PGP SIGNATURE-----

--iu5ypcxah5lvujer--
