Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:27963 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753468AbdEQIDl (ORCPT
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
Subject: [PATCH v1 4/5] configure.ac: add --disable-libv4l option
Date: Wed, 17 May 2017 10:03:11 +0200
Message-ID: <1495008192-21202-5-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1495008192-21202-1-git-send-email-hugues.fruchet@st.com>
References: <1495008192-21202-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an option to disable libv4l libraries and plugins compilation.
If system is not supporting dynamic shared libraries, this option
is automatically set.
dlopen() is no more a mandatory dependency (warning is kept).
lib/ and contrib/ folders are no more built with this option set
because of libv4l dependency.
utils/ folder is still built with this options set but without
rds-ctl because of its libv4l dependency.
v4l2-compliance and v4l2-ctl are also built but without any links
on libv4l and libv4lconvert libraries.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 Makefile.am                       | 11 +++++++++--
 configure.ac                      | 12 +++++++++++-
 utils/Makefile.am                 |  6 +++++-
 utils/v4l2-compliance/Makefile.am |  4 ++++
 utils/v4l2-ctl/Makefile.am        |  4 ++++
 5 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index e603472..07c3ef8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,10 +1,17 @@
 AUTOMAKE_OPTIONS = foreign
 ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS = v4l-utils-po libdvbv5-po lib
+SUBDIRS = v4l-utils-po libdvbv5-po
+
+if WITH_LIBV4L
+SUBDIRS += lib
+endif
 
 if WITH_V4LUTILS
-SUBDIRS += utils contrib
+SUBDIRS += utils
+if WITH_LIBV4L
+SUBDIRS += contrib
+endif
 endif
 
 EXTRA_DIST = android-config.h bootstrap.sh doxygen_libdvbv5.cfg include COPYING.libv4l \
diff --git a/configure.ac b/configure.ac
index 033d13c..26dc18d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -286,7 +286,7 @@ dl_saved_libs=$LIBS
   AC_SEARCH_LIBS([dlopen],
                  [dl],
                  [test "$ac_cv_search_dlopen" = "none required" || DLOPEN_LIBS=$ac_cv_search_dlopen],
-                 [AC_MSG_ERROR([unable to find the dlopen() function])])
+                 [AC_MSG_WARN([unable to find the dlopen() function])])
   AC_SUBST([DLOPEN_LIBS])
 LIBS=$dl_saved_libs
 
@@ -372,6 +372,14 @@ AC_ARG_ENABLE(libdvbv5,
    esac]
 )
 
+AC_ARG_ENABLE(libv4l,
+  AS_HELP_STRING([--disable-libv4l], [disable libv4l compilation]),
+  [case "${enableval}" in
+     yes | no ) ;;
+     *) AC_MSG_ERROR(bad value ${enableval} for --disable-libv4l) ;;
+   esac]
+)
+
 AC_ARG_ENABLE(dyn-libv4l,
   AS_HELP_STRING([--disable-dyn-libv4l], [disable dynamic libv4l support]),
   [case "${enableval}" in
@@ -437,6 +445,7 @@ AM_CONDITIONAL([WITH_LIBDVBV5],     [test x$enable_libdvbv5  != xno -a x$have_li
 AM_CONDITIONAL([WITH_DVBV5_REMOTE], [test x$enable_libdvbv5  != xno -a x$have_libudev = xyes -a x$have_pthread = xyes])
 
 AM_CONDITIONAL([WITH_DYN_LIBV4L],   [test x$enable_dyn_libv4l != xno])
+AM_CONDITIONAL([WITH_LIBV4L],       [test x$enable_libv4l    != xno -a x$enable_shared != xno])
 AM_CONDITIONAL([WITH_V4LUTILS],	    [test x$enable_v4l_utils != xno -a x$linux_os = xyes])
 AM_CONDITIONAL([WITH_QV4L2],	    [test x${qt_pkgconfig} = xtrue -a x$enable_qv4l2 != xno])
 AM_CONDITIONAL([WITH_V4L_PLUGINS],  [test x$enable_dyn_libv4l != xno -a x$enable_shared != xno])
@@ -465,6 +474,7 @@ AM_COND_IF([WITH_LIBDVBV5], [USE_LIBDVBV5="yes"], [USE_LIBDVBV5="no"])
 AM_COND_IF([WITH_DVBV5_REMOTE], [USE_DVBV5_REMOTE="yes"
 				 AC_DEFINE([HAVE_DVBV5_REMOTE], [1], [Usage of DVBv5 remote enabled])],
 			        [USE_DVBV5_REMOTE="no"])
+AM_COND_IF([WITH_LIBV4L], [USE_LIBV4L="yes"], [USE_LIBV4L="no"])
 AM_COND_IF([WITH_DYN_LIBV4L], [USE_DYN_LIBV4L="yes"], [USE_DYN_LIBV4L="no"])
 AM_COND_IF([WITH_V4LUTILS], [USE_V4LUTILS="yes"], [USE_V4LUTILS="no"])
 AM_COND_IF([WITH_QV4L2], [USE_QV4L2="yes"], [USE_QV4L2="no"])
diff --git a/utils/Makefile.am b/utils/Makefile.am
index d7708cc..ce710c2 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -13,8 +13,12 @@ SUBDIRS = \
 	v4l2-sysfs-path \
 	cec-ctl \
 	cec-compliance \
-	cec-follower \
+	cec-follower
+
+if WITH_LIBV4L
+SUBDIRS += \
 	rds-ctl
+endif
 
 if WITH_LIBDVBV5
 SUBDIRS += \
diff --git a/utils/v4l2-compliance/Makefile.am b/utils/v4l2-compliance/Makefile.am
index 58bad86..0671fda 100644
--- a/utils/v4l2-compliance/Makefile.am
+++ b/utils/v4l2-compliance/Makefile.am
@@ -7,12 +7,16 @@ v4l2_compliance_SOURCES = v4l2-compliance.cpp v4l2-test-debug.cpp v4l2-test-inpu
 	v4l2-test-codecs.cpp v4l2-test-colors.cpp v4l2-compliance.h
 v4l2_compliance_CPPFLAGS = -I$(top_srcdir)/utils/common
 
+if WITH_LIBV4L
 if WITH_V4L2_COMPLIANCE_LIBV4L
 v4l2_compliance_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lrt -lpthread
 else
 v4l2_compliance_LDADD = -lrt -lpthread
 DEFS += -DNO_LIBV4L2
 endif
+else
+DEFS += -DNO_LIBV4L2
+endif
 
 EXTRA_DIST = Android.mk fixme.txt v4l2-compliance.1
 
diff --git a/utils/v4l2-ctl/Makefile.am b/utils/v4l2-ctl/Makefile.am
index 83fa49a..cae4e74 100644
--- a/utils/v4l2-ctl/Makefile.am
+++ b/utils/v4l2-ctl/Makefile.am
@@ -9,11 +9,15 @@ v4l2_ctl_SOURCES = v4l2-ctl.cpp v4l2-ctl.h v4l2-ctl-common.cpp v4l2-ctl-tuner.cp
 	v4l2-tpg-colors.c v4l2-tpg-core.c v4l-stream.c v4l2-ctl-meta.cpp
 v4l2_ctl_CPPFLAGS = -I$(top_srcdir)/utils/common
 
+if WITH_LIBV4L
 if WITH_V4L2_CTL_LIBV4L
 v4l2_ctl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lrt -lpthread
 else
 DEFS += -DNO_LIBV4L2
 endif
+else
+DEFS += -DNO_LIBV4L2
+endif
 
 if !WITH_V4L2_CTL_STREAM_TO
 DEFS += -DNO_STREAM_TO
-- 
1.9.1
