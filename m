Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51170 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1424995AbeCBJfn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 04:35:43 -0500
Date: Fri, 2 Mar 2018 10:35:40 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Benoit Parrot <bparrot@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v8 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Message-ID: <20180302093540.yhgv2bcyesqvbaoo@flea.lan>
References: <20180215133335.9335-1-maxime.ripard@bootlin.com>
 <20180215133335.9335-3-maxime.ripard@bootlin.com>
 <20180301200918.GL6807@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5opse5bbpzu3xksz"
Content-Disposition: inline
In-Reply-To: <20180301200918.GL6807@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5opse5bbpzu3xksz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Benoit,

On Thu, Mar 01, 2018 at 02:09:18PM -0600, Benoit Parrot wrote:
> > +	/*
> > +	 * FIXME: Once we'll have internal D-PHY support, the check
> > +	 * will need to be removed.
> > +	 */
> > +	if (csi2rx->has_internal_dphy) {
> > +		dev_err(&pdev->dev, "Internal D-PHY not supported yet\n");
> > +		return -EINVAL;
> > +	}
>=20
> As one of the more critical thing is usually how the CSI2 Receiver intera=
ct
> with a DPHY when can we expect this part of the driver to be implemented?

That's definitely on my radar, but it isn't implemented by any
hardware or simulation at the moment. When that is done, we will
obviously do it.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--5opse5bbpzu3xksz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqZGusACgkQ0rTAlCFN
r3Rk9Q//cANITieZxy2raAUAcU8dNB0Bl8BMocnp/0fPfHAyLhWLNu14vGWTf7mB
3fbs47uVEG+d0vqy94Lw8z9Mo98OnvsZ9n+5qwx4pgX2P2eRDcHuOlwa+2vU9aRq
70tPUgIBXcTVrdAe+6CExl3VzDVhvMOQcHZF+TDBNyhhUU+5qHc2b1+VYdEjcSKI
XEueJ03X/aqydREC1XvsTUaMReotyBHcIOulrFMEmKFc5bkSYYnwDzYCO4om3g+N
C4knrl2JDsrCDscL0opc0UtiBI2nBK7/Gl3QmDv1oWhUFjOdAIDdwTpzmT5ONUVv
0uFy5Jlehi6ejhJYouRYlPIkw9uNuicaKEEL+c9Oqaf+MKtVOlAQ5wliGosvraLR
4jsnQ6q+IjlMXmG37Syw1+0+Is7FG6nJNexiX2gnPLVRfk4fhF7nAWG38ct9rjWi
etASIwdxOrnReDdSnd7d2hM+l994jJ1iqrgn5YAaK45yVeu0kBJ4V3F5xIVDL509
vlCmae77Srw0A/+bm9nJG2lJj/RPCKMFNemVTRUEn3MiWx2EUqADbXwxN4ajMhDa
IUliAFSBtvELam1IOuLxiw/HoFTbpMl5p19NCImFriiTTEy3q3gc0MCTDeUvlk2l
RUfiJdJtrWGkiafTM1Kc2Woxj2wOTGtnQrmCZaM96wnQQ3KkoS4=
=l34z
-----END PGP SIGNATURE-----

--5opse5bbpzu3xksz--
