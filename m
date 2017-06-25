Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34490 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdFYL0v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 07:26:51 -0400
Received: by mail-wr0-f195.google.com with SMTP id k67so23865324wrc.1
        for <linux-media@vger.kernel.org>; Sun, 25 Jun 2017 04:26:51 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v3 2/4] [media] dvb-frontends/stv0367: SNR DVBv5 statistics for DVB-C and T
Date: Sun, 25 Jun 2017 13:26:44 +0200
Message-Id: <20170625112646.7973-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170625112646.7973-1-d.scheller.oss@gmail.com>
References: <20170625112646.7973-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add signal-to-noise-ratio as provided by the demodulator in decibel scale.
QAM/DVB-C needs some intlog calculation to have usable dB values, OFDM/
DVB-T values from the demod look alright already and are provided as-is.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 39 +++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 9e5432b761b5..138f859d0f25 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -25,6 +25,8 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 
+#include "dvb_math.h"
+
 #include "stv0367.h"
 #include "stv0367_defs.h"
 #include "stv0367_regs.h"
@@ -3009,6 +3011,37 @@ static int stv0367ddb_set_frontend(struct dvb_frontend *fe)
 	return -EINVAL;
 }
 
+static void stv0367ddb_read_snr(struct dvb_frontend *fe)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	int cab_pwr;
+	u32 regval, tmpval, snrval = 0;
+
+	switch (state->activedemod) {
+	case demod_ter:
+		snrval = stv0367ter_snr_readreg(fe);
+		break;
+	case demod_cab:
+		cab_pwr = stv0367cab_snr_power(fe);
+		regval = stv0367cab_snr_readreg(fe, 0);
+
+		/* prevent division by zero */
+		if (!regval)
+			snrval = 0;
+
+		tmpval = (cab_pwr * 320) / regval;
+		snrval = ((tmpval != 0) ? (intlog2(tmpval) / 5581) : 0);
+		break;
+	default:
+		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return;
+	}
+
+	p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	p->cnr.stat[0].uvalue = snrval;
+}
+
 static void stv0367ddb_read_ucblocks(struct dvb_frontend *fe)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
@@ -3053,6 +3086,12 @@ static int stv0367ddb_read_status(struct dvb_frontend *fe,
 	if (ret)
 		return ret;
 
+	/* read carrier/noise when a carrier is detected */
+	if (*status & FE_HAS_CARRIER)
+		stv0367ddb_read_snr(fe);
+	else
+		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	/* stop if demod isn't locked */
 	if (!(*status & FE_HAS_LOCK)) {
 		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-- 
2.13.0
