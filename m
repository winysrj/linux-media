Return-path: <linux-media-owner@vger.kernel.org>
Received: from ring0.de ([91.143.88.219]:39541 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab2HPLn4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 07:43:56 -0400
Date: Thu, 16 Aug 2012 13:21:04 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Timo Kokkonen <timo.t.kokkonen@iki.fi>
Subject: Re: [git:v4l-dvb/for_v3.7] [media] media: rc: Introduce RX51 IR
 transmitter driver
Message-ID: <20120816112103.GA1429@earth.universe>
References: <E1T10iu-0000Xo-L8@www.linuxtv.org>
 <20120815160621.GV29636@valkosipuli.retiisi.org.uk>
 <502BFCA3.5040905@iki.fi>
 <20120816102328.GW29636@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20120816102328.GW29636@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> > It was an requirement back then that this driver needs to be a module as
> > 99% of the N900 owners still don't even know they have this kind of
> > capability on their devices, so it doesn't make sense to keep the module
> > loaded unless the user actually needs it.
>=20
> I don't think that's so important --- currently the vast majority of the
> N900 users using the mainline kernel compile it themselves. It's more
> important to have a clean implementation at this point.

I would like to enable this feature for the Debian OMAP kernel,
which is not only used for N900, but also for Pandaboard, etc.

-- Sebastian

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQLNefAAoJENju1/PIO/qa9qoP+wR3iLyJ516w08aAuagLuajR
/o2djTYUIHkhJ1D2Z7jSnN5rQTvrLVZG31KS+ytxf16zzRzVCmoeK20ReYSBAcBY
j8Ebutps9CHLHmwf3ca/5w4/O5FUL1s1NuOLV/ztKT9whRamzeDfOhwqkesKDdCK
7H6xjB/SRB8iwQpW5wdemVaZU9QSdBfhBZ4i1EkUgsYcmQversZLAas8J32BygLP
ENzz/3y17aVi7Muw0xf3EBU13bgOHiRO4ZktzlK1+ErwlK4wOh4fnVNqmP4NkLyz
R4CcYQQXyO/4ZK6M3nKm6pID/v23b5ocTrNprm+XhcLqs1wxArDKD3J26Yxpov4Q
BDeHVzUKWJfLJCjhAkCPIfB6DyZR//M94XJ74p1SQKc7aBAVGiu58yE5k7HlnCjQ
LS/20BQtVIXJKfCpbtVVpSYEqcUUjbIkxfGU3isNh+oJT305T4hbLkcR5Td31O8w
2bcqY4sOsChGXJ7VdYgddDX1fAgBuyFjZDmU/cKixTWW5sstS4K3IkMfWa1j9YPy
MDBMm6x9LkyqFcjtblIDsSdR16HQ993IB9A/HPqcYZOdTwtSeRwxAoCDjShKmv4O
lbTkE/TkvIKvD+RfNrWonCGdXkls/0+camSmRs2PGI/hbGKtdTxXPSb4e6inlhLD
sXvXF6/nnDppPyftTS+f
=XXqc
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
