Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52901 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757672Ab2HQBfy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 21:35:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/6] cxd2820r: GPIO when GPIOLIB is undefined
Date: Fri, 17 Aug 2012 04:35:09 +0300
Message-Id: <1345167310-8738-6-git-send-email-crope@iki.fi>
In-Reply-To: <1345167310-8738-1-git-send-email-crope@iki.fi>
References: <1345167310-8738-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use static GPIO config when GPIOLIB is undefined.
It is fallback condition as GPIOLIB seems to be disabled by default.
Better solution is needed, maybe GPIOLIB could be enabled by default?

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2820r_core.c | 29 ++++++++++++++++++++---------
 drivers/media/usb/em28xx/em28xx-dvb.c       |  2 ++
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 4bd42f2..4264864 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -567,7 +567,7 @@ static int cxd2820r_get_frontend_algo(struct dvb_frontend *fe)
 static void cxd2820r_release(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
+	int uninitialized_var(ret); /* silence compiler warning */
 
 	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
 
@@ -688,9 +688,9 @@ struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
 {
 	struct cxd2820r_priv *priv;
 	int ret;
-	u8 tmp;
+	u8 tmp, gpio[GPIO_COUNT];
 
-	priv = kzalloc(sizeof (struct cxd2820r_priv), GFP_KERNEL);
+	priv = kzalloc(sizeof(struct cxd2820r_priv), GFP_KERNEL);
 	if (!priv) {
 		ret = -ENOMEM;
 		dev_err(&i2c->dev, "%s: kzalloc() failed\n",
@@ -699,7 +699,9 @@ struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
 	}
 
 	priv->i2c = i2c;
-	memcpy(&priv->cfg, cfg, sizeof (struct cxd2820r_config));
+	memcpy(&priv->cfg, cfg, sizeof(struct cxd2820r_config));
+	memcpy(&priv->fe.ops, &cxd2820r_ops, sizeof(struct dvb_frontend_ops));
+	priv->fe.demodulator_priv = priv;
 
 	priv->bank[0] = priv->bank[1] = 0xff;
 	ret = cxd2820r_rd_reg(priv, 0x000fd, &tmp);
@@ -707,9 +709,9 @@ struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
 	if (ret || tmp != 0xe1)
 		goto error;
 
-#ifdef CONFIG_GPIOLIB
-	/* add GPIOs */
 	if (gpio_chip_base) {
+#ifdef CONFIG_GPIOLIB
+		/* add GPIOs */
 		priv->gpio_chip.label = KBUILD_MODNAME;
 		priv->gpio_chip.dev = &priv->i2c->dev;
 		priv->gpio_chip.owner = THIS_MODULE;
@@ -728,11 +730,20 @@ struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
 				priv->gpio_chip.base);
 
 		*gpio_chip_base = priv->gpio_chip.base;
-	}
+#else
+		/*
+		 * Use static GPIO configuration if GPIOLIB is undefined.
+		 * This is fallback condition.
+		 */
+		gpio[0] = (*gpio_chip_base >> 0) & 0x07;
+		gpio[1] = (*gpio_chip_base >> 3) & 0x07;
+		gpio[2] = 0;
+		ret = cxd2820r_gpio(&priv->fe, gpio);
+		if (ret)
+			goto error;
 #endif
+	}
 
-	memcpy(&priv->fe.ops, &cxd2820r_ops, sizeof (struct dvb_frontend_ops));
-	priv->fe.demodulator_priv = priv;
 	return &priv->fe;
 error:
 	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 75f907a..e0128b3 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -983,6 +983,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 				   &dev->i2c_adap, &kworld_a340_config);
 		break;
 	case EM28174_BOARD_PCTV_290E:
+		/* set default GPIO0 for LNA, used if GPIOLIB is undefined */
+		dvb->gpio = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L;
 		dvb->fe[0] = dvb_attach(cxd2820r_attach,
 					&em28xx_cxd2820r_config,
 					&dev->i2c_adap,
-- 
1.7.11.2

