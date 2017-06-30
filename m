Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33636 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752993AbdF3Uva (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 16:51:30 -0400
Received: by mail-wm0-f68.google.com with SMTP id j85so9870699wmj.0
        for <linux-media@vger.kernel.org>; Fri, 30 Jun 2017 13:51:24 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH v2 03/10] [media] dvb-frontends/stv0910: add multistream (ISI) and PLS capabilities
Date: Fri, 30 Jun 2017 22:50:59 +0200
Message-Id: <20170630205106.1268-4-d.scheller.oss@gmail.com>
In-Reply-To: <20170630205106.1268-1-d.scheller.oss@gmail.com>
References: <20170630205106.1268-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Implements stream_id filter and scrambling code setup in start() and also
sets FE_CAN_MULTISTREAM in frontend_ops. This enables the driver to
properly receive and handle multistream transponders, functionality has
been reported working fine by testers with access to such streams, in
conjunction with VDR on the userspace side.

The code snippet originates from the original vendor's dddvb driver
package and has been made working properly with the current in-kernel
DVB core API.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 5a5d190298ea..b9d6a61e6017 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -120,9 +120,7 @@ struct stv {
 	int   is_vcm;
 
 	u32   cur_scrambling_code;
-	u32   force_scrambling_code;
 	u32   scrambling_code;
-	u32   default_input_stream_id;
 
 	u32   last_bernumerator;
 	u32   last_berdenominator;
@@ -970,6 +968,7 @@ static int start(struct stv *state, struct dtv_frontend_properties *p)
 	s32 freq;
 	u8  reg_dmdcfgmd;
 	u16 symb;
+	u32 scrambling_code = 1;
 
 	if (p->symbol_rate < 100000 || p->symbol_rate > 70000000)
 		return -EINVAL;
@@ -983,6 +982,28 @@ static int start(struct stv *state, struct dtv_frontend_properties *p)
 
 	init_search_param(state);
 
+	if (p->stream_id != NO_STREAM_ID_FILTER) {
+		/* Backwards compatibility to "crazy" API.
+		 * PRBS X root cannot be 0, so this should always work.
+		 */
+		if (p->stream_id & 0xffffff00)
+			scrambling_code = p->stream_id >> 8;
+		write_reg(state, RSTV0910_P2_ISIENTRY + state->regoff,
+			  p->stream_id & 0xff);
+		write_reg(state, RSTV0910_P2_ISIBITENA + state->regoff,
+			  0xff);
+	}
+
+	if (scrambling_code != state->cur_scrambling_code) {
+		write_reg(state, RSTV0910_P2_PLROOT0 + state->regoff,
+			  scrambling_code & 0xff);
+		write_reg(state, RSTV0910_P2_PLROOT1 + state->regoff,
+			  (scrambling_code >> 8) & 0xff);
+		write_reg(state, RSTV0910_P2_PLROOT2 + state->regoff,
+			  (scrambling_code >> 16) & 0x07);
+		state->cur_scrambling_code = scrambling_code;
+	}
+
 	if (p->symbol_rate <= 1000000) {  /* SR <=1Msps */
 		state->demod_timeout = 3000;
 		state->fec_timeout = 2000;
@@ -1600,7 +1621,8 @@ static struct dvb_frontend_ops stv0910_ops = {
 		.caps			= FE_CAN_INVERSION_AUTO |
 					  FE_CAN_FEC_AUTO       |
 					  FE_CAN_QPSK           |
-					  FE_CAN_2G_MODULATION
+					  FE_CAN_2G_MODULATION  |
+					  FE_CAN_MULTISTREAM
 	},
 	.sleep				= sleep,
 	.release                        = release,
@@ -1658,9 +1680,7 @@ struct dvb_frontend *stv0910_attach(struct i2c_adapter *i2c,
 	state->search_range = 16000000;
 	state->demod_bits = 0x10;     /* Inversion : Auto with reset to 0 */
 	state->receive_mode   = RCVMODE_NONE;
-	state->cur_scrambling_code = (u32) -1;
-	state->force_scrambling_code = (u32) -1;
-	state->default_input_stream_id = (u32) -1;
+	state->cur_scrambling_code = (~0U);
 	state->single = cfg->single ? 1 : 0;
 
 	base = match_base(i2c, cfg->adr);
-- 
2.13.0
