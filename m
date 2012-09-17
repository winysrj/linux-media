Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47929 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab2IQU6k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 16:58:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/7] rtl28xxu: move tuner probing to .read_config()
Date: Mon, 17 Sep 2012 23:58:06 +0300
Message-Id: <1347915492-24924-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move rtl2832u tuner probing correct place.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 351 ++++++++++++++++----------------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |   1 +
 2 files changed, 175 insertions(+), 177 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c3e2602..ca77e62 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -254,6 +254,156 @@ static struct i2c_algorithm rtl28xxu_i2c_algo = {
 	.functionality = rtl28xxu_i2c_func,
 };
 
+static int rtl2832u_read_config(struct dvb_usb_device *d)
+{
+	struct rtl28xxu_priv *priv = d_to_priv(d);
+	int ret;
+	u8 buf[2], val;
+	/* open RTL2832U/RTL2832 I2C gate */
+	struct rtl28xxu_req req_gate_open = {0x0120, 0x0011, 0x0001, "\x18"};
+	/* close RTL2832U/RTL2832 I2C gate */
+	struct rtl28xxu_req req_gate_close = {0x0120, 0x0011, 0x0001, "\x10"};
+	/* tuner probes */
+	struct rtl28xxu_req req_fc0012 = {0x00c6, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_fc0013 = {0x00c6, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_mt2266 = {0x00c0, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_fc2580 = {0x01ac, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_mt2063 = {0x00c0, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_max3543 = {0x00c0, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_tua9001 = {0x7ec0, CMD_I2C_RD, 2, buf};
+	struct rtl28xxu_req req_mxl5007t = {0xd9c0, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_e4000 = {0x02c8, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_tda18272 = {0x00c0, CMD_I2C_RD, 2, buf};
+
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
+	ret = rtl28xx_rd_reg(d, SYS_GPIO_DIR, &val);
+	if (ret)
+		goto err;
+
+	val &= 0xbf;
+
+	ret = rtl28xx_wr_reg(d, SYS_GPIO_DIR, val);
+	if (ret)
+		goto err;
+
+	/* enable as output GPIO3 and GPIO6 */
+	ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_EN, &val);
+	if (ret)
+		goto err;
+
+	val |= 0x48;
+
+	ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_EN, val);
+	if (ret)
+		goto err;
+
+	/*
+	 * Probe used tuner. We need to know used tuner before demod attach
+	 * since there is some demod params needed to set according to tuner.
+	 */
+
+	/* open demod I2C gate */
+	ret = rtl28xxu_ctrl_msg(d, &req_gate_open);
+	if (ret)
+		goto err;
+
+	priv->tuner_name = "NONE";
+
+	/* check FC0012 ID register; reg=00 val=a1 */
+	ret = rtl28xxu_ctrl_msg(d, &req_fc0012);
+	if (ret == 0 && buf[0] == 0xa1) {
+		priv->tuner = TUNER_RTL2832_FC0012;
+		priv->tuner_name = "FC0012";
+		goto found;
+	}
+
+	/* check FC0013 ID register; reg=00 val=a3 */
+	ret = rtl28xxu_ctrl_msg(d, &req_fc0013);
+	if (ret == 0 && buf[0] == 0xa3) {
+		priv->tuner = TUNER_RTL2832_FC0013;
+		priv->tuner_name = "FC0013";
+		goto found;
+	}
+
+	/* check MT2266 ID register; reg=00 val=85 */
+	ret = rtl28xxu_ctrl_msg(d, &req_mt2266);
+	if (ret == 0 && buf[0] == 0x85) {
+		priv->tuner = TUNER_RTL2832_MT2266;
+		priv->tuner_name = "MT2266";
+		goto found;
+	}
+
+	/* check FC2580 ID register; reg=01 val=56 */
+	ret = rtl28xxu_ctrl_msg(d, &req_fc2580);
+	if (ret == 0 && buf[0] == 0x56) {
+		priv->tuner = TUNER_RTL2832_FC2580;
+		priv->tuner_name = "FC2580";
+		goto found;
+	}
+
+	/* check MT2063 ID register; reg=00 val=9e || 9c */
+	ret = rtl28xxu_ctrl_msg(d, &req_mt2063);
+	if (ret == 0 && (buf[0] == 0x9e || buf[0] == 0x9c)) {
+		priv->tuner = TUNER_RTL2832_MT2063;
+		priv->tuner_name = "MT2063";
+		goto found;
+	}
+
+	/* check MAX3543 ID register; reg=00 val=38 */
+	ret = rtl28xxu_ctrl_msg(d, &req_max3543);
+	if (ret == 0 && buf[0] == 0x38) {
+		priv->tuner = TUNER_RTL2832_MAX3543;
+		priv->tuner_name = "MAX3543";
+		goto found;
+	}
+
+	/* check TUA9001 ID register; reg=7e val=2328 */
+	ret = rtl28xxu_ctrl_msg(d, &req_tua9001);
+	if (ret == 0 && buf[0] == 0x23 && buf[1] == 0x28) {
+		priv->tuner = TUNER_RTL2832_TUA9001;
+		priv->tuner_name = "TUA9001";
+		goto found;
+	}
+
+	/* check MXL5007R ID register; reg=d9 val=14 */
+	ret = rtl28xxu_ctrl_msg(d, &req_mxl5007t);
+	if (ret == 0 && buf[0] == 0x14) {
+		priv->tuner = TUNER_RTL2832_MXL5007T;
+		priv->tuner_name = "MXL5007T";
+		goto found;
+	}
+
+	/* check E4000 ID register; reg=02 val=40 */
+	ret = rtl28xxu_ctrl_msg(d, &req_e4000);
+	if (ret == 0 && buf[0] == 0x40) {
+		priv->tuner = TUNER_RTL2832_E4000;
+		priv->tuner_name = "E4000";
+		goto found;
+	}
+
+	/* check TDA18272 ID register; reg=00 val=c760  */
+	ret = rtl28xxu_ctrl_msg(d, &req_tda18272);
+	if (ret == 0 && (buf[0] == 0xc7 || buf[1] == 0x60)) {
+		priv->tuner = TUNER_RTL2832_TDA18272;
+		priv->tuner_name = "TDA18272";
+		goto found;
+	}
+
+found:
+	dev_dbg(&d->udev->dev, "%s: tuner=%s\n", __func__, priv->tuner_name);
+
+	/* close demod I2C gate */
+	ret = rtl28xxu_ctrl_msg(d, &req_gate_close);
+	if (ret < 0)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
 static struct rtl2830_config rtl28xxu_rtl2830_mt2060_config = {
 	.i2c_addr = 0x10, /* 0x20 */
 	.xtal = 28800000,
@@ -537,199 +687,45 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
 	struct rtl2832_config *rtl2832_config;
-	u8 buf[2], val;
-	/* open RTL2832U/RTL2832 I2C gate */
-	struct rtl28xxu_req req_gate_open = {0x0120, 0x0011, 0x0001, "\x18"};
-	/* close RTL2832U/RTL2832 I2C gate */
-	struct rtl28xxu_req req_gate_close = {0x0120, 0x0011, 0x0001, "\x10"};
-	/* for FC0012 tuner probe */
-	struct rtl28xxu_req req_fc0012 = {0x00c6, CMD_I2C_RD, 1, buf};
-	/* for FC0013 tuner probe */
-	struct rtl28xxu_req req_fc0013 = {0x00c6, CMD_I2C_RD, 1, buf};
-	/* for MT2266 tuner probe */
-	struct rtl28xxu_req req_mt2266 = {0x00c0, CMD_I2C_RD, 1, buf};
-	/* for FC2580 tuner probe */
-	struct rtl28xxu_req req_fc2580 = {0x01ac, CMD_I2C_RD, 1, buf};
-	/* for MT2063 tuner probe */
-	struct rtl28xxu_req req_mt2063 = {0x00c0, CMD_I2C_RD, 1, buf};
-	/* for MAX3543 tuner probe */
-	struct rtl28xxu_req req_max3543 = {0x00c0, CMD_I2C_RD, 1, buf};
-	/* for TUA9001 tuner probe */
-	struct rtl28xxu_req req_tua9001 = {0x7ec0, CMD_I2C_RD, 2, buf};
-	/* for MXL5007T tuner probe */
-	struct rtl28xxu_req req_mxl5007t = {0xd9c0, CMD_I2C_RD, 1, buf};
-	/* for E4000 tuner probe */
-	struct rtl28xxu_req req_e4000 = {0x02c8, CMD_I2C_RD, 1, buf};
-	/* for TDA18272 tuner probe */
-	struct rtl28xxu_req req_tda18272 = {0x00c0, CMD_I2C_RD, 2, buf};
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
-	ret = rtl28xx_rd_reg(d, SYS_GPIO_DIR, &val);
-	if (ret)
-		goto err;
-
-	val &= 0xbf;
-
-	ret = rtl28xx_wr_reg(d, SYS_GPIO_DIR, val);
-	if (ret)
-		goto err;
-
-	/* enable as output GPIO3 and GPIO6*/
-	ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_EN, &val);
-	if (ret)
-		goto err;
-
-	val |= 0x48;
-
-	ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_EN, val);
-	if (ret)
-		goto err;
-
-	/*
-	 * Probe used tuner. We need to know used tuner before demod attach
-	 * since there is some demod params needed to set according to tuner.
-	 */
-
-	/* open demod I2C gate */
-	ret = rtl28xxu_ctrl_msg(d, &req_gate_open);
-	if (ret)
-		goto err;
-
-	priv->tuner = TUNER_NONE;
-
-	/* check FC0012 ID register; reg=00 val=a1 */
-	ret = rtl28xxu_ctrl_msg(d, &req_fc0012);
-	if (ret == 0 && buf[0] == 0xa1) {
-		priv->tuner = TUNER_RTL2832_FC0012;
+	switch (priv->tuner) {
+	case TUNER_RTL2832_FC0012:
 		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
-		dev_info(&d->udev->dev, "%s: FC0012 tuner found",
-				KBUILD_MODNAME);
-		goto found;
-	}
-
-	/* check FC0013 ID register; reg=00 val=a3 */
-	ret = rtl28xxu_ctrl_msg(d, &req_fc0013);
-	if (ret == 0 && buf[0] == 0xa3) {
-		priv->tuner = TUNER_RTL2832_FC0013;
+		break;
+	case TUNER_RTL2832_FC0013:
 		rtl2832_config = &rtl28xxu_rtl2832_fc0013_config;
-		dev_info(&d->udev->dev, "%s: FC0013 tuner found",
-				KBUILD_MODNAME);
-		goto found;
-	}
-
-	/* check MT2266 ID register; reg=00 val=85 */
-	ret = rtl28xxu_ctrl_msg(d, &req_mt2266);
-	if (ret == 0 && buf[0] == 0x85) {
-		priv->tuner = TUNER_RTL2832_MT2266;
-		/* TODO implement tuner */
-		dev_info(&d->udev->dev, "%s: MT2266 tuner found",
-				KBUILD_MODNAME);
-		goto unsupported;
-	}
-
-	/* check FC2580 ID register; reg=01 val=56 */
-	ret = rtl28xxu_ctrl_msg(d, &req_fc2580);
-	if (ret == 0 && buf[0] == 0x56) {
-		priv->tuner = TUNER_RTL2832_FC2580;
+		break;
+	case TUNER_RTL2832_FC2580:
 		/* FIXME: do not abuse fc0012 settings */
 		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
-		dev_info(&d->udev->dev, "%s: FC2580 tuner found",
-				KBUILD_MODNAME);
-		goto found;
-	}
-
-	/* check MT2063 ID register; reg=00 val=9e || 9c */
-	ret = rtl28xxu_ctrl_msg(d, &req_mt2063);
-	if (ret == 0 && (buf[0] == 0x9e || buf[0] == 0x9c)) {
-		priv->tuner = TUNER_RTL2832_MT2063;
-		/* TODO implement tuner */
-		dev_info(&d->udev->dev, "%s: MT2063 tuner found",
-				KBUILD_MODNAME);
-		goto unsupported;
-	}
-
-	/* check MAX3543 ID register; reg=00 val=38 */
-	ret = rtl28xxu_ctrl_msg(d, &req_max3543);
-	if (ret == 0 && buf[0] == 0x38) {
-		priv->tuner = TUNER_RTL2832_MAX3543;
-		/* TODO implement tuner */
-		dev_info(&d->udev->dev, "%s: MAX3534 tuner found",
-				KBUILD_MODNAME);
-		goto unsupported;
-	}
-
-	/* check TUA9001 ID register; reg=7e val=2328 */
-	ret = rtl28xxu_ctrl_msg(d, &req_tua9001);
-	if (ret == 0 && buf[0] == 0x23 && buf[1] == 0x28) {
-		priv->tuner = TUNER_RTL2832_TUA9001;
+		break;
+	case TUNER_RTL2832_TUA9001:
 		rtl2832_config = &rtl28xxu_rtl2832_tua9001_config;
-		dev_info(&d->udev->dev, "%s: TUA9001 tuner found",
-				KBUILD_MODNAME);
-		goto found;
-	}
-
-	/* check MXL5007R ID register; reg=d9 val=14 */
-	ret = rtl28xxu_ctrl_msg(d, &req_mxl5007t);
-	if (ret == 0 && buf[0] == 0x14) {
-		priv->tuner = TUNER_RTL2832_MXL5007T;
-		/* TODO implement tuner */
-		dev_info(&d->udev->dev, "%s: MXL5007T tuner found",
-				KBUILD_MODNAME);
-		goto unsupported;
-	}
-
-	/* check E4000 ID register; reg=02 val=40 */
-	ret = rtl28xxu_ctrl_msg(d, &req_e4000);
-	if (ret == 0 && buf[0] == 0x40) {
-		priv->tuner = TUNER_RTL2832_E4000;
+		break;
+	case TUNER_RTL2832_E4000:
 		/* FIXME: do not abuse fc0012 settings */
 		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
-		dev_info(&d->udev->dev, "%s: E4000 tuner found",
-				KBUILD_MODNAME);
-		goto found;
-	}
-
-	/* check TDA18272 ID register; reg=00 val=c760  */
-	ret = rtl28xxu_ctrl_msg(d, &req_tda18272);
-	if (ret == 0 && (buf[0] == 0xc7 || buf[1] == 0x60)) {
-		priv->tuner = TUNER_RTL2832_TDA18272;
-		/* TODO implement tuner */
-		dev_info(&d->udev->dev, "%s: TDA18272 tuner found",
-				KBUILD_MODNAME);
-		goto unsupported;
-	}
-
-unsupported:
-	/* close demod I2C gate */
-	ret = rtl28xxu_ctrl_msg(d, &req_gate_close);
-	if (ret)
-		goto err;
-
-	/* tuner not found */
-	dev_dbg(&d->udev->dev, "%s: No compatible tuner found\n", __func__);
-	ret = -ENODEV;
-	return ret;
-
-found:
-	/* close demod I2C gate */
-	ret = rtl28xxu_ctrl_msg(d, &req_gate_close);
-	if (ret)
+		break;
+	default:
+		dev_err(&d->udev->dev, "%s: unknown tuner=%s\n",
+				KBUILD_MODNAME, priv->tuner_name);
+		ret = -ENODEV;
 		goto err;
+	}
 
 	/* attach demodulator */
-	adap->fe[0] = dvb_attach(rtl2832_attach, rtl2832_config,
-		&d->i2c_adap);
-		if (adap->fe[0] == NULL) {
-			ret = -ENODEV;
-			goto err;
-		}
+	adap->fe[0] = dvb_attach(rtl2832_attach, rtl2832_config, &d->i2c_adap);
+	if (!adap->fe[0]) {
+		ret = -ENODEV;
+		goto err;
+	}
 
-	/* set fe callbacks */
+	/* set fe callback */
 	adap->fe[0]->callback = rtl2832u_frontend_callback;
 
-	return ret;
-
+	return 0;
 err:
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
@@ -1304,6 +1300,7 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
 
 	.power_ctrl = rtl2832u_power_ctrl,
 	.i2c_algo = &rtl28xxu_i2c_algo,
+	.read_config = rtl2832u_read_config,
 	.frontend_attach = rtl2832u_frontend_attach,
 	.tuner_attach = rtl2832u_tuner_attach,
 	.init = rtl28xxu_init,
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index c6c8a4f..2f3af2d 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -53,6 +53,7 @@
 struct rtl28xxu_priv {
 	u8 chip_id;
 	u8 tuner;
+	char *tuner_name;
 	u8 page; /* integrated demod active register page */
 	bool rc_active;
 };
-- 
1.7.11.4

