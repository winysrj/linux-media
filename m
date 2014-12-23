Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60592 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756653AbaLWUuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:35 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 47/66] rtl28xxu: switch SDR module to platform driver
Date: Tue, 23 Dec 2014 22:49:40 +0200
Message-Id: <1419367799-14263-47-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RTL2832 SDR module implements kernel platform driver. Change old
binding to that one.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 126 ++++++++++++--------------------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |   3 +
 2 files changed, 50 insertions(+), 79 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c64b5ed..c2d377f 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -22,25 +22,6 @@
 
 #include "rtl28xxu.h"
 
-#ifdef CONFIG_MEDIA_ATTACH
-#define dvb_attach_sdr(FUNCTION, ARGS...) ({ \
-	void *__r = NULL; \
-	typeof(&FUNCTION) __a = symbol_request(FUNCTION); \
-	if (__a) { \
-		__r = (void *) __a(ARGS); \
-		if (__r == NULL) \
-			symbol_put(FUNCTION); \
-	} \
-	__r; \
-})
-
-#else
-#define dvb_attach_sdr(FUNCTION, ARGS...) ({ \
-	FUNCTION(ARGS); \
-})
-
-#endif
-
 static int rtl28xxu_disable_rc;
 module_param_named(disable_rc, rtl28xxu_disable_rc, int, 0644);
 MODULE_PARM_DESC(disable_rc, "disable RTL2832U remote controller");
@@ -662,37 +643,6 @@ static const struct rtl2832_platform_data rtl2832_r820t_platform_data = {
 	.tuner = TUNER_RTL2832_R820T,
 };
 
-/* TODO: these are redundant information for rtl2832_sdr driver */
-static const struct rtl2832_config rtl28xxu_rtl2832_fc0012_config = {
-	.i2c_addr = 0x10, /* 0x20 */
-	.xtal = 28800000,
-	.tuner = TUNER_RTL2832_FC0012
-};
-
-static const struct rtl2832_config rtl28xxu_rtl2832_fc0013_config = {
-	.i2c_addr = 0x10, /* 0x20 */
-	.xtal = 28800000,
-	.tuner = TUNER_RTL2832_FC0013
-};
-
-static const struct rtl2832_config rtl28xxu_rtl2832_tua9001_config = {
-	.i2c_addr = 0x10, /* 0x20 */
-	.xtal = 28800000,
-	.tuner = TUNER_RTL2832_TUA9001,
-};
-
-static const struct rtl2832_config rtl28xxu_rtl2832_e4000_config = {
-	.i2c_addr = 0x10, /* 0x20 */
-	.xtal = 28800000,
-	.tuner = TUNER_RTL2832_E4000,
-};
-
-static const struct rtl2832_config rtl28xxu_rtl2832_r820t_config = {
-	.i2c_addr = 0x10,
-	.xtal = 28800000,
-	.tuner = TUNER_RTL2832_R820T,
-};
-
 static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 		int cmd, int arg)
 {
@@ -1062,10 +1012,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 	int ret;
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
-	struct rtl2832_platform_data *pdata = &priv->rtl2832_platform_data;
 	struct dvb_frontend *fe = NULL;
 	struct i2c_board_info info;
 	struct i2c_client *client;
+	struct v4l2_subdev *subdev = NULL;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
@@ -1080,10 +1030,6 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		 * that to the tuner driver */
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
-
-		/* attach SDR */
-		dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
-				&rtl28xxu_rtl2832_fc0012_config, NULL);
 		break;
 	case TUNER_RTL2832_FC0013:
 		fe = dvb_attach(fc0013_attach, adap->fe[0],
@@ -1092,16 +1038,8 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		/* fc0013 also supports signal strength reading */
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
-
-		/* attach SDR */
-		dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
-				&rtl28xxu_rtl2832_fc0013_config, NULL);
 		break;
 	case TUNER_RTL2832_E4000: {
-			struct v4l2_subdev *sd;
-			struct i2c_adapter *i2c_adap_internal =
-					pdata->get_private_i2c_adapter(priv->i2c_client_demod);
-
 			struct e4000_config e4000_config = {
 				.fe = adap->fe[0],
 				.clock = 28800000,
@@ -1122,13 +1060,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 			}
 
 			priv->i2c_client_tuner = client;
-			sd = i2c_get_clientdata(client);
-			i2c_set_adapdata(i2c_adap_internal, d);
-
-			/* attach SDR */
-			dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0],
-					i2c_adap_internal,
-					&rtl28xxu_rtl2832_e4000_config, sd);
+			subdev = i2c_get_clientdata(client);
 		}
 		break;
 	case TUNER_RTL2832_FC2580:
@@ -1158,10 +1090,6 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		/* Use tuner to get the signal strength */
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
-
-		/* attach SDR */
-		dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
-				&rtl28xxu_rtl2832_r820t_config, NULL);
 		break;
 	case TUNER_RTL2832_R828D:
 		fe = dvb_attach(r820t_attach, adap->fe[0],
@@ -1177,21 +1105,53 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 			adap->fe[1]->ops.read_signal_strength =
 					adap->fe[1]->ops.tuner_ops.get_rf_strength;
 		}
-
-		/* attach SDR */
-		dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
-				&rtl28xxu_rtl2832_r820t_config, NULL);
 		break;
 	default:
 		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
 				priv->tuner);
 	}
-
 	if (fe == NULL && priv->i2c_client_tuner == NULL) {
 		ret = -ENODEV;
 		goto err;
 	}
 
+	/* register SDR */
+	switch (priv->tuner) {
+		struct platform_device *pdev;
+		struct rtl2832_sdr_platform_data pdata = {};
+
+	case TUNER_RTL2832_FC0012:
+	case TUNER_RTL2832_FC0013:
+	case TUNER_RTL2832_E4000:
+	case TUNER_RTL2832_R820T:
+	case TUNER_RTL2832_R828D:
+		pdata.clk = priv->rtl2832_platform_data.clk;
+		pdata.tuner = priv->tuner;
+		pdata.i2c_client = priv->i2c_client_demod;
+		pdata.bulk_read = priv->rtl2832_platform_data.bulk_read;
+		pdata.bulk_write = priv->rtl2832_platform_data.bulk_write;
+		pdata.update_bits = priv->rtl2832_platform_data.update_bits;
+		pdata.dvb_frontend = adap->fe[0];
+		pdata.dvb_usb_device = d;
+		pdata.v4l2_subdev = subdev;
+
+		request_module("%s", "rtl2832_sdr");
+		pdev = platform_device_register_data(&priv->i2c_client_demod->dev,
+						     "rtl2832_sdr",
+						     PLATFORM_DEVID_AUTO,
+						     &pdata, sizeof(pdata));
+		if (pdev == NULL || pdev->dev.driver == NULL)
+			break;
+		if (!try_module_get(pdev->dev.driver->owner)) {
+			platform_device_unregister(pdev);
+			break;
+		}
+		priv->platform_device_sdr = pdev;
+		break;
+	default:
+		dev_dbg(&d->udev->dev, "no SDR for tuner=%d\n", priv->tuner);
+	}
+
 	return 0;
 err:
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
@@ -1203,9 +1163,17 @@ static int rtl2832u_tuner_detach(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
 	struct i2c_client *client;
+	struct platform_device *pdev;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
+	/* remove platform SDR */
+	pdev = priv->platform_device_sdr;
+	if (pdev) {
+		module_put(pdev->dev.driver->owner);
+		platform_device_unregister(pdev);
+	}
+
 	/* remove I2C tuner */
 	client = priv->i2c_client_tuner;
 	if (client) {
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index cb3fc65..62d3249 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -22,6 +22,8 @@
 #ifndef RTL28XXU_H
 #define RTL28XXU_H
 
+#include <linux/platform_device.h>
+
 #include "dvb_usb.h"
 
 #include "rtl2830.h"
@@ -76,6 +78,7 @@ struct rtl28xxu_priv {
 	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
 	struct i2c_client *i2c_client_slave_demod;
+	struct platform_device *platform_device_sdr;
 	#define SLAVE_DEMOD_NONE           0
 	#define SLAVE_DEMOD_MN88472        1
 	#define SLAVE_DEMOD_MN88473        2
-- 
http://palosaari.fi/

