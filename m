Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m63BnTt0000686
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 07:49:29 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m63BnFGs008904
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 07:49:15 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KENJK-0005S0-PV
	for video4linux-list@redhat.com; Thu, 03 Jul 2008 13:49:14 +0200
Message-ID: <486CBC99.20303@hhs.nl>
Date: Thu, 03 Jul 2008 13:48:41 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
Content-Type: multipart/mixed; boundary="------------050405070707000909090301"
Cc: video4linux-list@redhat.com
Subject: PATCH: v4l-dvb-do-not-strip-patch-files.patch
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
--------------050405070707000909090301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

While doing make commit of my latest patch I found out that strip-whitespace 
also strips the application patches included in the latest libv4l, which is 
bad, this patch fixes this.

Regards,

Hans

--------------050405070707000909090301
Content-Type: text/plain;
 name="v4l-dvb-do-not-strip-patch-files.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="v4l-dvb-do-not-strip-patch-files.patch"

The libv4l directory contains some bugfix patches / port to libv4l patches
for various applications, strip-trailing-whitespaces.sh should not touch these
this patch teaches strip-trailing-whitespaces.sh to not touch .patch files.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 6169e79de2d2 v4l/scripts/strip-trailing-whitespaces.sh
--- a/v4l/scripts/strip-trailing-whitespaces.sh	Tue Jul 01 21:18:23 2008 +0200
+++ b/v4l/scripts/strip-trailing-whitespaces.sh	Thu Jul 03 13:46:16 2008 +0200
@@ -20,6 +20,12 @@
 fi
 
 for file in `eval $files`; do
+	case "$file" in
+		*.patch)
+			continue
+			;;
+	esac
+
 	perl -ne '
 	s/[ \t]+$//;
 	s<^ {8}> <\t>;

--------------050405070707000909090301
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------050405070707000909090301--
