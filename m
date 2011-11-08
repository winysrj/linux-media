Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58000 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933423Ab1KHX7t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Nov 2011 18:59:49 -0500
Message-ID: <4EB9C272.2010607@iki.fi>
Date: Wed, 09 Nov 2011 01:59:46 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jean Delvare <khali@linux-fr.org>
Subject: [RFC 2/2] tda18218: use generic dvb_wr_regs()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
  drivers/media/common/tuners/tda18218.c      |   69 
+++++---------------------
  drivers/media/common/tuners/tda18218_priv.h |    3 +
  2 files changed, 17 insertions(+), 55 deletions(-)

diff --git a/drivers/media/common/tuners/tda18218.c 
b/drivers/media/common/tuners/tda18218.c
index aacfe23..fef5560f 100644
--- a/drivers/media/common/tuners/tda18218.c
+++ b/drivers/media/common/tuners/tda18218.c
@@ -25,46 +25,6 @@ static int debug;
  module_param(debug, int, 0644);
  MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");

-/* write multiple registers */
-static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 
*val, u8 len)
-{
-	int ret = 0;
-	u8 buf[1+len], quotient, remainder, i, msg_len, msg_len_max;
-	struct i2c_msg msg[1] = {
-		{
-			.addr = priv->cfg->i2c_address,
-			.flags = 0,
-			.buf = buf,
-		}
-	};
-
-	msg_len_max = priv->cfg->i2c_wr_max - 1;
-	quotient = len / msg_len_max;
-	remainder = len % msg_len_max;
-	msg_len = msg_len_max;
-	for (i = 0; (i <= quotient && remainder); i++) {
-		if (i == quotient)  /* set len of the last msg */
-			msg_len = remainder;
-
-		msg[0].len = msg_len + 1;
-		buf[0] = reg + i * msg_len_max;
-		memcpy(&buf[1], &val[i * msg_len_max], msg_len);
-
-		ret = i2c_transfer(priv->i2c, msg, 1);
-		if (ret != 1)
-			break;
-	}
-
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		warn("i2c wr failed ret:%d reg:%02x len:%d", ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
  /* read multiple registers */
  static int tda18218_rd_regs(struct tda18218_priv *priv, u8 reg, u8 
*val, u8 len)
  {
@@ -96,14 +56,7 @@ static int tda18218_rd_regs(struct tda18218_priv 
*priv, u8 reg, u8 *val, u8 len)
  	return ret;
  }

-/* write single register */
-static int tda18218_wr_reg(struct tda18218_priv *priv, u8 reg, u8 val)
-{
-	return tda18218_wr_regs(priv, reg, &val, 1);
-}
-
  /* read single register */
-
  static int tda18218_rd_reg(struct tda18218_priv *priv, u8 reg, u8 *val)
  {
  	return tda18218_rd_regs(priv, reg, val, 1);
@@ -167,7 +120,7 @@ static int tda18218_set_params(struct dvb_frontend *fe,
  	buf[0] = (priv->regs[R1A_IF1] & ~7) | BP_Filter; /* BP_Filter */
  	buf[1] = (priv->regs[R1B_IF2] & ~3) | LP_Fc; /* LP_Fc */
  	buf[2] = priv->regs[R1C_AGC2B];
-	ret = tda18218_wr_regs(priv, R1A_IF1, buf, 3);
+	ret = dvb_wr_regs(&priv->i2c_cfg, R1A_IF1, buf, 3);
  	if (ret)
  		goto error;

@@ -175,23 +128,23 @@ static int tda18218_set_params(struct dvb_frontend 
*fe,
  	buf[1] = (LO_Frac / 1000) >> 4; /* LO_Frac_1 */
  	buf[2] = (LO_Frac / 1000) << 4 |
  		(priv->regs[R0C_MD5] & 0x0f); /* LO_Frac_2 */
-	ret = tda18218_wr_regs(priv, R0A_MD3, buf, 3);
+	ret = dvb_wr_regs(&priv->i2c_cfg, R0A_MD3, buf, 3);
  	if (ret)
  		goto error;

  	buf[0] = priv->regs[R0F_MD8] | (1 << 6); /* Freq_prog_Start */
-	ret = tda18218_wr_regs(priv, R0F_MD8, buf, 1);
+	ret = dvb_wr_regs(&priv->i2c_cfg, R0F_MD8, buf, 1);
  	if (ret)
  		goto error;

  	buf[0] = priv->regs[R0F_MD8] & ~(1 << 6); /* Freq_prog_Start */
-	ret = tda18218_wr_regs(priv, R0F_MD8, buf, 1);
+	ret = dvb_wr_regs(&priv->i2c_cfg, R0F_MD8, buf, 1);
  	if (ret)
  		goto error;

  	/* trigger AGC */
  	for (i = 0; i < ARRAY_SIZE(agc); i++) {
-		ret = tda18218_wr_reg(priv, agc[i][0], agc[i][1]);
+		ret = dvb_wr_reg(&priv->i2c_cfg, agc[i][0], agc[i][1]);
  		if (ret)
  			goto error;
  	}
@@ -215,7 +168,8 @@ static int tda18218_sleep(struct dvb_frontend *fe)
  		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */

  	/* standby */
-	ret = tda18218_wr_reg(priv, R17_PD1, priv->regs[R17_PD1] | (1 << 0));
+	ret = dvb_wr_reg(&priv->i2c_cfg, R17_PD1,
+		priv->regs[R17_PD1] | (1 << 0));

  	if (fe->ops.i2c_gate_ctrl)
  		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
@@ -236,7 +190,8 @@ static int tda18218_init(struct dvb_frontend *fe)
  	if (fe->ops.i2c_gate_ctrl)
  		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */

-	ret = tda18218_wr_regs(priv, R00_ID, priv->regs, TDA18218_NUM_REGS);
+	ret = dvb_wr_regs(&priv->i2c_cfg, R00_ID, priv->regs,
+		TDA18218_NUM_REGS);

  	if (fe->ops.i2c_gate_ctrl)
  		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
@@ -292,6 +247,9 @@ struct dvb_frontend *tda18218_attach(struct 
dvb_frontend *fe,

  	priv->cfg = cfg;
  	priv->i2c = i2c;
+	priv->i2c_cfg.adapter = i2c;
+	priv->i2c_cfg.addr = cfg->i2c_address;
+	priv->i2c_cfg.max_wr = cfg->i2c_wr_max;
  	fe->tuner_priv = priv;

  	if (fe->ops.i2c_gate_ctrl)
@@ -318,7 +276,8 @@ struct dvb_frontend *tda18218_attach(struct 
dvb_frontend *fe,
  	}

  	/* standby */
-	ret = tda18218_wr_reg(priv, R17_PD1, priv->regs[R17_PD1] | (1 << 0));
+	ret = dvb_wr_reg(&priv->i2c_cfg, R17_PD1,
+		priv->regs[R17_PD1] | (1 << 0));
  	if (ret)
  		dbg("%s: failed ret:%d", __func__, ret);

diff --git a/drivers/media/common/tuners/tda18218_priv.h 
b/drivers/media/common/tuners/tda18218_priv.h
index 904e536..72d7277 100644
--- a/drivers/media/common/tuners/tda18218_priv.h
+++ b/drivers/media/common/tuners/tda18218_priv.h
@@ -23,6 +23,8 @@

  #define LOG_PREFIX "tda18218"

+#include "dvb_generic.h"
+
  #undef dbg
  #define dbg(f, arg...) \
  	if (debug) \
@@ -99,6 +101,7 @@
  struct tda18218_priv {
  	struct tda18218_config *cfg;
  	struct i2c_adapter *i2c;
+	struct dvb_i2c_cfg i2c_cfg;

  	u8 regs[TDA18218_NUM_REGS];
  };
-- 
1.7.4.4
