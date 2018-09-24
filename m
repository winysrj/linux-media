Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:36151 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731934AbeIXSVX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 14:21:23 -0400
Date: Mon, 24 Sep 2018 14:19:20 +0200
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
Message-ID: <20180924121920.kv4e4qkorvexmyj7@flea>
References: <a739a2d623c3e60373a73e1ec206c2aa35c4a742.1536138624.git-series.maxime.ripard@bootlin.com>
 <1ed01c1f-76d5-fa96-572b-9bfd269ad11b@ti.com>
 <20180906145622.kwxvkcuerbeqsj6b@flea>
 <1a169fad-72b7-fac0-1254-cac5d8304740@ti.com>
 <20180912084242.skxbwbgluakakyg6@flea>
 <e0d7db11-7ec1-cb98-4e62-12d78d1ba65b@ti.com>
 <20180919121436.ztjnxofe66quddeq@flea>
 <93088385-126b-6bfb-70e4-16f7b949d299@ti.com>
 <20180924095435.77hh7lrpq7wkss2o@flea>
 <b5ebd9a5-f43b-728b-1d7f-0f7b08021f39@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="trjigjmmd2pyq2b4"
Content-Disposition: inline
In-Reply-To: <b5ebd9a5-f43b-728b-1d7f-0f7b08021f39@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--trjigjmmd2pyq2b4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

(stripping the mail a bit)

On Mon, Sep 24, 2018 at 05:25:26PM +0530, Kishon Vijay Abraham I wrote:
> >>>>> This integration will prevent us to use some clock rates on the fir=
st
> >>>>> SoC, while the second one would be totally fine with it.
> >>>>
> >>>> If there's a clock that is fed to the PHY from the consumer, then th=
e consumer
> >>>> driver should model a clock provider and the PHY can get a reference=
 to it
> >>>> using clk_get(). Rockchip and Arasan eMMC PHYs has already used some=
thing like
> >>>> that.
> >>>
> >>> That would be doable, but no current driver has had this in their
> >>> binding. So that would prevent any further rework, and make that whole
> >>> series moot. And while I could live without the Allwinner part, the
> >>> Cadence one is really needed.
> >>
> >> We could add a binding and modify the driver to to register a clock pr=
ovider.
> >> That could be included in this series itself.
> >=20
> > That wouldn't work for device whose bindings need to remain backward
> > compatible. And the Allwinner part at least is in that case.
>=20
> Er..
>=20
> > I think we should aim at making it a norm for newer bindings, but we
> > still have to support the old ones that cannot be changed.
>=20
> There are drivers which support both the old and new bindings. Allwinner =
could
> be in that category.

Yes, definitely. However, in order to support the old binding, we'd
still need to have a way to give the clock rates to the phy when we
don't have that clock provider. So I don't really see how we could
remove those fields, even if we start introducing new bindings.

> >>> So the timings expressed in the structure are the set of all the ones
> >>> currently used in the tree by DSI and CSI drivers. I would consider
> >>> that a good proof that it would be useful.
> >>
> >> The problem I see here is each platform (PHY) will have it's own set of
> >> parameters and we have to keep adding members to phy_configure_opts wh=
ich is
> >> not scalable. We should try to find a correlation between generic PHY =
modes and
> >> these parameters (at-least for a subset).
> >=20
> > I definitely understand you skepticism towards someone coming in and
> > dropping such a big list of obscure parameters :)
>=20
> That's part of my concern. The other concern is consumer driver having to=
 know
> so much internal details of the PHY. None of the other consumers (PCIe, U=
SB,
> etc) had to know so much internals of the PHY.

I guess that's true to some extent, but it also feels a bit like a
self-realizing prophecy. The phy framework also didn't provide any way
to change the phy configuration based on some runtime values up until
now, and we have a good example with the MIPI-DSI and MIPI-CSI drivers
that given the constructs used in these drivers, if the phy framework
had allowed it, they would have used it.

Also, speaking of USB, we've had some configuration that was done in
some private functions exported by the phy drivers themselves. So
there is a use case for such an interface even for other, less
configurable, phy types.

I even planned for that, since the phy_validate and phy_configure
functions are passed an union, in order to make it extensible to other
phy types easily.

I guess that both the fact that the configuration is simpler for the
phy types supported so far, and that the phy and its consumer are very
integrated, didn't make it necessary to have such an interface so
far. But with MIPI-DPHY, we have both a quite extensive configuration
to make, and the phys and their consumers seem to be a bit more
loosely integrated. HDMI phys seem to be in pretty much the same case
too.

> > However, those values are actually the whole list of parameters
> > defined by the MIPI-DPHY standard, so I really don't expect drivers to
> > need more than that. As you can see, most drivers allow less
> > parameters to be configured, but all of them are defined within those
> > parameters. So I'm not sure we need to worry about an ever-expanding
> > list of parameters: we have a limited set of parameters defined, and
> > from an authoritative source, so we can also push back if someone
> > wants to add a parameter that is implementation specific.
>=20
> Your commit log mentioned there are a few parameters in addition to what =
is
> specified in the MIPI D-PHY spec :-/
>=20
> "The parameters added here are the one defined in the MIPI D-PHY spec, pl=
us
> some parameters that were used by a number of PHY drivers currently found
> in the linux kernel."

I should have phrased that better then, sorry. The only additions that
were made were the lanes number (that we agreed to remove), the high
speed and low power clock rates, and the video timings.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--trjigjmmd2pyq2b4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluo1kcACgkQ0rTAlCFN
r3QSkg//QvNcniiBPADCYWrwY43VcAb3kkap7cIUjC+t8Qdgd36eHBiyQxWIQQUY
nAWa0SG/S7UjWIKzzCNpEfoiqg4zEAKnY8k0pbmLkuI3xPZxGvVKMBNsnAPwgXp1
4qAO23AXFoujj426xIq++4pP3iyntw3InG2Xc+nb9a1HrF8X7UdzRQI0lBwshjgK
mRxLRCaDvCIysFkEgiyGqDciKyu97pSk2XMFtxsoZENLB+0ib+2GGHJJa2Ev/Flu
nx6xzHaH9Xk2HMj17/7OcDtxhJ/2UW14et2B5nLQy+yMcIod83SJJ1uPeF740fO6
vZWdfEo3tVe6msBsv/j2m7UqJoacYTHexTOKveqxiO9vNb3iZ9gZXErql88+krZ8
jjW7jfdrtvGhVwCQFhFvxXbOgvc0yyzx80EP9oP4OuJw2Fqc5tLtXQZmqj27+Rly
HWBTdN76NIIOviXuCUjcWv/VBosEh3FuxBIR0BvlzrwP0TZ7ybVyoYFlPlOFa6hr
BKBZYBnQ8hxceiUPERsVvGIWfka0lpDl2slWbNK6UWtnZQbPrQIeVUdWIws8ePYD
PvthSZRUtnRdF9I3Uopf01KGZWFu7STIDtoVcHdmgH9pfi4U3qxf90IgdROzdm/Z
aSwgrMjhlHObo+nAzPTJ65dH8XWG0RM0PMNnNnsnz8u3sOmdY8M=
=5xwp
-----END PGP SIGNATURE-----

--trjigjmmd2pyq2b4--
