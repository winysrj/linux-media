Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m64FBxlp031259
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 11:11:59 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m64FBQhN013964
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 11:11:26 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KEmwX-0006Yp-K2
	for video4linux-list@redhat.com; Fri, 04 Jul 2008 17:11:25 +0200
Message-ID: <486E3D78.4020307@hhs.nl>
Date: Fri, 04 Jul 2008 17:10:48 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
Content-Type: multipart/mixed; boundary="------------030302090506040000090000"
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: PATCH: libv4l-0.3.2-release.patch
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
--------------030302090506040000090000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

The current mercurial has been released on my homepage as tarbal release 0.3.2, 
the only changes from the current mercurial + all patches already send 
(including the asm patch from Gregor Jasny) is updating of the ChangeLog file 
and updating the version in the Makefile, these changes are included in the 
attached patch.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------030302090506040000090000
Content-Type: text/plain;
 name="libv4l-0.3.2-release.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libv4l-0.3.2-release.patch"

Current mercurial will be released on my homepage as tarbal release 0.3.2

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

--- a/v4l2-apps/lib/libv4l/ChangeLog	Fri Jul 04 14:13:03 2008 +0200
+++ b/v4l2-apps/lib/libv4l/ChangeLog	Fri Jul 04 16:17:59 2008 +0200
@@ -1,3 +1,9 @@
+libv4l-0.3.2
+------------
+* Add support for converting from sn9c10x compressed data
+* Add support for converting from pac207 compressed data
+* Add "make install" Makefile target
+
 libv4l-0.3.1
 ------------
 * Only serialize V4L2_BUF_TYPE_VIDEO_CAPTURE type ioctls
--- a/v4l2-apps/lib/libv4l/Makefile	Fri Jul 04 14:13:03 2008 +0200
+++ b/v4l2-apps/lib/libv4l/Makefile	Fri Jul 04 16:21:04 2008 +0200
@@ -1,5 +1,5 @@
 LIB_RELEASE=0
-V4L2_LIB_VERSION=$(LIB_RELEASE).3
+V4L2_LIB_VERSION=$(LIB_RELEASE).3.2
 
 all clean install:
 	$(MAKE) -C libv4lconvert $@

--------------030302090506040000090000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------030302090506040000090000--
