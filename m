Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:49291 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbbEETCf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 15:02:35 -0400
Date: Tue, 5 May 2015 21:02:23 +0200
From: Felix Janda <felix.janda@posteo.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCHv2 1/4] Use off_t and off64_t instead of __off_t and __off64_t
Message-ID: <20150505190223.GA4948@euler>
References: <20150125203557.GA11999@euler>
 <20150505093657.43acf519@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150505093657.43acf519@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since _LARGEFILE64_SOURCE is 1, these types coincide if defined.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
v2: rebased

Mauro Carvalho Chehab wrote:

Thanks for the review.

> Em Sun, 25 Jan 2015 21:36:15 +0100
> Felix Janda <felix.janda@posteo.de> escreveu:
> 
> > Since _LARGEFILE64_SOURCE is 1, these types coincide if defined.
> 
> The __off_t macro was also added by the FreeBSD patchset. Removing this
> will likely break for FreeBSD.

No. The patchset added a typedef of __off_t to off_t. Why? Because
FreeBSD does not have off_t. By now for a similar reason there is a
similar typedef for android. Generally, names starting with one or two
underscores are implementation specific and not portable. If the source
code did not use __off_t, there would be no need to introduce these
typedefs.

This patch removes all occurences of __off_t and __off64_t in the
source code. 

> So, provided that this is not causing any issues, better to keep it
> as-is.

It produces "error: unknown type name '__off_t'" on musl based linux
systems.

---
 lib/libv4l1/v4l1compat.c               |  5 ++---
 lib/libv4l2/v4l2convert.c              |  5 ++---
 lib/libv4lconvert/libv4lsyscall-priv.h | 11 +++--------
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/lib/libv4l1/v4l1compat.c b/lib/libv4l1/v4l1compat.c
index c641c17..282173b 100644
--- a/lib/libv4l1/v4l1compat.c
+++ b/lib/libv4l1/v4l1compat.c
@@ -116,14 +116,14 @@ LIBV4L_PUBLIC ssize_t read(int fd, void *buffer, size_t n)
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
index 008408e..2c2f12a 100644
@@ -148,14 +148,14 @@ LIBV4L_PUBLIC ssize_t read(int fd, void *buffer, size_t n)
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
2.3.6
