Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:33056 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbbEJK5v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 May 2015 06:57:51 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 6FF9B25ACC4C
	for <linux-media@vger.kernel.org>; Sun, 10 May 2015 12:57:50 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3ll2Rf1wrSz5vND
	for <linux-media@vger.kernel.org>; Sun, 10 May 2015 12:57:50 +0200 (CEST)
Date: Sun, 10 May 2015 12:57:38 +0200
From: Felix Janda <felix.janda@posteo.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] Globally enable LARGEFILE support
Message-ID: <20150510105738.GB27779@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use AC_SYS_LARGEFILE so that off_t is 64 bit on all systems in all
files. This also makes the O_LARGEFILE flag unecessary.

For the LD_PRELOAD libraries we need to be careful on linux with
glibc to wrap both mmap/mmap64 and open/open64 correctly. We use
the internal types __off_t and __off64_t to get the correct type
for use in mmap/mmap64 independent of _FILE_OFFSET_BITS definition.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
Actually all files should have <config.h> before the other includes
to take advantage.
---
 configure.ac              |  2 ++
 lib/libv4l1/v4l1compat.c  | 23 +++++++++++++++--------
 lib/libv4l2/v4l2convert.c | 23 +++++++++++++++--------
 utils/dvb/dvbv5-zap.c     |  9 +--------
 4 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/configure.ac b/configure.ac
index 79c1cfc..5435e6a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -118,6 +118,8 @@ gl_VISIBILITY
 AC_CHECK_HEADERS([sys/klog.h])
 AC_CHECK_FUNCS([klogctl])
 
+AC_SYS_LARGEFILE
+
 AC_CACHE_CHECK([for ioctl with POSIX signature],
   [gl_cv_func_ioctl_posix_signature],
   [AC_COMPILE_IFELSE(
diff --git a/lib/libv4l1/v4l1compat.c b/lib/libv4l1/v4l1compat.c
index 393896c..7ee59d9 100644
--- a/lib/libv4l1/v4l1compat.c
+++ b/lib/libv4l1/v4l1compat.c
@@ -19,8 +19,6 @@
 # Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA  02110-1335  USA
  */
 
-#define _LARGEFILE64_SOURCE 1
-
 #include <config.h>
 #include <stdlib.h>
 #include <stdarg.h>
@@ -42,7 +40,11 @@
 #define LIBV4L_PUBLIC
 #endif
 
+#if defined(linux) && defined(__GLIBC__)
+LIBV4L_PUBLIC int open64(const char *file, int oflag, ...)
+#else
 LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
+#endif
 {
 	int fd;
 
@@ -63,7 +65,7 @@ LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
 }
 
 #if defined(linux) && defined(__GLIBC__)
-LIBV4L_PUBLIC int open64(const char *file, int oflag, ...)
+LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
 {
 	int fd;
 
@@ -74,11 +76,11 @@ LIBV4L_PUBLIC int open64(const char *file, int oflag, ...)
 		va_start(ap, oflag);
 		mode = va_arg(ap, mode_t);
 
-		fd = v4l1_open(file, oflag | O_LARGEFILE, mode);
+		fd = v4l1_open(file, oflag, mode);
 
 		va_end(ap);
 	} else
-		fd = v4l1_open(file, oflag | O_LARGEFILE);
+		fd = v4l1_open(file, oflag);
 
 	return fd;
 }
@@ -115,15 +117,20 @@ LIBV4L_PUBLIC ssize_t read(int fd, void *buffer, size_t n)
 	return v4l1_read(fd, buffer, n);
 }
 
+#if defined(linux) && defined(__GLIBC__)
+LIBV4L_PUBLIC void *mmap64(void *start, size_t length, int prot, int flags, int fd,
+		__off64_t offset)
+#else
 LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd,
-		__off_t offset)
+		off_t offset)
+#endif
 {
 	return v4l1_mmap(start, length, prot, flags, fd, offset);
 }
 
 #if defined(linux) && defined(__GLIBC__)
-LIBV4L_PUBLIC void *mmap64(void *start, size_t length, int prot, int flags, int fd,
-		__off64_t offset)
+LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd,
+		__off_t offset)
 {
 	return v4l1_mmap(start, length, prot, flags, fd, offset);
 }
diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
index 0384c13..e2272a2 100644
--- a/lib/libv4l2/v4l2convert.c
+++ b/lib/libv4l2/v4l2convert.c
@@ -23,8 +23,6 @@
 /* prevent GCC 4.7 inlining error */
 #undef _FORTIFY_SOURCE
 
-#define _LARGEFILE64_SOURCE 1
-
 #ifdef ANDROID
 #include <android-config.h>
 #else
@@ -51,7 +49,11 @@
 #define LIBV4L_PUBLIC
 #endif
 
+#if defined(linux) && defined(__GLIBC__)
+LIBV4L_PUBLIC int open64(const char *file, int oflag, ...)
+#else
 LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
+#endif
 {
 	int fd;
 	int v4l_device = 0;
@@ -91,7 +93,7 @@ LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
 }
 
 #if defined(linux) && defined(__GLIBC__)
-LIBV4L_PUBLIC int open64(const char *file, int oflag, ...)
+LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
 {
 	int fd;
 
@@ -103,11 +105,11 @@ LIBV4L_PUBLIC int open64(const char *file, int oflag, ...)
 		va_start(ap, oflag);
 		mode = va_arg(ap, PROMOTED_MODE_T);
 
-		fd = open(file, oflag | O_LARGEFILE, mode);
+		fd = open64(file, oflag, mode);
 
 		va_end(ap);
 	} else {
-		fd = open(file, oflag | O_LARGEFILE);
+		fd = open64(file, oflag);
 	}
 	/* end of original open code */
 
@@ -147,15 +149,20 @@ LIBV4L_PUBLIC ssize_t read(int fd, void *buffer, size_t n)
 	return v4l2_read(fd, buffer, n);
 }
 
+#if defined(linux) && defined(__GLIBC__)
+LIBV4L_PUBLIC void *mmap64(void *start, size_t length, int prot, int flags, int fd,
+		__off64_t offset)
+#else
 LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd,
-		__off_t offset)
+		off_t offset)
+#endif
 {
 	return v4l2_mmap(start, length, prot, flags, fd, offset);
 }
 
 #if defined(linux) && defined(__GLIBC__)
-LIBV4L_PUBLIC void *mmap64(void *start, size_t length, int prot, int flags, int fd,
-		__off64_t offset)
+LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd,
+		__off_t offset)
 {
 	return v4l2_mmap(start, length, prot, flags, fd, offset);
 }
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index c036d15..9fd0798 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -20,9 +20,7 @@
  *	Bernard Hatt 24/2/04
  */
 
-#define _FILE_OFFSET_BITS 64
-#define _LARGEFILE_SOURCE 1
-#define _LARGEFILE64_SOURCE 1
+#include <config.h>
 
 #include <unistd.h>
 #include <stdlib.h>
@@ -34,8 +32,6 @@
 #include <argp.h>
 #include <sys/time.h>
 
-#include <config.h>
-
 #ifdef ENABLE_NLS
 # define _(string) gettext(string)
 # include "gettext.h"
@@ -976,9 +972,6 @@ int main(int argc, char **argv)
 
 			if (strcmp(args.filename, "-") != 0) {
 				file_fd = open(args.filename,
-#ifdef O_LARGEFILE
-					 O_LARGEFILE |
-#endif
 					 O_WRONLY | O_CREAT,
 					 0644);
 				if (file_fd < 0) {
-- 
2.3.6

