Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7MLHa1B030978
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 17:17:37 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7MLHPvv016257
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 17:17:25 -0400
Message-ID: <48AF2F67.5000900@hhs.nl>
Date: Fri, 22 Aug 2008 23:28:07 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------090309090004040305050900"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Patch: gspca-pac73xx-sof-detect.patch
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
--------------090309090004040305050900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch adjusts the pac73xx sof detection, we were throwing away 2 bytes 
after the sof, but one of those 2 actually is the first magic marker for the 
first MCU, as we may need those markers in the future pass the 2 bytes to 
userspace, this also simplifies the code :)

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------090309090004040305050900
Content-Type: text/plain;
 name="gspca-pac73xx-sof-detect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-pac73xx-sof-detect.patch"

Adjust pac73xx sof detection, we were throwing away 2 bytes after the sof,
but one of those 2 actually is the first magic marker for the first MCU, as
we may need those markers in the future pass the 2 bytes to userspace, this
also simplifies the code :)

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

p.s.

Matching userspace code has now been committed to my tree:
http://linuxtv.org/hg/~hgoede/v4l-dvb
diff -r 55d686bc5075 linux/drivers/media/video/gspca/pac7311.c
--- a/linux/drivers/media/video/gspca/pac7311.c	Fri Aug 22 22:51:29 2008 +0200
+++ b/linux/drivers/media/video/gspca/pac7311.c	Fri Aug 22 22:54:13 2008 +0200
@@ -70,7 +70,6 @@
 #define SENSOR_PAC7311 1
 
 	u8 sof_read;
-	u8 header_read;
 	u8 autogain_ignore_frames;
 
 	atomic_t avg_lum;
@@ -759,8 +758,6 @@
 /* Include pac common sof detection functions */
 #include "pac_common.h"
 
-#define HEADER_LENGTH 2
-
 /* this function is run at interrupt level */
 static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 			struct gspca_frame *frame,	/* target */
@@ -834,22 +831,7 @@
 		gspca_frame_add(gspca_dev, INTER_PACKET, frame, tmpbuf, 4);
 		gspca_frame_add(gspca_dev, INTER_PACKET, frame,
 			pac7311_jpeg_header2, sizeof(pac7311_jpeg_header2));
-
-		sd->header_read = 0;
 	}
-
-	if (sd->header_read < HEADER_LENGTH) {
-		/* skip the variable part of the sof header */
-		int needed = HEADER_LENGTH - sd->header_read;
-		if (len <= needed) {
-			sd->header_read += len;
-			return;
-		}
-		data += needed;
-		len -= needed;
-		sd->header_read = HEADER_LENGTH;
-	}
-
 	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
 }
 

--------------090309090004040305050900
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------090309090004040305050900--
