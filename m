Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:59946 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751147AbeCIPgx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:36:53 -0500
Date: Fri, 9 Mar 2018 16:36:39 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v8 0/2] media: v4l: Add support for the Cadence MIPI-CSI2
 RX
Message-ID: <20180309153639.f2oauh5gvlgagc5v@flea>
References: <20180215133335.9335-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="76sdo5dsk34ofwrl"
Content-Disposition: inline
In-Reply-To: <20180215133335.9335-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--76sdo5dsk34ofwrl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 15, 2018 at 02:33:33PM +0100, Maxime Ripard wrote:
> Hi,
>=20
> Here is another attempt at supporting the MIPI-CSI2 RX block from
> Cadence.
>=20
> This IP block is able to receive CSI data over up to 4 lanes, and
> split it to over 4 streams. Those streams are basically the interfaces
> to the video grabbers that will perform the capture.
>=20
> It is able to map streams to both CSI datatypes and virtual channels,
> dynamically. This is unclear at this point what the right way to
> support it would be, so the driver only uses a static mapping between
> the virtual channels and streams, and ignores the data types.

Ping?

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--76sdo5dsk34ofwrl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqiqgYACgkQ0rTAlCFN
r3R3aRAAkUsN9bD09gOZaSnrfBzNr1sDXkzoj+EZqYggMh+mnl2hl7mTy9/CtVLY
vS3TFy17W0XzdiT76k0s+3ENp8pqpQ1uAVk+eHfbG4soX2BaE/nc53YJMIb9U2if
xc9i+HK/MqP8M+jZwcfGoBFbTcMxYazrSOdGI6kqCl8XYAzSyQDuIg8qP/z1CD0f
tML0k/WKBa5LcRJuaDIFPahhHaHjBXSXRJeJgUeuvjfsR/5kXNdmfD8RZnrH06t0
IxChnuv+doNwFCSHyyF8boKHZyb3vx8XepjBCox87YiclKsf8xdfC4km/J27y4G3
0yGXiVsI0wUwCBv6lEcWy+OoRGkxzMXroztPONqUNcWNXZTtvDd46BGh3vsRPuM/
xPyNLWKYawXc8qYj+IugVEhgdMAOh9FWXnIttrH+dfk/gpRMC6ylup3xKKBAcH9d
wqlCgV+iXGtmvlx6gi7absH9wKSfv4hcC7aJDC/MLegcQZGSOnV5XPEF2FP14Rpq
cj0FUei68iszb6Grc4wgooIRJ709CTyC+MLQHjn9j8YabelGe1aSeFQAVMDrZgZA
t/9QznRkeOXA4dy7gytyikpTTlMBkYtLphcH6j7Tvo+10bN5A1p+dsmWULFETnDr
dA9pOsnEvfjzw7PYDhKpqa1IkRep/G6ccUlrTMda6pr7X7QTvwM=
=QBSz
-----END PGP SIGNATURE-----

--76sdo5dsk34ofwrl--
