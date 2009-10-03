Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:54219 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbZJCHfd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 03:35:33 -0400
Message-ID: <4AC6FEC5.4000808@freemail.hu>
Date: Sat, 03 Oct 2009 09:35:33 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>
CC: V4L Mailing List <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] pac7311: remove magic value for SKIP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Change the magic value 0xaa to SKIP for better understandability.

The change was tested with Labtec Webcam 2200.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr a/drivers/media/video/gspca/pac7311.c b/drivers/media/video/gspca/pac7311.c
--- a/drivers/media/video/gspca/pac7311.c	2009-09-28 17:40:19.000000000 +0200
+++ b/drivers/media/video/gspca/pac7311.c	2009-10-03 08:27:36.000000000 +0200
@@ -316,7 +316,8 @@ static const __u8 start_7302[] = {
 	0, 0				/* end of sequence */
 };

-/* page 3 - the value 0xaa says skip the index - see reg_w_page() */
+#define SKIP		0xaa
+/* page 3 - the value SKIP says skip the index - see reg_w_page() */
 static const __u8 page3_7302[] = {
 	0x90, 0x40, 0x03, 0x50, 0xc2, 0x01, 0x14, 0x16,
 	0x14, 0x12, 0x00, 0x00, 0x00, 0x02, 0x33, 0x00,
@@ -383,13 +384,13 @@ static const __u8 start_7311[] = {
 	0, 0				/* end of sequence */
 };

-/* page 4 - the value 0xaa says skip the index - see reg_w_page() */
+/* page 4 - the value SKIP says skip the index - see reg_w_page() */
 static const __u8 page4_7311[] = {
-	0xaa, 0xaa, 0x04, 0x54, 0x07, 0x2b, 0x09, 0x0f,
-	0x09, 0x00, 0xaa, 0xaa, 0x07, 0x00, 0x00, 0x62,
-	0x08, 0xaa, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x03, 0xa0, 0x01, 0xf4, 0xaa,
-	0xaa, 0x00, 0x08, 0xaa, 0x03, 0xaa, 0x00, 0x68,
+	SKIP, SKIP, 0x04, 0x54, 0x07, 0x2b, 0x09, 0x0f,
+	0x09, 0x00, SKIP, SKIP, 0x07, 0x00, 0x00, 0x62,
+	0x08, SKIP, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x03, 0xa0, 0x01, 0xf4, SKIP,
+	SKIP, 0x00, 0x08, SKIP, 0x03, SKIP, 0x00, 0x68,
 	0xca, 0x10, 0x06, 0x78, 0x00, 0x00, 0x00, 0x00,
 	0x23, 0x28, 0x04, 0x11, 0x00, 0x00
 };
@@ -438,7 +439,7 @@ static void reg_w_page(struct gspca_dev
 	int index;

 	for (index = 0; index < len; index++) {
-		if (page[index] == 0xaa)		/* skip this index */
+		if (page[index] == SKIP)		/* skip this index */
 			continue;
 		gspca_dev->usb_buf[0] = page[index];
 		usb_control_msg(gspca_dev->dev,
