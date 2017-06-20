Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36596 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdFTRpQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 13:45:16 -0400
Received: by mail-wr0-f196.google.com with SMTP id 77so19156124wrb.3
        for <linux-media@vger.kernel.org>; Tue, 20 Jun 2017 10:45:15 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de
Subject: [PATCH 4/4] [media] dvb-frontends/stv0367: DVB-C signal strength statistics
Date: Tue, 20 Jun 2017 19:45:06 +0200
Message-Id: <20170620174506.7593-5-d.scheller.oss@gmail.com>
In-Reply-To: <20170620174506.7593-1-d.scheller.oss@gmail.com>
References: <20170620174506.7593-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Provide QAM/DVB-C signal strength in decibel scale. Values returned from
stv0367cab_get_rf_lvl() are good but need to be multiplied as they're in
1dBm precision.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 0b13a407df23..cf684ba70a3f 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -3018,6 +3018,25 @@ static int stv0367ddb_read_status(struct dvb_frontend *fe,
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
@@ -3102,6 +3121,7 @@ static int stv0367ddb_get_frontend(struct dvb_frontend *fe,
 
 	stv0367ddb_read_ucblocks(fe);
 	stv0367ddb_read_snr(fe);
+	stv0367ddb_read_signal_strength(fe);
 
 	return 0;
 }
-- 
2.13.0
