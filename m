Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:57509 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbbEJKyb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 May 2015 06:54:31 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id A222F25ACC4D
	for <linux-media@vger.kernel.org>; Sun, 10 May 2015 12:54:30 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3ll2Mp2QHrz5vN5
	for <linux-media@vger.kernel.org>; Sun, 10 May 2015 12:54:30 +0200 (CEST)
Date: Sun, 10 May 2015 12:54:18 +0200
From: Felix Janda <felix.janda@posteo.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] Remove dead code behind CONFIG_SYS_WRAPPER
Message-ID: <20150510105418.GA27779@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 lib/libv4lconvert/libv4lsyscall-priv.h | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/lib/libv4lconvert/libv4lsyscall-priv.h b/lib/libv4lconvert/libv4lsyscall-priv.h
index f548fb2..e5f74f3 100644
--- a/lib/libv4lconvert/libv4lsyscall-priv.h
+++ b/lib/libv4lconvert/libv4lsyscall-priv.h
@@ -74,8 +74,6 @@ typedef off_t __off_t;
 #undef SYS_MMAP
 #undef SYS_MUNMAP
 
-#ifndef CONFIG_SYS_WRAPPER
-
 #ifdef SYS_openat
 #define SYS_OPEN(file, oflag, mode) \
 	syscall(SYS_openat, AT_FDCWD, (const char *)(file), (int)(oflag), (mode_t)(mode))
@@ -109,24 +107,4 @@ typedef off_t __off_t;
 #define SYS_MUNMAP(addr, len) \
 	syscall(SYS_munmap, (void *)(addr), (size_t)(len))
 
-#else
-
-int v4lx_open_wrapper(const char *, int, int);
-int v4lx_close_wrapper(int);
-int v4lx_ioctl_wrapper(int, unsigned long, void *);
-int v4lx_read_wrapper(int, void *, size_t);
-int v4lx_write_wrapper(int, const void *, size_t);
-void *v4lx_mmap_wrapper(void *, size_t, int, int, int, off_t);
-int v4lx_munmap_wrapper(void *, size_t);
-
-#define SYS_OPEN(...) v4lx_open_wrapper(__VA_ARGS__)
-#define SYS_CLOSE(...) v4lx_close_wrapper(__VA_ARGS__)
-#define SYS_IOCTL(...) v4lx_ioctl_wrapper(__VA_ARGS__)
-#define SYS_READ(...) v4lx_read_wrapper(__VA_ARGS__)
-#define SYS_WRITE(...) v4lx_write_wrapper(__VA_ARGS__)
-#define SYS_MMAP(...) v4lx_mmap_wrapper(__VA_ARGS__)
-#define SYS_MUNMAP(...) v4lx_munmap_wrapper(__VA_ARGS__)
-
-#endif
-
 #endif /* _LIBV4LSYSCALL_PRIV_H_ */
-- 
2.3.6

