Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38214 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754365AbeGHVdB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Jul 2018 17:33:01 -0400
Date: Sun, 8 Jul 2018 23:32:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        clayton@craftyguy.net, martijn@brixit.nl,
        sakari.ailus@linux.intel.com,
        Filip =?utf-8?Q?Matijevi=C4=87?= <filip.matijevic.pz@gmail.com>,
        mchehab@s-opensource.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: [PATCH, libv4l]: Make libv4l2 usable on devices with complex pipeline
Message-ID: <20180708213258.GA18217@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Add support for opening multiple devices in v4l2_open(), and for
mapping controls between devices.

This is necessary for complex devices, such as Nokia N900.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/lib/include/libv4l2.h b/lib/include/libv4l2.h
index ea1870d..a0ec0a9 100644
--- a/lib/include/libv4l2.h
+++ b/lib/include/libv4l2.h
@@ -58,6 +58,10 @@ LIBV4L_PUBLIC extern FILE *v4l2_log_file;
    invalid memory address will not lead to failure with errno being EFAULT,
    as it would with a real ioctl, but will cause libv4l2 to break, and you
    get to keep both pieces.
+
+   You can open complex pipelines by passing ".cv" file with pipeline
+   description to v4l2_open(). libv4l2 will open all the required
+   devices automatically in that case.
 */
=20
 LIBV4L_PUBLIC int v4l2_open(const char *file, int oflag, ...);
diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
index 1924c91..1ee697a 100644
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
@@ -130,4 +131,20 @@ static inline void v4l2_plugin_cleanup(void *plugin_li=
b, void *plugin_priv,
 extern const char *v4l2_ioctls[];
 void v4l2_log_ioctl(unsigned long int request, void *arg, int result);
=20
+
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
+int v4l2_open_pipeline(struct v4l2_controls_map *map, int v4l2_flags);
+LIBV4L_PUBLIC int v4l2_get_fd_for_control(int fd, unsigned long control);
+
 #endif
diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index 2db25d1..ac430f0 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -70,6 +70,8 @@
 #include <sys/types.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
+#include <dirent.h>
+
 #include "libv4l2.h"
 #include "libv4l2-priv.h"
 #include "libv4l-plugin.h"
@@ -618,6 +620,8 @@ static void v4l2_update_fps(int index, struct v4l2_stre=
amparm *parm)
 		devices[index].fps =3D 0;
 }
=20
+static int v4l2_open_complex(int fd, int v4l2_flags);
+
 int v4l2_open(const char *file, int oflag, ...)
 {
 	int fd;
@@ -641,6 +645,21 @@ int v4l2_open(const char *file, int oflag, ...)
 	if (fd =3D=3D -1)
 		return fd;
=20
+	int len =3D strlen(file);
+	char *end =3D ".cv";
+	int len2 =3D strlen(end);
+	if ((len > len2) && (!strcmp(file + len - len2, end))) {
+		/* .cv extension */
+		struct stat sb;
+
+		if (fstat(fd, &sb) =3D=3D 0) {
+			if ((sb.st_mode & S_IFMT) =3D=3D S_IFREG) {
+				return v4l2_open_complex(fd, 0);
+			}
+		}
+	=09
+	}
+
 	if (v4l2_fd_open(fd, 0) =3D=3D -1) {
 		int saved_err =3D errno;
=20
@@ -787,6 +806,8 @@ no_capture:
 	if (index >=3D devices_used)
 		devices_used =3D index + 1;
=20
+	devices[index].map =3D NULL;
+
 	/* Note we always tell v4lconvert to optimize src fmt selection for
 	   our default fps, the only exception is the app explicitly selecting
 	   a frame rate using the S_PARM ioctl after a S_FMT */
@@ -1056,12 +1077,47 @@ static int v4l2_s_fmt(int index, struct v4l2_format=
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
@@ -1076,18 +1132,19 @@ int v4l2_ioctl(int fd, unsigned long int request, .=
=2E.)
 	   ioctl, causing it to get sign extended, depending upon this behavior */
 	request =3D (unsigned int)request;
=20
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
@@ -1151,10 +1209,15 @@ int v4l2_ioctl(int fd, unsigned long int request, .=
=2E.)
 	}
=20
 	if (!is_capture_request) {
+		int sub_fd;
 no_capture_request:
+		sub_fd =3D fd;
+		if (is_subdev_request) {
+			sub_fd =3D v4l2_get_fd_for_control(index, ((struct v4l2_queryctrl *) ar=
g)->id);
+		}
 		result =3D devices[index].dev_ops->ioctl(
 				devices[index].dev_ops_priv,
-				fd, request, arg);
+				sub_fd, request, arg);
 		saved_err =3D errno;
 		v4l2_log_ioctl(request, arg, result);
 		errno =3D saved_err;
@@ -1782,3 +1845,194 @@ int v4l2_get_control(int fd, int cid)
 			(qctrl.maximum - qctrl.minimum) / 2) /
 		(qctrl.maximum - qctrl.minimum);
 }
+
+int v4l2_open_pipeline(struct v4l2_controls_map *map, int v4l2_flags)
+{
+	int index;
+	int i;
+
+	for (i=3D0; i<map->num_controls; i++) {
+		if (map->map[i].fd <=3D 0) {
+			V4L2_LOG_ERR("v4l2_open_pipeline: Bad fd in map.\n");
+			return -1;
+		}
+		if (i>=3D1 && map->map[i].control <=3D map->map[i-1].control) {
+			V4L2_LOG_ERR("v4l2_open_pipeline: Controls not sorted.\n");
+			return -1;
+		}
+	}
+
+	i =3D v4l2_fd_open(map->main_fd, v4l2_flags);
+	index =3D v4l2_get_index(map->main_fd);
+	devices[index].map =3D map;
+	return i;
+}
+
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
+
+				int i;
+				for (i =3D num-1; i >=3D0; i--) {
+					if (!strcmp(content, device_names[i])) {
+						sprintf(filename, "/dev/%s", namelist[n]->d_name);
+						device_fds[i] =3D open(filename, O_RDWR);
+						if (device_fds[i] < 0) {
+							V4L2_LOG_ERR("Error opening %s: %m\n", filename);
+						}
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
+static int v4l2_open_complex(int fd, int v4l2_flags)
+{
+#define perr(s) V4L2_LOG_ERR("open_complex: " s "\n")
+#define BUF 256
+	FILE *f =3D fdopen(fd, "r");
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
+		device_names[dev] =3D strdup(buf);
+		device_fds[dev] =3D -1;
+	}
+
+	scan_devices(device_names, device_fds, num_devices);
+
+	for (dev =3D 0; dev < num_devices; dev++) {
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
+	}
+	if (fscanf(f, "%s", buf) > 0) {
+		perr("junk at end of file");
+		goto free_map;
+	}
+
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

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltCgwoACgkQMOfwapXb+vIdAQCeIUsBo5vVW1be0ffRILeK3/4a
9eUAnjCBV4neoDSOVH95PHCR12K7ZZjM
=UxGP
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
