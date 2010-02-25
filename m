Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:18401
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758450Ab0BYKaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 05:30:12 -0500
Received: from [192.168.1.106] (helo=hp.purcell.id.au ident=Debian-exim)
	by bristol.purcell.id.au with esmtp (Exim 4.69)
	(envelope-from <msp@debian.org>)
	id 1Nkapo-0004Ky-VV
	for linux-media@vger.kernel.org; Thu, 25 Feb 2010 21:20:48 +1100
Received: from mark by hp.purcell.id.au with local (Exim 4.71)
	(envelope-from <msp@debian.org>)
	id 1Nkapm-0004xZ-2v
	for linux-media@vger.kernel.org; Thu, 25 Feb 2010 21:20:42 +1100
From: Mark Purcell <msp@debian.org>
To: linux-dvb@linuxtv.org
Date: Thu, 25 Feb 2010 21:09:36 +1100
Cc: 566336-forwarded@bugs.debian.org,
	Danai SAE-HAN (=E9=9F=93=E9=81=94=E8=80=90) <danai@debian.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3621302.VIntMhxQBG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201002252109.36680.msp@debian.org>
Subject: Fwd: Bug#566336: dvb-apps: be-Schoten and be-Antwerp run on 506MHz
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart3621302.VIntMhxQBG
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


=2D---------  Forwarded Message  ----------

Subject: Bug#566336: dvb-apps: be-Schoten and be-Antwerp run on 506MHz
Date: Saturday 23 January 2010
=46rom: Danai SAE-HAN  (=3DE9=3D9F=3D93=3DE9=3D81=3D94=3DE8=3D80=3D90) <dan=
ai@debian.org>
To: submit@bugs.debian.org

Package: dvb-apps
Version: 1.1.1+rev1273-1
Severity: minor


Hi

The file be-Schoten currently has a frequency of 778MHz, but it should
be 506MHz.
Also, there is another broadcaster in Antwerp, so could you also add a
file called
be-Antwerp with frequency 506MHz?

Source (in Dutch): http://nl.wikipedia.org/wiki/DVB-T-frequenties

Cheers


=2D-=20
Danai


=2D- System Information:
Debian Release: squeeze/sid
  APT prefers unstable
  APT policy: (500, 'unstable')
Architecture: i386 (i686)

Kernel: Linux 2.6.32-trunk-686-bigmem (SMP w/2 CPU cores)
Locale: LANG=3Den_GB.UTF-8, LC_CTYPE=3Den_GB.UTF-8 (charmap=3DUTF-8)
Shell: /bin/sh linked to /bin/dash

Versions of packages dvb-apps depends on:
ii  libc6                         2.10.2-5   Embedded GNU C Library: Shared=
 lib
ii  makedev                       2.3.1-89   creates device files in /dev
ii  udev                          150-2      /dev/ and hotplug management d=
aemo

dvb-apps recommends no packages.

dvb-apps suggests no packages.

=2D- no debconf information





=2D------------------------------------------------------

--nextPart3621302.VIntMhxQBG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkuGTGAACgkQoCzanz0IthL9RACghzHiwQ4jDxLQqieqao3mnjJa
CxUAn000ThsAB/O6R/tR2utPH5a2G7Hs
=yRDY
-----END PGP SIGNATURE-----

--nextPart3621302.VIntMhxQBG--

