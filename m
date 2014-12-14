Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49029 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaLNI3s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 03:29:48 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 02/18] rtl28xxu: use I2C binding for RTL2830 demod driver
Date: Sun, 14 Dec 2014 10:28:27 +0200
Message-Id: <1418545723-9536-2-git-send-email-crope@iki.fi>
In-Reply-To: <1418545723-9536-1-git-send-email-crope@iki.fi>
References: <1418545723-9536-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rtl2830 driver supports now I2C model too. Start using it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 80 +++++++++++++++------------------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h | 17 +++++++
 2 files changed, 54 insertions(+), 43 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 93bb7c9..4f94e0e 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -22,23 +22,6 @@
 
 #include "rtl28xxu.h"
 
-#include "rtl2830.h"
-#include "rtl2832.h"
-#include "rtl2832_sdr.h"
-#include "mn88472.h"
-#include "mn88473.h"
-
-#include "qt1010.h"
-#include "mt2060.h"
-#include "mxl5005s.h"
-#include "fc0012.h"
-#include "fc0013.h"
-#include "e4000.h"
-#include "fc2580.h"
-#include "tua9001.h"
-#include "r820t.h"
-
-
 #ifdef CONFIG_MEDIA_ATTACH
 #define dvb_attach_sdr(FUNCTION, ARGS...) ({ \
 	void *__r = NULL; \
@@ -572,10 +555,8 @@ err:
 	return ret;
 }
 
-static const struct rtl2830_config rtl28xxu_rtl2830_mt2060_config = {
-	.i2c_addr = 0x10, /* 0x20 */
-	.xtal = 28800000,
-	.ts_mode = 0,
+static const struct rtl2830_platform_data rtl2830_mt2060_platform_data = {
+	.clk = 28800000,
 	.spec_inv = 1,
 	.vtop = 0x20,
 	.krf = 0x04,
@@ -583,20 +564,16 @@ static const struct rtl2830_config rtl28xxu_rtl2830_mt2060_config = {
 
 };
 
-static const struct rtl2830_config rtl28xxu_rtl2830_qt1010_config = {
-	.i2c_addr = 0x10, /* 0x20 */
-	.xtal = 28800000,
-	.ts_mode = 0,
+static const struct rtl2830_platform_data rtl2830_qt1010_platform_data = {
+	.clk = 28800000,
 	.spec_inv = 1,
 	.vtop = 0x20,
 	.krf = 0x04,
 	.agc_targ_val = 0x2d,
 };
 
-static const struct rtl2830_config rtl28xxu_rtl2830_mxl5005s_config = {
-	.i2c_addr = 0x10, /* 0x20 */
-	.xtal = 28800000,
-	.ts_mode = 0,
+static const struct rtl2830_platform_data rtl2830_mxl5005s_platform_data = {
+	.clk = 28800000,
 	.spec_inv = 0,
 	.vtop = 0x3f,
 	.krf = 0x04,
@@ -607,20 +584,22 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
-	const struct rtl2830_config *rtl2830_config;
+	struct rtl2830_platform_data *pdata = &priv->rtl2830_platform_data;
+	struct i2c_board_info board_info;
+	struct i2c_client *client;
 	int ret;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	switch (priv->tuner) {
 	case TUNER_RTL2830_QT1010:
-		rtl2830_config = &rtl28xxu_rtl2830_qt1010_config;
+		*pdata = rtl2830_qt1010_platform_data;
 		break;
 	case TUNER_RTL2830_MT2060:
-		rtl2830_config = &rtl28xxu_rtl2830_mt2060_config;
+		*pdata = rtl2830_mt2060_platform_data;
 		break;
 	case TUNER_RTL2830_MXL5005S:
-		rtl2830_config = &rtl28xxu_rtl2830_mxl5005s_config;
+		*pdata = rtl2830_mxl5005s_platform_data;
 		break;
 	default:
 		dev_err(&d->udev->dev, "%s: unknown tuner=%s\n",
@@ -630,12 +609,28 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 
 	/* attach demodulator */
-	adap->fe[0] = dvb_attach(rtl2830_attach, rtl2830_config, &d->i2c_adap);
-	if (!adap->fe[0]) {
+	memset(&board_info, 0, sizeof(board_info));
+	strlcpy(board_info.type, "rtl2830", I2C_NAME_SIZE);
+	board_info.addr = 0x10;
+	board_info.platform_data = pdata;
+	request_module("%s", board_info.type);
+	client = i2c_new_device(&d->i2c_adap, &board_info);
+	if (client == NULL || client->dev.driver == NULL) {
 		ret = -ENODEV;
 		goto err;
 	}
 
+	if (!try_module_get(client->dev.driver->owner)) {
+		i2c_unregister_device(client);
+		ret = -ENODEV;
+		goto err;
+	}
+
+	adap->fe[0] = pdata->get_dvb_frontend(client);
+	priv->demod_i2c_adapter = pdata->get_i2c_adapter(client);
+
+	priv->i2c_client_demod = client;
+
 	return 0;
 err:
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
@@ -972,27 +967,25 @@ static int rtl2831u_tuner_attach(struct dvb_usb_adapter *adap)
 	int ret;
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
-	struct i2c_adapter *rtl2830_tuner_i2c;
 	struct dvb_frontend *fe;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
-	/* use rtl2830 driver I2C adapter, for more info see rtl2830 driver */
-	rtl2830_tuner_i2c = rtl2830_get_tuner_i2c_adapter(adap->fe[0]);
-
 	switch (priv->tuner) {
 	case TUNER_RTL2830_QT1010:
 		fe = dvb_attach(qt1010_attach, adap->fe[0],
-				rtl2830_tuner_i2c, &rtl28xxu_qt1010_config);
+				priv->demod_i2c_adapter,
+				&rtl28xxu_qt1010_config);
 		break;
 	case TUNER_RTL2830_MT2060:
 		fe = dvb_attach(mt2060_attach, adap->fe[0],
-				rtl2830_tuner_i2c, &rtl28xxu_mt2060_config,
-				1220);
+				priv->demod_i2c_adapter,
+				&rtl28xxu_mt2060_config, 1220);
 		break;
 	case TUNER_RTL2830_MXL5005S:
 		fe = dvb_attach(mxl5005s_attach, adap->fe[0],
-				rtl2830_tuner_i2c, &rtl28xxu_mxl5005s_config);
+				priv->demod_i2c_adapter,
+				&rtl28xxu_mxl5005s_config);
 		break;
 	default:
 		fe = NULL;
@@ -1585,6 +1578,7 @@ static const struct dvb_usb_device_properties rtl2831u_props = {
 	.i2c_algo = &rtl28xxu_i2c_algo,
 	.read_config = rtl2831u_read_config,
 	.frontend_attach = rtl2831u_frontend_attach,
+	.frontend_detach = rtl2832u_frontend_detach,
 	.tuner_attach = rtl2831u_tuner_attach,
 	.init = rtl28xxu_init,
 	.get_rc_config = rtl2831u_get_rc_config,
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index e52a2b7..3f630c8 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -24,6 +24,22 @@
 
 #include "dvb_usb.h"
 
+#include "rtl2830.h"
+#include "rtl2832.h"
+#include "rtl2832_sdr.h"
+#include "mn88472.h"
+#include "mn88473.h"
+
+#include "qt1010.h"
+#include "mt2060.h"
+#include "mxl5005s.h"
+#include "fc0012.h"
+#include "fc0013.h"
+#include "e4000.h"
+#include "fc2580.h"
+#include "tua9001.h"
+#include "r820t.h"
+
 /*
  * USB commands
  * (usb_control_msg() index parameter)
@@ -64,6 +80,7 @@ struct rtl28xxu_priv {
 	#define SLAVE_DEMOD_MN88472        1
 	#define SLAVE_DEMOD_MN88473        2
 	unsigned int slave_demod:2;
+	struct rtl2830_platform_data rtl2830_platform_data;
 };
 
 enum rtl28xxu_chip_id {
-- 
http://palosaari.fi/

