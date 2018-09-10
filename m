Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41421 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728063AbeIJTMy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 15:12:54 -0400
Date: Mon, 10 Sep 2018 16:18:23 +0200
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
Subject: Re: [PATCH 03/10] phy: Add MIPI D-PHY configuration options
Message-ID: <20180910141823.q43yylpkcq5cls4r@flea>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
 <11216244.YyI1EIWKhC@avalon>
 <20180907085623.ltzybsftrw3zmmev@flea>
 <4247225.jW0mJSbZmP@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="w4xzmhfdiyxyy2dg"
Content-Disposition: inline
In-Reply-To: <4247225.jW0mJSbZmP@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--w4xzmhfdiyxyy2dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 07, 2018 at 05:50:52PM +0300, Laurent Pinchart wrote:
> On Friday, 7 September 2018 11:56:23 EEST Maxime Ripard wrote:
> > On Wed, Sep 05, 2018 at 04:43:57PM +0300, Laurent Pinchart wrote:
> > >> The current set of parameters should cover all the potential users.
> > >>=20
> > >> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > >> ---
> > >>=20
> > >>  include/linux/phy/phy-mipi-dphy.h | 241 +++++++++++++++++++++++++++=
+++-
> > >>  include/linux/phy/phy.h           |   6 +-
> > >>  2 files changed, 247 insertions(+)
> > >>  create mode 100644 include/linux/phy/phy-mipi-dphy.h
> > >>=20
> > >> diff --git a/include/linux/phy/phy-mipi-dphy.h
> > >> b/include/linux/phy/phy-mipi-dphy.h new file mode 100644
> > >> index 000000000000..792724145290
> > >> --- /dev/null
> > >> +++ b/include/linux/phy/phy-mipi-dphy.h
> > >> @@ -0,0 +1,241 @@
> > >> +/* SPDX-License-Identifier: GPL-2.0 */
> > >> +/*
> > >> + * Copyright (C) 2018 Cadence Design Systems Inc.
> > >> + */
> > >> +
> > >> +#ifndef __PHY_MIPI_DPHY_H_
> > >> +#define __PHY_MIPI_DPHY_H_
> > >> +
> > >> +#include <video/videomode.h>
> > >> +
> > >> +/**
> > >> + * struct phy_configure_opts_mipi_dphy - MIPI D-PHY configuration s=
et
> > >> + *
> > >> + * This structure is used to represent the configuration state of a
> > >> + * MIPI D-PHY phy.
> > >=20
> > > Shouldn't we split the RX and TX parameters in two structures ?
> >=20
> > Are they different? As far as I understood it, both were having the
> > same parameters.
>=20
> clk_miss, for instance, is a receiver parameter, while clk_post is a=20
> transmitter parameter. There are relationships between the transmitter an=
d=20
> receiver parameters in the sense that they have to be compatible, and we =
may=20
> want to compute one set of parameters based on the other one, but I think=
 they=20
> target RX and TX separately.

That would require however to have to fill a structure in the consumer
whose sole purpose would be to validate things in the phy
framework. That looks quite weird from an API point-of-view.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--w4xzmhfdiyxyy2dg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluWfS4ACgkQ0rTAlCFN
r3RqTA/+MfrGErefSzmoCzf2+0dinKANNdfXlv/nSz6G8GYS9vdGT5DyB28xwNHD
PYmWtxWvEJbC/8Dg1vdnQhNfveqz/bPFkMGH1VrSf5dFtJogO7uzn6KcyxU3cWoA
RLlE482CD4yzUQjKrcqGST+v1wWZeES3AJfMvAdo4HCBkZVfL9ayR0SL3TX5XIfz
NnYtVzRbvY2/XDkgt4J12LhdZbdkTPrBHMe8wkAM0virJa3dLp7vqWVgyjI4mXVr
5T8izByuFJpjrPFGxqflPCDoBQDQuTCZe26QQ40+a62TumVga5Nax4xtsfYkjTUn
11Kn2JMip1tcVeyHX1BXVpxhYilS8wI3fbIE52PzqZ3h8eeyX7iVvLG/3GS0arsO
QytZzsVxjWcM5CQRnFe6wtkSTHDNDHI9FXgzQOJSk/Wg10IVaC87Z1er2NgTfzsy
svUlrIyTX0zioHCeare1tWlqvdsk+ElKPC6E6fnzlgvrUU/nptcpmInzWJBLa5AC
5A0CZiwu991qoJS1UzNLmbmU2CFuOiwVADeGx1ZIU74U65zOMQs6SBk/fvgSwjm1
M8rZsBRxMLmMRYv/iQDK/31uRStKhptR4taSnqfCFdNgIyGhrCzmZWgLAmXiWm6Y
617xjdrMsROeQ7HW2N4oEMf8MAJYkZuFhIV2GxsoyzaXK2jxIsk=
=3ef4
-----END PGP SIGNATURE-----

--w4xzmhfdiyxyy2dg--
