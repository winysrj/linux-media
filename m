Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARB6iqt010512
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 06:06:44 -0500
Received: from smtp-out113.alice.it (smtp-out113.alice.it [85.37.17.113])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mARB6U5S025550
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 06:06:30 -0500
Date: Thu, 27 Nov 2008 12:05:36 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Message-Id: <20081127120536.62b35cd6.ospite@studenti.unina.it>
In-Reply-To: <1227777784.1752.20.camel@localhost>
References: <20081125235249.d45b50f4.ospite@studenti.unina.it>
	<1227777784.1752.20.camel@localhost>
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
Content-Type: multipart/mixed; boundary="===============0033815316=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0033815316==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Thu__27_Nov_2008_12_05_36_+0100_53BOlo1_q0mGd+Ff"

--Signature=_Thu__27_Nov_2008_12_05_36_+0100_53BOlo1_q0mGd+Ff
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Nov 2008 10:23:04 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Tue, 2008-11-25 at 23:52 +0100, Antonio Ospite wrote:
> > Print only frame_rate actually used.
>=20
> Hello Antonio,
>=20
> This may be simplified as in the attached patch (the frame_rate in the
> sd structure was not used).
>

Some questions inlined. I am still learning.

> The patch also includes removing the bulk_size setting at streamon time:
> the value is already used at this time, and also, there is only one
> resolution.
>

We will add this again when we add other resolutions, OK.

> I found a real problem: for USB read and write, you have a 16-bits
> variable in/from which you read/write only one byte. This will fail with
> big-endian machines. Anyway, it is safer to use the usb_buf from the
> gspca structure.
>

Ah, you mean in control messages, yes, those always use size=3D1 so a u8
can be used there.
I'll give a look and will do some tests on a real PS3.

Thanks.

Regards,
   Antonio Ospite.

> Cheers.
>=20
> --=20
> Ken ar c'henta=F1 |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
>=20
>=20
>=20
> [ov534.patch  text/x-patch (2,1KB)]
> diff -r 3e0ba0a8e47f linux/drivers/media/video/gspca/ov534.c
> --- a/linux/drivers/media/video/gspca/ov534.c	Wed Nov 26 20:17:13 2008 +0=
100
> +++ b/linux/drivers/media/video/gspca/ov534.c	Thu Nov 27 10:15:08 2008 +0=
100
> @@ -48,7 +48,6 @@
>  /* specific webcam descriptor */
>  struct sd {
>  	struct gspca_dev gspca_dev;	/* !! must be the first item */
> -	__u8 frame_rate;
>  };
> =20
>  /* V4L2 controls supported by the driver */
> @@ -59,7 +58,7 @@
>  	{640, 480, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
>  	 .bytesperline =3D 640 * 2,
>  	 .sizeimage =3D 640 * 480 * 2,
> -	 .colorspace =3D V4L2_COLORSPACE_JPEG,
> +	 .colorspace =3D V4L2_COLORSPACE_SRGB,
>  	 .priv =3D 0},
>  };
>

Can you explain this one, please?

[snip]
> @@ -433,7 +429,6 @@
>  	int framesize =3D gspca_dev->cam.bulk_size;
> =20
>  	if (len =3D=3D framesize - 4) {
> -		frame =3D
>  		    gspca_frame_add(gspca_dev, FIRST_PACKET, frame, data, len);

This change is just to follow the convention used by other drivers,
right? You could also adjust indentation on following line, then.

>  		frame =3D
>  		    gspca_frame_add(gspca_dev, LAST_PACKET, frame, last_pixel,
>=20


--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Thu__27_Nov_2008_12_05_36_+0100_53BOlo1_q0mGd+Ff
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkufwAACgkQ5xr2akVTsAFctgCgqo4wBqVFgSLA3Bji2WDgH5RM
T0IAn325CkentLRKbh/ffuSOrtXhumqg
=E35b
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Nov_2008_12_05_36_+0100_53BOlo1_q0mGd+Ff--


--===============0033815316==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0033815316==--
