Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38704 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbbEEV7A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:59:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/21] af9035: bind tua9001 using I2C binding
Date: Wed,  6 May 2015 00:58:31 +0300
Message-Id: <1430863122-9888-10-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change tua9001 driver from media binding to I2C client binding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index ae72357..cd88597 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1234,10 +1234,6 @@ static int af9035_frontend_detach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
-static struct tua9001_config af9035_tua9001_config = {
-	.i2c_addr = 0x60,
-};
-
 static const struct fc0011_config af9035_fc0011_config = {
 	.i2c_address = 0x60,
 };
@@ -1296,9 +1292,15 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	 */
 
 	switch (state->af9033_config[adap->id].tuner) {
-	case AF9033_TUNER_TUA9001:
-		/* AF9035 gpiot3 = TUA9001 RESETN
-		   AF9035 gpiot2 = TUA9001 RXEN */
+	case AF9033_TUNER_TUA9001: {
+		struct tua9001_platform_data tua9001_pdata = {
+			.dvb_frontend = adap->fe[0],
+		};
+
+		/*
+		 * AF9035 gpiot3 = TUA9001 RESETN
+		 * AF9035 gpiot2 = TUA9001 RXEN
+		 */
 
 		/* configure gpiot2 and gpiot2 as output */
 		ret = af9035_wr_reg_mask(d, 0x00d8ec, 0x01, 0x01);
@@ -1318,9 +1320,14 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 			goto err;
 
 		/* attach tuner */
-		fe = dvb_attach(tua9001_attach, adap->fe[0],
-				&d->i2c_adap, &af9035_tua9001_config);
+		ret = af9035_add_i2c_dev(d, "tua9001", 0x60, &tua9001_pdata,
+					 &d->i2c_adap);
+		if (ret)
+			goto err;
+
+		fe = adap->fe[0];
 		break;
+	}
 	case AF9033_TUNER_FC0011:
 		fe = dvb_attach(fc0011_attach, adap->fe[0],
 				&d->i2c_adap, &af9035_fc0011_config);
@@ -1615,6 +1622,7 @@ static int af9035_tuner_detach(struct dvb_usb_adapter *adap)
 	dev_dbg(&d->udev->dev, "%s: adap->id=%d\n", __func__, adap->id);
 
 	switch (state->af9033_config[adap->id].tuner) {
+	case AF9033_TUNER_TUA9001:
 	case AF9033_TUNER_FC2580:
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
-- 
http://palosaari.fi/

