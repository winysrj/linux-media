Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38808 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729192AbeKDUpQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2018 15:45:16 -0500
Date: Sun, 4 Nov 2018 12:30:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] [media] ov7670: make "xclk" clock optional
Message-ID: <20181104113020.GC23864@amd>
References: <20181004212903.364064-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YD3LsXFS42OYHhNZ"
Content-Disposition: inline
In-Reply-To: <20181004212903.364064-1-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--YD3LsXFS42OYHhNZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2018-10-04 23:29:03, Lubomir Rintel wrote:
> When the "xclk" clock was added, it was made mandatory. This broke the
> driver on an OLPC plaform which doesn't know such clock. Make it
> optional.
>=20
> Tested on a OLPC XO-1 laptop.
>=20
> Cc: stable@vger.kernel.org # 4.11+
> Fixes: 0a024d634cee ("[media] ov7670: get xclk")
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

Acked-by: Pavel Machek <pavel@ucw.cz>


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--YD3LsXFS42OYHhNZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlve2EwACgkQMOfwapXb+vJUoACggV8Bt3YYgpmk12LMOFZdpQMU
KjcAniYg8eHKa/6CTmo38vhfmboXh67A
=uEmp
-----END PGP SIGNATURE-----

--YD3LsXFS42OYHhNZ--
