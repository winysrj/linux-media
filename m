Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:65361 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0AQNI3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 08:08:29 -0500
Message-ID: <4B530BC6.90903@freemail.hu>
Date: Sun, 17 Jan 2010 14:08:22 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2, RFC] gspca pac7302: add support for camera button
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Add support for snapshot button found on Labtec Webcam 2200.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 875c200a19dc linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Sun Jan 17 07:58:51 2010 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	Sun Jan 17 13:47:50 2010 +0100
@@ -5,6 +5,8 @@
  * V4L2 by Jean-Francois Moine <http://moinejf.free.fr>
  *
  * Separated from Pixart PAC7311 library by M�rton N�meth <nm127@freemail.hu>
+ * Camera button input handling by Márton Németh <nm127@freemail.hu>
+ * Copyright (C) 2009-2010 Márton Németh <nm127@freemail.hu>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -68,6 +70,7 @@

 #define MODULE_NAME "pac7302"

+#include <linux/input.h>
 #include <media/v4l2-chip-ident.h>
 #include "gspca.h"

@@ -1164,6 +1167,37 @@
 }
 #endif

+#ifdef CONFIG_INPUT
+static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
+			u8 *data,		/* interrupt packet data */
+			int len)		/* interrput packet length */
+{
+	int ret = -EINVAL;
+	u8 data0, data1;
+
+	if (len == 2) {
+		data0 = data[0];
+		data1 = data[1];
+		if ((data0 == 0x00 && data1 == 0x11) ||
+		    (data0 == 0x22 && data1 == 0x33) ||
+		    (data0 == 0x44 && data1 == 0x55) ||
+		    (data0 == 0x66 && data1 == 0x77) ||
+		    (data0 == 0x88 && data1 == 0x99) ||
+		    (data0 == 0xaa && data1 == 0xbb) ||
+		    (data0 == 0xcc && data1 == 0xdd) ||
+		    (data0 == 0xee && data1 == 0xff)) {
+			input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
+			input_sync(gspca_dev->input_dev);
+			input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
+			input_sync(gspca_dev->input_dev);
+			ret = 0;
+		}
+	}
+
+	return ret;
+}
+#endif
+
 /* sub-driver description for pac7302 */
 static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
@@ -1180,6 +1214,9 @@
 	.set_register = sd_dbg_s_register,
 	.get_chip_ident = sd_chip_ident,
 #endif
+#ifdef CONFIG_INPUT
+	.int_pkt_scan = sd_int_pkt_scan,
+#endif
 };

 /* -- module initialisation -- */
