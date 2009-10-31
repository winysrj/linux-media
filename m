Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:60618 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328AbZJaXNh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:13:37 -0400
Message-ID: <4AECC4A0.7080801@freemail.hu>
Date: Sun, 01 Nov 2009 00:13:36 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 02/21] gspca pac7302/pac7311: separate sd_desc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Move the sensor specific decision temporary to sd_probe. Create an sd_desc
for PAC7302 and one for PAC7311.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN b/drivers/media/video/gspca/pac7311.c c/drivers/media/video/gspca/pac7311.c
--- b/drivers/media/video/gspca/pac7311.c	2009-10-30 17:09:52.000000000 +0100
+++ c/drivers/media/video/gspca/pac7311.c	2009-10-30 17:05:09.000000000 +0100
@@ -1078,8 +1078,22 @@ static int sd_getvflip(struct gspca_dev
 	return 0;
 }

-/* sub-driver description */
-static struct sd_desc sd_desc = {
+/* sub-driver description for pac7302 */
+static struct sd_desc pac7302_sd_desc = {
+	.name = MODULE_NAME,
+	.ctrls = sd_ctrls,
+	.nctrls = ARRAY_SIZE(sd_ctrls),
+	.config = sd_config,
+	.init = sd_init,
+	.start = sd_start,
+	.stopN = sd_stopN,
+	.stop0 = sd_stop0,
+	.pkt_scan = sd_pkt_scan,
+	.dq_callback = do_autogain,
+};
+
+/* sub-driver description for pac7311 */
+static struct sd_desc pac7311_sd_desc = {
 	.name = MODULE_NAME,
 	.ctrls = sd_ctrls,
 	.nctrls = ARRAY_SIZE(sd_ctrls),
@@ -1117,8 +1131,12 @@ MODULE_DEVICE_TABLE(usb, device_table);
 static int sd_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
-	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
-				THIS_MODULE);
+	if (id->driver_info == SENSOR_PAC7302)
+		return gspca_dev_probe(intf, id, &pac7302_sd_desc,
+				sizeof(struct sd), THIS_MODULE);
+	else
+		return gspca_dev_probe(intf, id, &pac7311_sd_desc,
+				sizeof(struct sd), THIS_MODULE);
 }

 static struct usb_driver sd_driver = {
