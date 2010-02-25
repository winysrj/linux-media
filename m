Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:14184
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757474Ab0BYKU1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 05:20:27 -0500
Received: from [192.168.1.106] (helo=hp.purcell.id.au ident=Debian-exim)
	by bristol.purcell.id.au with esmtp (Exim 4.69)
	(envelope-from <msp@debian.org>)
	id 1NkapH-0004Kr-TF
	for linux-media@vger.kernel.org; Thu, 25 Feb 2010 21:20:22 +1100
Received: from mark by hp.purcell.id.au with local (Exim 4.71)
	(envelope-from <msp@debian.org>)
	id 1NkapE-0004wu-VL
	for linux-media@vger.kernel.org; Thu, 25 Feb 2010 21:20:08 +1100
From: Mark Purcell <msp@debian.org>
To: linux-dvb@linuxtv.org
Date: Thu, 25 Feb 2010 21:08:25 +1100
Cc: 540660-forwarded@bugs.debian.org, Hakan Ardo <hakan@debian.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2447162.KsOJeuX6R1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201002252108.25178.msp@debian.org>
Subject: Fwd: Bug#540660: dvb-apps: Missing muxes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart2447162.KsOJeuX6R1
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


=2D---------  Forwarded Message  ----------

Subject: Bug#540660: dvb-apps: Missing muxes
Date: Sunday 09 August 2009
=46rom: Hakan Ardo <hakan@debian.org>
To: Debian Bug Tracking System <submit@bugs.debian.org>

Package: dvb-apps
Version: 1.1.1+rev1207-3
Severity: normal

Hi,
there are two muxes missing in dvb-t/se-Horby_Sallerup. Please add:

T 650000000 8MHz 3/4 NONE QAM64 8k 1/4 NONE
T 570000000 8MHz 3/4 NONE QAM64 8k 1/4 NONE


  Tahnx



# diff -c /usr/share/dvb/dvb-t/se-Horby_Sallerup se-Horby_Sallerup
*** /usr/share/dvb/dvb-t/se-Horby_Sallerup	2008-09-05
11:52:04.000000000 +0200
=2D-- se-Horby_Sallerup	2009-08-09 15:18:16.000000000 +0200
***************
*** 1,5 ****
=2D-- 1,7 ----
  # Sweden - H=C3=B6rby/Sallerup
  # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+ T 650000000 8MHz 3/4 NONE QAM64 8k 1/4 NONE
+ T 570000000 8MHz 3/4 NONE QAM64 8k 1/4 NONE
  T 482000000 8MHz 3/4 NONE QAM64 8k 1/4 NONE
  T 506000000 8MHz 3/4 NONE QAM64 8k 1/4 NONE
  T 634000000 8MHz 3/4 NONE QAM64 8k 1/4 NONE


=2D- System Information:
Debian Release: 3.1
  APT prefers stable
  APT policy: (990, 'stable')
Architecture: i386 (i686)

Kernel: Linux 2.6.26-1-686 (SMP w/1 CPU core)
Locale: LANG=3Den_US, LC_CTYPE=3Den_US (charmap=3DISO-8859-1)
Shell: /bin/sh linked to /bin/bash

Versions of packages dvb-apps depends on:
ii  libc6                         2.7-14     GNU C Library: Shared libraries
ii  makedev                       2.3.1-82   creates device files in /dev
ii  udev                          0.093-1    /dev/ and hotplug management d=
aemo

dvb-apps recommends no packages.

=2D- no debconf information





=2D------------------------------------------------------

--nextPart2447162.KsOJeuX6R1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkuGTBkACgkQoCzanz0IthL14gCffmk/c9juubr4OV5LjYVVnvIB
MjgAnROFqCAXWclyITDg9jN4r49R02UP
=i12x
-----END PGP SIGNATURE-----

--nextPart2447162.KsOJeuX6R1--

