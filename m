Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43523 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751711AbdFODbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:35 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/15] af9015: use correct 7-bit i2c addresses
Date: Thu, 15 Jun 2017 06:30:51 +0300
Message-Id: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver was using wrong "8-bit" i2c addresses for demods and tuners.
Internal demod i2c address was not set at all. These are needed
to be fixed before proper i2c client binding is used.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 24 +++++++++++++-----------
 drivers/media/usb/dvb-usb-v2/af9015.h |  4 ++--
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index caa1e61..138416c 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -36,7 +36,7 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
 
 	state->buf[0] = req->cmd;
 	state->buf[1] = state->seq++;
-	state->buf[2] = req->i2c_addr;
+	state->buf[2] = req->i2c_addr << 1;
 	state->buf[3] = req->addr >> 8;
 	state->buf[4] = req->addr & 0xff;
 	state->buf[5] = req->mbox;
@@ -471,6 +471,8 @@ static int af9015_read_config(struct dvb_usb_device *d)
 	if (d->udev->speed == USB_SPEED_FULL)
 		state->dual_mode = 0;
 
+	state->af9013_config[0].i2c_addr = AF9015_I2C_DEMOD;
+
 	if (state->dual_mode) {
 		/* read 2nd demodulator I2C address */
 		req.addr = AF9015_EEPROM_DEMOD2_I2C;
@@ -478,7 +480,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
 		if (ret)
 			goto error;
 
-		state->af9013_config[1].i2c_addr = val;
+		state->af9013_config[1].i2c_addr = val >> 1;
 	}
 
 	for (i = 0; i < state->dual_mode + 1; i++) {
@@ -870,12 +872,12 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 }
 
 static struct mt2060_config af9015_mt2060_config = {
-	.i2c_address = 0xc0,
+	.i2c_address = 0x60,
 	.clock_out = 0,
 };
 
 static struct qt1010_config af9015_qt1010_config = {
-	.i2c_address = 0xc4,
+	.i2c_address = 0x62,
 };
 
 static struct tda18271_config af9015_tda18271_config = {
@@ -884,7 +886,7 @@ static struct tda18271_config af9015_tda18271_config = {
 };
 
 static struct mxl5005s_config af9015_mxl5003_config = {
-	.i2c_address     = 0xc6,
+	.i2c_address     = 0x63,
 	.if_freq         = IF_FREQ_4570000HZ,
 	.xtal_freq       = CRYSTAL_FREQ_16000000HZ,
 	.agc_mode        = MXL_SINGLE_AGC,
@@ -901,7 +903,7 @@ static struct mxl5005s_config af9015_mxl5003_config = {
 };
 
 static struct mxl5005s_config af9015_mxl5005_config = {
-	.i2c_address     = 0xc6,
+	.i2c_address     = 0x63,
 	.if_freq         = IF_FREQ_4570000HZ,
 	.xtal_freq       = CRYSTAL_FREQ_16000000HZ,
 	.agc_mode        = MXL_SINGLE_AGC,
@@ -918,12 +920,12 @@ static struct mxl5005s_config af9015_mxl5005_config = {
 };
 
 static struct mc44s803_config af9015_mc44s803_config = {
-	.i2c_address = 0xc0,
+	.i2c_address = 0x60,
 	.dig_out = 1,
 };
 
 static struct tda18218_config af9015_tda18218_config = {
-	.i2c_address = 0xc0,
+	.i2c_address = 0x60,
 	.i2c_wr_max = 21, /* max wr bytes AF9015 I2C adap can handle at once */
 };
 
@@ -954,7 +956,7 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 			&af9015_qt1010_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_TDA18271:
-		ret = dvb_attach(tda18271_attach, adap->fe[0], 0xc0,
+		ret = dvb_attach(tda18271_attach, adap->fe[0], 0x60,
 			&adap_to_d(adap)->i2c_adap,
 			&af9015_tda18271_config) == NULL ? -ENODEV : 0;
 		break;
@@ -975,7 +977,7 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 			&af9015_mxl5005_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_ENV77H11D5:
-		ret = dvb_attach(dvb_pll_attach, adap->fe[0], 0xc0,
+		ret = dvb_attach(dvb_pll_attach, adap->fe[0], 0x60,
 			&adap_to_d(adap)->i2c_adap,
 			DVB_PLL_TDA665X) == NULL ? -ENODEV : 0;
 		break;
@@ -987,7 +989,7 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 	case AF9013_TUNER_MXL5007T:
 		ret = dvb_attach(mxl5007t_attach, adap->fe[0],
 			&adap_to_d(adap)->i2c_adap,
-			0xc0, &af9015_mxl5007t_config) == NULL ? -ENODEV : 0;
+			0x60, &af9015_mxl5007t_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_UNKNOWN:
 	default:
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.h b/drivers/media/usb/dvb-usb-v2/af9015.h
index 2dd9231..3a9d981 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.h
+++ b/drivers/media/usb/dvb-usb-v2/af9015.h
@@ -47,8 +47,8 @@
 #define TS_USB20_MAX_PACKET_SIZE  512
 #define TS_USB11_MAX_PACKET_SIZE   64
 
-#define AF9015_I2C_EEPROM  0xa0
-#define AF9015_I2C_DEMOD   0x38
+#define AF9015_I2C_EEPROM  0x50
+#define AF9015_I2C_DEMOD   0x1c
 #define AF9015_USB_TIMEOUT 2000
 
 /* EEPROM locations */
-- 
http://palosaari.fi/
