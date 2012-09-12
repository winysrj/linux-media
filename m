Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41673 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758116Ab2ILC1q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 22:27:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Thomas Mair <mair.thomas86@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/8] rtl28xxu: add support for tua9001 tuner based devices
Date: Wed, 12 Sep 2012 05:27:09 +0300
Message-Id: <1347416831-1413-6-git-send-email-crope@iki.fi>
In-Reply-To: <1347416831-1413-1-git-send-email-crope@iki.fi>
References: <1347416831-1413-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 95 +++++++++++++++++++++++++++++++--
 1 file changed, 92 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index a62238f..31c9f44 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -32,6 +32,7 @@
 #include "fc0013.h"
 #include "e4000.h"
 #include "fc2580.h"
+#include "tua9001.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -399,6 +400,12 @@ static struct rtl2832_config rtl28xxu_rtl2832_fc0013_config = {
 	.tuner = TUNER_RTL2832_FC0013
 };
 
+static struct rtl2832_config rtl28xxu_rtl2832_tua9001_config = {
+	.i2c_addr = 0x10, /* 0x20 */
+	.xtal = 28800000,
+	.tuner = TUNER_RTL2832_TUA9001,
+};
+
 static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 		int cmd, int arg)
 {
@@ -443,6 +450,54 @@ static int rtl2832u_fc0013_tuner_callback(struct dvb_usb_device *d,
 	return 0;
 }
 
+static int rtl2832u_tua9001_tuner_callback(struct dvb_usb_device *d,
+		int cmd, int arg)
+{
+	int ret;
+	u8 val;
+
+	dev_dbg(&d->udev->dev, "%s: cmd=%d arg=%d\n", __func__, cmd, arg);
+
+	/*
+	 * CEN     always enabled by hardware wiring
+	 * RESETN  GPIO4
+	 * RXEN    GPIO1
+	 */
+
+	ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
+	if (ret < 0)
+		goto err;
+
+	switch (cmd) {
+	case TUA9001_CMD_RESETN:
+		if (arg)
+			val |= (1 << 4);
+		else
+			val &= ~(1 << 4);
+
+		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
+		if (ret < 0)
+			goto err;
+		break;
+	case TUA9001_CMD_RXEN:
+		if (arg)
+			val |= (1 << 1);
+		else
+			val &= ~(1 << 1);
+
+		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
+		if (ret < 0)
+			goto err;
+		break;
+	}
+
+	return 0;
+
+err:
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
 static int rtl2832u_tuner_callback(struct dvb_usb_device *d, int cmd, int arg)
 {
 	struct rtl28xxu_priv *priv = d->priv;
@@ -453,6 +508,9 @@ static int rtl2832u_tuner_callback(struct dvb_usb_device *d, int cmd, int arg)
 
 	case TUNER_RTL2832_FC0013:
 		return rtl2832u_fc0013_tuner_callback(d, cmd, arg);
+
+	case TUNER_RTL2832_TUA9001:
+		return rtl2832u_tua9001_tuner_callback(d, cmd, arg);
 	default:
 		break;
 	}
@@ -608,10 +666,10 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	ret = rtl28xxu_ctrl_msg(d, &req_tua9001);
 	if (ret == 0 && buf[0] == 0x23 && buf[1] == 0x28) {
 		priv->tuner = TUNER_RTL2832_TUA9001;
-		/* TODO implement tuner */
+		rtl2832_config = &rtl28xxu_rtl2832_tua9001_config;
 		dev_info(&d->udev->dev, "%s: TUA9001 tuner found",
 				KBUILD_MODNAME);
-		goto unsupported;
+		goto found;
 	}
 
 	/* check MXL5007R ID register; reg=d9 val=14 */
@@ -760,12 +818,17 @@ static const struct fc2580_config rtl2832u_fc2580_config = {
 	.clock = 16384000,
 };
 
+static struct tua9001_config rtl2832u_tua9001_config = {
+	.i2c_addr = 0x60,
+};
+
 static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
 	struct dvb_frontend *fe;
+	u8 val;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
@@ -796,6 +859,33 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		fe = dvb_attach(fc2580_attach, adap->fe[0], &d->i2c_adap,
 				&rtl2832u_fc2580_config);
 		break;
+	case TUNER_RTL2832_TUA9001:
+		/* enable GPIO1 and GPIO4 as output */
+		ret = rtl28xx_rd_reg(d, SYS_GPIO_DIR, &val);
+		if (ret < 0)
+			goto err;
+
+		val &= ~(1 << 1);
+		val &= ~(1 << 4);
+
+		ret = rtl28xx_wr_reg(d, SYS_GPIO_DIR, val);
+		if (ret < 0)
+			goto err;
+
+		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_EN, &val);
+		if (ret < 0)
+			goto err;
+
+		val |= (1 << 1);
+		val |= (1 << 4);
+
+		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_EN, val);
+		if (ret < 0)
+			goto err;
+
+		fe = dvb_attach(tua9001_attach, adap->fe[0], &d->i2c_adap,
+				&rtl2832u_tua9001_config);
+		break;
 	default:
 		fe = NULL;
 		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
@@ -978,7 +1068,6 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 		if (ret)
 			goto err;
 
-
 		/* streaming EP: clear stall & reset */
 		ret = rtl28xx_wr_regs(d, USB_EPA_CTL, "\x00\x00", 2);
 		if (ret)
-- 
1.7.11.4

