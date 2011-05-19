Return-path: <mchehab@pedra>
Received: from vms173017pub.verizon.net ([206.46.173.17]:35400 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab1ESDmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 23:42:38 -0400
Received: from gs_laptop.localnet ([unknown] [144.118.151.49])
 by vms173017.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0LLF00K52BMLSS40@vms173017.mailsrvcs.net> for
 linux-media@vger.kernel.org; Wed, 18 May 2011 22:42:21 -0500 (CDT)
From: David Korth <gerbilsoft@verizon.net>
To: linux-media@vger.kernel.org
Subject: em28xx: 240p video modes not working
Date: Wed, 18 May 2011 23:42:15 -0400
MIME-version: 1.0
Content-type: multipart/signed; boundary=nextPart1427058.nLOjJWuCME;
 protocol="application/pgp-signature"; micalg=pgp-sha1
Content-transfer-encoding: 7bit
Message-id: <201105182342.18285.gerbilsoft@verizon.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--nextPart1427058.nLOjJWuCME
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I'm having a problem connecting devices that output "240p" (non-interlaced=
=20
NTSC) on composite video. Specifically, connecting either a Sega Genesis or=
=20
Nintendo N64 to my WinTV HVR-950 results in any V4L2 program hanging while=
=20
playing back the stream. The program starts responding again the instant th=
e=20
240p device is removed.

Is it possible to get 240p input working with the em28xx driver?

Thanks,
=2D David Korth

--nextPart1427058.nLOjJWuCME
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk3UkZoACgkQFI9sMIk8KDH59QCdGk4rVzcpgO8YLn3mjsI+HgX1
2IMAn0biseQllH0LNOsPpoL6BBQsYo92
=p+ma
-----END PGP SIGNATURE-----

--nextPart1427058.nLOjJWuCME--
