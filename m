Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46553 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760189Ab2ILPhz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 11:37:55 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/5] af9035: declare MODULE_FIRMWARE
Date: Wed, 12 Sep 2012 18:37:26 +0300
Message-Id: <1347464249-23728-2-git-send-email-crope@iki.fi>
In-Reply-To: <1347464249-23728-1-git-send-email-crope@iki.fi>
References: <1347464249-23728-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 6 ++++--
 drivers/media/usb/dvb-usb-v2/af9035.h | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index fdec3b1..3c6d82e 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -994,7 +994,7 @@ static const struct dvb_usb_device_properties af9035_props = {
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
 	.identify_state = af9035_identify_state,
-	.firmware = "dvb-usb-af9035-02.fw",
+	.firmware = AF9035_FIRMWARE_AF9035,
 	.download_firmware = af9035_download_firmware,
 
 	.i2c_algo = &af9035_i2c_algo,
@@ -1024,7 +1024,7 @@ static const struct dvb_usb_device_properties it9135_props = {
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
 	.identify_state = af9035_identify_state,
-	.firmware = "dvb-usb-it9135-01.fw",
+	.firmware = AF9035_FIRMWARE_IT9135,
 	.download_firmware = af9035_download_firmware_it9135,
 
 	.i2c_algo = &af9035_i2c_algo,
@@ -1088,3 +1088,5 @@ module_usb_driver(af9035_usb_driver);
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Afatech AF9035 driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(AF9035_FIRMWARE_AF9035);
+MODULE_FIRMWARE(AF9035_FIRMWARE_IT9135);
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 59ff69e..de8e761 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -84,6 +84,9 @@ u32 clock_lut_it9135[] = {
 	22000000, /* 22.00 MHz */
 };
 
+#define AF9035_FIRMWARE_AF9035 "dvb-usb-af9035-02.fw"
+#define AF9035_FIRMWARE_IT9135 "dvb-usb-it9135-01.fw"
+
 /* EEPROM locations */
 #define EEPROM_IR_MODE            0x430d
 #define EEPROM_DUAL_MODE          0x4326
-- 
1.7.11.4

