Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:52372 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933316AbZJaXOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:14:40 -0400
Message-ID: <4AECC4E0.8090006@freemail.hu>
Date: Sun, 01 Nov 2009 00:14:40 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 08/21] gspca pac7302/pac7311: separate stop0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate the stop0 function. Remove the run-time decision for
PAC7302 and PAC7311 sensors.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN h/drivers/media/video/gspca/pac7311.c i/drivers/media/video/gspca/pac7311.c
--- h/drivers/media/video/gspca/pac7311.c	2009-10-30 18:01:57.000000000 +0100
+++ i/drivers/media/video/gspca/pac7311.c	2009-10-30 17:59:39.000000000 +0100
@@ -803,17 +803,18 @@ static void pac7311_sd_stopN(struct gspc
 	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
 }

-/* called on streamoff with alt 0 and on disconnect */
-static void sd_stop0(struct gspca_dev *gspca_dev)
+/* called on streamoff with alt 0 and on disconnect for pac7302 */
+static void pac7302_sd_stop0(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-
 	if (!gspca_dev->present)
 		return;
-	if (sd->sensor == SENSOR_PAC7302) {
-		reg_w(gspca_dev, 0xff, 0x01);
-		reg_w(gspca_dev, 0x78, 0x40);
-	}
+	reg_w(gspca_dev, 0xff, 0x01);
+	reg_w(gspca_dev, 0x78, 0x40);
+}
+
+/* called on streamoff with alt 0 and on disconnect for 7311 */
+static void pac7311_sd_stop0(struct gspca_dev *gspca_dev)
+{
 }

 /* Include pac common sof detection functions */
@@ -1177,7 +1178,7 @@ static struct sd_desc pac7302_sd_desc =
 	.init = pac7302_sd_init,
 	.start = pac7302_sd_start,
 	.stopN = pac7302_sd_stopN,
-	.stop0 = sd_stop0,
+	.stop0 = pac7302_sd_stop0,
 	.pkt_scan = pac7302_sd_pkt_scan,
 	.dq_callback = do_autogain,
 };
@@ -1191,7 +1192,7 @@ static struct sd_desc pac7311_sd_desc =
 	.init = pac7311_sd_init,
 	.start = pac7311_sd_start,
 	.stopN = pac7311_sd_stopN,
-	.stop0 = sd_stop0,
+	.stop0 = pac7311_sd_stop0,
 	.pkt_scan = pac7311_sd_pkt_scan,
 	.dq_callback = do_autogain,
 };
