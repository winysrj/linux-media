Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7QEJ3hO018006
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 10:19:03 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7QEJ0Sg024622
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 10:19:01 -0400
Message-ID: <48B4136A.1060901@hhs.nl>
Date: Tue, 26 Aug 2008 16:30:02 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------030805030105010909080400"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: PATCH: some pac7302 autogain improvements
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
--------------030805030105010909080400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

The attached patch stops the pac7302 autogain from oscilating under certain 
circumstances.

Regards,

Hans

--------------030805030105010909080400
Content-Type: text/plain;
 name="gspca-pac7302-autogain-tweaks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-pac7302-autogain-tweaks.patch"

Stop the pac7302 autogain from oscilating under certain circumstances.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
diff -r 1cf9e4187e0a linux/drivers/media/video/gspca/pac7311.c
--- a/linux/drivers/media/video/gspca/pac7311.c	Tue Aug 26 12:34:35 2008 +0200
+++ b/linux/drivers/media/video/gspca/pac7311.c	Tue Aug 26 16:06:32 2008 +0200
@@ -39,7 +39,7 @@
 
    Address	Description
    0x02		Clock divider 2-63, fps =~ 60 / val. Must be a multiple of 3 on
-		the 7302, so one of 3, 6, 9, ...
+		the 7302, so one of 3, 6, 9, ..., except when between 6 and 12?
    -/0x0f	Master gain 1-245, low value = high gain
    0x10/-	Master gain 0-31
    -/0x10	Another gain 0-15, limited influence (1-2x gain I guess)
@@ -640,8 +640,9 @@
 
 	if (sd->sensor == SENSOR_PAC7302) {
 		/* On the pac7302 reg2 MUST be a multiple of 3, so round it to
-		   the nearest multiple of 3 */
-		reg = ((reg + 1) / 3) * 3;
+		   the nearest multiple of 3, except when between 6 and 12? */
+		if (reg < 6 || reg > 12)
+			reg = ((reg + 1) / 3) * 3;
 		reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
 		reg_w(gspca_dev, 0x02, reg);
 	} else {
@@ -780,20 +781,32 @@
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int avg_lum = atomic_read(&sd->avg_lum);
-	int desired_lum;
+	int desired_lum, deadzone;
 
 	if (avg_lum == -1)
 		return;
 
-	if (sd->sensor == SENSOR_PAC7302)
-		desired_lum = 70 + sd->brightness * 2;
-	else
+	if (sd->sensor == SENSOR_PAC7302) {
+		desired_lum = 270 + sd->brightness * 4;
+		/* Hack hack, with the 7202 the first exposure step is
+		   pretty large, so if we're about to make the first
+		   exposure increase make the deadzone large to avoid
+		   oscilating */
+		if (desired_lum > avg_lum && sd->gain == GAIN_DEF &&
+				sd->exposure > EXPOSURE_DEF &&
+				sd->exposure < 42)
+			deadzone = 90;
+		else
+			deadzone = 30;
+	} else {
 		desired_lum = 200;
+		deadzone = 20;
+	}
 
 	if (sd->autogain_ignore_frames > 0)
 		sd->autogain_ignore_frames--;
 	else if (gspca_auto_gain_n_exposure(gspca_dev, avg_lum, desired_lum,
-			10, GAIN_KNEE, EXPOSURE_KNEE))
+			deadzone, GAIN_KNEE, EXPOSURE_KNEE))
 		sd->autogain_ignore_frames = PAC_AUTOGAIN_IGNORE_FRAMES;
 }
 
@@ -821,7 +834,11 @@
 		int n, lum_offset, footer_length;
 
 		if (sd->sensor == SENSOR_PAC7302) {
-		  lum_offset = 34 + sizeof pac_sof_marker;
+		  /* 6 bytes after the FF D9 EOF marker a number of lumination
+		     bytes are send corresponding to different parts of the
+		     image, the 14th and 15th byte after the EOF seem to
+		     correspond to the center of the image */
+		  lum_offset = 61 + sizeof pac_sof_marker;
 		  footer_length = 74;
 		} else {
 		  lum_offset = 24 + sizeof pac_sof_marker;
@@ -848,18 +865,11 @@
 
 		/* Get average lumination */
 		if (gspca_dev->last_packet_type == LAST_PACKET &&
-				n >= lum_offset) {
-			if (sd->sensor == SENSOR_PAC7302)
-				atomic_set(&sd->avg_lum,
-						(data[-lum_offset] << 8) |
+				n >= lum_offset)
+			atomic_set(&sd->avg_lum, data[-lum_offset] +
 						data[-lum_offset + 1]);
-			else
-				atomic_set(&sd->avg_lum,
-						data[-lum_offset] +
-						data[-lum_offset + 1]);
-		} else {
+		else
 			atomic_set(&sd->avg_lum, -1);
-		}
 
 		/* Start the new frame with the jpeg header */
 		gspca_frame_add(gspca_dev, FIRST_PACKET, frame,

--------------030805030105010909080400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------030805030105010909080400--
