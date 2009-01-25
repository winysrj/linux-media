Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f10.google.com ([209.85.219.10]:39838 "EHLO
	mail-ew0-f10.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbZAYDnn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2009 22:43:43 -0500
Received: by ewy3 with SMTP id 3so325659ewy.13
        for <linux-media@vger.kernel.org>; Sat, 24 Jan 2009 19:43:41 -0800 (PST)
Subject: [patch review] em28xx: correct mailing list
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 06:36:33 +0300
Message-Id: <1232854594.21610.7.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all
I'm not sure is this patch really suitable.
But looks that main development mail-list moved to linux-media..

---
Correct mailing list in 3 places in em28xx-cards.c
Move to linux-media on vger.kernel.org.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
--
diff -r 6a6eb9efc6cd linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Fri Jan 23 22:35:12 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Sun Jan 25 06:28:10 2009 +0300
@@ -1679,7 +1679,7 @@
 			em28xx_errdev("If the board were missdetected, "
 				      "please email this log to:\n");
 			em28xx_errdev("\tV4L Mailing List "
-				      " <video4linux-list@redhat.com>\n");
+				      " <linux-media@vger.kernel.org>\n");
 			em28xx_errdev("Board detected as %s\n",
 				      em28xx_boards[dev->model].name);
 
@@ -1711,7 +1711,7 @@
 			em28xx_errdev("If the board were missdetected, "
 				      "please email this log to:\n");
 			em28xx_errdev("\tV4L Mailing List "
-				      " <video4linux-list@redhat.com>\n");
+				      " <linux-media@vger.kernel.org>\n");
 			em28xx_errdev("Board detected as %s\n",
 				      em28xx_boards[dev->model].name);
 
@@ -1724,7 +1724,7 @@
 	em28xx_errdev("You may try to use card=<n> insmod option to "
 		      "workaround that.\n");
 	em28xx_errdev("Please send an email with this log to:\n");
-	em28xx_errdev("\tV4L Mailing List <video4linux-list@redhat.com>\n");
+	em28xx_errdev("\tV4L Mailing List <linux-media@vger.kernel.org>\n");
 	em28xx_errdev("Board eeprom hash is 0x%08lx\n", dev->hash);
 	em28xx_errdev("Board i2c devicelist hash is 0x%08lx\n", dev->i2c_hash);
 


-- 
Best regards, Klimov Alexey

