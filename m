Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57598 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbAAPvo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jan 2015 10:51:44 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Antti Palosaari <crope@iki.fi>,
	Nibble Max <nibble.max@gmail.com>,
	James Harper <james.harper@ejbdigital.com.au>,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 2/5] mb86a20s: convert it to I2C binding model
Date: Thu,  1 Jan 2015 13:51:23 -0200
Message-Id: <8f021fe831ce3e5b67a1e2ecf79ce919b6389d8c.1420127255.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420127255.git.mchehab@osg.samsung.com>
References: <cover.1420127255.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420127255.git.mchehab@osg.samsung.com>
References: <cover.1420127255.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using I2C raw API, use the standard I2C binding API,
with the DVB core support for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 8f54c39ca63f..8dd608be1edd 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -18,6 +18,7 @@
 #include <asm/div64.h>
 
 #include "dvb_frontend.h"
+#include "dvb_i2c.h"
 #include "mb86a20s.h"
 
 #define NUM_LAYERS 3
@@ -35,12 +36,10 @@ static u8 mb86a20s_subchannel[] = {
 };
 
 struct mb86a20s_state {
-	struct i2c_adapter *i2c;
+	struct i2c_client *i2c;
 	const struct mb86a20s_config *config;
 	u32 last_frequency;
 
-	struct dvb_frontend frontend;
-
 	u32 if_freq;
 	enum mb86a20s_bandwidth bw;
 	bool inversion;
@@ -234,7 +233,7 @@ static int mb86a20s_i2c_writereg(struct mb86a20s_state *state,
 	};
 	int rc;
 
-	rc = i2c_transfer(state->i2c, &msg, 1);
+	rc = i2c_transfer(state->i2c->adapter, &msg, 1);
 	if (rc != 1) {
 		dev_err(&state->i2c->dev,
 			"%s: writereg error (rc == %i, reg == 0x%02x, data == 0x%02x)\n",
@@ -269,7 +268,7 @@ static int mb86a20s_i2c_readreg(struct mb86a20s_state *state,
 		{ .addr = i2c_addr, .flags = I2C_M_RD, .buf = &val, .len = 1 }
 	};
 
-	rc = i2c_transfer(state->i2c, msg, 2);
+	rc = i2c_transfer(state->i2c->adapter, msg, 2);
 
 	if (rc != 2) {
 		dev_err(&state->i2c->dev, "%s: reg=0x%x (error=%d)\n",
@@ -281,11 +280,11 @@ static int mb86a20s_i2c_readreg(struct mb86a20s_state *state,
 }
 
 #define mb86a20s_readreg(state, reg) \
-	mb86a20s_i2c_readreg(state, state->config->demod_address, reg)
+	mb86a20s_i2c_readreg(state, state->i2c->addr, reg)
 #define mb86a20s_writereg(state, reg, val) \
-	mb86a20s_i2c_writereg(state, state->config->demod_address, reg, val)
+	mb86a20s_i2c_writereg(state, state->i2c->addr, reg, val)
 #define mb86a20s_writeregdata(state, regdata) \
-	mb86a20s_i2c_writeregdata(state, state->config->demod_address, \
+	mb86a20s_i2c_writeregdata(state, state->i2c->addr, \
 	regdata, ARRAY_SIZE(regdata))
 
 /*
@@ -2058,41 +2057,34 @@ static int mb86a20s_tune(struct dvb_frontend *fe,
 	return rc;
 }
 
-static void mb86a20s_release(struct dvb_frontend *fe)
+static int mb86a20s_remove(struct i2c_client *i2c)
 {
-	struct mb86a20s_state *state = fe->demodulator_priv;
+	dev_dbg(&i2c->dev, "%s called.\n", __func__);
 
-	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
-
-	kfree(state);
+	return 0;
 }
 
 static struct dvb_frontend_ops mb86a20s_ops;
 
-struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
-				    struct i2c_adapter *i2c)
+static int mb86a20s_probe(struct i2c_client *i2c,
+			  const struct i2c_device_id *id)
 {
+	struct dvb_frontend *fe;
 	struct mb86a20s_state *state;
 	u8	rev;
 
 	dev_dbg(&i2c->dev, "%s called.\n", __func__);
 
-	/* allocate memory for the internal state */
-	state = kzalloc(sizeof(struct mb86a20s_state), GFP_KERNEL);
-	if (state == NULL) {
-		dev_err(&i2c->dev,
-			"%s: unable to allocate memory for state\n", __func__);
-		goto error;
-	}
+	fe = i2c_get_clientdata(i2c);
+	state = fe->demodulator_priv;
 
 	/* setup the state */
-	state->config = config;
+	memcpy(&state->config, i2c->dev.platform_data, sizeof(state->config));
 	state->i2c = i2c;
 
 	/* create dvb_frontend */
-	memcpy(&state->frontend.ops, &mb86a20s_ops,
+	memcpy(&fe->ops, &mb86a20s_ops,
 		sizeof(struct dvb_frontend_ops));
-	state->frontend.demodulator_priv = state;
 
 	/* Check if it is a mb86a20s frontend */
 	rev = mb86a20s_readreg(state, 0);
@@ -2104,16 +2096,11 @@ struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 		dev_dbg(&i2c->dev,
 			"Frontend revision %d is unknown - aborting.\n",
 		       rev);
-		goto error;
+		return -ENODEV;
 	}
 
-	return &state->frontend;
-
-error:
-	kfree(state);
-	return NULL;
+	return 0;
 }
-EXPORT_SYMBOL(mb86a20s_attach);
 
 static struct dvb_frontend_ops mb86a20s_ops = {
 	.delsys = { SYS_ISDBT },
@@ -2132,8 +2119,6 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 		.frequency_stepsize = 62500,
 	},
 
-	.release = mb86a20s_release,
-
 	.init = mb86a20s_initfe,
 	.set_frontend = mb86a20s_set_frontend,
 	.get_frontend = mb86a20s_get_frontend_dummy,
@@ -2142,6 +2127,21 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 	.tune = mb86a20s_tune,
 };
 
+static const struct i2c_device_id mb86a20s_id[] = {
+	{ "mb86a20s", 0 },
+	{}
+};
+
+static const struct dvb_i2c_module_param mb86a20s_param = {
+	.ops.fe_ops = NULL,
+	.priv_probe = mb86a20s_probe,
+	.priv_remove = mb86a20s_remove,
+	.priv_size = sizeof(struct mb86a20s_state),
+	.is_tuner = false,
+};
+
+DEFINE_DVB_I2C_MODULE(mb86a20s, mb86a20s_id, mb86a20s_param);
+
 MODULE_DESCRIPTION("DVB Frontend module for Fujitsu mb86A20s hardware");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/mb86a20s.h b/drivers/media/dvb-frontends/mb86a20s.h
index cbeb941fba7c..18743c32209c 100644
--- a/drivers/media/dvb-frontends/mb86a20s.h
+++ b/drivers/media/dvb-frontends/mb86a20s.h
@@ -34,23 +34,4 @@ struct mb86a20s_config {
 	bool	is_serial;
 };
 
-#if IS_ENABLED(CONFIG_DVB_MB86A20S)
-extern struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
-					   struct i2c_adapter *i2c);
-extern struct i2c_adapter *mb86a20s_get_tuner_i2c_adapter(struct dvb_frontend *);
-#else
-static inline struct dvb_frontend *mb86a20s_attach(
-	const struct mb86a20s_config *config, struct i2c_adapter *i2c)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-static struct i2c_adapter *
-	mb86a20s_get_tuner_i2c_adapter(struct dvb_frontend *fe)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif
-
 #endif /* MB86A20S */
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index c47d18270cfc..fc23b7ad194f 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -26,6 +26,7 @@
 #include "cx23885.h"
 #include <media/v4l2-common.h>
 
+#include "dvb_i2c.h"
 #include "dvb_ca_en50221.h"
 #include "s5h1409.h"
 #include "s5h1411.h"
@@ -542,7 +543,10 @@ static struct xc5000_config mygica_x8506_xc5000_config = {
 };
 
 static struct mb86a20s_config mygica_x8507_mb86a20s_config = {
-	.demod_address = 0x10,
+};
+
+static const struct i2c_board_info mb86a20s_board_info = {
+	I2C_BOARD_INFO("mb86a20s", 0x10)
 };
 
 static struct xc5000_config mygica_x8507_xc5000_config = {
@@ -1503,9 +1507,10 @@ static int dvb_register(struct cx23885_tsport *port)
 	case CX23885_BOARD_MYGICA_X8507:
 		i2c_bus = &dev->i2c_bus[0];
 		i2c_bus2 = &dev->i2c_bus[1];
-		fe0->dvb.frontend = dvb_attach(mb86a20s_attach,
-			&mygica_x8507_mb86a20s_config,
-			&i2c_bus->i2c_adap);
+		fe0->dvb.frontend = dvb_i2c_attach_fe(&i2c_bus->i2c_adap,
+						       &mb86a20s_board_info,
+						       &mygica_x8507_mb86a20s_config,
+						       NULL);
 		if (fe0->dvb.frontend == NULL)
 			break;
 
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index 73ffbabf831c..74b5ce0de488 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -34,6 +34,7 @@
 #include "dvb-pll.h"
 #include <dvb_frontend.h>
 
+#include "dvb_i2c.h"
 #include "mt352.h"
 #include "mt352_priv.h" /* FIXME */
 #include "tda1004x.h"
@@ -245,7 +246,10 @@ static struct tda18271_config kworld_tda18271_config = {
 };
 
 static const struct mb86a20s_config kworld_mb86a20s_config = {
-	.demod_address = 0x10,
+};
+
+static const struct i2c_board_info mb86a20s_board_info = {
+	I2C_BOARD_INFO("mb86a20s", 0x10)
 };
 
 static int kworld_sbtvd_gate_ctrl(struct dvb_frontend* fe, int enable)
@@ -1807,9 +1811,10 @@ static int dvb_init(struct saa7134_dev *dev)
 		/* Switch to digital mode */
 		saa7134_tuner_callback(dev, 0,
 				       TDA18271_CALLBACK_CMD_AGC_ENABLE, 1);
-		fe0->dvb.frontend = dvb_attach(mb86a20s_attach,
-					       &kworld_mb86a20s_config,
-					       &dev->i2c_adap);
+		fe0->dvb.frontend = dvb_i2c_attach_fe(&dev->i2c_adap,
+						       &mb86a20s_board_info,
+						       &kworld_mb86a20s_config,
+						       NULL);
 		if (fe0->dvb.frontend != NULL) {
 			dvb_attach(tda829x_attach, fe0->dvb.frontend,
 				   &dev->i2c_adap, 0x4b,
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index dd600b994e69..27803a8cf5a4 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -26,6 +26,7 @@
 #include <media/v4l2-common.h>
 #include <media/videobuf-vmalloc.h>
 
+#include "dvb_i2c.h"
 #include "xc5000.h"
 #include "s5h1432.h"
 #include "tda18271.h"
@@ -138,10 +139,13 @@ static struct tda18271_config hcw_tda18271_config = {
 };
 
 static const struct mb86a20s_config pv_mb86a20s_config = {
-	.demod_address = 0x10,
 	.is_serial = true,
 };
 
+static const struct i2c_board_info mb86a20s_board_info = {
+	I2C_BOARD_INFO("mb86a20s", 0x10)
+};
+
 static struct tda18271_config pv_tda18271_config = {
 	.std_map = &mb86a20s_tda18271_config,
 	.gate    = TDA18271_GATE_DIGITAL,
@@ -815,10 +819,10 @@ static int dvb_init(struct cx231xx *dev)
 			 "%s: looking for demod on i2c bus: %d\n",
 			 __func__, i2c_adapter_id(tuner_i2c));
 
-		dev->dvb->frontend = dvb_attach(mb86a20s_attach,
-						&pv_mb86a20s_config,
-						demod_i2c);
-
+		dev->dvb->frontend = dvb_i2c_attach_fe(demod_i2c,
+						       &mb86a20s_board_info,
+						       &pv_mb86a20s_config,
+						       NULL);
 		if (dev->dvb->frontend == NULL) {
 			dev_err(dev->dev,
 				"Failed to attach mb86a20s demod\n");
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index aee70d483264..6fa4eeed9f50 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -34,6 +34,7 @@
 #include "tuner-simple.h"
 #include <linux/gpio.h>
 
+#include "dvb_i2c.h"
 #include "lgdt330x.h"
 #include "lgdt3305.h"
 #include "zl10353.h"
@@ -833,10 +834,13 @@ static struct qt1010_config em28xx_qt1010_config = {
 };
 
 static const struct mb86a20s_config c3tech_duo_mb86a20s_config = {
-	.demod_address = 0x10,
 	.is_serial = true,
 };
 
+static const struct i2c_board_info mb86a20s_board_info = {
+	I2C_BOARD_INFO("mb86a20s", 0x10)
+};
+
 static struct tda18271_std_map mb86a20s_tda18271_config = {
 	.dvbt_6   = { .if_freq = 4000, .agc_mode = 3, .std = 4,
 		      .if_lvl = 1, .rfagc_top = 0x37, },
@@ -1323,9 +1327,10 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 		break;
 	case EM2884_BOARD_C3TECH_DIGITAL_DUO:
-		dvb->fe[0] = dvb_attach(mb86a20s_attach,
-					   &c3tech_duo_mb86a20s_config,
-					   &dev->i2c_adap[dev->def_i2c_bus]);
+		dvb->fe[0] = dvb_i2c_attach_fe(&dev->i2c_adap[dev->def_i2c_bus],
+					       &mb86a20s_board_info,
+					       &c3tech_duo_mb86a20s_config,
+					       NULL);
 		if (dvb->fe[0] != NULL)
 			dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
 				   &dev->i2c_adap[dev->def_i2c_bus],
-- 
2.1.0

