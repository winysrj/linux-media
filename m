Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46064 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760188Ab2ILPhz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 11:37:55 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/5] af9015: declare MODULE_FIRMWARE
Date: Wed, 12 Sep 2012 18:37:25 +0300
Message-Id: <1347464249-23728-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 3 ++-
 drivers/media/usb/dvb-usb-v2/af9015.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 9afceed..d9d3030 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -1307,7 +1307,7 @@ static struct dvb_usb_device_properties af9015_props = {
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
 	.identify_state = af9015_identify_state,
-	.firmware = "dvb-usb-af9015.fw",
+	.firmware = AF9015_FIRMWARE,
 	.download_firmware = af9015_download_firmware,
 
 	.i2c_algo = &af9015_i2c_algo,
@@ -1433,3 +1433,4 @@ module_usb_driver(af9015_usb_driver);
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Afatech AF9015 driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(AF9015_FIRMWARE);
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.h b/drivers/media/usb/dvb-usb-v2/af9015.h
index c6b304d..35f946c 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.h
+++ b/drivers/media/usb/dvb-usb-v2/af9015.h
@@ -57,6 +57,8 @@
 #define warn(format, arg...) \
 	printk(KERN_WARNING DVB_USB_LOG_PREFIX ": " format "\n" , ## arg)
 
+#define AF9015_FIRMWARE "dvb-usb-af9015.fw"
+
 /* Windows driver uses packet count 21 for USB1.1 and 348 for USB2.0.
    We use smaller - about 1/4 from the original, 5 and 87. */
 #define TS_PACKET_SIZE            188
-- 
1.7.11.4

