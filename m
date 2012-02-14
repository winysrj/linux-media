Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:28212 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab2BNVsY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:24 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 07/22] mt2063: read_reg, write_reg
Date: Tue, 14 Feb 2012 22:47:31 +0100
Message-Id: <1329256066-8844-7-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |  118 ++++++++++-----------------------
 1 files changed, 36 insertions(+), 82 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 31cb636..f659d4c 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -161,32 +161,22 @@ struct mt2063_state {
 	u32 num_regs;
 	u8 reg[MT2063_REG_END_REGS];
 };
-
-/*
- * mt2063_write - Write data into the I2C bus
- */
-static u32 mt2063_write(struct mt2063_state *state, u8 reg, u8 *data, u32 len)
+static int mt2063_write(struct mt2063_state *state, u8 reg, u8 data)
 {
-	struct dvb_frontend *fe = state->frontend;
 	int ret;
-	u8 buf[60];
+	u8 buf[2] = { reg, data };
+
 	struct i2c_msg msg = {
-		.addr = state->config->tuner_address,
+		.addr = state->i2c_addr,
 		.flags = 0,
 		.buf = buf,
-		.len = len + 1
+		.len = 2,
 	};
 
-	dprintk(2, "\n");
-
-	msg.buf[0] = reg;
-	memcpy(msg.buf + 1, data, len);
+	dprintk(3, "writeing at address 0x%02x, subadresse 0x%02x, \
+		value 0x%02x\n", state->i2c_addr, reg, data);
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
 	ret = i2c_transfer(state->i2c, &msg, 1);
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
 
 	if (ret < 0)
 		printk(KERN_ERR "%s error ret=%d\n", __func__, ret);
@@ -194,83 +184,48 @@ static u32 mt2063_write(struct mt2063_state *state, u8 reg, u8 *data, u32 len)
 	return ret;
 }
 
-/*
- * mt2063_write - Write register data into the I2C bus, caching the value
- */
-static u32 mt2063_setreg(struct mt2063_state *state, u8 reg, u8 val)
+static int mt2063_read(struct mt2063_state *state, u8 reg, u8 *data)
 {
-	u32 status;
+	int ret = 0;
 
-	dprintk(2, "\n");
+	struct i2c_msg msg[] = { {
+		.addr = state->i2c_addr,
+		.flags = 0,
+		.buf = &reg,
+		.len = 1,
+	}, {
+		.addr = state->i2c_addr,
+		.flags = I2C_M_RD,
+		.buf = data,
+		.len = 1,
+	} };
 
-	if (reg >= MT2063_REG_END_REGS)
-		return -ERANGE;
+	dprintk(3, "\n");
 
-	status = mt2063_write(state, reg, &val, 1);
-	if (status < 0)
-		return status;
+	ret = i2c_transfer(state->i2c, msg, 2);
+
+	if (ret < 0)
+		printk(KERN_ERR "Can't read from address 0x%02x,\n", reg);
 
-	state->reg[reg] = val;
+	dprintk(3, "readed at address 0x%02x, subadress 0x%02x, \
+		value 0x%02x\n", state->i2c_addr, reg, data[0]);
 
-	return 0;
+	return ret;
 }
 
-/*
- * mt2063_read - Read data from the I2C bus
- */
-static u32 mt2063_read(struct mt2063_state *state,
-			   u8 subAddress, u8 *pData, u32 cnt)
+static int mt2063_set_reg_mask(struct mt2063_state *state, u8 reg,
+				u8 val, u8 mask)
 {
-	u32 status = 0;	/* Status to be returned        */
-	struct dvb_frontend *fe = state->frontend;
-	u32 i = 0;
-
-	dprintk(2, "addr 0x%02x, cnt %d\n", subAddress, cnt);
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
-	for (i = 0; i < cnt; i++) {
-		u8 b0[] = { subAddress + i };
-		struct i2c_msg msg[] = {
-			{
-				.addr = state->config->tuner_address,
-				.flags = 0,
-				.buf = b0,
-				.len = 1
-			}, {
-				.addr = state->config->tuner_address,
-				.flags = I2C_M_RD,
-				.buf = pData + i,
-				.len = 1
-			}
-		};
+	u8 old_val, new_val;
 
-		status = i2c_transfer(state->i2c, msg, 2);
-		dprintk(2, "addr 0x%02x, ret = %d, val = 0x%02x\n",
-			   subAddress + i, status, *(pData + i));
-		if (status < 0)
-			break;
-	}
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
+	dprintk(3, "\n");
 
-	if (status < 0)
-		printk(KERN_ERR "Can't read from address 0x%02x,\n",
-		       subAddress + i);
+	mt2063_read(state, reg, &old_val);
 
-	return status;
-}
+	new_val = (old_val & ~mask) | (val & mask);
 
-/*
- * FIXME: Is this really needed?
- */
-static int MT2063_Sleep(struct dvb_frontend *fe)
-{
-	/*
-	 *  ToDo:  Add code here to implement a OS blocking
-	 */
-	msleep(100);
+	if (new_val != old_val)
+		mt2063_write(state, reg, new_val);
 
 	return 0;
 }
@@ -1303,7 +1258,6 @@ static struct dvb_tuner_ops mt2063_ops = {
 		 },
 
 	.init = mt2063_init,
-	.sleep = MT2063_Sleep,
 	.get_status = mt2063_get_status,
 	.set_analog_params = mt2063_set_analog_params,
 	.set_params    = mt2063_set_params,
-- 
1.7.7.6

