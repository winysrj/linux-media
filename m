Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:64963 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303AbZJaXOG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:14:06 -0400
Message-ID: <4AECC4BD.4000700@freemail.hu>
Date: Sun, 01 Nov 2009 00:14:05 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 05/21] gspca pac7302/pac7311: separate init
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate the init function. Remove the run-time decision for
PAC7302 and PAC7311 sensors.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN e/drivers/media/video/gspca/pac7311.c f/drivers/media/video/gspca/pac7311.c
--- e/drivers/media/video/gspca/pac7311.c	2009-10-30 17:27:57.000000000 +0100
+++ f/drivers/media/video/gspca/pac7311.c	2009-10-30 18:04:30.000000000 +0100
@@ -698,15 +698,18 @@ static void sethvflip(struct gspca_dev *
 	reg_w(gspca_dev, 0x11, 0x01);
 }

-/* this function is called at probe and resume time */
-static int sd_init(struct gspca_dev *gspca_dev)
+/* this function is called at probe and resume time for pac7302 */
+static int pac7302_sd_init(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	reg_w_seq(gspca_dev, init_7302, sizeof init_7302);

-	if (sd->sensor == SENSOR_PAC7302)
-		reg_w_seq(gspca_dev, init_7302, sizeof init_7302);
-	else
-		reg_w_seq(gspca_dev, init_7311, sizeof init_7311);
+	return 0;
+}
+
+/* this function is called at probe and resume time for pac7311 */
+static int pac7311_sd_init(struct gspca_dev *gspca_dev)
+{
+	reg_w_seq(gspca_dev, init_7311, sizeof init_7311);

 	return 0;
 }
@@ -1156,7 +1159,7 @@ static struct sd_desc pac7302_sd_desc =
 	.ctrls = sd_ctrls,
 	.nctrls = ARRAY_SIZE(sd_ctrls),
 	.config = pac7302_sd_config,
-	.init = sd_init,
+	.init = pac7302_sd_init,
 	.start = sd_start,
 	.stopN = sd_stopN,
 	.stop0 = sd_stop0,
@@ -1170,7 +1173,7 @@ static struct sd_desc pac7311_sd_desc =
 	.ctrls = sd_ctrls,
 	.nctrls = ARRAY_SIZE(sd_ctrls),
 	.config = pac7311_sd_config,
-	.init = sd_init,
+	.init = pac7311_sd_init,
 	.start = sd_start,
 	.stopN = sd_stopN,
 	.stop0 = sd_stop0,
