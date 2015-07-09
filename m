Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33887 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbbGIEG4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 00:06:56 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/12] tda10071: convert to regmap I2C API
Date: Thu,  9 Jul 2015 07:06:28 +0300
Message-Id: <1436414792-9716-8-git-send-email-crope@iki.fi>
In-Reply-To: <1436414792-9716-1-git-send-email-crope@iki.fi>
References: <1436414792-9716-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use regmap API for I2C operations.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig         |   1 +
 drivers/media/dvb-frontends/tda10071.c      | 263 +++++++++-------------------
 drivers/media/dvb-frontends/tda10071_priv.h |   2 +
 3 files changed, 87 insertions(+), 179 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 5ab90f3..e717a05 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -264,6 +264,7 @@ config DVB_MB86A16
 config DVB_TDA10071
 	tristate "NXP TDA10071"
 	depends on DVB_CORE && I2C
+	select REGMAP
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 39a4197..6226b57 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -20,98 +20,13 @@
 
 #include "tda10071_priv.h"
 
-/* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
-
 static struct dvb_frontend_ops tda10071_ops;
 
-/* write multiple registers */
-static int tda10071_wr_regs(struct tda10071_dev *dev, u8 reg, u8 *val,
-	int len)
-{
-	struct i2c_client *client = dev->client;
-	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = 1 + len,
-			.buf = buf,
-		}
-	};
-
-	if (1 + len > sizeof(buf)) {
-		dev_warn(&client->dev, "i2c wr reg=%04x: len=%d is too big!\n",
-				reg, len);
-		return -EINVAL;
-	}
-
-	buf[0] = reg;
-	memcpy(&buf[1], val, len);
-
-	ret = i2c_transfer(client->adapter, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&client->dev, "i2c wr failed=%d reg=%02x len=%d\n",
-				ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-	return ret;
-}
-
-/* read multiple registers */
-static int tda10071_rd_regs(struct tda10071_dev *dev, u8 reg, u8 *val,
-	int len)
-{
-	struct i2c_client *client = dev->client;
-	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[2] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = 1,
-			.buf = &reg,
-		}, {
-			.addr = client->addr,
-			.flags = I2C_M_RD,
-			.len = len,
-			.buf = buf,
-		}
-	};
-
-	if (len > sizeof(buf)) {
-		dev_warn(&client->dev, "i2c wr reg=%04x: len=%d is too big!\n",
-				reg, len);
-		return -EINVAL;
-	}
-
-	ret = i2c_transfer(client->adapter, msg, 2);
-	if (ret == 2) {
-		memcpy(val, buf, len);
-		ret = 0;
-	} else {
-		dev_warn(&client->dev, "i2c rd failed=%d reg=%02x len=%d\n",
-				ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-	return ret;
-}
-
-/* write single register */
-static int tda10071_wr_reg(struct tda10071_dev *dev, u8 reg, u8 val)
-{
-	return tda10071_wr_regs(dev, reg, &val, 1);
-}
-
-/* read single register */
-static int tda10071_rd_reg(struct tda10071_dev *dev, u8 reg, u8 *val)
-{
-	return tda10071_rd_regs(dev, reg, val, 1);
-}
-
+/*
+ * XXX: regmap_update_bits() does not fit our needs as it does not support
+ * partially volatile registers. Also it performs register read even mask is as
+ * wide as register value.
+ */
 /* write single register with mask */
 static int tda10071_wr_reg_mask(struct tda10071_dev *dev,
 				u8 reg, u8 val, u8 mask)
@@ -121,7 +36,7 @@ static int tda10071_wr_reg_mask(struct tda10071_dev *dev,
 
 	/* no need for read if whole reg is written */
 	if (mask != 0xff) {
-		ret = tda10071_rd_regs(dev, reg, &tmp, 1);
+		ret = regmap_bulk_read(dev->regmap, reg, &tmp, 1);
 		if (ret)
 			return ret;
 
@@ -130,30 +45,7 @@ static int tda10071_wr_reg_mask(struct tda10071_dev *dev,
 		val |= tmp;
 	}
 
-	return tda10071_wr_regs(dev, reg, &val, 1);
-}
-
-/* read single register with mask */
-static int tda10071_rd_reg_mask(struct tda10071_dev *dev,
-				u8 reg, u8 *val, u8 mask)
-{
-	int ret, i;
-	u8 tmp;
-
-	ret = tda10071_rd_regs(dev, reg, &tmp, 1);
-	if (ret)
-		return ret;
-
-	tmp &= mask;
-
-	/* find position of the first bit */
-	for (i = 0; i < 8; i++) {
-		if ((mask >> i) & 0x01)
-			break;
-	}
-	*val = tmp >> i;
-
-	return 0;
+	return regmap_bulk_write(dev->regmap, reg, &val, 1);
 }
 
 /* execute firmware command */
@@ -162,7 +54,7 @@ static int tda10071_cmd_execute(struct tda10071_dev *dev,
 {
 	struct i2c_client *client = dev->client;
 	int ret, i;
-	u8 tmp;
+	unsigned int uitmp;
 
 	if (!dev->warm) {
 		ret = -EFAULT;
@@ -170,18 +62,18 @@ static int tda10071_cmd_execute(struct tda10071_dev *dev,
 	}
 
 	/* write cmd and args for firmware */
-	ret = tda10071_wr_regs(dev, 0x00, cmd->args, cmd->len);
+	ret = regmap_bulk_write(dev->regmap, 0x00, cmd->args, cmd->len);
 	if (ret)
 		goto error;
 
 	/* start cmd execution */
-	ret = tda10071_wr_reg(dev, 0x1f, 1);
+	ret = regmap_write(dev->regmap, 0x1f, 1);
 	if (ret)
 		goto error;
 
 	/* wait cmd execution terminate */
-	for (i = 1000, tmp = 1; i && tmp; i--) {
-		ret = tda10071_rd_reg(dev, 0x1f, &tmp);
+	for (i = 1000, uitmp = 1; i && uitmp; i--) {
+		ret = regmap_read(dev->regmap, 0x1f, &uitmp);
 		if (ret)
 			goto error;
 
@@ -299,7 +191,7 @@ static int tda10071_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret, i;
-	u8 tmp;
+	unsigned int uitmp;
 
 	if (!dev->warm) {
 		ret = -EFAULT;
@@ -314,11 +206,11 @@ static int tda10071_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	}
 
 	/* wait LNB TX */
-	for (i = 500, tmp = 0; i && !tmp; i--) {
-		ret = tda10071_rd_reg_mask(dev, 0x47, &tmp, 0x01);
+	for (i = 500, uitmp = 0; i && !uitmp; i--) {
+		ret = regmap_read(dev->regmap, 0x47, &uitmp);
 		if (ret)
 			goto error;
-
+		uitmp = (uitmp >> 0) & 1;
 		usleep_range(10000, 20000);
 	}
 
@@ -329,7 +221,7 @@ static int tda10071_diseqc_send_master_cmd(struct dvb_frontend *fe,
 		goto error;
 	}
 
-	ret = tda10071_wr_reg_mask(dev, 0x47, 0x00, 0x01);
+	ret = regmap_update_bits(dev->regmap, 0x47, 0x01, 0x00);
 	if (ret)
 		goto error;
 
@@ -359,7 +251,7 @@ static int tda10071_diseqc_recv_slave_reply(struct dvb_frontend *fe,
 	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret, i;
-	u8 tmp;
+	unsigned int uitmp;
 
 	if (!dev->warm) {
 		ret = -EFAULT;
@@ -369,11 +261,11 @@ static int tda10071_diseqc_recv_slave_reply(struct dvb_frontend *fe,
 	dev_dbg(&client->dev, "\n");
 
 	/* wait LNB RX */
-	for (i = 500, tmp = 0; i && !tmp; i--) {
-		ret = tda10071_rd_reg_mask(dev, 0x47, &tmp, 0x02);
+	for (i = 500, uitmp = 0; i && !uitmp; i--) {
+		ret = regmap_read(dev->regmap, 0x47, &uitmp);
 		if (ret)
 			goto error;
-
+		uitmp = (uitmp >> 1) & 1;
 		usleep_range(10000, 20000);
 	}
 
@@ -385,11 +277,11 @@ static int tda10071_diseqc_recv_slave_reply(struct dvb_frontend *fe,
 	}
 
 	/* reply len */
-	ret = tda10071_rd_reg(dev, 0x46, &tmp);
+	ret = regmap_read(dev->regmap, 0x46, &uitmp);
 	if (ret)
 		goto error;
 
-	reply->msg_len = tmp & 0x1f; /* [4:0] */
+	reply->msg_len = uitmp & 0x1f; /* [4:0] */
 	if (reply->msg_len > sizeof(reply->msg))
 		reply->msg_len = sizeof(reply->msg); /* truncate API max */
 
@@ -401,7 +293,8 @@ static int tda10071_diseqc_recv_slave_reply(struct dvb_frontend *fe,
 	if (ret)
 		goto error;
 
-	ret = tda10071_rd_regs(dev, cmd.len, reply->msg, reply->msg_len);
+	ret = regmap_bulk_read(dev->regmap, cmd.len, reply->msg,
+			       reply->msg_len);
 	if (ret)
 		goto error;
 
@@ -418,7 +311,8 @@ static int tda10071_diseqc_send_burst(struct dvb_frontend *fe,
 	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret, i;
-	u8 tmp, burst;
+	unsigned int uitmp;
+	u8 burst;
 
 	if (!dev->warm) {
 		ret = -EFAULT;
@@ -441,11 +335,11 @@ static int tda10071_diseqc_send_burst(struct dvb_frontend *fe,
 	}
 
 	/* wait LNB TX */
-	for (i = 500, tmp = 0; i && !tmp; i--) {
-		ret = tda10071_rd_reg_mask(dev, 0x47, &tmp, 0x01);
+	for (i = 500, uitmp = 0; i && !uitmp; i--) {
+		ret = regmap_read(dev->regmap, 0x47, &uitmp);
 		if (ret)
 			goto error;
-
+		uitmp = (uitmp >> 0) & 1;
 		usleep_range(10000, 20000);
 	}
 
@@ -456,7 +350,7 @@ static int tda10071_diseqc_send_burst(struct dvb_frontend *fe,
 		goto error;
 	}
 
-	ret = tda10071_wr_reg_mask(dev, 0x47, 0x00, 0x01);
+	ret = regmap_update_bits(dev->regmap, 0x47, 0x01, 0x00);
 	if (ret)
 		goto error;
 
@@ -479,7 +373,7 @@ static int tda10071_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	struct tda10071_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
-	u8 tmp;
+	unsigned int uitmp;
 
 	*status = 0;
 
@@ -488,16 +382,16 @@ static int tda10071_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		goto error;
 	}
 
-	ret = tda10071_rd_reg(dev, 0x39, &tmp);
+	ret = regmap_read(dev->regmap, 0x39, &uitmp);
 	if (ret)
 		goto error;
 
 	/* 0x39[0] tuner PLL */
-	if (tmp & 0x02) /* demod PLL */
+	if (uitmp & 0x02) /* demod PLL */
 		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
-	if (tmp & 0x04) /* viterbi or LDPC*/
+	if (uitmp & 0x04) /* viterbi or LDPC*/
 		*status |= FE_HAS_VITERBI;
-	if (tmp & 0x08) /* RS or BCH */
+	if (uitmp & 0x08) /* RS or BCH */
 		*status |= FE_HAS_SYNC | FE_HAS_LOCK;
 
 	dev->fe_status = *status;
@@ -521,7 +415,7 @@ static int tda10071_read_snr(struct dvb_frontend *fe, u16 *snr)
 		goto error;
 	}
 
-	ret = tda10071_rd_regs(dev, 0x3a, buf, 2);
+	ret = regmap_bulk_read(dev->regmap, 0x3a, buf, 2);
 	if (ret)
 		goto error;
 
@@ -540,7 +434,7 @@ static int tda10071_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret;
-	u8 tmp;
+	unsigned int uitmp;
 
 	if (!dev->warm || !(dev->fe_status & FE_HAS_LOCK)) {
 		*strength = 0;
@@ -556,17 +450,17 @@ static int tda10071_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 		goto error;
 
 	/* input power estimate dBm */
-	ret = tda10071_rd_reg(dev, 0x50, &tmp);
+	ret = regmap_read(dev->regmap, 0x50, &uitmp);
 	if (ret)
 		goto error;
 
-	if (tmp < 181)
-		tmp = 181; /* -75 dBm */
-	else if (tmp > 236)
-		tmp = 236; /* -20 dBm */
+	if (uitmp < 181)
+		uitmp = 181; /* -75 dBm */
+	else if (uitmp > 236)
+		uitmp = 236; /* -20 dBm */
 
 	/* scale value to 0x0000-0xffff */
-	*strength = (tmp-181) * 0xffff / (236-181);
+	*strength = (uitmp-181) * 0xffff / (236-181);
 
 	return ret;
 error:
@@ -580,7 +474,8 @@ static int tda10071_read_ber(struct dvb_frontend *fe, u32 *ber)
 	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret, i, len;
-	u8 tmp, reg, buf[8];
+	unsigned int uitmp;
+	u8 reg, buf[8];
 
 	if (!dev->warm || !(dev->fe_status & FE_HAS_LOCK)) {
 		*ber = dev->ber = 0;
@@ -604,16 +499,16 @@ static int tda10071_read_ber(struct dvb_frontend *fe, u32 *ber)
 		return 0;
 	}
 
-	ret = tda10071_rd_reg(dev, reg, &tmp);
+	ret = regmap_read(dev->regmap, reg, &uitmp);
 	if (ret)
 		goto error;
 
-	if (dev->meas_count[i] == tmp) {
-		dev_dbg(&client->dev, "meas not ready=%02x\n", tmp);
+	if (dev->meas_count[i] == uitmp) {
+		dev_dbg(&client->dev, "meas not ready=%02x\n", uitmp);
 		*ber = dev->ber;
 		return 0;
 	} else {
-		dev->meas_count[i] = tmp;
+		dev->meas_count[i] = uitmp;
 	}
 
 	cmd.args[0] = CMD_BER_UPDATE_COUNTERS;
@@ -624,7 +519,7 @@ static int tda10071_read_ber(struct dvb_frontend *fe, u32 *ber)
 	if (ret)
 		goto error;
 
-	ret = tda10071_rd_regs(dev, cmd.len, buf, len);
+	ret = regmap_bulk_read(dev->regmap, cmd.len, buf, len);
 	if (ret)
 		goto error;
 
@@ -772,11 +667,11 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 	else
 		div = 4;
 
-	ret = tda10071_wr_reg(dev, 0x81, div);
+	ret = regmap_write(dev->regmap, 0x81, div);
 	if (ret)
 		goto error;
 
-	ret = tda10071_wr_reg(dev, 0xe3, div);
+	ret = regmap_write(dev->regmap, 0xe3, div);
 	if (ret)
 		goto error;
 
@@ -821,7 +716,7 @@ static int tda10071_get_frontend(struct dvb_frontend *fe)
 		goto error;
 	}
 
-	ret = tda10071_rd_regs(dev, 0x30, buf, 5);
+	ret = regmap_bulk_read(dev->regmap, 0x30, buf, 5);
 	if (ret)
 		goto error;
 
@@ -854,7 +749,7 @@ static int tda10071_get_frontend(struct dvb_frontend *fe)
 
 	c->frequency = (buf[2] << 16) | (buf[3] << 8) | (buf[4] << 0);
 
-	ret = tda10071_rd_regs(dev, 0x52, buf, 3);
+	ret = regmap_bulk_read(dev->regmap, 0x52, buf, 3);
 	if (ret)
 		goto error;
 
@@ -872,6 +767,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 	struct i2c_client *client = dev->client;
 	struct tda10071_cmd cmd;
 	int ret, i, len, remaining, fw_size;
+	unsigned int uitmp;
 	const struct firmware *fw;
 	u8 *fw_file = TDA10071_FIRMWARE;
 	u8 tmp, buf[4];
@@ -971,19 +867,19 @@ static int tda10071_init(struct dvb_frontend *fe)
 		}
 
 		/*  download firmware */
-		ret = tda10071_wr_reg(dev, 0xe0, 0x7f);
+		ret = regmap_write(dev->regmap, 0xe0, 0x7f);
 		if (ret)
 			goto error_release_firmware;
 
-		ret = tda10071_wr_reg(dev, 0xf7, 0x81);
+		ret = regmap_write(dev->regmap, 0xf7, 0x81);
 		if (ret)
 			goto error_release_firmware;
 
-		ret = tda10071_wr_reg(dev, 0xf8, 0x00);
+		ret = regmap_write(dev->regmap, 0xf8, 0x00);
 		if (ret)
 			goto error_release_firmware;
 
-		ret = tda10071_wr_reg(dev, 0xf9, 0x00);
+		ret = regmap_write(dev->regmap, 0xf9, 0x00);
 		if (ret)
 			goto error_release_firmware;
 
@@ -1002,7 +898,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 			if (len > (dev->i2c_wr_max - 1))
 				len = (dev->i2c_wr_max - 1);
 
-			ret = tda10071_wr_regs(dev, 0xfa,
+			ret = regmap_bulk_write(dev->regmap, 0xfa,
 				(u8 *) &fw->data[fw_size - remaining], len);
 			if (ret) {
 				dev_err(&client->dev,
@@ -1012,11 +908,11 @@ static int tda10071_init(struct dvb_frontend *fe)
 		}
 		release_firmware(fw);
 
-		ret = tda10071_wr_reg(dev, 0xf7, 0x0c);
+		ret = regmap_write(dev->regmap, 0xf7, 0x0c);
 		if (ret)
 			goto error;
 
-		ret = tda10071_wr_reg(dev, 0xe0, 0x00);
+		ret = regmap_write(dev->regmap, 0xe0, 0x00);
 		if (ret)
 			goto error;
 
@@ -1024,11 +920,11 @@ static int tda10071_init(struct dvb_frontend *fe)
 		msleep(250);
 
 		/* firmware status */
-		ret = tda10071_rd_reg(dev, 0x51, &tmp);
+		ret = regmap_read(dev->regmap, 0x51, &uitmp);
 		if (ret)
 			goto error;
 
-		if (tmp) {
+		if (uitmp) {
 			dev_info(&client->dev, "firmware did not run\n");
 			ret = -EFAULT;
 			goto error;
@@ -1042,7 +938,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 		if (ret)
 			goto error;
 
-		ret = tda10071_rd_regs(dev, cmd.len, buf, 4);
+		ret = regmap_bulk_read(dev->regmap, cmd.len, buf, 4);
 		if (ret)
 			goto error;
 
@@ -1051,7 +947,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 		dev_info(&client->dev, "found a '%s' in warm state\n",
 			 tda10071_ops.info.name);
 
-		ret = tda10071_rd_regs(dev, 0x81, buf, 2);
+		ret = regmap_bulk_read(dev->regmap, 0x81, buf, 2);
 		if (ret)
 			goto error;
 
@@ -1104,7 +1000,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 		if (ret)
 			goto error;
 
-		ret = tda10071_wr_reg_mask(dev, 0xf0, 0x01, 0x01);
+		ret = regmap_update_bits(dev->regmap, 0xf0, 0x01, 0x01);
 		if (ret)
 			goto error;
 
@@ -1258,7 +1154,11 @@ static int tda10071_probe(struct i2c_client *client,
 	struct tda10071_dev *dev;
 	struct tda10071_platform_data *pdata = client->dev.platform_data;
 	int ret;
-	u8 u8tmp;
+	unsigned int uitmp;
+	static const struct regmap_config regmap_config = {
+		.reg_bits = 8,
+		.val_bits = 8,
+	};
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
@@ -1273,30 +1173,35 @@ static int tda10071_probe(struct i2c_client *client,
 	dev->spec_inv = pdata->spec_inv;
 	dev->pll_multiplier = pdata->pll_multiplier;
 	dev->tuner_i2c_addr = pdata->tuner_i2c_addr;
+	dev->regmap = devm_regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		goto err_kfree;
+	}
 
 	/* chip ID */
-	ret = tda10071_rd_reg(dev, 0xff, &u8tmp);
+	ret = regmap_read(dev->regmap, 0xff, &uitmp);
 	if (ret)
 		goto err_kfree;
-	if (u8tmp != 0x0f) {
+	if (uitmp != 0x0f) {
 		ret = -ENODEV;
 		goto err_kfree;
 	}
 
 	/* chip type */
-	ret = tda10071_rd_reg(dev, 0xdd, &u8tmp);
+	ret = regmap_read(dev->regmap, 0xdd, &uitmp);
 	if (ret)
 		goto err_kfree;
-	if (u8tmp != 0x00) {
+	if (uitmp != 0x00) {
 		ret = -ENODEV;
 		goto err_kfree;
 	}
 
 	/* chip version */
-	ret = tda10071_rd_reg(dev, 0xfe, &u8tmp);
+	ret = regmap_read(dev->regmap, 0xfe, &uitmp);
 	if (ret)
 		goto err_kfree;
-	if (u8tmp != 0x01) {
+	if (uitmp != 0x01) {
 		ret = -ENODEV;
 		goto err_kfree;
 	}
diff --git a/drivers/media/dvb-frontends/tda10071_priv.h b/drivers/media/dvb-frontends/tda10071_priv.h
index 9800028..30143c8 100644
--- a/drivers/media/dvb-frontends/tda10071_priv.h
+++ b/drivers/media/dvb-frontends/tda10071_priv.h
@@ -24,10 +24,12 @@
 #include "dvb_frontend.h"
 #include "tda10071.h"
 #include <linux/firmware.h>
+#include <linux/regmap.h>
 
 struct tda10071_dev {
 	struct dvb_frontend fe;
 	struct i2c_client *client;
+	struct regmap *regmap;
 	u32 clk;
 	u16 i2c_wr_max;
 	u8 ts_mode;
-- 
http://palosaari.fi/

