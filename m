Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52239 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab3CJCEm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:42 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 28/41] af9035: change dual mode boolean to bit field
Date: Sun, 10 Mar 2013 04:03:20 +0200
Message-Id: <1362881013-5271-28-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For some reason there seems to be value	0x03 in eeprom for dual mode
(and 0x00 for single mode). Boolean is not always 1 bit wide - it
could be 8 bit wide too. Storing number 0x03 to boolean causes driver
to thing there is 4 tuners in some cases :o

Add also some comments regarding to eeprom.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 59843c7..d934a18 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -57,7 +57,7 @@ struct state {
 	u8 prechip_version;
 	u8 chip_version;
 	u16 chip_type;
-	bool dual_mode;
+	u8 dual_mode:1;
 	u16 eeprom_addr;
 	struct af9033_config af9033_config[2];
 };
@@ -94,6 +94,14 @@ static const u32 clock_lut_it9135[] = {
 #define AF9035_FIRMWARE_IT9135_V1 "dvb-usb-it9135-01.fw"
 #define AF9035_FIRMWARE_IT9135_V2 "dvb-usb-it9135-02.fw"
 
+/*
+ * eeprom is memory mapped as read only. Writing that memory mapped address
+ * will not corrupt eeprom.
+ *
+ * eeprom has value 0x00 single mode and 0x03 for dual mode as far as I have
+ * seen to this day.
+ */
+
 #define EEPROM_BASE_AF9035        0x42fd
 #define EEPROM_BASE_IT9135        0x499c
 #define EEPROM_SHIFT                0x10
-- 
1.7.11.7

