Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:57551 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZJCVmE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 17:42:04 -0400
Received: by ewy7 with SMTP id 7so2375546ewy.17
        for <linux-media@vger.kernel.org>; Sat, 03 Oct 2009 14:41:26 -0700 (PDT)
Subject: [PATCH 1/3] gspca_gl860/Fixed format : main part update
From: Olivier Lorin <olorin75@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 03 Oct 2009 23:41:19 +0200
Message-Id: <1254606079.24873.28.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm sorry, I used a bad format for the 3 previous patches I sent this day.
This is fixed now.


gspca_gl860: improvement of the main driver part

From: Olivier Lorin <o.lorin@laposte.net>

- fix for compilation warning about sd_ctrls
- trace improvement while probing the sensor

Priority: normal

Signed-off-by: Olivier Lorin <o.lorin@laposte.net>

diff -rupN ../gspca-o/linux/drivers/media/video/gspca/gl860/gl860.c ./linux/drivers/media/video/gspca/gl860/gl860.c
--- ../gspca-o/linux/drivers/media/video/gspca/gl860/gl860.c	2009-09-18 10:36:24.000000000 +0200
+++ ./linux/drivers/media/video/gspca/gl860/gl860.c	2009-09-24 13:55:34.000000000 +0200
@@ -23,8 +23,8 @@
 #include "gspca.h"
 #include "gl860.h"
 
-MODULE_AUTHOR("Olivier Lorin <lorin@laposte.net>");
-MODULE_DESCRIPTION("GSPCA/Genesys Logic GL860 USB Camera Driver");
+MODULE_AUTHOR("Olivier Lorin <o.lorin@laposte.net>");
+MODULE_DESCRIPTION("Genesys Logic USB PC Camera Driver");
 MODULE_LICENSE("GPL");
 
 /*======================== static function declarations ====================*/
@@ -53,7 +53,7 @@ MODULE_PARM_DESC(AC50Hz, " Does AC power
 static char sensor[7];
 module_param_string(sensor, sensor, sizeof(sensor), 0644);
 MODULE_PARM_DESC(sensor,
-		" Driver sensor ('MI1320'/'MI2020'/'OV9655'/'OV2640'/'')");
+		" Driver sensor ('MI1320'/'MI2020'/'OV9655'/'OV2640')");
 
 /*============================ webcam controls =============================*/
 
@@ -119,16 +119,23 @@ static int gl860_build_control_table(str
 	struct ctrl *sd_ctrls;
 	int nCtrls = 0;
 
-	if (_MI1320_)
+	switch (sd->sensor) {
+	case ID_MI1320:
 		sd_ctrls = sd_ctrls_mi1320;
-	else if (_MI2020_)
+		break;
+	case ID_MI2020:
 		sd_ctrls = sd_ctrls_mi2020;
-	else if (_MI2020b_)
+		break;
+	case ID_MI2020b:
 		sd_ctrls = sd_ctrls_mi2020b;
-	else if (_OV2640_)
+		break;
+	case ID_OV2640:
 		sd_ctrls = sd_ctrls_ov2640;
-	else if (_OV9655_)
+		break;
+	default:
 		sd_ctrls = sd_ctrls_ov9655;
+		break;
+	}
 
 	memset(sd_ctrls, 0, GL860_NCTRLS * sizeof(struct ctrl));
 
@@ -154,7 +161,7 @@ static int gl860_build_control_table(str
 	SET_MY_CTRL(V4L2_CID_VFLIP,
 		V4L2_CTRL_TYPE_BOOLEAN, "Flip", flip)
 	SET_MY_CTRL(V4L2_CID_POWER_LINE_FREQUENCY,
-		V4L2_CTRL_TYPE_BOOLEAN, "50Hz", AC50Hz)
+		V4L2_CTRL_TYPE_BOOLEAN, "AC power 50Hz", AC50Hz)
 
 	return nCtrls;
 }
@@ -700,6 +707,7 @@ static int gl860_guess_sensor(struct gsp
 		ctrl_out(gspca_dev, 0x40, 1, 0x006a, 0x000d, 0, NULL);
 		msleep(56);
 
+		PDEBUG(D_PROBE, "probing for sensor MI2020 or OVXXXX");
 		nOV = 0;
 		for (ntry = 0; ntry < 4; ntry++) {
 			ctrl_out(gspca_dev, 0x40, 1, 0x0040, 0x0000, 0, NULL);
@@ -709,14 +717,14 @@ static int gl860_guess_sensor(struct gsp
 			ctrl_out(gspca_dev, 0x40, 1, 0x7a00, 0x8030, 0, NULL);
 			msleep(10);
 			ctrl_in(gspca_dev, 0xc0, 2, 0x7a00, 0x8030, 1, &probe);
-			PDEBUG(D_PROBE, "1st probe=%02x", probe);
+			PDEBUG(D_PROBE, "probe=0x%02x", probe);
 			if (probe == 0xff)
 				nOV++;
 		}
 
 		if (nOV) {
-			PDEBUG(D_PROBE, "0xff -> sensor OVXXXX");
-			PDEBUG(D_PROBE, "Probing for sensor OV2640 or OV9655");
+			PDEBUG(D_PROBE, "0xff -> OVXXXX");
+			PDEBUG(D_PROBE, "probing for sensor OV2640 or OV9655");
 
 			nb26 = nb96 = 0;
 			for (ntry = 0; ntry < 4; ntry++) {
@@ -726,40 +734,38 @@ static int gl860_guess_sensor(struct gsp
 				ctrl_out(gspca_dev, 0x40, 1, 0x6000, 0x800a,
 						0, NULL);
 				msleep(10);
+
 				/* Wait for 26(OV2640) or 96(OV9655) */
 				ctrl_in(gspca_dev, 0xc0, 2, 0x6000, 0x800a,
 						1, &probe);
 
-				PDEBUG(D_PROBE, "2nd probe=%02x", probe);
-				if (probe == 0x00)
-					nb26++;
 				if (probe == 0x26 || probe == 0x40) {
+					PDEBUG(D_PROBE,
+						"probe=0x%02x -> OV2640",
+						probe);
 					sd->sensor = ID_OV2640;
 					nb26 += 4;
 					break;
 				}
 				if (probe == 0x96 || probe == 0x55) {
+					PDEBUG(D_PROBE,
+						"probe=0x%02x -> OV9655",
+						probe);
 					sd->sensor = ID_OV9655;
 					nb96 += 4;
 					break;
 				}
+				PDEBUG(D_PROBE, "probe=0x%02x", probe);
+				if (probe == 0x00)
+					nb26++;
 				if (probe == 0xff)
 					nb96++;
 				msleep(3);
 			}
-			if (nb26 < 4 && nb96 < 4) {
-				PDEBUG(D_PROBE, "No relevant answer ");
-				PDEBUG(D_PROBE, "* 1.3Mpixels -> use OV9655");
-				PDEBUG(D_PROBE, "* 2.0Mpixels -> use OV2640");
-				PDEBUG(D_PROBE,
-					"To force a sensor, add that line to "
-					"/etc/modprobe.d/options.conf:");
-				PDEBUG(D_PROBE, "options gspca_gl860 "
-					"sensor=\"OV2640\" or \"OV9655\"");
+			if (nb26 < 4 && nb96 < 4)
 				return -1;
-			}
-		} else { /* probe = 0 */
-			PDEBUG(D_PROBE, "No 0xff -> sensor MI2020");
+		} else {
+			PDEBUG(D_PROBE, "Not any 0xff -> MI2020");
 			sd->sensor = ID_MI2020;
 		}
 	}
diff -rupN ../gspca-o/linux/drivers/media/video/gspca/gl860/gl860.h ./linux/drivers/media/video/gspca/gl860/gl860.h
--- ../gspca-o/linux/drivers/media/video/gspca/gl860/gl860.h	2009-09-18 10:36:24.000000000 +0200
+++ ./linux/drivers/media/video/gspca/gl860/gl860.h	2009-09-24 14:01:41.000000000 +0200
@@ -22,7 +22,7 @@
 #include "gspca.h"
 
 #define MODULE_NAME "gspca_gl860"
-#define DRIVER_VERSION "0.9d10"
+#define DRIVER_VERSION "0.9d11"
 
 #define ctrl_in  gl860_RTx
 #define ctrl_out gl860_RTx


