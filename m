Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6GFBH5F021025
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 11:11:17 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6GFB444010182
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 11:11:04 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KJ8em-0003BW-2q
	for video4linux-list@redhat.com; Wed, 16 Jul 2008 17:11:04 +0200
Message-ID: <487E0F5E.8070801@hhs.nl>
Date: Wed, 16 Jul 2008 17:10:22 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------080406090608060101030504"
Cc: video4linux-list@redhat.com
Subject: PAtch: gspca-sonixb-ov6650-expo-clamp.patch
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
--------------080406090608060101030504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patches fixing oscilating in daylight with clouds with the sonixb driver
in combination with the ov6650 sensor.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------080406090608060101030504
Content-Type: text/plain;
 name="gspca-sonixb-ov6650-expo-clamp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-sonixb-ov6650-expo-clamp.patch"

This patches fixing oscilating in daylight with clouds with the sonixb driver
in combination with the ov6650 sensor.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 086f909be17c linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Wed Jul 16 15:29:31 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Wed Jul 16 17:07:37 2008 +0200
@@ -712,8 +712,13 @@
 		/* frame exposure time in ms = 1000 * reg11 / 30    ->
 		reg10 = sd->exposure * 2 * reg10_max / (1000 * reg11 / 30) */
 		reg10 = (sd->exposure * 60 * reg10_max) / (1000 * reg11);
-		if (reg10 < 1) /* 0 is a valid value, but is very _black_ */
-			reg10 = 1;
+		
+		/* Don't allow this to get below 10 when using autogain, the
+		   steps become very large (relatively) when below 10 causing
+		   the image to oscilate from much too dark, to much too bright
+		   and back again. */
+		if (sd->autogain && reg10 < 10)
+			reg10 = 10;
 		else if (reg10 > reg10_max)
 			reg10 = reg10_max;
 
@@ -796,8 +801,11 @@
 		sd->autogain_ignore_frames--;
 	else if (gspca_auto_gain_n_exposure(gspca_dev, avg_lum,
 			sd->brightness * DESIRED_AVG_LUM / 127,
-			AUTOGAIN_DEADZONE, GAIN_KNEE, EXPOSURE_KNEE))
+			AUTOGAIN_DEADZONE, GAIN_KNEE, EXPOSURE_KNEE)) {
+		PDEBUG(D_FRAM, "autogain: gain changed: gain: %d expo: %d\n",
+			(int)sd->gain, (int)sd->exposure);
 		sd->autogain_ignore_frames = AUTOGAIN_IGNORE_FRAMES;
+	}
 }
 
 /* this function is called at probe time */

--------------080406090608060101030504
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------080406090608060101030504--
