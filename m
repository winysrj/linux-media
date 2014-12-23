Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54085 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaLWUub (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:31 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 24/66] rtl28xxu: use rtl2832 demod callbacks accessing its resources
Date: Tue, 23 Dec 2014 22:49:17 +0200
Message-Id: <1419367799-14263-24-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch demod resource use from exported symbols to callbacks its
provides.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 39 +++++++++++++++++----------------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |  5 ++++-
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index fa76ad2..3d619de 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -782,36 +782,35 @@ static int rtl2832u_frontend_callback(void *adapter_priv, int component,
 
 static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	int ret;
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
-	struct rtl2832_platform_data platform_data;
-	const struct rtl2832_config *rtl2832_config;
-	struct i2c_board_info board_info = {};
+	struct rtl2832_platform_data *pdata = &priv->rtl2832_platform_data;
+	struct i2c_board_info board_info;
 	struct i2c_client *client;
+	int ret;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	switch (priv->tuner) {
 	case TUNER_RTL2832_FC0012:
-		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
+		pdata->config = &rtl28xxu_rtl2832_fc0012_config;
 		break;
 	case TUNER_RTL2832_FC0013:
-		rtl2832_config = &rtl28xxu_rtl2832_fc0013_config;
+		pdata->config = &rtl28xxu_rtl2832_fc0013_config;
 		break;
 	case TUNER_RTL2832_FC2580:
 		/* FIXME: do not abuse fc0012 settings */
-		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
+		pdata->config = &rtl28xxu_rtl2832_fc0012_config;
 		break;
 	case TUNER_RTL2832_TUA9001:
-		rtl2832_config = &rtl28xxu_rtl2832_tua9001_config;
+		pdata->config = &rtl28xxu_rtl2832_tua9001_config;
 		break;
 	case TUNER_RTL2832_E4000:
-		rtl2832_config = &rtl28xxu_rtl2832_e4000_config;
+		pdata->config = &rtl28xxu_rtl2832_e4000_config;
 		break;
 	case TUNER_RTL2832_R820T:
 	case TUNER_RTL2832_R828D:
-		rtl2832_config = &rtl28xxu_rtl2832_r820t_config;
+		pdata->config = &rtl28xxu_rtl2832_r820t_config;
 		break;
 	default:
 		dev_err(&d->udev->dev, "%s: unknown tuner=%s\n",
@@ -821,11 +820,10 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 
 	/* attach demodulator */
-	platform_data.config = rtl2832_config;
-	platform_data.dvb_frontend = &adap->fe[0];
+	memset(&board_info, 0, sizeof(board_info));
 	strlcpy(board_info.type, "rtl2832", I2C_NAME_SIZE);
 	board_info.addr = 0x10;
-	board_info.platform_data = &platform_data;
+	board_info.platform_data = pdata;
 	request_module("%s", board_info.type);
 	client = i2c_new_device(&d->i2c_adap, &board_info);
 	if (client == NULL || client->dev.driver == NULL) {
@@ -839,10 +837,10 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 		goto err;
 	}
 
-	priv->i2c_client_demod = client;
+	adap->fe[0] = pdata->get_dvb_frontend(client);
+	priv->demod_i2c_adapter = pdata->get_i2c_adapter(client);
 
-	/* RTL2832 I2C repeater */
-	priv->demod_i2c_adapter = rtl2832_get_i2c_adapter(adap->fe[0]);
+	priv->i2c_client_demod = client;
 
 	/* set fe callback */
 	adap->fe[0]->callback = rtl2832u_frontend_callback;
@@ -1038,6 +1036,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 	int ret;
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
+	struct rtl2832_platform_data *pdata = &priv->rtl2832_platform_data;
 	struct dvb_frontend *fe = NULL;
 	struct i2c_board_info info;
 	struct i2c_client *client;
@@ -1075,7 +1074,8 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 	case TUNER_RTL2832_E4000: {
 			struct v4l2_subdev *sd;
 			struct i2c_adapter *i2c_adap_internal =
-					rtl2832_get_private_i2c_adapter(adap->fe[0]);
+					pdata->get_private_i2c_adapter(priv->i2c_client_demod);
+
 			struct e4000_config e4000_config = {
 				.fe = adap->fe[0],
 				.clock = 28800000,
@@ -1346,7 +1346,8 @@ err:
 static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 {
 	struct dvb_usb_device *d = fe_to_d(fe);
-	struct dvb_usb_adapter *adap = fe_to_adap(fe);
+	struct rtl28xxu_priv *priv = fe_to_priv(fe);
+	struct rtl2832_platform_data *pdata = &priv->rtl2832_platform_data;
 	int ret;
 	u8 val;
 
@@ -1364,7 +1365,7 @@ static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 
 	/* bypass slave demod TS through master demod */
 	if (fe->id == 1 && onoff) {
-		ret = rtl2832_enable_external_ts_if(adap->fe[0]);
+		ret = pdata->enable_slave_ts(priv->i2c_client_demod);
 		if (ret)
 			goto err;
 	}
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 3f630c8..cb3fc65 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -80,7 +80,10 @@ struct rtl28xxu_priv {
 	#define SLAVE_DEMOD_MN88472        1
 	#define SLAVE_DEMOD_MN88473        2
 	unsigned int slave_demod:2;
-	struct rtl2830_platform_data rtl2830_platform_data;
+	union {
+		struct rtl2830_platform_data rtl2830_platform_data;
+		struct rtl2832_platform_data rtl2832_platform_data;
+	};
 };
 
 enum rtl28xxu_chip_id {
-- 
http://palosaari.fi/

