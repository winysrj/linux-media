Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46217 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab2ERSsk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 14:48:40 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so2596772bkc.19
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 11:48:39 -0700 (PDT)
From: Thomas Mair <thomas.mair86@googlemail.com>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi, pomidorabelisima@gmail.com,
	Thomas Mair <thomas.mair86@googlemail.com>
Subject: [PATCH v5 2/5] rtl28xxu: support for the rtl2832 demod driver
Date: Fri, 18 May 2012 20:47:41 +0200
Message-Id: <1337366864-1256-3-git-send-email-thomas.mair86@googlemail.com>
In-Reply-To: <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com>
References: <1>
 <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This only adds support for the Terratec Cinergy T Stick Black device.

Changes from previous patches:
- fixed compiler warnings
- added fc0013 tuner handling to this patch

Signed-off-by: Thomas Mair <thomas.mair86@googlemail.com>
---
 drivers/media/dvb/dvb-usb/Kconfig       |    3 +
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/rtl28xxu.c    |  450 +++++++++++++++++++++++++++++--
 3 files changed, 429 insertions(+), 25 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index be1db75..98dd0d8 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -417,9 +417,12 @@ config DVB_USB_RTL28XXU
 	tristate "Realtek RTL28xxU DVB USB support"
 	depends on DVB_USB && EXPERIMENTAL
 	select DVB_RTL2830
+	select DVB_RTL2832
 	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_FC0012 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_FC0013 if !MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to support the Realtek RTL28xxU DVB USB receiver.
 
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 7a6160b..cd9254c 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -160,6 +160,7 @@
 #define USB_PID_TERRATEC_CINERGY_T_STICK		0x0093
 #define USB_PID_TERRATEC_CINERGY_T_STICK_RC		0x0097
 #define USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC	0x0099
+#define USB_PID_TERRATEC_CINERGY_T_STICK_BLACK_REV1	0x00a9
 #define USB_PID_TWINHAN_VP7041_COLD			0x3201
 #define USB_PID_TWINHAN_VP7041_WARM			0x3202
 #define USB_PID_TWINHAN_VP7020_COLD			0x3203
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index 4e69e9d..5285f3d 100644
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
@@ -22,10 +23,13 @@
 #include "rtl28xxu.h"
 
 #include "rtl2830.h"
+#include "rtl2832.h"
 
 #include "qt1010.h"
 #include "mt2060.h"
 #include "mxl5005s.h"
+#include "fc0012.h"
+#include "fc0013.h"
 
 /* debug */
 static int dvb_usb_rtl28xxu_debug;
@@ -378,34 +382,159 @@ err:
 	return ret;
 }
 
+static struct rtl2832_config rtl28xxu_rtl2832_fc0012_config = {
+	.i2c_addr = 0x10, /* 0x20 */
+	.xtal = 28800000,
+	.if_dvbt = 0,
+	.tuner = TUNER_RTL2832_FC0012
+};
+
+static struct rtl2832_config rtl28xxu_rtl2832_fc0013_config = {
+	.i2c_addr = 0x10, /* 0x20 */
+	.xtal = 28800000,
+	.if_dvbt = 0,
+	.tuner = TUNER_RTL2832_FC0013
+};
+
+static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
+		int cmd, int arg)
+{
+	int ret;
+	u8 val;
+
+	deb_info("%s cmd=%d arg=%d\n", __func__, cmd, arg);
+	switch (cmd) {
+	case FC_FE_CALLBACK_VHF_ENABLE:
+		/* set output values */
+		ret = rtl2831_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
+		if (ret)
+			goto err;
+
+		if (arg)
+			val &= 0xbf; /* set GPIO6 low */
+		else
+			val |= 0x40; /* set GPIO6 high */
+
+
+		ret = rtl2831_wr_reg(d, SYS_GPIO_OUT_VAL, val);
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
+	err("%s: failed=%d\n", __func__, ret);
+
+	return ret;
+}
+
+
+static int rtl2832u_fc0013_tuner_callback(struct dvb_usb_device *d,
+		int cmd, int arg)
+{
+	/* TODO implement*/
+	return 0;
+}
+
+static int rtl2832u_tuner_callback(struct dvb_usb_device *d, int cmd, int arg)
+{
+	struct rtl28xxu_priv *priv = d->priv;
+
+	switch (priv->tuner) {
+	case TUNER_RTL2832_FC0012:
+		return rtl2832u_fc0012_tuner_callback(d, cmd, arg);
+
+	case TUNER_RTL2832_FC0013:
+		return rtl2832u_fc0013_tuner_callback(d, cmd, arg);
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
+	u8 buf[2], val;
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
 
 	deb_info("%s:\n", __func__);
 
-	/* GPIO direction */
-	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_DIR, 0x0a);
+
+	ret = rtl2831_rd_reg(adap->dev, SYS_GPIO_DIR, &val);
 	if (ret)
 		goto err;
 
-	/* enable as output GPIO0, GPIO2, GPIO4 */
-	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_OUT_EN, 0x15);
+	val &= 0xbf;
+
+	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_DIR, val);
 	if (ret)
 		goto err;
 
-	ret = rtl2831_wr_reg(adap->dev, SYS_DEMOD_CTL, 0xe8);
+
+	/* enable as output GPIO3 and GPIO6*/
+	ret = rtl2831_rd_reg(adap->dev, SYS_GPIO_OUT_EN, &val);
 	if (ret)
 		goto err;
 
+	val |= 0x48;
+
+	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_OUT_EN, val);
+	if (ret)
+		goto err;
+
+
+
 	/*
 	 * Probe used tuner. We need to know used tuner before demod attach
 	 * since there is some demod params needed to set according to tuner.
@@ -416,25 +545,108 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	if (ret)
 		goto err;
 
+	priv->tuner = TUNER_NONE;
+
+	/* check FC0012 ID register; reg=00 val=a1 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc0012);
+	if (ret == 0 && buf[0] == 0xa1) {
+		priv->tuner = TUNER_RTL2832_FC0012;
+		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
+		info("%s: FC0012 tuner found", __func__);
+		goto found;
+	}
+
+	/* check FC0013 ID register; reg=00 val=a3 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc0013);
+	if (ret == 0 && buf[0] == 0xa3) {
+		priv->tuner = TUNER_RTL2832_FC0013;
+		rtl2832_config = &rtl28xxu_rtl2832_fc0013_config;
+		info("%s: FC0013 tuner found", __func__);
+		goto found;
+	}
+
+	/* check MT2266 ID register; reg=00 val=85 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_mt2266);
+	if (ret == 0 && buf[0] == 0x85) {
+		priv->tuner = TUNER_RTL2832_MT2266;
+		/* TODO implement tuner */
+		info("%s: MT2266 tuner found", __func__);
+		goto unsupported;
+	}
+
 	/* check FC2580 ID register; reg=01 val=56 */
 	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc2580);
 	if (ret == 0 && buf[0] == 0x56) {
 		priv->tuner = TUNER_RTL2832_FC2580;
-		deb_info("%s: FC2580\n", __func__);
-		goto found;
-	} else {
-		deb_info("%s: FC2580 probe failed=%d - %02x\n",
-			__func__, ret, buf[0]);
+		/* TODO implement tuner */
+		info("%s: FC2580 tuner found", __func__);
+		goto unsupported;
+	}
+
+	/* check MT2063 ID register; reg=00 val=9e || 9c */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_mt2063);
+	if (ret == 0 && (buf[0] == 0x9e || buf[0] == 0x9c)) {
+		priv->tuner = TUNER_RTL2832_MT2063;
+		/* TODO implement tuner */
+		info("%s: MT2063 tuner found", __func__);
+		goto unsupported;
+	}
+
+	/* check MAX3543 ID register; reg=00 val=38 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_max3543);
+	if (ret == 0 && buf[0] == 0x38) {
+		priv->tuner = TUNER_RTL2832_MAX3543;
+		/* TODO implement tuner */
+		info("%s: MAX3534 tuner found", __func__);
+		goto unsupported;
 	}
 
+	/* check TUA9001 ID register; reg=7e val=2328 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_tua9001);
+	if (ret == 0 && buf[0] == 0x23 && buf[1] == 0x28) {
+		priv->tuner = TUNER_RTL2832_TUA9001;
+		/* TODO implement tuner */
+		info("%s: TUA9001 tuner found", __func__);
+		goto unsupported;
+	}
+
+	/* check MXL5007R ID register; reg=d9 val=14 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_mxl5007t);
+	if (ret == 0 && buf[0] == 0x14) {
+		priv->tuner = TUNER_RTL2832_MXL5007T;
+		/* TODO implement tuner */
+		info("%s: MXL5007T tuner found", __func__);
+		goto unsupported;
+	}
+
+	/* check E4000 ID register; reg=02 val=40 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_e4000);
+	if (ret == 0 && buf[0] == 0x40) {
+		priv->tuner = TUNER_RTL2832_E4000;
+		/* TODO implement tuner */
+		info("%s: E4000 tuner found", __func__);
+		goto unsupported;
+	}
+
+	/* check TDA18272 ID register; reg=00 val=c760  */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_tda18272);
+	if (ret == 0 && (buf[0] == 0xc7 || buf[1] == 0x60)) {
+		priv->tuner = TUNER_RTL2832_TDA18272;
+		/* TODO implement tuner */
+		info("%s: TDA18272 tuner found", __func__);
+		goto unsupported;
+	}
+
+unsupported:
 	/* close demod I2C gate */
 	ret = rtl28xxu_ctrl_msg(adap->dev, &req_gate_close);
 	if (ret)
 		goto err;
 
 	/* tuner not found */
+	deb_info("No compatible tuner found");
 	ret = -ENODEV;
-	goto err;
+	return ret;
 
 found:
 	/* close demod I2C gate */
@@ -443,9 +655,18 @@ found:
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
 	deb_info("%s: failed=%d\n", __func__, ret);
 	return ret;
@@ -528,10 +749,24 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 	deb_info("%s:\n", __func__);
 
 	switch (priv->tuner) {
-	case TUNER_RTL2832_FC2580:
-		/* TODO: */
-		fe = NULL;
+	case TUNER_RTL2832_FC0012:
+		fe = dvb_attach(fc0012_attach, adap->fe_adap[0].fe,
+			&adap->dev->i2c_adap, 0xc6>>1, 0, FC_XTAL_28_8_MHZ);
+
+		/* since fc0012 includs reading the signal strength delegate
+		 * that to the tuner driver */
+		adap->fe_adap[0].fe->ops.read_signal_strength = adap->fe_adap[0].
+				fe->ops.tuner_ops.get_rf_strength;
+		return 0;
 		break;
+	case TUNER_RTL2832_FC0013:
+		fe = dvb_attach(fc0013_attach, adap->fe_adap[0].fe,
+			&adap->dev->i2c_adap, 0xc6>>1, 0, FC_XTAL_28_8_MHZ);
+
+		/* fc0013 also supports signal strength reading */
+		adap->fe_adap[0].fe->ops.read_signal_strength = adap->fe_adap[0]
+			.fe->ops.tuner_ops.get_rf_strength;
+		return 0;
 	default:
 		fe = NULL;
 		err("unknown tuner=%d", priv->tuner);
@@ -548,7 +783,7 @@ err:
 	return ret;
 }
 
-static int rtl28xxu_streaming_ctrl(struct dvb_usb_adapter *adap , int onoff)
+static int rtl2831u_streaming_ctrl(struct dvb_usb_adapter *adap , int onoff)
 {
 	int ret;
 	u8 buf[2], gpio;
@@ -583,7 +818,33 @@ err:
 	return ret;
 }
 
-static int rtl28xxu_power_ctrl(struct dvb_usb_device *d, int onoff)
+static int rtl2832u_streaming_ctrl(struct dvb_usb_adapter *adap , int onoff)
+{
+	int ret;
+	u8 buf[2];
+
+	deb_info("%s: onoff=%d\n", __func__, onoff);
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
+	ret = rtl2831_wr_regs(adap->dev, USB_EPA_CTL, buf, 2);
+	if (ret)
+		goto err;
+
+	return ret;
+err:
+	deb_info("%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	int ret;
 	u8 gpio, sys0;
@@ -631,6 +892,128 @@ err:
 	return ret;
 }
 
+static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
+{
+	int ret;
+	u8 val;
+
+	deb_info("%s: onoff=%d\n", __func__, onoff);
+
+	if (onoff) {
+		/* set output values */
+		ret = rtl2831_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
+		if (ret)
+			goto err;
+
+		val |= 0x08;
+		val &= 0xef;
+
+		ret = rtl2831_wr_reg(d, SYS_GPIO_OUT_VAL, val);
+		if (ret)
+			goto err;
+
+		/* demod_ctl_1 */
+		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL1, &val);
+		if (ret)
+			goto err;
+
+		val &= 0xef;
+
+		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL1, val);
+		if (ret)
+			goto err;
+
+		/* demod control */
+		/* PLL enable */
+		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
+		if (ret)
+			goto err;
+
+		/* bit 7 to 1 */
+		val |= 0x80;
+
+		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
+		if (ret)
+			goto err;
+
+		/* demod HW reset */
+		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
+		if (ret)
+			goto err;
+		/* bit 5 to 0 */
+		val &= 0xdf;
+
+		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
+		if (ret)
+			goto err;
+
+		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
+		if (ret)
+			goto err;
+
+		val |= 0x20;
+
+		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
+		if (ret)
+			goto err;
+
+		mdelay(5);
+
+		/*enable ADC_Q and ADC_I */
+		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
+		if (ret)
+			goto err;
+
+		val |= 0x48;
+
+		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
+		if (ret)
+			goto err;
+
+
+	} else {
+		/* demod_ctl_1 */
+		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL1, &val);
+		if (ret)
+			goto err;
+
+		val |= 0x0c;
+
+		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL1, val);
+		if (ret)
+			goto err;
+
+		/* set output values */
+		ret = rtl2831_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
+		if (ret)
+				goto err;
+
+		val |= 0x10;
+
+		ret = rtl2831_wr_reg(d, SYS_GPIO_OUT_VAL, val);
+		if (ret)
+			goto err;
+
+		/* demod control */
+		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
+		if (ret)
+			goto err;
+
+		val &= 0x37;
+
+		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
+		if (ret)
+			goto err;
+
+	}
+
+	return ret;
+err:
+	deb_info("%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+
 static int rtl2831u_rc_query(struct dvb_usb_device *d)
 {
 	int ret, i;
@@ -768,6 +1151,7 @@ enum rtl28xxu_usb_table_entry {
 	RTL2831U_0BDA_2831,
 	RTL2831U_14AA_0160,
 	RTL2831U_14AA_0161,
+	RTL2832U_0CCD_00A9,
 };
 
 static struct usb_device_id rtl28xxu_table[] = {
@@ -780,6 +1164,8 @@ static struct usb_device_id rtl28xxu_table[] = {
 		USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT_2)},
 
 	/* RTL2832U */
+	[RTL2832U_0CCD_00A9] = {
+		USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_BLACK_REV1)},
 	{} /* terminating entry */
 };
 
@@ -802,7 +1188,7 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 					{
 						.frontend_attach = rtl2831u_frontend_attach,
 						.tuner_attach    = rtl2831u_tuner_attach,
-						.streaming_ctrl  = rtl28xxu_streaming_ctrl,
+						.streaming_ctrl  = rtl2831u_streaming_ctrl,
 						.stream = {
 							.type = USB_BULK,
 							.count = 6,
@@ -818,7 +1204,7 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 			}
 		},
 
-		.power_ctrl = rtl28xxu_power_ctrl,
+		.power_ctrl = rtl2831u_power_ctrl,
 
 		.rc.core = {
 			.protocol       = RC_TYPE_NEC,
@@ -864,7 +1250,7 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 					{
 						.frontend_attach = rtl2832u_frontend_attach,
 						.tuner_attach    = rtl2832u_tuner_attach,
-						.streaming_ctrl  = rtl28xxu_streaming_ctrl,
+						.streaming_ctrl  = rtl2832u_streaming_ctrl,
 						.stream = {
 							.type = USB_BULK,
 							.count = 6,
@@ -880,7 +1266,7 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 			}
 		},
 
-		.power_ctrl = rtl28xxu_power_ctrl,
+		.power_ctrl = rtl2832u_power_ctrl,
 
 		.rc.core = {
 			.protocol       = RC_TYPE_NEC,
@@ -893,10 +1279,13 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 
 		.i2c_algo = &rtl28xxu_i2c_algo,
 
-		.num_device_descs = 0, /* disabled as no support for RTL2832 */
+		.num_device_descs = 1,
 		.devices = {
 			{
-				.name = "Realtek RTL2832U reference design",
+				.name = "Terratec Cinergy T Stick Black",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_0CCD_00A9],
+				},
 			},
 		}
 	},
@@ -907,6 +1296,7 @@ static int rtl28xxu_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
 	int ret, i;
+	u8 val;
 	int properties_count = ARRAY_SIZE(rtl28xxu_properties);
 	struct dvb_usb_device *d;
 	struct usb_device *udev;
@@ -951,15 +1341,24 @@ static int rtl28xxu_probe(struct usb_interface *intf,
 	if (ret)
 		goto err;
 
+
 	/* init USB endpoints */
-	ret = rtl2831_wr_reg(d, USB_SYSCTL_0, 0x09);
+	ret = rtl2831_rd_reg(d, USB_SYSCTL_0, &val);
+	if (ret)
+			goto err;
+
+	/* enable DMA and Full Packet Mode*/
+	val |= 0x09;
+	ret = rtl2831_wr_reg(d, USB_SYSCTL_0, val);
 	if (ret)
 		goto err;
 
+	/* set EPA maximum packet size to 0x0200 */
 	ret = rtl2831_wr_regs(d, USB_EPA_MAXPKT, "\x00\x02\x00\x00", 4);
 	if (ret)
 		goto err;
 
+	/* change EPA FIFO length */
 	ret = rtl2831_wr_regs(d, USB_EPA_FIFO_CFG, "\x14\x00\x00\x00", 4);
 	if (ret)
 		goto err;
@@ -1004,4 +1403,5 @@ module_exit(rtl28xxu_module_exit);
 
 MODULE_DESCRIPTION("Realtek RTL28xxU DVB USB driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
+MODULE_AUTHOR("Thomas Mair <thomas.mair86@googlemail.com>");
 MODULE_LICENSE("GPL");
-- 
1.7.7.6

