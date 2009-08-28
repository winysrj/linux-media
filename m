Return-path: <linux-media-owner@vger.kernel.org>
Received: from b186.blue.fastwebserver.de ([62.141.42.186]:56451 "EHLO
	mail.gw90.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbZH1K4G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 06:56:06 -0400
Subject: Re: Compile modules on 64-bit Linux kernel system for 686 Linux
 kernel
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <20090827085821.39c925f4@pedra.chehab.org>
References: <1251372537.5593.22.camel@mattotaupa.wohnung.familie-menzel.net>
	 <20090827085821.39c925f4@pedra.chehab.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-N0DvV1oVRnzFq1GXGw3N"
Date: Fri, 28 Aug 2009 12:55:58 +0200
Message-Id: <1251456958.7917.22.camel@mattotaupa.wohnung.familie-menzel.net>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-N0DvV1oVRnzFq1GXGw3N
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Mauro,


Am Donnerstag, den 27.08.2009, 08:58 -0300 schrieb Mauro Carvalho Chehab:
> Em Thu, 27 Aug 2009 13:28:57 +0200 Paul Menzel <paulepanter@users.sourcef=
orge.net> escreveu:

> > I am running Debian Sid/unstable with a 32-bit userspace with a 64-bit
> > kernel [1]. I want to compile the v4l-dvb modules for a 686 kernel [2]
> > on this system.
> >=20
> > I installed the header files for the 686 kernel [3], but running
> >=20
> > $ ARCH=3D686 make

[=E2=80=A6]

> > I do not even know if this is the correct way.
> >=20
> > Can someone of you please enlighten me?
>=20
> This is not the correct way. You'll need to also point where do you expec=
t it to get the headers:
> This should do the trick:
> 	make ARCH=3Di386 release DIR=3D<directory_name>
> 	make ARCH=3Di386 allmodconfig
> 	make ARCH=3Di386

Thanks, I should have read INSTALL more carefully. I did

$ make ARCH=3Di686 release VER=3D2.6.30-1-686
$ make ARCH=3Di686 allmodconfig
$ make ARCH=3Di686

which worked like a charm.


Thanks,

Paul

--=-N0DvV1oVRnzFq1GXGw3N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqXt74ACgkQPX1aK2wOHVgO1wCgjM+QHN8EoLLef5YqjIrl2PfI
BaMAnibO8u18N/4vbxmEb6tVtkUdKIZs
=9i9I
-----END PGP SIGNATURE-----

--=-N0DvV1oVRnzFq1GXGw3N--

