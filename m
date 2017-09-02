Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:37827 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751652AbdIBLmv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 07:42:51 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 1/7] media: dvb: i2c transfers over usb cannot be done from stack
Date: Sat,  2 Sep 2017 12:42:42 +0100
Message-Id: <50974f0773c1471cf0fbd590f48878fa649b8427.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 29d2fef8be11 ("usb: catch attempts to submit urbs
with a vmalloc'd transfer buffer"), the AverMedia AverTV DVB-T
USB 2.0 (a800) fails to probe.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/dvb-frontends/dib3000mc.c | 50 ++++++++++++++++++++++------
 drivers/media/dvb-frontends/dvb-pll.c   | 21 +++++++++---
 drivers/media/tuners/mt2060.c           | 59 ++++++++++++++++++++++++++-------
 3 files changed, 102 insertions(+), 28 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib3000mc.c b/drivers/media/dvb-frontends/dib3000mc.c
index 224283fe100a..31ade5512a36 100644
--- a/drivers/media/dvb-frontends/dib3000mc.c
+++ b/drivers/media/dvb-frontends/dib3000mc.c
@@ -55,29 +55,57 @@ struct dib3000mc_state {
 
 static u16 dib3000mc_read_word(struct dib3000mc_state *state, u16 reg)
 {
-	u8 wb[2] = { (reg >> 8) | 0x80, reg & 0xff };
-	u8 rb[2];
 	struct i2c_msg msg[2] = {
-		{ .addr = state->i2c_addr >> 1, .flags = 0,        .buf = wb, .len = 2 },
-		{ .addr = state->i2c_addr >> 1, .flags = I2C_M_RD, .buf = rb, .len = 2 },
+		{ .addr = state->i2c_addr >> 1, .flags = 0,        .len = 2 },
+		{ .addr = state->i2c_addr >> 1, .flags = I2C_M_RD, .len = 2 },
 	};
+	u16 word;
+	u8 *b;
+
+	b = kmalloc(4, GFP_KERNEL);
+	if (!b)
+		return 0;
+
+	b[0] = (reg >> 8) | 0x80;
+	b[1] = reg;
+	b[2] = 0;
+	b[3] = 0;
+
+	msg[0].buf = b;
+	msg[1].buf = b + 2;
 
 	if (i2c_transfer(state->i2c_adap, msg, 2) != 2)
 		dprintk("i2c read error on %d\n",reg);
 
-	return (rb[0] << 8) | rb[1];
+	word = b[2] << 8 | b[3];
+	kfree(b);
+
+	return word;
 }
 
 static int dib3000mc_write_word(struct dib3000mc_state *state, u16 reg, u16 val)
 {
-	u8 b[4] = {
-		(reg >> 8) & 0xff, reg & 0xff,
-		(val >> 8) & 0xff, val & 0xff,
-	};
 	struct i2c_msg msg = {
-		.addr = state->i2c_addr >> 1, .flags = 0, .buf = b, .len = 4
+		.addr = state->i2c_addr >> 1, .flags = 0, .len = 4
 	};
-	return i2c_transfer(state->i2c_adap, &msg, 1) != 1 ? -EREMOTEIO : 0;
+	int rc;
+	u8 *b;
+
+	b = kmalloc(4, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
+	b[0] = reg >> 8;
+	b[1] = reg;
+	b[2] = val >> 8;
+	b[3] = val;
+
+	msg.buf = b;
+
+	rc = i2c_transfer(state->i2c_adap, &msg, 1) != 1 ? -EREMOTEIO : 0;
+	kfree(b);
+
+	return rc;
 }
 
 static int dib3000mc_identify(struct dib3000mc_state *state)
diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index 7bec3e028bee..453c4f2a9012 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -753,13 +753,18 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 				    struct i2c_adapter *i2c,
 				    unsigned int pll_desc_id)
 {
-	u8 b1 [] = { 0 };
-	struct i2c_msg msg = { .addr = pll_addr, .flags = I2C_M_RD,
-			       .buf = b1, .len = 1 };
+	u8 *b1;
+	struct i2c_msg msg = { .addr = pll_addr, .flags = I2C_M_RD, .len = 1 };
 	struct dvb_pll_priv *priv = NULL;
 	int ret;
 	const struct dvb_pll_desc *desc;
 
+	b1 = kmalloc(1, GFP_KERNEL);
+	if (!b1)
+		return NULL;
+
+	msg.buf = b1;
+
 	if ((id[dvb_pll_devcount] > DVB_PLL_UNDEFINED) &&
 	    (id[dvb_pll_devcount] < ARRAY_SIZE(pll_list)))
 		pll_desc_id = id[dvb_pll_devcount];
@@ -773,15 +778,19 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 			fe->ops.i2c_gate_ctrl(fe, 1);
 
 		ret = i2c_transfer (i2c, &msg, 1);
-		if (ret != 1)
+		if (ret != 1) {
+			kfree(b1);
 			return NULL;
+		}
 		if (fe->ops.i2c_gate_ctrl)
 			     fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
 	priv = kzalloc(sizeof(struct dvb_pll_priv), GFP_KERNEL);
-	if (priv == NULL)
+	if (!priv) {
+		kfree(b1);
 		return NULL;
+	}
 
 	priv->pll_i2c_address = pll_addr;
 	priv->i2c = i2c;
@@ -811,6 +820,8 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 				"insmod option" : "autodetected");
 	}
 
+	kfree(b1);
+
 	return fe;
 }
 EXPORT_SYMBOL(dvb_pll_attach);
diff --git a/drivers/media/tuners/mt2060.c b/drivers/media/tuners/mt2060.c
index 2e487f9a2cc3..4983eeb39f36 100644
--- a/drivers/media/tuners/mt2060.c
+++ b/drivers/media/tuners/mt2060.c
@@ -38,41 +38,74 @@ MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
 static int mt2060_readreg(struct mt2060_priv *priv, u8 reg, u8 *val)
 {
 	struct i2c_msg msg[2] = {
-		{ .addr = priv->cfg->i2c_address, .flags = 0,        .buf = &reg, .len = 1 },
-		{ .addr = priv->cfg->i2c_address, .flags = I2C_M_RD, .buf = val,  .len = 1 },
+		{ .addr = priv->cfg->i2c_address, .flags = 0, .len = 1 },
+		{ .addr = priv->cfg->i2c_address, .flags = I2C_M_RD, .len = 1 },
 	};
+	int rc = 0;
+	u8 *b;
+
+	b = kmalloc(2, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
+	b[0] = reg;
+	b[1] = 0;
+
+	msg[0].buf = b;
+	msg[1].buf = b + 1;
 
 	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
 		printk(KERN_WARNING "mt2060 I2C read failed\n");
-		return -EREMOTEIO;
+		rc = -EREMOTEIO;
 	}
-	return 0;
+	*val = b[1];
+	kfree(b);
+
+	return rc;
 }
 
 // Writes a single register
 static int mt2060_writereg(struct mt2060_priv *priv, u8 reg, u8 val)
 {
-	u8 buf[2] = { reg, val };
 	struct i2c_msg msg = {
-		.addr = priv->cfg->i2c_address, .flags = 0, .buf = buf, .len = 2
+		.addr = priv->cfg->i2c_address, .flags = 0, .len = 2
 	};
+	u8 *buf;
+	int rc = 0;
+
+	buf = kmalloc(2, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	buf[0] = reg;
+	buf[1] = val;
+
+	msg.buf = buf;
 
 	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
 		printk(KERN_WARNING "mt2060 I2C write failed\n");
-		return -EREMOTEIO;
+		rc = -EREMOTEIO;
 	}
-	return 0;
+	kfree(buf);
+	return rc;
 }
 
 // Writes a set of consecutive registers
 static int mt2060_writeregs(struct mt2060_priv *priv,u8 *buf, u8 len)
 {
 	int rem, val_len;
-	u8 xfer_buf[16];
+	u8 *xfer_buf;
+	int rc = 0;
 	struct i2c_msg msg = {
-		.addr = priv->cfg->i2c_address, .flags = 0, .buf = xfer_buf
+		.addr = priv->cfg->i2c_address, .flags = 0
 	};
 
+	xfer_buf = kmalloc(16, GFP_KERNEL);
+	if (!xfer_buf)
+		return -ENOMEM;
+
+	msg.buf = xfer_buf;
+
 	for (rem = len - 1; rem > 0; rem -= priv->i2c_max_regs) {
 		val_len = min_t(int, rem, priv->i2c_max_regs);
 		msg.len = 1 + val_len;
@@ -81,11 +114,13 @@ static int mt2060_writeregs(struct mt2060_priv *priv,u8 *buf, u8 len)
 
 		if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
 			printk(KERN_WARNING "mt2060 I2C write failed (len=%i)\n", val_len);
-			return -EREMOTEIO;
+			rc = -EREMOTEIO;
+			break;
 		}
 	}
 
-	return 0;
+	kfree(xfer_buf);
+	return rc;
 }
 
 // Initialisation sequences
-- 
2.13.5
