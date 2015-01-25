Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:39153 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbbAYUhg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2015 15:37:36 -0500
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 231A225B8E02
	for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 21:37:34 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3kVmH25mXGz5vMp
	for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 21:37:34 +0100 (CET)
Date: Sun, 25 Jan 2015 21:36:15 +0100
From: Felix Janda <felix.janda@posteo.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] Use off_t and off64_t instead of __off_t and __off64_t
Message-ID: <20150125203557.GA11999@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since _LARGEFILE64_SOURCE is 1, these types coincide if defined.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 lib/libv4l1/v4l1compat.c               | 5 ++---
 lib/libv4l2/v4l2convert.c              | 4 ++--
 lib/libv4lconvert/libv4lsyscall-priv.h | 7 +++----
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/lib/libv4l1/v4l1compat.c b/lib/libv4l1/v4l1compat.c
index e328288..07240c1 100644
--- a/lib/libv4l1/v4l1compat.c
+++ b/lib/libv4l1/v4l1compat.c
@@ -26,7 +26,6 @@
 #include <stdarg.h>
 #include <fcntl.h>
 #include <libv4l1.h>
-#include "../libv4lconvert/libv4lsyscall-priv.h" /* for __off_t */
 
 #include <sys/ioctl.h>
 #include <sys/mman.h>
@@ -112,14 +111,14 @@ LIBV4L_PUBLIC ssize_t read(int fd, void *buffer, size_t n)
 }
 
 LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd,
-		__off_t offset)
+		off_t offset)
 {
 	return v4l1_mmap(start, length, prot, flags, fd, offset);
 }
 
 #ifdef linux
 LIBV4L_PUBLIC void *mmap64(void *start, size_t length, int prot, int flags, int fd,
-		__off64_t offset)
+		off64_t offset)
 {
 	return v4l1_mmap(start, length, prot, flags, fd, offset);
 }
diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
index 9b46ab8..b65da5e 100644
--- a/lib/libv4l2/v4l2convert.c
+++ b/lib/libv4l2/v4l2convert.c
@@ -139,14 +139,14 @@ LIBV4L_PUBLIC ssize_t read(int fd, void *buffer, size_t n)
 }
 
 LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd,
-		__off_t offset)
+		off_t offset)
 {
 	return v4l2_mmap(start, length, prot, flags, fd, offset);
 }
 
 #ifdef linux
 LIBV4L_PUBLIC void *mmap64(void *start, size_t length, int prot, int flags, int fd,
-		__off64_t offset)
+		off64_t offset)
 {
 	return v4l2_mmap(start, length, prot, flags, fd, offset);
 }
diff --git a/lib/libv4lconvert/libv4lsyscall-priv.h b/lib/libv4lconvert/libv4lsyscall-priv.h
index cdd38bc..ce89073 100644
--- a/lib/libv4lconvert/libv4lsyscall-priv.h
+++ b/lib/libv4lconvert/libv4lsyscall-priv.h
@@ -59,7 +59,6 @@
 #define	_IOC_SIZE(cmd) IOCPARM_LEN(cmd)
 #define	MAP_ANONYMOUS MAP_ANON
 #define	MMAP2_PAGE_SHIFT 0
-typedef off_t __off_t;
 #endif
 
 #undef SYS_OPEN
@@ -91,15 +90,15 @@ typedef off_t __off_t;
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
2.0.5

