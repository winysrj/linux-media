Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42793 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758875Ab2LIT5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans-Frieder Vogt <hfvogt@gmx.net>
Subject: [PATCH RFC 09/17] fc0012: use config directly from the config struct
Date: Sun,  9 Dec 2012 21:56:20 +0200
Message-Id: <1355082988-6211-9-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need to copy config to the driver state. Those are coming from
the const struct and could be used directly.

Cc: Hans-Frieder Vogt <hfvogt@gmx.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc0012-priv.h    |  3 ---
 drivers/media/tuners/fc0012.c         | 17 ++++++++---------
 drivers/media/tuners/fc0012.h         |  2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c |  4 ++--
 4 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/media/tuners/fc0012-priv.h b/drivers/media/tuners/fc0012-priv.h
index 1195ee9..3b98bf9 100644
--- a/drivers/media/tuners/fc0012-priv.h
+++ b/drivers/media/tuners/fc0012-priv.h
@@ -33,9 +33,6 @@
 struct fc0012_priv {
 	struct i2c_adapter *i2c;
 	const struct fc0012_config *cfg;
-	u8 addr;
-	u8 dual_master;
-	u8 xtal_freq;
 
 	u32 frequency;
 	u32 bandwidth;
diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
index 1a52b76..01f5e40 100644
--- a/drivers/media/tuners/fc0012.c
+++ b/drivers/media/tuners/fc0012.c
@@ -25,7 +25,7 @@ static int fc0012_writereg(struct fc0012_priv *priv, u8 reg, u8 val)
 {
 	u8 buf[2] = {reg, val};
 	struct i2c_msg msg = {
-		.addr = priv->addr, .flags = 0, .buf = buf, .len = 2
+		.addr = priv->cfg->i2c_address, .flags = 0, .buf = buf, .len = 2
 	};
 
 	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
@@ -38,8 +38,10 @@ static int fc0012_writereg(struct fc0012_priv *priv, u8 reg, u8 val)
 static int fc0012_readreg(struct fc0012_priv *priv, u8 reg, u8 *val)
 {
 	struct i2c_msg msg[2] = {
-		{ .addr = priv->addr, .flags = 0, .buf = &reg, .len = 1 },
-		{ .addr = priv->addr, .flags = I2C_M_RD, .buf = val, .len = 1 },
+		{ .addr = priv->cfg->i2c_address, .flags = 0,
+			.buf = &reg, .len = 1 },
+		{ .addr = priv->cfg->i2c_address, .flags = I2C_M_RD,
+			.buf = val, .len = 1 },
 	};
 
 	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
@@ -88,7 +90,7 @@ static int fc0012_init(struct dvb_frontend *fe)
 		0x04,	/* reg. 0x15: Enable LNA COMPS */
 	};
 
-	switch (priv->xtal_freq) {
+	switch (priv->cfg->xtal_freq) {
 	case FC_XTAL_27_MHZ:
 	case FC_XTAL_28_8_MHZ:
 		reg[0x07] |= 0x20;
@@ -98,7 +100,7 @@ static int fc0012_init(struct dvb_frontend *fe)
 		break;
 	}
 
-	if (priv->dual_master)
+	if (priv->cfg->dual_master)
 		reg[0x0c] |= 0x02;
 
 	if (priv->cfg->loop_through)
@@ -147,7 +149,7 @@ static int fc0012_set_params(struct dvb_frontend *fe)
 			goto exit;
 	}
 
-	switch (priv->xtal_freq) {
+	switch (priv->cfg->xtal_freq) {
 	case FC_XTAL_27_MHZ:
 		xtal_freq_khz_2 = 27000 / 2;
 		break;
@@ -449,9 +451,6 @@ struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
 
 	priv->i2c = i2c;
 	priv->cfg = cfg;
-	priv->dual_master = cfg->dual_master;
-	priv->addr = cfg->i2c_address;
-	priv->xtal_freq = cfg->xtal_freq;
 
 	info("Fitipower FC0012 successfully attached.");
 
diff --git a/drivers/media/tuners/fc0012.h b/drivers/media/tuners/fc0012.h
index 83a98e7..3fb53b8 100644
--- a/drivers/media/tuners/fc0012.h
+++ b/drivers/media/tuners/fc0012.h
@@ -35,7 +35,7 @@ struct fc0012_config {
 	 */
 	enum fc001x_xtal_freq xtal_freq;
 
-	int dual_master;
+	bool dual_master;
 
 	/*
 	 * RF loop-through
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 1c7fe5a..68e0e804 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -906,13 +906,13 @@ static const struct fc0012_config af9035_fc0012_config[] = {
 	{
 		.i2c_address = 0x63,
 		.xtal_freq = FC_XTAL_36_MHZ,
-		.dual_master = 1,
+		.dual_master = true,
 		.loop_through = true,
 		.clock_out = true,
 	}, {
 		.i2c_address = 0x63 | 0x80, /* I2C bus select hack */
 		.xtal_freq = FC_XTAL_36_MHZ,
-		.dual_master = 1,
+		.dual_master = true,
 	}
 };
 
-- 
1.7.11.7

