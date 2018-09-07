Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42887 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbeIGSSv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 14:18:51 -0400
Date: Fri, 7 Sep 2018 15:37:39 +0200
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
Subject: Re: [PATCH 04/10] phy: dphy: Add configuration helpers
Message-ID: <20180907133739.6lvlw7wsdk4ffeua@flea>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
 <aa491b814100a670ad16b646765005efbdae05d9.1536138624.git-series.maxime.ripard@bootlin.com>
 <3617916.Vq2Smf1hnZ@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xzvsx53ec7kgrpz7"
Content-Disposition: inline
In-Reply-To: <3617916.Vq2Smf1hnZ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--xzvsx53ec7kgrpz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 05, 2018 at 04:46:05PM +0300, Laurent Pinchart wrote:
> Hi Maxime,
>=20
> Thank you for the patch.
>=20
> On Wednesday, 5 September 2018 12:16:35 EEST Maxime Ripard wrote:
> > The MIPI D-PHY spec defines default values and boundaries for most of t=
he
> > parameters it defines. Introduce helpers to help drivers get meaningful
> > values based on their current parameters, and validate the boundaries of
> > these parameters if needed.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  drivers/phy/Kconfig               |   8 ++-
> >  drivers/phy/Makefile              |   1 +-
> >  drivers/phy/phy-core-mipi-dphy.c  | 160 ++++++++++++++++++++++++++++++=
+-
> >  include/linux/phy/phy-mipi-dphy.h |   6 +-
> >  4 files changed, 175 insertions(+)
> >  create mode 100644 drivers/phy/phy-core-mipi-dphy.c
> >=20
> > diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> > index 5c8d452e35e2..06bd22bd1f4a 100644
> > --- a/drivers/phy/Kconfig
> > +++ b/drivers/phy/Kconfig
> > @@ -15,6 +15,14 @@ config GENERIC_PHY
> >  	  phy users can obtain reference to the PHY. All the users of this
> >  	  framework should select this config.
> >=20
> > +config GENERIC_PHY_MIPI_DPHY
> > +	bool "MIPI D-PHY support"
> > +	help
> > +	  Generic MIPI D-PHY support.
> > +
> > +	  Provides a number of helpers a core functions for MIPI D-PHY
> > +	  drivers to us.
>=20
> Do we really need to make this user-selectable ?

Probably not :)

> >  config PHY_LPC18XX_USB_OTG
> >  	tristate "NXP LPC18xx/43xx SoC USB OTG PHY driver"
> >  	depends on OF && (ARCH_LPC18XX || COMPILE_TEST)
> > diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> > index 84e3bd9c5665..71c29d2b9af7 100644
> > --- a/drivers/phy/Makefile
> > +++ b/drivers/phy/Makefile
> > @@ -4,6 +4,7 @@
> >  #
> >=20
> >  obj-$(CONFIG_GENERIC_PHY)		+=3D phy-core.o
> > +obj-$(CONFIG_GENERIC_PHY_MIPI_DPHY)	+=3D phy-core-mipi-dphy.o
> >  obj-$(CONFIG_PHY_LPC18XX_USB_OTG)	+=3D phy-lpc18xx-usb-otg.o
> >  obj-$(CONFIG_PHY_XGENE)			+=3D phy-xgene.o
> >  obj-$(CONFIG_PHY_PISTACHIO_USB)		+=3D phy-pistachio-usb.o
> > diff --git a/drivers/phy/phy-core-mipi-dphy.c
> > b/drivers/phy/phy-core-mipi-dphy.c new file mode 100644
> > index 000000000000..6c1ddc7734a2
> > --- /dev/null
> > +++ b/drivers/phy/phy-core-mipi-dphy.c
> > @@ -0,0 +1,160 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) 2013 NVIDIA Corporation
> > + * Copyright (C) 2018 Cadence Design Systems Inc.
> > + */
> > +
> > +#include <linux/errno.h>
> > +#include <linux/export.h>
> > +#include <linux/kernel.h>
> > +#include <linux/time64.h>
> > +
> > +#include <linux/phy/phy.h>
> > +#include <linux/phy/phy-mipi-dphy.h>
> > +
> > +/*
> > + * Default D-PHY timings based on MIPI D-PHY specification. Derived fr=
om
> > the
> > + * valid ranges specified in Section 6.9, Table 14, Page 40 of the D-P=
HY
> > + * specification (v1.2) with minor adjustments.
>=20
> Could you list those adjustments ?

I will. This was taken from the Tegra DSI driver, so I'm not sure what
these are exactly, but that should be addressed.

> > + */
> > +int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
> > +				     unsigned int bpp,
> > +				     unsigned int lanes,
> > +				     struct phy_configure_opts_mipi_dphy *cfg)
> > +{
> > +	unsigned long hs_clk_rate;
> > +	unsigned long ui;
> > +
> > +	if (!cfg)
> > +		return -EINVAL;
>=20
> Should we really expect cfg to be NULL ?

It avoids a kernel panic and it's not in a hot patch, so I'd say yes?

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--xzvsx53ec7kgrpz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluSfyIACgkQ0rTAlCFN
r3Q6NQ//Vo9VNwq0Q/E3MGCE7xJc1frQHdbAlZyUse7WtZGymhiUpubD+2lyTw6B
zW5tfjExaFs3h4oOW/hTPJ8h2enIc0ySTT1I+DPgTEGetfMng/D5YjwZKL8iosX5
lsrLbWS4Mq5H9qsEvjA8r/iJ7IvTvkFbiKlPKRgq9OsZgUivMi3bt5L2nt4udM6y
zXxjRZczTw0e/OowYACXQ6twJ9K2QgwqOowgJcHf9ojXy7qacLI9vo+fb1zepAyp
fmxaxzj8e+knukbFMXRc+d32yzA2Rrichy0aDSjKDH1Nxmiv+pyvGBxhR5NYe9U4
/uM8XXgGi8JWsqDEwZqj3LgSHBWeiiHkGuRP+9fDhi05FaCN7nrK3ZtXPKqvlNNX
xii8lXarAm/gQmERTFtU4kTH5kGOJkMaC8Ssklv47lfBXBeyiQLCv1xIZ/JOA4vb
oI8E46WUCPKyjQAmcIz9xIVUICageXA++Yf7SALIhvObv8Jyh8EaMK6nyor78hnv
91LHJ80PG+LzDXWAIM77fG6gYUXx4BbWJ67yJNj+lRxo1D5oYWTBUKs96PnZmSKA
q+ftBvNmBlPKTG2tF5O9Xe+LCkgDVN7P2tnCq8UPDib+331hMG6hHwbLbjjfVZbD
YZKGPrz4L8mMBfERQSAE4ee3byygfdnU0IoS6r6vMpII7WsRuc4=
=RxIg
-----END PGP SIGNATURE-----

--xzvsx53ec7kgrpz7--
