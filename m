Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARDr71r023026
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 08:53:07 -0500
Received: from smtp-out25.alice.it (smtp-out25.alice.it [85.33.2.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mARDqqjN021021
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 08:52:53 -0500
Date: Thu, 27 Nov 2008 14:52:33 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Message-Id: <20081127145233.f467442a.ospite@studenti.unina.it>
In-Reply-To: <1227788553.1752.42.camel@localhost>
References: <20081125235249.d45b50f4.ospite@studenti.unina.it>
	<1227777784.1752.20.camel@localhost>
	<20081127120536.62b35cd6.ospite@studenti.unina.it>
	<1227788553.1752.42.camel@localhost>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] gspca_ov534: Print only frame_rate actually used.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1926243589=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1926243589==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Thu__27_Nov_2008_14_52_33_+0100_9+=nhzCy1eHievOy"

--Signature=_Thu__27_Nov_2008_14_52_33_+0100_9+=nhzCy1eHievOy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Nov 2008 13:22:33 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Thu, 2008-11-27 at 12:05 +0100, Antonio Ospite wrote:
> > > The patch also includes removing the bulk_size setting at streamon ti=
me:
> > > the value is already used at this time, and also, there is only one
> > > resolution.
> > We will add this again when we add other resolutions, OK.
>=20
> The bulk_size must be set at the max resolution because it is used for
> buffer allocation before stream on.
>

Well, isn't it only used in create_urbs()? AFAICS the latter uses it to
set urb->tranfer_buffer_length and is called at streamon time, so it
could still be worth to set bulk_size to exact value for the current
resolution to have more efficient transfers, what do you think?

> 	[snip]
> > >  /* V4L2 controls supported by the driver */
> > > @@ -59,7 +58,7 @@
> > >  	{640, 480, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
> > >  	 .bytesperline =3D 640 * 2,
> > >  	 .sizeimage =3D 640 * 480 * 2,
> > > -	 .colorspace =3D V4L2_COLORSPACE_JPEG,
> > > +	 .colorspace =3D V4L2_COLORSPACE_SRGB,
> > >  	 .priv =3D 0},
> > >  };
> > >
> >=20
> > Can you explain this one, please?
>=20
> I think the JPEG images embed colorspace information, and here, it is
> simple RGB.
>

Also other drivers are setting this colorspace for raw YCbCr data, see
mt9m111.c:
COL_FMT("YCrYCb 16 bit", 16, V4L2_PIX_FMT_YUYV, V4L2_COLORSPACE_JPEG),

and tcm825x.c:
switch (pix->pixelformat) {
	case V4L2_PIX_FMT_UYVY:
	default:
		pix->colorspace =3D V4L2_COLORSPACE_JPEG;
		break;

and also the comment relative to V4L2_COLORSPACE_JPEG mentions YCbCr,
but honestly, I don't know how this colorspace info is used that's why I
am asking.

> > [snip]
> > > @@ -433,7 +429,6 @@
> > >  	int framesize =3D gspca_dev->cam.bulk_size;
> > > =20
> > >  	if (len =3D=3D framesize - 4) {
> > > -		frame =3D
> > >  		    gspca_frame_add(gspca_dev, FIRST_PACKET, frame, data, len);
> >=20
> > This change is just to follow the convention used by other drivers,
> > right? You could also adjust indentation on following line, then.
>=20
> If you look carefully, the frame returned by gspca_frame_add() is
> changed only when the packet type is LAST_PACKET. OK for the
> indentation.
>

OK, thanks.

Regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Thu__27_Nov_2008_14_52_33_+0100_9+=nhzCy1eHievOy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkupiEACgkQ5xr2akVTsAF4WgCcCqYfUe4aPvq5acmM0yK7E6RU
NfMAnj+WE3BNsldh1287zioMHB+iiH77
=LeYR
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Nov_2008_14_52_33_+0100_9+=nhzCy1eHievOy--


--===============1926243589==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1926243589==--
