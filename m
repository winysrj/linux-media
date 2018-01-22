Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:41220 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751087AbeAVRNz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 12:13:55 -0500
Received: by mail-wm0-f68.google.com with SMTP id f71so17717426wmf.0
        for <linux-media@vger.kernel.org>; Mon, 22 Jan 2018 09:13:55 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rascobie@slingshot.co.nz
Subject: [PATCH v2 4/5] media: dvb-frontends/stv0910: report S2 rolloff in get_frontend()
Date: Mon, 22 Jan 2018 18:13:45 +0100
Message-Id: <20180122171346.822-5-d.scheller.oss@gmail.com>
In-Reply-To: <20180122171346.822-1-d.scheller.oss@gmail.com>
References: <20180122171346.822-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Report the currently used  S2 rolloff factor in get_frontend(). For
cosmetic reasons, also change all feroll_off occurences to fe_rolloff.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index de132a85e537..7ab014cec56c 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -113,7 +113,7 @@ struct stv {
 	enum fe_stv0910_mod_cod  mod_cod;
 	enum dvbs2_fectype       fectype;
 	u32                      pilots;
-	enum fe_stv0910_roll_off feroll_off;
+	enum fe_stv0910_roll_off fe_rolloff;
 
 	int   is_standard_broadcast;
 	int   is_vcm;
@@ -541,7 +541,7 @@ static int get_signal_parameters(struct stv *state)
 		}
 		state->is_vcm = 0;
 		state->is_standard_broadcast = 1;
-		state->feroll_off = FE_SAT_35;
+		state->fe_rolloff = FE_SAT_35;
 	}
 	return 0;
 }
@@ -1300,14 +1300,14 @@ static int manage_matype_info(struct stv *state)
 
 		read_regs(state, RSTV0910_P2_MATSTR1 + state->regoff,
 			  bbheader, 2);
-		state->feroll_off =
+		state->fe_rolloff =
 			(enum fe_stv0910_roll_off)(bbheader[0] & 0x03);
 		state->is_vcm = (bbheader[0] & 0x10) == 0;
 		state->is_standard_broadcast = (bbheader[0] & 0xFC) == 0xF0;
 	} else if (state->receive_mode == RCVMODE_DVBS) {
 		state->is_vcm = 0;
 		state->is_standard_broadcast = 1;
-		state->feroll_off = FE_SAT_35;
+		state->fe_rolloff = FE_SAT_35;
 	}
 	return 0;
 }
@@ -1571,11 +1571,15 @@ static int get_frontend(struct dvb_frontend *fe,
 			FEC_3_4, FEC_4_5, FEC_5_6, FEC_8_9,
 			FEC_9_10
 		};
+		const enum fe_rolloff ro2ro[4] = {
+			ROLLOFF_35, ROLLOFF_25, ROLLOFF_20, ROLLOFF_15,
+		};
 		read_reg(state, RSTV0910_P2_DMDMODCOD + state->regoff, &tmp);
 		mc = ((tmp & 0x7c) >> 2);
 		p->pilot = (tmp & 0x01) ? PILOT_ON : PILOT_OFF;
 		p->modulation = modcod2mod[mc];
 		p->fec_inner = modcod2fec[mc];
+		p->rolloff = ro2ro[state->fe_rolloff];
 	} else if (state->receive_mode == RCVMODE_DVBS) {
 		read_reg(state, RSTV0910_P2_VITCURPUN + state->regoff, &tmp);
 		switch (tmp & 0x1F) {
-- 
2.13.6
