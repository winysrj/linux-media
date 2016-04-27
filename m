Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56109 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbcD0ULV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 16:11:21 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9035: correct eeprom offsets
Date: Wed, 27 Apr 2016 23:10:59 +0300
Message-Id: <1461787859-6921-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Used memory mapped eeprom offsets were off-by 8 bytes.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index df22001..89e629a 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -118,20 +118,20 @@ static const u32 clock_lut_it9135[] = {
  * Values 0, 3 and 5 are seen to this day. 0 for single TS and 3/5 for dual TS.
  */
 
-#define EEPROM_BASE_AF9035        0x42fd
-#define EEPROM_BASE_IT9135        0x499c
+#define EEPROM_BASE_AF9035        0x42f5
+#define EEPROM_BASE_IT9135        0x4994
 #define EEPROM_SHIFT                0x10
 
-#define EEPROM_IR_MODE              0x10
-#define EEPROM_TS_MODE              0x29
-#define EEPROM_2ND_DEMOD_ADDR       0x2a
-#define EEPROM_IR_TYPE              0x2c
-#define EEPROM_1_IF_L               0x30
-#define EEPROM_1_IF_H               0x31
-#define EEPROM_1_TUNER_ID           0x34
-#define EEPROM_2_IF_L               0x40
-#define EEPROM_2_IF_H               0x41
-#define EEPROM_2_TUNER_ID           0x44
+#define EEPROM_IR_MODE              0x18
+#define EEPROM_TS_MODE              0x31
+#define EEPROM_2ND_DEMOD_ADDR       0x32
+#define EEPROM_IR_TYPE              0x34
+#define EEPROM_1_IF_L               0x38
+#define EEPROM_1_IF_H               0x39
+#define EEPROM_1_TUNER_ID           0x3c
+#define EEPROM_2_IF_L               0x48
+#define EEPROM_2_IF_H               0x49
+#define EEPROM_2_TUNER_ID           0x4c
 
 /* USB commands */
 #define CMD_MEM_RD                  0x00
-- 
http://palosaari.fi/

