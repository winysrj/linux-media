Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:44588 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756008AbbKCU6q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 15:58:46 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [v4l-utils 1/5] libv4lsyscall-priv.h: Use off_t instead of __off_t
Date: Tue,  3 Nov 2015 21:58:36 +0100
Message-Id: <1446584320-25016-2-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

__off_t is a kernel internal symbol, which happens to be user-visible
with glibc, but not necessarily with other C libraries such as
musl. In v4l-utils code, it's mainly used for the mmap() prototype,
but the mmap() manpage really uses off_t, not __off_t.

Switching from __off_t to off_t allows the code to build properly with
musl.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 lib/libv4l1/v4l1compat.c               |  3 +--
 lib/libv4l2/v4l2convert.c              |  5 ++---
 lib/libv4lconvert/libv4lsyscall-priv.h | 11 +++--------
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/lib/libv4l1/v4l1compat.c b/lib/libv4l1/v4l1compat.c
index 393896c..cb79629 100644
--- a/lib/libv4l1/v4l1compat.c
+++ b/lib/libv4l1/v4l1compat.c
@@ -26,7 +26,6 @@
 #include <stdarg.h>
 #include <fcntl.h>
 #include <libv4l1.h>
-#include "../libv4lconvert/libv4lsyscall-priv.h" /* for __off_t */
 
 #include <sys/ioctl.h>
 #include <sys/mman.h>
@@ -116,7 +115,7 @@ LIBV4L_PUBLIC ssize_t read(int fd, void *buffer, size_t n)
 }
 
 LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd,
-		__off_t offset)
+		off_t offset)
 {
 	return v4l1_mmap(start, length, prot, flags, fd, offset);
 }
diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
index 0384c13..6abccbf 100644
--- a/lib/libv4l2/v4l2convert.c
+++ b/lib/libv4l2/v4l2convert.c
@@ -36,7 +36,6 @@
 #include <string.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
-#include "../libv4lconvert/libv4lsyscall-priv.h"
 #include <linux/videodev2.h>
 #include <libv4l2.h>
 
@@ -148,14 +147,14 @@ LIBV4L_PUBLIC ssize_t read(int fd, void *buffer, size_t n)
 }
 
 LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd,
-		__off_t offset)
+		off_t offset)
 {
 	return v4l2_mmap(start, length, prot, flags, fd, offset);
 }
 
 #if defined(linux) && defined(__GLIBC__)
 LIBV4L_PUBLIC void *mmap64(void *start, size_t length, int prot, int flags, int fd,
-		__off64_t offset)
+		off64_t offset)
 {
 	return v4l2_mmap(start, length, prot, flags, fd, offset);
 }
diff --git a/lib/libv4lconvert/libv4lsyscall-priv.h b/lib/libv4lconvert/libv4lsyscall-priv.h
index f548fb2..f87eff4 100644
--- a/lib/libv4lconvert/libv4lsyscall-priv.h
+++ b/lib/libv4lconvert/libv4lsyscall-priv.h
@@ -59,11 +59,6 @@
 #define	_IOC_SIZE(cmd) IOCPARM_LEN(cmd)
 #define	MAP_ANONYMOUS MAP_ANON
 #define	MMAP2_PAGE_SHIFT 0
-typedef off_t __off_t;
-#endif
-
-#if defined(ANDROID)
-typedef off_t __off_t;
 #endif
 
 #undef SYS_OPEN
@@ -95,15 +90,15 @@ typedef off_t __off_t;
 #if defined(__FreeBSD__)
 #define SYS_MMAP(addr, len, prot, flags, fd, off) \
 	__syscall(SYS_mmap, (void *)(addr), (size_t)(len), \
-			(int)(prot), (int)(flags), (int)(fd), (__off_t)(off))
+			(int)(prot), (int)(flags), (int)(fd), (off_t)(off))
 #elif defined(__FreeBSD_kernel__)
 #define SYS_MMAP(addr, len, prot, flags, fd, off) \
 	syscall(SYS_mmap, (void *)(addr), (size_t)(len), \
-			(int)(prot), (int)(flags), (int)(fd), (__off_t)(off))
+			(int)(prot), (int)(flags), (int)(fd), (off_t)(off))
 #else
 #define SYS_MMAP(addr, len, prot, flags, fd, off) \
 	syscall(SYS_mmap2, (void *)(addr), (size_t)(len), \
-			(int)(prot), (int)(flags), (int)(fd), (__off_t)((off) >> MMAP2_PAGE_SHIFT))
+			(int)(prot), (int)(flags), (int)(fd), (off_t)((off) >> MMAP2_PAGE_SHIFT))
 #endif
 
 #define SYS_MUNMAP(addr, len) \
-- 
2.6.2

