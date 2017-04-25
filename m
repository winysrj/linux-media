Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52596 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946671AbdDYLXO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 07:23:14 -0400
Date: Tue, 25 Apr 2017 13:23:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hdegoede@redhat.com
Subject: Re: support autofocus / autogain in libv4l2
Message-ID: <20170425112310.GA7926@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424220701.GA27846@amd>
 <20170424225731.7532e368@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20170424225731.7532e368@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Umm, and it looks like libv4l can not automatically convert from
> > GRBG10.. and if it could, going through RGB24 would probably be too
> > slow on this device :-(.
>=20
> I suspect it shouldn't be hard to add support for GRBG10. It already
> supports 8 and 16 bits Bayer formats, at lib/libv4lconvert/bayer.c
> (to both RGB and YUV formats).

Proper format for 16 bit bayer would be tricky, AFAICT. Anyway, does
this look reasonable? It does not work too well here, since omap3isp
driver does not seem to support ENUM_FMT. (And I get just half of the
vertical image, strange. Interlacing?)

Best regards,
								Pavel

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lco=
nvert.c
index d3d8936..2a469b2 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -123,6 +126,8 @@ static const struct v4lconvert_pixfmt supported_src_pix=
fmts[] =3D {
 	{ V4L2_PIX_FMT_SGRBG8,		 8,	 8,	 8,	1 },
 	{ V4L2_PIX_FMT_SRGGB8,		 8,	 8,	 8,	1 },
 	{ V4L2_PIX_FMT_STV0680,		 8,	 8,	 8,	1 },
+
+	{ V4L2_PIX_FMT_SGRBG10,		16,	 8,	 8,	1 },
 	/* compressed bayer */
 	{ V4L2_PIX_FMT_SPCA561,		 0,	 9,	 9,	1 },
 	{ V4L2_PIX_FMT_SN9C10X,		 0,	 9,	 9,	1 },
@@ -668,6 +680,7 @@ static int v4lconvert_processing_needs_double_conversio=
n(
 	case V4L2_PIX_FMT_SGRBG8:
 	case V4L2_PIX_FMT_SRGGB8:
 	case V4L2_PIX_FMT_STV0680:
+	case V4L2_PIX_FMT_SGRBG10:
 		return 0;
 	}
 	switch (dest_pix_fmt) {
@@ -694,6 +707,17 @@ unsigned char *v4lconvert_alloc_buffer(int needed,
 	return *buf;
 }
=20
+static void v4lconvert_10to8(void *_src, unsigned char *dst, int width, in=
t height)
+{
+	int i;
+	uint16_t *src =3D _src;
+=09
+	printf("sizes %d x %d\n", width, height);
+	for (i=3D0; i<width*height; i++) {
+		dst[i] =3D src[i] >> 2;
+	}
+}
+
 int v4lconvert_oom_error(struct v4lconvert_data *data)
 {
 	V4LCONVERT_ERR("could not allocate memory\n");
@@ -867,7 +893,8 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_=
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
@@ -877,6 +904,11 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert=
_data *data,
 			return v4lconvert_oom_error(data);
=20
 		switch (src_pix_fmt) {
+		case V4L2_PIX_FMT_SGRBG10:
+			v4lconvert_10to8(src, tmpbuf, width, height);
+
+			tmpfmt.fmt.pix.pixelformat =3D V4L2_PIX_FMT_SGRBG8;
+			break;
 		case V4L2_PIX_FMT_SPCA561:
 			v4lconvert_decode_spca561(src, tmpbuf, width, height);
 			tmpfmt.fmt.pix.pixelformat =3D V4L2_PIX_FMT_SGBRG8;
@@ -949,6 +981,7 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_=
data *data,
 			V4LCONVERT_ERR("short raw bayer data frame\n");
 			errno =3D EPIPE;
 			result =3D -1;
+			/* FIXME: but then we proceed anyway?! */
 		}
 		switch (dest_pix_fmt) {
 		case V4L2_PIX_FMT_RGB24:




--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlj/MZ4ACgkQMOfwapXb+vJmawCcDJB3yDyELYx8y0JNRjvDID1D
yFEAn1kB+PUnEP0HBr/2coGZPDxb3Fo3
=UsqE
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
