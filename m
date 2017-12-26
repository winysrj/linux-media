Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:46062 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbdLZXiH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 18:38:07 -0500
Received: by mail-wm0-f68.google.com with SMTP id 9so36943799wme.4
        for <linux-media@vger.kernel.org>; Tue, 26 Dec 2017 15:38:07 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH 4/4] [media] dvb-frontends/stv0910: cleanup init_search_param() and enable PLS
Date: Wed, 27 Dec 2017 00:37:59 +0100
Message-Id: <20171226233759.16116-5-d.scheller.oss@gmail.com>
In-Reply-To: <20171226233759.16116-1-d.scheller.oss@gmail.com>
References: <20171226233759.16116-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Cleanup the mess in init_search_param() by utilising the new register
access macros and functions. And while at it, move the ISI and PLS setup
into separate functions, and pass the new scrambling_sequence_index (aka.
physical layer scrambling) value to set_pls.

Picked up from the dddvb upstream, adapted to the different naming of the
pls property (pls vs. scrambling_sequence_index).

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 113 ++++++++++++++++------------------
 1 file changed, 52 insertions(+), 61 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 5fed22685e28..b0c14ff74b67 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -194,7 +194,7 @@ static int write_shared_reg(struct stv *state, u16 reg, u8 mask, u8 val)
 	return status;
 }
 
-static int __maybe_unused write_field(struct stv *state, u32 field, u8 val)
+static int write_field(struct stv *state, u32 field, u8 val)
 {
 	int status;
 	u8 shift, mask, old, new;
@@ -880,45 +880,60 @@ static int stop(struct stv *state)
 	return 0;
 }
 
-static int init_search_param(struct stv *state)
+static void set_pls(struct stv *state, u32 pls_code)
 {
-	u8 tmp;
-
-	read_reg(state, RSTV0910_P2_PDELCTRL1 + state->regoff, &tmp);
-	tmp |= 0x20; /* Filter_en (no effect if SIS=non-MIS */
-	write_reg(state, RSTV0910_P2_PDELCTRL1 + state->regoff, tmp);
-
-	read_reg(state, RSTV0910_P2_PDELCTRL2 + state->regoff, &tmp);
-	tmp &= ~0x02; /* frame mode = 0 */
-	write_reg(state, RSTV0910_P2_PDELCTRL2 + state->regoff, tmp);
-
-	write_reg(state, RSTV0910_P2_UPLCCST0 + state->regoff, 0xe0);
-	write_reg(state, RSTV0910_P2_ISIBITENA + state->regoff, 0x00);
-
-	read_reg(state, RSTV0910_P2_TSSTATEM + state->regoff, &tmp);
-	tmp &= ~0x01; /* nosync = 0, in case next signal is standard TS */
-	write_reg(state, RSTV0910_P2_TSSTATEM + state->regoff, tmp);
-
-	read_reg(state, RSTV0910_P2_TSCFGL + state->regoff, &tmp);
-	tmp &= ~0x04; /* embindvb = 0 */
-	write_reg(state, RSTV0910_P2_TSCFGL + state->regoff, tmp);
-
-	read_reg(state, RSTV0910_P2_TSINSDELH + state->regoff, &tmp);
-	tmp &= ~0x80; /* syncbyte = 0 */
-	write_reg(state, RSTV0910_P2_TSINSDELH + state->regoff, tmp);
-
-	read_reg(state, RSTV0910_P2_TSINSDELM + state->regoff, &tmp);
-	tmp &= ~0x08; /* token = 0 */
-	write_reg(state, RSTV0910_P2_TSINSDELM + state->regoff, tmp);
+	if (pls_code == state->cur_scrambling_code)
+		return;
+
+	/* PLROOT2 bit 2 = gold code */
+	write_reg(state, RSTV0910_P2_PLROOT0 + state->regoff,
+		  pls_code & 0xff);
+	write_reg(state, RSTV0910_P2_PLROOT1 + state->regoff,
+		  (pls_code >> 8) & 0xff);
+	write_reg(state, RSTV0910_P2_PLROOT2 + state->regoff,
+		  0x04 | ((pls_code >> 16) & 0x03));
+	state->cur_scrambling_code = pls_code;
+}
 
-	read_reg(state, RSTV0910_P2_TSDLYSET2 + state->regoff, &tmp);
-	tmp &= ~0x30; /* hysteresis threshold = 0 */
-	write_reg(state, RSTV0910_P2_TSDLYSET2 + state->regoff, tmp);
+static void set_isi(struct stv *state, u32 isi)
+{
+	if (isi == NO_STREAM_ID_FILTER)
+		return;
+	if (isi == 0x80000000) {
+		SET_FIELD(FORCE_CONTINUOUS, 1);
+		SET_FIELD(TSOUT_NOSYNC, 1);
+	} else {
+		SET_FIELD(FILTER_EN, 1);
+		write_reg(state, RSTV0910_P2_ISIENTRY + state->regoff,
+			  isi & 0xff);
+		write_reg(state, RSTV0910_P2_ISIBITENA + state->regoff, 0xff);
+	}
+	SET_FIELD(ALGOSWRST, 1);
+	SET_FIELD(ALGOSWRST, 0);
+}
 
-	read_reg(state, RSTV0910_P2_PDELCTRL0 + state->regoff, &tmp);
-	tmp = (tmp & ~0x30) | 0x10; /* isi obs mode = 1, observe min ISI */
-	write_reg(state, RSTV0910_P2_PDELCTRL0 + state->regoff, tmp);
+static void set_stream_modes(struct stv *state,
+			     struct dtv_frontend_properties *p)
+{
+	set_isi(state, p->stream_id);
+	set_pls(state, p->scrambling_sequence_index);
+}
 
+static int init_search_param(struct stv *state,
+			     struct dtv_frontend_properties *p)
+{
+	SET_FIELD(FORCE_CONTINUOUS, 0);
+	SET_FIELD(FRAME_MODE, 0);
+	SET_FIELD(FILTER_EN, 0);
+	SET_FIELD(TSOUT_NOSYNC, 0);
+	SET_FIELD(TSFIFO_EMBINDVB, 0);
+	SET_FIELD(TSDEL_SYNCBYTE, 0);
+	SET_REG(UPLCCST0, 0xe0);
+	SET_FIELD(TSINS_TOKEN, 0);
+	SET_FIELD(HYSTERESIS_THRESHOLD, 0);
+	SET_FIELD(ISIOBS_MODE, 1);
+
+	set_stream_modes(state, p);
 	return 0;
 }
 
@@ -1005,7 +1020,6 @@ static int start(struct stv *state, struct dtv_frontend_properties *p)
 	s32 freq;
 	u8  reg_dmdcfgmd;
 	u16 symb;
-	u32 scrambling_code = 1;
 
 	if (p->symbol_rate < 100000 || p->symbol_rate > 70000000)
 		return -EINVAL;
@@ -1017,30 +1031,7 @@ static int start(struct stv *state, struct dtv_frontend_properties *p)
 	if (state->started)
 		write_reg(state, RSTV0910_P2_DMDISTATE + state->regoff, 0x5C);
 
-	init_search_param(state);
-
-	if (p->stream_id != NO_STREAM_ID_FILTER) {
-		/*
-		 * Backwards compatibility to "crazy" API.
-		 * PRBS X root cannot be 0, so this should always work.
-		 */
-		if (p->stream_id & 0xffffff00)
-			scrambling_code = p->stream_id >> 8;
-		write_reg(state, RSTV0910_P2_ISIENTRY + state->regoff,
-			  p->stream_id & 0xff);
-		write_reg(state, RSTV0910_P2_ISIBITENA + state->regoff,
-			  0xff);
-	}
-
-	if (scrambling_code != state->cur_scrambling_code) {
-		write_reg(state, RSTV0910_P2_PLROOT0 + state->regoff,
-			  scrambling_code & 0xff);
-		write_reg(state, RSTV0910_P2_PLROOT1 + state->regoff,
-			  (scrambling_code >> 8) & 0xff);
-		write_reg(state, RSTV0910_P2_PLROOT2 + state->regoff,
-			  (scrambling_code >> 16) & 0x0f);
-		state->cur_scrambling_code = scrambling_code;
-	}
+	init_search_param(state, p);
 
 	if (p->symbol_rate <= 1000000) { /* SR <=1Msps */
 		state->demod_timeout = 3000;
-- 
2.13.6
