Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m77ACqUZ007167
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 06:12:52 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m77ACe1j011960
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 06:12:40 -0400
Message-ID: <489ACCC5.1050109@hhs.nl>
Date: Thu, 07 Aug 2008 12:21:57 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------050300070900030505010606"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Subject: Patch: gspca-zc3xx-pas106b-detect.patch 
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
--------------050300070900030505010606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch moves the detection of the 2wr SIF pas106b sensor to before detecing
other 2 wire sensors (as it was done with gspcav1) without this the pas106b
gets misdetected as an HDCS2020b.

This makes my Philips SPC 200NC cam work, but unfortunately the picture is
upside down (same with gspcav1). While experimenting to try to fix this I've
found the meaning of one pas106b register and a comment now documents this.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------050300070900030505010606
Content-Type: text/x-patch;
 name="gspca-zc3xx-pas106b-detect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-zc3xx-pas106b-detect.patch"

This patch moves the detection of the 2wr SIF pas106b sensor to before detecing
other 2 wire sensors (as it was done with gspcav1) without this the pas106b
gets misdetected as an HDCS2020b.

This makes my Philips SPC 200NC cam work, but unfortunately the picture is
upside down (same with gspcav1). While experimenting to try to fix this I've
found the meaning of one pas106b register and a comment now documents this.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
diff -r 380c5715fd90 linux/drivers/media/video/gspca/zc3xx.c
--- a/linux/drivers/media/video/gspca/zc3xx.c	Wed Aug 06 10:49:16 2008 +0200
+++ b/linux/drivers/media/video/gspca/zc3xx.c	Thu Aug 07 12:18:01 2008 +0200
@@ -4134,6 +4134,7 @@
 	{0xaa, 0x0c, 0x0005},
 	{0xaa, 0x0d, 0x0000},
 	{0xaa, 0x0e, 0x0002},
+/*	{0xaa, 0x11, 0x0000}, seems to control exposure (0 = max exp) */
 	{0xaa, 0x14, 0x0081},
 
 /* Other registors */
@@ -6972,6 +6973,10 @@
 				/* may probe but with write in reg 0x0010 */
 		return -1;		/* don't probe */
 	}
+	sensor = sif_probe(gspca_dev);
+	if (sensor >= 0)
+		return sensor;
+
 	sensor = vga_2wr_probe(gspca_dev);
 	if (sensor >= 0) {
 		if (sensor < 0x7600)
@@ -6984,7 +6989,7 @@
 			return sensor;
 		return sensor2;
 	}
-	return sif_probe(gspca_dev);
+	return -1;
 }
 
 /* this function is called at probe time */

--------------050300070900030505010606
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------050300070900030505010606--
