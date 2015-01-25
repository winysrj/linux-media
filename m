Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:39267 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbbAYUhq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2015 15:37:46 -0500
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 39B1025B8E02
	for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 21:37:45 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3kVmHF0Y9sz5vNB
	for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 21:37:45 +0100 (CET)
Date: Sun, 25 Jan 2015 21:36:25 +0100
From: Felix Janda <felix.janda@posteo.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] Test for ioctl() function signature
Message-ID: <20150125203625.GB11999@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On glibc, ioctl has the signature ioctl(int, unsigned long int, ...).
On musl, libc and according to POSIX it is ioctl(int, int, ...).
Add a configure test adapted from gnulib's ioctl.m4 to make the
DL_PRELOAD libraries work for both signatures.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 configure.ac              | 12 ++++++++++++
 lib/libv4l1/v4l1compat.c  |  4 ++++
 lib/libv4l2/v4l2convert.c |  4 ++++
 3 files changed, 20 insertions(+)

diff --git a/configure.ac b/configure.ac
index 4156559..00136d7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -116,6 +116,18 @@ gl_VISIBILITY
 AC_CHECK_HEADERS([sys/klog.h])
 AC_CHECK_FUNCS([klogctl])
 
+AC_CACHE_CHECK([for ioctl with POSIX signature],
+  [gl_cv_func_ioctl_posix_signature],
+  [AC_COMPILE_IFELSE(
+     [AC_LANG_PROGRAM(
+        [[#include <sys/ioctl.h>]],
+        [[int ioctl (int, int, ...);]])
+     ],
+     [gl_cv_func_ioctl_posix_signature=yes],
+     [gl_cv_func_ioctl_posix_signature=no])
+  ])
+AC_DEFINE([HAVE_POSIX_IOCTL], [1], [test x$gl_cv_func_ioctl_posix_signature = xyes])
+
 AC_CHECK_FUNCS([__secure_getenv secure_getenv])
 
 # Check host os
diff --git a/lib/libv4l1/v4l1compat.c b/lib/libv4l1/v4l1compat.c
index 07240c1..282173b 100644
--- a/lib/libv4l1/v4l1compat.c
+++ b/lib/libv4l1/v4l1compat.c
@@ -93,7 +93,11 @@ LIBV4L_PUBLIC int dup(int fd)
 	return v4l1_dup(fd);
 }
 
+#ifdef HAVE_POSIX_IOCTL
+LIBV4L_PUBLIC int ioctl(int fd, int request, ...)
+#else
 LIBV4L_PUBLIC int ioctl(int fd, unsigned long int request, ...)
+#endif
 {
 	void *arg;
 	va_list ap;
diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
index b65da5e..c79f9da 100644
--- a/lib/libv4l2/v4l2convert.c
+++ b/lib/libv4l2/v4l2convert.c
@@ -121,7 +121,11 @@ LIBV4L_PUBLIC int dup(int fd)
 	return v4l2_dup(fd);
 }
 
+#ifdef HAVE_POSIX_IOCTL
+LIBV4L_PUBLIC int ioctl(int fd, int request, ...)
+#else
 LIBV4L_PUBLIC int ioctl(int fd, unsigned long int request, ...)
+#endif
 {
 	void *arg;
 	va_list ap;
-- 
2.0.5

