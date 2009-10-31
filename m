Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:52818 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383AbZJaXQl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:16:41 -0400
Message-ID: <4AECC558.2090909@freemail.hu>
Date: Sun, 01 Nov 2009 00:16:40 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 18/21] gspca pac7302/pac7311: generalize reg_w_var
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The original implementation of reg_w_var contains direct references to pac7302
and 7311 specific structures. Move these references to the parameter list.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN r/drivers/media/video/gspca/pac7311.c s/drivers/media/video/gspca/pac7311.c
--- r/drivers/media/video/gspca/pac7311.c	2009-10-31 09:07:56.000000000 +0100
+++ s/drivers/media/video/gspca/pac7311.c	2009-10-31 10:21:55.000000000 +0100
@@ -602,7 +602,9 @@ static void reg_w_page(struct gspca_dev

 /* output a variable sequence */
 static void reg_w_var(struct gspca_dev *gspca_dev,
-			const __u8 *seq)
+			const __u8 *seq,
+			const __u8 *page3, unsigned int page3_len,
+			const __u8 *page4, unsigned int page4_len)
 {
 	int index, len;

@@ -613,10 +615,10 @@ static void reg_w_var(struct gspca_dev *
 		case END_OF_SEQUENCE:
 			return;
 		case LOAD_PAGE4:
-			reg_w_page(gspca_dev, page4_7311, sizeof page4_7311);
+			reg_w_page(gspca_dev, page4, page4_len);
 			break;
 		case LOAD_PAGE3:
-			reg_w_page(gspca_dev, page3_7302, sizeof page3_7302);
+			reg_w_page(gspca_dev, page3, page3_len);
 			break;
 		default:
 			if (len > USB_BUF_SZ) {
@@ -874,7 +876,9 @@ static int pac7302_sd_start(struct gspca

 	sd->sof_read = 0;

-	reg_w_var(gspca_dev, start_7302);
+	reg_w_var(gspca_dev, start_7302,
+		page3_7302, sizeof(page3_7302),
+		NULL, 0);
 	pac7302_setbrightcont(gspca_dev);
 	pac7302_setcolors(gspca_dev);
 	pac7302_setgain(gspca_dev);
@@ -900,7 +904,9 @@ static int pac7311_sd_start(struct gspca

 	sd->sof_read = 0;

-	reg_w_var(gspca_dev, start_7311);
+	reg_w_var(gspca_dev, start_7311,
+		NULL, 0,
+		page4_7311, sizeof(page4_7311));
 	pac7311_setcontrast(gspca_dev);
 	pac7311_setgain(gspca_dev);
 	pac7311_setexposure(gspca_dev);
