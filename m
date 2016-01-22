Return-path: <linux-media-owner@vger.kernel.org>
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:59158 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbcAVTUR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2016 14:20:17 -0500
Received: from blue.my.domain (77.117.16.202.wireless.dyn.drei.com [77.117.16.202])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: feinerer)
	by mail.logic.tuwien.ac.at (Postfix) with ESMTPSA id CB8A4A77B
	for <linux-media@vger.kernel.org>; Fri, 22 Jan 2016 20:10:59 +0100 (CET)
Received: from localhost (blue.my.domain [local])
	by blue.my.domain (OpenSMTPD) with ESMTPA id d7ff5358
	for <linux-media@vger.kernel.org>;
	Fri, 22 Jan 2016 20:10:55 +0100 (CET)
Date: Fri, 22 Jan 2016 20:10:55 +0100
From: Ingo Feinerer <feinerer@logic.at>
To: linux-media@vger.kernel.org
Subject: libv4l on OpenBSD
Message-ID: <20160122191055.GA25166@blue.my.domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

in OpenBSD we recently updated our videoio.h (= videodev2.h in Linux)
header and also imported libv4l in our ports tree
(https://marc.info/?l=openbsd-ports-cvs&m=145218684026568&w=2).

However, we need a few patches to have it working. As there is already
FreeBSD support in libv4l, I would like to ask you if it would be
possible to add OpenBSD support as well (so that it works out of the
box)? The diffs (on top of https://git.linuxtv.org/v4l-utils.git)
towards this goal are as follows.

Thank you!

Best regards,
Ingo

diff --git a/configure.ac b/configure.ac
index 8bfe83d..91f5185 100644
--- a/configure.ac
+++ b/configure.ac
@@ -142,6 +142,9 @@ case "$host_os" in
   linux*)
     linux_os="yes"
     ;;
+  freebsd*)
+    freebsd_os="yes"
+    ;;
 esac
 
 AM_CONDITIONAL([LINUX_OS], [test x$linux_os = xyes])
@@ -410,7 +413,7 @@ AS_IF([test x$enable_libv4l = xno],   [AC_SUBST([ENFORCE_LIBV4L_STATIC],   ["-st
 
 if test "x$linux_os" = "xyes"; then
   CPPFLAGS="-I\$(top_srcdir)/include $CPPFLAGS"
-else
+elif test "x$freebsd_os" = "xyes"; then
   CPPFLAGS="-I\$(top_srcdir)/contrib/freebsd/include $CPPFLAGS"
 fi
 
diff --git a/lib/include/libv4l1-videodev.h b/lib/include/libv4l1-videodev.h
index b67c929..effe174 100644
--- a/lib/include/libv4l1-videodev.h
+++ b/lib/include/libv4l1-videodev.h
@@ -6,7 +6,7 @@
 #include <linux/ioctl.h>
 #endif
 
-#if defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
+#if defined(__FreeBSD__) || defined(__FreeBSD_kernel__) || defined(__OpenBSD__)
 #include <sys/ioctl.h>
 #endif
 
diff --git a/lib/include/libv4l2rds.h b/lib/include/libv4l2rds.h
index ff1050a..a2c2f4f 100644
--- a/lib/include/libv4l2rds.h
+++ b/lib/include/libv4l2rds.h
@@ -24,7 +24,11 @@
 #include <stdbool.h>
 #include <stdint.h>
 
+#if defined(__OpenBSD__)
+#include <sys/videoio.h>
+#else
 #include <linux/videodev2.h>
+#endif
 
 #ifdef __cplusplus
 extern "C" {
diff --git a/lib/include/libv4lconvert.h b/lib/include/libv4lconvert.h
index d425c51..c6064c5 100644
--- a/lib/include/libv4lconvert.h
+++ b/lib/include/libv4lconvert.h
@@ -28,7 +28,7 @@
 #include <linux/ioctl.h>
 #endif
 
-#if defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
+#if defined(__FreeBSD__) || defined(__FreeBSD_kernel__) || defined(__OpenBSD__)
 #include <sys/time.h>
 #include <sys/types.h>
 #include <sys/ioctl.h>
@@ -36,7 +36,11 @@
 
 /* end broken header workaround includes */
 
+#if defined(__OpenBSD__)
+#include <sys/videoio.h>
+#else
 #include <linux/videodev2.h>
+#endif
 
 #ifdef __cplusplus
 extern "C" {
diff --git a/lib/libv4l-mplane/libv4l-mplane.c b/lib/libv4l-mplane/libv4l-mplane.c
index 99a4d88..2f685a7 100644
--- a/lib/libv4l-mplane/libv4l-mplane.c
+++ b/lib/libv4l-mplane/libv4l-mplane.c
@@ -26,7 +26,12 @@
 #include <unistd.h>
 #include <sys/syscall.h>
 
+#if defined(__OpenBSD__)
+#include <sys/videoio.h>
+#include <sys/ioctl.h>
+#else
 #include <linux/videodev2.h>
+#endif
 
 #include "libv4l-plugin.h"
 
diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
index 5c147b3..dab665b 100644
--- a/lib/libv4l1/libv4l1.c
+++ b/lib/libv4l1/libv4l1.c
@@ -58,7 +58,11 @@
 #include <sys/types.h>
 #include <sys/mman.h>
 #include "../libv4lconvert/libv4lsyscall-priv.h"
+#if defined(__OpenBSD__)
+#include <sys/videoio.h>
+#else
 #include <linux/videodev2.h>
+#endif
 #include <libv4l2.h>
 #include "libv4l1.h"
 #include "libv4l1-priv.h"
diff --git a/lib/libv4l2/log.c b/lib/libv4l2/log.c
index 9d3eab1..d36b2e2 100644
--- a/lib/libv4l2/log.c
+++ b/lib/libv4l2/log.c
@@ -28,7 +28,11 @@
 #include <string.h>
 #include <errno.h>
 #include "../libv4lconvert/libv4lsyscall-priv.h"
+#if defined(__OpenBSD__)
+#include <sys/videoio.h>
+#else
 #include <linux/videodev2.h>
+#endif
 #include "libv4l2.h"
 #include "libv4l2-priv.h"
 
diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
index 3f43c89..7c9a04c 100644
--- a/lib/libv4l2/v4l2convert.c
+++ b/lib/libv4l2/v4l2convert.c
@@ -36,7 +36,11 @@
 #include <string.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
+#if defined(__OpenBSD__)
+#include <sys/videoio.h>
+#else
 #include <linux/videodev2.h>
+#endif
 #include <libv4l2.h>
 #include "../libv4lconvert/libv4lsyscall-priv.h"
 
diff --git a/lib/libv4l2rds/libv4l2rds.c b/lib/libv4l2rds/libv4l2rds.c
index 596cd19..48cc81b 100644
--- a/lib/libv4l2rds/libv4l2rds.c
+++ b/lib/libv4l2rds/libv4l2rds.c
@@ -27,7 +27,11 @@
 #include <sys/types.h>
 #include <sys/mman.h>
 
+#if defined(__OpenBSD__)
+#include <sys/videoio.h>
+#else
 #include <linux/videodev2.h>
+#endif
 
 #include "../include/libv4l2rds.h"
 
diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
index e1832a9..e61c72e 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -35,7 +35,11 @@
 #include "libv4lcontrol.h"
 #include "libv4lcontrol-priv.h"
 #include "../libv4lsyscall-priv.h"
+#if defined(__OpenBSD__)
+#include <sys/videoio.h>
+#else
 #include <linux/videodev2.h>
+#endif
 
 #define ARRAY_SIZE(x) ((int)sizeof(x) / (int)sizeof((x)[0]))
 
diff --git a/lib/libv4lconvert/libv4lsyscall-priv.h b/lib/libv4lconvert/libv4lsyscall-priv.h
index bc18b21..144a212 100644
--- a/lib/libv4lconvert/libv4lsyscall-priv.h
+++ b/lib/libv4lconvert/libv4lsyscall-priv.h
@@ -63,6 +63,15 @@
 #define	MMAP2_PAGE_SHIFT 0
 #endif
 
+#if defined(__OpenBSD__)
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+#define	_IOC_NR(cmd) ((cmd) & 0xFF)
+#define	_IOC_TYPE(cmd) IOCGROUP(cmd)
+#define	MMAP2_PAGE_SHIFT 0
+#endif
+
 #undef SYS_OPEN
 #undef SYS_CLOSE
 #undef SYS_IOCTL
@@ -97,6 +106,11 @@
 #define SYS_MMAP(addr, len, prot, flags, fd, off) \
 	syscall(SYS_mmap, (void *)(addr), (size_t)(len), \
 			(int)(prot), (int)(flags), (int)(fd), (off_t)(off))
+#elif defined(__OpenBSD__)
+register_t __syscall(quad_t, ...);
+#define SYS_MMAP(addr, len, prot, flags, fd, offset) \
+	__syscall((quad_t)SYS_mmap, (void *)(addr), (size_t)(len), \
+			(int)(prot), (int)(flags), (int)(fd), 0, (off_t)(offset))
 #else
 #define SYS_MMAP(addr, len, prot, flags, fd, off) \
 	syscall(SYS_mmap2, (void *)(addr), (size_t)(len), \
diff --git a/lib/libv4lconvert/processing/libv4lprocessing.h b/lib/libv4lconvert/processing/libv4lprocessing.h
index 8d413e1..c6a4adc 100644
--- a/lib/libv4lconvert/processing/libv4lprocessing.h
+++ b/lib/libv4lconvert/processing/libv4lprocessing.h
@@ -22,7 +22,11 @@
 #define __LIBV4LPROCESSING_H
 
 #include "../libv4lsyscall-priv.h"
+#if defined(__OpenBSD__)
+#include <sys/videoio.h>
+#else
 #include <linux/videodev2.h>
+#endif
 
 struct v4lprocessing_data;
 struct v4lcontrol_data;
