Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35165 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbcDYRO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 13:14:56 -0400
Received: by mail-wm0-f53.google.com with SMTP id e201so93341114wme.0
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 10:14:56 -0700 (PDT)
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Date: Mon, 25 Apr 2016 19:14:52 +0200
Cc: linux-media@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	sakari.ailus@iki.fi, sre@kernel.org
References: <571DBA2E.9020305@gmail.com> <20160425140612.GA19175@amd> <20160425141441.GE25465@pali>
In-Reply-To: <20160425141441.GE25465@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1666597.AmYnnHKeKt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201604251914.52944@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1666597.AmYnnHKeKt
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 25 April 2016 16:14:41 Pali Roh=C3=A1r wrote:
> > Anyway, does anyone know where to get the media-ctl tool?
>=20
> Looks like it is part of v4l-utils package. At least in git:
> https://git.linuxtv.org/v4l-utils.git/tree/utils/media-ctl
>=20
> > It does not seem to be in debian 7 or debian 8...
>=20
> I do not see it in debian too, but there is some version in ubuntu:
> http://packages.ubuntu.com/trusty/media-ctl
>=20
> So you can compile ubuntu dsc package, should work on debian.

=46inally, it is also in debian, see:

https://packages.debian.org/search?suite=3Dsid&arch=3Dany&mode=3Dpath&searc=
hon=3Dcontents&keywords=3Dmedia-ctl
https://packages.debian.org/sid/amd64/v4l-utils/filelist

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1666597.AmYnnHKeKt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlceUIwACgkQi/DJPQPkQ1KzAACfUd9IGn2JJPWPz7o7j+P2WDQa
j30An29JQ6DwIBiZMLsoZihhXOL/6ag/
=swHU
-----END PGP SIGNATURE-----

--nextPart1666597.AmYnnHKeKt--
