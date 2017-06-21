Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33640 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdFUTpv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 15:45:51 -0400
Received: by mail-wr0-f195.google.com with SMTP id x23so29319972wrb.0
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 12:45:50 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v2 4/4] [media] dvb-frontends/stv0367: DVB-C signal strength statistics
Date: Wed, 21 Jun 2017 21:45:44 +0200
Message-Id: <20170621194544.16949-5-d.scheller.oss@gmail.com>
In-Reply-To: <20170621194544.16949-1-d.scheller.oss@gmail.com>
References: <20170621194544.16949-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Provide QAM/DVB-C signal strength in decibel scale. Values returned from
stv0367cab_get_rf_lvl() are good but need to be multiplied as they're in
1dBm precision.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index d3be25bc1002..bac6707957a3 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -2998,6 +2998,25 @@ static int stv0367ddb_set_frontend(struct dvb_frontend *fe)
 	return -EINVAL;
 }
 
+static void stv0367ddb_read_signal_strength(struct dvb_frontend *fe)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	s32 signalstrength;
+
+	switch (state->activedemod) {
+	case demod_cab:
+		signalstrength = stv0367cab_get_rf_lvl(state) * 1000;
+		break;
+	default:
+		p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return;
+	}
+
+	p->strength.stat[0].scale = FE_SCALE_DECIBEL;
+	p->strength.stat[0].uvalue = signalstrength;
+}
+
 static void stv0367ddb_read_snr(struct dvb_frontend *fe)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
@@ -3075,12 +3094,14 @@ static int stv0367ddb_read_status(struct dvb_frontend *fe,
 
 	/* stop if demod isn't locked */
 	if (!(*status & FE_HAS_LOCK)) {
+		p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		return ret;
 	}
 
 	stv0367ddb_read_snr(fe);
+	stv0367ddb_read_signal_strength(fe);
 	stv0367ddb_read_ucblocks(fe);
 
 	return 0;
-- 
2.13.0
