Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48057 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2ACK1P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 05:27:15 -0500
Received: by wibhm6 with SMTP id hm6so8959016wib.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 02:27:14 -0800 (PST)
Message-ID: <1325586426.14924.6.camel@tvbox>
Subject: [PATCH] it913x ver 1.22 corrections to Tuner IDs
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Tue, 03 Jan 2012 10:27:06 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correction to tuner ID 0x51.

Don't force tuner ID 0x60 unless eprom data zero.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c      |    5 +++--
 drivers/media/dvb/frontends/it913x-fe.h |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 4db9124..9addf6c 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -397,7 +397,8 @@ static int ite_firmware_select(struct usb_device *udev,
 	else if (le16_to_cpu(udev->descriptor.idProduct) ==
 			USB_PID_ITETECH_IT9135_9006) {
 		sw = IT9135_V2_FW;
-		it913x_config.tuner_id_0 = 0x60;
+		if (it913x_config.tuner_id_0 == 0)
+			it913x_config.tuner_id_0 = IT9135_60;
 	} else
 		sw = IT9137_FW;
 
@@ -841,5 +842,5 @@ module_exit(it913x_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.21");
+MODULE_VERSION("1.22");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/frontends/it913x-fe.h b/drivers/media/dvb/frontends/it913x-fe.h
index 4143ef9..5ee3e2f 100644
--- a/drivers/media/dvb/frontends/it913x-fe.h
+++ b/drivers/media/dvb/frontends/it913x-fe.h
@@ -161,7 +161,7 @@ static inline struct dvb_frontend *it913x_fe_attach(
 /* Build in tuner types */
 #define IT9137 0x38
 #define IT9135_38 0x38
-#define IT9135_51 0x50
+#define IT9135_51 0x51
 #define IT9135_52 0x52
 #define IT9135_60 0x60
 #define IT9135_61 0x61
-- 
1.7.7.3



