Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:46865 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755165AbeBOJuU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 04:50:20 -0500
Date: Thu, 15 Feb 2018 10:50:18 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v7 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Message-ID: <20180215095018.hslnarg4ykegqsbo@flea.lan>
References: <20180208150830.9219-1-maxime.ripard@bootlin.com>
 <2517178.9jmyBy62ST@avalon>
 <20180214131933.t75jg5b5cjfuo7r6@flea.home>
 <1952975.8AbmfkeE6m@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zkbrrwh56qyk3crj"
Content-Disposition: inline
In-Reply-To: <1952975.8AbmfkeE6m@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zkbrrwh56qyk3crj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 14, 2018 at 05:03:26PM +0200, Laurent Pinchart wrote:
> On Wednesday, 14 February 2018 15:19:33 EET Maxime Ripard wrote:
> > On Thu, Feb 08, 2018 at 08:17:19PM +0200, Laurent Pinchart wrote:
> > >> +	/*
> > >> +	 * Create a static mapping between the CSI virtual channels
> > >> +	 * and the output stream.
> > >> +	 *
> > >> +	 * This should be enhanced, but v4l2 lacks the support for
> > >> +	 * changing that mapping dynamically.
> > >> +	 *
> > >> +	 * We also cannot enable and disable independant streams here,
> > >> +	 * hence the reference counting.
> > >> +	 */
> > >=20
> > > If you start all streams in one go, will s_stream(1) be called multip=
le
> > > times ? If not, you could possibly skip the whole reference counting =
and
> > > avoid locking.
> >=20
> > I guess that while we should expect the CSI-2 bus to be always
> > enabled, the downstream camera interface could be shutdown
> > independently, so I guess s_stream would be called each time one is
> > brought up or brought down?
>=20
> That's the idea. However, we don't have support for multiplexed streams i=
n=20
> mainline yet, so there's no way it can be implemented today in your drive=
r.

Ok, but we definitely plan on supporting that soon, so I guess that
wouldn't too much of a burden to keep it there.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
http://bootlin.com

--zkbrrwh56qyk3crj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqFV9kACgkQ0rTAlCFN
r3RU5Q/9H1VTrVPGgvRJJmgI1F8/xIpOdCMFliYvjkxul/fF4fUn5JJiq/PTwApi
yzrSKmRrarcYXqNZ1bSwQ9naN7sZHsiRT1L7xKUMPKEeMcWMvCSoCVrO0nrO9aWp
OwY4lcTapDwQO1gXmcevgxkMiO+TytcHVUxVYjueeC9fnvqlwpGynmRZuV6/ODZ1
gKOGzqdoAp3s4E4wm9OlrP4AjlgttZ7u4sdfC3bagSeqE0LIwNu4zCapg4toMbWu
8jwBQX84mK3s1270KB3VYBO5kaei/8phAiCNdaOJUD8NuoBqEg/0s9VAJt7DjLuf
QXjAbkx9KblNJK6NwYQzkuW1/7baf+eg1gM6SWnFmW0E4QFzxw21Cn5OlJOo/Pm8
uhRox+j+He9ZzmdNNtMja8flZrz7arZfoqiWO+UYKEti8OhrsnrqoIbvE2F+q8Y8
P0BS1WStp4h0tGwmMktK+66oO/ir3sgMkIz+Jt9LO1gbc8/1nUw3jOOwfOnF0GU8
mAQgJX0xJfW3z/aiHIbLgEup/JOoVpiys3b2/uNUPW08sNYIYDTrthHkyZ3dhial
MEC17MFx2nMqUf9JMfngLmeZfM6OvPGg/aelmRyslxD7IibWJ1gynozyW7yJnWcZ
LBs2cI4+SquekTbyI7HZl3Lz28uhOx8iZR6gsyXQQJxucn7dY7E=
=VPeT
-----END PGP SIGNATURE-----

--zkbrrwh56qyk3crj--
