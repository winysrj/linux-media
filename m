Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33200 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754713AbcKLKey (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 05:34:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 9/9] af9035: correct demod i2c addresses
Date: Sat, 12 Nov 2016 12:34:01 +0200
Message-Id: <1478946841-2807-9-git-send-email-crope@iki.fi>
In-Reply-To: <1478946841-2807-1-git-send-email-crope@iki.fi>
References: <1478946841-2807-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Chip uses so called 8-bit i2c addresses, but on bus there is of
course correct 7-bit addresses with rw bit as lsb - verified
with oscilloscope.

Lets still use correct addresses in driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index da29b6f..166ce09 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -772,9 +772,9 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 		/* tell the slave I2C address */
 		tmp = state->eeprom[EEPROM_2ND_DEMOD_ADDR];
 
-		/* use default I2C address if eeprom has no address set */
+		/* Use default I2C address if eeprom has no address set */
 		if (!tmp)
-			tmp = 0x3a;
+			tmp = 0x1d << 1; /* 8-bit format used by chip */
 
 		if ((state->chip_type == 0x9135) ||
 				(state->chip_type == 0x9306)) {
@@ -837,9 +837,9 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	u8 tmp;
 	u16 tmp16;
 
-	/* demod I2C "address" */
-	state->af9033_i2c_addr[0] = 0x38;
-	state->af9033_i2c_addr[1] = 0x3a;
+	/* Demod I2C address */
+	state->af9033_i2c_addr[0] = 0x1c;
+	state->af9033_i2c_addr[1] = 0x1d;
 	state->af9033_config[0].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 	state->af9033_config[1].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 	state->af9033_config[0].ts_mode = AF9033_TS_MODE_USB;
@@ -878,12 +878,13 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	state->ir_type = state->eeprom[EEPROM_IR_TYPE];
 
 	if (state->dual_mode) {
-		/* read 2nd demodulator I2C address */
+		/* Read 2nd demodulator I2C address. 8-bit format on eeprom */
 		tmp = state->eeprom[EEPROM_2ND_DEMOD_ADDR];
 		if (tmp)
-			state->af9033_i2c_addr[1] = tmp;
+			state->af9033_i2c_addr[1] = tmp >> 1;
 
-		dev_dbg(&intf->dev, "2nd demod I2C addr=%02x\n", tmp);
+		dev_dbg(&intf->dev, "2nd demod I2C addr=%02x\n",
+			state->af9033_i2c_addr[1]);
 	}
 
 	for (i = 0; i < state->dual_mode + 1; i++) {
-- 
http://palosaari.fi/

