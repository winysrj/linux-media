Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57172 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbbEEV67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:58:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/21] af9035: bind fc2580 using I2C binding
Date: Wed,  6 May 2015 00:58:24 +0300
Message-Id: <1430863122-9888-3-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change fc2580 driver from media binding to I2C client binding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 80a29f5..558166d 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1265,11 +1265,6 @@ static struct tda18218_config af9035_tda18218_config = {
 	.i2c_wr_max = 21,
 };
 
-static const struct fc2580_config af9035_fc2580_config = {
-	.i2c_addr = 0x56,
-	.clock = 16384000,
-};
-
 static const struct fc0012_config af9035_fc0012_config[] = {
 	{
 		.i2c_address = 0x63,
@@ -1390,7 +1385,11 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 		fe = dvb_attach(tda18218_attach, adap->fe[0],
 				&d->i2c_adap, &af9035_tda18218_config);
 		break;
-	case AF9033_TUNER_FC2580:
+	case AF9033_TUNER_FC2580: {
+		struct fc2580_platform_data fc2580_pdata = {
+			.dvb_frontend = adap->fe[0],
+		};
+
 		/* Tuner enable using gpiot2_o, gpiot2_en and gpiot2_on  */
 		ret = af9035_wr_reg_mask(d, 0xd8eb, 0x01, 0x01);
 		if (ret < 0)
@@ -1406,9 +1405,14 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 
 		usleep_range(10000, 50000);
 		/* attach tuner */
-		fe = dvb_attach(fc2580_attach, adap->fe[0],
-				&d->i2c_adap, &af9035_fc2580_config);
+		ret = af9035_add_i2c_dev(d, "fc2580", 0x56, &fc2580_pdata,
+					 &d->i2c_adap);
+		if (ret)
+			goto err;
+
+		fe = adap->fe[0];
 		break;
+	}
 	case AF9033_TUNER_FC0012:
 		/*
 		 * AF9035 gpiot2 = FC0012 enable
@@ -1611,6 +1615,7 @@ static int af9035_tuner_detach(struct dvb_usb_adapter *adap)
 	dev_dbg(&d->udev->dev, "%s: adap->id=%d\n", __func__, adap->id);
 
 	switch (state->af9033_config[adap->id].tuner) {
+	case AF9033_TUNER_FC2580:
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
 	case AF9033_TUNER_IT9135_52:
-- 
http://palosaari.fi/

