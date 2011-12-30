Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Vox015933
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 76/94] [media] mxl111sf-demod: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:13 -0200
Message-Id: <1325257711-12274-77-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/dvb-usb/mxl111sf-demod.c |   41 +++++++++++++--------------
 1 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-demod.c b/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
index b798cc8..c61f246 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
@@ -102,8 +102,8 @@ fail:
 }
 
 static
-int mxl1x1sf_demod_get_tps_constellation(struct mxl111sf_demod_state *state,
-					 fe_modulation_t *constellation)
+int mxl1x1sf_demod_get_tps_modulation(struct mxl111sf_demod_state *state,
+					 fe_modulation_t *modulation)
 {
 	u8 val;
 	int ret = mxl111sf_demod_read_reg(state, V6_MODORDER_TPS_REG, &val);
@@ -113,13 +113,13 @@ int mxl1x1sf_demod_get_tps_constellation(struct mxl111sf_demod_state *state,
 
 	switch ((val & V6_PARAM_CONSTELLATION_MASK) >> 4) {
 	case 0:
-		*constellation = QPSK;
+		*modulation = QPSK;
 		break;
 	case 1:
-		*constellation = QAM_16;
+		*modulation = QAM_16;
 		break;
 	case 2:
-		*constellation = QAM_64;
+		*modulation = QAM_64;
 		break;
 	}
 fail:
@@ -284,8 +284,7 @@ static int mxl1x1sf_demod_reset_irq_status(struct mxl111sf_demod_state *state)
 
 /* ------------------------------------------------------------------------ */
 
-static int mxl111sf_demod_set_frontend(struct dvb_frontend *fe,
-				       struct dvb_frontend_parameters *param)
+static int mxl111sf_demod_set_frontend(struct dvb_frontend *fe)
 {
 	struct mxl111sf_demod_state *state = fe->demodulator_priv;
 	int ret = 0;
@@ -481,13 +480,13 @@ static int mxl111sf_demod_read_signal_strength(struct dvb_frontend *fe,
 					       u16 *signal_strength)
 {
 	struct mxl111sf_demod_state *state = fe->demodulator_priv;
-	fe_modulation_t constellation;
+	fe_modulation_t modulation;
 	u16 snr;
 
 	mxl111sf_demod_calc_snr(state, &snr);
-	mxl1x1sf_demod_get_tps_constellation(state, &constellation);
+	mxl1x1sf_demod_get_tps_modulation(state, &modulation);
 
-	switch (constellation) {
+	switch (modulation) {
 	case QPSK:
 		*signal_strength = (snr >= 1300) ?
 			min(65535, snr * 44) : snr * 38;
@@ -509,7 +508,7 @@ static int mxl111sf_demod_read_signal_strength(struct dvb_frontend *fe,
 }
 
 static int mxl111sf_demod_get_frontend(struct dvb_frontend *fe,
-				       struct dvb_frontend_parameters *p)
+				       struct dtv_frontend_properties *p)
 {
 	struct mxl111sf_demod_state *state = fe->demodulator_priv;
 
@@ -518,18 +517,18 @@ static int mxl111sf_demod_get_frontend(struct dvb_frontend *fe,
 	p->inversion = /* FIXME */ ? INVERSION_ON : INVERSION_OFF;
 #endif
 	if (fe->ops.tuner_ops.get_bandwidth)
-		fe->ops.tuner_ops.get_bandwidth(fe, &p->u.ofdm.bandwidth);
+		fe->ops.tuner_ops.get_bandwidth(fe, &p->bandwidth_hz);
 	if (fe->ops.tuner_ops.get_frequency)
 		fe->ops.tuner_ops.get_frequency(fe, &p->frequency);
-	mxl1x1sf_demod_get_tps_code_rate(state, &p->u.ofdm.code_rate_HP);
-	mxl1x1sf_demod_get_tps_code_rate(state, &p->u.ofdm.code_rate_LP);
-	mxl1x1sf_demod_get_tps_constellation(state, &p->u.ofdm.constellation);
+	mxl1x1sf_demod_get_tps_code_rate(state, &p->code_rate_HP);
+	mxl1x1sf_demod_get_tps_code_rate(state, &p->code_rate_LP);
+	mxl1x1sf_demod_get_tps_modulation(state, &p->modulation);
 	mxl1x1sf_demod_get_tps_guard_fft_mode(state,
-					      &p->u.ofdm.transmission_mode);
+					      &p->transmission_mode);
 	mxl1x1sf_demod_get_tps_guard_interval(state,
-					      &p->u.ofdm.guard_interval);
+					      &p->guard_interval);
 	mxl1x1sf_demod_get_tps_hierarchy(state,
-					 &p->u.ofdm.hierarchy_information);
+					 &p->hierarchy);
 
 	return 0;
 }
@@ -551,7 +550,7 @@ static void mxl111sf_demod_release(struct dvb_frontend *fe)
 }
 
 static struct dvb_frontend_ops mxl111sf_demod_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name               = "MaxLinear MxL111SF DVB-T demodulator",
 		.type               = FE_OFDM,
@@ -570,8 +569,8 @@ static struct dvb_frontend_ops mxl111sf_demod_ops = {
 	.init                 = mxl111sf_init,
 	.i2c_gate_ctrl        = mxl111sf_i2c_gate_ctrl,
 #endif
-	.set_frontend_legacy         = mxl111sf_demod_set_frontend,
-	.get_frontend_legacy = mxl111sf_demod_get_frontend,
+	.set_frontend         = mxl111sf_demod_set_frontend,
+	.get_frontend         = mxl111sf_demod_get_frontend,
 	.get_tune_settings    = mxl111sf_demod_get_tune_settings,
 	.read_status          = mxl111sf_demod_read_status,
 	.read_signal_strength = mxl111sf_demod_read_signal_strength,
-- 
1.7.8.352.g876a6

