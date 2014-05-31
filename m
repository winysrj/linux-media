Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55182 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaEaRkB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 May 2014 13:40:01 -0400
Received: from shodan ([217.246.204.93]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0MRocn-1XFNRx0rIv-00Sxhv for
 <linux-media@vger.kernel.org>; Sat, 31 May 2014 19:40:00 +0200
From: Dexter Filmore <Dexter.Filmore@gmx.de>
To: linux-media@vger.kernel.org
Subject: auto-compile after reboot / compile only specific driver
Date: Sat, 31 May 2014 19:39:54 +0200
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2916432.d2LuVp2RmT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201405311939.57740.Dexter.Filmore@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart2916432.d2LuVp2RmT
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

on debian 7 or derivates such as ubuntu 12.04/14.04, how can I automtically=
=20
compile the linuxtv drivers against the latest kernel after a kernel update=
=20
came in?

Is DKMS suitable here? Has somebody done it and has instructions?

What if I only have one specific DVB module only anyway, can I configure th=
e=20
src to compile only that?

Cheers

Dex

=2D-=20
=2D----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@=20
b++(+++) DI+++ D- G++ e* h>++ r* y?
=2D-----END GEEK CODE BLOCK------

--nextPart2916432.d2LuVp2RmT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlOKE+0ACgkQm6TdMk9WhQ0DIQCg1+ircRcWkjhhVqQqJpRgzf6F
OwsAoMoVzKF2KQPr7wgu1jNxiwXXHNrs
=N5/5
-----END PGP SIGNATURE-----

--nextPart2916432.d2LuVp2RmT--
