Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37057 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbdEILB1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 07:01:27 -0400
Date: Tue, 9 May 2017 13:01:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: [patch, libv4l]: Add support for GRBG10 format conversion
Message-ID: <20170509110125.GB28248@amd>
References: <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd>
 <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Add support for GRBG10 format conversion.
   =20
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lco=
nvert.c
index d3d8936..a7376b8 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -123,6 +123,7 @@ static const struct v4lconvert_pixfmt supported_src_pix=
fmts[] =3D {
 	{ V4L2_PIX_FMT_SGRBG8,		 8,	 8,	 8,	1 },
 	{ V4L2_PIX_FMT_SRGGB8,		 8,	 8,	 8,	1 },
 	{ V4L2_PIX_FMT_STV0680,		 8,	 8,	 8,	1 },
+	{ V4L2_PIX_FMT_SGRBG10,		16,	 8,	 8,	1 },
 	/* compressed bayer */
 	{ V4L2_PIX_FMT_SPCA561,		 0,	 9,	 9,	1 },
 	{ V4L2_PIX_FMT_SN9C10X,		 0,	 9,	 9,	1 },
@@ -694,6 +695,16 @@ unsigned char *v4lconvert_alloc_buffer(int needed,
 	return *buf;
 }
=20
+static void v4lconvert_10to8(void *_src, unsigned char *dst, int width, in=
t height)
+{
+	int i;
+	uint16_t *src =3D _src;
+=09
+	for (i=3D0; i<width*height; i++) {
+		dst[i] =3D src[i] >> 2;
+	}
+}
+
 int v4lconvert_oom_error(struct v4lconvert_data *data)
 {
 	V4LCONVERT_ERR("could not allocate memory\n");
@@ -867,7 +878,8 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_=
data *data,
 #endif
 	case V4L2_PIX_FMT_SN9C2028:
 	case V4L2_PIX_FMT_SQ905C:
-	case V4L2_PIX_FMT_STV0680: { /* Not compressed but needs some shuffling */
+	case V4L2_PIX_FMT_STV0680:
+	case V4L2_PIX_FMT_SGRBG10: { /* Not compressed but needs some shuffling */
 		unsigned char *tmpbuf;
 		struct v4l2_format tmpfmt =3D *fmt;
=20
@@ -877,6 +889,11 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert=
_data *data,
 			return v4lconvert_oom_error(data);
=20
 		switch (src_pix_fmt) {
+		case V4L2_PIX_FMT_SGRBG10:
+			v4lconvert_10to8(src, tmpbuf, width, height);
+			tmpfmt.fmt.pix.pixelformat =3D V4L2_PIX_FMT_SGRBG8;
+			bytesperline =3D width;
+			break;
 		case V4L2_PIX_FMT_SPCA561:
 			v4lconvert_decode_spca561(src, tmpbuf, width, height);
 			tmpfmt.fmt.pix.pixelformat =3D V4L2_PIX_FMT_SGBRG8;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkRoYUACgkQMOfwapXb+vINrACgvO3msh3ANoArBx5NbeVzjncB
hykAoJjpzKceyQNEv4tS+09uRWqBYDFQ
=hJZn
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
