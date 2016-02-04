Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:42864 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965225AbcBDTGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 14:06:34 -0500
Message-ID: <1454612780.4401.66.camel@itzinteractive.com>
Subject: Re: PCTV 292e weirdness
From: Russel Winder <russel@itzinteractive.com>
To: Antti Palosaari <crope@iki.fi>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Thu, 04 Feb 2016 19:06:20 +0000
In-Reply-To: <56B378F0.6020301@iki.fi>
References: <1454523447.1970.15.camel@itzinteractive.com>
	 <56B378F0.6020301@iki.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1GqzS7Q5YUqBr/7NPmyd"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-1GqzS7Q5YUqBr/7NPmyd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-02-04 at 18:14 +0200, Antti Palosaari wrote:
[=E2=80=A6]
>=20
> Are you using DVB-T, T2 or C? I quickly tested T and T2 with dvbv5-
> zap=C2=A0
> and it worked (kernel media 4.5.0-rc1+).

Definitely T and T2. I had been assuming dvbv5-zap switched mode based
on the entry in the virtual channel file. In this case "BBC NEWS" is in
a T multiplex.

> PCTV 282e seems to be dibcom based DVB-T only device, so you are
> using=C2=A0
> DVB-T?

Yes, 282e is T only, ditto Terratec XXS. I haven't been able to get
anything working with WinTVSoloHD or WinTVdualHD as yet.

--=20
Russel.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
Dr Russel Winder       Director
It'z Interactive Ltd   t: +44 20 7585 2200        voip: sip:russel.winder@e=
kiga.net
41 Buckmaster Road     m: +44 7770 465 077        xmpp: russel@winder.org.u=
k
London SW11 1EN, UK    w: www.itzinteractive.com  skype: russel_winder


--=-1GqzS7Q5YUqBr/7NPmyd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlazoSwACgkQSN8tueOZ0k5sKQCg0o9pmPy/W96KYRPtB4B8JK2J
PvUAnif+49ANDdabgM9xlmNaindMXV4x
=qO7R
-----END PGP SIGNATURE-----

--=-1GqzS7Q5YUqBr/7NPmyd--

