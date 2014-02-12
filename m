Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41389 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbaBLTqc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 14:46:32 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 4/4] af9035: use default i2c slave address for af9035 too
Date: Wed, 12 Feb 2014 21:46:18 +0200
Message-Id: <1392234378-20959-4-git-send-email-crope@iki.fi>
In-Reply-To: <1392234378-20959-1-git-send-email-crope@iki.fi>
References: <1392234378-20959-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some device vendors has forgotten set correct slave demod I2C address
to eeprom. Use default I2C address when eeprom has no address at all.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 49e8360..1434d37 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -575,11 +575,11 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 		if (ret < 0)
 			goto err;
 
-		if (state->chip_type == 0x9135) {
-			if (!tmp)
-				/* default 0x9135 slave I2C address */
-				tmp = 0x3a;
+		/* use default I2C address if eeprom has no address set */
+		if (!tmp)
+			tmp = 0x3a;
 
+		if (state->chip_type == 0x9135) {
 			ret = af9035_wr_reg(d, 0x004bfb, tmp);
 			if (ret < 0)
 				goto err;
@@ -641,6 +641,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 
 	/* demod I2C "address" */
 	state->af9033_config[0].i2c_addr = 0x38;
+	state->af9033_config[1].i2c_addr = 0x3a;
 	state->af9033_config[0].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 	state->af9033_config[1].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 	state->af9033_config[0].ts_mode = AF9033_TS_MODE_USB;
@@ -688,11 +689,9 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		if (ret < 0)
 			goto err;
 
-		if (!tmp && state->chip_type == 0x9135)
-			/* default 0x9135 slave I2C address */
-			tmp = 0x3a;
+		if (tmp)
+			state->af9033_config[1].i2c_addr = tmp;
 
-		state->af9033_config[1].i2c_addr = tmp;
 		dev_dbg(&d->udev->dev, "%s: 2nd demod I2C addr=%02x\n",
 				__func__, tmp);
 	}
-- 
1.8.5.3

