Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab1L3PJ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:28 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9S7A015890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 39/94] [media] mt352: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:36 -0200
Message-Id: <1325257711-12274-40-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/mt352.c |   62 +++++++++++++++++------------------
 1 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/media/dvb/frontends/mt352.c b/drivers/media/dvb/frontends/mt352.c
index 021108d..0155fa8 100644
--- a/drivers/media/dvb/frontends/mt352.c
+++ b/drivers/media/dvb/frontends/mt352.c
@@ -111,20 +111,20 @@ static int mt352_sleep(struct dvb_frontend* fe)
 }
 
 static void mt352_calc_nominal_rate(struct mt352_state* state,
-				    enum fe_bandwidth bandwidth,
+				    u32 bandwidth,
 				    unsigned char *buf)
 {
 	u32 adc_clock = 20480; /* 20.340 MHz */
 	u32 bw,value;
 
 	switch (bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	case 6000000:
 		bw = 6;
 		break;
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		bw = 7;
 		break;
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 	default:
 		bw = 8;
 		break;
@@ -166,15 +166,14 @@ static void mt352_calc_input_freq(struct mt352_state* state,
 	buf[1] = lsb(value);
 }
 
-static int mt352_set_parameters(struct dvb_frontend* fe,
-				struct dvb_frontend_parameters *param)
+static int mt352_set_parameters(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *op = &fe->dtv_property_cache;
 	struct mt352_state* state = fe->demodulator_priv;
 	unsigned char buf[13];
 	static unsigned char tuner_go[] = { 0x5d, 0x01 };
 	static unsigned char fsm_go[]   = { 0x5e, 0x01 };
 	unsigned int tps = 0;
-	struct dvb_ofdm_parameters *op = &param->u.ofdm;
 
 	switch (op->code_rate_HP) {
 		case FEC_2_3:
@@ -213,14 +212,14 @@ static int mt352_set_parameters(struct dvb_frontend* fe,
 		case FEC_AUTO:
 			break;
 		case FEC_NONE:
-			if (op->hierarchy_information == HIERARCHY_AUTO ||
-			    op->hierarchy_information == HIERARCHY_NONE)
+			if (op->hierarchy == HIERARCHY_AUTO ||
+			    op->hierarchy == HIERARCHY_NONE)
 				break;
 		default:
 			return -EINVAL;
 	}
 
-	switch (op->constellation) {
+	switch (op->modulation) {
 		case QPSK:
 			break;
 		case QAM_AUTO:
@@ -262,7 +261,7 @@ static int mt352_set_parameters(struct dvb_frontend* fe,
 			return -EINVAL;
 	}
 
-	switch (op->hierarchy_information) {
+	switch (op->hierarchy) {
 		case HIERARCHY_AUTO:
 		case HIERARCHY_NONE:
 			break;
@@ -288,7 +287,7 @@ static int mt352_set_parameters(struct dvb_frontend* fe,
 	buf[3] = 0x50;  // old
 //	buf[3] = 0xf4;  // pinnacle
 
-	mt352_calc_nominal_rate(state, op->bandwidth, buf+4);
+	mt352_calc_nominal_rate(state, op->bandwidth_hz, buf+4);
 	mt352_calc_input_freq(state, buf+6);
 
 	if (state->config.no_tuner) {
@@ -313,13 +312,12 @@ static int mt352_set_parameters(struct dvb_frontend* fe,
 }
 
 static int mt352_get_parameters(struct dvb_frontend* fe,
-				struct dvb_frontend_parameters *param)
+				struct dtv_frontend_properties *op)
 {
 	struct mt352_state* state = fe->demodulator_priv;
 	u16 tps;
 	u16 div;
 	u8 trl;
-	struct dvb_ofdm_parameters *op = &param->u.ofdm;
 	static const u8 tps_fec_to_api[8] =
 	{
 		FEC_1_2,
@@ -348,16 +346,16 @@ static int mt352_get_parameters(struct dvb_frontend* fe,
 	switch ( (tps >> 13) & 3)
 	{
 		case 0:
-			op->constellation = QPSK;
+			op->modulation = QPSK;
 			break;
 		case 1:
-			op->constellation = QAM_16;
+			op->modulation = QAM_16;
 			break;
 		case 2:
-			op->constellation = QAM_64;
+			op->modulation = QAM_64;
 			break;
 		default:
-			op->constellation = QAM_AUTO;
+			op->modulation = QAM_AUTO;
 			break;
 	}
 
@@ -385,36 +383,36 @@ static int mt352_get_parameters(struct dvb_frontend* fe,
 	switch ( (tps >> 10) & 7)
 	{
 		case 0:
-			op->hierarchy_information = HIERARCHY_NONE;
+			op->hierarchy = HIERARCHY_NONE;
 			break;
 		case 1:
-			op->hierarchy_information = HIERARCHY_1;
+			op->hierarchy = HIERARCHY_1;
 			break;
 		case 2:
-			op->hierarchy_information = HIERARCHY_2;
+			op->hierarchy = HIERARCHY_2;
 			break;
 		case 3:
-			op->hierarchy_information = HIERARCHY_4;
+			op->hierarchy = HIERARCHY_4;
 			break;
 		default:
-			op->hierarchy_information = HIERARCHY_AUTO;
+			op->hierarchy = HIERARCHY_AUTO;
 			break;
 	}
 
-	param->frequency = ( 500 * (div - IF_FREQUENCYx6) ) / 3 * 1000;
+	op->frequency = ( 500 * (div - IF_FREQUENCYx6) ) / 3 * 1000;
 
 	if (trl == 0x72)
-		op->bandwidth = BANDWIDTH_8_MHZ;
+		op->bandwidth_hz = 8000000;
 	else if (trl == 0x64)
-		op->bandwidth = BANDWIDTH_7_MHZ;
+		op->bandwidth_hz = 7000000;
 	else
-		op->bandwidth = BANDWIDTH_6_MHZ;
+		op->bandwidth_hz = 6000000;
 
 
 	if (mt352_read_register(state, STATUS_2) & 0x02)
-		param->inversion = INVERSION_OFF;
+		op->inversion = INVERSION_OFF;
 	else
-		param->inversion = INVERSION_ON;
+		op->inversion = INVERSION_ON;
 
 	return 0;
 }
@@ -569,7 +567,7 @@ error:
 }
 
 static struct dvb_frontend_ops mt352_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Zarlink MT352 DVB-T",
 		.type			= FE_OFDM,
@@ -592,8 +590,8 @@ static struct dvb_frontend_ops mt352_ops = {
 	.sleep = mt352_sleep,
 	.write = _mt352_write,
 
-	.set_frontend_legacy = mt352_set_parameters,
-	.get_frontend_legacy = mt352_get_parameters,
+	.set_frontend = mt352_set_parameters,
+	.get_frontend = mt352_get_parameters,
 	.get_tune_settings = mt352_get_tune_settings,
 
 	.read_status = mt352_read_status,
-- 
1.7.8.352.g876a6

