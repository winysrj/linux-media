Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9H7ghXA007707
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 03:42:43 -0400
Received: from smtp-OUT05A.alice.it (smtp-OUT05A.alice.it [85.33.3.5])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9H7gTwp020691
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 03:42:29 -0400
Date: Fri, 17 Oct 2008 09:41:51 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081017094151.596d236f.ospite@studenti.unina.it>
In-Reply-To: <200810162258.28993.hverkuil@xs4all.nl>
References: <u63nt9mvx.wl%morimoto.kuninori@renesas.com>
	<20081016102701.1bcb2c59.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0810162114030.8422@axis700.grange>
	<200810162258.28993.hverkuil@xs4all.nl>
Mime-Version: 1.0
Subject: Re: [PATCH] Add ov772x driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1603970992=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1603970992==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Fri__17_Oct_2008_09_41_52_+0200_Hi1vRTiNgC+qX0Bq"

--Signature=_Fri__17_Oct_2008_09_41_52_+0200_Hi1vRTiNgC+qX0Bq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Oct 2008 22:58:28 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Thursday 16 October 2008 21:23:59 Guennadi Liakhovetski wrote:
> > On Thu, 16 Oct 2008, Antonio Ospite wrote:
> > > On Thu, 16 Oct 2008 13:28:52 +0900
> > >
> > > Kuninori Morimoto <morimoto.kuninori@renesas.com> wrote:
> > > > This patch adds ov772x driver that use soc_camera framework.
> > >
> > > Hi, this sensor is used also in some usb cameras (Playstation Eye,
> > > for instance), and this code can be reused to improve the
> > > previously posted ov534 driver.
> > >
> > > The question is: is there any mechanism to share sensor code
> > > between usb and i2c drivers or we have to copy and paste?
> >
> > Well, this is not the first time this idea / question appears...

[...]

> > Hans Verkuil will, probably, notice, that=20
> > soc-camera is not universal enough for many video applications, but
> > it might well be enough for the cideo part of a simple USB
> > web-camera, I think. OTOH, Hans is working on a new API, that should
> > unify the host / device interface in v4l applications, at which time
> > soc-camera drivers will have to be converted, as well as multiple
> > other currently existing APIs.
>=20
> I'm planning to start on this this weekend. If all goes well the basic=20
> framework should go into v4l-dvb soon after the 2.6.28 windows closes,=20
> and it should end up in 2.6.29.
>

Hans, does you work include splitting bridge/protocol code and sensor
related code? This will clearly lead to a combinatorial increase of
supported cameras.

Regards,
   Antonio

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Fri__17_Oct_2008_09_41_52_+0200_Hi1vRTiNgC+qX0Bq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj4QcAACgkQ5xr2akVTsAHPKgCdGfdNrSSxpIGxE6gpXeffEIva
TsgAoKGTD0QhPOoV2gJ/9KsmyfsiMGKk
=okox
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Oct_2008_09_41_52_+0200_Hi1vRTiNgC+qX0Bq--


--===============1603970992==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1603970992==--
