Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:44350 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752147AbdKZNAQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Nov 2017 08:00:16 -0500
Received: by mail-wm0-f66.google.com with SMTP id r68so29480938wmr.3
        for <linux-media@vger.kernel.org>; Sun, 26 Nov 2017 05:00:16 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, rascobie@slingshot.co.nz, jasmin@anw.at
Subject: [PATCH 3/7] [media] dvb-frontends/stv6111: handle gate_ctrl errors
Date: Sun, 26 Nov 2017 14:00:05 +0100
Message-Id: <20171126130009.6798-4-d.scheller.oss@gmail.com>
In-Reply-To: <20171126130009.6798-1-d.scheller.oss@gmail.com>
References: <20171126130009.6798-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

When a parent (demod) driver encounters and signals a problem with
gate_ctrl(), don't blindly continue poking the I2C bus.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <rascobie@slingshot.co.nz>
---
 drivers/media/dvb-frontends/stv6111.c | 44 +++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv6111.c b/drivers/media/dvb-frontends/stv6111.c
index e3e90070e293..789f7b61e628 100644
--- a/drivers/media/dvb-frontends/stv6111.c
+++ b/drivers/media/dvb-frontends/stv6111.c
@@ -424,6 +424,7 @@ static int set_bandwidth(struct dvb_frontend *fe, u32 cutoff_frequency)
 {
 	struct stv *state = fe->tuner_priv;
 	u32 index = (cutoff_frequency + 999999) / 1000000;
+	int stat = 0;
 
 	if (index < 6)
 		index = 6;
@@ -435,12 +436,14 @@ static int set_bandwidth(struct dvb_frontend *fe, u32 cutoff_frequency)
 	state->reg[0x08] = (state->reg[0x08] & ~0xFC) | ((index - 6) << 2);
 	state->reg[0x09] = (state->reg[0x09] & ~0x0C) | 0x08;
 	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-	write_regs(state, 0x08, 2);
-	wait_for_call_done(state, 0x08);
-	if (fe->ops.i2c_gate_ctrl)
+		stat = fe->ops.i2c_gate_ctrl(fe, 1);
+	if (!stat) {
+		write_regs(state, 0x08, 2);
+		wait_for_call_done(state, 0x08);
+	}
+	if (fe->ops.i2c_gate_ctrl && !stat)
 		fe->ops.i2c_gate_ctrl(fe, 0);
-	return 0;
+	return stat;
 }
 
 static int set_lof(struct stv *state, u32 local_frequency, u32 cutoff_frequency)
@@ -518,6 +521,7 @@ static int set_params(struct dvb_frontend *fe)
 	struct stv *state = fe->tuner_priv;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	u32 freq, cutoff;
+	int stat = 0;
 
 	if (p->delivery_system != SYS_DVBS && p->delivery_system != SYS_DVBS2)
 		return -EINVAL;
@@ -526,9 +530,10 @@ static int set_params(struct dvb_frontend *fe)
 	cutoff = 5000000 + muldiv32(p->symbol_rate, 135, 200);
 
 	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-	set_lof(state, freq, cutoff);
-	if (fe->ops.i2c_gate_ctrl)
+		stat = fe->ops.i2c_gate_ctrl(fe, 1);
+	if (!stat)
+		set_lof(state, freq, cutoff);
+	if (fe->ops.i2c_gate_ctrl && !stat)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 	return 0;
 }
@@ -575,14 +580,17 @@ static int get_rf_strength(struct dvb_frontend *fe, u16 *st)
 	if ((state->reg[0x03] & 0x60) == 0) {
 		/* RF Mode, Read AGC ADC */
 		u8 reg = 0;
+		int stat = 0;
 
 		if (fe->ops.i2c_gate_ctrl)
-			fe->ops.i2c_gate_ctrl(fe, 1);
-		write_reg(state, 0x02, state->reg[0x02] | 0x20);
-		read_reg(state, 2, &reg);
-		if (reg & 0x20)
+			stat = fe->ops.i2c_gate_ctrl(fe, 1);
+		if (!stat) {
+			write_reg(state, 0x02, state->reg[0x02] | 0x20);
 			read_reg(state, 2, &reg);
-		if (fe->ops.i2c_gate_ctrl)
+			if (reg & 0x20)
+				read_reg(state, 2, &reg);
+		}
+		if (fe->ops.i2c_gate_ctrl && !stat)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 
 		if ((state->reg[0x02] & 0x80) == 0)
@@ -652,7 +660,8 @@ struct dvb_frontend *stv6111_attach(struct dvb_frontend *fe,
 				    struct i2c_adapter *i2c, u8 adr)
 {
 	struct stv *state;
-	int stat;
+	int stat = -ENODEV;
+	int gatestat = 0;
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state)
@@ -663,9 +672,10 @@ struct dvb_frontend *stv6111_attach(struct dvb_frontend *fe,
 	init_state(state);
 
 	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-	stat = attach_init(state);
-	if (fe->ops.i2c_gate_ctrl)
+		gatestat = fe->ops.i2c_gate_ctrl(fe, 1);
+	if (!gatestat)
+		stat = attach_init(state);
+	if (fe->ops.i2c_gate_ctrl && !gatestat)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 	if (stat < 0) {
 		kfree(state);
-- 
2.13.6
