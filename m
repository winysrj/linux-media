Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA4HM7m9021640
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 12:22:07 -0500
Received: from smtp-out28.alice.it (smtp-out28.alice.it [85.33.2.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA4HLU7H029480
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 12:21:52 -0500
Date: Tue, 4 Nov 2008 18:21:22 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081104182122.a1bfe6ed.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0811040020330.7744@axis700.grange>
References: <20081029232544.661b8f17.ospite@studenti.unina.it>
	<87mygkof3j.fsf@free.fr>
	<Pine.LNX.4.64.0811022048430.14486@axis700.grange>
	<87skq87mgp.fsf@free.fr>
	<Pine.LNX.4.64.0811031944340.7744@axis700.grange>
	<87mygg4l5l.fsf@free.fr>
	<Pine.LNX.4.64.0811032131410.7744@axis700.grange>
	<Pine.LNX.4.64.0811032322420.7744@axis700.grange>
	<87k5bk30h0.fsf@free.fr>
	<Pine.LNX.4.64.0811040020330.7744@axis700.grange>
Mime-Version: 1.0
Subject: Re: [PATCH] mt9m111: Fix YUYV format for pxa-camera
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0247684334=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0247684334==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Tue__4_Nov_2008_18_21_22_+0100_s_SA_SJo81a9pDp/"

--Signature=_Tue__4_Nov_2008_18_21_22_+0100_s_SA_SJo81a9pDp/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 4 Nov 2008 15:42:59 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Mon, 3 Nov 2008, Robert Jarzmik wrote:
>=20
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> >=20
> > > Ok, just thinking one step further - Antonio most certainly was testi=
ng=20
> > > V4L2_PIX_FMT_YUYV, i.e., packed with his application, any other YCbCr=
=20
> > > format would be rejected by mt9m111 and YUYV _is_ packed. So, I think=
 this=20
> > > is indeed the case - there are mo errors in datasheets, we just named=
 the=20
> > > formats wrongly in pxa-camera and mt9m111 drivers.
> >=20
> > I don't agree. This has nothing to do with naming, this has to do with =
byte
> > order on qif bus and out of mt9m111 sensor.
>

Indeed I only played with packet formats.

> We agree, that YCbCr _in_ _memory_ format as defined in pxa270 datasheet=
=20
> table 27-21 is UYVY, right?
>=20
> To get that byte-order in memory data should appear on the camera bus as=
=20
> specified in Table 27-19. This order is also the default order for=20
> mt9m111. So, I think, it is reasonable to expect, that when a user=20
> application requests a UYVY format, we have to configure the camera to it=
s=20
> defaults and the PXA will work as documented.
>=20
> Instead, this configuration in the current mainline state is called YUYV,=
=20
> so, we provide data in UYUV format to an application, requesting YUYV.=20
> Then, of course, corrupted image result as in Antonio's test.
>=20
> Hence, the first thing we shouldn't lie to applications - the format we=20
> currently provide is UYUV and this is how we should advertise it. That's=
=20
> why it _is_ a naming issue.
>=20
> And, according to PXA documentation, pxa270 doesn't support any other=20
> byte-order variants on the camera bus, so, in principle one could stop=20
> here. Note, I think, this restriction is imposed to make image=20
> post-processing possible (see 7.4.9.2)
>=20
> Next, what we observe, I think, is that in this mode pxa acts just in a=20
> pass-through mode with 16-bit pixels packing bytes as they arrive in the=
=20
> FIFO in RAM buffers. So, if we don't use post-processing, we can (ab)use=
=20
> this mode for other 16-bit YCbCr formats, e.g., YUYV. For this we leave=20
> PXA as it is, and just configure the sensor to provide YUYV. This is what=
=20
> essentially Antonio's patch does. In this sense it is "correct" - mt9m111=
=20
> is indeed configured for YUYV and it is the only YCbCr format it=20
> advertises, and pxa pretends to support YUYV. But, that's exactly why I a=
m=20
> not quite happy about it - we abandon mt9m111's default UYUV format and=20
> switch it unconditionally to YUYV and we leave PXA270 lying about its=20
> supported pixel format. Instead, extending mt9m111 to claim support for=20
> all 4 formats, switching between them dynamically, and fixing pxa-camera=
=20
> to support all these four formats, and providing a comment, that we just=
=20
> use PXA270's UYUV as 16-bit pass-through, is a more complete fix and,=20
> probably, would have taken less time than this discussion:-)
>=20
> > But you can change my mind : just tell me where my thinking was
> > wrong in the previous mail where I stated bytes order (out of mt9m111 a=
nd in pxa
> > qif bus).
>=20
> Let's see if I managed...
>=20
> Thanks
> Guennadi

Very interesting discussion especially from a new learner point of view.
Of course I aimed at the correct end result not at the correct solution
as you stated.

I'll be very happy to promptly test the "complete" fix as soon as you
have something cooked.

Regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Tue__4_Nov_2008_18_21_22_+0100_s_SA_SJo81a9pDp/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkQhJIACgkQ5xr2akVTsAF7ZQCfY5uVbCXVkfZt7JhM19ZcQMsl
TNIAn3ULUtw3r7j2UU2mu654Fqahb5tv
=8UC9
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Nov_2008_18_21_22_+0100_s_SA_SJo81a9pDp/--


--===============0247684334==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0247684334==--
