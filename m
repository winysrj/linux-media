Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:55032 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbcBHIqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 03:46:31 -0500
Message-ID: <1454921189.2264.11.camel@winder.org.uk>
Subject: Re: PCTV 292e weirdness
From: Russel Winder <russel@winder.org.uk>
To: Rune Petersen <rune@megahurts.dk>, Antti Palosaari <crope@iki.fi>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Mon, 08 Feb 2016 08:46:29 +0000
In-Reply-To: <56B46E25.7070405@megahurts.dk>
References: <1454523447.1970.15.camel@itzinteractive.com>
	 <56B378F0.6020301@iki.fi> <1454612780.4401.66.camel@itzinteractive.com>
	 <56B46E25.7070405@megahurts.dk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-KSjfkgXFUwoY59lc3GbD"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-KSjfkgXFUwoY59lc3GbD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-02-05 at 10:40 +0100, Rune Petersen wrote:
> (sent email again since I managed to reply only to Russel)
>=20
> I have the same issue - haven't had time to look into it much.
>=20
> the problem is that si2157 & si2168 doesn't resume properly from
> suspend.
>=20
> I have attached 2 patches that disable suspend.
>=20
> What i have found out:
> I can resume the si2157 from suspend by replacing "goto warm" with
> "goto=C2=A0
> skip_fw_download" in si2157_init()
>=20
> I can 'resume' the si2168 from suspend if I set "dev->fw_loaded =3D 0"
> in=C2=A0
> si2168_sleep()

Is there a "building and 'installing' drivers such as this from source"
instruction sheet somewhere?

Is there a repository of the driver code and it's feature branches that
I could clone to work from?

I am entirely happy to try experimenting as long as I do not have to
start building custom kernels.


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


--=-KSjfkgXFUwoY59lc3GbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAla4VeUACgkQ+ooS3F10Be/HjACfciPYi0At1oJ0HiQ141a7N4WU
pdoAn1ZNl0PZ4/b4k5JyGzXN2HErFFHZ
=VaHD
-----END PGP SIGNATURE-----

--=-KSjfkgXFUwoY59lc3GbD--

