Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35705 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbdGWKNZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 06:13:25 -0400
Received: by mail-wm0-f67.google.com with SMTP id m75so5412375wmb.2
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 03:13:24 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, r.scobie@clear.net.nz
Subject: [PATCH 5/7] [media] dvb-frontends/stv6111: coding style cleanup
Date: Sun, 23 Jul 2017 12:13:13 +0200
Message-Id: <20170723101315.12523-6-d.scheller.oss@gmail.com>
In-Reply-To: <20170723101315.12523-1-d.scheller.oss@gmail.com>
References: <20170723101315.12523-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fix up all remainders reported by checkpatch-strict.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv6111.c | 38 ++++++++++++++++++++---------------
 drivers/media/dvb-frontends/stv6111.h |  7 ++++---
 2 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv6111.c b/drivers/media/dvb-frontends/stv6111.c
index ce5b5ff936d5..91e24ba44c30 100644
--- a/drivers/media/dvb-frontends/stv6111.c
+++ b/drivers/media/dvb-frontends/stv6111.c
@@ -298,7 +298,7 @@ static inline u32 muldiv32(u32 a, u32 b, u32 c)
 	tmp64 = (u64)a * (u64)b;
 	do_div(tmp64, c);
 
-	return (u32) tmp64;
+	return (u32)tmp64;
 }
 
 static int i2c_read(struct i2c_adapter *adap,
@@ -429,10 +429,10 @@ static int set_bandwidth(struct dvb_frontend *fe, u32 cutoff_frequency)
 		index = 6;
 	if (index > 50)
 		index = 50;
-	if ((state->reg[0x08] & ~0xFC) == ((index-6) << 2))
+	if ((state->reg[0x08] & ~0xFC) == ((index - 6) << 2))
 		return 0;
 
-	state->reg[0x08] = (state->reg[0x08] & ~0xFC) | ((index-6) << 2);
+	state->reg[0x08] = (state->reg[0x08] & ~0xFC) | ((index - 6) << 2);
 	state->reg[0x09] = (state->reg[0x09] & ~0x0C) | 0x08;
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
@@ -542,12 +542,12 @@ static s32 table_lookup(struct slookup *table, int table_size, u16 reg_value)
 	int i;
 
 	/* Assumes Table[0].RegValue < Table[imax].RegValue */
-	if (reg_value <= table[0].reg_value)
+	if (reg_value <= table[0].reg_value) {
 		gain = table[0].value;
-	else if (reg_value >= table[imax].reg_value)
+	} else if (reg_value >= table[imax].reg_value) {
 		gain = table[imax].value;
-	else {
-		while (imax-imin > 1) {
+	} else {
+		while ((imax - imin) > 1) {
 			i = (imax + imin) / 2;
 			if ((table[imin].reg_value <= reg_value) &&
 			    (reg_value <= table[i].reg_value))
@@ -558,9 +558,9 @@ static s32 table_lookup(struct slookup *table, int table_size, u16 reg_value)
 		reg_diff = table[imax].reg_value - table[imin].reg_value;
 		gain = table[imin].value;
 		if (reg_diff != 0)
-			gain += ((s32) (reg_value - table[imin].reg_value) *
+			gain += ((s32)(reg_value - table[imin].reg_value) *
 				(s32)(table[imax].value
-				- table[imin].value))/(reg_diff);
+				- table[imin].value)) / reg_diff;
 	}
 	return gain;
 }
@@ -587,27 +587,33 @@ static int get_rf_strength(struct dvb_frontend *fe, u16 *st)
 		if ((state->reg[0x02] & 0x80) == 0)
 			/* NF */
 			gain = table_lookup(lnagain_nf_lookup,
-				ARRAY_SIZE(lnagain_nf_lookup), reg & 0x1F);
+					    ARRAY_SIZE(lnagain_nf_lookup),
+					    reg & 0x1F);
 		else
 			/* IIP3 */
 			gain = table_lookup(lnagain_iip3_lookup,
-				ARRAY_SIZE(lnagain_iip3_lookup), reg & 0x1F);
+					    ARRAY_SIZE(lnagain_iip3_lookup),
+					    reg & 0x1F);
 
 		gain += table_lookup(gain_rfagc_lookup,
-				ARRAY_SIZE(gain_rfagc_lookup), rfagc);
+				     ARRAY_SIZE(gain_rfagc_lookup), rfagc);
+
 		gain -= 2400;
 	} else {
 		/* Channel Mode */
 		if ((state->reg[0x02] & 0x80) == 0) {
 			/* NF */
-			gain = table_lookup(gain_channel_agc_nf_lookup,
+			gain = table_lookup(
+				gain_channel_agc_nf_lookup,
 				ARRAY_SIZE(gain_channel_agc_nf_lookup), rfagc);
+
 			gain += 600;
 		} else {
 			/* IIP3 */
-			gain = table_lookup(gain_channel_agc_iip3_lookup,
+			gain = table_lookup(
+				gain_channel_agc_iip3_lookup,
 				ARRAY_SIZE(gain_channel_agc_iip3_lookup),
-					rfagc);
+				rfagc);
 		}
 	}
 
@@ -647,7 +653,7 @@ struct dvb_frontend *stv6111_attach(struct dvb_frontend *fe,
 	struct stv *state;
 	int stat;
 
-	state = kzalloc(sizeof(struct stv), GFP_KERNEL);
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state)
 		return NULL;
 	state->adr = adr;
diff --git a/drivers/media/dvb-frontends/stv6111.h b/drivers/media/dvb-frontends/stv6111.h
index 066dd70c9426..5bc1228dc9bd 100644
--- a/drivers/media/dvb-frontends/stv6111.h
+++ b/drivers/media/dvb-frontends/stv6111.h
@@ -3,13 +3,14 @@
 
 #if IS_REACHABLE(CONFIG_DVB_STV6111)
 
-extern struct dvb_frontend *stv6111_attach(struct dvb_frontend *fe,
-				struct i2c_adapter *i2c, u8 adr);
+struct dvb_frontend *stv6111_attach(struct dvb_frontend *fe,
+				    struct i2c_adapter *i2c, u8 adr);
 
 #else
 
 static inline struct dvb_frontend *stv6111_attach(struct dvb_frontend *fe,
-				struct i2c_adapter *i2c, u8 adr)
+						  struct i2c_adapter *i2c,
+						  u8 adr)
 {
 	pr_warn("%s: Driver disabled by Kconfig\n", __func__);
 	return NULL;
-- 
2.13.0
