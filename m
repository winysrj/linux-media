Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:54227 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbZJCHfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 03:35:41 -0400
Message-ID: <4AC6FECF.7050906@freemail.hu>
Date: Sat, 03 Oct 2009 09:35:43 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>
CC: V4L Mailing List <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] pac7311: remove magic values for END_OF_SEQUENCE and
 LOAD_PAGE{3,4}
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Change the magic values 0, 254 and 255 to END_OF_SEQUENCE, LOAD_PAGE4 and
LOAD_PAGE3 respectively for better source code readability.

The change was tested with Labtec Webcam 2200.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr b/drivers/media/video/gspca/pac7311.c c/drivers/media/video/gspca/pac7311.c
--- b/drivers/media/video/gspca/pac7311.c	2009-10-03 08:27:36.000000000 +0200
+++ c/drivers/media/video/gspca/pac7311.c	2009-10-03 08:47:30.000000000 +0200
@@ -244,6 +244,10 @@ static const struct v4l2_pix_format vga_
 		.priv = 0},
 };

+#define LOAD_PAGE3		255
+#define LOAD_PAGE4		254
+#define END_OF_SEQUENCE		0
+
 /* pac 7302 */
 static const __u8 init_7302[] = {
 /*	index,value */
@@ -302,7 +306,7 @@ static const __u8 start_7302[] = {
 	0xff, 1,	0x02,		/* page 2 */
 	0x22, 1,	0x00,
 	0xff, 1,	0x03,		/* page 3 */
-	0x00, 255,			/* load the page 3 */
+	0, LOAD_PAGE3,			/* load the page 3 */
 	0x11, 1,	0x01,
 	0xff, 1,	0x02,		/* page 2 */
 	0x13, 1,	0x00,
@@ -313,7 +317,7 @@ static const __u8 start_7302[] = {
 	0x6e, 1,	0x08,
 	0xff, 1,	0x01,		/* page 1 */
 	0x78, 1,	0x00,
-	0, 0				/* end of sequence */
+	0, END_OF_SEQUENCE		/* end of sequence */
 };

 #define SKIP		0xaa
@@ -379,9 +383,9 @@ static const __u8 start_7311[] = {
 	0xf0, 13,	0x01, 0x00, 0x00, 0x00, 0x22, 0x00, 0x20, 0x00,
 			0x3f, 0x00, 0x0a, 0x01, 0x00,
 	0xff, 1,	0x04,		/* page 4 */
-	0x00, 254,			/* load the page 4 */
+	0, LOAD_PAGE4,			/* load the page 4 */
 	0x11, 1,	0x01,
-	0, 0				/* end of sequence */
+	0, END_OF_SEQUENCE		/* end of sequence */
 };

 /* page 4 - the value SKIP says skip the index - see reg_w_page() */
@@ -461,12 +465,12 @@ static void reg_w_var(struct gspca_dev *
 		index = *seq++;
 		len = *seq++;
 		switch (len) {
-		case 0:
+		case END_OF_SEQUENCE:
 			return;
-		case 254:
+		case LOAD_PAGE4:
 			reg_w_page(gspca_dev, page4_7311, sizeof page4_7311);
 			break;
-		case 255:
+		case LOAD_PAGE3:
 			reg_w_page(gspca_dev, page3_7302, sizeof page3_7302);
 			break;
 		default:
