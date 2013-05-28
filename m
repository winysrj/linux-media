Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52286 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758675Ab3E1C6e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 May 2013 22:58:34 -0400
Message-ID: <1369709900.3469.418.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH stable < v3.7] media mantis: fix silly crash case
From: Ben Hutchings <ben@decadent.org.uk>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: stable@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Alan Cox <alan@linux.intel.com>
Date: Tue, 28 May 2013 03:58:20 +0100
In-Reply-To: <87ehd0lbwo.fsf@nemi.mork.no>
References: <87ehd0lbwo.fsf@nemi.mork.no>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rfPh3NJRJKJMXTVqRkH2"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-rfPh3NJRJKJMXTVqRkH2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-05-21 at 15:07 +0200, Bj=C3=B8rn Mork wrote:
> Hello,
>=20
> Please apply mainline commit e1d45ae to any maintained stable kernel
> prior to v3.7.  I just hit this bug on a Debian 3.2.41-2+deb7u2 kernel:
[...]

Queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-rfPh3NJRJKJMXTVqRkH2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUaQdTOe/yOyVhhEJAQoa/w/+OCmyXhLB52f5jWaBRmueyW/efWbf3Mnl
BoC6a5w+OWwIdJqIwH9gSZ8y4MliqvjqcujqReBtBj8Vp0OVRqdOT7p51VQVwzZJ
TAlbGNhI7cKT8axJxX+GSUycdO7uz7oP+wkEP4XJeHHGI/TuL0wajrToyGBAaDyo
21XSJYKYMQbFFAzcZ4u61C9EnSgAuY1rLDYyqXZsoAdji42dHgYkTW4xc4l8WRHU
IM/KZcI/BZ5amkDabBMyT15iRokW4zLhz5bED4E1h9kyLaqMGKMTit8RC127TCf4
z2U18kQ+NLY4oel4e47QtDBqYfBGW/ks3rB6pGgMEGUT5Lhnh0Ke0pViAHkNyGs1
BKHovTzF7D4b7ucJWsX4gp/Rm/VK3FgG4gD9eOaa0jzEMJ58dxcCEF6kggffMBxv
p96ppewhumfO3NTNscqBzSaV4e0oZ52pJrT6V0YLJuWoYl4iPv6g0xYDjHvG5nTo
ySODF2RUC10u4jvt75WYBxbx9nbE7M7M0KNZEQu+ATh2TtxaZmnbaL2HF6QZRXRz
hVv5MZ8HkAXV7R5KS79rRNxEabAqJTvGlVhLkcgpSEc2HiMZiifFPyPGMT+IjIhC
jE7GkroTKEho3GqrYbGciISwlUGy3184UrXh/euUdADgjPWl1/WUZ/TkwyAgOEPW
2xXQ9y12ovg=
=/cbA
-----END PGP SIGNATURE-----

--=-rfPh3NJRJKJMXTVqRkH2--
