Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65021 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab0KDUSC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Nov 2010 16:18:02 -0400
Received: by wwb39 with SMTP id 39so536608wwb.1
        for <linux-media@vger.kernel.org>; Thu, 04 Nov 2010 13:18:01 -0700 (PDT)
Subject: [PATCH][UPDATE_for_2.6.37]  DM04/QQBOX USB Timing change.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 20:17:51 +0000
Message-ID: <1288901871.2467.10.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


DM04/QQBOX USB Timing change.

Improved timing to avoid USB corruptions on some systems.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>




diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 3a32c65..de7f1fb 100755
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -124,7 +124,7 @@ static int lme2510_bulk_write(struct usb_device *dev,
 	int ret, actual_l;
 
 	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, pipe),
-				snd, len , &actual_l, 500);
+				snd, len , &actual_l, 100);
 	return ret;
 }
 
@@ -134,7 +134,7 @@ static int lme2510_bulk_read(struct usb_device *dev,
 	int ret, actual_l;
 
 	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, pipe),
-				 rev, len , &actual_l, 500);
+				 rev, len , &actual_l, 200);
 	return ret;
 }
 
@@ -166,7 +166,7 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 
 	ret |= lme2510_bulk_write(d->udev, buff, wlen , 0x01);
 
-	msleep(12);
+	msleep(10);
 
 	ret |= usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x01));
 
@@ -1073,5 +1073,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LM2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.70");
+MODULE_VERSION("1.71");
 MODULE_LICENSE("GPL");

