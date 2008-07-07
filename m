Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67LgBWg004698
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 17:42:11 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m67Lfc4a006757
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 17:41:38 -0400
Message-ID: <48728F2C.4000600@hhs.nl>
Date: Mon, 07 Jul 2008 23:48:28 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
Content-Type: multipart/mixed; boundary="------------050105040406020509040005"
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: PATCH: libv4l-really-sync-with-0.3.4.patch
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
--------------050105040406020509040005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch _really_ syncs mercurial with the 0.3.4 tarbal I've just released,
at the last minute I got a bugreport that kopete was not working with the 
wrapper leading to the following changes:

* Some apps (xawtv, kopete) use an ioctl wrapper internally for various
   reasons. This wrappers request argument is an int, but the real ioctl's
   request argument is an unsigned long. Passing the VIDIOC_xxx defines through
   to the wrapper, and then to the real ioctl, causes the request to get sign
   extended on 64 bit args. The kernel seems to ignore the upper 32 bits,
   causing the sign extension to not make a difference. libv4l now also
   ignores the upper 32 bits of the libv4lx_ioctl request argument on 64 bit
   archs
* Add a bugfix patch for kopete in the appl-patches dir, currently it assumes
   that it got the width and height it asked for when doing a S_FMT, which is a
   wrong assumption

Note that this applies on top of my previous 0.3.4 sync patch, and note that it 
adds a file under appl-patches !

Thanks & Regards,

Hans




--------------050105040406020509040005
Content-Type: text/x-patch;
 name="libv4l-really-sync-with-0.3.4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libv4l-really-sync-with-0.3.4.patch"

diff -r b727e145976f v4l2-apps/lib/libv4l/ChangeLog
--- a/v4l2-apps/lib/libv4l/ChangeLog	Mon Jul 07 23:35:40 2008 +0200
+++ b/v4l2-apps/lib/libv4l/ChangeLog	Mon Jul 07 23:37:40 2008 +0200
@@ -3,6 +3,17 @@
 * The mmap64 support in 0.3.3, has caused a bug in libv4l1 when running on
   32 bit systems (who uses those now a days?), this bug caused v4l1
   compatibility to not work at all, this release fixes this
+* Some apps (xawtv, kopete) use an ioctl wrapper internally for various
+  reasons. This wrappers request argument is an int, but the real ioctl's
+  request argument is an unsigned long. Passing the VIDIOC_xxx defines through
+  to the wrapper, and then to the real ioctl, causes the request to get sign
+  extended on 64 bit args. The kernel seems to ignore the upper 32 bits,
+  causing the sign extension to not make a difference. libv4l now also
+  ignores the upper 32 bits of the libv4lx_ioctl request argument on 64 bit
+  archs
+* Add a bugfix patch for kopete in the appl-patches dir, currently it assumes
+  that it got the width and height it asked for when doing a S_FMT, which is a
+  wrong assumption
 
 
 libv4l-0.3.3
diff -r b727e145976f v4l2-apps/lib/libv4l/appl-patches/kdenetwork-4.0.85-kopete.patch
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/v4l2-apps/lib/libv4l/appl-patches/kdenetwork-4.0.85-kopete.patch	Mon Jul 07 23:37:40 2008 +0200
@@ -0,0 +1,12 @@
+diff -up kdenetwork-4.0.85/kopete/libkopete/avdevice/videodevice.cpp~ kdenetwork-4.0.85/kopete/libkopete/avdevice/videodevice.cpp
+--- kdenetwork-4.0.85/kopete/libkopete/avdevice/videodevice.cpp~	2008-07-07 22:40:56.000000000 +0200
++++ kdenetwork-4.0.85/kopete/libkopete/avdevice/videodevice.cpp	2008-07-07 22:40:56.000000000 +0200
+@@ -679,6 +679,8 @@ kDebug() << "VIDIOC_S_FMT worked (" << e
+ 					if (fmt.fmt.pix.sizeimage < min)
+ 						fmt.fmt.pix.sizeimage = min;
+ 					m_buffer_size=fmt.fmt.pix.sizeimage ;
++					currentwidth = fmt.fmt.pix.width;
++					currentheight = fmt.fmt.pix.height;
+ 				}
+ 				break;
+ #endif
diff -r b727e145976f v4l2-apps/lib/libv4l/libv4l1/libv4l1.c
--- a/v4l2-apps/lib/libv4l/libv4l1/libv4l1.c	Mon Jul 07 23:35:40 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l1/libv4l1.c	Mon Jul 07 23:37:40 2008 +0200
@@ -453,6 +453,11 @@
 
   if ((index = v4l1_get_index(fd)) == -1)
     return syscall(SYS_ioctl, fd, request, arg);
+
+  /* Appearantly the kernel and / or glibc ignore the 32 most significant bits
+     when long = 64 bits, and some applications pass an int holding the req to
+     ioctl, causing it to get sign extended, depending upon this behavior */
+  request = (unsigned int)request;
 
   /* do we need to take the stream lock for this ioctl? */
   switch (request) {
diff -r b727e145976f v4l2-apps/lib/libv4l/libv4l2/libv4l2.c
--- a/v4l2-apps/lib/libv4l/libv4l2/libv4l2.c	Mon Jul 07 23:35:40 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l2/libv4l2.c	Mon Jul 07 23:37:40 2008 +0200
@@ -541,6 +541,11 @@
   if ((index = v4l2_get_index(fd)) == -1)
     return syscall(SYS_ioctl, fd, request, arg);
 
+  /* Appearantly the kernel and / or glibc ignore the 32 most significant bits
+     when long = 64 bits, and some applications pass an int holding the req to
+     ioctl, causing it to get sign extended, depending upon this behavior */
+  request = (unsigned int)request;
+
   /* Is this a capture request and do we need to take the stream lock? */
   switch (request) {
     case VIDIOC_ENUM_FMT:

--------------050105040406020509040005
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------050105040406020509040005--
