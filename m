Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59375 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2998672AbdDZKxD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 06:53:03 -0400
Date: Wed, 26 Apr 2017 12:53:00 +0200
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
Subject: [patch] propagating controls in libv4l2 was Re: support autofocus /
 autogain in libv4l2
Message-ID: <20170426105300.GA857@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20170424224724.5bb52382@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > IMO, the best place for autofocus is at libv4l2. Putting it on a
> > > separate "video server" application looks really weird for me. =20
> >=20
> > Well... let me see. libraries are quite limited -- it is hard to open
> > files, or use threads/have custom main loop. It may be useful to
> > switch resolutions -- do autofocus/autogain at lower resolution, then
> > switch to high one for taking picture. It would be good to have that
> > in "system" code, but I'm not at all sure libv4l2 design will allow
> > that.
>=20
> I don't see why it would be hard to open files or have threads inside
> a library. There are several libraries that do that already, specially
> the ones designed to be used on multimidia apps.

Well, This is what the libv4l2 says:

   This file implements libv4l2, which offers v4l2_ prefixed versions
   of
      open/close/etc. The API is 100% the same as directly opening
   /dev/videoX
      using regular open/close/etc, the big difference is that format
   conversion
  =20
but if I open additional files in v4l2_open(), API is no longer the
same, as unix open() is defined to open just one file descriptor.

Now. There is autogain support in libv4lconvert, but it expects to use
same fd for camera and for the gain... which does not work with
subdevs.

Of course, opening subdevs by name like this is not really
acceptable. But can you suggest a method that is?

Thanks,
								Pavel

commit 4cf9d10ead014c0db25452e4bb9cd144632407c3
Author: Pavel <pavel@ucw.cz>
Date:   Wed Apr 26 11:38:04 2017 +0200

    Add subdevices.

diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
index 343db5e..a6bc48e 100644
--- a/lib/libv4l2/libv4l2-priv.h
+++ b/lib/libv4l2/libv4l2-priv.h
@@ -26,6 +26,7 @@
 #include "../libv4lconvert/libv4lsyscall-priv.h"
=20
 #define V4L2_MAX_DEVICES 16
+#define V4L2_MAX_SUBDEVS 8
 /* Warning when making this larger the frame_queued and frame_mapped membe=
rs of
    the v4l2_dev_info struct can no longer be a bitfield, so the code needs=
 to
    be adjusted! */
@@ -104,6 +105,7 @@ struct v4l2_dev_info {
 	void *plugin_library;
 	void *dev_ops_priv;
 	const struct libv4l_dev_ops *dev_ops;
+        int subdev_fds[V4L2_MAX_SUBDEVS];
 };
=20
 /* From v4l2-plugin.c */
diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index 0ba0a88..edc9642 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -1,3 +1,4 @@
+/* -*- c-file-style: "linux" -*- */
 /*
 #             (C) 2008 Hans de Goede <hdegoede@redhat.com>
=20
@@ -789,18 +790,25 @@ no_capture:
=20
 	/* Note we always tell v4lconvert to optimize src fmt selection for
 	   our default fps, the only exception is the app explicitly selecting
-	   a fram erate using the S_PARM ioctl after a S_FMT */
+	   a frame rate using the S_PARM ioctl after a S_FMT */
 	if (devices[index].convert)
 		v4lconvert_set_fps(devices[index].convert, V4L2_DEFAULT_FPS);
 	v4l2_update_fps(index, &parm);
=20
+	devices[index].subdev_fds[0] =3D SYS_OPEN("/dev/video_sensor", O_RDWR, 0);
+	devices[index].subdev_fds[1] =3D SYS_OPEN("/dev/video_focus", O_RDWR, 0);
+	devices[index].subdev_fds[2] =3D -1;
+
+	printf("Sensor: %d, focus: %d\n", devices[index].subdev_fds[0],=20
+	       devices[index].subdev_fds[1]);
+
 	V4L2_LOG("open: %d\n", fd);
=20
 	return fd;
 }
=20
 /* Is this an fd for which we are emulating v4l1 ? */
-static int v4l2_get_index(int fd)
+int v4l2_get_index(int fd)
 {
 	int index;
=20

commit 1d6a9ce121f53e8f2e38549eed597a3c3dea5233
Author: Pavel <pavel@ucw.cz>
Date:   Wed Apr 26 12:34:04 2017 +0200

    Enable ioctl propagation.

diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index edc9642..6dab661 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -1064,6 +1064,23 @@ static int v4l2_s_fmt(int index, struct v4l2_format =
*dest_fmt)
 	return 0;
 }
=20
+static int v4l2_propagate_ioctl(int index, unsigned long request, void *ar=
g)
+{
+	int i =3D 0;
+	int result;
+	while (1) {
+		if (devices[index].subdev_fds[i] =3D=3D -1)
+			return -1;
+		printf("g_ctrl failed, trying...\n");
+		result =3D SYS_IOCTL(devices[index].subdev_fds[i], request, arg);
+		printf("subdev %d result %d\n", i, result);
+		if (result =3D=3D 0)
+			return 0;
+		i++;
+	}
+	return -1;
+}
+
 int v4l2_ioctl(int fd, unsigned long int request, ...)
 {
 	void *arg;
@@ -1193,14 +1210,20 @@ no_capture_request:
 	switch (request) {
 	case VIDIOC_QUERYCTRL:
 		result =3D v4lconvert_vidioc_queryctrl(devices[index].convert, arg);
+		if (result =3D=3D -1)
+			result =3D v4l2_propagate_ioctl(index, request, arg);
 		break;
=20
 	case VIDIOC_G_CTRL:
 		result =3D v4lconvert_vidioc_g_ctrl(devices[index].convert, arg);
+		if (result =3D=3D -1)
+			result =3D v4l2_propagate_ioctl(index, request, arg);
 		break;
=20
 	case VIDIOC_S_CTRL:
 		result =3D v4lconvert_vidioc_s_ctrl(devices[index].convert, arg);
+		if (result =3D=3D -1)
+			result =3D v4l2_propagate_ioctl(index, request, arg);
 		break;
=20
 	case VIDIOC_G_EXT_CTRLS:


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkAfAsACgkQMOfwapXb+vLcAwCggy+h9fRmvN4qvADN/nqoZCvX
69MAmwXHnF8cRmpb+r0sOxNesWQUqbRJ
=4juX
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
