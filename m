Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43632 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2ABSti (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 13:49:38 -0500
Received: by wgbdr13 with SMTP id dr13so26888274wgb.1
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 10:49:37 -0800 (PST)
Message-ID: <1325530168.32180.11.camel@tvbox>
Subject: [PATCH][BUG] it913x ver 1.21 Fixed for issue with 9006 and warm
 boot.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 02 Jan 2012 18:49:28 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Some channels appear weak signal after warm boot.

Because tuner id is not present in eprom 0x38 is
assigned.

9006 devices are now always assigned 0x60.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index ad7013c..4db9124 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -395,9 +395,10 @@ static int ite_firmware_select(struct usb_device *udev,
 			USB_PID_ITETECH_IT9135_9005)
 		sw = IT9135_V1_FW;
 	else if (le16_to_cpu(udev->descriptor.idProduct) ==
-			USB_PID_ITETECH_IT9135_9006)
+			USB_PID_ITETECH_IT9135_9006) {
 		sw = IT9135_V2_FW;
-	else
+		it913x_config.tuner_id_0 = 0x60;
+	} else
 		sw = IT9137_FW;
 
 	/* force switch */
@@ -840,5 +841,5 @@ module_exit(it913x_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.20");
+MODULE_VERSION("1.21");
 MODULE_LICENSE("GPL");
-- 
1.7.7.3


