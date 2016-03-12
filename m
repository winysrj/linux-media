Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:59278 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbcCLSvv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2016 13:51:51 -0500
Message-ID: <1457808708.4030.64.camel@winder.org.uk>
Subject: Support for WinTV-soloHD
From: Russel Winder <russel@winder.org.uk>
To: DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Sat, 12 Mar 2016 18:51:48 +0000
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ROsJV7IU4s7RSLRZPbYG"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ROsJV7IU4s7RSLRZPbYG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I plugged a WinTV-soloHD device into my Debian Sid system running:

Linux anglides 4.4.0-1-amd64 #1 SMP Debian 4.4.4-2 (2016-03-09) x86_64
GNU/Linux

but the device, whilst appearing in the lsusb listing, didn't cause a
/dev/dvb hierarchy to appear. I am guessing then that the change:

http://git.linuxtv.org/media_tree.git/commit/?id=3D1efc21701d94ed0c5b9146
7b042bed8b8becd5cc

hasn't actually appeared in the 4.4 kernel. Is it in the 4.5 kernel?


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


--=-ROsJV7IU4s7RSLRZPbYG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlbkZUQACgkQ+ooS3F10Be/T2gCdG2aBz7Z72JAuS/AK+K/jsjYx
Na8Ani36Nh1nKCqrSjzvKUHdJdLOJVGc
=NfT1
-----END PGP SIGNATURE-----

--=-ROsJV7IU4s7RSLRZPbYG--

