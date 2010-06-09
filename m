Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53061 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0FIPFr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jun 2010 11:05:47 -0400
Date: Wed, 9 Jun 2010 17:05:40 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 2/2] V4L/DVB: Use custom I2C probing function mechanism
Message-ID: <20100609150540.GB31319@pengutronix.de>
References: <20100608100100.35bdae0f@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <20100608100100.35bdae0f@hyperion.delvare>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Tue, Jun 08, 2010 at 10:01:00AM +0200, Jean Delvare wrote:
> Now that i2c-core offers the possibility to provide custom probing
> function for I2C devices, let's make use of it.
>=20
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

If this custom function is in i2c-core, maybe it should be documented?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwPrcQACgkQD27XaX1/VRsFPwCeO8IsKaTaYK3IX64plFZLWlHP
cQkAoKJDh6HAmgUvjoDo53oCF43aHJEv
=5lP5
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
