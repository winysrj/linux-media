Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38282 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab3CJCEk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:40 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 18/41] it913x: get rid of it913x config struct
Date: Sun, 10 Mar 2013 04:03:10 +0200
Message-Id: <1362881013-5271-18-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't need it. Tuner ID and device address are enough.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c         | 38 +++++++++++++++++++++--------------
 drivers/media/tuners/it913x.h         | 22 ++++++--------------
 drivers/media/usb/dvb-usb-v2/af9035.c | 18 +----------------
 3 files changed, 30 insertions(+), 48 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index de20da1..66d4b72 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -25,7 +25,8 @@
 struct it913x_state {
 	struct dvb_frontend frontend;
 	struct i2c_adapter *i2c_adap;
-	struct ite_config *config;
+	u8 chip_ver;
+	u8 firmware_ver;
 	u8 i2c_addr;
 	u32 frequency;
 	fe_modulation_t constellation;
@@ -156,7 +157,7 @@ static int it913x_init(struct dvb_frontend *fe)
 	u8 b[2];
 
 	/* v1 or v2 tuner script */
-	if (state->config->chip_ver > 1)
+	if (state->chip_ver > 1)
 		ret = it913x_script_loader(state, it9135_v2);
 	else
 		ret = it913x_script_loader(state, it9135_v1);
@@ -190,7 +191,7 @@ static int it913x_init(struct dvb_frontend *fe)
 	if (ret < 0)
 		return ret;
 
-	if (state->config->chip_ver == 2) {
+	if (state->chip_ver == 2) {
 		ret = it913x_wr_reg(state, PRO_DMOD, TRIGGER_OFSM, 0x1);
 		if (ret < 0)
 			return -ENODEV;
@@ -237,7 +238,7 @@ static int it913x_init(struct dvb_frontend *fe)
 	state->tun_fn_min /= (state->tun_fdiv * nv_val);
 	pr_debug("Tuner fn_min %d\n", state->tun_fn_min);
 
-	if (state->config->chip_ver > 1)
+	if (state->chip_ver > 1)
 		msleep(50);
 	else {
 		for (i = 0; i < 50; i++) {
@@ -276,7 +277,7 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	u8 lna_band;
 	u8 bw;
 
-	if (state->config->firmware_ver == 1)
+	if (state->firmware_ver == 1)
 		set_tuner = set_it9135_template;
 	else
 		set_tuner = set_it9137_template;
@@ -440,40 +441,47 @@ static const struct dvb_tuner_ops it913x_tuner_ops = {
 };
 
 struct dvb_frontend *it913x_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c_adap, u8 i2c_addr, struct ite_config *config)
+		struct i2c_adapter *i2c_adap, u8 i2c_addr, u8 config)
 {
 	struct it913x_state *state = NULL;
-	int ret;
 
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct it913x_state), GFP_KERNEL);
 	if (state == NULL)
 		return NULL;
-	if (config == NULL)
-		goto error;
 
 	state->i2c_adap = i2c_adap;
 	state->i2c_addr = i2c_addr;
-	state->config = config;
 
-	switch (state->config->tuner_id_0) {
+	switch (config) {
+	case IT9135_38:
 	case IT9135_51:
 	case IT9135_52:
+		state->chip_ver = 0x01;
+		break;
 	case IT9135_60:
 	case IT9135_61:
 	case IT9135_62:
-		state->tuner_type = state->config->tuner_id_0;
+		state->chip_ver = 0x02;
 		break;
 	default:
-	case IT9135_38:
-		state->tuner_type = IT9135_38;
+		dev_dbg(&i2c_adap->dev,
+				"%s: invalid config=%02x\n", __func__, config);
+		goto error;
 	}
 
+	state->tuner_type = config;
+	state->firmware_ver = 1;
+
 	fe->tuner_priv = state;
 	memcpy(&fe->ops.tuner_ops, &it913x_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
 
-	pr_info("%s: ITE Tech IT913X attached\n", KBUILD_MODNAME);
+	dev_info(&i2c_adap->dev,
+			"%s: ITE Tech IT913X successfully attached\n",
+			KBUILD_MODNAME);
+	dev_dbg(&i2c_adap->dev, "%s: config=%02x chip_ver=%02x\n",
+			__func__, config, state->chip_ver);
 
 	return fe;
 error:
diff --git a/drivers/media/tuners/it913x.h b/drivers/media/tuners/it913x.h
index 3583e56..12dd36b 100644
--- a/drivers/media/tuners/it913x.h
+++ b/drivers/media/tuners/it913x.h
@@ -25,27 +25,17 @@
 
 #include "dvb_frontend.h"
 
-struct ite_config {
-	u8 chip_ver;
-	u16 chip_type;
-	u32 firmware;
-	u8 firmware_ver;
-	u8 adc_x2;
-	u8 tuner_id_0;
-	u8 tuner_id_1;
-	u8 dual_mode;
-	u8 adf;
-	/* option to read SIGNAL_LEVEL */
-	u8 read_slevel;
-};
-
 #if defined(CONFIG_MEDIA_TUNER_IT913X) || \
 	(defined(CONFIG_MEDIA_TUNER_IT913X_MODULE) && defined(MODULE))
 extern struct dvb_frontend *it913x_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c_adap, u8 i2c_addr, struct ite_config *config);
+	struct i2c_adapter *i2c_adap,
+	u8 i2c_addr,
+	u8 config);
 #else
 static inline struct dvb_frontend *it913x_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c_adap, u8 i2c_addr, struct ite_config *config)
+	struct i2c_adapter *i2c_adap,
+	u8 i2c_addr,
+	u8 config)
 {
 	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 1db9c76..a220a12 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -978,20 +978,6 @@ static const struct fc0012_config af9035_fc0012_config[] = {
 	}
 };
 
-static struct ite_config af9035_it913x_config = {
-	.chip_ver = 0x02,
-	.chip_type = 0x9135,
-	.firmware = 0x00000000,
-	.firmware_ver = 1,
-	.adc_x2 = 1,
-	.tuner_id_0 = 0x00,
-	.tuner_id_1 = 0x00,
-	.dual_mode = 0x00,
-	.adf = 0x00,
-	/* option to read SIGNAL_LEVEL */
-	.read_slevel = 0,
-};
-
 static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
@@ -1159,15 +1145,13 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
 	case AF9033_TUNER_IT9135_52:
-		af9035_it913x_config.chip_ver = 0x01;
 	case AF9033_TUNER_IT9135_60:
 	case AF9033_TUNER_IT9135_61:
 	case AF9033_TUNER_IT9135_62:
-		af9035_it913x_config.tuner_id_0 = state->af9033_config[0].tuner;
 		/* attach tuner */
 		fe = dvb_attach(it913x_attach, adap->fe[0], &d->i2c_adap,
 				state->af9033_config[adap->id].i2c_addr,
-				&af9035_it913x_config);
+				state->af9033_config[0].tuner);
 		break;
 	default:
 		fe = NULL;
-- 
1.7.11.7

