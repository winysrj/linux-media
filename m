Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:46260 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750909AbdH2U3V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 16:29:21 -0400
Date: Tue, 29 Aug 2017 22:29:19 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, jacmet@sunsite.dk, jglauber@cavium.com,
        david.daney@cavium.com, hans.verkuil@cisco.com, mchehab@kernel.org,
        awalls@md.metrocast.net, serjk@netup.ru, aospan@netup.ru,
        isely@pobox.com, ezequiel@vanguardiasur.com.ar,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] i2c: busses: make i2c_adapter const
Message-ID: <20170829202919.i2xojjpugdp7s42t@ninjato>
References: <1503138855-585-1-git-send-email-bhumirks@gmail.com>
 <1503138855-585-2-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n6fymlp2tz7n7b7s"
Content-Disposition: inline
In-Reply-To: <1503138855-585-2-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--n6fymlp2tz7n7b7s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 19, 2017 at 04:04:12PM +0530, Bhumika Goyal wrote:
> Make these const as they are only used in a copy operation.
> Done using Coccinelle.
>=20
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Applied to for-next, thanks!


--n6fymlp2tz7n7b7s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlmlzp8ACgkQFA3kzBSg
KbYvag/9HsOSzdpT+L/rJb89uPi+Ja4ZsqjctLM5X5ziZY/c0d17njdESi4TOmL0
xkTU8lKLceSKDgTjaFx5R5/N4pJxgJZaPlUm5kkr9PVfZ7WYPI0ZgkOBQjUSUCZj
1t3pvtMQ18Gc7X4hv/8DxqV3QSpS+uaUOYaEhxSvH2TWT5DZE5dhlIpu9C/PB5Go
t/Q5X48gvIAsP/9X0MoJgRidYR5EQ1gvwItqYrAfNou1fHRhbNaU0Nqwj/fhJhoG
m9g8EW6dxZlIDubRUBeQ6nQ208bTmW/9L5XoNT5M99+og4Or1sekcexh29pNG15r
4XBokh0hRbuuiolMJasghNei0SHJbyGGrU5laXXZhm0gn+qDW0PmzPOjMYOrqJR+
fkmb0TFv0dPwF6043wKvtGbJ1/rUYRMmo/3nsACKVd0Sb767obwTl7WGaEMT1rx2
p2IBaBfIPtEOXVXOJApPgvoZb7cUwMjETwBKUzuZbvATzYUMHDG0c/YYXeYGy8ms
S+FD1gK7Q35ZsPJSWS+MguliyTJ/GlH7tm/kJD/coizahx2PJYTZNQPiBgDEJQL2
3xd9t3HsdZT7DyLLIqpYAR+4OTPqR+15bsFAq7/W4OV9IdjcuaolXpAs/EpxOkCQ
NwUm+vEDNA1cLN1Hu4RXXQEItPaG1wxyol6Lip3subEsiklEGTk=
=cEXF
-----END PGP SIGNATURE-----

--n6fymlp2tz7n7b7s--
