Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57748 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752889AbcKTPVa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Nov 2016 10:21:30 -0500
Date: Sun, 20 Nov 2016 16:21:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161120152127.GC5189@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Content-Disposition: inline
In-Reply-To: <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > +static void et8ek8_reglist_to_mbus(const struct et8ek8_reglist *reglis=
t,
> > +				   struct v4l2_mbus_framefmt *fmt)
> > +{
> > +	fmt->width =3D reglist->mode.window_width;
> > +	fmt->height =3D reglist->mode.window_height;
> > +
> > +	if (reglist->mode.pixel_format =3D=3D V4L2_PIX_FMT_SGRBG10DPCM8)
>=20
> The driver doesn't really need to deal with pixel formats. Could you use
> media bus formats instead, and rename the fields accordingly?
>=20
> The reason why it did use pixel formats was that (V4L2) media bus formats
> did not exist when the driver was written. :-)

Makes sense...

Something like this? [untested, will test complete changes.]

									Pavel

diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/e=
t8ek8/et8ek8_driver.c
index 0301e81..eb131b2 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -395,11 +395,7 @@ static void et8ek8_reglist_to_mbus(const struct et8ek8=
_reglist *reglist,
 {
 	fmt->width =3D reglist->mode.window_width;
 	fmt->height =3D reglist->mode.window_height;
-
-	if (reglist->mode.pixel_format =3D=3D V4L2_PIX_FMT_SGRBG10DPCM8)
-		fmt->code =3D MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8;
-	else
-		fmt->code =3D MEDIA_BUS_FMT_SGRBG10_1X10;
+	fmt->code =3D reglist->mode.bus_format;
 }
=20
 static struct et8ek8_reglist *et8ek8_reglist_find_mode_fmt(
@@ -538,7 +534,7 @@ static int et8ek8_reglist_import(struct i2c_client *cli=
ent,
 		       __func__,
 		       list->type,
 		       list->mode.window_width, list->mode.window_height,
-		       list->mode.pixel_format,
+		       list->mode.bus_format,
 		       list->mode.timeperframe.numerator,
 		       list->mode.timeperframe.denominator,
 		       (void *)meta->reglist[nlists].ptr);
@@ -967,21 +963,18 @@ static int et8ek8_enum_mbus_code(struct v4l2_subdev *=
subdev,
 			continue;
=20
 		for (i =3D 0; i < npixelformat; i++) {
-			if (pixelformat[i] =3D=3D mode->pixel_format)
+			if (pixelformat[i] =3D=3D mode->bus_format)
 				break;
 		}
 		if (i !=3D npixelformat)
 			continue;
=20
 		if (code->index =3D=3D npixelformat) {
-			if (mode->pixel_format =3D=3D V4L2_PIX_FMT_SGRBG10DPCM8)
-				code->code =3D MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8;
-			else
-				code->code =3D MEDIA_BUS_FMT_SGRBG10_1X10;
+			code->code =3D mode->bus_format;
 			return 0;
 		}
=20
-		pixelformat[npixelformat] =3D mode->pixel_format;
+		pixelformat[npixelformat] =3D mode->bus_format;
 		npixelformat++;
 	}
=20
diff --git a/drivers/media/i2c/et8ek8/et8ek8_mode.c b/drivers/media/i2c/et8=
ek8/et8ek8_mode.c
index 956fc60..12998d8 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_mode.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_mode.c
@@ -59,7 +59,7 @@ static struct et8ek8_reglist mode1_poweron_mode2_16vga_25=
92x1968_12_07fps =3D {
 		},
 		.max_exp =3D 2012,
 		/* .max_gain =3D 0, */
-		.pixel_format =3D V4L2_PIX_FMT_SGRBG10,
+		.bus_format =3D MEDIA_BUS_FMT_SGRBG10_1X10,
 		.sensitivity =3D 65536
 	},
 	.regs =3D {
@@ -160,7 +160,7 @@ static struct et8ek8_reglist mode1_16vga_2592x1968_13_1=
2fps_dpcm10_8 =3D {
 		},
 		.max_exp =3D 2012,
 		/* .max_gain =3D 0, */
-		.pixel_format =3D V4L2_PIX_FMT_SGRBG10DPCM8,
+		.bus_format =3D MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
 		.sensitivity =3D 65536
 	},
 	.regs =3D {
@@ -216,7 +216,7 @@ static struct et8ek8_reglist mode3_4vga_1296x984_29_99f=
ps_dpcm10_8 =3D {
 		},
 		.max_exp =3D 1004,
 		/* .max_gain =3D 0, */
-		.pixel_format =3D V4L2_PIX_FMT_SGRBG10DPCM8,
+		.bus_format =3D MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
 		.sensitivity =3D 65536
 	},
 	.regs =3D {
@@ -272,7 +272,7 @@ static struct et8ek8_reglist mode4_svga_864x656_29_88fp=
s =3D {
 		},
 		.max_exp =3D 668,
 		/* .max_gain =3D 0, */
-		.pixel_format =3D V4L2_PIX_FMT_SGRBG10,
+		.bus_format =3D MEDIA_BUS_FMT_SGRBG10_1X10,
 		.sensitivity =3D 65536
 	},
 	.regs =3D {
@@ -328,7 +328,7 @@ static struct et8ek8_reglist mode5_vga_648x492_29_93fps=
 =3D {
 		},
 		.max_exp =3D 500,
 		/* .max_gain =3D 0, */
-		.pixel_format =3D V4L2_PIX_FMT_SGRBG10,
+		.bus_format =3D MEDIA_BUS_FMT_SGRBG10_1X10,
 		.sensitivity =3D 65536
 	},
 	.regs =3D {
@@ -384,7 +384,7 @@ static struct et8ek8_reglist mode2_16vga_2592x1968_3_99=
fps =3D {
 		},
 		.max_exp =3D 6092,
 		/* .max_gain =3D 0, */
-		.pixel_format =3D V4L2_PIX_FMT_SGRBG10,
+		.bus_format =3D MEDIA_BUS_FMT_SGRBG10_1X10,
 		.sensitivity =3D 65536
 	},
 	.regs =3D {
@@ -439,7 +439,7 @@ static struct et8ek8_reglist mode_648x492_5fps =3D {
 		},
 		.max_exp =3D 500,
 		/* .max_gain =3D 0, */
-		.pixel_format =3D V4L2_PIX_FMT_SGRBG10,
+		.bus_format =3D MEDIA_BUS_FMT_SGRBG10_1X10,
 		.sensitivity =3D 65536
 	},
 	.regs =3D {
@@ -495,7 +495,7 @@ static struct et8ek8_reglist mode3_4vga_1296x984_5fps =
=3D {
 		},
 		.max_exp =3D 2996,
 		/* .max_gain =3D 0, */
-		.pixel_format =3D V4L2_PIX_FMT_SGRBG10,
+		.bus_format =3D MEDIA_BUS_FMT_SGRBG10_1X10,
 		.sensitivity =3D 65536
 	},
 	.regs =3D {
@@ -551,7 +551,7 @@ static struct et8ek8_reglist mode_4vga_1296x984_25fps_d=
pcm10_8 =3D {
 		},
 		.max_exp =3D 1052,
 		/* .max_gain =3D 0, */
-		.pixel_format =3D V4L2_PIX_FMT_SGRBG10DPCM8,
+		.bus_format =3D MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
 		.sensitivity =3D 65536
 	},
 	.regs =3D {
diff --git a/drivers/media/i2c/et8ek8/et8ek8_reg.h b/drivers/media/i2c/et8e=
k8/et8ek8_reg.h
index 9970bff..64a8fb7 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_reg.h
+++ b/drivers/media/i2c/et8ek8/et8ek8_reg.h
@@ -48,7 +48,7 @@ struct et8ek8_mode {
 	u32 ext_clock;			/* in Hz */
 	struct v4l2_fract timeperframe;
 	u32 max_exp;			/* Maximum exposure value */
-	u32 pixel_format;		/* V4L2_PIX_FMT_xxx */
+	u32 bus_format;			/* MEDIA_BUS_FMT_ */
 	u32 sensitivity;		/* 16.16 fixed point */
 };
=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgxv3cACgkQMOfwapXb+vJ0LQCgsb+Rgq6MJWJX9s13zWIXsMjl
fVoAoL4Y/uJ0YXGcGF6Vggw0j1NXkw1X
=3NEi
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
