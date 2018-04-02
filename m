Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:41219 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753104AbeDBSYd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 14:24:33 -0400
Received: by mail-wr0-f195.google.com with SMTP id s12so4413202wrc.8
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2018 11:24:33 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 02/20] [media] dvb-frontends/stv0910: increase parallel TS output speed
Date: Mon,  2 Apr 2018 20:24:09 +0200
Message-Id: <20180402182427.20918-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180402182427.20918-1-d.scheller.oss@gmail.com>
References: <20180402182427.20918-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

When running in parallel TS mode (cfg->parallel=1), increase the output
speed in the demod.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index f5b5ce971c0c..0d6130f97c36 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1200,7 +1200,6 @@ static int probe(struct stv *state)
 	write_reg(state, RSTV0910_P1_TSCFGM, 0xC0); /* Manual speed */
 	write_reg(state, RSTV0910_P1_TSCFGL, 0x20);
 
-	/* Speed = 67.5 MHz */
 	write_reg(state, RSTV0910_P1_TSSPEED, state->tsspeed);
 
 	write_reg(state, RSTV0910_P2_TSCFGH, state->tscfgh | 0x01);
@@ -1208,7 +1207,6 @@ static int probe(struct stv *state)
 	write_reg(state, RSTV0910_P2_TSCFGM, 0xC0); /* Manual speed */
 	write_reg(state, RSTV0910_P2_TSCFGL, 0x20);
 
-	/* Speed = 67.5 MHz */
 	write_reg(state, RSTV0910_P2_TSSPEED, state->tsspeed);
 
 	/* Reset stream merger */
@@ -1790,7 +1788,7 @@ struct dvb_frontend *stv0910_attach(struct i2c_adapter *i2c,
 	state->tscfgh = 0x20 | (cfg->parallel ? 0 : 0x40);
 	state->tsgeneral = (cfg->parallel == 2) ? 0x02 : 0x00;
 	state->i2crpt = 0x0A | ((cfg->rptlvl & 0x07) << 4);
-	state->tsspeed = 0x28;
+	state->tsspeed = cfg->parallel ? 0x10 : 0x28;
 	state->nr = nr;
 	state->regoff = state->nr ? 0 : 0x200;
 	state->search_range = 16000000;
-- 
2.16.1
