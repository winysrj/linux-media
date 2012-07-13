Return-path: <linux-media-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:60571 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2GMBZl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 21:25:41 -0400
Date: Fri, 13 Jul 2012 11:25:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Use a named union in struct v4l2_ioctl_info
Message-Id: <20120713112530.046231a137c32480d5512954@canb.auug.org.au>
In-Reply-To: <201207121806.24955.hverkuil@xs4all.nl>
References: <201207121806.24955.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__13_Jul_2012_11_25_30_+1000_ewbZxarh/_kwNrXS"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Fri__13_Jul_2012_11_25_30_+1000_ewbZxarh/_kwNrXS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Thu, 12 Jul 2012 18:06:24 +0200 Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> struct v4l2_ioctl_info uses an anonymous union, which is initialized
> in the v4l2_ioctls table.
>=20
> Unfortunately gcc < 4.6 uses a non-standard syntax for that, so trying to
> compile v4l2-ioctl.c with an older gcc will fail.
>=20
> It is possible to work around this by testing the gcc version, but in this
> case it is easier to make the union named since it is used in only a few
> places.
>=20
> Randy, Stephen, this patch should solve the v4l2-ioctl.c compilation prob=
lem
> in linux-next. Since Mauro is still on holiday you'll have to apply it ma=
nually.

I have added this as a merge fix for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__13_Jul_2012_11_25_30_+1000_ewbZxarh/_kwNrXS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP/3kKAAoJEECxmPOUX5FEqoMQAIIKqo7l2NtIGbWKgGB0r8Jv
ezH2XqONcFKguUgmtRBgJPCetxgO6QbylpMOYMf+MwzPsUd+S0e6sUWqMf0xMtVG
VJt+z4LRv5xv+tW1GB40Cxt7v+6hZBihEE5ix4nVwWnArO/Ohv7svYI/zWlSCBuq
kKXqF4nvVA0cOJJ2Cr08ODyBOaV91WOifV4+UBiPfcUbuCF6xKX2snbbIbwEq122
CCo4qObUmzSF5wMV9bFh4sD3y1q45RkNEfC5z09ULl59fIKEqBomwSJnn1PW4hUy
ZenjBqVW46MlO5diC/ikcVOaUAL16+T9fgpVL5yDrabFpsZ/QCL89mq0ew4Xsx1U
O+ji7Yj6JgXn938FkDdsf9qxiNnu1PnNMyCm0T4DCGVXwukyTd+YELiSo8q8QRrd
hhRvyZaHPfuZCzZMglAPAom8Dm7V7F40Q+QGMfcbT2+qaLGTGcRAK+NtR7dIIkvl
/HZP7uOawuBSuhM7oY42z+ua9fpoSpO4LQrARHVOPuJ2w8a6WHnytxxGZaxdzrWZ
VYLTsGrmLAgDay+ZNxeS7PtQjLQcuzJPRc3VPco/IcGZJ7W8xL6wvRPpeZ1rLw5K
cnc0Uo8wuld5pPOKKOWINlir9aGoFyFk9Oz85BPstXxcHQSQfbxEjfYZD8QVlpwm
EVnM98DqdaKHns8mLWvT
=Y3pv
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Jul_2012_11_25_30_+1000_ewbZxarh/_kwNrXS--
