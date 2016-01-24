Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:52176 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbcAXF6A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 00:58:00 -0500
Message-ID: <1453615078.2497.29.camel@winder.org.uk>
Subject: Re: SV: PCTV 292e support
From: Russel Winder <russel@winder.org.uk>
To: Peter =?ISO-8859-1?Q?F=E4ssberg?= <pf@leissner.se>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Sun, 24 Jan 2016 05:57:58 +0000
In-Reply-To: <ijvkgaod4jhqyaoroevcea7f.1453613737402@email.android.com>
References: <1453613292.2497.26.camel@winder.org.uk>
	 <ijvkgaod4jhqyaoroevcea7f.1453613737402@email.android.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-oa3PUUfBzxoYJoqkiWwG"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-oa3PUUfBzxoYJoqkiWwG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2016-01-24 at 05:35 +0000, Peter F=C3=A4ssberg wrote:
> You have probably not installed the firmware.
>=20
> Check the kernel log (dmesg) and you will find an error and the name
> of the missing file.

Hummm=E2=80=A6 Spot on. Now I just feel stupid :-)

[62987.648972] si2168 2-0064: found a 'Silicon Labs Si2168-B40'
[62987.649462] si2168 2-0064: firmware: failed to load dvb-demod-si2168-b40=
-01.fw (-2)
[62987.649467] si2168 2-0064: Direct firmware load for dvb-demod-si2168-b40=
-01.fw failed with error -2

=46rom what I can tell neither Debian nor Fedora have package with this
firmware. Unless I am just missing it. If this is the case should they
be packaged?

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


--=-oa3PUUfBzxoYJoqkiWwG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlakZ+YACgkQ+ooS3F10Be+ZnwCgw45nm+IKMSF9eRaIJ3HfQcNl
TzAAnAt58k42IR0KBkir1r17OwOFRLTv
=9ohM
-----END PGP SIGNATURE-----

--=-oa3PUUfBzxoYJoqkiWwG--

