Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46896 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760190Ab2ILPh4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 11:37:56 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/5] ec168: declare MODULE_FIRMWARE
Date: Wed, 12 Sep 2012 18:37:27 +0300
Message-Id: <1347464249-23728-3-git-send-email-crope@iki.fi>
In-Reply-To: <1347464249-23728-1-git-send-email-crope@iki.fi>
References: <1347464249-23728-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/ec168.c | 3 ++-
 drivers/media/usb/dvb-usb-v2/ec168.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/ec168.c b/drivers/media/usb/dvb-usb-v2/ec168.c
index b74c810..b6a9c5b 100644
--- a/drivers/media/usb/dvb-usb-v2/ec168.c
+++ b/drivers/media/usb/dvb-usb-v2/ec168.c
@@ -322,7 +322,7 @@ static struct dvb_usb_device_properties ec168_props = {
 	.bInterfaceNumber = 1,
 
 	.identify_state = ec168_identify_state,
-	.firmware = "dvb-usb-ec168.fw",
+	.firmware = EC168_FIRMWARE,
 	.download_firmware = ec168_download_firmware,
 
 	.i2c_algo = &ec168_i2c_algo,
@@ -374,3 +374,4 @@ module_usb_driver(ec168_driver);
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("E3C EC168 driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(EC168_FIRMWARE);
diff --git a/drivers/media/usb/dvb-usb-v2/ec168.h b/drivers/media/usb/dvb-usb-v2/ec168.h
index f651808..615a656 100644
--- a/drivers/media/usb/dvb-usb-v2/ec168.h
+++ b/drivers/media/usb/dvb-usb-v2/ec168.h
@@ -25,6 +25,7 @@
 #include "dvb_usb.h"
 
 #define EC168_USB_TIMEOUT 1000
+#define EC168_FIRMWARE "dvb-usb-ec168.fw"
 
 struct ec168_req {
 	u8  cmd;       /* [1] */
-- 
1.7.11.4

