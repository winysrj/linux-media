Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34498 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdFYL0w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 07:26:52 -0400
Received: by mail-wr0-f194.google.com with SMTP id k67so23865372wrc.1
        for <linux-media@vger.kernel.org>; Sun, 25 Jun 2017 04:26:52 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v3 3/4] [media] dvb-frontends/stv0367: DVB-C signal strength statistics
Date: Sun, 25 Jun 2017 13:26:45 +0200
Message-Id: <20170625112646.7973-4-d.scheller.oss@gmail.com>
In-Reply-To: <20170625112646.7973-1-d.scheller.oss@gmail.com>
References: <20170625112646.7973-1-d.scheller.oss@gmail.com>
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
index 138f859d0f25..6097752a93bc 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -3011,6 +3011,25 @@ static int stv0367ddb_set_frontend(struct dvb_frontend *fe)
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
@@ -3086,6 +3105,8 @@ static int stv0367ddb_read_status(struct dvb_frontend *fe,
 	if (ret)
 		return ret;
 
+	stv0367ddb_read_signal_strength(fe);
+
 	/* read carrier/noise when a carrier is detected */
 	if (*status & FE_HAS_CARRIER)
 		stv0367ddb_read_snr(fe);
-- 
2.13.0
