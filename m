Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39557 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2EFMqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 08:46:54 -0400
Received: by vbbff1 with SMTP id ff1so302894vbb.19
        for <linux-media@vger.kernel.org>; Sun, 06 May 2012 05:46:54 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 6 May 2012 14:46:53 +0200
Message-ID: <CAKZ=SG9U48d=eE3avccR-Auao5UMo0OANw8KKb=MP1XPtkHwmg@mail.gmail.com>
Subject: [PATCH v3 1/3] Modified RTL28xxU driver to work with RTL2832
From: Thomas Mair <thomas.mair86@googlemail.com>
To: linux-media@vger.kernel.org
Cc: hfvogt@gmx.net, poma <pomidorabelisima@gmail.com>,
	gennarone@gmail.com, Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

this is the first complete version of the rtl2832 demod driver. I
splitted the patches in three parts:
1. changes in the dvb-usb part (dvb_usb_rtl28xxu)
2. demod driver (rtl2832)
3. tuner driver (fc0012)

- added tuner probing with log output
- added callback for tuners to change UHF/VHF band
- moved and renamed tuner enums to own header file
- supported devices:
  - Terratec Cinergy T Stick Black
  - G-Tek Electronics Group Lifeview LV5TDLX DVB-T [RTL2832U]

Signed-off-by: Thomas Mair <thomas.mair86@googlemail.com>
---
 drivers/media/dvb/dvb-usb/rtl28xxu.c        |  604 ++++++++++++++++++++++-----
 drivers/media/dvb/dvb-usb/rtl28xxu.h        |   19 -
 drivers/media/dvb/dvb-usb/rtl28xxu_tuners.h |   42 ++
 3 files changed, 544 insertions(+), 121 deletions(-)
 create mode 100644 drivers/media/dvb/dvb-usb/rtl28xxu_tuners.h

diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c
b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index 8f4736a..00bd712 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2009 Antti Palosaari <crope@iki.fi>
  * Copyright (C) 2011 Antti Palosaari <crope@iki.fi>
+ * Copyright (C) 2012 Thomas Mair <thomas.mair86@googlemail.com>
  *
  *    This program is free software; you can redistribute it and/or modify
  *    it under the terms of the GNU General Public License as published by
@@ -20,17 +21,20 @@
  */

 #include "rtl28xxu.h"
+#include "rtl28xxu_tuners.h"

 #include "rtl2830.h"
+#include "rtl2832.h"

 #include "qt1010.h"
 #include "mt2060.h"
 #include "mxl5005s.h"
+#include "fc0012.h"
+

-/* debug */
 static int dvb_usb_rtl28xxu_debug;
 module_param_named(debug, dvb_usb_rtl28xxu_debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debugging level" DVB_USB_DEBUG_STATUS);
+MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);

 static int rtl28xxu_ctrl_msg(struct dvb_usb_device *d, struct
rtl28xxu_req *req)
@@ -76,11 +80,11 @@ static int rtl28xxu_ctrl_msg(struct dvb_usb_device
*d, struct rtl28xxu_req *req)

 	return ret;
 err:
-	deb_info("%s: failed=%d\n", __func__, ret);
+	deb_info("%s: failed=%d", __func__, ret);
 	return ret;
 }

-static int rtl2831_wr_regs(struct dvb_usb_device *d, u16 reg, u8 *val, int len)
+static int rtl28xx_wr_regs(struct dvb_usb_device *d, u16 reg, u8 *val, int len)
 {
 	struct rtl28xxu_req req;

@@ -98,7 +102,7 @@ static int rtl2831_wr_regs(struct dvb_usb_device
*d, u16 reg, u8 *val, int len)
 	return rtl28xxu_ctrl_msg(d, &req);
 }

-static int rtl2831_rd_regs(struct dvb_usb_device *d, u16 reg, u8 *val, int len)
+static int rtl28xx_rd_regs(struct dvb_usb_device *d, u16 reg, u8 *val, int len)
 {
 	struct rtl28xxu_req req;

@@ -116,14 +120,14 @@ static int rtl2831_rd_regs(struct dvb_usb_device
*d, u16 reg, u8 *val, int len)
 	return rtl28xxu_ctrl_msg(d, &req);
 }

-static int rtl2831_wr_reg(struct dvb_usb_device *d, u16 reg, u8 val)
+static int rtl28xx_wr_reg(struct dvb_usb_device *d, u16 reg, u8 val)
 {
-	return rtl2831_wr_regs(d, reg, &val, 1);
+	return rtl28xx_wr_regs(d, reg, &val, 1);
 }

-static int rtl2831_rd_reg(struct dvb_usb_device *d, u16 reg, u8 *val)
+static int rtl28xx_rd_reg(struct dvb_usb_device *d, u16 reg, u8 *val)
 {
-	return rtl2831_rd_regs(d, reg, val, 1);
+	return rtl28xx_rd_regs(d, reg, val, 1);
 }

 /* I2C */
@@ -297,7 +301,7 @@ static int rtl2831u_frontend_attach(struct
dvb_usb_adapter *adap)
 	/* for QT1010 tuner probe */
 	struct rtl28xxu_req req_qt1010 = { 0x0fc4, CMD_I2C_RD, 1, buf };

-	deb_info("%s:\n", __func__);
+	deb_info("%s:", __func__);

 	/*
 	 * RTL2831U GPIOs
@@ -308,12 +312,13 @@ static int rtl2831u_frontend_attach(struct
dvb_usb_adapter *adap)
 	 */

 	/* GPIO direction */
-	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_DIR, 0x0a);
+	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_DIR, 0x0a);
 	if (ret)
 		goto err;

+
 	/* enable as output GPIO0, GPIO2, GPIO4 */
-	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_OUT_EN, 0x15);
+	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_OUT_EN, 0x15);
 	if (ret)
 		goto err;

@@ -330,12 +335,12 @@ static int rtl2831u_frontend_attach(struct
dvb_usb_adapter *adap)
 	/* check QT1010 ID(?) register; reg=0f val=2c */
 	ret = rtl28xxu_ctrl_msg(adap->dev, &req_qt1010);
 	if (ret == 0 && buf[0] == 0x2c) {
-		priv->tuner = TUNER_RTL2830_QT1010;
+		priv->tuner = TUNER_RTL28XX_QT1010;
 		rtl2830_config = &rtl28xxu_rtl2830_qt1010_config;
-		deb_info("%s: QT1010\n", __func__);
+		deb_info("%s: QT1010", __func__);
 		goto found;
 	} else {
-		deb_info("%s: QT1010 probe failed=%d - %02x\n",
+		deb_info("%s: QT1010 probe failed=%d - %02x",
 			__func__, ret, buf[0]);
 	}

@@ -347,20 +352,20 @@ static int rtl2831u_frontend_attach(struct
dvb_usb_adapter *adap)
 	/* check MT2060 ID register; reg=00 val=63 */
 	ret = rtl28xxu_ctrl_msg(adap->dev, &req_mt2060);
 	if (ret == 0 && buf[0] == 0x63) {
-		priv->tuner = TUNER_RTL2830_MT2060;
+		priv->tuner = TUNER_RTL28XX_MT2060;
 		rtl2830_config = &rtl28xxu_rtl2830_mt2060_config;
-		deb_info("%s: MT2060\n", __func__);
+		deb_info("%s: MT2060", __func__);
 		goto found;
 	} else {
-		deb_info("%s: MT2060 probe failed=%d - %02x\n",
+		deb_info("%s: MT2060 probe failed=%d - %02x",
 			__func__, ret, buf[0]);
 	}

 	/* assume MXL5005S */
 	ret = 0;
-	priv->tuner = TUNER_RTL2830_MXL5005S;
+	priv->tuner = TUNER_RTL28XX_MXL5005S;
 	rtl2830_config = &rtl28xxu_rtl2830_mxl5005s_config;
-	deb_info("%s: MXL5005S\n", __func__);
+	deb_info("%s: MXL5005S", __func__);
 	goto found;

 found:
@@ -374,37 +379,143 @@ found:

 	return ret;
 err:
-	deb_info("%s: failed=%d\n", __func__, ret);
+	deb_info("%s: failed=%d", __func__, ret);
+	return ret;
+}
+
+static struct rtl2832_config rtl28xxu_rtl2832_fc0012_config = {
+	.i2c_addr = 0x10, /* 0x20 */
+	.xtal = 28800000,
+	.if_dvbt = 0,
+	.tuner = TUNER_RTL28XX_FC0012
+};
+
+
+static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
+		int cmd, int arg)
+{
+	int ret;
+	u8 val;
+
+	deb_info("%s cmd=%d arg=%d", __func__, cmd, arg);
+	switch (cmd) {
+	case FC0012_FE_CALLBACK_UHF_ENABLE:
+		/* set output values */
+
+		ret = rtl28xx_rd_reg(d, SYS_GPIO_DIR, &val);
+		if (ret)
+			goto err;
+
+		val &= 0xbf;
+
+		ret = rtl28xx_wr_reg(d, SYS_GPIO_DIR, val);
+		if (ret)
+			goto err;
+
+
+		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_EN, &val);
+		if (ret)
+			goto err;
+
+		val |= 0x40;
+
+		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_EN, val);
+		if (ret)
+			goto err;
+
+
+		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
+		if (ret)
+			goto err;
+
+		if (arg)
+			val &= 0xbf; /* set GPIO6 low */
+		else
+			val |= 0x40; /* set GPIO6 high */
+
+
+		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
+		if (ret)
+			goto err;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+	return 0;
+
+err:
+	err("%s: failed=%d", __func__, ret);
+
 	return ret;
 }

+static int rtl2832u_tuner_callback(struct dvb_usb_device *d, int cmd, int arg)
+{
+	struct rtl28xxu_priv *priv = d->priv;
+
+	switch (priv->tuner) {
+	case TUNER_RTL28XX_FC0012:
+		return rtl2832u_fc0012_tuner_callback(d, cmd, arg);
+	default:
+		break;
+	}
+
+	return -ENODEV;
+}
+
+static int rtl2832u_frontend_callback(void *adapter_priv, int component,
+				    int cmd, int arg)
+{
+	struct i2c_adapter *adap = adapter_priv;
+	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+
+	switch (component) {
+	case DVB_FRONTEND_COMPONENT_TUNER:
+		return rtl2832u_tuner_callback(d, cmd, arg);
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+
+
+
 static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
 	struct rtl28xxu_priv *priv = adap->dev->priv;
-	u8 buf[1];
+	struct rtl2832_config *rtl2832_config;
+
+	u8 buf[2];
 	/* open RTL2832U/RTL2832 I2C gate */
 	struct rtl28xxu_req req_gate_open = {0x0120, 0x0011, 0x0001, "\x18"};
 	/* close RTL2832U/RTL2832 I2C gate */
 	struct rtl28xxu_req req_gate_close = {0x0120, 0x0011, 0x0001, "\x10"};
+	/* for FC0012 tuner probe */
+	struct rtl28xxu_req req_fc0012 = {0x00c6, CMD_I2C_RD, 1, buf};
+	/* for FC0013 tuner probe */
+	struct rtl28xxu_req req_fc0013 = {0x00c6, CMD_I2C_RD, 1, buf};
+	/* for MT2266 tuner probe */
+	struct rtl28xxu_req req_mt2266 = {0x00c0, CMD_I2C_RD, 1, buf};
 	/* for FC2580 tuner probe */
 	struct rtl28xxu_req req_fc2580 = {0x01ac, CMD_I2C_RD, 1, buf};
-
-	deb_info("%s:\n", __func__);
-
-	/* GPIO direction */
-	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_DIR, 0x0a);
-	if (ret)
-		goto err;
-
-	/* enable as output GPIO0, GPIO2, GPIO4 */
-	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_OUT_EN, 0x15);
-	if (ret)
-		goto err;
-
-	ret = rtl2831_wr_reg(adap->dev, SYS_DEMOD_CTL, 0xe8);
-	if (ret)
-		goto err;
+	/* for MT2063 tuner probe */
+	struct rtl28xxu_req req_mt2063 = {0x00c0, CMD_I2C_RD, 1, buf};
+	/* for MAX3543 tuner probe */
+	struct rtl28xxu_req req_max3543 = {0x00c0, CMD_I2C_RD, 1, buf};
+	/* for TUA9001 tuner probe */
+	struct rtl28xxu_req req_tua9001 = {0x7ec0, CMD_I2C_RD, 2, buf};
+	/* for MXL5007T tuner probe */
+	struct rtl28xxu_req req_mxl5007t = {0xd9c0, CMD_I2C_RD, 1, buf};
+	/* for E4000 tuner probe */
+	struct rtl28xxu_req req_e4000 = {0x02c8, CMD_I2C_RD, 1, buf};
+	/* for TDA18272 tuner probe */
+	struct rtl28xxu_req req_tda18272 = {0x00c0, CMD_I2C_RD, 2, buf};
+
+	deb_info("%s:", __func__);

 	/*
 	 * Probe used tuner. We need to know used tuner before demod attach
@@ -416,15 +527,96 @@ static int rtl2832u_frontend_attach(struct
dvb_usb_adapter *adap)
 	if (ret)
 		goto err;

+	priv->tuner = TUNER_NONE;
+
+	/* check FC0012 ID register; reg=00 val=a1 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc0012);
+	if (ret == 0 && buf[0] == 0xa1) {
+		priv->tuner = TUNER_RTL28XX_FC0012;
+		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
+		info("%s: FC0012 tuner found", __func__);
+		goto found;
+	}
+
+	/* check FC0013 ID register; reg=00 val=a3 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc0013);
+	if (ret == 0 && buf[0] == 0xa3) {
+		priv->tuner = TUNER_RTL28XX_FC0013;
+		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
+		info("%s: FC0013 tuner found", __func__);
+		goto found;
+	}
+
+	/* check MT2266 ID register; reg=00 val=85 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_mt2266);
+	if (ret == 0 && buf[0] == 0x85) {
+		priv->tuner = TUNER_RTL28XX_MT2266;
+		/* TODO implement tuner */
+		info("%s: MT2266 tuner found", __func__);
+		goto found;
+	}
+
 	/* check FC2580 ID register; reg=01 val=56 */
 	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc2580);
 	if (ret == 0 && buf[0] == 0x56) {
-		priv->tuner = TUNER_RTL2832_FC2580;
-		deb_info("%s: FC2580\n", __func__);
+		priv->tuner = TUNER_RTL28XX_FC2580;
+		/* TODO implement tuner */
+		info("%s: FC2580 tuner found", __func__);
+		goto found;
+	}
+
+	/* check MT2063 ID register; reg=00 val=9e || 9c */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_mt2063);
+	if (ret == 0 && (buf[0] == 0x9e || buf[0] == 0x9c)) {
+		priv->tuner = TUNER_RTL28XX_MT2063;
+		/* TODO implement tuner */
+		info("%s: MT2063 tuner found", __func__);
+		goto found;
+	}
+
+	/* check MAX3543 ID register; reg=00 val=38 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_max3543);
+	if (ret == 0 && buf[0] == 0x38) {
+		priv->tuner = TUNER_RTL28XX_MAX3543;
+		/* TODO implement tuner */
+		info("%s: MAX3534 tuner found", __func__);
+		goto found;
+	}
+
+	/* check TUA9001 ID register; reg=7e val=2328 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_tua9001);
+	if (ret == 0 && buf[0] == 0x23 && buf[1] == 0x28) {
+		priv->tuner = TUNER_RTL28XX_TUA9001;
+		/* TODO implement tuner */
+		info("%s: TUA9001 tuner found", __func__);
+		goto found;
+	}
+
+	/* check MXL5007R ID register; reg=d9 val=14 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_mxl5007t);
+	if (ret == 0 && buf[0] == 0x14) {
+		priv->tuner = TUNER_RTL28XX_MXL5007T;
+		/* TODO implement tuner */
+		info("%s: MXL5007T tuner found", __func__);
+		goto found;
+	}
+
+	/* check E4000 ID register; reg=02 val=40 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_e4000);
+	if (ret == 0 && buf[0] == 0x40) {
+		priv->tuner = TUNER_RTL28XX_E4000;
+		/* TODO implement tuner */
+		info("%s: E4000 tuner found", __func__);
+		goto found;
+	}
+
+	/* check TDA18272 ID register; reg=00 val=c760  */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_tda18272);
+	if (ret == 0 && (buf[0] == 0xc7 || buf[1] == 0x60)) {
+		priv->tuner = TUNER_RTL28XX_TDA18272;
+		/* TODO implement tuner */
+		info("%s: TDA18272 tuner found", __func__);
 		goto found;
-	} else {
-		deb_info("%s: FC2580 probe failed=%d - %02x\n",
-			__func__, ret, buf[0]);
 	}

 	/* close demod I2C gate */
@@ -432,7 +624,9 @@ static int rtl2832u_frontend_attach(struct
dvb_usb_adapter *adap)
 	if (ret)
 		goto err;

+
 	/* tuner not found */
+	deb_info("No compatible tuner found");
 	ret = -ENODEV;
 	goto err;

@@ -443,11 +637,20 @@ found:
 		goto err;

 	/* attach demodulator */
-	/* TODO: */
+	adap->fe_adap[0].fe = dvb_attach(rtl2832_attach, rtl2832_config,
+		&adap->dev->i2c_adap);
+		if (adap->fe_adap[0].fe == NULL) {
+			ret = -ENODEV;
+			goto err;
+		}
+
+	/* set fe callbacks */
+	adap->fe_adap[0].fe->callback = rtl2832u_frontend_callback;

 	return ret;
+
 err:
-	deb_info("%s: failed=%d\n", __func__, ret);
+	deb_info("%s: failed=%d", __func__, ret);
 	return ret;
 }

@@ -484,22 +687,22 @@ static int rtl2831u_tuner_attach(struct
dvb_usb_adapter *adap)
 	struct i2c_adapter *rtl2830_tuner_i2c;
 	struct dvb_frontend *fe;

-	deb_info("%s:\n", __func__);
+	deb_info("%s:", __func__);

 	/* use rtl2830 driver I2C adapter, for more info see rtl2830 driver */
 	rtl2830_tuner_i2c = rtl2830_get_tuner_i2c_adapter(adap->fe_adap[0].fe);

 	switch (priv->tuner) {
-	case TUNER_RTL2830_QT1010:
+	case TUNER_RTL28XX_QT1010:
 		fe = dvb_attach(qt1010_attach, adap->fe_adap[0].fe,
 				rtl2830_tuner_i2c, &rtl28xxu_qt1010_config);
 		break;
-	case TUNER_RTL2830_MT2060:
+	case TUNER_RTL28XX_MT2060:
 		fe = dvb_attach(mt2060_attach, adap->fe_adap[0].fe,
 				rtl2830_tuner_i2c, &rtl28xxu_mt2060_config,
 				1220);
 		break;
-	case TUNER_RTL2830_MXL5005S:
+	case TUNER_RTL28XX_MXL5005S:
 		fe = dvb_attach(mxl5005s_attach, adap->fe_adap[0].fe,
 				rtl2830_tuner_i2c, &rtl28xxu_mxl5005s_config);
 		break;
@@ -515,7 +718,7 @@ static int rtl2831u_tuner_attach(struct
dvb_usb_adapter *adap)

 	return 0;
 err:
-	deb_info("%s: failed=%d\n", __func__, ret);
+	deb_info("%s: failed=%d", __func__, ret);
 	return ret;
 }

@@ -525,12 +728,13 @@ static int rtl2832u_tuner_attach(struct
dvb_usb_adapter *adap)
 	struct rtl28xxu_priv *priv = adap->dev->priv;
 	struct dvb_frontend *fe;

-	deb_info("%s:\n", __func__);
+	deb_info("%s:", __func__);

 	switch (priv->tuner) {
-	case TUNER_RTL2832_FC2580:
-		/* TODO: */
-		fe = NULL;
+	case TUNER_RTL28XX_FC0012:
+		fe = dvb_attach(fc0012_attach, adap->fe_adap[0].fe,
+			&adap->dev->i2c_adap, 0xc6>>1, FC_XTAL_28_8_MHZ);
+		return 0;
 		break;
 	default:
 		fe = NULL;
@@ -544,18 +748,18 @@ static int rtl2832u_tuner_attach(struct
dvb_usb_adapter *adap)

 	return 0;
 err:
-	deb_info("%s: failed=%d\n", __func__, ret);
+	deb_info("%s: failed=%d", __func__, ret);
 	return ret;
 }

-static int rtl28xxu_streaming_ctrl(struct dvb_usb_adapter *adap , int onoff)
+static int rtl2831u_streaming_ctrl(struct dvb_usb_adapter *adap , int onoff)
 {
 	int ret;
 	u8 buf[2], gpio;

-	deb_info("%s: onoff=%d\n", __func__, onoff);
+	deb_info("%s: onoff=%d", __func__, onoff);

-	ret = rtl2831_rd_reg(adap->dev, SYS_GPIO_OUT_VAL, &gpio);
+	ret = rtl28xx_rd_reg(adap->dev, SYS_GPIO_OUT_VAL, &gpio);
 	if (ret)
 		goto err;

@@ -569,43 +773,213 @@ static int rtl28xxu_streaming_ctrl(struct
dvb_usb_adapter *adap , int onoff)
 		gpio &= (~0x04); /* LED off */
 	}

-	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_OUT_VAL, gpio);
+	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_OUT_VAL, gpio);
 	if (ret)
 		goto err;

-	ret = rtl2831_wr_regs(adap->dev, USB_EPA_CTL, buf, 2);
+	ret = rtl28xx_wr_regs(adap->dev, USB_EPA_CTL, buf, 2);
 	if (ret)
 		goto err;

 	return ret;
 err:
-	deb_info("%s: failed=%d\n", __func__, ret);
+	deb_info("%s: failed=%d", __func__, ret);
 	return ret;
 }

-static int rtl28xxu_power_ctrl(struct dvb_usb_device *d, int onoff)
+static int rtl2832u_streaming_ctrl(struct dvb_usb_adapter *adap , int onoff)
+{
+	int ret;
+	u8 buf[2];
+
+	deb_info("%s: onoff=%d", __func__, onoff);
+
+
+	if (onoff) {
+		buf[0] = 0x00;
+		buf[1] = 0x00;
+	} else {
+		buf[0] = 0x10; /* stall EPA */
+		buf[1] = 0x02; /* reset EPA */
+	}
+
+	ret = rtl28xx_wr_regs(adap->dev, USB_EPA_CTL, buf, 2);
+	if (ret)
+		goto err;
+
+	return ret;
+err:
+	deb_info("%s: failed=%d", __func__, ret);
+	return ret;
+}
+
+
+static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
+{
+	int ret;
+	struct rtl28xxu_req req;
+	u8 val;
+
+	deb_info("%s: onoff=%d", __func__, onoff);
+
+	if (onoff) {
+		/* set output values */
+		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
+		if (ret)
+			goto err;
+
+		val |= 0x08;
+		val &= 0xef;
+
+		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
+		if (ret)
+			goto err;
+
+		/* enable as output GPIO3 */
+		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_EN, &val);
+		if (ret)
+			goto err;
+
+		val |= 0x08;
+
+		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_EN, val);
+		if (ret)
+			goto err;
+
+		/* demod_ctl_1 */
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL1, &val);
+		if (ret)
+			goto err;
+
+		val &= 0xef;
+
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL1, val);
+		if (ret)
+			goto err;
+
+		/* demod control */
+		/* PLL enable */
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
+		if (ret)
+			goto err;
+
+		/* bit 7 to 1 */
+		val |= 0x80;
+
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
+		if (ret)
+			goto err;
+
+		/* demod HW reset */
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
+		if (ret)
+			goto err;
+		/* bit 5 to 0 */
+		val &= 0xdf;
+
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
+		if (ret)
+			goto err;
+
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
+		if (ret)
+			goto err;
+
+		val |= 0x20;
+
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
+		if (ret)
+			goto err;
+
+		/* set page cache to 0 */
+		req.index = 0x0;
+		req.value = 0x20 + (1<<8);
+		req.data = &val;
+		req.size = 1;
+		ret = rtl28xxu_ctrl_msg(d, &req);
+		if (ret)
+			goto err;
+
+
+		mdelay(5);
+
+		/*enable ADC_Q and ADC_I */
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
+		if (ret)
+			goto err;
+
+		val |= 0x48;
+
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
+		if (ret)
+			goto err;
+
+
+	} else {
+		/* demod_ctl_1 */
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL1, &val);
+		if (ret)
+			goto err;
+
+		val |= 0x0c;
+
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL1, val);
+		if (ret)
+			goto err;
+
+		/* set output values */
+		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
+		if (ret)
+				goto err;
+
+		val |= 0x10;
+
+		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
+		if (ret)
+			goto err;
+
+		/* demod control */
+		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
+		if (ret)
+			goto err;
+
+		val &= 0x37;
+
+		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
+		if (ret)
+			goto err;
+
+	}
+
+	return ret;
+err:
+	deb_info("%s: failed=%d", __func__, ret);
+	return ret;
+}
+
+static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	int ret;
 	u8 gpio, sys0;

-	deb_info("%s: onoff=%d\n", __func__, onoff);
+	deb_info("%s: onoff=%d", __func__, onoff);

 	/* demod adc */
-	ret = rtl2831_rd_reg(d, SYS_SYS0, &sys0);
+	ret = rtl28xx_rd_reg(d, SYS_SYS0, &sys0);
 	if (ret)
 		goto err;

 	/* tuner power, read GPIOs */
-	ret = rtl2831_rd_reg(d, SYS_GPIO_OUT_VAL, &gpio);
+	ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &gpio);
 	if (ret)
 		goto err;

-	deb_info("%s: RD SYS0=%02x GPIO_OUT_VAL=%02x\n", __func__, sys0, gpio);
+	deb_info("%s: RD SYS0=%02x GPIO_OUT_VAL=%02x", __func__, sys0, gpio);

 	if (onoff) {
 		gpio |= 0x01; /* GPIO0 = 1 */
 		gpio &= (~0x10); /* GPIO4 = 0 */
-		sys0 = sys0 & 0x0f;
+		sys0 = sys0 & 0x0f; /* enable demod adc */
 		sys0 |= 0xe0;
 	} else {
 		gpio &= (~0x01); /* GPIO0 = 0 */
@@ -613,21 +987,21 @@ static int rtl28xxu_power_ctrl(struct
dvb_usb_device *d, int onoff)
 		sys0 = sys0 & (~0xc0);
 	}

-	deb_info("%s: WR SYS0=%02x GPIO_OUT_VAL=%02x\n", __func__, sys0, gpio);
+	deb_info("%s: WR SYS0=%02x GPIO_OUT_VAL=%02x", __func__, sys0, gpio);

 	/* demod adc */
-	ret = rtl2831_wr_reg(d, SYS_SYS0, sys0);
+	ret = rtl28xx_wr_reg(d, SYS_SYS0, sys0);
 	if (ret)
 		goto err;

 	/* tuner power, write GPIOs */
-	ret = rtl2831_wr_reg(d, SYS_GPIO_OUT_VAL, gpio);
+	ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, gpio);
 	if (ret)
 		goto err;

 	return ret;
 err:
-	deb_info("%s: failed=%d\n", __func__, ret);
+	deb_info("%s: failed=%d", __func__, ret);
 	return ret;
 }

@@ -657,7 +1031,7 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 	/* init remote controller */
 	if (!priv->rc_active) {
 		for (i = 0; i < ARRAY_SIZE(rc_nec_tab); i++) {
-			ret = rtl2831_wr_reg(d, rc_nec_tab[i].reg,
+			ret = rtl28xx_wr_reg(d, rc_nec_tab[i].reg,
 					rc_nec_tab[i].val);
 			if (ret)
 				goto err;
@@ -665,7 +1039,7 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 		priv->rc_active = true;
 	}

-	ret = rtl2831_rd_regs(d, SYS_IRRC_RP, buf, 5);
+	ret = rtl28xx_rd_regs(d, SYS_IRRC_RP, buf, 5);
 	if (ret)
 		goto err;

@@ -687,22 +1061,24 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)

 		rc_keydown(d->rc_dev, rc_code, 0);

-		ret = rtl2831_wr_reg(d, SYS_IRRC_SR, 1);
+		ret = rtl28xx_wr_reg(d, SYS_IRRC_SR, 1);
 		if (ret)
 			goto err;

 		/* repeated intentionally to avoid extra keypress */
-		ret = rtl2831_wr_reg(d, SYS_IRRC_SR, 1);
+		ret = rtl28xx_wr_reg(d, SYS_IRRC_SR, 1);
 		if (ret)
 			goto err;
 	}

 	return ret;
 err:
-	deb_info("%s: failed=%d\n", __func__, ret);
+	deb_info("%s: failed=%d", __func__, ret);
 	return ret;
 }

+/* unused for now */
+#if 0
 static int rtl2832u_rc_query(struct dvb_usb_device *d)
 {
 	int ret, i;
@@ -729,7 +1105,7 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 	/* init remote controller */
 	if (!priv->rc_active) {
 		for (i = 0; i < ARRAY_SIZE(rc_nec_tab); i++) {
-			ret = rtl2831_wr_reg(d, rc_nec_tab[i].reg,
+			ret = rtl28xx_wr_reg(d, rc_nec_tab[i].reg,
 					rc_nec_tab[i].val);
 			if (ret)
 				goto err;
@@ -737,37 +1113,40 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 		priv->rc_active = true;
 	}

-	ret = rtl2831_rd_reg(d, IR_RX_IF, &buf[0]);
+	ret = rtl28xx_rd_reg(d, IR_RX_IF, &buf[0]);
 	if (ret)
 		goto err;

 	if (buf[0] != 0x83)
 		goto exit;

-	ret = rtl2831_rd_reg(d, IR_RX_BC, &buf[0]);
+	ret = rtl28xx_rd_reg(d, IR_RX_BC, &buf[0]);
 	if (ret)
 		goto err;

 	len = buf[0];
-	ret = rtl2831_rd_regs(d, IR_RX_BUF, buf, len);
+	ret = rtl28xx_rd_regs(d, IR_RX_BUF, buf, len);

 	/* TODO: pass raw IR to Kernel IR decoder */

-	ret = rtl2831_wr_reg(d, IR_RX_IF, 0x03);
-	ret = rtl2831_wr_reg(d, IR_RX_BUF_CTRL, 0x80);
-	ret = rtl2831_wr_reg(d, IR_RX_CTRL, 0x80);
+	ret = rtl28xx_wr_reg(d, IR_RX_IF, 0x03);
+	ret = rtl28xx_wr_reg(d, IR_RX_BUF_CTRL, 0x80);
+	ret = rtl28xx_wr_reg(d, IR_RX_CTRL, 0x80);

 exit:
 	return ret;
 err:
-	deb_info("%s: failed=%d\n", __func__, ret);
+	deb_info("%s: failed=%d", __func__, ret);
 	return ret;
 }
+#endif

 enum rtl28xxu_usb_table_entry {
 	RTL2831U_0BDA_2831,
 	RTL2831U_14AA_0160,
 	RTL2831U_14AA_0161,
+	RTL2832U_0CCD_00A9,
+	RTL2832U_1F4D_B803,
 };

 static struct usb_device_id rtl28xxu_table[] = {
@@ -780,6 +1159,10 @@ static struct usb_device_id rtl28xxu_table[] = {
 		USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT_2)},

 	/* RTL2832U */
+	[RTL2832U_0CCD_00A9] = {
+		USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_BLACK)},
+	[RTL2832U_1F4D_B803] = {
+		USB_DEVICE(USB_VID_GTEK, USB_PID_GTEK)},
 	{} /* terminating entry */
 };

@@ -802,7 +1185,7 @@ static struct dvb_usb_device_properties
rtl28xxu_properties[] = {
 					{
 						.frontend_attach = rtl2831u_frontend_attach,
 						.tuner_attach    = rtl2831u_tuner_attach,
-						.streaming_ctrl  = rtl28xxu_streaming_ctrl,
+						.streaming_ctrl  = rtl2831u_streaming_ctrl,
 						.stream = {
 							.type = USB_BULK,
 							.count = 6,
@@ -818,7 +1201,7 @@ static struct dvb_usb_device_properties
rtl28xxu_properties[] = {
 			}
 		},

-		.power_ctrl = rtl28xxu_power_ctrl,
+		.power_ctrl = rtl2831u_power_ctrl,

 		.rc.core = {
 			.protocol       = RC_TYPE_NEC,
@@ -864,11 +1247,11 @@ static struct dvb_usb_device_properties
rtl28xxu_properties[] = {
 					{
 						.frontend_attach = rtl2832u_frontend_attach,
 						.tuner_attach    = rtl2832u_tuner_attach,
-						.streaming_ctrl  = rtl28xxu_streaming_ctrl,
+						.streaming_ctrl  = rtl2832u_streaming_ctrl,
 						.stream = {
 							.type = USB_BULK,
-							.count = 6,
-							.endpoint = 0x81,
+							.count = 10,
+							.endpoint = 0x01,
 							.u = {
 								.bulk = {
 									.buffersize = 8*512,
@@ -880,23 +1263,32 @@ static struct dvb_usb_device_properties
rtl28xxu_properties[] = {
 			}
 		},

-		.power_ctrl = rtl28xxu_power_ctrl,
+		.power_ctrl = rtl2832u_power_ctrl,

-		.rc.core = {
+		/*.rc.core = {
 			.protocol       = RC_TYPE_NEC,
 			.module_name    = "rtl28xxu",
 			.rc_query       = rtl2832u_rc_query,
 			.rc_interval    = 400,
 			.allowed_protos = RC_TYPE_NEC,
 			.rc_codes       = RC_MAP_EMPTY,
-		},
+		},*/

 		.i2c_algo = &rtl28xxu_i2c_algo,

-		.num_device_descs = 0, /* disabled as no support for RTL2832 */
+		.num_device_descs = 2,
 		.devices = {
 			{
-				.name = "Realtek RTL2832U reference design",
+				.name = "Terratec Cinergy T Stick Black",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_0CCD_00A9],
+				},
+			},
+			{
+				.name = "G-Tek Electronics Group Lifeview LV5TDLX DVB-T [RTL2832U]",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_1F4D_B803],
+				},
 			},
 		}
 	},
@@ -907,10 +1299,11 @@ static int rtl28xxu_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
 	int ret, i;
+	u8 val;
 	int properties_count = ARRAY_SIZE(rtl28xxu_properties);
 	struct dvb_usb_device *d;

-	deb_info("%s: interface=%d\n", __func__,
+	deb_info("%s: interface=%d", __func__,
 		intf->cur_altsetting->desc.bInterfaceNumber);

 	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
@@ -926,22 +1319,31 @@ static int rtl28xxu_probe(struct usb_interface *intf,
 	if (ret)
 		goto err;

+
 	/* init USB endpoints */
-	ret = rtl2831_wr_reg(d, USB_SYSCTL_0, 0x09);
+	ret = rtl28xx_rd_reg(d, USB_SYSCTL_0, &val);
+	if (ret)
+			goto err;
+
+	/* enable DMA and Full Packet Mode*/
+	val |= 0x09;
+	ret = rtl28xx_wr_reg(d, USB_SYSCTL_0, val);
 	if (ret)
 		goto err;

-	ret = rtl2831_wr_regs(d, USB_EPA_MAXPKT, "\x00\x02\x00\x00", 4);
+	/* set EPA maximum packet size to 0x0200 */
+	ret = rtl28xx_wr_regs(d, USB_EPA_MAXPKT, "\x00\x02\x00\x00", 4);
 	if (ret)
 		goto err;

-	ret = rtl2831_wr_regs(d, USB_EPA_FIFO_CFG, "\x14\x00\x00\x00", 4);
+	/* change EPA FIFO length */
+	ret = rtl28xx_wr_regs(d, USB_EPA_FIFO_CFG, "\x14\x00\x00\x00", 4);
 	if (ret)
 		goto err;

 	return ret;
 err:
-	deb_info("%s: failed=%d\n", __func__, ret);
+	deb_info("%s: failed=%d", __func__, ret);
 	return ret;
 }

@@ -957,8 +1359,6 @@ static int __init rtl28xxu_module_init(void)
 {
 	int ret;

-	deb_info("%s:\n", __func__);
-
 	ret = usb_register(&rtl28xxu_driver);
 	if (ret)
 		err("usb_register failed=%d", ret);
@@ -968,7 +1368,6 @@ static int __init rtl28xxu_module_init(void)

 static void __exit rtl28xxu_module_exit(void)
 {
-	deb_info("%s:\n", __func__);

 	/* deregister this driver from the USB subsystem */
 	usb_deregister(&rtl28xxu_driver);
@@ -979,4 +1378,5 @@ module_exit(rtl28xxu_module_exit);

 MODULE_DESCRIPTION("Realtek RTL28xxU DVB USB driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
+MODULE_AUTHOR("Thomas Mair <thomas.mair86@googlemail.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.h
b/drivers/media/dvb/dvb-usb/rtl28xxu.h
index 90f3bb4..55f7c50 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.h
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.h
@@ -84,25 +84,6 @@ enum rtl28xxu_chip_id {
 	CHIP_ID_RTL2832U,
 };

-enum rtl28xxu_tuner {
-	TUNER_NONE,
-
-	TUNER_RTL2830_QT1010,
-	TUNER_RTL2830_MT2060,
-	TUNER_RTL2830_MXL5005S,
-
-	TUNER_RTL2832_MT2266,
-	TUNER_RTL2832_FC2580,
-	TUNER_RTL2832_MT2063,
-	TUNER_RTL2832_MAX3543,
-	TUNER_RTL2832_TUA9001,
-	TUNER_RTL2832_MXL5007T,
-	TUNER_RTL2832_FC0012,
-	TUNER_RTL2832_E4000,
-	TUNER_RTL2832_TDA18272,
-	TUNER_RTL2832_FC0013,
-};
-
 struct rtl28xxu_req {
 	u16 value;
 	u16 index;
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu_tuners.h
b/drivers/media/dvb/dvb-usb/rtl28xxu_tuners.h
new file mode 100644
index 0000000..773e603
--- /dev/null
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu_tuners.h
@@ -0,0 +1,42 @@
+/*
+ * Realtek RTL28xxU DVB USB driver
+ *
+ * Copyright (C) 2009 Antti Palosaari <crope@iki.fi>
+ * Copyright (C) 2011 Antti Palosaari <crope@iki.fi>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License along
+ *    with this program; if not, write to the Free Software Foundation, Inc.,
+ *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef RTL28XXU_TUNERS_H
+#define RTL28XXU_TUNERS_H
+
+enum rtl28xxu_tuner {
+       TUNER_NONE,
+       TUNER_RTL28XX_QT1010,
+       TUNER_RTL28XX_MT2060,
+       TUNER_RTL28XX_MT2266,
+       TUNER_RTL28XX_MT2063,
+       TUNER_RTL28XX_MAX3543,
+       TUNER_RTL28XX_TUA9001,
+       TUNER_RTL28XX_MXL5005S,
+       TUNER_RTL28XX_MXL5007T,
+       TUNER_RTL28XX_FC2580,
+       TUNER_RTL28XX_FC0012,
+       TUNER_RTL28XX_FC0013,
+       TUNER_RTL28XX_E4000,
+       TUNER_RTL28XX_TDA18272,
+};
+
+#endif
-- 
1.7.7.6
