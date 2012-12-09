Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59092 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758876Ab2LIT5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 08/17] af9035: add support for fc0012 dual tuner configuration
Date: Sun,  9 Dec 2012 21:56:19 +0200
Message-Id: <1355082988-6211-8-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That adds support for AF9035 dual devices having FC0012 tuners.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 56 +++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 6cf9ad5..1c7fe5a 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -597,6 +597,8 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		/* disable dual mode if driver does not support it */
 		if (i == 1)
 			switch (tmp) {
+			case AF9033_TUNER_FC0012:
+				break;
 			default:
 				state->dual_mode = false;
 				dev_info(&d->udev->dev, "%s: driver does not " \
@@ -900,10 +902,18 @@ static const struct fc2580_config af9035_fc2580_config = {
 	.clock = 16384000,
 };
 
-static const struct fc0012_config af9035_fc0012_config = {
-	.i2c_address = 0x63,
-	.xtal_freq = FC_XTAL_36_MHZ,
-	.dual_master = 1,
+static const struct fc0012_config af9035_fc0012_config[] = {
+	{
+		.i2c_address = 0x63,
+		.xtal_freq = FC_XTAL_36_MHZ,
+		.dual_master = 1,
+		.loop_through = true,
+		.clock_out = true,
+	}, {
+		.i2c_address = 0x63 | 0x80, /* I2C bus select hack */
+		.xtal_freq = FC_XTAL_36_MHZ,
+		.dual_master = 1,
+	}
 };
 
 static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
@@ -912,6 +922,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	int ret;
 	struct dvb_frontend *fe;
+	struct i2c_msg msg[1];
 	u8 tuner_addr;
 	/*
 	 * XXX: Hack used in that function: we abuse unused I2C address bit [7]
@@ -1034,23 +1045,38 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 		 * my test I didn't find any difference.
 		 */
 
-		/* configure gpiot2 as output and high */
-		ret = af9035_wr_reg_mask(d, 0xd8eb, 0x01, 0x01);
-		if (ret < 0)
-			goto err;
+		if (adap->id == 0) {
+			/* configure gpiot2 as output and high */
+			ret = af9035_wr_reg_mask(d, 0xd8eb, 0x01, 0x01);
+			if (ret < 0)
+				goto err;
 
-		ret = af9035_wr_reg_mask(d, 0xd8ec, 0x01, 0x01);
-		if (ret < 0)
-			goto err;
+			ret = af9035_wr_reg_mask(d, 0xd8ec, 0x01, 0x01);
+			if (ret < 0)
+				goto err;
 
-		ret = af9035_wr_reg_mask(d, 0xd8ed, 0x01, 0x01);
-		if (ret < 0)
-			goto err;
+			ret = af9035_wr_reg_mask(d, 0xd8ed, 0x01, 0x01);
+			if (ret < 0)
+				goto err;
+		} else {
+			/*
+			 * FIXME: That belongs for the FC0012 driver.
+			 * Write 02 to FC0012 master tuner register 0d directly
+			 * in order to make slave tuner working.
+			 */
+			msg[0].addr = 0x63;
+			msg[0].flags = 0;
+			msg[0].len = 2;
+			msg[0].buf = "\x0d\x02";
+			ret = i2c_transfer(&d->i2c_adap, msg, 1);
+			if (ret < 0)
+				goto err;
+		}
 
 		usleep_range(10000, 50000);
 
 		fe = dvb_attach(fc0012_attach, adap->fe[0], &d->i2c_adap,
-				&af9035_fc0012_config);
+				&af9035_fc0012_config[adap->id]);
 		break;
 	default:
 		fe = NULL;
-- 
1.7.11.7

