Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:40126 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbeGVSfW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Jul 2018 14:35:22 -0400
Date: Sun, 22 Jul 2018 19:37:54 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH -next] regmap: sccb: fix typo and sort headers
 alphabetically
Message-ID: <20180722173753.ckor2rqeqcnfe667@katana>
References: <1532274346-16952-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5xxzovl5lozpz5qj"
Content-Disposition: inline
In-Reply-To: <1532274346-16952-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5xxzovl5lozpz5qj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 23, 2018 at 12:45:46AM +0900, Akinobu Mita wrote:
> Fix typos 's/wit/with/' in the comments and sort headers alphabetically
> in order to avoid duplicate includes in future.
>=20
> Fixes: bcf7eac3d97f ("regmap: add SCCB support")
> Reported-by: Wolfram Sang <wsa@the-dreams.de>

Could this be replaced with (as I did this in my work time):

Reported-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

?

> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Looks good, thanks!

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--5xxzovl5lozpz5qj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAltUwO0ACgkQFA3kzBSg
KbYNTg/7BsB/OjEkWPmeZb6zmaaF37ZesLy+nXLAK3uf5+l5hwHfFh39oJk8vL5w
op43UX4PmRElzAVkdKuwJOlMR8Vq3HVg2ehN6vyih5xOG/dymu7/iAn+pKTUm/Qa
Q9X7cQ5GD5OsY14UIUnxpRyNz5hjJYezCXXf1q9vf19xT4p+OBskaTh3ia4BSkrr
Oi4nSQTBNxsFym6AYu/k09NV/l9lopCm9vj1zRKmY8AM83Jo/lmSAO2vhv+lCavj
zkfGs8tcMym/o7D3WuV2Ryy9CfRgHuE9A1EWoyQsRB9cBKpqmgm10KGx84S2o+ht
HPgHT+mW7zPs6/5p7u2McKDbnMJz42WbM/7QzzBGskKCGAc6uSm+HN7MKRyWzyHo
/1FzVBz6TPu/d/INciETVCVIr+oVI7has/Buxx72WeUBlt3RfNfe2Oe0SkGJFwkQ
TbhEoEjDWLaqD51NsDmuzjyk/7pf9v3cJMBwtVsoOvxreKrd0bkBWzUAhAX0COji
yu7csCyP3fW3faE0HqBABH0t1CyDvaiV+w1MDKvAfM5tfBFQ+UI2SHzqtqCiH8l0
FB7Np+URoEOPGswGysTA3DEXpyrl1Tm9xUEoKVAQNWFREI6w5TNQutSjkRYDfCPE
LHS5sfqfA+cuaUK9GWfYWwQTM6wlPEuAp0oqQhq2F03Ut+PlA4I=
=eXU7
-----END PGP SIGNATURE-----

--5xxzovl5lozpz5qj--
