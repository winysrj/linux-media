Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49558 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757652Ab2HQBfu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 21:35:50 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/6] cxd2820r: use Kernel GPIO for GPIO access
Date: Fri, 17 Aug 2012 04:35:07 +0300
Message-Id: <1345167310-8738-4-git-send-email-crope@iki.fi>
In-Reply-To: <1345167310-8738-1-git-send-email-crope@iki.fi>
References: <1345167310-8738-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently there is LNA behind cxd2820r demodulator GPIO. Use
Kernel GPIO interface to access those GPIOs.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2820r.h      |  14 ++--
 drivers/media/dvb-frontends/cxd2820r_c.c    |   5 --
 drivers/media/dvb-frontends/cxd2820r_core.c | 108 ++++++++++++++++++++++------
 drivers/media/dvb-frontends/cxd2820r_priv.h |   9 ++-
 drivers/media/dvb-frontends/cxd2820r_t.c    |   5 --
 drivers/media/dvb-frontends/cxd2820r_t2.c   |   5 --
 drivers/media/usb/dvb-usb-v2/anysee.c       |   2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c       |  21 ++++--
 8 files changed, 114 insertions(+), 55 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r.h b/drivers/media/dvb-frontends/cxd2820r.h
index 5aa306e..6acc21c 100644
--- a/drivers/media/dvb-frontends/cxd2820r.h
+++ b/drivers/media/dvb-frontends/cxd2820r.h
@@ -62,14 +62,6 @@ struct cxd2820r_config {
 	 * Values: 0, 1
 	 */
 	bool spec_inv;
-
-	/* GPIOs for all used modes.
-	 * Default: none, disabled
-	 * Values: <see above>
-	 */
-	u8 gpio_dvbt[3];
-	u8 gpio_dvbt2[3];
-	u8 gpio_dvbc[3];
 };
 
 
@@ -77,12 +69,14 @@ struct cxd2820r_config {
 	(defined(CONFIG_DVB_CXD2820R_MODULE) && defined(MODULE))
 extern struct dvb_frontend *cxd2820r_attach(
 	const struct cxd2820r_config *config,
-	struct i2c_adapter *i2c
+	struct i2c_adapter *i2c,
+	int *gpio_chip_base
 );
 #else
 static inline struct dvb_frontend *cxd2820r_attach(
 	const struct cxd2820r_config *config,
-	struct i2c_adapter *i2c
+	struct i2c_adapter *i2c,
+	int *gpio_chip_base
 )
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
index d2a0c28..125a440 100644
--- a/drivers/media/dvb-frontends/cxd2820r_c.c
+++ b/drivers/media/dvb-frontends/cxd2820r_c.c
@@ -50,11 +50,6 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 	dev_dbg(&priv->i2c->dev, "%s: frequency=%d symbol_rate=%d\n", __func__,
 			c->frequency, c->symbol_rate);
 
-	/* update GPIOs */
-	ret = cxd2820r_gpio(fe);
-	if (ret)
-		goto error;
-
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index a3656ba..4bd42f2 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -168,30 +168,15 @@ int cxd2820r_wr_reg_mask(struct cxd2820r_priv *priv, u32 reg, u8 val,
 	return cxd2820r_wr_reg(priv, reg, val);
 }
 
-int cxd2820r_gpio(struct dvb_frontend *fe)
+int cxd2820r_gpio(struct dvb_frontend *fe, u8 *gpio)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret, i;
-	u8 *gpio, tmp0, tmp1;
+	u8 tmp0, tmp1;
 
 	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
 			fe->dtv_property_cache.delivery_system);
 
-	switch (fe->dtv_property_cache.delivery_system) {
-	case SYS_DVBT:
-		gpio = priv->cfg.gpio_dvbt;
-		break;
-	case SYS_DVBT2:
-		gpio = priv->cfg.gpio_dvbt2;
-		break;
-	case SYS_DVBC_ANNEX_AC:
-		gpio = priv->cfg.gpio_dvbc;
-		break;
-	default:
-		ret = -EINVAL;
-		goto error;
-	}
-
 	/* update GPIOs only when needed */
 	if (!memcmp(gpio, priv->gpio, sizeof(priv->gpio)))
 		return 0;
@@ -582,9 +567,19 @@ static int cxd2820r_get_frontend_algo(struct dvb_frontend *fe)
 static void cxd2820r_release(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	int ret;
 
 	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
 
+#ifdef CONFIG_GPIOLIB
+	/* remove GPIOs */
+	if (priv->gpio_chip.label) {
+		ret = gpiochip_remove(&priv->gpio_chip);
+		if (ret)
+			dev_err(&priv->i2c->dev, "%s: gpiochip_remove() " \
+					"failed=%d\n", KBUILD_MODNAME, ret);
+	}
+#endif
 	kfree(priv);
 	return;
 }
@@ -599,6 +594,49 @@ static int cxd2820r_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	return cxd2820r_wr_reg_mask(priv, 0xdb, enable ? 1 : 0, 0x1);
 }
 
+#ifdef CONFIG_GPIOLIB
+static int cxd2820r_gpio_direction_output(struct gpio_chip *chip, unsigned nr,
+		int val)
+{
+	struct cxd2820r_priv *priv =
+			container_of(chip, struct cxd2820r_priv, gpio_chip);
+	u8 gpio[GPIO_COUNT];
+
+	dev_dbg(&priv->i2c->dev, "%s: nr=%d val=%d\n", __func__, nr, val);
+
+	memcpy(gpio, priv->gpio, sizeof(gpio));
+	gpio[nr] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | (val << 2);
+
+	return cxd2820r_gpio(&priv->fe, gpio);
+}
+
+static void cxd2820r_gpio_set(struct gpio_chip *chip, unsigned nr, int val)
+{
+	struct cxd2820r_priv *priv =
+			container_of(chip, struct cxd2820r_priv, gpio_chip);
+	u8 gpio[GPIO_COUNT];
+
+	dev_dbg(&priv->i2c->dev, "%s: nr=%d val=%d\n", __func__, nr, val);
+
+	memcpy(gpio, priv->gpio, sizeof(gpio));
+	gpio[nr] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | (val << 2);
+
+	(void) cxd2820r_gpio(&priv->fe, gpio);
+
+	return;
+}
+
+static int cxd2820r_gpio_get(struct gpio_chip *chip, unsigned nr)
+{
+	struct cxd2820r_priv *priv =
+			container_of(chip, struct cxd2820r_priv, gpio_chip);
+
+	dev_dbg(&priv->i2c->dev, "%s: nr=%d\n", __func__, nr);
+
+	return (priv->gpio[nr] >> 2) & 0x01;
+}
+#endif
+
 static const struct dvb_frontend_ops cxd2820r_ops = {
 	.delsys = { SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A },
 	/* default: DVB-T/T2 */
@@ -645,15 +683,20 @@ static const struct dvb_frontend_ops cxd2820r_ops = {
 };
 
 struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
-		struct i2c_adapter *i2c)
+		struct i2c_adapter *i2c, int *gpio_chip_base
+)
 {
-	struct cxd2820r_priv *priv = NULL;
+	struct cxd2820r_priv *priv;
 	int ret;
 	u8 tmp;
 
 	priv = kzalloc(sizeof (struct cxd2820r_priv), GFP_KERNEL);
-	if (!priv)
+	if (!priv) {
+		ret = -ENOMEM;
+		dev_err(&i2c->dev, "%s: kzalloc() failed\n",
+				KBUILD_MODNAME);
 		goto error;
+	}
 
 	priv->i2c = i2c;
 	memcpy(&priv->cfg, cfg, sizeof (struct cxd2820r_config));
@@ -664,10 +707,35 @@ struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
 	if (ret || tmp != 0xe1)
 		goto error;
 
+#ifdef CONFIG_GPIOLIB
+	/* add GPIOs */
+	if (gpio_chip_base) {
+		priv->gpio_chip.label = KBUILD_MODNAME;
+		priv->gpio_chip.dev = &priv->i2c->dev;
+		priv->gpio_chip.owner = THIS_MODULE;
+		priv->gpio_chip.direction_output =
+				cxd2820r_gpio_direction_output;
+		priv->gpio_chip.set = cxd2820r_gpio_set;
+		priv->gpio_chip.get = cxd2820r_gpio_get;
+		priv->gpio_chip.base = -1; /* dynamic allocation */
+		priv->gpio_chip.ngpio = GPIO_COUNT;
+		priv->gpio_chip.can_sleep = 1;
+		ret = gpiochip_add(&priv->gpio_chip);
+		if (ret)
+			goto error;
+
+		dev_dbg(&priv->i2c->dev, "%s: gpio_chip.base=%d\n", __func__,
+				priv->gpio_chip.base);
+
+		*gpio_chip_base = priv->gpio_chip.base;
+	}
+#endif
+
 	memcpy(&priv->fe.ops, &cxd2820r_ops, sizeof (struct dvb_frontend_ops));
 	priv->fe.demodulator_priv = priv;
 	return &priv->fe;
 error:
+	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
 	kfree(priv);
 	return NULL;
 }
diff --git a/drivers/media/dvb-frontends/cxd2820r_priv.h b/drivers/media/dvb-frontends/cxd2820r_priv.h
index 9396492..7ff5f60 100644
--- a/drivers/media/dvb-frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb-frontends/cxd2820r_priv.h
@@ -26,6 +26,7 @@
 #include "dvb_frontend.h"
 #include "dvb_math.h"
 #include "cxd2820r.h"
+#include <linux/gpio.h>
 
 struct reg_val_mask {
 	u32 reg;
@@ -41,7 +42,11 @@ struct cxd2820r_priv {
 	bool ber_running;
 
 	u8 bank[2];
-	u8 gpio[3];
+#define GPIO_COUNT 3
+	u8 gpio[GPIO_COUNT];
+#ifdef CONFIG_GPIOLIB
+	struct gpio_chip gpio_chip;
+#endif
 
 	fe_delivery_system_t delivery_system;
 	bool last_tune_failed; /* for switch between T and T2 tune */
@@ -51,7 +56,7 @@ struct cxd2820r_priv {
 
 extern int cxd2820r_debug;
 
-int cxd2820r_gpio(struct dvb_frontend *fe);
+int cxd2820r_gpio(struct dvb_frontend *fe, u8 *gpio);
 
 int cxd2820r_wr_reg_mask(struct cxd2820r_priv *priv, u32 reg, u8 val,
 	u8 mask);
diff --git a/drivers/media/dvb-frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
index af5890e..fa184ca 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t.c
@@ -74,11 +74,6 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 
-	/* update GPIOs */
-	ret = cxd2820r_gpio(fe);
-	if (ret)
-		goto error;
-
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
index 653c56e..e82d82a 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
@@ -92,11 +92,6 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 
-	/* update GPIOs */
-	ret = cxd2820r_gpio(fe);
-	if (ret)
-		goto error;
-
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index b430bca..6705d81 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -874,7 +874,7 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 
 		/* attach demod */
 		adap->fe[0] = dvb_attach(cxd2820r_attach,
-				&anysee_cxd2820r_config, &d->i2c_adap);
+				&anysee_cxd2820r_config, &d->i2c_adap, NULL);
 
 		state->has_ci = true;
 
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a16531f..34c5ea9 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -28,6 +28,7 @@
 #include <media/videobuf-vmalloc.h>
 #include <media/tuner.h>
 #include "tuner-simple.h"
+#include <linux/gpio.h>
 
 #include "lgdt330x.h"
 #include "lgdt3305.h"
@@ -610,11 +611,6 @@ static struct tda10023_config em28xx_tda10023_config = {
 static struct cxd2820r_config em28xx_cxd2820r_config = {
 	.i2c_address = (0xd8 >> 1),
 	.ts_mode = CXD2820R_TS_SERIAL,
-
-	/* enable LNA for DVB-T, DVB-T2 and DVB-C */
-	.gpio_dvbt[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
-	.gpio_dvbt2[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
-	.gpio_dvbc[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
 };
 
 static struct tda18271_config em28xx_cxd2820r_tda18271_config = {
@@ -813,7 +809,7 @@ static void em28xx_unregister_dvb(struct em28xx_dvb *dvb)
 
 static int em28xx_dvb_init(struct em28xx *dev)
 {
-	int result = 0, mfe_shared = 0;
+	int result = 0, mfe_shared = 0, gpio_chip_base;
 	struct em28xx_dvb *dvb;
 
 	if (!dev->board.has_dvb) {
@@ -961,7 +957,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM28174_BOARD_PCTV_290E:
 		dvb->fe[0] = dvb_attach(cxd2820r_attach,
 					&em28xx_cxd2820r_config,
-					&dev->i2c_adap);
+					&dev->i2c_adap,
+					&gpio_chip_base);
 		if (dvb->fe[0]) {
 			/* FE 0 attach tuner */
 			if (!dvb_attach(tda18271_attach,
@@ -975,6 +972,16 @@ static int em28xx_dvb_init(struct em28xx *dev)
 				goto out_free;
 			}
 		}
+
+		/* enable LNA for DVB-T, DVB-T2 and DVB-C */
+		result = gpio_request_one(gpio_chip_base, GPIOF_INIT_LOW,
+				"LNA");
+		if (result)
+			em28xx_errdev("gpio request failed %d\n", result);
+		else
+			gpio_free(gpio_chip_base);
+
+		result = 0; /* continue even set LNA fails */
 		break;
 	case EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C:
 	{
-- 
1.7.11.2

