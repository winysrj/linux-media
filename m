Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:55856 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966339AbcCPKWB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 06:22:01 -0400
Message-ID: <1458123719.2372.12.camel@winder.org.uk>
Subject: Re: Support for WinTV-soloHD
From: Russel Winder <russel@winder.org.uk>
To: DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Wed, 16 Mar 2016 10:21:59 +0000
In-Reply-To: <1457808708.4030.64.camel@winder.org.uk>
References: <1457808708.4030.64.camel@winder.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-wxNdxm10rAm2cag803at"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-wxNdxm10rAm2cag803at
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Question answered: the device works as wanted in the newly released 4.5
kernel on Fedora Rawhide.

On Sat, 2016-03-12 at 18:51 +0000, Russel Winder wrote:
> I plugged a WinTV-soloHD device into my Debian Sid system running:
>=20
> Linux anglides 4.4.0-1-amd64 #1 SMP Debian 4.4.4-2 (2016-03-09)
> x86_64
> GNU/Linux
>=20
> but the device, whilst appearing in the lsusb listing, didn't cause a
> /dev/dvb hierarchy to appear. I am guessing then that the change:
>=20
> http://git.linuxtv.org/media_tree.git/commit/?id=3D1efc21701d94ed0c5b91
> 46
> 7b042bed8b8becd5cc
>=20
> hasn't actually appeared in the 4.4 kernel. Is it in the 4.5 kernel?
>=20
>=20
--=20
Russel.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
Dr Russel Winder      t: +44 20 7585 2200   voip: sip:russel.winder@ekiga.n=
et
41 Buckmaster Road    m: +44 7770 465 077   xmpp: russel@winder.org.uk
London SW11 1EN, UK   w: www.russel.org.uk  skype: russel_winder


--=-wxNdxm10rAm2cag803at
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlbpM8cACgkQ+ooS3F10Be8dXgCdHC3BXqJuTlGixRRZDlLbLIu1
/EAAoJNx0ntkTlzuPwzX4+5lseAJ9xhq
=TOqU
-----END PGP SIGNATURE-----

--=-wxNdxm10rAm2cag803at--

