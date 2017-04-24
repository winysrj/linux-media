Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40389 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167977AbdDXJbE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 05:31:04 -0400
Date: Mon, 24 Apr 2017 11:30:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: support autofocus / autogain in libv4l2
Message-ID: <20170424093059.GA20427@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <20170419105118.72b8e284@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

For focus to be useful, we need autofocus implmented
somewhere. Unfortunately, v4l framework does not seem to provide good
place where to put autofocus. I believe, long-term, we'll need some
kind of "video server" providing this kind of services.

Anyway, we probably don't want autofocus in kernel (even through some
cameras do it in hardware), and we probably don't want autofocus in
each and every user application.

So what remains is libv4l2. Now, this is in no way clean or complete,
and functionality provided by sdl.c and asciicam.c probably _should_
be in application, but... I'd like to get the code out there.

Oh and yes, I've canibalized decode_tm6000.c application instead of
introducing my own. Autotools scare me, sorry.

Regards,
							Pavel

diff --git a/lib/libv4l2/asciicam.c b/lib/libv4l2/asciicam.c
new file mode 100644
index 0000000..5388967
--- /dev/null
+++ b/lib/libv4l2/asciicam.c
@@ -0,0 +1,63 @@
+/* gcc asciicam.c /usr/lib/i386-linux-gnu/libv4l2.so.0.0.0 -o asciicam
+   gcc asciicam.c /usr/lib/arm-linux-gnueabi/libv4l2.so.0 -o asciicam
+
+gcc -std=3Dgnu99 -DHAVE_CONFIG_H -I. -I../.. -fvisibility=3Dhidden -I../..=
/lib/include -Wall -Wpointer-arith -D_GNU_SOURCE -I../../include -g -O2 asc=
iicam.c libv4l2.c /usr/lib/arm-linux-gnueabi/libv4lconvert.so.0 log.c v4l2c=
onvert.c v4l2-plugin.c -o asciicam
+ */
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include <linux/videodev2.h>
+
+#define SIZE 10*1024*1024
+
+char buf[SIZE];
+
+void main(void)
+{
+  int fd =3D v4l2_open("/dev/video2", O_RDWR);
+  int i;
+  static struct v4l2_format fmt;
+
+#if 1
+  fmt.type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
+  fmt.fmt.pix.pixelformat =3D V4L2_PIX_FMT_RGB24;
+  fmt.fmt.pix.field =3D V4L2_FIELD_INTERLACED;
+  fmt.fmt.pix.width =3D 640;
+  fmt.fmt.pix.height =3D 480;
+  if (fmt.fmt.pix.pixelformat !=3D 'RGB3') /* v4l2_fourcc('R', 'G', 'B', '=
3'); */
+    printf("hmm. strange format?\n");
+ =20
+  printf("ioctl =3D %d\n", v4l2_ioctl(fd, VIDIOC_S_FMT, &fmt));
+#endif
+
+  for (i=3D0; i<500; i++) {
+    int num =3D v4l2_read(fd, buf, SIZE);
+    int y,x;
+   =20
+    printf("%d\n", num);
+#if 0
+    for (y =3D 0; y < 25; y++) {
+      for (x =3D 0; x < 80; x++) {
+	int y1 =3D y * 480/25;
+	int x1 =3D x * 640/80;
+	int c =3D buf[fmt.fmt.pix.width*3*y1 + 3*x1] +
+	  buf[fmt.fmt.pix.width*3*y1 + 3*x1 + 1] +
+	  buf[fmt.fmt.pix.width*3*y1 + 3*x1 + 2];
+
+	if (c < 30) c =3D ' ';
+	else if (c < 60) c =3D '.';
+	else if (c < 120) c =3D '_';
+	else if (c < 180) c =3D 'o';
+	else if (c < 300) c =3D 'x';
+	else if (c < 400) c =3D 'X';
+	else c =3D '#';
+	 =20
+	printf("%c", c);
+      }
+      printf("\n");
+    }
+#endif   =20
+  }
+}
diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
index 343db5e..af740a7 100644
--- a/lib/libv4l2/libv4l2-priv.h
+++ b/lib/libv4l2/libv4l2-priv.h
@@ -1,3 +1,4 @@
+/* -*- c-file-style: "linux" -*- */
 /*
 #             (C) 2008 Hans de Goede <hdegoede@redhat.com>
=20
@@ -70,6 +71,14 @@
 	} while (0)
=20
 #define MIN(a, b) (((a) < (b)) ? (a) : (b))
+#define V4L2_MAX_SUBDEVS 16
+
+#define V4L2_MAX_FOCUS 10
+struct v4l2_focus_step {
+	int num;
+	int sharpness[V4L2_MAX_FOCUS];
+	int position[V4L2_MAX_FOCUS];
+};
=20
 struct v4l2_dev_info {
 	int fd;
@@ -104,6 +113,14 @@ struct v4l2_dev_info {
 	void *plugin_library;
 	void *dev_ops_priv;
 	const struct libv4l_dev_ops *dev_ops;
+        int subdev_fds[V4L2_MAX_SUBDEVS];
+  	int exposure;=20
+  	int frame;
+  	int focus;
+
+	/* Autofocus parameters */
+	int focus_frame, focus_exposure, focus_step, sh_prev;
+	struct v4l2_focus_step focus_step_params;
 };
=20
 /* From v4l2-plugin.c */
diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index 0ba0a88..3b84437 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -1,3 +1,4 @@
+/* -*- c-file-style: "linux" -*- */
 /*
 #             (C) 2008 Hans de Goede <hdegoede@redhat.com>
=20
@@ -100,6 +101,13 @@ static struct v4l2_dev_info devices[V4L2_MAX_DEVICES] =
=3D {
 };
 static int devices_used;
=20
+#include "sdl.c"
+
+static struct sdl sdl;
+
+int v4l2_get_index(int fd);
+void my_main(void);
+
 static int v4l2_ensure_convert_mmap_buf(int index)
 {
 	if (devices[index].convert_mmap_buf !=3D MAP_FAILED) {
@@ -311,7 +319,409 @@ static int v4l2_queue_read_buffer(int index, int buff=
er_index)
 	return 0;
 }
=20
-static int v4l2_dequeue_and_convert(int index, struct v4l2_buffer *buf,
+static void v4l2_paint(char *buf, int x1, int y1, const struct v4l2_format=
 *fmt)
+{
+  int y, x;
+  int width =3D fmt->fmt.pix.width;
+  printf("width =3D %d\n", width);
+   =20
+    for (y =3D 0; y < 25; y++) {
+      for (x =3D 0; x < 80; x++) {
+	int c =3D buf[width*4*y1 + 4*x1] +
+	  buf[width*4*y1 + 4*x1 + 1] +
+	  buf[width*4*y1 + 4*x1 + 2];
+
+	if (c < 30) c =3D ' ';
+	else if (c < 60) c =3D '.';
+	else if (c < 120) c =3D '_';
+	else if (c < 180) c =3D 'o';
+	else if (c < 300) c =3D 'x';
+	else if (c < 400) c =3D 'X';
+	else c =3D '#';
+	 =20
+	printf("%c", c);
+      }
+      printf("\n");
+    }
+}
+
+#define SX 80
+#define SY 25
+#define BUCKETS 20
+
+static void v4l2_histogram(unsigned char *buf, int cdf[], struct v4l2_form=
at *fmt)
+{
+    for (int y =3D 0; y < fmt->fmt.pix.height; y+=3D19)
+      for (int x =3D 0; x < fmt->fmt.pix.width; x+=3D19) {
+	pixel p =3D buf_pixel(fmt, buf, x, y);
+=09
+	int b;
+	/* HACK: we divide green by 2 to have nice picture, undo it here. */
+	b =3D p.r + 2*p.g + p.b;
+	b =3D (b * BUCKETS)/(256);
+	cdf[b]++;
+      }
+}
+
+static long v4l2_sharpness(unsigned char *buf, struct v4l2_format *fmt)
+{
+  int h =3D fmt->fmt.pix.height;
+  int w =3D fmt->fmt.pix.width;
+  long r =3D 0;
+
+    for (int y =3D h/3; y < h-h/3; y+=3Dh/9)
+      for (int x =3D w/3; x < w-w/3; x++) {
+	pixel p1 =3D buf_pixel(fmt, buf, x, y);
+	pixel p2 =3D buf_pixel(fmt, buf, x+2, y);
+=09
+	int b1, b2;
+	/* HACK: we divide green by 2 to have nice picture, undo it here. */
+	b1 =3D p1.r + 2*p1.g + p1.b;
+	b2 =3D p2.r + 2*p2.g + p2.b;
+
+	int v;
+	v =3D (b1-b2)*(b1-b2);
+	if (v > 36)
+		r+=3Dv;
+      }
+
+    return r;
+}
+
+int v4l2_set_exposure(int fd, int exposure)
+{
+	int index =3D v4l2_get_index(fd);
+
+	if (index =3D=3D -1 || devices[index].convert =3D=3D NULL) {
+		V4L2_LOG_ERR("v4l2_set_exposure called with invalid fd: %d\n", fd);
+		errno =3D EBADF;
+		return -1;
+	}
+
+	struct v4l2_control ctrl;
+	ctrl.id =3D V4L2_CID_EXPOSURE;
+	ctrl.value =3D exposure;
+	if (ioctl(devices[index].subdev_fds[0], VIDIOC_S_CTRL, &ctrl) < 0) {
+	  printf("Could not set exposure\n");
+	}
+	return 0;
+}
+
+int v4l2_set_gain(int fd, int gain)
+{
+	int index =3D v4l2_get_index(fd);
+
+	if (index =3D=3D -1 || devices[index].convert =3D=3D NULL) {
+		V4L2_LOG_ERR("v4l2_set_exposure called with invalid fd: %d\n", fd);
+		errno =3D EBADF;
+		return -1;
+	}
+=09
+	struct v4l2_control ctrl;
+	ctrl.id =3D 0x00980913;
+	ctrl.value =3D gain;
+	if (ioctl(devices[index].subdev_fds[0], VIDIOC_S_CTRL, &ctrl) < 0) {
+	  printf("Could not set exposure\n");
+	}
+	return 0;
+}
+
+int v4l2_set_focus(int fd, int diopt)
+{
+	int index =3D v4l2_get_index(fd);
+
+	if (index =3D=3D -1 || devices[index].convert =3D=3D NULL) {
+		V4L2_LOG_ERR("v4l2_set_focus called with invalid fd: %d\n", fd);
+		errno =3D EBADF;
+		return -1;
+	}
+
+	struct v4l2_control ctrl;
+	ctrl.id =3D V4L2_CID_FOCUS_ABSOLUTE;
+	ctrl.value =3D diopt;
+	if (ioctl(devices[index].subdev_fds[1], VIDIOC_S_CTRL, &ctrl) < 0) {
+		printf("Could not set focus\n");
+	}
+	return 0;
+}
+
+#define LESS 1
+#define MID 0
+#define MORE 2
+
+static void v4l2_start_focus_step(struct v4l2_focus_step *fs, int focus, i=
nt step)
+{
+	int i;
+
+	fs->num =3D 3;
+	for (i=3D0; i<V4L2_MAX_FOCUS; i++) {
+		fs->sharpness[i] =3D -1;
+		fs->position[i] =3D -1;
+	}
+
+	fs->position[LESS] =3D focus - step;
+	fs->position[MID] =3D focus;
+	fs->position[MORE] =3D focus + step;
+}
+
+static int v4l2_focus_get_best(struct v4l2_focus_step *fs)
+{
+	int i, max =3D -1, maxi =3D -1;
+=09
+	for (i=3D0; i<fs->num; i++)
+		if (max < fs->sharpness[i]) {
+			max =3D fs->sharpness[i];
+			maxi =3D i;
+		}
+
+	return maxi;
+}
+
+static void v4l2_auto_focus_continuous(struct v4l2_dev_info *m, int sh)
+{
+	int f =3D m->frame - m->focus_frame;
+	int step;
+	const int max_step =3D 300, min_step =3D 20;
+	struct v4l2_focus_step *fs =3D &m->focus_step_params;
+
+	if (m->focus_step =3D=3D 0 || m->focus_step > max_step) {
+		printf("step reset -- max\n");
+		m->focus_step =3D max_step;
+	}
+	if (m->focus_step < min_step) {
+		printf("step reset -- 10 (%d)\n", m->focus_step);
+		m->focus_step =3D min_step;
+		/* It takes cca 5.7 seconds to achieve the focus:
+		   0.76user 0.30system 5.66 (0m5.661s) elapsed 18.72%CPU
+		 */
+		printf("Focused at %d\n", m->focus);
+		exit(0);
+	}
+
+	step =3D m->focus_step;
+
+	if (m->exposure !=3D m->focus_exposure) {
+		m->focus_frame =3D m->frame;
+		m->focus_exposure =3D m->exposure;
+		v4l2_start_focus_step(fs, m->focus, m->focus_step);
+		return;
+	}
+	if (m->focus < step) {
+		m->focus =3D step;
+	}
+
+	const int every =3D 3;
+	if (f%every)
+		return;
+
+	{
+		int i =3D f/every;
+
+		if (i =3D=3D 0) {
+			printf("Can not happen?\n");
+			return;
+		}
+		i--;
+		if (i < fs->num)
+			v4l2_set_focus(m->fd, fs->position[i]);
+		if (i > 0)
+			fs->sharpness[i-1] =3D sh;
+		if (i < fs->num)
+			return;
+	}
+	int i;
+	for (i=3D0; i<fs->num; i++) {
+		printf("%d: %d | ", fs->position[i], fs->sharpness[i]);
+	}
+	int best =3D v4l2_focus_get_best(fs);
+	if ((fs->sharpness[best] < m->sh_prev) && (m->focus_step < max_step)) {
+		m->focus_step *=3D2;
+		m->sh_prev =3D m->sh_prev * 0.9;
+		printf("step up %d\n", m->focus_step);
+	} else if (best =3D=3D LESS) {
+		printf("less ");
+		m->focus -=3D step;
+	} else if (best =3D=3D MORE) {
+		printf("more ");
+		m->focus +=3D step;
+	} else {
+		m->sh_prev =3D fs->sharpness[MID];
+		m->focus_step =3D m->focus_step / 2;
+		printf("step %d ", m->focus_step);
+	}
+	m->focus_frame =3D m->frame;
+	v4l2_start_focus_step(fs, m->focus, m->focus_step);
+	printf("Focus now %d\n", m->focus);
+}
+
+static void v4l2_start_focus_sweep(struct v4l2_focus_step *fs, int focus, =
int step)
+{
+	int i;
+
+	fs->num =3D V4L2_MAX_FOCUS;
+	for (i=3D0; i<V4L2_MAX_FOCUS; i++) {
+		fs->sharpness[i] =3D -1;
+		fs->position[i] =3D -1;
+	}
+
+	int f =3D focus;
+	for (i=3D0; i<V4L2_MAX_FOCUS; i++) {
+		fs->position[i] =3D f;
+		f +=3D step;
+	}
+}
+
+static void v4l2_auto_focus_single(struct v4l2_dev_info *m, int sh)
+{
+	int f =3D m->frame - m->focus_frame;
+	int step;
+	struct v4l2_focus_step *fs =3D &m->focus_step_params;
+
+	if (m->focus_step =3D=3D 0) {
+		printf("step reset -- max\n");
+		m->focus_step =3D 1;
+	}
+
+	if (m->exposure !=3D m->focus_exposure) {
+		m->focus_frame =3D m->frame;
+		m->focus_exposure =3D m->exposure;
+		v4l2_start_focus_sweep(fs, 0, 100);
+		return;
+	}
+
+	const int every =3D 3;
+	if (f%every)
+		return;
+
+	{
+		int i =3D f/every;
+
+		if (i =3D=3D 0) {
+			printf("Can not happen?\n");
+			return;
+		}
+		i--;
+		if (i < fs->num)
+			v4l2_set_focus(m->fd, fs->position[i]);
+		if (i > 0)
+			fs->sharpness[i-1] =3D sh;
+		if (i < fs->num)
+			return;
+	}
+#if 0
+	int i;
+	for (i=3D0; i<fs->num; i++) {
+		printf("%d: %d | ", fs->position[i], fs->sharpness[i]);
+	}
+#endif
+	int best =3D v4l2_focus_get_best(fs);
+	m->focus_frame =3D m->frame;
+	switch (m->focus_step) {
+	case 1:
+		printf("Best now %d / %d\n", fs->position[best], fs->sharpness[best]);
+		v4l2_start_focus_sweep(fs, fs->position[best] - 50, 10);
+		m->focus_step =3D 2;
+		break;
+	case 2:
+		printf("Best now %d / %d\n", fs->position[best], fs->sharpness[best]);
+		v4l2_start_focus_sweep(fs, fs->position[best] - 10, 2);
+		m->focus_step =3D 3;
+		break;
+	case 3:
+		printf("Best now %d / %d\n", fs->position[best], fs->sharpness[best]);
+		printf("done.\n");
+		exit(0);
+	}
+}
+
+
+static void v4l2_auto_exposure(int index, struct v4l2_buffer *buf)
+{
+	struct v4l2_format *fmt;
+	int cdf[BUCKETS] =3D { 0, };
+	int i;
+
+	fmt =3D &devices[index].src_fmt;
+
+	v4l2_histogram(devices[index].frame_pointers[buf->index], cdf, fmt);
+
+#if 0
+	printf("hist: ");
+	for (i =3D 0; i<BUCKETS; i++)
+		printf("%d ", cdf[i]);
+	printf("\n");
+#endif
+	for (i=3D1; i<BUCKETS; i++)
+		cdf[i] +=3D cdf[i-1];
+
+	int b =3D BUCKETS;
+	int brightPixels =3D cdf[b-1] - cdf[b-8];
+	int targetBrightPixels =3D cdf[b-1]/50;
+	int maxSaturatedPixels =3D cdf[b-1]/200;
+	int saturatedPixels =3D cdf[b-1] - cdf[b-2];
+	// how much should I change brightness by
+	float adjustment =3D 1.0f;
+#if 0
+	printf( "AutoExposure: totalPixels: %d,"
+		"brightPixels: %d, targetBrightPixels: %d,"
+		"saturatedPixels: %d, maxSaturatedPixels: %d\n",
+		cdf[b-1], brightPixels, targetBrightPixels,
+		saturatedPixels, maxSaturatedPixels);
+#endif
+	 =20
+	if (saturatedPixels > maxSaturatedPixels) {
+		// first don't let things saturate too much
+		adjustment =3D 1.0f - ((float)(saturatedPixels - maxSaturatedPixels))/cd=
f[b-1];
+	} else if (brightPixels < (targetBrightPixels - (saturatedPixels * 4))) {
+		// increase brightness to try and hit the desired number of well exposed=
 pixels
+		int l =3D b-6;
+		while (brightPixels < targetBrightPixels && l > 0) {
+			brightPixels +=3D cdf[l];
+			brightPixels -=3D cdf[l-1];
+			l--;
+		}
+
+		// that level is supposed to be at b-11;
+		adjustment =3D ((float) (b-6+1))/(l+1);
+	} else {
+		// we're not oversaturated, and we have enough bright pixels. Do nothing.
+	}
+
+	{
+		float limit =3D 4;
+		if (adjustment > limit) { adjustment =3D limit; }
+		if (adjustment < 1/limit) { adjustment =3D 1/limit; }
+	}
+	 =20
+	if (!devices[index].exposure)
+		devices[index].exposure =3D 1;
+	devices[index].exposure *=3D adjustment;
+	if (adjustment !=3D 1.)
+		printf( "AutoExposure: adjustment: %f exposure %d\n", adjustment, device=
s[index].exposure);
+
+	v4l2_set_exposure(devices[index].fd, devices[index].exposure);
+}
+
+static void v4l2_statistics(int index, struct v4l2_buffer *buf)
+{
+	unsigned char *b;
+	struct v4l2_format *fmt;
+
+	fmt =3D &devices[index].src_fmt;
+	b =3D devices[index].frame_pointers[buf->index];
+
+	if (!(devices[index].frame%3))
+		v4l2_auto_exposure(index, buf);
+=09
+	int sh =3D v4l2_sharpness(b, fmt);
+	v4l2_auto_focus_single(&devices[index], sh);
+=09
+	devices[index].frame++;
+	if (!(devices[index].frame%4))
+		sdl_render(&sdl, b, fmt);
+}
+
+int v4l2_dequeue_and_convert(int index, struct v4l2_buffer *buf,
 		unsigned char *dest, int dest_size)
 {
 	const int max_tries =3D V4L2_IGNORE_FIRST_FRAME_ERRORS + 1;
@@ -345,6 +755,13 @@ static int v4l2_dequeue_and_convert(int index, struct =
v4l2_buffer *buf,
 			errno =3D -EINVAL;
 			return -1;
 		}
+	=09
+#if 1
+		v4l2_statistics(index, buf);
+#endif
+#if 0
+		/* This is rather major eater of CPU time. CPU time goes from 80% to 4%=
=20
+		   when conversion is disabled. */
=20
 		result =3D v4lconvert_convert(devices[index].convert,
 				&devices[index].src_fmt, &devices[index].dest_fmt,
@@ -352,7 +769,7 @@ static int v4l2_dequeue_and_convert(int index, struct v=
4l2_buffer *buf,
 				buf->bytesused, dest ? dest : (devices[index].convert_mmap_buf +
 					buf->index * devices[index].convert_mmap_frame_size),
 				dest_size);
-
+#endif
 		if (devices[index].first_frame) {
 			/* Always treat convert errors as EAGAIN during the first few frames, as
 			   some cams produce bad frames at the start of the stream
@@ -789,18 +1206,24 @@ no_capture:
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
@@ -823,6 +1246,10 @@ int v4l2_close(int fd)
 {
 	int index, result;
=20
+	if (fd =3D=3D -2) {
+	  my_main();
+	}
+
 	index =3D v4l2_get_index(fd);
 	if (index =3D=3D -1)
 		return SYS_CLOSE(fd);
@@ -1782,3 +2209,65 @@ int v4l2_get_control(int fd, int cid)
 			(qctrl.maximum - qctrl.minimum) / 2) /
 		(qctrl.maximum - qctrl.minimum);
 }
+
+void v4l2_debug(void)
+{
+	printf("debug\n");
+}
+
+/* ------------------------------------------------------------------ */
+
+#define SIZE 10*1024*1024
+
+char buf[SIZE];
+
+void my_main(void)
+{
+	int fd =3D v4l2_open("/dev/video2", O_RDWR);
+	int i;
+	static struct v4l2_format fmt;
+
+	fmt.type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	fmt.fmt.pix.pixelformat =3D V4L2_PIX_FMT_RGB24;
+	fmt.fmt.pix.field =3D V4L2_FIELD_INTERLACED;
+	fmt.fmt.pix.width =3D 640;
+	fmt.fmt.pix.height =3D 480;
+
+	v4l2_set_gain(fd, 300);
+	v4l2_set_exposure(fd, 10000);
+	v4l2_set_focus(fd, 0);
+
+
+	printf("ioctl =3D %d\n", v4l2_ioctl(fd, VIDIOC_S_FMT, &fmt));
+
+	printf("capture is %d, %d\n", fmt.fmt.pix.width, fmt.fmt.pix.height);
+	/* factor =3D=3D 2 still fits window, but very slow. factor =3D=3D 6 .. */
+	/* factor needs to be odd, otherwise ... fun with BA10 format. */
+	sdl_init(&sdl, fmt.fmt.pix.width, fmt.fmt.pix.height, 5);
+ =20
+	v4l2_debug();
+
+	/* In 800x600 "raw" mode, this should take cca 17.8 seconds (without
+	   sdl output. CPU usage should be cca 5% without conversion). That's 28 =
fps.
+	   (benchmark with i<500)
+	*/
+	for (i=3D0; i<50000; i++) {
+		int num =3D v4l2_read(fd, buf, SIZE);
+
+		if (i=3D=3D490) {
+			printf("Focus to closest.... -------------------\n");
+			v4l2_set_focus(fd, 99999);
+		}
+   =20
+#if 0
+		v4l2_paint(buf, 640/80, 480/25, &fmt);
+#endif
+		/* Over USB connection, rendering every single frame slows
+		   execution down from 23 seconds to 36 seconds. */
+#if 0
+		if (!(i%4))
+			sdl_render(&sdl, buf, &fmt);
+#endif
+	}
+ =20
+}
diff --git a/lib/libv4l2/sdl.c b/lib/libv4l2/sdl.c
new file mode 100644
index 0000000..17a8d24
--- /dev/null
+++ b/lib/libv4l2/sdl.c
@@ -0,0 +1,530 @@
+/* -*- c-file-style: "linux" -*- */
+/* SDL support.
+
+   Copyright 2017 Pavel Machek, LGPL
+*/
+
+#include <SDL2/SDL.h>
+#include <SDL2/SDL_image.h>
+
+struct sdl {
+	SDL_Window *window;
+	SDL_Surface *liveview, *screen;
+
+	int wx, wy;
+	int sx, sy;
+	int bx, by;
+	int factor;
+	float focus, gain, exposure, do_focus, do_exposure;=20
+};
+
+#if 0
+void loop(void) {
+	int done;
+	SDL_Event event;
+
+	while(!done){ //While program isn't done                                 =
 =20
+		while(SDL_PollEvent(&event)){ //Poll events                       =20
+			switch(event.type){ //Check event type                    =20
+			case SDL_QUIT: //User hit the X (or equivelent)           =20
+				done =3D true; //Make the loop end                  =20
+				break; //We handled the event                     =20
+			} //Finished with current event                           =20
+		} //Done with all events for now                                  =20
+	} //Program done, exited                                                 =
 =20
+}
+#endif
+
+typedef struct {
+	Uint8 r;
+	Uint8 g;
+	Uint8 b;
+	Uint8 alpha;
+} pixel;
+
+#define d_raw 1
+
+void sfc_put_pixel(SDL_Surface* liveview, int x, int y, pixel *p)
+{
+	Uint32* p_liveview =3D (Uint32*)liveview->pixels;
+	p_liveview +=3D y*liveview->w+x;
+	*p_liveview =3D SDL_MapRGBA(liveview->format,p->r,p->g,p->b,p->alpha);
+}
+
+#if 0
+int pix_exposure(float x)
+{
+	return sy*x / 199410.0;
+}
+
+int pix_gain(float x)
+{
+	return sy*x / 16.0;
+}
+
+int render_statistics(SDL_Surface* liveview)
+{
+	pixel white;
+	white.r =3D (Uint8)0xff;
+	white.g =3D (Uint8)0xff;
+	white.b =3D (Uint8)0xff;
+	white.alpha =3D (Uint8)128;
+
+	//printf("Stats: focus %d, gain %d, exposure %d\n", focus, gain, exposure=
);
+
+	for (int x=3D0; x<sx && x<sx*focus; x++)
+		put_pixel(liveview, x, 0, &white);
+
+	for (int y=3D0; y<sy && y<pix_gain(gain); y++)
+		put_pixel(liveview, 0, y, &white);
+
+	for (int y=3D0; y<sy && y<pix_exposure(exposure); y++)
+		put_pixel(liveview, sx-1, y, &white);
+
+	for (int x=3D0; x<sx; x++)
+		put_pixel(liveview, x, sy-1, &white);
+
+	return 0;
+}
+#endif
+
+void sdl_begin_paint(struct sdl *m) {
+	//Fill the surface white                                                 =
 =20
+	SDL_FillRect(m->liveview, NULL, SDL_MapRGB( m->liveview->format, 0, 0, 0 =
));
+
+	SDL_LockSurface(m->liveview);
+}
+
+void sdl_finish_paint(struct sdl *m) {
+	SDL_UnlockSurface(m->liveview);
+	SDL_Rect rcDest =3D { m->bx, m->by, m->sx, m->sy };
+
+	SDL_BlitSurface(m->liveview, NULL, m->screen, &rcDest);
+	//Update the surface                                                     =
 =20
+	SDL_UpdateWindowSurfaceRects(m->window, &rcDest, 1);
+}
+ =20
+void sdl_paint_image(struct sdl *m, char **xpm, int x, int y) {
+	SDL_Surface *image =3D IMG_ReadXPMFromArray(xpm);
+	if (!image) {
+		printf("IMG_Load: %s\n", IMG_GetError());
+		exit(1);
+	}
+
+	int x_pos =3D x - image->w/2, y_pos =3D y - image->h/2;
+
+	SDL_Rect rcDest =3D { x_pos, y_pos, image->w, image->h };
+	int r =3D SDL_BlitSurface ( image, NULL, m->screen, &rcDest );
+
+	if (r) {
+		printf("Error blitting: %s\n", SDL_GetError());
+		exit(1);
+	}
+	SDL_FreeSurface ( image );
+}
+
+void sdl_paint_ui(struct sdl *m) {
+	static char *wait_xpm[] =3D {
+		"16 9 2 1",
+		"# c #ffffff",
+		". c #000000",
+		"....########....",
+		".....#....#.....",
+		".....#....#.....",
+		"......#..#......",
+		".......##.......",
+		"......#..#......",
+		".....#....#.....",
+		".....#....#.....",
+		"....########....",
+	};
+
+	static char *ok_xpm[] =3D {
+		"16 9 2 1",
+		"# c #ffffff",
+		". c #000000",
+		"...............#",
+		"............###.",
+		"..........##....",
+		"#.......##......",
+		".#.....#........",
+		"..#...#.........",
+		"..#..#..........",
+		"...##...........",
+		"...#............",
+	};
+
+	static char *exit_xpm[] =3D {
+		"16 9 2 1",
+		"x c #ffffff",
+		". c #000000",
+		"....x......x....",
+		".....x....x.....",
+		"......x..x......",
+		".......xx.......",
+		".......xx.......",
+		"......x..x......",
+		".....x....x.....",
+		"....x......x....",
+		"................",
+	};
+
+	static char *f1m_xpm[] =3D {
+		"16 9 2 1",
+		"# c #ffffff",
+		". c #000000",
+		"....##..........",
+		"...#.#..........",
+		"..#..#..........",
+		".....#...#.#.##.",
+		".....#...##.#..#",
+		".....#...#..#..#",
+		".....#...#..#..#",
+		".....#...#..#..#",
+		"................",
+	};
+
+	static char *f25cm_xpm[] =3D {
+		"16 9 2 1",
+		"x c #ffffff",
+		". c #000000",
+		".xxx..xxxx......",
+		"x...x.x.........",
+		"...x..xxx.......",
+		"..x......x..xx.x",
+		".x.......x.x.xxx",
+		"xxxxx.xxx...xxxx",
+		"................",
+		"................",
+		"................",
+	};
+
+	static char *iso400_xpm[] =3D {
+		"16 12 2 1",
+		"x c #ffffff",
+		". c #000000",
+		"x..x.xxxx.xxxx..",
+		"x..x.x..x.x..x..",
+		"xxxx.x..x.x..x..",
+		"...x.x..x.x..x..",
+		"...x.xxxx.xxxx..",
+		"................",
+		".x..xx..x.......",
+		".x.x...x.x......",
+		".x..x..x.x......",
+		".x...x.x.x......",
+		".x.xx...x.......",
+		"................",
+	};
+
+	static char *time_1_100_xpm[] =3D {
+		"16 12 2 1",
+		"x c #ffffff",
+		". c #000000",
+		".x....x.........",
+		".x...x..........",
+		".x..x...........",
+		".x.x............",
+		"................",
+		"..x.xxxx.xxxx...",
+		"..x.x..x.x..x...",
+		"..x.x..x.x..x...",
+		"..x.x..x.x..x...",
+		"..x.x..x.x..x...",
+		"..x.xxxx.xxxx...",
+		"................",
+	};
+
+	static char *time_1_10_xpm[] =3D {
+		"16 12 2 1",
+		"x c #ffffff",
+		". c #000000",
+		".x....x.........",
+		".x...x..........",
+		".x..x...........",
+		".x.x............",
+		"................",
+		"..x.xxxx........",
+		"..x.x..x........",
+		"..x.x..x........",
+		"..x.x..x........",
+		"..x.x..x........",
+		"..x.xxxx........",
+		"................",
+	};
+
+	static char *af_xpm[] =3D {
+		"16 12 2 1",
+		"x c #ffffff",
+		". c #000000",
+		".....xxxxxxx....",
+		".....x..........",
+		".....x..........",
+		".x...xxxxx......",
+		"x.x..x..........",
+		"xxx..x..........",
+		"x.x..x..........",
+		"x.x..x..........",
+		"................",
+		"................",
+		"................",
+		"................",
+	};
+
+	static char *ae_xpm[] =3D {
+		"16 12 2 1",
+		"x c #ffffff",
+		". c #000000",
+		".....xxxxxxx....",
+		".....x..........",
+		".....x..........",
+		".x...xxxxx......",
+		"x.x..x..........",
+		"xxx..x..........",
+		"x.x..x..........",
+		"x.x..xxxxxxx....",
+		"................",
+		"................",
+		"................",
+		"................",
+	};
+   =20
+	static char *not_xpm[] =3D {
+		"16 12 2 1",
+		"x c #ffffff",
+		". c #000000",
+		"......xxxxx.....",
+		"....xx.....xx...",
+		"...x.........x..",
+		"..x........xx.x.",
+		"..x......xx...x.",
+		".x.....xx......x",
+		".x...xx........x",
+		"..xxx.........x.",
+		"..x...........x.",
+		"...x.........x..",
+		"....xx.....xx...",
+		"......xxxxx.....",
+	};
+
+	static char *empty_xpm[] =3D {
+		"16 12 2 1",
+		"x c #ffffff",
+		". c #000000",
+		"................",
+		"................",
+		"................",
+		"................",
+		"................",
+		"................",
+		"................",
+		"................",
+		"................",
+		"................",
+		"................",
+		"................",
+	};
+
+	SDL_FillRect(m->screen, NULL, SDL_MapRGB( m->liveview->format, 0, 0, 0 ));
+	sdl_paint_image(m, wait_xpm,  m->wx/2,     m->wy/2);
+	sdl_paint_image(m, ok_xpm,    m->wx-m->bx/2,  m->wy-m->by/2);
+	sdl_paint_image(m, exit_xpm,  m->bx/2,     m->wy-m->by/2);
+	sdl_paint_image(m, f1m_xpm,   m->bx+m->sx/20, m->by/2);
+	sdl_paint_image(m, f25cm_xpm, m->bx+m->sx/5,  m->by/2);
+
+	sdl_paint_image(m, af_xpm,    m->bx/2,     m->by/2);
+	if (!m->do_focus) {
+		sdl_paint_image(m, not_xpm,  16+m->bx/2,     m->by/2);     =20
+	}
+	sdl_paint_image(m, ae_xpm,    m->wx-m->bx/2,  m->by/2);
+	if (!m->do_exposure) {
+		sdl_paint_image(m, not_xpm,  16+m->bx/2,     m->by/2);     =20
+	}
+
+#if 0
+	sdl_paint_image(m, time_1_100_xpm, m->wx-m->bx/2, m->by+pix_exposure(1000=
0));
+	sdl_paint_image(m, time_1_10_xpm,  m->wx-m->bx/2, m->by+pix_exposure(1000=
00));
+	sdl_paint_image(m, iso400_xpm,     m->bx/2,    m->by+pix_gain(4.0));
+#endif
+	=09
+	SDL_UpdateWindowSurface(m->window);
+}
+
+void fmt_print(struct v4l2_format *fmt)
+{
+	int f;
+	printf("Format: %dx%d. ", fmt->fmt.pix.width, fmt->fmt.pix.height);
+	printf("%x ", fmt->fmt.pix.pixelformat);
+	f =3D fmt->fmt.pix.pixelformat;
+	for (int i=3D0; i<4; i++) {
+		printf("%c", f & 0xff);
+		f >>=3D 8;
+	}
+	printf("\n");
+}
+
+pixel buf_pixel(struct v4l2_format *fmt, unsigned char *buf, int x, int y)
+{
+	pixel p =3D { 0, 0, 0, 0 };
+	int pos =3D x + y*fmt->fmt.pix.width;
+	int b;
+
+	p.alpha =3D 128;
+
+	switch (fmt->fmt.pix.pixelformat) {
+	case '01AB': /* BA10, aka GRBG10,=20
+			https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-srgg=
b10.html?highlight=3Dba10
+		     */
+		b =3D buf[pos*2];
+		b +=3D buf[pos*2+1] << 8;
+		b /=3D 4;
+		if ((y % 2) =3D=3D 0) {
+			switch (x % 2) {
+			case 0: p.g =3D b/2; break;
+			case 1: p.r =3D b; break;
+			}
+		} else {
+			switch (x % 2) {
+			case 0: p.b =3D b; break;
+			case 1: p.g =3D b/2; break;
+			}
+		}
+		break;
+
+	case V4L2_PIX_FMT_RGB24:
+		pos *=3D 4;
+		p.r =3D buf[pos];
+		p.g =3D buf[pos+1];
+		p.b =3D buf[pos+2];
+		break;
+
+	default:
+		printf("Wrong pixel format!\n");
+		fmt_print(fmt);
+		exit(1);
+	}
+
+	return p;
+}
+
+void sdl_render(struct sdl *m, unsigned char *buf, struct v4l2_format *fmt)
+{
+	if (!m->window)=20
+		return;
+	sdl_begin_paint(m);   =20
+	/* do your rendering here */
+
+	for (int y =3D 0; y < m->sy; y++)
+		for (int x =3D 0; x < m->sx; x++) {
+			pixel p =3D buf_pixel(fmt, buf, x*m->factor, y*m->factor);
+			p.alpha =3D 128;
+			sfc_put_pixel(m->liveview, x, y, &p);
+		}
+
+	//render_statistics(liveview);
+
+	sdl_finish_paint(m);
+}
+
+#if 0
+void imageStatistics(FCam::Image img)
+{
+	int sx, sy;
+
+	sx =3D img.size().width;                                                 =
        =20
+	sy =3D img.size().height;                                                =
        =20
+	printf("Image is %d x %d, ", sx, sy);                                    =
      =20
+
+	printf("(%d) ", img.brightness(sx/2, sy/2));
+
+	int dark =3D 0;                                                          =
        =20
+	int bright =3D 0;                                                        =
        =20
+	int total =3D 0;                                                         =
        =20
+#define RATIO 10
+	for (int y =3D sy/(2*RATIO); y < sy; y +=3D sy/RATIO)                    =
          =20
+		for (int x =3D sx/(2*RATIO); x < sx; x +=3D sx/RATIO) {                 =
  =20
+			int br =3D img.brightness(x, y);                              =20
+
+			if (!d_raw) {
+				/* It seems real range is 60 to 218 */
+				if (br > 200)
+					bright++;                                              =20
+				if (br < 80)
+					dark++;
+			} else {
+				/* there's a lot of noise, it seems black is commonly 65..71,
+				   bright is cca 1023 */
+				if (br > 1000)
+					bright++;
+				if (br < 75)
+					dark++;
+			}
+			total++;                                                     =20
+		}
+
+	printf("%d dark %d bri,", dark, bright);                    =20
+
+	long sharp =3D 0;
+	for (int y =3D sy/3; y < 2*(sy/3); y+=3Dsy/12) {
+		int b =3D -1;
+		for (int x =3D sx/3; x < 2*(sx/3); x++) {
+			int b2;                                                               =
=20
+			b2 =3D img.brightness(x, y/2);                                         =
=20
+			if (b !=3D -1)
+				sharp +=3D (b-b2) * (b-b2);                                           =
  =20
+			b =3D b2;                                                              =
 =20
+		}
+	}
+	printf("sh %d\n", sharp);
+}
+#endif
+
+
+void sdl_init(struct sdl *m, int _sx, int _sy, int _factor)
+{
+	printf("Initing SDL\n");
+
+	if (SDL_Init(SDL_INIT_VIDEO) < 0) {
+		printf("Could not init SDL\n");
+		exit(1);
+	}
+
+	atexit(SDL_Quit);
+
+	m->wx =3D 800;
+	m->wy =3D 400;
+
+	m->window =3D SDL_CreateWindow( "Camera", SDL_WINDOWPOS_UNDEFINED,
+				      SDL_WINDOWPOS_UNDEFINED, m->wx, m->wy,
+				      SDL_WINDOW_SHOWN );
+	if (m->window =3D=3D NULL) {
+		printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );
+	}
+
+	m->screen =3D SDL_GetWindowSurface(m->window);
+	if (!m->screen) {
+		printf("Couldn't create liveview\n");
+		exit(1);
+	}
+
+	m->sx =3D _sx;
+	m->sy =3D _sy;
+	m->factor =3D _factor;
+
+	m->sx /=3D m->factor;
+	m->sy /=3D m->factor;
+   =20
+	m->focus =3D 0;
+	m->gain =3D 0;
+	m->exposure =3D 0;
+
+	m->bx =3D (m->wx-m->sx)/2;
+	m->by =3D (m->wy-m->sy)/2;
+
+	m->liveview =3D SDL_CreateRGBSurface(0,m->sx,m->sy,32,0,0,0,0);
+	if (!m->liveview) {
+		printf("Couldn't create liveview\n");
+		exit(1);
+	}
+	sdl_paint_ui(m);
+}
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lco=
nvert.c
index d3d8936..7521ec8 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -1205,6 +1205,8 @@ static int v4lconvert_convert_pixfmt(struct v4lconver=
t_data *data,
 			v4lconvert_swap_uv(src, dest, fmt);
 			break;
 		}
+		default:
+		  /* This is bad, fixme? */
 		break;
=20
 	case V4L2_PIX_FMT_YVU420:
@@ -1228,6 +1230,8 @@ static int v4lconvert_convert_pixfmt(struct v4lconver=
t_data *data,
 		case V4L2_PIX_FMT_YVU420:
 			memcpy(dest, src, width * height * 3 / 2);
 			break;
+		default:
+		  /* This is bad, fixme? */
 		}
 		break;
=20
diff --git a/utils/decode_tm6000/Makefile.am b/utils/decode_tm6000/Makefile=
=2Eam
index ac4e85e..f059e3c 100644
--- a/utils/decode_tm6000/Makefile.am
+++ b/utils/decode_tm6000/Makefile.am
@@ -1,4 +1,4 @@
 bin_PROGRAMS =3D decode_tm6000
 decode_tm6000_SOURCES =3D decode_tm6000.c
-decode_tm6000_LDADD =3D ../libv4l2util/libv4l2util.la
+decode_tm6000_LDADD =3D ../libv4l2/libv4l2.la
 decode_tm6000_LDFLAGS =3D $(ARGP_LIBS)
diff --git a/utils/decode_tm6000/decode_tm6000.c b/utils/decode_tm6000/deco=
de_tm6000.c
index 4bffbdd..fda7e3b 100644
--- a/utils/decode_tm6000/decode_tm6000.c
+++ b/utils/decode_tm6000/decode_tm6000.c
@@ -1,365 +1,16 @@
-/*
-   decode_tm6000.c - decode multiplexed format from TM5600/TM6000 USB
+/* gcc asciicam.c /usr/lib/i386-linux-gnu/libv4l2.so.0.0.0 -o asciicam
+   gcc asciicam.c /usr/lib/arm-linux-gnueabi/libv4l2.so.0 -o asciicam
=20
-   Copyright (C) 2007 Mauro Carvalho Chehab <mchehab@infradead.org>
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation version 2.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA 02110-1335 =
USA.
+gcc -std=3Dgnu99 -DHAVE_CONFIG_H -I. -I../.. -fvisibility=3Dhidden -I../..=
/lib/include -Wall -Wpointer-arith -D_GNU_SOURCE -I../../include -g -O2 asc=
iicam.c libv4l2.c /usr/lib/arm-linux-gnueabi/libv4lconvert.so.0 log.c v4l2c=
onvert.c v4l2-plugin.c -o asciicam
  */
-#include "../libv4l2util/v4l2_driver.h"
 #include <stdio.h>
-#include <string.h>
-#include <argp.h>
-#include <unistd.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
-#include <stdlib.h>
-#include <errno.h>
-
-const char *argp_program_version=3D"decode_tm6000 version 0.0.1";
-const char *argp_program_bug_address=3D"Mauro Carvalho Chehab <mchehab@inf=
radead.org>";
-const char doc[]=3D"Decodes tm6000 proprietary format streams";
-const struct argp_option options[] =3D {
-	{"verbose",	'v',	0,	0,	"enables debug messages", 0},
-	{"device",	'd',	"DEV",	0,	"uses device for reading", 0},
-	{"output",	'o',	"FILE",	0,	"outputs raw stream to a file", 0},
-	{"input",	'i',	"FILE",	0,	"parses a file, instead of a device", 0},
-	{"freq",	'f',	"Freq",	0,	"station frequency, in MHz (default is 193.25)",=
 0},
-	{"nbufs",	'n',	"quant",0,	"number of video buffers", 0},
-	{"audio",	'a',	0,	0,	"outputs audio on stdout", 0},
-	{"read",	'r',	0,	0,	"use read() instead of mmap method", 0},
-	{ 0, 0, 0, 0, 0, 0 }
-};
-
-static char outbuf[692224];
-static int debug=3D0, audio=3D0, use_mmap=3D1, nbufs=3D4;
-static float freq_mhz=3D193.25;
-static char *devicename=3D"/dev/video0";
-static char *filename=3DNULL;
-static enum {
-	NORMAL,
-	INPUT,
-	OUTPUT
-} mode =3D NORMAL;
-
-static FILE *fout;
-
-//const char args_doc[]=3D"ARG1 ARG2";
-
-static error_t parse_opt (int key, char *arg, struct argp_state *state)
-{
-	switch (key) {
-	case 'a':
-		audio++;
-		break;
-	case 'r':
-		use_mmap=3D0;
-		break;
-	case 'v':
-		debug++;
-		break;
-	case 'd':
-		devicename=3Darg;
-		break;
-	case 'i':
-	case 'o':
-		if (mode!=3DNORMAL) {
-			argp_error(state,"You can't use input/output options simultaneously.\n"=
);
-			break;
-		}
-		if (key=3D=3D'i')
-			mode=3DINPUT;
-		else
-			mode=3DOUTPUT;
-
-		filename=3Darg;
-		break;
-	case 'f':
-		freq_mhz=3Datof(arg);
-		break;
-	case 'n':
-		nbufs=3Datoi(arg);
-		if  (nbufs<2)
-			nbufs=3D2;
-		break;
-	default:
-		return ARGP_ERR_UNKNOWN;
-	}
-	return 0;
-}
-
-static struct argp argp =3D {
-	.options=3Doptions,
-	.parser=3Dparse_opt,
-	.args_doc=3DNULL,
-	.doc=3Ddoc,
-};
=20
-#define TM6000_URB_MSG_LEN 180
-enum {
-	TM6000_URB_MSG_VIDEO=3D1,
-	TM6000_URB_MSG_AUDIO,
-	TM6000_URB_MSG_VBI,
-	TM6000_URB_MSG_PTS,
-	TM6000_URB_MSG_ERR,
-};
-
-const char *tm6000_msg_type[]=3D {
-	"unknown(0)",	//0
-	"video",	//1
-	"audio",	//2
-	"vbi",		//3
-	"pts",		//4
-	"err",		//5
-	"unknown(6)",	//6
-	"unknown(7)",	//7
-};
-
-#define dprintf(fmt,arg...) \
-	if (debug) fprintf(stderr, fmt, ##arg)
-
-static int recebe_buffer (struct v4l2_buffer *v4l2_buf, struct v4l2_t_buf =
*buf)
-{
-	dprintf("Received %zd bytes\n", buf->length);
-fflush(stdout);
-	memcpy (outbuf,buf->start,buf->length);
-	return buf->length;
-}
-
-
-static int prepare_read (struct v4l2_driver *drv)
-{
-	struct v4l2_format fmt;
-	double freq;
-	int rc;
-
-	memset (drv,0,sizeof(*drv));
-
-	if (v4l2_open (devicename, 1,drv)<0) {
-		perror ("Error opening dev");
-		return -1;
-	}
-
-	memset (&fmt,0,sizeof(fmt));
-
-	uint32_t pixelformat=3DV4L2_PIX_FMT_TM6000;
-
-	if (v4l2_gettryset_fmt_cap (drv,V4L2_SET,&fmt, 720, 480,
-				    pixelformat,V4L2_FIELD_ANY)) {
-		perror("set_input to tm6000 raw format");
-		return -1;
-	}
-
-	if (freq_mhz) {
-		freq=3Dfreq_mhz * 1000 * 1000;
-		rc=3Dv4l2_getset_freq (drv,V4L2_SET, &freq);
-		if (rc<0)
-			printf ("Cannot set freq to %.3f MHz\n",freq_mhz);
-	}
-
-	if (use_mmap) {
-		printf("Preparing for receiving frames on %d buffers...\n",nbufs);
-		fflush (stdout);
-
-		rc=3Dv4l2_mmap_bufs(drv, nbufs);
-		if (rc<0) {
-			printf ("Cannot mmap %d buffers\n",nbufs);
-			return -1;
-		}
-
-//		v4l2_stop_streaming(&drv);
-		rc=3Dv4l2_start_streaming(drv);
-		if (rc<0) {
-			printf ("Cannot start streaming\n");
-			return -1;
-		}
-	}
-	printf("Waiting for frames...\n");
-
-	return 0;
-}
+#include <linux/videodev2.h>
=20
-static int read_stream (struct v4l2_driver *drv, int fd)
+void main(void)
 {
-	if (use_mmap) {
-		fd_set fds;
-		struct timeval tv;
-		int r;
-
-		FD_ZERO (&fds);
-		FD_SET (fd, &fds);
-
-		/* Timeout. */
-		tv.tv_sec =3D 2;
-		tv.tv_usec =3D 0;
-
-		r =3D select (fd + 1, &fds, NULL, NULL, &tv);
-		if (-1 =3D=3D r) {
-			if (EINTR =3D=3D errno) {
-				perror ("select");
-				return -errno;
-			}
-		}
-
-		if (0 =3D=3D r) {
-			fprintf (stderr, "select timeout\n");
-			return -errno;
-		}
-
-		return v4l2_rcvbuf(drv, recebe_buffer);
-	} else {
-		int size=3Dread(fd, outbuf, sizeof(outbuf));
-		return size;
-	}
-
-	return 0;
-}
-
-static int read_char (struct v4l2_driver *drv, int fd)
-{
-	static int sizebuf=3D0;
-	static unsigned char *p=3DNULL;
-	unsigned char c;
-
-	if (sizebuf<=3D0) {
-		sizebuf=3Dread_stream(drv,fd);
-		if (sizebuf<=3D0)
-			return -1;
-		p=3D(unsigned char *)outbuf;
-	}
-	c=3D*p;
-	p++;
-	sizebuf--;
-
-	return c;
-}
-
-
-int main (int argc, char*argv[])
-{
-	int fd;
-	unsigned int i;
-	unsigned char buf[TM6000_URB_MSG_LEN], img[720*2*480];
-	unsigned int  cmd, size, field, block, line, pos=3D0;
-	unsigned long header=3D0;
-	int           linesize=3D720*2,skip=3D0;
-	struct v4l2_driver drv;
-
-	argp_parse (&argp, argc, argv, 0, 0, 0);
-
-	if (mode!=3DINPUT) {
-		if (prepare_read (&drv)<0)
-			return -1;
-		fd=3Ddrv.fd;
-	} else {
-		/*mode =3D=3D INPUT */
-
-		fd=3Dopen(filename,O_RDONLY);
-		if (fd<0) {
-			perror ("error opening a file for parsing");
-			return -1;
-		}
-		dprintf("file %s opened for parsing\n",filename);
-		use_mmap=3D0;
-	}
-
-	if (mode=3D=3DOUTPUT) {
-		fout=3Dfopen(filename,"w");
-		if (!fout) {
-			perror ("error opening a file to write");
-			return -1;
-		}
-		dprintf("file %s opened for output\n",filename);
-
-		do {
-			size=3Dread_stream (&drv,fd);
-
-			if (size<=3D0) {
-				close (fd);
-				return -1;
-			}
-			dprintf("writing %d bytes\n",size);
-			fwrite(outbuf,1, size,fout);
-//			fflush(fout);
-		} while (1);
-	}
-
-
-	while (1) {
-		skip=3D0;
-		header=3D0;
-		do {
-			int c;
-			c=3Dread_char (&drv,fd);
-			if (c<0) {
-				perror("read");
-				return -1;
-			}
-
-			header=3D(header>>8)&0xffffff;
-			header=3Dheader|(c<<24);
-			skip++;
-		} while ( (((header>>24)&0xff) !=3D 0x47) );
-
-		/* split the header fields */
-		size  =3D (((header & 0x7e)<<1) -1) * 4;
-		block =3D (header>>7) & 0xf;
-		field =3D (header>>11) & 0x1;
-		line  =3D (header>>12) & 0x1ff;
-		cmd   =3D (header>>21) & 0x7;
-
-		/* Read the remaining buffer */
-		for (i=3D0;i<sizeof(buf);i++) {
-			int c;
-			c=3Dread_char (&drv,fd);
-			if (c<0) {
-				perror("read");
-				return -1;
-			}
-			buf[i]=3Dc;
-		}
-
-		/* FIXME: Mounts the image as field0+field1
-			* It should, instead, check if the user selected
-			* entrelaced or non-entrelaced mode
-			*/
-		pos=3D((line<<1)+field)*linesize+
-					block*TM6000_URB_MSG_LEN;
-
-			/* Prints debug info */
-		dprintf("0x%08x (skip %d), %s size=3D%d, line=3D%d, field=3D%d, block=3D=
%d\n",
-				(unsigned int)header, skip,
-				 tm6000_msg_type[cmd],
-				 size, line, field, block);
-
-		/* Don't allow to write out of the buffer */
-		if (pos+sizeof(buf) > sizeof(img))
-			cmd =3D TM6000_URB_MSG_ERR;
-
-		/* handles each different URB message */
-		switch(cmd) {
-		case TM6000_URB_MSG_VIDEO:
-			/* Fills video buffer */
-			memcpy(buf,&img[pos],sizeof(buf));
-		case TM6000_URB_MSG_AUDIO:
-			if (audio)
-				fwrite(buf,sizeof(buf),1,stdout);
-//		case TM6000_URB_MSG_VBI:
-//		case TM6000_URB_MSG_PTS:
-		break;
-		}
-	}
-	close(fd);
-	return 0;
+  v4l2_close(-2);
 }

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlj9xdMACgkQMOfwapXb+vIW5wCgk4hn9tdgRV75Y2IZ02eDwQ1y
PDYAoKO0qzRMiz8ryfepZ4z68Vm+7wLR
=MfJ3
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
