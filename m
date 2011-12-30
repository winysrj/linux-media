Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab1L3PJ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:29 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Tf2015902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:29 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 45/94] [media] tda10048: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:42 -0200
Message-Id: <1325257711-12274-46-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/tda10048.c |   78 +++++++++++++-------------------
 1 files changed, 32 insertions(+), 46 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10048.c b/drivers/media/dvb/frontends/tda10048.c
index bba249b..80de9f6 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -341,21 +341,14 @@ static int tda10048_set_wref(struct dvb_frontend *fe, u32 sample_freq_hz,
 {
 	struct tda10048_state *state = fe->demodulator_priv;
 	u64 t, z;
-	u32 b = 8000000;
 
 	dprintk(1, "%s()\n", __func__);
 
 	if (sample_freq_hz == 0)
 		return -EINVAL;
 
-	if (bw == BANDWIDTH_6_MHZ)
-		b = 6000000;
-	else
-	if (bw == BANDWIDTH_7_MHZ)
-		b = 7000000;
-
 	/* WREF = (B / (7 * fs)) * 2^31 */
-	t = b * 10;
+	t = bw * 10;
 	/* avoid warning: this decimal constant is unsigned only in ISO C90 */
 	/* t *= 2147483648 on 32bit platforms */
 	t *= (2048 * 1024);
@@ -378,25 +371,18 @@ static int tda10048_set_invwref(struct dvb_frontend *fe, u32 sample_freq_hz,
 {
 	struct tda10048_state *state = fe->demodulator_priv;
 	u64 t;
-	u32 b = 8000000;
 
 	dprintk(1, "%s()\n", __func__);
 
 	if (sample_freq_hz == 0)
 		return -EINVAL;
 
-	if (bw == BANDWIDTH_6_MHZ)
-		b = 6000000;
-	else
-	if (bw == BANDWIDTH_7_MHZ)
-		b = 7000000;
-
 	/* INVWREF = ((7 * fs) / B) * 2^5 */
 	t = sample_freq_hz;
 	t *= 7;
 	t *= 32;
 	t *= 10;
-	do_div(t, b);
+	do_div(t, bw);
 	t += 5;
 	do_div(t, 10);
 
@@ -407,16 +393,16 @@ static int tda10048_set_invwref(struct dvb_frontend *fe, u32 sample_freq_hz,
 }
 
 static int tda10048_set_bandwidth(struct dvb_frontend *fe,
-	enum fe_bandwidth bw)
+	u32 bw)
 {
 	struct tda10048_state *state = fe->demodulator_priv;
 	dprintk(1, "%s(bw=%d)\n", __func__, bw);
 
 	/* Bandwidth setting may need to be adjusted */
 	switch (bw) {
-	case BANDWIDTH_6_MHZ:
-	case BANDWIDTH_7_MHZ:
-	case BANDWIDTH_8_MHZ:
+	case 6000000:
+	case 7000000:
+	case 8000000:
 		tda10048_set_wref(fe, state->sample_freq, bw);
 		tda10048_set_invwref(fe, state->sample_freq, bw);
 		break;
@@ -430,7 +416,7 @@ static int tda10048_set_bandwidth(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int tda10048_set_if(struct dvb_frontend *fe, enum fe_bandwidth bw)
+static int tda10048_set_if(struct dvb_frontend *fe, u32 bw)
 {
 	struct tda10048_state *state = fe->demodulator_priv;
 	struct tda10048_config *config = &state->config;
@@ -441,13 +427,13 @@ static int tda10048_set_if(struct dvb_frontend *fe, enum fe_bandwidth bw)
 
 	/* based on target bandwidth and clk we calculate pll factors */
 	switch (bw) {
-	case BANDWIDTH_6_MHZ:
+	case 6000000:
 		if_freq_khz = config->dtv6_if_freq_khz;
 		break;
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		if_freq_khz = config->dtv7_if_freq_khz;
 		break;
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 		if_freq_khz = config->dtv8_if_freq_khz;
 		break;
 	default:
@@ -601,7 +587,7 @@ static int tda10048_set_inversion(struct dvb_frontend *fe, int inversion)
 
 /* Retrieve the demod settings */
 static int tda10048_get_tps(struct tda10048_state *state,
-	struct dvb_ofdm_parameters *p)
+	struct dtv_frontend_properties *p)
 {
 	u8 val;
 
@@ -612,27 +598,27 @@ static int tda10048_get_tps(struct tda10048_state *state,
 	val = tda10048_readreg(state, TDA10048_OUT_CONF2);
 	switch ((val & 0x60) >> 5) {
 	case 0:
-		p->constellation = QPSK;
+		p->modulation = QPSK;
 		break;
 	case 1:
-		p->constellation = QAM_16;
+		p->modulation = QAM_16;
 		break;
 	case 2:
-		p->constellation = QAM_64;
+		p->modulation = QAM_64;
 		break;
 	}
 	switch ((val & 0x18) >> 3) {
 	case 0:
-		p->hierarchy_information = HIERARCHY_NONE;
+		p->hierarchy = HIERARCHY_NONE;
 		break;
 	case 1:
-		p->hierarchy_information = HIERARCHY_1;
+		p->hierarchy = HIERARCHY_1;
 		break;
 	case 2:
-		p->hierarchy_information = HIERARCHY_2;
+		p->hierarchy = HIERARCHY_2;
 		break;
 	case 3:
-		p->hierarchy_information = HIERARCHY_4;
+		p->hierarchy = HIERARCHY_4;
 		break;
 	}
 	switch (val & 0x07) {
@@ -738,17 +724,17 @@ static int tda10048_output_mode(struct dvb_frontend *fe, int serial)
 
 /* Talk to the demod, set the FEC, GUARD, QAM settings etc */
 /* TODO: Support manual tuning with specific params */
-static int tda10048_set_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static int tda10048_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct tda10048_state *state = fe->demodulator_priv;
 
 	dprintk(1, "%s(frequency=%d)\n", __func__, p->frequency);
 
 	/* Update the I/F pll's if the bandwidth changes */
-	if (p->u.ofdm.bandwidth != state->bandwidth) {
-		tda10048_set_if(fe, p->u.ofdm.bandwidth);
-		tda10048_set_bandwidth(fe, p->u.ofdm.bandwidth);
+	if (p->bandwidth_hz != state->bandwidth) {
+		tda10048_set_if(fe, p->bandwidth_hz);
+		tda10048_set_bandwidth(fe, p->bandwidth_hz);
 	}
 
 	if (fe->ops.tuner_ops.set_params) {
@@ -797,8 +783,8 @@ static int tda10048_init(struct dvb_frontend *fe)
 	tda10048_set_inversion(fe, config->inversion);
 
 	/* Establish default RF values */
-	tda10048_set_if(fe, BANDWIDTH_8_MHZ);
-	tda10048_set_bandwidth(fe, BANDWIDTH_8_MHZ);
+	tda10048_set_if(fe, 8000000);
+	tda10048_set_bandwidth(fe, 8000000);
 
 	/* Ensure we leave the gate closed */
 	tda10048_i2c_gate_ctrl(fe, 0);
@@ -1043,7 +1029,7 @@ static int tda10048_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 }
 
 static int tda10048_get_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+	struct dtv_frontend_properties *p)
 {
 	struct tda10048_state *state = fe->demodulator_priv;
 
@@ -1052,7 +1038,7 @@ static int tda10048_get_frontend(struct dvb_frontend *fe,
 	p->inversion = tda10048_readreg(state, TDA10048_CONF_C1_1)
 		& 0x20 ? INVERSION_ON : INVERSION_OFF;
 
-	return tda10048_get_tps(state, &p->u.ofdm);
+	return tda10048_get_tps(state, p);
 }
 
 static int tda10048_get_tune_settings(struct dvb_frontend *fe,
@@ -1126,7 +1112,7 @@ struct dvb_frontend *tda10048_attach(const struct tda10048_config *config,
 	memcpy(&state->config, config, sizeof(*config));
 	state->i2c = i2c;
 	state->fwloaded = config->no_firmware;
-	state->bandwidth = BANDWIDTH_8_MHZ;
+	state->bandwidth = 8000000;
 
 	/* check if the demod is present */
 	if (tda10048_readreg(state, TDA10048_IDENTITY) != 0x048)
@@ -1152,11 +1138,11 @@ struct dvb_frontend *tda10048_attach(const struct tda10048_config *config,
 	tda10048_establish_defaults(&state->frontend);
 
 	/* Set the xtal and freq defaults */
-	if (tda10048_set_if(&state->frontend, BANDWIDTH_8_MHZ) != 0)
+	if (tda10048_set_if(&state->frontend, 8000000) != 0)
 		goto error;
 
 	/* Default bandwidth */
-	if (tda10048_set_bandwidth(&state->frontend, BANDWIDTH_8_MHZ) != 0)
+	if (tda10048_set_bandwidth(&state->frontend, 8000000) != 0)
 		goto error;
 
 	/* Leave the gate closed */
@@ -1188,8 +1174,8 @@ static struct dvb_frontend_ops tda10048_ops = {
 	.release = tda10048_release,
 	.init = tda10048_init,
 	.i2c_gate_ctrl = tda10048_i2c_gate_ctrl,
-	.set_frontend_legacy = tda10048_set_frontend,
-	.get_frontend_legacy = tda10048_get_frontend,
+	.set_frontend = tda10048_set_frontend,
+	.get_frontend = tda10048_get_frontend,
 	.get_tune_settings = tda10048_get_tune_settings,
 	.read_status = tda10048_read_status,
 	.read_ber = tda10048_read_ber,
-- 
1.7.8.352.g876a6

