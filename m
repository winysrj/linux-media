Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67JKVVE029903
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 15:20:31 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m67JKJC6005200
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 15:20:19 -0400
Message-ID: <48726E0C.9050505@hhs.nl>
Date: Mon, 07 Jul 2008 21:27:08 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
Content-Type: multipart/mixed; boundary="------------030308070208000404090605"
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: PATCH: libv4l-0.3.4-sync.patch
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------030308070208000404090605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch syncs mercurial with the 0.3.4 tarbal I've just released, which 
contains the following single (brownpaperbag) fix:
* The mmap64 support in 0.3.3, has caused a bug in libv4l1 when running on
   32 bit systems (who uses those now a days?), this bug caused v4l1
   compatibility to not work at all, this release fixes this

Regards,

Hans



--------------030308070208000404090605
Content-Type: text/x-patch;
 name="libv4l-0.3.4-sync.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libv4l-0.3.4-sync.patch"

Sync mercurial with 0.3.4 release (which contains a single fix):
* The mmap64 support in 0.3.3, has caused a bug in libv4l1 when running on
  32 bit systems (who uses those now a days?), this bug caused v4l1
  compatibility to not work at all, this release fixes this

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r fb3e549faf69 v4l2-apps/lib/libv4l/ChangeLog
--- a/v4l2-apps/lib/libv4l/ChangeLog	Sun Jul 06 14:07:34 2008 +0200
+++ b/v4l2-apps/lib/libv4l/ChangeLog	Mon Jul 07 21:22:23 2008 +0200
@@ -1,3 +1,10 @@
+libv4l-0.3.4 (the brownpaperbag release)
+----------------------------------------
+* The mmap64 support in 0.3.3, has caused a bug in libv4l1 when running on
+  32 bit systems (who uses those now a days?), this bug caused v4l1
+  compatibility to not work at all, this release fixes this
+
+
 libv4l-0.3.3
 ------------
 * Add open64 and mmap64 wrappers to the LD_PRELOAD wrapper libs, so that
diff -r fb3e549faf69 v4l2-apps/lib/libv4l/libv4l1/libv4l1-priv.h
--- a/v4l2-apps/lib/libv4l/libv4l1/libv4l1-priv.h	Sun Jul 06 14:07:34 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l1/libv4l1-priv.h	Mon Jul 07 21:22:23 2008 +0200
@@ -21,6 +21,15 @@
 
 #include <stdio.h>
 #include <pthread.h>
+
+/* On 32 bits archs we always use mmap2, on 64 bits archs there is no mmap2 */
+#ifdef __NR_mmap2
+#define SYS_mmap2 __NR_mmap2
+#define MMAP2_PAGE_SHIFT 12
+#else
+#define SYS_mmap2 SYS_mmap
+#define MMAP2_PAGE_SHIFT 0
+#endif
 
 #define V4L1_MAX_DEVICES 16
 #define V4L1_NO_FRAMES 4
diff -r fb3e549faf69 v4l2-apps/lib/libv4l/libv4l1/libv4l1.c
--- a/v4l2-apps/lib/libv4l/libv4l1/libv4l1.c	Sun Jul 06 14:07:34 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l1/libv4l1.c	Mon Jul 07 21:22:23 2008 +0200
@@ -639,7 +639,7 @@
 	}
 
 	if (devices[index].v4l1_frame_pointer == MAP_FAILED) {
-	  devices[index].v4l1_frame_pointer = (void *)syscall(SYS_mmap, NULL,
+	  devices[index].v4l1_frame_pointer = (void *)syscall(SYS_mmap2, NULL,
 				      (size_t)mbuf->size,
 				      PROT_READ|PROT_WRITE,
 				      MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);

--------------030308070208000404090605
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------030308070208000404090605--
