Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35765 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeEPUx3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 16:53:29 -0400
Date: Wed, 16 May 2018 22:53:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180516205325.GA24044@amd>
References: <20180316205512.GA6069@amd>
 <c2a7e1f3-589d-7186-2a85-545bfa1c4536@xs4all.nl>
 <20180319102354.GA12557@amd>
 <20180319074715.5b700405@vento.lan>
 <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
 <20180319120043.GA20451@amd>
 <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
 <20180319095544.7e235a3e@vento.lan>
 <20180515200117.GA21673@amd>
 <20180515190314.2909e3be@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20180515190314.2909e3be@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > #modes: 2
> > Driver name: OMAP 3 resizer
>=20
> It probably makes sense to place the driver name before #modes.

I dropped the driver for now. It served no purpose...

I got the patches to work on N900. With them (and right)

> From what I understood, the "#foo: <number>" is a tag that makes the
> parser to expect for <number> of "foo".
>=20
> I would also add a first line at the beginning describing the
> version of the format, just in case we add more stuff that
> would require to change something at the format.

Ok, done.

> Except for that, it seems ok.

Good, thanks!

Here's current version of the patch. Code will need moving to
libv4l2. Would "v4l2_open_pipeline()" be suitable name to use?

Best regards,
								Pavel

diff --git a/contrib/test/sdlcam.c b/contrib/test/sdlcam.c
index cc43a10..95f85f9 100644
--- a/contrib/test/sdlcam.c
+++ b/contrib/test/sdlcam.c
@@ -8,7 +8,7 @@
    Copyright 2017 Pavel Machek, LGPL
=20
    Needs sdl2, sdl2_image libraries. sudo aptitude install libsdl2-dev
-   libsdl2-image-dev on Debian systems.
+   libsdl2-image-dev libjpeg-dev on Debian systems.
 */
=20
 #include <time.h>
@@ -26,6 +26,7 @@
 #include <sys/time.h>
 #include <sys/ioctl.h>
 #include <fcntl.h>
+#include <dirent.h>
=20
 #include <jpeglib.h>
=20
@@ -1172,11 +1173,18 @@ static void sdl_iteration(struct sdl *m)
 	}
 }
=20
+static int open_complex(char *name, int v4l2_flags);
+
 static void cam_open(struct dev_info *dev, char *name)
 {
 	struct v4l2_format *fmt =3D &dev->fmt;
=20
-	dev->fd =3D v4l2_open(name, O_RDWR);
+	//	dev->fd =3D v4l2_open(name, O_RDWR);
+	//dev->fd =3D open_complex("/my/tui/camera/n900.cv", 0);
+	dev->fd =3D open_complex("/data/pavel/g/v4l-utils/test.txt", 0);
+	//dev->fd =3D open(name, O_RDWR);
+	//printf("fd =3D %d\n", dev->fd);
+	//dev->fd =3D v4l2_fd_open(dev->fd, 0);
 	if (dev->fd < 0) {
 		printf("video %s open failed: %m\n", name);
 		exit(1);
@@ -1198,6 +1206,179 @@ static void cam_open(struct dev_info *dev, char *na=
me)
=20
 /* ------------------------------------------------------------------ */
=20
+static void scan_devices(char **device_names, int *device_fds, int num)
+{
+	struct dirent **namelist;
+	int n;
+	char *class_v4l =3D "/sys/class/video4linux";
+
+	n =3D scandir(class_v4l, &namelist, NULL, alphasort);
+	if (n < 0) {
+		perror("scandir");
+		return;
+	}
+=09
+	while (n--) {
+		if (namelist[n]->d_name[0] !=3D '.') {
+			char filename[1024], content[1024];
+			sprintf(filename, "%s/%s/name", class_v4l, namelist[n]->d_name);
+			FILE *f =3D fopen(filename, "r");
+			if (!f) {
+				printf("Strange, can't open %s", filename);
+			} else {
+				fgets(content, 1024, f);
+				fclose(f);
+				printf("device %s : %s\n", namelist[n]->d_name, content);
+				int i;
+				for (i =3D num-1; i >=3D0; i--) {
+					if (!strcmp(content, device_names[i])) {
+						sprintf(filename, "/dev/%s", namelist[n]->d_name);
+						device_fds[i] =3D open(filename, O_RDWR);
+						if (device_fds[i] < 0) {
+							printf("Error opening %s: %m\n", filename);
+						}
+						printf("*** found match - %s %d\n", filename, device_fds[i]);
+					}
+				}
+			}
+		}
+		free(namelist[n]);
+	}
+	free(namelist);
+ =20
+}
+
+static int open_complex(char *name, int v4l2_flags)
+{
+#define perr(s) printf("v4l2: open_complex: " s "\n");
+#define BUF 256
+	FILE *f =3D fopen(name, "r");
+
+	int res =3D -1;
+	char buf[BUF];
+	int version, num_modes, num_devices, num_controls;
+	int dev, control;
+
+	if (!f) {
+		perr("open of .cv file failed: %m");
+		goto err;
+	}
+
+	if (fscanf(f, "Complex Video: %d\n", &version) !=3D 1) {
+		perr(".cv file does not have required header");
+		goto close;
+	}
+
+	if (version !=3D 0) {
+		perr(".cv file has unknown version");
+		goto close;
+	}
+ =20
+	if (fscanf(f, "#modes: %d\n", &num_modes) !=3D 1) {
+		perr("could not parse modes");
+		goto close;
+	}
+
+	if (num_modes !=3D 1) {
+		perr("only single mode is supported for now");
+		goto close;
+	}
+
+	if (fscanf(f, "Mode: %s\n", buf) !=3D 1) {
+		perr("could not parse mode name");
+		goto close;
+	}
+
+	if (fscanf(f, " #devices: %d\n", &num_devices) !=3D 1) {
+		perr("could not parse number of devices");
+		goto close;
+	}
+#define MAX_DEVICES 16
+	char *device_names[MAX_DEVICES] =3D { NULL, };
+	int device_fds[MAX_DEVICES];
+	if (num_devices > MAX_DEVICES) {
+		perr("too many devices");
+		goto close;
+	}
+ =20
+	for (dev =3D 0; dev < num_devices; dev++) {
+		int tmp;
+		if (fscanf(f, "%d: ", &tmp) !=3D 1) {
+			perr("could not parse device");
+			goto free_devices;
+		}
+		if (tmp !=3D dev) {
+			perr("bad device number");
+			goto free_devices;
+		}
+		fgets(buf, BUF, f);
+		printf("Device %d %d %s\n", dev, tmp, buf);
+		device_names[dev] =3D strdup(buf);
+		device_fds[dev] =3D -1;
+	}
+
+	scan_devices(device_names, device_fds, num_devices);
+
+	for (dev =3D 0; dev < num_devices; dev++) {
+		printf("Device %d fd %d\n", dev, device_fds[dev]);
+		if (device_fds[dev] =3D=3D -1) {
+			perr("Could not open all required devices");
+			goto close_devices;
+		}
+	}
+
+	if (fscanf(f, " #controls: %d\n", &num_controls) !=3D 1) {
+		perr("can not parse number of controls");
+		goto close_devices;
+	}
+
+	struct v4l2_controls_map *map =3D malloc(sizeof(struct v4l2_controls_map)=
 +
+					       num_controls*sizeof(struct v4l2_control_map));
+
+	map->num_controls =3D num_controls;
+	map->num_fds =3D num_devices;
+	map->main_fd =3D device_fds[0];
+ =20
+	for (control =3D 0; control < num_controls; control++) {
+		unsigned long num;
+		int dev;
+		if (fscanf(f, "0x%lx: %d\n", &num, &dev) !=3D 2) {
+			perr("could not parse control");
+			goto free_map;
+		}
+		if ((dev < 0) || (dev >=3D num_devices)) {
+			perr("device out of range");
+			goto free_map;
+		}
+		map->map[control].control =3D num;
+		map->map[control].fd =3D device_fds[dev];
+		printf("---> map: %lx %d\n", num, device_fds[dev]);
+	}
+	if (fscanf(f, "%s", buf) > 0) {
+		perr("junk at end of file");
+		goto free_map;
+	}
+
+	printf("Success, main fd is %d\n", map->main_fd);
+	res =3D v4l2_open_pipeline(map, v4l2_flags);
+
+	if (res < 0) {
+free_map:
+		free(map);
+close_devices:
+		for (dev =3D 0; dev < num_devices; dev++)
+			close(device_fds[dev]);
+	}
+free_devices:
+	for (dev =3D 0; dev < num_devices; dev++) {
+		free(device_names[dev]);
+	}
+close:
+	fclose(f);
+err:
+	return res;
+}
+
=20
 static struct dev_info dev;
=20
@@ -1206,6 +1387,8 @@ int main(void)
 	int i;
 	struct v4l2_format *fmt =3D &dev.fmt;
=20
+	//open_complex("/my/tui/camera/n900.cv");
+
 	dtime();
 	cam_open(&dev, "/dev/video0");
=20
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
index 2db25d1..6bb232d 100644
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
@@ -1056,12 +1058,47 @@ static int v4l2_s_fmt(int index, struct v4l2_format=
 *dest_fmt)
 	return 0;
 }
=20
+int v4l2_get_fd_for_control(int fd, unsigned long control)
+{
+	int index =3D v4l2_get_index(fd);
+	struct v4l2_controls_map *map;
+	int lo =3D 0;
+	int hi;
+
+	if (index < 0)
+		return fd;
+
+	map =3D devices[index].map;
+	if (!map)
+		return fd;
+	hi =3D map->num_controls;
+
+	while (lo < hi) {
+		int i =3D (lo + hi) / 2;
+		if (map->map[i].control =3D=3D control) {
+			return map->map[i].fd;
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
@@ -1076,18 +1113,20 @@ int v4l2_ioctl(int fd, unsigned long int request, .=
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
@@ -1151,10 +1190,15 @@ int v4l2_ioctl(int fd, unsigned long int request, .=
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
@@ -1782,3 +1826,28 @@ int v4l2_get_control(int fd, int cid)
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
+	i =3D v4l2_fd_open(map->main_fd, v4l2_flags);
+	index =3D v4l2_get_index(map->main_fd);
+	devices[index].map =3D map;
+	return i;
+}
+
diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/=
control/libv4lcontrol.c
index 59f28b1..c1e6f93 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -863,6 +863,7 @@ int v4lcontrol_vidioc_queryctrl(struct v4lcontrol_data =
*data, void *arg)
 	struct v4l2_queryctrl *ctrl =3D arg;
 	int retval;
 	uint32_t orig_id =3D ctrl->id;
+	int fd;
=20
 	/* if we have an exact match return it */
 	for (i =3D 0; i < V4LCONTROL_COUNT; i++)
@@ -872,8 +873,9 @@ int v4lcontrol_vidioc_queryctrl(struct v4lcontrol_data =
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
@@ -903,6 +905,7 @@ int v4lcontrol_vidioc_g_ctrl(struct v4lcontrol_data *da=
ta, void *arg)
 {
 	int i;
 	struct v4l2_control *ctrl =3D arg;
+	int fd;
=20
 	for (i =3D 0; i < V4LCONTROL_COUNT; i++)
 		if ((data->controls & (1 << i)) &&
@@ -911,7 +914,8 @@ int v4lcontrol_vidioc_g_ctrl(struct v4lcontrol_data *da=
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
@@ -994,6 +998,7 @@ int v4lcontrol_vidioc_s_ctrl(struct v4lcontrol_data *da=
ta, void *arg)
 {
 	int i;
 	struct v4l2_control *ctrl =3D arg;
+	int fd;
=20
 	for (i =3D 0; i < V4LCONTROL_COUNT; i++)
 		if ((data->controls & (1 << i)) &&
@@ -1008,7 +1013,8 @@ int v4lcontrol_vidioc_s_ctrl(struct v4lcontrol_data *=
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

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlr8mkUACgkQMOfwapXb+vJfTgCgrlQuB2R7GLSRRhMIN1MEbNcb
JawAn0Ig+FeNrQKip07H1tbvsZzs3wvo
=U9HN
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
