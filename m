Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58924 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbbGIEG4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 00:06:56 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/12] tda10071: rename device state struct to dev
Date: Thu,  9 Jul 2015 07:06:27 +0300
Message-Id: <1436414792-9716-7-git-send-email-crope@iki.fi>
In-Reply-To: <1436414792-9716-1-git-send-email-crope@iki.fi>
References: <1436414792-9716-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename device state struct from 'priv' to 'dev'.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c      | 268 ++++++++++++++--------------
 drivers/media/dvb-frontends/tda10071_priv.h |   2 +-
 2 files changed, 135 insertions(+), 135 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index cc65285..39a4197 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -26,10 +26,10 @@
 static struct dvb_frontend_ops tda10071_ops;
 
 /* write multiple registers */
-static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
+static int tda10071_wr_regs(struct tda10071_dev *dev, u8 reg, u8 *val,
 	int len)
 {
-	struct i2c_client *client = priv->client;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
@@ -62,10 +62,10 @@ static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 }
 
 /* read multiple registers */
-static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
+static int tda10071_rd_regs(struct tda10071_dev *dev, u8 reg, u8 *val,
 	int len)
 {
-	struct i2c_client *client = priv->client;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
@@ -101,19 +101,19 @@ static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 }
 
 /* write single register */
-static int tda10071_wr_reg(struct tda10071_priv *priv, u8 reg, u8 val)
+static int tda10071_wr_reg(struct tda10071_dev *dev, u8 reg, u8 val)
 {
-	return tda10071_wr_regs(priv, reg, &val, 1);
+	return tda10071_wr_regs(dev, reg, &val, 1);
 }
 
 /* read single register */
-static int tda10071_rd_reg(struct tda10071_priv *priv, u8 reg, u8 *val)
+static int tda10071_rd_reg(struct tda10071_dev *dev, u8 reg, u8 *val)
 {
-	return tda10071_rd_regs(priv, reg, val, 1);
+	return tda10071_rd_regs(dev, reg, val, 1);
 }
 
 /* write single register with mask */
-static int tda10071_wr_reg_mask(struct tda10071_priv *priv,
+static int tda10071_wr_reg_mask(struct tda10071_dev *dev,
 				u8 reg, u8 val, u8 mask)
 {
 	int ret;
@@ -121,7 +121,7 @@ static int tda10071_wr_reg_mask(struct tda10071_priv *priv,
 
 	/* no need for read if whole reg is written */
 	if (mask != 0xff) {
-		ret = tda10071_rd_regs(priv, reg, &tmp, 1);
+		ret = tda10071_rd_regs(dev, reg, &tmp, 1);
 		if (ret)
 			return ret;
 
@@ -130,17 +130,17 @@ static int tda10071_wr_reg_mask(struct tda10071_priv *priv,
 		val |= tmp;
 	}
 
-	return tda10071_wr_regs(priv, reg, &val, 1);
+	return tda10071_wr_regs(dev, reg, &val, 1);
 }
 
 /* read single register with mask */
-static int tda10071_rd_reg_mask(struct tda10071_priv *priv,
+static int tda10071_rd_reg_mask(struct tda10071_dev *dev,
 				u8 reg, u8 *val, u8 mask)
 {
 	int ret, i;
 	u8 tmp;
 
-	ret = tda10071_rd_regs(priv, reg, &tmp, 1);
+	ret = tda10071_rd_regs(dev, reg, &tmp, 1);
 	if (ret)
 		return ret;
 
@@ -157,31 +157,31 @@ static int tda10071_rd_reg_mask(struct tda10071_priv *priv,
 }
 
 /* execute firmware command */
-static int tda10071_cmd_execute(struct tda10071_priv *priv,
+static int tda10071_cmd_execute(struct tda10071_dev *dev,
 	struct tda10071_cmd *cmd)
 {
-	struct i2c_client *client = priv->client;
+	struct i2c_client *client = dev->client;
 	int ret, i;
 	u8 tmp;
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EFAULT;
 		goto error;
 	}
 
 	/* write cmd and args for firmware */
-	ret = tda10071_wr_regs(priv, 0x00, cmd->args, cmd->len);
+	ret = tda10071_wr_regs(dev, 0x00, cmd->args, cmd->len);
 	if (ret)
 		goto error;
 
 	/* start cmd execution */
-	ret = tda10071_wr_reg(priv, 0x1f, 1);
+	ret = tda10071_wr_reg(dev, 0x1f, 1);
 	if (ret)
 		goto error;
 
 	/* wait cmd execution terminate */
 	for (i = 1000, tmp = 1; i && tmp; i--) {
-		ret = tda10071_rd_reg(priv, 0x1f, &tmp);
+		ret = tda10071_rd_reg(dev, 0x1f, &tmp);
 		if (ret)
 			goto error;
 
@@ -204,13 +204,13 @@ error:
 static int tda10071_set_tone(struct dvb_frontend *fe,
 	enum fe_sec_tone_mode fe_sec_tone_mode)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret;
 	u8 tone;
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EFAULT;
 		goto error;
 	}
@@ -236,7 +236,7 @@ static int tda10071_set_tone(struct dvb_frontend *fe,
 	cmd.args[3] = 0x00;
 	cmd.args[4] = tone;
 	cmd.len = 5;
-	ret = tda10071_cmd_execute(priv, &cmd);
+	ret = tda10071_cmd_execute(dev, &cmd);
 	if (ret)
 		goto error;
 
@@ -249,13 +249,13 @@ error:
 static int tda10071_set_voltage(struct dvb_frontend *fe,
 	enum fe_sec_voltage fe_sec_voltage)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret;
 	u8 voltage;
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EFAULT;
 		goto error;
 	}
@@ -282,7 +282,7 @@ static int tda10071_set_voltage(struct dvb_frontend *fe,
 	cmd.args[1] = 0;
 	cmd.args[2] = voltage;
 	cmd.len = 3;
-	ret = tda10071_cmd_execute(priv, &cmd);
+	ret = tda10071_cmd_execute(dev, &cmd);
 	if (ret)
 		goto error;
 
@@ -295,13 +295,13 @@ error:
 static int tda10071_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	struct dvb_diseqc_master_cmd *diseqc_cmd)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret, i;
 	u8 tmp;
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EFAULT;
 		goto error;
 	}
@@ -315,7 +315,7 @@ static int tda10071_diseqc_send_master_cmd(struct dvb_frontend *fe,
 
 	/* wait LNB TX */
 	for (i = 500, tmp = 0; i && !tmp; i--) {
-		ret = tda10071_rd_reg_mask(priv, 0x47, &tmp, 0x01);
+		ret = tda10071_rd_reg_mask(dev, 0x47, &tmp, 0x01);
 		if (ret)
 			goto error;
 
@@ -329,7 +329,7 @@ static int tda10071_diseqc_send_master_cmd(struct dvb_frontend *fe,
 		goto error;
 	}
 
-	ret = tda10071_wr_reg_mask(priv, 0x47, 0x00, 0x01);
+	ret = tda10071_wr_reg_mask(dev, 0x47, 0x00, 0x01);
 	if (ret)
 		goto error;
 
@@ -342,7 +342,7 @@ static int tda10071_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	cmd.args[6] = diseqc_cmd->msg_len;
 	memcpy(&cmd.args[7], diseqc_cmd->msg, diseqc_cmd->msg_len);
 	cmd.len = 7 + diseqc_cmd->msg_len;
-	ret = tda10071_cmd_execute(priv, &cmd);
+	ret = tda10071_cmd_execute(dev, &cmd);
 	if (ret)
 		goto error;
 
@@ -355,13 +355,13 @@ error:
 static int tda10071_diseqc_recv_slave_reply(struct dvb_frontend *fe,
 	struct dvb_diseqc_slave_reply *reply)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret, i;
 	u8 tmp;
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EFAULT;
 		goto error;
 	}
@@ -370,7 +370,7 @@ static int tda10071_diseqc_recv_slave_reply(struct dvb_frontend *fe,
 
 	/* wait LNB RX */
 	for (i = 500, tmp = 0; i && !tmp; i--) {
-		ret = tda10071_rd_reg_mask(priv, 0x47, &tmp, 0x02);
+		ret = tda10071_rd_reg_mask(dev, 0x47, &tmp, 0x02);
 		if (ret)
 			goto error;
 
@@ -385,7 +385,7 @@ static int tda10071_diseqc_recv_slave_reply(struct dvb_frontend *fe,
 	}
 
 	/* reply len */
-	ret = tda10071_rd_reg(priv, 0x46, &tmp);
+	ret = tda10071_rd_reg(dev, 0x46, &tmp);
 	if (ret)
 		goto error;
 
@@ -397,11 +397,11 @@ static int tda10071_diseqc_recv_slave_reply(struct dvb_frontend *fe,
 	cmd.args[0] = CMD_LNB_UPDATE_REPLY;
 	cmd.args[1] = 0;
 	cmd.len = 2;
-	ret = tda10071_cmd_execute(priv, &cmd);
+	ret = tda10071_cmd_execute(dev, &cmd);
 	if (ret)
 		goto error;
 
-	ret = tda10071_rd_regs(priv, cmd.len, reply->msg, reply->msg_len);
+	ret = tda10071_rd_regs(dev, cmd.len, reply->msg, reply->msg_len);
 	if (ret)
 		goto error;
 
@@ -414,13 +414,13 @@ error:
 static int tda10071_diseqc_send_burst(struct dvb_frontend *fe,
 	enum fe_sec_mini_cmd fe_sec_mini_cmd)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret, i;
 	u8 tmp, burst;
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EFAULT;
 		goto error;
 	}
@@ -442,7 +442,7 @@ static int tda10071_diseqc_send_burst(struct dvb_frontend *fe,
 
 	/* wait LNB TX */
 	for (i = 500, tmp = 0; i && !tmp; i--) {
-		ret = tda10071_rd_reg_mask(priv, 0x47, &tmp, 0x01);
+		ret = tda10071_rd_reg_mask(dev, 0x47, &tmp, 0x01);
 		if (ret)
 			goto error;
 
@@ -456,7 +456,7 @@ static int tda10071_diseqc_send_burst(struct dvb_frontend *fe,
 		goto error;
 	}
 
-	ret = tda10071_wr_reg_mask(priv, 0x47, 0x00, 0x01);
+	ret = tda10071_wr_reg_mask(dev, 0x47, 0x00, 0x01);
 	if (ret)
 		goto error;
 
@@ -464,7 +464,7 @@ static int tda10071_diseqc_send_burst(struct dvb_frontend *fe,
 	cmd.args[1] = 0;
 	cmd.args[2] = burst;
 	cmd.len = 3;
-	ret = tda10071_cmd_execute(priv, &cmd);
+	ret = tda10071_cmd_execute(dev, &cmd);
 	if (ret)
 		goto error;
 
@@ -476,19 +476,19 @@ error:
 
 static int tda10071_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 tmp;
 
 	*status = 0;
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = 0;
 		goto error;
 	}
 
-	ret = tda10071_rd_reg(priv, 0x39, &tmp);
+	ret = tda10071_rd_reg(dev, 0x39, &tmp);
 	if (ret)
 		goto error;
 
@@ -500,7 +500,7 @@ static int tda10071_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	if (tmp & 0x08) /* RS or BCH */
 		*status |= FE_HAS_SYNC | FE_HAS_LOCK;
 
-	priv->fe_status = *status;
+	dev->fe_status = *status;
 
 	return ret;
 error:
@@ -510,18 +510,18 @@ error:
 
 static int tda10071_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[2];
 
-	if (!priv->warm || !(priv->fe_status & FE_HAS_LOCK)) {
+	if (!dev->warm || !(dev->fe_status & FE_HAS_LOCK)) {
 		*snr = 0;
 		ret = 0;
 		goto error;
 	}
 
-	ret = tda10071_rd_regs(priv, 0x3a, buf, 2);
+	ret = tda10071_rd_regs(dev, 0x3a, buf, 2);
 	if (ret)
 		goto error;
 
@@ -536,13 +536,13 @@ error:
 
 static int tda10071_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret;
 	u8 tmp;
 
-	if (!priv->warm || !(priv->fe_status & FE_HAS_LOCK)) {
+	if (!dev->warm || !(dev->fe_status & FE_HAS_LOCK)) {
 		*strength = 0;
 		ret = 0;
 		goto error;
@@ -551,12 +551,12 @@ static int tda10071_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	cmd.args[0] = CMD_GET_AGCACC;
 	cmd.args[1] = 0;
 	cmd.len = 2;
-	ret = tda10071_cmd_execute(priv, &cmd);
+	ret = tda10071_cmd_execute(dev, &cmd);
 	if (ret)
 		goto error;
 
 	/* input power estimate dBm */
-	ret = tda10071_rd_reg(priv, 0x50, &tmp);
+	ret = tda10071_rd_reg(dev, 0x50, &tmp);
 	if (ret)
 		goto error;
 
@@ -576,19 +576,19 @@ error:
 
 static int tda10071_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret, i, len;
 	u8 tmp, reg, buf[8];
 
-	if (!priv->warm || !(priv->fe_status & FE_HAS_LOCK)) {
-		*ber = priv->ber = 0;
+	if (!dev->warm || !(dev->fe_status & FE_HAS_LOCK)) {
+		*ber = dev->ber = 0;
 		ret = 0;
 		goto error;
 	}
 
-	switch (priv->delivery_system) {
+	switch (dev->delivery_system) {
 	case SYS_DVBS:
 		reg = 0x4c;
 		len = 8;
@@ -600,41 +600,41 @@ static int tda10071_read_ber(struct dvb_frontend *fe, u32 *ber)
 		i = 0;
 		break;
 	default:
-		*ber = priv->ber = 0;
+		*ber = dev->ber = 0;
 		return 0;
 	}
 
-	ret = tda10071_rd_reg(priv, reg, &tmp);
+	ret = tda10071_rd_reg(dev, reg, &tmp);
 	if (ret)
 		goto error;
 
-	if (priv->meas_count[i] == tmp) {
+	if (dev->meas_count[i] == tmp) {
 		dev_dbg(&client->dev, "meas not ready=%02x\n", tmp);
-		*ber = priv->ber;
+		*ber = dev->ber;
 		return 0;
 	} else {
-		priv->meas_count[i] = tmp;
+		dev->meas_count[i] = tmp;
 	}
 
 	cmd.args[0] = CMD_BER_UPDATE_COUNTERS;
 	cmd.args[1] = 0;
 	cmd.args[2] = i;
 	cmd.len = 3;
-	ret = tda10071_cmd_execute(priv, &cmd);
+	ret = tda10071_cmd_execute(dev, &cmd);
 	if (ret)
 		goto error;
 
-	ret = tda10071_rd_regs(priv, cmd.len, buf, len);
+	ret = tda10071_rd_regs(dev, cmd.len, buf, len);
 	if (ret)
 		goto error;
 
-	if (priv->delivery_system == SYS_DVBS) {
+	if (dev->delivery_system == SYS_DVBS) {
 		*ber = (buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3];
-		priv->ucb += (buf[4] << 8) | buf[5];
+		dev->ucb += (buf[4] << 8) | buf[5];
 	} else {
 		*ber = (buf[0] << 8) | buf[1];
 	}
-	priv->ber = *ber;
+	dev->ber = *ber;
 
 	return ret;
 error:
@@ -644,18 +644,18 @@ error:
 
 static int tda10071_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret = 0;
 
-	if (!priv->warm || !(priv->fe_status & FE_HAS_LOCK)) {
+	if (!dev->warm || !(dev->fe_status & FE_HAS_LOCK)) {
 		*ucblocks = 0;
 		goto error;
 	}
 
 	/* UCB is updated when BER is read. Assume BER is read anyway. */
 
-	*ucblocks = priv->ucb;
+	*ucblocks = dev->ucb;
 
 	return ret;
 error:
@@ -665,8 +665,8 @@ error:
 
 static int tda10071_set_frontend(struct dvb_frontend *fe)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
@@ -678,9 +678,9 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 		c->delivery_system, c->modulation, c->frequency, c->symbol_rate,
 		c->inversion, c->pilot, c->rolloff);
 
-	priv->delivery_system = SYS_UNDEFINED;
+	dev->delivery_system = SYS_UNDEFINED;
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EFAULT;
 		goto error;
 	}
@@ -772,11 +772,11 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 	else
 		div = 4;
 
-	ret = tda10071_wr_reg(priv, 0x81, div);
+	ret = tda10071_wr_reg(dev, 0x81, div);
 	if (ret)
 		goto error;
 
-	ret = tda10071_wr_reg(priv, 0xe3, div);
+	ret = tda10071_wr_reg(dev, 0xe3, div);
 	if (ret)
 		goto error;
 
@@ -796,11 +796,11 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 	cmd.args[13] = 0x00;
 	cmd.args[14] = 0x00;
 	cmd.len = 15;
-	ret = tda10071_cmd_execute(priv, &cmd);
+	ret = tda10071_cmd_execute(dev, &cmd);
 	if (ret)
 		goto error;
 
-	priv->delivery_system = c->delivery_system;
+	dev->delivery_system = c->delivery_system;
 
 	return ret;
 error:
@@ -810,18 +810,18 @@ error:
 
 static int tda10071_get_frontend(struct dvb_frontend *fe)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u8 buf[5], tmp;
 
-	if (!priv->warm || !(priv->fe_status & FE_HAS_LOCK)) {
+	if (!dev->warm || !(dev->fe_status & FE_HAS_LOCK)) {
 		ret = -EFAULT;
 		goto error;
 	}
 
-	ret = tda10071_rd_regs(priv, 0x30, buf, 5);
+	ret = tda10071_rd_regs(dev, 0x30, buf, 5);
 	if (ret)
 		goto error;
 
@@ -854,7 +854,7 @@ static int tda10071_get_frontend(struct dvb_frontend *fe)
 
 	c->frequency = (buf[2] << 16) | (buf[3] << 8) | (buf[4] << 0);
 
-	ret = tda10071_rd_regs(priv, 0x52, buf, 3);
+	ret = tda10071_rd_regs(dev, 0x52, buf, 3);
 	if (ret)
 		goto error;
 
@@ -868,8 +868,8 @@ error:
 
 static int tda10071_init(struct dvb_frontend *fe)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret, i, len, remaining, fw_size;
 	const struct firmware *fw;
@@ -889,7 +889,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 	};
 	struct tda10071_reg_val_mask tab2[] = {
 		{ 0xf1, 0x70, 0xff },
-		{ 0x88, priv->pll_multiplier, 0x3f },
+		{ 0x88, dev->pll_multiplier, 0x3f },
 		{ 0x89, 0x00, 0x10 },
 		{ 0x89, 0x10, 0x10 },
 		{ 0xc0, 0x01, 0x01 },
@@ -933,11 +933,11 @@ static int tda10071_init(struct dvb_frontend *fe)
 		{ 0xd5, 0x03, 0x03 },
 	};
 
-	if (priv->warm) {
+	if (dev->warm) {
 		/* warm state - wake up device from sleep */
 
 		for (i = 0; i < ARRAY_SIZE(tab); i++) {
-			ret = tda10071_wr_reg_mask(priv, tab[i].reg,
+			ret = tda10071_wr_reg_mask(dev, tab[i].reg,
 				tab[i].val, tab[i].mask);
 			if (ret)
 				goto error;
@@ -947,7 +947,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 		cmd.args[1] = 0;
 		cmd.args[2] = 0;
 		cmd.len = 3;
-		ret = tda10071_cmd_execute(priv, &cmd);
+		ret = tda10071_cmd_execute(dev, &cmd);
 		if (ret)
 			goto error;
 	} else {
@@ -964,26 +964,26 @@ static int tda10071_init(struct dvb_frontend *fe)
 
 		/* init */
 		for (i = 0; i < ARRAY_SIZE(tab2); i++) {
-			ret = tda10071_wr_reg_mask(priv, tab2[i].reg,
+			ret = tda10071_wr_reg_mask(dev, tab2[i].reg,
 				tab2[i].val, tab2[i].mask);
 			if (ret)
 				goto error_release_firmware;
 		}
 
 		/*  download firmware */
-		ret = tda10071_wr_reg(priv, 0xe0, 0x7f);
+		ret = tda10071_wr_reg(dev, 0xe0, 0x7f);
 		if (ret)
 			goto error_release_firmware;
 
-		ret = tda10071_wr_reg(priv, 0xf7, 0x81);
+		ret = tda10071_wr_reg(dev, 0xf7, 0x81);
 		if (ret)
 			goto error_release_firmware;
 
-		ret = tda10071_wr_reg(priv, 0xf8, 0x00);
+		ret = tda10071_wr_reg(dev, 0xf8, 0x00);
 		if (ret)
 			goto error_release_firmware;
 
-		ret = tda10071_wr_reg(priv, 0xf9, 0x00);
+		ret = tda10071_wr_reg(dev, 0xf9, 0x00);
 		if (ret)
 			goto error_release_firmware;
 
@@ -997,12 +997,12 @@ static int tda10071_init(struct dvb_frontend *fe)
 		fw_size = fw->size - 1;
 
 		for (remaining = fw_size; remaining > 0;
-			remaining -= (priv->i2c_wr_max - 1)) {
+			remaining -= (dev->i2c_wr_max - 1)) {
 			len = remaining;
-			if (len > (priv->i2c_wr_max - 1))
-				len = (priv->i2c_wr_max - 1);
+			if (len > (dev->i2c_wr_max - 1))
+				len = (dev->i2c_wr_max - 1);
 
-			ret = tda10071_wr_regs(priv, 0xfa,
+			ret = tda10071_wr_regs(dev, 0xfa,
 				(u8 *) &fw->data[fw_size - remaining], len);
 			if (ret) {
 				dev_err(&client->dev,
@@ -1012,11 +1012,11 @@ static int tda10071_init(struct dvb_frontend *fe)
 		}
 		release_firmware(fw);
 
-		ret = tda10071_wr_reg(priv, 0xf7, 0x0c);
+		ret = tda10071_wr_reg(dev, 0xf7, 0x0c);
 		if (ret)
 			goto error;
 
-		ret = tda10071_wr_reg(priv, 0xe0, 0x00);
+		ret = tda10071_wr_reg(dev, 0xe0, 0x00);
 		if (ret)
 			goto error;
 
@@ -1024,7 +1024,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 		msleep(250);
 
 		/* firmware status */
-		ret = tda10071_rd_reg(priv, 0x51, &tmp);
+		ret = tda10071_rd_reg(dev, 0x51, &tmp);
 		if (ret)
 			goto error;
 
@@ -1033,16 +1033,16 @@ static int tda10071_init(struct dvb_frontend *fe)
 			ret = -EFAULT;
 			goto error;
 		} else {
-			priv->warm = true;
+			dev->warm = true;
 		}
 
 		cmd.args[0] = CMD_GET_FW_VERSION;
 		cmd.len = 1;
-		ret = tda10071_cmd_execute(priv, &cmd);
+		ret = tda10071_cmd_execute(dev, &cmd);
 		if (ret)
 			goto error;
 
-		ret = tda10071_rd_regs(priv, cmd.len, buf, 4);
+		ret = tda10071_rd_regs(dev, cmd.len, buf, 4);
 		if (ret)
 			goto error;
 
@@ -1051,25 +1051,25 @@ static int tda10071_init(struct dvb_frontend *fe)
 		dev_info(&client->dev, "found a '%s' in warm state\n",
 			 tda10071_ops.info.name);
 
-		ret = tda10071_rd_regs(priv, 0x81, buf, 2);
+		ret = tda10071_rd_regs(dev, 0x81, buf, 2);
 		if (ret)
 			goto error;
 
 		cmd.args[0] = CMD_DEMOD_INIT;
-		cmd.args[1] = ((priv->clk / 1000) >> 8) & 0xff;
-		cmd.args[2] = ((priv->clk / 1000) >> 0) & 0xff;
+		cmd.args[1] = ((dev->clk / 1000) >> 8) & 0xff;
+		cmd.args[2] = ((dev->clk / 1000) >> 0) & 0xff;
 		cmd.args[3] = buf[0];
 		cmd.args[4] = buf[1];
-		cmd.args[5] = priv->pll_multiplier;
-		cmd.args[6] = priv->spec_inv;
+		cmd.args[5] = dev->pll_multiplier;
+		cmd.args[6] = dev->spec_inv;
 		cmd.args[7] = 0x00;
 		cmd.len = 8;
-		ret = tda10071_cmd_execute(priv, &cmd);
+		ret = tda10071_cmd_execute(dev, &cmd);
 		if (ret)
 			goto error;
 
-		if (priv->tuner_i2c_addr)
-			tmp = priv->tuner_i2c_addr;
+		if (dev->tuner_i2c_addr)
+			tmp = dev->tuner_i2c_addr;
 		else
 			tmp = 0x14;
 
@@ -1089,22 +1089,22 @@ static int tda10071_init(struct dvb_frontend *fe)
 		cmd.args[13] = 0x00;
 		cmd.args[14] = 0x00;
 		cmd.len = 15;
-		ret = tda10071_cmd_execute(priv, &cmd);
+		ret = tda10071_cmd_execute(dev, &cmd);
 		if (ret)
 			goto error;
 
 		cmd.args[0] = CMD_MPEG_CONFIG;
 		cmd.args[1] = 0;
-		cmd.args[2] = priv->ts_mode;
+		cmd.args[2] = dev->ts_mode;
 		cmd.args[3] = 0x00;
 		cmd.args[4] = 0x04;
 		cmd.args[5] = 0x00;
 		cmd.len = 6;
-		ret = tda10071_cmd_execute(priv, &cmd);
+		ret = tda10071_cmd_execute(dev, &cmd);
 		if (ret)
 			goto error;
 
-		ret = tda10071_wr_reg_mask(priv, 0xf0, 0x01, 0x01);
+		ret = tda10071_wr_reg_mask(dev, 0xf0, 0x01, 0x01);
 		if (ret)
 			goto error;
 
@@ -1120,7 +1120,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 		cmd.args[9] = 30;
 		cmd.args[10] = 30;
 		cmd.len = 11;
-		ret = tda10071_cmd_execute(priv, &cmd);
+		ret = tda10071_cmd_execute(dev, &cmd);
 		if (ret)
 			goto error;
 
@@ -1129,7 +1129,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 		cmd.args[2] = 14;
 		cmd.args[3] = 14;
 		cmd.len = 4;
-		ret = tda10071_cmd_execute(priv, &cmd);
+		ret = tda10071_cmd_execute(dev, &cmd);
 		if (ret)
 			goto error;
 	}
@@ -1144,8 +1144,8 @@ error:
 
 static int tda10071_sleep(struct dvb_frontend *fe)
 {
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	struct i2c_client *client = priv->client;
+	struct tda10071_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret, i;
 	struct tda10071_reg_val_mask tab[] = {
@@ -1161,7 +1161,7 @@ static int tda10071_sleep(struct dvb_frontend *fe)
 		{ 0xce, 0x10, 0x10 },
 	};
 
-	if (!priv->warm) {
+	if (!dev->warm) {
 		ret = -EFAULT;
 		goto error;
 	}
@@ -1170,12 +1170,12 @@ static int tda10071_sleep(struct dvb_frontend *fe)
 	cmd.args[1] = 0;
 	cmd.args[2] = 1;
 	cmd.len = 3;
-	ret = tda10071_cmd_execute(priv, &cmd);
+	ret = tda10071_cmd_execute(dev, &cmd);
 	if (ret)
 		goto error;
 
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
-		ret = tda10071_wr_reg_mask(priv, tab[i].reg, tab[i].val,
+		ret = tda10071_wr_reg_mask(dev, tab[i].reg, tab[i].val,
 			tab[i].mask);
 		if (ret)
 			goto error;
@@ -1245,7 +1245,7 @@ static struct dvb_frontend_ops tda10071_ops = {
 
 static struct dvb_frontend *tda10071_get_dvb_frontend(struct i2c_client *client)
 {
-	struct tda10071_priv *dev = i2c_get_clientdata(client);
+	struct tda10071_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 
@@ -1255,7 +1255,7 @@ static struct dvb_frontend *tda10071_get_dvb_frontend(struct i2c_client *client)
 static int tda10071_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct tda10071_priv *dev;
+	struct tda10071_dev *dev;
 	struct tda10071_platform_data *pdata = client->dev.platform_data;
 	int ret;
 	u8 u8tmp;
diff --git a/drivers/media/dvb-frontends/tda10071_priv.h b/drivers/media/dvb-frontends/tda10071_priv.h
index a6d8f8c..9800028 100644
--- a/drivers/media/dvb-frontends/tda10071_priv.h
+++ b/drivers/media/dvb-frontends/tda10071_priv.h
@@ -25,7 +25,7 @@
 #include "tda10071.h"
 #include <linux/firmware.h>
 
-struct tda10071_priv {
+struct tda10071_dev {
 	struct dvb_frontend fe;
 	struct i2c_client *client;
 	u32 clk;
-- 
http://palosaari.fi/

