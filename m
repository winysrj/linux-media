Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36224 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab1APA7F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 19:59:05 -0500
Received: by wwi17 with SMTP id 17so959984wwi.1
        for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 16:59:03 -0800 (PST)
Subject: [PATCH][BUG FIX for 2.6.38] DM04/QQBOX memcpy to const char fix.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 00:58:57 +0000
Message-ID: <1295139537.28044.20.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Driver Version v1.75
Kernel oops appears in 2.6.37-rc8 in lme_firmware_switch because of a memcpy to a const char.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>





diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 9eea418..46ccd01 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -659,7 +659,7 @@ static int lme2510_download_firmware(struct usb_device *dev,
 }
 
 /* Default firmware for LME2510C */
-const char lme_firmware[50] = "dvb-usb-lme2510c-s7395.fw";
+char lme_firmware[50] = "dvb-usb-lme2510c-s7395.fw";
 
 static void lme_coldreset(struct usb_device *dev)
 {
@@ -1006,7 +1006,7 @@ static struct dvb_usb_device_properties lme2510c_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = DEVICE_SPECIFIC,
 	.download_firmware = lme2510_download_firmware,
-	.firmware = lme_firmware,
+	.firmware = (const char *)&lme_firmware,
 	.size_of_priv = sizeof(struct lme2510_state),
 	.num_adapters = 1,
 	.adapter = {
@@ -1109,5 +1109,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.74");
+MODULE_VERSION("1.75");
 MODULE_LICENSE("GPL");

