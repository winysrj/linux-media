Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48286 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419AbaLWVCQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 16:02:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 59/66] rtl28xxu: rename state variable 'priv' to 'dev'
Date: Tue, 23 Dec 2014 22:49:52 +0200
Message-Id: <1419367799-14263-59-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I prefer dev over priv and I want keep all my drivers in line with
that.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 238 ++++++++++++++++----------------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |   2 +-
 2 files changed, 120 insertions(+), 120 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 27cf341..57afcba 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -147,7 +147,7 @@ static int rtl28xxu_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 {
 	int ret;
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	struct rtl28xxu_priv *priv = d->priv;
+	struct rtl28xxu_dev *dev = d->priv;
 	struct rtl28xxu_req req;
 
 	/*
@@ -184,7 +184,7 @@ static int rtl28xxu_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		} else if (msg[0].addr == 0x10) {
 			/* method 1 - integrated demod */
 			req.value = (msg[0].buf[0] << 8) | (msg[0].addr << 1);
-			req.index = CMD_DEMOD_RD | priv->page;
+			req.index = CMD_DEMOD_RD | dev->page;
 			req.size = msg[1].len;
 			req.data = &msg[1].buf[0];
 			ret = rtl28xxu_ctrl_msg(d, &req);
@@ -220,12 +220,12 @@ static int rtl28xxu_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			/* method 1 - integrated demod */
 			if (msg[0].buf[0] == 0x00) {
 				/* save demod page for later demod access */
-				priv->page = msg[0].buf[1];
+				dev->page = msg[0].buf[1];
 				ret = 0;
 			} else {
 				req.value = (msg[0].buf[0] << 8) |
 					(msg[0].addr << 1);
-				req.index = CMD_DEMOD_WR | priv->page;
+				req.index = CMD_DEMOD_WR | dev->page;
 				req.size = msg[0].len-1;
 				req.data = &msg[0].buf[1];
 				ret = rtl28xxu_ctrl_msg(d, &req);
@@ -267,7 +267,7 @@ static struct i2c_algorithm rtl28xxu_i2c_algo = {
 
 static int rtl2831u_read_config(struct dvb_usb_device *d)
 {
-	struct rtl28xxu_priv *priv = d_to_priv(d);
+	struct rtl28xxu_dev *dev = d_to_priv(d);
 	int ret;
 	u8 buf[1];
 	/* open RTL2831U/RTL2830 I2C gate */
@@ -304,7 +304,7 @@ static int rtl2831u_read_config(struct dvb_usb_device *d)
 	/* demod needs some time to wake up */
 	msleep(20);
 
-	priv->tuner_name = "NONE";
+	dev->tuner_name = "NONE";
 
 	/* open demod I2C gate */
 	ret = rtl28xxu_ctrl_msg(d, &req_gate_open);
@@ -314,8 +314,8 @@ static int rtl2831u_read_config(struct dvb_usb_device *d)
 	/* check QT1010 ID(?) register; reg=0f val=2c */
 	ret = rtl28xxu_ctrl_msg(d, &req_qt1010);
 	if (ret == 0 && buf[0] == 0x2c) {
-		priv->tuner = TUNER_RTL2830_QT1010;
-		priv->tuner_name = "QT1010";
+		dev->tuner = TUNER_RTL2830_QT1010;
+		dev->tuner_name = "QT1010";
 		goto found;
 	}
 
@@ -327,18 +327,18 @@ static int rtl2831u_read_config(struct dvb_usb_device *d)
 	/* check MT2060 ID register; reg=00 val=63 */
 	ret = rtl28xxu_ctrl_msg(d, &req_mt2060);
 	if (ret == 0 && buf[0] == 0x63) {
-		priv->tuner = TUNER_RTL2830_MT2060;
-		priv->tuner_name = "MT2060";
+		dev->tuner = TUNER_RTL2830_MT2060;
+		dev->tuner_name = "MT2060";
 		goto found;
 	}
 
 	/* assume MXL5005S */
-	priv->tuner = TUNER_RTL2830_MXL5005S;
-	priv->tuner_name = "MXL5005S";
+	dev->tuner = TUNER_RTL2830_MXL5005S;
+	dev->tuner_name = "MXL5005S";
 	goto found;
 
 found:
-	dev_dbg(&d->udev->dev, "%s: tuner=%s\n", __func__, priv->tuner_name);
+	dev_dbg(&d->udev->dev, "%s: tuner=%s\n", __func__, dev->tuner_name);
 
 	return 0;
 err:
@@ -348,7 +348,7 @@ err:
 
 static int rtl2832u_read_config(struct dvb_usb_device *d)
 {
-	struct rtl28xxu_priv *priv = d_to_priv(d);
+	struct rtl28xxu_dev *dev = d_to_priv(d);
 	int ret;
 	u8 buf[2];
 	/* open RTL2832U/RTL2832 I2C gate */
@@ -392,109 +392,109 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	if (ret)
 		goto err;
 
-	priv->tuner_name = "NONE";
+	dev->tuner_name = "NONE";
 
 	/* check FC0012 ID register; reg=00 val=a1 */
 	ret = rtl28xxu_ctrl_msg(d, &req_fc0012);
 	if (ret == 0 && buf[0] == 0xa1) {
-		priv->tuner = TUNER_RTL2832_FC0012;
-		priv->tuner_name = "FC0012";
+		dev->tuner = TUNER_RTL2832_FC0012;
+		dev->tuner_name = "FC0012";
 		goto tuner_found;
 	}
 
 	/* check FC0013 ID register; reg=00 val=a3 */
 	ret = rtl28xxu_ctrl_msg(d, &req_fc0013);
 	if (ret == 0 && buf[0] == 0xa3) {
-		priv->tuner = TUNER_RTL2832_FC0013;
-		priv->tuner_name = "FC0013";
+		dev->tuner = TUNER_RTL2832_FC0013;
+		dev->tuner_name = "FC0013";
 		goto tuner_found;
 	}
 
 	/* check MT2266 ID register; reg=00 val=85 */
 	ret = rtl28xxu_ctrl_msg(d, &req_mt2266);
 	if (ret == 0 && buf[0] == 0x85) {
-		priv->tuner = TUNER_RTL2832_MT2266;
-		priv->tuner_name = "MT2266";
+		dev->tuner = TUNER_RTL2832_MT2266;
+		dev->tuner_name = "MT2266";
 		goto tuner_found;
 	}
 
 	/* check FC2580 ID register; reg=01 val=56 */
 	ret = rtl28xxu_ctrl_msg(d, &req_fc2580);
 	if (ret == 0 && buf[0] == 0x56) {
-		priv->tuner = TUNER_RTL2832_FC2580;
-		priv->tuner_name = "FC2580";
+		dev->tuner = TUNER_RTL2832_FC2580;
+		dev->tuner_name = "FC2580";
 		goto tuner_found;
 	}
 
 	/* check MT2063 ID register; reg=00 val=9e || 9c */
 	ret = rtl28xxu_ctrl_msg(d, &req_mt2063);
 	if (ret == 0 && (buf[0] == 0x9e || buf[0] == 0x9c)) {
-		priv->tuner = TUNER_RTL2832_MT2063;
-		priv->tuner_name = "MT2063";
+		dev->tuner = TUNER_RTL2832_MT2063;
+		dev->tuner_name = "MT2063";
 		goto tuner_found;
 	}
 
 	/* check MAX3543 ID register; reg=00 val=38 */
 	ret = rtl28xxu_ctrl_msg(d, &req_max3543);
 	if (ret == 0 && buf[0] == 0x38) {
-		priv->tuner = TUNER_RTL2832_MAX3543;
-		priv->tuner_name = "MAX3543";
+		dev->tuner = TUNER_RTL2832_MAX3543;
+		dev->tuner_name = "MAX3543";
 		goto tuner_found;
 	}
 
 	/* check TUA9001 ID register; reg=7e val=2328 */
 	ret = rtl28xxu_ctrl_msg(d, &req_tua9001);
 	if (ret == 0 && buf[0] == 0x23 && buf[1] == 0x28) {
-		priv->tuner = TUNER_RTL2832_TUA9001;
-		priv->tuner_name = "TUA9001";
+		dev->tuner = TUNER_RTL2832_TUA9001;
+		dev->tuner_name = "TUA9001";
 		goto tuner_found;
 	}
 
 	/* check MXL5007R ID register; reg=d9 val=14 */
 	ret = rtl28xxu_ctrl_msg(d, &req_mxl5007t);
 	if (ret == 0 && buf[0] == 0x14) {
-		priv->tuner = TUNER_RTL2832_MXL5007T;
-		priv->tuner_name = "MXL5007T";
+		dev->tuner = TUNER_RTL2832_MXL5007T;
+		dev->tuner_name = "MXL5007T";
 		goto tuner_found;
 	}
 
 	/* check E4000 ID register; reg=02 val=40 */
 	ret = rtl28xxu_ctrl_msg(d, &req_e4000);
 	if (ret == 0 && buf[0] == 0x40) {
-		priv->tuner = TUNER_RTL2832_E4000;
-		priv->tuner_name = "E4000";
+		dev->tuner = TUNER_RTL2832_E4000;
+		dev->tuner_name = "E4000";
 		goto tuner_found;
 	}
 
 	/* check TDA18272 ID register; reg=00 val=c760  */
 	ret = rtl28xxu_ctrl_msg(d, &req_tda18272);
 	if (ret == 0 && (buf[0] == 0xc7 || buf[1] == 0x60)) {
-		priv->tuner = TUNER_RTL2832_TDA18272;
-		priv->tuner_name = "TDA18272";
+		dev->tuner = TUNER_RTL2832_TDA18272;
+		dev->tuner_name = "TDA18272";
 		goto tuner_found;
 	}
 
 	/* check R820T ID register; reg=00 val=69 */
 	ret = rtl28xxu_ctrl_msg(d, &req_r820t);
 	if (ret == 0 && buf[0] == 0x69) {
-		priv->tuner = TUNER_RTL2832_R820T;
-		priv->tuner_name = "R820T";
+		dev->tuner = TUNER_RTL2832_R820T;
+		dev->tuner_name = "R820T";
 		goto tuner_found;
 	}
 
 	/* check R828D ID register; reg=00 val=69 */
 	ret = rtl28xxu_ctrl_msg(d, &req_r828d);
 	if (ret == 0 && buf[0] == 0x69) {
-		priv->tuner = TUNER_RTL2832_R828D;
-		priv->tuner_name = "R828D";
+		dev->tuner = TUNER_RTL2832_R828D;
+		dev->tuner_name = "R828D";
 		goto tuner_found;
 	}
 
 tuner_found:
-	dev_dbg(&d->udev->dev, "%s: tuner=%s\n", __func__, priv->tuner_name);
+	dev_dbg(&d->udev->dev, "%s: tuner=%s\n", __func__, dev->tuner_name);
 
 	/* probe slave demod */
-	if (priv->tuner == TUNER_RTL2832_R828D) {
+	if (dev->tuner == TUNER_RTL2832_R828D) {
 		/* power on MN88472 demod on GPIO0 */
 		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x01, 0x01);
 		if (ret)
@@ -512,14 +512,14 @@ tuner_found:
 		ret = rtl28xxu_ctrl_msg(d, &req_mn88472);
 		if (ret == 0 && buf[0] == 0x02) {
 			dev_dbg(&d->udev->dev, "%s: MN88472 found\n", __func__);
-			priv->slave_demod = SLAVE_DEMOD_MN88472;
+			dev->slave_demod = SLAVE_DEMOD_MN88472;
 			goto demod_found;
 		}
 
 		ret = rtl28xxu_ctrl_msg(d, &req_mn88473);
 		if (ret == 0 && buf[0] == 0x03) {
 			dev_dbg(&d->udev->dev, "%s: MN88473 found\n", __func__);
-			priv->slave_demod = SLAVE_DEMOD_MN88473;
+			dev->slave_demod = SLAVE_DEMOD_MN88473;
 			goto demod_found;
 		}
 	}
@@ -564,15 +564,15 @@ static const struct rtl2830_platform_data rtl2830_mxl5005s_platform_data = {
 static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
-	struct rtl28xxu_priv *priv = d_to_priv(d);
-	struct rtl2830_platform_data *pdata = &priv->rtl2830_platform_data;
+	struct rtl28xxu_dev *dev = d_to_priv(d);
+	struct rtl2830_platform_data *pdata = &dev->rtl2830_platform_data;
 	struct i2c_board_info board_info;
 	struct i2c_client *client;
 	int ret;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
-	switch (priv->tuner) {
+	switch (dev->tuner) {
 	case TUNER_RTL2830_QT1010:
 		*pdata = rtl2830_qt1010_platform_data;
 		break;
@@ -584,7 +584,7 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
 		break;
 	default:
 		dev_err(&d->udev->dev, "%s: unknown tuner=%s\n",
-				KBUILD_MODNAME, priv->tuner_name);
+				KBUILD_MODNAME, dev->tuner_name);
 		ret = -ENODEV;
 		goto err;
 	}
@@ -608,9 +608,9 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 
 	adap->fe[0] = pdata->get_dvb_frontend(client);
-	priv->demod_i2c_adapter = pdata->get_i2c_adapter(client);
+	dev->demod_i2c_adapter = pdata->get_i2c_adapter(client);
 
-	priv->i2c_client_demod = client;
+	dev->i2c_client_demod = client;
 
 	return 0;
 err:
@@ -728,7 +728,7 @@ static int rtl2832u_frontend_callback(void *adapter_priv, int component,
 	struct device *parent = adapter->dev.parent;
 	struct i2c_adapter *parent_adapter;
 	struct dvb_usb_device *d;
-	struct rtl28xxu_priv *priv;
+	struct rtl28xxu_dev *dev;
 
 	/*
 	 * All tuners are connected to demod muxed I2C adapter. We have to
@@ -742,14 +742,14 @@ static int rtl2832u_frontend_callback(void *adapter_priv, int component,
 		return -EINVAL;
 
 	d = i2c_get_adapdata(parent_adapter);
-	priv = d->priv;
+	dev = d->priv;
 
 	dev_dbg(&d->udev->dev, "%s: component=%d cmd=%d arg=%d\n",
 			__func__, component, cmd, arg);
 
 	switch (component) {
 	case DVB_FRONTEND_COMPONENT_TUNER:
-		switch (priv->tuner) {
+		switch (dev->tuner) {
 		case TUNER_RTL2832_FC0012:
 			return rtl2832u_fc0012_tuner_callback(d, cmd, arg);
 		case TUNER_RTL2832_TUA9001:
@@ -765,15 +765,15 @@ static int rtl2832u_frontend_callback(void *adapter_priv, int component,
 static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
-	struct rtl28xxu_priv *priv = d_to_priv(d);
-	struct rtl2832_platform_data *pdata = &priv->rtl2832_platform_data;
+	struct rtl28xxu_dev *dev = d_to_priv(d);
+	struct rtl2832_platform_data *pdata = &dev->rtl2832_platform_data;
 	struct i2c_board_info board_info;
 	struct i2c_client *client;
 	int ret;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
-	switch (priv->tuner) {
+	switch (dev->tuner) {
 	case TUNER_RTL2832_FC0012:
 		*pdata = rtl2832_fc0012_platform_data;
 		break;
@@ -796,7 +796,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 		break;
 	default:
 		dev_err(&d->udev->dev, "%s: unknown tuner=%s\n",
-				KBUILD_MODNAME, priv->tuner_name);
+				KBUILD_MODNAME, dev->tuner_name);
 		ret = -ENODEV;
 		goto err;
 	}
@@ -820,14 +820,14 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 
 	adap->fe[0] = pdata->get_dvb_frontend(client);
-	priv->demod_i2c_adapter = pdata->get_i2c_adapter(client);
+	dev->demod_i2c_adapter = pdata->get_i2c_adapter(client);
 
-	priv->i2c_client_demod = client;
+	dev->i2c_client_demod = client;
 
 	/* set fe callback */
 	adap->fe[0]->callback = rtl2832u_frontend_callback;
 
-	if (priv->slave_demod) {
+	if (dev->slave_demod) {
 		struct i2c_board_info info = {};
 
 		/*
@@ -837,7 +837,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 		ret = 0;
 
 		/* attach slave demodulator */
-		if (priv->slave_demod == SLAVE_DEMOD_MN88472) {
+		if (dev->slave_demod == SLAVE_DEMOD_MN88472) {
 			struct mn88472_config mn88472_config = {};
 
 			mn88472_config.fe = &adap->fe[1];
@@ -849,17 +849,17 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			request_module(info.type);
 			client = i2c_new_device(&d->i2c_adap, &info);
 			if (client == NULL || client->dev.driver == NULL) {
-				priv->slave_demod = SLAVE_DEMOD_NONE;
+				dev->slave_demod = SLAVE_DEMOD_NONE;
 				goto err_slave_demod_failed;
 			}
 
 			if (!try_module_get(client->dev.driver->owner)) {
 				i2c_unregister_device(client);
-				priv->slave_demod = SLAVE_DEMOD_NONE;
+				dev->slave_demod = SLAVE_DEMOD_NONE;
 				goto err_slave_demod_failed;
 			}
 
-			priv->i2c_client_slave_demod = client;
+			dev->i2c_client_slave_demod = client;
 		} else {
 			struct mn88473_config mn88473_config = {};
 
@@ -871,17 +871,17 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			request_module(info.type);
 			client = i2c_new_device(&d->i2c_adap, &info);
 			if (client == NULL || client->dev.driver == NULL) {
-				priv->slave_demod = SLAVE_DEMOD_NONE;
+				dev->slave_demod = SLAVE_DEMOD_NONE;
 				goto err_slave_demod_failed;
 			}
 
 			if (!try_module_get(client->dev.driver->owner)) {
 				i2c_unregister_device(client);
-				priv->slave_demod = SLAVE_DEMOD_NONE;
+				dev->slave_demod = SLAVE_DEMOD_NONE;
 				goto err_slave_demod_failed;
 			}
 
-			priv->i2c_client_slave_demod = client;
+			dev->i2c_client_slave_demod = client;
 		}
 	}
 
@@ -895,20 +895,20 @@ err:
 static int rtl2832u_frontend_detach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
-	struct rtl28xxu_priv *priv = d_to_priv(d);
+	struct rtl28xxu_dev *dev = d_to_priv(d);
 	struct i2c_client *client;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	/* remove I2C slave demod */
-	client = priv->i2c_client_slave_demod;
+	client = dev->i2c_client_slave_demod;
 	if (client) {
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
 	}
 
 	/* remove I2C demod */
-	client = priv->i2c_client_demod;
+	client = dev->i2c_client_demod;
 	if (client) {
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
@@ -947,31 +947,31 @@ static int rtl2831u_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
 	struct dvb_usb_device *d = adap_to_d(adap);
-	struct rtl28xxu_priv *priv = d_to_priv(d);
+	struct rtl28xxu_dev *dev = d_to_priv(d);
 	struct dvb_frontend *fe;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
-	switch (priv->tuner) {
+	switch (dev->tuner) {
 	case TUNER_RTL2830_QT1010:
 		fe = dvb_attach(qt1010_attach, adap->fe[0],
-				priv->demod_i2c_adapter,
+				dev->demod_i2c_adapter,
 				&rtl28xxu_qt1010_config);
 		break;
 	case TUNER_RTL2830_MT2060:
 		fe = dvb_attach(mt2060_attach, adap->fe[0],
-				priv->demod_i2c_adapter,
+				dev->demod_i2c_adapter,
 				&rtl28xxu_mt2060_config, 1220);
 		break;
 	case TUNER_RTL2830_MXL5005S:
 		fe = dvb_attach(mxl5005s_attach, adap->fe[0],
-				priv->demod_i2c_adapter,
+				dev->demod_i2c_adapter,
 				&rtl28xxu_mxl5005s_config);
 		break;
 	default:
 		fe = NULL;
 		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
-				priv->tuner);
+				dev->tuner);
 	}
 
 	if (fe == NULL) {
@@ -1017,7 +1017,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
 	struct dvb_usb_device *d = adap_to_d(adap);
-	struct rtl28xxu_priv *priv = d_to_priv(d);
+	struct rtl28xxu_dev *dev = d_to_priv(d);
 	struct dvb_frontend *fe = NULL;
 	struct i2c_board_info info;
 	struct i2c_client *client;
@@ -1027,10 +1027,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
 
-	switch (priv->tuner) {
+	switch (dev->tuner) {
 	case TUNER_RTL2832_FC0012:
 		fe = dvb_attach(fc0012_attach, adap->fe[0],
-			priv->demod_i2c_adapter, &rtl2832u_fc0012_config);
+			dev->demod_i2c_adapter, &rtl2832u_fc0012_config);
 
 		/* since fc0012 includs reading the signal strength delegate
 		 * that to the tuner driver */
@@ -1039,7 +1039,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		break;
 	case TUNER_RTL2832_FC0013:
 		fe = dvb_attach(fc0013_attach, adap->fe[0],
-			priv->demod_i2c_adapter, 0xc6>>1, 0, FC_XTAL_28_8_MHZ);
+			dev->demod_i2c_adapter, 0xc6>>1, 0, FC_XTAL_28_8_MHZ);
 
 		/* fc0013 also supports signal strength reading */
 		adap->fe[0]->ops.read_signal_strength =
@@ -1056,7 +1056,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 			info.platform_data = &e4000_config;
 
 			request_module(info.type);
-			client = i2c_new_device(priv->demod_i2c_adapter, &info);
+			client = i2c_new_device(dev->demod_i2c_adapter, &info);
 			if (client == NULL || client->dev.driver == NULL)
 				break;
 
@@ -1065,13 +1065,13 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				break;
 			}
 
-			priv->i2c_client_tuner = client;
+			dev->i2c_client_tuner = client;
 			subdev = i2c_get_clientdata(client);
 		}
 		break;
 	case TUNER_RTL2832_FC2580:
 		fe = dvb_attach(fc2580_attach, adap->fe[0],
-				priv->demod_i2c_adapter,
+				dev->demod_i2c_adapter,
 				&rtl2832u_fc2580_config);
 		break;
 	case TUNER_RTL2832_TUA9001:
@@ -1085,12 +1085,12 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 			goto err;
 
 		fe = dvb_attach(tua9001_attach, adap->fe[0],
-				priv->demod_i2c_adapter,
+				dev->demod_i2c_adapter,
 				&rtl2832u_tua9001_config);
 		break;
 	case TUNER_RTL2832_R820T:
 		fe = dvb_attach(r820t_attach, adap->fe[0],
-				priv->demod_i2c_adapter,
+				dev->demod_i2c_adapter,
 				&rtl2832u_r820t_config);
 
 		/* Use tuner to get the signal strength */
@@ -1099,14 +1099,14 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		break;
 	case TUNER_RTL2832_R828D:
 		fe = dvb_attach(r820t_attach, adap->fe[0],
-				priv->demod_i2c_adapter,
+				dev->demod_i2c_adapter,
 				&rtl2832u_r828d_config);
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 
 		if (adap->fe[1]) {
 			fe = dvb_attach(r820t_attach, adap->fe[1],
-					priv->demod_i2c_adapter,
+					dev->demod_i2c_adapter,
 					&rtl2832u_r828d_config);
 			adap->fe[1]->ops.read_signal_strength =
 					adap->fe[1]->ops.tuner_ops.get_rf_strength;
@@ -1114,15 +1114,15 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		break;
 	default:
 		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
-				priv->tuner);
+				dev->tuner);
 	}
-	if (fe == NULL && priv->i2c_client_tuner == NULL) {
+	if (fe == NULL && dev->i2c_client_tuner == NULL) {
 		ret = -ENODEV;
 		goto err;
 	}
 
 	/* register SDR */
-	switch (priv->tuner) {
+	switch (dev->tuner) {
 		struct platform_device *pdev;
 		struct rtl2832_sdr_platform_data pdata = {};
 
@@ -1131,12 +1131,12 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 	case TUNER_RTL2832_E4000:
 	case TUNER_RTL2832_R820T:
 	case TUNER_RTL2832_R828D:
-		pdata.clk = priv->rtl2832_platform_data.clk;
-		pdata.tuner = priv->tuner;
-		pdata.i2c_client = priv->i2c_client_demod;
-		pdata.bulk_read = priv->rtl2832_platform_data.bulk_read;
-		pdata.bulk_write = priv->rtl2832_platform_data.bulk_write;
-		pdata.update_bits = priv->rtl2832_platform_data.update_bits;
+		pdata.clk = dev->rtl2832_platform_data.clk;
+		pdata.tuner = dev->tuner;
+		pdata.i2c_client = dev->i2c_client_demod;
+		pdata.bulk_read = dev->rtl2832_platform_data.bulk_read;
+		pdata.bulk_write = dev->rtl2832_platform_data.bulk_write;
+		pdata.update_bits = dev->rtl2832_platform_data.update_bits;
 		pdata.dvb_frontend = adap->fe[0];
 		pdata.dvb_usb_device = d;
 		pdata.v4l2_subdev = subdev;
@@ -1148,10 +1148,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 						     &pdata, sizeof(pdata));
 		if (pdev == NULL || pdev->dev.driver == NULL)
 			break;
-		priv->platform_device_sdr = pdev;
+		dev->platform_device_sdr = pdev;
 		break;
 	default:
-		dev_dbg(&d->udev->dev, "no SDR for tuner=%d\n", priv->tuner);
+		dev_dbg(&d->udev->dev, "no SDR for tuner=%d\n", dev->tuner);
 	}
 
 	return 0;
@@ -1163,19 +1163,19 @@ err:
 static int rtl2832u_tuner_detach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
-	struct rtl28xxu_priv *priv = d_to_priv(d);
+	struct rtl28xxu_dev *dev = d_to_priv(d);
 	struct i2c_client *client;
 	struct platform_device *pdev;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	/* remove platform SDR */
-	pdev = priv->platform_device_sdr;
+	pdev = dev->platform_device_sdr;
 	if (pdev)
 		platform_device_unregister(pdev);
 
 	/* remove I2C tuner */
-	client = priv->i2c_client_tuner;
+	client = dev->i2c_client_tuner;
 	if (client) {
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
@@ -1343,8 +1343,8 @@ err:
 static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 {
 	struct dvb_usb_device *d = fe_to_d(fe);
-	struct rtl28xxu_priv *priv = fe_to_priv(fe);
-	struct rtl2832_platform_data *pdata = &priv->rtl2832_platform_data;
+	struct rtl28xxu_dev *dev = fe_to_priv(fe);
+	struct rtl2832_platform_data *pdata = &dev->rtl2832_platform_data;
 	int ret;
 	u8 val;
 
@@ -1362,7 +1362,7 @@ static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 
 	/* bypass slave demod TS through master demod */
 	if (fe->id == 1 && onoff) {
-		ret = pdata->enable_slave_ts(priv->i2c_client_demod);
+		ret = pdata->enable_slave_ts(dev->i2c_client_demod);
 		if (ret)
 			goto err;
 	}
@@ -1377,7 +1377,7 @@ err:
 static int rtl2831u_rc_query(struct dvb_usb_device *d)
 {
 	int ret, i;
-	struct rtl28xxu_priv *priv = d->priv;
+	struct rtl28xxu_dev *dev = d->priv;
 	u8 buf[5];
 	u32 rc_code;
 	struct rtl28xxu_reg_val rc_nec_tab[] = {
@@ -1398,14 +1398,14 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 	};
 
 	/* init remote controller */
-	if (!priv->rc_active) {
+	if (!dev->rc_active) {
 		for (i = 0; i < ARRAY_SIZE(rc_nec_tab); i++) {
 			ret = rtl28xx_wr_reg(d, rc_nec_tab[i].reg,
 					rc_nec_tab[i].val);
 			if (ret)
 				goto err;
 		}
-		priv->rc_active = true;
+		dev->rc_active = true;
 	}
 
 	ret = rtl2831_rd_regs(d, SYS_IRRC_RP, buf, 5);
@@ -1460,7 +1460,7 @@ static int rtl2831u_get_rc_config(struct dvb_usb_device *d,
 static int rtl2832u_rc_query(struct dvb_usb_device *d)
 {
 	int ret, i, len;
-	struct rtl28xxu_priv *priv = d->priv;
+	struct rtl28xxu_dev *dev = d->priv;
 	struct ir_raw_event ev;
 	u8 buf[128];
 	static const struct rtl28xxu_reg_val_mask refresh_tab[] = {
@@ -1470,7 +1470,7 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 	};
 
 	/* init remote controller */
-	if (!priv->rc_active) {
+	if (!dev->rc_active) {
 		static const struct rtl28xxu_reg_val_mask init_tab[] = {
 			{SYS_DEMOD_CTL1,         0x00, 0x04},
 			{SYS_DEMOD_CTL1,         0x00, 0x08},
@@ -1497,7 +1497,7 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 				goto err;
 		}
 
-		priv->rc_active = true;
+		dev->rc_active = true;
 	}
 
 	ret = rtl28xx_rd_reg(d, IR_RX_IF, &buf[0]);
@@ -1570,8 +1570,8 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
 static int rtl2831u_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
-	struct rtl28xxu_priv *priv = d_to_priv(d);
-	struct rtl2830_platform_data *pdata = &priv->rtl2830_platform_data;
+	struct rtl28xxu_dev *dev = d_to_priv(d);
+	struct rtl2830_platform_data *pdata = &dev->rtl2830_platform_data;
 
 	return pdata->pid_filter_ctrl(adap->fe[0], onoff);
 }
@@ -1579,8 +1579,8 @@ static int rtl2831u_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 static int rtl2832u_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
-	struct rtl28xxu_priv *priv = d_to_priv(d);
-	struct rtl2832_platform_data *pdata = &priv->rtl2832_platform_data;
+	struct rtl28xxu_dev *dev = d_to_priv(d);
+	struct rtl2832_platform_data *pdata = &dev->rtl2832_platform_data;
 
 	return pdata->pid_filter_ctrl(adap->fe[0], onoff);
 }
@@ -1588,8 +1588,8 @@ static int rtl2832u_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 static int rtl2831u_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid, int onoff)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
-	struct rtl28xxu_priv *priv = d_to_priv(d);
-	struct rtl2830_platform_data *pdata = &priv->rtl2830_platform_data;
+	struct rtl28xxu_dev *dev = d_to_priv(d);
+	struct rtl2830_platform_data *pdata = &dev->rtl2830_platform_data;
 
 	return pdata->pid_filter(adap->fe[0], index, pid, onoff);
 }
@@ -1597,8 +1597,8 @@ static int rtl2831u_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 static int rtl2832u_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid, int onoff)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
-	struct rtl28xxu_priv *priv = d_to_priv(d);
-	struct rtl2832_platform_data *pdata = &priv->rtl2832_platform_data;
+	struct rtl28xxu_dev *dev = d_to_priv(d);
+	struct rtl2832_platform_data *pdata = &dev->rtl2832_platform_data;
 
 	return pdata->pid_filter(adap->fe[0], index, pid, onoff);
 }
@@ -1607,7 +1607,7 @@ static const struct dvb_usb_device_properties rtl2831u_props = {
 	.driver_name = KBUILD_MODNAME,
 	.owner = THIS_MODULE,
 	.adapter_nr = adapter_nr,
-	.size_of_priv = sizeof(struct rtl28xxu_priv),
+	.size_of_priv = sizeof(struct rtl28xxu_dev),
 
 	.power_ctrl = rtl2831u_power_ctrl,
 	.i2c_algo = &rtl28xxu_i2c_algo,
@@ -1637,7 +1637,7 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
 	.driver_name = KBUILD_MODNAME,
 	.owner = THIS_MODULE,
 	.adapter_nr = adapter_nr,
-	.size_of_priv = sizeof(struct rtl28xxu_priv),
+	.size_of_priv = sizeof(struct rtl28xxu_dev),
 
 	.power_ctrl = rtl2832u_power_ctrl,
 	.frontend_ctrl = rtl2832u_frontend_ctrl,
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 62d3249..abf0111 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -68,7 +68,7 @@
 #define CMD_I2C_DA_WR    0x0610
 
 
-struct rtl28xxu_priv {
+struct rtl28xxu_dev {
 	u8 chip_id;
 	u8 tuner;
 	char *tuner_name;
-- 
http://palosaari.fi/

