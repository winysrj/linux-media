Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:56857 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZKGH1Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 02:27:24 -0500
Message-ID: <4AF5215E.8090601@freemail.hu>
Date: Sat, 07 Nov 2009 08:27:26 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca pac7302: remove redundant stream off command
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The stream off command is sent to the device twice, one is enough.

The patch was tested together with Labtec Webcam 2200 (USB ID 093a:2626).

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 40705fec2fb2 linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Fri Nov 06 15:54:49 2009 -0200
+++ b/linux/drivers/media/video/gspca/pac7302.c	Sat Nov 07 08:21:19 2009 +0100
@@ -627,8 +627,8 @@

 static void sd_stopN(struct gspca_dev *gspca_dev)
 {
+	/* stop stream */
 	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x00);
 	reg_w(gspca_dev, 0x78, 0x00);
 }

