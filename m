Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:52396 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364AbZJaXOv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:14:51 -0400
Message-ID: <4AECC4EB.7070504@freemail.hu>
Date: Sun, 01 Nov 2009 00:14:51 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 09/21] gspca pac7302/pac7311: separate dq_callback
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate the dq_callback function. Remove the run-time decision for
PAC7302 and PAC7311 sensors.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN i/drivers/media/video/gspca/pac7311.c j/drivers/media/video/gspca/pac7311.c
--- i/drivers/media/video/gspca/pac7311.c	2009-10-30 17:59:39.000000000 +0100
+++ j/drivers/media/video/gspca/pac7311.c	2009-10-30 18:00:55.000000000 +0100
@@ -820,7 +820,7 @@ static void pac7311_sd_stop0(struct gspc
 /* Include pac common sof detection functions */
 #include "pac_common.h"

-static void do_autogain(struct gspca_dev *gspca_dev)
+static void pac7302_do_autogain(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int avg_lum = atomic_read(&sd->avg_lum);
@@ -829,22 +829,36 @@ static void do_autogain(struct gspca_dev
 	if (avg_lum == -1)
 		return;

-	if (sd->sensor == SENSOR_PAC7302) {
-		desired_lum = 270 + sd->brightness * 4;
-		/* Hack hack, with the 7202 the first exposure step is
-		   pretty large, so if we're about to make the first
-		   exposure increase make the deadzone large to avoid
-		   oscilating */
-		if (desired_lum > avg_lum && sd->gain == GAIN_DEF &&
-				sd->exposure > EXPOSURE_DEF &&
-				sd->exposure < 42)
-			deadzone = 90;
-		else
-			deadzone = 30;
-	} else {
-		desired_lum = 200;
-		deadzone = 20;
-	}
+	desired_lum = 270 + sd->brightness * 4;
+	/* Hack hack, with the 7202 the first exposure step is
+	   pretty large, so if we're about to make the first
+	   exposure increase make the deadzone large to avoid
+	   oscilating */
+	if (desired_lum > avg_lum && sd->gain == GAIN_DEF &&
+			sd->exposure > EXPOSURE_DEF &&
+			sd->exposure < 42)
+		deadzone = 90;
+	else
+		deadzone = 30;
+
+	if (sd->autogain_ignore_frames > 0)
+		sd->autogain_ignore_frames--;
+	else if (gspca_auto_gain_n_exposure(gspca_dev, avg_lum, desired_lum,
+			deadzone, GAIN_KNEE, EXPOSURE_KNEE))
+		sd->autogain_ignore_frames = PAC_AUTOGAIN_IGNORE_FRAMES;
+}
+
+static void pac7311_do_autogain(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int avg_lum = atomic_read(&sd->avg_lum);
+	int desired_lum, deadzone;
+
+	if (avg_lum == -1)
+		return;
+
+	desired_lum = 200;
+	deadzone = 20;

 	if (sd->autogain_ignore_frames > 0)
 		sd->autogain_ignore_frames--;
@@ -1180,7 +1194,7 @@ static struct sd_desc pac7302_sd_desc =
 	.stopN = pac7302_sd_stopN,
 	.stop0 = pac7302_sd_stop0,
 	.pkt_scan = pac7302_sd_pkt_scan,
-	.dq_callback = do_autogain,
+	.dq_callback = pac7302_do_autogain,
 };

 /* sub-driver description for pac7311 */
@@ -1194,7 +1208,7 @@ static struct sd_desc pac7311_sd_desc =
 	.stopN = pac7311_sd_stopN,
 	.stop0 = pac7311_sd_stop0,
 	.pkt_scan = pac7311_sd_pkt_scan,
-	.dq_callback = do_autogain,
+	.dq_callback = pac7311_do_autogain,
 };

 /* -- module initialisation -- */
