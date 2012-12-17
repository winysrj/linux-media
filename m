Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3351 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2LQBMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 20:12:17 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, crope@iki.fi,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH] tda10071: make sure both tuner and demod i2c addresses are specified
Date: Sun, 16 Dec 2012 20:12:04 -0500
Message-Id: <1355706724-25663-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

display an error message if either tuner_i2c_addr or demod_i2c_addr
are not specified in the tda10071_config structure

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb-frontends/tda10071.c  |   18 +++++++++++++++---
 drivers/media/dvb-frontends/tda10071.h  |    4 ++--
 drivers/media/pci/cx23885/cx23885-dvb.c |    2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c   |    3 ++-
 4 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 7103629..02f9234 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -30,7 +30,7 @@ static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 	u8 buf[len+1];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->cfg.i2c_address,
+			.addr = priv->cfg.demod_i2c_addr,
 			.flags = 0,
 			.len = sizeof(buf),
 			.buf = buf,
@@ -59,12 +59,12 @@ static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 	u8 buf[len];
 	struct i2c_msg msg[2] = {
 		{
-			.addr = priv->cfg.i2c_address,
+			.addr = priv->cfg.demod_i2c_addr,
 			.flags = 0,
 			.len = 1,
 			.buf = &reg,
 		}, {
-			.addr = priv->cfg.i2c_address,
+			.addr = priv->cfg.demod_i2c_addr,
 			.flags = I2C_M_RD,
 			.len = sizeof(buf),
 			.buf = buf,
@@ -1202,6 +1202,18 @@ struct dvb_frontend *tda10071_attach(const struct tda10071_config *config,
 		goto error;
 	}
 
+	/* make sure demod i2c address is specified */
+	if (!config->demod_i2c_addr) {
+		dev_dbg(&i2c->dev, "%s: invalid demod i2c address!\n", __func__);
+		goto error;
+	}
+
+	/* make sure tuner i2c address is specified */
+	if (!config->tuner_i2c_addr) {
+		dev_dbg(&i2c->dev, "%s: invalid tuner i2c address!\n", __func__);
+		goto error;
+	}
+
 	/* setup the priv */
 	priv->i2c = i2c;
 	memcpy(&priv->cfg, config, sizeof(struct tda10071_config));
diff --git a/drivers/media/dvb-frontends/tda10071.h b/drivers/media/dvb-frontends/tda10071.h
index a20d5c4..bff1c38 100644
--- a/drivers/media/dvb-frontends/tda10071.h
+++ b/drivers/media/dvb-frontends/tda10071.h
@@ -28,10 +28,10 @@ struct tda10071_config {
 	 * Default: none, must set
 	 * Values: 0x55,
 	 */
-	u8 i2c_address;
+	u8 demod_i2c_addr;
 
 	/* Tuner I2C address.
-	 * Default: 0x14
+	 * Default: none, must set
 	 * Values: 0x14, 0x54, ...
 	 */
 	u8 tuner_i2c_addr;
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index cf84c53..a1aae56 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -662,7 +662,7 @@ static struct mt2063_config terratec_mt2063_config[] = {
 };
 
 static const struct tda10071_config hauppauge_tda10071_config = {
-	.i2c_address = 0x05,
+	.demod_i2c_addr = 0x05,
 	.tuner_i2c_addr = 0x54,
 	.i2c_wr_max = 64,
 	.ts_mode = TDA10071_TS_SERIAL,
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 63f2e70..e800881 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -714,7 +714,8 @@ static struct tda18271_config em28xx_cxd2820r_tda18271_config = {
 };
 
 static const struct tda10071_config em28xx_tda10071_config = {
-	.i2c_address = 0x55, /* (0xaa >> 1) */
+	.demod_i2c_addr = 0x55, /* (0xaa >> 1) */
+	.tuner_i2c_addr = 0x14,
 	.i2c_wr_max = 64,
 	.ts_mode = TDA10071_TS_SERIAL,
 	.spec_inv = 0,
-- 
1.7.10.4

