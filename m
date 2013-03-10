Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55355 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab3CJCEl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 26/41] af9035: set demod TS mode config in read_config()
Date: Sun, 10 Mar 2013 04:03:18 +0200
Message-Id: <1362881013-5271-26-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index a29169f..7f87b01 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -588,6 +588,8 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	state->af9033_config[0].i2c_addr = 0x38;
 	state->af9033_config[0].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 	state->af9033_config[1].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
+	state->af9033_config[0].ts_mode = AF9033_TS_MODE_USB;
+	state->af9033_config[1].ts_mode = AF9033_TS_MODE_SERIAL;
 
 	/* eeprom memory mapped location */
 	if (state->chip_type == 0x9135) {
@@ -903,11 +905,6 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 		goto err;
 	}
 
-	if (adap->id == 0) {
-		state->af9033_config[0].ts_mode = AF9033_TS_MODE_USB;
-		state->af9033_config[1].ts_mode = AF9033_TS_MODE_SERIAL;
-	}
-
 	/* attach demodulator */
 	adap->fe[0] = dvb_attach(af9033_attach, &state->af9033_config[adap->id],
 			&d->i2c_adap);
-- 
1.7.11.7

