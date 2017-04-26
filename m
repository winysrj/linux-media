Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36259 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1953712AbdDZNXl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 09:23:41 -0400
Date: Wed, 26 Apr 2017 15:23:37 +0200
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
        linux-media@vger.kernel.org
Subject: [patch] autogain support for bayer10 format (was Re: [patch]
 propagating controls in libv4l2)
Message-ID: <20170426132337.GA6482@amd>
References: <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20170426081330.6ca10e42@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > I don't see why it would be hard to open files or have threads inside
> > > a library. There are several libraries that do that already, specially
> > > the ones designed to be used on multimidia apps. =20
> >=20
> > Well, This is what the libv4l2 says:
> >=20
> >    This file implements libv4l2, which offers v4l2_ prefixed versions
> >    of
> >       open/close/etc. The API is 100% the same as directly opening
> >    /dev/videoX
> >       using regular open/close/etc, the big difference is that format
> >    conversion
> >   =20
> > but if I open additional files in v4l2_open(), API is no longer the
> > same, as unix open() is defined to open just one file descriptor.
> >=20
> > Now. There is autogain support in libv4lconvert, but it expects to use
> > same fd for camera and for the gain... which does not work with
> > subdevs.
> >=20
> > Of course, opening subdevs by name like this is not really
> > acceptable. But can you suggest a method that is?
>=20
> There are two separate things here:
>=20
> 1) Autofoucs for a device that doesn't use subdev API
> 2) libv4l2 support for devices that require MC and subdev API

Actually there are three: 0) autogain. Unfortunately, I need autogain
first before autofocus has a chance...

And that means... bayer10 support for autogain.

Plus, I changed avg_lum to long long. Quick calculation tells me int
could overflow with few megapixel sensor.

Oh, btw http://ytse.tricolour.net/docs/LowLightOptimization.html no
longer works.

Regards,
								Pavel

diff --git a/lib/libv4lconvert/processing/autogain.c b/lib/libv4lconvert/pr=
ocessing/autogain.c
index c6866d6..0b52d0f 100644
--- a/lib/libv4lconvert/processing/autogain.c
+++ b/lib/libv4lconvert/processing/autogain.c
@@ -68,6 +71,41 @@ static void autogain_adjust(struct v4l2_queryctrl *ctrl,=
 int *value,
 	}
 }
=20
+static int get_luminosity_bayer10(uint16_t *buf, const struct v4l2_format =
*fmt)
+{
+	long long avg_lum =3D 0;
+	int x, y;
+=09
+	buf +=3D fmt->fmt.pix.height * fmt->fmt.pix.bytesperline / 4 +
+		fmt->fmt.pix.width / 4;
+
+	for (y =3D 0; y < fmt->fmt.pix.height / 2; y++) {
+		for (x =3D 0; x < fmt->fmt.pix.width / 2; x++)
+			avg_lum +=3D *buf++;
+		buf +=3D fmt->fmt.pix.bytesperline - fmt->fmt.pix.width / 2;
+	}
+	avg_lum /=3D fmt->fmt.pix.height * fmt->fmt.pix.width / 4;
+	avg_lum /=3D 4;
+	return avg_lum;
+}
+
+static int get_luminosity_bayer8(unsigned char *buf, const struct v4l2_for=
mat *fmt)
+{
+	long long avg_lum =3D 0;
+	int x, y;
+=09
+	buf +=3D fmt->fmt.pix.height * fmt->fmt.pix.bytesperline / 4 +
+		fmt->fmt.pix.width / 4;
+
+	for (y =3D 0; y < fmt->fmt.pix.height / 2; y++) {
+		for (x =3D 0; x < fmt->fmt.pix.width / 2; x++)
+			avg_lum +=3D *buf++;
+		buf +=3D fmt->fmt.pix.bytesperline - fmt->fmt.pix.width / 2;
+	}
+	avg_lum /=3D fmt->fmt.pix.height * fmt->fmt.pix.width / 4;
+	return avg_lum;
+}
+
 /* auto gain and exposure algorithm based on the knee algorithm described =
here:
 http://ytse.tricolour.net/docs/LowLightOptimization.html */
 static int autogain_calculate_lookup_tables(
@@ -100,17 +142,16 @@ static int autogain_calculate_lookup_tables(
 	switch (fmt->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_SGBRG10:
+	case V4L2_PIX_FMT_SGRBG10:
+	case V4L2_PIX_FMT_SBGGR10:
+	case V4L2_PIX_FMT_SRGGB10:
+		avg_lum =3D get_luminosity_bayer10((void *) buf, fmt);
+		break;
+
 	case V4L2_PIX_FMT_SGBRG8:
 	case V4L2_PIX_FMT_SGRBG8:
 	case V4L2_PIX_FMT_SBGGR8:
 	case V4L2_PIX_FMT_SRGGB8:
-		buf +=3D fmt->fmt.pix.height * fmt->fmt.pix.bytesperline / 4 +
-			fmt->fmt.pix.width / 4;
-
-		for (y =3D 0; y < fmt->fmt.pix.height / 2; y++) {
-			for (x =3D 0; x < fmt->fmt.pix.width / 2; x++)
-				avg_lum +=3D *buf++;
-			buf +=3D fmt->fmt.pix.bytesperline - fmt->fmt.pix.width / 2;
-		}
-		avg_lum /=3D fmt->fmt.pix.height * fmt->fmt.pix.width / 4;
+		avg_lum =3D get_luminosity_bayer8(buf, fmt);
 		break;
=20
 	case V4L2_PIX_FMT_RGB24:
diff --git a/lib/libv4lconvert/processing/libv4lprocessing.c b/lib/libv4lco=
nvert/processing/libv4lprocessing.c
index b061f50..b98d024 100644
--- a/lib/libv4lconvert/processing/libv4lprocessing.c
+++ b/lib/libv4lconvert/processing/libv4lprocessing.c
@@ -164,6 +165,10 @@ void v4lprocessing_processing(struct v4lprocessing_dat=
a *data,
 	case V4L2_PIX_FMT_SGRBG8:
 	case V4L2_PIX_FMT_SBGGR8:
 	case V4L2_PIX_FMT_SRGGB8:
+	case V4L2_PIX_FMT_SGBRG10:
+	case V4L2_PIX_FMT_SGRBG10:
+	case V4L2_PIX_FMT_SBGGR10:
+	case V4L2_PIX_FMT_SRGGB10:
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_BGR24:
 		break;



--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkAn1kACgkQMOfwapXb+vLIZQCeOoZPl9euVMkjt6GQyDRG6ZWN
q2wAn1/WUxMfa2HxXKT8PjFgQD1RVnGX
=/3b7
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
