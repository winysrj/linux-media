Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40311 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab3CJCEi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:38 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [REVIEW PATCH 03/41] af9035: add support for 1st gen it9135
Date: Sun, 10 Mar 2013 04:02:55 +0200
Message-Id: <1362881013-5271-3-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Kconfig  |  1 +
 drivers/media/usb/dvb-usb-v2/af9035.c | 24 +++++++++++++++++++++++-
 drivers/media/usb/dvb-usb-v2/af9035.h |  1 +
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 692224d..2d4abfa 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -41,6 +41,7 @@ config DVB_USB_AF9035
 	select MEDIA_TUNER_MXL5007T if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18218 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_FC2580 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_IT913X if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Afatech AF9035 based DVB USB receiver.
 
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index f11cc42..d57fbb1 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -652,6 +652,10 @@ static int af9035_read_config_it9135(struct dvb_usb_device *d)
 	int ret, i;
 	u8 tmp;
 
+	/* demod I2C "address" */
+	state->af9033_config[0].i2c_addr = 0x38;
+	state->af9033_config[0].tuner = AF9033_TUNER_IT9135_38;
+	state->af9033_config[0].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 	state->dual_mode = false;
 
 	/* get demod clock */
@@ -920,6 +924,20 @@ static const struct fc0012_config af9035_fc0012_config[] = {
 	}
 };
 
+static struct ite_config af9035_it913x_config = {
+	.chip_ver = 0x01,
+	.chip_type = 0x9135,
+	.firmware = 0x00000000,
+	.firmware_ver = 1,
+	.adc_x2 = 1,
+	.tuner_id_0 = AF9033_TUNER_IT9135_38,
+	.tuner_id_1 = 0x00,
+	.dual_mode = 0x00,
+	.adf = 0x00,
+	/* option to read SIGNAL_LEVEL */
+	.read_slevel = 0,
+};
+
 static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
@@ -1082,6 +1100,11 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 		fe = dvb_attach(fc0012_attach, adap->fe[0], &d->i2c_adap,
 				&af9035_fc0012_config[adap->id]);
 		break;
+	case AF9033_TUNER_IT9135_38:
+		/* attach tuner */
+		fe = dvb_attach(it913x_attach, adap->fe[0],
+				&d->i2c_adap, 0x38, &af9035_it913x_config);
+		break;
 	default:
 		fe = NULL;
 	}
@@ -1275,7 +1298,6 @@ static const struct dvb_usb_device_properties it9135_props = {
 	.frontend_attach = af9035_frontend_attach,
 	.tuner_attach = af9035_tuner_attach,
 	.init = af9035_init,
-	.get_rc_config = af9035_get_rc_config,
 
 	.num_adapters = 1,
 	.adapter = {
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 29f3eec..9556bab 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -30,6 +30,7 @@
 #include "mxl5007t.h"
 #include "tda18218.h"
 #include "fc2580.h"
+#include "it913x.h"
 
 struct reg_val {
 	u32 reg;
-- 
1.7.11.7

