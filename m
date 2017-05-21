Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44292 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdEUKdS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 06:33:18 -0400
Date: Sun, 21 May 2017 12:33:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: [patch, libv4l]: add sdlcam example for testing digital still camera
 functionality
Message-ID: <20170521103315.GA10716@amd>
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
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Add simple SDL-based application for capturing photos. Manual
focus/gain/exposure can be set, flash can be controlled and
autofocus/autogain can be selected if camera supports that.

It is already useful for testing autofocus/autogain improvements to
the libraries on Nokia N900.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/configure.ac b/configure.ac
index f30d66d..2c8ad7e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -88,6 +88,247 @@ LIBDVBV5_DOMAIN=3D"libdvbv5"
 AC_DEFINE([LIBDVBV5_DOMAIN], "libdvbv5", [libdvbv5 domain])
 AC_SUBST(LIBDVBV5_DOMAIN)
=20
+# Configure paths for SDL
+# Sam Lantinga 9/21/99
+# stolen from Manish Singh
+# stolen back from Frank Belew
+# stolen from Manish Singh
+# Shamelessly stolen from Owen Taylor
+#
+# Changelog:
+# * also look for SDL2.framework under Mac OS X
+
+# serial 1
+
+dnl AM_PATH_SDL2([MINIMUM-VERSION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND=
]]])
+dnl Test for SDL, and define SDL_CFLAGS and SDL_LIBS
+dnl
+AC_DEFUN([AM_PATH_SDL2],
+[dnl=20
+dnl Get the cflags and libraries from the sdl2-config script
+dnl
+AC_ARG_WITH(sdl-prefix,[  --with-sdl-prefix=3DPFX   Prefix where SDL is in=
stalled (optional)],
+            sdl_prefix=3D"$withval", sdl_prefix=3D"")
+AC_ARG_WITH(sdl-exec-prefix,[  --with-sdl-exec-prefix=3DPFX Exec prefix wh=
ere SDL is installed (optional)],
+            sdl_exec_prefix=3D"$withval", sdl_exec_prefix=3D"")
+AC_ARG_ENABLE(sdltest, [  --disable-sdltest       Do not try to compile an=
d run a test SDL program],
+		    , enable_sdltest=3Dyes)
+AC_ARG_ENABLE(sdlframework, [  --disable-sdlframework Do not search for SD=
L2.framework],
+        , search_sdl_framework=3Dyes)
+
+AC_ARG_VAR(SDL2_FRAMEWORK, [Path to SDL2.framework])
+
+  min_sdl_version=3Difelse([$1], ,2.0.0,$1)
+
+  if test "x$sdl_prefix$sdl_exec_prefix" =3D x ; then
+    PKG_CHECK_MODULES([SDL], [sdl2 >=3D $min_sdl_version],
+           [sdl_pc=3Dyes],
+           [sdl_pc=3Dno])
+  else
+    sdl_pc=3Dno
+    if test x$sdl_exec_prefix !=3D x ; then
+      sdl_config_args=3D"$sdl_config_args --exec-prefix=3D$sdl_exec_prefix"
+      if test x${SDL2_CONFIG+set} !=3D xset ; then
+        SDL2_CONFIG=3D$sdl_exec_prefix/bin/sdl2-config
+      fi
+    fi
+    if test x$sdl_prefix !=3D x ; then
+      sdl_config_args=3D"$sdl_config_args --prefix=3D$sdl_prefix"
+      if test x${SDL2_CONFIG+set} !=3D xset ; then
+        SDL2_CONFIG=3D$sdl_prefix/bin/sdl2-config
+      fi
+    fi
+  fi
+
+  if test "x$sdl_pc" =3D xyes ; then
+    no_sdl=3D""
+    SDL2_CONFIG=3D"pkg-config sdl2"
+  else
+    as_save_PATH=3D"$PATH"
+    if test "x$prefix" !=3D xNONE && test "$cross_compiling" !=3D yes; then
+      PATH=3D"$prefix/bin:$prefix/usr/bin:$PATH"
+    fi
+    AC_PATH_PROG(SDL2_CONFIG, sdl2-config, no, [$PATH])
+    PATH=3D"$as_save_PATH"
+    no_sdl=3D""
+
+    if test "$SDL2_CONFIG" =3D "no" -a "x$search_sdl_framework" =3D "xyes"=
; then
+      AC_MSG_CHECKING(for SDL2.framework)
+      if test "x$SDL2_FRAMEWORK" !=3D x; then
+        sdl_framework=3D$SDL2_FRAMEWORK
+      else
+        for d in / ~/ /System/; do
+          if test -d "$dLibrary/Frameworks/SDL2.framework"; then
+            sdl_framework=3D"$dLibrary/Frameworks/SDL2.framework"
+          fi
+        done
+      fi
+
+      if test -d $sdl_framework; then
+        AC_MSG_RESULT($sdl_framework)
+        sdl_framework_dir=3D`dirname $sdl_framework`
+        SDL_CFLAGS=3D"-F$sdl_framework_dir -Wl,-framework,SDL2 -I$sdl_fram=
ework/include"
+        SDL_LIBS=3D"-F$sdl_framework_dir -Wl,-framework,SDL2"
+      else
+        no_sdl=3Dyes
+      fi
+    fi
+
+    if test "$SDL2_CONFIG" !=3D "no"; then
+      if test "x$sdl_pc" =3D "xno"; then
+        AC_MSG_CHECKING(for SDL - version >=3D $min_sdl_version)
+        SDL_CFLAGS=3D`$SDL2_CONFIG $sdl_config_args --cflags`
+        SDL_LIBS=3D`$SDL2_CONFIG $sdl_config_args --libs`
+      fi
+
+      sdl_major_version=3D`$SDL2_CONFIG $sdl_config_args --version | \
+             sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\1/'`
+      sdl_minor_version=3D`$SDL2_CONFIG $sdl_config_args --version | \
+             sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\2/'`
+      sdl_micro_version=3D`$SDL2_CONFIG $sdl_config_args --version | \
+             sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\3/'`
+      if test "x$enable_sdltest" =3D "xyes" ; then
+        ac_save_CFLAGS=3D"$CFLAGS"
+        ac_save_CXXFLAGS=3D"$CXXFLAGS"
+        ac_save_LIBS=3D"$LIBS"
+        CFLAGS=3D"$CFLAGS $SDL_CFLAGS"
+        CXXFLAGS=3D"$CXXFLAGS $SDL_CFLAGS"
+        LIBS=3D"$LIBS $SDL_LIBS"
+dnl
+dnl Now check if the installed SDL is sufficiently new. (Also sanity
+dnl checks the results of sdl2-config to some extent
+dnl
+      rm -f conf.sdltest
+      AC_TRY_RUN([
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include "SDL.h"
+
+char*
+my_strdup (char *str)
+{
+  char *new_str;
+ =20
+  if (str)
+    {
+      new_str =3D (char *)malloc ((strlen (str) + 1) * sizeof(char));
+      strcpy (new_str, str);
+    }
+  else
+    new_str =3D NULL;
+ =20
+  return new_str;
+}
+
+int main (int argc, char *argv[])
+{
+  int major, minor, micro;
+  char *tmp_version;
+
+  /* This hangs on some systems (?)
+  system ("touch conf.sdltest");
+  */
+  { FILE *fp =3D fopen("conf.sdltest", "a"); if ( fp ) fclose(fp); }
+
+  /* HP/UX 9 (%@#!) writes to sscanf strings */
+  tmp_version =3D my_strdup("$min_sdl_version");
+  if (sscanf(tmp_version, "%d.%d.%d", &major, &minor, &micro) !=3D 3) {
+     printf("%s, bad version string\n", "$min_sdl_version");
+     exit(1);
+   }
+
+   if (($sdl_major_version > major) ||
+      (($sdl_major_version =3D=3D major) && ($sdl_minor_version > minor)) =
||
+      (($sdl_major_version =3D=3D major) && ($sdl_minor_version =3D=3D min=
or) && ($sdl_micro_version >=3D micro)))
+    {
+      return 0;
+    }
+  else
+    {
+      printf("\n*** 'sdl2-config --version' returned %d.%d.%d, but the min=
imum version\n", $sdl_major_version, $sdl_minor_version, $sdl_micro_version=
);
+      printf("*** of SDL required is %d.%d.%d. If sdl2-config is correct, =
then it is\n", major, minor, micro);
+      printf("*** best to upgrade to the required version.\n");
+      printf("*** If sdl2-config was wrong, set the environment variable S=
DL2_CONFIG\n");
+      printf("*** to point to the correct copy of sdl2-config, and remove =
the file\n");
+      printf("*** config.cache before re-running configure\n");
+      return 1;
+    }
+}
+
+],, no_sdl=3Dyes,[echo $ac_n "cross compiling; assumed OK... $ac_c"])
+        CFLAGS=3D"$ac_save_CFLAGS"
+        CXXFLAGS=3D"$ac_save_CXXFLAGS"
+        LIBS=3D"$ac_save_LIBS"
+
+      fi
+      if test "x$sdl_pc" =3D "xno"; then
+        if test "x$no_sdl" =3D "xyes"; then
+          AC_MSG_RESULT(no)
+        else
+          AC_MSG_RESULT(yes)
+        fi
+      fi
+    fi
+  fi
+  if test "x$no_sdl" =3D x ; then
+     ifelse([$2], , :, [$2])
+  else
+     if test "$SDL2_CONFIG" =3D "no" ; then
+       echo "*** The sdl2-config script installed by SDL could not be foun=
d"
+       echo "*** If SDL was installed in PREFIX, make sure PREFIX/bin is i=
n"
+       echo "*** your path, or set the SDL2_CONFIG environment variable to=
 the"
+       echo "*** full path to sdl2-config."
+     else
+       if test -f conf.sdltest ; then
+        :
+       else
+          echo "*** Could not run SDL test program, checking why..."
+          CFLAGS=3D"$CFLAGS $SDL_CFLAGS"
+          CXXFLAGS=3D"$CXXFLAGS $SDL_CFLAGS"
+          LIBS=3D"$LIBS $SDL_LIBS"
+          AC_TRY_LINK([
+#include <stdio.h>
+#include "SDL.h"
+
+int main(int argc, char *argv[])
+{ return 0; }
+#undef  main
+#define main K_and_R_C_main
+],      [ return 0; ],
+        [ echo "*** The test program compiled, but did not run. This usual=
ly means"
+          echo "*** that the run-time linker is not finding SDL or finding=
 the wrong"
+          echo "*** version of SDL. If it is not finding SDL, you'll need =
to set your"
+          echo "*** LD_LIBRARY_PATH environment variable, or edit /etc/ld.=
so.conf to point"
+          echo "*** to the installed location  Also, make sure you have ru=
n ldconfig if that"
+          echo "*** is required on your system"
+	  echo "***"
+          echo "*** If you have an old version installed, it is best to re=
move it, although"
+          echo "*** you may also be able to get things to work by modifyin=
g LD_LIBRARY_PATH"],
+        [ echo "*** The test program failed to compile or link. See the fi=
le config.log for the"
+          echo "*** exact error that occured. This usually means SDL was i=
ncorrectly installed"
+          echo "*** or that you have moved SDL since it was installed. In =
the latter case, you"
+          echo "*** may want to edit the sdl2-config script: $SDL2_CONFIG"=
 ])
+          CFLAGS=3D"$ac_save_CFLAGS"
+          CXXFLAGS=3D"$ac_save_CXXFLAGS"
+          LIBS=3D"$ac_save_LIBS"
+       fi
+     fi
+     SDL_CFLAGS=3D""
+     SDL_LIBS=3D""
+     ifelse([$3], , :, [$3])
+  fi
+  AC_SUBST(SDL_CFLAGS)
+  AC_SUBST(SDL_LIBS)
+  rm -f conf.sdltest
+])
+
+dnl Check for SDL
+SDL_VERSION=3D2.0
+AM_PATH_SDL2($SDL_VERSION, sdl_pkgconfig=3Dyes, sdl_pkgconfig=3Dno)
+
+AM_CONDITIONAL([HAVE_SDL], [test x$sdl_pkgconfig =3D xyes])
+
 # Define localedir
 AC_DEFUN([V4L_EXPAND_PREFIX], [
 	$1=3D$2
@@ -432,5 +673,6 @@ compile time options summary
     libudev		: $have_libudev
     QT version		: $QT_VERSION
     ALSA support	: $alsa_pkgconfig
+    SDL support		: $sdl_pkgconfig
=20
 EOF
diff --git a/contrib/test/Makefile.am b/contrib/test/Makefile.am
index 4641e21..dd06cc1 100644
--- a/contrib/test/Makefile.am
+++ b/contrib/test/Makefile.am
@@ -16,6 +16,10 @@ if HAVE_GLU
 noinst_PROGRAMS +=3D v4l2gl
 endif
=20
+if HAVE_SDL
+noinst_PROGRAMS +=3D sdlcam
+endif
+
 driver_test_SOURCES =3D driver-test.c
 driver_test_LDADD =3D ../../utils/libv4l2util/libv4l2util.la
=20
@@ -31,6 +35,10 @@ v4l2gl_SOURCES =3D v4l2gl.c
 v4l2gl_LDFLAGS =3D $(X11_LIBS) $(GL_LIBS) $(GLU_LIBS) $(ARGP_LIBS)
 v4l2gl_LDADD =3D ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv=
4lconvert.la
=20
+sdlcam_LDFLAGS =3D $(JPEG_LIBS) $(SDL_LIBS) ../../lib/libv4l2/.libs/libv4l=
2.a  ../../lib/libv4lconvert/.libs/libv4lconvert.a
+sdlcam_CFLAGS =3D -I../..
+v4l2gl_LDADD =3D=20
+
 mc_nextgen_test_CFLAGS =3D $(LIBUDEV_CFLAGS)
 mc_nextgen_test_LDFLAGS =3D $(LIBUDEV_LIBS)
=20
diff --git a/contrib/test/sdlcam.c b/contrib/test/sdlcam.c
new file mode 100644
index 0000000..16d1bef
--- /dev/null
+++ b/contrib/test/sdlcam.c
@@ -0,0 +1,1093 @@
+/*
+   Digital still camera.
+
+   SDL based, suitable for camera phone such as Nokia N900. In
+   particular, we support focus, gain and exposure control, but not
+   aperture control or lens zoom.
+
+   Copyright 2017 Pavel Machek, LGPLv2 or later.
+*/
+
+#include <time.h>
+#include <errno.h>
+#include <stdarg.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/ioctl.h>
+#include <fcntl.h>
+
+#include <jpeglib.h>
+
+#include "libv4l2.h"
+#include <linux/videodev2.h>
+#include "libv4l-plugin.h"
+
+#include <SDL2/SDL.h>
+#include <SDL2/SDL_image.h>
+
+static double dtime(void)
+{
+	static double start =3D 0.0;
+	struct timeval now;
+
+	gettimeofday(&now, NULL);
+
+	double n =3D now.tv_sec + now.tv_usec / 1000000.;
+	if (!start)
+		start =3D n;
+	return n - start;
+}
+
+static long v4l2_g_ctrl(int fd, long id)
+{
+	int res;
+	struct v4l2_control ctrl;
+	ctrl.id =3D id;
+	res =3D v4l2_ioctl(fd, VIDIOC_G_CTRL, &ctrl);
+	if (res < 0)
+		printf("Get control %ld failed\n", id);
+	return ctrl.value;
+}
+
+static int v4l2_s_ctrl(int fd, long id, long value)
+{
+	int res;
+	struct v4l2_control ctrl;
+	ctrl.id =3D id;
+	ctrl.value =3D value;
+	res =3D v4l2_ioctl(fd, VIDIOC_S_CTRL, &ctrl);
+	if (res < 0)
+		printf("Set control %lx %ld failed\n", id, value);
+	return res;
+}
+
+
+static int v4l2_set_focus(int fd, int diopt)
+{
+	if (v4l2_s_ctrl(fd, V4L2_CID_FOCUS_ABSOLUTE, diopt) < 0) {
+		printf("Could not set focus\n");
+	}
+	return 0;
+}
+
+#define SIZE 1296*984*3
+struct dev_info {
+	int fd;
+	struct v4l2_format fmt;
+
+	unsigned char buf[SIZE];
+	int debug;
+#define D_TIMING 1
+};
+
+struct sdl {
+	SDL_Window *window;
+	SDL_Surface *screen, *liveview;
+
+	int wx, wy; /* Window size */
+	int sx, sy; /* Live view size */
+	int bx, by; /* Border size */
+	int nx, ny; /* Number of buttons */
+	int factor;
+
+	/* These should go separately */
+	int do_focus, do_exposure, do_flash, do_white;
+	double focus_min;
+=09
+	int fd;
+
+	struct dev_info *dev;
+};
+
+typedef struct {
+	uint8_t r, g, b, alpha;
+} pixel;
+
+#define d_raw 1
+
+static void sfc_put_pixel(SDL_Surface* liveview, int x, int y, pixel *p)
+{
+	Uint32* p_liveview =3D (Uint32*)liveview->pixels;
+	p_liveview +=3D y*liveview->w+x;
+	*p_liveview =3D SDL_MapRGBA(liveview->format, p->r, p->g, p->b, p->alpha);
+}
+
+static void sdl_begin_paint(struct sdl *m)
+{
+	/* Fill the surface white */
+	SDL_FillRect(m->liveview, NULL, SDL_MapRGB( m->liveview->format, 0, 0, 0 =
));
+
+	SDL_LockSurface(m->liveview);
+}
+
+static void sdl_finish_paint(struct sdl *m) {
+	SDL_UnlockSurface(m->liveview);
+	SDL_Rect rcDest =3D { m->bx, m->by, m->sx, m->sy };
+
+	SDL_BlitSurface(m->liveview, NULL, m->screen, &rcDest);
+	SDL_UpdateWindowSurfaceRects(m->window, &rcDest, 1);
+}
+ =20
+static void sdl_paint_image(struct sdl *m, char **xpm, int x, int y) {
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
+static void cam_exposure_limits(struct sdl *m, struct v4l2_queryctrl *qctr=
l)
+{
+	qctrl->id =3D V4L2_CID_EXPOSURE_ABSOLUTE;
+=09
+	if (v4l2_ioctl(m->fd, VIDIOC_QUERYCTRL, qctrl)) {
+		printf("Exposure absolute limits failed\n");
+		exit(1);
+	}
+
+	if (qctrl->minimum < 500)
+		qctrl->minimum =3D 500;
+}
+
+static void cam_set_exposure(struct sdl *m, double v)
+{
+	int cid =3D V4L2_CID_EXPOSURE_ABSOLUTE;
+	double res;
+	double range;
+	struct v4l2_queryctrl qctrl =3D { .id =3D cid };
+	struct v4l2_control ctrl =3D { .id =3D cid };
+
+	cam_exposure_limits(m, &qctrl);
+
+	if (v4l2_ioctl(m->fd, VIDIOC_G_CTRL, &ctrl)) {
+		printf("Can't get exposure parameters\n");
+		exit(1);
+	}
+
+	range =3D log2(qctrl.maximum) - log2(qctrl.minimum);
+	res =3D log2(qctrl.minimum) + v*range;
+	res =3D exp2(res);
+
+	v4l2_s_ctrl(m->fd, V4L2_CID_EXPOSURE_ABSOLUTE, res);
+}
+
+static double cam_convert_exposure(struct sdl *m, int v)
+{
+	int cid =3D V4L2_CID_EXPOSURE_ABSOLUTE;
+	double res;
+	struct v4l2_queryctrl qctrl =3D { .id =3D cid };
+
+	cam_exposure_limits(m, &qctrl);
+	res =3D (log2(v) - log2(qctrl.minimum)) / (log2(qctrl.maximum) - log2(qct=
rl.minimum));
+
+	return res;
+}
+
+static double cam_get_exposure(struct sdl *m)
+{
+	int cid =3D V4L2_CID_EXPOSURE_ABSOLUTE;
+	struct v4l2_control ctrl =3D { .id =3D cid };
+
+	if (v4l2_ioctl(m->fd, VIDIOC_G_CTRL, &ctrl))
+		return -1;
+
+	return cam_convert_exposure(m, ctrl.value);
+}
+
+static void cam_set_focus(struct sdl *m, double val)
+{
+	v4l2_s_ctrl(m->fd, V4L2_CID_FOCUS_ABSOLUTE, (val * m->focus_min) * (1023.=
 / 20));
+}
+
+static double cam_convert_focus(struct sdl *m, double diopter)
+{
+	return diopter / m->focus_min;
+}
+
+static double cam_get_focus_diopter(struct sdl *m)
+{
+	return (v4l2_g_ctrl(m->fd, V4L2_CID_FOCUS_ABSOLUTE) * 20.) / 1023.;
+}
+
+static double cam_get_focus(struct sdl *m)
+{
+	return cam_convert_focus(m, cam_get_focus_diopter(m));
+}
+
+static void sdl_line_color(struct sdl *m, int x1, int y1, int x2, int y2, =
Uint32 color)
+{
+	SDL_Rect rcDest =3D { x1, y1, x2-x1+1, y2-y1+1};
+
+	SDL_FillRect(m->screen, &rcDest, color);
+}
+
+static void sdl_line(struct sdl *m, int x1, int y1, int x2, int y2)
+{
+	sdl_line_color(m, x1, y1, x2, y2, SDL_MapRGB( m->liveview->format, 255, 2=
55, 255 ));
+}
+
+static void sdl_digit(struct sdl *m, int x, int y, int s, int i)
+{
+	unsigned char gr[] =3D { 0x5f, 0x0a, 0x76, 0x7a, 0x2b,
+			       0x79, 0x7d, 0x1a, 0x7f, 0x7b };
+	unsigned char g =3D gr[i];
+	/*
+              10
+	    01  02
+              20
+            04  08
+	      40
+	*/
+
+	if (g & 1) sdl_line(m, x, y, x, y+s);
+	if (g & 2) sdl_line(m, x+s, y, x+s, y+s);
+	if (g & 4) sdl_line(m, x, y+s, x, y+s+s);
+	if (g & 8) sdl_line(m, x+s, y+s, x+s, y+s+s);
+
+	if (g & 0x10) sdl_line(m, x, y, x+s, y);
+	if (g & 0x20) sdl_line(m, x, y+s, x+s, y+s);
+	if (g & 0x40) sdl_line(m, x, y+s+s, x+s, y+s+s);
+}
+
+static void sdl_number(struct sdl *m, int x, int y, int s, int digits, int=
 i)
+{
+	int tot =3D s * 5;
+	x +=3D tot * digits;
+	for (int j=3D0; j<digits; j++) {
+		sdl_digit(m, x+2, y+4, s*3, i%10);
+		i /=3D 10;
+		x -=3D tot;
+	}
+}
+
+static void sdl_paint_ui_iso(struct sdl *m, double y_, int i)
+{
+	static char *iso_xpm[] =3D {
+		"16 12 2 1",
+		"x c #ffffff",
+		". c #000000",
+		"................",
+		"................",
+		"................",
+		".x..xx..x.......",
+		".x.x...x.x......",
+		".x..x..x.x......",
+		".x...x.x.x......",
+		".x.xx...x.......",
+		"................",
+		"................",
+		"................",
+		"................",
+	};
+
+	int x =3D m->bx - 10;
+	int y =3D m->by+m->sy*y_;
+
+	sdl_number(m, x-35, y-10, 1, 3, i);
+	sdl_paint_image(m, iso_xpm, x, y);
+}
+
+static void sdl_paint_ui_exposure(struct sdl *m, int t)
+{
+	static char *time_1_xpm[] =3D {
+		"16 12 2 1",
+		"x c #ffffff",
+		". c #000000",
+		"......x.........",
+		".....x..........",
+		"....x...........",
+		"...x............",
+		"................",
+		".xxx.xxxx.xxxx..",
+		"x....x....x.....",
+		".xx..xxx..x.....",
+		"...x.x....x.....",
+		"...x.x....x.....",
+		"xxx..xxxx.xxxx..",
+		"................",
+	};
+	int x =3D m->wx-m->bx + 30;
+	int y =3D m->by+m->sy*cam_convert_exposure(m, 1000000/t);
+
+	sdl_number(m, x-35, y-10, 1, 3, t);
+	sdl_paint_image(m, time_1_xpm, x, y);
+}
+
+static void sdl_paint_boolean(struct sdl *m, char **image, int x, int y, i=
nt yes)
+{
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
+	sdl_paint_image(m, image, x, y);
+	if (!yes)
+		sdl_paint_image(m, not_xpm,  16+x, y);     =20
+}
+
+static void sdl_paint_button(struct sdl *m, char **image, int x, int y, in=
t yes)
+{
+	int bsx =3D m->wx/m->nx;
+	int bsy =3D m->wy/m->ny;
+	if (x < 0)
+		x +=3D m->nx;
+	if (y < 0)
+		y +=3D m->ny;
+	x =3D bsx/2 + x*bsx;
+	y =3D bsy/2 + y*bsy;
+	sdl_paint_boolean(m, image, x, y, yes);
+}
+
+static void sdl_paint_ui_focus(struct sdl *m, int f)
+{
+	static char *cm_xpm[] =3D {
+		"16 9 2 1",
+		"# c #ffffff",
+		". c #000000",
+		"................",
+		"................",
+		"................",
+		"....###..#.#.##.",
+		"...#.....##.#..#",
+		"...#.....#..#..#",
+		"...#.....#..#..#",
+		"....###..#..#..#",
+		"................",
+	};
+	double dioptr =3D 1/(f/100.);
+	int x =3D m->bx+cam_convert_focus(m, dioptr)*m->sx;
+	int y =3D m->by - 20;
+
+	if (dioptr > m->focus_min)
+		return;
+	sdl_paint_image(m, cm_xpm, x, y);
+	sdl_number(m, x-12, y-15, 1, 3, f);
+}
+
+static void sdl_paint_ui(struct sdl *m)
+{
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
+	static char *af_xpm[] =3D {
+		"16 12 2 1",
+		"x c #ffffff",
+		". c #000000",
+		"................",
+		"................",
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
+	};
+
+	static char *ae_xpm[] =3D {
+		"16 12 2 1",
+		"x c #ffffff",
+		". c #000000",
+		"................",
+		"................",
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
+	};
+   =20
+	static char *focus_xpm[] =3D {
+		"16 12 2 1",
+		"# c #ffffff",
+		". c #000000",
+		"................",
+		"................",
+		"###..........###",
+		"#..............#",
+		"#.....####.....#",
+		".....#....#.....",
+		".....#....#.....",
+		"#.....####.....#",
+		"#..............#",
+		"###..........###",
+		"................",
+		"................",
+	};
+
+	static char *flash_xpm[] =3D {
+		"16 12 2 1",
+		"# c #ffffff",
+		". c #000000",
+		"................",	=09
+		"..........#.....",
+		"........##......",
+		".......##.......",
+		"......##........",
+		".....########...",
+		"..........##....",
+		".......#.##.....",
+		".......###......",
+		".......####.....",
+		"................",
+		"................",
+	};
+
+	static char *wb_xpm[] =3D {
+		"16 12 2 1",
+		"# c #ffffff",
+		". c #000000",
+		"................",
+		"................",
+		"................",
+		"#.....#..####...",
+		"#.....#..#...#..",
+		"#..#..#..####...",
+		"#..#..#..#...#..",
+		".##.##...####...",
+		"................",
+		"................",
+		"................",
+		"................",
+	};
+/* Template for more xpm's:
+	static char *empty_xpm[] =3D {
+		"16 12 2 1",
+		"# c #ffffff",
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
+*/
+	SDL_FillRect(m->screen, NULL, SDL_MapRGB( m->liveview->format, 0, 0, 0 ));
+
+	{
+		/* Paint grid */
+		int x, y;
+		int nx =3D m->nx;
+		for (x=3D1; x<nx; x++) {
+			int x_ =3D (x*m->wx)/nx;
+			sdl_line_color(m, x_, 1, x_, m->wy-1, SDL_MapRGB( m->liveview->format, =
40, 40, 40 ));
+		}
+
+		int ny =3D m->ny;
+		for (y=3D1; y<nx; y++) {
+			int y_ =3D (y*m->wy)/ny;
+			sdl_line_color(m, 1, y_, m->wx-1, y_, SDL_MapRGB( m->liveview->format, =
40, 40, 40 ));
+		}
+				      =20
+	}
+
+	sdl_paint_image(m, wait_xpm,  m->wx/2,     m->wy/2);
+
+	sdl_paint_ui_focus(m, 100);
+	sdl_paint_ui_focus(m, 40);
+	sdl_paint_ui_focus(m, 25);
+	sdl_paint_ui_focus(m, 16);=09
+	sdl_paint_ui_focus(m, 10);
+	sdl_paint_ui_focus(m, 8);
+	sdl_paint_ui_focus(m, 6);
+
+	sdl_paint_button(m, af_xpm, 0,  0, m->do_focus);
+	sdl_paint_button(m, ae_xpm, -1, 0, m->do_exposure);
+
+	sdl_paint_button(m, exit_xpm,   0, -1, 1);
+	sdl_paint_button(m, flash_xpm,  1, -1, m->do_flash);
+	sdl_paint_button(m, wb_xpm,     2, -1, m->do_white);
+	sdl_paint_button(m, focus_xpm, -2, -1, 1);
+	sdl_paint_button(m, ok_xpm,    -1, -1, 1);
+
+	sdl_paint_ui_exposure(m, 10);
+	sdl_paint_ui_exposure(m, 100);
+	sdl_paint_ui_exposure(m, 999);
+
+	sdl_paint_ui_iso(m, 0/4., 100);
+	sdl_paint_ui_iso(m, 1/4., 200);
+	sdl_paint_ui_iso(m, 2/4., 400);
+	sdl_paint_ui_iso(m, 3/4., 800);
+
+	SDL_UpdateWindowSurface(m->window);
+}
+
+static double usec_to_time(double v)
+{
+	return 1/(v*.000001);
+}
+
+static void sdl_status(struct sdl *m, double avg)
+{
+	int ox =3D m->bx;
+	int oy =3D m->by+m->sy;
+	SDL_Rect rcDest =3D { ox, oy, m->sx, 25 /* m->by */ };
+
+	SDL_FillRect(m->screen, &rcDest, SDL_MapRGB( m->liveview->format, 30, 30,=
 30 ));
+	ox+=3D40;
+	sdl_number(m, ox, oy, 2, 3, avg*1000);
+
+	{
+		double focus, gain, exposure;
+
+		exposure =3D v4l2_g_ctrl(m->fd, V4L2_CID_EXPOSURE_ABSOLUTE);
+		gain =3D v4l2_g_ctrl(m->fd, 0x00980913);
+		focus =3D cam_get_focus_diopter(m);
+
+		ox+=3D40;
+		double x =3D usec_to_time(exposure);
+		if (x > 999) x =3D 999;
+		sdl_number(m, ox, oy, 2, 3, x);
+
+		ox+=3D40;
+		x =3D (gain / 10);
+		sdl_number(m, ox, oy, 2, 1, x);
+
+		ox+=3D20;
+		x =3D focus; /* diopters */
+		if (x =3D=3D 0)
+			x =3D 999;
+		else
+			x =3D 100/x; /* centimeters */
+		sdl_number(m, ox, oy, 2, 3, x);
+	}
+
+	SDL_UpdateWindowSurfaceRects(m->window, &rcDest, 1);
+}
+
+static void fmt_print(struct v4l2_format *fmt)
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
+static pixel buf_pixel(struct v4l2_format *fmt, unsigned char *buf, int x,=
 int y)
+{
+	pixel p =3D { 0, 0, 0, 0 };
+	int pos =3D x + y*fmt->fmt.pix.width;
+
+	p.alpha =3D 128;
+
+	switch (fmt->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_SGRBG10:
+		{
+			short *b2 =3D (void *)buf;
+			x &=3D ~1;
+			y &=3D ~1;
+			p.g =3D b2[x + y*fmt->fmt.pix.width] /4;
+			p.r =3D b2[x + y*fmt->fmt.pix.width+1] /4;
+			p.b =3D b2[x + (y+1)*fmt->fmt.pix.width] /4;
+		}
+		break;
+
+	case V4L2_PIX_FMT_RGB24:
+		pos *=3D 3;
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
+static char *fmt_name(struct v4l2_format *fmt)
+{
+	switch (fmt->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_SGRBG10:
+		return "GRBG10";
+	case V4L2_PIX_FMT_RGB24:
+		return "RGB24";
+	default:
+		return "unknown";
+	}
+}
+
+static void sdl_handle_focus(struct sdl *m, float how)
+{
+	v4l2_set_control(m->fd, V4L2_CID_FOCUS_ABSOLUTE, 65535. * how);
+}
+
+static void sdl_key(struct sdl *m, int c)
+{
+	switch (c) {
+	case 27: exit(1); break;
+	case 'q': sdl_handle_focus(m, 0.); break;
+	case 'w': sdl_handle_focus(m, 1/6.); break;
+	case 'e': sdl_handle_focus(m, 1/3.); break;
+	case 'r': sdl_handle_focus(m, 1/2.); break;
+	case 't': sdl_handle_focus(m, 1/1); break;
+	case 'y': sdl_handle_focus(m, 1/.8); break;
+	case 'u': sdl_handle_focus(m, 1/.5); break;
+	case 'i': sdl_handle_focus(m, 1/.2); break;
+	case 'o': sdl_handle_focus(m, 1/.1); break;
+	case 'p': sdl_handle_focus(m, 1/.05); break;
+	case SDLK_SPACE: /* save_image(); */ printf("Should save jpeg.\n"); break;
+	default: printf("Unknown key %d / %c", c, c);
+	}
+}
+
+static int render_statistics(struct sdl *m)
+{
+	pixel white;
+	double focus, gain, exposure;
+
+	white.r =3D (Uint8)0xff;
+	white.g =3D (Uint8)0xff;
+	white.b =3D (Uint8)0xff;
+	white.alpha =3D (Uint8)128;
+
+	exposure =3D cam_get_exposure(m);
+	gain =3D v4l2_get_control(m->fd, 0x00980913) / 65535.;
+	focus =3D cam_get_focus(m);
+
+	for (int x=3D0; x<m->sx && x<m->sx*focus; x++)
+		sfc_put_pixel(m->liveview, x, 0, &white);
+
+	for (int y=3D0; y<m->sy && y<m->sy*gain; y++)
+		sfc_put_pixel(m->liveview, 0, y, &white);
+
+	for (int y=3D0; y<m->sy && y<m->sy*exposure; y++)
+		sfc_put_pixel(m->liveview, m->sx-1, y, &white);
+
+	for (int x=3D0; x<m->sx; x++)
+		sfc_put_pixel(m->liveview, x, m->sy-1, &white);
+
+	return 0;
+}
+
+static void sdl_render(struct sdl *m, unsigned char *buf, struct v4l2_form=
at *fmt)
+{
+	if (!m->window)=20
+		return;
+	sdl_begin_paint(m);   =20
+
+	for (int y =3D 0; y < m->sy; y++)
+		for (int x =3D 0; x < m->sx; x++) {
+			pixel p =3D buf_pixel(fmt, buf, x*m->factor, y*m->factor);
+			p.alpha =3D 128;
+			sfc_put_pixel(m->liveview, x, y, &p);
+		}
+
+	render_statistics(m);
+	sdl_finish_paint(m);
+}
+
+static void sdl_sync_settings(struct sdl *m)
+{
+	printf("Autofocus: "); v4l2_s_ctrl(m->fd, V4L2_CID_FOCUS_AUTO, m->do_focu=
s);
+	printf("Autogain: " ); v4l2_s_ctrl(m->fd, V4L2_CID_AUTOGAIN, m->do_exposu=
re);
+	printf("Autowhite: "); v4l2_s_ctrl(m->fd, V4L2_CID_AUTO_WHITE_BALANCE, m-=
>do_white);
+	v4l2_s_ctrl(m->fd, 0x009c0901, m->do_flash ? 2 : 0);
+}
+
+static void sdl_init(struct sdl *m, struct dev_info *dev, int _factor)
+{
+	m->fd =3D dev->fd;
+	m->dev =3D dev;
+
+	if (SDL_Init(SDL_INIT_VIDEO) < 0) {
+		printf("Could not init SDL\n");
+		exit(1);
+	}
+
+	atexit(SDL_Quit);
+
+	m->wx =3D 800;
+	m->wy =3D 429;
+
+	m->window =3D SDL_CreateWindow("Camera", SDL_WINDOWPOS_UNDEFINED,
+				     SDL_WINDOWPOS_UNDEFINED, m->wx, m->wy,
+				     SDL_WINDOW_SHOWN);
+	if (m->window =3D=3D NULL) {
+		printf("Window could not be created! SDL_Error: %s\n", SDL_GetError());
+		exit(1);
+	}
+
+	m->screen =3D SDL_GetWindowSurface(m->window);
+	if (!m->screen) {
+		printf("Couldn't create screen\n");
+		exit(1);
+	}
+
+	m->sx =3D dev->fmt.fmt.pix.width;
+	m->sy =3D dev->fmt.fmt.pix.height;
+	m->factor =3D _factor;
+
+	m->sx /=3D m->factor;
+	m->sy /=3D m->factor;
+
+	m->bx =3D (m->wx-m->sx)/2;
+	m->by =3D (m->wy-m->sy)/2;
+
+	m->nx =3D 6;
+	m->ny =3D 4;
+
+	m->liveview =3D SDL_CreateRGBSurface(0,m->sx,m->sy,32,0,0,0,0);
+	if (!m->liveview) {
+		printf("Couldn't create liveview\n");
+		exit(1);
+	}
+
+	m->do_flash =3D 1;
+	m->do_focus =3D 0;
+	m->do_exposure =3D 1;
+	m->focus_min =3D 5;
+	sdl_paint_ui(m);
+	sdl_sync_settings(m);
+}
+
+static struct sdl sdl;
+
+static void pgm_write(struct dev_info *dev, struct v4l2_format *fmt, unsig=
ned char *img, char *out_name)
+{
+	FILE *fout;
+	int size =3D fmt->fmt.pix.width * fmt->fmt.pix.height;
+	char swapped[size*2];
+
+	fout =3D fopen(out_name, "w");
+	if (!fout) {
+		perror("Cannot open image");
+		exit(EXIT_FAILURE);
+	}
+	switch (fmt->fmt.pix.pixelformat) {
+		/* ?? 	cinfo.in_color_space =3D JCS_YCbCr; */
+	case V4L2_PIX_FMT_SGRBG10:
+		printf("ok\n");
+		break;
+	default:
+		printf("Bad pixel format\n");
+		exit(1);
+	}
+
+	for (int i=3D0; i<size*2; i+=3D2) {
+		swapped[i] =3D img[i+1];
+		swapped[i+1] =3D img[i];
+	}
+
+	fprintf(fout, "P5\n# SDLcam raw image\n# ");
+	{
+		double focus, gain, exposure;
+
+		exposure =3D v4l2_get_control(dev->fd, V4L2_CID_EXPOSURE_ABSOLUTE) / 655=
36.;
+		gain =3D v4l2_get_control(dev->fd, 0x00980913) / 65536.;
+		focus =3D v4l2_get_control(dev->fd, V4L2_CID_FOCUS_ABSOLUTE) / 65536.;
+
+		fprintf(fout, "Exposure %f, gain %f, focus %f\n", exposure, gain, focus);
+	}
+	fprintf(fout, "%d %d\n1023\n",
+		fmt->fmt.pix.width, fmt->fmt.pix.height);
+	fwrite(swapped, size, 2, fout);
+	fclose(fout);
+}
+
+static void any_write(struct dev_info *dev)
+{
+	char name[1024];
+	unsigned char *buf;
+	time_t t =3D time(NULL);
+
+	buf =3D dev->buf;
+
+	if (1) {
+		sprintf(name, "/data/tmp/delme_%d.%s", (int) t, "pgm");
+
+		if (dev->fmt.fmt.pix.pixelformat !=3D V4L2_PIX_FMT_SGRBG10)
+			printf("Not in bayer10, can't write raw.\n");
+		else
+			pgm_write(dev, &dev->fmt, buf, name);
+	}
+}
+
+static void sdl_mouse(struct sdl *m, SDL_Event event)
+{
+	int ax =3D 0, ay =3D 0;
+	int nx =3D event.button.x / (m->wx/m->nx), ny =3D event.button.y / (m->wy=
/m->ny);
+	if (nx > m->nx/2)
+		nx -=3D m->nx;
+	if (ny > m->ny/2)
+		ny -=3D m->ny;
+
+	printf("Button %d %d\n", nx, ny);
+	switch (ny) {
+	case 0:
+		switch (nx) {
+		case 0:
+			m->do_focus ^=3D 1;
+			sdl_paint_ui(m);
+			sdl_sync_settings(m);
+			return;
+		case -1:
+			m->do_exposure ^=3D 1;
+			sdl_paint_ui(m);
+			sdl_sync_settings(m);
+			return;
+		}
+		break;
+	case -1:
+		switch (nx) {
+		case 0:
+			exit(0);
+		case 1:
+			m->do_flash ^=3D 1;
+			sdl_paint_ui(m);
+			sdl_sync_settings(m);
+			return;
+		case 2:
+			m->do_white ^=3D 1;
+			sdl_paint_ui(m);
+			sdl_sync_settings(m);
+			return;
+		case -2:
+			v4l2_s_ctrl(m->fd, V4L2_CID_AUTO_FOCUS_STATUS, 1);
+			return;
+		case -1:
+			sdl_paint_ui(m);
+			any_write(m->dev);
+			return;
+		}
+		break;
+	}
+		=09
+	if (event.button.x > m->wx-m->bx)
+		ax =3D 1;
+	if (event.button.x < m->bx)
+		ax =3D -1;
+
+	if (event.button.y > m->wy-m->by)
+		ay =3D 1;
+	if (event.button.y < m->by)
+		ay =3D -1;
+	   =20
+	printf("mouse button at...%d, %d area %d, %d\n", event.button.x, event.bu=
tton.y,
+	       ax, ay);
+
+	int bx =3D event.button.x - m->bx;
+	int by =3D event.button.y - m->by;
+
+	/*
+	  AF    |  Focus   |  Aexp        =20
+	  -------------------------------
+	  ISO   |          |  time        =20
+	  -------------------------------
+	  Quit  |Fl | nF|F!|  Shoot
+	*/
+	if ((ax =3D=3D 0) && (ay =3D=3D -1)) {
+		cam_set_focus(m, ((float) bx)/m->sx);
+		return;
+	}
+	if ((ax =3D=3D -1) && (ay =3D=3D 0)) {
+		m->do_exposure =3D 0;
+		v4l2_set_control(m->fd, 0x00980913, (65536 * by)/m->sy);
+		sdl_sync_settings(m);
+		return;
+	}
+	if ((ax =3D=3D 1) && (ay =3D=3D 0)) {
+		m->do_exposure =3D 0;
+		cam_set_exposure(m, ((double) by)/m->sy);
+		sdl_sync_settings(m);
+		return;
+	}
+	if ((ax =3D=3D 0) && (ay =3D=3D 1)) {
+		/* Below */
+	}
+}
+
+static void sdl_iteration(struct sdl *m)
+{
+	SDL_Event event;
+
+	while(SDL_PollEvent(&event)) {
+		switch(event.type) {
+		case SDL_QUIT:
+			exit(1);
+			break;
+		case SDL_KEYDOWN:
+			printf("key pressed... %c\n", event.key.keysym.sym);
+			/* SDLK_A, SDLK_LEFT, SDLK_RETURN, SDLK_BACKSPACE, SDLK_SPACE */
+			switch (event.key.keysym.sym) {
+			default: sdl_key(m, event.key.keysym.sym);
+			}
+			break;
+		case SDL_WINDOWEVENT:
+			if (event.window.event =3D=3D SDL_WINDOWEVENT_EXPOSED)
+				sdl_paint_ui(m);
+			break;
+		case SDL_MOUSEBUTTONDOWN:
+			sdl_mouse(m, event);
+			break;
+		}
+	}
+}
+
+static void cam_open(struct dev_info *dev)
+{
+	struct v4l2_format *fmt =3D &dev->fmt;
+
+	dev->fd =3D v4l2_open("/dev/video0", O_RDWR);
+
+	fmt->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	fmt->fmt.pix.pixelformat =3D V4L2_PIX_FMT_SGRBG10;
+	fmt->fmt.pix.field =3D V4L2_FIELD_NONE;
+	fmt->fmt.pix.width =3D 1296;
+	fmt->fmt.pix.height =3D 984;
+
+	v4l2_s_ctrl(dev->fd, V4L2_CID_AUTO_FOCUS_STATUS, 0);
+	v4l2_set_focus(dev->fd, 50);
+
+	printf("ioctl =3D %d\n", v4l2_ioctl(dev->fd, VIDIOC_S_FMT, fmt));
+
+	printf("capture is %lx %s %d x %d\n", (unsigned long) fmt->fmt.pix.pixelf=
ormat, fmt_name(fmt), fmt->fmt.pix.width, fmt->fmt.pix.height);
+}
+
+/* ------------------------------------------------------------------ */
+
+
+static struct dev_info dev;
+
+int main(void)
+{
+	int i;
+	struct v4l2_format *fmt =3D &dev.fmt;
+
+	dtime();
+	cam_open(&dev);
+
+	sdl_init(&sdl, &dev, 5);
+ =20
+	double loop =3D dtime(), max =3D 0, avg =3D .200;
+	if (dev.debug & D_TIMING)
+		printf("startup took %f\n", loop);
+=09
+	for (i=3D0; i<500000; i++) {
+		int num =3D v4l2_read(dev.fd, dev.buf, SIZE);
+		if (num < 0)
+			return 1;
+
+		{
+			double d =3D dtime();
+			sdl_render(&sdl, dev.buf, fmt);
+			if (dev.debug & D_TIMING)
+				printf("Render took %f\n", dtime() - d);
+		}
+		{
+			double d =3D dtime();
+			for (int i =3D 0; i<1; i++)
+				sdl_status(&sdl, avg);
+			if (dev.debug & D_TIMING)
+				printf("Status took %f\n", dtime() - d);
+		}
+
+		sdl_iteration(&sdl);
+		double now =3D dtime();
+		if (now - loop > max)
+			max =3D now - loop;
+		double c =3D 0.03;
+		avg =3D (now - loop) * c + avg * (1-c);
+		if (dev.debug & D_TIMING)
+			printf("Iteration %f, maximum %f, average %f\n", now-loop, max, avg);
+		loop =3D now;
+	}
+	return 0;
+}


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkhbOsACgkQMOfwapXb+vIwLACgoQYQpcb06/7f8r3RMo8LMIwY
zn0AoIPybFI2Ft2BZnOULt1GXgC8OBab
=l112
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
