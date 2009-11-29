Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:61548 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbZK2KYt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 05:24:49 -0500
Message-ID: <4B124BF4.3080809@freemail.hu>
Date: Sun, 29 Nov 2009 11:24:52 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca main: remove unnecessary set to alternate 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Calling gspca_set_alt0() in gspca_dev_probe() is not needed as gspca_set_alt0()
will do nothing because gspca_dev->alt is always zero at that time.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 064a82aa2daa linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Thu Nov 26 19:36:40 2009 +0100
+++ b/linux/drivers/media/video/gspca/gspca.c	Sun Nov 29 11:14:23 2009 +0100
@@ -2066,9 +2060,6 @@
 	ret = sd_desc->init(gspca_dev);
 	if (ret < 0)
 		goto out;
-	ret = gspca_set_alt0(gspca_dev);
-	if (ret < 0)
-		goto out;
 	gspca_set_default_mode(gspca_dev);

 	mutex_init(&gspca_dev->usb_lock);
