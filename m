Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m64BLS7H013379
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 07:21:28 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m64BLFfY019173
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 07:21:15 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KEjLm-0006ea-IN
	for video4linux-list@redhat.com; Fri, 04 Jul 2008 13:21:14 +0200
Message-ID: <486E0786.9050807@hhs.nl>
Date: Fri, 04 Jul 2008 13:20:38 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
Content-Type: multipart/mixed; boundary="------------000706090204030503080505"
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: PATCH: libv4l-update-documentation.patch
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
--------------000706090204030503080505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Some documentation updates to bring the documentation up2date with the latest
changes.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans


--------------000706090204030503080505
Content-Type: text/plain;
 name="libv4l-update-docs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libv4l-update-docs.patch"

Some documentation updates to bring the documentation up2date with the latest
changes.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 5a184775625e v4l2-apps/lib/libv4l/INSTALL
--- a/v4l2-apps/lib/libv4l/INSTALL	Fri Jul 04 13:09:05 2008 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-To compile simply type "make" after that you can find the compiled libraries
-and wrappers under the lib dir, public headers are under the include dir.
-
-Sorry no make install target for now.
diff -r 5a184775625e v4l2-apps/lib/libv4l/README
--- a/v4l2-apps/lib/libv4l/README	Fri Jul 04 13:09:05 2008 +0200
+++ b/v4l2-apps/lib/libv4l/README	Fri Jul 04 13:18:59 2008 +0200
@@ -62,10 +62,18 @@
 applications is called v4l1compat.so. The preloadable libv4l1 wrapper which
 adds v4l2 device compatibility to v4l1 applications is called v4l2convert.so
 
-Example usage:
-$ export LD_LIBRARY_PATH=`pwd`/lib
-$ export LD_PRELOAD=`pwd`/lib/v4l1compat.so
+Example usage (after install in default location):
+$ export LD_PRELOAD=/usr/local/lib/v4l1compat.so
 $ camorama
+
+
+Installation Instructions
+-------------------------
+
+Simple type the following commands from the libv4l-x.y.z directory
+(adjusting DESTDIR as desired):
+make
+make install DESTDIR=/usr/local
 
 
 FAQ
diff -r 5a184775625e v4l2-apps/lib/libv4l/TODO
--- a/v4l2-apps/lib/libv4l/TODO	Fri Jul 04 13:09:05 2008 +0200
+++ b/v4l2-apps/lib/libv4l/TODO	Fri Jul 04 13:18:59 2008 +0200
@@ -1,11 +1,3 @@
--protect open() against being called from different threads simultaniously,
- we are then thread safe except for the jpeg decompression under the following
- assumption:
- * We assume all device setup (for a single device) is done from a single
-   thread
- * We assume that at the time an videodev fd gets closed all other threads
-   which may have been using it have stopped using it.
-
 -add support for setting / getting the number of read buffers
 
 -add code to v4l2_read to not return frames more then say 5 seconds old
@@ -15,12 +7,6 @@
  impossible for overlays) can be done, so that it will no longer be
  necessary to implement CGMBUF in the kernel for each driver.
 
--add (configurable) support for alsa faking enum_fmt to libv4l2 ?
-
 -check v4l2_field during conversion
 
--add make install target
-
 -add conversion from bgr24 to yuv420
-
--add v4l2_dup, make re-entrant safe (for gstreamer v4l2 support)

--------------000706090204030503080505
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------000706090204030503080505--
