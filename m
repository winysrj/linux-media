Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:44590 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756053AbbKCU6t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 15:58:49 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [v4l-utils 4/5] libv4lsyscall-priv.h: Only define SYS_mmap2 if needed
Date: Tue,  3 Nov 2015 21:58:39 +0100
Message-Id: <1446584320-25016-5-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic in libv4lsyscall-priv.h unconditionally defines SYS_mmap2 on
Linux systems, but with current versions of C libraries, SYS_mmap2 is
already defined, and therefore this additional definition causes some
build warnings:

In file included from processing/libv4lprocessing.h:24:0,
                 from libv4lconvert-priv.h:37,
                 from tinyjpeg.c:42:
processing/../libv4lsyscall-priv.h:44:0: warning: "SYS_mmap2" redefined
 #define SYS_mmap2 __NR_mmap2
 ^
In file included from .../sysroot/usr/include/sys/syscall.h:4:0,
                 from processing/../libv4lsyscall-priv.h:39,
                 from processing/libv4lprocessing.h:24,
                 from libv4lconvert-priv.h:37,
                 from tinyjpeg.c:42:
.../sysroot/usr/include/bits/syscall.h:504:0: note: this is the location of the previous definition
 #define SYS_mmap2 192

This commit fixes that by only defining SYS_mmap2 if not already
defined.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 lib/libv4lconvert/libv4lsyscall-priv.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/libv4lconvert/libv4lsyscall-priv.h b/lib/libv4lconvert/libv4lsyscall-priv.h
index f87eff4..bc18b21 100644
--- a/lib/libv4lconvert/libv4lsyscall-priv.h
+++ b/lib/libv4lconvert/libv4lsyscall-priv.h
@@ -41,7 +41,9 @@
 #include <linux/ioctl.h>
 /* On 32 bits archs we always use mmap2, on 64 bits archs there is no mmap2 */
 #ifdef __NR_mmap2
+#if !defined(SYS_mmap2)
 #define	SYS_mmap2 __NR_mmap2
+#endif
 #define	MMAP2_PAGE_SHIFT 12
 #else
 #define	SYS_mmap2 SYS_mmap
-- 
2.6.2

