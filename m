Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51714 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425957AbeCBJt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 04:49:58 -0500
Date: Fri, 2 Mar 2018 10:49:46 +0100
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
Subject: Re: [PATCH v5 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Message-ID: <20180302094946.kds3zjheo5gcntdd@flea.lan>
References: <20180301113049.16470-1-maxime.ripard@bootlin.com>
 <20180301113049.16470-3-maxime.ripard@bootlin.com>
 <20180301203515.GM6807@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iuixmato4gwn7gto"
Content-Disposition: inline
In-Reply-To: <20180301203515.GM6807@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--iuixmato4gwn7gto
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Benoit,

On Thu, Mar 01, 2018 at 02:35:16PM -0600, Benoit Parrot wrote:
> > +	writel(CSI2TX_DPHY_CLK_WAKEUP_ULPS_CYCLES(32),
> > +	       csi2tx->base + CSI2TX_DPHY_CLK_WAKEUP_REG);
>=20
> I am sorry if I missed this previously but do all these
> CSI2TX_DPHY* reg access assume that "has_internal_dphy" is true?

It seems like it's needed even for the case without an internal
DPHY. I'll check, and add a comment if it's really the case.

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--iuixmato4gwn7gto
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqZHjkACgkQ0rTAlCFN
r3Rk9w//eQBLUB2sIB7wRCEoL5Byuod9B0oBORSiCI1aks7DKF7FHosChtiROl0l
VPdM5Hzgsfkx9gyVyBTlClJCVbf2JG5pgneTBvKbl/LFMUr36/GBByipXjEjqEqM
8jHpWPQXazty3rsvSX1+JqIBbmgHlGZUy1aNDXFt7aAJZfkYh5PbCZFpT3lzxCZv
b0zTmZlPkcclYTmJB4e0CnLWmClBFR+KF9fVoqy9JQDjksQfuhH0NT3fsiHq4rD8
WC6JpNdZRK31sLGgb9Pf3YPl3AtxLjmkKgF0zE8ESHEgcFST8iPk3VhX7GvUM3r1
1+PjC/Oy81CxMrkbq8aDnBr6rawfujRp0PW15coLya9otC6P1C/rzkzmwXsRKz8X
x+qqLcfxrLQ7kIf+iISIyUgqrzC0d330lnwuoBoHg60f66OiLkG84v6TjzF3NMQb
PhoGnDjYqV+jS2h3vquJat0PhviZSirRqCJ/XCXsW9lSVdrANW8D75rxvu/eSEDt
ImqBTa8GBnEfSNmnvX1RSc4zFvyZP0gL0SmcGdejnzSLIXD/oPI0w10zzUAGbTXb
RczdatcvTYcfZ8jAUaLG2xN4rEZU267dSn5ePN+RcTVd+BiUj10uQ0sGLIBzoHfO
4hvNnuII9p7IfM3vAySQG2iNneMJoqezaCFQuGv7IiS/MJqv+Xg=
=BDnr
-----END PGP SIGNATURE-----

--iuixmato4gwn7gto--
