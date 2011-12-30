Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab1L3PJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:27 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9RsU015866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 20/94] [media] dib3000mb: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:17 -0200
Message-Id: <1325257711-12274-21-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/dib3000mb.c |  111 +++++++++++++++----------------
 1 files changed, 54 insertions(+), 57 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib3000mb.c b/drivers/media/dvb/frontends/dib3000mb.c
index 77af240..432d1b0 100644
--- a/drivers/media/dvb/frontends/dib3000mb.c
+++ b/drivers/media/dvb/frontends/dib3000mb.c
@@ -113,13 +113,12 @@ static u16 dib3000_seq[2][2][2] =     /* fft,gua,   inv   */
 	};
 
 static int dib3000mb_get_frontend(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *fep);
+				  struct dtv_frontend_properties *c);
 
-static int dib3000mb_set_frontend(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *fep, int tuner)
+static int dib3000mb_set_frontend(struct dvb_frontend* fe, int tuner)
 {
 	struct dib3000_state* state = fe->demodulator_priv;
-	struct dvb_ofdm_parameters *ofdm = &fep->u.ofdm;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	fe_code_rate_t fe_cr = FEC_NONE;
 	int search_state, seq;
 
@@ -128,23 +127,23 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 
 		deb_setf("bandwidth: ");
-		switch (ofdm->bandwidth) {
-			case BANDWIDTH_8_MHZ:
+		switch (c->bandwidth_hz) {
+			case 8000000:
 				deb_setf("8 MHz\n");
 				wr_foreach(dib3000mb_reg_timing_freq, dib3000mb_timing_freq[2]);
 				wr_foreach(dib3000mb_reg_bandwidth, dib3000mb_bandwidth_8mhz);
 				break;
-			case BANDWIDTH_7_MHZ:
+			case 7000000:
 				deb_setf("7 MHz\n");
 				wr_foreach(dib3000mb_reg_timing_freq, dib3000mb_timing_freq[1]);
 				wr_foreach(dib3000mb_reg_bandwidth, dib3000mb_bandwidth_7mhz);
 				break;
-			case BANDWIDTH_6_MHZ:
+			case 6000000:
 				deb_setf("6 MHz\n");
 				wr_foreach(dib3000mb_reg_timing_freq, dib3000mb_timing_freq[0]);
 				wr_foreach(dib3000mb_reg_bandwidth, dib3000mb_bandwidth_6mhz);
 				break;
-			case BANDWIDTH_AUTO:
+			case 0:
 				return -EOPNOTSUPP;
 			default:
 				err("unknown bandwidth value.");
@@ -154,7 +153,7 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 	wr(DIB3000MB_REG_LOCK1_MASK, DIB3000MB_LOCK1_SEARCH_4);
 
 	deb_setf("transmission mode: ");
-	switch (ofdm->transmission_mode) {
+	switch (c->transmission_mode) {
 		case TRANSMISSION_MODE_2K:
 			deb_setf("2k\n");
 			wr(DIB3000MB_REG_FFT, DIB3000_TRANSMISSION_MODE_2K);
@@ -171,7 +170,7 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 	}
 
 	deb_setf("guard: ");
-	switch (ofdm->guard_interval) {
+	switch (c->guard_interval) {
 		case GUARD_INTERVAL_1_32:
 			deb_setf("1_32\n");
 			wr(DIB3000MB_REG_GUARD_TIME, DIB3000_GUARD_TIME_1_32);
@@ -196,7 +195,7 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 	}
 
 	deb_setf("inversion: ");
-	switch (fep->inversion) {
+	switch (c->inversion) {
 		case INVERSION_OFF:
 			deb_setf("off\n");
 			wr(DIB3000MB_REG_DDS_INV, DIB3000_DDS_INVERSION_OFF);
@@ -212,8 +211,8 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 			return -EINVAL;
 	}
 
-	deb_setf("constellation: ");
-	switch (ofdm->constellation) {
+	deb_setf("modulation: ");
+	switch (c->modulation) {
 		case QPSK:
 			deb_setf("qpsk\n");
 			wr(DIB3000MB_REG_QAM, DIB3000_CONSTELLATION_QPSK);
@@ -232,7 +231,7 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 			return -EINVAL;
 	}
 	deb_setf("hierarchy: ");
-	switch (ofdm->hierarchy_information) {
+	switch (c->hierarchy) {
 		case HIERARCHY_NONE:
 			deb_setf("none ");
 			/* fall through */
@@ -256,16 +255,16 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 	}
 
 	deb_setf("hierarchy: ");
-	if (ofdm->hierarchy_information == HIERARCHY_NONE) {
+	if (c->hierarchy == HIERARCHY_NONE) {
 		deb_setf("none\n");
 		wr(DIB3000MB_REG_VIT_HRCH, DIB3000_HRCH_OFF);
 		wr(DIB3000MB_REG_VIT_HP, DIB3000_SELECT_HP);
-		fe_cr = ofdm->code_rate_HP;
-	} else if (ofdm->hierarchy_information != HIERARCHY_AUTO) {
+		fe_cr = c->code_rate_HP;
+	} else if (c->hierarchy != HIERARCHY_AUTO) {
 		deb_setf("on\n");
 		wr(DIB3000MB_REG_VIT_HRCH, DIB3000_HRCH_ON);
 		wr(DIB3000MB_REG_VIT_HP, DIB3000_SELECT_LP);
-		fe_cr = ofdm->code_rate_LP;
+		fe_cr = c->code_rate_LP;
 	}
 	deb_setf("fec: ");
 	switch (fe_cr) {
@@ -300,9 +299,9 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 	}
 
 	seq = dib3000_seq
-		[ofdm->transmission_mode == TRANSMISSION_MODE_AUTO]
-		[ofdm->guard_interval == GUARD_INTERVAL_AUTO]
-		[fep->inversion == INVERSION_AUTO];
+		[c->transmission_mode == TRANSMISSION_MODE_AUTO]
+		[c->guard_interval == GUARD_INTERVAL_AUTO]
+		[c->inversion == INVERSION_AUTO];
 
 	deb_setf("seq? %d\n", seq);
 
@@ -310,8 +309,8 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 
 	wr(DIB3000MB_REG_ISI, seq ? DIB3000MB_ISI_INHIBIT : DIB3000MB_ISI_ACTIVATE);
 
-	if (ofdm->transmission_mode == TRANSMISSION_MODE_2K) {
-		if (ofdm->guard_interval == GUARD_INTERVAL_1_8) {
+	if (c->transmission_mode == TRANSMISSION_MODE_2K) {
+		if (c->guard_interval == GUARD_INTERVAL_1_8) {
 			wr(DIB3000MB_REG_SYNC_IMPROVEMENT, DIB3000MB_SYNC_IMPROVE_2K_1_8);
 		} else {
 			wr(DIB3000MB_REG_SYNC_IMPROVEMENT, DIB3000MB_SYNC_IMPROVE_DEFAULT);
@@ -339,10 +338,10 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 	wr_foreach(dib3000mb_reg_agc_bandwidth, dib3000mb_agc_bandwidth_low);
 
 	/* something has to be auto searched */
-	if (ofdm->constellation == QAM_AUTO ||
-		ofdm->hierarchy_information == HIERARCHY_AUTO ||
+	if (c->modulation == QAM_AUTO ||
+		c->hierarchy == HIERARCHY_AUTO ||
 		fe_cr == FEC_AUTO ||
-		fep->inversion == INVERSION_AUTO) {
+		c->inversion == INVERSION_AUTO) {
 		int as_count=0;
 
 		deb_setf("autosearch enabled.\n");
@@ -361,10 +360,9 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 		deb_setf("search_state after autosearch %d after %d checks\n",search_state,as_count);
 
 		if (search_state == 1) {
-			struct dvb_frontend_parameters feps;
-			if (dib3000mb_get_frontend(fe, &feps) == 0) {
+			if (dib3000mb_get_frontend(fe, c) == 0) {
 				deb_setf("reading tuning data from frontend succeeded.\n");
-				return dib3000mb_set_frontend(fe, &feps, 0);
+				return dib3000mb_set_frontend(fe, 0);
 			}
 		}
 
@@ -454,10 +452,9 @@ static int dib3000mb_fe_init(struct dvb_frontend* fe, int mobile_mode)
 }
 
 static int dib3000mb_get_frontend(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *fep)
+				  struct dtv_frontend_properties *c)
 {
 	struct dib3000_state* state = fe->demodulator_priv;
-	struct dvb_ofdm_parameters *ofdm = &fep->u.ofdm;
 	fe_code_rate_t *cr;
 	u16 tps_val;
 	int inv_test1,inv_test2;
@@ -484,25 +481,25 @@ static int dib3000mb_get_frontend(struct dvb_frontend* fe,
 	else
 		inv_test2 = 2;
 
-	fep->inversion =
+	c->inversion =
 		((inv_test2 == 2) && (inv_test1==1 || inv_test1==0)) ||
 		((inv_test2 == 0) && (inv_test1==1 || inv_test1==2)) ?
 		INVERSION_ON : INVERSION_OFF;
 
-	deb_getf("inversion %d %d, %d\n", inv_test2, inv_test1, fep->inversion);
+	deb_getf("inversion %d %d, %d\n", inv_test2, inv_test1, c->inversion);
 
 	switch ((tps_val = rd(DIB3000MB_REG_TPS_QAM))) {
 		case DIB3000_CONSTELLATION_QPSK:
 			deb_getf("QPSK ");
-			ofdm->constellation = QPSK;
+			c->modulation = QPSK;
 			break;
 		case DIB3000_CONSTELLATION_16QAM:
 			deb_getf("QAM16 ");
-			ofdm->constellation = QAM_16;
+			c->modulation = QAM_16;
 			break;
 		case DIB3000_CONSTELLATION_64QAM:
 			deb_getf("QAM64 ");
-			ofdm->constellation = QAM_64;
+			c->modulation = QAM_64;
 			break;
 		default:
 			err("Unexpected constellation returned by TPS (%d)", tps_val);
@@ -512,24 +509,24 @@ static int dib3000mb_get_frontend(struct dvb_frontend* fe,
 
 	if (rd(DIB3000MB_REG_TPS_HRCH)) {
 		deb_getf("HRCH ON\n");
-		cr = &ofdm->code_rate_LP;
-		ofdm->code_rate_HP = FEC_NONE;
+		cr = &c->code_rate_LP;
+		c->code_rate_HP = FEC_NONE;
 		switch ((tps_val = rd(DIB3000MB_REG_TPS_VIT_ALPHA))) {
 			case DIB3000_ALPHA_0:
 				deb_getf("HIERARCHY_NONE ");
-				ofdm->hierarchy_information = HIERARCHY_NONE;
+				c->hierarchy = HIERARCHY_NONE;
 				break;
 			case DIB3000_ALPHA_1:
 				deb_getf("HIERARCHY_1 ");
-				ofdm->hierarchy_information = HIERARCHY_1;
+				c->hierarchy = HIERARCHY_1;
 				break;
 			case DIB3000_ALPHA_2:
 				deb_getf("HIERARCHY_2 ");
-				ofdm->hierarchy_information = HIERARCHY_2;
+				c->hierarchy = HIERARCHY_2;
 				break;
 			case DIB3000_ALPHA_4:
 				deb_getf("HIERARCHY_4 ");
-				ofdm->hierarchy_information = HIERARCHY_4;
+				c->hierarchy = HIERARCHY_4;
 				break;
 			default:
 				err("Unexpected ALPHA value returned by TPS (%d)", tps_val);
@@ -540,9 +537,9 @@ static int dib3000mb_get_frontend(struct dvb_frontend* fe,
 		tps_val = rd(DIB3000MB_REG_TPS_CODE_RATE_LP);
 	} else {
 		deb_getf("HRCH OFF\n");
-		cr = &ofdm->code_rate_HP;
-		ofdm->code_rate_LP = FEC_NONE;
-		ofdm->hierarchy_information = HIERARCHY_NONE;
+		cr = &c->code_rate_HP;
+		c->code_rate_LP = FEC_NONE;
+		c->hierarchy = HIERARCHY_NONE;
 
 		tps_val = rd(DIB3000MB_REG_TPS_CODE_RATE_HP);
 	}
@@ -577,19 +574,19 @@ static int dib3000mb_get_frontend(struct dvb_frontend* fe,
 	switch ((tps_val = rd(DIB3000MB_REG_TPS_GUARD_TIME))) {
 		case DIB3000_GUARD_TIME_1_32:
 			deb_getf("GUARD_INTERVAL_1_32 ");
-			ofdm->guard_interval = GUARD_INTERVAL_1_32;
+			c->guard_interval = GUARD_INTERVAL_1_32;
 			break;
 		case DIB3000_GUARD_TIME_1_16:
 			deb_getf("GUARD_INTERVAL_1_16 ");
-			ofdm->guard_interval = GUARD_INTERVAL_1_16;
+			c->guard_interval = GUARD_INTERVAL_1_16;
 			break;
 		case DIB3000_GUARD_TIME_1_8:
 			deb_getf("GUARD_INTERVAL_1_8 ");
-			ofdm->guard_interval = GUARD_INTERVAL_1_8;
+			c->guard_interval = GUARD_INTERVAL_1_8;
 			break;
 		case DIB3000_GUARD_TIME_1_4:
 			deb_getf("GUARD_INTERVAL_1_4 ");
-			ofdm->guard_interval = GUARD_INTERVAL_1_4;
+			c->guard_interval = GUARD_INTERVAL_1_4;
 			break;
 		default:
 			err("Unexpected Guard Time returned by TPS (%d)", tps_val);
@@ -600,11 +597,11 @@ static int dib3000mb_get_frontend(struct dvb_frontend* fe,
 	switch ((tps_val = rd(DIB3000MB_REG_TPS_FFT))) {
 		case DIB3000_TRANSMISSION_MODE_2K:
 			deb_getf("TRANSMISSION_MODE_2K ");
-			ofdm->transmission_mode = TRANSMISSION_MODE_2K;
+			c->transmission_mode = TRANSMISSION_MODE_2K;
 			break;
 		case DIB3000_TRANSMISSION_MODE_8K:
 			deb_getf("TRANSMISSION_MODE_8K ");
-			ofdm->transmission_mode = TRANSMISSION_MODE_8K;
+			c->transmission_mode = TRANSMISSION_MODE_8K;
 			break;
 		default:
 			err("unexpected transmission mode return by TPS (%d)", tps_val);
@@ -701,9 +698,9 @@ static int dib3000mb_fe_init_nonmobile(struct dvb_frontend* fe)
 	return dib3000mb_fe_init(fe, 0);
 }
 
-static int dib3000mb_set_frontend_and_tuner(struct dvb_frontend* fe, struct dvb_frontend_parameters *fep)
+static int dib3000mb_set_frontend_and_tuner(struct dvb_frontend* fe)
 {
-	return dib3000mb_set_frontend(fe, fep, 1);
+	return dib3000mb_set_frontend(fe, 1);
 }
 
 static void dib3000mb_release(struct dvb_frontend* fe)
@@ -794,7 +791,7 @@ error:
 }
 
 static struct dvb_frontend_ops dib3000mb_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "DiBcom 3000M-B DVB-T",
 		.type			= FE_OFDM,
@@ -816,8 +813,8 @@ static struct dvb_frontend_ops dib3000mb_ops = {
 	.init = dib3000mb_fe_init_nonmobile,
 	.sleep = dib3000mb_sleep,
 
-	.set_frontend_legacy = dib3000mb_set_frontend_and_tuner,
-	.get_frontend_legacy = dib3000mb_get_frontend,
+	.set_frontend = dib3000mb_set_frontend_and_tuner,
+	.get_frontend = dib3000mb_get_frontend,
 	.get_tune_settings = dib3000mb_fe_get_tune_settings,
 
 	.read_status = dib3000mb_read_status,
-- 
1.7.8.352.g876a6

