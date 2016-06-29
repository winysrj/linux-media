Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43478 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbcF2Wnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 18:43:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 07/10] lgdt3306a: Expose SNR via dvbv5 stats
Date: Wed, 29 Jun 2016 19:43:23 -0300
Message-Id: <263b682ec3094833065bce3c16de902a7a2ec7ae.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for dvbv5 stats to expose the S/N ratio in
decibels.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 36 +++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 179c26e5eb4e..6b686c3a44ce 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -811,6 +811,7 @@ static int lgdt3306a_fe_sleep(struct dvb_frontend *fe)
 static int lgdt3306a_init(struct dvb_frontend *fe)
 {
 	struct lgdt3306a_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	u8 val;
 	int ret;
 
@@ -962,6 +963,13 @@ static int lgdt3306a_init(struct dvb_frontend *fe)
 	ret = lgdt3306a_sleep(state);
 	lg_chkerr(ret);
 
+	/* Initialize DVBv5 statistics */
+	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	p->strength.stat[0].uvalue = 0;
+	p->strength.len = 1;
+	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->cnr.len = 1;
+
 fail:
 	return ret;
 }
@@ -1032,6 +1040,11 @@ static int lgdt3306a_set_parameters(struct dvb_frontend *fe)
 	if (lg_chkerr(ret))
 		goto fail;
 
+	/* Reset DVBv5 stats */
+	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	p->strength.stat[0].uvalue = 0;
+	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 #ifdef DBG_DUMP
 	lgdt3306a_DumpAllRegs(state);
 #endif
@@ -1497,6 +1510,8 @@ static u32 lgdt3306a_calculate_snr_x100(struct lgdt3306a_state *state)
 	snr_x100 = log10_x1000((pwr * 10000) / mse) - 3000;
 	dbg_info("mse=%u, pwr=%u, snr_x100=%d\n", mse, pwr, snr_x100);
 
+	state->snr = snr_x100;
+
 	return snr_x100;
 }
 
@@ -1558,6 +1573,18 @@ lgdt3306a_qam_lock_poll(struct lgdt3306a_state *state)
 	return LG3306_UNLOCK;
 }
 
+static void lgdt3306a_get_stats(struct dvb_frontend *fe, enum fe_status status)
+{
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	struct lgdt3306a_state *state = fe->demodulator_priv;
+
+	if (!(status & FE_HAS_LOCK))
+		return;
+
+	p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	p->cnr.stat[0].svalue = state->snr * 10;
+}
+
 static int lgdt3306a_read_status(struct dvb_frontend *fe,
 				 enum fe_status *status)
 {
@@ -1599,9 +1626,16 @@ static int lgdt3306a_read_status(struct dvb_frontend *fe,
 			}
 			break;
 		default:
+			state->snr = 0;
 			ret = -EINVAL;
 		}
+	} else {
+		state->snr = 0;
 	}
+
+
+	lgdt3306a_get_stats(fe, *status);
+
 	return ret;
 }
 
@@ -1610,8 +1644,6 @@ static int lgdt3306a_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct lgdt3306a_state *state = fe->demodulator_priv;
 
-	state->snr = lgdt3306a_calculate_snr_x100(state);
-	/* report SNR in dB * 10 */
 	*snr = state->snr/10;
 
 	return 0;
-- 
2.7.4

