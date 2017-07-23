Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35697 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdGWKNW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 06:13:22 -0400
Received: by mail-wm0-f65.google.com with SMTP id m75so5412309wmb.2
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 03:13:22 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, r.scobie@clear.net.nz
Subject: [PATCH 3/7] [media] dvb-frontends/stv0910: further coding style cleanup
Date: Sun, 23 Jul 2017 12:13:11 +0200
Message-Id: <20170723101315.12523-4-d.scheller.oss@gmail.com>
In-Reply-To: <20170723101315.12523-1-d.scheller.oss@gmail.com>
References: <20170723101315.12523-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixes up all remainders reported by "checkpatch.pl --strict"

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 93 +++++++++++++++++------------------
 drivers/media/dvb-frontends/stv0910.h |  4 +-
 2 files changed, 48 insertions(+), 49 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index bbe609143497..8dc767a118a0 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -71,7 +71,7 @@ static inline u32 muldiv32(u32 a, u32 b, u32 c)
 	tmp64 = (u64)a * (u64)b;
 	do_div(tmp64, c);
 
-	return (u32) tmp64;
+	return (u32)tmp64;
 }
 
 struct stv_base {
@@ -79,8 +79,8 @@ struct stv_base {
 
 	u8                   adr;
 	struct i2c_adapter  *i2c;
-	struct mutex         i2c_lock;
-	struct mutex         reg_lock;
+	struct mutex         i2c_lock; /* shared I2C access protect */
+	struct mutex         reg_lock; /* shared register write protect */
 	int                  count;
 
 	u32                  extclk;
@@ -146,8 +146,8 @@ static inline int i2c_write(struct i2c_adapter *adap, u8 adr,
 
 	if (i2c_transfer(adap, &msg, 1) != 1) {
 		dev_warn(&adap->dev, "i2c write error ([%02x] %04x: %02x)\n",
-			adr, (data[0] << 8) | data[1],
-			(len > 2 ? data[2] : 0));
+			 adr, (data[0] << 8) | data[1],
+			 (len > 2 ? data[2] : 0));
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -166,7 +166,7 @@ static int write_reg(struct stv *state, u16 reg, u8 val)
 }
 
 static inline int i2c_read_regs16(struct i2c_adapter *adapter, u8 adr,
-				 u16 reg, u8 *val, int count)
+				  u16 reg, u8 *val, int count)
 {
 	u8 msg[2] = {reg >> 8, reg & 0xff};
 	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
@@ -176,7 +176,7 @@ static inline int i2c_read_regs16(struct i2c_adapter *adapter, u8 adr,
 
 	if (i2c_transfer(adapter, msgs, 2) != 2) {
 		dev_warn(&adapter->dev, "i2c read error ([%02x] %04x)\n",
-			adr, reg);
+			 adr, reg);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -185,7 +185,7 @@ static inline int i2c_read_regs16(struct i2c_adapter *adapter, u8 adr,
 static int read_reg(struct stv *state, u16 reg, u8 *val)
 {
 	return i2c_read_regs16(state->base->i2c, state->base->adr,
-		reg, val, 1);
+			       reg, val, 1);
 }
 
 static int read_regs(struct stv *state, u16 reg, u8 *val, int len)
@@ -473,16 +473,16 @@ static int get_cur_symbol_rate(struct stv *state, u32 *p_symbol_rate)
 	read_reg(state, RSTV0910_P2_TMGREG1 + state->regoff, &tim_offs1);
 	read_reg(state, RSTV0910_P2_TMGREG0 + state->regoff, &tim_offs0);
 
-	symbol_rate = ((u32) symb_freq3 << 24) | ((u32) symb_freq2 << 16) |
-		((u32) symb_freq1 << 8) | (u32) symb_freq0;
-	timing_offset = ((u32) tim_offs2 << 16) | ((u32) tim_offs1 << 8) |
-		(u32) tim_offs0;
+	symbol_rate = ((u32)symb_freq3 << 24) | ((u32)symb_freq2 << 16) |
+		((u32)symb_freq1 << 8) | (u32)symb_freq0;
+	timing_offset = ((u32)tim_offs2 << 16) | ((u32)tim_offs1 << 8) |
+		(u32)tim_offs0;
 
-	if ((timing_offset & (1<<23)) != 0)
+	if ((timing_offset & (1 << 23)) != 0)
 		timing_offset |= 0xFF000000; /* Sign extent */
 
-	symbol_rate = (u32) (((u64) symbol_rate * state->base->mclk) >> 32);
-	timing_offset = (s32) (((s64) symbol_rate * (s64) timing_offset) >> 29);
+	symbol_rate = (u32)(((u64)symbol_rate * state->base->mclk) >> 32);
+	timing_offset = (s32)(((s64)symbol_rate * (s64)timing_offset) >> 29);
 
 	*p_symbol_rate = symbol_rate + timing_offset;
 
@@ -498,9 +498,9 @@ static int get_signal_parameters(struct stv *state)
 
 	if (state->receive_mode == RCVMODE_DVBS2) {
 		read_reg(state, RSTV0910_P2_DMDMODCOD + state->regoff, &tmp);
-		state->mod_cod = (enum fe_stv0910_mod_cod) ((tmp & 0x7c) >> 2);
+		state->mod_cod = (enum fe_stv0910_mod_cod)((tmp & 0x7c) >> 2);
 		state->pilots = (tmp & 0x01) != 0;
-		state->fectype = (enum dvbs2_fectype) ((tmp & 0x02) >> 1);
+		state->fectype = (enum dvbs2_fectype)((tmp & 0x02) >> 1);
 
 	} else if (state->receive_mode == RCVMODE_DVBS) {
 		read_reg(state, RSTV0910_P2_VITCURPUN + state->regoff, &tmp);
@@ -586,7 +586,7 @@ static int tracking_optimization(struct stv *state)
 }
 
 static s32 table_lookup(struct slookup *table,
-		       int table_size, u32 reg_value)
+			int table_size, u32 reg_value)
 {
 	s32 value;
 	int imin = 0;
@@ -595,15 +595,15 @@ static s32 table_lookup(struct slookup *table,
 	s32 reg_diff;
 
 	/* Assumes Table[0].RegValue > Table[imax].RegValue */
-	if (reg_value >= table[0].reg_value)
+	if (reg_value >= table[0].reg_value) {
 		value = table[0].value;
-	else if (reg_value <= table[imax].reg_value)
+	} else if (reg_value <= table[imax].reg_value) {
 		value = table[imax].value;
-	else {
-		while (imax-imin > 1) {
+	} else {
+		while ((imax - imin) > 1) {
 			i = (imax + imin) / 2;
 			if ((table[imin].reg_value >= reg_value) &&
-				(reg_value >= table[i].reg_value))
+			    (reg_value >= table[i].reg_value))
 				imax = i;
 			else
 				imin = i;
@@ -649,13 +649,13 @@ static int get_signal_to_noise(struct stv *state, s32 *signal_to_noise)
 		n_lookup = ARRAY_SIZE(s1_sn_lookup);
 		lookup = s1_sn_lookup;
 	}
-	data = (((u16)data1) << 8) | (u16) data0;
+	data = (((u16)data1) << 8) | (u16)data0;
 	*signal_to_noise = table_lookup(lookup, n_lookup, data);
 	return 0;
 }
 
 static int get_bit_error_rate_s(struct stv *state, u32 *bernumerator,
-			    u32 *berdenominator)
+				u32 *berdenominator)
 {
 	u8 regs[3];
 
@@ -669,8 +669,8 @@ static int get_bit_error_rate_s(struct stv *state, u32 *bernumerator,
 	if ((regs[0] & 0x80) == 0) {
 		state->last_berdenominator = 1 << ((state->berscale * 2) +
 						  10 + 3);
-		state->last_bernumerator = ((u32) (regs[0] & 0x7F) << 16) |
-			((u32) regs[1] << 8) | regs[2];
+		state->last_bernumerator = ((u32)(regs[0] & 0x7F) << 16) |
+			((u32)regs[1] << 8) | regs[2];
 		if (state->last_bernumerator < 256 && state->berscale < 6) {
 			state->berscale += 1;
 			status = write_reg(state, RSTV0910_P2_ERRCTRL1 +
@@ -730,7 +730,7 @@ static u32 dvbs2_nbch(enum dvbs2_mod_cod mod_cod, enum dvbs2_fectype fectype)
 }
 
 static int get_bit_error_rate_s2(struct stv *state, u32 *bernumerator,
-			     u32 *berdenominator)
+				 u32 *berdenominator)
 {
 	u8 regs[3];
 
@@ -742,11 +742,11 @@ static int get_bit_error_rate_s2(struct stv *state, u32 *bernumerator,
 
 	if ((regs[0] & 0x80) == 0) {
 		state->last_berdenominator =
-			dvbs2_nbch((enum dvbs2_mod_cod) state->mod_cod,
+			dvbs2_nbch((enum dvbs2_mod_cod)state->mod_cod,
 				   state->fectype) <<
 			(state->berscale * 2);
-		state->last_bernumerator = (((u32) regs[0] & 0x7F) << 16) |
-			((u32) regs[1] << 8) | regs[2];
+		state->last_bernumerator = (((u32)regs[0] & 0x7F) << 16) |
+			((u32)regs[1] << 8) | regs[2];
 		if (state->last_bernumerator < 256 && state->berscale < 6) {
 			state->berscale += 1;
 			write_reg(state, RSTV0910_P2_ERRCTRL1 + state->regoff,
@@ -764,7 +764,7 @@ static int get_bit_error_rate_s2(struct stv *state, u32 *bernumerator,
 }
 
 static int get_bit_error_rate(struct stv *state, u32 *bernumerator,
-			   u32 *berdenominator)
+			      u32 *berdenominator)
 {
 	*bernumerator = 0;
 	*berdenominator = 1;
@@ -1211,7 +1211,6 @@ static int probe(struct stv *state)
 	return 0;
 }
 
-
 static int gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct stv *state = fe->demodulator_priv;
@@ -1273,9 +1272,9 @@ static int manage_matype_info(struct stv *state)
 		u8 bbheader[2];
 
 		read_regs(state, RSTV0910_P2_MATSTR1 + state->regoff,
-			bbheader, 2);
+			  bbheader, 2);
 		state->feroll_off =
-			(enum fe_stv0910_roll_off) (bbheader[0] & 0x03);
+			(enum fe_stv0910_roll_off)(bbheader[0] & 0x03);
 		state->is_vcm = (bbheader[0] & 0x10) == 0;
 		state->is_standard_broadcast = (bbheader[0] & 0xFC) == 0xF0;
 	} else if (state->receive_mode == RCVMODE_DVBS) {
@@ -1295,8 +1294,9 @@ static int read_snr(struct dvb_frontend *fe)
 	if (!get_signal_to_noise(state, &snrval)) {
 		p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 		p->cnr.stat[0].uvalue = 100 * snrval; /* fix scale */
-	} else
+	} else {
 		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
 
 	return 0;
 }
@@ -1328,12 +1328,12 @@ static void read_signal_strength(struct dvb_frontend *fe)
 
 	read_regs(state, RSTV0910_P2_AGCIQIN1 + state->regoff, reg, 2);
 
-	agc = (((u32) reg[0]) << 8) | reg[1];
+	agc = (((u32)reg[0]) << 8) | reg[1];
 
 	for (i = 0; i < 5; i += 1) {
 		read_regs(state, RSTV0910_P2_POWERI + state->regoff, reg, 2);
-		power += (u32) reg[0] * (u32) reg[0]
-			+ (u32) reg[1] * (u32) reg[1];
+		power += (u32)reg[0] * (u32)reg[0]
+			+ (u32)reg[1] * (u32)reg[1];
 		usleep_range(3000, 4000);
 	}
 	power /= 5;
@@ -1490,9 +1490,9 @@ static int read_status(struct dvb_frontend *fe, enum fe_status *status)
 		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
 	/* read ber */
-	if (*status & FE_HAS_VITERBI)
+	if (*status & FE_HAS_VITERBI) {
 		read_ber(fe);
-	else {
+	} else {
 		p->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		p->pre_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
@@ -1584,7 +1584,6 @@ static int tune(struct dvb_frontend *fe, bool re_tune,
 	return 0;
 }
 
-
 static int get_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_HW;
@@ -1697,7 +1696,7 @@ static struct dvb_frontend_ops stv0910_ops = {
 	.diseqc_send_burst              = send_burst,
 };
 
-static struct stv_base *match_base(struct i2c_adapter  *i2c, u8 adr)
+static struct stv_base *match_base(struct i2c_adapter *i2c, u8 adr)
 {
 	struct stv_base *p;
 
@@ -1728,7 +1727,7 @@ struct dvb_frontend *stv0910_attach(struct i2c_adapter *i2c,
 	struct stv *state;
 	struct stv_base *base;
 
-	state = kzalloc(sizeof(struct stv), GFP_KERNEL);
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state)
 		return NULL;
 
@@ -1749,7 +1748,7 @@ struct dvb_frontend *stv0910_attach(struct i2c_adapter *i2c,
 		base->count++;
 		state->base = base;
 	} else {
-		base = kzalloc(sizeof(struct stv_base), GFP_KERNEL);
+		base = kzalloc(sizeof(*base), GFP_KERNEL);
 		if (!base)
 			goto fail;
 		base->i2c = i2c;
@@ -1762,7 +1761,7 @@ struct dvb_frontend *stv0910_attach(struct i2c_adapter *i2c,
 		state->base = base;
 		if (probe(state) < 0) {
 			dev_info(&i2c->dev, "No demod found at adr %02X on %s\n",
-				cfg->adr, dev_name(&i2c->dev));
+				 cfg->adr, dev_name(&i2c->dev));
 			kfree(base);
 			goto fail;
 		}
@@ -1773,7 +1772,7 @@ struct dvb_frontend *stv0910_attach(struct i2c_adapter *i2c,
 	state->nr = nr;
 
 	dev_info(&i2c->dev, "%s demod found at adr %02X on %s\n",
-		state->fe.ops.info.name, cfg->adr, dev_name(&i2c->dev));
+		 state->fe.ops.info.name, cfg->adr, dev_name(&i2c->dev));
 
 	stv0910_init_stats(state);
 
diff --git a/drivers/media/dvb-frontends/stv0910.h b/drivers/media/dvb-frontends/stv0910.h
index e1ab6df7c805..fccd8d9b665f 100644
--- a/drivers/media/dvb-frontends/stv0910.h
+++ b/drivers/media/dvb-frontends/stv0910.h
@@ -14,8 +14,8 @@ struct stv0910_cfg {
 
 #if IS_REACHABLE(CONFIG_DVB_STV0910)
 
-extern struct dvb_frontend *stv0910_attach(struct i2c_adapter *i2c,
-					   struct stv0910_cfg *cfg, int nr);
+struct dvb_frontend *stv0910_attach(struct i2c_adapter *i2c,
+				    struct stv0910_cfg *cfg, int nr);
 
 #else
 
-- 
2.13.0
