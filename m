Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62789 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab1BMXMV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 18:12:21 -0500
Received: by wyb28 with SMTP id 28so4190173wyb.19
        for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 15:12:20 -0800 (PST)
Subject: [PATCH] DM04/QQBOX Fix issue with firmware release and cold reset
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Feb 2011 23:12:15 +0000
Message-ID: <1297638735.5123.8.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fix issue where firmware does not release on cold reset.
Also, default firmware never cold resets in multi tuner
environment.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index cd26e7c..ec0f5a7 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -747,7 +747,7 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
 			fw_lme = fw_s0194;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
 			if (ret == 0) {
-				cold = 0;/*lme2510-s0194 cannot cold reset*/
+				cold = 0;
 				break;
 			}
 			dvb_usb_lme2510_firmware = TUNER_LG;
@@ -769,8 +769,10 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
 		case TUNER_S7395:
 			fw_lme = fw_c_s7395;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
-			if (ret == 0)
+			if (ret == 0) {
+				cold = 0;
 				break;
+			}
 			dvb_usb_lme2510_firmware = TUNER_LG;
 		case TUNER_LG:
 			fw_lme = fw_c_lg;
@@ -796,14 +798,14 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
 		ret = lme2510_download_firmware(udev, fw);
 	}
 
+	release_firmware(fw);
+
 	if (cold) {
 		info("FRM Changing to %s firmware", fw_lme);
 		lme_coldreset(udev);
 		return -ENODEV;
 	}
 
-	release_firmware(fw);
-
 	return ret;
 }
 
@@ -1220,5 +1222,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.80");
+MODULE_VERSION("1.81");
 MODULE_LICENSE("GPL");
-- 
1.7.1

