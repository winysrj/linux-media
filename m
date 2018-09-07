Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:59348 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbeIGNgc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 09:36:32 -0400
Date: Fri, 7 Sep 2018 10:56:23 +0200
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
Message-ID: <20180907085623.ltzybsftrw3zmmev@flea>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
 <5b784b096d5507e45c641880af31b07763b4fce2.1536138624.git-series.maxime.ripard@bootlin.com>
 <11216244.YyI1EIWKhC@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3f5k7jmk5ecpvt3d"
Content-Disposition: inline
In-Reply-To: <11216244.YyI1EIWKhC@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3f5k7jmk5ecpvt3d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 05, 2018 at 04:43:57PM +0300, Laurent Pinchart wrote:
> > The current set of parameters should cover all the potential users.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  include/linux/phy/phy-mipi-dphy.h | 241 ++++++++++++++++++++++++++++++=
+-
> >  include/linux/phy/phy.h           |   6 +-
> >  2 files changed, 247 insertions(+)
> >  create mode 100644 include/linux/phy/phy-mipi-dphy.h
> >=20
> > diff --git a/include/linux/phy/phy-mipi-dphy.h
> > b/include/linux/phy/phy-mipi-dphy.h new file mode 100644
> > index 000000000000..792724145290
> > --- /dev/null
> > +++ b/include/linux/phy/phy-mipi-dphy.h
> > @@ -0,0 +1,241 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) 2018 Cadence Design Systems Inc.
> > + */
> > +
> > +#ifndef __PHY_MIPI_DPHY_H_
> > +#define __PHY_MIPI_DPHY_H_
> > +
> > +#include <video/videomode.h>
> > +
> > +/**
> > + * struct phy_configure_opts_mipi_dphy - MIPI D-PHY configuration set
> > + *
> > + * This structure is used to represent the configuration state of a
> > + * MIPI D-PHY phy.
>=20
> Shouldn't we split the RX and TX parameters in two structures ?

Are they different? As far as I understood it, both were having the
same parameters.



> > +	/**
> > +	 * @modes:
> > +	 *
> > +	 * transmission operation mode flags
> > +	 */
> > +	u32			modes;
>=20
> Where are those flags defined ?

goto label;

> > +	/**
> > +	 * @timings:
> > +	 *
> > +	 * Video timings associated with the transmission.
>=20
> That's a pretty vague description...

I'll try to improve it then

> > +	 */
> > +	struct videomode	timings;
> > +};
> > +

label:
> > +/* TODO: Add other modes (burst, commands, etc) */
> > +#define MIPI_DPHY_MODE_VIDEO_SYNC_PULSE		BIT(0)

But maybe I should reorganize it to make it more obvious.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--3f5k7jmk5ecpvt3d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluSPTYACgkQ0rTAlCFN
r3RBZRAAmC0lLyvNPZiFPmKx16xUoK0BkAL1vOXWXhzvc4bVTSbGHqWyBL35dDXO
8fi29Ch3D/M363GPxyg5v1adgF9cFmr1/hHGkyPRqhd8Mq9N/grtFefWYih4DlYh
O1rKzFUUVWzFyJd2EnkIY8PXEIZ7KNIzUj26QhSubmGwrxcml5kmovbOVur6AoCU
DV7BBoSs/Fu1Mf8hf5D/P/ELVkIoi5XWl/zCkeLgNJqpAnB/ZzT9CVj83YjSCIsY
ypahVHFYA/mV9pSL1v4+W5AxN7otb7L8T9foOH6Z7gT7Jbd83fX57NMYy858R1Yr
Lv31tKl5y68DyxJlXyv0x+NsCkA/ETOt1HL6OTQQqgAGJSPnQhfHuYDne5KN+htn
vx5KzMX+wa5qFo6uZPIOyAJiGEa/58yHBbnMLmm28ADvXXMhidf0RA39LlYQA04c
xqVrypRJzdyDbQ/s+i+kB8yhuTRUFwfydJ+bF+xmwL6xkIOo/5ybpHEn75V6Llwz
m2aRIBjiA38cP1rhS4xqpuQX3TGH9aqzzBErfXL0w61OjaJOghEaDsG/CZ2aHIXU
TlmHK9ooI/zImdy7VV2Ucb/l2c29J9pT+eSfXg2fEzzK9K3JdurftHEI/jCrwYqK
WUO1meAwKFbtEsHxxL5uvkVA5g+YxvSkGHX+IRePEYpn4ktR03E=
=WRu9
-----END PGP SIGNATURE-----

--3f5k7jmk5ecpvt3d--
