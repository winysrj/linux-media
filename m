Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:46889 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbcBGWIN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2016 17:08:13 -0500
Date: Sun, 7 Feb 2016 23:08:05 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-sh@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] soc_camera: cleanup control device on async_unbind
Message-ID: <20160207220805.GA2453@tetsubishi>
References: <1451911723-10868-1-git-send-email-wsa@the-dreams.de>
 <20160207132307.GC3717@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20160207132307.GC3717@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > This gets fixed by clearing the control device pointer on async_unbind.
> >
> > Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
>=20
> Tested-by: Niklas S=C3=B6derlund <niklas.soderlund@ragnatech.se>
>=20
> Tested on Koelsch and the camera works fine after a unbind/bind
> operation.

Thanks a lot, Niklas!


--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWt8BFAAoJEBQN5MwUoCm2fcQP/AmNVNaf+RPXT+AwT7DkQyim
CVz8PoJspZ0eVcAAlMT1mJE5coT4Fz8fnsMC0uG48zKmr6UgxMw9eluCVJuwNWgl
cYk88YvkgiHp9WMvTDZwDte1PerKDF/QbVuzCihJmRnF07tKhed5ujCpeorenJ8G
aVewsPas6v5k4BM8vUO9A9CK5nJsB0UJjDHdpaS6MxBWVHY284em9UXPWuViZpjw
c3bq72wRgCEvuV9Wtqs5dU4xa1zMpn4gytdcUq2f/3+l/uvza5aETF0tbdi6euQO
kEyPHAxo5gJ5NdkPxHqHn8NqPcBReG/GMFXRsA8Mlg4vK+ht5dajyBFz3eg44j13
Nh8LLvHpoVeu9uzEsk1G6mZvJjFFd4vmccbMjEkc/RzlilRa24XPVLlwPPtn+mwd
LomZj9W1dOMKqgk+pb0uiKKrW73b5xjAhwvvNmHF1YHzS/ZJDMCLqWzXw1Wmc6ng
NWULxQcMYLZNvbmNpIAm2JWJdYvfJGHdfVMWaqQ2kZAGtaXFrLHQJRi3EeZ8Jo+O
0k/tCp5sVKUYqYt8UWDx5tik+Tx9pMMx2QDMlGrKCy4shhErsNp0U8XL4Iw+QmPV
bnTGu2VAG0HL4zgNm0v0eo3hRWhhGhGC8aPspdfanhs2WhsTirZyrmn0uOBT8yVC
Q+U8MgfIlKZ5H4t8qPBE
=aIbv
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
