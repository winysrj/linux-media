Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58112 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbbAMV6N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 16:58:13 -0500
Received: from shodan ([217.246.216.149]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0MHoC5-1YByxS1QZp-003hrj for
 <linux-media@vger.kernel.org>; Tue, 13 Jan 2015 22:58:11 +0100
From: Dexter Filmore <Dexter.Filmore@gmx.de>
To: linux-media@vger.kernel.org
Subject: compile only specific module, dkms
Date: Tue, 13 Jan 2015 22:58:06 +0100
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12468971.MEl3J8pHu3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501132258.09156.Dexter.Filmore@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart12468971.MEl3J8pHu3
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all,

I have a Technotrend TT S2-3600 on my debian 7 media center.=20
Debians stock 3.2 kernel would cause panics when talking to the device unle=
ss=20
I compile the LinuxTV module.=20
Alas, debian has a *lot* of kernel upgrades and I'd like to have only my=20
specific module compiled at boot time if it is not there.

I thought maybe manually compile via dkms, but I don't know how to compile=
=20
only one specific set of modules. The 3600 is identical to the pctv452, but=
=20
depends on dvb-usb modules, possibly needs firmware.=20
Pointers appreciated.

Dex


=2D-=20
=2D----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@=20
b++(+++) DI+++ D- G++ e* h>++ r* y?
=2D-----END GEEK CODE BLOCK------

--nextPart12468971.MEl3J8pHu3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlS1lPEACgkQm6TdMk9WhQ2TTACgyVLOJfPARe5q4ERp6rCujyZq
GlgAn2OjTYoWgwnBs7r49AHjnUV8Qog/
=WDI4
-----END PGP SIGNATURE-----

--nextPart12468971.MEl3J8pHu3--
