Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab1L0BJi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:38 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19c7a017874
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:38 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 70/91] [media] dst: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:58 -0200
Message-Id: <1324948159-23709-71-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-70-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
 <1324948159-23709-7-git-send-email-mchehab@redhat.com>
 <1324948159-23709-8-git-send-email-mchehab@redhat.com>
 <1324948159-23709-9-git-send-email-mchehab@redhat.com>
 <1324948159-23709-10-git-send-email-mchehab@redhat.com>
 <1324948159-23709-11-git-send-email-mchehab@redhat.com>
 <1324948159-23709-12-git-send-email-mchehab@redhat.com>
 <1324948159-23709-13-git-send-email-mchehab@redhat.com>
 <1324948159-23709-14-git-send-email-mchehab@redhat.com>
 <1324948159-23709-15-git-send-email-mchehab@redhat.com>
 <1324948159-23709-16-git-send-email-mchehab@redhat.com>
 <1324948159-23709-17-git-send-email-mchehab@redhat.com>
 <1324948159-23709-18-git-send-email-mchehab@redhat.com>
 <1324948159-23709-19-git-send-email-mchehab@redhat.com>
 <1324948159-23709-20-git-send-email-mchehab@redhat.com>
 <1324948159-23709-21-git-send-email-mchehab@redhat.com>
 <1324948159-23709-22-git-send-email-mchehab@redhat.com>
 <1324948159-23709-23-git-send-email-mchehab@redhat.com>
 <1324948159-23709-24-git-send-email-mchehab@redhat.com>
 <1324948159-23709-25-git-send-email-mchehab@redhat.com>
 <1324948159-23709-26-git-send-email-mchehab@redhat.com>
 <1324948159-23709-27-git-send-email-mchehab@redhat.com>
 <1324948159-23709-28-git-send-email-mchehab@redhat.com>
 <1324948159-23709-29-git-send-email-mchehab@redhat.com>
 <1324948159-23709-30-git-send-email-mchehab@redhat.com>
 <1324948159-23709-31-git-send-email-mchehab@redhat.com>
 <1324948159-23709-32-git-send-email-mchehab@redhat.com>
 <1324948159-23709-33-git-send-email-mchehab@redhat.com>
 <1324948159-23709-34-git-send-email-mchehab@redhat.com>
 <1324948159-23709-35-git-send-email-mchehab@redhat.com>
 <1324948159-23709-36-git-send-email-mchehab@redhat.com>
 <1324948159-23709-37-git-send-email-mchehab@redhat.com>
 <1324948159-23709-38-git-send-email-mchehab@redhat.com>
 <1324948159-23709-39-git-send-email-mchehab@redhat.com>
 <1324948159-23709-40-git-send-email-mchehab@redhat.com>
 <1324948159-23709-41-git-send-email-mchehab@redhat.com>
 <1324948159-23709-42-git-send-email-mchehab@redhat.com>
 <1324948159-23709-43-git-send-email-mchehab@redhat.com>
 <1324948159-23709-44-git-send-email-mchehab@redhat.com>
 <1324948159-23709-45-git-send-email-mchehab@redhat.com>
 <1324948159-23709-46-git-send-email-mchehab@redhat.com>
 <1324948159-23709-47-git-send-email-mchehab@redhat.com>
 <1324948159-23709-48-git-send-email-mchehab@redhat.com>
 <1324948159-23709-49-git-send-email-mchehab@redhat.com>
 <1324948159-23709-50-git-send-email-mchehab@redhat.com>
 <1324948159-23709-51-git-send-email-mchehab@redhat.com>
 <1324948159-23709-52-git-send-email-mchehab@redhat.com>
 <1324948159-23709-53-git-send-email-mchehab@redhat.com>
 <1324948159-23709-54-git-send-email-mchehab@redhat.com>
 <1324948159-23709-55-git-send-email-mchehab@redhat.com>
 <1324948159-23709-56-git-send-email-mchehab@redhat.com>
 <1324948159-23709-57-git-send-email-mchehab@redhat.com>
 <1324948159-23709-58-git-send-email-mchehab@redhat.com>
 <1324948159-23709-59-git-send-email-mchehab@redhat.com>
 <1324948159-23709-60-git-send-email-mchehab@redhat.com>
 <1324948159-23709-61-git-send-email-mchehab@redhat.com>
 <1324948159-23709-62-git-send-email-mchehab@redhat.com>
 <1324948159-23709-63-git-send-email-mchehab@redhat.com>
 <1324948159-23709-64-git-send-email-mchehab@redhat.com>
 <1324948159-23709-65-git-send-email-mchehab@redhat.com>
 <1324948159-23709-66-git-send-email-mchehab@redhat.com>
 <1324948159-23709-67-git-send-email-mchehab@redhat.com>
 <1324948159-23709-68-git-send-email-mchehab@redhat.com>
 <1324948159-23709-69-git-send-email-mchehab@redhat.com>
 <1324948159-23709-70-git-send-email-mchehab@redhat.com>
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

