Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33378 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdFTRpM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 13:45:12 -0400
Received: by mail-wr0-f194.google.com with SMTP id x23so19170843wrb.0
        for <linux-media@vger.kernel.org>; Tue, 20 Jun 2017 10:45:11 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de
Subject: [PATCH 1/4] [media] dvb-frontends/stv0367: initial DDB DVBv5 stats, implement ucblocks
Date: Tue, 20 Jun 2017 19:45:03 +0200
Message-Id: <20170620174506.7593-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170620174506.7593-1-d.scheller.oss@gmail.com>
References: <20170620174506.7593-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This adds the basics to stv0367ddb_get_frontend() to be able to properly
provide signal statistics in DVBv5 format. Also adds UCB readout and
provides those values.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 59 ++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index e726c2e00460..5374d4eaabd6 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -2997,21 +2997,64 @@ static int stv0367ddb_read_status(struct dvb_frontend *fe,
 	return -EINVAL;
 }
 
+static void stv0367ddb_read_ucblocks(struct dvb_frontend *fe)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	u32 ucblocks = 0;
+
+	switch (state->activedemod) {
+	case demod_ter:
+		stv0367ter_read_ucblocks(fe, &ucblocks);
+		break;
+	case demod_cab:
+		stv0367cab_read_ucblcks(fe, &ucblocks);
+		break;
+	default:
+		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return;
+	}
+
+	p->block_error.stat[0].scale = FE_SCALE_COUNTER;
+	p->block_error.stat[0].uvalue = ucblocks;
+}
+
 static int stv0367ddb_get_frontend(struct dvb_frontend *fe,
 				   struct dtv_frontend_properties *p)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
+	int ret = -EINVAL;
+	enum fe_status status = 0;
 
 	switch (state->activedemod) {
 	case demod_ter:
-		return stv0367ter_get_frontend(fe, p);
+		ret = stv0367ter_get_frontend(fe, p);
+		break;
 	case demod_cab:
-		return stv0367cab_get_frontend(fe, p);
-	default:
+		ret = stv0367cab_get_frontend(fe, p);
 		break;
+	default:
+		p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return ret;
 	}
 
-	return -EINVAL;
+	/* read fe lock status */
+	if (!ret)
+		ret = stv0367ddb_read_status(fe, &status);
+
+	/* stop if get_frontend failed or if demod isn't locked */
+	if (ret || !(status & FE_HAS_LOCK)) {
+		p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return ret;
+	}
+
+	stv0367ddb_read_ucblocks(fe);
+
+	return 0;
 }
 
 static int stv0367ddb_sleep(struct dvb_frontend *fe)
@@ -3035,6 +3078,7 @@ static int stv0367ddb_sleep(struct dvb_frontend *fe)
 static int stv0367ddb_init(struct stv0367_state *state)
 {
 	struct stv0367ter_state *ter_state = state->ter_state;
+	struct dtv_frontend_properties *p = &state->fe.dtv_property_cache;
 
 	stv0367_writereg(state, R367TER_TOPCTRL, 0x10);
 
@@ -3109,6 +3153,13 @@ static int stv0367ddb_init(struct stv0367_state *state)
 	ter_state->first_lock = 0;
 	ter_state->unlock_counter = 2;
 
+	p->strength.len = 1;
+	p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->cnr.len = 1;
+	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->block_error.len = 1;
+	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	return 0;
 }
 
-- 
2.13.0
