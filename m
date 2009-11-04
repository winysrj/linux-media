Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:54806 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbZKDWim (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 17:38:42 -0500
Message-ID: <4AF20272.7040104@freemail.hu>
Date: Wed, 04 Nov 2009 23:38:42 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca pac7302/pac7311: fix buffer overrun
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The reg_w_seq() function expects the sequence length in entries
and not in bytes. One entry in init_7302 and init_7311 is two
bytes and not one.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr a/drivers/media/video/gspca/pac7302.c b/drivers/media/video/gspca/pac7302.c
--- a/drivers/media/video/gspca/pac7302.c	2009-11-05 00:31:36.000000000 +0100
+++ b/drivers/media/video/gspca/pac7302.c	2009-11-05 00:32:50.000000000 +0100
@@ -592,7 +592,7 @@ static void sethvflip(struct gspca_dev *
 /* this function is called at probe and resume time for pac7302 */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
-	reg_w_seq(gspca_dev, init_7302, sizeof init_7302);
+	reg_w_seq(gspca_dev, init_7302, sizeof(init_7302)/2);

 	return 0;
 }
diff -upr a/drivers/media/video/gspca/pac7311.c b/drivers/media/video/gspca/pac7311.c
--- a/drivers/media/video/gspca/pac7311.c	2009-11-04 23:28:31.000000000 +0100
+++ b/drivers/media/video/gspca/pac7311.c	2009-11-05 00:33:08.000000000 +0100
@@ -490,7 +490,7 @@ static void sethvflip(struct gspca_dev *
 /* this function is called at probe and resume time for pac7311 */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
-	reg_w_seq(gspca_dev, init_7311, sizeof init_7311);
+	reg_w_seq(gspca_dev, init_7311, sizeof(init_7311)/2);

 	return 0;
 }
