Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9UI9pU7018602
	for <video4linux-list@redhat.com>; Thu, 30 Oct 2008 14:09:51 -0400
Received: from QMTA05.emeryville.ca.mail.comcast.net
	(qmta05.emeryville.ca.mail.comcast.net [76.96.30.48])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9UI9aLB006599
	for <video4linux-list@redhat.com>; Thu, 30 Oct 2008 14:09:37 -0400
Message-ID: <4909F85E.4060900@personnelware.com>
Date: Thu, 30 Oct 2008 13:09:34 -0500
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: multipart/mixed; boundary="------------080901080303080406080905"
Subject: [patch] vivi version bump
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
--------------080901080303080406080905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

New features have been added, so VIVI_MINOR_VERSION gets bumped.

Signed-off-by: Carl Karsten  <carl@personnelware.com>

diff -r 931fa560184d linux/drivers/media/video/vivi.c
--- a/linux/drivers/media/video/vivi.c	Tue Oct 21 20:20:26 2008 -0200
+++ b/linux/drivers/media/video/vivi.c	Thu Oct 30 13:00:41 2008 -0500
@@ -53,7 +53,7 @@
 #include "font.h"

 #define VIVI_MAJOR_VERSION 0
-#define VIVI_MINOR_VERSION 5
+#define VIVI_MINOR_VERSION 6
 #define VIVI_RELEASE 0
 #define VIVI_VERSION \

Carl Karsten

--------------080901080303080406080905
Content-Type: text/x-patch;
 name="vivi.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vivi.c.diff"

diff -r 931fa560184d linux/drivers/media/video/vivi.c
--- a/linux/drivers/media/video/vivi.c	Tue Oct 21 20:20:26 2008 -0200
+++ b/linux/drivers/media/video/vivi.c	Thu Oct 30 13:04:23 2008 -0500
@@ -53,7 +53,7 @@
 #include "font.h"
 
 #define VIVI_MAJOR_VERSION 0
-#define VIVI_MINOR_VERSION 5
+#define VIVI_MINOR_VERSION 6
 #define VIVI_RELEASE 0
 #define VIVI_VERSION \
 	KERNEL_VERSION(VIVI_MAJOR_VERSION, VIVI_MINOR_VERSION, VIVI_RELEASE)

--------------080901080303080406080905
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------080901080303080406080905--
