Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57031 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbbE1BIn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 21:08:43 -0400
Received: from shodan ([217.246.205.108]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0LevUh-1ZTW220Uwx-00qibm for
 <linux-media@vger.kernel.org>; Thu, 28 May 2015 03:08:41 +0200
From: Dexter Filmore <Dexter.Filmore@gmx.de>
To: linux-media@vger.kernel.org
Subject: media build error
Date: Thu, 28 May 2015 03:07:27 +0200
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1643610.5ktDgXLfA5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201505280307.41042.Dexter.Filmore@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1643610.5ktDgXLfA5
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

deb7, Debian 3.2.68-1+deb7u1 x86_64 GNU/Linux

  CC=20
[M]  /home/dexter/software/linuxtv-current/media_build/v4l/media-devnode.o
  CC [M]  /home/dexter/software/linuxtv-current/media_build/v4l/media-entit=
y.o
  CC=20
[M]  /home/dexter/software/linuxtv-current/media_build/v4l/msp3400-driver.o
  CC=20
[M]  /home/dexter/software/linuxtv-current/media_build/v4l/msp3400-kthreads=
=2Eo
  CC [M]  /home/dexter/software/linuxtv-current/media_build/v4l/ngene-core.o
  CC [M]  /home/dexter/software/linuxtv-current/media_build/v4l/ngene-i2c.o
  CC [M]  /home/dexter/software/linuxtv-current/media_build/v4l/ngene-cards=
=2Eo
  CC [M]  /home/dexter/software/linuxtv-current/media_build/v4l/ngene-dvb.o
  CC [M]  /home/dexter/software/linuxtv-current/media_build/v4l/pd-video.o
/home/dexter/software/linuxtv-current/media_build/v4l/pd-video.c:1450:2:=20
error: unknown field 'ioctl' specified in initializer
/home/dexter/software/linuxtv-current/media_build/v4l/pd-video.c:1450:2:=20
warning: initialization from incompatible pointer type [enabled by default]
/home/dexter/software/linuxtv-current/media_build/v4l/pd-video.c:1450:2:=20
warning: (near initialization for 'pd_video_fops.open') [enabled by default]
make[5]: ***=20
[/home/dexter/software/linuxtv-current/media_build/v4l/pd-video.o] Fehler 1
make[4]: *** [_module_/home/dexter/software/linuxtv-current/media_build/v4l=
]=20
=46ehler 2
make[3]: *** [sub-make] Error 2
make[2]: *** [all] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-3.2.0-4-amd64'
make[1]: *** [default] Fehler 2
make[1]: Leaving directory=20
`/home/dexter/software/linuxtv-current/media_build/v4l'
make: *** [all] Fehler 2
build failed at ./build line 491.


=2D-=20
=2D----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@=20
b++(+++) DI+++ D- G++ e* h>++ r* y?
=2D-----END GEEK CODE BLOCK------

--nextPart1643610.5ktDgXLfA5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlVmal0ACgkQm6TdMk9WhQ3S2wCeO5U3D3IAvGYgydcVSZVj2k2d
mXkAnRvsLE6c3PSXXsz6kDjbRNsNCDoq
=GKPZ
-----END PGP SIGNATURE-----

--nextPart1643610.5ktDgXLfA5--
