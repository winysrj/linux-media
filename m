Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Vj3026586
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 70/94] [media] dst: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:07 -0200
Message-Id: <1325257711-12274-71-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/bt8xx/dst.c |   63 +++++++++++++++++++++--------------------
 1 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/dvb/bt8xx/dst.c
index 6afc083..7d60893 100644
--- a/drivers/media/dvb/bt8xx/dst.c
+++ b/drivers/media/dvb/bt8xx/dst.c
@@ -386,7 +386,7 @@ static int dst_set_freq(struct dst_state *state, u32 freq)
 	return 0;
 }
 
-static int dst_set_bandwidth(struct dst_state *state, fe_bandwidth_t bandwidth)
+static int dst_set_bandwidth(struct dst_state *state, u32 bandwidth)
 {
 	state->bandwidth = bandwidth;
 
@@ -394,7 +394,7 @@ static int dst_set_bandwidth(struct dst_state *state, fe_bandwidth_t bandwidth)
 		return -EOPNOTSUPP;
 
 	switch (bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	case 6000000:
 		if (state->dst_hw_cap & DST_TYPE_HAS_CA)
 			state->tx_tuna[7] = 0x06;
 		else {
@@ -402,7 +402,7 @@ static int dst_set_bandwidth(struct dst_state *state, fe_bandwidth_t bandwidth)
 			state->tx_tuna[7] = 0x00;
 		}
 		break;
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		if (state->dst_hw_cap & DST_TYPE_HAS_CA)
 			state->tx_tuna[7] = 0x07;
 		else {
@@ -410,7 +410,7 @@ static int dst_set_bandwidth(struct dst_state *state, fe_bandwidth_t bandwidth)
 			state->tx_tuna[7] = 0x00;
 		}
 		break;
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 		if (state->dst_hw_cap & DST_TYPE_HAS_CA)
 			state->tx_tuna[7] = 0x08;
 		else {
@@ -1561,7 +1561,7 @@ static int dst_init(struct dvb_frontend *fe)
 	state->tone = SEC_TONE_OFF;
 	state->diseq_flags = 0;
 	state->k22 = 0x02;
-	state->bandwidth = BANDWIDTH_7_MHZ;
+	state->bandwidth = 7000000;
 	state->cur_jiff = jiffies;
 	if (state->dst_type == DST_TYPE_IS_SAT)
 		memcpy(state->tx_tuna, ((state->type_flags & DST_TYPE_HAS_VLF) ? sat_tuna_188 : sat_tuna_204), sizeof (sat_tuna_204));
@@ -1609,8 +1609,9 @@ static int dst_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return retval;
 }
 
-static int dst_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+static int dst_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	int retval = -EINVAL;
 	struct dst_state *state = fe->demodulator_priv;
 
@@ -1623,17 +1624,17 @@ static int dst_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_paramet
 		if (state->dst_type == DST_TYPE_IS_SAT) {
 			if (state->type_flags & DST_TYPE_HAS_OBS_REGS)
 				dst_set_inversion(state, p->inversion);
-			dst_set_fec(state, p->u.qpsk.fec_inner);
-			dst_set_symbolrate(state, p->u.qpsk.symbol_rate);
+			dst_set_fec(state, p->fec_inner);
+			dst_set_symbolrate(state, p->symbol_rate);
 			dst_set_polarization(state);
-			dprintk(verbose, DST_DEBUG, 1, "Set Symbolrate=[%d]", p->u.qpsk.symbol_rate);
+			dprintk(verbose, DST_DEBUG, 1, "Set Symbolrate=[%d]", p->symbol_rate);
 
 		} else if (state->dst_type == DST_TYPE_IS_TERR)
-			dst_set_bandwidth(state, p->u.ofdm.bandwidth);
+			dst_set_bandwidth(state, p->bandwidth_hz);
 		else if (state->dst_type == DST_TYPE_IS_CABLE) {
-			dst_set_fec(state, p->u.qam.fec_inner);
-			dst_set_symbolrate(state, p->u.qam.symbol_rate);
-			dst_set_modulation(state, p->u.qam.modulation);
+			dst_set_fec(state, p->fec_inner);
+			dst_set_symbolrate(state, p->symbol_rate);
+			dst_set_modulation(state, p->modulation);
 		}
 		retval = dst_write_tuna(fe);
 	}
@@ -1683,7 +1684,7 @@ static int dst_get_tuning_algo(struct dvb_frontend *fe)
 	return dst_algo ? DVBFE_ALGO_HW : DVBFE_ALGO_SW;
 }
 
-static int dst_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+static int dst_get_frontend(struct dvb_frontend *fe, struct dtv_frontend_properties *p)
 {
 	struct dst_state *state = fe->demodulator_priv;
 
@@ -1691,14 +1692,14 @@ static int dst_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_paramet
 	if (state->dst_type == DST_TYPE_IS_SAT) {
 		if (state->type_flags & DST_TYPE_HAS_OBS_REGS)
 			p->inversion = state->inversion;
-		p->u.qpsk.symbol_rate = state->symbol_rate;
-		p->u.qpsk.fec_inner = dst_get_fec(state);
+		p->symbol_rate = state->symbol_rate;
+		p->fec_inner = dst_get_fec(state);
 	} else if (state->dst_type == DST_TYPE_IS_TERR) {
-		p->u.ofdm.bandwidth = state->bandwidth;
+		p->bandwidth_hz = state->bandwidth;
 	} else if (state->dst_type == DST_TYPE_IS_CABLE) {
-		p->u.qam.symbol_rate = state->symbol_rate;
-		p->u.qam.fec_inner = dst_get_fec(state);
-		p->u.qam.modulation = dst_get_modulation(state);
+		p->symbol_rate = state->symbol_rate;
+		p->fec_inner = dst_get_fec(state);
+		p->modulation = dst_get_modulation(state);
 	}
 
 	return 0;
@@ -1756,7 +1757,7 @@ struct dst_state *dst_attach(struct dst_state *state, struct dvb_adapter *dvb_ad
 EXPORT_SYMBOL(dst_attach);
 
 static struct dvb_frontend_ops dst_dvbt_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "DST DVB-T",
 		.type = FE_OFDM,
@@ -1777,8 +1778,8 @@ static struct dvb_frontend_ops dst_dvbt_ops = {
 	.release = dst_release,
 	.init = dst_init,
 	.tune = dst_tune_frontend,
-	.set_frontend_legacy = dst_set_frontend,
-	.get_frontend_legacy = dst_get_frontend,
+	.set_frontend = dst_set_frontend,
+	.get_frontend = dst_get_frontend,
 	.get_frontend_algo = dst_get_tuning_algo,
 	.read_status = dst_read_status,
 	.read_signal_strength = dst_read_signal_strength,
@@ -1786,7 +1787,7 @@ static struct dvb_frontend_ops dst_dvbt_ops = {
 };
 
 static struct dvb_frontend_ops dst_dvbs_ops = {
-
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "DST DVB-S",
 		.type = FE_QPSK,
@@ -1803,8 +1804,8 @@ static struct dvb_frontend_ops dst_dvbs_ops = {
 	.release = dst_release,
 	.init = dst_init,
 	.tune = dst_tune_frontend,
-	.set_frontend_legacy = dst_set_frontend,
-	.get_frontend_legacy = dst_get_frontend,
+	.set_frontend = dst_set_frontend,
+	.get_frontend = dst_get_frontend,
 	.get_frontend_algo = dst_get_tuning_algo,
 	.read_status = dst_read_status,
 	.read_signal_strength = dst_read_signal_strength,
@@ -1816,7 +1817,7 @@ static struct dvb_frontend_ops dst_dvbs_ops = {
 };
 
 static struct dvb_frontend_ops dst_dvbc_ops = {
-
+	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name = "DST DVB-C",
 		.type = FE_QAM,
@@ -1837,8 +1838,8 @@ static struct dvb_frontend_ops dst_dvbc_ops = {
 	.release = dst_release,
 	.init = dst_init,
 	.tune = dst_tune_frontend,
-	.set_frontend_legacy = dst_set_frontend,
-	.get_frontend_legacy = dst_get_frontend,
+	.set_frontend = dst_set_frontend,
+	.get_frontend = dst_get_frontend,
 	.get_frontend_algo = dst_get_tuning_algo,
 	.read_status = dst_read_status,
 	.read_signal_strength = dst_read_signal_strength,
@@ -1860,8 +1861,8 @@ static struct dvb_frontend_ops dst_atsc_ops = {
 	.release = dst_release,
 	.init = dst_init,
 	.tune = dst_tune_frontend,
-	.set_frontend_legacy = dst_set_frontend,
-	.get_frontend_legacy = dst_get_frontend,
+	.set_frontend = dst_set_frontend,
+	.get_frontend = dst_get_frontend,
 	.get_frontend_algo = dst_get_tuning_algo,
 	.read_status = dst_read_status,
 	.read_signal_strength = dst_read_signal_strength,
-- 
1.7.8.352.g876a6

