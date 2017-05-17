Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:43195 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753322AbdEQIDl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 04:03:41 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Gregor Jasny <gjasny@googlemail.com>,
        Christophe Priouzeau <christophe.priouzeau@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 3/5] configure.ac: revisit --disable-libv4l to --disable-dyn-libv4l
Date: Wed, 17 May 2017 10:03:10 +0200
Message-ID: <1495008192-21202-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1495008192-21202-1-git-send-email-hugues.fruchet@st.com>
References: <1495008192-21202-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--disable-libv4l is not disabling libv4l compilation, but only
dynamic library support of libv4l libraries.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 configure.ac                  | 16 ++++++++--------
 lib/libv4l1/Makefile.am       |  2 +-
 lib/libv4l2/Makefile.am       |  2 +-
 lib/libv4l2rds/Makefile.am    |  2 +-
 lib/libv4lconvert/Makefile.am |  2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/configure.ac b/configure.ac
index 0ce5082..033d13c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -372,11 +372,11 @@ AC_ARG_ENABLE(libdvbv5,
    esac]
 )
 
-AC_ARG_ENABLE(libv4l,
-  AS_HELP_STRING([--disable-libv4l], [disable dynamic libv4l compilation]),
+AC_ARG_ENABLE(dyn-libv4l,
+  AS_HELP_STRING([--disable-dyn-libv4l], [disable dynamic libv4l support]),
   [case "${enableval}" in
      yes | no ) ;;
-     *) AC_MSG_ERROR(bad value ${enableval} for --disable-libv4l) ;;
+     *) AC_MSG_ERROR(bad value ${enableval} for --disable-dyn-libv4l) ;;
    esac]
 )
 
@@ -436,11 +436,11 @@ AC_SEARCH_LIBS([backtrace], [execinfo], [
 AM_CONDITIONAL([WITH_LIBDVBV5],     [test x$enable_libdvbv5  != xno -a x$have_libudev = xyes])
 AM_CONDITIONAL([WITH_DVBV5_REMOTE], [test x$enable_libdvbv5  != xno -a x$have_libudev = xyes -a x$have_pthread = xyes])
 
-AM_CONDITIONAL([WITH_LIBV4L],       [test x$enable_libv4l    != xno])
+AM_CONDITIONAL([WITH_DYN_LIBV4L],   [test x$enable_dyn_libv4l != xno])
 AM_CONDITIONAL([WITH_V4LUTILS],	    [test x$enable_v4l_utils != xno -a x$linux_os = xyes])
 AM_CONDITIONAL([WITH_QV4L2],	    [test x${qt_pkgconfig} = xtrue -a x$enable_qv4l2 != xno])
-AM_CONDITIONAL([WITH_V4L_PLUGINS],  [test x$enable_libv4l != xno -a x$enable_shared != xno])
-AM_CONDITIONAL([WITH_V4L_WRAPPERS], [test x$enable_libv4l != xno -a x$enable_shared != xno])
+AM_CONDITIONAL([WITH_V4L_PLUGINS],  [test x$enable_dyn_libv4l != xno -a x$enable_shared != xno])
+AM_CONDITIONAL([WITH_V4L_WRAPPERS], [test x$enable_dyn_libv4l != xno -a x$enable_shared != xno])
 AM_CONDITIONAL([WITH_QTGL],	    [test x${qt_pkgconfig_gl} = xtrue])
 AM_CONDITIONAL([WITH_GCONV],        [test x${enable_gconv} = xyes])
 AM_CONDITIONAL([WITH_V4L2_CTL_LIBV4L], [test x${enable_v4l2_ctl_libv4l} != xno])
@@ -465,7 +465,7 @@ AM_COND_IF([WITH_LIBDVBV5], [USE_LIBDVBV5="yes"], [USE_LIBDVBV5="no"])
 AM_COND_IF([WITH_DVBV5_REMOTE], [USE_DVBV5_REMOTE="yes"
 				 AC_DEFINE([HAVE_DVBV5_REMOTE], [1], [Usage of DVBv5 remote enabled])],
 			        [USE_DVBV5_REMOTE="no"])
-AM_COND_IF([WITH_LIBV4L], [USE_LIBV4L="yes"], [USE_LIBV4L="no"])
+AM_COND_IF([WITH_DYN_LIBV4L], [USE_DYN_LIBV4L="yes"], [USE_DYN_LIBV4L="no"])
 AM_COND_IF([WITH_V4LUTILS], [USE_V4LUTILS="yes"], [USE_V4LUTILS="no"])
 AM_COND_IF([WITH_QV4L2], [USE_QV4L2="yes"], [USE_QV4L2="no"])
 AM_COND_IF([WITH_V4L_PLUGINS], [USE_V4L_PLUGINS="yes"], [USE_V4L_PLUGINS="no"])
@@ -500,7 +500,7 @@ compile time options summary
 
     gconv                      : $USE_GCONV
 
-    dynamic libv4l             : $USE_LIBV4L
+    dynamic libv4l             : $USE_DYN_LIBV4L
     v4l_plugins                : $USE_V4L_PLUGINS
     v4l_wrappers               : $USE_V4L_WRAPPERS
     libdvbv5                   : $USE_LIBDVBV5
diff --git a/lib/libv4l1/Makefile.am b/lib/libv4l1/Makefile.am
index f768eaa..42cb3db 100644
--- a/lib/libv4l1/Makefile.am
+++ b/lib/libv4l1/Makefile.am
@@ -1,4 +1,4 @@
-if WITH_LIBV4L
+if WITH_DYN_LIBV4L
 lib_LTLIBRARIES = libv4l1.la
 include_HEADERS = ../include/libv4l1.h ../include/libv4l1-videodev.h
 pkgconfig_DATA = libv4l1.pc
diff --git a/lib/libv4l2/Makefile.am b/lib/libv4l2/Makefile.am
index 1314a99..811c45c 100644
--- a/lib/libv4l2/Makefile.am
+++ b/lib/libv4l2/Makefile.am
@@ -1,4 +1,4 @@
-if WITH_LIBV4L
+if WITH_DYN_LIBV4L
 lib_LTLIBRARIES = libv4l2.la
 include_HEADERS = ../include/libv4l2.h ../include/libv4l-plugin.h
 pkgconfig_DATA = libv4l2.pc
diff --git a/lib/libv4l2rds/Makefile.am b/lib/libv4l2rds/Makefile.am
index 4f23a3f..73fdd3e 100644
--- a/lib/libv4l2rds/Makefile.am
+++ b/lib/libv4l2rds/Makefile.am
@@ -1,4 +1,4 @@
-if WITH_LIBV4L
+if WITH_DYN_LIBV4L
 lib_LTLIBRARIES = libv4l2rds.la
 include_HEADERS = ../include/libv4l2rds.h
 pkgconfig_DATA = libv4l2rds.pc
diff --git a/lib/libv4lconvert/Makefile.am b/lib/libv4lconvert/Makefile.am
index 5c8a1cf..4f332fa 100644
--- a/lib/libv4lconvert/Makefile.am
+++ b/lib/libv4lconvert/Makefile.am
@@ -1,4 +1,4 @@
-if WITH_LIBV4L
+if WITH_DYN_LIBV4L
 lib_LTLIBRARIES = libv4lconvert.la
 libv4lconvertpriv_PROGRAMS = ov511-decomp ov518-decomp
 include_HEADERS = ../include/libv4lconvert.h
-- 
1.9.1
