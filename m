Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACII0Tr001443
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 13:18:00 -0500
Received: from smtp-out25.alice.it (smtp-out25.alice.it [85.33.2.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACIHiBp007365
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 13:17:46 -0500
Date: Wed, 12 Nov 2008 19:17:36 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081112191736.bcbc1e37.ospite@studenti.unina.it>
In-Reply-To: <4919E47E.4000603@hhs.nl>
References: <20080816050023.GB30725@thumper>
	<20080816083613.51071257@mchehab.chehab.org>
	<7813ee860808160513g2f0e3602q9f3aed45d66ef165@mail.gmail.com>
	<20081105203114.213b599a@pedra.chehab.org>
	<20081111184200.cb9a2ba4.ospite@studenti.unina.it>
	<20081111191516.20febe64.ospite@studenti.unina.it>
	<4919E47E.4000603@hhs.nl>
Mime-Version: 1.0
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1583644281=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1583644281==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Wed__12_Nov_2008_19_17_36_+0100_LOhpzd52r_sFZAHv"

--Signature=_Wed__12_Nov_2008_19_17_36_+0100_LOhpzd52r_sFZAHv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Nov 2008 21:01:02 +0100
Hans de Goede <j.w.r.degoede@hhs.nl> wrote:

> > Antonio Ospite <ospite@studenti.unina.it> wrote:
> >=20
> >> Actually I've started a port of this driver to gspca as an exercise.
>=20
> Thanks, good work! Did this reduce the driver in size, iow do you think i=
t=20
> makes writing usb webcam driver easy, any improvements we could make?
>

Well, with my hacks to gspca.c the ov534 driver has become really
trivial. The source has shrunk from 33K to 13K. But these hacks could
not be accepted though :) But, yes, the opinion on gspca is positive.

The improvement that I always dream to see is to have bridge and sensor
drivers split, so sensor drivers can be shared, a-la soc_camera, I mean.
Bringing that idea to the extreme, one could think even to share sensor
drivers with the soc_camera framework itself, but I only have this
abstract suggestion, no idea at all about how it can be done, sorry.
Could it be a GSoC project for next summer?

> > I forgot to say that the changes are against linux-2.6.28-rc4 from linus
> > git tree.
> >=20
>=20
> If you do gspca based drivers, you will want to use jfmoine's tree as a b=
ase:
> http://linuxtv.org/hg/~jfrancois/gspca/
>=20
> Use "hg clone http://linuxtv.org/hg/~jfrancois/gspca/" to get it. hint if=
 you=20
> don't have the hg command it is part of mercurial.
>=20
> Regards,
>=20
> Hans

Thanks, will try that.

Regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Wed__12_Nov_2008_19_17_36_+0100_LOhpzd52r_sFZAHv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkbHcAACgkQ5xr2akVTsAF+/gCdFUzseQ9fF9nqPHqfhRt9dRt5
36wAoJ+uqgo8+wymFdZkiob9KA+NxGIF
=949q
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Nov_2008_19_17_36_+0100_LOhpzd52r_sFZAHv--


--===============1583644281==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1583644281==--
