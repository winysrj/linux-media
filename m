Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab1L0BJn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:43 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19gJ1005515
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:42 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 44/91] [media] stv0367: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:32 -0200
Message-Id: <1324948159-23709-45-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-44-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/stv0367.c |  154 ++++++++++++++++-----------------
 1 files changed, 75 insertions(+), 79 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
index e0a2438..7c8964f6 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -1577,9 +1577,9 @@ int stv0367ter_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int stv0367ter_algo(struct dvb_frontend *fe,
-				struct dvb_frontend_parameters *param)
+static int stv0367ter_algo(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct stv0367ter_state *ter_state = state->ter_state;
 	int offset = 0, tempo = 0;
@@ -1591,7 +1591,7 @@ static int stv0367ter_algo(struct dvb_frontend *fe,
 
 	dprintk("%s:\n", __func__);
 
-	ter_state->frequency = param->frequency;
+	ter_state->frequency = p->frequency;
 	ter_state->force = FE_TER_FORCENONE
 			+ stv0367_readbits(state, F367TER_FORCE) * 2;
 	ter_state->if_iq_mode = state->config->if_iq_mode;
@@ -1620,7 +1620,7 @@ static int stv0367ter_algo(struct dvb_frontend *fe,
 
 	usleep_range(5000, 7000);
 
-	switch (param->inversion) {
+	switch (p->inversion) {
 	case INVERSION_AUTO:
 	default:
 		dprintk("%s: inversion AUTO\n", __func__);
@@ -1636,10 +1636,10 @@ static int stv0367ter_algo(struct dvb_frontend *fe,
 	case INVERSION_OFF:
 		if (ter_state->if_iq_mode == FE_TER_IQ_TUNER)
 			stv0367_writebits(state, F367TER_IQ_INVERT,
-						param->inversion);
+						p->inversion);
 		else
 			stv0367_writebits(state, F367TER_INV_SPECTR,
-						param->inversion);
+						p->inversion);
 
 		break;
 	}
@@ -1806,10 +1806,9 @@ static int stv0367ter_algo(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int stv0367ter_set_frontend(struct dvb_frontend *fe,
-				struct dvb_frontend_parameters *param)
+static int stv0367ter_set_frontend(struct dvb_frontend *fe)
 {
-	struct dvb_ofdm_parameters *op = &param->u.ofdm;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct stv0367ter_state *ter_state = state->ter_state;
 
@@ -1827,7 +1826,7 @@ static int stv0367ter_set_frontend(struct dvb_frontend *fe,
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	switch (op->transmission_mode) {
+	switch (p->transmission_mode) {
 	default:
 	case TRANSMISSION_MODE_AUTO:
 	case TRANSMISSION_MODE_2K:
@@ -1841,34 +1840,34 @@ static int stv0367ter_set_frontend(struct dvb_frontend *fe,
 		break;
 	}
 
-	switch (op->guard_interval) {
+	switch (p->guard_interval) {
 	default:
 	case GUARD_INTERVAL_1_32:
 	case GUARD_INTERVAL_1_16:
 	case GUARD_INTERVAL_1_8:
 	case GUARD_INTERVAL_1_4:
-		ter_state->guard = op->guard_interval;
+		ter_state->guard = p->guard_interval;
 		break;
 	case GUARD_INTERVAL_AUTO:
 		ter_state->guard = GUARD_INTERVAL_1_32;
 		break;
 	}
 
-	switch (op->bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	switch (p->bandwidth_hz) {
+	case 6000000:
 		ter_state->bw = FE_TER_CHAN_BW_6M;
 		break;
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		ter_state->bw = FE_TER_CHAN_BW_7M;
 		break;
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 	default:
 		ter_state->bw = FE_TER_CHAN_BW_8M;
 	}
 
 	ter_state->hierarchy = FE_TER_HIER_NONE;
 
-	switch (param->inversion) {
+	switch (p->inversion) {
 	case INVERSION_OFF:
 	case INVERSION_ON:
 		num_trials = 1;
@@ -1885,14 +1884,14 @@ static int stv0367ter_set_frontend(struct dvb_frontend *fe,
 
 	while (((index) < num_trials) && (ter_state->state != FE_TER_LOCKOK)) {
 		if (!ter_state->first_lock) {
-			if (param->inversion == INVERSION_AUTO)
+			if (p->inversion == INVERSION_AUTO)
 				ter_state->sense = SenseTrials[index];
 
 		}
-		stv0367ter_algo(fe,/* &pLook, result,*/ param);
+		stv0367ter_algo(fe);
 
 		if ((ter_state->state == FE_TER_LOCKOK) &&
-				(param->inversion == INVERSION_AUTO) &&
+				(p->inversion == INVERSION_AUTO) &&
 								(index == 1)) {
 			/* invert spectrum sense */
 			SenseTrials[index] = SenseTrials[0];
@@ -1928,49 +1927,47 @@ static int stv0367ter_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 }
 
 static int stv0367ter_get_frontend(struct dvb_frontend *fe,
-				  struct dvb_frontend_parameters *param)
+				   struct dtv_frontend_properties *p)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct stv0367ter_state *ter_state = state->ter_state;
-	struct dvb_ofdm_parameters *op = &param->u.ofdm;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
 	int error = 0;
 	enum stv0367_ter_mode mode;
 	int constell = 0,/* snr = 0,*/ Data = 0;
 
-	param->frequency = stv0367_get_tuner_freq(fe);
-	if ((int)param->frequency < 0)
-		param->frequency = c->frequency;
+	p->frequency = stv0367_get_tuner_freq(fe);
+	if ((int)p->frequency < 0)
+		p->frequency = -p->frequency;
 
 	constell = stv0367_readbits(state, F367TER_TPS_CONST);
 	if (constell == 0)
-		op->constellation = QPSK;
+		p->modulation = QPSK;
 	else if (constell == 1)
-		op->constellation = QAM_16;
+		p->modulation = QAM_16;
 	else
-		op->constellation = QAM_64;
+		p->modulation = QAM_64;
 
-	param->inversion = stv0367_readbits(state, F367TER_INV_SPECTR);
+	p->inversion = stv0367_readbits(state, F367TER_INV_SPECTR);
 
 	/* Get the Hierarchical mode */
 	Data = stv0367_readbits(state, F367TER_TPS_HIERMODE);
 
 	switch (Data) {
 	case 0:
-		op->hierarchy_information = HIERARCHY_NONE;
+		p->hierarchy = HIERARCHY_NONE;
 		break;
 	case 1:
-		op->hierarchy_information = HIERARCHY_1;
+		p->hierarchy = HIERARCHY_1;
 		break;
 	case 2:
-		op->hierarchy_information = HIERARCHY_2;
+		p->hierarchy = HIERARCHY_2;
 		break;
 	case 3:
-		op->hierarchy_information = HIERARCHY_4;
+		p->hierarchy = HIERARCHY_4;
 		break;
 	default:
-		op->hierarchy_information = HIERARCHY_AUTO;
+		p->hierarchy = HIERARCHY_AUTO;
 		break; /* error */
 	}
 
@@ -1982,22 +1979,22 @@ static int stv0367ter_get_frontend(struct dvb_frontend *fe,
 
 	switch (Data) {
 	case 0:
-		op->code_rate_HP = FEC_1_2;
+		p->code_rate_HP = FEC_1_2;
 		break;
 	case 1:
-		op->code_rate_HP = FEC_2_3;
+		p->code_rate_HP = FEC_2_3;
 		break;
 	case 2:
-		op->code_rate_HP = FEC_3_4;
+		p->code_rate_HP = FEC_3_4;
 		break;
 	case 3:
-		op->code_rate_HP = FEC_5_6;
+		p->code_rate_HP = FEC_5_6;
 		break;
 	case 4:
-		op->code_rate_HP = FEC_7_8;
+		p->code_rate_HP = FEC_7_8;
 		break;
 	default:
-		op->code_rate_HP = FEC_AUTO;
+		p->code_rate_HP = FEC_AUTO;
 		break; /* error */
 	}
 
@@ -2005,19 +2002,19 @@ static int stv0367ter_get_frontend(struct dvb_frontend *fe,
 
 	switch (mode) {
 	case FE_TER_MODE_2K:
-		op->transmission_mode = TRANSMISSION_MODE_2K;
+		p->transmission_mode = TRANSMISSION_MODE_2K;
 		break;
 /*	case FE_TER_MODE_4K:
-		op->transmission_mode = TRANSMISSION_MODE_4K;
+		p->transmission_mode = TRANSMISSION_MODE_4K;
 		break;*/
 	case FE_TER_MODE_8K:
-		op->transmission_mode = TRANSMISSION_MODE_8K;
+		p->transmission_mode = TRANSMISSION_MODE_8K;
 		break;
 	default:
-		op->transmission_mode = TRANSMISSION_MODE_AUTO;
+		p->transmission_mode = TRANSMISSION_MODE_AUTO;
 	}
 
-	op->guard_interval = stv0367_readbits(state, F367TER_SYR_GUARD);
+	p->guard_interval = stv0367_readbits(state, F367TER_SYR_GUARD);
 
 	return error;
 }
@@ -2265,6 +2262,7 @@ static void stv0367_release(struct dvb_frontend *fe)
 }
 
 static struct dvb_frontend_ops stv0367ter_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "ST STV0367 DVB-T",
 		.type			= FE_OFDM,
@@ -2285,8 +2283,8 @@ static struct dvb_frontend_ops stv0367ter_ops = {
 	.init = stv0367ter_init,
 	.sleep = stv0367ter_sleep,
 	.i2c_gate_ctrl = stv0367ter_gate_ctrl,
-	.set_frontend_legacy = stv0367ter_set_frontend,
-	.get_frontend_legacy = stv0367ter_get_frontend,
+	.set_frontend = stv0367ter_set_frontend,
+	.get_frontend = stv0367ter_get_frontend,
 	.get_tune_settings = stv0367_get_tune_settings,
 	.read_status = stv0367ter_read_status,
 	.read_ber = stv0367ter_read_ber,/* too slow */
@@ -2822,9 +2820,8 @@ int stv0367cab_init(struct dvb_frontend *fe)
 }
 static
 enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
-				struct dvb_frontend_parameters *param)
+					     struct dtv_frontend_properties *p)
 {
-	struct dvb_qam_parameters *op = &param->u.qam;
 	struct stv0367cab_state *cab_state = state->cab_state;
 	enum stv0367_cab_signal_type signalType = FE_CAB_NOAGC;
 	u32	QAMFEC_Lock, QAM_Lock, u32_tmp,
@@ -2839,7 +2836,7 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 	/* A max lock time of 25 ms is allowed for delayed AGC */
 	AGCTimeOut = 25;
 	/* 100000 symbols needed by the TRL as a maximum value */
-	TRLTimeOut = 100000000 / op->symbol_rate;
+	TRLTimeOut = 100000000 / p->symbol_rate;
 	/* CRLSymbols is the needed number of symbols to achieve a lock
 	   within [-4%, +4%] of the symbol rate.
 	   CRL timeout is calculated
@@ -2849,7 +2846,7 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 	   A characterization must be performed
 	   with these echoes to get new timeout values.
 	*/
-	switch (op->modulation) {
+	switch (p->modulation) {
 	case QAM_16:
 		CRLSymbols = 150000;
 		EQLTimeOut = 100;
@@ -2883,9 +2880,9 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 	} else
 #endif
 	CRLTimeOut = (25 * CRLSymbols * (cab_state->search_range / 1000)) /
-					(op->symbol_rate / 1000);
+					(p->symbol_rate / 1000);
 
-	CRLTimeOut = (1000 * CRLTimeOut) / op->symbol_rate;
+	CRLTimeOut = (1000 * CRLTimeOut) / p->symbol_rate;
 	/* Timeouts below 50ms are coerced */
 	if (CRLTimeOut < 50)
 		CRLTimeOut = 50;
@@ -2915,7 +2912,7 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 	stv0367cab_set_derot_freq(state, cab_state->adc_clk,
 		(1000 * (s32)state->config->if_khz + cab_state->derot_offset));
 	/* Disable the Allpass Filter when the symbol rate is out of range */
-	if ((op->symbol_rate > 10800000) | (op->symbol_rate < 1800000)) {
+	if ((p->symbol_rate > 10800000) | (p->symbol_rate < 1800000)) {
 		stv0367_writebits(state, F367CAB_ADJ_EN, 0);
 		stv0367_writebits(state, F367CAB_ALLPASSFILT_EN, 0);
 	}
@@ -2999,7 +2996,7 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 
 	if (QAMFEC_Lock) {
 		signalType = FE_CAB_DATAOK;
-		cab_state->modulation = op->modulation;
+		cab_state->modulation = p->modulation;
 		cab_state->spect_inv = stv0367_readbits(state,
 							F367CAB_QUAD_INV);
 #if 0
@@ -3081,20 +3078,19 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 	return signalType;
 }
 
-static int stv0367cab_set_frontend(struct dvb_frontend *fe,
-				struct dvb_frontend_parameters *param)
+static int stv0367cab_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct stv0367cab_state *cab_state = state->cab_state;
-	struct dvb_qam_parameters *op = &param->u.qam;
 	enum stv0367cab_mod QAMSize = 0;
 
 	dprintk("%s: freq = %d, srate = %d\n", __func__,
-					param->frequency, op->symbol_rate);
+					p->frequency, p->symbol_rate);
 
 	cab_state->derot_offset = 0;
 
-	switch (op->modulation) {
+	switch (p->modulation) {
 	case QAM_16:
 		QAMSize = FE_CAB_MOD_QAM16;
 		break;
@@ -3127,70 +3123,69 @@ static int stv0367cab_set_frontend(struct dvb_frontend *fe,
 
 	stv0367cab_SetQamSize(
 			state,
-			op->symbol_rate,
+			p->symbol_rate,
 			QAMSize);
 
 	stv0367cab_set_srate(state,
 			cab_state->adc_clk,
 			cab_state->mclk,
-			op->symbol_rate,
+			p->symbol_rate,
 			QAMSize);
 	/* Search algorithm launch, [-1.1*RangeOffset, +1.1*RangeOffset] scan */
-	cab_state->state = stv0367cab_algo(state, param);
+	cab_state->state = stv0367cab_algo(state, p);
 	return 0;
 }
 
 static int stv0367cab_get_frontend(struct dvb_frontend *fe,
-				  struct dvb_frontend_parameters *param)
+				   struct dtv_frontend_properties *p)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct stv0367cab_state *cab_state = state->cab_state;
-	struct dvb_qam_parameters *op = &param->u.qam;
 
 	enum stv0367cab_mod QAMSize;
 
 	dprintk("%s:\n", __func__);
 
-	op->symbol_rate = stv0367cab_GetSymbolRate(state, cab_state->mclk);
+	p->symbol_rate = stv0367cab_GetSymbolRate(state, cab_state->mclk);
 
 	QAMSize = stv0367_readbits(state, F367CAB_QAM_MODE);
 	switch (QAMSize) {
 	case FE_CAB_MOD_QAM16:
-		op->modulation = QAM_16;
+		p->modulation = QAM_16;
 		break;
 	case FE_CAB_MOD_QAM32:
-		op->modulation = QAM_32;
+		p->modulation = QAM_32;
 		break;
 	case FE_CAB_MOD_QAM64:
-		op->modulation = QAM_64;
+		p->modulation = QAM_64;
 		break;
 	case FE_CAB_MOD_QAM128:
-		op->modulation = QAM_128;
+		p->modulation = QAM_128;
 		break;
 	case QAM_256:
-		op->modulation = QAM_256;
+		p->modulation = QAM_256;
 		break;
 	default:
 		break;
 	}
 
-	param->frequency = stv0367_get_tuner_freq(fe);
+	p->frequency = stv0367_get_tuner_freq(fe);
 
-	dprintk("%s: tuner frequency = %d\n", __func__, param->frequency);
+	dprintk("%s: tuner frequency = %d\n", __func__, p->frequency);
 
 	if (state->config->if_khz == 0) {
-		param->frequency +=
+		p->frequency +=
 			(stv0367cab_get_derot_freq(state, cab_state->adc_clk) -
 			cab_state->adc_clk / 4000);
 		return 0;
 	}
 
 	if (state->config->if_khz > cab_state->adc_clk / 1000)
-		param->frequency += (state->config->if_khz
+		p->frequency += (state->config->if_khz
 			- stv0367cab_get_derot_freq(state, cab_state->adc_clk)
 			- cab_state->adc_clk / 1000);
 	else
-		param->frequency += (state->config->if_khz
+		p->frequency += (state->config->if_khz
 			- stv0367cab_get_derot_freq(state, cab_state->adc_clk));
 
 	return 0;
@@ -3386,6 +3381,7 @@ static int stv0367cab_read_ucblcks(struct dvb_frontend *fe, u32 *ucblocks)
 };
 
 static struct dvb_frontend_ops stv0367cab_ops = {
+	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name = "ST STV0367 DVB-C",
 		.type = FE_QAM,
@@ -3403,8 +3399,8 @@ static struct dvb_frontend_ops stv0367cab_ops = {
 	.init					= stv0367cab_init,
 	.sleep					= stv0367cab_sleep,
 	.i2c_gate_ctrl				= stv0367cab_gate_ctrl,
-	.set_frontend_legacy				= stv0367cab_set_frontend,
-	.get_frontend_legacy = stv0367cab_get_frontend,
+	.set_frontend				= stv0367cab_set_frontend,
+	.get_frontend				= stv0367cab_get_frontend,
 	.read_status				= stv0367cab_read_status,
 /*	.read_ber				= stv0367cab_read_ber, */
 	.read_signal_strength			= stv0367cab_read_strength,
-- 
1.7.8.352.g876a6

