Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33445 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2A1WCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Jan 2012 17:02:42 -0500
Received: by wics10 with SMTP id s10so2400186wic.19
        for <linux-media@vger.kernel.org>; Sat, 28 Jan 2012 14:02:40 -0800 (PST)
Message-ID: <1327788154.2826.2.camel@tvbox>
Subject: [PATCH] it913x ver 1.24 Make 0x60 default on version 2 devices.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 28 Jan 2012 22:02:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some version 2 devices have different tuner IDs. ID 0x38
appears to have weak signal strength.

Apply default 0x60 to unknown IDs.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 50d578c..c80098a 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -409,8 +409,15 @@ static int ite_firmware_select(struct usb_device *udev,
 		it913x_config.firmware_ver = 1;
 		it913x_config.adc_x2 = 1;
 		props->firmware = fw_it9135_v2;
-		if (it913x_config.tuner_id_0 == 0)
+		switch (it913x_config.tuner_id_0) {
+		case IT9135_61:
+		case IT9135_62:
+			break;
+		default:
+			info("Unknown tuner ID applying default 0x60");
+		case IT9135_60:
 			it913x_config.tuner_id_0 = IT9135_60;
+		}
 		break;
 	case IT9137_FW:
 	default:
@@ -818,5 +825,5 @@ module_usb_driver(it913x_driver);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.23");
+MODULE_VERSION("1.24");
 MODULE_LICENSE("GPL");
-- 
1.7.8.3


