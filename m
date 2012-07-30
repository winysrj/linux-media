Return-path: <linux-media-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:44493 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2G3Wky (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 18:40:54 -0400
Date: Tue, 31 Jul 2012 08:40:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media" <linux-media@vger.kernel.org>,
	Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Use a named union in struct v4l2_ioctl_info
Message-Id: <20120731084044.80ebe5f895068da2ad6a3652@canb.auug.org.au>
In-Reply-To: <20120713112530.046231a137c32480d5512954@canb.auug.org.au>
References: <201207121806.24955.hverkuil@xs4all.nl>
	<20120713112530.046231a137c32480d5512954@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__31_Jul_2012_08_40_44_+1000_ZYUKC25XV4uwQJ1Q"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Tue__31_Jul_2012_08_40_44_+1000_ZYUKC25XV4uwQJ1Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Fri, 13 Jul 2012 11:25:30 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 12 Jul 2012 18:06:24 +0200 Hans Verkuil <hverkuil@xs4all.nl> wrot=
e:
> >
> > struct v4l2_ioctl_info uses an anonymous union, which is initialized
> > in the v4l2_ioctls table.
> >=20
> > Unfortunately gcc < 4.6 uses a non-standard syntax for that, so trying =
to
> > compile v4l2-ioctl.c with an older gcc will fail.
> >=20
> > It is possible to work around this by testing the gcc version, but in t=
his
> > case it is easier to make the union named since it is used in only a few
> > places.
> >=20
> > Randy, Stephen, this patch should solve the v4l2-ioctl.c compilation pr=
oblem
> > in linux-next. Since Mauro is still on holiday you'll have to apply it =
manually.
>=20
> I have added this as a merge fix for today.

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__31_Jul_2012_08_40_44_+1000_ZYUKC25XV4uwQJ1Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQFw1sAAoJEECxmPOUX5FEFk0P/iYRgHxyjRdOo8tYuHP/92bc
i+R5Pj5TpN97SubTVgDhME2+UvCwFHuZQdXsNSOeQTnSbR69/GCnfdxq+p+wPqMR
oSVyP/+v+XM15tvQNMULjJZJaYX5ncJphJOqQzusKB5ADDNlD2TRiaT20j8SPS/O
ec8eEOxFvacEZNDohTTqvdKMPq2YahgLT6Gux6vPEp4UvHyF11EB90XoOitJsVBQ
Z3L1EdvKQ7tb80Dyl2IVAQBFnW7isWxl3LJY2sLSDpWpQ2YJYzRyb7V9ZOYWO6c/
1N82HTktzzs9jdLxrCcJBRR3ZlDmsa782qTJoz24SsxDYM7p1v49833NCtA4taYY
juI0DmMoXGWx+v5QJ8dCwfSYbuR8DVJmMtvGquDKrL4KAXbXVWCXN7bvBP714CGF
e8q4Pr0HNrEy++PWs9JmyAhnFsPzh5OvuHuBYME2STPPtAIYCRhycPjI8lz8Mfiq
sdsbooUQ+oSIRj5qbweAvt85qajahDF7QGP37B6bAkJvSuEUAOLBjeDWzdXOoFes
Wqyp8PsGX2t8WUVvLCeoS7yQNDy4cYaa6YswdtWxsuUEIRzDyw6GzuJj1KTexUJh
PgTndnRqXlGaqRIkafdlq+k6HKFh/CYTSwNRoZcTDU6PtNQdy+JNlBkYlyJH/sLw
ljHMvJ2XSjl3ELu29AAB
=JwdQ
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Jul_2012_08_40_44_+1000_ZYUKC25XV4uwQJ1Q--
