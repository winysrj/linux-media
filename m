Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:53060 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932533AbbICPYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2015 11:24:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: gjasny@googlemail.com, Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 1/2] v4l2-ctl/compliance: add configure option to disable libv4l use
Date: Thu,  3 Sep 2015 17:23:15 +0200
Message-Id: <bcfc73c11a7616b8ff18aa058fd12a6f4783756f.1441293195.git.hansverk@cisco.com>
In-Reply-To: <1441293796-16972-1-git-send-email-hverkuil@xs4all.nl>
References: <1441293796-16972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Sometimes you want to compile these two utilities without the libv4l2 wrapper.
This patch adds new configure options to do this:

--disable-v4l2-compliance-libv4l
--disable-v4l2-ctl-libv4l

This is useful when building for an embedded system where you do not want
to use the libv4l2 wrapper library.

The capability to do this was already available, but not hooked up to
the configure system.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 configure.ac                      | 18 ++++++++++++++++++
 utils/v4l2-compliance/Makefile.am |  8 +++++++-
 utils/v4l2-ctl/Makefile.am        |  8 +++++++-
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 53cbc8d..13df263 100644
--- a/configure.ac
+++ b/configure.ac
@@ -359,6 +359,22 @@ AC_ARG_ENABLE(v4l-utils,
    esac]
 )
 
+AC_ARG_ENABLE(v4l2-compliance-libv4l,
+  AS_HELP_STRING([--disable-v4l2-compliance-libv4l], [disable use of libv4l in v4l2-compliance]),
+  [case "${enableval}" in
+     yes | no ) ;;
+     *) AC_MSG_ERROR(bad value ${enableval} for --disable-v4l2-compliance-libv4l) ;;
+   esac]
+)
+
+AC_ARG_ENABLE(v4l2-ctl-libv4l,
+  AS_HELP_STRING([--disable-v4l2-ctl-libv4l], [disable use of libv4l in v4l2-ctl]),
+  [case "${enableval}" in
+     yes | no ) ;;
+     *) AC_MSG_ERROR(bad value ${enableval} for --disable-v4l2-ctl-libv4l) ;;
+   esac]
+)
+
 AC_ARG_ENABLE(qv4l2,
   AS_HELP_STRING([--disable-qv4l2], [disable qv4l2 compilation]),
   [case "${enableval}" in
@@ -383,6 +399,8 @@ AM_CONDITIONAL([WITH_V4L_PLUGINS],  [test x$enable_libv4l != xno -a x$enable_sha
 AM_CONDITIONAL([WITH_V4L_WRAPPERS], [test x$enable_libv4l != xno -a x$enable_shared != xno])
 AM_CONDITIONAL([WITH_QTGL],	    [test ${qt_pkgconfig_gl} = true])
 AM_CONDITIONAL([WITH_GCONV],        [test x${enable_gconv} = xyes])
+AM_CONDITIONAL([WITH_V4L2_CTL_LIBV4L], [test x${enable_v4l2_ctl_libv4l} != xno])
+AM_CONDITIONAL([WITH_V4L2_COMPLIANCE_LIBV4L], [test x${enable_v4l2_compliance_libv4l} != xno])
 
 # append -static to libtool compile and link command to enforce static libs
 AS_IF([test x$enable_libdvbv5 = xno], [AC_SUBST([ENFORCE_LIBDVBV5_STATIC], ["-static"])])
diff --git a/utils/v4l2-compliance/Makefile.am b/utils/v4l2-compliance/Makefile.am
index 3ffc5bd..e7bfc8a 100644
--- a/utils/v4l2-compliance/Makefile.am
+++ b/utils/v4l2-compliance/Makefile.am
@@ -1,10 +1,16 @@
 bin_PROGRAMS = v4l2-compliance
 man_MANS = v4l2-compliance.1
+DEFS :=
 
 v4l2_compliance_SOURCES = v4l2-compliance.cpp v4l2-test-debug.cpp v4l2-test-input-output.cpp \
 	v4l2-test-controls.cpp v4l2-test-io-config.cpp v4l2-test-formats.cpp v4l2-test-buffers.cpp \
 	v4l2-test-codecs.cpp v4l2-test-colors.cpp v4l2-compliance.h cv4l-helpers.h v4l-helpers.h
-v4l2_compliance_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la
 v4l2_compliance_LDFLAGS = -lrt
 
+if WITH_V4L2_COMPLIANCE_LIBV4L
+v4l2_compliance_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la
+else
+DEFS += -DNO_LIBV4L2
+endif
+
 EXTRA_DIST = Android.mk fixme.txt v4l2-compliance.1
diff --git a/utils/v4l2-ctl/Makefile.am b/utils/v4l2-ctl/Makefile.am
index af7111e..932499c 100644
--- a/utils/v4l2-ctl/Makefile.am
+++ b/utils/v4l2-ctl/Makefile.am
@@ -1,12 +1,18 @@
 bin_PROGRAMS = v4l2-ctl
 man_MANS = v4l2-ctl.1
+DEFS :=
 
 v4l2_ctl_SOURCES = v4l2-ctl.cpp v4l2-ctl.h v4l2-ctl-common.cpp v4l2-ctl-tuner.cpp \
 	v4l2-ctl-io.cpp v4l2-ctl-stds.cpp v4l2-ctl-vidcap.cpp v4l2-ctl-vidout.cpp \
 	v4l2-ctl-overlay.cpp v4l2-ctl-vbi.cpp v4l2-ctl-selection.cpp v4l2-ctl-misc.cpp \
 	v4l2-ctl-streaming.cpp v4l2-ctl-sdr.cpp v4l2-ctl-edid.cpp v4l2-ctl-modes.cpp \
 	vivid-tpg-colors.c vivid-tpg.c
-v4l2_ctl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la
 v4l2_ctl_LDFLAGS = -lrt
 
+if WITH_V4L2_CTL_LIBV4L
+v4l2_ctl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la
+else
+DEFS += -DNO_LIBV4L2
+endif
+
 EXTRA_DIST = Android.mk vivid-tpg.h.patch v4l2-ctl.1
-- 
2.1.4

