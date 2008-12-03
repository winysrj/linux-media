Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB3Gjpcc011991
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 11:45:51 -0500
Received: from smtp-out25.alice.it (smtp-out25.alice.it [85.33.2.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB3Gjctx022098
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 11:45:38 -0500
Date: Wed, 3 Dec 2008 17:45:28 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081203174528.712f1549.ospite@studenti.unina.it>
In-Reply-To: <20081127145233.f467442a.ospite@studenti.unina.it>
References: <20081125235249.d45b50f4.ospite@studenti.unina.it>
	<1227777784.1752.20.camel@localhost>
	<20081127120536.62b35cd6.ospite@studenti.unina.it>
	<1227788553.1752.42.camel@localhost>
	<20081127145233.f467442a.ospite@studenti.unina.it>
Mime-Version: 1.0
Cc: 
Subject: Re: [PATCH] gspca_ov534: Print only frame_rate actually used.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1634184345=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1634184345==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Wed__3_Dec_2008_17_45_28_+0100__smzmCfL+acfIYrk"

--Signature=_Wed__3_Dec_2008_17_45_28_+0100__smzmCfL+acfIYrk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Nov 2008 14:52:33 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> On Thu, 27 Nov 2008 13:22:33 +0100
> Jean-Francois Moine <moinejf@free.fr> wrote:
>=20
> > On Thu, 2008-11-27 at 12:05 +0100, Antonio Ospite wrote:
> > > > The patch also includes removing the bulk_size setting at streamon =
time:
> > > > the value is already used at this time, and also, there is only one
> > > > resolution.
> > > We will add this again when we add other resolutions, OK.
> >=20
> > The bulk_size must be set at the max resolution because it is used for
> > buffer allocation before stream on.
> >
>=20
> Well, isn't it only used in create_urbs()? AFAICS the latter uses it to
> set urb->tranfer_buffer_length and is called at streamon time, so it
> could still be worth to set bulk_size to exact value for the current
> resolution to have more efficient transfers, what do you think?
>=20

Hi Jean-Francois,

it turned out that on PS3 the big current bulk_size doesn't work,
because here the hardware needs contiguous memory for transfers (if
the description is somewhat imprecise please correct me) and it is not
always possible to allocate such a big contiguous chunk, so we have to
use a smaller fixed size for bulk transfers and fill the frame in
several passes in pkt_scan.

I am preparing some patches, but I come across a problem.

Now I use this code in pkt_scan (I add a zero length FIRST_PACKET in
sd_start):

	if ((frame->data_end - frame->data + len) =3D=3D (framesize - 4)) {
		PDEBUG(D_PACK, "  end of frame?");
		gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
		frame =3D gspca_frame_add(gspca_dev, LAST_PACKET, frame, last, 4);
		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, data, 0);
	} else
		gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);

When everything works ok I get this log messages:

  ov534: ** packet len =3D 16384, framesize =3D 614400
  ov534: ** frame->data_end - frame->data + len =3D 16384
  ov534:=20
  ...
  ov534: ** packet len =3D 8188, framesize =3D 614400
  ov534: ** frame->data_end - frame->data + len =3D 614396
  ov534:    end of frame!
  ov534:=20
  ov534: ** packet len =3D 16384, framesize =3D 614400
  ov534: ** frame->data_end - frame->data + len =3D 16384
  ov534:=20
  ...

But sometime, at higher frame rates, it doesn't work,
frames are discarded because I get:

  ov534: ** packet len =3D 16384, framesize =3D 614400
  ov534: ** frame->data_end - frame->data + len =3D 16384
  ov534:=20
  ...
  ov534: ** packet len =3D 8188, framesize =3D 614400
  ov534: ** frame->data_end - frame->data + len =3D 614396
  ov534:    end of frame!
  ov534:=20
  ov534: ** packet len =3D 16384, framesize =3D 614400
  ov534: ** frame->data_end - frame->data + len =3D 630784
  ov534:                                          ^^^^^^
  ...                                             ^^^^^^

It looks like something is failing in gspca_frame_add(), it doesn't get
to the statement frame->data_end =3D frame->data; when adding the
FIRST_PACKET. That could be because the packet has been queued but not
added yet, AFAIU. How to deal with such case?

As a side note, if I use this check to detect the end of the frame:

	if (len < gspca_dev->cam.bulk_size) {
		...
	} else ...

I can recover from the previous error even if I get some frame
discarded from time to time. Is this check acceptable to you If I take
care that framesize is not a multiple of bulk_size?

The current quilt patchset is here:
http://shell.studenti.unina.it/~ospite/tmp/gspca_ov534_patches-2008-12-03.t=
ar.gz

Regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Wed__3_Dec_2008_17_45_28_+0100__smzmCfL+acfIYrk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk2t6gACgkQ5xr2akVTsAHwvwCcDqceFJIwW6/CSf4yWiILLEBK
wg0AnjfgSBy5foVj0aRW4qFkSn1rsvp1
=X3Yn
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Dec_2008_17_45_28_+0100__smzmCfL+acfIYrk--


--===============1634184345==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1634184345==--
