Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34016 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751417AbdFXQDJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 12:03:09 -0400
Received: by mail-wr0-f193.google.com with SMTP id k67so19936584wrc.1
        for <linux-media@vger.kernel.org>; Sat, 24 Jun 2017 09:03:08 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH 3/9] [media] dvb-frontends/stv0910: add multistream (ISI) and PLS capabilities
Date: Sat, 24 Jun 2017 18:02:55 +0200
Message-Id: <20170624160301.17710-4-d.scheller.oss@gmail.com>
In-Reply-To: <20170624160301.17710-1-d.scheller.oss@gmail.com>
References: <20170624160301.17710-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Implements stream_id filter and scrambling code setup in Start() and also
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
index a5eac1a3a048..999ee6a8ea23 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -124,9 +124,7 @@ struct stv {
 	int   isVCM;
 
 	u32   CurScramblingCode;
-	u32   ForceScramblingCode;
 	u32   ScramblingCode;
-	u32   DefaultInputStreamID;
 
 	u32   LastBERNumerator;
 	u32   LastBERDenominator;
@@ -972,6 +970,7 @@ static int Start(struct stv *state, struct dtv_frontend_properties *p)
 	s32 Freq;
 	u8  regDMDCFGMD;
 	u16 symb;
+	u32 ScramblingCode = 1;
 
 	if (p->symbol_rate < 100000 || p->symbol_rate > 70000000)
 		return -EINVAL;
@@ -985,6 +984,28 @@ static int Start(struct stv *state, struct dtv_frontend_properties *p)
 
 	init_search_param(state);
 
+	if (p->stream_id != NO_STREAM_ID_FILTER) {
+		/* Backwards compatibility to "crazy" API.
+		 * PRBS X root cannot be 0, so this should always work.
+		 */
+		if (p->stream_id & 0xffffff00)
+			ScramblingCode = p->stream_id >> 8;
+		write_reg(state, RSTV0910_P2_ISIENTRY + state->regoff,
+			  p->stream_id & 0xff);
+		write_reg(state, RSTV0910_P2_ISIBITENA + state->regoff,
+			  0xff);
+	}
+
+	if (ScramblingCode != state->CurScramblingCode) {
+		write_reg(state, RSTV0910_P2_PLROOT0 + state->regoff,
+			  ScramblingCode & 0xff);
+		write_reg(state, RSTV0910_P2_PLROOT1 + state->regoff,
+			  (ScramblingCode >> 8) & 0xff);
+		write_reg(state, RSTV0910_P2_PLROOT2 + state->regoff,
+			  (ScramblingCode >> 16) & 0x07);
+		state->CurScramblingCode = ScramblingCode;
+	}
+
 	if (p->symbol_rate <= 1000000) {  /* SR <=1Msps */
 		state->DemodTimeout = 3000;
 		state->FecTimeout = 2000;
@@ -1643,7 +1664,8 @@ static struct dvb_frontend_ops stv0910_ops = {
 		.caps			= FE_CAN_INVERSION_AUTO |
 					  FE_CAN_FEC_AUTO       |
 					  FE_CAN_QPSK           |
-					  FE_CAN_2G_MODULATION
+					  FE_CAN_2G_MODULATION  |
+					  FE_CAN_MULTISTREAM
 	},
 	.sleep				= sleep,
 	.release                        = release,
@@ -1687,9 +1709,7 @@ struct dvb_frontend *stv0910_attach(struct i2c_adapter *i2c,
 	state->SearchRange = 16000000;
 	state->DEMOD = 0x10;     /* Inversion : Auto with reset to 0 */
 	state->ReceiveMode   = Mode_None;
-	state->CurScramblingCode = (u32) -1;
-	state->ForceScramblingCode = (u32) -1;
-	state->DefaultInputStreamID = (u32) -1;
+	state->CurScramblingCode = (~0U);
 	state->single = cfg->single ? 1 : 0;
 
 	base = match_base(i2c, cfg->adr);
-- 
2.13.0
