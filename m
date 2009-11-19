Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:63673 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbZKSHqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 02:46:46 -0500
Message-ID: <4B04F7EA.4020804@freemail.hu>
Date: Thu, 19 Nov 2009 08:46:50 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [RFC, PATCH 2/2] gspca pac7302: add support for camera button
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Add support for snapshot button found on Labtec Webcam 2200.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 182b5f8fa160 linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Sun Nov 15 10:05:30 2009 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	Thu Nov 19 08:36:01 2009 +0100
@@ -68,8 +68,10 @@

 #define MODULE_NAME "pac7302"

+#include <linux/input.h>
 #include <media/v4l2-chip-ident.h>
 #include "gspca.h"
+#include "input.h"

 MODULE_AUTHOR("Thomas Kaiser thomas@kaiser-linux.li");
 MODULE_DESCRIPTION("Pixart PAC7302");
@@ -1220,6 +1222,36 @@
 }
 #endif

+static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
+			u8 *data,			/* interrupt packet data */
+			int len)			/* interrput packet length */
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
+
+
 /* sub-driver description for pac7302 */
 static struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
@@ -1236,6 +1268,7 @@
 	.set_register = sd_dbg_s_register,
 	.get_chip_ident = sd_chip_ident,
 #endif
+	.int_pkt_scan = sd_int_pkt_scan,
 };

 /* -- module initialisation -- */
