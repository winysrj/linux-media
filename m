Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:62973 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbZK2KYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 05:24:30 -0500
Message-ID: <4B124BDF.50309@freemail.hu>
Date: Sun, 29 Nov 2009 11:24:31 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca main: reorganize loop
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Eliminate redundant code by reorganizing the loop.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 064a82aa2daa linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Thu Nov 26 19:36:40 2009 +0100
+++ b/linux/drivers/media/video/gspca/gspca.c	Sun Nov 29 11:09:33 2009 +0100
@@ -623,12 +623,12 @@
 		if (ret < 0)
 			goto out;
 	}
-	ep = get_ep(gspca_dev);
-	if (ep == NULL) {
-		ret = -EIO;
-		goto out;
-	}
 	for (;;) {
+		ep = get_ep(gspca_dev);
+		if (ep == NULL) {
+			ret = -EIO;
+			goto out;
+		}
 		PDEBUG(D_STREAM, "init transfer alt %d", gspca_dev->alt);
 		ret = create_urbs(gspca_dev, ep);
 		if (ret < 0)
@@ -677,12 +677,6 @@
 			ret = gspca_dev->sd_desc->isoc_nego(gspca_dev);
 			if (ret < 0)
 				goto out;
-		} else {
-			ep = get_ep(gspca_dev);
-			if (ep == NULL) {
-				ret = -EIO;
-				goto out;
-			}
 		}
 	}
 out:
