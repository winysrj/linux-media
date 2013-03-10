Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33617 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab3CJCEk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:40 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 16/41] it913x: rename functions and variables
Date: Sun, 10 Mar 2013 04:03:08 +0200
Message-Id: <1362881013-5271-16-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c | 72 +++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 34 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 6eb3afa..82cc053 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -22,7 +22,7 @@
 
 #include "it913x_priv.h"
 
-struct it913x_fe_state {
+struct it913x_state {
 	struct dvb_frontend frontend;
 	struct i2c_adapter *i2c_adap;
 	struct ite_config *config;
@@ -43,7 +43,8 @@ struct it913x_fe_state {
 	u32 ucblocks;
 };
 
-static int it913x_read_reg(struct it913x_fe_state *state,
+/* read multiple registers */
+static int it913x_rd_regs(struct it913x_state *state,
 		u32 reg, u8 *data, u8 count)
 {
 	int ret;
@@ -64,15 +65,17 @@ static int it913x_read_reg(struct it913x_fe_state *state,
 	return ret;
 }
 
-static int it913x_read_reg_u8(struct it913x_fe_state *state, u32 reg)
+/* read single register */
+static int it913x_rd_reg(struct it913x_state *state, u32 reg)
 {
 	int ret;
 	u8 b[1];
-	ret = it913x_read_reg(state, reg, &b[0], sizeof(b));
+	ret = it913x_rd_regs(state, reg, &b[0], sizeof(b));
 	return (ret < 0) ? -ENODEV : b[0];
 }
 
-static int it913x_write(struct it913x_fe_state *state,
+/* write multiple registers */
+static int it913x_wr_regs(struct it913x_state *state,
 		u8 pro, u32 reg, u8 buf[], u8 count)
 {
 	u8 b[256];
@@ -97,7 +100,8 @@ static int it913x_write(struct it913x_fe_state *state,
 	return 0;
 }
 
-static int it913x_write_reg(struct it913x_fe_state *state,
+/* write single register */
+static int it913x_wr_reg(struct it913x_state *state,
 		u8 pro, u32 reg, u32 data)
 {
 	int ret;
@@ -118,12 +122,12 @@ static int it913x_write_reg(struct it913x_fe_state *state,
 	else
 		s = 0;
 
-	ret = it913x_write(state, pro, reg, &b[s], sizeof(b) - s);
+	ret = it913x_wr_regs(state, pro, reg, &b[s], sizeof(b) - s);
 
 	return ret;
 }
 
-static int it913x_fe_script_loader(struct it913x_fe_state *state,
+static int it913x_script_loader(struct it913x_state *state,
 		struct it913xset *loadscript)
 {
 	int ret, i;
@@ -133,7 +137,7 @@ static int it913x_fe_script_loader(struct it913x_fe_state *state,
 	for (i = 0; i < 1000; ++i) {
 		if (loadscript[i].pro == 0xff)
 			break;
-		ret = it913x_write(state, loadscript[i].pro,
+		ret = it913x_wr_regs(state, loadscript[i].pro,
 			loadscript[i].address,
 			loadscript[i].reg, loadscript[i].count);
 		if (ret < 0)
@@ -142,9 +146,9 @@ static int it913x_fe_script_loader(struct it913x_fe_state *state,
 	return 0;
 }
 
-static int it913x_init_tuner(struct dvb_frontend *fe)
+static int it913x_init(struct dvb_frontend *fe)
 {
-	struct it913x_fe_state *state = fe->tuner_priv;
+	struct it913x_state *state = fe->tuner_priv;
 	int ret, i, reg;
 	struct it913xset *set_lna;
 	u8 val, nv_val;
@@ -153,9 +157,9 @@ static int it913x_init_tuner(struct dvb_frontend *fe)
 
 	/* v1 or v2 tuner script */
 	if (state->config->chip_ver > 1)
-		ret = it913x_fe_script_loader(state, it9135_v2);
+		ret = it913x_script_loader(state, it9135_v2);
 	else
-		ret = it913x_fe_script_loader(state, it9135_v1);
+		ret = it913x_script_loader(state, it9135_v1);
 	if (ret < 0)
 		return ret;
 
@@ -182,19 +186,19 @@ static int it913x_init_tuner(struct dvb_frontend *fe)
 	}
 	pr_info("Tuner LNA type :%02x\n", state->tuner_type);
 
-	ret = it913x_fe_script_loader(state, set_lna);
+	ret = it913x_script_loader(state, set_lna);
 	if (ret < 0)
 		return ret;
 
 	if (state->config->chip_ver == 2) {
-		ret = it913x_write_reg(state, PRO_DMOD, TRIGGER_OFSM, 0x1);
-		ret |= it913x_write_reg(state, PRO_LINK, PADODPU, 0x0);
-		ret |= it913x_write_reg(state, PRO_LINK, AGC_O_D, 0x0);
+		ret = it913x_wr_reg(state, PRO_DMOD, TRIGGER_OFSM, 0x1);
+		ret |= it913x_wr_reg(state, PRO_LINK, PADODPU, 0x0);
+		ret |= it913x_wr_reg(state, PRO_LINK, AGC_O_D, 0x0);
 	}
 	if (ret < 0)
 		return -ENODEV;
 
-	reg = it913x_read_reg_u8(state, 0xec86);
+	reg = it913x_rd_reg(state, 0xec86);
 	switch (reg) {
 	case 0:
 		state->tun_clk_mode = reg;
@@ -213,7 +217,7 @@ static int it913x_init_tuner(struct dvb_frontend *fe)
 		break;
 	}
 
-	reg = it913x_read_reg_u8(state, 0xed03);
+	reg = it913x_rd_reg(state, 0xed03);
 
 	if (reg < 0)
 		return -ENODEV;
@@ -223,7 +227,7 @@ static int it913x_init_tuner(struct dvb_frontend *fe)
 		nv_val = 2;
 
 	for (i = 0; i < 50; i++) {
-		ret = it913x_read_reg(state, 0xed23, &b[0], sizeof(b));
+		ret = it913x_rd_regs(state, 0xed23, &b[0], sizeof(b));
 		reg = (b[1] << 8) + b[0];
 		if (reg > 0)
 			break;
@@ -239,7 +243,7 @@ static int it913x_init_tuner(struct dvb_frontend *fe)
 		msleep(50);
 	else {
 		for (i = 0; i < 50; i++) {
-			reg = it913x_read_reg_u8(state, 0xec82);
+			reg = it913x_rd_reg(state, 0xec82);
 			if (reg > 0)
 				break;
 			if (reg < 0)
@@ -248,12 +252,12 @@ static int it913x_init_tuner(struct dvb_frontend *fe)
 		}
 	}
 
-	return it913x_write_reg(state, PRO_DMOD, 0xed81, val);
+	return it913x_wr_reg(state, PRO_DMOD, 0xed81, val);
 }
 
-static int it9137_set_tuner(struct dvb_frontend *fe)
+static int it9137_set_params(struct dvb_frontend *fe)
 {
-	struct it913x_fe_state *state = fe->tuner_priv;
+	struct it913x_state *state = fe->tuner_priv;
 	struct it913xset *set_tuner = set_it9137_template;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	u32 bandwidth = p->bandwidth_hz;
@@ -358,7 +362,7 @@ static int it9137_set_tuner(struct dvb_frontend *fe)
 	} else
 		return -EINVAL;
 
-	reg = it913x_read_reg_u8(state, 0xed81);
+	reg = it913x_rd_reg(state, 0xed81);
 	iqik_m_cal = (u16)reg * n_div;
 
 	if (reg < 0x20) {
@@ -396,7 +400,7 @@ static int it9137_set_tuner(struct dvb_frontend *fe)
 
 	pr_debug("low Frequency = %04x\n", freq);
 
-	ret = it913x_fe_script_loader(state, set_tuner);
+	ret = it913x_script_loader(state, set_tuner);
 
 	return (ret < 0) ? -ENODEV : 0;
 }
@@ -405,10 +409,10 @@ static int it9137_set_tuner(struct dvb_frontend *fe)
 /* Power Up	Tuner on -> Frontend suspend off -> Tuner clk on */
 /* Power Down	Frontend suspend on -> Tuner clk off -> Tuner off */
 
-static int it913x_fe_sleep(struct dvb_frontend *fe)
+static int it913x_sleep(struct dvb_frontend *fe)
 {
-	struct it913x_fe_state *state = fe->tuner_priv;
-	return it913x_fe_script_loader(state, it9137_tuner_off);
+	struct it913x_state *state = fe->tuner_priv;
+	return it913x_script_loader(state, it9137_tuner_off);
 }
 
 static int it913x_release(struct dvb_frontend *fe)
@@ -426,19 +430,19 @@ static const struct dvb_tuner_ops it913x_tuner_ops = {
 
 	.release = it913x_release,
 
-	.init = it913x_init_tuner,
-	.sleep = it913x_fe_sleep,
-	.set_params = it9137_set_tuner,
+	.init = it913x_init,
+	.sleep = it913x_sleep,
+	.set_params = it9137_set_params,
 };
 
 struct dvb_frontend *it913x_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c_adap, u8 i2c_addr, struct ite_config *config)
 {
-	struct it913x_fe_state *state = NULL;
+	struct it913x_state *state = NULL;
 	int ret;
 
 	/* allocate memory for the internal state */
-	state = kzalloc(sizeof(struct it913x_fe_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct it913x_state), GFP_KERNEL);
 	if (state == NULL)
 		return NULL;
 	if (config == NULL)
-- 
1.7.11.7

