Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49321 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751313AbdJUWAa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Oct 2017 18:00:30 -0400
Date: Sun, 22 Oct 2017 00:00:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        linux-media@vger.kernel.org
Subject: Camera support, Prague next week, sdlcam
Message-ID: <20171021220026.GA26881@amd>
References: <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426082608.7dd52fbf@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20170426082608.7dd52fbf@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I'd still like to get some reasonable support for cellphone camera in
Linux.

IMO first reasonable step is to merge sdlcam, then we can implement
autofocus, improve autogain... and rest of the boring stuff. Ouch and
media graph support would be nice. Currently, _nothing_ works with
media graph device, such as N900.

I'll talk about the issues at ELCE in few days:

https://osseu17.sched.com/event/ByYH/cheap-complex-cameras-pavel-machek-den=
x-software-engineering-gmbh

Will someone else be there? Is there some place where v4l people meet?

Best regards,

								Pavel

commit 8db1546cd0b5229ad7bf2605fd5c295365df57f8
Author: Pavel <pavel@ucw.cz>
Date:   Fri Oct 13 21:24:16 2017 +0200

    Port changes from "cleaner" branch. For some reason, SDL2_image is
    missing in compilation.
   =20
    gcc -std=3Dgnu99 -I../.. -g -O2 -o sdlcam sdlcam-sdlcam.o  -ljpeg -lSDL2
    -lSDL2_image ../../lib/libv4l2/.libs/libv4l2.a ../../lib/libv4lconvert/=
=2Elibs/libv4lconvert.a

diff --git a/configure.ac b/configure.ac
index f3691be..dc412c9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -98,6 +98,247 @@ LIBDVBV5_DOMAIN=3D"libdvbv5"
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
@@ -507,6 +748,7 @@ compile time options summary
     pthread                    : $have_pthread
     QT version                 : $QT_VERSION
     ALSA support               : $USE_ALSA
+    SDL support		       : $sdl_pkgconfig
=20
     build dynamic libs         : $enable_shared
     build static libs          : $enable_static
diff --git a/contrib/test/Makefile.am b/contrib/test/Makefile.am
index 4641e21..4e585cf 100644
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
@@ -31,6 +35,11 @@ v4l2gl_SOURCES =3D v4l2gl.c
 v4l2gl_LDFLAGS =3D $(X11_LIBS) $(GL_LIBS) $(GLU_LIBS) $(ARGP_LIBS)
 v4l2gl_LDADD =3D ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv=
4lconvert.la
=20
+sdlcam_LDFLAGS =3D $(JPEG_LIBS) $(SDL_LIBS) ../../lib/libv4l2/.libs/libv4l=
2.a  ../../lib/libv4lconvert/.libs/libv4lconvert.a
+sdlcam_CFLAGS =3D -I../..
+v4l2gl_LDADD =3D=20
+# ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la
+
 mc_nextgen_test_CFLAGS =3D $(LIBUDEV_CFLAGS)
 mc_nextgen_test_LDFLAGS =3D $(LIBUDEV_LIBS)
=20
diff --git a/contrib/test/libcam.c b/contrib/test/libcam.c
new file mode 100644
index 0000000..115e6b1
--- /dev/null
+++ b/contrib/test/libcam.c
@@ -0,0 +1,48 @@
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
+static void pgm_write(struct v4l2_format *fmt, unsigned char *img, char *o=
ut_name, char *extra)
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
+	fprintf(fout, "P5\n");
+	if (extra)
+		fprintf(fout, "%s", extra);
+	 =20
+	fprintf(fout, "%d %d\n1023\n",
+		fmt->fmt.pix.width, fmt->fmt.pix.height);
+	fwrite(swapped, size, 2, fout);
+	fclose(fout);
+}
diff --git a/contrib/test/raw.c b/contrib/test/raw.c
new file mode 100644
index 0000000..70d3340
--- /dev/null
+++ b/contrib/test/raw.c
@@ -0,0 +1,298 @@
+/* -*- c-file-style: "linux" -*- */
+/*
+   lens-shading is described at page 1411 of omap3isp manual,
+   downsampled by 4..64
+
+   gcc -std=3Dc99 raw.c
+*/
+
+#include <linux/videodev2.h>
+#include <arpa/inet.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "libcam.c"
+
+struct image {
+	struct v4l2_format fmt;
+	unsigned char *buf;
+	unsigned char data[];=20
+};
+
+struct image *read_pgm(char *name)
+{
+	FILE *f;
+	char buf[1024];
+	struct v4l2_format fmt;
+	int max;
+
+
+	f =3D fopen(name, "r");
+	if (!f) {
+		printf("Can not open: %s\n", name);
+		return NULL;
+	}
+	fgets(buf, sizeof(buf)-1, f);
+	if (strcmp(buf, "P5\n")) {
+		printf("Not a pgm\n");
+		return NULL;
+	}
+
+	fgets(buf, sizeof(buf)-1, f);
+	while (buf[0] =3D=3D '#')
+		fgets(buf, sizeof(buf)-1, f);
+
+	fmt.type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	fmt.fmt.pix.field =3D V4L2_FIELD_NONE;
+
+	if (2 !=3D sscanf(buf, "%d %d\n", &fmt.fmt.pix.width, &fmt.fmt.pix.height=
))
+		printf("Could not read size: %s\n", buf);
+	fgets(buf, sizeof(buf)-1, f);
+	if (1 !=3D sscanf(buf, "%d\n", &max))
+		printf("Could not read bits\n");
+
+	int size =3D fmt.fmt.pix.width * fmt.fmt.pix.height;
+	int bpp;
+	switch (max) {
+	case 255:
+		bpp =3D 1;
+		fmt.fmt.pix.pixelformat =3D V4L2_PIX_FMT_SGRBG8;	=09
+		break;
+	case 1023:
+		bpp =3D 2;
+		fmt.fmt.pix.pixelformat =3D V4L2_PIX_FMT_SGRBG10;
+		break;
+	default:
+		printf("Unexpected image depth: %d\n", max);
+		return NULL;
+	}
+
+	struct image *img =3D malloc(sizeof(struct image) + size*bpp);
+	img->buf =3D img->data;
+	fmt_print(&fmt);
+
+	if (size !=3D fread(img->buf, bpp, size, f))
+		printf("Short read, bpp %d\n", bpp);
+
+	if (bpp =3D=3D 2)
+		for (int i =3D 0; i < size; i++) {
+			unsigned short *b =3D (void *) img->buf;
+			b[i] =3D ntohs(b[i]);
+		}
+
+	img->fmt =3D fmt;
+
+	fclose(f);
+	return img;
+}
+
+static inline int img_pos(struct image *img, int x, int y)
+{
+	return y*img->fmt.fmt.pix.width + x;
+}
+
+static inline unsigned short img_value(struct image *img, int x, int y)
+{
+	int pos =3D img_pos(img, x, y);
+
+	switch (img->fmt.fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_SGRBG8:
+		return img->buf[pos];
+	case  V4L2_PIX_FMT_SGRBG10:
+		return ((unsigned short *)img->buf)[pos];
+	default:
+		printf("Unknown format in img_value\n");
+		exit(1);
+	}
+}
+
+static int img_value_safe(struct image *img, int x, int y)
+{
+	if ((x < 0) || (y < 0))
+		return -1;
+	if ((x >=3D img->fmt.fmt.pix.width) || (y >=3D img->fmt.fmt.pix.height))
+		return -1;
+	return img_value(img, x, y);
+}
+
+static inline void img_value_set(struct image *img, int x, int y, int v)
+{
+	int pos =3D img_pos(img, x, y);
+
+	switch (img->fmt.fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_SGRBG8:
+		img->buf[pos] =3D v;
+		break;
+	case  V4L2_PIX_FMT_SGRBG10:
+		((unsigned short *)img->buf)[pos] =3D v;
+		break;
+	default:
+		printf("Unknown format in img_value_set\n");
+		exit(1);
+	}
+}
+
+static inline int img_max_value(struct image *img)
+{
+	switch (img->fmt.fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_SGRBG8:
+		return 255;
+	case  V4L2_PIX_FMT_SGRBG10:
+		return 1023;
+	default:
+		printf("Unknown format in img_value_max\n");
+		exit(1);
+	}
+}
+
+static int img_expected_value(struct image *img, int x, int y)
+{
+	int v =3D 0, n =3D 0, v1;
+
+	v1 =3D img_value_safe(img, x-2, y);
+	if (v1 >=3D 0)
+		v +=3D v1, n++;
+
+	v1 =3D img_value_safe(img, x+2, y);
+	if (v1 >=3D 0)
+		v +=3D v1, n++;
+
+	v1 =3D img_value_safe(img, x, y-2);
+	if (v1 >=3D 0)
+		v +=3D v1, n++;
+
+	v1 =3D img_value_safe(img, x, y+2);
+	if (v1 >=3D 0)
+		v +=3D v1, n++;
+
+	v /=3D n;
+	return v;
+}
+
+/* img -=3D sub */
+static void img_substract(struct image *img, struct image *sub)
+{
+	for (int y=3D0; y<img->fmt.fmt.pix.height; y++)
+		for (int x=3D0; x<img->fmt.fmt.pix.width; x++) {
+			int v =3D img_value(img, x, y) -
+				img_value(sub, x, y);
+			if (v < 0)
+				v =3D 0;
+			img_value_set(img, x, y, v);
+		}
+}
+
+static int histogram_perc(int *cdf, int buckets, int perc)
+{
+	long long total =3D cdf[buckets-1];=09
+	int lim =3D total * perc / 10000;
+
+	for (int i=3D0; i<buckets; i++)
+		if (cdf[i] > lim)
+			return i;
+	return buckets-1;
+}
+
+static void img_histogram(struct image *img, int cdf[], int buckets, int s=
tep)
+{
+	int max =3D img_max_value(img);
+
+	for (int i=3D0; i<buckets; i++)
+		cdf[i] =3D 0;
+=09
+	for (int y =3D 0; y < img->fmt.fmt.pix.height; y+=3Dstep)
+		for (int x =3D 0; x < img->fmt.fmt.pix.width; x+=3Dstep) {
+			int b;
+			b =3D img_value(img, x, y);
+			b =3D (b * buckets)/(max+1);
+			cdf[b]++;
+		}
+
+	for (int i=3D1; i<buckets; i++)
+		cdf[i] +=3D cdf[i-1];
+}
+
+static void img_remove_dead(struct image *img, struct image *sub)
+{
+	int buckets =3D 1024;
+	int cdf[buckets];
+	int lim;
+	img_histogram(sub, cdf, buckets, 1);
+
+	printf("Total is %d\n", cdf[buckets-1]);
+	printf("Median is %d\n", histogram_perc(cdf, buckets, 5000));
+	lim =3D histogram_perc(cdf, buckets, 9999);
+	printf("99th percentile is %d (%d)\n", lim, lim/4);
+	lim =3D lim + lim / 10;
+	printf("bad pixel limit is %d (%d)\n", lim, lim/4);
+	printf("%d bad pixels\n", cdf[buckets-1] - cdf[lim]);
+
+	int c =3D 0;
+
+	for (int y =3D 0; y < img->fmt.fmt.pix.height; y++)
+		for (int x =3D 0; x < img->fmt.fmt.pix.width; x++) {
+			int v =3D img_value(sub, x, y);
+			if (v > lim) {
+				int vo =3D img_value(img, x, y);
+				int v1 =3D img_expected_value(img, x, y);
+
+				img_value_set(img, x, y, v1);
+				//printf("Bad pixel, dark: %d %d -> %d\n", v, vo, v1);
+				c++;
+			}
+		}
+	printf("Corrected %d bad pixels\n", c);
+
+}
+
+static void img_shading(struct image *img, struct image *cor)
+{
+	int syi =3D img->fmt.fmt.pix.height;
+	int syc =3D cor->fmt.fmt.pix.height;
+	int sxi =3D img->fmt.fmt.pix.width;
+	int sxc =3D cor->fmt.fmt.pix.width;
+	int max =3D 0, min =3D 255;
+=09
+	for (int y=3D0; y<syc; y++)
+		for (int x=3D0; x<sxc; x++) {
+			int v =3D img_value(cor, x, y);
+
+			if (v < min)
+				min =3D v;
+			if (v > max)
+				max =3D v;
+		}
+
+	printf("Extremes in correction image are %d, %d\n", min, max);
+
+	int m =3D img_max_value(img);
+	for (int y=3D0; y<syi; y++) {
+		int yc =3D (y*syc) / syi;
+		for (int x=3D0; x<sxi; x++) {
+			int xc =3D (x*sxc) / sxi;
+			int v =3D img_value(img, x, y);
+			int vc =3D img_value(cor, xc, yc);
+
+			v =3D (v * max) / vc;
+			if (v > m)
+				v =3D m;
+			img_value_set(img, x, y, v);
+
+		}
+	}
+}
+
+int main(void)
+{
+	struct image *img =3D read_pgm("/data/tmp/test_dark.pgm");
+	struct image *dark =3D read_pgm("/data/tmp/dark_max_iso_exp.pgm");
+	struct image *shading =3D read_pgm("/data/tmp/lens_shading.pgm");
+
+	pgm_write(&img->fmt, img->buf, "/data/tmp/delme_original.pgm", NULL);
+	//img_substract(img, dark);
+	img_remove_dead(img, dark);
+	pgm_write(&img->fmt, img->buf, "/data/tmp/delme_dark.pgm", NULL);
+	img_shading(img, shading);
+	pgm_write(&img->fmt, img->buf, "/data/tmp/delme_shading.pgm", NULL);
+}
diff --git a/contrib/test/sdlcam.c b/contrib/test/sdlcam.c
new file mode 100644
index 0000000..69b9712
--- /dev/null
+++ b/contrib/test/sdlcam.c
@@ -0,0 +1,1385 @@
+/* -*- c-file-style: "linux" -*- */
+/* Digital still camera.
+
+   SDL based, suitable for camera phone such as Nokia N900. In
+   particular, we support focus, gain and exposure control, but not
+   aperture control or lens zoom.
+
+   Copyright 2017 Pavel Machek, LGPL
+
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
+#define COOKED
+#ifdef COOKED
+#include "../../lib/libv4l2/libv4l2-priv.h"
+#endif
+#include "libv4l-plugin.h"
+
+#include <SDL2/SDL.h>
+#include <SDL2/SDL_image.h>
+
+#include "libcam.c"
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
+#define SX 2592
+#define SY 1968
+#define SIZE SX*SY*3
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
+	float factor;
+
+	/* These should go separately */
+	int do_focus, do_exposure, do_flash, do_white, do_big, do_full;
+	double zoom;
+	double focus_min;
+
+	int slider_mode;
+#define M_BIAS 0
+#define M_EXPOSURE 1
+#define M_GAIN 2
+#define M_FOCUS 3
+#define M_NUM 4
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
+	int r =3D SDL_BlitSurface(image, NULL, m->screen, &rcDest);
+
+	if (r) {
+		printf("Error blitting: %s\n", SDL_GetError());
+		exit(1);
+	}
+	SDL_FreeSurface(image);
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
+	/* Minimum of 11300 gets approximately same range on ISO and
+	 * exposure axis. */
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
+static int cam_get_gain_iso(struct dev_info *dev)
+{
+	double x;
+
+	x =3D v4l2_g_ctrl(dev->fd, 0x00980913);
+	x =3D (x / 10); /* EV */
+	x =3D exp2(x);
+	x =3D 100*x;
+	return x;
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
+static void sdl_icon_pos(struct sdl *m, int *x, int *y, double val)
+{
+	*x =3D m->wx - 10;
+	*y =3D val * m->wy;
+}=20
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
+	int x, y;
+
+	sdl_icon_pos(m, &x, &y, y_);
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
+	int x, y;
+
+	sdl_icon_pos(m, &x, &y, cam_convert_exposure(m, 1000000/t));
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
+	int x, y;
+
+	if (dioptr > m->focus_min)
+		return;
+
+	sdl_icon_pos(m, &x, &y, cam_convert_focus(m, dioptr));
+	sdl_paint_image(m, cm_xpm, x, y);
+	sdl_number(m, x-12, y-15, 1, 3, f);
+}
+
+static void sdl_paint_ui_bias(struct sdl *m, double v)
+{
+	static char *bias_xpm[] =3D {
+		"16 12 2 1",
+		"# c #ffffff",
+		". c #000000",
+		"...#............",
+		"...#.......#....",
+		".#####....#.....",
+		"...#.....#......",
+		"...#....#.......",
+		".......#........",
+		"......#...#####.",
+		".....#..........",
+		"....#...........",
+		"...#............",
+		"................",
+		"................",
+	};
+	int x, y;
+
+	sdl_icon_pos(m, &x, &y, v);
+	sdl_paint_image(m, bias_xpm, x, y);
+	//sdl_number(m, x-12, y-15, 1, 3, f);
+}
+
+static void sdl_paint_slider(struct sdl *m)
+{
+	switch (m->slider_mode) {
+	case M_BIAS:
+		sdl_paint_ui_bias(m, 0.5);
+		return;
+	case M_EXPOSURE:
+		sdl_paint_ui_exposure(m, 10);
+		sdl_paint_ui_exposure(m, 100);
+		sdl_paint_ui_exposure(m, 999);
+#if 0
+		sdl_paint_ui_exposure(m, 10001);
+		sdl_paint_ui_exposure(m, 14002);
+#endif
+		return;
+	case M_GAIN:
+		sdl_paint_ui_iso(m, 0/4., 100);
+		sdl_paint_ui_iso(m, 1/4., 200);
+		sdl_paint_ui_iso(m, 2/4., 400);
+		sdl_paint_ui_iso(m, 3/4., 800);
+		return;
+	case M_FOCUS:
+		sdl_paint_ui_focus(m, 100);
+		sdl_paint_ui_focus(m, 40);
+		sdl_paint_ui_focus(m, 25);
+		sdl_paint_ui_focus(m, 16);=09
+		sdl_paint_ui_focus(m, 10);
+		sdl_paint_ui_focus(m, 8);
+		sdl_paint_ui_focus(m, 6);
+		return;
+	}
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
+
+	sdl_paint_button(m, af_xpm, 0,  0, m->do_focus);
+	sdl_paint_button(m, ae_xpm, -1, 0, m->do_exposure);
+
+	sdl_paint_button(m, exit_xpm,   0, -1, 1);
+	sdl_paint_button(m, flash_xpm,  1, -1, m->do_flash);
+	sdl_paint_button(m, wb_xpm,     2, -1, m->do_white);
+	sdl_paint_button(m, focus_xpm, -1, -2, 1);
+	sdl_paint_button(m, ok_xpm,    -1, -1, 1);
+
+	sdl_paint_slider(m);
+	SDL_UpdateWindowSurface(m->window);
+}
+
+static double usec_to_time(double v)
+{
+	return 1/(v*.000001);
+}
+
+static void sdl_status_below(struct sdl *m, double avg)
+{
+	int ox =3D m->bx;
+	int oy =3D m->by+m->sy;
+	SDL_Rect rcDest =3D { ox, oy, m->sx, 25 /* m->by */ };
+
+	SDL_FillRect(m->screen, &rcDest, SDL_MapRGB( m->liveview->format, 30, 30,=
 30 ));
+
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
+static void sdl_status(struct sdl *m, double avg)
+{
+	int ox =3D 0;
+	int oy =3D m->wy/2;
+	int s =3D 3;
+	SDL_Rect rcDest =3D { ox, oy, s*25, s*40 };
+
+	SDL_FillRect(m->screen, &rcDest, SDL_MapRGB( m->liveview->format, 30, 30,=
 30 ));
+
+	sdl_number(m, ox, oy, s, 3, avg*1000);
+	oy +=3D s*10;
+
+	{
+		double focus, gain, exposure;
+
+		exposure =3D v4l2_g_ctrl(m->fd, V4L2_CID_EXPOSURE_ABSOLUTE);
+		gain =3D cam_get_gain_iso(m->dev);
+		focus =3D cam_get_focus_diopter(m);
+
+		double x =3D usec_to_time(exposure);
+		if (x > 999) x =3D 999;
+		sdl_number(m, ox, oy, s, 3, x);
+
+		oy +=3D s*10;
+		if (gain > 999)
+			gain =3D 999;
+		sdl_number(m, ox, oy, s, 3, gain);
+
+		oy +=3D s*10;
+		x =3D focus; /* diopters */
+		if (x =3D=3D 0)
+			x =3D 999;
+		else
+			x =3D 100/x; /* centimeters */
+		sdl_number(m, ox, oy, s, 3, x);
+	}
+
+	SDL_UpdateWindowSurfaceRects(m->window, &rcDest, 1);
+}
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
+#if 0
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
+#else
+		{
+			short *b2 =3D (void *)buf;
+			x &=3D ~1;
+			y &=3D ~1;
+			p.g =3D b2[x + y*fmt->fmt.pix.width] /4;
+			p.r =3D b2[x + y*fmt->fmt.pix.width+1] /4;
+			p.b =3D b2[x + (y+1)*fmt->fmt.pix.width] /4;
+		}
+#endif
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
+static int sdl_render_statistics(struct sdl *m)
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
+	float zoom =3D m->zoom;
+	if (!m->window)=20
+		return;
+
+	sdl_begin_paint(m);
+	int x0 =3D (fmt->fmt.pix.width - m->sx*m->factor/zoom)/2;
+	int y0 =3D (fmt->fmt.pix.height - m->sy*m->factor/zoom)/2;
+
+	for (int y =3D 0; y < m->sy; y++)
+		for (int x =3D 0; x < m->sx; x++) {
+			int x1 =3D x0+x*m->factor/zoom;
+			int y1 =3D y0+y*m->factor/zoom;
+			pixel p =3D buf_pixel(fmt, buf, x1, y1);
+			p.alpha =3D 128;
+			sfc_put_pixel(m->liveview, x, y, &p);
+		}
+
+	sdl_render_statistics(m);
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
+static void sdl_init_window(struct sdl *m)
+{
+	if (m->do_full) {
+		m->wx =3D 800;
+		m->wy =3D 480;
+	} else {
+		m->wx =3D 800;
+		m->wy =3D 429;
+	}
+
+	SDL_SetWindowFullscreen(m->window, m->do_full*SDL_WINDOW_FULLSCREEN_DESKT=
OP);
+
+	m->screen =3D SDL_GetWindowSurface(m->window);
+	if (!m->screen) {
+		printf("Couldn't create screen\n");
+		exit(1);
+	}
+}
+
+static void sdl_init(struct sdl *m, struct dev_info *dev)
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
+	m->nx =3D 6;
+	m->ny =3D 4;
+
+	m->do_flash =3D 1;
+	m->do_focus =3D 0;
+	m->do_exposure =3D 1;
+	m->focus_min =3D 5;
+	m->do_white =3D 0;
+	m->do_big =3D 0;
+	m->do_full =3D 0;
+	m->zoom =3D 1;
+
+	m->window =3D SDL_CreateWindow("Camera", SDL_WINDOWPOS_UNDEFINED,
+				     SDL_WINDOWPOS_UNDEFINED, 800, 429,
+				     SDL_WINDOW_SHOWN |=20
+				     m->do_full * SDL_WINDOW_FULLSCREEN_DESKTOP);
+	if (m->window =3D=3D NULL) {
+		printf("Window could not be created! SDL_Error: %s\n", SDL_GetError());
+		exit(1);
+	}
+
+	sdl_init_window(m);
+}
+
+static void sdl_set_size(struct sdl *m, int _sx)
+{
+	m->sx =3D _sx;
+	m->factor =3D (float) m->dev->fmt.fmt.pix.width / m->sx;
+	m->sy =3D m->dev->fmt.fmt.pix.height / m->factor;
+
+	m->bx =3D (m->wx-m->sx)/2;
+	m->by =3D (m->wy-m->sy)/2;
+
+	m->liveview =3D SDL_CreateRGBSurface(0,m->sx,m->sy,32,0,0,0,0);
+	if (!m->liveview) {
+		printf("Couldn't create liveview\n");
+		exit(1);
+	}
+
+	sdl_paint_ui(m);
+	sdl_sync_settings(m);
+}
+
+static struct sdl sdl;
+
+static void cam_pgm_write(struct dev_info *dev, struct v4l2_format *fmt, u=
nsigned char *img, char *out_name)
+{
+	char buf[1024];
+	double focus, gain, exposure;
+
+	exposure =3D v4l2_get_control(dev->fd, V4L2_CID_EXPOSURE_ABSOLUTE) / 6553=
6.;
+	gain =3D v4l2_get_control(dev->fd, 0x00980913) / 65536.;
+	focus =3D v4l2_get_control(dev->fd, V4L2_CID_FOCUS_ABSOLUTE) / 65536.;
+
+	sprintf(buf, "# SDLcam raw image\n# Exposure %f, gain %f, focus %f\n", ex=
posure, gain, focus);
+
+	pgm_write(fmt, img, out_name, buf);
+}
+
+#ifdef COOKED
+static void ppm_write(struct v4l2_format *fmt, unsigned char *img, char *o=
ut_name)
+{
+	FILE *fout;
+	fout =3D fopen(out_name, "w");
+	if (!fout) {
+		perror("Cannot open image");
+		exit(EXIT_FAILURE);
+	}
+	switch (fmt->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_RGB24:
+		printf("ok\n");
+		break;
+	default:
+		printf("Bad pixel format\n");
+		exit(1);
+	}
+
+	fprintf(fout, "P6\n%d %d 255\n",
+		fmt->fmt.pix.width, fmt->fmt.pix.height);
+	fwrite(img, fmt->fmt.pix.width, 3*fmt->fmt.pix.height, fout);
+	fclose(fout);
+}
+
+/**
+   Write image to jpeg file.
+   \param img image to write
+*/
+static void jpeg_write(struct v4l2_format *fmt, unsigned char *img, char *=
jpegFilename)
+{
+	struct jpeg_compress_struct cinfo;
+	struct jpeg_error_mgr jerr;
+
+	JSAMPROW row_pointer[1];
+	FILE *outfile =3D fopen(jpegFilename, "wb");
+	if (!outfile) {
+		printf("Can't open jpeg for writing.\n");
+		exit(2);
+	}
+
+	/* create jpeg data */
+	cinfo.err =3D jpeg_std_error(&jerr);
+	jpeg_create_compress(&cinfo);
+	jpeg_stdio_dest(&cinfo, outfile);
+
+	/* set image parameters */
+	cinfo.image_width =3D fmt->fmt.pix.width;
+	cinfo.image_height =3D fmt->fmt.pix.height;
+	cinfo.input_components =3D 3;
+	switch (fmt->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_SGRBG10:
+	case V4L2_PIX_FMT_RGB24:
+		cinfo.in_color_space =3D JCS_RGB;
+		break;
+	default:
+		printf("Need to specify colorspace!\n");
+		exit(1);
+	}
+
+	/* set jpeg compression parameters to default */
+	jpeg_set_defaults(&cinfo);
+	jpeg_set_quality(&cinfo, 90, TRUE);
+
+	jpeg_start_compress(&cinfo, TRUE);
+
+	/* feed data */
+	while (cinfo.next_scanline < cinfo.image_height) {
+		row_pointer[0] =3D &img[cinfo.next_scanline * cinfo.image_width *  cinfo=
=2Einput_components];
+		jpeg_write_scanlines(&cinfo, row_pointer, 1);
+	}
+
+	jpeg_finish_compress(&cinfo);
+	jpeg_destroy_compress(&cinfo);
+	fclose(outfile);
+}
+
+static void convert_rgb(struct dev_info *dev, struct v4l2_format sfmt, voi=
d *buf, struct v4l2_format dfmt, void *buf2, int wb)
+{
+	struct v4lconvert_data *data =3D v4lconvert_create(dev->fd);
+	int res;
+
+	printf("Converting first.");
+	if (wb) {
+		struct v4l2_control ctrl;
+		ctrl.id =3D V4L2_CID_AUTO_WHITE_BALANCE;
+		ctrl.value =3D 1;
+		v4lconvert_vidioc_s_ctrl(data, &ctrl);
+	}
+	res =3D v4lconvert_convert(data, &sfmt, &dfmt, buf, SIZE, buf2, SIZE);
+	printf("Converting: %d\n", res);
+	v4lconvert_destroy(data);
+}
+#endif
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
+			cam_pgm_write(dev, &dev->fmt, buf, name);
+	}
+
+#ifdef COOKED
+	int ppm =3D 0;
+	/* FIXME: full resolution picture is too big to be put on stack */
+	static unsigned char buf2[SIZE];
+
+	sprintf(name, "/data/tmp/delme_%d.%s", (int) t, ppm ? "ppm" : "jpg");
+	if (dev->fmt.fmt.pix.pixelformat !=3D V4L2_PIX_FMT_RGB24) {
+		struct v4l2_format dest_fmt;
+
+		dest_fmt =3D dev->fmt;
+		dest_fmt.fmt.pix.pixelformat =3D V4L2_PIX_FMT_RGB24;
+		dest_fmt.fmt.pix.bytesperline =3D 3 * dest_fmt.fmt.pix.width;
+		dest_fmt.fmt.pix.sizeimage =3D 3 * dest_fmt.fmt.pix.width * dest_fmt.fmt=
=2Epix.height;
+
+		convert_rgb(dev, dev->fmt, buf, dest_fmt, buf2, 0);
+		buf =3D buf2;
+		//convert_rgb(dev, dest_fmt, buf2, dest_fmt, buf, 0);
+	}
+	if (ppm)
+		ppm_write(&dev->fmt, buf, name);
+	else
+		jpeg_write(&dev->fmt, buf, name);
+#endif
+}
+
+static void sdl_mouse(struct sdl *m, SDL_Event event)
+{
+	int ax =3D 0, ay =3D 0;
+	int nx =3D event.button.x / (m->wx/m->nx), ny =3D event.button.y / (m->wy=
/m->ny);
+	if (nx >=3D m->nx/2)
+		nx -=3D m->nx;
+	if (ny >=3D m->ny/2)
+		ny -=3D m->ny;
+
+	printf("Button %d %d\n", nx, ny);
+
+	/* Virtual slider */
+	if (nx =3D=3D -2) {
+		double value =3D (double) event.button.y / m->wy;
+		switch (m->slider_mode) {
+		case M_BIAS: {
+			double ev =3D value - .5; /* -.5 .. +.5 */
+			ev *=3D 3000;
+			printf("Exposure bias: %f mEV %d\n", ev, (int) ev);
+			if (v4l2_s_ctrl(m->fd, V4L2_CID_AUTO_EXPOSURE_BIAS, ev) < 0) {
+				printf("Could not set exposure bias\n");
+			}
+		}
+			return;
+		case M_EXPOSURE:
+			m->do_exposure =3D 0;
+			cam_set_exposure(m, value);
+			sdl_sync_settings(m);
+			return;
+		case M_GAIN:
+			m->do_exposure =3D 0;
+			v4l2_set_control(m->fd, 0x00980913, value * 65535);
+			sdl_sync_settings(m);
+			return;
+		case M_FOCUS:
+			cam_set_focus(m, value);
+			return;
+		}
+	}
+
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
+	case 1:
+		switch (nx) {
+		case -1:
+			m->slider_mode =3D (m->slider_mode + 1) % M_NUM;
+			sdl_paint_ui(m);
+		}
+		break;
+	case -2:
+		switch (nx) {
+#if 0
+		case -2:
+			m->do_full ^=3D 1;
+			sdl_init_window(m);
+			sdl_paint_ui(m);
+			return;
+		case -1:
+			if (m->zoom =3D=3D 1) {
+				m->zoom =3D 4;
+				return;
+			}
+			m->zoom =3D 1;
+			return;
+#endif
+		case -1:
+			v4l2_s_ctrl(m->fd, V4L2_CID_AUTO_FOCUS_STATUS, 1);
+			return;
+		break;
+		}
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
+		case -3:
+			m->do_big ^=3D 1;
+			if (m->do_big)
+				sdl_set_size(m, m->do_full ? 630:512);
+			else
+				sdl_set_size(m, 256);
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
+	dev->fd =3D v4l2_open("/dev/video_ccdc", O_RDWR);
+
+	fmt->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	fmt->fmt.pix.pixelformat =3D V4L2_PIX_FMT_SGRBG10;
+//	fmt->fmt.pix.pixelformat =3D V4L2_PIX_FMT_RGB24;
+	fmt->fmt.pix.field =3D V4L2_FIELD_NONE;
+	fmt->fmt.pix.width =3D SX;
+	fmt->fmt.pix.height =3D SY;
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
+	/* factor =3D=3D 3 still fits window, but very slow over ssh. (Fast enoug=
h on localhost) */
+	/* factor =3D=3D 5 nice over ssh */
+	/* =3D=3D 1.7, full-screen video for 800x600 */
+	/* =3D=3D 2.5, full-screen video for 1200x, 516 */
+	sdl_init(&sdl, &dev);
+	sdl_set_size(&sdl, 256);
+ =20
+	/* In 800x600 "raw" mode, this should take cca 17.8 seconds (without
+	   sdl output. CPU usage should be cca 5% without conversion). That's 28 =
fps.
+	   (benchmark with i<500)
+
+	   switched to separate application -- not in library:
+	   1296x986, i<20, with RGB24 conversion: 32 sec
+	   1296x986, i<20, raw _SGRBG10: 6.3 sec
+
+	   i<500, 2m59, 86%, RGB24
+	   i<500, 1m43, 36%, b10
+	*/
+	double loop =3D dtime(), max =3D 0, avg =3D .200;
+	if (dev.debug & D_TIMING)
+		printf("startup took %f\n", loop);
+=09
+	for (i=3D0; i<500000; i++) {
+		int num =3D v4l2_read(dev.fd, dev.buf, SIZE);
+		if (num < 0)
+			return 1;
+		/* Over USB connection, rendering every single frame slows
+		   execution down from 23 seconds to 36 seconds. */
+#if 1
+		{
+			/* Render takes 80msec over ssh, 47msec on localhost */
+			double d =3D dtime();
+			sdl_render(&sdl, dev.buf, fmt);
+			if (dev.debug & D_TIMING)
+				printf("Render took %f\n", dtime() - d);
+		}
+		{
+			/* Takes cca 10msec over ssh */
+			double d =3D dtime();
+			for (int i =3D 0; i<1; i++)
+				sdl_status(&sdl, avg);
+			if (dev.debug & D_TIMING)
+				printf("Status took %f\n", dtime() - d);
+		}
+#endif
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
diff --git a/contrib/test/unused-v4l2sdl.c b/contrib/test/unused-v4l2sdl.c
new file mode 100644
index 0000000..fe79b9e
--- /dev/null
+++ b/contrib/test/unused-v4l2sdl.c
@@ -0,0 +1,124 @@
+/*
+
+gcc sdlcam.c -I. -I../../include -I../../lib/include -I../../lib/libv4l2 -=
I../../lib/libv4lconvert/processing -I../../lib/libv4lconvert -std=3Dc99 -l=
SDL2 -lSDL2_image -ljpeg -lefence ../../lib/libv4l2/.libs/libv4l2.a  ../../=
lib/libv4lconvert/.libs/libv4lconvert.a && time ./a.out
+
+  libv4l is problematic:
+  1) It converts image to RGB24, but we'd prefer to stay in GRBG10
+  2) It only uses 8-bits per color internally. Cameras such as Nikon D500=
=20
+     store 14-bits per channel. Even N900 stores 10.
+  3) We'd really like to know units for exposure/gain/focus.
+  4) It does not work with subdevices -- at all.
+  5) It steps up time before stepping up gain -- unsuitable for camera.
+  6) Too much resolution in time at the high end, and not enough at the lo=
w end, thus oscillations
+
+*/
+
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
+static int v4l2_set_autogain(int fd)
+{
+	if (v4l2_s_ctrl(fd, V4L2_CID_AUTOGAIN, 1) < 0) {
+		printf("Could not set autogain\n");
+	}
+	return 0;
+}
+
+static int v4l2_set_exposure(int fd, int exposure)
+{
+	if (v4l2_s_ctrl(fd, V4L2_CID_EXPOSURE_ABSOLUTE, exposure) < 0) {
+		printf("Could not set exposure\n");
+	}
+	return 0;
+}
+
+static int v4l2_set_gain(int fd, int gain)
+{
+	if (v4l2_s_ctrl(fd, 0x00980913, gain) < 0) {
+		printf("Could not set gain\n");
+	}
+	return 0;
+}
+
+static double gain_to_EV(double v)
+{
+	return -(log(v)/log(2));
+}
+
+static double EV_to_lux(double v)
+{
+	return 2.5 * pow(2, v);
+}
+
+/* Takes inverse 1/time! */
+static double time_to_EV(double v) {
+	return 5+log(v)/log(2);
+}
+
diff --git a/contrib/test/v4l2grab.c b/contrib/test/v4l2grab.c
index 778c51c..8b25b45 100644
--- a/contrib/test/v4l2grab.c
+++ b/contrib/test/v4l2grab.c
@@ -326,7 +326,7 @@ static int capture(char *dev_name, int x_res, int y_res=
, int n_frames,
  * capture routine
  */
=20
-const char *argp_program_version =3D "V4L2 grabber version " V4L_UTILS_VER=
SION;
+const char *argp_program_version =3D "V4L2 grabber version <local>";
 const char *argp_program_bug_address =3D "Mauro Carvalho Chehab <m.chehab@=
samsung.com>";
=20
 static const char doc[] =3D "\nCapture images using libv4l, storing them a=
s ppm files\n";
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
index 2db25d1..f9e2711 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -1,3 +1,4 @@
+/* -*- c-file-style: "linux" -*- */
 /*
 #             (C) 2008 Hans de Goede <hdegoede@redhat.com>
=20
@@ -794,13 +795,21 @@ no_capture:
 		v4lconvert_set_fps(devices[index].convert, V4L2_DEFAULT_FPS);
 	v4l2_update_fps(index, &parm);
=20
+	devices[index].subdev_fds[0] =3D SYS_OPEN("/dev/video_sensor", O_RDWR, 0);
+	devices[index].subdev_fds[1] =3D SYS_OPEN("/dev/video_focus", O_RDWR, 0);
+	devices[index].subdev_fds[2] =3D SYS_OPEN("/dev/video_flash", O_RDWR, 0);
+	devices[index].subdev_fds[3] =3D -1;
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
@@ -1056,6 +1065,21 @@ static int v4l2_s_fmt(int index, struct v4l2_format =
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
+		result =3D SYS_IOCTL(devices[index].subdev_fds[i], request, arg);
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
@@ -1185,14 +1209,20 @@ no_capture_request:
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
@@ -1739,7 +1769,8 @@ int v4l2_set_control(int fd, int cid, int value)
=20
 	result =3D v4lconvert_vidioc_queryctrl(devices[index].convert, &qctrl);
 	if (result)
-		return result;
+		if (v4l2_propagate_ioctl(index, VIDIOC_QUERYCTRL, &qctrl))
+			return -1;
=20
 	if (!(qctrl.flags & V4L2_CTRL_FLAG_DISABLED) &&
 			!(qctrl.flags & V4L2_CTRL_FLAG_GRABBED)) {
@@ -1750,6 +1781,8 @@ int v4l2_set_control(int fd, int cid, int value)
 				qctrl.minimum;
=20
 		result =3D v4lconvert_vidioc_s_ctrl(devices[index].convert, &ctrl);
+		if (result =3D=3D -1)
+			result =3D v4l2_propagate_ioctl(index, VIDIOC_S_CTRL, &ctrl);
 	}
=20
 	return result;
@@ -1768,7 +1801,8 @@ int v4l2_get_control(int fd, int cid)
 	}
=20
 	if (v4lconvert_vidioc_queryctrl(devices[index].convert, &qctrl))
-		return -1;
+		if (v4l2_propagate_ioctl(index, VIDIOC_QUERYCTRL, &qctrl))
+			return -1;
=20
 	if (qctrl.flags & V4L2_CTRL_FLAG_DISABLED) {
 		errno =3D EINVAL;
diff --git a/lib/libv4lconvert/Makefile.am b/lib/libv4lconvert/Makefile.am
index f266f3e..9557a9c 100644
--- a/lib/libv4lconvert/Makefile.am
+++ b/lib/libv4lconvert/Makefile.am
@@ -17,6 +17,7 @@ libv4lconvert_la_SOURCES =3D \
   stv0680.c cpia1.c se401.c jpgl.c jpeg.c jl2005bcd.c \
   control/libv4lcontrol.c control/libv4lcontrol.h control/libv4lcontrol-pr=
iv.h \
   processing/libv4lprocessing.c processing/whitebalance.c processing/autog=
ain.c \
+  processing/focus.c \
   processing/gamma.c processing/libv4lprocessing.h processing/libv4lproces=
sing-priv.h \
   helper-funcs.h libv4lconvert-priv.h libv4lsyscall-priv.h \
   tinyjpeg.h tinyjpeg-internal.h
diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/=
control/libv4lcontrol.c
index 1e784ed..e8c67e2 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -638,7 +638,7 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, void =
*dev_ops_priv,
=20
 	/* If the device always needs conversion, we can add fake controls at no =
cost
 	   (no cost when not activated by the user that is) */
-	if (always_needs_conversion || v4lcontrol_needs_conversion(data)) {
+	if (1 || always_needs_conversion || v4lcontrol_needs_conversion(data)) {
 		for (i =3D 0; i < V4LCONTROL_AUTO_ENABLE_COUNT; i++) {
 			ctrl.id =3D fake_controls[i].id;
 			rc =3D data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
@@ -678,6 +678,16 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, void=
 *dev_ops_priv,
 		break;
 	}
=20
+       data->controls |=3D 1 << V4LCONTROL_AUTOGAIN |
+	 	         1 << V4LCONTROL_AUTOGAIN_TARGET |
+	                 1 << V4LCONTROL_EXPOSURE_BIAS |
+	 	         1 << V4LCONTROL_AUTO_FOCUS |
+	 	         1 << V4LCONTROL_FOCUS_START |
+	 		 1 << V4LCONTROL_FOCUS_STOP |
+	 		 1 << V4LCONTROL_FOCUS_STATUS |
+	 		 1 << V4LCONTROL_FOCUS_RANGE;
+
+
 	/* Allow overriding through environment */
 	s =3D getenv("LIBV4LCONTROL_CONTROLS");
 	if (s)
@@ -841,6 +851,60 @@ static const struct v4l2_queryctrl fake_controls[V4LCO=
NTROL_COUNT] =3D {
 		.step =3D 1,
 		.default_value =3D 100,
 		.flags =3D V4L2_CTRL_FLAG_SLIDER
+	},  {
+	        .id =3D V4L2_CID_FOCUS_AUTO,
+		.type =3D V4L2_CTRL_TYPE_INTEGER,
+		.name =3D  "Auto Focus enabled",
+		.minimum =3D 0,
+		.maximum =3D 1,
+		.step =3D 1,
+		.default_value =3D 0,
+		.flags =3D 0
+	},  {
+	        .id =3D V4L2_CID_AUTO_FOCUS_START,
+		.type =3D V4L2_CTRL_TYPE_INTEGER,
+		.name =3D  "Focus start",
+		.minimum =3D 0,
+		.maximum =3D 1,
+		.step =3D 1,
+		.default_value =3D 0,
+		.flags =3D 0
+	},  {
+	        .id =3D V4L2_CID_AUTO_FOCUS_STOP,
+		.type =3D V4L2_CTRL_TYPE_INTEGER,
+		.name =3D  "",
+		.minimum =3D 0,
+		.maximum =3D 1,
+		.step =3D 1,
+		.default_value =3D 0,
+		.flags =3D 0
+	},  {
+	        .id =3D V4L2_CID_AUTO_FOCUS_STATUS,
+		.type =3D V4L2_CTRL_TYPE_INTEGER,
+		.name =3D  "",
+		.minimum =3D 0,
+		.maximum =3D 1,
+		.step =3D 1,
+		.default_value =3D 0,
+		.flags =3D 0
+	}, {
+	        .id =3D V4L2_CID_AUTO_FOCUS_RANGE,
+		.type =3D V4L2_CTRL_TYPE_INTEGER,
+		.name =3D  "",
+		.minimum =3D 0,
+		.maximum =3D 1,
+		.step =3D 1,
+		.default_value =3D 0,
+		.flags =3D 0
+	}, {
+	        .id =3D V4L2_CID_AUTO_EXPOSURE_BIAS,
+		.type =3D V4L2_CTRL_TYPE_INTEGER,
+		.name =3D  "",
+		.minimum =3D -10000,
+		.maximum =3D 10000,
+		.step =3D 1,
+		.default_value =3D 0,
+		.flags =3D 0
 	},
 };
=20
@@ -905,6 +969,7 @@ int v4lcontrol_vidioc_g_ctrl(struct v4lcontrol_data *da=
ta, void *arg)
 {
 	int i;
 	struct v4l2_control *ctrl =3D arg;
+	int res;
=20
 	for (i =3D 0; i < V4LCONTROL_COUNT; i++)
 		if ((data->controls & (1 << i)) &&
@@ -913,8 +978,10 @@ int v4lcontrol_vidioc_g_ctrl(struct v4lcontrol_data *d=
ata, void *arg)
 			return 0;
 		}
=20
-	return data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+	res =3D data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
 			VIDIOC_G_CTRL, arg);
+
+	return res;
 }
=20
 static void v4lcontrol_alloc_valid_controls(struct v4lcontrol_data *data,
diff --git a/lib/libv4lconvert/control/libv4lcontrol.h b/lib/libv4lconvert/=
control/libv4lcontrol.h
index fa9cf42..7a970cb 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.h
+++ b/lib/libv4lconvert/control/libv4lcontrol.h
@@ -45,6 +45,12 @@ enum {
 	V4LCONTROL_AUTO_ENABLE_COUNT,
 	V4LCONTROL_AUTOGAIN,
 	V4LCONTROL_AUTOGAIN_TARGET,
+	V4LCONTROL_AUTO_FOCUS,
+	V4LCONTROL_FOCUS_START,
+	V4LCONTROL_FOCUS_STOP,
+	V4LCONTROL_FOCUS_STATUS,
+	V4LCONTROL_FOCUS_RANGE,
+	V4LCONTROL_EXPOSURE_BIAS,
 	V4LCONTROL_COUNT
 };
=20
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lco=
nvert.c
index 1a5ccec..e1db987 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -1,3 +1,4 @@
+/* -*- c-file-style: "linux" -*- */
 /*
 #             (C) 2008-2011 Hans de Goede <hdegoede@redhat.com>
=20
@@ -71,6 +72,8 @@ const struct libv4l_dev_ops *v4lconvert_get_default_dev_o=
ps()
 	return &default_dev_ops;
 }
=20
+#define V4LCONVERT_ERR printf
+
 static void v4lconvert_get_framesizes(struct v4lconvert_data *data,
 		unsigned int pixelformat, int index);
=20
@@ -89,7 +92,8 @@ static void v4lconvert_get_framesizes(struct v4lconvert_d=
ata *data,
 	{ V4L2_PIX_FMT_RGB24,		24,	 1,	 5,	0 }, \
 	{ V4L2_PIX_FMT_BGR24,		24,	 1,	 5,	0 }, \
 	{ V4L2_PIX_FMT_YUV420,		12,	 6,	 1,	0 }, \
-	{ V4L2_PIX_FMT_YVU420,		12,	 6,	 1,	0 }
+	{ V4L2_PIX_FMT_YVU420,		12,	 6,	 1,	0 }, \
+	{ V4L2_PIX_FMT_SGRBG10,		16,	 8,	 8,	0 }
=20
 static const struct v4lconvert_pixfmt supported_src_pixfmts[] =3D {
 	SUPPORTED_DST_PIXFMTS,
@@ -131,7 +135,7 @@ static const struct v4lconvert_pixfmt supported_src_pix=
fmts[] =3D {
 	{ V4L2_PIX_FMT_SGBRG8,		 8,	 8,	 8,	0 },
 	{ V4L2_PIX_FMT_SGRBG8,		 8,	 8,	 8,	0 },
 	{ V4L2_PIX_FMT_SRGGB8,		 8,	 8,	 8,	0 },
-	{ V4L2_PIX_FMT_STV0680,		 8,	 8,	 8,	1 },
+	{ V4L2_PIX_FMT_STV0680,		 8,	 8,	 8,	0 },
 	{ V4L2_PIX_FMT_SGRBG10,		16,	 8,	 8,	1 },
 	/* compressed bayer */
 	{ V4L2_PIX_FMT_SPCA561,		 0,	 9,	 9,	1 },
@@ -206,14 +210,16 @@ struct v4lconvert_data *v4lconvert_create_with_dev_op=
s(int fd, void *dev_ops_pri
 	data->fps =3D 30;
=20
 	/* Check supported formats */
-	for (i =3D 0; ; i++) {
+	for (i =3D 0; i < 1; i++) {
 		struct v4l2_fmtdesc fmt =3D { .type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE };
=20
 		fmt.index =3D i;
=20
 		if (data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
-				VIDIOC_ENUM_FMT, &fmt))
-			break;
+					 VIDIOC_ENUM_FMT, &fmt)) {
+			printf("Enum fmt failed. Assuming N900: SGRBG10\n");
+			fmt.pixelformat =3D V4L2_PIX_FMT_SGRBG10;
+		}
=20
 		for (j =3D 0; j < ARRAY_SIZE(supported_src_pixfmts); j++)
 			if (fmt.pixelformat =3D=3D supported_src_pixfmts[j].fmt)
@@ -371,6 +377,7 @@ static int v4lconvert_get_rank(struct v4lconvert_data *=
data,
 	int needed, rank =3D 0;
=20
 	switch (dest_pixelformat) {
+	case V4L2_PIX_FMT_SGRBG10:	=09
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_BGR24:
 		rank =3D supported_src_pixfmts[src_index].rgb_rank;
@@ -525,6 +532,10 @@ static int v4lconvert_do_try_format(struct v4lconvert_=
data *data,
 void v4lconvert_fixup_fmt(struct v4l2_format *fmt)
 {
 	switch (fmt->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_SGRBG10:
+		fmt->fmt.pix.bytesperline =3D fmt->fmt.pix.width * 2;
+		fmt->fmt.pix.sizeimage =3D fmt->fmt.pix.width * fmt->fmt.pix.height * 2;
+		break;
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_BGR24:
 		fmt->fmt.pix.bytesperline =3D fmt->fmt.pix.width * 3;
@@ -687,6 +698,7 @@ static int v4lconvert_processing_needs_double_conversio=
n(
 	case V4L2_PIX_FMT_SGRBG8:
 	case V4L2_PIX_FMT_SRGGB8:
 	case V4L2_PIX_FMT_STV0680:
+	case V4L2_PIX_FMT_SGRBG10:
 		return 0;
 	}
 	switch (dest_pix_fmt) {
@@ -740,6 +752,8 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_=
data *data,
 	unsigned int height =3D fmt->fmt.pix.height;
 	unsigned int bytesperline =3D fmt->fmt.pix.bytesperline;
=20
+	//printf("Convert_pixfmt %lx -> %lx\n", src_pix_fmt, dest_pix_fmt);
+=09
 	switch (src_pix_fmt) {
 	/* JPG and variants */
 	case V4L2_PIX_FMT_MJPEG:
@@ -866,6 +880,9 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_=
data *data,
 			v4lconvert_yuv420_to_bgr24(data->convert_pixfmt_buf, dest, width,
 					height, yvu);
 			break;
+		case V4L2_PIX_FMT_SGRBG10:
+			printf("Convert yuv to sgrbg10\n");
+			exit (1);
 		}
 		break;
 	}
@@ -885,6 +902,9 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_=
data *data,
 		case V4L2_PIX_FMT_YVU420:
 			v4lconvert_hm12_to_yuv420(src, dest, width, height, 1);
 			break;
+		case V4L2_PIX_FMT_SGRBG10:
+			printf("Convert something to sgrbg10\n");
+			exit (1);
 		}
 		break;
=20
@@ -903,6 +923,12 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert=
_data *data,
 		unsigned char *tmpbuf;
 		struct v4l2_format tmpfmt =3D *fmt;
=20
+		if (src_pix_fmt =3D=3D dest_pix_fmt) {
+			int to_copy =3D MIN(dest_size, src_size);
+			memcpy(dest, src, to_copy);
+			return to_copy;
+		}
+
 		tmpbuf =3D v4lconvert_alloc_buffer(width * height,
 				&data->convert_pixfmt_buf, &data->convert_pixfmt_buf_size);
 		if (!tmpbuf)
@@ -986,6 +1012,7 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert=
_data *data,
 			V4LCONVERT_ERR("short raw bayer data frame\n");
 			errno =3D EPIPE;
 			result =3D -1;
+			/* FIXME: but then we proceed anyway?! */
 		}
 		switch (dest_pix_fmt) {
 		case V4L2_PIX_FMT_RGB24:
@@ -1000,6 +1027,9 @@ static int v4lconvert_convert_pixfmt(struct v4lconver=
t_data *data,
 		case V4L2_PIX_FMT_YVU420:
 			v4lconvert_bayer_to_yuv420(src, dest, width, height, bytesperline, src_=
pix_fmt, 1);
 			break;
+		case V4L2_PIX_FMT_SGRBG10:
+			printf("Convert bayer to sgrbg10\n");
+			exit(1);
 		}
 		break;
=20
@@ -1485,6 +1515,12 @@ int v4lconvert_convert(struct v4lconvert_data *data,
 		temp_needed =3D
 			my_src_fmt.fmt.pix.width * my_src_fmt.fmt.pix.height * 3 / 2;
 		break;
+	case V4L2_PIX_FMT_SGRBG10:
+		dest_needed =3D
+			my_dest_fmt.fmt.pix.width * my_dest_fmt.fmt.pix.height * 2;
+		temp_needed =3D
+			my_src_fmt.fmt.pix.width * my_src_fmt.fmt.pix.height * 2;
+		break;
 	default:
 		V4LCONVERT_ERR("Unknown dest format in conversion\n");
 		errno =3D EINVAL;
diff --git a/lib/libv4lconvert/processing/autogain.c b/lib/libv4lconvert/pr=
ocessing/autogain.c
index c6866d6..0888697 100644
--- a/lib/libv4lconvert/processing/autogain.c
+++ b/lib/libv4lconvert/processing/autogain.c
@@ -1,3 +1,4 @@
+/* -*- c-file-style: "linux" -*- */
 /*
 #             (C) 2008-2009 Hans de Goede <hdegoede@redhat.com>
=20
@@ -21,6 +22,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <math.h>
=20
 #include "libv4lprocessing.h"
 #include "libv4lprocessing-priv.h"
@@ -37,6 +39,20 @@ static int autogain_active(struct v4lprocessing_data *da=
ta)
 		data->last_gain_correction =3D 0;
 	}
=20
+	/* Related controls:
+
+	   V4L2_CID_EXPOSURE_ABSOLUTE (integer)
+	   V4L2_CID_EXPOSURE_AUTO_PRIORITY
+	   V4L2_CID_EXPOSURE_BIAS ... mEV
+	   V4L2_CID_EXPOSURE_METERING
+
+	   V4L2_CID_ISO_SENSITIVITY
+	   V4L2_CID_ISO_SENSITIVITY_AUTO
+
+	   V4L2_CID_SCENE_MODE
+	   ...sports.
+	*/
+
 	return autogain;
 }
=20
@@ -46,6 +62,8 @@ static void autogain_adjust(struct v4l2_queryctrl *ctrl, =
int *value,
 {
 	int ctrl_range =3D (ctrl->maximum - ctrl->minimum) / ctrl->step;
=20
+	printf("Audogain: adjust\n");
+
 	/* If we are of 3 * deadzone or more, and we have a fine grained
 	   control, take larger steps, otherwise we take ages to get to the
 	   right setting point. We use 256 as tripping point for determining
@@ -68,6 +86,196 @@ static void autogain_adjust(struct v4l2_queryctrl *ctrl=
, int *value,
 	}
 }
=20
+static int get_luminosity_bayer10(uint16_t *buf, const struct v4l2_format =
*fmt)
+{
+	long long avg_lum =3D 0;
+	int x, y;
+=09
+	buf +=3D fmt->fmt.pix.height * fmt->fmt.pix.bytesperline / 8 +
+		fmt->fmt.pix.width / 4;
+
+	for (y =3D 0; y < fmt->fmt.pix.height / 2; y++) {
+		for (x =3D 0; x < fmt->fmt.pix.width / 2; x++)
+			avg_lum +=3D *buf++;
+		buf +=3D fmt->fmt.pix.bytesperline / 2 - fmt->fmt.pix.width / 2;
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
+#define BUCKETS 20
+
+static void v4l2_histogram_bayer10(unsigned short *buf, int cdf[], const s=
truct v4l2_format *fmt)
+{
+    for (int y =3D 0; y < fmt->fmt.pix.height; y+=3D19)
+      for (int x =3D 0; x < fmt->fmt.pix.width; x+=3D19) {
+	int b;
+	b =3D buf[fmt->fmt.pix.width*y + x];
+	b =3D (b * BUCKETS)/(1024);
+	cdf[b]++;
+      }
+}
+
+static int v4l2_s_ctrl(int fd, long id, long value)
+{
+        int res;
+	struct v4l2_control ctrl;
+        ctrl.id =3D id;
+	ctrl.value =3D value;
+        res =3D v4l2_ioctl(fd, VIDIOC_S_CTRL, &ctrl);
+        if (res < 0)
+                printf("Set control %lx %ld failed\n", id, value);
+        return res;
+}
+
+static double get_bias(struct v4lprocessing_data *data)
+{
+	double bias;
+
+	bias =3D v4lcontrol_get_ctrl(data->control, V4LCONTROL_EXPOSURE_BIAS);
+	printf("Control bias %f\n", bias);
+#if 1
+	bias =3D bias / 1000;
+	bias =3D exp2(bias); /* EV -> internal multipliers */
+#endif
+	return bias;
+}
+
+static int v4l2_set_exposure(struct v4lprocessing_data *data, double expos=
ure)
+{
+	double exp, gain; /* microseconds */
+	int exp_, gain_;
+	int fd =3D data->fd;
+
+	gain =3D 1;
+	exp =3D exposure / gain;
+	if (exp > 10000) {
+		exp =3D 10000;
+		gain =3D exposure / exp;
+	}
+	if (gain > 16) {
+		gain =3D 16;
+		exp =3D exposure / gain;
+	}
+
+	exp_ =3D exp;
+	gain_ =3D 10*log(gain)/log(2);=20
+	printf("Exposure %f %d, gain %f %d\n", exp, exp_, gain, gain_);
+
+	/* gain | ISO | gain_ */
+	/* 1.   | 100 | 0 */
+	/* 2.   | 200 | 10 */
+
+        /* 16.   | 1600 | 40 */
+		=09
+	if (v4l2_s_ctrl(fd, 0x00980913 /* FIXME? V4L2_CID_GAIN */, gain_) < 0) {
+		printf("Could not set gain\n");
+	}
+	if (v4l2_s_ctrl(fd, V4L2_CID_EXPOSURE_ABSOLUTE, exp_) < 0) {
+		printf("Could not set exposure\n");
+	}
+	return 0;
+}
+
+struct exposure_data {
+	double exposure;
+};
+
+static int autogain_calculate_lookup_tables_exp(
+		struct v4lprocessing_data *data,
+		unsigned char *buf, const struct v4l2_format *fmt)
+{
+	int cdf[BUCKETS] =3D { 0, };
+	static struct exposure_data e_data;
+	static struct exposure_data *exp =3D &e_data;
+
+	v4l2_histogram_bayer10((void *) buf, cdf, fmt);
+
+#if 0
+	printf("hist: ");
+	for (i =3D 0; i<BUCKETS; i++)
+		printf("%d ", cdf[i]);
+	printf("\n");
+#endif
+	for (int i=3D1; i<BUCKETS; i++)
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
+	adjustment *=3D get_bias(data);
+	 =20
+	exp->exposure *=3D adjustment;
+	if (exp->exposure < 1)
+		exp->exposure =3D 1;
+	{
+		float limit =3D 64000000;
+		if (exp->exposure > limit)
+			exp->exposure =3D limit;
+	}
+=09
+	if (adjustment !=3D 1.)
+		printf( "AutoExposure: adjustment: %f exposure %f\n", adjustment, exp->e=
xposure);
+
+	v4l2_set_exposure(data, exp->exposure);
+	return 0;
+}
+
+/* This autogain version is suitable for webcams with linear controls, not=
 for cameras */
+
 /* auto gain and exposure algorithm based on the knee algorithm described =
here:
 http://ytse.tricolour.net/docs/LowLightOptimization.html */
 static int autogain_calculate_lookup_tables(
@@ -80,11 +288,17 @@ static int autogain_calculate_lookup_tables(
 	struct v4l2_queryctrl gainctrl, expoctrl;
 	const int deadzone =3D 6;
=20
+	printf("autogain: calculate lookups\n");
+
 	ctrl.id =3D V4L2_CID_EXPOSURE;
 	expoctrl.id =3D V4L2_CID_EXPOSURE;
-	if (SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL, &expoctrl) ||
-			SYS_IOCTL(data->fd, VIDIOC_G_CTRL, &ctrl))
-		return 0;
+	if (v4l2_ioctl(data->fd, VIDIOC_QUERYCTRL, &expoctrl) ||
+	    v4l2_ioctl(data->fd, VIDIOC_G_CTRL, &ctrl)) {
+		/* No exposure control; but perhaps this is digital camera,
+		   we have V4L2_CID_EXPOSURE_ABSOLUTE, and should use different
+		   control algorithm. */
+		return autogain_calculate_lookup_tables_exp(data, buf, fmt);
+	}
=20
 	exposure =3D orig_exposure =3D ctrl.value;
 	/* Determine a value below which we try to not lower the exposure,
@@ -100,25 +314,26 @@ static int autogain_calculate_lookup_tables(
=20
 	ctrl.id =3D V4L2_CID_GAIN;
 	gainctrl.id =3D V4L2_CID_GAIN;
-	if (SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL, &gainctrl) ||
-			SYS_IOCTL(data->fd, VIDIOC_G_CTRL, &ctrl))
+	if (v4l2_ioctl(data->fd, VIDIOC_QUERYCTRL, &gainctrl) ||
+	    v4l2_ioctl(data->fd, VIDIOC_G_CTRL, &ctrl))
 		return 0;
 	gain =3D orig_gain =3D ctrl.value;
=20
+	printf("Looking at pixels...\n");
+
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
@@ -137,7 +352,7 @@ static int autogain_calculate_lookup_tables(
 		avg_lum /=3D fmt->fmt.pix.height * fmt->fmt.pix.width * 3 / 4;
 		break;
 	}
-
+=09
 	/* If we are off a multiple of deadzone, do multiple steps to reach the
 	   desired lumination fast (with the risc of a slight overshoot) */
 	target =3D v4lcontrol_get_ctrl(data->control, V4LCONTROL_AUTOGAIN_TARGET);
@@ -199,20 +414,23 @@ static int autogain_calculate_lookup_tables(
 		data->lookup_table_update_counter =3D V4L2PROCESSING_UPDATE_RATE - 2;
 	}
=20
+	printf("Setting gain %d / exposure %d\n", gain, exposure);
+
 	if (gain !=3D orig_gain) {
 		ctrl.id =3D V4L2_CID_GAIN;
 		ctrl.value =3D gain;
-		SYS_IOCTL(data->fd, VIDIOC_S_CTRL, &ctrl);
+		v4l2_ioctl(data->fd, VIDIOC_S_CTRL, &ctrl);
 	}
 	if (exposure !=3D orig_exposure) {
-		ctrl.id =3D V4L2_CID_EXPOSURE;
+		ctrl.id =3D V4L2_CID_EXPOSURE_ABSOLUTE;
 		ctrl.value =3D exposure;
-		SYS_IOCTL(data->fd, VIDIOC_S_CTRL, &ctrl);
+		v4l2_ioctl(data->fd, VIDIOC_S_CTRL, &ctrl);
 	}
=20
 	return 0;
 }
=20
 struct v4lprocessing_filter autogain_filter =3D {
-	autogain_active, autogain_calculate_lookup_tables
+	autogain_active, autogain_calculate_lookup_tables_exp
 };
+
diff --git a/lib/libv4lconvert/processing/libv4lprocessing-priv.h b/lib/lib=
v4lconvert/processing/libv4lprocessing-priv.h
index e4a29dd..43badef 100644
--- a/lib/libv4lconvert/processing/libv4lprocessing-priv.h
+++ b/lib/libv4lconvert/processing/libv4lprocessing-priv.h
@@ -24,7 +24,9 @@
 #include "../control/libv4lcontrol.h"
 #include "../libv4lsyscall-priv.h"
=20
-#define V4L2PROCESSING_UPDATE_RATE 10
+#define V4L2PROCESSING_UPDATE_RATE 1
+/* Size of lookup tables */
+#define LSIZE 1024
=20
 struct v4lprocessing_data {
 	struct v4lcontrol_data *control;
@@ -32,15 +34,15 @@ struct v4lprocessing_data {
 	int do_process;
 	int controls_changed;
 	/* True if any of the lookup tables does not contain
-	   linear 0-255 */
+	   linear 0..LSIZE-1 */
 	int lookup_table_active;
 	/* Counts the number of processed frames until a
 	   V4L2PROCESSING_UPDATE_RATE overflow happens */
 	int lookup_table_update_counter;
 	/* RGB/BGR lookup tables */
-	unsigned char comp1[256];
-	unsigned char green[256];
-	unsigned char comp2[256];
+	unsigned short comp1[LSIZE];
+	unsigned short green[LSIZE];
+	unsigned short comp2[LSIZE];
 	/* Filter private data for filters which need it */
 	/* whitebalance.c data */
 	int green_avg;
@@ -48,7 +50,7 @@ struct v4lprocessing_data {
 	int comp2_avg;
 	/* gamma.c data */
 	int last_gamma;
-	unsigned char gamma_table[256];
+	unsigned char gamma_table[LSIZE];
 	/* autogain.c data */
 	int last_gain_correction;
 };
@@ -64,5 +66,6 @@ struct v4lprocessing_filter {
 extern struct v4lprocessing_filter whitebalance_filter;
 extern struct v4lprocessing_filter autogain_filter;
 extern struct v4lprocessing_filter gamma_filter;
+extern struct v4lprocessing_filter focus_filter;
=20
 #endif
diff --git a/lib/libv4lconvert/processing/libv4lprocessing.c b/lib/libv4lco=
nvert/processing/libv4lprocessing.c
index b061f50..b66c15a 100644
--- a/lib/libv4lconvert/processing/libv4lprocessing.c
+++ b/lib/libv4lconvert/processing/libv4lprocessing.c
@@ -31,6 +31,7 @@ static struct v4lprocessing_filter *filters[] =3D {
 	&whitebalance_filter,
 	&autogain_filter,
 	&gamma_filter,
+	&focus_filter,
 };
=20
 struct v4lprocessing_data *v4lprocessing_create(int fd, struct v4lcontrol_=
data *control)
@@ -74,7 +75,7 @@ static void v4lprocessing_update_lookup_tables(struct v4l=
processing_data *data,
 {
 	int i;
=20
-	for (i =3D 0; i < 256; i++) {
+	for (i =3D 0; i < LSIZE; i++) {
 		data->comp1[i] =3D i;
 		data->green[i] =3D i;
 		data->comp2[i] =3D i;
@@ -89,15 +90,34 @@ static void v4lprocessing_update_lookup_tables(struct v=
4lprocessing_data *data,
 	}
 }
=20
-static void v4lprocessing_do_processing(struct v4lprocessing_data *data,
-		unsigned char *buf, const struct v4l2_format *fmt)
+static void v4lprocessing_do_processing_bayer10(struct v4lprocessing_data =
*data,
+		unsigned short *buf, const struct v4l2_format *fmt)
 {
 	int x, y;
+  		for (y =3D 0; y < fmt->fmt.pix.height / 2; y++) {
+			for (x =3D 0; x < fmt->fmt.pix.width / 2; x++) {
+				*buf =3D data->green[*buf];
+				buf++;
+				*buf =3D data->comp1[*buf];
+				buf++;
+			}
+			buf +=3D fmt->fmt.pix.bytesperline - fmt->fmt.pix.width * 2;
+			for (x =3D 0; x < fmt->fmt.pix.width / 2; x++) {
+				*buf =3D data->comp2[*buf];
+				buf++;
+				*buf =3D data->green[*buf];
+				buf++;
+			}
+			buf +=3D fmt->fmt.pix.bytesperline - fmt->fmt.pix.width * 2;;
+		}
=20
-	switch (fmt->fmt.pix.pixelformat) {
-	case V4L2_PIX_FMT_SGBRG8:
-	case V4L2_PIX_FMT_SGRBG8: /* Bayer patterns starting with green */
-		for (y =3D 0; y < fmt->fmt.pix.height / 2; y++) {
+}
+
+static void v4lprocessing_do_processing_bayer8(struct v4lprocessing_data *=
data,
+		unsigned char *buf, const struct v4l2_format *fmt)
+{
+	int x, y;
+  		for (y =3D 0; y < fmt->fmt.pix.height / 2; y++) {
 			for (x =3D 0; x < fmt->fmt.pix.width / 2; x++) {
 				*buf =3D data->green[*buf];
 				buf++;
@@ -113,8 +133,25 @@ static void v4lprocessing_do_processing(struct v4lproc=
essing_data *data,
 			}
 			buf +=3D fmt->fmt.pix.bytesperline - fmt->fmt.pix.width;
 		}
+
+}
+
+static void v4lprocessing_do_processing(struct v4lprocessing_data *data,
+		unsigned char *buf, const struct v4l2_format *fmt)
+{
+	int x, y;
+
+	switch (fmt->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_SGRBG10: /* Bayer patterns starting with green */
+	  	v4lprocessing_do_processing_bayer10(data, buf, fmt);
 		break;
=20
+	case V4L2_PIX_FMT_SGBRG8:
+	case V4L2_PIX_FMT_SGRBG8: /* Bayer patterns starting with green */
+	  	v4lprocessing_do_processing_bayer8(data, buf, fmt);
+		break;
+
+
 	case V4L2_PIX_FMT_SBGGR8:
 	case V4L2_PIX_FMT_SRGGB8: /* Bayer patterns *NOT* starting with green */
 		for (y =3D 0; y < fmt->fmt.pix.height / 2; y++) {
@@ -164,15 +201,20 @@ void v4lprocessing_processing(struct v4lprocessing_da=
ta *data,
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
 	default:
-		return; /* Non supported pix format */
+		printf("Processing: unsupported pix format\n");
+		break; /* Non supported pix format */
 	}
=20
 	if (data->controls_changed ||
-			data->lookup_table_update_counter =3D=3D V4L2PROCESSING_UPDATE_RATE) {
+			data->lookup_table_update_counter >=3D V4L2PROCESSING_UPDATE_RATE) {
 		data->controls_changed =3D 0;
 		data->lookup_table_update_counter =3D 0;
 		/* Do this after resetting lookup_table_update_counter so that filters c=
an
@@ -181,8 +223,9 @@ void v4lprocessing_processing(struct v4lprocessing_data=
 *data,
 	} else
 		data->lookup_table_update_counter++;
=20
-	if (data->lookup_table_active)
+	if (data->lookup_table_active) {
 		v4lprocessing_do_processing(data, buf, fmt);
+	}
=20
 	data->do_process =3D 0;
 }
diff --git a/lib/libv4lconvert/processing/whitebalance.c b/lib/libv4lconver=
t/processing/whitebalance.c
index c74069a..95eb9c7 100644
--- a/lib/libv4lconvert/processing/whitebalance.c
+++ b/lib/libv4lconvert/processing/whitebalance.c
@@ -27,8 +27,8 @@
 #include "libv4lprocessing-priv.h"
 #include "../libv4lconvert-priv.h" /* for PIX_FMT defines */
=20
-#define CLIP256(color) (((color) > 0xff) ? 0xff : (((color) < 0) ? 0 : (co=
lor)))
 #define CLIP(color, min, max) (((color) > (max)) ? (max) : (((color) < (mi=
n)) ? (min) : (color)))
+#define CLIPLSIZE(color) CLIP(color, 0, LSIZE-1)
=20
 static int whitebalance_active(struct v4lprocessing_data *data)
 {
@@ -43,6 +43,7 @@ static int whitebalance_active(struct v4lprocessing_data =
*data)
 	return wb;
 }
=20
+/* Updates data->comp1/comp2 tables, that are later used by v4lprocessing_=
do_processing() */
 static int whitebalance_calculate_lookup_tables_generic(
 		struct v4lprocessing_data *data, int green_avg, int comp1_avg, int comp2=
_avg)
 {
@@ -51,12 +52,12 @@ static int whitebalance_calculate_lookup_tables_generic(
 	const int max_step =3D 128;
=20
 	/* Clip averages (restricts maximum white balance correction) */
-	green_avg =3D CLIP(green_avg, 512, 3072);
-	comp1_avg =3D CLIP(comp1_avg, 512, 3072);
-	comp2_avg =3D CLIP(comp2_avg, 512, 3072);
+	green_avg =3D CLIP(green_avg, LSIZE*2, LSIZE*12);
+	comp1_avg =3D CLIP(comp1_avg, LSIZE*2, LSIZE*12);
+	comp2_avg =3D CLIP(comp2_avg, LSIZE*2, LSIZE*12);
=20
 	/* First frame ? */
-	if (data->green_avg =3D=3D 0) {
+	if (1 || data->green_avg =3D=3D 0) {
 		data->green_avg =3D green_avg;
 		data->comp1_avg =3D comp1_avg;
 		data->comp2_avg =3D comp2_avg;
@@ -111,15 +112,54 @@ static int whitebalance_calculate_lookup_tables_gener=
ic(
=20
 	avg_avg =3D (data->green_avg + data->comp1_avg + data->comp2_avg) / 3;
=20
-	for (i =3D 0; i < 256; i++) {
-		data->comp1[i] =3D CLIP256(data->comp1[i] * avg_avg / data->comp1_avg);
-		data->green[i] =3D CLIP256(data->green[i] * avg_avg / data->green_avg);
-		data->comp2[i] =3D CLIP256(data->comp2[i] * avg_avg / data->comp2_avg);
+	for (i =3D 0; i < LSIZE; i++) {
+		data->comp1[i] =3D CLIPLSIZE(data->comp1[i] * avg_avg / data->comp1_avg);
+		data->green[i] =3D CLIPLSIZE(data->green[i] * avg_avg / data->green_avg);
+		data->comp2[i] =3D CLIPLSIZE(data->comp2[i] * avg_avg / data->comp2_avg);
 	}
=20
 	return 1;
 }
=20
+static int whitebalance_calculate_lookup_tables_bayer10(
+		struct v4lprocessing_data *data, unsigned short *buf,
+		const struct v4l2_format *fmt, int starts_with_green)
+{
+	int x, y, a1 =3D 0, a2 =3D 0, b1 =3D 0, b2 =3D 0;
+	int green_avg, comp1_avg, comp2_avg;
+
+	for (y =3D 0; y < fmt->fmt.pix.height; y +=3D 2) {
+		for (x =3D 0; x < fmt->fmt.pix.width; x +=3D 2) {
+			a1 +=3D *buf++;
+			a2 +=3D *buf++;
+		}
+		buf +=3D fmt->fmt.pix.bytesperline - fmt->fmt.pix.width * 2;
+		for (x =3D 0; x < fmt->fmt.pix.width; x +=3D 2) {
+			b1 +=3D *buf++;
+			b2 +=3D *buf++;
+		}
+		buf +=3D fmt->fmt.pix.bytesperline - fmt->fmt.pix.width * 2;
+	}
+
+	if (starts_with_green) {
+		green_avg =3D a1 / 2 + b2 / 2;
+		comp1_avg =3D a2;
+		comp2_avg =3D b1;
+	} else {
+		green_avg =3D a2 / 2 + b1 / 2;
+		comp1_avg =3D a1;
+		comp2_avg =3D b2;
+	}
+
+	/* Norm avg to ~ 0 - 4095 */
+	green_avg /=3D fmt->fmt.pix.width * fmt->fmt.pix.height / 64;
+	comp1_avg /=3D fmt->fmt.pix.width * fmt->fmt.pix.height / 64;
+	comp2_avg /=3D fmt->fmt.pix.width * fmt->fmt.pix.height / 64;
+
+	return whitebalance_calculate_lookup_tables_generic(data, green_avg,
+			comp1_avg, comp2_avg);
+}
+
 static int whitebalance_calculate_lookup_tables_bayer(
 		struct v4lprocessing_data *data, unsigned char *buf,
 		const struct v4l2_format *fmt, int starts_with_green)
@@ -189,6 +229,9 @@ static int whitebalance_calculate_lookup_tables(
 		unsigned char *buf, const struct v4l2_format *fmt)
 {
 	switch (fmt->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_SGRBG10: /* Bayer patterns starting with green */
+		return whitebalance_calculate_lookup_tables_bayer10(data, (void *) buf, =
fmt, 1);
+
 	case V4L2_PIX_FMT_SGBRG8:
 	case V4L2_PIX_FMT_SGRBG8: /* Bayer patterns starting with green */
 		return whitebalance_calculate_lookup_tables_bayer(data, buf, fmt, 1);
@@ -200,6 +243,9 @@ static int whitebalance_calculate_lookup_tables(
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_BGR24:
 		return whitebalance_calculate_lookup_tables_rgb(data, buf, fmt);
+
+	default:
+	        printf("Whitebalance: unknown format\n");
 	}
=20
 	return 0; /* Should never happen */


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnrw3oACgkQMOfwapXb+vLhlwCeIXlYXciVhegyZze5FLRuESJw
b7cAnjOuqfttP2e/1/ZBnW5Y74mRT2wZ
=Idvj
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
