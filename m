Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab1L3PJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:27 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9RcG026536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 25/94] [media] drxd: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:22 -0200
Message-Id: <1325257711-12274-26-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/drxd.h      |    2 -
 drivers/media/dvb/frontends/drxd_hard.c |   58 ++++++++++++-------------------
 2 files changed, 22 insertions(+), 38 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxd.h b/drivers/media/dvb/frontends/drxd.h
index 7113535..3439873 100644
--- a/drivers/media/dvb/frontends/drxd.h
+++ b/drivers/media/dvb/frontends/drxd.h
@@ -48,8 +48,6 @@ struct drxd_config {
 	u8 disable_i2c_gate_ctrl;
 
 	u32 IF;
-	int (*pll_set) (void *priv, void *priv_params,
-			u8 pll_addr, u8 demoda_addr, s32 *off);
 	 s16(*osc_deviation) (void *priv, s16 dev, int flag);
 };
 
diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index ca05a24..2520620 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -120,7 +120,7 @@ enum EIFFilter {
 struct drxd_state {
 	struct dvb_frontend frontend;
 	struct dvb_frontend_ops ops;
-	struct dvb_frontend_parameters param;
+	struct dtv_frontend_properties props;
 
 	const struct firmware *fw;
 	struct device *dev;
@@ -1621,14 +1621,14 @@ static int CorrectSysClockDeviation(struct drxd_state *state)
 				break;
 		}
 
-		switch (state->param.u.ofdm.bandwidth) {
-		case BANDWIDTH_8_MHZ:
+		switch (state->props.bandwidth_hz) {
+		case 8000000:
 			bandwidth = DRXD_BANDWIDTH_8MHZ_IN_HZ;
 			break;
-		case BANDWIDTH_7_MHZ:
+		case 7000000:
 			bandwidth = DRXD_BANDWIDTH_7MHZ_IN_HZ;
 			break;
-		case BANDWIDTH_6_MHZ:
+		case 6000000:
 			bandwidth = DRXD_BANDWIDTH_6MHZ_IN_HZ;
 			break;
 		default:
@@ -1803,7 +1803,7 @@ static int StartDiversity(struct drxd_state *state)
 			status = WriteTable(state, state->m_StartDiversityEnd);
 			if (status < 0)
 				break;
-			if (state->param.u.ofdm.bandwidth == BANDWIDTH_8_MHZ) {
+			if (state->props.bandwidth_hz == 8000000) {
 				status = WriteTable(state, state->m_DiversityDelay8MHZ);
 				if (status < 0)
 					break;
@@ -1905,7 +1905,7 @@ static int SetCfgNoiseCalibration(struct drxd_state *state,
 
 static int DRX_Start(struct drxd_state *state, s32 off)
 {
-	struct dvb_ofdm_parameters *p = &state->param.u.ofdm;
+	struct dtv_frontend_properties *p = &state->props;
 	int status;
 
 	u16 transmissionParams = 0;
@@ -1970,7 +1970,7 @@ static int DRX_Start(struct drxd_state *state, s32 off)
 		if (status < 0)
 			break;
 
-		mirrorFreqSpect = (state->param.inversion == INVERSION_ON);
+		mirrorFreqSpect = (state->props.inversion == INVERSION_ON);
 
 		switch (p->transmission_mode) {
 		default:	/* Not set, detect it automatically */
@@ -2020,7 +2020,7 @@ static int DRX_Start(struct drxd_state *state, s32 off)
 			break;
 		}
 
-		switch (p->hierarchy_information) {
+		switch (p->hierarchy) {
 		case HIERARCHY_1:
 			transmissionParams |= SC_RA_RAM_OP_PARAM_HIER_A1;
 			if (state->type_A) {
@@ -2146,7 +2146,7 @@ static int DRX_Start(struct drxd_state *state, s32 off)
 		if (status < 0)
 			break;
 
-		switch (p->constellation) {
+		switch (p->modulation) {
 		default:
 			operationMode |= SC_RA_RAM_OP_AUTO_CONST__M;
 			/* fall through , try first guess
@@ -2330,9 +2330,11 @@ static int DRX_Start(struct drxd_state *state, s32 off)
 		   by SC for fix for some 8K,1/8 guard but is restored by
 		   InitEC and ResetEC
 		   functions */
-		switch (p->bandwidth) {
-		case BANDWIDTH_AUTO:
-		case BANDWIDTH_8_MHZ:
+		switch (p->bandwidth_hz) {
+		case 0:
+			p->bandwidth_hz = 8000000;
+			/* fall through */
+		case 8000000:
 			/* (64/7)*(8/8)*1000000 */
 			bandwidth = DRXD_BANDWIDTH_8MHZ_IN_HZ;
 
@@ -2340,14 +2342,14 @@ static int DRX_Start(struct drxd_state *state, s32 off)
 			status = Write16(state,
 					 FE_AG_REG_IND_DEL__A, 50, 0x0000);
 			break;
-		case BANDWIDTH_7_MHZ:
+		case 7000000:
 			/* (64/7)*(7/8)*1000000 */
 			bandwidth = DRXD_BANDWIDTH_7MHZ_IN_HZ;
 			bandwidthParam = 0x4807;	/*binary:0100 1000 0000 0111 */
 			status = Write16(state,
 					 FE_AG_REG_IND_DEL__A, 59, 0x0000);
 			break;
-		case BANDWIDTH_6_MHZ:
+		case 6000000:
 			/* (64/7)*(6/8)*1000000 */
 			bandwidth = DRXD_BANDWIDTH_6MHZ_IN_HZ;
 			bandwidthParam = 0x0F07;	/*binary: 0000 1111 0000 0111 */
@@ -2886,24 +2888,18 @@ static int drxd_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int drxd_get_frontend(struct dvb_frontend *fe,
-			     struct dvb_frontend_parameters *param)
-{
-	return 0;
-}
-
 static int drxd_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	return drxd_config_i2c(fe, enable);
 }
 
-static int drxd_set_frontend(struct dvb_frontend *fe,
-			     struct dvb_frontend_parameters *param)
+static int drxd_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct drxd_state *state = fe->demodulator_priv;
 	s32 off = 0;
 
-	state->param = *param;
+	state->props = *p;
 	DRX_Stop(state);
 
 	if (fe->ops.tuner_ops.set_params) {
@@ -2912,15 +2908,6 @@ static int drxd_set_frontend(struct dvb_frontend *fe,
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	/* FIXME: move PLL drivers */
-	if (state->config.pll_set &&
-	    state->config.pll_set(state->priv, param,
-				  state->config.pll_address,
-				  state->config.demoda_address, &off) < 0) {
-		printk(KERN_ERR "Error in pll_set\n");
-		return -1;
-	}
-
 	msleep(200);
 
 	return DRX_Start(state, off);
@@ -2934,7 +2921,7 @@ static void drxd_release(struct dvb_frontend *fe)
 }
 
 static struct dvb_frontend_ops drxd_ops = {
-
+	.delsys = { SYS_DVBT},
 	.info = {
 		 .name = "Micronas DRXD DVB-T",
 		 .type = FE_OFDM,
@@ -2956,8 +2943,7 @@ static struct dvb_frontend_ops drxd_ops = {
 	.sleep = drxd_sleep,
 	.i2c_gate_ctrl = drxd_i2c_gate_ctrl,
 
-	.set_frontend_legacy = drxd_set_frontend,
-	.get_frontend_legacy = drxd_get_frontend,
+	.set_frontend = drxd_set_frontend,
 	.get_tune_settings = drxd_get_tune_settings,
 
 	.read_status = drxd_read_status,
-- 
1.7.8.352.g876a6

