Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6H9edBi024918
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 05:40:39 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6H9ePFI013112
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 05:40:25 -0400
Message-ID: <487F1552.4000505@hhs.nl>
Date: Thu, 17 Jul 2008 11:48:02 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------020609080006030200020907"
Cc: video4linux-list@redhat.com
Subject: Patch: gspca-sonixb-ov6650-fixes.patch
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
--------------020609080006030200020907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

2 small sonixb ov6650 fixes:

1) Don't change  the red and blue pre-gain's from their defaults
2) Actually make the powerline freq ctrl available to userspace

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>


Regards,

Hans

--------------020609080006030200020907
Content-Type: text/x-patch;
 name="gspca-sonixb-ov6650-fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-sonixb-ov6650-fixes.patch"

2 small sonixb ov6650 fixes:

1) Don't change  the red and blue pre-gain's from their defaults
2) Actually make the powerline freq ctrl available to userspace

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r e7aa8d7a1cfd linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Thu Jul 17 07:41:50 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Thu Jul 17 11:43:14 2008 +0200
@@ -246,8 +297,15 @@
 	{0xd0, 0x60, 0x26, 0x01, 0x14, 0xd8, 0xa4, 0x10}, /* format out? */
 	{0xd0, 0x60, 0x26, 0x01, 0x14, 0xd8, 0xa4, 0x10},
 	{0xa0, 0x60, 0x30, 0x3d, 0x0A, 0xd8, 0xa4, 0x10},
-	/* Disable autobright ? */
-	{0xb0, 0x60, 0x60, 0x66, 0x68, 0xd8, 0xa4, 0x10},
+	/* Enable rgb brightness control */
+	{0xa0, 0x60, 0x61, 0x08, 0x00, 0x00, 0x00, 0x10},
+	/* HDG: Note windows uses the line below, which sets both register 0x60
+	   and 0x61 I believe these registers of the ov6650 are identical as
+	   those of the ov7630, because if this is true the windows settings
+	   add a bit additional red gain and a lot additional blue gain, which
+	   matches my findings that the windows settings make blue much too
+	   blue and red a little too red.
+	{0xb0, 0x60, 0x60, 0x66, 0x68, 0xd8, 0xa4, 0x10}, */
 	/* Some more unknown stuff */
 	{0xa0, 0x60, 0x68, 0x04, 0x68, 0xd8, 0xa4, 0x10},
 	{0xd0, 0x60, 0x17, 0x24, 0xd6, 0x04, 0x94, 0x10}, /* Clipreg */
@@ -813,7 +932,7 @@
 			sd->sensor = SENSOR_OV6650;
 			sd->sensor_has_gain = 1;
 			sd->sensor_addr = 0x60;
-			sd->sd_desc.nctrls = 4;
+			sd->sd_desc.nctrls = 5;
 			sd->sd_desc.dq_callback = do_autogain;
 			sif = 1;
 			break;

--------------020609080006030200020907
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------020609080006030200020907--
