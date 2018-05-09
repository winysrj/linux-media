Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:51543 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964892AbeEIUIK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 16:08:10 -0400
Received: by mail-wm0-f67.google.com with SMTP id j4-v6so507408wme.1
        for <linux-media@vger.kernel.org>; Wed, 09 May 2018 13:08:09 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, mchehab+samsung@kernel.org
Subject: [PATCH 3/4] [media] dvb-frontends/stv0910: make TS speed configurable
Date: Wed,  9 May 2018 22:08:02 +0200
Message-Id: <20180509200803.5253-4-d.scheller.oss@gmail.com>
In-Reply-To: <20180509200803.5253-1-d.scheller.oss@gmail.com>
References: <20180509200803.5253-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add a tsspeed config option to struct stv0910_cfg which can be used by
users of the driver to set the (parallel) TS speed (higher speeds enable
support for higher bitrate transponders). If tsspeed isn't set in the
config, it'll default to a sane value.

This commit also updates the two consumers of the stv0910 driver (ngene
and ddbridge) to have a default tsspeed in their stv0910_cfg templates.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <rascobie@slingshot.co.nz>
Tested-by: Helmut Auer <post@helmutauer.de>
---
 drivers/media/dvb-frontends/stv0910.c      | 5 ++---
 drivers/media/dvb-frontends/stv0910.h      | 1 +
 drivers/media/pci/ddbridge/ddbridge-core.c | 1 +
 drivers/media/pci/ngene/ngene-cards.c      | 1 +
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 7e9b016b3b28..41444fa1c0bb 100644
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
@@ -1790,7 +1788,8 @@ struct dvb_frontend *stv0910_attach(struct i2c_adapter *i2c,
 	state->tscfgh = 0x20 | (cfg->parallel ? 0 : 0x40);
 	state->tsgeneral = (cfg->parallel == 2) ? 0x02 : 0x00;
 	state->i2crpt = 0x0A | ((cfg->rptlvl & 0x07) << 4);
-	state->tsspeed = 0x28;
+	/* use safe tsspeed value if unspecified through stv0910_cfg */
+	state->tsspeed = (cfg->tsspeed ? cfg->tsspeed : 0x28);
 	state->nr = nr;
 	state->regoff = state->nr ? 0 : 0x200;
 	state->search_range = 16000000;
diff --git a/drivers/media/dvb-frontends/stv0910.h b/drivers/media/dvb-frontends/stv0910.h
index fccd8d9b665f..f37171b7a2de 100644
--- a/drivers/media/dvb-frontends/stv0910.h
+++ b/drivers/media/dvb-frontends/stv0910.h
@@ -10,6 +10,7 @@ struct stv0910_cfg {
 	u8  parallel;
 	u8  rptlvl;
 	u8  single;
+	u8  tsspeed;
 };
 
 #if IS_REACHABLE(CONFIG_DVB_STV0910)
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 377269c64449..6c2341642017 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1183,6 +1183,7 @@ static const struct stv0910_cfg stv0910_p = {
 	.parallel = 1,
 	.rptlvl   = 4,
 	.clk      = 30000000,
+	.tsspeed  = 0x28,
 };
 
 static const struct lnbh25_config lnbh25_cfg = {
diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 7738565193d6..7a106bc11a2b 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -327,6 +327,7 @@ static struct stv0910_cfg stv0910_p = {
 	.parallel = 1,
 	.rptlvl   = 4,
 	.clk      = 30000000,
+	.tsspeed  = 0x28,
 };
 
 static struct lnbh25_config lnbh25_cfg = {
-- 
2.16.1
