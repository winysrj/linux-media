Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37322 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051AbaIDChB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Bimow Chen <Bimow.Chen@ite.com.tw>
Subject: [PATCH 02/37] af9035: enable AF9033 demod clock source for IT9135
Date: Thu,  4 Sep 2014 05:36:10 +0300
Message-Id: <1409798205-25645-2-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Integrated RF tuner of IT9135 is connected to demod clock source
named dyn0_clk. Enable that clock source in order to provide stable
clock early enough.

Cc: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index c82beac..8ac0423 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -647,16 +647,19 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	state->af9033_config[0].ts_mode = AF9033_TS_MODE_USB;
 	state->af9033_config[1].ts_mode = AF9033_TS_MODE_SERIAL;
 
-	/* eeprom memory mapped location */
 	if (state->chip_type == 0x9135) {
+		/* feed clock for integrated RF tuner */
+		state->af9033_config[0].dyn0_clk = true;
+		state->af9033_config[1].dyn0_clk = true;
+
 		if (state->chip_version == 0x02) {
 			state->af9033_config[0].tuner = AF9033_TUNER_IT9135_60;
 			state->af9033_config[1].tuner = AF9033_TUNER_IT9135_60;
-			tmp16 = 0x00461d;
+			tmp16 = 0x00461d; /* eeprom memory mapped location */
 		} else {
 			state->af9033_config[0].tuner = AF9033_TUNER_IT9135_38;
 			state->af9033_config[1].tuner = AF9033_TUNER_IT9135_38;
-			tmp16 = 0x00461b;
+			tmp16 = 0x00461b; /* eeprom memory mapped location */
 		}
 
 		/* check if eeprom exists */
-- 
http://palosaari.fi/

