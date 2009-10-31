Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:52348 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349AbZJaXO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:14:29 -0400
Message-ID: <4AECC4D5.2000006@freemail.hu>
Date: Sun, 01 Nov 2009 00:14:29 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 07/21] gspca pac7302/pac7311: separate stopN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate the stopN function. Remove the run-time decision for
PAC7302 and PAC7311 sensors.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN g/drivers/media/video/gspca/pac7311.c h/drivers/media/video/gspca/pac7311.c
--- g/drivers/media/video/gspca/pac7311.c	2009-10-30 18:03:15.000000000 +0100
+++ h/drivers/media/video/gspca/pac7311.c	2009-10-30 18:01:57.000000000 +0100
@@ -782,16 +782,15 @@ static int pac7311_sd_start(struct gspca
 	return 0;
 }

-static void sd_stopN(struct gspca_dev *gspca_dev)
+static void pac7302_sd_stopN(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	reg_w(gspca_dev, 0xff, 0x01);
+	reg_w(gspca_dev, 0x78, 0x00);
+	reg_w(gspca_dev, 0x78, 0x00);
+}

-	if (sd->sensor == SENSOR_PAC7302) {
-		reg_w(gspca_dev, 0xff, 0x01);
-		reg_w(gspca_dev, 0x78, 0x00);
-		reg_w(gspca_dev, 0x78, 0x00);
-		return;
-	}
+static void pac7311_sd_stopN(struct gspca_dev *gspca_dev)
+{
 	reg_w(gspca_dev, 0xff, 0x04);
 	reg_w(gspca_dev, 0x27, 0x80);
 	reg_w(gspca_dev, 0x28, 0xca);
@@ -1177,7 +1176,7 @@ static struct sd_desc pac7302_sd_desc =
 	.config = pac7302_sd_config,
 	.init = pac7302_sd_init,
 	.start = pac7302_sd_start,
-	.stopN = sd_stopN,
+	.stopN = pac7302_sd_stopN,
 	.stop0 = sd_stop0,
 	.pkt_scan = pac7302_sd_pkt_scan,
 	.dq_callback = do_autogain,
@@ -1191,7 +1190,7 @@ static struct sd_desc pac7311_sd_desc =
 	.config = pac7311_sd_config,
 	.init = pac7311_sd_init,
 	.start = pac7311_sd_start,
-	.stopN = sd_stopN,
+	.stopN = pac7311_sd_stopN,
 	.stop0 = sd_stop0,
 	.pkt_scan = pac7311_sd_pkt_scan,
 	.dq_callback = do_autogain,
