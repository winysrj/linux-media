Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38510 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbeK0U5m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 15:57:42 -0500
Received: by mail-wm1-f66.google.com with SMTP id k198so21568172wmd.3
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2018 02:00:19 -0800 (PST)
From: Fabrice Fontaine <fontaine.fabrice@gmail.com>
To: linux-media@vger.kernel.org
Cc: Fabrice Fontaine <fontaine.fabrice@gmail.com>
Subject: [PATCH v4l-utils] v4l2-compliance needs fork
Date: Tue, 27 Nov 2018 11:00:02 +0100
Message-Id: <20181127100002.12853-1-fontaine.fabrice@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compliance uses fork, since
https://git.linuxtv.org/v4l-utils.git/commit/utils/v4l2-compliance/?id=79d98edd1a27233667a6bc38d3d7f8958c2ec02c

So don't build it if fork is not available

Fixes:
 - http://autobuild.buildroot.org/results/447d792ce21c0e33a36ca9384fee46e099435ed8

Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
---
 configure.ac      | 5 ++++-
 utils/Makefile.am | 6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 5cc34c24..52ea5c6d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -478,7 +478,8 @@ AM_CONDITIONAL([WITH_QTGL],	    [test x${qt_pkgconfig_gl} = xtrue])
 AM_CONDITIONAL([WITH_GCONV],        [test x$enable_gconv = xyes -a x$enable_shared == xyes -a x$with_gconvdir != x -a -f $with_gconvdir/gconv-modules])
 AM_CONDITIONAL([WITH_V4L2_CTL_LIBV4L], [test x${enable_v4l2_ctl_libv4l} != xno])
 AM_CONDITIONAL([WITH_V4L2_CTL_STREAM_TO], [test x${enable_v4l2_ctl_stream_to} != xno])
-AM_CONDITIONAL([WITH_V4L2_COMPLIANCE_LIBV4L], [test x${enable_v4l2_compliance_libv4l} != xno])
+AM_CONDITIONAL([WITH_V4L2_COMPLIANCE], [test x$ac_cv_func_fork = xyes])
+AM_CONDITIONAL([WITH_V4L2_COMPLIANCE_LIBV4L], [test x$ac_cv_func_fork = xyes -a x${enable_v4l2_compliance_libv4l} != xno])
 AM_CONDITIONAL([WITH_BPF],          [test x$enable_bpf != xno -a x$libelf_pkgconfig = xyes -a x$CLANG = xclang])
 
 # append -static to libtool compile and link command to enforce static libs
@@ -509,6 +510,7 @@ AM_COND_IF([WITH_V4L_PLUGINS], [USE_V4L_PLUGINS="yes"
 AM_COND_IF([WITH_V4L_WRAPPERS], [USE_V4L_WRAPPERS="yes"], [USE_V4L_WRAPPERS="no"])
 AM_COND_IF([WITH_GCONV], [USE_GCONV="yes"], [USE_GCONV="no"])
 AM_COND_IF([WITH_V4L2_CTL_LIBV4L], [USE_V4L2_CTL_LIBV4L="yes"], [USE_V4L2_CTL_LIBV4L="no"])
+AM_COND_IF([WITH_V4L2_COMPLIANCE], [USE_V4L2_COMPLIANCE="yes"], [USE_V4L2_COMPLIANCE="no"])
 AM_COND_IF([WITH_V4L2_COMPLIANCE_LIBV4L], [USE_V4L2_COMPLIANCE_LIBV4L="yes"], [USE_V4L2_COMPLIANCE_LIBV4L="no"])
 AM_COND_IF([WITH_BPF],         [USE_BPF="yes"
                                 AC_DEFINE([HAVE_BPF], [1], [BPF IR decoder support enabled])],
@@ -556,6 +558,7 @@ compile time options summary
     qv4l2                      : $USE_QV4L2
     qvidcap                    : $USE_QVIDCAP
     v4l2-ctl uses libv4l       : $USE_V4L2_CTL_LIBV4L
+    v4l2-compliance            : $USE_V4L2_COMPLIANCE
     v4l2-compliance uses libv4l: $USE_V4L2_COMPLIANCE_LIBV4L
     BPF IR Decoders:           : $USE_BPF
 EOF
diff --git a/utils/Makefile.am b/utils/Makefile.am
index 2d507028..9c29926a 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -6,7 +6,6 @@ SUBDIRS = \
 	cx18-ctl \
 	keytable \
 	media-ctl \
-	v4l2-compliance \
 	v4l2-ctl \
 	v4l2-dbg \
 	v4l2-sysfs-path \
@@ -20,6 +19,11 @@ SUBDIRS += \
 	dvb
 endif
 
+if WITH_V4L2_COMPLIANCE
+SUBDIRS += \
+	v4l2-compliance
+endif
+
 if WITH_QV4L2
 SUBDIRS += qv4l2
 endif
-- 
2.17.1
