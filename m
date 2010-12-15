Return-path: <mchehab@gaivota>
Received: from smtp209.alice.it ([82.57.200.105]:47287 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab0LOQL6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 11:11:58 -0500
Received: from jcn (82.61.82.13) by smtp209.alice.it (8.5.124.08) (authenticated as fospite@alice.it)
        id 4C1A27590CBB9451 for linux-media@vger.kernel.org; Wed, 15 Dec 2010 17:11:57 +0100
Date: Wed, 15 Dec 2010 17:11:39 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Subject: Question about libv4lconvert.
Message-Id: <20101215171139.b6c1f03a.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Dec_2010_17_11_39_+0100_6q1XD/+JuO6Eul2W"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

--Signature=_Wed__15_Dec_2010_17_11_39_+0100_6q1XD/+JuO6Eul2W
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I am taking a look at libv4lconvert, and I have a question about the
logic in v4lconvert_convert_pixfmt(), in some conversion switches there
is code like this:

	case V4L2_PIX_FMT_GREY:
		switch (dest_pix_fmt) {
		case V4L2_PIX_FMT_RGB24:
	        case V4L2_PIX_FMT_BGR24:
			v4lconvert_grey_to_rgb24(src, dest, width, height);
			break;
		case V4L2_PIX_FMT_YUV420:
		case V4L2_PIX_FMT_YVU420:
			v4lconvert_grey_to_yuv420(src, dest, fmt);
			break;
		}
		if (src_size < (width * height)) {
			V4LCONVERT_ERR("short grey data frame\n");
			errno =3D EPIPE;
			result =3D -1;
		}
		break;

However the conversion routines which are going to be called seem to
assume that the buffers, in particular the source buffer, are of the
correct full frame size when looping over them.

My question is: shouldn't the size check now at the end of the case
block be at the _beginning_ of it instead, so to detect a short frame
before conversion and avoid a possible out of bound access inside the
conversion routine?

Some patches to show what I am saying:

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lco=
nvert.c
index 26a0978..46e6500 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -854,7 +854,7 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_=
data *data,
 		if (src_size < (width * height)) {
 			V4LCONVERT_ERR("short grey data frame\n");
 			errno =3D EPIPE;
-			result =3D -1;
+			return -1;
 		}
 		break;
 	case V4L2_PIX_FMT_RGB565:

And:

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lco=
nvert.c
index 46e6500..a1a4858 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -841,6 +841,11 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert=
_data *data,
 		break;
=20
 	case V4L2_PIX_FMT_GREY:
+		if (src_size < (width * height)) {
+			V4LCONVERT_ERR("short grey data frame\n");
+			errno =3D EPIPE;
+			return -1;
+		}
 		switch (dest_pix_fmt) {
 		case V4L2_PIX_FMT_RGB24:
 	        case V4L2_PIX_FMT_BGR24:
@@ -851,11 +856,6 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert=
_data *data,
 			v4lconvert_grey_to_yuv420(src, dest, fmt);
 			break;
 		}
-		if (src_size < (width * height)) {
-			V4LCONVERT_ERR("short grey data frame\n");
-			errno =3D EPIPE;
-			return -1;
-		}
 		break;
 	case V4L2_PIX_FMT_RGB565:
 		switch (dest_pix_fmt) {


Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__15_Dec_2010_17_11_39_+0100_6q1XD/+JuO6Eul2W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0I6LsACgkQ5xr2akVTsAFelwCffUuFY4Qjbp0/c8U/nUOjUNiw
F48Ani5cBiSul1rgdmgWxdfgLue9b+P5
=ZmRy
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Dec_2010_17_11_39_+0100_6q1XD/+JuO6Eul2W--
