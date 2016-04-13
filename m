Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:38528 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbcDMPk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 11:40:58 -0400
Message-ID: <1460562055.28492.27.camel@winder.org.uk>
Subject: Re: libdvbv5 licencing
From: Russel Winder <russel@winder.org.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: DVB_Linux_Media <linux-media@vger.kernel.org>,
	Sebastian =?ISO-8859-1?Q?Dr=F6ge?= <slomo@coaxion.net>
Date: Wed, 13 Apr 2016 16:40:55 +0100
In-Reply-To: <20160412111945.22846572@recife.lan>
References: <1458972788.3344.8.camel@winder.org.uk>
	 <20160412111945.22846572@recife.lan>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-A0TYphfyfHSF1GbmZ+ey"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-A0TYphfyfHSF1GbmZ+ey
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-04-12 at 11:19 -0300, Mauro Carvalho Chehab wrote:
[=E2=80=A6]

> Yes. We had some discussions in the past to re-license it to LGPL,
> if this is going to be used by some other OSS project that would
> require that. Most of the code was written by me, and, in the past
> the other developers that worked on that also agreed on re-licensing
> as LGPL.
>=20
> So, basically, if gstreamer is willing to use libdvbv5, we'll
> relicense it to LGPL.

I have volunteered to rewrite the DVB plugin for GStreamer and proposed
use of libdvbv5, a proposal which was stated as being entirely
acceptable, but only if libdvbv5 was LGPL. So if libdvbv5 becomes an
LGPL library, my rewrite of the GStreamer DVB plugin will certainly use
it. I will then put forward my rewrite for incorporation into the
GStreamer bad plugins (seriously misnamed library, but=E2=80=A6).
=C2=A0
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


--=-A0TYphfyfHSF1GbmZ+ey
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXDmiHAAoJENS91dLOzae4TJMP/RnsqXRD5XTio7D63X/xm6s6
8WE8zE1nkEgTgYmwOXNytDak+onxfDj2J9PIIcQ30rdjc/BgsA1t7zaNE5MvrDXz
jfl2rPXbDoZW6O+jpgeYFagKITgqYLwgpc4/XLo91zRsGBo3V6wPuKGZahlimorF
QVYKe86cm0zTsTgD3J1SpVMNs3Djrteo68NrkoY9dvIwQFvj5Pxj7lIA3mJLjxTu
qBH82KV7TsXsEcqutRl3bhsfqDCB4/0Ur7YxNJrUQE4Axpt5HNEcjtJLYpSwF+46
N0XJDgXT0S4vZZMhhEL+R2J3vdJMnnENlW6TbqkLpbRWnq+cSqc159QgxLByqTEJ
8vsmH2Eu3M7TuKcJ3fKAqdBJEDPx0gXDObyauz3TSDfEGrBh2Kok7HPBW9j7lQoS
0M00wwf5X5PGUfe4SAVEPIwG6qWGGlLCIKvFt+ujz5ZM8G7FnvAzCJvvP8QJVmwc
hfRWLmtY+CYwToEnQs1qmo1H9mPjWciKJNlwpZG9JN4OYoHWahGgFmd11K8h24U6
gy854JP/2QL6//niMcwtxn1bqFPlaDWMNYvx+dG037o86G0YjlV0fOOtqDPv8mf9
mYeTz7pGHPL13TLfLl4QiRi8V2EQJUdgSNnWGHyd6NL3nyFjfN105ZYFm0gVG/Kr
pdOde0YUPF7V3xM2Zzk4
=HbAM
-----END PGP SIGNATURE-----

--=-A0TYphfyfHSF1GbmZ+ey--

