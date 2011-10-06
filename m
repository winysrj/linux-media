Return-path: <linux-media-owner@vger.kernel.org>
Received: from calzone.tip.net.au ([203.10.76.15]:49020 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1JFDC2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 23:02:28 -0400
Date: Thu, 6 Oct 2011 14:02:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-next@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] drivers/media: fix dependencies in video
 mt9t001/mt9p031
Message-Id: <20111006140214.b64b22b77f2f831442d59794@canb.auug.org.au>
In-Reply-To: <4E8644D5.6080307@xenotime.net>
References: <4E83A02F.2020309@xenotime.net>
	<1317418491-26513-1-git-send-email-paul.gortmaker@windriver.com>
	<4E8644D5.6080307@xenotime.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Oct_2011_14_02_14_+1100_5V6Yt/gIeO6_v0JX"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Thu__6_Oct_2011_14_02_14_+1100_5V6Yt/gIeO6_v0JX
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Fri, 30 Sep 2011 15:38:13 -0700 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> On 09/30/11 14:34, Paul Gortmaker wrote:
> > Both mt9t001.c and mt9p031.c have two identical issues, those
> > being that they will need module.h inclusion for the upcoming
> > cleanup going on there, and that their dependencies don't limit
> > selection of configs that will fail to compile as follows:
> >=20
> > drivers/media/video/mt9p031.c:457: error: implicit declaration of funct=
ion =E2=80=98v4l2_subdev_get_try_crop=E2=80=99
> > drivers/media/video/mt9t001.c:787: error: =E2=80=98struct v4l2_subdev=
=E2=80=99 has no member named =E2=80=98entity=E2=80=99
> >=20
> > The related config options are CONFIG_MEDIA_CONTROLLER and
> > CONFIG_VIDEO_V4L2_SUBDEV_API.  Looking at the code, it appears
> > that the driver was never intended to work without these enabled,
> > so add a dependency on CONFIG_VIDEO_V4L2_SUBDEV_API, which in
> > turn already has a dependency on CONFIG_MEDIA_CONTROLLER.
> >=20
> > Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>=20
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Oct_2011_14_02_14_+1100_5V6Yt/gIeO6_v0JX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjRo2AAoJEECxmPOUX5FEN9YQAJDGa1UL4mqZAe9Y3gc1SRU2
ZjWL11vlwed1Qr1Ert3WJnOOmQ1zAht25hGawhLjIOTAMC9qhFz76hNsY4AzQY3T
Jq/rsominQ6z/chTheynt2GOuu0hJC9UfnPkdvorf66PyqcPFAXFr+51swAt+0fB
igW9lFigLgcBtL9QeqHfLjDEA8/cZZRmIAacon5/wfMK9gGEKlwWWeWcfXLbdJnM
f+tD1zaxgEo1RC0BVjJvsgxRenfNsRCw1QhYoQsbI/FL2UewITt56qpVPLoIQKPe
SVrYm6QO9//7hxyhd/cvyde3u2ypogjB0MaVcZnPeyoGhAt9UzTRkvSgOmseEUEN
xXmj8tzmgjDzEZiNkk0ZpCwTpBHEW71CH5lVvz8QAAPkPd8QHwXldvIWuYcej/lM
vln9ivIT5UlWQkKTZKQ4YWIdw6WWcUUW+ynICYqzdFob+hELdBVLaMruEQME+DKg
MshdtXn2Wwj3Q1Z3sa7bB+Hb37Lz5gZ0PP9E64x/Dq9ucLGDMODA8l7QBak9aab/
tbsuLYgQ4Vm20fnOe0n4RlXLFGwZnGT1cZwI3NQkTRjOi7T7zsvuO5v/hZjfsNpR
lmVTr8zm1vrB+96gvAedfjVpnXKVf7EfKft1QBTx29yjwag7792HxFGQPP7rWbbL
iOtz69Y+4xEuVEvMBdBQ
=Z1Ab
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Oct_2011_14_02_14_+1100_5V6Yt/gIeO6_v0JX--
