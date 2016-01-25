Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49118 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030AbcAYMnK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 07:43:10 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 2/2] Fix configure script errors
Date: Mon, 25 Jan 2016 14:41:24 +0200
Message-Id: <1453725684-4561-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1453725684-4561-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1453725684-4561-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the the QT library is disabled, $qt_pkgconfig_gl will not be set,
leading to an error in the configure script:

./configure: line 21721: test: =: unary operator expected

Fix this. Also do the same for $qt_pkgconfig.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 configure.ac | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 8bfe83d..0fbf981 100644
--- a/configure.ac
+++ b/configure.ac
@@ -394,10 +394,10 @@ AC_ARG_ENABLE(gconv,
 AM_CONDITIONAL([WITH_LIBDVBV5],     [test x$enable_libdvbv5  != xno])
 AM_CONDITIONAL([WITH_LIBV4L],       [test x$enable_libv4l    != xno])
 AM_CONDITIONAL([WITH_V4LUTILS],	    [test x$enable_v4l_utils != xno -a x$linux_os = xyes])
-AM_CONDITIONAL([WITH_QV4L2],	    [test ${qt_pkgconfig}  = true -a x$enable_qv4l2 != xno])
+AM_CONDITIONAL([WITH_QV4L2],	    [test x${qt_pkgconfig} = xtrue -a x$enable_qv4l2 != xno])
 AM_CONDITIONAL([WITH_V4L_PLUGINS],  [test x$enable_libv4l != xno -a x$enable_shared != xno])
 AM_CONDITIONAL([WITH_V4L_WRAPPERS], [test x$enable_libv4l != xno -a x$enable_shared != xno])
-AM_CONDITIONAL([WITH_QTGL],	    [test ${qt_pkgconfig_gl} = true])
+AM_CONDITIONAL([WITH_QTGL],	    [test x${qt_pkgconfig_gl} = xtrue])
 AM_CONDITIONAL([WITH_GCONV],        [test x${enable_gconv} = xyes])
 AM_CONDITIONAL([WITH_V4L2_CTL_LIBV4L], [test x${enable_v4l2_ctl_libv4l} != xno])
 AM_CONDITIONAL([WITH_V4L2_COMPLIANCE_LIBV4L], [test x${enable_v4l2_compliance_libv4l} != xno])
-- 
2.1.0.231.g7484e3b

