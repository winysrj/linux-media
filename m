Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:49365 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757746AbdJMLi2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 07:38:28 -0400
Date: Fri, 13 Oct 2017 13:38:26 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Benoit Parrot <bparrot@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, nm@ti.com
Subject: Re: [PATCH 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Message-ID: <20171013113826.65x26y7g4reofowl@flea.lan>
References: <20170922114703.30511-1-maxime.ripard@free-electrons.com>
 <20170922114703.30511-3-maxime.ripard@free-electrons.com>
 <20170929182125.GB3163@ti.com>
 <20171011115544.w7eswyhke6dskgbb@flea>
 <20171011133639.GC25400@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4z2ec5jlfufdvmms"
Content-Disposition: inline
In-Reply-To: <20171011133639.GC25400@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4z2ec5jlfufdvmms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 11, 2017 at 01:36:39PM +0000, Benoit Parrot wrote:
> > > > +		/*
> > > > +		 * We use the stream ID there, but it's wrong.
> > > > +		 *
> > > > +		 * A stream could very well send a data type that is
> > > > +		 * not equal to its stream ID. We need to find a
> > > > +		 * proper way to address it.
> > > > +		 */
> > >=20
> > > I don't quite get the above comment, from the code below it looks like
> > > you are using the current fmt as a source to provide the correct DT.
> > > Am I missing soemthing?
> >=20
> > Yes, so far the datatype is inferred from the format set. Is there
> > anything wrong with that?
>=20
> No, nothing wrong with that behavior it just doesn't not match the comment
> above, where it is says that the DT is set to the stream ID...

As explained in the cover letter, you actually have two datatypes, the
input one that is in the 0-8 range, which is then mapped through that
register to a MIPI-CSI2 datatype. The comment refers to the input
datatype, not the CSI's.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--4z2ec5jlfufdvmms
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZ4KWyAAoJEBx+YmzsjxAgxfEP/2IYBbnv/X9f/WESi1nMV1zd
RSK8/3weIPR1BzWLh0ZzPnASwJTvmWrF84EIgFj6JWISas37SNq/PD3ZRJwWAY5i
hQe9siB+OyVTH6yKFm+S+YnhtPzUdp/OdUc3inhtKbL2oHhj2aZfxVroxVhmhlJF
sQuB6qySmk2p7Xtq3/q2DOlc4awQm3rt+kp+cV4kMvaocfsIJ/RPltDHoB97W+42
cIbP56MNmpl81I//EsbMGs2UNUrUkL1uGsHeO09uqxGCp3VK9VXLvUzM5ilLRQ1z
MLptew1ZPfe/Lt8Jnna9BKkUUWv7AtoSPluT3et0Qz+wao6lznqA+VePHQD/YAMH
SH4k13nldqLA1TMx8GYN2GM9AeRDjivWiQsQhQs4VPT/fzbvVBAt9tDA1cBpuBm6
NmHtPdGmNXznqVtcqzCXi203THNw9JetO0HN5vccarp3XsUyj529b+hjhAx1Yb5v
4SeE7C+gxxPcW3MKQrkr5TywjZP+IjMXJAe1xGOrsaOC42jLLlWZeFyM1SiHqEFq
gqjYa2o/NINl4YjxC7CmvhLDIjOztxCX/wDgI/DJgizXsYNB4b+2apud4l89+XhF
R3IzBgEbqZ8aFT/urPTh4iBXKQETIKt7GV7TAVXbB1F/qY9coNbPl+PlG+PBkYGi
oqsNiEkt2RagAa+agnge
=HeW6
-----END PGP SIGNATURE-----

--4z2ec5jlfufdvmms--
