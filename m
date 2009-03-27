Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35516 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZC0QHF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 12:07:05 -0400
Received: by fxm2 with SMTP id 2so1090902fxm.37
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2009 09:07:02 -0700 (PDT)
Subject: [patch review] gspca - mr97310a: return error instead of -1 in
 sd_mod_init
From: Alexey Klimov <klimov.linux@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Fri, 27 Mar 2009 19:08:22 +0300
Message-Id: <1238170102.3791.8.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Jean-Francois

What do you think about such small cleanup ?

---
Patch reformats sd_mod_init in the way to make it return error code from
usb_register instead of -1.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 56cf0f1772f7 linux/drivers/media/video/gspca/mr97310a.c
--- a/linux/drivers/media/video/gspca/mr97310a.c	Mon Mar 23 19:18:34 2009 -0300
+++ b/linux/drivers/media/video/gspca/mr97310a.c	Fri Mar 27 01:42:28 2009 +0300
@@ -347,8 +347,10 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
-		return -1;
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }


-- 
Best regards, Klimov Alexey

