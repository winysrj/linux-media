Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33067 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbeCPUzO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 16:55:14 -0400
Date: Fri, 16 Mar 2018 21:55:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: [RFC, libv4l]: Make libv4l2 usable on devices with complex pipeline
Message-ID: <20180316205512.GA6069@amd>
References: <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd>
 <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
 <20170509110440.GC28248@amd>
 <c4f61bc5-6650-9468-5fbf-8041403a0ef2@xs4all.nl>
 <20170516124519.GA25650@amd>
 <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

What about something like this?

Pass map of controls and expects fds to libv4l2...
=20
+static struct v4l2_controls_map map =3D {
+  .num_fds =3D 2,
+  .num_controls =3D 3,
+  .map =3D { [0] =3D { .control =3D 0x00980913, .fd =3D 1 },
+	   [1] =3D { .control =3D V4L2_CID_EXPOSURE_ABSOLUTE, .fd =3D 1 },
+	   [2] =3D { .control =3D V4L2_CID_FOCUS_ABSOLUTE, .fd =3D 2 },
+	  =20
+         },
+};
+
+static void open_chk(char *name, int fd)
+{
+	int f =3D open(name, O_RDWR);
+
+	if (fd !=3D f) {
+	  printf("Unexpected error %m opening %s\n", name);
+	  exit(1);
+	}
+}
+
+static void cam_open_n900(struct dev_info *dev)
+{
+	struct v4l2_format *fmt =3D &dev->fmt;
+	int fd;
+=09
+	map.main_fd =3D open("/dev/video_ccdc", O_RDWR);
+
+	open_chk("/dev/video_sensor", map.main_fd+1);
+	open_chk("/dev/video_focus", map.main_fd+2);
+	//	open_chk("/dev/video_flash", map.main_fd+3);
+
+	v4l2_open_pipeline(&map, 0);
+	dev->fd =3D map.main_fd;
+

=2E..so you can use it on complex devices. Tested on my N900.

I guess later helper would be added that would parse some kind of
descritption file and do open_pipeline(). But.. lets solve that
next. In the first place, it would be nice to have libv4l2 usable on
complex devices.

Best regards,
							Pavel
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/lib/include/libv4l2.h b/lib/include/libv4l2.h
index ea1870d..6220dfd 100644
--- a/lib/include/libv4l2.h
+++ b/lib/include/libv4l2.h
@@ -109,6 +109,23 @@ LIBV4L_PUBLIC int v4l2_get_control(int fd, int cid);
    (note the fd is left open in this case). */
 LIBV4L_PUBLIC int v4l2_fd_open(int fd, int v4l2_flags);
=20
+struct v4l2_control_map {
+	unsigned long control;
+	int fd;
+};
+
+struct v4l2_controls_map {
+	int main_fd;
+	int num_fds;
+	int num_controls;
+	struct v4l2_control_map map[];
+};
+
+LIBV4L_PUBLIC int v4l2_open_pipeline(struct v4l2_controls_map *map, int v4=
l2_flags);
+
+LIBV4L_PUBLIC int v4l2_get_fd_for_control(int fd, unsigned long control);
+
+
 #ifdef __cplusplus
 }
 #endif /* __cplusplus */
diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
index 1924c91..ebe5dad 100644
--- a/lib/libv4l2/libv4l2-priv.h
+++ b/lib/libv4l2/libv4l2-priv.h
@@ -104,6 +104,7 @@ struct v4l2_dev_info {
 	void *plugin_library;
 	void *dev_ops_priv;
 	const struct libv4l_dev_ops *dev_ops;
+	struct v4l2_controls_map *map;
 };
=20
 /* From v4l2-plugin.c */
diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index 2db25d1..b3ae70b 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -787,6 +787,8 @@ no_capture:
 	if (index >=3D devices_used)
 		devices_used =3D index + 1;
=20
+	devices[index].map =3D NULL;
+
 	/* Note we always tell v4lconvert to optimize src fmt selection for
 	   our default fps, the only exception is the app explicitly selecting
 	   a frame rate using the S_PARM ioctl after a S_FMT */
@@ -1056,12 +1058,39 @@ static int v4l2_s_fmt(int index, struct v4l2_format=
 *dest_fmt)
 	return 0;
 }
=20
+int v4l2_get_fd_for_control(int fd, unsigned long control)
+{
+	int index =3D v4l2_get_index(fd);
+	struct v4l2_controls_map *map =3D devices[index].map;
+	int lo =3D 0;
+	int hi =3D map->num_controls;
+
+	while (lo < hi) {
+		int i =3D (lo + hi) / 2;
+		if (map->map[i].control =3D=3D control) {
+			return map->map[i].fd + fd;
+		}
+		if (map->map[i].control > control) {
+			hi =3D i;
+			continue;
+		}
+		if (map->map[i].control < control) {
+			lo =3D i+1;
+			continue;
+		}
+		printf("Bad: impossible condition in binary search\n");
+		exit(1);
+	}
+	return fd;
+}
+
 int v4l2_ioctl(int fd, unsigned long int request, ...)
 {
 	void *arg;
 	va_list ap;
 	int result, index, saved_err;
-	int is_capture_request =3D 0, stream_needs_locking =3D 0;
+	int is_capture_request =3D 0, stream_needs_locking =3D 0,=20
+	    is_subdev_request =3D 0;
=20
 	va_start(ap, request);
 	arg =3D va_arg(ap, void *);
@@ -1076,18 +1105,20 @@ int v4l2_ioctl(int fd, unsigned long int request, .=
=2E.)
 	   ioctl, causing it to get sign extended, depending upon this behavior */
 	request =3D (unsigned int)request;
=20
+	/* FIXME */
 	if (devices[index].convert =3D=3D NULL)
 		goto no_capture_request;
=20
 	/* Is this a capture request and do we need to take the stream lock? */
 	switch (request) {
-	case VIDIOC_QUERYCAP:
 	case VIDIOC_QUERYCTRL:
 	case VIDIOC_G_CTRL:
 	case VIDIOC_S_CTRL:
 	case VIDIOC_G_EXT_CTRLS:
-	case VIDIOC_TRY_EXT_CTRLS:
 	case VIDIOC_S_EXT_CTRLS:
+		is_subdev_request =3D 1;
+	case VIDIOC_QUERYCAP:
+	case VIDIOC_TRY_EXT_CTRLS:
 	case VIDIOC_ENUM_FRAMESIZES:
 	case VIDIOC_ENUM_FRAMEINTERVALS:
 		is_capture_request =3D 1;
@@ -1151,10 +1182,15 @@ int v4l2_ioctl(int fd, unsigned long int request, .=
=2E.)
 	}
=20
 	if (!is_capture_request) {
+	  int sub_fd;
 no_capture_request:
+		  sub_fd =3D fd;
+		if (is_subdev_request) {
+		  sub_fd =3D v4l2_get_fd_for_control(index, ((struct v4l2_queryctrl *) a=
rg)->id);
+		}
 		result =3D devices[index].dev_ops->ioctl(
 				devices[index].dev_ops_priv,
-				fd, request, arg);
+				sub_fd, request, arg);
 		saved_err =3D errno;
 		v4l2_log_ioctl(request, arg, result);
 		errno =3D saved_err;
@@ -1782,3 +1818,28 @@ int v4l2_get_control(int fd, int cid)
 			(qctrl.maximum - qctrl.minimum) / 2) /
 		(qctrl.maximum - qctrl.minimum);
 }
+
+
+int v4l2_open_pipeline(struct v4l2_controls_map *map, int v4l2_flags)
+{
+	int index;
+	int i;
+
+	for (i=3D0; i<map->num_controls; i++) {
+	  printf("%lx %d\n", map->map[i].control, map->map[i].fd);
+	  if (map->map[i].fd <=3D 0) {
+	    printf("Bad fd in map\n");
+	    return -1;
+	  }
+	  if (i>=3D1 && map->map[i].control <=3D map->map[i-1].control) {
+	    printf("Not sorted\n");
+	    return -1;
+	  }
+	}
+
+	v4l2_fd_open(map->main_fd, v4l2_flags);
+	index =3D v4l2_get_index(map->main_fd);
+	devices[index].map =3D map;
+	return 0;
+}
+
diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/=
control/libv4lcontrol.c
index 1e784ed..1963e7e 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -865,6 +865,7 @@ int v4lcontrol_vidioc_queryctrl(struct v4lcontrol_data =
*data, void *arg)
 	struct v4l2_queryctrl *ctrl =3D arg;
 	int retval;
 	uint32_t orig_id =3D ctrl->id;
+	int fd;
=20
 	/* if we have an exact match return it */
 	for (i =3D 0; i < V4LCONTROL_COUNT; i++)
@@ -874,8 +875,9 @@ int v4lcontrol_vidioc_queryctrl(struct v4lcontrol_data =
*data, void *arg)
 			return 0;
 		}
=20
+	fd =3D v4l2_get_fd_for_control(data->fd, ctrl->id);
 	/* find out what the kernel driver would respond. */
-	retval =3D data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+	retval =3D data->dev_ops->ioctl(data->dev_ops_priv, fd,
 			VIDIOC_QUERYCTRL, arg);
=20
 	if ((data->priv_flags & V4LCONTROL_SUPPORTS_NEXT_CTRL) &&
@@ -905,6 +907,7 @@ int v4lcontrol_vidioc_g_ctrl(struct v4lcontrol_data *da=
ta, void *arg)
 {
 	int i;
 	struct v4l2_control *ctrl =3D arg;
+	int fd;
=20
 	for (i =3D 0; i < V4LCONTROL_COUNT; i++)
 		if ((data->controls & (1 << i)) &&
@@ -913,7 +916,8 @@ int v4lcontrol_vidioc_g_ctrl(struct v4lcontrol_data *da=
ta, void *arg)
 			return 0;
 		}
=20
-	return data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+	fd =3D v4l2_get_fd_for_control(data->fd, ctrl->id);
+	return data->dev_ops->ioctl(data->dev_ops_priv, fd,
 			VIDIOC_G_CTRL, arg);
 }
=20
@@ -996,6 +1000,7 @@ int v4lcontrol_vidioc_s_ctrl(struct v4lcontrol_data *d=
ata, void *arg)
 {
 	int i;
 	struct v4l2_control *ctrl =3D arg;
+	int fd;
=20
 	for (i =3D 0; i < V4LCONTROL_COUNT; i++)
 		if ((data->controls & (1 << i)) &&
@@ -1010,7 +1015,8 @@ int v4lcontrol_vidioc_s_ctrl(struct v4lcontrol_data *=
data, void *arg)
 			return 0;
 		}
=20
-	return data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+	fd =3D v4l2_get_fd_for_control(data->fd, ctrl->id);
+	return data->dev_ops->ioctl(data->dev_ops_priv, fd,
 			VIDIOC_S_CTRL, arg);
 }
=20


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlqsLzAACgkQMOfwapXb+vJ0xwCguP6o5GPJF8vJohB0CONQNole
sI0An2V2vY+SLvLAgaTS8ibvPlm5pgt1
=Fpe2
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
