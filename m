Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42237 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaL3UBd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 15:01:33 -0500
Date: Tue, 30 Dec 2014 18:01:26 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH] dvb-core: add template code for i2c binding model
Message-ID: <20141230180126.0b0b333d@concha.lan>
In-Reply-To: <20141230111051.7aeff58a@concha.lan>
References: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
	<20141230111051.7aeff58a@concha.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 30 Dec 2014 11:10:51 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Fri, 05 Dec 2014 19:49:33 +0900
> tskd08@gmail.com escreveu:
> 
> > From: Akihiro Tsukada <tskd08@gmail.com>
> > 
> > Define a standard interface for demod/tuner i2c driver modules.
> > A module client calls dvb_i2c_attach_{fe,tuner}(),
> > and a module driver defines struct dvb_i2c_module_param and
> > calls DEFINE_DVB_I2C_MODULE() macro.
> > 
> > This template provides implicit module requests and ref-counting,
> > alloc/free's private data structures,
> > fixes the usage of clientdata of i2c devices,
> > and defines the platformdata structures for passing around
> > device specific config/output parameters between drivers and clients.
> > These kinds of code are common to (almost) all dvb i2c drivers/client,
> > but they were scattered over adapter modules and demod/tuner modules.
> 
> The idea behind this patch is good. I didn't have time yet to test it on a
> device that I have currently access.
> 
> I have a few comments below, mostly regards with naming convention.
> 
> By seeing the patches you converted a few drivers to use this, I'm a little
> bit concern about the conversion. We need something that won't be hard to
> convert to the new model without requiring to re-test everything.
> 
> Anyway, my plan is to take a deeper look on it next week and convert one
> or two drivers to use the new I2C binding approach you're proposing.

Ok, did some tests and it worked. The issues I commented on my last email
may be fixed latter. I'm working on adding media controller support for
it.

The only thing I noticed is that it is causing some warnings at
dmesg about trying to create already created sysfs nodes, when the
driver is removed/reinserted.

Probably, the remove callback is called too soon or too late.

I'll do more tests latter (either this or the next week).

I used the enclosed patch on my tests.

Regards,
Mauro

[PATCH] mb86a20s: convert it to I2C binding model

Instead of using I2C raw API, use the standard I2C binding API,
with the DVB core support for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 8f54c39..8dd608b 100644
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
-
-	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+	dev_dbg(&i2c->dev, "%s called.\n", __func__);
 
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
index cbeb941..18743c3 100644
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
index c47d182..fc23b7a 100644
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
index 73ffbab..74b5ce0 100644
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
index dd600b9..27803a8 100644
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
index aee70d4..6fa4eee 100644
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

Cheers,
Mauro
