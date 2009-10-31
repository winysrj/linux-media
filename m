Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:52332 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336AbZJaXOT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:14:19 -0400
Message-ID: <4AECC4C9.5080709@freemail.hu>
Date: Sun, 01 Nov 2009 00:14:17 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 06/21] gspca pac7302/pac7311: separate start
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate the start function. Remove the run-time decision for
PAC7302 and PAC7311 sensors.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN f/drivers/media/video/gspca/pac7311.c g/drivers/media/video/gspca/pac7311.c
--- f/drivers/media/video/gspca/pac7311.c	2009-10-30 18:04:30.000000000 +0100
+++ g/drivers/media/video/gspca/pac7311.c	2009-10-30 18:03:15.000000000 +0100
@@ -714,20 +714,40 @@ static int pac7311_sd_init(struct gspca_
 	return 0;
 }

-static int sd_start(struct gspca_dev *gspca_dev)
+static int pac7302_sd_start(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

 	sd->sof_read = 0;

-	if (sd->sensor == SENSOR_PAC7302) {
-		reg_w_var(gspca_dev, start_7302);
-		pac7302_setbrightcont(gspca_dev);
-		pac7302_setcolors(gspca_dev);
-	} else {
-		reg_w_var(gspca_dev, start_7311);
-		pac7311_setcontrast(gspca_dev);
-	}
+	reg_w_var(gspca_dev, start_7302);
+	pac7302_setbrightcont(gspca_dev);
+	pac7302_setcolors(gspca_dev);
+	setgain(gspca_dev);
+	setexposure(gspca_dev);
+	sethvflip(gspca_dev);
+
+	/* only resolution 640x480 is supported for pac7302 */
+
+	sd->sof_read = 0;
+	sd->autogain_ignore_frames = 0;
+	atomic_set(&sd->avg_lum, -1);
+
+	/* start stream */
+	reg_w(gspca_dev, 0xff, 0x01);
+	reg_w(gspca_dev, 0x78, 0x01);
+
+	return 0;
+}
+
+static int pac7311_sd_start(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->sof_read = 0;
+
+	reg_w_var(gspca_dev, start_7311);
+	pac7311_setcontrast(gspca_dev);
 	setgain(gspca_dev);
 	setexposure(gspca_dev);
 	sethvflip(gspca_dev);
@@ -745,8 +765,6 @@ static int sd_start(struct gspca_dev *gs
 		reg_w(gspca_dev, 0x87, 0x11);
 		break;
 	case 0:					/* 640x480 */
-		if (sd->sensor == SENSOR_PAC7302)
-			break;
 		reg_w(gspca_dev, 0xff, 0x01);
 		reg_w(gspca_dev, 0x17, 0x00);
 		reg_w(gspca_dev, 0x87, 0x12);
@@ -759,10 +777,8 @@ static int sd_start(struct gspca_dev *gs

 	/* start stream */
 	reg_w(gspca_dev, 0xff, 0x01);
-	if (sd->sensor == SENSOR_PAC7302)
-		reg_w(gspca_dev, 0x78, 0x01);
-	else
-		reg_w(gspca_dev, 0x78, 0x05);
+	reg_w(gspca_dev, 0x78, 0x05);
+
 	return 0;
 }

@@ -1160,7 +1176,7 @@ static struct sd_desc pac7302_sd_desc =
 	.nctrls = ARRAY_SIZE(sd_ctrls),
 	.config = pac7302_sd_config,
 	.init = pac7302_sd_init,
-	.start = sd_start,
+	.start = pac7302_sd_start,
 	.stopN = sd_stopN,
 	.stop0 = sd_stop0,
 	.pkt_scan = pac7302_sd_pkt_scan,
@@ -1174,7 +1190,7 @@ static struct sd_desc pac7311_sd_desc =
 	.nctrls = ARRAY_SIZE(sd_ctrls),
 	.config = pac7311_sd_config,
 	.init = pac7311_sd_init,
-	.start = sd_start,
+	.start = pac7311_sd_start,
 	.stopN = sd_stopN,
 	.stop0 = sd_stop0,
 	.pkt_scan = pac7311_sd_pkt_scan,
