Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:49318 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbbEETCg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 15:02:36 -0400
Date: Tue, 5 May 2015 21:02:25 +0200
From: Felix Janda <felix.janda@posteo.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCHv2 2/4] Test for ioctl() function signature
Message-ID: <20150505190225.GA17531@euler>
References: <20150125203625.GB11999@euler>
 <20150505090549.22d51930@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150505090549.22d51930@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On glibc, ioctl has the signature ioctl(int, unsigned long int, ...).
On musl, libc and according to POSIX it is ioctl(int, int, ...).
Add a configure test adapted from gnulib's ioctl.m4 to make the
DL_PRELOAD libraries work for both signatures.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
v2: Fix declaration of HAVE_POSIX_IOCTL

Mauro Carvalho Chehab wrote:
> Em Sun, 25 Jan 2015 21:36:25 +0100
> Felix Janda <felix.janda@posteo.de> escreveu:
> 
> > On glibc, ioctl has the signature ioctl(int, unsigned long int, ...).
> > On musl, libc and according to POSIX it is ioctl(int, int, ...).
> > Add a configure test adapted from gnulib's ioctl.m4 to make the
> > DL_PRELOAD libraries work for both signatures.
> 
> 
> This patch breaks compilation on Fedora:
> 
> v4l2convert.c:130:45: error: conflicting types for 'ioctl'
>  LIBV4L_PUBLIC int ioctl(int fd, int request, ...)
>                                              ^
> In file included from v4l2convert.c:37:0:
> /usr/include/sys/ioctl.h:41:12: note: previous declaration of 'ioctl' was here
>  extern int ioctl (int __fd, unsigned long int __request, ...) __THROW;
>             ^

Sorry for the bad patch.
./configure will have correctly identified in your case that ioctl does
not have the POSIX signature, but by my mistake it still put

#define HAVE_POSIX_IOCTL 1

into config.h. Should be fixed with this patch.

---
 configure.ac              | 14 ++++++++++++++
 lib/libv4l1/v4l1compat.c  |  4 ++++
 lib/libv4l2/v4l2convert.c |  4 ++++
 3 files changed, 22 insertions(+)

diff --git a/configure.ac b/configure.ac
index 330479c..79c1cfc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -118,6 +118,20 @@ gl_VISIBILITY
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
+if test "x$gl_cv_func_ioctl_posix_signature" = xyes; then
+  AC_DEFINE([HAVE_POSIX_IOCTL], [1], [Have ioctl with POSIX signature])
+fi
+
 AC_CHECK_FUNCS([__secure_getenv secure_getenv])
 
 # Check host os
diff --git a/lib/libv4l1/v4l1compat.c b/lib/libv4l1/v4l1compat.c
index e328288..c641c17 100644
--- a/lib/libv4l1/v4l1compat.c
+++ b/lib/libv4l1/v4l1compat.c
@@ -94,7 +94,11 @@ LIBV4L_PUBLIC int dup(int fd)
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
index d046834..008408e 100644
--- a/lib/libv4l2/v4l2convert.c
+++ b/lib/libv4l2/v4l2convert.c
@@ -126,7 +126,11 @@ LIBV4L_PUBLIC int dup(int fd)
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
2.3.6
