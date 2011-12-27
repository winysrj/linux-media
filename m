Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab1L0BJn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:43 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19hfN015688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:43 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 76/91] [media] mxl111sf-demod: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:09:04 -0200
Message-Id: <1324948159-23709-77-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-76-git-send-email-mchehab@redhat.com>
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
 <1324948159-23709-71-git-send-email-mchehab@redhat.com>
 <1324948159-23709-72-git-send-email-mchehab@redhat.com>
 <1324948159-23709-73-git-send-email-mchehab@redhat.com>
 <1324948159-23709-74-git-send-email-mchehab@redhat.com>
 <1324948159-23709-75-git-send-email-mchehab@redhat.com>
 <1324948159-23709-76-git-send-email-mchehab@redhat.com>
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

