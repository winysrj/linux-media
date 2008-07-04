Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m648ufR1011266
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 04:56:41 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m648uA3U010944
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 04:56:10 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KEh5O-0001pG-5q
	for video4linux-list@redhat.com; Fri, 04 Jul 2008 10:56:10 +0200
Message-ID: <486DE587.3090204@hhs.nl>
Date: Fri, 04 Jul 2008 10:55:35 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------070400050000070305010205"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-default-comp_fac.patch
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
--------------070400050000070305010205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch changes the default gspca comp_fac as 30% sometimes causes issues
with the spca561, whose bayer compression does not allways achieve 30%.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------070400050000070305010205
Content-Type: text/plain;
 name="gspca-default-comp_fac.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-default-comp_fac.patch"

This patch changes the default gspca comp_fac as 30% sometimes causes issues
with the spca561, whose bayer compression does not allways achieve 30%.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 15974504cec1 linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Fri Jul 04 10:51:37 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.c	Fri Jul 04 10:53:35 2008 +0200
@@ -48,7 +48,9 @@
 
 static int video_nr = -1;
 
-static int comp_fac = 30;	/* Buffer size ratio when compressed in % */
+static int comp_fac = 40;	/* Buffer size ratio when compressed in %,
+				   Note 30% is too small for bayer level
+				   compression like the spca561 */
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 int gspca_debug = D_ERR | D_PROBE;

--------------070400050000070305010205
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------070400050000070305010205--
