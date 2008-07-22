Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6MA2tTc022543
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 06:02:55 -0400
Received: from t111.niisi.ras.ru (t111.niisi.ras.ru [193.232.173.111])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6MA2fhU006074
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 06:02:42 -0400
From: "Nickolay V. Shmyrev" <nshmyrev@yandex.ru>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200807191308.30071.hverkuil@xs4all.nl>
References: <200807181625.12619.hverkuil@xs4all.nl>
	<1216423424.2708.116.camel@morgan.walls.org>
	<200807191308.30071.hverkuil@xs4all.nl>
Date: Tue, 22 Jul 2008 14:00:23 +0400
Message-Id: <1216720823.2541.14.camel@t94>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: RFC: Add support to query and change connections inside a
	media device
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0743889434=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--===============0743889434==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-tg4YJQWdSuTwT/+k2xrl"


--=-tg4YJQWdSuTwT/+k2xrl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> It's very similar. In fact, it's almost identical if it wasn't for some=20
> V4L2 contraints. The main interesting feature I noticed in the=20
> gstreamer concept is 'binning'. I'm wondering if that can be used to=20
> group the related devices together, but I don't quite see how that=20
> would work right now.

Hans, what desktop are you using :) ? Just wonder.

This long proposal really makes me think a lot about the very bad
interoperation between userspace developers and kernel ones. The
gstreamer usage seems obvious and the question is what constrains are
you talking about? It will be quite easy for userspace developers to put
audio and video streams in a bin, redirect it wherever you like and pass
it through devices, probably hardware-based.

Another issue is device enumeration. While increasing amount of apps use
HAL to get information about system hardware why do we need to support
v4l-specific ioctls? For example DVB manager in GNOME SoC project works
with HAL.


--=-tg4YJQWdSuTwT/+k2xrl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: =?koi8-r?Q?=FC=D4=C1?= =?koi8-r?Q?_=DE=C1=D3=D4=D8?=
	=?koi8-r?Q?_=D3=CF=CF=C2=DD=C5=CE=C9=D1?=
	=?koi8-r?Q?_=D0=CF=C4=D0=C9=D3=C1=CE=C1?=
	=?koi8-r?Q?_=C3=C9=C6=D2=CF=D7=CF=CA?=
	=?koi8-r?Q?_=D0=CF=C4=D0=C9=D3=D8=C0?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBIha+3LCDh4YwOt9kRAjTaAJ4/TBSjWmnG+tzfCZ/MV3vTwMrKLwCgoXSY
PaacWsA6YF/n3eVHBaHgffg=
=lfMg
-----END PGP SIGNATURE-----

--=-tg4YJQWdSuTwT/+k2xrl--


--===============0743889434==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0743889434==--
