Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:60376 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbZKHV3E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 16:29:04 -0500
Message-ID: <4AF73817.1030605@freemail.hu>
Date: Sun, 08 Nov 2009 22:28:55 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca pac7311: stop sending URBs on first error
References: <4AF6BA5C.9030304@freemail.hu>
In-Reply-To: <4AF6BA5C.9030304@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

It is no use to continue sending URBs if one of them already
failed.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
The patch is based on 13335:3fd924da7091 from http://linuxtv.org/hg/~jfrancois/gspca/ .
---
diff -r 3fd924da7091 linux/drivers/media/video/gspca/pac7311.c
--- a/linux/drivers/media/video/gspca/pac7311.c	Sun Nov 08 08:41:28 2009 +0100
+++ b/linux/drivers/media/video/gspca/pac7311.c	Sun Nov 08 23:14:13 2009 +0100
@@ -590,16 +590,27 @@

 static void sd_stopN(struct gspca_dev *gspca_dev)
 {
-	reg_w(gspca_dev, 0xff, 0x04);
-	reg_w(gspca_dev, 0x27, 0x80);
-	reg_w(gspca_dev, 0x28, 0xca);
-	reg_w(gspca_dev, 0x29, 0x53);
-	reg_w(gspca_dev, 0x2a, 0x0e);
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x3e, 0x20);
-	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
-	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
-	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
+	int ret;
+
+	ret = reg_w(gspca_dev, 0xff, 0x04);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x27, 0x80);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x28, 0xca);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x29, 0x53);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x2a, 0x0e);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xff, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x3e, 0x20);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
 }

 /* called on streamoff with alt 0 and on disconnect for 7311 */
