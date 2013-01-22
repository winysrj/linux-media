Return-path: <linux-media-owner@vger.kernel.org>
Received: from afflict.kos.to ([92.243.29.197]:36706 "EHLO afflict.kos.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab3AVQrs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 11:47:48 -0500
From: Riku Voipio <riku.voipio@linaro.org>
To: linux-media@vger.kernel.org
Cc: Riku Voipio <riku.voipio@linaro.org>
Subject: [PATCH] v4l-utils: use openat when available
Date: Tue, 22 Jan 2013 18:37:22 +0200
Message-Id: <1358872642-30843-1-git-send-email-riku.voipio@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New architectures such as 64-Bit arm build kernels without legacy
system calls - Such as the the no-at system calls. Thus, use
SYS_openat whenever it is available.

Signed-off-by: Riku Voipio <riku.voipio@linaro.org>
---
 lib/libv4lconvert/libv4lsyscall-priv.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/libv4lconvert/libv4lsyscall-priv.h b/lib/libv4lconvert/libv4lsyscall-priv.h
index 2dac49a..cdd38bc 100644
--- a/lib/libv4lconvert/libv4lsyscall-priv.h
+++ b/lib/libv4lconvert/libv4lsyscall-priv.h
@@ -72,8 +72,13 @@ typedef off_t __off_t;
 
 #ifndef CONFIG_SYS_WRAPPER
 
+#ifdef SYS_openat
+#define SYS_OPEN(file, oflag, mode) \
+	syscall(SYS_openat, AT_FDCWD, (const char *)(file), (int)(oflag), (mode_t)(mode))
+#else
 #define SYS_OPEN(file, oflag, mode) \
 	syscall(SYS_open, (const char *)(file), (int)(oflag), (mode_t)(mode))
+#endif
 #define SYS_CLOSE(fd) \
 	syscall(SYS_close, (int)(fd))
 #define SYS_IOCTL(fd, cmd, arg) \
-- 
1.7.10.4

