Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out01.alice.it ([85.33.2.12]:4807 "EHLO
	smtp-out01.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbZKQKwH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 05:52:07 -0500
Date: Tue, 17 Nov 2009 11:41:47 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>
Subject: [RFC, PATCH] gspca: implement vidioc_enum_frameintervals
Message-Id: <20091117114147.09889427.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_Nov_2009_11_41_47_+0100_4_FZxpW41s9TvfxY"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Tue__17_Nov_2009_11_41_47_+0100_4_FZxpW41s9TvfxY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

gspca does not implement vidioc_enum_frameintervals yet, so even if a
camera can support multiple frame rates (or frame intervals) there is
still no way to enumerate them from userspace.

The following is just a quick and dirty implementation to show the
problem and to have something to base the discussion on. In the patch
there is also a working example of use with the ov534 subdriver.

Someone with a better knowledge of gspca and v4l internals can suggest
better solutions.

The tests has been done using 'luvcview -L', the output before the
patch:
    $ luvcview -d /dev/video1 -L
    luvcview 0.2.6

    SDL information:
      Video driver: x11
      A window manager is available
    Device information:
      Device path:  /dev/video1
    { pixelformat =3D 'YUYV', description =3D 'YUYV' }
    { discrete: width =3D 320, height =3D 240 }
	    Time interval between frame:
    1/40, 1/30, { discrete: width =3D 640, height =3D 480 }
	    Time interval between frame:


And the output after it:
    $ luvcview -d /dev/video1 -L
    luvcview 0.2.6

    SDL information:
      Video driver: x11
      A window manager is available
    Device information:
      Device path:  /dev/video1
    { pixelformat =3D 'YUYV', description =3D 'YUYV' }
    { discrete: width =3D 320, height =3D 240 }
	    Time interval between frame: 1/125, 1/100, 1/75, 1/60, 1/50, 1/40, 1/3=
0,
    { discrete: width =3D 640, height =3D 480 }
	    Time interval between frame: 1/60, 1/50, 1/40, 1/30, 1/15,=20

Thanks,
   Antonio

diff -r 182b5f8fa160 linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Sun Nov 15 10:05:30 2009 +0100
+++ b/linux/drivers/media/video/gspca/gspca.c	Tue Nov 17 11:39:21 2009 +0100
@@ -995,6 +995,37 @@
 	return -EINVAL;
 }
=20
+static int vidioc_enum_frameintervals(struct file *filp, void *priv,
+				      struct v4l2_frmivalenum *fival)
+{
+	struct gspca_dev *gspca_dev =3D priv;
+	int mode =3D wxh_to_mode(gspca_dev, fival->width, fival->height);
+	int i;
+	__u32 index =3D 0;
+
+	if (gspca_dev->cam.mode_framerates =3D=3D NULL ||
+			gspca_dev->cam.mode_framerates[mode].nrates =3D=3D 0)
+		return -EINVAL;
+
+	/* FIXME: Needed? */
+	if (fival->pixel_format !=3D
+			gspca_dev->cam.cam_mode[mode].pixelformat)
+		return -EINVAL;
+
+	for (i =3D 0; i < gspca_dev->cam.mode_framerates[mode].nrates; i++) {
+		if (fival->index =3D=3D index) {
+			fival->type =3D V4L2_FRMSIZE_TYPE_DISCRETE;
+			fival->discrete.numerator =3D 1;
+			fival->discrete.denominator =3D
+				gspca_dev->cam.mode_framerates[mode].rates[i];
+			return 0;
+		}
+		index++;
+	}
+
+	return -EINVAL;
+}
+
 static void gspca_release(struct video_device *vfd)
 {
 	struct gspca_dev *gspca_dev =3D container_of(vfd, struct gspca_dev, vdev);
@@ -1987,6 +2018,7 @@
 	.vidioc_g_parm		=3D vidioc_g_parm,
 	.vidioc_s_parm		=3D vidioc_s_parm,
 	.vidioc_enum_framesizes =3D vidioc_enum_framesizes,
+	.vidioc_enum_frameintervals =3D vidioc_enum_frameintervals,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register	=3D vidioc_g_register,
 	.vidioc_s_register	=3D vidioc_s_register,
diff -r 182b5f8fa160 linux/drivers/media/video/gspca/gspca.h
--- a/linux/drivers/media/video/gspca/gspca.h	Sun Nov 15 10:05:30 2009 +0100
+++ b/linux/drivers/media/video/gspca/gspca.h	Tue Nov 17 11:39:21 2009 +0100
@@ -45,11 +45,17 @@
 /* image transfers */
 #define MAX_NURBS 4		/* max number of URBs */
=20
+struct framerates {
+	int *rates;
+	int nrates;
+};
+
 /* device information - set at probe time */
 struct cam {
 	int bulk_size;		/* buffer size when image transfer by bulk */
 	const struct v4l2_pix_format *cam_mode;	/* size nmodes */
 	char nmodes;
+	const struct framerates *mode_framerates; /* size nmode, like cam_mode */
 	__u8 bulk_nurbs;	/* number of URBs in bulk mode
 				 * - cannot be > MAX_NURBS
 				 * - when 0 and bulk_size !=3D 0 means
diff -r 182b5f8fa160 linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Sun Nov 15 10:05:30 2009 +0100
+++ b/linux/drivers/media/video/gspca/ov534.c	Tue Nov 17 11:39:21 2009 +0100
@@ -287,6 +287,20 @@
 	 .priv =3D 0},
 };
=20
+static int qvga_rates[] =3D {125, 100, 75, 60, 50, 40, 30};
+static int vga_rates[] =3D {60, 50, 40, 30, 15};
+
+static const struct framerates ov772x_framerates[] =3D {
+	{ /* 320x240 */
+		.rates =3D qvga_rates,
+		.nrates =3D ARRAY_SIZE(qvga_rates),
+	},
+	{ /* 640x480 */
+		.rates =3D vga_rates,
+		.nrates =3D ARRAY_SIZE(vga_rates),
+	},
+};
+
 static const struct v4l2_pix_format ov965x_mode[] =3D {
 	{320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
 	 .bytesperline =3D 320,
@@ -1411,6 +1425,7 @@
 	if (sd->sensor =3D=3D SENSOR_OV772X) {
 		cam->cam_mode =3D ov772x_mode;
 		cam->nmodes =3D ARRAY_SIZE(ov772x_mode);
+		cam->mode_framerates =3D ov772x_framerates;
=20
 		cam->bulk =3D 1;
 		cam->bulk_size =3D 16384;


--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Tue__17_Nov_2009_11_41_47_+0100_4_FZxpW41s9TvfxY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksCfesACgkQ5xr2akVTsAGQtQCgnuSYueDSBnExiQfBlNqR1T+G
alcAn3HDV3ayUriKLOdYDfHJv/gItRF0
=I8rf
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Nov_2009_11_41_47_+0100_4_FZxpW41s9TvfxY--
