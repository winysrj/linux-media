Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1L3PJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:30 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Un2024206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 23/94] [media] zl10353: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:20 -0200
Message-Id: <1325257711-12274-24-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/zl10353.c |  113 +++++++++++++++------------------
 1 files changed, 50 insertions(+), 63 deletions(-)

diff --git a/drivers/media/dvb/frontends/zl10353.c b/drivers/media/dvb/frontends/zl10353.c
index 35334da..39c1bdb 100644
--- a/drivers/media/dvb/frontends/zl10353.c
+++ b/drivers/media/dvb/frontends/zl10353.c
@@ -37,9 +37,9 @@ struct zl10353_state {
 
 	struct zl10353_config config;
 
-	enum fe_bandwidth bandwidth;
-       u32 ucblocks;
-       u32 frequency;
+	u32 bandwidth;
+	u32 ucblocks;
+	u32 frequency;
 };
 
 static int debug;
@@ -122,30 +122,17 @@ static void zl10353_dump_regs(struct dvb_frontend *fe)
 }
 
 static void zl10353_calc_nominal_rate(struct dvb_frontend *fe,
-				      enum fe_bandwidth bandwidth,
+				      u32 bandwidth,
 				      u16 *nominal_rate)
 {
 	struct zl10353_state *state = fe->demodulator_priv;
 	u32 adc_clock = 450560; /* 45.056 MHz */
 	u64 value;
-	u8 bw;
+	u8 bw = bandwidth / 1000000;
 
 	if (state->config.adc_clock)
 		adc_clock = state->config.adc_clock;
 
-	switch (bandwidth) {
-	case BANDWIDTH_6_MHZ:
-		bw = 6;
-		break;
-	case BANDWIDTH_7_MHZ:
-		bw = 7;
-		break;
-	case BANDWIDTH_8_MHZ:
-	default:
-		bw = 8;
-		break;
-	}
-
 	value = (u64)10 * (1 << 23) / 7 * 125;
 	value = (bw * value) + adc_clock / 2;
 	do_div(value, adc_clock);
@@ -192,16 +179,15 @@ static int zl10353_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int zl10353_set_parameters(struct dvb_frontend *fe,
-				  struct dvb_frontend_parameters *param)
+static int zl10353_set_parameters(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct zl10353_state *state = fe->demodulator_priv;
 	u16 nominal_rate, input_freq;
 	u8 pllbuf[6] = { 0x67 }, acq_ctl = 0;
 	u16 tps = 0;
-	struct dvb_ofdm_parameters *op = &param->u.ofdm;
 
-       state->frequency = param->frequency;
+	state->frequency = c->frequency;
 
 	zl10353_single_write(fe, RESET, 0x80);
 	udelay(200);
@@ -211,42 +197,44 @@ static int zl10353_set_parameters(struct dvb_frontend *fe,
 
 	zl10353_single_write(fe, AGC_TARGET, 0x28);
 
-	if (op->transmission_mode != TRANSMISSION_MODE_AUTO)
+	if (c->transmission_mode != TRANSMISSION_MODE_AUTO)
 		acq_ctl |= (1 << 0);
-	if (op->guard_interval != GUARD_INTERVAL_AUTO)
+	if (c->guard_interval != GUARD_INTERVAL_AUTO)
 		acq_ctl |= (1 << 1);
 	zl10353_single_write(fe, ACQ_CTL, acq_ctl);
 
-	switch (op->bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	switch (c->bandwidth_hz) {
+	case 6000000:
 		/* These are extrapolated from the 7 and 8MHz values */
 		zl10353_single_write(fe, MCLK_RATIO, 0x97);
 		zl10353_single_write(fe, 0x64, 0x34);
 		zl10353_single_write(fe, 0xcc, 0xdd);
 		break;
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		zl10353_single_write(fe, MCLK_RATIO, 0x86);
 		zl10353_single_write(fe, 0x64, 0x35);
 		zl10353_single_write(fe, 0xcc, 0x73);
 		break;
-	case BANDWIDTH_8_MHZ:
 	default:
+		c->bandwidth_hz = 8000000;
+		/* fall though */
+	case 8000000:
 		zl10353_single_write(fe, MCLK_RATIO, 0x75);
 		zl10353_single_write(fe, 0x64, 0x36);
 		zl10353_single_write(fe, 0xcc, 0x73);
 	}
 
-	zl10353_calc_nominal_rate(fe, op->bandwidth, &nominal_rate);
+	zl10353_calc_nominal_rate(fe, c->bandwidth_hz, &nominal_rate);
 	zl10353_single_write(fe, TRL_NOMINAL_RATE_1, msb(nominal_rate));
 	zl10353_single_write(fe, TRL_NOMINAL_RATE_0, lsb(nominal_rate));
-	state->bandwidth = op->bandwidth;
+	state->bandwidth = c->bandwidth_hz;
 
 	zl10353_calc_input_freq(fe, &input_freq);
 	zl10353_single_write(fe, INPUT_FREQ_1, msb(input_freq));
 	zl10353_single_write(fe, INPUT_FREQ_0, lsb(input_freq));
 
 	/* Hint at TPS settings */
-	switch (op->code_rate_HP) {
+	switch (c->code_rate_HP) {
 	case FEC_2_3:
 		tps |= (1 << 7);
 		break;
@@ -266,7 +254,7 @@ static int zl10353_set_parameters(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	switch (op->code_rate_LP) {
+	switch (c->code_rate_LP) {
 	case FEC_2_3:
 		tps |= (1 << 4);
 		break;
@@ -283,14 +271,14 @@ static int zl10353_set_parameters(struct dvb_frontend *fe,
 	case FEC_AUTO:
 		break;
 	case FEC_NONE:
-		if (op->hierarchy_information == HIERARCHY_AUTO ||
-		    op->hierarchy_information == HIERARCHY_NONE)
+		if (c->hierarchy == HIERARCHY_AUTO ||
+		    c->hierarchy == HIERARCHY_NONE)
 			break;
 	default:
 		return -EINVAL;
 	}
 
-	switch (op->constellation) {
+	switch (c->modulation) {
 	case QPSK:
 		break;
 	case QAM_AUTO:
@@ -304,7 +292,7 @@ static int zl10353_set_parameters(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	switch (op->transmission_mode) {
+	switch (c->transmission_mode) {
 	case TRANSMISSION_MODE_2K:
 	case TRANSMISSION_MODE_AUTO:
 		break;
@@ -315,7 +303,7 @@ static int zl10353_set_parameters(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	switch (op->guard_interval) {
+	switch (c->guard_interval) {
 	case GUARD_INTERVAL_1_32:
 	case GUARD_INTERVAL_AUTO:
 		break;
@@ -332,7 +320,7 @@ static int zl10353_set_parameters(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	switch (op->hierarchy_information) {
+	switch (c->hierarchy) {
 	case HIERARCHY_AUTO:
 	case HIERARCHY_NONE:
 		break;
@@ -384,10 +372,9 @@ static int zl10353_set_parameters(struct dvb_frontend *fe,
 }
 
 static int zl10353_get_parameters(struct dvb_frontend *fe,
-				  struct dvb_frontend_parameters *param)
+				  struct dtv_frontend_properties *c)
 {
 	struct zl10353_state *state = fe->demodulator_priv;
-	struct dvb_ofdm_parameters *op = &param->u.ofdm;
 	int s6, s9;
 	u16 tps;
 	static const u8 tps_fec_to_api[8] = {
@@ -411,66 +398,66 @@ static int zl10353_get_parameters(struct dvb_frontend *fe,
 	tps = zl10353_read_register(state, TPS_RECEIVED_1) << 8 |
 	      zl10353_read_register(state, TPS_RECEIVED_0);
 
-	op->code_rate_HP = tps_fec_to_api[(tps >> 7) & 7];
-	op->code_rate_LP = tps_fec_to_api[(tps >> 4) & 7];
+	c->code_rate_HP = tps_fec_to_api[(tps >> 7) & 7];
+	c->code_rate_LP = tps_fec_to_api[(tps >> 4) & 7];
 
 	switch ((tps >> 13) & 3) {
 	case 0:
-		op->constellation = QPSK;
+		c->modulation = QPSK;
 		break;
 	case 1:
-		op->constellation = QAM_16;
+		c->modulation = QAM_16;
 		break;
 	case 2:
-		op->constellation = QAM_64;
+		c->modulation = QAM_64;
 		break;
 	default:
-		op->constellation = QAM_AUTO;
+		c->modulation = QAM_AUTO;
 		break;
 	}
 
-	op->transmission_mode = (tps & 0x01) ? TRANSMISSION_MODE_8K :
+	c->transmission_mode = (tps & 0x01) ? TRANSMISSION_MODE_8K :
 					       TRANSMISSION_MODE_2K;
 
 	switch ((tps >> 2) & 3) {
 	case 0:
-		op->guard_interval = GUARD_INTERVAL_1_32;
+		c->guard_interval = GUARD_INTERVAL_1_32;
 		break;
 	case 1:
-		op->guard_interval = GUARD_INTERVAL_1_16;
+		c->guard_interval = GUARD_INTERVAL_1_16;
 		break;
 	case 2:
-		op->guard_interval = GUARD_INTERVAL_1_8;
+		c->guard_interval = GUARD_INTERVAL_1_8;
 		break;
 	case 3:
-		op->guard_interval = GUARD_INTERVAL_1_4;
+		c->guard_interval = GUARD_INTERVAL_1_4;
 		break;
 	default:
-		op->guard_interval = GUARD_INTERVAL_AUTO;
+		c->guard_interval = GUARD_INTERVAL_AUTO;
 		break;
 	}
 
 	switch ((tps >> 10) & 7) {
 	case 0:
-		op->hierarchy_information = HIERARCHY_NONE;
+		c->hierarchy = HIERARCHY_NONE;
 		break;
 	case 1:
-		op->hierarchy_information = HIERARCHY_1;
+		c->hierarchy = HIERARCHY_1;
 		break;
 	case 2:
-		op->hierarchy_information = HIERARCHY_2;
+		c->hierarchy = HIERARCHY_2;
 		break;
 	case 3:
-		op->hierarchy_information = HIERARCHY_4;
+		c->hierarchy = HIERARCHY_4;
 		break;
 	default:
-		op->hierarchy_information = HIERARCHY_AUTO;
+		c->hierarchy = HIERARCHY_AUTO;
 		break;
 	}
 
-       param->frequency = state->frequency;
-	op->bandwidth = state->bandwidth;
-	param->inversion = INVERSION_AUTO;
+	c->frequency = state->frequency;
+	c->bandwidth_hz = state->bandwidth;
+	c->inversion = INVERSION_AUTO;
 
 	return 0;
 }
@@ -651,7 +638,7 @@ error:
 }
 
 static struct dvb_frontend_ops zl10353_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Zarlink ZL10353 DVB-T",
 		.type			= FE_OFDM,
@@ -675,8 +662,8 @@ static struct dvb_frontend_ops zl10353_ops = {
 	.i2c_gate_ctrl = zl10353_i2c_gate_ctrl,
 	.write = zl10353_write,
 
-	.set_frontend_legacy = zl10353_set_parameters,
-	.get_frontend_legacy = zl10353_get_parameters,
+	.set_frontend = zl10353_set_parameters,
+	.get_frontend = zl10353_get_parameters,
 	.get_tune_settings = zl10353_get_tune_settings,
 
 	.read_status = zl10353_read_status,
-- 
1.7.8.352.g876a6

