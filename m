Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49253 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751095AbeDCNtL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Apr 2018 09:49:11 -0400
Date: Tue, 3 Apr 2018 15:48:59 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
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
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v7 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Message-ID: <20180403134859.73r3usnf6foyxncu@flea>
References: <20180326133456.16584-1-maxime.ripard@bootlin.com>
 <20180326133456.16584-3-maxime.ripard@bootlin.com>
 <20180329123534.GB26532@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uoddcctbr6jg5mro"
Content-Disposition: inline
In-Reply-To: <20180329123534.GB26532@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--uoddcctbr6jg5mro
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Thu, Mar 29, 2018 at 02:35:34PM +0200, Niklas S=F6derlund wrote:
> > +	/*
> > +	 * Create a static mapping between the CSI virtual channels
> > +	 * and the input streams.
> > +	 *
> > +	 * This should be enhanced, but v4l2 lacks the support for
> > +	 * changing that mapping dynamically at the moment.
> > +	 *
> > +	 * We're protected from the userspace setting up links at the
> > +	 * same time by the upper layer having called
> > +	 * media_pipeline_start().
> > +	 */
> > +	list_for_each_entry(link, &entity->links, list) {
>=20
> I wonder is this list_for_each_entry() really needed? Can't you simply=20
> iterate over all sink pads as with the loop bellow but drop the pad =3D=
=3D=20
> link->sink check? Maybe I'm missing something.

This was a review made by Sakari here:
https://patchwork.linuxtv.org/patch/44422/

The idea is that we need to know if the pad is enabled, and as far as
I know this information is only stored at the link level, not at the
pad level.

> Apart from this and the small nit-picks (one more bellow) I think this=20
> patch is fine. Once I understand this I be happy to add my tag to this=20
> change, great work!

Is this a reviewed by? :)

> I also think you shall consider to add a MAINTAINERS record for the RX=20
> and TX drivers. Maybe one entry for both drivers as they live in the=20
> same directory but I think one of the two should add it :-)

Right, I'll do it, thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--uoddcctbr6jg5mro
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrDhkoACgkQ0rTAlCFN
r3THLQ//X4xNGn/Px4U9RfqyoHtRuic16lboyB7w/iBMYKmZ+CnBSAmyX/8pbo7W
rIAwu9ejGGA8g43o7no+vo1RfZ+uUP3Uk1fjTP6cioDf2MrMIDNS7g06atjYKC56
rb8caOzvfKn7Ao7C6Xtw7vT7j5TMHCvvcNq9QAwEnc5uymsZReYlOC9UXCmC5ZxI
hZouHHNg9gufGpN0ERD8ygbIHnLcFj0QMrg93d+1AMKoFPWaEy3qMzcNbEFNlf8U
ot0udKLTuD1JoCfPsSJtkIHK+IvaOMjSLcgWimfIKUFDyv3kLUzr1BzpkWCWe6MU
DI9V2xbqZN9hTuJoO/Vj/v2+LeGKB5FITBv6lFfJLIGpK0cJ9/u15kqlozpvVUzW
11hYfp+cfdCHySr+yMUccO9O7opNj9WumkzjSmP2upcPz4t7oO7OfftiO8UOSr7D
FeGLRT2hhYnnCPZK4Pf7eqMHCTbbhl2FuKUiqJEa91JOJFM+JhoXHEpM/1AoILqJ
C8SHh29lhmZV2Z4S0LMZ027p70u3N/QRjz1uXA8ISwFtbR0H+HCZBcwDNDPf/RlY
KTsqwIUm4oksVdxeAxCLYNikJMO7asHm20wuGPfcicw/rJPwiXHC+nVcuaQ8iRXZ
l65mWLY52591YC+ilY6R/fXxsG+N2JpZ+uTE0WBtLi9Vg+24htE=
=cxPC
-----END PGP SIGNATURE-----

--uoddcctbr6jg5mro--
