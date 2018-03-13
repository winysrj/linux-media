Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:39447 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752100AbeCMWSM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 18:18:12 -0400
Received: by mail-wr0-f195.google.com with SMTP id k3so2476301wrg.6
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 15:18:11 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rascobie@slingshot.co.nz
Subject: [PATCH v3 3/3] [media] dvb-frontends/stv0910: more detailed reporting in get_frontend()
Date: Tue, 13 Mar 2018 23:18:05 +0100
Message-Id: <20180313221805.26818-4-d.scheller.oss@gmail.com>
In-Reply-To: <20180313221805.26818-1-d.scheller.oss@gmail.com>
References: <20180313221805.26818-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The first two missing FECs in the modcod2fec fe_code_rate table were 1/4
and 1/3. Add them as they're now defined by the API. Also, report the
currently used S2 rolloff factor in get_frontend(). For cosmetic reasons,
also change all feroll_off occurences to fe_rolloff. In addition,
Richard Scobie <rascobie@slingshot.co.nz> suggested to report the
currently active delivery system aswell, so add this while at it.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
v2 to v3:
- Squashed all stv0910 get_frontend() reporting into a single commit

Please take note of some additional things in the cover letter.

 drivers/media/dvb-frontends/stv0910.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 52355c14fd64..e12bc87de87b 100644
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
@@ -1562,7 +1562,7 @@ static int get_frontend(struct dvb_frontend *fe,
 			APSK_32,
 		};
 		const enum fe_code_rate modcod2fec[0x20] = {
-			FEC_NONE, FEC_NONE, FEC_NONE, FEC_2_5,
+			FEC_NONE, FEC_1_4, FEC_1_3, FEC_2_5,
 			FEC_1_2, FEC_3_5, FEC_2_3, FEC_3_4,
 			FEC_4_5, FEC_5_6, FEC_8_9, FEC_9_10,
 			FEC_3_5, FEC_2_3, FEC_3_4, FEC_5_6,
@@ -1571,11 +1571,16 @@ static int get_frontend(struct dvb_frontend *fe,
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
+		p->delivery_system = SYS_DVBS2;
 	} else if (state->receive_mode == RCVMODE_DVBS) {
 		read_reg(state, RSTV0910_P2_VITCURPUN + state->regoff, &tmp);
 		switch (tmp & 0x1F) {
@@ -1599,6 +1604,7 @@ static int get_frontend(struct dvb_frontend *fe,
 			break;
 		}
 		p->rolloff = ROLLOFF_35;
+		p->delivery_system = SYS_DVBS;
 	}
 
 	if (state->receive_mode != RCVMODE_NONE) {
-- 
2.16.1
