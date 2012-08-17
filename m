Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54987 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757626Ab2HQBfv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 21:35:51 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/6] em28xx: implement FE set_lna() callback
Date: Fri, 17 Aug 2012 04:35:08 +0300
Message-Id: <1345167310-8738-5-git-send-email-crope@iki.fi>
In-Reply-To: <1345167310-8738-1-git-send-email-crope@iki.fi>
References: <1345167310-8738-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make LNA run-time switching possible for PCTV nanoStick T2 290e!

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 40 ++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 34c5ea9..75f907a 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -81,6 +81,7 @@ struct em28xx_dvb {
 	int (*gate_ctrl)(struct dvb_frontend *, int);
 	struct semaphore      pll_mutex;
 	bool			dont_attach_fe1;
+	int			gpio;
 };
 
 
@@ -568,6 +569,33 @@ static void pctv_520e_init(struct em28xx *dev)
 		i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
 };
 
+static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe, int val)
+{
+	struct em28xx *dev = fe->dvb->priv;
+#ifdef CONFIG_GPIOLIB
+	struct em28xx_dvb *dvb = dev->dvb;
+	int ret;
+	unsigned long flags;
+
+	if (val)
+		flags = GPIOF_OUT_INIT_LOW;
+	else
+		flags = GPIOF_OUT_INIT_HIGH;
+
+	ret = gpio_request_one(dvb->gpio, flags, NULL);
+	if (ret)
+		em28xx_errdev("gpio request failed %d\n", ret);
+	else
+		gpio_free(dvb->gpio);
+
+	return ret;
+#else
+	dev_warn(&dev->udev->dev, "%s: LNA control is disabled\n",
+			KBUILD_MODNAME);
+	return 0;
+#endif
+}
+
 static int em28xx_mt352_terratec_xs_init(struct dvb_frontend *fe)
 {
 	/* Values extracted from a USB trace of the Terratec Windows driver */
@@ -809,7 +837,7 @@ static void em28xx_unregister_dvb(struct em28xx_dvb *dvb)
 
 static int em28xx_dvb_init(struct em28xx *dev)
 {
-	int result = 0, mfe_shared = 0, gpio_chip_base;
+	int result = 0, mfe_shared = 0;
 	struct em28xx_dvb *dvb;
 
 	if (!dev->board.has_dvb) {
@@ -958,7 +986,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		dvb->fe[0] = dvb_attach(cxd2820r_attach,
 					&em28xx_cxd2820r_config,
 					&dev->i2c_adap,
-					&gpio_chip_base);
+					&dvb->gpio);
 		if (dvb->fe[0]) {
 			/* FE 0 attach tuner */
 			if (!dvb_attach(tda18271_attach,
@@ -973,15 +1001,17 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			}
 		}
 
+#ifdef CONFIG_GPIOLIB
 		/* enable LNA for DVB-T, DVB-T2 and DVB-C */
-		result = gpio_request_one(gpio_chip_base, GPIOF_INIT_LOW,
-				"LNA");
+		result = gpio_request_one(dvb->gpio, GPIOF_OUT_INIT_LOW, NULL);
 		if (result)
 			em28xx_errdev("gpio request failed %d\n", result);
 		else
-			gpio_free(gpio_chip_base);
+			gpio_free(dvb->gpio);
 
 		result = 0; /* continue even set LNA fails */
+#endif
+		dvb->fe[0]->ops.set_lna = em28xx_pctv_290e_set_lna;
 		break;
 	case EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C:
 	{
-- 
1.7.11.2

