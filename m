Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42905 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbeIGSTR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 14:19:17 -0400
Date: Fri, 7 Sep 2018 15:38:04 +0200
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
Subject: Re: [PATCH 09/10] phy: Add Cadence D-PHY support
Message-ID: <20180907133804.ktpth3n4uft6fvl6@flea>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
 <d50a5f0750647dcc09ef52411641b628161b362e.1536138624.git-series.maxime.ripard@bootlin.com>
 <1838745.9zNmGlpGXc@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cuyvdolowx73taes"
Content-Disposition: inline
In-Reply-To: <1838745.9zNmGlpGXc@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cuyvdolowx73taes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 05, 2018 at 04:48:27PM +0300, Laurent Pinchart wrote:
> Hi Maxime,
>=20
> Thank you for the patch.
>=20
> On Wednesday, 5 September 2018 12:16:40 EEST Maxime Ripard wrote:
> > Cadence has designed a D-PHY that can be used by the, currently in tree,
> > DSI bridge (DRM), CSI Transceiver and CSI Receiver (v4l2) drivers.
> >=20
> > Only the DSI driver has an ad-hoc driver for that phy at the moment, wh=
ile
> > the v4l2 drivers are completely missing any phy support. In order to ma=
ke
> > that phy support available to all these drivers, without having to
> > duplicate that code three times, let's create a generic phy framework
> > driver.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  drivers/phy/Kconfig             |   1 +-
> >  drivers/phy/Makefile            |   1 +-
> >  drivers/phy/cadence/Kconfig     |  13 +-
> >  drivers/phy/cadence/Makefile    |   1 +-
> >  drivers/phy/cadence/cdns-dphy.c | 499 ++++++++++++++++++++++++++++++++=
+-
>=20
> Should the DT bindings be split from Documentation/devicetree/bindings/
> display/bridge/cdns,dsi.txt ?

Yep, I'll change it.

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--cuyvdolowx73taes
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluSfzsACgkQ0rTAlCFN
r3R1YQ/8Dcq7GFoZ3FVBxlIk5V9dLkefeHySK2NXWZWAxYzSEUlkmRVfoq8+HoZE
GvKTAPrqnLfWiczZzDtMQaXe2QSHfg9w+9yEP59q31RDYAqSWHKXmg3C2ro2PXlf
QJpfsT40zTWcMHNYlWI0x9EU0P4TV/5KJbiwvHeVR8xvrZ6a747xs3wfQpB3gryW
eP3z0pO4bVeAT9SSgOp0zfPzAsX40lFWxjSdPqF4NRVuJ4WqdEIhnorp5ySIGUos
qhhw88Um5BnVY0p7+c4gjphChLa9RZekiQIFNjjarAFRSiJGm9zCzMNBBpoNlW7C
YPyrs3OHKr6r9Cq0NI98tPg3uias6bW0H2Qna0FIp2eqWqF2KOvfYWGNBEljEipP
76o7rtpgRqxkQmf+OsAZIHgatuKeoW7sT7A/M6y9sjwBoByZR0uas7ld8qoNvc/p
7Sm6NiBtLGDMpHvGoYGzDvv6mdKmmxO+b4RtpXNFUReNgCz/f0KPDuleHvtqCFn8
7pHbK/EHch+peSG4quRjcoMr/slMB/JbB3cDqK7DHZzT+YH7QGc4LTVvd+GZd04u
2hNKVfvAFVPqERneZRpXFFboICzYdP3hfOEKmEDK/NRkQHR6qyykknIHzu384R9/
i4Pwq0pG9HbpyjAhdunQmW1Gkqx9ixRdJ+uBm07qmv7WbsVryVU=
=MZ+y
-----END PGP SIGNATURE-----

--cuyvdolowx73taes--
