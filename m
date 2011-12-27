Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609Ab1L0BJe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:34 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19YfC005459
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:34 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 39/91] [media] mt352: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:27 -0200
Message-Id: <1324948159-23709-40-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-39-git-send-email-mchehab@redhat.com>
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

