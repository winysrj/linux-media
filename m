Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50585 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbaKRHVh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 02:21:37 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 2/6] rtl28xxu: add support for Panasonic MN88472 slave demod
Date: Tue, 18 Nov 2014 09:20:39 +0200
Message-Id: <1416295243-27300-2-git-send-email-crope@iki.fi>
In-Reply-To: <1416295243-27300-1-git-send-email-crope@iki.fi>
References: <1416295243-27300-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is RTL2832P devices having extra MN88472 demodulator. This
patch add support for such configuration. Logically MN88472 slave
demodulator is connected to RTL2832 master demodulator, both I2C
bus and TS input. RTL2832 is integrated to RTL2832U and RTL2832P
chips. Chip version RTL2832P has extra TS interface for connecting
slave demodulator.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 135 ++++++++++++++++++++++++--------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |   4 +
 2 files changed, 108 insertions(+), 31 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 5ea52c7..d9ee1a9 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -24,6 +24,7 @@
 
 #include "rtl2830.h"
 #include "rtl2832.h"
+#include "mn88472.h"
 
 #include "qt1010.h"
 #include "mt2060.h"
@@ -420,6 +421,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	struct rtl28xxu_req req_tda18272 = {0x00c0, CMD_I2C_RD, 2, buf};
 	struct rtl28xxu_req req_r820t = {0x0034, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_r828d = {0x0074, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_mn88472 = {0xff38, CMD_I2C_RD, 1, buf};
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
@@ -449,7 +451,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	if (ret == 0 && buf[0] == 0xa1) {
 		priv->tuner = TUNER_RTL2832_FC0012;
 		priv->tuner_name = "FC0012";
-		goto found;
+		goto tuner_found;
 	}
 
 	/* check FC0013 ID register; reg=00 val=a3 */
@@ -457,7 +459,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	if (ret == 0 && buf[0] == 0xa3) {
 		priv->tuner = TUNER_RTL2832_FC0013;
 		priv->tuner_name = "FC0013";
-		goto found;
+		goto tuner_found;
 	}
 
 	/* check MT2266 ID register; reg=00 val=85 */
@@ -465,7 +467,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	if (ret == 0 && buf[0] == 0x85) {
 		priv->tuner = TUNER_RTL2832_MT2266;
 		priv->tuner_name = "MT2266";
-		goto found;
+		goto tuner_found;
 	}
 
 	/* check FC2580 ID register; reg=01 val=56 */
@@ -473,7 +475,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	if (ret == 0 && buf[0] == 0x56) {
 		priv->tuner = TUNER_RTL2832_FC2580;
 		priv->tuner_name = "FC2580";
-		goto found;
+		goto tuner_found;
 	}
 
 	/* check MT2063 ID register; reg=00 val=9e || 9c */
@@ -481,7 +483,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	if (ret == 0 && (buf[0] == 0x9e || buf[0] == 0x9c)) {
 		priv->tuner = TUNER_RTL2832_MT2063;
 		priv->tuner_name = "MT2063";
-		goto found;
+		goto tuner_found;
 	}
 
 	/* check MAX3543 ID register; reg=00 val=38 */
@@ -489,7 +491,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	if (ret == 0 && buf[0] == 0x38) {
 		priv->tuner = TUNER_RTL2832_MAX3543;
 		priv->tuner_name = "MAX3543";
-		goto found;
+		goto tuner_found;
 	}
 
 	/* check TUA9001 ID register; reg=7e val=2328 */
@@ -497,7 +499,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	if (ret == 0 && buf[0] == 0x23 && buf[1] == 0x28) {
 		priv->tuner = TUNER_RTL2832_TUA9001;
 		priv->tuner_name = "TUA9001";
-		goto found;
+		goto tuner_found;
 	}
 
 	/* check MXL5007R ID register; reg=d9 val=14 */
@@ -505,7 +507,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	if (ret == 0 && buf[0] == 0x14) {
 		priv->tuner = TUNER_RTL2832_MXL5007T;
 		priv->tuner_name = "MXL5007T";
-		goto found;
+		goto tuner_found;
 	}
 
 	/* check E4000 ID register; reg=02 val=40 */
@@ -513,7 +515,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	if (ret == 0 && buf[0] == 0x40) {
 		priv->tuner = TUNER_RTL2832_E4000;
 		priv->tuner_name = "E4000";
-		goto found;
+		goto tuner_found;
 	}
 
 	/* check TDA18272 ID register; reg=00 val=c760  */
@@ -521,7 +523,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	if (ret == 0 && (buf[0] == 0xc7 || buf[1] == 0x60)) {
 		priv->tuner = TUNER_RTL2832_TDA18272;
 		priv->tuner_name = "TDA18272";
-		goto found;
+		goto tuner_found;
 	}
 
 	/* check R820T ID register; reg=00 val=69 */
@@ -529,7 +531,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	if (ret == 0 && buf[0] == 0x69) {
 		priv->tuner = TUNER_RTL2832_R820T;
 		priv->tuner_name = "R820T";
-		goto found;
+		goto tuner_found;
 	}
 
 	/* check R828D ID register; reg=00 val=69 */
@@ -537,13 +539,37 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	if (ret == 0 && buf[0] == 0x69) {
 		priv->tuner = TUNER_RTL2832_R828D;
 		priv->tuner_name = "R828D";
-		goto found;
+		goto tuner_found;
 	}
 
-
-found:
+tuner_found:
 	dev_dbg(&d->udev->dev, "%s: tuner=%s\n", __func__, priv->tuner_name);
 
+	/* probe slave demod */
+	if (priv->tuner == TUNER_RTL2832_R828D) {
+		/* power on MN88472 demod on GPIO0 */
+		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x01, 0x01);
+		if (ret)
+			goto err;
+
+		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x01);
+		if (ret)
+			goto err;
+
+		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x01, 0x01);
+		if (ret)
+			goto err;
+
+		/* check MN88472 answers */
+		ret = rtl28xxu_ctrl_msg(d, &req_mn88472);
+		if (ret == 0 && buf[0] == 0x02) {
+			dev_dbg(&d->udev->dev, "%s: MN88472 found\n", __func__);
+			priv->slave_demod = SLAVE_DEMOD_MN88472;
+			goto demod_found;
+		}
+	}
+
+demod_found:
 	/* close demod I2C gate */
 	ret = rtl28xxu_ctrl_msg(d, &req_gate_close);
 	if (ret < 0)
@@ -818,7 +844,44 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	/* set fe callback */
 	adap->fe[0]->callback = rtl2832u_frontend_callback;
 
+	if (priv->slave_demod) {
+		struct i2c_board_info info = {};
+		struct i2c_client *client;
+
+		/*
+		 * We continue on reduced mode, without DVB-T2/C, using master
+		 * demod, when slave demod fails.
+		 */
+		ret = 0;
+
+		/* attach slave demodulator */
+		if (priv->slave_demod == SLAVE_DEMOD_MN88472) {
+			struct mn88472_config mn88472_config = {};
+
+			mn88472_config.fe = &adap->fe[1];
+			mn88472_config.i2c_wr_max = 22,
+			strlcpy(info.type, "mn88472", I2C_NAME_SIZE);
+			info.addr = 0x18;
+			info.platform_data = &mn88472_config;
+			request_module(info.type);
+			client = i2c_new_device(priv->demod_i2c_adapter, &info);
+			if (client == NULL || client->dev.driver == NULL) {
+				priv->slave_demod = SLAVE_DEMOD_NONE;
+				goto err_slave_demod_failed;
+			}
+
+			if (!try_module_get(client->dev.driver->owner)) {
+				i2c_unregister_device(client);
+				priv->slave_demod = SLAVE_DEMOD_NONE;
+				goto err_slave_demod_failed;
+			}
+
+			priv->i2c_client_slave_demod = client;
+		}
+	}
+
 	return 0;
+err_slave_demod_failed:
 err:
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
@@ -1024,25 +1087,19 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				&rtl28xxu_rtl2832_r820t_config, NULL);
 		break;
 	case TUNER_RTL2832_R828D:
-		/* power off mn88472 demod on GPIO0 */
-		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x00, 0x01);
-		if (ret)
-			goto err;
-
-		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x01);
-		if (ret)
-			goto err;
-
-		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x01, 0x01);
-		if (ret)
-			goto err;
-
-		fe = dvb_attach(r820t_attach, adap->fe[0], &d->i2c_adap,
+		fe = dvb_attach(r820t_attach, adap->fe[0],
+				priv->demod_i2c_adapter,
 				&rtl2832u_r828d_config);
-
-		/* Use tuner to get the signal strength */
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
+
+		if (adap->fe[1]) {
+			fe = dvb_attach(r820t_attach, adap->fe[1],
+					priv->demod_i2c_adapter,
+					&rtl2832u_r828d_config);
+			adap->fe[1]->ops.read_signal_strength =
+					adap->fe[1]->ops.tuner_ops.get_rf_strength;
+		}
 		break;
 	default:
 		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
@@ -1097,11 +1154,19 @@ err:
 static void rtl28xxu_exit(struct dvb_usb_device *d)
 {
 	struct rtl28xxu_priv *priv = d->priv;
-	struct i2c_client *client = priv->client;
+	struct i2c_client *client;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	/* remove I2C tuner */
+	client = priv->client;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
+	/* remove I2C slave demod */
+	client = priv->i2c_client_slave_demod;
 	if (client) {
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
@@ -1235,6 +1300,7 @@ err:
 static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 {
 	struct dvb_usb_device *d = fe_to_d(fe);
+	struct dvb_usb_adapter *adap = fe_to_adap(fe);
 	int ret;
 	u8 val;
 
@@ -1250,6 +1316,13 @@ static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 	if (ret)
 		goto err;
 
+	/* bypass slave demod TS through master demod */
+	if (fe->id == 1 && onoff) {
+		ret = rtl2832_enable_external_ts_if(adap->fe[0]);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
 err:
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index a26cab1..c1b00b9 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -58,6 +58,10 @@ struct rtl28xxu_priv {
 	struct i2c_adapter *demod_i2c_adapter;
 	bool rc_active;
 	struct i2c_client *client;
+	struct i2c_client *i2c_client_slave_demod;
+	#define SLAVE_DEMOD_NONE           0
+	#define SLAVE_DEMOD_MN88472        1
+	unsigned int slave_demod:1;
 };
 
 enum rtl28xxu_chip_id {
-- 
http://palosaari.fi/

