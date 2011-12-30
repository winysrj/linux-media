Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab1L3PJ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:29 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9TJr024193
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:29 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 46/94] [media] tda1004x: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:43 -0200
Message-Id: <1325257711-12274-47-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/tda1004x.c |  114 ++++++++++++++++----------------
 1 files changed, 58 insertions(+), 56 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda1004x.c b/drivers/media/dvb/frontends/tda1004x.c
index 2dbb070..d5e68af 100644
--- a/drivers/media/dvb/frontends/tda1004x.c
+++ b/drivers/media/dvb/frontends/tda1004x.c
@@ -224,22 +224,22 @@ static int tda1004x_disable_tuner_i2c(struct tda1004x_state *state)
 }
 
 static int tda10045h_set_bandwidth(struct tda1004x_state *state,
-				   fe_bandwidth_t bandwidth)
+				   u32 bandwidth)
 {
 	static u8 bandwidth_6mhz[] = { 0x02, 0x00, 0x3d, 0x00, 0x60, 0x1e, 0xa7, 0x45, 0x4f };
 	static u8 bandwidth_7mhz[] = { 0x02, 0x00, 0x37, 0x00, 0x4a, 0x2f, 0x6d, 0x76, 0xdb };
 	static u8 bandwidth_8mhz[] = { 0x02, 0x00, 0x3d, 0x00, 0x48, 0x17, 0x89, 0xc7, 0x14 };
 
 	switch (bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	case 6000000:
 		tda1004x_write_buf(state, TDA10045H_CONFPLL_P, bandwidth_6mhz, sizeof(bandwidth_6mhz));
 		break;
 
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		tda1004x_write_buf(state, TDA10045H_CONFPLL_P, bandwidth_7mhz, sizeof(bandwidth_7mhz));
 		break;
 
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 		tda1004x_write_buf(state, TDA10045H_CONFPLL_P, bandwidth_8mhz, sizeof(bandwidth_8mhz));
 		break;
 
@@ -253,7 +253,7 @@ static int tda10045h_set_bandwidth(struct tda1004x_state *state,
 }
 
 static int tda10046h_set_bandwidth(struct tda1004x_state *state,
-				   fe_bandwidth_t bandwidth)
+				   u32 bandwidth)
 {
 	static u8 bandwidth_6mhz_53M[] = { 0x7b, 0x2e, 0x11, 0xf0, 0xd2 };
 	static u8 bandwidth_7mhz_53M[] = { 0x6a, 0x02, 0x6a, 0x43, 0x9f };
@@ -270,7 +270,7 @@ static int tda10046h_set_bandwidth(struct tda1004x_state *state,
 	else
 		tda10046_clk53m = 1;
 	switch (bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	case 6000000:
 		if (tda10046_clk53m)
 			tda1004x_write_buf(state, TDA10046H_TIME_WREF1, bandwidth_6mhz_53M,
 						  sizeof(bandwidth_6mhz_53M));
@@ -283,7 +283,7 @@ static int tda10046h_set_bandwidth(struct tda1004x_state *state,
 		}
 		break;
 
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		if (tda10046_clk53m)
 			tda1004x_write_buf(state, TDA10046H_TIME_WREF1, bandwidth_7mhz_53M,
 						  sizeof(bandwidth_7mhz_53M));
@@ -296,7 +296,7 @@ static int tda10046h_set_bandwidth(struct tda1004x_state *state,
 		}
 		break;
 
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 		if (tda10046_clk53m)
 			tda1004x_write_buf(state, TDA10046H_TIME_WREF1, bandwidth_8mhz_53M,
 						  sizeof(bandwidth_8mhz_53M));
@@ -409,7 +409,7 @@ static int tda10045_fwupload(struct dvb_frontend* fe)
 	msleep(10);
 
 	/* set parameters */
-	tda10045h_set_bandwidth(state, BANDWIDTH_8_MHZ);
+	tda10045h_set_bandwidth(state, 8000000);
 
 	ret = tda1004x_do_upload(state, fw->data, fw->size, TDA10045H_FWPAGE, TDA10045H_CODE_IN);
 	release_firmware(fw);
@@ -473,7 +473,7 @@ static void tda10046_init_plls(struct dvb_frontend* fe)
 		tda1004x_write_byteI(state, TDA10046H_FREQ_PHY2_LSB, 0x3f);
 		break;
 	}
-	tda10046h_set_bandwidth(state, BANDWIDTH_8_MHZ); // default bandwidth 8 MHz
+	tda10046h_set_bandwidth(state, 8000000); // default bandwidth 8 MHz
 	/* let the PLLs settle */
 	msleep(120);
 }
@@ -697,9 +697,9 @@ static int tda10046_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int tda1004x_set_fe(struct dvb_frontend* fe,
-			   struct dvb_frontend_parameters *fe_params)
+static int tda1004x_set_fe(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *fe_params = &fe->dtv_property_cache;
 	struct tda1004x_state* state = fe->demodulator_priv;
 	int tmp;
 	int inversion;
@@ -726,37 +726,37 @@ static int tda1004x_set_fe(struct dvb_frontend* fe,
 	// Hardcoded to use auto as much as possible on the TDA10045 as it
 	// is very unreliable if AUTO mode is _not_ used.
 	if (state->demod_type == TDA1004X_DEMOD_TDA10045) {
-		fe_params->u.ofdm.code_rate_HP = FEC_AUTO;
-		fe_params->u.ofdm.guard_interval = GUARD_INTERVAL_AUTO;
-		fe_params->u.ofdm.transmission_mode = TRANSMISSION_MODE_AUTO;
+		fe_params->code_rate_HP = FEC_AUTO;
+		fe_params->guard_interval = GUARD_INTERVAL_AUTO;
+		fe_params->transmission_mode = TRANSMISSION_MODE_AUTO;
 	}
 
 	// Set standard params.. or put them to auto
-	if ((fe_params->u.ofdm.code_rate_HP == FEC_AUTO) ||
-		(fe_params->u.ofdm.code_rate_LP == FEC_AUTO) ||
-		(fe_params->u.ofdm.constellation == QAM_AUTO) ||
-		(fe_params->u.ofdm.hierarchy_information == HIERARCHY_AUTO)) {
+	if ((fe_params->code_rate_HP == FEC_AUTO) ||
+		(fe_params->code_rate_LP == FEC_AUTO) ||
+		(fe_params->modulation == QAM_AUTO) ||
+		(fe_params->hierarchy == HIERARCHY_AUTO)) {
 		tda1004x_write_mask(state, TDA1004X_AUTO, 1, 1);	// enable auto
-		tda1004x_write_mask(state, TDA1004X_IN_CONF1, 0x03, 0);	// turn off constellation bits
+		tda1004x_write_mask(state, TDA1004X_IN_CONF1, 0x03, 0);	// turn off modulation bits
 		tda1004x_write_mask(state, TDA1004X_IN_CONF1, 0x60, 0);	// turn off hierarchy bits
 		tda1004x_write_mask(state, TDA1004X_IN_CONF2, 0x3f, 0);	// turn off FEC bits
 	} else {
 		tda1004x_write_mask(state, TDA1004X_AUTO, 1, 0);	// disable auto
 
 		// set HP FEC
-		tmp = tda1004x_encode_fec(fe_params->u.ofdm.code_rate_HP);
+		tmp = tda1004x_encode_fec(fe_params->code_rate_HP);
 		if (tmp < 0)
 			return tmp;
 		tda1004x_write_mask(state, TDA1004X_IN_CONF2, 7, tmp);
 
 		// set LP FEC
-		tmp = tda1004x_encode_fec(fe_params->u.ofdm.code_rate_LP);
+		tmp = tda1004x_encode_fec(fe_params->code_rate_LP);
 		if (tmp < 0)
 			return tmp;
 		tda1004x_write_mask(state, TDA1004X_IN_CONF2, 0x38, tmp << 3);
 
-		// set constellation
-		switch (fe_params->u.ofdm.constellation) {
+		// set modulation
+		switch (fe_params->modulation) {
 		case QPSK:
 			tda1004x_write_mask(state, TDA1004X_IN_CONF1, 3, 0);
 			break;
@@ -774,7 +774,7 @@ static int tda1004x_set_fe(struct dvb_frontend* fe,
 		}
 
 		// set hierarchy
-		switch (fe_params->u.ofdm.hierarchy_information) {
+		switch (fe_params->hierarchy) {
 		case HIERARCHY_NONE:
 			tda1004x_write_mask(state, TDA1004X_IN_CONF1, 0x60, 0 << 5);
 			break;
@@ -799,11 +799,11 @@ static int tda1004x_set_fe(struct dvb_frontend* fe,
 	// set bandwidth
 	switch (state->demod_type) {
 	case TDA1004X_DEMOD_TDA10045:
-		tda10045h_set_bandwidth(state, fe_params->u.ofdm.bandwidth);
+		tda10045h_set_bandwidth(state, fe_params->bandwidth_hz);
 		break;
 
 	case TDA1004X_DEMOD_TDA10046:
-		tda10046h_set_bandwidth(state, fe_params->u.ofdm.bandwidth);
+		tda10046h_set_bandwidth(state, fe_params->bandwidth_hz);
 		break;
 	}
 
@@ -825,7 +825,7 @@ static int tda1004x_set_fe(struct dvb_frontend* fe,
 	}
 
 	// set guard interval
-	switch (fe_params->u.ofdm.guard_interval) {
+	switch (fe_params->guard_interval) {
 	case GUARD_INTERVAL_1_32:
 		tda1004x_write_mask(state, TDA1004X_AUTO, 2, 0);
 		tda1004x_write_mask(state, TDA1004X_IN_CONF1, 0x0c, 0 << 2);
@@ -856,7 +856,7 @@ static int tda1004x_set_fe(struct dvb_frontend* fe,
 	}
 
 	// set transmission mode
-	switch (fe_params->u.ofdm.transmission_mode) {
+	switch (fe_params->transmission_mode) {
 	case TRANSMISSION_MODE_2K:
 		tda1004x_write_mask(state, TDA1004X_AUTO, 4, 0);
 		tda1004x_write_mask(state, TDA1004X_IN_CONF1, 0x10, 0 << 4);
@@ -895,7 +895,7 @@ static int tda1004x_set_fe(struct dvb_frontend* fe,
 	return 0;
 }
 
-static int tda1004x_get_fe(struct dvb_frontend* fe, struct dvb_frontend_parameters *fe_params)
+static int tda1004x_get_fe(struct dvb_frontend* fe, struct dtv_frontend_properties *fe_params)
 {
 	struct tda1004x_state* state = fe->demodulator_priv;
 
@@ -913,13 +913,13 @@ static int tda1004x_get_fe(struct dvb_frontend* fe, struct dvb_frontend_paramete
 	case TDA1004X_DEMOD_TDA10045:
 		switch (tda1004x_read_byte(state, TDA10045H_WREF_LSB)) {
 		case 0x14:
-			fe_params->u.ofdm.bandwidth = BANDWIDTH_8_MHZ;
+			fe_params->bandwidth_hz = 8000000;
 			break;
 		case 0xdb:
-			fe_params->u.ofdm.bandwidth = BANDWIDTH_7_MHZ;
+			fe_params->bandwidth_hz = 7000000;
 			break;
 		case 0x4f:
-			fe_params->u.ofdm.bandwidth = BANDWIDTH_6_MHZ;
+			fe_params->bandwidth_hz = 6000000;
 			break;
 		}
 		break;
@@ -927,73 +927,73 @@ static int tda1004x_get_fe(struct dvb_frontend* fe, struct dvb_frontend_paramete
 		switch (tda1004x_read_byte(state, TDA10046H_TIME_WREF1)) {
 		case 0x5c:
 		case 0x54:
-			fe_params->u.ofdm.bandwidth = BANDWIDTH_8_MHZ;
+			fe_params->bandwidth_hz = 8000000;
 			break;
 		case 0x6a:
 		case 0x60:
-			fe_params->u.ofdm.bandwidth = BANDWIDTH_7_MHZ;
+			fe_params->bandwidth_hz = 7000000;
 			break;
 		case 0x7b:
 		case 0x70:
-			fe_params->u.ofdm.bandwidth = BANDWIDTH_6_MHZ;
+			fe_params->bandwidth_hz = 6000000;
 			break;
 		}
 		break;
 	}
 
 	// FEC
-	fe_params->u.ofdm.code_rate_HP =
+	fe_params->code_rate_HP =
 	    tda1004x_decode_fec(tda1004x_read_byte(state, TDA1004X_OUT_CONF2) & 7);
-	fe_params->u.ofdm.code_rate_LP =
+	fe_params->code_rate_LP =
 	    tda1004x_decode_fec((tda1004x_read_byte(state, TDA1004X_OUT_CONF2) >> 3) & 7);
 
-	// constellation
+	// modulation
 	switch (tda1004x_read_byte(state, TDA1004X_OUT_CONF1) & 3) {
 	case 0:
-		fe_params->u.ofdm.constellation = QPSK;
+		fe_params->modulation = QPSK;
 		break;
 	case 1:
-		fe_params->u.ofdm.constellation = QAM_16;
+		fe_params->modulation = QAM_16;
 		break;
 	case 2:
-		fe_params->u.ofdm.constellation = QAM_64;
+		fe_params->modulation = QAM_64;
 		break;
 	}
 
 	// transmission mode
-	fe_params->u.ofdm.transmission_mode = TRANSMISSION_MODE_2K;
+	fe_params->transmission_mode = TRANSMISSION_MODE_2K;
 	if (tda1004x_read_byte(state, TDA1004X_OUT_CONF1) & 0x10)
-		fe_params->u.ofdm.transmission_mode = TRANSMISSION_MODE_8K;
+		fe_params->transmission_mode = TRANSMISSION_MODE_8K;
 
 	// guard interval
 	switch ((tda1004x_read_byte(state, TDA1004X_OUT_CONF1) & 0x0c) >> 2) {
 	case 0:
-		fe_params->u.ofdm.guard_interval = GUARD_INTERVAL_1_32;
+		fe_params->guard_interval = GUARD_INTERVAL_1_32;
 		break;
 	case 1:
-		fe_params->u.ofdm.guard_interval = GUARD_INTERVAL_1_16;
+		fe_params->guard_interval = GUARD_INTERVAL_1_16;
 		break;
 	case 2:
-		fe_params->u.ofdm.guard_interval = GUARD_INTERVAL_1_8;
+		fe_params->guard_interval = GUARD_INTERVAL_1_8;
 		break;
 	case 3:
-		fe_params->u.ofdm.guard_interval = GUARD_INTERVAL_1_4;
+		fe_params->guard_interval = GUARD_INTERVAL_1_4;
 		break;
 	}
 
 	// hierarchy
 	switch ((tda1004x_read_byte(state, TDA1004X_OUT_CONF1) & 0x60) >> 5) {
 	case 0:
-		fe_params->u.ofdm.hierarchy_information = HIERARCHY_NONE;
+		fe_params->hierarchy = HIERARCHY_NONE;
 		break;
 	case 1:
-		fe_params->u.ofdm.hierarchy_information = HIERARCHY_1;
+		fe_params->hierarchy = HIERARCHY_1;
 		break;
 	case 2:
-		fe_params->u.ofdm.hierarchy_information = HIERARCHY_2;
+		fe_params->hierarchy = HIERARCHY_2;
 		break;
 	case 3:
-		fe_params->u.ofdm.hierarchy_information = HIERARCHY_4;
+		fe_params->hierarchy = HIERARCHY_4;
 		break;
 	}
 
@@ -1231,6 +1231,7 @@ static void tda1004x_release(struct dvb_frontend* fe)
 }
 
 static struct dvb_frontend_ops tda10045_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Philips TDA10045H DVB-T",
 		.type = FE_OFDM,
@@ -1251,8 +1252,8 @@ static struct dvb_frontend_ops tda10045_ops = {
 	.write = tda1004x_write,
 	.i2c_gate_ctrl = tda1004x_i2c_gate_ctrl,
 
-	.set_frontend_legacy = tda1004x_set_fe,
-	.get_frontend_legacy = tda1004x_get_fe,
+	.set_frontend = tda1004x_set_fe,
+	.get_frontend = tda1004x_get_fe,
 	.get_tune_settings = tda1004x_get_tune_settings,
 
 	.read_status = tda1004x_read_status,
@@ -1301,6 +1302,7 @@ struct dvb_frontend* tda10045_attach(const struct tda1004x_config* config,
 }
 
 static struct dvb_frontend_ops tda10046_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Philips TDA10046H DVB-T",
 		.type = FE_OFDM,
@@ -1321,8 +1323,8 @@ static struct dvb_frontend_ops tda10046_ops = {
 	.write = tda1004x_write,
 	.i2c_gate_ctrl = tda1004x_i2c_gate_ctrl,
 
-	.set_frontend_legacy = tda1004x_set_fe,
-	.get_frontend_legacy = tda1004x_get_fe,
+	.set_frontend = tda1004x_set_fe,
+	.get_frontend= tda1004x_get_fe,
 	.get_tune_settings = tda1004x_get_tune_settings,
 
 	.read_status = tda1004x_read_status,
-- 
1.7.8.352.g876a6

