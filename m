Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:45565 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752799AbeA3Pl3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 10:41:29 -0500
Date: Tue, 30 Jan 2018 16:41:26 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Benoit Parrot <bparrot@ti.com>, Simon Hatliff <hatliff@cadence.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, nm@ti.com
Subject: Re: [PATCH v5 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Message-ID: <20180130154126.keytdulix5imq6b3@flea.lan>
References: <20180119081357.20799-1-maxime.ripard@free-electrons.com>
 <20180119081357.20799-3-maxime.ripard@free-electrons.com>
 <20180129191036.GE25980@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pkhuki3st7u2jpzf"
Content-Disposition: inline
In-Reply-To: <20180129191036.GE25980@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pkhuki3st7u2jpzf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Benoit,

On Mon, Jan 29, 2018 at 01:10:36PM -0600, Benoit Parrot wrote:
> > +	reg =3D csi2rx->num_lanes << 8;
> > +	for (i =3D 0; i < csi2rx->num_lanes; i++)
> > +		reg |=3D CSI2RX_STATIC_CFG_DLANE_MAP(i, csi2rx->lanes[i]);
> > +
> > +	for (i =3D csi2rx->num_lanes; i < csi2rx->max_lanes; i++)
> > +		reg |=3D CSI2RX_STATIC_CFG_DLANE_MAP(i, i + 1);
>=20
> Not sure why the above init loop is needed, but at any rate it could
> cause lane number collision. As far as I can see the MIPI spec does
> not require data lane to be consecutive or starting at a specific
> physical lane number.

I should probably add a comment there, but the hardware needs the data
lanes to have a mapping even though they are not in use. This was
addressing this behaviour but...

> Based on that the following DT node could be a valid configuration
> 	csi2_cam0: endpoint {
> 		clock-lanes =3D <0>;
> 		data-lanes =3D <2 3>;
> 		...
> 	};

I obviously overlooked a few corner cases :)

Since the lanes are not in use, I'm not sure we have to worry about
lanes collision. Simon, would it cause any trouble if we map to lanes
to the same physical lane?

Thanks!
maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--pkhuki3st7u2jpzf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpwkiYACgkQ0rTAlCFN
r3REZA//anq9dIomRL4bguGYU/PMo8r+BeTm3KPx+geLhyqmwnsHjni51KthdVlE
U+G2FOlAXiVUFO04oFffSppALiSeUhGcVzghVLa2SAKydGimWfDg5QHJAWwzge73
Fp9mvdDqowAKikd38PhqDEImrfD858MOeiEn9QYm9C3jL0dJliuSFxq04+BMW743
tEor9L4Jyl62ZrDfTT85jQNfmqe1qdSq9KGGiIx/SbeyAbKog/Ghym2XcwWBC/s7
KpxXOf6wcL4IbkaukI78SjYFzvZ+z+wXXJMUULTEjv/Q0TqXbrV61X5kGCydYNxU
EkeoHIaUdHd9BJxdM0LqGEts9uhBcJwQaklNwwRFY+JlWl14iR5oEOt7m+JVB/g+
Gnfs2TogM27X9FlEpezuemHOALtorUlaDiShuCsLDtxPE5lwxaq+G+xlYnekfX8p
DNsFhWpZp/otC9iGJ58LPfuppNeZaZ6lQ5xV2pbKVmgdBeCfk8nsVp/zfKha0QDE
OhS5I4tjPfo8pbl0XeFTIRx+fURzTibAoSU8v2oJZSOaxYR7Lo+NRRXpxT6vfAy6
wn5W0lDoOBFT+QQdjx7fBTZuwDtbQFKPDHCWRR94M2eJ+rJOpvl08luBrC21nsJR
ZZSshZyoVnNpvb9qaAL8dGraEktAOrrXG9cFYDgXWCo4zs4ZxrM=
=CWmJ
-----END PGP SIGNATURE-----

--pkhuki3st7u2jpzf--
