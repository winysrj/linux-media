Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:56488 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbaDOSla (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 14:41:30 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so8162930eek.27
        for <linux-media@vger.kernel.org>; Tue, 15 Apr 2014 11:41:29 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 4/4] libdvbv5: build dynamic libdvbv5 by default
Date: Tue, 15 Apr 2014 20:39:33 +0200
Message-Id: <1397587173-1120-4-git-send-email-neolynx@gmail.com>
In-Reply-To: <1397587173-1120-1-git-send-email-neolynx@gmail.com>
References: <1397587173-1120-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- renamed ./configure option --enable-libdvbv5 to --disable-libdvbv5
- thus libdvbv5 will be build shared by default
- cleanups in configure.ac

Signed-off-by: André Roth <neolynx@gmail.com>
---
 configure.ac | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/configure.ac b/configure.ac
index 4080d1e..474c681 100644
--- a/configure.ac
+++ b/configure.ac
@@ -216,10 +216,10 @@ AC_DEFINE_DIR([IR_KEYTABLE_USER_DIR], [keytableuserdir], [ir-keytable user defin
 # options
 
 AC_ARG_ENABLE(libdvbv5,
-  AS_HELP_STRING([--enable-libdvbv5], [enable experimental dynamic libdvbv5 compilation]),
+  AS_HELP_STRING([--disable-libdvbv5], [disable experimental dynamic libdvbv5 compilation]),
   [case "${enableval}" in
      yes | no ) ;;
-     *) AC_MSG_ERROR(bad value ${enableval} for --enable-libdvbv5) ;;
+     *) AC_MSG_ERROR(bad value ${enableval} for --disable-libdvbv5) ;;
    esac]
 )
 
@@ -227,7 +227,7 @@ AC_ARG_ENABLE(libv4l,
   AS_HELP_STRING([--disable-libv4l], [disable dynamic libv4l compilation]),
   [case "${enableval}" in
      yes | no ) ;;
-     *) AC_MSG_ERROR(bad value ${enableval} for --enable-libv4l) ;;
+     *) AC_MSG_ERROR(bad value ${enableval} for --disable-libv4l) ;;
    esac]
 )
 
@@ -235,7 +235,7 @@ AC_ARG_ENABLE(v4l-utils,
   AS_HELP_STRING([--disable-v4l-utils], [disable v4l-utils compilation]),
   [case "${enableval}" in
      yes | no ) ;;
-     *) AC_MSG_ERROR(bad value ${enableval} for --enable-v4l-utils) ;;
+     *) AC_MSG_ERROR(bad value ${enableval} for --disable-v4l-utils) ;;
    esac]
 )
 
@@ -247,17 +247,17 @@ AC_ARG_ENABLE(qv4l2,
    esac]
 )
 
-AM_CONDITIONAL([WITH_LIBDVBV5], [test x$enable_libdvbv5 = xyes])
-AM_CONDITIONAL([WITH_LIBV4L], [test x$enable_libv4l != xno])
-AM_CONDITIONAL([WITH_V4LUTILS], [test x$enable_v4l_utils != "xno"])
-AM_CONDITIONAL([WITH_QV4L2], [test ${qt_pkgconfig} = true -a x$enable_qv4l2 != xno])
-AM_CONDITIONAL([WITH_V4L_PLUGINS], [test x$enable_libv4l != xno -a x$enable_shared != xno])
+AM_CONDITIONAL([WITH_LIBDVBV5],     [test x$enable_libdvbv5  != xno])
+AM_CONDITIONAL([WITH_LIBV4L],       [test x$enable_libv4l    != xno])
+AM_CONDITIONAL([WITH_V4LUTILS],	    [test x$enable_v4l_utils != xno])
+AM_CONDITIONAL([WITH_QV4L2],	    [test ${qt_pkgconfig}  = true -a x$enable_qv4l2 != xno])
+AM_CONDITIONAL([WITH_V4L_PLUGINS],  [test x$enable_libv4l != xno -a x$enable_shared != xno])
 AM_CONDITIONAL([WITH_V4L_WRAPPERS], [test x$enable_libv4l != xno -a x$enable_shared != xno])
-AM_CONDITIONAL([WITH_QTGL], [test ${qt_pkgconfig_gl} = true])
+AM_CONDITIONAL([WITH_QTGL],	    [test ${qt_pkgconfig_gl} = true])
 
 # append -static to libtool compile and link command to enforce static libs
-AS_IF([test x$enable_libdvbv5 != xyes], [AC_SUBST([ENFORCE_LIBDVBV5_STATIC], ["-static"])])
-AS_IF([test x$enable_libv4l = xno], [AC_SUBST([ENFORCE_LIBV4L_STATIC], ["-static"])])
+AS_IF([test x$enable_libdvbv5 = xno], [AC_SUBST([ENFORCE_LIBDVBV5_STATIC], ["-static"])])
+AS_IF([test x$enable_libv4l = xno],   [AC_SUBST([ENFORCE_LIBV4L_STATIC],   ["-static"])])
 
 # misc
 
-- 
1.9.1

