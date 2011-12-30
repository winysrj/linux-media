Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab1L3PJY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:24 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Npi026515
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 04/94] [media] af9013: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:01 -0200
Message-Id: <1325257711-12274-5-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/af9013.c      |  110 +++++++++++++++--------------
 drivers/media/dvb/frontends/af9013_priv.h |   24 +++---
 2 files changed, 68 insertions(+), 66 deletions(-)

diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index 540ed0f..08a0364 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -365,9 +365,10 @@ error:
 	return ret;
 }
 
-static int af9013_set_ofdm_params(struct af9013_state *state,
-	struct dvb_ofdm_parameters *params, u8 *auto_mode)
+static int af9013_set_ofdm_params(struct dvb_frontend *fe, u8 *auto_mode)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct af9013_state *state = fe->demodulator_priv;
 	int ret;
 	u8 i, buf[3] = {0, 0, 0};
 	*auto_mode = 0; /* set if parameters are requested to auto set */
@@ -376,7 +377,7 @@ static int af9013_set_ofdm_params(struct af9013_state *state,
 	   garbage parameters given by application for compatibility.
 	   MPlayer seems to provide garbage parameters currently. */
 
-	switch (params->transmission_mode) {
+	switch (c->transmission_mode) {
 	case TRANSMISSION_MODE_AUTO:
 		*auto_mode = 1;
 	case TRANSMISSION_MODE_2K:
@@ -389,7 +390,7 @@ static int af9013_set_ofdm_params(struct af9013_state *state,
 		*auto_mode = 1;
 	}
 
-	switch (params->guard_interval) {
+	switch (c->guard_interval) {
 	case GUARD_INTERVAL_AUTO:
 		*auto_mode = 1;
 	case GUARD_INTERVAL_1_32:
@@ -408,7 +409,7 @@ static int af9013_set_ofdm_params(struct af9013_state *state,
 		*auto_mode = 1;
 	}
 
-	switch (params->hierarchy_information) {
+	switch (c->hierarchy) {
 	case HIERARCHY_AUTO:
 		*auto_mode = 1;
 	case HIERARCHY_NONE:
@@ -423,11 +424,11 @@ static int af9013_set_ofdm_params(struct af9013_state *state,
 		buf[0] |= (3 << 4);
 		break;
 	default:
-		deb_info("%s: invalid hierarchy_information\n", __func__);
+		deb_info("%s: invalid hierarchy\n", __func__);
 		*auto_mode = 1;
 	};
 
-	switch (params->constellation) {
+	switch (c->modulation) {
 	case QAM_AUTO:
 		*auto_mode = 1;
 	case QPSK:
@@ -439,14 +440,14 @@ static int af9013_set_ofdm_params(struct af9013_state *state,
 		buf[1] |= (2 << 6);
 		break;
 	default:
-		deb_info("%s: invalid constellation\n", __func__);
+		deb_info("%s: invalid modulation\n", __func__);
 		*auto_mode = 1;
 	}
 
 	/* Use HP. How and which case we can switch to LP? */
 	buf[1] |= (1 << 4);
 
-	switch (params->code_rate_HP) {
+	switch (c->code_rate_HP) {
 	case FEC_AUTO:
 		*auto_mode = 1;
 	case FEC_1_2:
@@ -468,11 +469,11 @@ static int af9013_set_ofdm_params(struct af9013_state *state,
 		*auto_mode = 1;
 	}
 
-	switch (params->code_rate_LP) {
+	switch (c->code_rate_LP) {
 	case FEC_AUTO:
 	/* if HIERARCHY_NONE and FEC_NONE then LP FEC is set to FEC_AUTO
 	   by dvb_frontend.c for compatibility */
-		if (params->hierarchy_information != HIERARCHY_NONE)
+		if (c->hierarchy != HIERARCHY_NONE)
 			*auto_mode = 1;
 	case FEC_1_2:
 		break;
@@ -489,20 +490,20 @@ static int af9013_set_ofdm_params(struct af9013_state *state,
 		buf[2] |= (4 << 3);
 		break;
 	case FEC_NONE:
-		if (params->hierarchy_information == HIERARCHY_AUTO)
+		if (c->hierarchy == HIERARCHY_AUTO)
 			break;
 	default:
 		deb_info("%s: invalid code_rate_LP\n", __func__);
 		*auto_mode = 1;
 	}
 
-	switch (params->bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	switch (c->bandwidth_hz) {
+	case 6000000:
 		break;
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		buf[1] |= (1 << 2);
 		break;
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 		buf[1] |= (2 << 2);
 		break;
 	default:
@@ -594,24 +595,24 @@ static int af9013_lock_led(struct af9013_state *state, u8 onoff)
 	return af9013_write_reg_bits(state, 0xd730, 0, 1, onoff);
 }
 
-static int af9013_set_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params)
+static int af9013_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct af9013_state *state = fe->demodulator_priv;
 	int ret;
 	u8 auto_mode; /* auto set TPS */
 
-	deb_info("%s: freq:%d bw:%d\n", __func__, params->frequency,
-		params->u.ofdm.bandwidth);
+	deb_info("%s: freq:%d Hz bw:%d Hz\n", __func__, c->frequency,
+		c->bandwidth_hz);
 
-	state->frequency = params->frequency;
+	state->frequency = c->frequency;
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
 
 	/* program CFOE coefficients */
-	ret = af9013_set_coeff(state, params->u.ofdm.bandwidth);
+	ret = af9013_set_coeff(state, c->bandwidth_hz);
 	if (ret)
 		goto error;
 
@@ -641,7 +642,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe,
 		goto error;
 
 	/* program TPS and bandwidth, check if auto mode needed */
-	ret = af9013_set_ofdm_params(state, &params->u.ofdm, &auto_mode);
+	ret = af9013_set_ofdm_params(fe, &auto_mode);
 	if (ret)
 		goto error;
 
@@ -670,7 +671,7 @@ error:
 }
 
 static int af9013_get_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+			       struct dtv_frontend_properties *c)
 {
 	struct af9013_state *state = fe->demodulator_priv;
 	int ret;
@@ -686,104 +687,104 @@ static int af9013_get_frontend(struct dvb_frontend *fe,
 
 	switch ((buf[1] >> 6) & 3) {
 	case 0:
-		p->u.ofdm.constellation = QPSK;
+		c->modulation = QPSK;
 		break;
 	case 1:
-		p->u.ofdm.constellation = QAM_16;
+		c->modulation = QAM_16;
 		break;
 	case 2:
-		p->u.ofdm.constellation = QAM_64;
+		c->modulation = QAM_64;
 		break;
 	}
 
 	switch ((buf[0] >> 0) & 3) {
 	case 0:
-		p->u.ofdm.transmission_mode = TRANSMISSION_MODE_2K;
+		c->modulation = TRANSMISSION_MODE_2K;
 		break;
 	case 1:
-		p->u.ofdm.transmission_mode = TRANSMISSION_MODE_8K;
+		c->modulation = TRANSMISSION_MODE_8K;
 	}
 
 	switch ((buf[0] >> 2) & 3) {
 	case 0:
-		p->u.ofdm.guard_interval = GUARD_INTERVAL_1_32;
+		c->guard_interval = GUARD_INTERVAL_1_32;
 		break;
 	case 1:
-		p->u.ofdm.guard_interval = GUARD_INTERVAL_1_16;
+		c->guard_interval = GUARD_INTERVAL_1_16;
 		break;
 	case 2:
-		p->u.ofdm.guard_interval = GUARD_INTERVAL_1_8;
+		c->guard_interval = GUARD_INTERVAL_1_8;
 		break;
 	case 3:
-		p->u.ofdm.guard_interval = GUARD_INTERVAL_1_4;
+		c->guard_interval = GUARD_INTERVAL_1_4;
 		break;
 	}
 
 	switch ((buf[0] >> 4) & 7) {
 	case 0:
-		p->u.ofdm.hierarchy_information = HIERARCHY_NONE;
+		c->hierarchy = HIERARCHY_NONE;
 		break;
 	case 1:
-		p->u.ofdm.hierarchy_information = HIERARCHY_1;
+		c->hierarchy = HIERARCHY_1;
 		break;
 	case 2:
-		p->u.ofdm.hierarchy_information = HIERARCHY_2;
+		c->hierarchy = HIERARCHY_2;
 		break;
 	case 3:
-		p->u.ofdm.hierarchy_information = HIERARCHY_4;
+		c->hierarchy = HIERARCHY_4;
 		break;
 	}
 
 	switch ((buf[2] >> 0) & 7) {
 	case 0:
-		p->u.ofdm.code_rate_HP = FEC_1_2;
+		c->code_rate_HP = FEC_1_2;
 		break;
 	case 1:
-		p->u.ofdm.code_rate_HP = FEC_2_3;
+		c->code_rate_HP = FEC_2_3;
 		break;
 	case 2:
-		p->u.ofdm.code_rate_HP = FEC_3_4;
+		c->code_rate_HP = FEC_3_4;
 		break;
 	case 3:
-		p->u.ofdm.code_rate_HP = FEC_5_6;
+		c->code_rate_HP = FEC_5_6;
 		break;
 	case 4:
-		p->u.ofdm.code_rate_HP = FEC_7_8;
+		c->code_rate_HP = FEC_7_8;
 		break;
 	}
 
 	switch ((buf[2] >> 3) & 7) {
 	case 0:
-		p->u.ofdm.code_rate_LP = FEC_1_2;
+		c->code_rate_LP = FEC_1_2;
 		break;
 	case 1:
-		p->u.ofdm.code_rate_LP = FEC_2_3;
+		c->code_rate_LP = FEC_2_3;
 		break;
 	case 2:
-		p->u.ofdm.code_rate_LP = FEC_3_4;
+		c->code_rate_LP = FEC_3_4;
 		break;
 	case 3:
-		p->u.ofdm.code_rate_LP = FEC_5_6;
+		c->code_rate_LP = FEC_5_6;
 		break;
 	case 4:
-		p->u.ofdm.code_rate_LP = FEC_7_8;
+		c->code_rate_LP = FEC_7_8;
 		break;
 	}
 
 	switch ((buf[1] >> 2) & 3) {
 	case 0:
-		p->u.ofdm.bandwidth = BANDWIDTH_6_MHZ;
+		c->bandwidth_hz = 6000000;
 		break;
 	case 1:
-		p->u.ofdm.bandwidth = BANDWIDTH_7_MHZ;
+		c->bandwidth_hz = 7000000;
 		break;
 	case 2:
-		p->u.ofdm.bandwidth = BANDWIDTH_8_MHZ;
+		c->bandwidth_hz = 8000000;
 		break;
 	}
 
-	p->inversion = INVERSION_AUTO;
-	p->frequency = state->frequency;
+	c->inversion = INVERSION_AUTO;
+	c->frequency = state->frequency;
 
 error:
 	return ret;
@@ -1505,6 +1506,7 @@ error:
 EXPORT_SYMBOL(af9013_attach);
 
 static struct dvb_frontend_ops af9013_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Afatech AF9013 DVB-T",
 		.type = FE_OFDM,
@@ -1529,8 +1531,8 @@ static struct dvb_frontend_ops af9013_ops = {
 	.sleep = af9013_sleep,
 	.i2c_gate_ctrl = af9013_i2c_gate_ctrl,
 
-	.set_frontend_legacy = af9013_set_frontend,
-	.get_frontend_legacy = af9013_get_frontend,
+	.set_frontend = af9013_set_frontend,
+	.get_frontend = af9013_get_frontend,
 
 	.get_tune_settings = af9013_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/af9013_priv.h b/drivers/media/dvb/frontends/af9013_priv.h
index e00b2a4..67efd16 100644
--- a/drivers/media/dvb/frontends/af9013_priv.h
+++ b/drivers/media/dvb/frontends/af9013_priv.h
@@ -69,43 +69,43 @@ struct coeff {
 /* pre-calculated coeff lookup table */
 static struct coeff coeff_table[] = {
 	/* 28.800 MHz */
-	{ 28800, BANDWIDTH_8_MHZ, { 0x02, 0x8a, 0x28, 0xa3, 0x05, 0x14,
+	{ 28800, 8000000, { 0x02, 0x8a, 0x28, 0xa3, 0x05, 0x14,
 		0x51, 0x11, 0x00, 0xa2, 0x8f, 0x3d, 0x00, 0xa2, 0x8a,
 		0x29, 0x00, 0xa2, 0x85, 0x14, 0x01, 0x45, 0x14, 0x14 } },
-	{ 28800, BANDWIDTH_7_MHZ, { 0x02, 0x38, 0xe3, 0x8e, 0x04, 0x71,
+	{ 28800, 7000000, { 0x02, 0x38, 0xe3, 0x8e, 0x04, 0x71,
 		0xc7, 0x07, 0x00, 0x8e, 0x3d, 0x55, 0x00, 0x8e, 0x38,
 		0xe4, 0x00, 0x8e, 0x34, 0x72, 0x01, 0x1c, 0x71, 0x32 } },
-	{ 28800, BANDWIDTH_6_MHZ, { 0x01, 0xe7, 0x9e, 0x7a, 0x03, 0xcf,
+	{ 28800, 6000000, { 0x01, 0xe7, 0x9e, 0x7a, 0x03, 0xcf,
 		0x3c, 0x3d, 0x00, 0x79, 0xeb, 0x6e, 0x00, 0x79, 0xe7,
 		0x9e, 0x00, 0x79, 0xe3, 0xcf, 0x00, 0xf3, 0xcf, 0x0f } },
 	/* 20.480 MHz */
-	{ 20480, BANDWIDTH_8_MHZ, { 0x03, 0x92, 0x49, 0x26, 0x07, 0x24,
+	{ 20480, 8000000, { 0x03, 0x92, 0x49, 0x26, 0x07, 0x24,
 		0x92, 0x13, 0x00, 0xe4, 0x99, 0x6e, 0x00, 0xe4, 0x92,
 		0x49, 0x00, 0xe4, 0x8b, 0x25, 0x01, 0xc9, 0x24, 0x25 } },
-	{ 20480, BANDWIDTH_7_MHZ, { 0x03, 0x20, 0x00, 0x01, 0x06, 0x40,
+	{ 20480, 7000000, { 0x03, 0x20, 0x00, 0x01, 0x06, 0x40,
 		0x00, 0x00, 0x00, 0xc8, 0x06, 0x40, 0x00, 0xc8, 0x00,
 		0x00, 0x00, 0xc7, 0xf9, 0xc0, 0x01, 0x90, 0x00, 0x00 } },
-	{ 20480, BANDWIDTH_6_MHZ, { 0x02, 0xad, 0xb6, 0xdc, 0x05, 0x5b,
+	{ 20480, 6000000, { 0x02, 0xad, 0xb6, 0xdc, 0x05, 0x5b,
 		0x6d, 0x2e, 0x00, 0xab, 0x73, 0x13, 0x00, 0xab, 0x6d,
 		0xb7, 0x00, 0xab, 0x68, 0x5c, 0x01, 0x56, 0xdb, 0x1c } },
 	/* 28.000 MHz */
-	{ 28000, BANDWIDTH_8_MHZ, { 0x02, 0x9c, 0xbc, 0x15, 0x05, 0x39,
+	{ 28000, 8000000, { 0x02, 0x9c, 0xbc, 0x15, 0x05, 0x39,
 		0x78, 0x0a, 0x00, 0xa7, 0x34, 0x3f, 0x00, 0xa7, 0x2f,
 		0x05, 0x00, 0xa7, 0x29, 0xcc, 0x01, 0x4e, 0x5e, 0x03 } },
-	{ 28000, BANDWIDTH_7_MHZ, { 0x02, 0x49, 0x24, 0x92, 0x04, 0x92,
+	{ 28000, 7000000, { 0x02, 0x49, 0x24, 0x92, 0x04, 0x92,
 		0x49, 0x09, 0x00, 0x92, 0x4d, 0xb7, 0x00, 0x92, 0x49,
 		0x25, 0x00, 0x92, 0x44, 0x92, 0x01, 0x24, 0x92, 0x12 } },
-	{ 28000, BANDWIDTH_6_MHZ, { 0x01, 0xf5, 0x8d, 0x10, 0x03, 0xeb,
+	{ 28000, 6000000, { 0x01, 0xf5, 0x8d, 0x10, 0x03, 0xeb,
 		0x1a, 0x08, 0x00, 0x7d, 0x67, 0x2f, 0x00, 0x7d, 0x63,
 		0x44, 0x00, 0x7d, 0x5f, 0x59, 0x00, 0xfa, 0xc6, 0x22 } },
 	/* 25.000 MHz */
-	{ 25000, BANDWIDTH_8_MHZ, { 0x02, 0xec, 0xfb, 0x9d, 0x05, 0xd9,
+	{ 25000, 8000000, { 0x02, 0xec, 0xfb, 0x9d, 0x05, 0xd9,
 		0xf7, 0x0e, 0x00, 0xbb, 0x44, 0xc1, 0x00, 0xbb, 0x3e,
 		0xe7, 0x00, 0xbb, 0x39, 0x0d, 0x01, 0x76, 0x7d, 0x34 } },
-	{ 25000, BANDWIDTH_7_MHZ, { 0x02, 0x8f, 0x5c, 0x29, 0x05, 0x1e,
+	{ 25000, 7000000, { 0x02, 0x8f, 0x5c, 0x29, 0x05, 0x1e,
 		0xb8, 0x14, 0x00, 0xa3, 0xdc, 0x29, 0x00, 0xa3, 0xd7,
 		0x0a, 0x00, 0xa3, 0xd1, 0xec, 0x01, 0x47, 0xae, 0x05 } },
-	{ 25000, BANDWIDTH_6_MHZ, { 0x02, 0x31, 0xbc, 0xb5, 0x04, 0x63,
+	{ 25000, 6000000, { 0x02, 0x31, 0xbc, 0xb5, 0x04, 0x63,
 		0x79, 0x1b, 0x00, 0x8c, 0x73, 0x91, 0x00, 0x8c, 0x6f,
 		0x2d, 0x00, 0x8c, 0x6a, 0xca, 0x01, 0x18, 0xde, 0x17 } },
 };
-- 
1.7.8.352.g876a6

