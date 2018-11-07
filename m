Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59479 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbeKGVcJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 16:32:09 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: Peter Seiderer <ps.report@gmx.net>
Subject: [PATCH v2 v4l-utils] configure: build without BPF support in ir-keytable
Date: Wed,  7 Nov 2018 12:02:05 +0000
Message-Id: <20181107120205.13851-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It currently does not build on mips and some platforms do not have
BPF support yet (risc-v, for example).

Signed-off-by: Sean Young <sean@mess.org>
---
 configure.ac               | 17 +++++++++++++----
 utils/keytable/Makefile.am |  7 ++++---
 utils/keytable/keytable.c  |  5 ++++-
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/configure.ac b/configure.ac
index 387f8539..5cc34c24 100644
--- a/configure.ac
+++ b/configure.ac
@@ -173,16 +173,12 @@ AM_CONDITIONAL([HAVE_X11], [test x$x11_pkgconfig = xyes])
 PKG_CHECK_MODULES([LIBELF], [libelf], [libelf_pkgconfig=yes], [libelf_pkgconfig=no])
 AC_SUBST([LIBELF_CFLAGS])
 AC_SUBST([LIBELF_LIBS])
-AM_CONDITIONAL([HAVE_LIBELF], [test x$libelf_pkgconfig = xyes])
 if test "x$libelf_pkgconfig" = "xyes"; then
   AC_CHECK_PROG([CLANG], clang, clang)
-  AC_DEFINE([HAVE_LIBELF], [1], [libelf library is present])
 else
   AC_MSG_WARN(libelf library not available)
 fi
 
-AM_CONDITIONAL([BPF_PROTOCOLS], [test x$CLANG = xclang])
-
 AS_IF([test "x$x11_pkgconfig" = xyes],
       [PKG_CHECK_MODULES(GL, [gl], [gl_pkgconfig=yes], [gl_pkgconfig=no])], [gl_pkgconfig=no])
 AC_SUBST([GL_CFLAGS])
@@ -453,6 +449,14 @@ AC_ARG_ENABLE(gconv,
    esac]
 )
 
+AC_ARG_ENABLE(bpf,
+  AS_HELP_STRING([--disable-bpf], [disable IR BPF decoders]),
+  [case "${enableval}" in
+    yes | no ) ;;
+    *) AC_MSG_ERROR(bad value ${enableval} for --enable-bpf) ;;
+   esac]
+)
+
 PKG_CHECK_MODULES([SDL2], [sdl2 SDL2_image], [sdl_pc=yes], [sdl_pc=no])
 AM_CONDITIONAL([HAVE_SDL], [test x$sdl_pc = xyes])
 
@@ -475,6 +479,7 @@ AM_CONDITIONAL([WITH_GCONV],        [test x$enable_gconv = xyes -a x$enable_shar
 AM_CONDITIONAL([WITH_V4L2_CTL_LIBV4L], [test x${enable_v4l2_ctl_libv4l} != xno])
 AM_CONDITIONAL([WITH_V4L2_CTL_STREAM_TO], [test x${enable_v4l2_ctl_stream_to} != xno])
 AM_CONDITIONAL([WITH_V4L2_COMPLIANCE_LIBV4L], [test x${enable_v4l2_compliance_libv4l} != xno])
+AM_CONDITIONAL([WITH_BPF],          [test x$enable_bpf != xno -a x$libelf_pkgconfig = xyes -a x$CLANG = xclang])
 
 # append -static to libtool compile and link command to enforce static libs
 AS_IF([test x$enable_libdvbv5 = xno], [AC_SUBST([ENFORCE_LIBDVBV5_STATIC], ["-static"])])
@@ -505,6 +510,9 @@ AM_COND_IF([WITH_V4L_WRAPPERS], [USE_V4L_WRAPPERS="yes"], [USE_V4L_WRAPPERS="no"
 AM_COND_IF([WITH_GCONV], [USE_GCONV="yes"], [USE_GCONV="no"])
 AM_COND_IF([WITH_V4L2_CTL_LIBV4L], [USE_V4L2_CTL_LIBV4L="yes"], [USE_V4L2_CTL_LIBV4L="no"])
 AM_COND_IF([WITH_V4L2_COMPLIANCE_LIBV4L], [USE_V4L2_COMPLIANCE_LIBV4L="yes"], [USE_V4L2_COMPLIANCE_LIBV4L="no"])
+AM_COND_IF([WITH_BPF],         [USE_BPF="yes"
+                                AC_DEFINE([HAVE_BPF], [1], [BPF IR decoder support enabled])],
+				[USE_BPF="no"])
 AS_IF([test "x$alsa_pkgconfig" = "xtrue"], [USE_ALSA="yes"], [USE_ALSA="no"])
 
 AC_OUTPUT
@@ -549,4 +557,5 @@ compile time options summary
     qvidcap                    : $USE_QVIDCAP
     v4l2-ctl uses libv4l       : $USE_V4L2_CTL_LIBV4L
     v4l2-compliance uses libv4l: $USE_V4L2_COMPLIANCE_LIBV4L
+    BPF IR Decoders:           : $USE_BPF
 EOF
diff --git a/utils/keytable/Makefile.am b/utils/keytable/Makefile.am
index 90e4c8c8..ddbab0f7 100644
--- a/utils/keytable/Makefile.am
+++ b/utils/keytable/Makefile.am
@@ -6,14 +6,15 @@ udevrules_DATA = 70-infrared.rules
 
 ir_keytable_SOURCES = keytable.c parse.h ir-encode.c ir-encode.h toml.c toml.h
 
-if HAVE_LIBELF
+if WITH_BPF
 ir_keytable_SOURCES += bpf.c bpf_load.c bpf.h bpf_load.h
 endif
 
 ir_keytable_LDADD = @LIBINTL@
-ir_keytable_LDFLAGS = $(ARGP_LIBS) $(LIBELF_LIBS)
+ir_keytable_LDFLAGS = $(ARGP_LIBS)
 
-if BPF_PROTOCOLS
+if WITH_BPF
+ir_keytable_LDFLAGS += $(LIBELF_LIBS)
 SUBDIRS = bpf_protocols
 endif
 
diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index a7ed436b..6fc22358 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -34,8 +34,11 @@
 #include "ir-encode.h"
 #include "parse.h"
 #include "toml.h"
+
+#ifdef HAVE_BPF
 #include "bpf.h"
 #include "bpf_load.h"
+#endif
 
 #ifdef ENABLE_NLS
 # define _(string) gettext(string)
@@ -1847,7 +1850,7 @@ static void device_info(int fd, char *prepend)
 		perror ("EVIOCGID");
 }
 
-#ifdef HAVE_LIBELF
+#ifdef HAVE_BPF
 #define MAX_PROGS 64
 static void attach_bpf(const char *lirc_name, const char *bpf_prog, struct toml_table_t *toml)
 {
-- 
2.17.2
