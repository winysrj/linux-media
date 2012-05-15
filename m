Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:39485 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143Ab2EOOZt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 10:25:49 -0400
Date: Tue, 15 May 2012 16:25:32 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: gennarone@gmail.com
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [PATCH] media_build: add fixp-arith.h in linux/include/linux
Message-Id: <20120515162532.81fe775d3e332df9c950bea6@studenti.unina.it>
In-Reply-To: <4FB25B93.6080508@gmail.com>
References: <1337087801-31527-1-git-send-email-gennarone@gmail.com>
	<4FB2593B.3030402@redhat.com>
	<4FB25B93.6080508@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_May_2012_16_25_32_+0200_m0NLX7_2pDWIwpzK"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Tue__15_May_2012_16_25_32_+0200_m0NLX7_2pDWIwpzK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 15 May 2012 15:35:15 +0200
Gianluca Gennari <gennarone@gmail.com> wrote:

> Il 15/05/2012 15:25, Mauro Carvalho Chehab ha scritto:
> > Em 15-05-2012 10:16, Gianluca Gennari escreveu:
> >> This patch:
> >> http://patchwork.linuxtv.org/patch/10824/
> >> moved the file fixp-arith.h from drivers/input/ to include/linux/ .
> >>
> >> To make this file available to old kernels, we must include it in the
> >> media_build package.
> >>
> >> The version included here comes from kernel 3.4-rc7.
> >>
> >> This patch corrects the following build error:
> >>
> >> media_build/v4l/ov534.c:38:30: error: linux/fixp-arith.h: No such file=
 or directory
> >> media_build/v4l/ov534.c: In function 'sethue':
> >> media_build/v4l/ov534.c:1000: error: implicit declaration of function =
'fixp_sin'
> >> media_build/v4l/ov534.c:1001: error: implicit declaration of function =
'fixp_cos'
> >>
> >> Tested on kernel 2.6.32-41-generic-pae (Ubuntu 10.04).
> >>
> >> Signed-off-by: Gianluca Gennari <gennarone@gmail.com
> >> ---
> >>  linux/include/linux/fixp-arith.h |   87 +++++++++++++++++++++++++++++=
+++++++++
> >=20
> > It is not that simple, as make clean will remove it.
> >=20
> > I can think on a few possible solutions for it:
> > 	1) just don't compile ov534 on older kernels;
> > 	2) add a backport patch that will dynamically create it;
> > 	3) add linux/include/linux/fixp-arith.h inside the tarball with:
> > 		TARFILES +=3D include/linux/fixp-arith.h
> >=20
> > Eventually, you can also tweak with the building system, but it doesn't=
 sound a good
> > idea to keep this header there as-is for kernels > 3.4, as some changes=
 on this header
> > can be added there.
> >=20
> >>From all above, (3) is the simpler one. I'll apply it.
> >=20
[...]
>=20
>=20
> It looks like this file has not been changed in the last years, so
> chances are it will not change in the future. So adding it in the
> tarball file looks as a good solution.
>=20

Hi,

I just wanted to mention that it has been proposed to move part of
include/linux/fixp-arith.h to a .c file (maybe under lib/) in order to
share some code between the users, which are now 2
(drivers/input/ff-memless.c and drivers/media/video/gspca/ov534.c).

I don't know yet if I'll do it or when it will be done but the file
_might_ change not too far in the future.

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Tue__15_May_2012_16_25_32_+0200_m0NLX7_2pDWIwpzK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+yZ1wACgkQ5xr2akVTsAFbSgCfcdnm0o6vJm/AKFyjyH0ScYsJ
NnAAoJve93JnftBXwPVreR1So8QcwSEa
=v+Bd
-----END PGP SIGNATURE-----

--Signature=_Tue__15_May_2012_16_25_32_+0200_m0NLX7_2pDWIwpzK--
